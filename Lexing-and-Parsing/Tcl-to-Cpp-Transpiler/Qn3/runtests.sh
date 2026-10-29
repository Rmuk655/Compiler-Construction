#!/usr/bin/env bash
# For every test/input/tN.txt: transpile to C++, compile it, run it, and compare
# the program's output with test/expected/tN.expected.
# Inputs named err_*.txt must make the transpiler exit non-zero and print the
# message in test/expected/err_*.stderr on stderr.
# Usage: ./runtests.sh [path-to-tcl2cpp]   (default: out/tcl2cpp)
set -u
root=$(cd "$(dirname "$0")" && pwd)
bin=$(realpath "${1:-$root/out/tcl2cpp}")
[ -x "$bin" ] || { echo "tcl2cpp not found: $bin (run make first)" >&2; exit 2; }

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

pass=0
fail=0
for in in "$root"/test/input/err_*.txt; do
    name=$(basename "$in" .txt)
    err=$("$bin" < "$in" 2>&1 >/dev/null)
    rc=$?
    if [ "$rc" -ne 0 ] && [ "$err" == "$(cat "$root/test/expected/$name.stderr")" ]; then
        echo "PASS $name"; pass=$((pass + 1))
    else
        echo "FAIL $name"; fail=$((fail + 1))
    fi
done

for in in "$root"/test/input/t*.txt; do
    name=$(basename "$in" .txt)
    if "$bin" < "$in" > "$work/$name.cpp" 2>/dev/null \
        && g++ -o "$work/$name" "$work/$name.cpp" 2>/dev/null \
        && "$work/$name" | cmp -s - "$root/test/expected/$name.expected"; then
        echo "PASS $name"; pass=$((pass + 1))
    else
        echo "FAIL $name"; fail=$((fail + 1))
    fi
done
echo "passed $pass, failed $fail"
[ "$fail" -eq 0 ]
