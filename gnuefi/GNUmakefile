#
#  Copyright (c) 1999-2007 Hewlett-Packard Development Company, L.P.
#	Contributed by David Mosberger <davidm@hpl.hp.com>
#	Contributed by Stephane Eranian <eranian@hpl.hp.com>
#  Copyright (C) 2022 Mintsuki
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

define DEFAULT_VAR =
    ifeq ($(origin $1), default)
        override $(1) := $(2)
    endif
    ifeq ($(origin $1), undefined)
        override $(1) := $(2)
    endif
endef

$(eval $(call DEFAULT_VAR,CC,cc))

# Target identification
ARCH ?= x86_64

# Default CFLAGS
CFLAGS ?= -g -O2 -pipe -Wall -Wextra

# Generic compilation flags

override CPPFLAGS += -I../inc -I../inc/$(ARCH) -I../inc/protocol

override CFLAGS += \
    -std=gnu11 \
    -ffreestanding \
    -fno-stack-protector \
    -fno-stack-check \
    -fno-strict-aliasing \
    -fshort-wchar \
    -fno-lto \
    -fpie

# Arch-specific compilation flags

ifeq ($(ARCH),ia32)
    override CFLAGS += \
        -m32 \
        -march=i686 \
        -mabi=sysv \
        -mno-80387
endif

ifeq ($(ARCH),x86_64)
    override CFLAGS += \
        -m64 \
        -march=x86-64 \
        -mabi=sysv \
        -mno-80387 \
        -mno-mmx \
        -mno-sse \
        -mno-sse2 \
        -mno-red-zone
    override CPPFLAGS += -DGNU_EFI_USE_MS_ABI
endif

ifeq ($(ARCH),aarch64)
    override CFLAGS += \
        -fno-jump-tables \
        -mgeneral-regs-only
endif

override OBJS := crt0-efi-$(ARCH).o reloc_$(ARCH).o

all: $(OBJS)

%.o: %.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

%.o: %.S
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS)
