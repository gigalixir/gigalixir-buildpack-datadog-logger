#!/usr/bin/env bash

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source $SCRIPT_DIR/.test_support.sh

touch ${cache_dir}/gig-dd-logger-v1.0.0-rc.1

echo() {
  /bin/true
}


# TESTS
######################
suite "compile"


  test "adds the logger executable and profile script"

    source $SCRIPT_DIR/../bin/compile $build_dir $cache_dir $env_dir

    [ -e ${build_dir}/.profile.d/999_gigalixir_datadog_logger.sh ]
    [ -e ${build_dir}/.profile.d/gigalixir_datadog_logger/log_shuttle ]



PASSED_ALL_TESTS=true
