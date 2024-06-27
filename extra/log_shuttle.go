package main

import (
	"bufio"
	"bytes"
	"compress/gzip"
	"fmt"
	"io"
	"log"
	"net/http"
	"net/url"
	"os"
	"regexp"
)

func cleanForemanLine(line string) (string, string) {
	re := regexp.MustCompile(`\[\d+m([a-zA-Z0-9.]+)\s+\|\s+\[\d+m(.*)`)
	matches := re.FindStringSubmatch(line)

	if len(matches) == 3 {
		processName := matches[1]
		message := matches[2]

		return processName, message
	} else {
		return "", line
	}
}

// sendLog sends a single log entry to Datadog
func sendLog(client *http.Client, ddUrl, apiKey, logEntry string) error {
	processName, message := cleanForemanLine(logEntry)

	var buf bytes.Buffer
	gw := gzip.NewWriter(&buf)
	if _, err := gw.Write([]byte(message)); err != nil {
		return err
	}
	if err := gw.Close(); err != nil {
		return err
	}

	// parse the url
	u, err := url.Parse(ddUrl)
	if err != nil {
		return err
	}
	q := u.Query()

	// add 'ddsource=gigalixir' if missing
	if q.Get("ddsource") == "" {
		q.Set("ddsource", "gigalixir")
	}

	// add 'host=$(hostname)' if missing
	if q.Get("host") == "" {
		if os.Getenv("HOSTNAME") != "" {
			q.Set("host", os.Getenv("HOSTNAME"))
		}
	}

	// add 'service=processName' if missing
	if q.Get("service") == "" {
		if processName != "" {
			q.Set("service", processName)
		}
	}

	u.RawQuery = q.Encode()

	req, err := http.NewRequest("POST", u.String(), &buf)
	if err != nil {
		return err
	}

	req.Header.Set("Accept", "application/json")
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Content-Encoding", "gzip")
	req.Header.Set("DD-API-KEY", apiKey)

	resp, err := client.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusAccepted {
		body, _ := io.ReadAll(resp.Body)
		return fmt.Errorf("Unexpected HTTP status: %v, body: %s", resp.Status, body)
	}

	return nil
}

func main() {

	apiKey := os.Getenv("GIG_DD_LOGGER__API_KEY")
	if apiKey == "" {
		apiKey := os.Getenv("DATADOG_API_KEY")
		if apiKey == "" {
			log.Fatal("GIG_DD_LOGGER__API_KEY or DATADOG_API_KEY is required")
		}
	}

	ddUrl := os.Getenv("GIG_DD_LOGGER__URL")
	if ddUrl == "" {
		log.Fatal("GIG_DD_LOGGER__URL is required")
	}

	client := &http.Client{}

	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		logEntry := scanner.Text()
		if err := sendLog(client, ddUrl, apiKey, logEntry); err != nil {
			log.Printf("Failed to send log: %v", err)
		}
	}

	if err := scanner.Err(); err != nil {
		log.Fatalf("Error reading from stdin: %v", err)
	}
}
