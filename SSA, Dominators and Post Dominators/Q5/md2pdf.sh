#!/usr/bin/env bash
# Q5.md -> Q5.tex -> Q5.pdf
# Needs pandoc and pdflatex.
set -euo pipefail
cd "$(dirname "$0")"

pandoc Q5.md -s -o Q5.tex \
    -V geometry:margin=0.8in -V colorlinks=true \
    -M title="CS3423 Mini Assignment 6: Q5"

pdflatex -interaction=nonstopmode -halt-on-error Q5.tex > /dev/null
rm -f Q5.aux Q5.log Q5.out
echo "done: Q5.tex, Q5.pdf"
