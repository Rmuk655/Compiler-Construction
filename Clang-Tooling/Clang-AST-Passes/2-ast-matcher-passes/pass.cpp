#include "clang/ASTMatchers/ASTMatchFinder.h"
#include "clang/ASTMatchers/ASTMatchers.h"
#include "clang/Tooling/CommonOptionsParser.h"
#include "clang/Tooling/Tooling.h"
#include "llvm/Support/CommandLine.h"
#include "clang/Tooling/Inclusions/HeaderIncludes.h"
#include "clang/Tooling/Core/Replacement.h"

#include "clang/Frontend/CompilerInstance.h"
#include "clang/Frontend/FrontendAction.h"
#include "clang/Lex/Preprocessor.h"
#include "clang/Lex/PreprocessorOptions.h"
#include "clang/Lex/HeaderSearch.h"
#include "clang/Basic/FileManager.h"

#include <set>
#include <vector>

using namespace std;
using namespace clang;
using namespace clang::tooling;
using namespace clang::ast_matchers;
using namespace llvm;

static llvm::cl::OptionCategory Simple_Pass("Simple_Pass options");

// write matchers here..
// 1. Find assignments that occur inside conditional expressions and could indicate accidental use of “=” instead of “ ==”
StatementMatcher ifcondassgn = ifStmt(hasCondition(ignoringParenImpCasts(binaryOperator(hasOperatorName("=")).bind("assignment"))));
StatementMatcher forcondassgn = forStmt(hasCondition(ignoringParenImpCasts(binaryOperator(hasOperatorName("=")).bind("assignment"))));
StatementMatcher whilecondassgn = whileStmt(hasCondition(ignoringParenImpCasts(binaryOperator(hasOperatorName("=")).bind("assignment"))));
StatementMatcher docondassgn = doStmt(hasCondition(ignoringParenImpCasts(binaryOperator(hasOperatorName("=")).bind("assignment"))));
StatementMatcher condassgn = conditionalOperator(hasCondition(ignoringParenImpCasts(binaryOperator(hasOperatorName("=")).bind("assignment"))));
StatementMatcher asscondcheck = stmt(anyOf(ifcondassgn, forcondassgn, whilecondassgn, docondassgn, condassgn), isExpansionInMainFile());
// 2. Detect for, while, and do-while loops whose bodies are empty compound statements.
StatementMatcher for_empty = forStmt(hasBody(compoundStmt(statementCountIs(0))), isExpansionInMainFile()).bind("loop");
StatementMatcher while_empty = whileStmt(hasBody(compoundStmt(statementCountIs(0))), isExpansionInMainFile()).bind("loop");
StatementMatcher do_while_empty = doStmt(hasBody(compoundStmt(statementCountIs(0))), isExpansionInMainFile()).bind("loop");
// 3. Identify local variables that are declared but never referenced elsewhere in their enclosing function.
DeclarationMatcher decls = varDecl(hasLocalStorage(), unless(parmVarDecl()), isExpansionInMainFile()).bind("var");
StatementMatcher refs = declRefExpr(to(varDecl(hasLocalStorage()))).bind("ref");

class Simple_Pass_Handler : public MatchFinder::MatchCallback
{
public:
  // DeclaredVars is a vector so the unused variables are reported in source order
  // (a set of pointers would give a different order on every run).
  vector<const VarDecl *> DeclaredVars;
  set<const VarDecl *> ReferencedVars;
  virtual void run(const MatchFinder::MatchResult &Result) override
  {
    if (auto *A = Result.Nodes.getNodeAs<BinaryOperator>("assignment"))
    {
      outs() << A->getBeginLoc().printToString(*Result.SourceManager) << "\n";
    }
    else if (auto *L = Result.Nodes.getNodeAs<Stmt>("loop"))
    {
      outs() << L->getBeginLoc().printToString(*Result.SourceManager) << "\n";
    }
    else if (auto *V = Result.Nodes.getNodeAs<VarDecl>("var"))
    {
      DeclaredVars.push_back(V);
    }
    else if (auto *R = Result.Nodes.getNodeAs<DeclRefExpr>("ref"))
    {
      ReferencedVars.insert(cast<VarDecl>(R->getDecl()));
    }
  }
};

int main(int argc, const char **argv)
{

  auto ExpectedParser = CommonOptionsParser::create(argc, argv, Simple_Pass);
  if (!ExpectedParser)
  {
    // Fail gracefully for unsupported options.
    errs() << ExpectedParser.takeError();
    return 1;
  }
  CommonOptionsParser &OptionsParser = ExpectedParser.get();
  ClangTool Tool(OptionsParser.getCompilations(),
                 OptionsParser.getSourcePathList());

  Simple_Pass_Handler Handler;

  MatchFinder Finder;

  Finder.addMatcher(asscondcheck, &Handler);
  Finder.addMatcher(for_empty, &Handler);
  Finder.addMatcher(while_empty, &Handler);
  Finder.addMatcher(do_while_empty, &Handler);
  Finder.addMatcher(decls, &Handler);
  Finder.addMatcher(refs, &Handler);

  Tool.run(newFrontendActionFactory(&Finder).get());

  for (auto *V : Handler.DeclaredVars)
  {
    if (!Handler.ReferencedVars.count(V))
    {
      outs() << "Unused variable: " << V->getName() << "\n";
    }
  }
}