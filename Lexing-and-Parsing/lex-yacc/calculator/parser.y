%{
    #include <stdio.h>
    #include <stdlib.h>
    int yylex(void);
    int yyerror(char *s);
%}

%token INTEGER
%token BAD

%%
program: program expr '\n' { printf("%d\n", $2); }
    | program error '\n' { yyerrok; }
    | program '\n'  { exit(0); }
    |
    ;

expr: expr '+' term { $$ = $1 + $3; }
    | expr '-' term { $$ = $1 - $3; }
    | term { $$ = $1; }

term: term '*' factor { $$ = $1 * $3; }
    | factor { $$ = $1; }

factor: INTEGER { $$ = $1; }
    | '(' expr ')'      { $$ = $2; }
    | '-' factor        { $$ = -$2; }
    ;

%%

int yyerror(char *s) { 
    fprintf(stderr, "%s\n", s);
    return 0;
}

int main(void){
    yyparse();
    return 0;
}