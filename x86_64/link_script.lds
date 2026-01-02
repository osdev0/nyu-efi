/* Copyright (C) 2021-2026 Mintsuki and contributors.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

OUTPUT_FORMAT(elf64-x86-64)
ENTRY(_start)

PHDRS
{
    text    PT_LOAD    FLAGS(0x05);
    rodata  PT_LOAD    FLAGS(0x04);
    data    PT_LOAD    FLAGS(0x06);
    dynamic PT_DYNAMIC FLAGS(0x06);
}

SECTIONS
{
    . = 0;
    __slide = .;
    __image_base = ABSOLUTE(.);
    __image_size = ABSOLUTE(__image_end - __image_base);

    .text : {
        KEEP(*(.pe_header))

        . = ALIGN(0x1000);

        __text_start = ABSOLUTE(.);
        *(.text .text.*)
    } :text

    . = ALIGN(0x1000);
    __text_end = ABSOLUTE(.);
    __text_size = ABSOLUTE(__text_end - __text_start);

    .rodata : {
        __reloc_start = ABSOLUTE(.);
        *(.dummy_reloc)

        . = ALIGN(0x1000);
        __reloc_end = ABSOLUTE(.);
        __reloc_size = ABSOLUTE(__reloc_end - __reloc_start);

        __data_start = ABSOLUTE(.);
        *(.rodata .rodata.*)
    } :rodata

    .data : {
        *(.data .data.*)
    } :data

    .bss : {
        *(.bss .bss.*)
        *(COMMON)
    } :data

    .dynamic : {
        *(.dynamic)
    } :data :dynamic

    __data_end = ABSOLUTE(ALIGN(0x1000));
    __data_size = ABSOLUTE(__data_end - __data_start);

    __image_end = ABSOLUTE(ALIGN(0x1000));

    /DISCARD/ : {
        *(.eh_frame*)
        *(.note .note.*)
        *(.interp)
    }
}
