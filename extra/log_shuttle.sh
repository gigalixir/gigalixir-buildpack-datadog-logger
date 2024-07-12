#!/usr/bin/env bash

cat - | /opt/gigalixir/bin/log-shuttle.datadog | /opt/gigalixir/bin/log-shuttle.real $@
