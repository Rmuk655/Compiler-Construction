# Lex and Yacc
## Lab Session 3

Implement a simplified lexer and parser for a minimal programming language. The program should parse basic integer declarations, assignment statements, print statements, and simple if-else conditionals while printing recognized tokens and parsed statements.

---

## 1. Lexical Analyzer

The lexical analyzer must recognize all the tokens categorized below.

### 1.1 Identifier
- Can contain letters (uppercase and lowercase), numbers, and underscores.
- The first character cannot be a number.
- Examples: `demo`, `Demo`, `d3m0`, `_demo_`

### 1.2 Constant
- Integer constants
- Examples: `122`, `0`, `42`

### 1.3 Punctuation
- `{ } ( ) ; =`

### 1.4 Reserved Words
- `if`
- `else`
- `print`

### 1.5 Type
- `int`

### 1.6 Arithmetic Operators
- `+ - *`

### 1.7 Comparison Operators
- `< > ==`

### 1.8 Single-Line Comment
- `#` indicates that everything to the right of the hashtag is a comment.

---

## 2. Syntax Analyzer

The program consists of the following statement types. Statements are separated by semicolons. Spaces, tabs, and newlines between tokens are ignored.

- Variable Declaration
- Assignment Statement
- Conditional Statement
- Print Statement

### 2.1 Variable Declaration
```c
int a;              // declares an integer a
int a = 3, b, c;    // declares integers a, b, c
```

### 2.2 Assignment Statement
```c
a = 2 * (a + b);    // RHS is an expression
```

### 2.3 Expression
Expressions contain variables, constants, arithmetic operators, and grouping using parentheses `()`.

> Note: `expr` is any expression as defined previously.

### 2.4 Conditional Statement
A conditional block contains an `if` statement and an optional `else` block.

```c
if (predicate) { body } else { body }
```

Predicate: a condition consisting of expressions separated by comparison operators such as `<`, `>`, and `==`.

### 2.5 Print Statement
```c
print(a);    // prints the value of an integer
```

---

## 3. Logging

The input file will be a `.txt` file. The parser should take the input file name as the first command-line argument.

### 3.1 Token Logging
During lexical analysis, every token should be printed along with its category. Generate a file named `tokens.txt` whose lines have the format:

```text
LINE-NUM : CATEGORY : TOKEN
```

If a token has multiple uses, print both uses separated by ` : ` as shown below:

```text
4 : Punctuation : Access Operator : [
9 : Punctuation : Comparison Operator : <
```

### 3.2 Statement Logging
During syntax analysis, every statement should be categorized and printed in a file named `parsed.txt` with each line having the format:

```text
LINE-NUM : CATEGORY
```

> Note: Nested statements must also be printed.

`LINE-NUM` is the line number of the starting line of the statement in the input file. For example, in a conditional statement or function declaration that spans multiple lines, use the line number from the first line only.

---

## Test Program

```c
int a = 5;
int b = 2;
if (a > 2) {
   b = b * a;
} else {
   b = 0;
}
print(b);
```

## Token Log

```text
1 : Type : int
1 : Identifier : a
1 : Punctuation : =
1 : Constant : 5
2 : Type : int
2 : Identifier : b
3 : Reserved Word : if
3 : Punctuation : (
3 : Identifier : a
3 : Comparison Operator : >
3 : Constant : 2
3 : Punctuation : )
...
```

## Statement Log

```text
1 : Variable Declaration
2 : Variable Declaration
3 : Conditional Statement
4 : Assignment Statement
6 : Assignment Statement
9 : Print Statement
```
