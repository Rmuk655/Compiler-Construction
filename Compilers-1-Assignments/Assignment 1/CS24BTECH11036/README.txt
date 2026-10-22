Lexer for the "pp" toy language (CS3423 Compilers, Assignment 1)

Build:
    flex lexer.l
    gcc lex.yy.c -o lexer

Run (reads standard input, prints one token per line):
    ./lexer < test_cases/I1.txt

Token classes: LABEL (pp<number>:), KEYWORD (do, null, repeat, in case that,
otherwise, jump to), DATATYPE (integer, character, string), IDENTIFIER, NUMBER,
STRING (double-quoted, with backslash escapes), OPERATOR, RELOP, LOGICAL,
SEPARATOR (;), SCOPE_OPEN ([), SCOPE_CLOSE (]). Whitespace and // comments are
skipped; unrecognised characters print ERROR!.

Tests: each test_cases/<name>.txt has an expected token stream in
test_cases/<name>.expected. I3 has two accepted outputs (I3.expected and
I3_alternate.expected) because the specification allows [ ] either way.
