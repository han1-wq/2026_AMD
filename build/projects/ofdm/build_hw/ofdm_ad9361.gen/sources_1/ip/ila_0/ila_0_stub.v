// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (lin64) Build 3526262 Mon Apr 18 15:47:01 MDT 2022
// Date        : Fri Oct 16 02:52:19 2026
// Host        : ubuntu running 64-bit Ubuntu 20.04.1 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/amd/ofdm/eeSDR_ofdm_loopback/build_hw/ofdm_ad9361.gen/sources_1/ip/ila_0/ila_0_stub.v
// Design      : ila_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "ila,Vivado 2022.1" *)
module ila_0(clk, probe0, probe1, probe2, probe3, probe4, probe5, 
  probe6, probe7, probe8, probe9, probe10, probe11, probe12, probe13, probe14, probe15, probe16, probe17, 
  probe18)
/* synthesis syn_black_box black_box_pad_pin="clk,probe0[0:0],probe1[0:0],probe2[15:0],probe3[15:0],probe4[3:0],probe5[11:0],probe6[11:0],probe7[0:0],probe8[11:0],probe9[11:0],probe10[0:0],probe11[15:0],probe12[15:0],probe13[6:0],probe14[7:0],probe15[15:0],probe16[9:0],probe17[2:0],probe18[10:0]" */;
  input clk;
  input [0:0]probe0;
  input [0:0]probe1;
  input [15:0]probe2;
  input [15:0]probe3;
  input [3:0]probe4;
  input [11:0]probe5;
  input [11:0]probe6;
  input [0:0]probe7;
  input [11:0]probe8;
  input [11:0]probe9;
  input [0:0]probe10;
  input [15:0]probe11;
  input [15:0]probe12;
  input [6:0]probe13;
  input [7:0]probe14;
  input [15:0]probe15;
  input [9:0]probe16;
  input [2:0]probe17;
  input [10:0]probe18;
endmodule
