%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    int yylex(void);
    int yyerror(char *s);
    int expr_is_float;
    int depth = 1;
    void indent(){
        for(int i = 0; i < depth; i++){
            printf("    ");
        }
    }
    typedef struct {
        char *name;
        int is_float;
    } sym;
    sym sym_table[100];
    int sym_cnt = 0;
    void add(char *name, int is_float){
        sym_table[sym_cnt].name = strdup(name);
        sym_table[sym_cnt].is_float = is_float;
        sym_cnt++;
    }
    int lookup(char* name){
        for(int i = 0; i < sym_cnt; i++){
            if(strcmp(sym_table[i].name, name) == 0){
                return sym_table[i].is_float;
            }
        }
        return -1;
    }
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

%type <sval> expr
%type <sval> term
%type <sval> factor
%type <sval> condition

%%
program: statements
    ;

statements:
      statements statement
    |
    ;

statement: 
    SET IDENTIFIER expr ';'
    {
        indent();
        if(lookup($2) != -1){
            printf("%s = %s;\n", $2, $3);
        }
        else if (expr_is_float){
            printf("float %s = %s;\n", $2, $3);
            add($2, 1);
        }
        else{
            printf("int %s = %s;\n", $2, $3);
            add($2, 0);
        }
        expr_is_float = 0;
    }
    | PUTS '\"' IDENTIFIER '\"' ';' { indent(); printf("cout << %s << \"\\n\";\n", $3); }
    | PRINT '\"' IDENTIFIER '\"' ';' { indent(); printf("cout << %s << \"\\n\";\n", $3); }
    | IF '(' condition ')' { indent(); printf("if(%s){\n", $3); expr_is_float = 0; depth++;} 
    '{' statements '}' { depth--; indent(); printf("}\n"); } else_part
    | WHILE '(' condition ')' { indent(); printf("while(%s){\n", $3); expr_is_float = 0; depth++;}
    '{' statements '}' { depth--; indent(); printf("}\n"); }
    ;

else_part: ELSE { indent(); printf("else{\n"); depth++; }
    '{' statements '}'{ depth--; indent(); printf("}\n"); }
    |
    ;

expr: expr '+' term 
    { 
        $$ = malloc(strlen($1) + strlen($3) + 4);
        sprintf($$, "%s + %s", $1, $3);
    }
    | expr '-' term
    { 
        $$ = malloc(strlen($1) + strlen($3) + 4);
        sprintf($$, "%s - %s", $1, $3);
    }
    | term { $$ = $1; }
    ;

term: term '*' factor
    { 
        $$ = malloc(strlen($1) + strlen($3) + 4);
        sprintf($$, "%s * %s", $1, $3);
    }
    | term '/' factor
    { 
        $$ = malloc(strlen($1) + strlen($3) + 4);
        sprintf($$, "%s / %s", $1, $3);
    }
    | factor { $$ = $1; }
    ;   

factor: INTEGER { $$ = malloc(20); sprintf($$, "%d", $1); }
    | FLOAT { expr_is_float = 1; $$ = malloc(30); sprintf($$, "%f", $1); }
    | IDENTIFIER 
    {   
        $$ = strdup($1); 
        if (lookup($1) == 1)
            expr_is_float = 1;
    }
    | '(' expr ')' { $$ = malloc(strlen($2) + 3); sprintf($$, "(%s)", $2); }
    ;

condition: expr RELOP expr 
    {
        $$ = malloc(strlen($1) + strlen($2) + strlen($3) + 3);
        sprintf($$, "%s %s %s", $1, $2, $3);
    }
    | condition RELOP expr
    {
        $$ = malloc(strlen($1) + strlen($2) + strlen($3) + 3);
        sprintf($$, "%s %s %s", $1, $2, $3);
    }
    ;
%%

int yyerror(char *s){
    fprintf(stderr, "%s\n", s);
    return 0;
}

int main(){
    printf("#include <iostream>\n\nusing namespace std;\n\nint main(){\n");
    yyparse();
    printf("    return 0;\n}\n");
    return 0;
}