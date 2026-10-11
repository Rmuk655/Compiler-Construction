%option noyywrap
%{
#include <stdio.h>
#include "parser.tab.h"

extern FILE *tokens_out;
%}

%%

[ \t\r]+    ;
\n           ;
.            ;

%%
