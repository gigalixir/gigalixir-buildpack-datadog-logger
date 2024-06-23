#!/usr/bin/env bash


ROOT_DIR=$(dirname "$SCRIPT_DIR")
PASSED_ALL_TESTS=false

# make a temp dir for test files/directories
TEST_DIR=$(mktemp -d -t gigalixir-buildpack-phoenix-static_XXXXXXXXXX)
ECHO_CONTENT=()
cleanup() {
  rm -rf ${TEST_DIR}
  if $PASSED_ALL_TESTS; then
    /bin/echo -e "  \e[0;32mTest Suite PASSED\e[0m"
  else
    /bin/echo -e "  \e[0;31mFAILED\e[0m"
  fi
  exit
}
trap cleanup EXIT INT TERM

# set directories for test
build_dir=${TEST_DIR}/build_dir
cache_dir=${TEST_DIR}/cache_dir
env_dir=${TEST_DIR}/env_dir
mkdir -p ${build_dir} ${cache_dir} ${env_dir}


# overridden functions
info() {
  true
}

# helper functions
test() {
  failed=false
  ECHO_CONTENT=()
  /bin/echo "  TEST: $@"
}

suite() {
  failed=false
  /bin/echo -e "\e[0;36mSUITE: $@\e[0m"
}
