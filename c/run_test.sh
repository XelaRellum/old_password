#!/bin/sh
export CTEST_OUTPUT_ON_FAILURE=1
cmake -H. -B_builds\RelWithDebInfo -DCMAKE_BUILD_TYPE=RelWithDebInfo -G "Ninja"
cmake --build _builds\RelWithDebInfo
ninja -C _builds\RelWithDebInfo test

