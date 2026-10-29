%{
    #include "parser.tab.h"
    #include <stdlib.h>
    #include <errno.h>
    #include <limits.h>
    int yyerror(char *s);
%}

%%
[0-9]+ {
    errno = 0;
    long v = strtol(yytext, NULL, 10);
    if (errno == ERANGE || v > INT_MAX) { yyerror("integer too large"); return BAD; }
    yylval = (int) v;
    return INTEGER;
}
[-+*()\n] { return *yytext; }
[ \t] ; /* skip whitespace */
. { yyerror("invalid character"); } /**/
%%

int yywrap(void){
    return 1;
}