%{
    #define _GNU_SOURCE
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    int yylex(void);
    int yyerror(char *s);

    char *names[512];   /* declared variables */
    int types[512];     /* 0 = int, 1 = float */
    int count = 0;
    int depth = 1;      /* indentation level */
    int isfloat = 0;    /* does the current expression use a float */
%}

%union {
    int ival;
    float fval;
    char* sval;
}

%token IF ELSE WHILE PUTS SET PRINT

%token <ival> INTEGER
%token <fval> FLOAT
%token <sval> IDENTIFIER RELOP

%type <sval> condition expr term factor

%%
program: statements
    |
    ;

statements:
      statements statement
    | statement
    ;

statement: SET IDENTIFIER { isfloat = 0; } expr ';' {
            int i = 0;
            while (i < count && strcmp(names[i], $2)) i++;
            printf("%*s", depth * 4, "");
            if (i == count){
                names[count] = $2;
                types[count++] = isfloat;
                printf("%s ", isfloat ? "float" : "int");
            }
            printf("%s = %s;\n", $2, $4);
        }
    | PUTS '"' IDENTIFIER '"' ';' { printf("%*scout<<%s<<\"\\n\";\n", depth * 4, "", $3); }
    | PRINT '"' IDENTIFIER '"' ';' { printf("%*scout<<%s<<\"\\n\";\n", depth * 4, "", $3); }
    | IF '(' condition ')' { printf("%*sif(%s){\n", depth * 4, "", $3); depth++; }
      block { depth--; printf("%*s}\n", depth * 4, ""); }
      else_part
    | WHILE '(' condition ')' { printf("%*swhile(%s){\n", depth * 4, "", $3); depth++; }
      block { depth--; printf("%*s}\n", depth * 4, ""); }
    ;

block: '{' statements '}'
    | '{' '}'
    ;

else_part: ELSE { printf("%*selse{\n", depth * 4, ""); depth++; }
      block { depth--; printf("%*s}\n", depth * 4, ""); }
    |
    ;

condition: condition RELOP expr { asprintf(&$$, "%s %s %s", $1, $2, $3); }
    | expr RELOP expr { asprintf(&$$, "%s %s %s", $1, $2, $3); }
    ;

expr: expr '+' term { asprintf(&$$, "%s + %s", $1, $3); }
    | expr '-' term { asprintf(&$$, "%s - %s", $1, $3); }
    | term { $$ = $1; }
    ;

term: term '*' factor { asprintf(&$$, "%s * %s", $1, $3); }
    | term '/' factor { asprintf(&$$, "%s / %s", $1, $3); }
    | factor { $$ = $1; }
    ;

factor: INTEGER { asprintf(&$$, "%d", $1); }
    | FLOAT { asprintf(&$$, "%g", $1); if (!strchr($$, '.')) asprintf(&$$, "%s.0", $$); isfloat = 1; }
    | IDENTIFIER {
            int i = 0;
            while (i < count && strcmp(names[i], $1)) i++;
            if (i < count && types[i]) isfloat = 1;
            $$ = $1;
        }
    | '(' expr ')' { asprintf(&$$, "(%s)", $2); }
    ;
%%

int yyerror(char *s){
    fprintf(stderr, "%s\n", s);
    return 0;
}

int main(){
    printf("#include <iostream>\nusing namespace std;\n\nint main(){\n");
    yyparse();
    printf("    return 0;\n}\n");
    return 0;
}
