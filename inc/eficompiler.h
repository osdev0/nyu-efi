/*++

Copyright (c) 2016 Pete Batard <pete@akeo.ie>

Module Name:

    eficompiler.h

Abstract:

    Compiler specific adjustments

--*/

#define EFI_UNUSED __attribute__((__unused__))

#define ALIGN(x) __attribute__((__aligned__(x)))
