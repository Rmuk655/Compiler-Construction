%{
//===----------------------------------------------------------------------===//
// Parser 
//===----------------------------------------------------------------------===//
// Replaces the recursive-descent parser and the operator-precedence
// ParseBinOpRHS(). Operator precedence and associativity are declared with
// %left below instead of the BinopPrecedence table, and each rule builds the
// same AST nodes the hand-written parser built.

#include "ast.h"
#include <cstdio>
#include <memory>
#include <string>
#include <vector>

int yylex();
void yyerror(const char *S);
%}

/* Make the AST types visible in the generated parser.tab.h, which the
   lexer includes for the token numbers and yylval. */
%code requires {
#include "ast.h"
#include <string>
#include <vector>
}

/* Semantic values. A %union can only hold trivially copyable types, so
   nodes travel up the parse stack as raw pointers and are wrapped back into
   std::unique_ptr as soon as they are attached to a parent node. */
%union {
  double num;
  std::string *str;
  ExprAST *expr;
  PrototypeAST *proto;
  FunctionAST *func;
  std::vector<ExprAST *> *exprs;
  std::vector<std::string> *names;
}

%define parse.error detailed

%token DEF EXTERN
%token <str> IDENTIFIER
%token <num> NUMBER

%type <expr> expr
%type <proto> prototype external
%type <func> definition
%type <exprs> args arglist
%type <names> params

/* Free values that get discarded during error recovery. */
%destructor { delete $$; } <str> <expr> <proto> <func> <names>
%destructor { for (ExprAST *E : *$$) delete E; delete $$; } <exprs>

/* Precedence, lowest first. Matches the old BinopPrecedence table:
   '<' = 10, '+' '-' = 20, '*' = 40, all left-associative. */
%left '<'
%left '+' '-'
%left '*'

/* "x (" is always a call, never variable x followed by a parenthesised
   top-level expression (same choice the hand-written parser made). */
%precedence VARIABLE
%precedence '('

%%

/// top ::= definition | external | expression | ';'
program
  : %empty
  | program top           { fprintf(stderr, "ready> "); }
  ;

top
  : definition            { HandleDefinition(std::unique_ptr<FunctionAST>($1)); }
  | external              { HandleExtern(std::unique_ptr<PrototypeAST>($1)); }
  | expr                  { HandleTopLevelExpression(std::unique_ptr<ExprAST>($1)); }
  | ';'                   { /* ignore top-level semicolons */ }
  | error ';'             { yyerrok; /* skip to the next ';' and carry on */ }
  ;

/// definition ::= 'def' prototype expression
definition
  : DEF prototype expr    { $$ = new FunctionAST(std::unique_ptr<PrototypeAST>($2),
                                                 std::unique_ptr<ExprAST>($3)); }
  ;

/// external ::= 'extern' prototype
external
  : EXTERN prototype      { $$ = $2; }
  ;

/// prototype ::= id '(' id* ')'
prototype
  : IDENTIFIER '(' params ')'
                          { $$ = new PrototypeAST(*$1, std::move(*$3));
                            delete $1; delete $3; }
  ;

params
  : %empty                { $$ = new std::vector<std::string>(); }
  | params IDENTIFIER     { $1->push_back(*$2); delete $2; $$ = $1; }
  ;

/// expression
///   ::= numberexpr | identifierexpr | parenexpr | expression binop expression
expr
  : NUMBER                { $$ = new NumberExprAST($1); }
  | IDENTIFIER %prec VARIABLE
                          { $$ = new VariableExprAST(*$1); delete $1; }
  | IDENTIFIER '(' args ')'
                          { std::vector<std::unique_ptr<ExprAST>> Args;
                            for (ExprAST *E : *$3)
                              Args.emplace_back(E);
                            delete $3;
                            $$ = new CallExprAST(*$1, std::move(Args));
                            delete $1; }
  | '(' expr ')'          { $$ = $2; }
  | expr '<' expr         { $$ = new BinaryExprAST('<', std::unique_ptr<ExprAST>($1),
                                                        std::unique_ptr<ExprAST>($3)); }
  | expr '+' expr         { $$ = new BinaryExprAST('+', std::unique_ptr<ExprAST>($1),
                                                        std::unique_ptr<ExprAST>($3)); }
  | expr '-' expr         { $$ = new BinaryExprAST('-', std::unique_ptr<ExprAST>($1),
                                                        std::unique_ptr<ExprAST>($3)); }
  | expr '*' expr         { $$ = new BinaryExprAST('*', std::unique_ptr<ExprAST>($1),
                                                        std::unique_ptr<ExprAST>($3)); }
  ;

/// args ::= (expression (',' expression)*)?
args
  : %empty                { $$ = new std::vector<ExprAST *>(); }
  | arglist               { $$ = $1; }
  ;

arglist
  : expr                  { $$ = new std::vector<ExprAST *>(); $$->push_back($1); }
  | arglist ',' expr      { $1->push_back($3); $$ = $1; }
  ;

%%

void yyerror(const char *S) { fprintf(stderr, "Error: %s\n", S); }