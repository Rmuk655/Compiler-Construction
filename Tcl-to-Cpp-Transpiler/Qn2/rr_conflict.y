%token ID

%%
stat:
      A
    | B
    ;

A:
      ID
    ;

B:
      ID
    ;
%%
int main(void) { return 0; }
int yyerror(const char *s) { return 0; }
int yylex(void) { return 0; }
