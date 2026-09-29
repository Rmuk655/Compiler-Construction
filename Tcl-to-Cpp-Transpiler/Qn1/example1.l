%%
[a-z]+      { printf("WORD\n"); }
"end"       { printf("END\n"); }
%%
int main(void) { yylex(); return 0; }
int yywrap(void) { return 1; }
