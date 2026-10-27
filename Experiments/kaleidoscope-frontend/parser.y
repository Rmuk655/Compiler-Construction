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
  double num_double;
  int num_int;
  bool cond;
  VarType ty;
  std::string *str;
  ExprAST *expr;
  PrototypeAST *proto;
  FunctionAST *func;
  std::vector<ExprAST *> *exprs;
  std::vector<Param> *typed_params;
}

%define parse.error detailed

%token DEF EXTERN
%token <str> IDENTIFIER
%token <num_double> DOUBLE
%token <num_int> INTEGER
%token <cond> BOOLEAN
%token TYPE_DOUBLE TYPE_INT TYPE_BOOL

%type <ty> type
%type <expr> expr
%type <proto> prototype external
%type <func> definition
%type <exprs> args arglist
%type <typed_params> params

/* Free values that get discarded during error recovery. */
%destructor { delete $$; } <str> <expr> <proto> <func> <typed_params>
%destructor { for (ExprAST *E : *$$) delete E; delete $$; } <exprs>

/* Precedence, lowest first, all left-associative. Extends the old
   BinopPrecedence table: '<' '>' = 10, '+' '-' = 20, '*' '/' = 40. */
%left '<' '>'
%left '+' '-'
%left '*' '/'

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

/// prototype ::= type id '(' (type id)* ')'
prototype
  : type IDENTIFIER '(' params ')'
                          { $$ = new PrototypeAST($1, *$2, std::move(*$4));
                            delete $2; delete $4; }
  ;

/// type ::= 'int' | 'double' | 'bool'
type
  : TYPE_INT              { $$ = VarType::Int; }
  | TYPE_DOUBLE           { $$ = VarType::Double; }
  | TYPE_BOOL             { $$ = VarType::Bool; }
  ;

params
  : %empty                { $$ = new std::vector<Param>(); }
  | params type IDENTIFIER
                          { $1->push_back({$2, *$3}); delete $3; $$ = $1; }
  ;

/// expression
///   ::= numberexpr | identifierexpr | parenexpr | castexpr
///     | expression binop expression
expr
  : DOUBLE                { $$ = new NumberExprAST($1); }
  | INTEGER               { $$ = new NumberExprAST($1); }
  | BOOLEAN               { $$ = new NumberExprAST($1); }
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
  | type '(' expr ')'     { $$ = new CastExprAST($1, std::unique_ptr<ExprAST>($3)); }
  | expr '<' expr         { $$ = new BinaryExprAST('<', std::unique_ptr<ExprAST>($1),
                                                        std::unique_ptr<ExprAST>($3)); }
  | expr '>' expr         { $$ = new BinaryExprAST('>', std::unique_ptr<ExprAST>($1),
                                                        std::unique_ptr<ExprAST>($3)); }
  | expr '+' expr         { $$ = new BinaryExprAST('+', std::unique_ptr<ExprAST>($1),
                                                        std::unique_ptr<ExprAST>($3)); }
  | expr '-' expr         { $$ = new BinaryExprAST('-', std::unique_ptr<ExprAST>($1),
                                                        std::unique_ptr<ExprAST>($3)); }
  | expr '*' expr         { $$ = new BinaryExprAST('*', std::unique_ptr<ExprAST>($1),
                                                        std::unique_ptr<ExprAST>($3)); }
  | expr '/' expr         { $$ = new BinaryExprAST('/', std::unique_ptr<ExprAST>($1),
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