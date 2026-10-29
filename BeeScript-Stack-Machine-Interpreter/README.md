# BeeScript Stack Machine Interpreter

An interpreter for BeeScript, a small stack-based language, built with flex and bison.

## Files

- `lexer.l`: flex lexer. Recognises the instructions and numbers, ignores whitespace and any unknown text. Also holds `main`.
- `parser.y`: bison grammar. Each instruction runs its stack action directly in the grammar rule.
- `script.txt`: the Bee Movie script used by `AVIATE`. It must be in the directory the program runs from.
- `tests/test-cases/`: sample `.bee` programs.
- `tests/expected/`: expected output for each sample.

## Build

```
make              # or: cmake -S . -B build && cmake --build build
```

This puts the interpreter at `build/compiler`. By hand:

```
bison -d parser.y
flex lexer.l
g++ -o compiler lex.yy.c parser.tab.c
```

## Run

```
./compiler <file.bee> [input]
```

- `file.bee` is the BeeScript program.
- `input` is one string. `YELLOW` takes its characters from it, one per call.
- Output is written to `output.txt` in the current directory.

Example:

```
./compiler tests/test-cases/example1.bee            # output.txt: Hello
./compiler tests/test-cases/example2.bee black      # output.txt: bkcal
```

## Tests

```
make test         # or: ctest --test-dir build
```

`runtests.sh` runs every `tests/test-cases/*.bee` in a temporary directory and compares `output.txt` with `tests/expected/<name>.expected`. If `tests/inputs/<name>.input` exists, its contents are passed as the input argument for `YELLOW`. There are 31 checks: 20 cases covering each instruction, stack underflow in `BARRY`, negative results, rotation order, input via `YELLOW` and ignored text, plus 9 error cases and 2 command-line failures (`err_*`). Expected outputs were derived from the spec, not copied from the program's output.

## Instructions

The stack is a `deque<int>`, so both ends are reachable.

| Instruction | Action |
|---|---|
| `AVIATE n` | Push the ASCII code of the nth character (1-based) of `script.txt`. |
| `BEE` | Duplicate the top value. |
| `BLACK` | Pop the top value and print it as a character. If it is 0 or negative, print the number itself. |
| `BARRY` | Pop A, then B, and push B - A. Does nothing if the stack has fewer than 2 values. |
| `ROTATE` | Remove the bottom value and push it on top. |
| `ROTAT` | Pop the top value and push it at the bottom. |
| `YELLOW` | Push the ASCII code of the next character of the `input` argument. |

Any other text in the program is ignored.

## Error handling

Bad instructions are skipped, a message goes to stderr, and `output.txt` only holds program output:

- `BEE`, `BLACK`, `ROTATE` or `ROTAT` on an empty stack.
- `AVIATE n` with n below 1 or past the end of `script.txt`. Later `AVIATE`s still work.
- `YELLOW` when the input argument is missing or used up.
- A push onto a full stack (100 values).

A missing program argument, an unreadable program file, or an unreadable `script.txt` stops the run with exit code 1 and a message.

## Assumptions

- `AVIATE n` rewinds `script.txt` after each use, so any n can follow any other.
- `BLACK` of a value above 127 writes the low byte, because the language does not define it.
