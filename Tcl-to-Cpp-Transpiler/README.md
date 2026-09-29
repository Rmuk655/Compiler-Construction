# CS3423 Mini Assignment 2: Lex and Yacc

**Team members**
- CS24BTECH11030
- CS24BTECH11036

**Requirements:** `flex`, `bison`, `gcc`, `g++`, `make` (tested on Linux / WSL Ubuntu).

---

## Q1: "warning, rule cannot be matched"

This warning appears when a rule's pattern is entirely shadowed by an earlier
rule (longest match wins, ties go to the earlier rule), so the later rule's
action can never run. See `Qn1/report.pdf` for the full explanation.

- `Qn1/example1.l` — `"end"` shadowed by `[a-z]+`
- `Qn1/example2.l` — `[0-9]{3}` shadowed by `[0-9]+`

Run: `flex Qn1/example1.l` (or `example2.l`) to reproduce the warning.

---

## Q2: Shift-reduce and reduce-reduce conflicts

See `Qn2/report.pdf` for the full explanation.

- `Qn2/sr_conflict.y` — dangling-else grammar, 1 shift/reduce conflict
- `Qn2/rr_conflict.y` — two identical single-token rules, 1 reduce/reduce conflict

Run: `bison -y -v Qn2/sr_conflict.y` (or `rr_conflict.y`) to reproduce the warnings.

---

## Q3: Tcl subset to C++ transpiler

### Directory layout
```
Qn3/
├── src/
│   ├── lexer.l       flex lexer: turns Tcl source into tokens
│   └── parser.y      bison parser: grammar + C++ code generation
├── build/
│   └── Makefile      builds ./tcl2cpp and runs the tests
└── test/
    ├── input/        Tcl test programs      (t1.txt, t2.txt, ...)
    ├── output/       transpiled C++ files   (output1.cpp, ...)
    └── printed/      output of running them (printed1.txt, ...)
```

### How to run
```bash
cd Qn3/build
make            # builds the transpiler ./tcl2cpp
make test       # for every test/input/tN.txt:
                #   tN.txt -> test/output/outputN.cpp -> test/printed/printedN.txt
make clean      # removes generated files
```
To transpile one file by hand:
```bash
./tcl2cpp < ../test/input/t1.txt > out.cpp
g++ out.cpp -o out && ./out
```
The transpiler reads Tcl from stdin and writes C++ to stdout. Errors go to stderr.

### Supported Tcl subset
| Tcl | Generated C++ |
|---|---|
| `set x 10;` (first time) | `int x = 10;` |
| `set y 2.02;` (first time) | `float y = 2.020000;` |
| `set z $x + $y / 2;` | `float z = x + y / 2;` |
| `set x $x + 1;` (already declared) | `x = x + 1;` |
| `puts "$x";` / `print "$x";` | `cout << x << "\n";` |
| `if (cond) { ... } else { ... }` | `if(cond){ ... } else{ ... }` |
| `while (cond) { ... }` | `while(cond){ ... }` |

- **Operators:** `+ - * /` with normal precedence, parentheses, and `< > == && ||` in conditions.
- **Output:** the generated code is wrapped in `#include <iostream>` / `int main(){ ... }` so that it compiles directly. It is indented 4 spaces per nesting level.

### Design
- **Lexer (`lexer.l`)**
  - Recognises keywords, integers, floats, identifiers, operators and punctuation.
  - `$` is skipped, so `$x` and `x` both become the identifier `x`.
  - Whitespace and newlines are ignored.
  - Token values are passed through `yylval` (`ival`, `fval`, `sval`).
- **Parser (`parser.y`)**
  - Expressions use the `expr` / `term` / `factor` layering, so precedence comes from the grammar itself.
  - Each rule builds the C++ text of its expression as a string.
- **Symbol table**
  - An array of `{name, is_float}` entries.
  - The first `set` of a variable prints a declaration (`int`/`float x = ...`). Later ones print a plain assignment (`x = ...`).
- **Type rule (b)**
  - A flag `expr_is_float` is set whenever an expression contains a float literal or a float variable.
  - That makes the result `float`. Otherwise it is `int`.
- **`if` / `while` / `else`**
  - An action placed in the middle of the rule prints `if(cond){` *before* the body is parsed.
  - An action at the end prints the closing `}`.
  - A `depth` counter handles indentation.

### Assumptions
1. Only `int` and `float` values are used (as stated in the assignment).
2. Every statement ends with `;`, because newlines are not treated as statement separators.
3. A variable's type is fixed when it is first `set`. A later float assigned to an `int` variable is truncated by C++.
4. A variable first `set` inside an `if`/`while` block is declared inside that block, so it is only visible there in the generated C++.
5. `puts`/`print` take a single variable in quotes, e.g. `puts "$x";`.
6. Float literals are printed with `%f` (e.g. `2.020000`). The value is the same, and the literal always contains a `.`, so C++ keeps it as floating point.
7. Conditions use `( )` as in the assignment's example, instead of Tcl's `{ }`.
8. On a syntax error, the transpiler prints `syntax error` to stderr and stops.
