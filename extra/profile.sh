#!/usr/bin/env bash

if [ -z "${GIG_DD_LOGGER__API_KEY}" ]; then
  if [ -z "${DATADOG_API_KEY}" ]; then
    echo "GIG_DD_LOGGER__API_KEY nor DATADOG_API_KEY are not set. Continuing without the Gigalixir DataDog Logger."
  fi
else

  log_shuttle_path=${log_shuttle_path:-/app/.profile.d/gigalixir_datadog_logger/log_shuttle}
  if [ ! -x $log_shuttle_path ]; then
    echo "gigalixir_datadog_logger executable not found. Continuing without the Gigalixir DataDog Logger. '$log_shuttle_path'"
  else
    gigalixir_bin_path=${gigalixir_bin_path:-/opt/gigalixir/bin}
    cp ${gigalixir_bin_path}/log_shuttle ${gigalixir_bin_path}/log_shuttle.real
    cp $log_shuttle_path ${gigalixir_bin_path}/log_shuttle
    chmod +x ${gigalixir_bin_path}/log_shuttle
  fi
fi
