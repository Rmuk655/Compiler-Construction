%{
    #include "parser.tab.h"
    #include <stdlib.h>
    int yyerror(char *s);
%}

MINUS   -
%%
{MINUS}[0-9]+ { yylval = atoi(yytext); return INTEGER; }
[0-9]+ { yylval = atoi(yytext); return INTEGER; }
[+*()\n] { return *yytext; }
[ \t] ; /* skip whitespace */
. { yyerror("invalid character"); } /**/
%%

int yywrap(void){
    return 1;
}