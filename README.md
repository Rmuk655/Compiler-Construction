# Compiler Construction

[![CI](https://github.com/Rmuk655/Compiler-Construction/actions/workflows/ci.yml/badge.svg)](https://github.com/Rmuk655/Compiler-Construction/actions/workflows/ci.yml)

Front ends, intermediate representations and compiler tooling, written in C, C++, Flex, Bison, LLVM and Clang LibTooling. Over 300 automated checks across the projects; every one runs with `make test` or `ctest`.

## Flagship projects

### Typed Kaleidoscope front end on LLVM — [`Kaleidoscope/kaleidoscope-frontend`](Kaleidoscope/kaleidoscope-frontend)
A Flex/Bison front end that extends the LLVM Kaleidoscope tutorial with a typed language (`int`, `double`, `bool`).
- Typed parameters recorded in a symbol table; type checking with explicit diagnostics (bool arithmetic, narrowing, duplicate parameters, unknown variables, literal overflow, division by a constant zero).
- Implicit `int` to `double` promotion, explicit casts (`fptosi`, `sitofp`, `uitofp`, `zext`), and `extern`/`def` signature checks.
- Correct IR for signed integer and ordered floating-point comparisons.
- 20 regression tests assert the exact IR instructions and error messages. The earlier untyped version is kept in `kaleidoscope-flex-bison-baseline` with its own 20 tests.

### Clang AST-matcher passes — [`Clang-Tooling/Clang-AST-Passes`](Clang-Tooling/Clang-AST-Passes)
A LibTooling tool that reports assignment used as a condition (`if`, `for`, `while`, `do`, `?:`), empty loop bodies, and unused locals, with source locations.
- 24 tests with hand-derived expected locations, including negative cases that must stay silent.
- Output is deterministic: unused variables are reported in source order.

### Tcl-to-C++ transpiler — [`Lexing-and-Parsing/Tcl-to-Cpp-Transpiler`](Lexing-and-Parsing/Tcl-to-Cpp-Transpiler)
A Flex/Bison transpiler for a Tcl subset: type inference (`int`/`float`), scoped declarations, `if`/`else`, `while`, and expressions with correct precedence.
- 24 tests, including error cases, transpile, compile with `g++` and run each program, then compare its output.
- Also reproduces and checks Flex "rule cannot be matched" warnings and Bison shift/reduce and reduce/reduce conflicts.

### LLVM IR study — [`LLVM-IR`](LLVM-IR) and [`Lexer-and-IR-Programs`](Lexer-and-IR-Programs)
C and C++ programs with the IR Clang generates (globals, control flow, casts, structs, unions, vectors, classes, floating point), CFG dumps, and a dead-code experiment. Every `.c`, `.cpp` and `.ll` file is checked with the LLVM verifier.

## Smaller projects
- [`BeeScript-Stack-Machine-Interpreter`](BeeScript-Stack-Machine-Interpreter): a stack-machine interpreter in Flex/Bison with error handling (31 tests).
- [`Lexer-and-IR-Programs/Lexer-Project`](Lexer-and-IR-Programs/Lexer-Project): a Flex lexer for a small language (20 tests).
- [`Lexing-and-Parsing/lex-yacc/calculator`](Lexing-and-Parsing/lex-yacc/calculator): an integer-expression calculator with error recovery (30 tests).

## How the tests are built
- Expected outputs come from the language specification and hand calculation, not from the program's own output.
- IR is checked with the LLVM verifier (`opt -passes=verify`) and by asserting specific instructions.
- Each negative case (a diagnostic that must fire, or a pattern that must not be flagged) is tested as well as the positive ones.
- Flex/Bison projects and the IR checks run in GitHub Actions on every push. The Kaleidoscope and Clang-tooling suites need an LLVM toolchain, so they run locally.

```bash
cd <project> && make test
cmake -S . -B build && cmake --build build && ctest --test-dir build
```

## Notes
The Kaleidoscope front end builds on the [LLVM Kaleidoscope tutorial](https://llvm.org/docs/tutorial/). Toolchain setup and per-project build commands are in [`SETUP.md`](SETUP.md).

## License
See [`LICENSE`](LICENSE).
