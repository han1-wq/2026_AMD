// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
// Tool Version Limit: 2022.04
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// ==============================================================
// control
// 0x000 : Control signals
//         bit 0  - ap_start (Read/Write/COH)
//         bit 1  - ap_done (Read/COR)
//         bit 2  - ap_idle (Read)
//         bit 3  - ap_ready (Read/COR)
//         bit 7  - auto_restart (Read/Write)
//         bit 9  - interrupt (Read)
//         others - reserved
// 0x004 : Global Interrupt Enable Register
//         bit 0  - Global Interrupt Enable (Read/Write)
//         others - reserved
// 0x008 : IP Interrupt Enable Register (Read/Write)
//         bit 0 - enable ap_done interrupt (Read/Write)
//         bit 1 - enable ap_ready interrupt (Read/Write)
//         others - reserved
// 0x00c : IP Interrupt Status Register (Read/COR)
//         bit 0 - ap_done (Read/COR)
//         bit 1 - ap_ready (Read/COR)
//         others - reserved
// 0x010 : Data signal of ap_return
//         bit 31~0 - ap_return[31:0] (Read)
// 0x018 : Data signal of src
//         bit 31~0 - src[31:0] (Read/Write)
// 0x01c : Data signal of src
//         bit 31~0 - src[63:32] (Read/Write)
// 0x020 : reserved
// 0x024 : Data signal of tensor
//         bit 31~0 - tensor[31:0] (Read/Write)
// 0x028 : Data signal of tensor
//         bit 31~0 - tensor[63:32] (Read/Write)
// 0x02c : reserved
// 0x030 : Data signal of preview
//         bit 31~0 - preview[31:0] (Read/Write)
// 0x034 : Data signal of preview
//         bit 31~0 - preview[63:32] (Read/Write)
// 0x038 : reserved
// 0x03c : Data signal of luts
//         bit 31~0 - luts[31:0] (Read/Write)
// 0x040 : Data signal of luts
//         bit 31~0 - luts[63:32] (Read/Write)
// 0x044 : reserved
// 0x048 : Data signal of width
//         bit 31~0 - width[31:0] (Read/Write)
// 0x04c : reserved
// 0x050 : Data signal of height
//         bit 31~0 - height[31:0] (Read/Write)
// 0x054 : reserved
// 0x058 : Data signal of src_stride
//         bit 31~0 - src_stride[31:0] (Read/Write)
// 0x05c : reserved
// 0x060 : Data signal of src_capacity
//         bit 31~0 - src_capacity[31:0] (Read/Write)
// 0x064 : reserved
// 0x068 : Data signal of tensor_capacity
//         bit 31~0 - tensor_capacity[31:0] (Read/Write)
// 0x06c : reserved
// 0x070 : Data signal of preview_stride
//         bit 31~0 - preview_stride[31:0] (Read/Write)
// 0x074 : reserved
// 0x078 : Data signal of preview_capacity
//         bit 31~0 - preview_capacity[31:0] (Read/Write)
// 0x07c : reserved
// 0x080 : Data signal of resized_w
//         bit 31~0 - resized_w[31:0] (Read/Write)
// 0x084 : reserved
// 0x088 : Data signal of resized_h
//         bit 31~0 - resized_h[31:0] (Read/Write)
// 0x08c : reserved
// 0x090 : Data signal of pad_x
//         bit 31~0 - pad_x[31:0] (Read/Write)
// 0x094 : reserved
// 0x098 : Data signal of pad_y
//         bit 31~0 - pad_y[31:0] (Read/Write)
// 0x09c : reserved
// 0x0a0 : Data signal of output_mode
//         bit 31~0 - output_mode[31:0] (Read/Write)
// 0x0a4 : reserved
// 0x0a8 : Data signal of flags
//         bit 31~0 - flags[31:0] (Read/Write)
// 0x0ac : reserved
// 0x0b0 : Data signal of eq_mode
//         bit 31~0 - eq_mode[31:0] (Read/Write)
// 0x0b4 : reserved
// 0x0b8 : Data signal of saturation_q12
//         bit 31~0 - saturation_q12[31:0] (Read/Write)
// 0x0bc : reserved
// 0x0c0 : Data signal of frame_id
//         bit 31~0 - frame_id[31:0] (Read/Write)
// 0x0c4 : reserved
// 0x0c8 : Data signal of config_id
//         bit 31~0 - config_id[31:0] (Read/Write)
// 0x0cc : reserved
// 0x0d0 : Data signal of completed_frame_id
//         bit 31~0 - completed_frame_id[31:0] (Read)
// 0x0d4 : Control signal of completed_frame_id
//         bit 0  - completed_frame_id_ap_vld (Read/COR)
//         others - reserved
// 0x0e0 : Data signal of completed_config_id
//         bit 31~0 - completed_config_id[31:0] (Read)
// 0x0e4 : Control signal of completed_config_id
//         bit 0  - completed_config_id_ap_vld (Read/COR)
//         others - reserved
// 0x0f0 : Data signal of tensor_bytes
//         bit 31~0 - tensor_bytes[31:0] (Read)
// 0x0f4 : Control signal of tensor_bytes
//         bit 0  - tensor_bytes_ap_vld (Read/COR)
//         others - reserved
// 0x100 : Data signal of preview_bytes
//         bit 31~0 - preview_bytes[31:0] (Read)
// 0x104 : Control signal of preview_bytes
//         bit 0  - preview_bytes_ap_vld (Read/COR)
//         others - reserved
// 0x110 : Data signal of abi_version
//         bit 31~0 - abi_version[31:0] (Read)
// 0x114 : Control signal of abi_version
//         bit 0  - abi_version_ap_vld (Read/COR)
//         others - reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

#define XIMAGE_PREPROCESS_CONTROL_ADDR_AP_CTRL                  0x000
#define XIMAGE_PREPROCESS_CONTROL_ADDR_GIE                      0x004
#define XIMAGE_PREPROCESS_CONTROL_ADDR_IER                      0x008
#define XIMAGE_PREPROCESS_CONTROL_ADDR_ISR                      0x00c
#define XIMAGE_PREPROCESS_CONTROL_ADDR_AP_RETURN                0x010
#define XIMAGE_PREPROCESS_CONTROL_BITS_AP_RETURN                32
#define XIMAGE_PREPROCESS_CONTROL_ADDR_SRC_DATA                 0x018
#define XIMAGE_PREPROCESS_CONTROL_BITS_SRC_DATA                 64
#define XIMAGE_PREPROCESS_CONTROL_ADDR_TENSOR_DATA              0x024
#define XIMAGE_PREPROCESS_CONTROL_BITS_TENSOR_DATA              64
#define XIMAGE_PREPROCESS_CONTROL_ADDR_PREVIEW_DATA             0x030
#define XIMAGE_PREPROCESS_CONTROL_BITS_PREVIEW_DATA             64
#define XIMAGE_PREPROCESS_CONTROL_ADDR_LUTS_DATA                0x03c
#define XIMAGE_PREPROCESS_CONTROL_BITS_LUTS_DATA                64
#define XIMAGE_PREPROCESS_CONTROL_ADDR_WIDTH_DATA               0x048
#define XIMAGE_PREPROCESS_CONTROL_BITS_WIDTH_DATA               32
#define XIMAGE_PREPROCESS_CONTROL_ADDR_HEIGHT_DATA              0x050
#define XIMAGE_PREPROCESS_CONTROL_BITS_HEIGHT_DATA              32
#define XIMAGE_PREPROCESS_CONTROL_ADDR_SRC_STRIDE_DATA          0x058
#define XIMAGE_PREPROCESS_CONTROL_BITS_SRC_STRIDE_DATA          32
#define XIMAGE_PREPROCESS_CONTROL_ADDR_SRC_CAPACITY_DATA        0x060
#define XIMAGE_PREPROCESS_CONTROL_BITS_SRC_CAPACITY_DATA        32
#define XIMAGE_PREPROCESS_CONTROL_ADDR_TENSOR_CAPACITY_DATA     0x068
#define XIMAGE_PREPROCESS_CONTROL_BITS_TENSOR_CAPACITY_DATA     32
#define XIMAGE_PREPROCESS_CONTROL_ADDR_PREVIEW_STRIDE_DATA      0x070
#define XIMAGE_PREPROCESS_CONTROL_BITS_PREVIEW_STRIDE_DATA      32
#define XIMAGE_PREPROCESS_CONTROL_ADDR_PREVIEW_CAPACITY_DATA    0x078
#define XIMAGE_PREPROCESS_CONTROL_BITS_PREVIEW_CAPACITY_DATA    32
#define XIMAGE_PREPROCESS_CONTROL_ADDR_RESIZED_W_DATA           0x080
#define XIMAGE_PREPROCESS_CONTROL_BITS_RESIZED_W_DATA           32
#define XIMAGE_PREPROCESS_CONTROL_ADDR_RESIZED_H_DATA           0x088
#define XIMAGE_PREPROCESS_CONTROL_BITS_RESIZED_H_DATA           32
#define XIMAGE_PREPROCESS_CONTROL_ADDR_PAD_X_DATA               0x090
#define XIMAGE_PREPROCESS_CONTROL_BITS_PAD_X_DATA               32
#define XIMAGE_PREPROCESS_CONTROL_ADDR_PAD_Y_DATA               0x098
#define XIMAGE_PREPROCESS_CONTROL_BITS_PAD_Y_DATA               32
#define XIMAGE_PREPROCESS_CONTROL_ADDR_OUTPUT_MODE_DATA         0x0a0
#define XIMAGE_PREPROCESS_CONTROL_BITS_OUTPUT_MODE_DATA         32
#define XIMAGE_PREPROCESS_CONTROL_ADDR_FLAGS_DATA               0x0a8
#define XIMAGE_PREPROCESS_CONTROL_BITS_FLAGS_DATA               32
#define XIMAGE_PREPROCESS_CONTROL_ADDR_EQ_MODE_DATA             0x0b0
#define XIMAGE_PREPROCESS_CONTROL_BITS_EQ_MODE_DATA             32
#define XIMAGE_PREPROCESS_CONTROL_ADDR_SATURATION_Q12_DATA      0x0b8
#define XIMAGE_PREPROCESS_CONTROL_BITS_SATURATION_Q12_DATA      32
#define XIMAGE_PREPROCESS_CONTROL_ADDR_FRAME_ID_DATA            0x0c0
#define XIMAGE_PREPROCESS_CONTROL_BITS_FRAME_ID_DATA            32
#define XIMAGE_PREPROCESS_CONTROL_ADDR_CONFIG_ID_DATA           0x0c8
#define XIMAGE_PREPROCESS_CONTROL_BITS_CONFIG_ID_DATA           32
#define XIMAGE_PREPROCESS_CONTROL_ADDR_COMPLETED_FRAME_ID_DATA  0x0d0
#define XIMAGE_PREPROCESS_CONTROL_BITS_COMPLETED_FRAME_ID_DATA  32
#define XIMAGE_PREPROCESS_CONTROL_ADDR_COMPLETED_FRAME_ID_CTRL  0x0d4
#define XIMAGE_PREPROCESS_CONTROL_ADDR_COMPLETED_CONFIG_ID_DATA 0x0e0
#define XIMAGE_PREPROCESS_CONTROL_BITS_COMPLETED_CONFIG_ID_DATA 32
#define XIMAGE_PREPROCESS_CONTROL_ADDR_COMPLETED_CONFIG_ID_CTRL 0x0e4
#define XIMAGE_PREPROCESS_CONTROL_ADDR_TENSOR_BYTES_DATA        0x0f0
#define XIMAGE_PREPROCESS_CONTROL_BITS_TENSOR_BYTES_DATA        32
#define XIMAGE_PREPROCESS_CONTROL_ADDR_TENSOR_BYTES_CTRL        0x0f4
#define XIMAGE_PREPROCESS_CONTROL_ADDR_PREVIEW_BYTES_DATA       0x100
#define XIMAGE_PREPROCESS_CONTROL_BITS_PREVIEW_BYTES_DATA       32
#define XIMAGE_PREPROCESS_CONTROL_ADDR_PREVIEW_BYTES_CTRL       0x104
#define XIMAGE_PREPROCESS_CONTROL_ADDR_ABI_VERSION_DATA         0x110
#define XIMAGE_PREPROCESS_CONTROL_BITS_ABI_VERSION_DATA         32
#define XIMAGE_PREPROCESS_CONTROL_ADDR_ABI_VERSION_CTRL         0x114

