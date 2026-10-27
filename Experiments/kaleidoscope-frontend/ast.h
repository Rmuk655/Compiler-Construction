#ifndef KALEIDOSCOPE_AST_H
#define KALEIDOSCOPE_AST_H

#include "llvm/IR/Function.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/Value.h"
#include <memory>
#include <string>
#include <vector>

//===----------------------------------------------------------------------===//
// Types
//===----------------------------------------------------------------------===//

/// VarType - The source-level types of the language. Every parameter, every
/// function return value and every literal carries one of these.
enum class VarType { Double, Int, Bool };

/// Param - One typed formal parameter of a prototype, like "int a".
struct Param {
  VarType Ty;
  std::string Name;
};

/// Map a source-level type to its LLVM type: double -> double, int -> i32,
/// bool -> i1. Defined in toy.cpp, where the LLVMContext lives.
llvm::Type *toLLVMType(VarType Ty);

//===----------------------------------------------------------------------===//
// Abstract Syntax Tree (aka Parse Tree)
//===----------------------------------------------------------------------===//
// These classes are shared between the yacc parser (parser.y), which builds
// the tree, and toy.cpp, which generates LLVM IR from it. Unlike the
// hand-written version they can't live in an anonymous namespace, since they
// are used from more than one translation unit.

/// ExprAST - Base class for all expression nodes.
class ExprAST {
public:
  virtual ~ExprAST() = default;

  virtual llvm::Value *codegen() = 0;
};

/// NumberExprAST - Expression class for literals like "1.0", "1" or "true".
class NumberExprAST : public ExprAST {
  VarType Ty;
  double Val_double = 0.0;
  int Val_int = 0;
  bool Val_bool = false;

public:
  NumberExprAST(double Val) : Ty(VarType::Double), Val_double(Val) {}
  NumberExprAST(int Val) : Ty(VarType::Int), Val_int(Val) {}
  NumberExprAST(bool Val) : Ty(VarType::Bool), Val_bool(Val) {}

  llvm::Value *codegen() override;
};

/// VariableExprAST - Expression class for referencing a variable, like "a".
class VariableExprAST : public ExprAST {
  std::string Name;

public:
  VariableExprAST(const std::string &Name) : Name(Name) {}

  llvm::Value *codegen() override;
};

/// BinaryExprAST - Expression class for a binary operator.
class BinaryExprAST : public ExprAST {
  char Op;
  std::unique_ptr<ExprAST> LHS, RHS;

public:
  BinaryExprAST(char Op, std::unique_ptr<ExprAST> LHS,
                std::unique_ptr<ExprAST> RHS)
      : Op(Op), LHS(std::move(LHS)), RHS(std::move(RHS)) {}

  llvm::Value *codegen() override;
};

/// CastExprAST - Expression class for an explicit cast, like "int(x)".
class CastExprAST : public ExprAST {
  VarType Target;
  std::unique_ptr<ExprAST> Operand;

public:
  CastExprAST(VarType Target, std::unique_ptr<ExprAST> Operand)
      : Target(Target), Operand(std::move(Operand)) {}

  llvm::Value *codegen() override;
};

/// CallExprAST - Expression class for function calls.
class CallExprAST : public ExprAST {
  std::string Callee;
  std::vector<std::unique_ptr<ExprAST>> Args;

public:
  CallExprAST(const std::string &Callee,
              std::vector<std::unique_ptr<ExprAST>> Args)
      : Callee(Callee), Args(std::move(Args)) {}

  llvm::Value *codegen() override;
};

/// PrototypeAST - This class represents the "prototype" for a function,
/// which captures its return type, its name, and its typed parameters (thus
/// implicitly the number of arguments the function takes).
class PrototypeAST {
  VarType RetTy;
  std::string Name;
  std::vector<Param> Args;

public:
  PrototypeAST(VarType RetTy, const std::string &Name, std::vector<Param> Args)
      : RetTy(RetTy), Name(Name), Args(std::move(Args)) {}

  llvm::Function *codegen();
  const std::string &getName() const { return Name; }
  VarType getReturnType() const { return RetTy; }
  const std::vector<Param> &getParams() const { return Args; }
};

/// FunctionAST - This class represents a function definition itself.
class FunctionAST {
  std::unique_ptr<PrototypeAST> Proto;
  std::unique_ptr<ExprAST> Body;

public:
  FunctionAST(std::unique_ptr<PrototypeAST> Proto,
              std::unique_ptr<ExprAST> Body)
      : Proto(std::move(Proto)), Body(std::move(Body)) {}

  llvm::Function *codegen();
};

//===----------------------------------------------------------------------===//
// Top-level handlers (defined in toy.cpp, called from the parser actions)
//===----------------------------------------------------------------------===//

void HandleDefinition(std::unique_ptr<FunctionAST> FnAST);
void HandleExtern(std::unique_ptr<PrototypeAST> ProtoAST);
void HandleTopLevelExpression(std::unique_ptr<ExprAST> E);

#endif // KALEIDOSCOPE_AST_H