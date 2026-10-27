# LLVM IR Explorer

Small C/C++ programs and the LLVM IR that Clang 17.0.6 (built from source) generates for them, used to study how language constructs lower to IR. Folder numbers follow the assignment items (item 1, the LLVM directory layout, is theory only).

| Dir | Covers |
|-----|--------|
| `Q2/` | IR study: globals/locals, conditionals and loops, functions, integer casts (`fptosi`, `sext`, `trunc`) |
| `Q3/` | data structures: arrays, struct, class, `std::vector`, union, struct vs class |
| `Q4/` | floating-point types, operations and casts |

Run `./run.sh` to regenerate every output. `Report.pdf` is the report.
