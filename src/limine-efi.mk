#
#  Copyright (c) 1999-2007 Hewlett-Packard Development Company, L.P.
#	Contributed by David Mosberger <davidm@hpl.hp.com>
#	Contributed by Stephane Eranian <eranian@hpl.hp.com>
#  Copyright (C) 2022-2024 mintsuki
#
#    All rights reserved.
#
#    Redistribution and use in source and binary forms, with or without
#    modification, are permitted provided that the following conditions
#    are met:
#
#    * Redistributions of source code must retain the above copyright
#      notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above
#      copyright notice, this list of conditions and the following
#      disclaimer in the documentation and/or other materials
#      provided with the distribution.
#    * Neither the name of Hewlett-Packard Co. nor the names of its
#      contributors may be used to endorse or promote products derived
#      from this software without specific prior written permission.
#
#    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
#    CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
#    INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
#    MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
#    BE LIABLE FOR ANYDIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
#    OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
#    PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
#    PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
#    THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
#    TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
#    THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
#    SUCH DAMAGE.
#

MAKEFLAGS += -rR
.SUFFIXES:

override USER_VARIABLE = $(if $(filter $(origin $(1)),default undefined),$(eval override $(1) := $(2)))

$(call USER_VARIABLE,CC,cc)

# Target identification
$(call USER_VARIABLE,ARCH,x86_64)

$(call USER_VARIABLE,CFLAGS,-g -O2 -pipe)
$(call USER_VARIABLE,CPPFLAGS,)

# Generic compilation flags

override CPPFLAGS := \
    -I../inc \
    $(CPPFLAGS)

override CFLAGS += \
    -Wall \
    -Wextra \
    -std=gnu11 \
    -ffreestanding \
    -fno-stack-protector \
    -fno-stack-check \
    -fno-strict-aliasing \
    -fshort-wchar \
    -fno-lto \
    -fPIE

# Arch-specific compilation flags

ifeq ($(ARCH),ia32)
    override CFLAGS += \
        -m32 \
        -march=i686 \
        -mno-80387
endif

ifeq ($(ARCH),x86_64)
    override CFLAGS += \
        -m64 \
        -march=x86-64 \
        -mno-80387 \
        -mno-mmx \
        -mno-sse \
        -mno-sse2 \
        -mno-red-zone
endif

ifeq ($(ARCH),aarch64)
    override CFLAGS += \
        -fno-jump-tables \
        -mgeneral-regs-only
endif

ifeq ($(ARCH),riscv64)
    ifeq ($(shell $(CC) --version | grep -i 'clang'),)
        override CFLAGS += -march=rv64imac_zicsr_zifencei
    else
        override CFLAGS += -march=rv64imac
    endif
    override CFLAGS += \
        -mabi=lp64 \
        -mno-relax
endif

ifeq ($(ARCH),loongarch64)
    override CFLAGS += \
        -march=loongarch64 \
        -mabi=lp64s
endif

override OBJS := crt0-efi-$(ARCH).S.o reloc_$(ARCH).c.o

all: $(OBJS)

%.c.o: %.c limine-efi.mk
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

%.S.o: %.S limine-efi.mk
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS)
