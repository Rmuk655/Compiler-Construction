%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int yyerror(char *s);
#include "parser.tab.h"
%}

NUMBER [0-9]+
FLOAT {NUMBER}"."{NUMBER}
ALPHABET [a-zA-Z]
ALPHANUMERIC ({ALPHABET}|{NUMBER})
IDENTIFIER {ALPHABET}({ALPHANUMERIC}|_)*
/*+, *, / have special meanings in regex and hence must be escaped using \
/ means trailing context 
OP (\+|\*|/|=|-)*/
OP [+\*=/-]
RELOP (>|<|==|&&|\|\|)
L_PAREN "\("
R_PAREN "\)"
L_CURL "\{"
R_CURL "\}"
IF "if"
ELSE "else"
WHILE "while"
PUTS "puts"
SET "set"
PRINT "print"

%%
{IF}         { return IF; }
{ELSE}       { return ELSE; }
{WHILE}      { return WHILE; }
{PUTS}       { return PUTS; }
{SET}        { return SET; }
{PRINT}      { return PRINT; }
{NUMBER}     { yylval.ival = atoi(yytext); return INTEGER; }
{FLOAT}      { yylval.fval = atof(yytext); return FLOAT; }
{IDENTIFIER} { yylval.sval = strdup(yytext); return IDENTIFIER; }
{OP}         { return *yytext; }
{RELOP}      { yylval.sval = strdup(yytext); return RELOP; }
{L_PAREN}    { return *yytext; }
{R_PAREN}    { return *yytext; }
{L_CURL}     { return *yytext; }
{R_CURL}     { return *yytext; }
";"          { return *yytext; }
"\""         { return *yytext; }
"$"          ;
[ \t\r]+     ;
[\n]         ;
.            { yyerror("invalid character"); }
%%

int yywrap(){
    return 1;
}