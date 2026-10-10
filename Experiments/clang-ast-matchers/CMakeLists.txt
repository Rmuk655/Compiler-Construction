set(LLVM_LINK_COMPONENTS
  Support
  )

add_clang_executable(Simple_Pass
  Mypass.cpp
  )

clang_target_link_libraries(Simple_Pass
  PRIVATE
  clangAST
  clangASTMatchers
  clangBasic
  clangFrontend
  clangLex
  clangTooling
  clangToolingCore
  clangToolingInclusions
  )