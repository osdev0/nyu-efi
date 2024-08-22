/*++

Copyright (c) 1998  Intel Corporation

Module Name:

    efi.h

Abstract:

    Public EFI header files



Revision History

--*/


// Add a predefined macro to detect usage of the library
#ifndef _GNU_EFI
#define _GNU_EFI
#endif

//
// Build flags on input
//  EFI32
//  EFI_DEBUG               - Enable debugging code
//  EFI_NT_EMULATOR         - Building for running under NT
//


#ifndef EFI_H_
#define EFI_H_

#ifdef __cplusplus
extern "C" {
#endif

#define EFI_FIRMWARE_VENDOR         L"INTEL"
#define EFI_FIRMWARE_MAJOR_REVISION 12
#define EFI_FIRMWARE_MINOR_REVISION 33
#define EFI_FIRMWARE_REVISION ((EFI_FIRMWARE_MAJOR_REVISION <<16) | (EFI_FIRMWARE_MINOR_REVISION))

#if defined(_M_X64) || defined(__x86_64__) || defined(__amd64__)
#include "efi/x86_64/efibind.h"
#elif defined(_M_IX86) || defined(__i386__)
#include "efi/ia32/efibind.h"
#elif defined (_M_ARM64) || defined(__aarch64__)
#include "efi/aarch64/efibind.h"
#elif defined (__riscv) && __riscv_xlen == 64
#include "efi/riscv64/efibind.h"
#elif defined (__loongarch64)
#include "efi/loongarch64/efibind.h"
#else
#error Unsupported architecture
#endif

#include "efi/eficompiler.h"
#include "efi/efidef.h"
#include "efi/efidevp.h"
#include "efi/efipciio.h"
#include "efi/efiprot.h"
#include "efi/eficon.h"
#include "efi/eficonex.h"
#include "efi/efiser.h"
#include "efi/efi_nii.h"
#include "efi/efipxebc.h"
#include "efi/efinet.h"
#include "efi/efiapi.h"
#include "efi/efifs.h"
#include "efi/efierr.h"
#include "efi/efiui.h"
#include "efi/efimp.h"
#include "efi/efiip.h"
#include "efi/efiudp.h"
#include "efi/efitcp.h"
#include "efi/efipoint.h"
#include "efi/efishell.h"

#ifdef __cplusplus
}
#endif

#endif
