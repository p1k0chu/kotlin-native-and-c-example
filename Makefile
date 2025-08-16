#################
### COMPILERS ###
#################

CC := clang
CC_FLAGS := -Wall -Wextra -Igenerated

KOTLINC := kotlinc-native
KOTLINC_FLAGS := -produce static -opt

KOTLIN_CINTEROP := cinterop

LD := clang++
LD_FLAGS :=

###################
### COMPILATION ###
##################

O := build

C_SRC := $(wildcard *.c)
C_HEADERS := $(wildcard *.h)
KOTLIN_SRC := $(wildcard *.kt)

OBJ := $(patsubst %,$(O)/%.o,$(C_SRC))

$(O)/main: $(OBJ) $(O)/libmykt.a
	$(LD) $(LD_FLAGS) -o $@ $^

# main.c includes this header
$(O)/main.c.o: generated/mykt_api.h

# your C code bindings for the kotlin
$(O)/c_bindings.klib: $(C_HEADERS) | $(O)/
	$(KOTLIN_CINTEROP) -pkg org.example -o $(patsubst %.klib,%,$@) $(foreach h,$(C_HEADERS),-header $(shell realpath $(h)))

generated/c_bindings.klib: $(O)/c_bindings.klib | generated/
	@cp $< $@

# your kotlin lib
# it produces two files so use the .stamp file trick
# https://www.gnu.org/software/automake/manual/html_node/Multiple-Outputs.html

$(O)/libmykt.a $(O)/mykt_api.h: $(O)/mykt.stamp
## Recover from the removal of $@
	@test -f $@ || rm -f $<
	@test -f $@ || $(MAKE) $(AM_MAKEFLAGS) $<

$(O)/mykt.stamp: generated/c_bindings.klib $(KOTLIN_SRC) | $(O)/
	@rm -f $@.tmp
	@touch $@.tmp
	$(KOTLINC) $(KOTLINC_FLAGS) -l $< -o $(O)/mykt $(filter %.kt,$^)
	@mv -f $@.tmp $@

# put the kotlin header in generated/ directory
generated/mykt_api.h: $(O)/mykt_api.h | generated/
	@cp $< $@

%/:
	mkdir -p $@

$(O)/%.c.o: %.c | $(O)/
	$(CC) $(CC_FLAGS) -c -o $@ $<

clean:
	rm -vrf $(O)
	rm -vrf generated

.PHONY: clean

