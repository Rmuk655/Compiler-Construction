%{
#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;
extern int yylex(void);
void yyerror(const char *s);

FILE *tokens_out;
FILE *parsed_out;

static void write_output_files(void) {
    fprintf(tokens_out, "# tokens output\n");
    fprintf(parsed_out, "# parsed output\n");
}
%}

%%

program:
    /* TODO: write grammar here */
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <input-file>\n", argv[0]);
        return 1;
    }

    FILE *input = fopen(argv[1], "r");
    if (!input) {
        perror("fopen input");
        return 1;
    }

    tokens_out = fopen("output/tokens.txt", "w");
    parsed_out = fopen("output/parsed.txt", "w");
    if (!tokens_out || !parsed_out) {
        perror("fopen output");
        fclose(input);
        return 1;
    }

    write_output_files();

    yyin = input;
    yyparse();

    fclose(input);
    fclose(tokens_out);
    fclose(parsed_out);
    return 0;
}
