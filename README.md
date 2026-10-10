# Compiler Construction

Compiler construction work done alongside **CS3423 – Compilers 2** (IIT Hyderabad): lexers and parsers, LLVM IR, and Clang tooling. Updated as the work progresses.

## Contents

| Folder | What it is | Tools |
|---|---|---|
| [`Tcl-to-Cpp-Transpiler/`](Tcl-to-Cpp-Transpiler) | Mini assignment: lexer/parser conflict analysis and a Tcl → C++ transpiler | Flex, Bison |
| [`LLVM-IR-Explorer/`](LLVM-IR-Explorer) | C/C++ programs and the LLVM IR Clang 17.0.6 generates for them: globals, control flow, functions, casts, data structures, floating point; includes a written report | Clang, LLVM |
| [`Experiments/lex-yacc/`](Experiments/lex-yacc) | Lex/Yacc experiments: an integer-expression calculator and a lexer/parser for a small imperative language | Flex, Bison |
| [`Experiments/llvm-ir-and-cfg/`](Experiments/llvm-ir-and-cfg) | Emitting LLVM IR from C/C++, and dumping/visualising control-flow graphs | Clang, `opt`, Graphviz |
| [`Experiments/kaleidoscope-frontend/`](Experiments/kaleidoscope-frontend) | Flex/Bison front end that builds an AST and generates LLVM IR (modified Kaleidoscope tutorial) | Flex, Bison, LLVM |
| [`Experiments/clang-ast-matchers/`](Experiments/clang-ast-matchers) | A Clang tool using AST matchers to find function definitions and variable declarations | Clang LibTooling |

Setup notes for the environment (LLVM 14 / 17, flex, commands used) are in [`Experiments/setup-notes.txt`](Experiments/setup-notes.txt).

## Status

- **Done:** LLVM IR Explorer (programs, generated IR, report); Lex/Yacc calculator; mini-language lexer and parser (tokens and parse output included); LLVM IR and CFG exercises; Tcl → C++ transpiler.
- **Clang AST matcher tool** (`clang-ast-matchers/`): function and variable matchers both implemented; yet to be built and run against `test.cpp`.
- **Kaleidoscope front end:** source is included; see its folder for build instructions.

## Building the experiments

```bash
# Lex/Yacc calculator
cd Experiments/lex-yacc/calculator && bison -d parser.y -o parser.tab.c && flex lexer.l && gcc parser.tab.c lex.yy.c -o calc

# Kaleidoscope front end (needs LLVM and clang++)
cd Experiments/kaleidoscope-frontend && make

# CFG of a C file
cd Experiments/llvm-ir-and-cfg/cfg-and-pass
clang -x c -S -emit-llvm -O0 -Xclang -disable-O0-optnone -fno-discard-value-names temp.c -o temp.ll
opt -passes=dot-cfg temp.ll -disable-output && dot -Tpdf .foo.dot -o foo.pdf
```

Generated files (`lex.yy.c`, `*.tab.c`, binaries) are intentionally not committed.
