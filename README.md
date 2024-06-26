# Gigalixir Datadog Logger Buildpack

## Purpose

This buildpack allows a user to emit application messages directly to datadog.



## Usage

To use this buildpack:
1. add it to your `.buildpacks` file
2. be sure to set `DATADOG_API_KEY` or `GIG_DD_LOGGER__API_KEY` for your application
3. be sure to set `GIG_DD_LOGGER__URL` for your application
4. emit logs entries on a single line in the desired format

See the [datadog documentation](https://docs.datadoghq.com/api/latest/logs/?code-lang=curl) for further information.

Here is a JSON example (unfurled to multiple lines for clairity):
```json
{
  "logger": {
    "line": 900,
    "file_name": "lib/my_app_web/controllers/user_controller.ex",
    "method_name": "Elixir.MyApp.UserController.create/2",
    "thread_name": "#PID<0.1182.0>"
  },
  "message": "Unable to use email address 'badly-formmatted@not-a-domain'",
  "syslog": {
    "timestamp": "2024-06-25T12:56:00.500Z",
    "hostname": "my-app-12345678",
    "severity": "debug"
  }
}
```


## Configuration

Required settings:

| Setting                  | Description |
|--------------------------|-------------|
| `GIG_DD_LOGGER__API_KEY` | The API key to use for authentication. If not set, the value of `DATADOG_API_KEY` is used. |
| `GIG_DD_LOGGER__URL`     | The URL to use for the datadog logger endpoint. See notes below. |


To determine your `GIG_DD_LOGGER__URL`, first determine your DataDog Site, then use the following table:

| Site    | URL                                                       |
|---------|-----------------------------------------------------------|
| US1     | `https://http-intake.logs.datadoghq.com/api/v2/logs/`     |
| US3     | `https://http-intake.logs.us3.datadoghq.com/api/v2/logs/` |
| US5     | `https://http-intake.logs.us5.datadoghq.com/api/v2/logs/` |
| EU      | `https://http-intake.logs.datadoghq.eu/api/v2/logs/`      |
| API     | `https://http-intake.logs.ap1.datadoghq.com/api/v2/logs/` |
| US1-FED | `https://http-intake.logs.ddog-gov.com/api/v2/logs/`      |


You can append a DataDog service name to the URL if you like: `https://http-intake.logs.datadoghq.com/api/v2/logs/?service=my-application`


## Tests

Tests are available in the [test](test) directory.
To run all tests, use `for tst in test/*; do $tst; done`.
