#!/usr/bin/env bash

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source $SCRIPT_DIR/.test_support.sh

# override echo
echo() {
  ECHO_LINE="$@"
}

# TESTS
######################
suite "detect"


  test "echos and exits gracefully"

    source $SCRIPT_DIR/../bin/detect

    [ "$ECHO_LINE" == "Gigalixir DataDog Logger" ]



PASSED_ALL_TESTS=true
