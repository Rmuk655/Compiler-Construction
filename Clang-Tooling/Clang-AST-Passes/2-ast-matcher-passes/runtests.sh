#!/usr/bin/env bash
# Run the MA4_Pass tool on every tests/*.cpp and compare its stdout with
# tests/expected/<name>.expected. Both sides are sorted first, because the
# "Unused variable" lines come out in pointer order.
# MA4_Pass is built inside an LLVM source tree (see README), so point this at it:
#   ./runtests.sh path/to/MA4_Pass      (default: $HOME/llvm-project/build/bin/MA4_Pass)
# Exits 0 with a SKIP message if the tool has not been built.
set -u
root=$(cd "$(dirname "$0")" && pwd)
bin=${1:-$HOME/llvm-project/build/bin/MA4_Pass}
if [ ! -x "$bin" ]; then
    echo "SKIP: $bin not found (build MA4_Pass inside an LLVM tree first)"
    exit 0
fi
bin=$(realpath "$bin")

cd "$root/tests"
pass=0
fail=0
for src in *.cpp; do
    name=${src%.cpp}
    actual=$("$bin" "$src" -- 2>/dev/null | sed "s|$PWD/||" | LC_ALL=C sort)
    expected=$(LC_ALL=C sort "expected/$name.expected")
    if [ "$actual" == "$expected" ]; then
        echo "PASS $name"; pass=$((pass + 1))
    else
        echo "FAIL $name"; fail=$((fail + 1))
    fi
done
echo "passed $pass, failed $fail"
[ "$fail" -eq 0 ]
