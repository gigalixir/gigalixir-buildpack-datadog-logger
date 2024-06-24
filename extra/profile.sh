#!/usr/bin/env bash

gigalixir_bin_path=${gigalixir_bin_path:-/opt/gigalixir/bin}
log_shuttle_path=${log_shuttle_path:-/app/.profile.d/gigalixir_datadog_logger/log_shuttle}

# just once, move in the new log_shuttle file
if [ ! -x ${gigalixir_bin_path}/log_shuttle.real ] && [ -x $log_shuttle_path ]; then
  cp ${gigalixir_bin_path}/log_shuttle ${gigalixir_bin_path}/log_shuttle.real
  cp $log_shuttle_path ${gigalixir_bin_path}/log_shuttle
fi
