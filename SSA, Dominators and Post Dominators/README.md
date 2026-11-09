# CS3423 Mini Assignment 6: SSA, Dominators and Post Dominators

Team: Krishnan R (CS24BTECH11036)

## Contents

| Path | What it has |
|------|-------------|
| `Q1/cpp Codes/1.cpp` to `5.cpp` | five programs with branches: if / else-if / else ladder, for loop with `continue` and `break`, while loop with `&&` and an if-else, do-while with a switch, nested for loops with an early `return` |
| `Q1/IR/N.ll` | unoptimised LLVM IR of each program |
| `Q1/trees/N.txt` | dominator and post-dominator trees printed by `opt` |
| `Q1/trees/N_cfg.pdf`, `N_dom.pdf`, `N_postdom.pdf` | CFG, dominator tree and post-dominator tree of each program |
| `Q1/Q1.pdf` (source `Q1.tex`) | difference between dominators and post-dominators, the trees, and for every block its idom, ipdom and which blocks it dominates and post-dominates |
| `Q1/run.sh` | regenerates everything in `Q1/IR` and `Q1/trees` |
| `Q2/Q2.md` | what SSA is and which analyses and optimisations benefit from it |
| `Q3/Q3.md` | 10-point summary of Cytron et al., "Efficiently Computing Static Single Assignment Form and the Control Dependence Graph" (TOPLAS 1991) |
| `Q3/Paper.pdf` | the paper summarised in Q3 |
| `Q4/Q4.md` | what LLVM's mem2reg pass does and why it helps |
| `Q5/cpp Codes/1.cpp` to `5.cpp` | five programs with pointers |
| `Q5/IR/N_before.ll`, `N_after.ll` | IR without and with mem2reg |
| `Q5/q5_analysis.txt` | analyses requested by mem2reg (`opt -debug-pass-manager` output) |
| `Q5/Q5.pdf` (source `Q5.tex`) | observations: analyses mem2reg depends on, variables promoted to SSA, variables left in memory and why |

## Tools used

- Ubuntu LLVM 18.1.3 (`clang++`, `opt`)
- `c++filt` (binutils), to demangle function names in the tree output
- Graphviz `dot`, to draw the graphs as PDFs
- `pdflatex`, for `Q1.pdf` and `Q5.pdf`
## Running Q1

```bash
cd Q1
./run.sh
pdflatex Q1.tex
```

For each `cpp Codes/N.cpp`, `run.sh` does the following:

1. It emits IR with
   `clang++ -std=c++17 -S -emit-llvm -O0 -Xclang -disable-O0-optnone -fno-discard-value-names N.cpp -o IR/N.ll`.
   `-fno-discard-value-names` keeps block names such as `if.then` and `for.cond`, so the trees are readable.
2. It prints both trees with
   `opt -passes='print<domtree>,print<postdomtree>' -disable-output IR/N.ll`
   into `trees/N.txt`.
3. It draws the CFG and both trees with the `dot-cfg-only`, `dot-dom-only` and `dot-post-dom-only` passes and Graphviz.

## Running Q5

For each program `N.cpp` in `Q5/cpp Codes`:

```bash
clang++ -std=c++17 -S -emit-llvm -O0 -Xclang -disable-O0-optnone "cpp Codes/N.cpp" -o IR/N_before.ll
opt -passes=mem2reg -S IR/N_before.ll -o IR/N_after.ll
opt -passes=verify -disable-output IR/N_after.ll
opt -debug-pass-manager -passes=mem2reg -disable-output IR/N_before.ll
```

The last command lists the analyses mem2reg requests (saved in `q5_analysis.txt`).

## Assumptions and notes

- `-O0` alone adds the `optnone` attribute, which makes `opt` skip mem2reg. So `-Xclang -disable-O0-optnone` is used, as the assignment suggests. The IR is still unoptimised.
- The Q1 tables list only strict relations, because every block dominates and post-dominates itself.
- LLVM adds a virtual exit node as the root of the post-dominator tree. So the last block of each function has `exit` as its immediate post-dominator.
- Q1 shows only the function with branches in each file. `main` is a single block, so its trees are trivial.
- The layout uses folders `Q1` to `Q5`, with `Q2.md`, `Q3.md` and `Q4.md` inside their own folders.
