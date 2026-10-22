# Compilers 1 (CS3320) assignments

Coursework from Compilers 1 (CS3320, IIT Hyderabad): a Flex lexer and hand-written LLVM IR for small C and C++ programs. These were previously the separate `compiler-construction-practice` repository; its commit history is part of this repository.

| Folder | Contents | Tools |
|---|---|---|
| [`Assignment-1-Lexer/`](Assignment-1-Lexer) | Lexer for a small "pp" language (labels, keywords, data types, identifiers, numbers, strings with escapes, operators, scope brackets), with 12 test inputs and expected token streams | Flex, GCC |
| [`Assignment-2-LLVM-IR/`](Assignment-2-LLVM-IR) | C and C++ programs with the LLVM IR Clang generates for them, a report, the problem statement and a Word copy of the report | Clang / LLVM |

## Assignment 1: lexer

Build and run (`lex.yy.c` and the `lexer` binary are generated and not committed):

```bash
cd Assignment-1-Lexer
flex lexer.l && gcc lex.yy.c -o lexer
./lexer < test_cases/I1.txt
```

Run all test cases. A case passes when the lexer output equals `<name>.expected` (or `<name>_alternate.expected`), ignoring trailing blank lines:

```bash
for t in test_cases/*.txt; do
  n=$(basename "$t" .txt); out=$(./lexer < "$t")
  if [ "$out" = "$(cat test_cases/$n.expected)" ] || { [ -f test_cases/${n}_alternate.expected ] && [ "$out" = "$(cat test_cases/${n}_alternate.expected)" ]; }; then echo "PASS $n"; else echo "FAIL $n"; fi
done
```

All 12 cases pass with Flex and GCC on Ubuntu; `I3` matches its alternate expected output (the specification allows the brackets either way). The token classes are listed in [`Assignment-1-Lexer/README.txt`](Assignment-1-Lexer/README.txt). The two PDFs in the folder are the lab practice and evaluation sheets.

## Assignment 2: LLVM IR

Generate the IR for a source file:

```bash
cd Assignment-2-LLVM-IR/Q1
clang -S -emit-llvm -O0 Q1a.c -o Q1a.ll
```

| Folder | Contents |
|---|---|
| `Q1/` | `Q1a` global and local integers, `Q1b` if/else, `Q1c` function call, `Q1d` narrowing and widening casts |
| `Q2/` | `Q2a` static and `malloc`-allocated arrays, `Q2bi` struct, `Q2bii` C++ class (source is `Q2bii.cpp`) |
| `Q3/` | `input.c` with a ternary expression; `ternary_O0.ll` and `ternary_O1.ll` are its IR at `-O0` and `-O1` |

`Report.pdf` explains the IR; `Report.docx` is its Word copy, and `Assignment-2-problem-statement.pdf` is the assignment sheet.

Notes on the committed files:

- The `.ll` files were generated with Clang 17.0.6 (`Q1a`, `Q1b`, `Q2*`) and Clang 18.1.3 (`Q1c`, `Q1d`, `Q3`), so a regeneration with another Clang differs in metadata and data layout.
- All committed `.ll` files pass `opt -passes=verify`.
- `Q1d.c` defines `uint64` as `long` and `uint32` as `int` at the top of the file; with those definitions its `main` compiles to exactly the IR in the committed `Q1d.ll` (the widening in part (iii) is a sign extension).
- `Q3/sample.c` is a small copy-propagation and dead-code example (no IR is committed for it); it compiles with Clang.
- Every `.c` file in the assignment compiles with `clang -S -emit-llvm -O0`.
