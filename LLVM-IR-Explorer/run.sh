#!/bin/bash
LLVM_BIN=${LLVM_BIN:-$HOME/llvm-project/build/bin}
if [ -x "$LLVM_BIN/clang" ]; then
    CC=$LLVM_BIN/clang; CXX=$LLVM_BIN/clang++
else
    CC=clang-17; CXX=clang++-17
fi
set -e
cd "$(dirname "$0")"

for f in Q2/Q2_variables Q2/Q2_conditionals_loops Q2/Q2_functions Q2/Q2_casts; do
    $CC -S -emit-llvm -O0 -o $f.ll $f.c
done

for f in Q3/Q3_array Q3/Q3_struct Q3/Q3_union; do
    $CC -S -emit-llvm -O0 -o $f.ll $f.c
done
for f in Q3/Q3_vector Q3/Q3_class; do
    $CXX -S -emit-llvm -O0 -o $f.ll $f.cpp
done

$CC -S -emit-llvm -O0 -o Q4/Q4_float.ll Q4/Q4_float.c
echo "done"