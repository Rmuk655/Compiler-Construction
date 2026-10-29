#!/usr/bin/env bash
# IR sanity checks for this directory:
#   * every .c / .cpp file compiles to LLVM IR that passes the LLVM verifier
#   * every committed .ll file parses and passes the verifier
# Usage: ./runtests.sh      (env: CC, CXX, OPT override clang, clang++, opt)
set -u
root=$(cd "$(dirname "$0")" && pwd)
CC=${CC:-clang}; CXX=${CXX:-clang++}; OPT=${OPT:-opt}

pass=0
fail=0
report() { # status name
    if [ "$1" -eq 0 ]; then echo "PASS $2"; pass=$((pass + 1)); else echo "FAIL $2"; fail=$((fail + 1)); fi
}

while IFS= read -r src; do
    case $src in *.cpp) cc=$CXX ;; *) cc=$CC ;; esac
    "$cc" -S -emit-llvm -O0 -o - "$src" 2>/dev/null | "$OPT" -passes=verify -disable-output 2>/dev/null
    report $(( PIPESTATUS[0] + PIPESTATUS[1] )) "compile ${src#$root/}" 
done < <(find "$root" \( -name '*.c' -o -name '*.cpp' \) -not -path '*/graphify-out/*' -not -path '*/build/*' | sort)

while IFS= read -r ll; do
    "$OPT" -passes=verify -disable-output "$ll" 2>/dev/null
    report $? "verify ${ll#$root/}"
done < <(find "$root" -name '*.ll' -not -path '*/graphify-out/*' -not -path '*/build/*' | sort)

echo "passed $pass, failed $fail"
[ "$fail" -eq 0 ]
