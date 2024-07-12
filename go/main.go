package main

import (
	"bufio"
	"fmt"
	"log"
	"os"

	"github.com/gigalixir/gigalixir-buildpack-datadog-logger/datadog"
)

func main() {
	d := datadog.New()

	scanner := bufio.NewScanner(os.Stdin)
	if d.IsValid() {
		for scanner.Scan() {
			if err := d.ProcessLine(scanner.Text()); err != nil {
				log.Fatalf("Datadog Logger Failed: %v", err)
			}
		}
	} else {
		// repeat everything to stdout
		for scanner.Scan() {
			fmt.Println(scanner.Text())
		}
	}

	if err := scanner.Err(); err != nil {
		log.Fatalf("Error reading from stdin: %v", err)
	}
}
