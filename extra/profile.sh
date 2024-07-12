#!/usr/bin/env bash

gigalixir_bin_path=${gigalixir_bin_path:-/opt/gigalixir/bin}
log_shuttle_bin_path=${log_shuttle_bin_path:-/app/.profile.d/gigalixir_datadog_logger/log_shuttle.datadog}
log_shuttle_sh_path=${log_shuttle_sh_path:-/app/.profile.d/gigalixir_datadog_logger/log_shuttle.sh}

# just once, move in the new log_shuttle file
if [ ! -x ${gigalixir_bin_path}/log-shuttle.real ] && \
   [ -x ${log_shuttle_bin_path} ] && \
   [ -x ${log_shuttle_sh_path} ]; then

  cp ${gigalixir_bin_path}/log-shuttle ${gigalixir_bin_path}/log-shuttle.real
  cp $log_shuttle_bin_path ${gigalixir_bin_path}/log-shuttle.datadog
  cp $log_shuttle_sh_path ${gigalixir_bin_path}/log-shuttle
fi
