package datadog

import (
	"encoding/json"
	"fmt"
	"regexp"
)

func (d Datadog) ProcessLine(line string) error {
	processName, message := cleanForemanLine(line)

	// if the log entry is not valid json and we are only passing valid json
	// print it to stdout for passthrough to default logger
	if d.onlyJson && !isValidJSON(message) {
		fmt.Println(line)
		return nil
	}

	if d.client == nil {
		d.debugLog(processName, message)
	} else {
		if err := d.emitLog(processName, message); err != nil {
			fmt.Printf("Datadog Logger Error: %v", err)
		}
	}
	return nil
}

func isValidJSON(s string) bool {
	var js interface{}
	err := json.Unmarshal([]byte(s), &js)
	return err == nil
}

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
