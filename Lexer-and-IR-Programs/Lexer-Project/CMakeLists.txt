cmake_minimum_required(VERSION 3.16)
project(PPLexer C)

find_package(FLEX REQUIRED)
flex_target(Lexer lexer.l ${CMAKE_CURRENT_BINARY_DIR}/lex.yy.c)

add_executable(lexer ${FLEX_Lexer_OUTPUTS})

enable_testing()
add_test(NAME pp-lexer
         COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/runtests.sh $<TARGET_FILE:lexer>)
