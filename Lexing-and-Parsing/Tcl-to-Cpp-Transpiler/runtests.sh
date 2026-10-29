#!/usr/bin/env bash
# Checks for Q1 and Q2 of the Tcl-to-C++ assignment:
#   Q1: flex warns "rule cannot be matched" for the shadowed rule in Qn1/example1.l
#       and Qn1/example2.l, and does not warn for the clean Qn3 lexer.
#   Q2: bison reports exactly one shift/reduce conflict for Qn2/sr_conflict.y,
#       exactly one reduce/reduce conflict for Qn2/rr_conflict.y, and no
#       conflicts for the Qn3 parser.
# (The transpiler itself is tested by Qn3/runtests.sh.)
# Usage: ./runtests.sh
set -u
root=$(cd "$(dirname "$0")" && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

pass=0
fail=0
expect() { # name condition-exit-status
    if [ "$2" -eq 0 ]; then echo "PASS $1"; pass=$((pass + 1)); else echo "FAIL $1"; fail=$((fail + 1)); fi
}

flex_out() { flex -o "$work/lex.c" "$1" 2>&1; }
bison_out() { bison -y -v -o "$work/y.c" "$1" 2>&1; }

for f in example1 example2; do
    out=$(flex_out "$root/Qn1/$f.l")
    [ "$(grep -c 'rule cannot be matched' <<< "$out")" -eq 1 ]
    expect "Qn1/$f.l warns 'rule cannot be matched' once" $?
done
out=$(flex_out "$root/Qn3/src/lexer.l")
! grep -q 'rule cannot be matched' <<< "$out"
expect "Qn3 lexer has no unmatched rule" $?

out=$(bison_out "$root/Qn2/sr_conflict.y")
grep -q '1 shift/reduce conflict' <<< "$out" && ! grep -q 'reduce/reduce' <<< "$out"
expect "Qn2/sr_conflict.y has exactly 1 shift/reduce conflict" $?

out=$(bison_out "$root/Qn2/rr_conflict.y")
grep -q '1 reduce/reduce conflict' <<< "$out" && ! grep -q 'shift/reduce' <<< "$out"
expect "Qn2/rr_conflict.y has exactly 1 reduce/reduce conflict" $?

out=$(bison_out "$root/Qn3/src/parser.y")
! grep -q 'conflict' <<< "$out"
expect "Qn3 parser has no conflicts" $?

echo "passed $pass, failed $fail"
[ "$fail" -eq 0 ]
