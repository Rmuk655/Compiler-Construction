cmake_minimum_required(VERSION 3.16)
project(LLVMIRProject NONE)

enable_testing()
add_test(NAME ir-checks COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/runtests.sh)
