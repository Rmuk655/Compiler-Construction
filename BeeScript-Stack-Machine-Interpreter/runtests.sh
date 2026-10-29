#!/usr/bin/env bash
# Run every tests/test-cases/*.bee through the interpreter and compare output.txt
# with tests/expected/<name>.expected. If tests/inputs/<name>.input exists, its
# contents are passed as the second argument (the characters read by YELLOW).
# Usage: ./runtests.sh [path-to-interpreter]   (default: build/compiler)
set -u
root=$(cd "$(dirname "$0")" && pwd)
bin=$(realpath "${1:-$root/build/compiler}")
[ -x "$bin" ] || { echo "interpreter not found: $bin (run make first)" >&2; exit 2; }

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
cp "$root/script.txt" "$work/"

pass=0
fail=0
for bee in "$root"/tests/test-cases/*.bee; do
    name=$(basename "$bee" .bee)
    input=""
    [ -f "$root/tests/inputs/$name.input" ] && input=$(cat "$root/tests/inputs/$name.input")
    rm -f "$work/output.txt"
    (cd "$work" && "$bin" "$bee" "$input" 2>/dev/null)
    rc=$?
    if [ "$rc" -eq 0 ] && cmp -s "$work/output.txt" "$root/tests/expected/$name.expected"; then
        echo "PASS $name"
        pass=$((pass + 1))
    else
        echo "FAIL $name"
        fail=$((fail + 1))
    fi
done

# usage and file errors must fail cleanly (exit 1, message on stderr)
check_fails() { # name command...
    local name=$1; shift
    if (cd "$work" && "$@" >/dev/null 2>"$work/err.txt"); then
        echo "FAIL $name"; fail=$((fail + 1))
    elif [ -s "$work/err.txt" ]; then
        echo "PASS $name"; pass=$((pass + 1))
    else
        echo "FAIL $name"; fail=$((fail + 1))
    fi
}
check_fails err_no_arguments "$bin"
check_fails err_missing_file "$bin" "$work/does-not-exist.bee"

echo "passed $pass, failed $fail"
[ "$fail" -eq 0 ]
