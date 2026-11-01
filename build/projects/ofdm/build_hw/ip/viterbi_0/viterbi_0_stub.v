// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (lin64) Build 3526262 Mon Apr 18 15:47:01 MDT 2022
// Date        : Fri Oct 16 02:52:07 2026
// Host        : ubuntu running 64-bit Ubuntu 20.04.1 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/amd/ofdm/eeSDR_ofdm_loopback/build_hw/ip/viterbi_0/viterbi_0_stub.v
// Design      : viterbi_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "viterbi_v9_1_13,Vivado 2022.1" *)
module viterbi_0(aclk, aresetn, s_axis_data_tdata, 
  s_axis_data_tuser, s_axis_data_tvalid, s_axis_data_tready, m_axis_data_tdata, 
  m_axis_data_tvalid)
/* synthesis syn_black_box black_box_pad_pin="aclk,aresetn,s_axis_data_tdata[15:0],s_axis_data_tuser[7:0],s_axis_data_tvalid,s_axis_data_tready,m_axis_data_tdata[7:0],m_axis_data_tvalid" */;
  input aclk;
  input aresetn;
  input [15:0]s_axis_data_tdata;
  input [7:0]s_axis_data_tuser;
  input s_axis_data_tvalid;
  output s_axis_data_tready;
  output [7:0]m_axis_data_tdata;
  output m_axis_data_tvalid;
endmodule
