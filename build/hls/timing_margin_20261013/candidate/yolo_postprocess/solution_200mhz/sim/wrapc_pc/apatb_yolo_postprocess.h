// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
// Tool Version Limit: 2022.04
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// ==============================================================

extern "C" int AESL_WRAP_yolo_postprocess (
volatile void* input_r,
volatile void* tables,
volatile void* output_r,
int input_words,
int table_words,
int output_capacity,
int confidence_q30,
int nms_q16,
int enable_nms,
volatile void* candidate_count,
volatile void* detection_count);
