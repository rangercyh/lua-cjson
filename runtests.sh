#!/bin/sh

EGREP="grep -E"
#EGREP="egrep"

set -e

do_tests() {
    echo
    cd tests
    ./test.lua | $EGREP 'version|PASS|FAIL'
    cd ..
}

cat <<EOT
Please ensure you do not have the Lua CJSON module installed before
running these tests.

EOT

echo "===== Setting LuaRocks PATH ====="
eval "`luarocks path`"

echo "===== Building UTF-8 test data ====="
( cd tests && ./genutf8.pl; )

echo "===== Cleaning old build data ====="
make clean
rm -f tests/cjson.so

echo "===== Testing LuaRocks build ====="
luarocks make --local
do_tests
luarocks remove --local lua-cjson
make clean

echo "===== Testing Makefile build ====="
make
cp cjson.so tests
do_tests
make clean
rm -f tests/cjson.so