set(LLVM_LINK_COMPONENTS
  Support
  )

add_clang_executable(MA4_Pass
  pass.cpp
  )

clang_target_link_libraries(MA4_Pass
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
