OBJ = 
BIN = mathfs

.PHONY: all
all: build-int

mathfs: fs.c.o error.c.o parse.c.o eval.c.o op.c.o

CC = gcc
RM = rm -f

CFLAGS  = -ggdb
LDFLAGS =
override CFLAGS  += -Wall -pipe -MMD
override LDFLAGS += -lm
FUSE_CFLAGS  := $(shell pkg-config fuse --cflags)
FUSE_LDFLAGS := $(shell pkg-config fuse --libs)

.PHONY: build-int
build-int: $(BIN)

.PHONY: build-float
build-float: CFLAGS+=-DNUM_FLOAT
build-float: $(BIN)

.PHONY: rebuild
rebuild: | clean
	$(MAKE) -C . build

.PHONY: clean
clean:
	$(RM) $(BIN) $(BIN).tar *.d *.o $(OBJ)

%.c.o : %.c
	$(CC) $(CFLAGS) $(FUSE_CFLAGS) -c -o $@ $<

$(BIN): $(OBJ)
	$(CC) $(CFLAGS) $(LDFLAGS) $(FUSE_LDFLAGS) -o $@ $^

.PHONY: archive
PKG_NAME:=mathfs
archive:
	git archive --prefix='$(PKG_NAME)/' HEAD > $(PKG_NAME).tar

-include $(wildcard *.d)
