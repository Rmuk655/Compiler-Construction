#include "ast.h"
#include "llvm/ADT/APFloat.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/Verifier.h"
#include <cstdio>
#include <map>
#include <memory>
#include <string>
#include <vector>

using namespace llvm;

// The lexer now lives in lexer.l (flex), the parser in parser.y (bison), and
// the AST classes in ast.h. This file only holds code generation and the
// driver.

int yyparse();

//===----------------------------------------------------------------------===//
// Code Generation
//===----------------------------------------------------------------------===//

static std::unique_ptr<LLVMContext> TheContext;
static std::unique_ptr<Module> TheModule;
static std::unique_ptr<IRBuilder<>> Builder;

/// SymbolInfo - What the symbol table records for each variable: its IR
/// value and its declared source-level type.
struct SymbolInfo {
  Value *Val;
  VarType Ty;
};
static std::map<std::string, SymbolInfo> NamedValues;

Value *LogErrorV(const std::string &Str) {
  fprintf(stderr, "Error: %s\n", Str.c_str());
  return nullptr;
}

Type *toLLVMType(VarType Ty) {
  switch (Ty) {
  case VarType::Double:
    return Type::getDoubleTy(*TheContext);
  case VarType::Int:
    return Type::getInt32Ty(*TheContext);
  case VarType::Bool:
    return Type::getInt1Ty(*TheContext);
  }
  return nullptr;
}

/// Source-level name of an LLVM type, for error messages.
static std::string typeName(Type *T) {
  if (T->isDoubleTy())
    return "double";
  if (T->isIntegerTy(32))
    return "int";
  if (T->isIntegerTy(1))
    return "bool";
  return "<unknown>";
}

/// castTo - Convert V to type Target. Only int -> double is allowed
/// implicitly (a widening conversion). Every other conversion between double,
/// int and bool needs an explicit cast such as int(x). Ctx names the place the
/// conversion is needed, for the error message.
static Value *castTo(Value *V, Type *Target, bool Explicit,
                     const std::string &Ctx) {
  Type *From = V->getType();
  if (From == Target)
    return V;

  // int -> double: implicit promotion.
  if (From->isIntegerTy(32) && Target->isDoubleTy())
    return Builder->CreateSIToFP(V, Target, "casttmp");

  if (!Explicit)
    return LogErrorV(Ctx + ": cannot implicitly convert " + typeName(From) +
                     " to " + typeName(Target) + " (use an explicit cast)");

  // double -> int: truncate towards zero.
  if (From->isDoubleTy() && Target->isIntegerTy(32))
    return Builder->CreateFPToSI(V, Target, "casttmp");
  // bool -> int / double: true is 1, false is 0.
  if (From->isIntegerTy(1) && Target->isIntegerTy(32))
    return Builder->CreateZExt(V, Target, "casttmp");
  if (From->isIntegerTy(1) && Target->isDoubleTy())
    return Builder->CreateUIToFP(V, Target, "casttmp");
  // int / double -> bool: non-zero is true (NaN is true, as in C).
  if (From->isIntegerTy(32) && Target->isIntegerTy(1))
    return Builder->CreateICmpNE(V, ConstantInt::get(From, 0), "casttmp");
  if (From->isDoubleTy() && Target->isIntegerTy(1))
    return Builder->CreateFCmpUNE(V, ConstantFP::get(From, 0.0), "casttmp");

  return LogErrorV(Ctx + ": cannot convert " + typeName(From) + " to " +
                   typeName(Target));
}

Value *NumberExprAST::codegen() {
  switch (Ty) {
  case VarType::Double:
    return ConstantFP::get(*TheContext, APFloat(Val_double));
  case VarType::Int:
    return ConstantInt::get(*TheContext, APInt(32, Val_int, true));
  case VarType::Bool:
    return ConstantInt::get(*TheContext, APInt(1, Val_bool));
  }
  return LogErrorV("Unknown literal type");
}

Value *VariableExprAST::codegen() {
  // Look this variable up in the function. find() rather than operator[], so
  // an unknown name is not silently inserted into the table.
  auto It = NamedValues.find(Name);
  if (It == NamedValues.end())
    return LogErrorV("Unknown variable name '" + Name + "'");
  return It->second.Val;
}

Value *CastExprAST::codegen() {
  Value *V = Operand->codegen();
  if (!V)
    return nullptr;
  return castTo(V, toLLVMType(Target), /*Explicit=*/true, "cast");
}

Value *BinaryExprAST::codegen() {
  Value *L = LHS->codegen();
  Value *R = RHS->codegen();
  if (!L || !R)
    return nullptr;

  std::string OpStr = std::string("operator '") + Op + "'";

  // bool operands are only allowed through an explicit cast.
  if (L->getType()->isIntegerTy(1) || R->getType()->isIntegerTy(1))
    return LogErrorV(OpStr + ": operands cannot be bool (got " +
                     typeName(L->getType()) + " and " +
                     typeName(R->getType()) + ")");

  // Mixed int/double: promote the int side to double.
  if (L->getType() != R->getType()) {
    Type *DoubleTy = Type::getDoubleTy(*TheContext);
    L = castTo(L, DoubleTy, /*Explicit=*/false, OpStr);
    R = castTo(R, DoubleTy, /*Explicit=*/false, OpStr);
    if (!L || !R)
      return nullptr;
  }

  // Comparisons always produce bool (i1); arithmetic keeps the operand type.
  if (L->getType()->isIntegerTy(32)) {
    switch (Op) {
    case '+':
      return Builder->CreateAdd(L, R, "addtmp");
    case '-':
      return Builder->CreateSub(L, R, "subtmp");
    case '*':
      return Builder->CreateMul(L, R, "multmp");
    case '/':
      if (auto *C = dyn_cast<ConstantInt>(R); C && C->isZero())
        return LogErrorV("integer division by constant zero");
      return Builder->CreateSDiv(L, R, "divtmp");
    case '<':
      return Builder->CreateICmpSLT(L, R, "cmptmp");
    case '>':
      return Builder->CreateICmpSGT(L, R, "cmptmp");
    default:
      return LogErrorV("invalid binary operator");
    }
  }

  if (L->getType()->isDoubleTy()) {
    switch (Op) {
    case '+':
      return Builder->CreateFAdd(L, R, "addtmp");
    case '-':
      return Builder->CreateFSub(L, R, "subtmp");
    case '*':
      return Builder->CreateFMul(L, R, "multmp");
    case '/':
      return Builder->CreateFDiv(L, R, "divtmp");
    case '<':
      return Builder->CreateFCmpOLT(L, R, "cmptmp");
    case '>':
      return Builder->CreateFCmpOGT(L, R, "cmptmp");
    default:
      return LogErrorV("invalid binary operator");
    }
  }

  return LogErrorV(OpStr + ": unsupported operand type " +
                   typeName(L->getType()));
}

Value *CallExprAST::codegen() {
  // Look up the name in the global module table.
  Function *CalleeF = TheModule->getFunction(Callee);
  if (!CalleeF)
    return LogErrorV("Unknown function referenced '" + Callee + "'");

  // If argument mismatch error.
  if (CalleeF->arg_size() != Args.size())
    return LogErrorV("Incorrect # arguments passed to '" + Callee + "'");

  // Each argument must match (or implicitly convert to) its parameter type.
  std::vector<Value *> ArgsV;
  for (unsigned i = 0, e = Args.size(); i != e; ++i) {
    Value *V = Args[i]->codegen();
    if (!V)
      return nullptr;
    V = castTo(V, CalleeF->getArg(i)->getType(), /*Explicit=*/false,
               "argument " + std::to_string(i + 1) + " of '" + Callee + "'");
    if (!V)
      return nullptr;
    ArgsV.push_back(V);
  }

  return Builder->CreateCall(CalleeF, ArgsV, "calltmp");
}

Function *PrototypeAST::codegen() {
  // Parameter names must be unique within a prototype.
  for (size_t i = 0; i < Args.size(); ++i)
    for (size_t j = 0; j < i; ++j)
      if (Args[i].Name == Args[j].Name)
        return (Function *)LogErrorV("redefinition of parameter '" +
                                     Args[i].Name + "' in '" + Name + "'");

  // Make the function type from the declared types, e.g. int(int,double).
  std::vector<Type *> ArgTypes;
  for (const Param &P : Args)
    ArgTypes.push_back(toLLVMType(P.Ty));
  FunctionType *FT = FunctionType::get(toLLVMType(RetTy), ArgTypes, false);

  // A previous extern (or definition) of the same name must have exactly the
  // same signature; otherwise LLVM would quietly create a renamed copy.
  Function *F = TheModule->getFunction(Name);
  if (F && F->getFunctionType() != FT)
    return (Function *)LogErrorV("conflicting types for '" + Name +
                                 "': does not match its earlier declaration");
  if (!F)
    F = Function::Create(FT, Function::ExternalLinkage, Name, TheModule.get());

  // Set names for all arguments (unless this is an already defined function).
  if (F->empty()) {
    unsigned Idx = 0;
    for (auto &Arg : F->args())
      Arg.setName(Args[Idx++].Name);
  }

  return F;
}

Function *FunctionAST::codegen() {
  // Reuse an earlier 'extern' declaration if there is one; PrototypeAST checks
  // that its signature matches.
  bool WasDeclared = TheModule->getFunction(Proto->getName()) != nullptr;
  Function *TheFunction = Proto->codegen();
  if (!TheFunction)
    return nullptr;

  if (!TheFunction->empty())
    return (Function *)LogErrorV("Function '" + Proto->getName() +
                                 "' cannot be redefined.");

  // Create a new basic block to start insertion into.
  BasicBlock *BB = BasicBlock::Create(*TheContext, "entry", TheFunction);
  Builder->SetInsertPoint(BB);

  // Record the function arguments, with their declared types, in the
  // NamedValues symbol table.
  NamedValues.clear();
  const std::vector<Param> &Params = Proto->getParams();
  unsigned Idx = 0;
  for (auto &Arg : TheFunction->args()) {
    NamedValues[Params[Idx].Name] = {&Arg, Params[Idx].Ty};
    ++Idx;
  }

  if (Value *RetVal = Body->codegen()) {
    // The body's value must match the declared return type.
    RetVal = castTo(RetVal, TheFunction->getReturnType(), /*Explicit=*/false,
                    "return value of '" + Proto->getName() + "'");
    if (RetVal) {
      // Finish off the function.
      Builder->CreateRet(RetVal);

      // Validate the generated code, checking for consistency.
      if (verifyFunction(*TheFunction, &errs())) {
        TheFunction->eraseFromParent();
        return nullptr;
      }

      return TheFunction;
    }
  }

  // Error reading body: drop it. Keep an earlier extern declaration, so a
  // failed definition does not make the extern disappear.
  if (WasDeclared)
    TheFunction->deleteBody();
  else
    TheFunction->eraseFromParent();
  return nullptr;
}

//===----------------------------------------------------------------------===//
// Top-Level handlers and driver
//===----------------------------------------------------------------------===//
// The parser calls these as soon as it reduces a complete top-level item, so
// the REPL still prints IR after each definition / extern / expression.

static void InitializeModule() {
  // Open a new context and module.
  TheContext = std::make_unique<LLVMContext>();
  TheModule = std::make_unique<Module>("my cool jit", *TheContext);

  // Create a new builder for the module.
  Builder = std::make_unique<IRBuilder<>>(*TheContext);
}

void HandleDefinition(std::unique_ptr<FunctionAST> FnAST) {
  if (auto *FnIR = FnAST->codegen()) {
    fprintf(stderr, "Read function definition:");
    FnIR->print(errs());
    fprintf(stderr, "\n");
  }
}

void HandleExtern(std::unique_ptr<PrototypeAST> ProtoAST) {
  if (auto *FnIR = ProtoAST->codegen()) {
    fprintf(stderr, "Read extern: ");
    FnIR->print(errs());
    fprintf(stderr, "\n");
  }
}

void HandleTopLevelExpression(std::unique_ptr<ExprAST> E) {
  // Evaluate a top-level expression into an anonymous function. Its result
  // type is always double, so the value is explicitly converted to double
  // (true -> 1.0, 3 -> 3.0).
  auto Proto = std::make_unique<PrototypeAST>(VarType::Double, "__anon_expr",
                                              std::vector<Param>());
  auto Body = std::make_unique<CastExprAST>(VarType::Double, std::move(E));
  auto FnAST = std::make_unique<FunctionAST>(std::move(Proto), std::move(Body));
  if (auto *FnIR = FnAST->codegen()) {
    fprintf(stderr, "Read top-level expression:");
    FnIR->print(errs());
    fprintf(stderr, "\n");

    // Remove the anonymous expression.
    FnIR->eraseFromParent();
  }
}

//===----------------------------------------------------------------------===//
// Main driver code.
//===----------------------------------------------------------------------===//

int main() {
  // Make the module, which holds all the code.
  InitializeModule();

  // Run the parser; it drives codegen through the Handle* callbacks.
  fprintf(stderr, "ready> ");
  yyparse();

  // Print out all of the generated code.
  TheModule->print(errs(), nullptr);

  return 0;
}
