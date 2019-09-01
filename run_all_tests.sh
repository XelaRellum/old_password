#!/bin/sh
# run C tests first, so the testdata is generated
set -e
for LANG in c python elixir ; do
    cd $LANG
    ./run_tests.sh
    cd ..
done
