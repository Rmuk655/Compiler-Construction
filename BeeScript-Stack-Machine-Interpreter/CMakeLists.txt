# Build and test helper for the GitHub repo. Not needed for the lab exam.
cmake_minimum_required(VERSION 3.16)
project(BeeScript CXX)

find_package(BISON REQUIRED)
find_package(FLEX REQUIRED)

bison_target(Parser parser.y ${CMAKE_CURRENT_BINARY_DIR}/parser.tab.c
             DEFINES_FILE ${CMAKE_CURRENT_BINARY_DIR}/parser.tab.h)
flex_target(Lexer lexer.l ${CMAKE_CURRENT_BINARY_DIR}/lex.yy.c)
add_flex_bison_dependency(Lexer Parser)

# The grammar actions use C++ (iostream, deque), so compile the generated files as C++.
set_source_files_properties(${BISON_Parser_OUTPUT_SOURCE} ${FLEX_Lexer_OUTPUTS}
                            PROPERTIES LANGUAGE CXX)

add_executable(compiler ${BISON_Parser_OUTPUT_SOURCE} ${FLEX_Lexer_OUTPUTS})
target_include_directories(compiler PRIVATE ${CMAKE_CURRENT_BINARY_DIR})

enable_testing()
add_test(NAME beescript
         COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/runtests.sh $<TARGET_FILE:compiler>)
