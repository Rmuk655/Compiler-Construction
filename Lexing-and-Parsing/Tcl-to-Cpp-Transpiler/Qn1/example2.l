%%
[0-9]+       { printf("NUM\n"); }
[0-9]{3}     { printf("THREE_DIGITS\n"); }
%%
int main(void) { yylex(); return 0; }
int yywrap(void) { return 1; }
