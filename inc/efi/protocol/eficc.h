#ifndef EFI_PROTOCOL_EFICC_H_
#define EFI_PROTOCOL_EFICC_H_

/*++

Module Name:

    eficc.h

Abstract:

    EFI_CC_MEASUREMENT_PROTOCOL

    Confidential Computing measurement protocol -- exposed by firmware on
    platforms such as AMD SEV-SNP and Intel TDX where measurements are
    extended into platform Memory Reference (MR) registers rather than
    TPM PCRs. Event log format mirrors TCG 2.0.

--*/

#define EFI_CC_MEASUREMENT_PROTOCOL_GUID \
    { 0x96751a3d, 0x72f4, 0x41a6, {0xa7, 0x94, 0xed, 0x5d, 0x0e, 0x67, 0xae, 0x6b} }

#define EFI_CC_FINAL_EVENTS_TABLE_GUID \
    { 0xdd4a4648, 0x2de7, 0x4665, {0x96, 0x4d, 0x21, 0xd9, 0xef, 0x5f, 0xb4, 0x46} }

typedef UINT32 EFI_CC_MR_INDEX;
typedef UINT32 EFI_CC_EVENT_LOG_BITMAP;
typedef UINT32 EFI_CC_EVENT_LOG_FORMAT;
typedef UINT32 EFI_CC_EVENT_ALGORITHM_BITMAP;

#define EFI_CC_EVENT_LOG_FORMAT_TCG_2  0x00000002

#define EFI_CC_BOOT_HASH_ALG_SHA384    0x00000004

typedef struct {
    UINT8 Major;
    UINT8 Minor;
} EFI_CC_VERSION;

typedef struct {
    UINT8 Type;
    UINT8 SubType;
} EFI_CC_TYPE;

#define EFI_CC_TYPE_NONE       0
#define EFI_CC_TYPE_AMD_SEV    1
#define EFI_CC_TYPE_INTEL_TDX  2

typedef struct {
    UINT8                          Size;
    EFI_CC_VERSION                 StructureVersion;
    EFI_CC_VERSION                 ProtocolVersion;
    EFI_CC_EVENT_ALGORITHM_BITMAP  HashAlgorithmBitmap;
    EFI_CC_EVENT_LOG_BITMAP        SupportedEventLogs;
    EFI_CC_TYPE                    CcType;
} EFI_CC_BOOT_SERVICE_CAPABILITY;

#define EFI_CC_EVENT_HEADER_VERSION 1

#pragma pack(1)

typedef struct {
    UINT32           HeaderSize;
    UINT16           HeaderVersion;
    EFI_CC_MR_INDEX  MrIndex;
    UINT32           EventType;
} EFI_CC_EVENT_HEADER;

typedef struct {
    UINT32               Size;
    EFI_CC_EVENT_HEADER  Header;
    UINT8                Event[1];
} EFI_CC_EVENT;

#pragma pack()

INTERFACE_DECL(_EFI_CC_MEASUREMENT_PROTOCOL);

typedef
EFI_STATUS
(EFIAPI *EFI_CC_GET_CAPABILITY) (
    IN  struct _EFI_CC_MEASUREMENT_PROTOCOL    *This,
    IN OUT EFI_CC_BOOT_SERVICE_CAPABILITY      *ProtocolCapability
    );

typedef
EFI_STATUS
(EFIAPI *EFI_CC_GET_EVENT_LOG) (
    IN  struct _EFI_CC_MEASUREMENT_PROTOCOL  *This,
    IN  EFI_CC_EVENT_LOG_FORMAT              EventLogFormat,
    OUT EFI_PHYSICAL_ADDRESS                 *EventLogLocation,
    OUT EFI_PHYSICAL_ADDRESS                 *EventLogLastEntry,
    OUT BOOLEAN                              *EventLogTruncated
    );

typedef
EFI_STATUS
(EFIAPI *EFI_CC_HASH_LOG_EXTEND_EVENT) (
    IN  struct _EFI_CC_MEASUREMENT_PROTOCOL  *This,
    IN  UINT64                               Flags,
    IN  EFI_PHYSICAL_ADDRESS                 DataToHash,
    IN  UINT64                               DataToHashLen,
    IN  EFI_CC_EVENT                         *EfiCcEvent
    );

typedef
EFI_STATUS
(EFIAPI *EFI_CC_MAP_PCR_TO_MR_INDEX) (
    IN  struct _EFI_CC_MEASUREMENT_PROTOCOL  *This,
    IN  UINT32                               PcrIndex,
    OUT EFI_CC_MR_INDEX                      *MrIndex
    );

typedef struct _EFI_CC_MEASUREMENT_PROTOCOL {
    EFI_CC_GET_CAPABILITY         GetCapability;
    EFI_CC_GET_EVENT_LOG          GetEventLog;
    EFI_CC_HASH_LOG_EXTEND_EVENT  HashLogExtendEvent;
    EFI_CC_MAP_PCR_TO_MR_INDEX    MapPcrToMrIndex;
} EFI_CC_MEASUREMENT_PROTOCOL;

#endif
