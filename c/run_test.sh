#!/bin/sh
export CTEST_OUTPUT_ON_FAILURE=1
set -e
cmake -H. -B_builds -G "Ninja"
cmake --build _builds
ninja -C _builds test
# _builds/oldpassword_c_test
