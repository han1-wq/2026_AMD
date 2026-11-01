// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (lin64) Build 3526262 Mon Apr 18 15:47:01 MDT 2022
// Date        : Wed Oct 14 01:41:45 2026
// Host        : ubuntu running 64-bit Ubuntu 20.04.1 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/amd/Workspace/dpu_platform2/kv260_vitis_platform/dpu_trd_system_hw_link/Hardware/dpu.build/link/vivado/vpl/prj/prj.gen/sources_1/bd/kv260_hardware_platform/ip/kv260_hardware_platform_sfm_xrt_top_1_0/kv260_hardware_platform_sfm_xrt_top_1_0_stub.v
// Design      : kv260_hardware_platform_sfm_xrt_top_1_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xck26-sfvc784-2LV-c
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "sfm_xrt_top,Vivado 2022.1" *)
module kv260_hardware_platform_sfm_xrt_top_1_0(aclk, aresetn, s_axi_control_AWVALID, 
  s_axi_control_AWREADY, s_axi_control_AWADDR, s_axi_control_WVALID, 
  s_axi_control_WREADY, s_axi_control_WDATA, s_axi_control_WSTRB, s_axi_control_ARVALID, 
  s_axi_control_ARREADY, s_axi_control_ARADDR, s_axi_control_RVALID, 
  s_axi_control_RREADY, s_axi_control_RDATA, s_axi_control_RRESP, s_axi_control_BVALID, 
  s_axi_control_BREADY, s_axi_control_BRESP, M_AXI_araddr, M_AXI_arburst, M_AXI_arcache, 
  M_AXI_arlen, M_AXI_arlock, M_AXI_arprot, M_AXI_arqos, M_AXI_arready, M_AXI_arsize, 
  M_AXI_arvalid, M_AXI_awaddr, M_AXI_awburst, M_AXI_awcache, M_AXI_awlen, M_AXI_awlock, 
  M_AXI_awprot, M_AXI_awqos, M_AXI_awready, M_AXI_awsize, M_AXI_awvalid, M_AXI_bready, 
  M_AXI_bresp, M_AXI_bvalid, M_AXI_rdata, M_AXI_rlast, M_AXI_rready, M_AXI_rresp, M_AXI_rvalid, 
  M_AXI_wdata, M_AXI_wlast, M_AXI_wready, M_AXI_wstrb, M_AXI_wvalid, interrupt)
/* synthesis syn_black_box black_box_pad_pin="aclk,aresetn,s_axi_control_AWVALID,s_axi_control_AWREADY,s_axi_control_AWADDR[11:0],s_axi_control_WVALID,s_axi_control_WREADY,s_axi_control_WDATA[31:0],s_axi_control_WSTRB[3:0],s_axi_control_ARVALID,s_axi_control_ARREADY,s_axi_control_ARADDR[11:0],s_axi_control_RVALID,s_axi_control_RREADY,s_axi_control_RDATA[31:0],s_axi_control_RRESP[1:0],s_axi_control_BVALID,s_axi_control_BREADY,s_axi_control_BRESP[1:0],M_AXI_araddr[31:0],M_AXI_arburst[1:0],M_AXI_arcache[3:0],M_AXI_arlen[7:0],M_AXI_arlock[0:0],M_AXI_arprot[2:0],M_AXI_arqos[3:0],M_AXI_arready,M_AXI_arsize[2:0],M_AXI_arvalid,M_AXI_awaddr[31:0],M_AXI_awburst[1:0],M_AXI_awcache[3:0],M_AXI_awlen[7:0],M_AXI_awlock[0:0],M_AXI_awprot[2:0],M_AXI_awqos[3:0],M_AXI_awready,M_AXI_awsize[2:0],M_AXI_awvalid,M_AXI_bready,M_AXI_bresp[1:0],M_AXI_bvalid,M_AXI_rdata[127:0],M_AXI_rlast,M_AXI_rready,M_AXI_rresp[1:0],M_AXI_rvalid,M_AXI_wdata[127:0],M_AXI_wlast,M_AXI_wready,M_AXI_wstrb[15:0],M_AXI_wvalid,interrupt" */;
  input aclk;
  input aresetn;
  input s_axi_control_AWVALID;
  output s_axi_control_AWREADY;
  input [11:0]s_axi_control_AWADDR;
  input s_axi_control_WVALID;
  output s_axi_control_WREADY;
  input [31:0]s_axi_control_WDATA;
  input [3:0]s_axi_control_WSTRB;
  input s_axi_control_ARVALID;
  output s_axi_control_ARREADY;
  input [11:0]s_axi_control_ARADDR;
  output s_axi_control_RVALID;
  input s_axi_control_RREADY;
  output [31:0]s_axi_control_RDATA;
  output [1:0]s_axi_control_RRESP;
  output s_axi_control_BVALID;
  input s_axi_control_BREADY;
  output [1:0]s_axi_control_BRESP;
  output [31:0]M_AXI_araddr;
  output [1:0]M_AXI_arburst;
  output [3:0]M_AXI_arcache;
  output [7:0]M_AXI_arlen;
  output [0:0]M_AXI_arlock;
  output [2:0]M_AXI_arprot;
  output [3:0]M_AXI_arqos;
  input M_AXI_arready;
  output [2:0]M_AXI_arsize;
  output M_AXI_arvalid;
  output [31:0]M_AXI_awaddr;
  output [1:0]M_AXI_awburst;
  output [3:0]M_AXI_awcache;
  output [7:0]M_AXI_awlen;
  output [0:0]M_AXI_awlock;
  output [2:0]M_AXI_awprot;
  output [3:0]M_AXI_awqos;
  input M_AXI_awready;
  output [2:0]M_AXI_awsize;
  output M_AXI_awvalid;
  output M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input M_AXI_bvalid;
  input [127:0]M_AXI_rdata;
  input M_AXI_rlast;
  output M_AXI_rready;
  input [1:0]M_AXI_rresp;
  input M_AXI_rvalid;
  output [127:0]M_AXI_wdata;
  output M_AXI_wlast;
  input M_AXI_wready;
  output [15:0]M_AXI_wstrb;
  output M_AXI_wvalid;
  output interrupt;
endmodule
