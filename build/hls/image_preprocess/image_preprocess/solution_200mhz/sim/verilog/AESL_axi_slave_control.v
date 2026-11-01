// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
// Tool Version Limit: 2022.04
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// ==============================================================

`timescale 1 ns / 1 ps

module AESL_axi_slave_control (
    clk,
    reset,
    TRAN_s_axi_control_AWADDR,
    TRAN_s_axi_control_AWVALID,
    TRAN_s_axi_control_AWREADY,
    TRAN_s_axi_control_WVALID,
    TRAN_s_axi_control_WREADY,
    TRAN_s_axi_control_WDATA,
    TRAN_s_axi_control_WSTRB,
    TRAN_s_axi_control_ARADDR,
    TRAN_s_axi_control_ARVALID,
    TRAN_s_axi_control_ARREADY,
    TRAN_s_axi_control_RVALID,
    TRAN_s_axi_control_RREADY,
    TRAN_s_axi_control_RDATA,
    TRAN_s_axi_control_RRESP,
    TRAN_s_axi_control_BVALID,
    TRAN_s_axi_control_BREADY,
    TRAN_s_axi_control_BRESP,
    TRAN_control_write_data_finish,
    TRAN_control_read_data_finish,
    TRAN_control_start_in,
    TRAN_control_idle_out,
    TRAN_control_ready_out,
    TRAN_control_ready_in,
    TRAN_control_done_out,
    TRAN_control_write_start_in   ,
    TRAN_control_write_start_finish,
    TRAN_control_interrupt,
    TRAN_control_transaction_done_in
    );

//------------------------Parameter----------------------
`define TV_IN_src "../tv/cdatafile/c.image_preprocess.autotvin_src.dat"
`define TV_IN_tensor "../tv/cdatafile/c.image_preprocess.autotvin_tensor.dat"
`define TV_IN_preview "../tv/cdatafile/c.image_preprocess.autotvin_preview.dat"
`define TV_IN_luts "../tv/cdatafile/c.image_preprocess.autotvin_luts.dat"
`define TV_IN_width "../tv/cdatafile/c.image_preprocess.autotvin_width.dat"
`define TV_IN_height "../tv/cdatafile/c.image_preprocess.autotvin_height.dat"
`define TV_IN_src_stride "../tv/cdatafile/c.image_preprocess.autotvin_src_stride.dat"
`define TV_IN_src_capacity "../tv/cdatafile/c.image_preprocess.autotvin_src_capacity.dat"
`define TV_IN_tensor_capacity "../tv/cdatafile/c.image_preprocess.autotvin_tensor_capacity.dat"
`define TV_IN_preview_stride "../tv/cdatafile/c.image_preprocess.autotvin_preview_stride.dat"
`define TV_IN_preview_capacity "../tv/cdatafile/c.image_preprocess.autotvin_preview_capacity.dat"
`define TV_IN_resized_w "../tv/cdatafile/c.image_preprocess.autotvin_resized_w.dat"
`define TV_IN_resized_h "../tv/cdatafile/c.image_preprocess.autotvin_resized_h.dat"
`define TV_IN_pad_x "../tv/cdatafile/c.image_preprocess.autotvin_pad_x.dat"
`define TV_IN_pad_y "../tv/cdatafile/c.image_preprocess.autotvin_pad_y.dat"
`define TV_IN_output_mode "../tv/cdatafile/c.image_preprocess.autotvin_output_mode.dat"
`define TV_IN_flags "../tv/cdatafile/c.image_preprocess.autotvin_flags.dat"
`define TV_IN_eq_mode "../tv/cdatafile/c.image_preprocess.autotvin_eq_mode.dat"
`define TV_IN_saturation_q12 "../tv/cdatafile/c.image_preprocess.autotvin_saturation_q12.dat"
`define TV_IN_frame_id "../tv/cdatafile/c.image_preprocess.autotvin_frame_id.dat"
`define TV_IN_config_id "../tv/cdatafile/c.image_preprocess.autotvin_config_id.dat"
`define TV_OUT_completed_frame_id "../tv/rtldatafile/rtl.image_preprocess.autotvout_completed_frame_id.dat"
`define TV_OUT_completed_config_id "../tv/rtldatafile/rtl.image_preprocess.autotvout_completed_config_id.dat"
`define TV_OUT_tensor_bytes "../tv/rtldatafile/rtl.image_preprocess.autotvout_tensor_bytes.dat"
`define TV_OUT_preview_bytes "../tv/rtldatafile/rtl.image_preprocess.autotvout_preview_bytes.dat"
`define TV_OUT_abi_version "../tv/rtldatafile/rtl.image_preprocess.autotvout_abi_version.dat"
`define TV_OUT_ap_return "../tv/rtldatafile/rtl.image_preprocess.autotvout_ap_return.dat"
parameter ADDR_WIDTH = 9;
parameter DATA_WIDTH = 32;
parameter src_DEPTH = 1;
reg [31 : 0] src_OPERATE_DEPTH = 0;
parameter src_c_bitwidth = 64;
parameter tensor_DEPTH = 1;
reg [31 : 0] tensor_OPERATE_DEPTH = 0;
parameter tensor_c_bitwidth = 64;
parameter preview_DEPTH = 1;
reg [31 : 0] preview_OPERATE_DEPTH = 0;
parameter preview_c_bitwidth = 64;
parameter luts_DEPTH = 1;
reg [31 : 0] luts_OPERATE_DEPTH = 0;
parameter luts_c_bitwidth = 64;
parameter width_DEPTH = 1;
reg [31 : 0] width_OPERATE_DEPTH = 0;
parameter width_c_bitwidth = 32;
parameter height_DEPTH = 1;
reg [31 : 0] height_OPERATE_DEPTH = 0;
parameter height_c_bitwidth = 32;
parameter src_stride_DEPTH = 1;
reg [31 : 0] src_stride_OPERATE_DEPTH = 0;
parameter src_stride_c_bitwidth = 32;
parameter src_capacity_DEPTH = 1;
reg [31 : 0] src_capacity_OPERATE_DEPTH = 0;
parameter src_capacity_c_bitwidth = 32;
parameter tensor_capacity_DEPTH = 1;
reg [31 : 0] tensor_capacity_OPERATE_DEPTH = 0;
parameter tensor_capacity_c_bitwidth = 32;
parameter preview_stride_DEPTH = 1;
reg [31 : 0] preview_stride_OPERATE_DEPTH = 0;
parameter preview_stride_c_bitwidth = 32;
parameter preview_capacity_DEPTH = 1;
reg [31 : 0] preview_capacity_OPERATE_DEPTH = 0;
parameter preview_capacity_c_bitwidth = 32;
parameter resized_w_DEPTH = 1;
reg [31 : 0] resized_w_OPERATE_DEPTH = 0;
parameter resized_w_c_bitwidth = 32;
parameter resized_h_DEPTH = 1;
reg [31 : 0] resized_h_OPERATE_DEPTH = 0;
parameter resized_h_c_bitwidth = 32;
parameter pad_x_DEPTH = 1;
reg [31 : 0] pad_x_OPERATE_DEPTH = 0;
parameter pad_x_c_bitwidth = 32;
parameter pad_y_DEPTH = 1;
reg [31 : 0] pad_y_OPERATE_DEPTH = 0;
parameter pad_y_c_bitwidth = 32;
parameter output_mode_DEPTH = 1;
reg [31 : 0] output_mode_OPERATE_DEPTH = 0;
parameter output_mode_c_bitwidth = 32;
parameter flags_DEPTH = 1;
reg [31 : 0] flags_OPERATE_DEPTH = 0;
parameter flags_c_bitwidth = 32;
parameter eq_mode_DEPTH = 1;
reg [31 : 0] eq_mode_OPERATE_DEPTH = 0;
parameter eq_mode_c_bitwidth = 32;
parameter saturation_q12_DEPTH = 1;
reg [31 : 0] saturation_q12_OPERATE_DEPTH = 0;
parameter saturation_q12_c_bitwidth = 32;
parameter frame_id_DEPTH = 1;
reg [31 : 0] frame_id_OPERATE_DEPTH = 0;
parameter frame_id_c_bitwidth = 32;
parameter config_id_DEPTH = 1;
reg [31 : 0] config_id_OPERATE_DEPTH = 0;
parameter config_id_c_bitwidth = 32;
parameter completed_frame_id_DEPTH = 1;
reg [31 : 0] completed_frame_id_OPERATE_DEPTH = 0;
parameter completed_frame_id_c_bitwidth = 32;
parameter completed_config_id_DEPTH = 1;
reg [31 : 0] completed_config_id_OPERATE_DEPTH = 0;
parameter completed_config_id_c_bitwidth = 32;
parameter tensor_bytes_DEPTH = 1;
reg [31 : 0] tensor_bytes_OPERATE_DEPTH = 0;
parameter tensor_bytes_c_bitwidth = 32;
parameter preview_bytes_DEPTH = 1;
reg [31 : 0] preview_bytes_OPERATE_DEPTH = 0;
parameter preview_bytes_c_bitwidth = 32;
parameter abi_version_DEPTH = 1;
reg [31 : 0] abi_version_OPERATE_DEPTH = 0;
parameter abi_version_c_bitwidth = 32;
parameter ap_return_DEPTH = 1;
reg [31 : 0] ap_return_OPERATE_DEPTH = 0;
parameter ap_return_c_bitwidth = 32;
parameter START_ADDR = 0;
parameter image_preprocess_continue_addr = 0;
parameter image_preprocess_auto_start_addr = 0;
parameter src_data_in_addr = 24;
parameter tensor_data_in_addr = 36;
parameter preview_data_in_addr = 48;
parameter luts_data_in_addr = 60;
parameter width_data_in_addr = 72;
parameter height_data_in_addr = 80;
parameter src_stride_data_in_addr = 88;
parameter src_capacity_data_in_addr = 96;
parameter tensor_capacity_data_in_addr = 104;
parameter preview_stride_data_in_addr = 112;
parameter preview_capacity_data_in_addr = 120;
parameter resized_w_data_in_addr = 128;
parameter resized_h_data_in_addr = 136;
parameter pad_x_data_in_addr = 144;
parameter pad_y_data_in_addr = 152;
parameter output_mode_data_in_addr = 160;
parameter flags_data_in_addr = 168;
parameter eq_mode_data_in_addr = 176;
parameter saturation_q12_data_in_addr = 184;
parameter frame_id_data_in_addr = 192;
parameter config_id_data_in_addr = 200;
parameter ap_return_data_out_addr = 16;
parameter completed_frame_id_data_out_addr = 208;
parameter completed_frame_id_valid_out_addr = 212;
parameter completed_config_id_data_out_addr = 224;
parameter completed_config_id_valid_out_addr = 228;
parameter tensor_bytes_data_out_addr = 240;
parameter tensor_bytes_valid_out_addr = 244;
parameter preview_bytes_data_out_addr = 256;
parameter preview_bytes_valid_out_addr = 260;
parameter abi_version_data_out_addr = 272;
parameter abi_version_valid_out_addr = 276;
parameter STATUS_ADDR = 0;

output [ADDR_WIDTH - 1 : 0] TRAN_s_axi_control_AWADDR;
output  TRAN_s_axi_control_AWVALID;
input  TRAN_s_axi_control_AWREADY;
output  TRAN_s_axi_control_WVALID;
input  TRAN_s_axi_control_WREADY;
output [DATA_WIDTH - 1 : 0] TRAN_s_axi_control_WDATA;
output [DATA_WIDTH/8 - 1 : 0] TRAN_s_axi_control_WSTRB;
output [ADDR_WIDTH - 1 : 0] TRAN_s_axi_control_ARADDR;
output  TRAN_s_axi_control_ARVALID;
input  TRAN_s_axi_control_ARREADY;
input  TRAN_s_axi_control_RVALID;
output  TRAN_s_axi_control_RREADY;
input [DATA_WIDTH - 1 : 0] TRAN_s_axi_control_RDATA;
input [2 - 1 : 0] TRAN_s_axi_control_RRESP;
input  TRAN_s_axi_control_BVALID;
output  TRAN_s_axi_control_BREADY;
input [2 - 1 : 0] TRAN_s_axi_control_BRESP;
output TRAN_control_write_data_finish;
output TRAN_control_read_data_finish;
input     clk;
input     reset;
input     TRAN_control_start_in;
output    TRAN_control_done_out;
output    TRAN_control_ready_out;
input     TRAN_control_ready_in;
output    TRAN_control_idle_out;
input  TRAN_control_write_start_in   ;
output TRAN_control_write_start_finish;
input     TRAN_control_interrupt;
input     TRAN_control_transaction_done_in;

reg [ADDR_WIDTH - 1 : 0] AWADDR_reg = 0;
reg  AWVALID_reg = 0;
reg  WVALID_reg = 0;
reg [DATA_WIDTH - 1 : 0] WDATA_reg = 0;
reg [DATA_WIDTH/8 - 1 : 0] WSTRB_reg = 0;
reg [ADDR_WIDTH - 1 : 0] ARADDR_reg = 0;
reg  ARVALID_reg = 0;
reg  RREADY_reg = 0;
reg [DATA_WIDTH - 1 : 0] RDATA_reg = 0;
reg  BREADY_reg = 0;
reg [src_c_bitwidth - 1 : 0] mem_src [src_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_src [ (src_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * src_DEPTH -1 : 0] = '{default : 'hz};
reg src_write_data_finish;
reg [tensor_c_bitwidth - 1 : 0] mem_tensor [tensor_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_tensor [ (tensor_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * tensor_DEPTH -1 : 0] = '{default : 'hz};
reg tensor_write_data_finish;
reg [preview_c_bitwidth - 1 : 0] mem_preview [preview_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_preview [ (preview_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * preview_DEPTH -1 : 0] = '{default : 'hz};
reg preview_write_data_finish;
reg [luts_c_bitwidth - 1 : 0] mem_luts [luts_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_luts [ (luts_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * luts_DEPTH -1 : 0] = '{default : 'hz};
reg luts_write_data_finish;
reg [DATA_WIDTH - 1 : 0] mem_width [width_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_width [ (width_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * width_DEPTH -1 : 0] = '{default : 'hz};
reg width_write_data_finish;
reg [DATA_WIDTH - 1 : 0] mem_height [height_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_height [ (height_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * height_DEPTH -1 : 0] = '{default : 'hz};
reg height_write_data_finish;
reg [DATA_WIDTH - 1 : 0] mem_src_stride [src_stride_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_src_stride [ (src_stride_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * src_stride_DEPTH -1 : 0] = '{default : 'hz};
reg src_stride_write_data_finish;
reg [DATA_WIDTH - 1 : 0] mem_src_capacity [src_capacity_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_src_capacity [ (src_capacity_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * src_capacity_DEPTH -1 : 0] = '{default : 'hz};
reg src_capacity_write_data_finish;
reg [DATA_WIDTH - 1 : 0] mem_tensor_capacity [tensor_capacity_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_tensor_capacity [ (tensor_capacity_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * tensor_capacity_DEPTH -1 : 0] = '{default : 'hz};
reg tensor_capacity_write_data_finish;
reg [DATA_WIDTH - 1 : 0] mem_preview_stride [preview_stride_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_preview_stride [ (preview_stride_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * preview_stride_DEPTH -1 : 0] = '{default : 'hz};
reg preview_stride_write_data_finish;
reg [DATA_WIDTH - 1 : 0] mem_preview_capacity [preview_capacity_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_preview_capacity [ (preview_capacity_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * preview_capacity_DEPTH -1 : 0] = '{default : 'hz};
reg preview_capacity_write_data_finish;
reg [DATA_WIDTH - 1 : 0] mem_resized_w [resized_w_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_resized_w [ (resized_w_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * resized_w_DEPTH -1 : 0] = '{default : 'hz};
reg resized_w_write_data_finish;
reg [DATA_WIDTH - 1 : 0] mem_resized_h [resized_h_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_resized_h [ (resized_h_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * resized_h_DEPTH -1 : 0] = '{default : 'hz};
reg resized_h_write_data_finish;
reg [DATA_WIDTH - 1 : 0] mem_pad_x [pad_x_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_pad_x [ (pad_x_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * pad_x_DEPTH -1 : 0] = '{default : 'hz};
reg pad_x_write_data_finish;
reg [DATA_WIDTH - 1 : 0] mem_pad_y [pad_y_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_pad_y [ (pad_y_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * pad_y_DEPTH -1 : 0] = '{default : 'hz};
reg pad_y_write_data_finish;
reg [DATA_WIDTH - 1 : 0] mem_output_mode [output_mode_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_output_mode [ (output_mode_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * output_mode_DEPTH -1 : 0] = '{default : 'hz};
reg output_mode_write_data_finish;
reg [DATA_WIDTH - 1 : 0] mem_flags [flags_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_flags [ (flags_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * flags_DEPTH -1 : 0] = '{default : 'hz};
reg flags_write_data_finish;
reg [DATA_WIDTH - 1 : 0] mem_eq_mode [eq_mode_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_eq_mode [ (eq_mode_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * eq_mode_DEPTH -1 : 0] = '{default : 'hz};
reg eq_mode_write_data_finish;
reg [DATA_WIDTH - 1 : 0] mem_saturation_q12 [saturation_q12_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_saturation_q12 [ (saturation_q12_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * saturation_q12_DEPTH -1 : 0] = '{default : 'hz};
reg saturation_q12_write_data_finish;
reg [DATA_WIDTH - 1 : 0] mem_frame_id [frame_id_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_frame_id [ (frame_id_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * frame_id_DEPTH -1 : 0] = '{default : 'hz};
reg frame_id_write_data_finish;
reg [DATA_WIDTH - 1 : 0] mem_config_id [config_id_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_config_id [ (config_id_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * config_id_DEPTH -1 : 0] = '{default : 'hz};
reg config_id_write_data_finish;
reg [DATA_WIDTH - 1 : 0] mem_completed_frame_id [completed_frame_id_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_completed_frame_id [ (completed_frame_id_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * completed_frame_id_DEPTH -1 : 0] = '{default : 'hz};
reg completed_frame_id_read_data_finish;
reg [DATA_WIDTH - 1 : 0] mem_completed_config_id [completed_config_id_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_completed_config_id [ (completed_config_id_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * completed_config_id_DEPTH -1 : 0] = '{default : 'hz};
reg completed_config_id_read_data_finish;
reg [DATA_WIDTH - 1 : 0] mem_tensor_bytes [tensor_bytes_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_tensor_bytes [ (tensor_bytes_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * tensor_bytes_DEPTH -1 : 0] = '{default : 'hz};
reg tensor_bytes_read_data_finish;
reg [DATA_WIDTH - 1 : 0] mem_preview_bytes [preview_bytes_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_preview_bytes [ (preview_bytes_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * preview_bytes_DEPTH -1 : 0] = '{default : 'hz};
reg preview_bytes_read_data_finish;
reg [DATA_WIDTH - 1 : 0] mem_abi_version [abi_version_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_abi_version [ (abi_version_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * abi_version_DEPTH -1 : 0] = '{default : 'hz};
reg abi_version_read_data_finish;
reg [DATA_WIDTH - 1 : 0] mem_ap_return [ap_return_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_ap_return [ (ap_return_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * ap_return_DEPTH -1 : 0] = '{default : 'hz};
reg ap_return_read_data_finish;
reg AESL_ready_out_index_reg = 0;
reg AESL_write_start_finish = 0;
reg AESL_ready_reg;
reg ready_initial;
reg AESL_done_index_reg = 0;
reg AESL_idle_index_reg = 0;
reg AESL_auto_restart_index_reg;
reg process_0_finish = 0;
reg process_1_finish = 0;
reg process_2_finish = 0;
reg process_3_finish = 0;
reg process_4_finish = 0;
reg process_5_finish = 0;
reg process_6_finish = 0;
reg process_7_finish = 0;
reg process_8_finish = 0;
reg process_9_finish = 0;
reg process_10_finish = 0;
reg process_11_finish = 0;
reg process_12_finish = 0;
reg process_13_finish = 0;
reg process_14_finish = 0;
reg process_15_finish = 0;
reg process_16_finish = 0;
reg process_17_finish = 0;
reg process_18_finish = 0;
reg process_19_finish = 0;
reg process_20_finish = 0;
reg process_21_finish = 0;
reg process_22_finish = 0;
reg process_23_finish = 0;
reg process_24_finish = 0;
reg process_25_finish = 0;
reg process_26_finish = 0;
reg process_27_finish = 0;
reg process_28_finish = 0;
//write src reg
reg [31 : 0] write_src_count = 0;
reg write_src_run_flag = 0;
reg write_one_src_data_done = 0;
//write tensor reg
reg [31 : 0] write_tensor_count = 0;
reg write_tensor_run_flag = 0;
reg write_one_tensor_data_done = 0;
//write preview reg
reg [31 : 0] write_preview_count = 0;
reg write_preview_run_flag = 0;
reg write_one_preview_data_done = 0;
//write luts reg
reg [31 : 0] write_luts_count = 0;
reg write_luts_run_flag = 0;
reg write_one_luts_data_done = 0;
//write width reg
reg [31 : 0] write_width_count = 0;
reg write_width_run_flag = 0;
reg write_one_width_data_done = 0;
//write height reg
reg [31 : 0] write_height_count = 0;
reg write_height_run_flag = 0;
reg write_one_height_data_done = 0;
//write src_stride reg
reg [31 : 0] write_src_stride_count = 0;
reg write_src_stride_run_flag = 0;
reg write_one_src_stride_data_done = 0;
//write src_capacity reg
reg [31 : 0] write_src_capacity_count = 0;
reg write_src_capacity_run_flag = 0;
reg write_one_src_capacity_data_done = 0;
//write tensor_capacity reg
reg [31 : 0] write_tensor_capacity_count = 0;
reg write_tensor_capacity_run_flag = 0;
reg write_one_tensor_capacity_data_done = 0;
//write preview_stride reg
reg [31 : 0] write_preview_stride_count = 0;
reg write_preview_stride_run_flag = 0;
reg write_one_preview_stride_data_done = 0;
//write preview_capacity reg
reg [31 : 0] write_preview_capacity_count = 0;
reg write_preview_capacity_run_flag = 0;
reg write_one_preview_capacity_data_done = 0;
//write resized_w reg
reg [31 : 0] write_resized_w_count = 0;
reg write_resized_w_run_flag = 0;
reg write_one_resized_w_data_done = 0;
//write resized_h reg
reg [31 : 0] write_resized_h_count = 0;
reg write_resized_h_run_flag = 0;
reg write_one_resized_h_data_done = 0;
//write pad_x reg
reg [31 : 0] write_pad_x_count = 0;
reg write_pad_x_run_flag = 0;
reg write_one_pad_x_data_done = 0;
//write pad_y reg
reg [31 : 0] write_pad_y_count = 0;
reg write_pad_y_run_flag = 0;
reg write_one_pad_y_data_done = 0;
//write output_mode reg
reg [31 : 0] write_output_mode_count = 0;
reg write_output_mode_run_flag = 0;
reg write_one_output_mode_data_done = 0;
//write flags reg
reg [31 : 0] write_flags_count = 0;
reg write_flags_run_flag = 0;
reg write_one_flags_data_done = 0;
//write eq_mode reg
reg [31 : 0] write_eq_mode_count = 0;
reg write_eq_mode_run_flag = 0;
reg write_one_eq_mode_data_done = 0;
//write saturation_q12 reg
reg [31 : 0] write_saturation_q12_count = 0;
reg write_saturation_q12_run_flag = 0;
reg write_one_saturation_q12_data_done = 0;
//write frame_id reg
reg [31 : 0] write_frame_id_count = 0;
reg write_frame_id_run_flag = 0;
reg write_one_frame_id_data_done = 0;
//write config_id reg
reg [31 : 0] write_config_id_count = 0;
reg write_config_id_run_flag = 0;
reg write_one_config_id_data_done = 0;
//read completed_frame_id reg
reg [31 : 0] read_completed_frame_id_count = 0;
reg read_completed_frame_id_run_flag = 0;
reg read_one_completed_frame_id_data_done = 0;
//read completed_config_id reg
reg [31 : 0] read_completed_config_id_count = 0;
reg read_completed_config_id_run_flag = 0;
reg read_one_completed_config_id_data_done = 0;
//read tensor_bytes reg
reg [31 : 0] read_tensor_bytes_count = 0;
reg read_tensor_bytes_run_flag = 0;
reg read_one_tensor_bytes_data_done = 0;
//read preview_bytes reg
reg [31 : 0] read_preview_bytes_count = 0;
reg read_preview_bytes_run_flag = 0;
reg read_one_preview_bytes_data_done = 0;
//read abi_version reg
reg [31 : 0] read_abi_version_count = 0;
reg read_abi_version_run_flag = 0;
reg read_one_abi_version_data_done = 0;
//read ap_return reg
reg [31 : 0] read_ap_return_count = 0;
reg read_ap_return_run_flag = 0;
reg read_one_ap_return_data_done = 0;
reg [31 : 0] write_start_count = 0;
reg write_start_run_flag = 0;

//===================process control=================
reg [31 : 0] ongoing_process_number = 0;
//process number depends on how much processes needed.
reg process_busy = 0;

//=================== signal connection ==============
assign TRAN_s_axi_control_AWADDR = AWADDR_reg;
assign TRAN_s_axi_control_AWVALID = AWVALID_reg;
assign TRAN_s_axi_control_WVALID = WVALID_reg;
assign TRAN_s_axi_control_WDATA = WDATA_reg;
assign TRAN_s_axi_control_WSTRB = WSTRB_reg;
assign TRAN_s_axi_control_ARADDR = ARADDR_reg;
assign TRAN_s_axi_control_ARVALID = ARVALID_reg;
assign TRAN_s_axi_control_RREADY = RREADY_reg;
assign TRAN_s_axi_control_BREADY = BREADY_reg;
assign TRAN_control_write_start_finish = AESL_write_start_finish;
assign TRAN_control_done_out = AESL_done_index_reg;
assign TRAN_control_ready_out = AESL_ready_out_index_reg;
assign TRAN_control_idle_out = AESL_idle_index_reg;
assign TRAN_control_read_data_finish = 1 & completed_frame_id_read_data_finish & completed_config_id_read_data_finish & tensor_bytes_read_data_finish & preview_bytes_read_data_finish & abi_version_read_data_finish & ap_return_read_data_finish;
assign TRAN_control_write_data_finish = 1 & src_write_data_finish & tensor_write_data_finish & preview_write_data_finish & luts_write_data_finish & width_write_data_finish & height_write_data_finish & src_stride_write_data_finish & src_capacity_write_data_finish & tensor_capacity_write_data_finish & preview_stride_write_data_finish & preview_capacity_write_data_finish & resized_w_write_data_finish & resized_h_write_data_finish & pad_x_write_data_finish & pad_y_write_data_finish & output_mode_write_data_finish & flags_write_data_finish & eq_mode_write_data_finish & saturation_q12_write_data_finish & frame_id_write_data_finish & config_id_write_data_finish;
always @(TRAN_control_ready_in or ready_initial) 
begin
    AESL_ready_reg <= TRAN_control_ready_in | ready_initial;
end

always @(reset or process_0_finish or process_1_finish or process_2_finish or process_3_finish or process_4_finish or process_5_finish or process_6_finish or process_7_finish or process_8_finish or process_9_finish or process_10_finish or process_11_finish or process_12_finish or process_13_finish or process_14_finish or process_15_finish or process_16_finish or process_17_finish or process_18_finish or process_19_finish or process_20_finish or process_21_finish or process_22_finish or process_23_finish or process_24_finish or process_25_finish or process_26_finish or process_27_finish or process_28_finish ) begin
    if (reset == 0) begin
        ongoing_process_number <= 0;
    end
    else if (ongoing_process_number == 0 && process_0_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 1 && process_1_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 2 && process_2_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 3 && process_3_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 4 && process_4_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 5 && process_5_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 6 && process_6_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 7 && process_7_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 8 && process_8_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 9 && process_9_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 10 && process_10_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 11 && process_11_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 12 && process_12_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 13 && process_13_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 14 && process_14_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 15 && process_15_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 16 && process_16_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 17 && process_17_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 18 && process_18_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 19 && process_19_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 20 && process_20_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 21 && process_21_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 22 && process_22_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 23 && process_23_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 24 && process_24_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 25 && process_25_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 26 && process_26_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 27 && process_27_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 28 && process_28_finish == 1) begin
            ongoing_process_number <= 0;
    end
end

task count_c_data_four_byte_num_by_bitwidth;
input  integer bitwidth;
output integer num;
integer factor;
integer i;
begin
    factor = 32;
    for (i = 1; i <= 1024; i = i + 1) begin
        if (bitwidth <= factor && bitwidth > factor - 32) begin
            num = i;
        end
        factor = factor + 32;
    end
end    
endtask

task count_seperate_factor_by_bitwidth;
input  integer bitwidth;
output integer factor;
begin
    if (bitwidth <= 8) begin
        factor=4;
    end
    if (bitwidth <= 16 & bitwidth > 8 ) begin
        factor=2;
    end
    if (bitwidth <= 32 & bitwidth > 16 ) begin
        factor=1;
    end
    if (bitwidth > 32 ) begin
        factor=1;
    end
end    
endtask

task count_operate_depth_by_bitwidth_and_depth;
input  integer bitwidth;
input  integer depth;
output integer operate_depth;
integer factor;
integer remain;
begin
    count_seperate_factor_by_bitwidth (bitwidth , factor);
    operate_depth = depth / factor;
    remain = depth % factor;
    if (remain > 0) begin
        operate_depth = operate_depth + 1;
    end
end    
endtask

task write; /*{{{*/
    input  reg [ADDR_WIDTH - 1:0] waddr;   // write address
    input  reg [DATA_WIDTH - 1:0] wdata;   // write data
    output reg wresp;
    reg aw_flag;
    reg w_flag;
    reg [DATA_WIDTH/8 - 1:0] wstrb_reg;
    integer i;
begin 
    wresp = 0;
    aw_flag = 0;
    w_flag = 0;
//=======================one single write operate======================
    AWADDR_reg <= waddr;
    AWVALID_reg <= 1;
    WDATA_reg <= wdata;
    WVALID_reg <= 1;
    for (i = 0; i < DATA_WIDTH/8; i = i + 1) begin
        wstrb_reg [i] = 1;
    end    
    WSTRB_reg <= wstrb_reg;
    while (!(aw_flag && w_flag)) begin
        @(posedge clk);
        if (aw_flag != 1)
            aw_flag = TRAN_s_axi_control_AWREADY & AWVALID_reg;
        if (w_flag != 1)
            w_flag = TRAN_s_axi_control_WREADY & WVALID_reg;
        AWVALID_reg <= !aw_flag;
        WVALID_reg <= !w_flag;
    end

    BREADY_reg <= 1;
    while (TRAN_s_axi_control_BVALID != 1) begin
        //wait for response 
        @(posedge clk);
    end
    @(posedge clk);
    BREADY_reg <= 0;
    if (TRAN_s_axi_control_BRESP === 2'b00) begin
        wresp = 1;
        //input success. in fact BRESP is always 2'b00
    end   
//=======================one single write operate======================

end
endtask/*}}}*/

task read (/*{{{*/
    input  [ADDR_WIDTH - 1:0] raddr ,   // write address
    output [DATA_WIDTH - 1:0] RDATA_result ,
    output rresp
);
begin 
    rresp = 0;
//=======================one single read operate======================
    ARADDR_reg <= raddr;
    ARVALID_reg <= 1;
    while (TRAN_s_axi_control_ARREADY !== 1) begin
        @(posedge clk);
    end
    @(posedge clk);
    ARVALID_reg <= 0;
    RREADY_reg <= 1;
    while (TRAN_s_axi_control_RVALID !== 1) begin
        //wait for response 
        @(posedge clk);
    end
    @(posedge clk);
    RDATA_result  <= TRAN_s_axi_control_RDATA;
    RREADY_reg <= 0;
    if (TRAN_s_axi_control_RRESP === 2'b00 ) begin
        rresp <= 1;
        //output success. in fact RRESP is always 2'b00
    end  
    @(posedge clk);

//=======================one single read operate end======================

end
endtask/*}}}*/

initial begin : ready_initial_process
    ready_initial = 0;
    wait(reset === 1);
    @(posedge clk);
    ready_initial = 1;
    @(posedge clk);
    ready_initial = 0;
end

initial begin : update_status
    integer process_num ;
    integer read_status_resp;
    wait(reset === 1);
    @(posedge clk);
    process_num = 0;
    while (1) begin
        process_0_finish = 0;
        AESL_done_index_reg         <= 0;
        AESL_ready_out_index_reg        <= 0;
        if (ongoing_process_number === process_num && process_busy === 0) begin
            process_busy = 1;
            read (STATUS_ADDR, RDATA_reg, read_status_resp);
                AESL_done_index_reg         <= RDATA_reg[1 : 1];
                AESL_ready_out_index_reg    <= RDATA_reg[1 : 1];
                AESL_idle_index_reg         <= RDATA_reg[2 : 2];
            process_0_finish = 1;
            process_busy = 0;
        end 
        @(posedge clk);
    end
end

always @(reset or posedge clk) begin
    if (reset == 0) begin
        src_write_data_finish <= 0;
        write_src_run_flag <= 0; 
        write_src_count = 0;
        count_operate_depth_by_bitwidth_and_depth (src_c_bitwidth, src_DEPTH, src_OPERATE_DEPTH);
    end
    else begin
        if (TRAN_control_start_in === 1) begin
            src_write_data_finish <= 0;
        end
        if (AESL_ready_reg === 1) begin
            write_src_run_flag <= 1; 
            write_src_count = 0;
        end
        if (write_one_src_data_done === 1) begin
            write_src_count = write_src_count + 1;
            if (write_src_count == src_OPERATE_DEPTH) begin
                write_src_run_flag <= 0; 
                src_write_data_finish <= 1;
            end
        end
    end
end

initial begin : write_src
    integer write_src_resp;
    integer process_num ;
    integer get_ack;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;
    reg [31 : 0] src_data_tmp_reg;
    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = src_c_bitwidth;
    process_num = 1;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_1_finish <= 0;

        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            get_ack = 1;
            if (write_src_run_flag === 1 && get_ack === 1) begin
                process_busy = 1;
                //write src data 
                for (i = 0 ; i < four_byte_num ; i = i+1) begin
                    if (src_c_bitwidth < 32) begin
                        src_data_tmp_reg = mem_src[write_src_count];
                    end
                    else begin
                        for (j=0 ; j<32 ; j = j + 1) begin
                            if (i*32 + j < src_c_bitwidth) begin
                                src_data_tmp_reg[j] = mem_src[write_src_count][i*32 + j];
                            end
                            else begin
                                src_data_tmp_reg[j] = 0;
                            end
                        end
                    end
                    if(image_mem_src[write_src_count * four_byte_num  + i]!==src_data_tmp_reg) begin
                    write (src_data_in_addr + write_src_count * four_byte_num * 4 + i * 4, src_data_tmp_reg, write_src_resp);
                    image_mem_src[write_src_count * four_byte_num + i]=src_data_tmp_reg;
                    end
                end
                process_busy = 0;
                write_one_src_data_done <= 1;
                @(posedge clk);
                write_one_src_data_done <= 0;
            end   
            process_1_finish <= 1;
        end
        @(posedge clk);
    end    
end
always @(reset or posedge clk) begin
    if (reset == 0) begin
        tensor_write_data_finish <= 0;
        write_tensor_run_flag <= 0; 
        write_tensor_count = 0;
        count_operate_depth_by_bitwidth_and_depth (tensor_c_bitwidth, tensor_DEPTH, tensor_OPERATE_DEPTH);
    end
    else begin
        if (TRAN_control_start_in === 1) begin
            tensor_write_data_finish <= 0;
        end
        if (AESL_ready_reg === 1) begin
            write_tensor_run_flag <= 1; 
            write_tensor_count = 0;
        end
        if (write_one_tensor_data_done === 1) begin
            write_tensor_count = write_tensor_count + 1;
            if (write_tensor_count == tensor_OPERATE_DEPTH) begin
                write_tensor_run_flag <= 0; 
                tensor_write_data_finish <= 1;
            end
        end
    end
end

initial begin : write_tensor
    integer write_tensor_resp;
    integer process_num ;
    integer get_ack;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;
    reg [31 : 0] tensor_data_tmp_reg;
    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = tensor_c_bitwidth;
    process_num = 2;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_2_finish <= 0;

        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            get_ack = 1;
            if (write_tensor_run_flag === 1 && get_ack === 1) begin
                process_busy = 1;
                //write tensor data 
                for (i = 0 ; i < four_byte_num ; i = i+1) begin
                    if (tensor_c_bitwidth < 32) begin
                        tensor_data_tmp_reg = mem_tensor[write_tensor_count];
                    end
                    else begin
                        for (j=0 ; j<32 ; j = j + 1) begin
                            if (i*32 + j < tensor_c_bitwidth) begin
                                tensor_data_tmp_reg[j] = mem_tensor[write_tensor_count][i*32 + j];
                            end
                            else begin
                                tensor_data_tmp_reg[j] = 0;
                            end
                        end
                    end
                    if(image_mem_tensor[write_tensor_count * four_byte_num  + i]!==tensor_data_tmp_reg) begin
                    write (tensor_data_in_addr + write_tensor_count * four_byte_num * 4 + i * 4, tensor_data_tmp_reg, write_tensor_resp);
                    image_mem_tensor[write_tensor_count * four_byte_num + i]=tensor_data_tmp_reg;
                    end
                end
                process_busy = 0;
                write_one_tensor_data_done <= 1;
                @(posedge clk);
                write_one_tensor_data_done <= 0;
            end   
            process_2_finish <= 1;
        end
        @(posedge clk);
    end    
end
always @(reset or posedge clk) begin
    if (reset == 0) begin
        preview_write_data_finish <= 0;
        write_preview_run_flag <= 0; 
        write_preview_count = 0;
        count_operate_depth_by_bitwidth_and_depth (preview_c_bitwidth, preview_DEPTH, preview_OPERATE_DEPTH);
    end
    else begin
        if (TRAN_control_start_in === 1) begin
            preview_write_data_finish <= 0;
        end
        if (AESL_ready_reg === 1) begin
            write_preview_run_flag <= 1; 
            write_preview_count = 0;
        end
        if (write_one_preview_data_done === 1) begin
            write_preview_count = write_preview_count + 1;
            if (write_preview_count == preview_OPERATE_DEPTH) begin
                write_preview_run_flag <= 0; 
                preview_write_data_finish <= 1;
            end
        end
    end
end

initial begin : write_preview
    integer write_preview_resp;
    integer process_num ;
    integer get_ack;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;
    reg [31 : 0] preview_data_tmp_reg;
    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = preview_c_bitwidth;
    process_num = 3;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_3_finish <= 0;

        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            get_ack = 1;
            if (write_preview_run_flag === 1 && get_ack === 1) begin
                process_busy = 1;
                //write preview data 
                for (i = 0 ; i < four_byte_num ; i = i+1) begin
                    if (preview_c_bitwidth < 32) begin
                        preview_data_tmp_reg = mem_preview[write_preview_count];
                    end
                    else begin
                        for (j=0 ; j<32 ; j = j + 1) begin
                            if (i*32 + j < preview_c_bitwidth) begin
                                preview_data_tmp_reg[j] = mem_preview[write_preview_count][i*32 + j];
                            end
                            else begin
                                preview_data_tmp_reg[j] = 0;
                            end
                        end
                    end
                    if(image_mem_preview[write_preview_count * four_byte_num  + i]!==preview_data_tmp_reg) begin
                    write (preview_data_in_addr + write_preview_count * four_byte_num * 4 + i * 4, preview_data_tmp_reg, write_preview_resp);
                    image_mem_preview[write_preview_count * four_byte_num + i]=preview_data_tmp_reg;
                    end
                end
                process_busy = 0;
                write_one_preview_data_done <= 1;
                @(posedge clk);
                write_one_preview_data_done <= 0;
            end   
            process_3_finish <= 1;
        end
        @(posedge clk);
    end    
end
always @(reset or posedge clk) begin
    if (reset == 0) begin
        luts_write_data_finish <= 0;
        write_luts_run_flag <= 0; 
        write_luts_count = 0;
        count_operate_depth_by_bitwidth_and_depth (luts_c_bitwidth, luts_DEPTH, luts_OPERATE_DEPTH);
    end
    else begin
        if (TRAN_control_start_in === 1) begin
            luts_write_data_finish <= 0;
        end
        if (AESL_ready_reg === 1) begin
            write_luts_run_flag <= 1; 
            write_luts_count = 0;
        end
        if (write_one_luts_data_done === 1) begin
            write_luts_count = write_luts_count + 1;
            if (write_luts_count == luts_OPERATE_DEPTH) begin
                write_luts_run_flag <= 0; 
                luts_write_data_finish <= 1;
            end
        end
    end
end

initial begin : write_luts
    integer write_luts_resp;
    integer process_num ;
    integer get_ack;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;
    reg [31 : 0] luts_data_tmp_reg;
    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = luts_c_bitwidth;
    process_num = 4;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_4_finish <= 0;

        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            get_ack = 1;
            if (write_luts_run_flag === 1 && get_ack === 1) begin
                process_busy = 1;
                //write luts data 
                for (i = 0 ; i < four_byte_num ; i = i+1) begin
                    if (luts_c_bitwidth < 32) begin
                        luts_data_tmp_reg = mem_luts[write_luts_count];
                    end
                    else begin
                        for (j=0 ; j<32 ; j = j + 1) begin
                            if (i*32 + j < luts_c_bitwidth) begin
                                luts_data_tmp_reg[j] = mem_luts[write_luts_count][i*32 + j];
                            end
                            else begin
                                luts_data_tmp_reg[j] = 0;
                            end
                        end
                    end
                    if(image_mem_luts[write_luts_count * four_byte_num  + i]!==luts_data_tmp_reg) begin
                    write (luts_data_in_addr + write_luts_count * four_byte_num * 4 + i * 4, luts_data_tmp_reg, write_luts_resp);
                    image_mem_luts[write_luts_count * four_byte_num + i]=luts_data_tmp_reg;
                    end
                end
                process_busy = 0;
                write_one_luts_data_done <= 1;
                @(posedge clk);
                write_one_luts_data_done <= 0;
            end   
            process_4_finish <= 1;
        end
        @(posedge clk);
    end    
end
always @(reset or posedge clk) begin
    if (reset == 0) begin
        width_write_data_finish <= 0;
        write_width_run_flag <= 0; 
        write_width_count = 0;
        count_operate_depth_by_bitwidth_and_depth (width_c_bitwidth, width_DEPTH, width_OPERATE_DEPTH);
    end
    else begin
        if (TRAN_control_start_in === 1) begin
            width_write_data_finish <= 0;
        end
        if (AESL_ready_reg === 1) begin
            write_width_run_flag <= 1; 
            write_width_count = 0;
        end
        if (write_one_width_data_done === 1) begin
            write_width_count = write_width_count + 1;
            if (write_width_count == width_OPERATE_DEPTH) begin
                write_width_run_flag <= 0; 
                width_write_data_finish <= 1;
            end
        end
    end
end

initial begin : write_width
    integer write_width_resp;
    integer process_num ;
    integer get_ack;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;
    reg [31 : 0] width_data_tmp_reg;
    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = width_c_bitwidth;
    process_num = 5;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_5_finish <= 0;

        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            get_ack = 1;
            if (write_width_run_flag === 1 && get_ack === 1) begin
                process_busy = 1;
                //write width data 
                for (i = 0 ; i < four_byte_num ; i = i+1) begin
                    if (width_c_bitwidth < 32) begin
                        width_data_tmp_reg = mem_width[write_width_count];
                    end
                    else begin
                        for (j=0 ; j<32 ; j = j + 1) begin
                            if (i*32 + j < width_c_bitwidth) begin
                                width_data_tmp_reg[j] = mem_width[write_width_count][i*32 + j];
                            end
                            else begin
                                width_data_tmp_reg[j] = 0;
                            end
                        end
                    end
                    if(image_mem_width[write_width_count * four_byte_num  + i]!==width_data_tmp_reg) begin
                    write (width_data_in_addr + write_width_count * four_byte_num * 4 + i * 4, width_data_tmp_reg, write_width_resp);
                    image_mem_width[write_width_count * four_byte_num + i]=width_data_tmp_reg;
                    end
                end
                process_busy = 0;
                write_one_width_data_done <= 1;
                @(posedge clk);
                write_one_width_data_done <= 0;
            end   
            process_5_finish <= 1;
        end
        @(posedge clk);
    end    
end
always @(reset or posedge clk) begin
    if (reset == 0) begin
        height_write_data_finish <= 0;
        write_height_run_flag <= 0; 
        write_height_count = 0;
        count_operate_depth_by_bitwidth_and_depth (height_c_bitwidth, height_DEPTH, height_OPERATE_DEPTH);
    end
    else begin
        if (TRAN_control_start_in === 1) begin
            height_write_data_finish <= 0;
        end
        if (AESL_ready_reg === 1) begin
            write_height_run_flag <= 1; 
            write_height_count = 0;
        end
        if (write_one_height_data_done === 1) begin
            write_height_count = write_height_count + 1;
            if (write_height_count == height_OPERATE_DEPTH) begin
                write_height_run_flag <= 0; 
                height_write_data_finish <= 1;
            end
        end
    end
end

initial begin : write_height
    integer write_height_resp;
    integer process_num ;
    integer get_ack;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;
    reg [31 : 0] height_data_tmp_reg;
    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = height_c_bitwidth;
    process_num = 6;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_6_finish <= 0;

        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            get_ack = 1;
            if (write_height_run_flag === 1 && get_ack === 1) begin
                process_busy = 1;
                //write height data 
                for (i = 0 ; i < four_byte_num ; i = i+1) begin
                    if (height_c_bitwidth < 32) begin
                        height_data_tmp_reg = mem_height[write_height_count];
                    end
                    else begin
                        for (j=0 ; j<32 ; j = j + 1) begin
                            if (i*32 + j < height_c_bitwidth) begin
                                height_data_tmp_reg[j] = mem_height[write_height_count][i*32 + j];
                            end
                            else begin
                                height_data_tmp_reg[j] = 0;
                            end
                        end
                    end
                    if(image_mem_height[write_height_count * four_byte_num  + i]!==height_data_tmp_reg) begin
                    write (height_data_in_addr + write_height_count * four_byte_num * 4 + i * 4, height_data_tmp_reg, write_height_resp);
                    image_mem_height[write_height_count * four_byte_num + i]=height_data_tmp_reg;
                    end
                end
                process_busy = 0;
                write_one_height_data_done <= 1;
                @(posedge clk);
                write_one_height_data_done <= 0;
            end   
            process_6_finish <= 1;
        end
        @(posedge clk);
    end    
end
always @(reset or posedge clk) begin
    if (reset == 0) begin
        src_stride_write_data_finish <= 0;
        write_src_stride_run_flag <= 0; 
        write_src_stride_count = 0;
        count_operate_depth_by_bitwidth_and_depth (src_stride_c_bitwidth, src_stride_DEPTH, src_stride_OPERATE_DEPTH);
    end
    else begin
        if (TRAN_control_start_in === 1) begin
            src_stride_write_data_finish <= 0;
        end
        if (AESL_ready_reg === 1) begin
            write_src_stride_run_flag <= 1; 
            write_src_stride_count = 0;
        end
        if (write_one_src_stride_data_done === 1) begin
            write_src_stride_count = write_src_stride_count + 1;
            if (write_src_stride_count == src_stride_OPERATE_DEPTH) begin
                write_src_stride_run_flag <= 0; 
                src_stride_write_data_finish <= 1;
            end
        end
    end
end

initial begin : write_src_stride
    integer write_src_stride_resp;
    integer process_num ;
    integer get_ack;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;
    reg [31 : 0] src_stride_data_tmp_reg;
    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = src_stride_c_bitwidth;
    process_num = 7;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_7_finish <= 0;

        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            get_ack = 1;
            if (write_src_stride_run_flag === 1 && get_ack === 1) begin
                process_busy = 1;
                //write src_stride data 
                for (i = 0 ; i < four_byte_num ; i = i+1) begin
                    if (src_stride_c_bitwidth < 32) begin
                        src_stride_data_tmp_reg = mem_src_stride[write_src_stride_count];
                    end
                    else begin
                        for (j=0 ; j<32 ; j = j + 1) begin
                            if (i*32 + j < src_stride_c_bitwidth) begin
                                src_stride_data_tmp_reg[j] = mem_src_stride[write_src_stride_count][i*32 + j];
                            end
                            else begin
                                src_stride_data_tmp_reg[j] = 0;
                            end
                        end
                    end
                    if(image_mem_src_stride[write_src_stride_count * four_byte_num  + i]!==src_stride_data_tmp_reg) begin
                    write (src_stride_data_in_addr + write_src_stride_count * four_byte_num * 4 + i * 4, src_stride_data_tmp_reg, write_src_stride_resp);
                    image_mem_src_stride[write_src_stride_count * four_byte_num + i]=src_stride_data_tmp_reg;
                    end
                end
                process_busy = 0;
                write_one_src_stride_data_done <= 1;
                @(posedge clk);
                write_one_src_stride_data_done <= 0;
            end   
            process_7_finish <= 1;
        end
        @(posedge clk);
    end    
end
always @(reset or posedge clk) begin
    if (reset == 0) begin
        src_capacity_write_data_finish <= 0;
        write_src_capacity_run_flag <= 0; 
        write_src_capacity_count = 0;
        count_operate_depth_by_bitwidth_and_depth (src_capacity_c_bitwidth, src_capacity_DEPTH, src_capacity_OPERATE_DEPTH);
    end
    else begin
        if (TRAN_control_start_in === 1) begin
            src_capacity_write_data_finish <= 0;
        end
        if (AESL_ready_reg === 1) begin
            write_src_capacity_run_flag <= 1; 
            write_src_capacity_count = 0;
        end
        if (write_one_src_capacity_data_done === 1) begin
            write_src_capacity_count = write_src_capacity_count + 1;
            if (write_src_capacity_count == src_capacity_OPERATE_DEPTH) begin
                write_src_capacity_run_flag <= 0; 
                src_capacity_write_data_finish <= 1;
            end
        end
    end
end

initial begin : write_src_capacity
    integer write_src_capacity_resp;
    integer process_num ;
    integer get_ack;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;
    reg [31 : 0] src_capacity_data_tmp_reg;
    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = src_capacity_c_bitwidth;
    process_num = 8;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_8_finish <= 0;

        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            get_ack = 1;
            if (write_src_capacity_run_flag === 1 && get_ack === 1) begin
                process_busy = 1;
                //write src_capacity data 
                for (i = 0 ; i < four_byte_num ; i = i+1) begin
                    if (src_capacity_c_bitwidth < 32) begin
                        src_capacity_data_tmp_reg = mem_src_capacity[write_src_capacity_count];
                    end
                    else begin
                        for (j=0 ; j<32 ; j = j + 1) begin
                            if (i*32 + j < src_capacity_c_bitwidth) begin
                                src_capacity_data_tmp_reg[j] = mem_src_capacity[write_src_capacity_count][i*32 + j];
                            end
                            else begin
                                src_capacity_data_tmp_reg[j] = 0;
                            end
                        end
                    end
                    if(image_mem_src_capacity[write_src_capacity_count * four_byte_num  + i]!==src_capacity_data_tmp_reg) begin
                    write (src_capacity_data_in_addr + write_src_capacity_count * four_byte_num * 4 + i * 4, src_capacity_data_tmp_reg, write_src_capacity_resp);
                    image_mem_src_capacity[write_src_capacity_count * four_byte_num + i]=src_capacity_data_tmp_reg;
                    end
                end
                process_busy = 0;
                write_one_src_capacity_data_done <= 1;
                @(posedge clk);
                write_one_src_capacity_data_done <= 0;
            end   
            process_8_finish <= 1;
        end
        @(posedge clk);
    end    
end
always @(reset or posedge clk) begin
    if (reset == 0) begin
        tensor_capacity_write_data_finish <= 0;
        write_tensor_capacity_run_flag <= 0; 
        write_tensor_capacity_count = 0;
        count_operate_depth_by_bitwidth_and_depth (tensor_capacity_c_bitwidth, tensor_capacity_DEPTH, tensor_capacity_OPERATE_DEPTH);
    end
    else begin
        if (TRAN_control_start_in === 1) begin
            tensor_capacity_write_data_finish <= 0;
        end
        if (AESL_ready_reg === 1) begin
            write_tensor_capacity_run_flag <= 1; 
            write_tensor_capacity_count = 0;
        end
        if (write_one_tensor_capacity_data_done === 1) begin
            write_tensor_capacity_count = write_tensor_capacity_count + 1;
            if (write_tensor_capacity_count == tensor_capacity_OPERATE_DEPTH) begin
                write_tensor_capacity_run_flag <= 0; 
                tensor_capacity_write_data_finish <= 1;
            end
        end
    end
end

initial begin : write_tensor_capacity
    integer write_tensor_capacity_resp;
    integer process_num ;
    integer get_ack;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;
    reg [31 : 0] tensor_capacity_data_tmp_reg;
    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = tensor_capacity_c_bitwidth;
    process_num = 9;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_9_finish <= 0;

        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            get_ack = 1;
            if (write_tensor_capacity_run_flag === 1 && get_ack === 1) begin
                process_busy = 1;
                //write tensor_capacity data 
                for (i = 0 ; i < four_byte_num ; i = i+1) begin
                    if (tensor_capacity_c_bitwidth < 32) begin
                        tensor_capacity_data_tmp_reg = mem_tensor_capacity[write_tensor_capacity_count];
                    end
                    else begin
                        for (j=0 ; j<32 ; j = j + 1) begin
                            if (i*32 + j < tensor_capacity_c_bitwidth) begin
                                tensor_capacity_data_tmp_reg[j] = mem_tensor_capacity[write_tensor_capacity_count][i*32 + j];
                            end
                            else begin
                                tensor_capacity_data_tmp_reg[j] = 0;
                            end
                        end
                    end
                    if(image_mem_tensor_capacity[write_tensor_capacity_count * four_byte_num  + i]!==tensor_capacity_data_tmp_reg) begin
                    write (tensor_capacity_data_in_addr + write_tensor_capacity_count * four_byte_num * 4 + i * 4, tensor_capacity_data_tmp_reg, write_tensor_capacity_resp);
                    image_mem_tensor_capacity[write_tensor_capacity_count * four_byte_num + i]=tensor_capacity_data_tmp_reg;
                    end
                end
                process_busy = 0;
                write_one_tensor_capacity_data_done <= 1;
                @(posedge clk);
                write_one_tensor_capacity_data_done <= 0;
            end   
            process_9_finish <= 1;
        end
        @(posedge clk);
    end    
end
always @(reset or posedge clk) begin
    if (reset == 0) begin
        preview_stride_write_data_finish <= 0;
        write_preview_stride_run_flag <= 0; 
        write_preview_stride_count = 0;
        count_operate_depth_by_bitwidth_and_depth (preview_stride_c_bitwidth, preview_stride_DEPTH, preview_stride_OPERATE_DEPTH);
    end
    else begin
        if (TRAN_control_start_in === 1) begin
            preview_stride_write_data_finish <= 0;
        end
        if (AESL_ready_reg === 1) begin
            write_preview_stride_run_flag <= 1; 
            write_preview_stride_count = 0;
        end
        if (write_one_preview_stride_data_done === 1) begin
            write_preview_stride_count = write_preview_stride_count + 1;
            if (write_preview_stride_count == preview_stride_OPERATE_DEPTH) begin
                write_preview_stride_run_flag <= 0; 
                preview_stride_write_data_finish <= 1;
            end
        end
    end
end

initial begin : write_preview_stride
    integer write_preview_stride_resp;
    integer process_num ;
    integer get_ack;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;
    reg [31 : 0] preview_stride_data_tmp_reg;
    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = preview_stride_c_bitwidth;
    process_num = 10;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_10_finish <= 0;

        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            get_ack = 1;
            if (write_preview_stride_run_flag === 1 && get_ack === 1) begin
                process_busy = 1;
                //write preview_stride data 
                for (i = 0 ; i < four_byte_num ; i = i+1) begin
                    if (preview_stride_c_bitwidth < 32) begin
                        preview_stride_data_tmp_reg = mem_preview_stride[write_preview_stride_count];
                    end
                    else begin
                        for (j=0 ; j<32 ; j = j + 1) begin
                            if (i*32 + j < preview_stride_c_bitwidth) begin
                                preview_stride_data_tmp_reg[j] = mem_preview_stride[write_preview_stride_count][i*32 + j];
                            end
                            else begin
                                preview_stride_data_tmp_reg[j] = 0;
                            end
                        end
                    end
                    if(image_mem_preview_stride[write_preview_stride_count * four_byte_num  + i]!==preview_stride_data_tmp_reg) begin
                    write (preview_stride_data_in_addr + write_preview_stride_count * four_byte_num * 4 + i * 4, preview_stride_data_tmp_reg, write_preview_stride_resp);
                    image_mem_preview_stride[write_preview_stride_count * four_byte_num + i]=preview_stride_data_tmp_reg;
                    end
                end
                process_busy = 0;
                write_one_preview_stride_data_done <= 1;
                @(posedge clk);
                write_one_preview_stride_data_done <= 0;
            end   
            process_10_finish <= 1;
        end
        @(posedge clk);
    end    
end
always @(reset or posedge clk) begin
    if (reset == 0) begin
        preview_capacity_write_data_finish <= 0;
        write_preview_capacity_run_flag <= 0; 
        write_preview_capacity_count = 0;
        count_operate_depth_by_bitwidth_and_depth (preview_capacity_c_bitwidth, preview_capacity_DEPTH, preview_capacity_OPERATE_DEPTH);
    end
    else begin
        if (TRAN_control_start_in === 1) begin
            preview_capacity_write_data_finish <= 0;
        end
        if (AESL_ready_reg === 1) begin
            write_preview_capacity_run_flag <= 1; 
            write_preview_capacity_count = 0;
        end
        if (write_one_preview_capacity_data_done === 1) begin
            write_preview_capacity_count = write_preview_capacity_count + 1;
            if (write_preview_capacity_count == preview_capacity_OPERATE_DEPTH) begin
                write_preview_capacity_run_flag <= 0; 
                preview_capacity_write_data_finish <= 1;
            end
        end
    end
end

initial begin : write_preview_capacity
    integer write_preview_capacity_resp;
    integer process_num ;
    integer get_ack;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;
    reg [31 : 0] preview_capacity_data_tmp_reg;
    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = preview_capacity_c_bitwidth;
    process_num = 11;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_11_finish <= 0;

        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            get_ack = 1;
            if (write_preview_capacity_run_flag === 1 && get_ack === 1) begin
                process_busy = 1;
                //write preview_capacity data 
                for (i = 0 ; i < four_byte_num ; i = i+1) begin
                    if (preview_capacity_c_bitwidth < 32) begin
                        preview_capacity_data_tmp_reg = mem_preview_capacity[write_preview_capacity_count];
                    end
                    else begin
                        for (j=0 ; j<32 ; j = j + 1) begin
                            if (i*32 + j < preview_capacity_c_bitwidth) begin
                                preview_capacity_data_tmp_reg[j] = mem_preview_capacity[write_preview_capacity_count][i*32 + j];
                            end
                            else begin
                                preview_capacity_data_tmp_reg[j] = 0;
                            end
                        end
                    end
                    if(image_mem_preview_capacity[write_preview_capacity_count * four_byte_num  + i]!==preview_capacity_data_tmp_reg) begin
                    write (preview_capacity_data_in_addr + write_preview_capacity_count * four_byte_num * 4 + i * 4, preview_capacity_data_tmp_reg, write_preview_capacity_resp);
                    image_mem_preview_capacity[write_preview_capacity_count * four_byte_num + i]=preview_capacity_data_tmp_reg;
                    end
                end
                process_busy = 0;
                write_one_preview_capacity_data_done <= 1;
                @(posedge clk);
                write_one_preview_capacity_data_done <= 0;
            end   
            process_11_finish <= 1;
        end
        @(posedge clk);
    end    
end
always @(reset or posedge clk) begin
    if (reset == 0) begin
        resized_w_write_data_finish <= 0;
        write_resized_w_run_flag <= 0; 
        write_resized_w_count = 0;
        count_operate_depth_by_bitwidth_and_depth (resized_w_c_bitwidth, resized_w_DEPTH, resized_w_OPERATE_DEPTH);
    end
    else begin
        if (TRAN_control_start_in === 1) begin
            resized_w_write_data_finish <= 0;
        end
        if (AESL_ready_reg === 1) begin
            write_resized_w_run_flag <= 1; 
            write_resized_w_count = 0;
        end
        if (write_one_resized_w_data_done === 1) begin
            write_resized_w_count = write_resized_w_count + 1;
            if (write_resized_w_count == resized_w_OPERATE_DEPTH) begin
                write_resized_w_run_flag <= 0; 
                resized_w_write_data_finish <= 1;
            end
        end
    end
end

initial begin : write_resized_w
    integer write_resized_w_resp;
    integer process_num ;
    integer get_ack;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;
    reg [31 : 0] resized_w_data_tmp_reg;
    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = resized_w_c_bitwidth;
    process_num = 12;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_12_finish <= 0;

        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            get_ack = 1;
            if (write_resized_w_run_flag === 1 && get_ack === 1) begin
                process_busy = 1;
                //write resized_w data 
                for (i = 0 ; i < four_byte_num ; i = i+1) begin
                    if (resized_w_c_bitwidth < 32) begin
                        resized_w_data_tmp_reg = mem_resized_w[write_resized_w_count];
                    end
                    else begin
                        for (j=0 ; j<32 ; j = j + 1) begin
                            if (i*32 + j < resized_w_c_bitwidth) begin
                                resized_w_data_tmp_reg[j] = mem_resized_w[write_resized_w_count][i*32 + j];
                            end
                            else begin
                                resized_w_data_tmp_reg[j] = 0;
                            end
                        end
                    end
                    if(image_mem_resized_w[write_resized_w_count * four_byte_num  + i]!==resized_w_data_tmp_reg) begin
                    write (resized_w_data_in_addr + write_resized_w_count * four_byte_num * 4 + i * 4, resized_w_data_tmp_reg, write_resized_w_resp);
                    image_mem_resized_w[write_resized_w_count * four_byte_num + i]=resized_w_data_tmp_reg;
                    end
                end
                process_busy = 0;
                write_one_resized_w_data_done <= 1;
                @(posedge clk);
                write_one_resized_w_data_done <= 0;
            end   
            process_12_finish <= 1;
        end
        @(posedge clk);
    end    
end
always @(reset or posedge clk) begin
    if (reset == 0) begin
        resized_h_write_data_finish <= 0;
        write_resized_h_run_flag <= 0; 
        write_resized_h_count = 0;
        count_operate_depth_by_bitwidth_and_depth (resized_h_c_bitwidth, resized_h_DEPTH, resized_h_OPERATE_DEPTH);
    end
    else begin
        if (TRAN_control_start_in === 1) begin
            resized_h_write_data_finish <= 0;
        end
        if (AESL_ready_reg === 1) begin
            write_resized_h_run_flag <= 1; 
            write_resized_h_count = 0;
        end
        if (write_one_resized_h_data_done === 1) begin
            write_resized_h_count = write_resized_h_count + 1;
            if (write_resized_h_count == resized_h_OPERATE_DEPTH) begin
                write_resized_h_run_flag <= 0; 
                resized_h_write_data_finish <= 1;
            end
        end
    end
end

initial begin : write_resized_h
    integer write_resized_h_resp;
    integer process_num ;
    integer get_ack;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;
    reg [31 : 0] resized_h_data_tmp_reg;
    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = resized_h_c_bitwidth;
    process_num = 13;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_13_finish <= 0;

        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            get_ack = 1;
            if (write_resized_h_run_flag === 1 && get_ack === 1) begin
                process_busy = 1;
                //write resized_h data 
                for (i = 0 ; i < four_byte_num ; i = i+1) begin
                    if (resized_h_c_bitwidth < 32) begin
                        resized_h_data_tmp_reg = mem_resized_h[write_resized_h_count];
                    end
                    else begin
                        for (j=0 ; j<32 ; j = j + 1) begin
                            if (i*32 + j < resized_h_c_bitwidth) begin
                                resized_h_data_tmp_reg[j] = mem_resized_h[write_resized_h_count][i*32 + j];
                            end
                            else begin
                                resized_h_data_tmp_reg[j] = 0;
                            end
                        end
                    end
                    if(image_mem_resized_h[write_resized_h_count * four_byte_num  + i]!==resized_h_data_tmp_reg) begin
                    write (resized_h_data_in_addr + write_resized_h_count * four_byte_num * 4 + i * 4, resized_h_data_tmp_reg, write_resized_h_resp);
                    image_mem_resized_h[write_resized_h_count * four_byte_num + i]=resized_h_data_tmp_reg;
                    end
                end
                process_busy = 0;
                write_one_resized_h_data_done <= 1;
                @(posedge clk);
                write_one_resized_h_data_done <= 0;
            end   
            process_13_finish <= 1;
        end
        @(posedge clk);
    end    
end
always @(reset or posedge clk) begin
    if (reset == 0) begin
        pad_x_write_data_finish <= 0;
        write_pad_x_run_flag <= 0; 
        write_pad_x_count = 0;
        count_operate_depth_by_bitwidth_and_depth (pad_x_c_bitwidth, pad_x_DEPTH, pad_x_OPERATE_DEPTH);
    end
    else begin
        if (TRAN_control_start_in === 1) begin
            pad_x_write_data_finish <= 0;
        end
        if (AESL_ready_reg === 1) begin
            write_pad_x_run_flag <= 1; 
            write_pad_x_count = 0;
        end
        if (write_one_pad_x_data_done === 1) begin
            write_pad_x_count = write_pad_x_count + 1;
            if (write_pad_x_count == pad_x_OPERATE_DEPTH) begin
                write_pad_x_run_flag <= 0; 
                pad_x_write_data_finish <= 1;
            end
        end
    end
end

initial begin : write_pad_x
    integer write_pad_x_resp;
    integer process_num ;
    integer get_ack;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;
    reg [31 : 0] pad_x_data_tmp_reg;
    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = pad_x_c_bitwidth;
    process_num = 14;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_14_finish <= 0;

        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            get_ack = 1;
            if (write_pad_x_run_flag === 1 && get_ack === 1) begin
                process_busy = 1;
                //write pad_x data 
                for (i = 0 ; i < four_byte_num ; i = i+1) begin
                    if (pad_x_c_bitwidth < 32) begin
                        pad_x_data_tmp_reg = mem_pad_x[write_pad_x_count];
                    end
                    else begin
                        for (j=0 ; j<32 ; j = j + 1) begin
                            if (i*32 + j < pad_x_c_bitwidth) begin
                                pad_x_data_tmp_reg[j] = mem_pad_x[write_pad_x_count][i*32 + j];
                            end
                            else begin
                                pad_x_data_tmp_reg[j] = 0;
                            end
                        end
                    end
                    if(image_mem_pad_x[write_pad_x_count * four_byte_num  + i]!==pad_x_data_tmp_reg) begin
                    write (pad_x_data_in_addr + write_pad_x_count * four_byte_num * 4 + i * 4, pad_x_data_tmp_reg, write_pad_x_resp);
                    image_mem_pad_x[write_pad_x_count * four_byte_num + i]=pad_x_data_tmp_reg;
                    end
                end
                process_busy = 0;
                write_one_pad_x_data_done <= 1;
                @(posedge clk);
                write_one_pad_x_data_done <= 0;
            end   
            process_14_finish <= 1;
        end
        @(posedge clk);
    end    
end
always @(reset or posedge clk) begin
    if (reset == 0) begin
        pad_y_write_data_finish <= 0;
        write_pad_y_run_flag <= 0; 
        write_pad_y_count = 0;
        count_operate_depth_by_bitwidth_and_depth (pad_y_c_bitwidth, pad_y_DEPTH, pad_y_OPERATE_DEPTH);
    end
    else begin
        if (TRAN_control_start_in === 1) begin
            pad_y_write_data_finish <= 0;
        end
        if (AESL_ready_reg === 1) begin
            write_pad_y_run_flag <= 1; 
            write_pad_y_count = 0;
        end
        if (write_one_pad_y_data_done === 1) begin
            write_pad_y_count = write_pad_y_count + 1;
            if (write_pad_y_count == pad_y_OPERATE_DEPTH) begin
                write_pad_y_run_flag <= 0; 
                pad_y_write_data_finish <= 1;
            end
        end
    end
end

initial begin : write_pad_y
    integer write_pad_y_resp;
    integer process_num ;
    integer get_ack;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;
    reg [31 : 0] pad_y_data_tmp_reg;
    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = pad_y_c_bitwidth;
    process_num = 15;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_15_finish <= 0;

        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            get_ack = 1;
            if (write_pad_y_run_flag === 1 && get_ack === 1) begin
                process_busy = 1;
                //write pad_y data 
                for (i = 0 ; i < four_byte_num ; i = i+1) begin
                    if (pad_y_c_bitwidth < 32) begin
                        pad_y_data_tmp_reg = mem_pad_y[write_pad_y_count];
                    end
                    else begin
                        for (j=0 ; j<32 ; j = j + 1) begin
                            if (i*32 + j < pad_y_c_bitwidth) begin
                                pad_y_data_tmp_reg[j] = mem_pad_y[write_pad_y_count][i*32 + j];
                            end
                            else begin
                                pad_y_data_tmp_reg[j] = 0;
                            end
                        end
                    end
                    if(image_mem_pad_y[write_pad_y_count * four_byte_num  + i]!==pad_y_data_tmp_reg) begin
                    write (pad_y_data_in_addr + write_pad_y_count * four_byte_num * 4 + i * 4, pad_y_data_tmp_reg, write_pad_y_resp);
                    image_mem_pad_y[write_pad_y_count * four_byte_num + i]=pad_y_data_tmp_reg;
                    end
                end
                process_busy = 0;
                write_one_pad_y_data_done <= 1;
                @(posedge clk);
                write_one_pad_y_data_done <= 0;
            end   
            process_15_finish <= 1;
        end
        @(posedge clk);
    end    
end
always @(reset or posedge clk) begin
    if (reset == 0) begin
        output_mode_write_data_finish <= 0;
        write_output_mode_run_flag <= 0; 
        write_output_mode_count = 0;
        count_operate_depth_by_bitwidth_and_depth (output_mode_c_bitwidth, output_mode_DEPTH, output_mode_OPERATE_DEPTH);
    end
    else begin
        if (TRAN_control_start_in === 1) begin
            output_mode_write_data_finish <= 0;
        end
        if (AESL_ready_reg === 1) begin
            write_output_mode_run_flag <= 1; 
            write_output_mode_count = 0;
        end
        if (write_one_output_mode_data_done === 1) begin
            write_output_mode_count = write_output_mode_count + 1;
            if (write_output_mode_count == output_mode_OPERATE_DEPTH) begin
                write_output_mode_run_flag <= 0; 
                output_mode_write_data_finish <= 1;
            end
        end
    end
end

initial begin : write_output_mode
    integer write_output_mode_resp;
    integer process_num ;
    integer get_ack;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;
    reg [31 : 0] output_mode_data_tmp_reg;
    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = output_mode_c_bitwidth;
    process_num = 16;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_16_finish <= 0;

        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            get_ack = 1;
            if (write_output_mode_run_flag === 1 && get_ack === 1) begin
                process_busy = 1;
                //write output_mode data 
                for (i = 0 ; i < four_byte_num ; i = i+1) begin
                    if (output_mode_c_bitwidth < 32) begin
                        output_mode_data_tmp_reg = mem_output_mode[write_output_mode_count];
                    end
                    else begin
                        for (j=0 ; j<32 ; j = j + 1) begin
                            if (i*32 + j < output_mode_c_bitwidth) begin
                                output_mode_data_tmp_reg[j] = mem_output_mode[write_output_mode_count][i*32 + j];
                            end
                            else begin
                                output_mode_data_tmp_reg[j] = 0;
                            end
                        end
                    end
                    if(image_mem_output_mode[write_output_mode_count * four_byte_num  + i]!==output_mode_data_tmp_reg) begin
                    write (output_mode_data_in_addr + write_output_mode_count * four_byte_num * 4 + i * 4, output_mode_data_tmp_reg, write_output_mode_resp);
                    image_mem_output_mode[write_output_mode_count * four_byte_num + i]=output_mode_data_tmp_reg;
                    end
                end
                process_busy = 0;
                write_one_output_mode_data_done <= 1;
                @(posedge clk);
                write_one_output_mode_data_done <= 0;
            end   
            process_16_finish <= 1;
        end
        @(posedge clk);
    end    
end
always @(reset or posedge clk) begin
    if (reset == 0) begin
        flags_write_data_finish <= 0;
        write_flags_run_flag <= 0; 
        write_flags_count = 0;
        count_operate_depth_by_bitwidth_and_depth (flags_c_bitwidth, flags_DEPTH, flags_OPERATE_DEPTH);
    end
    else begin
        if (TRAN_control_start_in === 1) begin
            flags_write_data_finish <= 0;
        end
        if (AESL_ready_reg === 1) begin
            write_flags_run_flag <= 1; 
            write_flags_count = 0;
        end
        if (write_one_flags_data_done === 1) begin
            write_flags_count = write_flags_count + 1;
            if (write_flags_count == flags_OPERATE_DEPTH) begin
                write_flags_run_flag <= 0; 
                flags_write_data_finish <= 1;
            end
        end
    end
end

initial begin : write_flags
    integer write_flags_resp;
    integer process_num ;
    integer get_ack;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;
    reg [31 : 0] flags_data_tmp_reg;
    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = flags_c_bitwidth;
    process_num = 17;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_17_finish <= 0;

        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            get_ack = 1;
            if (write_flags_run_flag === 1 && get_ack === 1) begin
                process_busy = 1;
                //write flags data 
                for (i = 0 ; i < four_byte_num ; i = i+1) begin
                    if (flags_c_bitwidth < 32) begin
                        flags_data_tmp_reg = mem_flags[write_flags_count];
                    end
                    else begin
                        for (j=0 ; j<32 ; j = j + 1) begin
                            if (i*32 + j < flags_c_bitwidth) begin
                                flags_data_tmp_reg[j] = mem_flags[write_flags_count][i*32 + j];
                            end
                            else begin
                                flags_data_tmp_reg[j] = 0;
                            end
                        end
                    end
                    if(image_mem_flags[write_flags_count * four_byte_num  + i]!==flags_data_tmp_reg) begin
                    write (flags_data_in_addr + write_flags_count * four_byte_num * 4 + i * 4, flags_data_tmp_reg, write_flags_resp);
                    image_mem_flags[write_flags_count * four_byte_num + i]=flags_data_tmp_reg;
                    end
                end
                process_busy = 0;
                write_one_flags_data_done <= 1;
                @(posedge clk);
                write_one_flags_data_done <= 0;
            end   
            process_17_finish <= 1;
        end
        @(posedge clk);
    end    
end
always @(reset or posedge clk) begin
    if (reset == 0) begin
        eq_mode_write_data_finish <= 0;
        write_eq_mode_run_flag <= 0; 
        write_eq_mode_count = 0;
        count_operate_depth_by_bitwidth_and_depth (eq_mode_c_bitwidth, eq_mode_DEPTH, eq_mode_OPERATE_DEPTH);
    end
    else begin
        if (TRAN_control_start_in === 1) begin
            eq_mode_write_data_finish <= 0;
        end
        if (AESL_ready_reg === 1) begin
            write_eq_mode_run_flag <= 1; 
            write_eq_mode_count = 0;
        end
        if (write_one_eq_mode_data_done === 1) begin
            write_eq_mode_count = write_eq_mode_count + 1;
            if (write_eq_mode_count == eq_mode_OPERATE_DEPTH) begin
                write_eq_mode_run_flag <= 0; 
                eq_mode_write_data_finish <= 1;
            end
        end
    end
end

initial begin : write_eq_mode
    integer write_eq_mode_resp;
    integer process_num ;
    integer get_ack;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;
    reg [31 : 0] eq_mode_data_tmp_reg;
    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = eq_mode_c_bitwidth;
    process_num = 18;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_18_finish <= 0;

        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            get_ack = 1;
            if (write_eq_mode_run_flag === 1 && get_ack === 1) begin
                process_busy = 1;
                //write eq_mode data 
                for (i = 0 ; i < four_byte_num ; i = i+1) begin
                    if (eq_mode_c_bitwidth < 32) begin
                        eq_mode_data_tmp_reg = mem_eq_mode[write_eq_mode_count];
                    end
                    else begin
                        for (j=0 ; j<32 ; j = j + 1) begin
                            if (i*32 + j < eq_mode_c_bitwidth) begin
                                eq_mode_data_tmp_reg[j] = mem_eq_mode[write_eq_mode_count][i*32 + j];
                            end
                            else begin
                                eq_mode_data_tmp_reg[j] = 0;
                            end
                        end
                    end
                    if(image_mem_eq_mode[write_eq_mode_count * four_byte_num  + i]!==eq_mode_data_tmp_reg) begin
                    write (eq_mode_data_in_addr + write_eq_mode_count * four_byte_num * 4 + i * 4, eq_mode_data_tmp_reg, write_eq_mode_resp);
                    image_mem_eq_mode[write_eq_mode_count * four_byte_num + i]=eq_mode_data_tmp_reg;
                    end
                end
                process_busy = 0;
                write_one_eq_mode_data_done <= 1;
                @(posedge clk);
                write_one_eq_mode_data_done <= 0;
            end   
            process_18_finish <= 1;
        end
        @(posedge clk);
    end    
end
always @(reset or posedge clk) begin
    if (reset == 0) begin
        saturation_q12_write_data_finish <= 0;
        write_saturation_q12_run_flag <= 0; 
        write_saturation_q12_count = 0;
        count_operate_depth_by_bitwidth_and_depth (saturation_q12_c_bitwidth, saturation_q12_DEPTH, saturation_q12_OPERATE_DEPTH);
    end
    else begin
        if (TRAN_control_start_in === 1) begin
            saturation_q12_write_data_finish <= 0;
        end
        if (AESL_ready_reg === 1) begin
            write_saturation_q12_run_flag <= 1; 
            write_saturation_q12_count = 0;
        end
        if (write_one_saturation_q12_data_done === 1) begin
            write_saturation_q12_count = write_saturation_q12_count + 1;
            if (write_saturation_q12_count == saturation_q12_OPERATE_DEPTH) begin
                write_saturation_q12_run_flag <= 0; 
                saturation_q12_write_data_finish <= 1;
            end
        end
    end
end

initial begin : write_saturation_q12
    integer write_saturation_q12_resp;
    integer process_num ;
    integer get_ack;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;
    reg [31 : 0] saturation_q12_data_tmp_reg;
    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = saturation_q12_c_bitwidth;
    process_num = 19;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_19_finish <= 0;

        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            get_ack = 1;
            if (write_saturation_q12_run_flag === 1 && get_ack === 1) begin
                process_busy = 1;
                //write saturation_q12 data 
                for (i = 0 ; i < four_byte_num ; i = i+1) begin
                    if (saturation_q12_c_bitwidth < 32) begin
                        saturation_q12_data_tmp_reg = mem_saturation_q12[write_saturation_q12_count];
                    end
                    else begin
                        for (j=0 ; j<32 ; j = j + 1) begin
                            if (i*32 + j < saturation_q12_c_bitwidth) begin
                                saturation_q12_data_tmp_reg[j] = mem_saturation_q12[write_saturation_q12_count][i*32 + j];
                            end
                            else begin
                                saturation_q12_data_tmp_reg[j] = 0;
                            end
                        end
                    end
                    if(image_mem_saturation_q12[write_saturation_q12_count * four_byte_num  + i]!==saturation_q12_data_tmp_reg) begin
                    write (saturation_q12_data_in_addr + write_saturation_q12_count * four_byte_num * 4 + i * 4, saturation_q12_data_tmp_reg, write_saturation_q12_resp);
                    image_mem_saturation_q12[write_saturation_q12_count * four_byte_num + i]=saturation_q12_data_tmp_reg;
                    end
                end
                process_busy = 0;
                write_one_saturation_q12_data_done <= 1;
                @(posedge clk);
                write_one_saturation_q12_data_done <= 0;
            end   
            process_19_finish <= 1;
        end
        @(posedge clk);
    end    
end
always @(reset or posedge clk) begin
    if (reset == 0) begin
        frame_id_write_data_finish <= 0;
        write_frame_id_run_flag <= 0; 
        write_frame_id_count = 0;
        count_operate_depth_by_bitwidth_and_depth (frame_id_c_bitwidth, frame_id_DEPTH, frame_id_OPERATE_DEPTH);
    end
    else begin
        if (TRAN_control_start_in === 1) begin
            frame_id_write_data_finish <= 0;
        end
        if (AESL_ready_reg === 1) begin
            write_frame_id_run_flag <= 1; 
            write_frame_id_count = 0;
        end
        if (write_one_frame_id_data_done === 1) begin
            write_frame_id_count = write_frame_id_count + 1;
            if (write_frame_id_count == frame_id_OPERATE_DEPTH) begin
                write_frame_id_run_flag <= 0; 
                frame_id_write_data_finish <= 1;
            end
        end
    end
end

initial begin : write_frame_id
    integer write_frame_id_resp;
    integer process_num ;
    integer get_ack;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;
    reg [31 : 0] frame_id_data_tmp_reg;
    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = frame_id_c_bitwidth;
    process_num = 20;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_20_finish <= 0;

        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            get_ack = 1;
            if (write_frame_id_run_flag === 1 && get_ack === 1) begin
                process_busy = 1;
                //write frame_id data 
                for (i = 0 ; i < four_byte_num ; i = i+1) begin
                    if (frame_id_c_bitwidth < 32) begin
                        frame_id_data_tmp_reg = mem_frame_id[write_frame_id_count];
                    end
                    else begin
                        for (j=0 ; j<32 ; j = j + 1) begin
                            if (i*32 + j < frame_id_c_bitwidth) begin
                                frame_id_data_tmp_reg[j] = mem_frame_id[write_frame_id_count][i*32 + j];
                            end
                            else begin
                                frame_id_data_tmp_reg[j] = 0;
                            end
                        end
                    end
                    if(image_mem_frame_id[write_frame_id_count * four_byte_num  + i]!==frame_id_data_tmp_reg) begin
                    write (frame_id_data_in_addr + write_frame_id_count * four_byte_num * 4 + i * 4, frame_id_data_tmp_reg, write_frame_id_resp);
                    image_mem_frame_id[write_frame_id_count * four_byte_num + i]=frame_id_data_tmp_reg;
                    end
                end
                process_busy = 0;
                write_one_frame_id_data_done <= 1;
                @(posedge clk);
                write_one_frame_id_data_done <= 0;
            end   
            process_20_finish <= 1;
        end
        @(posedge clk);
    end    
end
always @(reset or posedge clk) begin
    if (reset == 0) begin
        config_id_write_data_finish <= 0;
        write_config_id_run_flag <= 0; 
        write_config_id_count = 0;
        count_operate_depth_by_bitwidth_and_depth (config_id_c_bitwidth, config_id_DEPTH, config_id_OPERATE_DEPTH);
    end
    else begin
        if (TRAN_control_start_in === 1) begin
            config_id_write_data_finish <= 0;
        end
        if (AESL_ready_reg === 1) begin
            write_config_id_run_flag <= 1; 
            write_config_id_count = 0;
        end
        if (write_one_config_id_data_done === 1) begin
            write_config_id_count = write_config_id_count + 1;
            if (write_config_id_count == config_id_OPERATE_DEPTH) begin
                write_config_id_run_flag <= 0; 
                config_id_write_data_finish <= 1;
            end
        end
    end
end

initial begin : write_config_id
    integer write_config_id_resp;
    integer process_num ;
    integer get_ack;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;
    reg [31 : 0] config_id_data_tmp_reg;
    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = config_id_c_bitwidth;
    process_num = 21;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_21_finish <= 0;

        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            get_ack = 1;
            if (write_config_id_run_flag === 1 && get_ack === 1) begin
                process_busy = 1;
                //write config_id data 
                for (i = 0 ; i < four_byte_num ; i = i+1) begin
                    if (config_id_c_bitwidth < 32) begin
                        config_id_data_tmp_reg = mem_config_id[write_config_id_count];
                    end
                    else begin
                        for (j=0 ; j<32 ; j = j + 1) begin
                            if (i*32 + j < config_id_c_bitwidth) begin
                                config_id_data_tmp_reg[j] = mem_config_id[write_config_id_count][i*32 + j];
                            end
                            else begin
                                config_id_data_tmp_reg[j] = 0;
                            end
                        end
                    end
                    if(image_mem_config_id[write_config_id_count * four_byte_num  + i]!==config_id_data_tmp_reg) begin
                    write (config_id_data_in_addr + write_config_id_count * four_byte_num * 4 + i * 4, config_id_data_tmp_reg, write_config_id_resp);
                    image_mem_config_id[write_config_id_count * four_byte_num + i]=config_id_data_tmp_reg;
                    end
                end
                process_busy = 0;
                write_one_config_id_data_done <= 1;
                @(posedge clk);
                write_one_config_id_data_done <= 0;
            end   
            process_21_finish <= 1;
        end
        @(posedge clk);
    end    
end

always @(reset or posedge clk) begin
    if (reset == 0) begin
        write_start_run_flag <= 0; 
        write_start_count <= 0;
    end
    else begin
        if (write_start_count >= 5) begin
            write_start_run_flag <= 0; 
        end
        else if (TRAN_control_write_start_in === 1) begin
            write_start_run_flag <= 1; 
        end
        if (AESL_write_start_finish === 1) begin
            write_start_count <= write_start_count + 1;
            write_start_run_flag <= 0; 
        end
    end
end

initial begin : write_start
    reg [DATA_WIDTH - 1 : 0] write_start_tmp;
    integer process_num;
    integer write_start_resp;
    wait(reset === 1);
    @(posedge clk);
    process_num = 22;
    while (1) begin
        process_22_finish = 0;
        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            if (write_start_run_flag === 1) begin
                process_busy = 1;
                write_start_tmp=0;
                write_start_tmp[0 : 0] = 1;
                write (START_ADDR, write_start_tmp, write_start_resp);
                process_busy = 0;
                AESL_write_start_finish <= 1;
                @(posedge clk);
                AESL_write_start_finish <= 0;
            end
            process_22_finish <= 1;
        end 
        @(posedge clk);
    end
end

always @(reset or posedge clk) begin
    if (reset == 0) begin
        completed_frame_id_read_data_finish <= 0;
        read_completed_frame_id_run_flag <= 0; 
        read_completed_frame_id_count = 0;
        count_operate_depth_by_bitwidth_and_depth (completed_frame_id_c_bitwidth, completed_frame_id_DEPTH, completed_frame_id_OPERATE_DEPTH);
    end
    else begin
        if (AESL_done_index_reg === 1) begin
            read_completed_frame_id_run_flag = 1; 
        end
        if (TRAN_control_transaction_done_in === 1) begin
            completed_frame_id_read_data_finish <= 0;
            read_completed_frame_id_count = 0; 
        end
        if (read_one_completed_frame_id_data_done === 1) begin
            read_completed_frame_id_count = read_completed_frame_id_count + 1;
            if (read_completed_frame_id_count == completed_frame_id_OPERATE_DEPTH) begin
                read_completed_frame_id_run_flag <= 0; 
                completed_frame_id_read_data_finish <= 1;
            end
        end
    end
end

initial begin : read_completed_frame_id
    integer read_completed_frame_id_resp;
    integer process_num;
    integer get_vld;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;

    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = completed_frame_id_c_bitwidth;
    process_num = 23;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_23_finish <= 0;
        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            if (read_completed_frame_id_run_flag === 1) begin
                process_busy = 1;
                get_vld = 0;
                //read completed_frame_id vld
                read (completed_frame_id_valid_out_addr, RDATA_reg, read_completed_frame_id_resp);
                if (RDATA_reg[0 : 0] == 1) begin
                    get_vld = 1;
                end
                if (get_vld == 1) begin
                    //read completed_frame_id data 
                    for (i = 0 ; i < four_byte_num ; i = i+1) begin
                        read (completed_frame_id_data_out_addr + read_completed_frame_id_count * four_byte_num * 4 + i * 4, RDATA_reg, read_completed_frame_id_resp);
                        if (completed_frame_id_c_bitwidth < 32) begin
                            mem_completed_frame_id[read_completed_frame_id_count] <= RDATA_reg;
                        end
                        else begin
                            for (j=0 ; j < 32 ; j = j + 1) begin
                                if (i*32 + j < completed_frame_id_c_bitwidth) begin
                                    mem_completed_frame_id[read_completed_frame_id_count][i*32 + j] <= RDATA_reg[j];
                                end
                            end
                        end
                    end
                    
                    read_one_completed_frame_id_data_done <= 1;
                    @(posedge clk);
                    read_one_completed_frame_id_data_done <= 0;
                end    
                process_busy = 0;
            end    
            process_23_finish <= 1;
        end
        @(posedge clk);
    end    
end
always @(reset or posedge clk) begin
    if (reset == 0) begin
        completed_config_id_read_data_finish <= 0;
        read_completed_config_id_run_flag <= 0; 
        read_completed_config_id_count = 0;
        count_operate_depth_by_bitwidth_and_depth (completed_config_id_c_bitwidth, completed_config_id_DEPTH, completed_config_id_OPERATE_DEPTH);
    end
    else begin
        if (AESL_done_index_reg === 1) begin
            read_completed_config_id_run_flag = 1; 
        end
        if (TRAN_control_transaction_done_in === 1) begin
            completed_config_id_read_data_finish <= 0;
            read_completed_config_id_count = 0; 
        end
        if (read_one_completed_config_id_data_done === 1) begin
            read_completed_config_id_count = read_completed_config_id_count + 1;
            if (read_completed_config_id_count == completed_config_id_OPERATE_DEPTH) begin
                read_completed_config_id_run_flag <= 0; 
                completed_config_id_read_data_finish <= 1;
            end
        end
    end
end

initial begin : read_completed_config_id
    integer read_completed_config_id_resp;
    integer process_num;
    integer get_vld;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;

    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = completed_config_id_c_bitwidth;
    process_num = 24;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_24_finish <= 0;
        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            if (read_completed_config_id_run_flag === 1) begin
                process_busy = 1;
                get_vld = 0;
                //read completed_config_id vld
                read (completed_config_id_valid_out_addr, RDATA_reg, read_completed_config_id_resp);
                if (RDATA_reg[0 : 0] == 1) begin
                    get_vld = 1;
                end
                if (get_vld == 1) begin
                    //read completed_config_id data 
                    for (i = 0 ; i < four_byte_num ; i = i+1) begin
                        read (completed_config_id_data_out_addr + read_completed_config_id_count * four_byte_num * 4 + i * 4, RDATA_reg, read_completed_config_id_resp);
                        if (completed_config_id_c_bitwidth < 32) begin
                            mem_completed_config_id[read_completed_config_id_count] <= RDATA_reg;
                        end
                        else begin
                            for (j=0 ; j < 32 ; j = j + 1) begin
                                if (i*32 + j < completed_config_id_c_bitwidth) begin
                                    mem_completed_config_id[read_completed_config_id_count][i*32 + j] <= RDATA_reg[j];
                                end
                            end
                        end
                    end
                    
                    read_one_completed_config_id_data_done <= 1;
                    @(posedge clk);
                    read_one_completed_config_id_data_done <= 0;
                end    
                process_busy = 0;
            end    
            process_24_finish <= 1;
        end
        @(posedge clk);
    end    
end
always @(reset or posedge clk) begin
    if (reset == 0) begin
        tensor_bytes_read_data_finish <= 0;
        read_tensor_bytes_run_flag <= 0; 
        read_tensor_bytes_count = 0;
        count_operate_depth_by_bitwidth_and_depth (tensor_bytes_c_bitwidth, tensor_bytes_DEPTH, tensor_bytes_OPERATE_DEPTH);
    end
    else begin
        if (AESL_done_index_reg === 1) begin
            read_tensor_bytes_run_flag = 1; 
        end
        if (TRAN_control_transaction_done_in === 1) begin
            tensor_bytes_read_data_finish <= 0;
            read_tensor_bytes_count = 0; 
        end
        if (read_one_tensor_bytes_data_done === 1) begin
            read_tensor_bytes_count = read_tensor_bytes_count + 1;
            if (read_tensor_bytes_count == tensor_bytes_OPERATE_DEPTH) begin
                read_tensor_bytes_run_flag <= 0; 
                tensor_bytes_read_data_finish <= 1;
            end
        end
    end
end

initial begin : read_tensor_bytes
    integer read_tensor_bytes_resp;
    integer process_num;
    integer get_vld;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;

    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = tensor_bytes_c_bitwidth;
    process_num = 25;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_25_finish <= 0;
        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            if (read_tensor_bytes_run_flag === 1) begin
                process_busy = 1;
                get_vld = 0;
                //read tensor_bytes vld
                read (tensor_bytes_valid_out_addr, RDATA_reg, read_tensor_bytes_resp);
                if (RDATA_reg[0 : 0] == 1) begin
                    get_vld = 1;
                end
                if (get_vld == 1) begin
                    //read tensor_bytes data 
                    for (i = 0 ; i < four_byte_num ; i = i+1) begin
                        read (tensor_bytes_data_out_addr + read_tensor_bytes_count * four_byte_num * 4 + i * 4, RDATA_reg, read_tensor_bytes_resp);
                        if (tensor_bytes_c_bitwidth < 32) begin
                            mem_tensor_bytes[read_tensor_bytes_count] <= RDATA_reg;
                        end
                        else begin
                            for (j=0 ; j < 32 ; j = j + 1) begin
                                if (i*32 + j < tensor_bytes_c_bitwidth) begin
                                    mem_tensor_bytes[read_tensor_bytes_count][i*32 + j] <= RDATA_reg[j];
                                end
                            end
                        end
                    end
                    
                    read_one_tensor_bytes_data_done <= 1;
                    @(posedge clk);
                    read_one_tensor_bytes_data_done <= 0;
                end    
                process_busy = 0;
            end    
            process_25_finish <= 1;
        end
        @(posedge clk);
    end    
end
always @(reset or posedge clk) begin
    if (reset == 0) begin
        preview_bytes_read_data_finish <= 0;
        read_preview_bytes_run_flag <= 0; 
        read_preview_bytes_count = 0;
        count_operate_depth_by_bitwidth_and_depth (preview_bytes_c_bitwidth, preview_bytes_DEPTH, preview_bytes_OPERATE_DEPTH);
    end
    else begin
        if (AESL_done_index_reg === 1) begin
            read_preview_bytes_run_flag = 1; 
        end
        if (TRAN_control_transaction_done_in === 1) begin
            preview_bytes_read_data_finish <= 0;
            read_preview_bytes_count = 0; 
        end
        if (read_one_preview_bytes_data_done === 1) begin
            read_preview_bytes_count = read_preview_bytes_count + 1;
            if (read_preview_bytes_count == preview_bytes_OPERATE_DEPTH) begin
                read_preview_bytes_run_flag <= 0; 
                preview_bytes_read_data_finish <= 1;
            end
        end
    end
end

initial begin : read_preview_bytes
    integer read_preview_bytes_resp;
    integer process_num;
    integer get_vld;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;

    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = preview_bytes_c_bitwidth;
    process_num = 26;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_26_finish <= 0;
        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            if (read_preview_bytes_run_flag === 1) begin
                process_busy = 1;
                get_vld = 0;
                //read preview_bytes vld
                read (preview_bytes_valid_out_addr, RDATA_reg, read_preview_bytes_resp);
                if (RDATA_reg[0 : 0] == 1) begin
                    get_vld = 1;
                end
                if (get_vld == 1) begin
                    //read preview_bytes data 
                    for (i = 0 ; i < four_byte_num ; i = i+1) begin
                        read (preview_bytes_data_out_addr + read_preview_bytes_count * four_byte_num * 4 + i * 4, RDATA_reg, read_preview_bytes_resp);
                        if (preview_bytes_c_bitwidth < 32) begin
                            mem_preview_bytes[read_preview_bytes_count] <= RDATA_reg;
                        end
                        else begin
                            for (j=0 ; j < 32 ; j = j + 1) begin
                                if (i*32 + j < preview_bytes_c_bitwidth) begin
                                    mem_preview_bytes[read_preview_bytes_count][i*32 + j] <= RDATA_reg[j];
                                end
                            end
                        end
                    end
                    
                    read_one_preview_bytes_data_done <= 1;
                    @(posedge clk);
                    read_one_preview_bytes_data_done <= 0;
                end    
                process_busy = 0;
            end    
            process_26_finish <= 1;
        end
        @(posedge clk);
    end    
end
always @(reset or posedge clk) begin
    if (reset == 0) begin
        abi_version_read_data_finish <= 0;
        read_abi_version_run_flag <= 0; 
        read_abi_version_count = 0;
        count_operate_depth_by_bitwidth_and_depth (abi_version_c_bitwidth, abi_version_DEPTH, abi_version_OPERATE_DEPTH);
    end
    else begin
        if (AESL_done_index_reg === 1) begin
            read_abi_version_run_flag = 1; 
        end
        if (TRAN_control_transaction_done_in === 1) begin
            abi_version_read_data_finish <= 0;
            read_abi_version_count = 0; 
        end
        if (read_one_abi_version_data_done === 1) begin
            read_abi_version_count = read_abi_version_count + 1;
            if (read_abi_version_count == abi_version_OPERATE_DEPTH) begin
                read_abi_version_run_flag <= 0; 
                abi_version_read_data_finish <= 1;
            end
        end
    end
end

initial begin : read_abi_version
    integer read_abi_version_resp;
    integer process_num;
    integer get_vld;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;

    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = abi_version_c_bitwidth;
    process_num = 27;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_27_finish <= 0;
        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            if (read_abi_version_run_flag === 1) begin
                process_busy = 1;
                get_vld = 0;
                //read abi_version vld
                read (abi_version_valid_out_addr, RDATA_reg, read_abi_version_resp);
                if (RDATA_reg[0 : 0] == 1) begin
                    get_vld = 1;
                end
                if (get_vld == 1) begin
                    //read abi_version data 
                    for (i = 0 ; i < four_byte_num ; i = i+1) begin
                        read (abi_version_data_out_addr + read_abi_version_count * four_byte_num * 4 + i * 4, RDATA_reg, read_abi_version_resp);
                        if (abi_version_c_bitwidth < 32) begin
                            mem_abi_version[read_abi_version_count] <= RDATA_reg;
                        end
                        else begin
                            for (j=0 ; j < 32 ; j = j + 1) begin
                                if (i*32 + j < abi_version_c_bitwidth) begin
                                    mem_abi_version[read_abi_version_count][i*32 + j] <= RDATA_reg[j];
                                end
                            end
                        end
                    end
                    
                    read_one_abi_version_data_done <= 1;
                    @(posedge clk);
                    read_one_abi_version_data_done <= 0;
                end    
                process_busy = 0;
            end    
            process_27_finish <= 1;
        end
        @(posedge clk);
    end    
end
always @(reset or posedge clk) begin
    if (reset == 0) begin
        ap_return_read_data_finish <= 0;
        read_ap_return_run_flag <= 0; 
        read_ap_return_count = 0;
        count_operate_depth_by_bitwidth_and_depth (ap_return_c_bitwidth, ap_return_DEPTH, ap_return_OPERATE_DEPTH);
    end
    else begin
        if (AESL_done_index_reg === 1) begin
            read_ap_return_run_flag = 1; 
        end
        if (TRAN_control_transaction_done_in === 1) begin
            ap_return_read_data_finish <= 0;
            read_ap_return_count = 0; 
        end
        if (read_one_ap_return_data_done === 1) begin
            read_ap_return_count = read_ap_return_count + 1;
            if (read_ap_return_count == ap_return_OPERATE_DEPTH) begin
                read_ap_return_run_flag <= 0; 
                ap_return_read_data_finish <= 1;
            end
        end
    end
end

initial begin : read_ap_return
    integer read_ap_return_resp;
    integer process_num;
    integer get_vld;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;

    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = ap_return_c_bitwidth;
    process_num = 28;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_28_finish <= 0;
        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            if (read_ap_return_run_flag === 1) begin
                process_busy = 1;
                get_vld = 1;
                if (get_vld == 1) begin
                    //read ap_return data 
                    for (i = 0 ; i < four_byte_num ; i = i+1) begin
                        read (ap_return_data_out_addr + read_ap_return_count * four_byte_num * 4 + i * 4, RDATA_reg, read_ap_return_resp);
                        if (ap_return_c_bitwidth < 32) begin
                            mem_ap_return[read_ap_return_count] <= RDATA_reg;
                        end
                        else begin
                            for (j=0 ; j < 32 ; j = j + 1) begin
                                if (i*32 + j < ap_return_c_bitwidth) begin
                                    mem_ap_return[read_ap_return_count][i*32 + j] <= RDATA_reg[j];
                                end
                            end
                        end
                    end
                    
                    read_one_ap_return_data_done <= 1;
                    @(posedge clk);
                    read_one_ap_return_data_done <= 0;
                end    
                process_busy = 0;
            end    
            process_28_finish <= 1;
        end
        @(posedge clk);
    end    
end
//------------------------Task and function-------------- 
task read_token; 
    input integer fp; 
    output reg [151 : 0] token;
    integer ret;
    begin
        token = "";
        ret = 0;
        ret = $fscanf(fp,"%s",token);
    end 
endtask 
 
//------------------------Read file------------------------ 
 
// Read data from file 
initial begin : read_src_file_process 
  integer fp; 
  integer ret; 
  integer factor; 
  reg [151 : 0] token; 
  reg [151 : 0] token_tmp; 
  //reg [src_c_bitwidth - 1 : 0] token_tmp; 
  reg [DATA_WIDTH - 1 : 0] tmp_cache_mem; 
  reg [ 8*5 : 1] str;
    reg [63:0] trans_depth;
  integer transaction_idx; 
  integer i; 
  transaction_idx = 0; 
  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
  count_seperate_factor_by_bitwidth (src_c_bitwidth , factor);
  fp = $fopen(`TV_IN_src ,"r"); 
  if(fp == 0) begin                               // Failed to open file 
      $display("Failed to open file \"%s\"!", `TV_IN_src); 
      $finish; 
  end 
  read_token(fp, token); 
  if (token != "[[[runtime]]]") begin             // Illegal format 
      $display("ERROR: Simulation using HLS TB failed.");
      $finish; 
  end 
  read_token(fp, token); 
  while (token != "[[[/runtime]]]") begin 
      if (token != "[[transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token);                        // skip transaction number 
      @(posedge clk);
      # 0.2;
      while(AESL_ready_reg !== 1) begin
          @(posedge clk); 
          # 0.2;
      end
      for(i = 0; i < src_DEPTH; i = i + 1) begin 
          read_token(fp, token); 
          ret = $sscanf(token, "0x%x", token_tmp); 
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [7 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [15 : 8] = token_tmp;
              end
              if (i%factor == 2) begin
                  tmp_cache_mem [23 : 16] = token_tmp;
              end
              if (i%factor == 3) begin
                  tmp_cache_mem [31 : 24] = token_tmp;
                  mem_src [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
              end
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [15 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [31 : 16] = token_tmp;
                  mem_src [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1: 0] = 0;
              end
          end
          if (factor == 1) begin
              mem_src [i] = token_tmp;
          end
      end 
      if (factor == 4) begin
          if (i%factor != 0) begin
              mem_src [i/factor] = tmp_cache_mem;
          end
      end
      if (factor == 2) begin
          if (i%factor != 0) begin
              mem_src [i/factor] = tmp_cache_mem;
          end
      end 
      read_token(fp, token); 
      if(token != "[[/transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token); 
      transaction_idx = transaction_idx + 1; 
  end 
  $fclose(fp); 
end 
 
task write_binary_src;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
//------------------------Read file------------------------ 
 
// Read data from file 
initial begin : read_tensor_file_process 
  integer fp; 
  integer ret; 
  integer factor; 
  reg [151 : 0] token; 
  reg [151 : 0] token_tmp; 
  //reg [tensor_c_bitwidth - 1 : 0] token_tmp; 
  reg [DATA_WIDTH - 1 : 0] tmp_cache_mem; 
  reg [ 8*5 : 1] str;
    reg [63:0] trans_depth;
  integer transaction_idx; 
  integer i; 
  transaction_idx = 0; 
  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
  count_seperate_factor_by_bitwidth (tensor_c_bitwidth , factor);
  fp = $fopen(`TV_IN_tensor ,"r"); 
  if(fp == 0) begin                               // Failed to open file 
      $display("Failed to open file \"%s\"!", `TV_IN_tensor); 
      $finish; 
  end 
  read_token(fp, token); 
  if (token != "[[[runtime]]]") begin             // Illegal format 
      $display("ERROR: Simulation using HLS TB failed.");
      $finish; 
  end 
  read_token(fp, token); 
  while (token != "[[[/runtime]]]") begin 
      if (token != "[[transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token);                        // skip transaction number 
      @(posedge clk);
      # 0.2;
      while(AESL_ready_reg !== 1) begin
          @(posedge clk); 
          # 0.2;
      end
      for(i = 0; i < tensor_DEPTH; i = i + 1) begin 
          read_token(fp, token); 
          ret = $sscanf(token, "0x%x", token_tmp); 
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [7 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [15 : 8] = token_tmp;
              end
              if (i%factor == 2) begin
                  tmp_cache_mem [23 : 16] = token_tmp;
              end
              if (i%factor == 3) begin
                  tmp_cache_mem [31 : 24] = token_tmp;
                  mem_tensor [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
              end
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [15 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [31 : 16] = token_tmp;
                  mem_tensor [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1: 0] = 0;
              end
          end
          if (factor == 1) begin
              mem_tensor [i] = token_tmp;
          end
      end 
      if (factor == 4) begin
          if (i%factor != 0) begin
              mem_tensor [i/factor] = tmp_cache_mem;
          end
      end
      if (factor == 2) begin
          if (i%factor != 0) begin
              mem_tensor [i/factor] = tmp_cache_mem;
          end
      end 
      read_token(fp, token); 
      if(token != "[[/transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token); 
      transaction_idx = transaction_idx + 1; 
  end 
  $fclose(fp); 
end 
 
task write_binary_tensor;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
//------------------------Read file------------------------ 
 
// Read data from file 
initial begin : read_preview_file_process 
  integer fp; 
  integer ret; 
  integer factor; 
  reg [151 : 0] token; 
  reg [151 : 0] token_tmp; 
  //reg [preview_c_bitwidth - 1 : 0] token_tmp; 
  reg [DATA_WIDTH - 1 : 0] tmp_cache_mem; 
  reg [ 8*5 : 1] str;
    reg [63:0] trans_depth;
  integer transaction_idx; 
  integer i; 
  transaction_idx = 0; 
  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
  count_seperate_factor_by_bitwidth (preview_c_bitwidth , factor);
  fp = $fopen(`TV_IN_preview ,"r"); 
  if(fp == 0) begin                               // Failed to open file 
      $display("Failed to open file \"%s\"!", `TV_IN_preview); 
      $finish; 
  end 
  read_token(fp, token); 
  if (token != "[[[runtime]]]") begin             // Illegal format 
      $display("ERROR: Simulation using HLS TB failed.");
      $finish; 
  end 
  read_token(fp, token); 
  while (token != "[[[/runtime]]]") begin 
      if (token != "[[transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token);                        // skip transaction number 
      @(posedge clk);
      # 0.2;
      while(AESL_ready_reg !== 1) begin
          @(posedge clk); 
          # 0.2;
      end
      for(i = 0; i < preview_DEPTH; i = i + 1) begin 
          read_token(fp, token); 
          ret = $sscanf(token, "0x%x", token_tmp); 
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [7 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [15 : 8] = token_tmp;
              end
              if (i%factor == 2) begin
                  tmp_cache_mem [23 : 16] = token_tmp;
              end
              if (i%factor == 3) begin
                  tmp_cache_mem [31 : 24] = token_tmp;
                  mem_preview [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
              end
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [15 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [31 : 16] = token_tmp;
                  mem_preview [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1: 0] = 0;
              end
          end
          if (factor == 1) begin
              mem_preview [i] = token_tmp;
          end
      end 
      if (factor == 4) begin
          if (i%factor != 0) begin
              mem_preview [i/factor] = tmp_cache_mem;
          end
      end
      if (factor == 2) begin
          if (i%factor != 0) begin
              mem_preview [i/factor] = tmp_cache_mem;
          end
      end 
      read_token(fp, token); 
      if(token != "[[/transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token); 
      transaction_idx = transaction_idx + 1; 
  end 
  $fclose(fp); 
end 
 
task write_binary_preview;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
//------------------------Read file------------------------ 
 
// Read data from file 
initial begin : read_luts_file_process 
  integer fp; 
  integer ret; 
  integer factor; 
  reg [151 : 0] token; 
  reg [151 : 0] token_tmp; 
  //reg [luts_c_bitwidth - 1 : 0] token_tmp; 
  reg [DATA_WIDTH - 1 : 0] tmp_cache_mem; 
  reg [ 8*5 : 1] str;
    reg [63:0] trans_depth;
  integer transaction_idx; 
  integer i; 
  transaction_idx = 0; 
  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
  count_seperate_factor_by_bitwidth (luts_c_bitwidth , factor);
  fp = $fopen(`TV_IN_luts ,"r"); 
  if(fp == 0) begin                               // Failed to open file 
      $display("Failed to open file \"%s\"!", `TV_IN_luts); 
      $finish; 
  end 
  read_token(fp, token); 
  if (token != "[[[runtime]]]") begin             // Illegal format 
      $display("ERROR: Simulation using HLS TB failed.");
      $finish; 
  end 
  read_token(fp, token); 
  while (token != "[[[/runtime]]]") begin 
      if (token != "[[transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token);                        // skip transaction number 
      @(posedge clk);
      # 0.2;
      while(AESL_ready_reg !== 1) begin
          @(posedge clk); 
          # 0.2;
      end
      for(i = 0; i < luts_DEPTH; i = i + 1) begin 
          read_token(fp, token); 
          ret = $sscanf(token, "0x%x", token_tmp); 
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [7 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [15 : 8] = token_tmp;
              end
              if (i%factor == 2) begin
                  tmp_cache_mem [23 : 16] = token_tmp;
              end
              if (i%factor == 3) begin
                  tmp_cache_mem [31 : 24] = token_tmp;
                  mem_luts [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
              end
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [15 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [31 : 16] = token_tmp;
                  mem_luts [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1: 0] = 0;
              end
          end
          if (factor == 1) begin
              mem_luts [i] = token_tmp;
          end
      end 
      if (factor == 4) begin
          if (i%factor != 0) begin
              mem_luts [i/factor] = tmp_cache_mem;
          end
      end
      if (factor == 2) begin
          if (i%factor != 0) begin
              mem_luts [i/factor] = tmp_cache_mem;
          end
      end 
      read_token(fp, token); 
      if(token != "[[/transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token); 
      transaction_idx = transaction_idx + 1; 
  end 
  $fclose(fp); 
end 
 
task write_binary_luts;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
//------------------------Read file------------------------ 
 
// Read data from file 
initial begin : read_width_file_process 
  integer fp; 
  integer ret; 
  integer factor; 
  reg [127 : 0] token; 
  reg [127 : 0] token_tmp; 
  //reg [width_c_bitwidth - 1 : 0] token_tmp; 
  reg [DATA_WIDTH - 1 : 0] tmp_cache_mem; 
  reg [ 8*5 : 1] str;
    reg [63:0] trans_depth;
  integer transaction_idx; 
  integer i; 
  transaction_idx = 0; 
  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
  count_seperate_factor_by_bitwidth (width_c_bitwidth , factor);
  fp = $fopen(`TV_IN_width ,"r"); 
  if(fp == 0) begin                               // Failed to open file 
      $display("Failed to open file \"%s\"!", `TV_IN_width); 
      $finish; 
  end 
  read_token(fp, token); 
  if (token != "[[[runtime]]]") begin             // Illegal format 
      $display("ERROR: Simulation using HLS TB failed.");
      $finish; 
  end 
  read_token(fp, token); 
  while (token != "[[[/runtime]]]") begin 
      if (token != "[[transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token);                        // skip transaction number 
      @(posedge clk);
      # 0.2;
      while(AESL_ready_reg !== 1) begin
          @(posedge clk); 
          # 0.2;
      end
      for(i = 0; i < width_DEPTH; i = i + 1) begin 
          read_token(fp, token); 
          ret = $sscanf(token, "0x%x", token_tmp); 
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [7 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [15 : 8] = token_tmp;
              end
              if (i%factor == 2) begin
                  tmp_cache_mem [23 : 16] = token_tmp;
              end
              if (i%factor == 3) begin
                  tmp_cache_mem [31 : 24] = token_tmp;
                  mem_width [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
              end
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [15 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [31 : 16] = token_tmp;
                  mem_width [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1: 0] = 0;
              end
          end
          if (factor == 1) begin
              mem_width [i] = token_tmp;
          end
      end 
      if (factor == 4) begin
          if (i%factor != 0) begin
              mem_width [i/factor] = tmp_cache_mem;
          end
      end
      if (factor == 2) begin
          if (i%factor != 0) begin
              mem_width [i/factor] = tmp_cache_mem;
          end
      end 
      read_token(fp, token); 
      if(token != "[[/transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token); 
      transaction_idx = transaction_idx + 1; 
  end 
  $fclose(fp); 
end 
 
task write_binary_width;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
//------------------------Read file------------------------ 
 
// Read data from file 
initial begin : read_height_file_process 
  integer fp; 
  integer ret; 
  integer factor; 
  reg [127 : 0] token; 
  reg [127 : 0] token_tmp; 
  //reg [height_c_bitwidth - 1 : 0] token_tmp; 
  reg [DATA_WIDTH - 1 : 0] tmp_cache_mem; 
  reg [ 8*5 : 1] str;
    reg [63:0] trans_depth;
  integer transaction_idx; 
  integer i; 
  transaction_idx = 0; 
  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
  count_seperate_factor_by_bitwidth (height_c_bitwidth , factor);
  fp = $fopen(`TV_IN_height ,"r"); 
  if(fp == 0) begin                               // Failed to open file 
      $display("Failed to open file \"%s\"!", `TV_IN_height); 
      $finish; 
  end 
  read_token(fp, token); 
  if (token != "[[[runtime]]]") begin             // Illegal format 
      $display("ERROR: Simulation using HLS TB failed.");
      $finish; 
  end 
  read_token(fp, token); 
  while (token != "[[[/runtime]]]") begin 
      if (token != "[[transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token);                        // skip transaction number 
      @(posedge clk);
      # 0.2;
      while(AESL_ready_reg !== 1) begin
          @(posedge clk); 
          # 0.2;
      end
      for(i = 0; i < height_DEPTH; i = i + 1) begin 
          read_token(fp, token); 
          ret = $sscanf(token, "0x%x", token_tmp); 
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [7 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [15 : 8] = token_tmp;
              end
              if (i%factor == 2) begin
                  tmp_cache_mem [23 : 16] = token_tmp;
              end
              if (i%factor == 3) begin
                  tmp_cache_mem [31 : 24] = token_tmp;
                  mem_height [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
              end
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [15 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [31 : 16] = token_tmp;
                  mem_height [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1: 0] = 0;
              end
          end
          if (factor == 1) begin
              mem_height [i] = token_tmp;
          end
      end 
      if (factor == 4) begin
          if (i%factor != 0) begin
              mem_height [i/factor] = tmp_cache_mem;
          end
      end
      if (factor == 2) begin
          if (i%factor != 0) begin
              mem_height [i/factor] = tmp_cache_mem;
          end
      end 
      read_token(fp, token); 
      if(token != "[[/transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token); 
      transaction_idx = transaction_idx + 1; 
  end 
  $fclose(fp); 
end 
 
task write_binary_height;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
//------------------------Read file------------------------ 
 
// Read data from file 
initial begin : read_src_stride_file_process 
  integer fp; 
  integer ret; 
  integer factor; 
  reg [127 : 0] token; 
  reg [127 : 0] token_tmp; 
  //reg [src_stride_c_bitwidth - 1 : 0] token_tmp; 
  reg [DATA_WIDTH - 1 : 0] tmp_cache_mem; 
  reg [ 8*5 : 1] str;
    reg [63:0] trans_depth;
  integer transaction_idx; 
  integer i; 
  transaction_idx = 0; 
  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
  count_seperate_factor_by_bitwidth (src_stride_c_bitwidth , factor);
  fp = $fopen(`TV_IN_src_stride ,"r"); 
  if(fp == 0) begin                               // Failed to open file 
      $display("Failed to open file \"%s\"!", `TV_IN_src_stride); 
      $finish; 
  end 
  read_token(fp, token); 
  if (token != "[[[runtime]]]") begin             // Illegal format 
      $display("ERROR: Simulation using HLS TB failed.");
      $finish; 
  end 
  read_token(fp, token); 
  while (token != "[[[/runtime]]]") begin 
      if (token != "[[transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token);                        // skip transaction number 
      @(posedge clk);
      # 0.2;
      while(AESL_ready_reg !== 1) begin
          @(posedge clk); 
          # 0.2;
      end
      for(i = 0; i < src_stride_DEPTH; i = i + 1) begin 
          read_token(fp, token); 
          ret = $sscanf(token, "0x%x", token_tmp); 
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [7 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [15 : 8] = token_tmp;
              end
              if (i%factor == 2) begin
                  tmp_cache_mem [23 : 16] = token_tmp;
              end
              if (i%factor == 3) begin
                  tmp_cache_mem [31 : 24] = token_tmp;
                  mem_src_stride [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
              end
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [15 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [31 : 16] = token_tmp;
                  mem_src_stride [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1: 0] = 0;
              end
          end
          if (factor == 1) begin
              mem_src_stride [i] = token_tmp;
          end
      end 
      if (factor == 4) begin
          if (i%factor != 0) begin
              mem_src_stride [i/factor] = tmp_cache_mem;
          end
      end
      if (factor == 2) begin
          if (i%factor != 0) begin
              mem_src_stride [i/factor] = tmp_cache_mem;
          end
      end 
      read_token(fp, token); 
      if(token != "[[/transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token); 
      transaction_idx = transaction_idx + 1; 
  end 
  $fclose(fp); 
end 
 
task write_binary_src_stride;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
//------------------------Read file------------------------ 
 
// Read data from file 
initial begin : read_src_capacity_file_process 
  integer fp; 
  integer ret; 
  integer factor; 
  reg [127 : 0] token; 
  reg [127 : 0] token_tmp; 
  //reg [src_capacity_c_bitwidth - 1 : 0] token_tmp; 
  reg [DATA_WIDTH - 1 : 0] tmp_cache_mem; 
  reg [ 8*5 : 1] str;
    reg [63:0] trans_depth;
  integer transaction_idx; 
  integer i; 
  transaction_idx = 0; 
  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
  count_seperate_factor_by_bitwidth (src_capacity_c_bitwidth , factor);
  fp = $fopen(`TV_IN_src_capacity ,"r"); 
  if(fp == 0) begin                               // Failed to open file 
      $display("Failed to open file \"%s\"!", `TV_IN_src_capacity); 
      $finish; 
  end 
  read_token(fp, token); 
  if (token != "[[[runtime]]]") begin             // Illegal format 
      $display("ERROR: Simulation using HLS TB failed.");
      $finish; 
  end 
  read_token(fp, token); 
  while (token != "[[[/runtime]]]") begin 
      if (token != "[[transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token);                        // skip transaction number 
      @(posedge clk);
      # 0.2;
      while(AESL_ready_reg !== 1) begin
          @(posedge clk); 
          # 0.2;
      end
      for(i = 0; i < src_capacity_DEPTH; i = i + 1) begin 
          read_token(fp, token); 
          ret = $sscanf(token, "0x%x", token_tmp); 
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [7 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [15 : 8] = token_tmp;
              end
              if (i%factor == 2) begin
                  tmp_cache_mem [23 : 16] = token_tmp;
              end
              if (i%factor == 3) begin
                  tmp_cache_mem [31 : 24] = token_tmp;
                  mem_src_capacity [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
              end
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [15 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [31 : 16] = token_tmp;
                  mem_src_capacity [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1: 0] = 0;
              end
          end
          if (factor == 1) begin
              mem_src_capacity [i] = token_tmp;
          end
      end 
      if (factor == 4) begin
          if (i%factor != 0) begin
              mem_src_capacity [i/factor] = tmp_cache_mem;
          end
      end
      if (factor == 2) begin
          if (i%factor != 0) begin
              mem_src_capacity [i/factor] = tmp_cache_mem;
          end
      end 
      read_token(fp, token); 
      if(token != "[[/transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token); 
      transaction_idx = transaction_idx + 1; 
  end 
  $fclose(fp); 
end 
 
task write_binary_src_capacity;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
//------------------------Read file------------------------ 
 
// Read data from file 
initial begin : read_tensor_capacity_file_process 
  integer fp; 
  integer ret; 
  integer factor; 
  reg [127 : 0] token; 
  reg [127 : 0] token_tmp; 
  //reg [tensor_capacity_c_bitwidth - 1 : 0] token_tmp; 
  reg [DATA_WIDTH - 1 : 0] tmp_cache_mem; 
  reg [ 8*5 : 1] str;
    reg [63:0] trans_depth;
  integer transaction_idx; 
  integer i; 
  transaction_idx = 0; 
  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
  count_seperate_factor_by_bitwidth (tensor_capacity_c_bitwidth , factor);
  fp = $fopen(`TV_IN_tensor_capacity ,"r"); 
  if(fp == 0) begin                               // Failed to open file 
      $display("Failed to open file \"%s\"!", `TV_IN_tensor_capacity); 
      $finish; 
  end 
  read_token(fp, token); 
  if (token != "[[[runtime]]]") begin             // Illegal format 
      $display("ERROR: Simulation using HLS TB failed.");
      $finish; 
  end 
  read_token(fp, token); 
  while (token != "[[[/runtime]]]") begin 
      if (token != "[[transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token);                        // skip transaction number 
      @(posedge clk);
      # 0.2;
      while(AESL_ready_reg !== 1) begin
          @(posedge clk); 
          # 0.2;
      end
      for(i = 0; i < tensor_capacity_DEPTH; i = i + 1) begin 
          read_token(fp, token); 
          ret = $sscanf(token, "0x%x", token_tmp); 
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [7 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [15 : 8] = token_tmp;
              end
              if (i%factor == 2) begin
                  tmp_cache_mem [23 : 16] = token_tmp;
              end
              if (i%factor == 3) begin
                  tmp_cache_mem [31 : 24] = token_tmp;
                  mem_tensor_capacity [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
              end
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [15 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [31 : 16] = token_tmp;
                  mem_tensor_capacity [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1: 0] = 0;
              end
          end
          if (factor == 1) begin
              mem_tensor_capacity [i] = token_tmp;
          end
      end 
      if (factor == 4) begin
          if (i%factor != 0) begin
              mem_tensor_capacity [i/factor] = tmp_cache_mem;
          end
      end
      if (factor == 2) begin
          if (i%factor != 0) begin
              mem_tensor_capacity [i/factor] = tmp_cache_mem;
          end
      end 
      read_token(fp, token); 
      if(token != "[[/transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token); 
      transaction_idx = transaction_idx + 1; 
  end 
  $fclose(fp); 
end 
 
task write_binary_tensor_capacity;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
//------------------------Read file------------------------ 
 
// Read data from file 
initial begin : read_preview_stride_file_process 
  integer fp; 
  integer ret; 
  integer factor; 
  reg [127 : 0] token; 
  reg [127 : 0] token_tmp; 
  //reg [preview_stride_c_bitwidth - 1 : 0] token_tmp; 
  reg [DATA_WIDTH - 1 : 0] tmp_cache_mem; 
  reg [ 8*5 : 1] str;
    reg [63:0] trans_depth;
  integer transaction_idx; 
  integer i; 
  transaction_idx = 0; 
  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
  count_seperate_factor_by_bitwidth (preview_stride_c_bitwidth , factor);
  fp = $fopen(`TV_IN_preview_stride ,"r"); 
  if(fp == 0) begin                               // Failed to open file 
      $display("Failed to open file \"%s\"!", `TV_IN_preview_stride); 
      $finish; 
  end 
  read_token(fp, token); 
  if (token != "[[[runtime]]]") begin             // Illegal format 
      $display("ERROR: Simulation using HLS TB failed.");
      $finish; 
  end 
  read_token(fp, token); 
  while (token != "[[[/runtime]]]") begin 
      if (token != "[[transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token);                        // skip transaction number 
      @(posedge clk);
      # 0.2;
      while(AESL_ready_reg !== 1) begin
          @(posedge clk); 
          # 0.2;
      end
      for(i = 0; i < preview_stride_DEPTH; i = i + 1) begin 
          read_token(fp, token); 
          ret = $sscanf(token, "0x%x", token_tmp); 
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [7 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [15 : 8] = token_tmp;
              end
              if (i%factor == 2) begin
                  tmp_cache_mem [23 : 16] = token_tmp;
              end
              if (i%factor == 3) begin
                  tmp_cache_mem [31 : 24] = token_tmp;
                  mem_preview_stride [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
              end
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [15 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [31 : 16] = token_tmp;
                  mem_preview_stride [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1: 0] = 0;
              end
          end
          if (factor == 1) begin
              mem_preview_stride [i] = token_tmp;
          end
      end 
      if (factor == 4) begin
          if (i%factor != 0) begin
              mem_preview_stride [i/factor] = tmp_cache_mem;
          end
      end
      if (factor == 2) begin
          if (i%factor != 0) begin
              mem_preview_stride [i/factor] = tmp_cache_mem;
          end
      end 
      read_token(fp, token); 
      if(token != "[[/transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token); 
      transaction_idx = transaction_idx + 1; 
  end 
  $fclose(fp); 
end 
 
task write_binary_preview_stride;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
//------------------------Read file------------------------ 
 
// Read data from file 
initial begin : read_preview_capacity_file_process 
  integer fp; 
  integer ret; 
  integer factor; 
  reg [127 : 0] token; 
  reg [127 : 0] token_tmp; 
  //reg [preview_capacity_c_bitwidth - 1 : 0] token_tmp; 
  reg [DATA_WIDTH - 1 : 0] tmp_cache_mem; 
  reg [ 8*5 : 1] str;
    reg [63:0] trans_depth;
  integer transaction_idx; 
  integer i; 
  transaction_idx = 0; 
  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
  count_seperate_factor_by_bitwidth (preview_capacity_c_bitwidth , factor);
  fp = $fopen(`TV_IN_preview_capacity ,"r"); 
  if(fp == 0) begin                               // Failed to open file 
      $display("Failed to open file \"%s\"!", `TV_IN_preview_capacity); 
      $finish; 
  end 
  read_token(fp, token); 
  if (token != "[[[runtime]]]") begin             // Illegal format 
      $display("ERROR: Simulation using HLS TB failed.");
      $finish; 
  end 
  read_token(fp, token); 
  while (token != "[[[/runtime]]]") begin 
      if (token != "[[transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token);                        // skip transaction number 
      @(posedge clk);
      # 0.2;
      while(AESL_ready_reg !== 1) begin
          @(posedge clk); 
          # 0.2;
      end
      for(i = 0; i < preview_capacity_DEPTH; i = i + 1) begin 
          read_token(fp, token); 
          ret = $sscanf(token, "0x%x", token_tmp); 
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [7 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [15 : 8] = token_tmp;
              end
              if (i%factor == 2) begin
                  tmp_cache_mem [23 : 16] = token_tmp;
              end
              if (i%factor == 3) begin
                  tmp_cache_mem [31 : 24] = token_tmp;
                  mem_preview_capacity [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
              end
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [15 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [31 : 16] = token_tmp;
                  mem_preview_capacity [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1: 0] = 0;
              end
          end
          if (factor == 1) begin
              mem_preview_capacity [i] = token_tmp;
          end
      end 
      if (factor == 4) begin
          if (i%factor != 0) begin
              mem_preview_capacity [i/factor] = tmp_cache_mem;
          end
      end
      if (factor == 2) begin
          if (i%factor != 0) begin
              mem_preview_capacity [i/factor] = tmp_cache_mem;
          end
      end 
      read_token(fp, token); 
      if(token != "[[/transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token); 
      transaction_idx = transaction_idx + 1; 
  end 
  $fclose(fp); 
end 
 
task write_binary_preview_capacity;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
//------------------------Read file------------------------ 
 
// Read data from file 
initial begin : read_resized_w_file_process 
  integer fp; 
  integer ret; 
  integer factor; 
  reg [127 : 0] token; 
  reg [127 : 0] token_tmp; 
  //reg [resized_w_c_bitwidth - 1 : 0] token_tmp; 
  reg [DATA_WIDTH - 1 : 0] tmp_cache_mem; 
  reg [ 8*5 : 1] str;
    reg [63:0] trans_depth;
  integer transaction_idx; 
  integer i; 
  transaction_idx = 0; 
  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
  count_seperate_factor_by_bitwidth (resized_w_c_bitwidth , factor);
  fp = $fopen(`TV_IN_resized_w ,"r"); 
  if(fp == 0) begin                               // Failed to open file 
      $display("Failed to open file \"%s\"!", `TV_IN_resized_w); 
      $finish; 
  end 
  read_token(fp, token); 
  if (token != "[[[runtime]]]") begin             // Illegal format 
      $display("ERROR: Simulation using HLS TB failed.");
      $finish; 
  end 
  read_token(fp, token); 
  while (token != "[[[/runtime]]]") begin 
      if (token != "[[transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token);                        // skip transaction number 
      @(posedge clk);
      # 0.2;
      while(AESL_ready_reg !== 1) begin
          @(posedge clk); 
          # 0.2;
      end
      for(i = 0; i < resized_w_DEPTH; i = i + 1) begin 
          read_token(fp, token); 
          ret = $sscanf(token, "0x%x", token_tmp); 
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [7 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [15 : 8] = token_tmp;
              end
              if (i%factor == 2) begin
                  tmp_cache_mem [23 : 16] = token_tmp;
              end
              if (i%factor == 3) begin
                  tmp_cache_mem [31 : 24] = token_tmp;
                  mem_resized_w [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
              end
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [15 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [31 : 16] = token_tmp;
                  mem_resized_w [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1: 0] = 0;
              end
          end
          if (factor == 1) begin
              mem_resized_w [i] = token_tmp;
          end
      end 
      if (factor == 4) begin
          if (i%factor != 0) begin
              mem_resized_w [i/factor] = tmp_cache_mem;
          end
      end
      if (factor == 2) begin
          if (i%factor != 0) begin
              mem_resized_w [i/factor] = tmp_cache_mem;
          end
      end 
      read_token(fp, token); 
      if(token != "[[/transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token); 
      transaction_idx = transaction_idx + 1; 
  end 
  $fclose(fp); 
end 
 
task write_binary_resized_w;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
//------------------------Read file------------------------ 
 
// Read data from file 
initial begin : read_resized_h_file_process 
  integer fp; 
  integer ret; 
  integer factor; 
  reg [127 : 0] token; 
  reg [127 : 0] token_tmp; 
  //reg [resized_h_c_bitwidth - 1 : 0] token_tmp; 
  reg [DATA_WIDTH - 1 : 0] tmp_cache_mem; 
  reg [ 8*5 : 1] str;
    reg [63:0] trans_depth;
  integer transaction_idx; 
  integer i; 
  transaction_idx = 0; 
  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
  count_seperate_factor_by_bitwidth (resized_h_c_bitwidth , factor);
  fp = $fopen(`TV_IN_resized_h ,"r"); 
  if(fp == 0) begin                               // Failed to open file 
      $display("Failed to open file \"%s\"!", `TV_IN_resized_h); 
      $finish; 
  end 
  read_token(fp, token); 
  if (token != "[[[runtime]]]") begin             // Illegal format 
      $display("ERROR: Simulation using HLS TB failed.");
      $finish; 
  end 
  read_token(fp, token); 
  while (token != "[[[/runtime]]]") begin 
      if (token != "[[transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token);                        // skip transaction number 
      @(posedge clk);
      # 0.2;
      while(AESL_ready_reg !== 1) begin
          @(posedge clk); 
          # 0.2;
      end
      for(i = 0; i < resized_h_DEPTH; i = i + 1) begin 
          read_token(fp, token); 
          ret = $sscanf(token, "0x%x", token_tmp); 
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [7 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [15 : 8] = token_tmp;
              end
              if (i%factor == 2) begin
                  tmp_cache_mem [23 : 16] = token_tmp;
              end
              if (i%factor == 3) begin
                  tmp_cache_mem [31 : 24] = token_tmp;
                  mem_resized_h [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
              end
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [15 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [31 : 16] = token_tmp;
                  mem_resized_h [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1: 0] = 0;
              end
          end
          if (factor == 1) begin
              mem_resized_h [i] = token_tmp;
          end
      end 
      if (factor == 4) begin
          if (i%factor != 0) begin
              mem_resized_h [i/factor] = tmp_cache_mem;
          end
      end
      if (factor == 2) begin
          if (i%factor != 0) begin
              mem_resized_h [i/factor] = tmp_cache_mem;
          end
      end 
      read_token(fp, token); 
      if(token != "[[/transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token); 
      transaction_idx = transaction_idx + 1; 
  end 
  $fclose(fp); 
end 
 
task write_binary_resized_h;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
//------------------------Read file------------------------ 
 
// Read data from file 
initial begin : read_pad_x_file_process 
  integer fp; 
  integer ret; 
  integer factor; 
  reg [127 : 0] token; 
  reg [127 : 0] token_tmp; 
  //reg [pad_x_c_bitwidth - 1 : 0] token_tmp; 
  reg [DATA_WIDTH - 1 : 0] tmp_cache_mem; 
  reg [ 8*5 : 1] str;
    reg [63:0] trans_depth;
  integer transaction_idx; 
  integer i; 
  transaction_idx = 0; 
  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
  count_seperate_factor_by_bitwidth (pad_x_c_bitwidth , factor);
  fp = $fopen(`TV_IN_pad_x ,"r"); 
  if(fp == 0) begin                               // Failed to open file 
      $display("Failed to open file \"%s\"!", `TV_IN_pad_x); 
      $finish; 
  end 
  read_token(fp, token); 
  if (token != "[[[runtime]]]") begin             // Illegal format 
      $display("ERROR: Simulation using HLS TB failed.");
      $finish; 
  end 
  read_token(fp, token); 
  while (token != "[[[/runtime]]]") begin 
      if (token != "[[transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token);                        // skip transaction number 
      @(posedge clk);
      # 0.2;
      while(AESL_ready_reg !== 1) begin
          @(posedge clk); 
          # 0.2;
      end
      for(i = 0; i < pad_x_DEPTH; i = i + 1) begin 
          read_token(fp, token); 
          ret = $sscanf(token, "0x%x", token_tmp); 
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [7 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [15 : 8] = token_tmp;
              end
              if (i%factor == 2) begin
                  tmp_cache_mem [23 : 16] = token_tmp;
              end
              if (i%factor == 3) begin
                  tmp_cache_mem [31 : 24] = token_tmp;
                  mem_pad_x [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
              end
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [15 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [31 : 16] = token_tmp;
                  mem_pad_x [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1: 0] = 0;
              end
          end
          if (factor == 1) begin
              mem_pad_x [i] = token_tmp;
          end
      end 
      if (factor == 4) begin
          if (i%factor != 0) begin
              mem_pad_x [i/factor] = tmp_cache_mem;
          end
      end
      if (factor == 2) begin
          if (i%factor != 0) begin
              mem_pad_x [i/factor] = tmp_cache_mem;
          end
      end 
      read_token(fp, token); 
      if(token != "[[/transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token); 
      transaction_idx = transaction_idx + 1; 
  end 
  $fclose(fp); 
end 
 
task write_binary_pad_x;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
//------------------------Read file------------------------ 
 
// Read data from file 
initial begin : read_pad_y_file_process 
  integer fp; 
  integer ret; 
  integer factor; 
  reg [127 : 0] token; 
  reg [127 : 0] token_tmp; 
  //reg [pad_y_c_bitwidth - 1 : 0] token_tmp; 
  reg [DATA_WIDTH - 1 : 0] tmp_cache_mem; 
  reg [ 8*5 : 1] str;
    reg [63:0] trans_depth;
  integer transaction_idx; 
  integer i; 
  transaction_idx = 0; 
  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
  count_seperate_factor_by_bitwidth (pad_y_c_bitwidth , factor);
  fp = $fopen(`TV_IN_pad_y ,"r"); 
  if(fp == 0) begin                               // Failed to open file 
      $display("Failed to open file \"%s\"!", `TV_IN_pad_y); 
      $finish; 
  end 
  read_token(fp, token); 
  if (token != "[[[runtime]]]") begin             // Illegal format 
      $display("ERROR: Simulation using HLS TB failed.");
      $finish; 
  end 
  read_token(fp, token); 
  while (token != "[[[/runtime]]]") begin 
      if (token != "[[transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token);                        // skip transaction number 
      @(posedge clk);
      # 0.2;
      while(AESL_ready_reg !== 1) begin
          @(posedge clk); 
          # 0.2;
      end
      for(i = 0; i < pad_y_DEPTH; i = i + 1) begin 
          read_token(fp, token); 
          ret = $sscanf(token, "0x%x", token_tmp); 
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [7 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [15 : 8] = token_tmp;
              end
              if (i%factor == 2) begin
                  tmp_cache_mem [23 : 16] = token_tmp;
              end
              if (i%factor == 3) begin
                  tmp_cache_mem [31 : 24] = token_tmp;
                  mem_pad_y [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
              end
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [15 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [31 : 16] = token_tmp;
                  mem_pad_y [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1: 0] = 0;
              end
          end
          if (factor == 1) begin
              mem_pad_y [i] = token_tmp;
          end
      end 
      if (factor == 4) begin
          if (i%factor != 0) begin
              mem_pad_y [i/factor] = tmp_cache_mem;
          end
      end
      if (factor == 2) begin
          if (i%factor != 0) begin
              mem_pad_y [i/factor] = tmp_cache_mem;
          end
      end 
      read_token(fp, token); 
      if(token != "[[/transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token); 
      transaction_idx = transaction_idx + 1; 
  end 
  $fclose(fp); 
end 
 
task write_binary_pad_y;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
//------------------------Read file------------------------ 
 
// Read data from file 
initial begin : read_output_mode_file_process 
  integer fp; 
  integer ret; 
  integer factor; 
  reg [127 : 0] token; 
  reg [127 : 0] token_tmp; 
  //reg [output_mode_c_bitwidth - 1 : 0] token_tmp; 
  reg [DATA_WIDTH - 1 : 0] tmp_cache_mem; 
  reg [ 8*5 : 1] str;
    reg [63:0] trans_depth;
  integer transaction_idx; 
  integer i; 
  transaction_idx = 0; 
  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
  count_seperate_factor_by_bitwidth (output_mode_c_bitwidth , factor);
  fp = $fopen(`TV_IN_output_mode ,"r"); 
  if(fp == 0) begin                               // Failed to open file 
      $display("Failed to open file \"%s\"!", `TV_IN_output_mode); 
      $finish; 
  end 
  read_token(fp, token); 
  if (token != "[[[runtime]]]") begin             // Illegal format 
      $display("ERROR: Simulation using HLS TB failed.");
      $finish; 
  end 
  read_token(fp, token); 
  while (token != "[[[/runtime]]]") begin 
      if (token != "[[transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token);                        // skip transaction number 
      @(posedge clk);
      # 0.2;
      while(AESL_ready_reg !== 1) begin
          @(posedge clk); 
          # 0.2;
      end
      for(i = 0; i < output_mode_DEPTH; i = i + 1) begin 
          read_token(fp, token); 
          ret = $sscanf(token, "0x%x", token_tmp); 
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [7 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [15 : 8] = token_tmp;
              end
              if (i%factor == 2) begin
                  tmp_cache_mem [23 : 16] = token_tmp;
              end
              if (i%factor == 3) begin
                  tmp_cache_mem [31 : 24] = token_tmp;
                  mem_output_mode [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
              end
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [15 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [31 : 16] = token_tmp;
                  mem_output_mode [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1: 0] = 0;
              end
          end
          if (factor == 1) begin
              mem_output_mode [i] = token_tmp;
          end
      end 
      if (factor == 4) begin
          if (i%factor != 0) begin
              mem_output_mode [i/factor] = tmp_cache_mem;
          end
      end
      if (factor == 2) begin
          if (i%factor != 0) begin
              mem_output_mode [i/factor] = tmp_cache_mem;
          end
      end 
      read_token(fp, token); 
      if(token != "[[/transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token); 
      transaction_idx = transaction_idx + 1; 
  end 
  $fclose(fp); 
end 
 
task write_binary_output_mode;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
//------------------------Read file------------------------ 
 
// Read data from file 
initial begin : read_flags_file_process 
  integer fp; 
  integer ret; 
  integer factor; 
  reg [127 : 0] token; 
  reg [127 : 0] token_tmp; 
  //reg [flags_c_bitwidth - 1 : 0] token_tmp; 
  reg [DATA_WIDTH - 1 : 0] tmp_cache_mem; 
  reg [ 8*5 : 1] str;
    reg [63:0] trans_depth;
  integer transaction_idx; 
  integer i; 
  transaction_idx = 0; 
  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
  count_seperate_factor_by_bitwidth (flags_c_bitwidth , factor);
  fp = $fopen(`TV_IN_flags ,"r"); 
  if(fp == 0) begin                               // Failed to open file 
      $display("Failed to open file \"%s\"!", `TV_IN_flags); 
      $finish; 
  end 
  read_token(fp, token); 
  if (token != "[[[runtime]]]") begin             // Illegal format 
      $display("ERROR: Simulation using HLS TB failed.");
      $finish; 
  end 
  read_token(fp, token); 
  while (token != "[[[/runtime]]]") begin 
      if (token != "[[transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token);                        // skip transaction number 
      @(posedge clk);
      # 0.2;
      while(AESL_ready_reg !== 1) begin
          @(posedge clk); 
          # 0.2;
      end
      for(i = 0; i < flags_DEPTH; i = i + 1) begin 
          read_token(fp, token); 
          ret = $sscanf(token, "0x%x", token_tmp); 
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [7 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [15 : 8] = token_tmp;
              end
              if (i%factor == 2) begin
                  tmp_cache_mem [23 : 16] = token_tmp;
              end
              if (i%factor == 3) begin
                  tmp_cache_mem [31 : 24] = token_tmp;
                  mem_flags [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
              end
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [15 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [31 : 16] = token_tmp;
                  mem_flags [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1: 0] = 0;
              end
          end
          if (factor == 1) begin
              mem_flags [i] = token_tmp;
          end
      end 
      if (factor == 4) begin
          if (i%factor != 0) begin
              mem_flags [i/factor] = tmp_cache_mem;
          end
      end
      if (factor == 2) begin
          if (i%factor != 0) begin
              mem_flags [i/factor] = tmp_cache_mem;
          end
      end 
      read_token(fp, token); 
      if(token != "[[/transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token); 
      transaction_idx = transaction_idx + 1; 
  end 
  $fclose(fp); 
end 
 
task write_binary_flags;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
//------------------------Read file------------------------ 
 
// Read data from file 
initial begin : read_eq_mode_file_process 
  integer fp; 
  integer ret; 
  integer factor; 
  reg [127 : 0] token; 
  reg [127 : 0] token_tmp; 
  //reg [eq_mode_c_bitwidth - 1 : 0] token_tmp; 
  reg [DATA_WIDTH - 1 : 0] tmp_cache_mem; 
  reg [ 8*5 : 1] str;
    reg [63:0] trans_depth;
  integer transaction_idx; 
  integer i; 
  transaction_idx = 0; 
  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
  count_seperate_factor_by_bitwidth (eq_mode_c_bitwidth , factor);
  fp = $fopen(`TV_IN_eq_mode ,"r"); 
  if(fp == 0) begin                               // Failed to open file 
      $display("Failed to open file \"%s\"!", `TV_IN_eq_mode); 
      $finish; 
  end 
  read_token(fp, token); 
  if (token != "[[[runtime]]]") begin             // Illegal format 
      $display("ERROR: Simulation using HLS TB failed.");
      $finish; 
  end 
  read_token(fp, token); 
  while (token != "[[[/runtime]]]") begin 
      if (token != "[[transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token);                        // skip transaction number 
      @(posedge clk);
      # 0.2;
      while(AESL_ready_reg !== 1) begin
          @(posedge clk); 
          # 0.2;
      end
      for(i = 0; i < eq_mode_DEPTH; i = i + 1) begin 
          read_token(fp, token); 
          ret = $sscanf(token, "0x%x", token_tmp); 
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [7 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [15 : 8] = token_tmp;
              end
              if (i%factor == 2) begin
                  tmp_cache_mem [23 : 16] = token_tmp;
              end
              if (i%factor == 3) begin
                  tmp_cache_mem [31 : 24] = token_tmp;
                  mem_eq_mode [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
              end
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [15 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [31 : 16] = token_tmp;
                  mem_eq_mode [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1: 0] = 0;
              end
          end
          if (factor == 1) begin
              mem_eq_mode [i] = token_tmp;
          end
      end 
      if (factor == 4) begin
          if (i%factor != 0) begin
              mem_eq_mode [i/factor] = tmp_cache_mem;
          end
      end
      if (factor == 2) begin
          if (i%factor != 0) begin
              mem_eq_mode [i/factor] = tmp_cache_mem;
          end
      end 
      read_token(fp, token); 
      if(token != "[[/transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token); 
      transaction_idx = transaction_idx + 1; 
  end 
  $fclose(fp); 
end 
 
task write_binary_eq_mode;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
//------------------------Read file------------------------ 
 
// Read data from file 
initial begin : read_saturation_q12_file_process 
  integer fp; 
  integer ret; 
  integer factor; 
  reg [127 : 0] token; 
  reg [127 : 0] token_tmp; 
  //reg [saturation_q12_c_bitwidth - 1 : 0] token_tmp; 
  reg [DATA_WIDTH - 1 : 0] tmp_cache_mem; 
  reg [ 8*5 : 1] str;
    reg [63:0] trans_depth;
  integer transaction_idx; 
  integer i; 
  transaction_idx = 0; 
  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
  count_seperate_factor_by_bitwidth (saturation_q12_c_bitwidth , factor);
  fp = $fopen(`TV_IN_saturation_q12 ,"r"); 
  if(fp == 0) begin                               // Failed to open file 
      $display("Failed to open file \"%s\"!", `TV_IN_saturation_q12); 
      $finish; 
  end 
  read_token(fp, token); 
  if (token != "[[[runtime]]]") begin             // Illegal format 
      $display("ERROR: Simulation using HLS TB failed.");
      $finish; 
  end 
  read_token(fp, token); 
  while (token != "[[[/runtime]]]") begin 
      if (token != "[[transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token);                        // skip transaction number 
      @(posedge clk);
      # 0.2;
      while(AESL_ready_reg !== 1) begin
          @(posedge clk); 
          # 0.2;
      end
      for(i = 0; i < saturation_q12_DEPTH; i = i + 1) begin 
          read_token(fp, token); 
          ret = $sscanf(token, "0x%x", token_tmp); 
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [7 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [15 : 8] = token_tmp;
              end
              if (i%factor == 2) begin
                  tmp_cache_mem [23 : 16] = token_tmp;
              end
              if (i%factor == 3) begin
                  tmp_cache_mem [31 : 24] = token_tmp;
                  mem_saturation_q12 [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
              end
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [15 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [31 : 16] = token_tmp;
                  mem_saturation_q12 [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1: 0] = 0;
              end
          end
          if (factor == 1) begin
              mem_saturation_q12 [i] = token_tmp;
          end
      end 
      if (factor == 4) begin
          if (i%factor != 0) begin
              mem_saturation_q12 [i/factor] = tmp_cache_mem;
          end
      end
      if (factor == 2) begin
          if (i%factor != 0) begin
              mem_saturation_q12 [i/factor] = tmp_cache_mem;
          end
      end 
      read_token(fp, token); 
      if(token != "[[/transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token); 
      transaction_idx = transaction_idx + 1; 
  end 
  $fclose(fp); 
end 
 
task write_binary_saturation_q12;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
//------------------------Read file------------------------ 
 
// Read data from file 
initial begin : read_frame_id_file_process 
  integer fp; 
  integer ret; 
  integer factor; 
  reg [127 : 0] token; 
  reg [127 : 0] token_tmp; 
  //reg [frame_id_c_bitwidth - 1 : 0] token_tmp; 
  reg [DATA_WIDTH - 1 : 0] tmp_cache_mem; 
  reg [ 8*5 : 1] str;
    reg [63:0] trans_depth;
  integer transaction_idx; 
  integer i; 
  transaction_idx = 0; 
  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
  count_seperate_factor_by_bitwidth (frame_id_c_bitwidth , factor);
  fp = $fopen(`TV_IN_frame_id ,"r"); 
  if(fp == 0) begin                               // Failed to open file 
      $display("Failed to open file \"%s\"!", `TV_IN_frame_id); 
      $finish; 
  end 
  read_token(fp, token); 
  if (token != "[[[runtime]]]") begin             // Illegal format 
      $display("ERROR: Simulation using HLS TB failed.");
      $finish; 
  end 
  read_token(fp, token); 
  while (token != "[[[/runtime]]]") begin 
      if (token != "[[transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token);                        // skip transaction number 
      @(posedge clk);
      # 0.2;
      while(AESL_ready_reg !== 1) begin
          @(posedge clk); 
          # 0.2;
      end
      for(i = 0; i < frame_id_DEPTH; i = i + 1) begin 
          read_token(fp, token); 
          ret = $sscanf(token, "0x%x", token_tmp); 
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [7 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [15 : 8] = token_tmp;
              end
              if (i%factor == 2) begin
                  tmp_cache_mem [23 : 16] = token_tmp;
              end
              if (i%factor == 3) begin
                  tmp_cache_mem [31 : 24] = token_tmp;
                  mem_frame_id [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
              end
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [15 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [31 : 16] = token_tmp;
                  mem_frame_id [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1: 0] = 0;
              end
          end
          if (factor == 1) begin
              mem_frame_id [i] = token_tmp;
          end
      end 
      if (factor == 4) begin
          if (i%factor != 0) begin
              mem_frame_id [i/factor] = tmp_cache_mem;
          end
      end
      if (factor == 2) begin
          if (i%factor != 0) begin
              mem_frame_id [i/factor] = tmp_cache_mem;
          end
      end 
      read_token(fp, token); 
      if(token != "[[/transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token); 
      transaction_idx = transaction_idx + 1; 
  end 
  $fclose(fp); 
end 
 
task write_binary_frame_id;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
//------------------------Read file------------------------ 
 
// Read data from file 
initial begin : read_config_id_file_process 
  integer fp; 
  integer ret; 
  integer factor; 
  reg [127 : 0] token; 
  reg [127 : 0] token_tmp; 
  //reg [config_id_c_bitwidth - 1 : 0] token_tmp; 
  reg [DATA_WIDTH - 1 : 0] tmp_cache_mem; 
  reg [ 8*5 : 1] str;
    reg [63:0] trans_depth;
  integer transaction_idx; 
  integer i; 
  transaction_idx = 0; 
  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
  count_seperate_factor_by_bitwidth (config_id_c_bitwidth , factor);
  fp = $fopen(`TV_IN_config_id ,"r"); 
  if(fp == 0) begin                               // Failed to open file 
      $display("Failed to open file \"%s\"!", `TV_IN_config_id); 
      $finish; 
  end 
  read_token(fp, token); 
  if (token != "[[[runtime]]]") begin             // Illegal format 
      $display("ERROR: Simulation using HLS TB failed.");
      $finish; 
  end 
  read_token(fp, token); 
  while (token != "[[[/runtime]]]") begin 
      if (token != "[[transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token);                        // skip transaction number 
      @(posedge clk);
      # 0.2;
      while(AESL_ready_reg !== 1) begin
          @(posedge clk); 
          # 0.2;
      end
      for(i = 0; i < config_id_DEPTH; i = i + 1) begin 
          read_token(fp, token); 
          ret = $sscanf(token, "0x%x", token_tmp); 
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [7 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [15 : 8] = token_tmp;
              end
              if (i%factor == 2) begin
                  tmp_cache_mem [23 : 16] = token_tmp;
              end
              if (i%factor == 3) begin
                  tmp_cache_mem [31 : 24] = token_tmp;
                  mem_config_id [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
              end
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [15 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [31 : 16] = token_tmp;
                  mem_config_id [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1: 0] = 0;
              end
          end
          if (factor == 1) begin
              mem_config_id [i] = token_tmp;
          end
      end 
      if (factor == 4) begin
          if (i%factor != 0) begin
              mem_config_id [i/factor] = tmp_cache_mem;
          end
      end
      if (factor == 2) begin
          if (i%factor != 0) begin
              mem_config_id [i/factor] = tmp_cache_mem;
          end
      end 
      read_token(fp, token); 
      if(token != "[[/transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token); 
      transaction_idx = transaction_idx + 1; 
  end 
  $fclose(fp); 
end 
 
task write_binary_config_id;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
task write_binary_completed_frame_id;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
//------------------------Write file----------------------- 
 
// Write data to file 
 
initial begin : write_completed_frame_id_file_proc 
  integer fp; 
  integer factor; 
  integer transaction_idx; 
  reg [completed_frame_id_c_bitwidth - 1 : 0] tmp_cache_mem; 
  reg [ 100*8 : 1] str;
  reg [63:0] bin_data;
  integer i; 
  transaction_idx = 0; 
  count_seperate_factor_by_bitwidth (completed_frame_id_c_bitwidth , factor);
  while(1) begin 
      @(posedge clk);
      while (completed_frame_id_read_data_finish !== 1 || TRAN_control_transaction_done_in === 1) begin
          @(posedge clk);
      end
      # 0.1;
      fp = $fopen(`TV_OUT_completed_frame_id, "a"); 
      if(fp == 0) begin       // Failed to open file 
          $display("Failed to open file \"%s\"!", `TV_OUT_completed_frame_id); 
          $finish; 
      end 
      $fdisplay(fp, "[[transaction]] %d", transaction_idx);
      for (i = 0; i < (completed_frame_id_DEPTH - completed_frame_id_DEPTH % factor); i = i + 1) begin
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem = mem_completed_frame_id[i/factor][7:0];
              end
              if (i%factor == 1) begin
                  tmp_cache_mem = mem_completed_frame_id[i/factor][15:8];
              end
              if (i%factor == 2) begin
                  tmp_cache_mem = mem_completed_frame_id[i/factor][23:16];
              end
              if (i%factor == 3) begin
                  tmp_cache_mem = mem_completed_frame_id[i/factor][31:24];
              end
              $fdisplay(fp,"0x%x",tmp_cache_mem);
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem = mem_completed_frame_id[i/factor][15:0];
              end
              if (i%factor == 1) begin
                  tmp_cache_mem = mem_completed_frame_id[i/factor][31:16];
              end
              $fdisplay(fp,"0x%x",tmp_cache_mem);
          end
          if (factor == 1) begin
              $fdisplay(fp,"0x%x",mem_completed_frame_id[i]);
          end
      end 
      if (factor == 4) begin
          if ((completed_frame_id_DEPTH - 1) % factor == 2) begin
              $fdisplay(fp,"0x%x",mem_completed_frame_id[completed_frame_id_DEPTH / factor][7:0]);
              $fdisplay(fp,"0x%x",mem_completed_frame_id[completed_frame_id_DEPTH / factor][15:8]);
              $fdisplay(fp,"0x%x",mem_completed_frame_id[completed_frame_id_DEPTH / factor][23:16]);
          end
          if ((completed_frame_id_DEPTH - 1) % factor == 1) begin
              $fdisplay(fp,"0x%x",mem_completed_frame_id[completed_frame_id_DEPTH / factor][7:0]);
              $fdisplay(fp,"0x%x",mem_completed_frame_id[completed_frame_id_DEPTH / factor][15:8]);
          end
          if ((completed_frame_id_DEPTH - 1) % factor == 0) begin
              $fdisplay(fp,"0x%x",mem_completed_frame_id[completed_frame_id_DEPTH / factor][7:0]);
          end
      end
      if (factor == 2) begin
          if ((completed_frame_id_DEPTH - 1) % factor == 0) begin
              $fdisplay(fp,"0x%x",mem_completed_frame_id[completed_frame_id_DEPTH / factor][15:0]);
          end
      end
      $fdisplay(fp, "[[/transaction]]");
      transaction_idx = transaction_idx + 1;
      $fclose(fp); 
      while (TRAN_control_start_in !== 1) begin
          @(posedge clk);
      end
  end 
end 
 
task write_binary_completed_config_id;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
//------------------------Write file----------------------- 
 
// Write data to file 
 
initial begin : write_completed_config_id_file_proc 
  integer fp; 
  integer factor; 
  integer transaction_idx; 
  reg [completed_config_id_c_bitwidth - 1 : 0] tmp_cache_mem; 
  reg [ 100*8 : 1] str;
  reg [63:0] bin_data;
  integer i; 
  transaction_idx = 0; 
  count_seperate_factor_by_bitwidth (completed_config_id_c_bitwidth , factor);
  while(1) begin 
      @(posedge clk);
      while (completed_config_id_read_data_finish !== 1 || TRAN_control_transaction_done_in === 1) begin
          @(posedge clk);
      end
      # 0.1;
      fp = $fopen(`TV_OUT_completed_config_id, "a"); 
      if(fp == 0) begin       // Failed to open file 
          $display("Failed to open file \"%s\"!", `TV_OUT_completed_config_id); 
          $finish; 
      end 
      $fdisplay(fp, "[[transaction]] %d", transaction_idx);
      for (i = 0; i < (completed_config_id_DEPTH - completed_config_id_DEPTH % factor); i = i + 1) begin
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem = mem_completed_config_id[i/factor][7:0];
              end
              if (i%factor == 1) begin
                  tmp_cache_mem = mem_completed_config_id[i/factor][15:8];
              end
              if (i%factor == 2) begin
                  tmp_cache_mem = mem_completed_config_id[i/factor][23:16];
              end
              if (i%factor == 3) begin
                  tmp_cache_mem = mem_completed_config_id[i/factor][31:24];
              end
              $fdisplay(fp,"0x%x",tmp_cache_mem);
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem = mem_completed_config_id[i/factor][15:0];
              end
              if (i%factor == 1) begin
                  tmp_cache_mem = mem_completed_config_id[i/factor][31:16];
              end
              $fdisplay(fp,"0x%x",tmp_cache_mem);
          end
          if (factor == 1) begin
              $fdisplay(fp,"0x%x",mem_completed_config_id[i]);
          end
      end 
      if (factor == 4) begin
          if ((completed_config_id_DEPTH - 1) % factor == 2) begin
              $fdisplay(fp,"0x%x",mem_completed_config_id[completed_config_id_DEPTH / factor][7:0]);
              $fdisplay(fp,"0x%x",mem_completed_config_id[completed_config_id_DEPTH / factor][15:8]);
              $fdisplay(fp,"0x%x",mem_completed_config_id[completed_config_id_DEPTH / factor][23:16]);
          end
          if ((completed_config_id_DEPTH - 1) % factor == 1) begin
              $fdisplay(fp,"0x%x",mem_completed_config_id[completed_config_id_DEPTH / factor][7:0]);
              $fdisplay(fp,"0x%x",mem_completed_config_id[completed_config_id_DEPTH / factor][15:8]);
          end
          if ((completed_config_id_DEPTH - 1) % factor == 0) begin
              $fdisplay(fp,"0x%x",mem_completed_config_id[completed_config_id_DEPTH / factor][7:0]);
          end
      end
      if (factor == 2) begin
          if ((completed_config_id_DEPTH - 1) % factor == 0) begin
              $fdisplay(fp,"0x%x",mem_completed_config_id[completed_config_id_DEPTH / factor][15:0]);
          end
      end
      $fdisplay(fp, "[[/transaction]]");
      transaction_idx = transaction_idx + 1;
      $fclose(fp); 
      while (TRAN_control_start_in !== 1) begin
          @(posedge clk);
      end
  end 
end 
 
task write_binary_tensor_bytes;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
//------------------------Write file----------------------- 
 
// Write data to file 
 
initial begin : write_tensor_bytes_file_proc 
  integer fp; 
  integer factor; 
  integer transaction_idx; 
  reg [tensor_bytes_c_bitwidth - 1 : 0] tmp_cache_mem; 
  reg [ 100*8 : 1] str;
  reg [63:0] bin_data;
  integer i; 
  transaction_idx = 0; 
  count_seperate_factor_by_bitwidth (tensor_bytes_c_bitwidth , factor);
  while(1) begin 
      @(posedge clk);
      while (tensor_bytes_read_data_finish !== 1 || TRAN_control_transaction_done_in === 1) begin
          @(posedge clk);
      end
      # 0.1;
      fp = $fopen(`TV_OUT_tensor_bytes, "a"); 
      if(fp == 0) begin       // Failed to open file 
          $display("Failed to open file \"%s\"!", `TV_OUT_tensor_bytes); 
          $finish; 
      end 
      $fdisplay(fp, "[[transaction]] %d", transaction_idx);
      for (i = 0; i < (tensor_bytes_DEPTH - tensor_bytes_DEPTH % factor); i = i + 1) begin
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem = mem_tensor_bytes[i/factor][7:0];
              end
              if (i%factor == 1) begin
                  tmp_cache_mem = mem_tensor_bytes[i/factor][15:8];
              end
              if (i%factor == 2) begin
                  tmp_cache_mem = mem_tensor_bytes[i/factor][23:16];
              end
              if (i%factor == 3) begin
                  tmp_cache_mem = mem_tensor_bytes[i/factor][31:24];
              end
              $fdisplay(fp,"0x%x",tmp_cache_mem);
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem = mem_tensor_bytes[i/factor][15:0];
              end
              if (i%factor == 1) begin
                  tmp_cache_mem = mem_tensor_bytes[i/factor][31:16];
              end
              $fdisplay(fp,"0x%x",tmp_cache_mem);
          end
          if (factor == 1) begin
              $fdisplay(fp,"0x%x",mem_tensor_bytes[i]);
          end
      end 
      if (factor == 4) begin
          if ((tensor_bytes_DEPTH - 1) % factor == 2) begin
              $fdisplay(fp,"0x%x",mem_tensor_bytes[tensor_bytes_DEPTH / factor][7:0]);
              $fdisplay(fp,"0x%x",mem_tensor_bytes[tensor_bytes_DEPTH / factor][15:8]);
              $fdisplay(fp,"0x%x",mem_tensor_bytes[tensor_bytes_DEPTH / factor][23:16]);
          end
          if ((tensor_bytes_DEPTH - 1) % factor == 1) begin
              $fdisplay(fp,"0x%x",mem_tensor_bytes[tensor_bytes_DEPTH / factor][7:0]);
              $fdisplay(fp,"0x%x",mem_tensor_bytes[tensor_bytes_DEPTH / factor][15:8]);
          end
          if ((tensor_bytes_DEPTH - 1) % factor == 0) begin
              $fdisplay(fp,"0x%x",mem_tensor_bytes[tensor_bytes_DEPTH / factor][7:0]);
          end
      end
      if (factor == 2) begin
          if ((tensor_bytes_DEPTH - 1) % factor == 0) begin
              $fdisplay(fp,"0x%x",mem_tensor_bytes[tensor_bytes_DEPTH / factor][15:0]);
          end
      end
      $fdisplay(fp, "[[/transaction]]");
      transaction_idx = transaction_idx + 1;
      $fclose(fp); 
      while (TRAN_control_start_in !== 1) begin
          @(posedge clk);
      end
  end 
end 
 
task write_binary_preview_bytes;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
//------------------------Write file----------------------- 
 
// Write data to file 
 
initial begin : write_preview_bytes_file_proc 
  integer fp; 
  integer factor; 
  integer transaction_idx; 
  reg [preview_bytes_c_bitwidth - 1 : 0] tmp_cache_mem; 
  reg [ 100*8 : 1] str;
  reg [63:0] bin_data;
  integer i; 
  transaction_idx = 0; 
  count_seperate_factor_by_bitwidth (preview_bytes_c_bitwidth , factor);
  while(1) begin 
      @(posedge clk);
      while (preview_bytes_read_data_finish !== 1 || TRAN_control_transaction_done_in === 1) begin
          @(posedge clk);
      end
      # 0.1;
      fp = $fopen(`TV_OUT_preview_bytes, "a"); 
      if(fp == 0) begin       // Failed to open file 
          $display("Failed to open file \"%s\"!", `TV_OUT_preview_bytes); 
          $finish; 
      end 
      $fdisplay(fp, "[[transaction]] %d", transaction_idx);
      for (i = 0; i < (preview_bytes_DEPTH - preview_bytes_DEPTH % factor); i = i + 1) begin
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem = mem_preview_bytes[i/factor][7:0];
              end
              if (i%factor == 1) begin
                  tmp_cache_mem = mem_preview_bytes[i/factor][15:8];
              end
              if (i%factor == 2) begin
                  tmp_cache_mem = mem_preview_bytes[i/factor][23:16];
              end
              if (i%factor == 3) begin
                  tmp_cache_mem = mem_preview_bytes[i/factor][31:24];
              end
              $fdisplay(fp,"0x%x",tmp_cache_mem);
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem = mem_preview_bytes[i/factor][15:0];
              end
              if (i%factor == 1) begin
                  tmp_cache_mem = mem_preview_bytes[i/factor][31:16];
              end
              $fdisplay(fp,"0x%x",tmp_cache_mem);
          end
          if (factor == 1) begin
              $fdisplay(fp,"0x%x",mem_preview_bytes[i]);
          end
      end 
      if (factor == 4) begin
          if ((preview_bytes_DEPTH - 1) % factor == 2) begin
              $fdisplay(fp,"0x%x",mem_preview_bytes[preview_bytes_DEPTH / factor][7:0]);
              $fdisplay(fp,"0x%x",mem_preview_bytes[preview_bytes_DEPTH / factor][15:8]);
              $fdisplay(fp,"0x%x",mem_preview_bytes[preview_bytes_DEPTH / factor][23:16]);
          end
          if ((preview_bytes_DEPTH - 1) % factor == 1) begin
              $fdisplay(fp,"0x%x",mem_preview_bytes[preview_bytes_DEPTH / factor][7:0]);
              $fdisplay(fp,"0x%x",mem_preview_bytes[preview_bytes_DEPTH / factor][15:8]);
          end
          if ((preview_bytes_DEPTH - 1) % factor == 0) begin
              $fdisplay(fp,"0x%x",mem_preview_bytes[preview_bytes_DEPTH / factor][7:0]);
          end
      end
      if (factor == 2) begin
          if ((preview_bytes_DEPTH - 1) % factor == 0) begin
              $fdisplay(fp,"0x%x",mem_preview_bytes[preview_bytes_DEPTH / factor][15:0]);
          end
      end
      $fdisplay(fp, "[[/transaction]]");
      transaction_idx = transaction_idx + 1;
      $fclose(fp); 
      while (TRAN_control_start_in !== 1) begin
          @(posedge clk);
      end
  end 
end 
 
task write_binary_abi_version;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
//------------------------Write file----------------------- 
 
// Write data to file 
 
initial begin : write_abi_version_file_proc 
  integer fp; 
  integer factor; 
  integer transaction_idx; 
  reg [abi_version_c_bitwidth - 1 : 0] tmp_cache_mem; 
  reg [ 100*8 : 1] str;
  reg [63:0] bin_data;
  integer i; 
  transaction_idx = 0; 
  count_seperate_factor_by_bitwidth (abi_version_c_bitwidth , factor);
  while(1) begin 
      @(posedge clk);
      while (abi_version_read_data_finish !== 1 || TRAN_control_transaction_done_in === 1) begin
          @(posedge clk);
      end
      # 0.1;
      fp = $fopen(`TV_OUT_abi_version, "a"); 
      if(fp == 0) begin       // Failed to open file 
          $display("Failed to open file \"%s\"!", `TV_OUT_abi_version); 
          $finish; 
      end 
      $fdisplay(fp, "[[transaction]] %d", transaction_idx);
      for (i = 0; i < (abi_version_DEPTH - abi_version_DEPTH % factor); i = i + 1) begin
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem = mem_abi_version[i/factor][7:0];
              end
              if (i%factor == 1) begin
                  tmp_cache_mem = mem_abi_version[i/factor][15:8];
              end
              if (i%factor == 2) begin
                  tmp_cache_mem = mem_abi_version[i/factor][23:16];
              end
              if (i%factor == 3) begin
                  tmp_cache_mem = mem_abi_version[i/factor][31:24];
              end
              $fdisplay(fp,"0x%x",tmp_cache_mem);
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem = mem_abi_version[i/factor][15:0];
              end
              if (i%factor == 1) begin
                  tmp_cache_mem = mem_abi_version[i/factor][31:16];
              end
              $fdisplay(fp,"0x%x",tmp_cache_mem);
          end
          if (factor == 1) begin
              $fdisplay(fp,"0x%x",mem_abi_version[i]);
          end
      end 
      if (factor == 4) begin
          if ((abi_version_DEPTH - 1) % factor == 2) begin
              $fdisplay(fp,"0x%x",mem_abi_version[abi_version_DEPTH / factor][7:0]);
              $fdisplay(fp,"0x%x",mem_abi_version[abi_version_DEPTH / factor][15:8]);
              $fdisplay(fp,"0x%x",mem_abi_version[abi_version_DEPTH / factor][23:16]);
          end
          if ((abi_version_DEPTH - 1) % factor == 1) begin
              $fdisplay(fp,"0x%x",mem_abi_version[abi_version_DEPTH / factor][7:0]);
              $fdisplay(fp,"0x%x",mem_abi_version[abi_version_DEPTH / factor][15:8]);
          end
          if ((abi_version_DEPTH - 1) % factor == 0) begin
              $fdisplay(fp,"0x%x",mem_abi_version[abi_version_DEPTH / factor][7:0]);
          end
      end
      if (factor == 2) begin
          if ((abi_version_DEPTH - 1) % factor == 0) begin
              $fdisplay(fp,"0x%x",mem_abi_version[abi_version_DEPTH / factor][15:0]);
          end
      end
      $fdisplay(fp, "[[/transaction]]");
      transaction_idx = transaction_idx + 1;
      $fclose(fp); 
      while (TRAN_control_start_in !== 1) begin
          @(posedge clk);
      end
  end 
end 
 
task write_binary_ap_return;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
//------------------------Write file----------------------- 
 
// Write data to file 
 
initial begin : write_ap_return_file_proc 
  integer fp; 
  integer factor; 
  integer transaction_idx; 
  reg [ap_return_c_bitwidth - 1 : 0] tmp_cache_mem; 
  reg [ 100*8 : 1] str;
  reg [63:0] bin_data;
  integer i; 
  transaction_idx = 0; 
  count_seperate_factor_by_bitwidth (ap_return_c_bitwidth , factor);
  while(1) begin 
      @(posedge clk);
      while (TRAN_control_transaction_done_in !== 1) begin
          @(posedge clk);
      end
      # 0.1;
      fp = $fopen(`TV_OUT_ap_return, "a"); 
      if(fp == 0) begin       // Failed to open file 
          $display("Failed to open file \"%s\"!", `TV_OUT_ap_return); 
          $finish; 
      end 
      $fdisplay(fp, "[[transaction]] %d", transaction_idx);
      for (i = 0; i < (ap_return_DEPTH - ap_return_DEPTH % factor); i = i + 1) begin
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem = mem_ap_return[i/factor][7:0];
              end
              if (i%factor == 1) begin
                  tmp_cache_mem = mem_ap_return[i/factor][15:8];
              end
              if (i%factor == 2) begin
                  tmp_cache_mem = mem_ap_return[i/factor][23:16];
              end
              if (i%factor == 3) begin
                  tmp_cache_mem = mem_ap_return[i/factor][31:24];
              end
              $fdisplay(fp,"0x%x",tmp_cache_mem);
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem = mem_ap_return[i/factor][15:0];
              end
              if (i%factor == 1) begin
                  tmp_cache_mem = mem_ap_return[i/factor][31:16];
              end
              $fdisplay(fp,"0x%x",tmp_cache_mem);
          end
          if (factor == 1) begin
              $fdisplay(fp,"0x%x",mem_ap_return[i]);
          end
      end 
      if (factor == 4) begin
          if ((ap_return_DEPTH - 1) % factor == 2) begin
              $fdisplay(fp,"0x%x",mem_ap_return[ap_return_DEPTH / factor][7:0]);
              $fdisplay(fp,"0x%x",mem_ap_return[ap_return_DEPTH / factor][15:8]);
              $fdisplay(fp,"0x%x",mem_ap_return[ap_return_DEPTH / factor][23:16]);
          end
          if ((ap_return_DEPTH - 1) % factor == 1) begin
              $fdisplay(fp,"0x%x",mem_ap_return[ap_return_DEPTH / factor][7:0]);
              $fdisplay(fp,"0x%x",mem_ap_return[ap_return_DEPTH / factor][15:8]);
          end
          if ((ap_return_DEPTH - 1) % factor == 0) begin
              $fdisplay(fp,"0x%x",mem_ap_return[ap_return_DEPTH / factor][7:0]);
          end
      end
      if (factor == 2) begin
          if ((ap_return_DEPTH - 1) % factor == 0) begin
              $fdisplay(fp,"0x%x",mem_ap_return[ap_return_DEPTH / factor][15:0]);
          end
      end
      $fdisplay(fp, "[[/transaction]]");
      transaction_idx = transaction_idx + 1;
      $fclose(fp); 
  end 
end 
 
endmodule
