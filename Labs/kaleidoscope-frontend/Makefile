CXX      := clang++
CXXFLAGS := -g -O3 $(shell llvm-config --cxxflags)
LDFLAGS  := $(shell llvm-config --ldflags --system-libs --libs core)

toy: toy.cpp parser.tab.cpp lex.yy.cpp ast.h
	$(CXX) $(CXXFLAGS) toy.cpp parser.tab.cpp lex.yy.cpp $(LDFLAGS) -o $@

parser.tab.cpp parser.tab.h: parser.y
	bison -d -Wall -o parser.tab.cpp --header=parser.tab.h parser.y

lex.yy.cpp: lexer.l parser.tab.h
	flex -o $@ lexer.l

clean:
	rm -f toy parser.tab.cpp parser.tab.h lex.yy.cpp

.PHONY: clean