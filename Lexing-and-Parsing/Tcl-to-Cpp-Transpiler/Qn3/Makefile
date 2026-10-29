# Out-of-tree build (build/ already holds the original in-place Makefile).
OUT := out
BIN := $(OUT)/tcl2cpp

all: $(BIN)

$(OUT)/parser.tab.c $(OUT)/parser.tab.h: src/parser.y | $(OUT)
	bison -d -o $(OUT)/parser.tab.c src/parser.y

$(OUT)/lex.yy.c: src/lexer.l $(OUT)/parser.tab.h | $(OUT)
	flex -o $@ src/lexer.l

$(BIN): $(OUT)/parser.tab.c $(OUT)/lex.yy.c
	gcc -I$(OUT) -o $@ $(OUT)/parser.tab.c $(OUT)/lex.yy.c

$(OUT):
	mkdir -p $(OUT)

test: $(BIN)
	./runtests.sh $(BIN)

clean:
	rm -rf $(OUT)

.PHONY: all test clean
