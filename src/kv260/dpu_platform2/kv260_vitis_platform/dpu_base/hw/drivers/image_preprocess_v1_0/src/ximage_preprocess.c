// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
// Tool Version Limit: 2022.04
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// ==============================================================
/***************************** Include Files *********************************/
#include "ximage_preprocess.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XImage_preprocess_CfgInitialize(XImage_preprocess *InstancePtr, XImage_preprocess_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XImage_preprocess_Start(XImage_preprocess *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_AP_CTRL) & 0x80;
    XImage_preprocess_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XImage_preprocess_IsDone(XImage_preprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XImage_preprocess_IsIdle(XImage_preprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XImage_preprocess_IsReady(XImage_preprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XImage_preprocess_EnableAutoRestart(XImage_preprocess *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XImage_preprocess_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_AP_CTRL, 0x80);
}

void XImage_preprocess_DisableAutoRestart(XImage_preprocess *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XImage_preprocess_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_AP_CTRL, 0);
}

u32 XImage_preprocess_Get_return(XImage_preprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_AP_RETURN);
    return Data;
}
void XImage_preprocess_Set_src(XImage_preprocess *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XImage_preprocess_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_SRC_DATA, (u32)(Data));
    XImage_preprocess_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_SRC_DATA + 4, (u32)(Data >> 32));
}

u64 XImage_preprocess_Get_src(XImage_preprocess *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_SRC_DATA);
    Data += (u64)XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_SRC_DATA + 4) << 32;
    return Data;
}

void XImage_preprocess_Set_tensor(XImage_preprocess *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XImage_preprocess_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_TENSOR_DATA, (u32)(Data));
    XImage_preprocess_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_TENSOR_DATA + 4, (u32)(Data >> 32));
}

u64 XImage_preprocess_Get_tensor(XImage_preprocess *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_TENSOR_DATA);
    Data += (u64)XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_TENSOR_DATA + 4) << 32;
    return Data;
}

void XImage_preprocess_Set_preview(XImage_preprocess *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XImage_preprocess_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_PREVIEW_DATA, (u32)(Data));
    XImage_preprocess_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_PREVIEW_DATA + 4, (u32)(Data >> 32));
}

u64 XImage_preprocess_Get_preview(XImage_preprocess *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_PREVIEW_DATA);
    Data += (u64)XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_PREVIEW_DATA + 4) << 32;
    return Data;
}

void XImage_preprocess_Set_luts(XImage_preprocess *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XImage_preprocess_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_LUTS_DATA, (u32)(Data));
    XImage_preprocess_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_LUTS_DATA + 4, (u32)(Data >> 32));
}

u64 XImage_preprocess_Get_luts(XImage_preprocess *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_LUTS_DATA);
    Data += (u64)XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_LUTS_DATA + 4) << 32;
    return Data;
}

void XImage_preprocess_Set_width(XImage_preprocess *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XImage_preprocess_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_WIDTH_DATA, Data);
}

u32 XImage_preprocess_Get_width(XImage_preprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_WIDTH_DATA);
    return Data;
}

void XImage_preprocess_Set_height(XImage_preprocess *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XImage_preprocess_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_HEIGHT_DATA, Data);
}

u32 XImage_preprocess_Get_height(XImage_preprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_HEIGHT_DATA);
    return Data;
}

void XImage_preprocess_Set_src_stride(XImage_preprocess *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XImage_preprocess_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_SRC_STRIDE_DATA, Data);
}

u32 XImage_preprocess_Get_src_stride(XImage_preprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_SRC_STRIDE_DATA);
    return Data;
}

void XImage_preprocess_Set_src_capacity(XImage_preprocess *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XImage_preprocess_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_SRC_CAPACITY_DATA, Data);
}

u32 XImage_preprocess_Get_src_capacity(XImage_preprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_SRC_CAPACITY_DATA);
    return Data;
}

void XImage_preprocess_Set_tensor_capacity(XImage_preprocess *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XImage_preprocess_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_TENSOR_CAPACITY_DATA, Data);
}

u32 XImage_preprocess_Get_tensor_capacity(XImage_preprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_TENSOR_CAPACITY_DATA);
    return Data;
}

void XImage_preprocess_Set_preview_stride(XImage_preprocess *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XImage_preprocess_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_PREVIEW_STRIDE_DATA, Data);
}

u32 XImage_preprocess_Get_preview_stride(XImage_preprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_PREVIEW_STRIDE_DATA);
    return Data;
}

void XImage_preprocess_Set_preview_capacity(XImage_preprocess *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XImage_preprocess_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_PREVIEW_CAPACITY_DATA, Data);
}

u32 XImage_preprocess_Get_preview_capacity(XImage_preprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_PREVIEW_CAPACITY_DATA);
    return Data;
}

void XImage_preprocess_Set_resized_w(XImage_preprocess *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XImage_preprocess_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_RESIZED_W_DATA, Data);
}

u32 XImage_preprocess_Get_resized_w(XImage_preprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_RESIZED_W_DATA);
    return Data;
}

void XImage_preprocess_Set_resized_h(XImage_preprocess *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XImage_preprocess_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_RESIZED_H_DATA, Data);
}

u32 XImage_preprocess_Get_resized_h(XImage_preprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_RESIZED_H_DATA);
    return Data;
}

void XImage_preprocess_Set_pad_x(XImage_preprocess *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XImage_preprocess_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_PAD_X_DATA, Data);
}

u32 XImage_preprocess_Get_pad_x(XImage_preprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_PAD_X_DATA);
    return Data;
}

void XImage_preprocess_Set_pad_y(XImage_preprocess *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XImage_preprocess_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_PAD_Y_DATA, Data);
}

u32 XImage_preprocess_Get_pad_y(XImage_preprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_PAD_Y_DATA);
    return Data;
}

void XImage_preprocess_Set_output_mode(XImage_preprocess *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XImage_preprocess_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_OUTPUT_MODE_DATA, Data);
}

u32 XImage_preprocess_Get_output_mode(XImage_preprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_OUTPUT_MODE_DATA);
    return Data;
}

void XImage_preprocess_Set_flags(XImage_preprocess *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XImage_preprocess_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_FLAGS_DATA, Data);
}

u32 XImage_preprocess_Get_flags(XImage_preprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_FLAGS_DATA);
    return Data;
}

void XImage_preprocess_Set_eq_mode(XImage_preprocess *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XImage_preprocess_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_EQ_MODE_DATA, Data);
}

u32 XImage_preprocess_Get_eq_mode(XImage_preprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_EQ_MODE_DATA);
    return Data;
}

void XImage_preprocess_Set_saturation_q12(XImage_preprocess *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XImage_preprocess_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_SATURATION_Q12_DATA, Data);
}

u32 XImage_preprocess_Get_saturation_q12(XImage_preprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_SATURATION_Q12_DATA);
    return Data;
}

void XImage_preprocess_Set_frame_id(XImage_preprocess *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XImage_preprocess_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_FRAME_ID_DATA, Data);
}

u32 XImage_preprocess_Get_frame_id(XImage_preprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_FRAME_ID_DATA);
    return Data;
}

void XImage_preprocess_Set_config_id(XImage_preprocess *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XImage_preprocess_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_CONFIG_ID_DATA, Data);
}

u32 XImage_preprocess_Get_config_id(XImage_preprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_CONFIG_ID_DATA);
    return Data;
}

u32 XImage_preprocess_Get_completed_frame_id(XImage_preprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_COMPLETED_FRAME_ID_DATA);
    return Data;
}

u32 XImage_preprocess_Get_completed_frame_id_vld(XImage_preprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_COMPLETED_FRAME_ID_CTRL);
    return Data & 0x1;
}

u32 XImage_preprocess_Get_completed_config_id(XImage_preprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_COMPLETED_CONFIG_ID_DATA);
    return Data;
}

u32 XImage_preprocess_Get_completed_config_id_vld(XImage_preprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_COMPLETED_CONFIG_ID_CTRL);
    return Data & 0x1;
}

u32 XImage_preprocess_Get_tensor_bytes(XImage_preprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_TENSOR_BYTES_DATA);
    return Data;
}

u32 XImage_preprocess_Get_tensor_bytes_vld(XImage_preprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_TENSOR_BYTES_CTRL);
    return Data & 0x1;
}

u32 XImage_preprocess_Get_preview_bytes(XImage_preprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_PREVIEW_BYTES_DATA);
    return Data;
}

u32 XImage_preprocess_Get_preview_bytes_vld(XImage_preprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_PREVIEW_BYTES_CTRL);
    return Data & 0x1;
}

u32 XImage_preprocess_Get_abi_version(XImage_preprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_ABI_VERSION_DATA);
    return Data;
}

u32 XImage_preprocess_Get_abi_version_vld(XImage_preprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_ABI_VERSION_CTRL);
    return Data & 0x1;
}

void XImage_preprocess_InterruptGlobalEnable(XImage_preprocess *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XImage_preprocess_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_GIE, 1);
}

void XImage_preprocess_InterruptGlobalDisable(XImage_preprocess *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XImage_preprocess_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_GIE, 0);
}

void XImage_preprocess_InterruptEnable(XImage_preprocess *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_IER);
    XImage_preprocess_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_IER, Register | Mask);
}

void XImage_preprocess_InterruptDisable(XImage_preprocess *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_IER);
    XImage_preprocess_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_IER, Register & (~Mask));
}

void XImage_preprocess_InterruptClear(XImage_preprocess *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    //XImage_preprocess_WriteReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_ISR, Mask);
}

u32 XImage_preprocess_InterruptGetEnabled(XImage_preprocess *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_IER);
}

u32 XImage_preprocess_InterruptGetStatus(XImage_preprocess *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    // Current Interrupt Clear Behavior is Clear on Read(COR).
    return XImage_preprocess_ReadReg(InstancePtr->Control_BaseAddress, XIMAGE_PREPROCESS_CONTROL_ADDR_ISR);
}

