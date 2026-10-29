BUILD := build
BIN   := $(BUILD)/lexer

all: $(BIN)

$(BUILD)/lex.yy.c: lexer.l | $(BUILD)
	flex -o $@ lexer.l

$(BIN): $(BUILD)/lex.yy.c
	gcc -o $@ $<

$(BUILD):
	mkdir -p $(BUILD)

test: $(BIN)
	./runtests.sh $(BIN)

clean:
	rm -rf $(BUILD)

.PHONY: all test clean
