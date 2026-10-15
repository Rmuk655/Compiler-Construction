# Mini Assignment 4: Clang AST Passes

CS3423 Compilers II, IIT Hyderabad. Team: CS24BTECH11030, CS24BTECH11036.
The PDF write-up is `Mini-Asgn-4-CS24BTECH11030-CS24BTECH11036.pdf`.

| Roll no. | Work |
|---|---|
| CS24BTECH11030 | Part 1 (AST dump and node analysis), traversal mechanisms |
| CS24BTECH11036 | Part 2 (AST-matcher passes, tests, write-up) |

## Layout

| Path | Contents |
|---|---|
| `1-ast-dump/nested_loops.cpp` | Program with nested loops and function calls, used for the AST dump |
| `1-ast-dump/ast_dump_main.txt` | Raw `clang -ast-dump` output for `main` |
| `2-ast-matcher-passes/pass.cpp` | The three AST-matcher passes in one LibTooling tool |
| `2-ast-matcher-passes/CMakeLists.txt` | Build file (not part of the `.cpp`-only submission) |
| `2-ast-matcher-passes/tests/` | Inputs: `assign_in_condition.cpp`, `empty_loop_body.cpp`, `unused_local.cpp` |

## Part 1: AST dump

```bash
clang -fsyntax-only -Xclang -ast-dump -Xclang -ast-dump-filter=main 1-ast-dump/nested_loops.cpp
```

`-ast-dump-filter=main` limits the dump to `main`, skipping the thousands of nodes pulled in by `<stdio.h>`.
The analysis of the nodes and of Clang's traversal mechanisms is in the PDF.

## Part 2: AST-matcher passes

One tool, `pass.cpp`, registers six matchers on a single `MatchFinder` with a single callback. Every matcher is
restricted to the main file with `isExpansionInMainFile()`, so nodes coming from `<stdio.h>` and other headers
are ignored. The callback tells the matchers apart by their bind ID.

| # | Detects | Matcher(s) | Bind ID | Test input |
|---|---|---|---|---|
| 1 | Assignment used as a condition (`if (x = 5)`), probably a typo for `==` | `ifStmt`, `forStmt`, `whileStmt`, `doStmt`, `conditionalOperator`, each with `hasCondition(ignoringParenImpCasts(binaryOperator(hasOperatorName("="))))`, combined with `anyOf` | `assignment` | `tests/assign_in_condition.cpp` |
| 2 | `for` / `while` / `do-while` whose body is an empty `{}` | `forStmt` / `whileStmt` / `doStmt` with `hasBody(compoundStmt(statementCountIs(0)))` | `loop` | `tests/empty_loop_body.cpp` |
| 3 | Local variable declared but never referenced | `varDecl(hasLocalStorage())` for declarations, `declRefExpr(to(varDecl(hasLocalStorage())))` for uses | `var`, `ref` | `tests/unused_local.cpp` |

### How each pass works

**Pass 1.** A condition is not always the bare assignment: in C++ `if (n = 13)` wraps it in an
`ImplicitCastExpr` (int to bool), and `if ((n = 13))` adds a `ParenExpr`. `ignoringParenImpCasts` skips those,
so both forms are found. All five statement kinds that have a condition are covered.

**Pass 2.** Only a body that is a `CompoundStmt` with zero statements counts. A loop whose body is a single
non-block statement (`for (...) x++;`) or a bare `;` (`NullStmt`) is deliberately not reported, because the
assignment asks for empty compound statements.

**Pass 3.** A set difference, computed after the whole file has been visited:

```
Declared = { VarDecl* of every local variable }
Used     = { VarDecl* that some DeclRefExpr refers to }
Unused   = Declared minus Used
```

Every variable has exactly one `VarDecl` node and every use is a `DeclRefExpr` whose `getDecl()` points back to it,
so the `VarDecl*` is the variable's identity (two variables both named `i` are two different pointers). The
report is printed after `Tool.run(...)` because a use may appear after the declaration.

### Build

The tool is built inside an LLVM 17.0.6 source tree. Either use the lab layout:

```bash
cp -r 2-ast-matcher-passes ~/llvm-project/clang-tools-extra/Mypass
# add   add_subdirectory(Mypass)   to clang-tools-extra/CMakeLists.txt
cd ~/llvm-project/build && cmake . && make -j4 Simple_Pass
```

or build it from where it is, with a small wrapper `CMakeLists.txt` in the LLVM tree that points at this folder.

### Run

```bash
~/llvm-project/build/bin/Simple_Pass 2-ast-matcher-passes/tests/assign_in_condition.cpp --
```

(`--` means "no compilation database".)

### Expected results on the provided tests

| Test | What it contains | Expected report |
|---|---|---|
| `assign_in_condition.cpp` | `if (n = 13)` on line 5, and `if (n == 10)` on line 8 | line 5 only |
| `empty_loop_body.cpp` | empty `for` body (lines 6-8); `do` and `while` have real bodies | the `for` on line 6 only |
| `unused_local.cpp` | `x` in `f` and `x` in `main` are never used; `n`, `i` are | `Unused variable: x` twice |

## Status

Verified on 15 Oct 2026 against LLVM 17.0.6 (`MA4_Pass` target, built from the committed `pass.cpp`):

- [x] Part 1 write-up
- [x] `pass.cpp` compiles, links and runs on all three tests
- [x] Pass 1 reports line 5 of `assign_in_condition.cpp` (`if (n = 13)`) and not line 8 (`n == 10`)
- [x] Pass 2 reports the empty `for` on line 6 of `empty_loop_body.cpp` and nothing else
- [x] Pass 3 reports `Unused variable: x` twice on `unused_local.cpp`; `n` and `i` are not reported
- [ ] Sample outputs added to the PDF

### Extra checks (own test inputs, not committed)

- Pass 1 found `if (x = 5)`, `if ((x = g()))`, `while (x = y)`, `for (;x = y;)`, `do {} while (x = 0)` and
  `(x = 3) ? 1 : 2`, and did not report `if (x == 5)`, `x = 7;` or `if (x)`.
- Pass 2 found empty `for`, `while` and `do-while` bodies and skipped `for (...);`, `while (...);` and non-empty bodies.
- Pass 3 found a plain unused local, an unused local in an inner block, and one inside a loop body. It did not
  report used variables, a global, a `static` local or function parameters.

### Behaviour to state in the PDF

1. Pass 1 matches plain `=` only. `if (x += 2)` is not reported (`hasOperatorName("=")`).
2. Pass 2 reports only an empty `{}`. `for (...);` (a `NullStmt` body) is not reported.
3. Pass 3 treats any reference as a use, so `int c = 3; c = 4;` (written, never read) is not reported.
4. Output for passes 1 and 2 is the source location (`file:line:col`) of the offending statement.

## Notes

The README and PDF text were drafted with AI assistance. The passes are written by the authors.
