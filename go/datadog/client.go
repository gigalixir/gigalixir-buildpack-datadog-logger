package datadog

import (
	"bytes"
	"compress/gzip"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"os"
)

func (d Datadog) emitLog(processName, message string) error {
	var buf bytes.Buffer
	gw := gzip.NewWriter(&buf)
	if _, err := gw.Write([]byte(message)); err != nil {
		return err
	}
	if err := gw.Close(); err != nil {
		return err
	}

	url, err := d.finalUrl(processName)
	if err != nil {
		return err
	}

	req, err := http.NewRequest("POST", url, &buf)
	if err != nil {
		return err
	}

	req.Header.Set("Accept", "application/json")
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Content-Encoding", "gzip")
	req.Header.Set("DD-API-KEY", d.apiKey)

	resp, err := d.client.Do(req)
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

func (d Datadog) finalUrl(processName string) (string, error) {
	// parse the url
	u, err := url.Parse(d.url)
	if err != nil {
		return "", err
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

	return u.String(), nil
}
