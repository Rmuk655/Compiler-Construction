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

using namespace std;
using namespace clang;
using namespace clang::tooling;
using namespace clang::ast_matchers;
using namespace llvm;

static llvm::cl::OptionCategory Simple_Pass("Simple_Pass options");

// write matchers here..
DeclarationMatcher func = functionDecl(isDefinition()).bind("function");
DeclarationMatcher var = varDecl(unless(parmVarDecl())).bind("variable");

class Simple_Pass_Handler : public MatchFinder::MatchCallback {
public:
    int count =0;
    int Var_count =0;
  virtual void run(const MatchFinder::MatchResult &Result) override {

    if (const FunctionDecl *FD = Result.Nodes.getNodeAs<FunctionDecl>("function")) {
        count++;
      outs() << "Function name: " << FD->getNameAsString() <<" "<< count<<"\n";
    }
    if(const VarDecl *VD = Result.Nodes.getNodeAs<VarDecl>("variable")){
      Var_count++;
      outs() << "Variable name: " << VD->getNameAsString() <<" "<< Var_count<<"\n";
    }
    
  }
};

int main(int argc, const char **argv) {

  auto ExpectedParser = CommonOptionsParser::create(argc, argv, Simple_Pass);
  if (!ExpectedParser) {
    // Fail gracefully for unsupported options.
    errs() << ExpectedParser.takeError();
    return 1;
  }
  CommonOptionsParser &OptionsParser = ExpectedParser.get();
  ClangTool Tool(OptionsParser.getCompilations(),
                 OptionsParser.getSourcePathList());

  Simple_Pass_Handler Handler;

  MatchFinder Finder;

  Finder.addMatcher(func, &Handler);
  Finder.addMatcher(var, &Handler);

  Tool.run(newFrontendActionFactory(&Finder).get());

  outs() << "The Total VarCount " << Handler.Var_count <<"\n";
}