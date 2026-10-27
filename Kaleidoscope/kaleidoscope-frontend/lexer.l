%{
//===----------------------------------------------------------------------===//
// Lexer
//===----------------------------------------------------------------------===//
// Replaces the hand-written gettok(). Keywords and literals become named
// tokens declared in parser.y; any other character is returned as its own
// ASCII value, just like before.

#include "ast.h"
#include "parser.tab.h"
#include <cerrno>
#include <climits>
#include <cstdio>
#include <cstdlib>
#include <string>
%}

%option noyywrap nounput noinput

DIGIT   [0-9]
ALPHA   [a-zA-Z]

%%

[ \t\r\n]+                  { /* skip whitespace */ }
"#".*                       { /* comment until end of line */ }

"def"                       { return DEF; }
"extern"                    { return EXTERN; }
"int"                       { return TYPE_INT; }
"bool"                      { return TYPE_BOOL; }
"double"                    { return TYPE_DOUBLE; }

"true"                      { yylval.cond = true; return BOOLEAN; }
"false"                     { yylval.cond = false; return BOOLEAN; }

{ALPHA}({ALPHA}|{DIGIT})*   { yylval.str = new std::string(yytext);
                              return IDENTIFIER; }

{DIGIT}+"."{DIGIT}*|"."{DIGIT}+ {
                              yylval.num_double = strtod(yytext, nullptr);
                              return DOUBLE; }

{DIGIT}+                    { errno = 0;
                              long V = strtol(yytext, nullptr, 10);
                              if (errno == ERANGE || V > INT_MAX) {
                                // Out of range for i32: report it and let the
                                // parser's error recovery skip the statement.
                                fprintf(stderr, "Error: integer literal %s "
                                        "does not fit in int\n", yytext);
                                return YYerror;
                              }
                              yylval.num_int = (int)V;
                              return INTEGER; }

.                           { return yytext[0]; }

%%