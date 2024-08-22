/*
 * Copyright (C) 2014 - 2015 Linaro Ltd.
 * Author: Ard Biesheuvel <ard.biesheuvel@linaro.org>
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

#ifndef EFI_AARCH64_EFIBIND_H_
#define EFI_AARCH64_EFIBIND_H_

#include <stdint.h>

//
// Basic EFI types of various widths
//

#include <stddef.h>

typedef wchar_t CHAR16;
#define WCHAR CHAR16

typedef uint64_t   UINT64;
typedef int64_t    INT64;

typedef uint32_t   UINT32;
typedef int32_t    INT32;

typedef uint16_t   UINT16;
typedef int16_t    INT16;

typedef uint8_t    UINT8;
typedef char       CHAR8;
typedef int8_t     INT8;

#undef VOID
typedef void       VOID;

typedef int64_t    INTN;
typedef uint64_t   UINTN;

#define EFIERR(a)           (0x8000000000000000 | a)
#define EFI_ERROR_MASK      0x8000000000000000
#define EFIERR_OEM(a)       (0xc000000000000000 | a)

#define BAD_POINTER         0xFBFBFBFBFBFBFBFB
#define MAX_ADDRESS         0xFFFFFFFFFFFFFFFF

#define BREAKPOINT()        while (TRUE);    // Make it hang on Bios[Dbg]32

//
// Pointers must be aligned to these address to function
//

#define MIN_ALIGNMENT_SIZE  8

#define ALIGN_VARIABLE(Value ,Adjustment) \
            (UINTN)Adjustment = 0; \
            if((UINTN)Value % MIN_ALIGNMENT_SIZE) \
                (UINTN)Adjustment = MIN_ALIGNMENT_SIZE - ((UINTN)Value % MIN_ALIGNMENT_SIZE); \
            Value = (UINTN)Value + (UINTN)Adjustment


//
// Define macros to build data structure signatures from characters.
//

#define EFI_SIGNATURE_16(A,B)             ((A) | (B<<8))
#define EFI_SIGNATURE_32(A,B,C,D)         (EFI_SIGNATURE_16(A,B)     | (EFI_SIGNATURE_16(C,D)     << 16))
#define EFI_SIGNATURE_64(A,B,C,D,E,F,G,H) (EFI_SIGNATURE_32(A,B,C,D) | ((UINT64)(EFI_SIGNATURE_32(E,F,G,H)) << 32))

//
// EFIAPI - prototype calling convention for EFI function pointers
//

#ifndef EFIAPI          // Forces EFI calling conventions reguardless of compiler options
#define EFIAPI          // Substitute expresion to force C calling convention
#endif


#define VOLATILE                volatile

#define MEMORY_FENCE            __sync_synchronize


//
// Some compilers don't support the forward reference construct:
//  typedef struct XXXXX
//
// The following macro provide a workaround for such cases.

#define INTERFACE_DECL(x) struct x

#define EFI_FUNCTION

#endif
