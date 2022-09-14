#!/bin/bash

export FOBNAIL_PO_ROOT=.temp/fobnail_test_root.crt
export FOBNAIL_LOG=debug
./build.sh $1
