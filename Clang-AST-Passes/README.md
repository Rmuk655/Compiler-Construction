# Mini-Assignment 4: Clang AST Passes

CS3423 Compilers II, IIT Hyderabad. CS24BTECH11030, CS24BTECH11036.

This README is also submitted as `Mini-Asgn-4-CS24BTECH11030-CS24BTECH11036.pdf` (same content).

**Contributions.** CS24BTECH11030: Part 1 (AST dump and node analysis) and the traversal mechanisms section.
CS24BTECH11036: Part 2 (the three AST-matcher passes, their tests and write-up).

## Files

| Path | Contents |
|---|---|
| `1-ast-dump/nested_loops.cpp` | Program with a function `f`, nested `for` loops, a `while` loop and an `if`/`else`, used for the AST dump |
| `1-ast-dump/ast_dump.txt` | Full raw `clang -ast-dump` output for `nested_loops.cpp` (replaces the old `ast_dump_main.txt`) |
| `2-ast-matcher-passes/pass.cpp` | The three AST-matcher passes in one LibTooling tool |
| `2-ast-matcher-passes/CMakeLists.txt` | Build file (not part of the `.cpp`-only submission) |
| `2-ast-matcher-passes/tests/` | Test inputs: `assign_in_condition.cpp`, `empty_loop_body.cpp`, `unused_local.cpp` |

## Part 1: Exploring AST dumps

```bash
cd 1-ast-dump
clang -Xclang -ast-dump -fno-color-diagnostics -fsyntax-only nested_loops.cpp > ast_dump.txt
```

`nested_loops.cpp` has no `#include`, so the dump contains only Clang's few implicit typedefs plus `f` and
`main` (about 100 lines) and no filter is needed. It covers a function with a reference parameter (`f`),
nested `for` loops, a compound assignment (`sum += f(i, j)`), a `while` loop and an `if`/`else`.
`ast_dump.txt` is the committed output of the command above (addresses differ between runs).
The analysis of the nodes and of Clang's traversal mechanisms is in the PDF.

## Part 2: AST-matcher passes

All three matchers are in one file `pass.cpp`. Each check has its own test file in `tests/`. Every matcher only looks at the main file, so code from headers like `<stdio.h>` is ignored.

### Build and run

The tool is built inside an LLVM 17.0.6 source tree. The target is called `MA4_Pass`, so it does not clash with
the lab's `Simple_Pass`:

```bash
# run from the folder that contains 2-ast-matcher-passes/
cd path/to/CS24BTECH11030_CS24BTECH11036
cp -r 2-ast-matcher-passes ~/llvm-project/clang-tools-extra/ma4-passes
# add   add_subdirectory(ma4-passes)   to ~/llvm-project/clang-tools-extra/CMakeLists.txt
cd ~/llvm-project/build && cmake . && make -j4 MA4_Pass
bin/MA4_Pass ../clang-tools-extra/ma4-passes/tests/assign_in_condition.cpp --
```

`--` means "no compilation database".

Tested with LLVM/Clang 17.0.6.

### Pass 1: assignment inside a condition

**Goal.** Find `if (x = 5)`, where `==` was probably meant.

**Approach.** We check the conditional statements inside `if`, `for`, `while`, `do-while` and `?:` constructs and in each, we look for an
assignment operator `=`. The matcher for the `if` is shown below; the other four are the same with a different statement name, and `anyOf` joins all five.

```cpp
ifStmt(hasCondition(ignoringParenImpCasts(binaryOperator(hasOperatorName("=")).bind("assignment"))))
```

In C++, `n = 13` is implicitly converted to bool, and `if ((n = 13))` has extra brackets.
`ignoringParenImpCasts` skips extra nodes around the condition and without it, the above cases would be missed.
We match only plain assignment statements `=`, not compound assignment operators like `+=`.
The callback prints where the assignment is.

**Test.** `tests/assign_in_condition.cpp`

**Output.** The assignments on lines 5, 11, 17, 25, 29 are reported while the comparisons like `n == 10` on line 8 are not.

```
tests/assign_in_condition.cpp:5:8
tests/assign_in_condition.cpp:11:21
tests/assign_in_condition.cpp:17:11
tests/assign_in_condition.cpp:25:13
tests/assign_in_condition.cpp:29:10
```

### Pass 2: empty loop body

**Goal.** Find `for`, `while` and `do-while` loops with an empty body `{}`.

**Approach.** For each of the three loops, we use `hasBody(compoundStmt(statementCountIs(0)))`. This matches statements having a body with 0 statements inside it. However, loops with a single statement as the body, or just a `;` (like `for (...);`), are not reported, as the question asks only for empty blocks.

**Test.** `tests/empty_loop_body.cpp`

**Output.** The empty `for` on line 13, the empty `do{}while()` on line 21 and the empty `while(){}` on line 25 are reported.

```
tests/empty_loop_body.cpp:13:5
tests/empty_loop_body.cpp:21:5
tests/empty_loop_body.cpp:25:5
```

### Pass 3: unused local variable

**Goal.** Find local variables that are declared but never used.

**Approach.** We use two matchers decls and refs. decls records every local variable when it is declared. refs records every
place a local variable is used. Each variable has one declaration node, and every use (referenced) points back to it, so we
can tell variables apart even if they have the same name. We keep two sets: declared variables and referenced variables. 
After we process the whole file, any variable in the declared set but not in the referenced set is unused (unreferenced) and we print it. 
We must wait until the end because a variable may be used later in the file after it is declared. 
Function parameters, global variables and `static` locals are not reported. A variable that is only assigned to after declaration
(`int c = 3; c = 4;`) also counts as used.

**Test.** `tests/unused_local.cpp`

**Output.** The unused `y` in `f`, unused `z` in `f` and the unused `x` in `main` are all reported. `n`, `i` and `x` in `f` are used, so they
are not reported.

```
Unused variable: y
Unused variable: z
Unused variable: x
```

## Limitations

- Pass 1 finds only statements with `=`. It misses `if (x += 2)`. It also misses assignments inside bigger conditions, like
  `if ((x = 1) && y)`, because we only check the whole condition and not break it into subparts.
- Pass 2 does not report `for (...);` or `while (...);`, or a body that only holds an empty inner block like `for(...){if(...){}}`.
- Pass 3 misses variables that are only assigned and never read. It does not report parameters, globals or `static` local variables. It prints only the name, not the line number of the variable which can be confusing if the variable name is used across multiple scopes.
- Code in headers is ignored, so problems in included files are not reported.

## Note on AI use

AI assistance was used to organize and polish the report. The passes themselves were written by us.
