// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (lin64) Build 3526262 Mon Apr 18 15:47:01 MDT 2022
// Date        : Wed Oct 14 01:37:42 2026
// Host        : ubuntu running 64-bit Ubuntu 20.04.1 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/amd/Workspace/dpu_platform2/kv260_vitis_platform/dpu_trd_system_hw_link/Hardware/dpu.build/link/vivado/vpl/prj/prj.gen/sources_1/bd/kv260_hardware_platform/ip/kv260_hardware_platform_image_preprocess_1_0/kv260_hardware_platform_image_preprocess_1_0_stub.v
// Design      : kv260_hardware_platform_image_preprocess_1_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xck26-sfvc784-2LV-c
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "image_preprocess,Vivado 2022.1" *)
module kv260_hardware_platform_image_preprocess_1_0(s_axi_control_AWADDR, 
  s_axi_control_AWVALID, s_axi_control_AWREADY, s_axi_control_WDATA, s_axi_control_WSTRB, 
  s_axi_control_WVALID, s_axi_control_WREADY, s_axi_control_BRESP, s_axi_control_BVALID, 
  s_axi_control_BREADY, s_axi_control_ARADDR, s_axi_control_ARVALID, 
  s_axi_control_ARREADY, s_axi_control_RDATA, s_axi_control_RRESP, s_axi_control_RVALID, 
  s_axi_control_RREADY, ap_clk, ap_rst_n, interrupt, m_axi_gmem_in_AWADDR, 
  m_axi_gmem_in_AWLEN, m_axi_gmem_in_AWSIZE, m_axi_gmem_in_AWBURST, m_axi_gmem_in_AWLOCK, 
  m_axi_gmem_in_AWREGION, m_axi_gmem_in_AWCACHE, m_axi_gmem_in_AWPROT, 
  m_axi_gmem_in_AWQOS, m_axi_gmem_in_AWVALID, m_axi_gmem_in_AWREADY, m_axi_gmem_in_WDATA, 
  m_axi_gmem_in_WSTRB, m_axi_gmem_in_WLAST, m_axi_gmem_in_WVALID, m_axi_gmem_in_WREADY, 
  m_axi_gmem_in_BRESP, m_axi_gmem_in_BVALID, m_axi_gmem_in_BREADY, m_axi_gmem_in_ARADDR, 
  m_axi_gmem_in_ARLEN, m_axi_gmem_in_ARSIZE, m_axi_gmem_in_ARBURST, m_axi_gmem_in_ARLOCK, 
  m_axi_gmem_in_ARREGION, m_axi_gmem_in_ARCACHE, m_axi_gmem_in_ARPROT, 
  m_axi_gmem_in_ARQOS, m_axi_gmem_in_ARVALID, m_axi_gmem_in_ARREADY, m_axi_gmem_in_RDATA, 
  m_axi_gmem_in_RRESP, m_axi_gmem_in_RLAST, m_axi_gmem_in_RVALID, m_axi_gmem_in_RREADY, 
  m_axi_gmem_out_AWADDR, m_axi_gmem_out_AWLEN, m_axi_gmem_out_AWSIZE, 
  m_axi_gmem_out_AWBURST, m_axi_gmem_out_AWLOCK, m_axi_gmem_out_AWREGION, 
  m_axi_gmem_out_AWCACHE, m_axi_gmem_out_AWPROT, m_axi_gmem_out_AWQOS, 
  m_axi_gmem_out_AWVALID, m_axi_gmem_out_AWREADY, m_axi_gmem_out_WDATA, 
  m_axi_gmem_out_WSTRB, m_axi_gmem_out_WLAST, m_axi_gmem_out_WVALID, 
  m_axi_gmem_out_WREADY, m_axi_gmem_out_BRESP, m_axi_gmem_out_BVALID, 
  m_axi_gmem_out_BREADY, m_axi_gmem_out_ARADDR, m_axi_gmem_out_ARLEN, 
  m_axi_gmem_out_ARSIZE, m_axi_gmem_out_ARBURST, m_axi_gmem_out_ARLOCK, 
  m_axi_gmem_out_ARREGION, m_axi_gmem_out_ARCACHE, m_axi_gmem_out_ARPROT, 
  m_axi_gmem_out_ARQOS, m_axi_gmem_out_ARVALID, m_axi_gmem_out_ARREADY, 
  m_axi_gmem_out_RDATA, m_axi_gmem_out_RRESP, m_axi_gmem_out_RLAST, 
  m_axi_gmem_out_RVALID, m_axi_gmem_out_RREADY, m_axi_gmem_preview_AWADDR, 
  m_axi_gmem_preview_AWLEN, m_axi_gmem_preview_AWSIZE, m_axi_gmem_preview_AWBURST, 
  m_axi_gmem_preview_AWLOCK, m_axi_gmem_preview_AWREGION, m_axi_gmem_preview_AWCACHE, 
  m_axi_gmem_preview_AWPROT, m_axi_gmem_preview_AWQOS, m_axi_gmem_preview_AWVALID, 
  m_axi_gmem_preview_AWREADY, m_axi_gmem_preview_WDATA, m_axi_gmem_preview_WSTRB, 
  m_axi_gmem_preview_WLAST, m_axi_gmem_preview_WVALID, m_axi_gmem_preview_WREADY, 
  m_axi_gmem_preview_BRESP, m_axi_gmem_preview_BVALID, m_axi_gmem_preview_BREADY, 
  m_axi_gmem_preview_ARADDR, m_axi_gmem_preview_ARLEN, m_axi_gmem_preview_ARSIZE, 
  m_axi_gmem_preview_ARBURST, m_axi_gmem_preview_ARLOCK, m_axi_gmem_preview_ARREGION, 
  m_axi_gmem_preview_ARCACHE, m_axi_gmem_preview_ARPROT, m_axi_gmem_preview_ARQOS, 
  m_axi_gmem_preview_ARVALID, m_axi_gmem_preview_ARREADY, m_axi_gmem_preview_RDATA, 
  m_axi_gmem_preview_RRESP, m_axi_gmem_preview_RLAST, m_axi_gmem_preview_RVALID, 
  m_axi_gmem_preview_RREADY)
/* synthesis syn_black_box black_box_pad_pin="s_axi_control_AWADDR[8:0],s_axi_control_AWVALID,s_axi_control_AWREADY,s_axi_control_WDATA[31:0],s_axi_control_WSTRB[3:0],s_axi_control_WVALID,s_axi_control_WREADY,s_axi_control_BRESP[1:0],s_axi_control_BVALID,s_axi_control_BREADY,s_axi_control_ARADDR[8:0],s_axi_control_ARVALID,s_axi_control_ARREADY,s_axi_control_RDATA[31:0],s_axi_control_RRESP[1:0],s_axi_control_RVALID,s_axi_control_RREADY,ap_clk,ap_rst_n,interrupt,m_axi_gmem_in_AWADDR[63:0],m_axi_gmem_in_AWLEN[7:0],m_axi_gmem_in_AWSIZE[2:0],m_axi_gmem_in_AWBURST[1:0],m_axi_gmem_in_AWLOCK[1:0],m_axi_gmem_in_AWREGION[3:0],m_axi_gmem_in_AWCACHE[3:0],m_axi_gmem_in_AWPROT[2:0],m_axi_gmem_in_AWQOS[3:0],m_axi_gmem_in_AWVALID,m_axi_gmem_in_AWREADY,m_axi_gmem_in_WDATA[127:0],m_axi_gmem_in_WSTRB[15:0],m_axi_gmem_in_WLAST,m_axi_gmem_in_WVALID,m_axi_gmem_in_WREADY,m_axi_gmem_in_BRESP[1:0],m_axi_gmem_in_BVALID,m_axi_gmem_in_BREADY,m_axi_gmem_in_ARADDR[63:0],m_axi_gmem_in_ARLEN[7:0],m_axi_gmem_in_ARSIZE[2:0],m_axi_gmem_in_ARBURST[1:0],m_axi_gmem_in_ARLOCK[1:0],m_axi_gmem_in_ARREGION[3:0],m_axi_gmem_in_ARCACHE[3:0],m_axi_gmem_in_ARPROT[2:0],m_axi_gmem_in_ARQOS[3:0],m_axi_gmem_in_ARVALID,m_axi_gmem_in_ARREADY,m_axi_gmem_in_RDATA[127:0],m_axi_gmem_in_RRESP[1:0],m_axi_gmem_in_RLAST,m_axi_gmem_in_RVALID,m_axi_gmem_in_RREADY,m_axi_gmem_out_AWADDR[63:0],m_axi_gmem_out_AWLEN[7:0],m_axi_gmem_out_AWSIZE[2:0],m_axi_gmem_out_AWBURST[1:0],m_axi_gmem_out_AWLOCK[1:0],m_axi_gmem_out_AWREGION[3:0],m_axi_gmem_out_AWCACHE[3:0],m_axi_gmem_out_AWPROT[2:0],m_axi_gmem_out_AWQOS[3:0],m_axi_gmem_out_AWVALID,m_axi_gmem_out_AWREADY,m_axi_gmem_out_WDATA[127:0],m_axi_gmem_out_WSTRB[15:0],m_axi_gmem_out_WLAST,m_axi_gmem_out_WVALID,m_axi_gmem_out_WREADY,m_axi_gmem_out_BRESP[1:0],m_axi_gmem_out_BVALID,m_axi_gmem_out_BREADY,m_axi_gmem_out_ARADDR[63:0],m_axi_gmem_out_ARLEN[7:0],m_axi_gmem_out_ARSIZE[2:0],m_axi_gmem_out_ARBURST[1:0],m_axi_gmem_out_ARLOCK[1:0],m_axi_gmem_out_ARREGION[3:0],m_axi_gmem_out_ARCACHE[3:0],m_axi_gmem_out_ARPROT[2:0],m_axi_gmem_out_ARQOS[3:0],m_axi_gmem_out_ARVALID,m_axi_gmem_out_ARREADY,m_axi_gmem_out_RDATA[127:0],m_axi_gmem_out_RRESP[1:0],m_axi_gmem_out_RLAST,m_axi_gmem_out_RVALID,m_axi_gmem_out_RREADY,m_axi_gmem_preview_AWADDR[63:0],m_axi_gmem_preview_AWLEN[7:0],m_axi_gmem_preview_AWSIZE[2:0],m_axi_gmem_preview_AWBURST[1:0],m_axi_gmem_preview_AWLOCK[1:0],m_axi_gmem_preview_AWREGION[3:0],m_axi_gmem_preview_AWCACHE[3:0],m_axi_gmem_preview_AWPROT[2:0],m_axi_gmem_preview_AWQOS[3:0],m_axi_gmem_preview_AWVALID,m_axi_gmem_preview_AWREADY,m_axi_gmem_preview_WDATA[127:0],m_axi_gmem_preview_WSTRB[15:0],m_axi_gmem_preview_WLAST,m_axi_gmem_preview_WVALID,m_axi_gmem_preview_WREADY,m_axi_gmem_preview_BRESP[1:0],m_axi_gmem_preview_BVALID,m_axi_gmem_preview_BREADY,m_axi_gmem_preview_ARADDR[63:0],m_axi_gmem_preview_ARLEN[7:0],m_axi_gmem_preview_ARSIZE[2:0],m_axi_gmem_preview_ARBURST[1:0],m_axi_gmem_preview_ARLOCK[1:0],m_axi_gmem_preview_ARREGION[3:0],m_axi_gmem_preview_ARCACHE[3:0],m_axi_gmem_preview_ARPROT[2:0],m_axi_gmem_preview_ARQOS[3:0],m_axi_gmem_preview_ARVALID,m_axi_gmem_preview_ARREADY,m_axi_gmem_preview_RDATA[127:0],m_axi_gmem_preview_RRESP[1:0],m_axi_gmem_preview_RLAST,m_axi_gmem_preview_RVALID,m_axi_gmem_preview_RREADY" */;
  input [8:0]s_axi_control_AWADDR;
  input s_axi_control_AWVALID;
  output s_axi_control_AWREADY;
  input [31:0]s_axi_control_WDATA;
  input [3:0]s_axi_control_WSTRB;
  input s_axi_control_WVALID;
  output s_axi_control_WREADY;
  output [1:0]s_axi_control_BRESP;
  output s_axi_control_BVALID;
  input s_axi_control_BREADY;
  input [8:0]s_axi_control_ARADDR;
  input s_axi_control_ARVALID;
  output s_axi_control_ARREADY;
  output [31:0]s_axi_control_RDATA;
  output [1:0]s_axi_control_RRESP;
  output s_axi_control_RVALID;
  input s_axi_control_RREADY;
  input ap_clk;
  input ap_rst_n;
  output interrupt;
  output [63:0]m_axi_gmem_in_AWADDR;
  output [7:0]m_axi_gmem_in_AWLEN;
  output [2:0]m_axi_gmem_in_AWSIZE;
  output [1:0]m_axi_gmem_in_AWBURST;
  output [1:0]m_axi_gmem_in_AWLOCK;
  output [3:0]m_axi_gmem_in_AWREGION;
  output [3:0]m_axi_gmem_in_AWCACHE;
  output [2:0]m_axi_gmem_in_AWPROT;
  output [3:0]m_axi_gmem_in_AWQOS;
  output m_axi_gmem_in_AWVALID;
  input m_axi_gmem_in_AWREADY;
  output [127:0]m_axi_gmem_in_WDATA;
  output [15:0]m_axi_gmem_in_WSTRB;
  output m_axi_gmem_in_WLAST;
  output m_axi_gmem_in_WVALID;
  input m_axi_gmem_in_WREADY;
  input [1:0]m_axi_gmem_in_BRESP;
  input m_axi_gmem_in_BVALID;
  output m_axi_gmem_in_BREADY;
  output [63:0]m_axi_gmem_in_ARADDR;
  output [7:0]m_axi_gmem_in_ARLEN;
  output [2:0]m_axi_gmem_in_ARSIZE;
  output [1:0]m_axi_gmem_in_ARBURST;
  output [1:0]m_axi_gmem_in_ARLOCK;
  output [3:0]m_axi_gmem_in_ARREGION;
  output [3:0]m_axi_gmem_in_ARCACHE;
  output [2:0]m_axi_gmem_in_ARPROT;
  output [3:0]m_axi_gmem_in_ARQOS;
  output m_axi_gmem_in_ARVALID;
  input m_axi_gmem_in_ARREADY;
  input [127:0]m_axi_gmem_in_RDATA;
  input [1:0]m_axi_gmem_in_RRESP;
  input m_axi_gmem_in_RLAST;
  input m_axi_gmem_in_RVALID;
  output m_axi_gmem_in_RREADY;
  output [63:0]m_axi_gmem_out_AWADDR;
  output [7:0]m_axi_gmem_out_AWLEN;
  output [2:0]m_axi_gmem_out_AWSIZE;
  output [1:0]m_axi_gmem_out_AWBURST;
  output [1:0]m_axi_gmem_out_AWLOCK;
  output [3:0]m_axi_gmem_out_AWREGION;
  output [3:0]m_axi_gmem_out_AWCACHE;
  output [2:0]m_axi_gmem_out_AWPROT;
  output [3:0]m_axi_gmem_out_AWQOS;
  output m_axi_gmem_out_AWVALID;
  input m_axi_gmem_out_AWREADY;
  output [127:0]m_axi_gmem_out_WDATA;
  output [15:0]m_axi_gmem_out_WSTRB;
  output m_axi_gmem_out_WLAST;
  output m_axi_gmem_out_WVALID;
  input m_axi_gmem_out_WREADY;
  input [1:0]m_axi_gmem_out_BRESP;
  input m_axi_gmem_out_BVALID;
  output m_axi_gmem_out_BREADY;
  output [63:0]m_axi_gmem_out_ARADDR;
  output [7:0]m_axi_gmem_out_ARLEN;
  output [2:0]m_axi_gmem_out_ARSIZE;
  output [1:0]m_axi_gmem_out_ARBURST;
  output [1:0]m_axi_gmem_out_ARLOCK;
  output [3:0]m_axi_gmem_out_ARREGION;
  output [3:0]m_axi_gmem_out_ARCACHE;
  output [2:0]m_axi_gmem_out_ARPROT;
  output [3:0]m_axi_gmem_out_ARQOS;
  output m_axi_gmem_out_ARVALID;
  input m_axi_gmem_out_ARREADY;
  input [127:0]m_axi_gmem_out_RDATA;
  input [1:0]m_axi_gmem_out_RRESP;
  input m_axi_gmem_out_RLAST;
  input m_axi_gmem_out_RVALID;
  output m_axi_gmem_out_RREADY;
  output [63:0]m_axi_gmem_preview_AWADDR;
  output [7:0]m_axi_gmem_preview_AWLEN;
  output [2:0]m_axi_gmem_preview_AWSIZE;
  output [1:0]m_axi_gmem_preview_AWBURST;
  output [1:0]m_axi_gmem_preview_AWLOCK;
  output [3:0]m_axi_gmem_preview_AWREGION;
  output [3:0]m_axi_gmem_preview_AWCACHE;
  output [2:0]m_axi_gmem_preview_AWPROT;
  output [3:0]m_axi_gmem_preview_AWQOS;
  output m_axi_gmem_preview_AWVALID;
  input m_axi_gmem_preview_AWREADY;
  output [127:0]m_axi_gmem_preview_WDATA;
  output [15:0]m_axi_gmem_preview_WSTRB;
  output m_axi_gmem_preview_WLAST;
  output m_axi_gmem_preview_WVALID;
  input m_axi_gmem_preview_WREADY;
  input [1:0]m_axi_gmem_preview_BRESP;
  input m_axi_gmem_preview_BVALID;
  output m_axi_gmem_preview_BREADY;
  output [63:0]m_axi_gmem_preview_ARADDR;
  output [7:0]m_axi_gmem_preview_ARLEN;
  output [2:0]m_axi_gmem_preview_ARSIZE;
  output [1:0]m_axi_gmem_preview_ARBURST;
  output [1:0]m_axi_gmem_preview_ARLOCK;
  output [3:0]m_axi_gmem_preview_ARREGION;
  output [3:0]m_axi_gmem_preview_ARCACHE;
  output [2:0]m_axi_gmem_preview_ARPROT;
  output [3:0]m_axi_gmem_preview_ARQOS;
  output m_axi_gmem_preview_ARVALID;
  input m_axi_gmem_preview_ARREADY;
  input [127:0]m_axi_gmem_preview_RDATA;
  input [1:0]m_axi_gmem_preview_RRESP;
  input m_axi_gmem_preview_RLAST;
  input m_axi_gmem_preview_RVALID;
  output m_axi_gmem_preview_RREADY;
endmodule
