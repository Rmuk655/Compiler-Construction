#!/bin/bash
# Regenerates every .ll file used in the report (Clang/LLVM 17, -O0 unless noted).
# Run from this directory: ./run.sh
CC=${CC:-clang-17}
CXX=${CXX:-clang++-17}
set -e
cd "$(dirname "$0")"

for f in Q1/Q1a Q1/Q1b Q1/Q1c Q1/Q1d Q1/Q1e Q2/Q2a Q2/Q2bi Q2/Q2d_union Q4/Q4_float; do
	$CC -S -emit-llvm -O0 -o $f.ll $f.c
done
for f in Q2/Q2bii Q2/Q2c_vector Q2/Q2e_struct_class; do
	$CXX -S -emit-llvm -O0 -o $f.ll $f.cpp
done

# Q4: machine-code lowering of the floating-point operations (x86-64 assembly)
llc-17 -O0 Q4/Q4_float.ll -o Q4/Q4_float.s

# Q3: ternary at -O0 and -O1, plus token stream and AST
$CC -S -emit-llvm -O0 -o Q3/ternary_O0.ll Q3/input.c
$CC -S -emit-llvm -O1 -o Q3/ternary_O1.ll Q3/input.c
$CC -fsyntax-only -Xclang -dump-tokens Q3/input.c 2> Q3/tokens.txt || true
$CC -fsyntax-only -Xclang -ast-dump Q3/input.c > Q3/ast.txt
echo "done"
