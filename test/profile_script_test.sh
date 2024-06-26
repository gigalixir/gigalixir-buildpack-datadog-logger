#!/usr/bin/env bash

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source $SCRIPT_DIR/.test_support.sh

gigalixir_bin_path=${TEST_DIR}/gigalixir/bin
mkdir -p ${gigalixir_bin_path}
echo "echo 'this is the stand-in for the real log shuttle'" > ${gigalixir_bin_path}/log_shuttle
chmod +x ${gigalixir_bin_path}/log_shuttle

log_shuttle_path="${cache_dir}/log_shuttle"
touch ${log_shuttle_path}
chmod +x ${log_shuttle_path}

# TESTS
######################
suite "profile script"


  test "happy path"

    output=$(log_shuttle_path=${log_shuttle_path} gigalixir_bin_path=$gigalixir_bin_path $SCRIPT_DIR/../extra/profile.sh)

    [ "$?" -eq "0" ]
    [ -z "$output" ]
    [ -x "${gigalixir_bin_path}/log_shuttle.real" ]
    grep -q "this is the stand-in for the real log shuttle" ${gigalixir_bin_path}/log_shuttle.real
    [ -x "${gigalixir_bin_path}/log_shuttle" ]
    diff ${gigalixir_bin_path}/log_shuttle ${log_shuttle_path} > /dev/null



PASSED_ALL_TESTS=true
