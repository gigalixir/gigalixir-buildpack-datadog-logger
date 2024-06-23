#!/usr/bin/env bash

# setup default options
GIG_DD_LOGGER__API_KEY=${GIG_DD_LOGGER__API_KEY:${DATADOG_API_KEY}}
GIG_DD_LOGGER__CURL_PATH=${GIG_DD_LOGGER__CURL_PATH:-curl}
GIG_DD_LOGGER__PROPAGATE=${GIG_DD_LOGGER__PROPAGATE:-true}
GIG_DD_LOGGER__URL=${GIG_DD_LOGGER__URL:-https://http-intake.logs.datadoghq.com/api/v2/logs}

curl_args=(
  "$GIG_DD_LOGGER__CURL_PATH"
  "$GIG_DD_LOGGER__CURL_OPTS"
  "-X"
  "$GIG_DD_LOGGER__CURL_METHOD"
  "$GIG_DD_LOGGER__URL"
)
# Construct curl command using an array
curl_args=(
  "$GIG_DD_LOGGER__CURL_PATH"
  "-X POST"
  "$GIG_DD_LOGGER__URL"
  -H "Accept: application/json"
  -H "Content-Type: application/json"
  -H "Content-Encoding: gzip"
  -H "DD-API-KEY: $DATADOG_API_KEY"
  --data-binary @-
)

if $GIG_DD_LOGGER__PROPAGATE; then
  # Propagate log lines to the original log_shuttle and custom logger
  cat - | tee >(gzip | "${curl_args[@]}") | /opt/gigalixir/bin/log_shuttle.real "$@"
else
  # Only emit log lines to the custom logger
  cat - | gzip | "${curl_args[@]}"
fi
