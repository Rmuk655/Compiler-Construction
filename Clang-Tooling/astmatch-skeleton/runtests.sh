#!/usr/bin/env bash
# Syntax-check astmatch.cpp against the clang headers of an LLVM source tree.
# The skeleton has no matchers yet, so this only checks that it compiles.
#   LLVM_TREE=path/to/llvm-project ./runtests.sh   (default: $HOME/llvm-project)
# Exits 0 with a SKIP message if the tree or its build directory is missing.
set -u
root=$(cd "$(dirname "$0")" && pwd)
tree=${LLVM_TREE:-$HOME/llvm-project}
if [ ! -d "$tree/clang/include" ] || [ ! -d "$tree/build/tools/clang/include" ]; then
    echo "SKIP: no built LLVM tree at $tree"
    exit 0
fi
if clang++ -fsyntax-only -std=c++17 -I"$tree/clang/include" -I"$tree/build/tools/clang/include" \
        -I"$tree/llvm/include" -I"$tree/build/include" "$root/astmatch.cpp" 2>/dev/null; then
    echo "PASS astmatch.cpp compiles"
else
    echo "FAIL astmatch.cpp compiles"
    exit 1
fi
