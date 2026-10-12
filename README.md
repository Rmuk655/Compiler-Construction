# Compiler Construction Practice

Assignments from Compilers 1 (CS3320, IIT Hyderabad): a Flex lexer and hand-written LLVM IR experiments.

| Assignment | Contents | Tools |
|---|---|---|
| [`Assignment 1/`](Assignment%201/CS24BTECH11036) | Lexer for a small "pp" language: labels, keywords, data types, identifiers, numbers, strings with escapes, operators, scope brackets. 12 test cases with expected token streams. | Flex, GCC |
| [`Assignment 2/`](Assignment%202/CS24BTECH11036) | LLVM IR for C programs: globals and locals, if/else and loops, function calls, type casts, arrays, structs, and a ternary expression at `-O0` and `-O1`. Each `.c` file has its generated `.ll` next to it, and `Report.pdf` explains the IR. | Clang/LLVM |

## Assignment 1: lexer

```bash
cd "Assignment 1/CS24BTECH11036"
flex lexer.l && gcc lex.yy.c -o lexer
./lexer < test_cases/I1.txt
```

Every test case compares against `test_cases/<name>.expected`; see that folder's `README.txt` for the token classes. All 12 cases pass (I3 matches its alternate expected output).

## Assignment 2: LLVM IR

```bash
cd "Assignment 2/CS24BTECH11036/Q1"
clang -S -emit-llvm -O0 Q1a.c -o Q1a.ll
```

| Folder | Topic |
|---|---|
| `Q1/` | `Q1a` global and local integers, `Q1b` if/else, `Q1c` function call, `Q1d` narrowing and widening casts |
| `Q2/` | `Q2a` static and `malloc`-allocated arrays, `Q2bi` and `Q2bii` structs |
| `Q3/` | Ternary operator: IR at `-O0` versus `-O1` |
