#------------------------------------------------------------------------------------
# Copyright (C) Arm Limited, 2019-2021 All rights reserved.
#
# The example code is provided to you as an aid to learning when working
# with Arm-based technology, including but not limited to programming tutorials.
#
# Arm hereby grants to you, subject to the terms and conditions of this Licence,
# a non-exclusive, non-transferable, non-sub-licensable, free-of-charge copyright
# licence, to use, copy and modify the Software solely for the purpose of internal
# demonstration and evaluation.
#
# You accept that the Software has not been tested by Arm therefore the Software
# is provided "as is", without warranty of any kind, express or implied. In no
# event shall the authors or copyright holders be liable for any claim, damages
# or other liability, whether in action or contract, tort or otherwise, arising
# from, out of or in connection with the Software or the use of Software.
#------------------------------------------------------------------------------------

EXE = histogram_vls512

SRCDIR = ./src
BUILDDIR = ./build

CC = ${ARM_SVE_COMPILER}

CFLAGS = -I$(SRCDIR) -std=c11 -MMD
CFLAGS += -Wall -Wextra -Wpedantic
CFLAGS += -Werror -Wshadow -Wconversion
CFLAGS += -march=armv8.4-a+sve2 -O3

SRC_C := $(wildcard $(SRCDIR)/*.c)
SRC_ASM := $(wildcard $(SRCDIR)/*.S)

OBJ_C := $(patsubst $(SRCDIR)/%.c, $(BUILDDIR)/%.s, $(SRC_C))

.PHONY: all
all: build_directory executable

DEPS := $(OBJ_C:%.s=%.d)

-include $(DEPS)

$(BUILDDIR)/%.s: $(SRCDIR)/%.c
	$(CC) $(CFLAGS) $< -S -o $@

.PHONY: build_directory
build_directory:
	@mkdir -pv $(BUILDDIR)

.PHONY: executable
executable: $(OBJ_C) $(SRC_ASM)
	$(CC) $(CFLAGS) $^ -o $(BUILDDIR)/$(EXE)

.PHONY: clean
clean:
	rm -fv $(BUILDDIR)/*.d $(BUILDDIR)/*.s $(BUILDDIR)/$(EXE)
