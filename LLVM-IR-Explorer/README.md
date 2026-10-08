# LLVM IR Explorer

Small C/C++ programs and the LLVM IR Clang 17 generates for them, used to study how language constructs lower to IR.

| Dir | Covers |
|-----|--------|
| `Q1/` | globals/locals, conditionals and loops, functions, integer casts |
| `Q2/` | arrays, structs, classes, `std::vector`, unions, struct vs class |
| `Q3/` | ternary operator at `-O0` / `-O1`, token stream, AST |
| `Q4/` | floating-point types, operations and casts |

Requires `clang-17` / `clang++-17`. Run `./run.sh` to regenerate every `.ll` file.
