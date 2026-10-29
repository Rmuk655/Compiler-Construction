#!/usr/bin/env bash
# Run the Simple_Pass tool (built from Mypass.cpp) on every tests/*.cpp and
# compare its stdout with tests/expected/<name>.expected. The test inputs have
# no #include, because the matchers also match declarations that come from headers.
# Simple_Pass is built inside an LLVM source tree, so point this at it:
#   ./runtests.sh path/to/Simple_Pass   (default: $HOME/llvm-project/build/bin/Simple_Pass)
# Exits 0 with a SKIP message if the tool has not been built.
set -u
root=$(cd "$(dirname "$0")" && pwd)
bin=${1:-$HOME/llvm-project/build/bin/Simple_Pass}
if [ ! -x "$bin" ]; then
    echo "SKIP: $bin not found (build Simple_Pass inside an LLVM tree first)"
    exit 0
fi
bin=$(realpath "$bin")

cd "$root/tests"
pass=0
fail=0
for src in *.cpp; do
    name=${src%.cpp}
    if "$bin" "$src" -- 2>/dev/null | cmp -s - "expected/$name.expected"; then
        echo "PASS $name"; pass=$((pass + 1))
    else
        echo "FAIL $name"; fail=$((fail + 1))
    fi
done
echo "passed $pass, failed $fail"
[ "$fail" -eq 0 ]
