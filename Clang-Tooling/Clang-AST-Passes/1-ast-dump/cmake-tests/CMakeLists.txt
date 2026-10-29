# Standalone test runner (the CMakeLists.txt next to the sources is for building inside an LLVM tree).
# Usage: cmake -S Clang-AST-Passes/1-ast-dump/cmake-tests -B build && ctest --test-dir build
cmake_minimum_required(VERSION 3.16)
project(Tests NONE)

enable_testing()
add_test(NAME tests COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/../runtests.sh)
