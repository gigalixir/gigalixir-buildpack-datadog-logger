#!/usr/bin/env bash

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source $SCRIPT_DIR/.test_support.sh

gigalixir_bin_path=${TEST_DIR}/gigalixir/bin
mkdir -p ${gigalixir_bin_path}
echo "echo 'this is the stand-in for the real log shuttle'" > ${gigalixir_bin_path}/log_shuttle
chmod +x ${gigalixir_bin_path}/log_shuttle


# TESTS
######################
suite "profile script"


  test "KEY not set"

    output=$($SCRIPT_DIR/../extra/profile.sh)

    [ "$?" -eq "0" ]
    [[ "$output" == *"KEY are not set"* ]]


  test "log shuttle file doesn't exist"

    output=$(GIG_DD_LOGGER__API_KEY=fake-key $SCRIPT_DIR/../extra/profile.sh)

    [ "$?" -eq "0" ]
    [[ "$output" == *"executable not found"* ]]


  test "happy path"

    output=$(GIG_DD_LOGGER__API_KEY=fake-key log_shuttle_path=$SCRIPT_DIR/../extra/log_shuttle.sh gigalixir_bin_path=$gigalixir_bin_path $SCRIPT_DIR/../extra/profile.sh)

    [ "$?" -eq "0" ]
    [ -z "$output" ]
    [ -x "${gigalixir_bin_path}/log_shuttle.real" ]
    grep -q "this is the stand-in for the real log shuttle" ${gigalixir_bin_path}/log_shuttle.real
    [ -x "${gigalixir_bin_path}/log_shuttle" ]
    grep -q "GIG_DD_LOGGER__PROPAGATE" ${gigalixir_bin_path}/log_shuttle



PASSED_ALL_TESTS=true
