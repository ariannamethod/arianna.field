# arianna.field — single-file C heart. Punk: no external deps, just cc + libm.
# The whole organism is arianna-q.c (GGUF + SentencePiece + Llama forward + δ-field).
# Build:  make            Run one voice:  make run            δ-field chorus:  make field
# Body (GGUF) is gitignored — pull from HF ataeff/arianna.q or ~/arianna/arianna-duo/weights.

CC     ?= cc
CFLAGS ?= -O2 -Wall
LDLIBS := -lm
BIN    := arianna-q
SRC    := arianna-q.c
MODEL  ?= weights/nanoarianna89m_full_v4_step2750_f16.gguf
PROMPT ?= What is resonance?

$(BIN): $(SRC)
	$(CC) $(CFLAGS) $(SRC) $(LDLIBS) -o $(BIN)

# single voice (continuation)
run: $(BIN)
	./$(BIN) "$(MODEL)" "$(PROMPT)" 48 0.8

# δ-field chorus: N cells, each its own answer, hearing each other's hidden K/V
field: $(BIN)
	./$(BIN) "$(MODEL)" "$(PROMPT)" field 4 16 1

# δ-life: the chorus as a Game of Life — cells born/die/reproduce, the population breathes
life: $(BIN)
	./$(BIN) "$(MODEL)" "$(PROMPT)" life 12 18 5

clean:
	rm -f $(BIN)

.PHONY: run field life clean
