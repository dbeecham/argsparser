# paths 
CC ?=
RM ?= rm -f
RAGEL ?= ragel
INSTALL ?= install

# flags to applications
CFLAGS ?= $(cflags-y) $(EXTRA_CFLAGS)
LDFLAGS ?= $(ldflags-y)
CROSS_COMPILE ?=
CPPFLAGS ?=
RAGELFLAGS ?= $(ragelflags-y) $(EXTRA_RAGELFLAGS)
LDLIBS ?= $(EXTRA_LDLIBS)
PREFIX ?= /usr/local

# quiet flag
Q = @

# colors
CC_COLOR = \033[0;34m
LD_COLOR = \033[0;33m
TEST_COLOR = \033[0;35m
INSTALL_COLOR = \033[0;32m
NO_COLOR = \033[m


# configurables
cflags-y += -Isrc
cflags-y += -Os
cflags-y += -std=c11
cflags-y += -march=native
cflags-y += -Wall -Wextra -Wno-unused-variable -Wno-implicit-fallthrough
ldflags-y += -Os
ragelflags-y += -G2


# main target
example: example.o args_parser.o

# install target
install: $(DESTDIR)$(PREFIX)/bin/example

# cleanup target
clean:
	$(RM) *.o example


# paths to sources
vpath %.c src
vpath %.c.rl src


# implicit rules
$(DESTDIR)$(PREFIX)/bin:
	@printf "$(INSTALL_COLOR)INSTALL$(NO_COLOR) $@\n"
	$(Q)$(INSTALL) -m 0755 -d $@

$(DESTDIR)$(PREFIX)/lib:
	@printf "$(INSTALL_COLOR)INSTALL$(NO_COLOR) $@\n"
	$(Q)$(INSTALL) -m 0755 -d $@

$(DESTDIR)$(PREFIX)/include:
	@printf "$(INSTALL_COLOR)INSTALL$(NO_COLOR) $@\n"
	$(Q)$(INSTALL) -m 0755 -d $@

$(DESTDIR)$(PREFIX)/lib/%.so: %.so | $(DESTDIR)$(PREFIX)/lib
	@printf "$(INSTALL_COLOR)INSTALL$(NO_COLOR) $@\n"
	$(Q)$(INSTALL) -m 0644 $< $@

$(DESTDIR)$(PREFIX)/lib/%.a: %.a | $(DESTDIR)$(PREFIX)/lib
	@printf "$(INSTALL_COLOR)INSTALL$(NO_COLOR) $@\n"
	$(Q)$(INSTALL) -m 0644 $< $@

$(DESTDIR)$(PREFIX)/include/%.h: %.h | $(DESTDIR)$(PREFIX)/include
	@printf "$(INSTALL_COLOR)INSTALL$(NO_COLOR) $@\n"
	$(Q)$(INSTALL) -m 0644 $< $@

$(DESTDIR)$(PREFIX)/bin/%: % | $(DESTDIR)$(PREFIX)/bin
	@printf "$(INSTALL_COLOR)INSTALL$(NO_COLOR) $@\n"
	$(Q)$(INSTALL) -m 0755 $< $@

%: %.o
	@printf "$(LD_COLOR)LD$(NO_COLOR) $@\n"
	$(Q)$(CROSS_COMPILE)$(CC) $(LDFLAGS) -o $@ $^ $(LOADLIBES) $(LDLIBS)

%.c: %.c.rl
	@printf "$(CC_COLOR)CC$(NO_COLOR) $@\n"
	$(Q)$(RAGEL) -Iinclude $(RAGELFLAGS) -o $@ $<

%.o: %.c
	@printf "$(CC_COLOR)CC$(NO_COLOR) $@\n"
	$(Q)$(CROSS_COMPILE)$(CC) -c $(CFLAGS) $(CPPFLAGS) -o $@ $^
