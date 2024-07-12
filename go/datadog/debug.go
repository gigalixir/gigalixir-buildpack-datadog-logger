package datadog

import (
	"fmt"
)

var debugSentUrl bool

func (d Datadog) debugLog(processName, message string) error {
	if ! debugSentUrl {
		url, err := d.finalUrl(processName)
		if err != nil {
			return err
		}

		fmt.Printf("Debugging Datadog Logger in debug mode <dd:%s>\n", url)
		debugSentUrl = true
	}

	fmt.Printf("<dd> %s\n", message)

	return nil
}
