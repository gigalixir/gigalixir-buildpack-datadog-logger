# Gigalixir Datadog Logger Buildpack

## Purpose

This buildpack allows a user to emit application messages directly to datadog.



## Usage

To use this buildpack:
1. add it to your `.buildpacks` file
2. be sure to set `DATADOG_API_KEY` for your application
3. emit logs entries on a single line in the desired format

See the [datadog documentation](https://docs.datadoghq.com/api/latest/logs/?code-lang=curl) for further information.



## Configuration

Required settings:

| Setting                  | Description |
|--------------------------|-------------|
| `GIG_DD_LOGGER__API_KEY` | The API key to use for authentication. If not set, the value of `DATADOG_API_KEY` is used. |

Optional settings:
| Setting                      | Default | Description |
|------------------------------|---------|-------------|
| `GIG_DD_LOGGER__CURL_PATH`   | curl    | Path to the curl binary. Primarly used for test scripts |
| `GIG_DD_LOGGER__PROPAGATE`   | false   | When `true` logs are emited to the Gigalixir logger and DD endpoint. |
| `GIG_DD_LOGGER__URL`         | https://http-intake.logs.datadoghq.com/api/v2/logs | The URL to use for the datadog logger endpoint. Primary used for test scripts |



## Tests

Tests are available in the [test](test) directory.
To run all tests, use `for tst in test/*; do $tst; done`.
