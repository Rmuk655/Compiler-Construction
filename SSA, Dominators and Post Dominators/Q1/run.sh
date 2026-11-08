#!/usr/bin/env bash
# For every program in "cpp Codes":
#   1. emit unoptimised LLVM IR (block names kept, so the trees are readable)
#   2. print the dominator and post-dominator trees with opt  -> trees/N.txt
#   3. draw the CFG, dominator tree and post-dominator tree   -> trees/N_*.pdf
# Needs clang++, opt (LLVM 18 was used) and graphviz.
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p IR trees

for src in "cpp Codes"/*.cpp; do
    n=$(basename "$src" .cpp)
    ll="$PWD/IR/$n.ll"

    clang++ -std=c++17 -S -emit-llvm -O0 -Xclang -disable-O0-optnone \
        -fno-discard-value-names "$src" -o "$ll"

    opt -passes='print<domtree>,print<postdomtree>' -disable-output "$ll" \
        2>&1 | c++filt > "trees/$n.txt"

    # the function we care about is the one that isn't main
    fn=$(grep -oP '^define .*@\K[\w.]+' "$ll" | grep -vx main | head -n1)

    tmp=$(mktemp -d)
    (cd "$tmp" && opt -passes='dot-cfg-only,dot-dom-only,dot-post-dom-only' \
        -disable-output "$ll" > /dev/null 2>&1)
    for g in ".:cfg" "domonly.:dom" "postdomonly.:postdom"; do
        # drop LLVM's long caption (the PDF has its own) and tighten spacing
        sed -e '/^\tlabel=/d' -e 's/Post dominance root node/virtual exit/' \
            "$tmp/${g%%:*}$fn.dot" |
            dot -Tpdf -Gnodesep=0.2 -Granksep=0.35 -o "trees/${n}_${g##*:}.pdf"
    done
    rm -rf "$tmp"

    echo "done: $src  ($fn)"
done
