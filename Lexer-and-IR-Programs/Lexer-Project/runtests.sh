#!/usr/bin/env bash
# Feed every test_cases/<name>.txt to the lexer on stdin and compare stdout with
# test_cases/<name>.expected (or <name>_alternate.expected if that file exists).
# Trailing blank lines are ignored, since some expected files end with an extra one.
# Usage: ./runtests.sh [path-to-lexer]   (default: build/lexer)
set -u
root=$(cd "$(dirname "$0")" && pwd)
bin=$(realpath "${1:-$root/build/lexer}")
[ -x "$bin" ] || { echo "lexer not found: $bin (run make first)" >&2; exit 2; }

pass=0
fail=0
for txt in "$root"/test_cases/*.txt; do
    name=$(basename "$txt" .txt)
    actual=$("$bin" < "$txt")
    ok=0
    for exp in "$root/test_cases/$name.expected" "$root/test_cases/${name}_alternate.expected"; do
        [ -f "$exp" ] && [ "$actual" == "$(cat "$exp")" ] && ok=1
    done
    if [ "$ok" -eq 1 ]; then echo "PASS $name"; pass=$((pass + 1)); else echo "FAIL $name"; fail=$((fail + 1)); fi
done
echo "passed $pass, failed $fail"
[ "$fail" -eq 0 ]
