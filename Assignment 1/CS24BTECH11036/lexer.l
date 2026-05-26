%{
#include <stdio.h>
%}

PP "pp"
COLON [":"]
DIGIT  [0-9]
LETTER [a-zA-Z]
NUMBER {DIGIT}+
LABEL  "pp"{NUMBER}:
UNDERSCORE  "_"
SCOPE_OPEN  "["
SCOPE_CLOSE "]"
SEPARATOR   ";"
SPECIAL_SYMBOLS "@"|"#"|"*"|"-"|"+"|"/"|"_"|":"|"\""
SPECIAL ["@", "#", "*", "-", "+", "_", ":", "\"]
SPECIAL_EX ["@", "#", "*", "-", "+", "/", "_", "\"]
DATATYPE    ["integer", "character", "string"]
IDENTIFIER  ({SPECIAL_SYMBOLS}|{LETTER})({SPECIAL_SYMBOLS}|{LETTER}|{DIGIT})*
KEYWORD     ["do", "null", "repeat", "in case that", "otherwise", "jump to"]
UNARY_OP ["_"]
RELOP    ["gt", "lt", "gteq", "lteq"]
LOGICAL  ["and", "or"]
WHITESPACE [" ", "\n", "\t"]
BLANK [" "]
SPACE    [" ", "\t"]
STRING   ({LETTER}|{SPECIAL_SYMBOLS})({LETTER}|{WHITESPACE}|{SPECIAL_SYMBOLS})+
ALL ({DIGIT}|{LETTER}|{SPECIAL_SYMBOLS}|{SCOPE_OPEN}|{SCOPE_CLOSE}|{WHITESPACE})+
ALLCOM ({DIGIT}|{LETTER}|{SPECIAL_SYMBOLS}|{SCOPE_OPEN}|{SCOPE_CLOSE}|{SPACE})*
%%
" "|"\n"|"\t"|{BLANK}+                                     ;
"//"{ALLCOM}"\n"                                           ;
"\""{ALL}"\""                                              { printf("STRING: %s\n", yytext); }
"pp"{NUMBER}":"|" pp"{NUMBER}":"                           { printf("LABEL: %s\n", yytext); }
"do"|"null"|"repeat"|"in case that"|"otherwise"|"jump to"  { printf("KEYWORD: %s\n", yytext); }
{NUMBER}                                                   { printf("NUMBER: %s\n", yytext); }
"gt"|"lt"|"gteq"|"lteq"         { printf("RELOP: %s\n", yytext); }
"and"|"or"       { printf("LOGICAL: %s\n", yytext); }
"+"|"-"|"*"|"/"|"="|"%%"|"_"|"gt"|"lt"|"gteq"|"lteq"|"and"|"or" { printf("OPERATOR: %s\n", yytext); }
"integer"|"character"|"string"                             { printf("DATATYPE: %s\n", yytext); }
{IDENTIFIER}                                               { printf("IDENTIFIER: %s\n", yytext); }
{SEPARATOR}                                                { printf("SEPARATOR: %s\n", yytext); }
{SCOPE_OPEN}                                               { printf("SCOPE_OPEN: %s\n", yytext); }
{SCOPE_CLOSE}                                              { printf("SCOPE_CLOSE: %s\n", yytext); } 
.                                                          { printf("ERROR!\n"); }
%%
int main(){
	yylex();
	return 0;
}

int yywrap(){
	return 1;
}
