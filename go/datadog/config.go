package datadog

import (
	"fmt"
	"net/http"
	"os"
)

// struct for configuration
type Datadog struct {
	apiKey   string `json:"apiKey"`
	onlyJson bool   `json:"onlyJson"`
	url      string `json:"url"`

	client *http.Client
}

func New() Datadog {
	d := Datadog{
		apiKey:   os.Getenv("GIG_DD_LOGGER__API_KEY"),
		url:      os.Getenv("GIG_DD_LOGGER__URL"),
		onlyJson: os.Getenv("GIG_DD_LOGGER__ONLY_JSON") == "true",
	}

	if os.Getenv("GIG_DD_LOGGER__DEBUG_HTTP") != "true" {
		d.client = &http.Client{}
	}

	return d
}

func (d Datadog) IsValid() bool {
	valid := true

	if d.apiKey == "" {
		d.apiKey = os.Getenv("DATADOG_API_KEY")
	}

	if d.apiKey == "" {
		fmt.Println("GIG_DD_LOGGER__API_KEY or DATADOG_API_KEY is required")
		valid = false
	}

	if d.url == "" {
		fmt.Println("GIG_DD_LOGGER__URL is required")
		valid = false
	}

	if !valid {
		fmt.Println("Datadog Logger is not configured properly. Falling back to default logger.")
	}

	return valid
}
