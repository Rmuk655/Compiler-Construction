# Mini Assignment 4: Clang AST Passes

CS3423 Compilers II, IIT Hyderabad. Team: CS24BTECH11030, CS24BTECH11036.
The PDF write-up is `Mini-Asgn-4-CS24BTECH11030-CS24BTECH11036.pdf`.

## Layout

| Path | Contents |
|---|---|
| `1-ast-dump/nested_loops.cpp` | Program with nested loops and function calls, used for the AST dump |
| `1-ast-dump/ast_dump_main.txt` | Raw `clang -ast-dump` output for `main` |
| `2-ast-matcher-passes/pass.cpp` | The AST-matcher pass(es) (LibTooling tool `Simple_Pass`) |
| `2-ast-matcher-passes/CMakeLists.txt` | Build file for `Simple_Pass` (not part of the `.cpp`-only submission) |
| `2-ast-matcher-passes/tests/` | Inputs: `assign_in_condition.cpp`, `empty_loop_body.cpp`, `unused_local.cpp` |

## Part 1: AST dump

```bash
clang -fsyntax-only -Xclang -ast-dump -Xclang -ast-dump-filter=main 1-ast-dump/nested_loops.cpp
```

`-ast-dump-filter=main` limits the dump to `main`, skipping the thousands of nodes pulled in by `<stdio.h>`.
The analysis of the nodes and of Clang's traversal mechanisms is in the PDF.

## Part 2: passes

| # | Detects | Test input |
|---|---|---|
| 1 | Assignment used as a condition (`if (x = 5)`), likely a typo for `==` | `tests/assign_in_condition.cpp` |
| 2 | `for` / `while` / `do-while` with an empty compound-statement body | `tests/empty_loop_body.cpp` |
| 3 | Local variable declared but never referenced in its function | `tests/unused_local.cpp` |

### Build

The tool is built inside an LLVM 17.0.6 source tree, like the lab's `Simple_Pass`:

```bash
cp -r 2-ast-matcher-passes ~/llvm-project/clang-tools-extra/Mypass
# add   add_subdirectory(Mypass)   to clang-tools-extra/CMakeLists.txt
cd ~/llvm-project/build && cmake . && make -j4 Simple_Pass
```

### Run

```bash
~/llvm-project/build/bin/Simple_Pass 2-ast-matcher-passes/tests/assign_in_condition.cpp --
```

(`--` means "no compilation database".)

## Status

- [x] Part 1 write-up
- [ ] Pass 1: assignment in condition
- [ ] Pass 2: empty loop body
- [ ] Pass 3: unused local variable
- [ ] Sample outputs added to the PDF

## Notes

The README and PDF text were drafted with AI assistance. The passes are written by the authors.
