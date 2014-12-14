
SRC = $(wildcard *.c)
LIB ?= libqute.a
OBJS ?= $(SRC:.c=.o)
TESTS ?= $(wildcard test/*.c)

PREFIX ?= /usr/local

DEP_SRC ?= $(wildcard deps/*/*.c)

EXAMPLES_SRC ?= $(wildcard examples/*.c)
EXAMPLES ?= $(EXAMPLES_SRC:.c=)

.PHONY: $(LIB)
$(LIB): $(OBJS)
	ar crus $(@) $(OBJS)

.PHONY: $(OBJS)
$(OBJS):
	$(CC) -c $(@:.o=.c) -o $(@)

clean:
	rm -f $(LIB) $(OBJS)
	rm -f $(TESTS:.c=)
	rm -f $(EXAMPLES)

install: $(LIB)
	install $(LIB) $(PREFIX)/lib

uninstall:
	rm -f $(PREFIX)/lib/$(LIB)

test: test/simple

test/simple: $(LIB)
	$(CC) -I. -Ideps $(LIB) $(@).c $(DEP_SRC) -o $(@)
	./$(@)

examples/: examples
examples: $(EXAMPLES)

.PHONY: $(EXAMPLES)
$(EXAMPLES):
	$(CC) -I. -Ideps $(LIB) $(@).c -o $(@)