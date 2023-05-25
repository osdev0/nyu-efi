/*
 * Copright (C) 2023 xvanc
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

#define RISCV_EFI_BOOT_PROTOCOL_GUID \
    { 0xccd15fec, 0x6f73, 0x4eec, \
    { 0x83, 0x95, 0x3e, 0x69, 0xe4, 0xb9, 0x40, 0xbf } }

#define RISCV_EFI_BOOT_PROTOCOL_REVISION 0x00010000
#define RISCV_EFI_BOOT_PROTOCOL_LATEST_VERSION \
    RISCV_EFI_BOOT_PROTOCOL_REVISION

struct _RISCV_EFI_BOOT_PROTOCOL;

typedef EFI_STATUS
(EFIAPI *EFI_GET_BOOT_HARTID) (
    IN struct _RISCV_EFI_BOOT_PROTOCOL *This,
    OUT UINTN                          *BootHartId
    );

typedef struct _RISCV_EFI_BOOT_PROTOCOL {
    UINT64                Revision;
    EFI_GET_BOOT_HARTID   GetBootHartId;
} RISCV_EFI_BOOT_PROTOCOL;
