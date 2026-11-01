// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
// Tool Version Limit: 2022.04
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// ==============================================================

extern "C" int AESL_WRAP_image_preprocess (
volatile void* src,
volatile void* tensor,
volatile void* preview,
volatile void* luts,
int width,
int height,
int src_stride,
int src_capacity,
int tensor_capacity,
int preview_stride,
int preview_capacity,
int resized_w,
int resized_h,
int pad_x,
int pad_y,
int output_mode,
int flags,
int eq_mode,
int saturation_q12,
int frame_id,
int config_id,
volatile void* completed_frame_id,
volatile void* completed_config_id,
volatile void* tensor_bytes,
volatile void* preview_bytes,
volatile void* abi_version);
