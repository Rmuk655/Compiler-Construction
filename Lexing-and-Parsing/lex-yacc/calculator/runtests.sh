#!/usr/bin/env bash
# Feed every tests/<name>.in to the calculator on stdin and compare stdout with
# tests/<name>.expected. stderr (syntax errors) is not compared.
# Usage: ./runtests.sh [path-to-calculator]   (default: build/calculator)
set -u
root=$(cd "$(dirname "$0")" && pwd)
bin=$(realpath "${1:-$root/build/calculator}")
[ -x "$bin" ] || { echo "calculator not found: $bin (run make first)" >&2; exit 2; }

pass=0
fail=0
for in in "$root"/tests/*.in; do
    name=$(basename "$in" .in)
    if "$bin" < "$in" 2>/dev/null | cmp -s - "$root/tests/$name.expected"; then
        echo "PASS $name"; pass=$((pass + 1))
    else
        echo "FAIL $name"; fail=$((fail + 1))
    fi
done
echo "passed $pass, failed $fail"
[ "$fail" -eq 0 ]
