%{
//===----------------------------------------------------------------------===//
// Lexer
//===----------------------------------------------------------------------===//
// Replaces the hand-written gettok(). Keywords and literals become named
// tokens declared in parser.y; any other character is returned as its own
// ASCII value, just like before.

#include "ast.h"
#include "parser.tab.h"
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

{ALPHA}({ALPHA}|{DIGIT})*   { yylval.str = new std::string(yytext);
                              return IDENTIFIER; }

({DIGIT}|".")+              { yylval.num = strtod(yytext, nullptr);
                              return NUMBER; }

.                           { return yytext[0]; }

%%