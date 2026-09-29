%token IF ELSE EXPR STMT

%%
stmt:
      IF expr stmt
    | IF expr stmt ELSE stmt
    | STMT
    ;

expr:
      EXPR
    ;
%%
int main(void) { return 0; }
int yyerror(const char *s) { return 0; }
int yylex(void) { return 0; }
