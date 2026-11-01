// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
// Tool Version Limit: 2022.04
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __linux__

#include "xstatus.h"
#include "xparameters.h"
#include "ximage_preprocess.h"

extern XImage_preprocess_Config XImage_preprocess_ConfigTable[];

XImage_preprocess_Config *XImage_preprocess_LookupConfig(u16 DeviceId) {
	XImage_preprocess_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XIMAGE_PREPROCESS_NUM_INSTANCES; Index++) {
		if (XImage_preprocess_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XImage_preprocess_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XImage_preprocess_Initialize(XImage_preprocess *InstancePtr, u16 DeviceId) {
	XImage_preprocess_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XImage_preprocess_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XImage_preprocess_CfgInitialize(InstancePtr, ConfigPtr);
}

#endif

