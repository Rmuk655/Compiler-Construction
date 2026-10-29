cmake_minimum_required(VERSION 3.16)
project(KaleidoscopeFrontend CXX)

find_package(BISON REQUIRED)
find_package(FLEX REQUIRED)

# Use llvm-config like the Makefile does (the packaged LLVM CMake config files
# are not reliable on every distro).
find_program(LLVM_CONFIG llvm-config REQUIRED)
execute_process(COMMAND ${LLVM_CONFIG} --cxxflags OUTPUT_VARIABLE LLVM_CXXFLAGS OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND ${LLVM_CONFIG} --ldflags --system-libs --libs core
                OUTPUT_VARIABLE LLVM_LDFLAGS OUTPUT_STRIP_TRAILING_WHITESPACE)
separate_arguments(LLVM_CXXFLAGS UNIX_COMMAND "${LLVM_CXXFLAGS}")
separate_arguments(LLVM_LDFLAGS UNIX_COMMAND "${LLVM_LDFLAGS}")

bison_target(Parser parser.y ${CMAKE_CURRENT_BINARY_DIR}/parser.tab.cpp
             DEFINES_FILE ${CMAKE_CURRENT_BINARY_DIR}/parser.tab.h)
flex_target(Lexer lexer.l ${CMAKE_CURRENT_BINARY_DIR}/lex.yy.cpp)
add_flex_bison_dependency(Lexer Parser)

add_executable(toy toy.cpp ${BISON_Parser_OUTPUT_SOURCE} ${FLEX_Lexer_OUTPUTS})
target_include_directories(toy PRIVATE ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR})
target_compile_options(toy PRIVATE ${LLVM_CXXFLAGS})
target_link_libraries(toy PRIVATE ${LLVM_LDFLAGS})

enable_testing()
add_test(NAME kaleidoscope-frontend
         COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/runtests.sh $<TARGET_FILE:toy>)
