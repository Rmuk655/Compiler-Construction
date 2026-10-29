# Setup

Toolchain and manual build commands. For the automated tests, run `make test` in a project folder (see the [README](README.md)).

## Toolchain

Tested on Ubuntu (WSL2).

```bash
# Flex / Bison / build tools
sudo apt update && sudo apt install -y flex bison build-essential cmake git graphviz

# LLVM 14 from apt
sudo apt install -y llvm-14 llvm-14-dev clang-14 lld-14
clang-14 --version && opt-14 --version && llvm-config-14 --version

# LLVM / Clang 17.0.6 from source (used for the Clang tooling and LLVM-IR-Explorer)
git clone https://github.com/llvm/llvm-project.git && cd llvm-project
git checkout llvmorg-17.0.6
mkdir build && cd build
cmake -G "Unix Makefiles" -DLLVM_TARGETS_TO_BUILD=X86 \
      -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra" -DCMAKE_BUILD_TYPE=Release ../llvm
make -j$(nproc)
```

Useful references: [Kaleidoscope tutorial](https://github.com/sreevyshnavi02/kaleidoscope_tutorial), [`llvm::Value`](https://llvm.org/doxygen/classllvm_1_1Value.html), [AST Matcher reference](https://clang.llvm.org/docs/LibASTMatchersReference.html).

## Building by hand

```bash
# Lex/Yacc calculator
cd Lexing-and-Parsing/lex-yacc/calculator
bison -d parser.y -o parser.tab.c && flex lexer.l && gcc parser.tab.c lex.yy.c -o calc

# Kaleidoscope front end (needs LLVM and clang++); IR and diagnostics go to stderr
cd Kaleidoscope/kaleidoscope-frontend
make && ./toy < tests.kal 2>&1

# Emit LLVM IR and a control-flow graph for a C file
cd LLVM-IR/llvm-ir-and-cfg/cfg-and-pass
clang -S -emit-llvm -O0 -Xclang -disable-O0-optnone -fno-discard-value-names temp.c -o temp.ll
opt -passes=dot-cfg temp.ll -disable-output && dot -Tpdf .foo.dot -o foo.pdf
```

Other IR commands: `clang -S -g -emit-llvm temp.c -o temp.ll` (with debug info) and `clang -S -emit-llvm -Xclang -disable-O0-optnone temp.c -o temp.ll` (unoptimised, attribute-free).
