CFLAGS += -g3 -O0
RAGEL ?= ragel
RM ?= rm -f

args: args.o args_parser.o

%.c: %.c.rl
	$(RAGEL) -G2 -o $@ $<

clean:
	$(RM) *.o args
