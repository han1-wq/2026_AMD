// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
// Tool Version Limit: 2022.04
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef XYOLO_POSTPROCESS_H
#define XYOLO_POSTPROCESS_H

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
#include "xyolo_postprocess_hw.h"

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
} XYolo_postprocess_Config;
#endif

typedef struct {
    u64 Control_BaseAddress;
    u32 IsReady;
} XYolo_postprocess;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XYolo_postprocess_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XYolo_postprocess_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XYolo_postprocess_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XYolo_postprocess_ReadReg(BaseAddress, RegOffset) \
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
int XYolo_postprocess_Initialize(XYolo_postprocess *InstancePtr, u16 DeviceId);
XYolo_postprocess_Config* XYolo_postprocess_LookupConfig(u16 DeviceId);
int XYolo_postprocess_CfgInitialize(XYolo_postprocess *InstancePtr, XYolo_postprocess_Config *ConfigPtr);
#else
int XYolo_postprocess_Initialize(XYolo_postprocess *InstancePtr, const char* InstanceName);
int XYolo_postprocess_Release(XYolo_postprocess *InstancePtr);
#endif

void XYolo_postprocess_Start(XYolo_postprocess *InstancePtr);
u32 XYolo_postprocess_IsDone(XYolo_postprocess *InstancePtr);
u32 XYolo_postprocess_IsIdle(XYolo_postprocess *InstancePtr);
u32 XYolo_postprocess_IsReady(XYolo_postprocess *InstancePtr);
void XYolo_postprocess_EnableAutoRestart(XYolo_postprocess *InstancePtr);
void XYolo_postprocess_DisableAutoRestart(XYolo_postprocess *InstancePtr);
u32 XYolo_postprocess_Get_return(XYolo_postprocess *InstancePtr);

void XYolo_postprocess_Set_input_r(XYolo_postprocess *InstancePtr, u64 Data);
u64 XYolo_postprocess_Get_input_r(XYolo_postprocess *InstancePtr);
void XYolo_postprocess_Set_tables(XYolo_postprocess *InstancePtr, u64 Data);
u64 XYolo_postprocess_Get_tables(XYolo_postprocess *InstancePtr);
void XYolo_postprocess_Set_output_r(XYolo_postprocess *InstancePtr, u64 Data);
u64 XYolo_postprocess_Get_output_r(XYolo_postprocess *InstancePtr);
void XYolo_postprocess_Set_input_words(XYolo_postprocess *InstancePtr, u32 Data);
u32 XYolo_postprocess_Get_input_words(XYolo_postprocess *InstancePtr);
void XYolo_postprocess_Set_table_words(XYolo_postprocess *InstancePtr, u32 Data);
u32 XYolo_postprocess_Get_table_words(XYolo_postprocess *InstancePtr);
void XYolo_postprocess_Set_output_capacity(XYolo_postprocess *InstancePtr, u32 Data);
u32 XYolo_postprocess_Get_output_capacity(XYolo_postprocess *InstancePtr);
void XYolo_postprocess_Set_confidence_q30(XYolo_postprocess *InstancePtr, u32 Data);
u32 XYolo_postprocess_Get_confidence_q30(XYolo_postprocess *InstancePtr);
void XYolo_postprocess_Set_nms_q16(XYolo_postprocess *InstancePtr, u32 Data);
u32 XYolo_postprocess_Get_nms_q16(XYolo_postprocess *InstancePtr);
void XYolo_postprocess_Set_enable_nms(XYolo_postprocess *InstancePtr, u32 Data);
u32 XYolo_postprocess_Get_enable_nms(XYolo_postprocess *InstancePtr);
u32 XYolo_postprocess_Get_candidate_count(XYolo_postprocess *InstancePtr);
u32 XYolo_postprocess_Get_candidate_count_vld(XYolo_postprocess *InstancePtr);
u32 XYolo_postprocess_Get_detection_count(XYolo_postprocess *InstancePtr);
u32 XYolo_postprocess_Get_detection_count_vld(XYolo_postprocess *InstancePtr);

void XYolo_postprocess_InterruptGlobalEnable(XYolo_postprocess *InstancePtr);
void XYolo_postprocess_InterruptGlobalDisable(XYolo_postprocess *InstancePtr);
void XYolo_postprocess_InterruptEnable(XYolo_postprocess *InstancePtr, u32 Mask);
void XYolo_postprocess_InterruptDisable(XYolo_postprocess *InstancePtr, u32 Mask);
void XYolo_postprocess_InterruptClear(XYolo_postprocess *InstancePtr, u32 Mask);
u32 XYolo_postprocess_InterruptGetEnabled(XYolo_postprocess *InstancePtr);
u32 XYolo_postprocess_InterruptGetStatus(XYolo_postprocess *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
