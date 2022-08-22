/*
 * crt0-efi-aarch64.S - PE/COFF header for AArch64 EFI applications
 *
 * Copyright (C) 2014 Linaro Ltd. <ard.biesheuvel@linaro.org>
 * Copyright (C) 2022 Mintsuki
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice and this list of conditions, without modification.
 * 2. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * Alternatively, this software may be distributed under the terms of the
 * GNU General Public License as published by the Free Software Foundation;
 * either version 2 of the License, or (at your option) any later version.
 */

.section .pe_header
  mz_stub:
    .short 0x5a4d, 0x0090, 0x0003, 0x0000, 0x0004, 0x0000, 0xffff, 0x0000
    .short 0x00b8, 0x0000, 0x0000, 0x0000, 0x0040, 0x0000, 0x0000, 0x0000
    .short 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
    .short 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0080, 0x0000
    .byte 0x0e, 0x1f, 0xba, 0x0e, 0x00, 0xb4, 0x09, 0xcd, 0x21, 0xb8, 0x01
    .byte 0x4c, 0xcd, 0x21, 0x54, 0x68, 0x69, 0x73, 0x20, 0x70, 0x72, 0x6f
    .byte 0x67, 0x72, 0x61, 0x6d, 0x20, 0x63, 0x61, 0x6e, 0x6e, 0x6f, 0x74
    .byte 0x20, 0x62, 0x65, 0x20, 0x72, 0x75, 0x6e, 0x20, 0x69, 0x6e, 0x20
    .byte 0x44, 0x4f, 0x53, 0x20, 0x6d, 0x6f, 0x64, 0x65, 0x2e, 0x0d, 0x0d
    .byte 0x0a, 0x24, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

  pe_header:
    .long 0x00004550 // magic
    .short 0xaa64    // machine
    .short 0x0004    // section #
    .long 0          // timestamp
    .long 0          // symbol table ptr
    .long 0          // symbol #
    .short data_dirs_end - opt_header // opt header size
    .short 0x0206    // characteristics

  opt_header:
    .short 0x020b      // magic
    .byte 0x02         // maj linker ver
    .byte 0x26         // min linker ver
    .long __text_size  // code size
    .long __data_size  // data size
    .long 0            // uninitialised data size
    .long _start       // entry point
    .long __text_start // code base
    .quad __image_base // image base
    .long 0x1000       // section alignment
    .long 0x1000       // file alignment
    .short 0           // OS maj
    .short 0           // OS min
    .short 0           // image maj
    .short 0           // image min
    .short 0           // subsystem maj
    .short 0           // subsystem min
    .long 0            // win32 ver
    .long __image_size // image size
    .long __text_start // headers size
    .long 0            // checksum
    .short 0x0a        // subsystem
    .short 0           // dll characteristics
    .quad 0            // stack reserve size
    .quad 0            // stack commit size
    .quad 0            // heap reserve size
    .quad 0            // heap commit size
    .long 0            // loader flags
    .long 6            // rvas and size count
  opt_header_end:

  data_dirs:
    // export table
    .long 0, 0

    // import table
    .long 0, 0

    // resource table
    .long 0, 0

    // exception table
    .long 0, 0

    // certificate table
    .long 0, 0

    // base relocation table
    .long reloc, 12
  data_dirs_end:

  sect_table:
    .ascii ".text\0\0\0" // name
    .long __text_size    // virtual size
    .long __text_start   // rva
    .long __text_size    // file size
    .long __text_start   // file location
    .long 0              // relocs
    .long 0              // line nums
    .short 0             // relocs count
    .short 0             // line nums count
    .long 0x60000020     // characteristics

    .ascii ".sbat\0\0\0" // name
    .long __sbat_sizev   // virtual size
    .long __sbat_start   // rva
    .long __sbat_size    // file size
    .long __sbat_start   // file location
    .long 0              // relocs
    .long 0              // line nums
    .short 0             // relocs count
    .short 0             // line nums count
    .long 0x40000000     // characteristics

    .ascii ".reloc\0\0"  // name
    .long 12             // virtual size
    .long reloc          // rva
    .long 0x1000         // file size
    .long reloc          // file location
    .long 0              // relocs
    .long 0              // line nums
    .short 0             // relocs count
    .short 0             // line nums count
    .long 0x42000040     // characteristics

    .ascii ".data\0\0\0" // name
    .long __data_size    // virtual size
    .long __data_start   // rva
    .long __data_size    // file size
    .long __data_start   // file location
    .long 0              // relocs
    .long 0              // line nums
    .short 0             // relocs count
    .short 0             // line nums count
    .long 0xc0000040     // characteristics

.section .text
  .align 12
  .globl _start
  _start:
    stp x29, x30, [sp, #-32]!
    mov x29, sp

    stp x0, x1, [sp, #16]
    mov x2, x0
    mov x3, x1
    adr x0, __image_base
    adrp x1, _DYNAMIC
    add x1, x1, #:lo12:_DYNAMIC
    bl __relocate
    cbnz x0, 0f

    ldp x0, x1, [sp, #16]
    bl efi_main

0:
    ldp x29, x30, [sp], #32
    ret

// hand-craft a dummy .reloc section so EFI knows it's a relocatable executable:

.section .data
  .align 12
    dummy: .long 0

.section .data.reloc
    reloc:
      .long dummy - reloc // Page RVA
      .long 12            // Block Size (2*4+2*2), must be aligned by 32 Bits
      .long 0             // reloc for dummy
