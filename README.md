# Compiler Construction

Coursework for **CS3423 – Compilers 2** (IIT Hyderabad, Semester 5): mini assignments, lab sessions and related experiments. This repo is updated as the course progresses.

## Contents

| Folder | What it is | Tools |
|---|---|---|
| [`Tcl-to-Cpp-Transpiler/`](Tcl-to-Cpp-Transpiler) | Mini assignment: lexer/parser conflict analysis and a Tcl → C++ transpiler | Flex, Bison |
| [`Labs/lex-yacc/`](Labs/lex-yacc) | Lex/Yacc lab work: an integer-expression calculator and a lexer/parser for a small imperative language | Flex, Bison |
| [`Labs/llvm-ir-and-cfg/`](Labs/llvm-ir-and-cfg) | Emitting LLVM IR from C/C++, and dumping/visualising control-flow graphs | Clang, `opt`, Graphviz |
| [`Labs/kaleidoscope-frontend/`](Labs/kaleidoscope-frontend) | Flex/Bison front end that builds an AST and generates LLVM IR (modified Kaleidoscope tutorial) | Flex, Bison, LLVM |
| [`Labs/clang-ast-matchers/`](Labs/clang-ast-matchers) | A Clang tool using AST matchers to find function definitions and variable declarations | Clang LibTooling |

Setup notes for the lab environment (LLVM 14 / 17, flex, commands used) are in [`Labs/lab-setup-notes.txt`](Labs/lab-setup-notes.txt).

## Status

- **Done:** Lex/Yacc calculator; mini-language lexer and parser (tokens and parse output included); LLVM IR and CFG exercises; Tcl → C++ transpiler.
- **In progress:** Clang AST matcher tool (`clang-ast-matchers/`). The function matcher works; the variable matcher is registered but its counting is not finished.
- **Kaleidoscope front end:** source is included; see its folder for build instructions.

## Building the lab pieces

```bash
# Lex/Yacc calculator
cd Labs/lex-yacc/calculator && bison -d parser.y -o parser.tab.c && flex lexer.l && gcc parser.tab.c lex.yy.c -o calc

# Kaleidoscope front end (needs LLVM and clang++)
cd Labs/kaleidoscope-frontend && make

# CFG of a C file
cd Labs/llvm-ir-and-cfg/cfg-and-pass
clang -x c -S -emit-llvm -O0 -Xclang -disable-O0-optnone -fno-discard-value-names temp.c -o temp.ll
opt -passes=dot-cfg temp.ll -disable-output && dot -Tpdf .foo.dot -o foo.pdf
```

Generated files (`lex.yy.c`, `*.tab.c`, binaries) are intentionally not committed.
