#!/bin/bash
# Regenerates every output used in the report (Clang/LLVM 17, -O0).
# Run from this directory: ./run.sh
# Uses the LLVM 17.0.6 built from source (clang + clang-tools-extra) if present,
# otherwise falls back to the system clang-17. Override with LLVM_BIN=/path/to/bin
LLVM_BIN=${LLVM_BIN:-$HOME/llvm-project/build/bin}
if [ -x "$LLVM_BIN/clang" ]; then
	CC=$LLVM_BIN/clang; CXX=$LLVM_BIN/clang++; LLC=$LLVM_BIN/llc
else
	CC=clang-17; CXX=clang++-17; LLC=llc-17
fi
set -e
cd "$(dirname "$0")"

# Q2: IR study of core constructs
for f in Q2/Q2_variables Q2/Q2_conditionals_loops Q2/Q2_functions Q2/Q2_casts; do
	$CC -S -emit-llvm -O0 -o $f.ll $f.c
done

# Q3: data structures
for f in Q3/Q3_array Q3/Q3_struct Q3/Q3_union; do
	$CC -S -emit-llvm -O0 -o $f.ll $f.c
done
for f in Q3/Q3_vector Q3/Q3_class Q3/Q3_struct_vs_class; do
	$CXX -S -emit-llvm -O0 -o $f.ll $f.cpp
done

# Q4: floating point, plus machine-code lowering (x86-64 assembly)
$CC -S -emit-llvm -O0 -o Q4/Q4_float.ll Q4/Q4_float.c
$LLC -O0 Q4/Q4_float.ll -o Q4/Q4_float.s
echo "done"
