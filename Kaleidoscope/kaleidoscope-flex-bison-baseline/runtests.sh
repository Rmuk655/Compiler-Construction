#!/usr/bin/env bash
# Run every tests/cases/<name>.kal through the compiler front end and check its
# diagnostics/IR (stdout + stderr) against tests/expected/<name>.expect.
# Each non-empty line of an .expect file is a fixed string that must appear in
# the output; a line starting with '!' is a string that must NOT appear.
# Usage: ./runtests.sh [path-to-toy]   (default: ./toy)
set -u
root=$(cd "$(dirname "$0")" && pwd)
bin=$(realpath "${1:-$root/toy}")
[ -x "$bin" ] || { echo "toy not found: $bin (run make first)" >&2; exit 2; }

pass=0
fail=0
for kal in "$root"/tests/cases/*.kal; do
    name=$(basename "$kal" .kal)
    out=$("$bin" < "$kal" 2>&1)
    ok=1
    while IFS= read -r line; do
        [ -z "$line" ] && continue
        if [ "${line:0:1}" = "!" ]; then
            grep -qF -- "${line:1}" <<< "$out" && ok=0
        else
            grep -qF -- "$line" <<< "$out" || ok=0
        fi
    done < "$root/tests/expected/$name.expect"
    if [ "$ok" -eq 1 ]; then echo "PASS $name"; pass=$((pass + 1)); else echo "FAIL $name"; fail=$((fail + 1)); fi
done
echo "passed $pass, failed $fail"
[ "$fail" -eq 0 ]
