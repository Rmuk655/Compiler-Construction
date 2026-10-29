# Build and test helper for the GitHub repo. Not needed for the lab exam.
BUILD := build
BIN   := $(BUILD)/compiler

all: $(BIN)

$(BUILD)/parser.tab.c $(BUILD)/parser.tab.h: parser.y | $(BUILD)
	bison -d -o $(BUILD)/parser.tab.c parser.y

$(BUILD)/lex.yy.c: lexer.l $(BUILD)/parser.tab.h | $(BUILD)
	flex -o $@ lexer.l

$(BIN): $(BUILD)/lex.yy.c $(BUILD)/parser.tab.c
	g++ -I$(BUILD) -o $@ $(BUILD)/lex.yy.c $(BUILD)/parser.tab.c

$(BUILD):
	mkdir -p $(BUILD)

test: $(BIN)
	./runtests.sh $(BIN)

clean:
	rm -rf $(BUILD)

.PHONY: all test clean
