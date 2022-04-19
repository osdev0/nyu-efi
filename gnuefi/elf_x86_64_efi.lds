OUTPUT_FORMAT(elf64-x86-64)
OUTPUT_ARCH(i386:x86-64)
ENTRY(_start)

PHDRS
{
    null    PT_NULL    FLAGS(0) ;
    segm    PT_LOAD    FLAGS(7) ;
    dynamic PT_DYNAMIC FLAGS(7) ;
}

SECTIONS
{
  . = 0;
  __image_base = .;

  .sect : {
      *(.pe_header)

      . = ALIGN(0x1000);

      __text_start = .;
      *(.text .text.*)
      . = ALIGN(0x1000);
      __text_end = .;
      __text_size = __text_end - __text_start;

      __reloc_start = .;
      *(.reloc)
      . = ALIGN(0x1000);
      __reloc_end = .;
      __reloc_size = __reloc_end - __reloc_start;

      __sbat_start = .;
      *(.sbat)
      . = ALIGN(0x1000);
      __sbat_end = .;
      __sbat_size = __sbat_end - __sbat_start;

      __data_start = .;
      *(.data .data.*)
      *(.rodata .rodata.*)
      *(COMMON)
      *(.bss .bss.*)
      . = ALIGN(0x1000);
      __data_size = __data_end - __data_start;
  } :segm

  .dynamic : {
      *(.dynamic)
      . = ALIGN(0x1000);

      __data_end = .;

      __image_end = .;
      __image_size = __image_end - __image_base;
  } :segm :dynamic

  .symtab : {
      *(.symtab)
  } :null

  .strtab : {
      *(.strtab)
  } :null

  .shstrtab : {
      *(.shstrtab)
  } :null

  /DISCARD/ : {
      *(*)
  }
}
