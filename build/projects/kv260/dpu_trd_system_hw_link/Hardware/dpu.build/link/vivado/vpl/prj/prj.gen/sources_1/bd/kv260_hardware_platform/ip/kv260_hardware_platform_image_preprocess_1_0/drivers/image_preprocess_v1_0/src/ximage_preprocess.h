// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
// Tool Version Limit: 2022.04
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef XIMAGE_PREPROCESS_H
#define XIMAGE_PREPROCESS_H

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files *********************************/
#ifndef __linux__
#include "xil_types.h"
#include "xil_assert.h"
#include "xstatus.h"
#include "xil_io.h"
#else
#include <stdint.h>
#include <assert.h>
#include <dirent.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stddef.h>
#endif
#include "ximage_preprocess_hw.h"

/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;
#else
typedef struct {
    u16 DeviceId;
    u64 Control_BaseAddress;
} XImage_preprocess_Config;
#endif

typedef struct {
    u64 Control_BaseAddress;
    u32 IsReady;
} XImage_preprocess;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XImage_preprocess_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XImage_preprocess_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XImage_preprocess_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XImage_preprocess_ReadReg(BaseAddress, RegOffset) \
    *(volatile u32*)((BaseAddress) + (RegOffset))

#define Xil_AssertVoid(expr)    assert(expr)
#define Xil_AssertNonvoid(expr) assert(expr)

#define XST_SUCCESS             0
#define XST_DEVICE_NOT_FOUND    2
#define XST_OPEN_DEVICE_FAILED  3
#define XIL_COMPONENT_IS_READY  1
#endif

/************************** Function Prototypes *****************************/
#ifndef __linux__
int XImage_preprocess_Initialize(XImage_preprocess *InstancePtr, u16 DeviceId);
XImage_preprocess_Config* XImage_preprocess_LookupConfig(u16 DeviceId);
int XImage_preprocess_CfgInitialize(XImage_preprocess *InstancePtr, XImage_preprocess_Config *ConfigPtr);
#else
int XImage_preprocess_Initialize(XImage_preprocess *InstancePtr, const char* InstanceName);
int XImage_preprocess_Release(XImage_preprocess *InstancePtr);
#endif

void XImage_preprocess_Start(XImage_preprocess *InstancePtr);
u32 XImage_preprocess_IsDone(XImage_preprocess *InstancePtr);
u32 XImage_preprocess_IsIdle(XImage_preprocess *InstancePtr);
u32 XImage_preprocess_IsReady(XImage_preprocess *InstancePtr);
void XImage_preprocess_EnableAutoRestart(XImage_preprocess *InstancePtr);
void XImage_preprocess_DisableAutoRestart(XImage_preprocess *InstancePtr);
u32 XImage_preprocess_Get_return(XImage_preprocess *InstancePtr);

void XImage_preprocess_Set_src(XImage_preprocess *InstancePtr, u64 Data);
u64 XImage_preprocess_Get_src(XImage_preprocess *InstancePtr);
void XImage_preprocess_Set_tensor(XImage_preprocess *InstancePtr, u64 Data);
u64 XImage_preprocess_Get_tensor(XImage_preprocess *InstancePtr);
void XImage_preprocess_Set_preview(XImage_preprocess *InstancePtr, u64 Data);
u64 XImage_preprocess_Get_preview(XImage_preprocess *InstancePtr);
void XImage_preprocess_Set_luts(XImage_preprocess *InstancePtr, u64 Data);
u64 XImage_preprocess_Get_luts(XImage_preprocess *InstancePtr);
void XImage_preprocess_Set_width(XImage_preprocess *InstancePtr, u32 Data);
u32 XImage_preprocess_Get_width(XImage_preprocess *InstancePtr);
void XImage_preprocess_Set_height(XImage_preprocess *InstancePtr, u32 Data);
u32 XImage_preprocess_Get_height(XImage_preprocess *InstancePtr);
void XImage_preprocess_Set_src_stride(XImage_preprocess *InstancePtr, u32 Data);
u32 XImage_preprocess_Get_src_stride(XImage_preprocess *InstancePtr);
void XImage_preprocess_Set_src_capacity(XImage_preprocess *InstancePtr, u32 Data);
u32 XImage_preprocess_Get_src_capacity(XImage_preprocess *InstancePtr);
void XImage_preprocess_Set_tensor_capacity(XImage_preprocess *InstancePtr, u32 Data);
u32 XImage_preprocess_Get_tensor_capacity(XImage_preprocess *InstancePtr);
void XImage_preprocess_Set_preview_stride(XImage_preprocess *InstancePtr, u32 Data);
u32 XImage_preprocess_Get_preview_stride(XImage_preprocess *InstancePtr);
void XImage_preprocess_Set_preview_capacity(XImage_preprocess *InstancePtr, u32 Data);
u32 XImage_preprocess_Get_preview_capacity(XImage_preprocess *InstancePtr);
void XImage_preprocess_Set_resized_w(XImage_preprocess *InstancePtr, u32 Data);
u32 XImage_preprocess_Get_resized_w(XImage_preprocess *InstancePtr);
void XImage_preprocess_Set_resized_h(XImage_preprocess *InstancePtr, u32 Data);
u32 XImage_preprocess_Get_resized_h(XImage_preprocess *InstancePtr);
void XImage_preprocess_Set_pad_x(XImage_preprocess *InstancePtr, u32 Data);
u32 XImage_preprocess_Get_pad_x(XImage_preprocess *InstancePtr);
void XImage_preprocess_Set_pad_y(XImage_preprocess *InstancePtr, u32 Data);
u32 XImage_preprocess_Get_pad_y(XImage_preprocess *InstancePtr);
void XImage_preprocess_Set_output_mode(XImage_preprocess *InstancePtr, u32 Data);
u32 XImage_preprocess_Get_output_mode(XImage_preprocess *InstancePtr);
void XImage_preprocess_Set_flags(XImage_preprocess *InstancePtr, u32 Data);
u32 XImage_preprocess_Get_flags(XImage_preprocess *InstancePtr);
void XImage_preprocess_Set_eq_mode(XImage_preprocess *InstancePtr, u32 Data);
u32 XImage_preprocess_Get_eq_mode(XImage_preprocess *InstancePtr);
void XImage_preprocess_Set_saturation_q12(XImage_preprocess *InstancePtr, u32 Data);
u32 XImage_preprocess_Get_saturation_q12(XImage_preprocess *InstancePtr);
void XImage_preprocess_Set_frame_id(XImage_preprocess *InstancePtr, u32 Data);
u32 XImage_preprocess_Get_frame_id(XImage_preprocess *InstancePtr);
void XImage_preprocess_Set_config_id(XImage_preprocess *InstancePtr, u32 Data);
u32 XImage_preprocess_Get_config_id(XImage_preprocess *InstancePtr);
u32 XImage_preprocess_Get_completed_frame_id(XImage_preprocess *InstancePtr);
u32 XImage_preprocess_Get_completed_frame_id_vld(XImage_preprocess *InstancePtr);
u32 XImage_preprocess_Get_completed_config_id(XImage_preprocess *InstancePtr);
u32 XImage_preprocess_Get_completed_config_id_vld(XImage_preprocess *InstancePtr);
u32 XImage_preprocess_Get_tensor_bytes(XImage_preprocess *InstancePtr);
u32 XImage_preprocess_Get_tensor_bytes_vld(XImage_preprocess *InstancePtr);
u32 XImage_preprocess_Get_preview_bytes(XImage_preprocess *InstancePtr);
u32 XImage_preprocess_Get_preview_bytes_vld(XImage_preprocess *InstancePtr);
u32 XImage_preprocess_Get_abi_version(XImage_preprocess *InstancePtr);
u32 XImage_preprocess_Get_abi_version_vld(XImage_preprocess *InstancePtr);

void XImage_preprocess_InterruptGlobalEnable(XImage_preprocess *InstancePtr);
void XImage_preprocess_InterruptGlobalDisable(XImage_preprocess *InstancePtr);
void XImage_preprocess_InterruptEnable(XImage_preprocess *InstancePtr, u32 Mask);
void XImage_preprocess_InterruptDisable(XImage_preprocess *InstancePtr, u32 Mask);
void XImage_preprocess_InterruptClear(XImage_preprocess *InstancePtr, u32 Mask);
u32 XImage_preprocess_InterruptGetEnabled(XImage_preprocess *InstancePtr);
u32 XImage_preprocess_InterruptGetStatus(XImage_preprocess *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
