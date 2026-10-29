#!/usr/bin/env bash
# Dump the AST of nested_loops.cpp with clang and check how many nodes of each
# kind it contains. The counts are worked out by hand from nested_loops.cpp.
# The committed ast_dump.txt is checked against the same counts.
# Usage: ./runtests.sh      (env: CLANG overrides clang)
set -u
root=$(cd "$(dirname "$0")" && pwd)
CLANG=${CLANG:-clang}

fresh=$("$CLANG" -Xclang -ast-dump -fno-color-diagnostics -fsyntax-only "$root/nested_loops.cpp" 2>/dev/null)
committed=$(cat "$root/ast_dump.txt")

pass=0
fail=0
check() { # label dump-text pattern expected-count
    local got
    got=$(grep -cE "$3" <<< "$2")
    if [ "$got" -eq "$4" ]; then echo "PASS $1"; pass=$((pass + 1)); else echo "FAIL $1 (got $got, want $4)"; fail=$((fail + 1)); fi
}

# node pattern                                            count
checks=(
    '[-`]ForStmt 0x|2'
    '[-`]WhileStmt 0x|1'
    '[-`]IfStmt 0x|1'
    '[-`]CompoundAssignOperator 0x|2'
    '[-`]CallExpr 0x|1'
    '[-`]ReturnStmt 0x|2'
    '[-`]ParmVarDecl 0x|2'
    '[-`]VarDecl 0x|5'
    '[-`]DeclStmt 0x|4'
    '[-`]FunctionDecl 0x[0-9a-f]+ <[^>]*> line:[0-9:]+ (used )?(f|main) .int|2'
)
for entry in "${checks[@]}"; do
    pattern=${entry%|*}
    count=${entry##*|}
    check "fresh     $pattern" "$fresh" "$pattern" "$count"
    check "committed $pattern" "$committed" "$pattern" "$count"
done

echo "passed $pass, failed $fail"
[ "$fail" -eq 0 ]
