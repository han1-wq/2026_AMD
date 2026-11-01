// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
// Tool Version Limit: 2022.04
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// ==============================================================
/***************************** Include Files *********************************/
#include "xyolo_postprocess.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XYolo_postprocess_CfgInitialize(XYolo_postprocess *InstancePtr, XYolo_postprocess_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XYolo_postprocess_Start(XYolo_postprocess *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XYolo_postprocess_ReadReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_AP_CTRL) & 0x80;
    XYolo_postprocess_WriteReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XYolo_postprocess_IsDone(XYolo_postprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XYolo_postprocess_ReadReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XYolo_postprocess_IsIdle(XYolo_postprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XYolo_postprocess_ReadReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XYolo_postprocess_IsReady(XYolo_postprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XYolo_postprocess_ReadReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XYolo_postprocess_EnableAutoRestart(XYolo_postprocess *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XYolo_postprocess_WriteReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_AP_CTRL, 0x80);
}

void XYolo_postprocess_DisableAutoRestart(XYolo_postprocess *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XYolo_postprocess_WriteReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_AP_CTRL, 0);
}

u32 XYolo_postprocess_Get_return(XYolo_postprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XYolo_postprocess_ReadReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_AP_RETURN);
    return Data;
}
void XYolo_postprocess_Set_input_r(XYolo_postprocess *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XYolo_postprocess_WriteReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_INPUT_R_DATA, (u32)(Data));
    XYolo_postprocess_WriteReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_INPUT_R_DATA + 4, (u32)(Data >> 32));
}

u64 XYolo_postprocess_Get_input_r(XYolo_postprocess *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XYolo_postprocess_ReadReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_INPUT_R_DATA);
    Data += (u64)XYolo_postprocess_ReadReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_INPUT_R_DATA + 4) << 32;
    return Data;
}

void XYolo_postprocess_Set_tables(XYolo_postprocess *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XYolo_postprocess_WriteReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_TABLES_DATA, (u32)(Data));
    XYolo_postprocess_WriteReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_TABLES_DATA + 4, (u32)(Data >> 32));
}

u64 XYolo_postprocess_Get_tables(XYolo_postprocess *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XYolo_postprocess_ReadReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_TABLES_DATA);
    Data += (u64)XYolo_postprocess_ReadReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_TABLES_DATA + 4) << 32;
    return Data;
}

void XYolo_postprocess_Set_output_r(XYolo_postprocess *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XYolo_postprocess_WriteReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_OUTPUT_R_DATA, (u32)(Data));
    XYolo_postprocess_WriteReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_OUTPUT_R_DATA + 4, (u32)(Data >> 32));
}

u64 XYolo_postprocess_Get_output_r(XYolo_postprocess *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XYolo_postprocess_ReadReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_OUTPUT_R_DATA);
    Data += (u64)XYolo_postprocess_ReadReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_OUTPUT_R_DATA + 4) << 32;
    return Data;
}

void XYolo_postprocess_Set_input_words(XYolo_postprocess *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XYolo_postprocess_WriteReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_INPUT_WORDS_DATA, Data);
}

u32 XYolo_postprocess_Get_input_words(XYolo_postprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XYolo_postprocess_ReadReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_INPUT_WORDS_DATA);
    return Data;
}

void XYolo_postprocess_Set_table_words(XYolo_postprocess *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XYolo_postprocess_WriteReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_TABLE_WORDS_DATA, Data);
}

u32 XYolo_postprocess_Get_table_words(XYolo_postprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XYolo_postprocess_ReadReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_TABLE_WORDS_DATA);
    return Data;
}

void XYolo_postprocess_Set_output_capacity(XYolo_postprocess *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XYolo_postprocess_WriteReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_OUTPUT_CAPACITY_DATA, Data);
}

u32 XYolo_postprocess_Get_output_capacity(XYolo_postprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XYolo_postprocess_ReadReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_OUTPUT_CAPACITY_DATA);
    return Data;
}

void XYolo_postprocess_Set_confidence_q30(XYolo_postprocess *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XYolo_postprocess_WriteReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_CONFIDENCE_Q30_DATA, Data);
}

u32 XYolo_postprocess_Get_confidence_q30(XYolo_postprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XYolo_postprocess_ReadReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_CONFIDENCE_Q30_DATA);
    return Data;
}

void XYolo_postprocess_Set_nms_q16(XYolo_postprocess *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XYolo_postprocess_WriteReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_NMS_Q16_DATA, Data);
}

u32 XYolo_postprocess_Get_nms_q16(XYolo_postprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XYolo_postprocess_ReadReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_NMS_Q16_DATA);
    return Data;
}

void XYolo_postprocess_Set_enable_nms(XYolo_postprocess *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XYolo_postprocess_WriteReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_ENABLE_NMS_DATA, Data);
}

u32 XYolo_postprocess_Get_enable_nms(XYolo_postprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XYolo_postprocess_ReadReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_ENABLE_NMS_DATA);
    return Data;
}

u32 XYolo_postprocess_Get_candidate_count(XYolo_postprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XYolo_postprocess_ReadReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_CANDIDATE_COUNT_DATA);
    return Data;
}

u32 XYolo_postprocess_Get_candidate_count_vld(XYolo_postprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XYolo_postprocess_ReadReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_CANDIDATE_COUNT_CTRL);
    return Data & 0x1;
}

u32 XYolo_postprocess_Get_detection_count(XYolo_postprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XYolo_postprocess_ReadReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_DETECTION_COUNT_DATA);
    return Data;
}

u32 XYolo_postprocess_Get_detection_count_vld(XYolo_postprocess *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XYolo_postprocess_ReadReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_DETECTION_COUNT_CTRL);
    return Data & 0x1;
}

void XYolo_postprocess_InterruptGlobalEnable(XYolo_postprocess *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XYolo_postprocess_WriteReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_GIE, 1);
}

void XYolo_postprocess_InterruptGlobalDisable(XYolo_postprocess *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XYolo_postprocess_WriteReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_GIE, 0);
}

void XYolo_postprocess_InterruptEnable(XYolo_postprocess *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XYolo_postprocess_ReadReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_IER);
    XYolo_postprocess_WriteReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_IER, Register | Mask);
}

void XYolo_postprocess_InterruptDisable(XYolo_postprocess *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XYolo_postprocess_ReadReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_IER);
    XYolo_postprocess_WriteReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_IER, Register & (~Mask));
}

void XYolo_postprocess_InterruptClear(XYolo_postprocess *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    //XYolo_postprocess_WriteReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_ISR, Mask);
}

u32 XYolo_postprocess_InterruptGetEnabled(XYolo_postprocess *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XYolo_postprocess_ReadReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_IER);
}

u32 XYolo_postprocess_InterruptGetStatus(XYolo_postprocess *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    // Current Interrupt Clear Behavior is Clear on Read(COR).
    return XYolo_postprocess_ReadReg(InstancePtr->Control_BaseAddress, XYOLO_POSTPROCESS_CONTROL_ADDR_ISR);
}

