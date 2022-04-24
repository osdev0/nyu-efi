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

$(eval $(call DEFAULT_VAR,CC,gcc))
$(eval $(call DEFAULT_VAR,AR,ar))

# Target identification
ARCH ?= x86_64

# Arch-specific compilation flags

ifeq ($(ARCH),ia64)
	override CFLAGS += -mfixed-range=f32-f127
endif

ifeq ($(ARCH),ia32)
	override CFLAGS += -mno-80387 -mno-mmx -mno-sse -m32
endif

ifeq ($(ARCH),x86_64)
	override CFLAGS += -mno-80387 -mno-mmx -mno-sse -mno-sse2 -mno-red-zone \
	                   -mabi=sysv -m64
	override CPPFLAGS += -DGNU_EFI_USE_MS_ABI
endif

ifeq ($(ARCH),mips64el)
	override CFLAGS += -march=mips64r2 -mabi=64
endif

ifeq ($(ARCH),arm)
	override CFLAGS += -marm
endif

ifeq ($(ARCH),aarch64)
	override CFLAGS += -fno-jump-tables
endif

# Generic compilation flags

override INCDIR += -I../inc -I../inc/$(ARCH) -I../inc/protocol

override CFLAGS += -g -O2 -Wall -Wextra -Werror \
                   -std=gnu11 -Wno-error=pragmas -fpie -fno-lto \
                   -fshort-wchar -fno-strict-aliasing \
                   -ffreestanding -fno-stack-protector -fno-stack-check

override ARFLAGS := rDv

override FILES := reloc_$(ARCH)
override OBJS := $(FILES:%=%.o)

override TARGETS := crt0-efi-$(ARCH).o libgnuefi.a

all: $(TARGETS)

libgnuefi.a: $(OBJS)
	$(AR) $(ARFLAGS) $@ $^

%.o: %.c
	$(CC) $(INCDIR) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

%.o: %.S
	$(CC) $(INCDIR) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

clean:
	rm -f $(TARGETS) $(OBJS)
