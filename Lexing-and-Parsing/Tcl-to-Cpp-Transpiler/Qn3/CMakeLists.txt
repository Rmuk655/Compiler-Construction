cmake_minimum_required(VERSION 3.16)
project(TclToCpp C)

find_package(BISON REQUIRED)
find_package(FLEX REQUIRED)

bison_target(Parser src/parser.y ${CMAKE_CURRENT_BINARY_DIR}/parser.tab.c
             DEFINES_FILE ${CMAKE_CURRENT_BINARY_DIR}/parser.tab.h)
flex_target(Lexer src/lexer.l ${CMAKE_CURRENT_BINARY_DIR}/lex.yy.c)
add_flex_bison_dependency(Lexer Parser)

add_executable(tcl2cpp ${BISON_Parser_OUTPUT_SOURCE} ${FLEX_Lexer_OUTPUTS})
target_include_directories(tcl2cpp PRIVATE ${CMAKE_CURRENT_BINARY_DIR})

enable_testing()
add_test(NAME tcl2cpp
         COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/runtests.sh $<TARGET_FILE:tcl2cpp>)
