%option noyywrap
%{
    #include <stdio.h>
    #include "parser.tab.h"
%}

DIGIT [0-9]
NUMBER {DIGIT}+

%%
"AVIATE"[ \t]+    { return TOK_AVIATE; }
{NUMBER}          { yylval.int_val = atoi(yytext); return TOK_NUMBER; }
"BEE"             { return TOK_BEE; }
"BLACK"           { return TOK_BLACK; }
"BARRY"           { return TOK_BARRY; }
"ROTATE"          { return TOK_ROTATE; }
"ROTAT"           { return TOK_ROTAT; }
"YELLOW"          { return TOK_YELLOW; }
[ \t\r\n]+        ;
.                 ;
%%

char* runtime_input;
bool files_ok();
int main(int argc, char*argv[]){
    if(argc < 2){
        fprintf(stderr, "usage: %s <file.bee> [input]\n", argv[0]);
        return 1;
    }
    yyin = fopen(argv[1], "r");
    if(!yyin){
        perror(argv[1]);
        return 1;
    }
    if(!files_ok()) return 1;
    runtime_input = argc > 2 ? argv[2] : NULL;
    int result = yyparse();
    fclose(yyin);
    return result;
}