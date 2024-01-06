#!/bin/bash
# Copyright (c) Meta Platforms, Inc. and affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

# exit when any command fails
set -e

echo "building cql"
(cd .. ; make)

echo "building C code"
../out/cql --in demo_todo.sql --cg demo_todo.h demo_todo.c --cqlrt cqlrt_cf.h

echo "building OBJC code"
../out/cql --in demo_todo.sql --cg demo_objc.h --rt objc --objc_c_include_path demo_todo.h --cqlrt cqlrt_cf.h

echo "building executable"
cc -o demo -g -I.. -I. demo_todo.c demo_main.m cqlrt_cf.c cqlholder.m -lsqlite3 -framework Foundation -fobjc-arc

echo "running demo"
./demo

echo ""
echo "Done"
echo ""
echo "to clean the directory run ./clean.sh"
