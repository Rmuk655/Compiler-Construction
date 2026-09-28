%{
#include<stdio.h>
#include<stdlib.h> 
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

%%
"if"         { printf("%s ", yytext); }
"else"       { printf("%s ", yytext); }
"while"      { printf("%s ", yytext); }
"puts"       { printf("%s ", yytext); }
"set"        { printf("%s ", yytext); }
"print"      { printf("%s ", yytext); }
{NUMBER}     { printf("%s", yytext); }
{FLOAT}      { printf("%s", yytext); }
{IDENTIFIER} { printf("%s ", yytext); }
{OP}         { printf("%s ", yytext); }
{RELOP}      { printf("%s ", yytext); }
{L_PAREN}    { printf("%s", yytext); }
{R_PAREN}    { printf("%s\n", yytext); }
{L_CURL}     { printf("%s\n", yytext); }
{R_CURL}     { printf("%s\n", yytext); }
";"          { printf("%s\n", yytext); }
"\""         { printf("%s\n", yytext); }
"$"          ;
[ \t\r]+     ;
[\n]         ;
.   ;
%%

int yywrap(){
    return 1;
}

int main(){
    yylex();
    return 1;
}