%option noyywrap
%{
#include <stdio.h>
#include "parser.tab.h"

extern FILE *tokens_out;
%}

IDEN [a-zA-Z_][a-zA-Z0-9_]*
INT [0-9]+
%%
"if" { fprintf(tokens_out, "Reserved Word: if\n"); }
"else" { fprintf(tokens_out, "Reserved Word: else\n"); }
"print" { fprintf(tokens_out, "Reserved Word: print\n"); }
"int" { fprintf(tokens_out, "Type: int\n"); }
"+" { fprintf(tokens_out, "Arithmetic Operator: +\n"); }
"-" { fprintf(tokens_out, "Arithmetic Operator: -\n"); }
"*" { fprintf(tokens_out, "Arithmetic Operator: *\n"); }
">" { fprintf(tokens_out, "Comparison Operator: >\n"); }
"<" { fprintf(tokens_out, "Comparison Operator: <\n"); }
"==" { fprintf(tokens_out, "Comparison Operator: ==\n"); }
"(" { fprintf(tokens_out, "Punctuation: Left Parenthesis\n"); }
")" { fprintf(tokens_out, "Punctuation: Right Parenthesis\n"); }
"{" { fprintf(tokens_out, "Punctuation: Left Brace\n"); }
"}" { fprintf(tokens_out, "Punctuation: Right Brace\n"); }
";" { fprintf(tokens_out, "Punctuation: ;\n"); }
"=" { fprintf(tokens_out, "Punctuation: =\n"); }
"#".* ;
[0-9]+{IDEN} { fprintf(tokens_out, "Invalid identifier: %s\n", yytext); }
{IDEN} { fprintf(tokens_out, "IDENTIFIER: %s\n", yytext); }
{INT} { fprintf(tokens_out, "INTEGER: %s\n", yytext); }
[ \t\r]+    ;
\n           ;
.            ;

%%
