// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (lin64) Build 3526262 Mon Apr 18 15:47:01 MDT 2022
// Date        : Wed Oct 14 01:46:17 2026
// Host        : ubuntu running 64-bit Ubuntu 20.04.1 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/amd/Workspace/dpu_platform2/kv260_vitis_platform/dpu_trd_system_hw_link/Hardware/dpu.build/link/vivado/vpl/prj/prj.gen/sources_1/bd/kv260_hardware_platform/ip/kv260_hardware_platform_DPUCZDX8G_1_0/kv260_hardware_platform_DPUCZDX8G_1_0_stub.v
// Design      : kv260_hardware_platform_DPUCZDX8G_1_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xck26-sfvc784-2LV-c
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "DPUCZDX8G,Vivado 2022.1" *)
module kv260_hardware_platform_DPUCZDX8G_1_0(M_AXI_GP0_araddr, M_AXI_GP0_arburst, 
  M_AXI_GP0_arcache, M_AXI_GP0_arlen, M_AXI_GP0_arlock, M_AXI_GP0_arprot, M_AXI_GP0_arqos, 
  M_AXI_GP0_arready, M_AXI_GP0_arsize, M_AXI_GP0_arvalid, M_AXI_GP0_awaddr, 
  M_AXI_GP0_awburst, M_AXI_GP0_awcache, M_AXI_GP0_awlen, M_AXI_GP0_awlock, 
  M_AXI_GP0_awprot, M_AXI_GP0_awqos, M_AXI_GP0_awready, M_AXI_GP0_awsize, 
  M_AXI_GP0_awvalid, M_AXI_GP0_bready, M_AXI_GP0_bresp, M_AXI_GP0_bvalid, M_AXI_GP0_rdata, 
  M_AXI_GP0_rlast, M_AXI_GP0_rready, M_AXI_GP0_rresp, M_AXI_GP0_rvalid, M_AXI_GP0_wdata, 
  M_AXI_GP0_wlast, M_AXI_GP0_wready, M_AXI_GP0_wstrb, M_AXI_GP0_wvalid, M_AXI_GP0_aruser, 
  M_AXI_GP0_awuser, M_AXI_HP0_araddr, M_AXI_HP0_arburst, M_AXI_HP0_arcache, 
  M_AXI_HP0_arlen, M_AXI_HP0_arlock, M_AXI_HP0_arprot, M_AXI_HP0_arqos, M_AXI_HP0_arready, 
  M_AXI_HP0_arsize, M_AXI_HP0_arvalid, M_AXI_HP0_awaddr, M_AXI_HP0_awburst, 
  M_AXI_HP0_awcache, M_AXI_HP0_awlen, M_AXI_HP0_awlock, M_AXI_HP0_awprot, M_AXI_HP0_awqos, 
  M_AXI_HP0_awready, M_AXI_HP0_awsize, M_AXI_HP0_awvalid, M_AXI_HP0_bready, 
  M_AXI_HP0_bresp, M_AXI_HP0_bvalid, M_AXI_HP0_rdata, M_AXI_HP0_rlast, M_AXI_HP0_rready, 
  M_AXI_HP0_rresp, M_AXI_HP0_rvalid, M_AXI_HP0_wdata, M_AXI_HP0_wlast, M_AXI_HP0_wready, 
  M_AXI_HP0_wstrb, M_AXI_HP0_wvalid, M_AXI_HP0_aruser, M_AXI_HP0_awuser, M_AXI_HP2_araddr, 
  M_AXI_HP2_arburst, M_AXI_HP2_arcache, M_AXI_HP2_arlen, M_AXI_HP2_arlock, 
  M_AXI_HP2_arprot, M_AXI_HP2_arqos, M_AXI_HP2_arready, M_AXI_HP2_arsize, 
  M_AXI_HP2_arvalid, M_AXI_HP2_awaddr, M_AXI_HP2_awburst, M_AXI_HP2_awcache, 
  M_AXI_HP2_awlen, M_AXI_HP2_awlock, M_AXI_HP2_awprot, M_AXI_HP2_awqos, M_AXI_HP2_awready, 
  M_AXI_HP2_awsize, M_AXI_HP2_awvalid, M_AXI_HP2_bready, M_AXI_HP2_bresp, M_AXI_HP2_bvalid, 
  M_AXI_HP2_rdata, M_AXI_HP2_rlast, M_AXI_HP2_rready, M_AXI_HP2_rresp, M_AXI_HP2_rvalid, 
  M_AXI_HP2_wdata, M_AXI_HP2_wlast, M_AXI_HP2_wready, M_AXI_HP2_wstrb, M_AXI_HP2_wvalid, 
  M_AXI_HP2_aruser, M_AXI_HP2_awuser, S_AXI_CONTROL_araddr, S_AXI_CONTROL_arready, 
  S_AXI_CONTROL_arvalid, S_AXI_CONTROL_awaddr, S_AXI_CONTROL_awready, 
  S_AXI_CONTROL_awvalid, S_AXI_CONTROL_bready, S_AXI_CONTROL_bresp, S_AXI_CONTROL_bvalid, 
  S_AXI_CONTROL_rdata, S_AXI_CONTROL_rready, S_AXI_CONTROL_rresp, S_AXI_CONTROL_rvalid, 
  S_AXI_CONTROL_wdata, S_AXI_CONTROL_wready, S_AXI_CONTROL_wstrb, S_AXI_CONTROL_wvalid, 
  aclk, ap_clk_2, ap_rst_n_2, aresetn, interrupt)
/* synthesis syn_black_box black_box_pad_pin="M_AXI_GP0_araddr[39:0],M_AXI_GP0_arburst[1:0],M_AXI_GP0_arcache[3:0],M_AXI_GP0_arlen[7:0],M_AXI_GP0_arlock[0:0],M_AXI_GP0_arprot[2:0],M_AXI_GP0_arqos[3:0],M_AXI_GP0_arready,M_AXI_GP0_arsize[2:0],M_AXI_GP0_arvalid,M_AXI_GP0_awaddr[39:0],M_AXI_GP0_awburst[1:0],M_AXI_GP0_awcache[3:0],M_AXI_GP0_awlen[7:0],M_AXI_GP0_awlock[0:0],M_AXI_GP0_awprot[2:0],M_AXI_GP0_awqos[3:0],M_AXI_GP0_awready,M_AXI_GP0_awsize[2:0],M_AXI_GP0_awvalid,M_AXI_GP0_bready,M_AXI_GP0_bresp[1:0],M_AXI_GP0_bvalid,M_AXI_GP0_rdata[31:0],M_AXI_GP0_rlast,M_AXI_GP0_rready,M_AXI_GP0_rresp[1:0],M_AXI_GP0_rvalid,M_AXI_GP0_wdata[31:0],M_AXI_GP0_wlast,M_AXI_GP0_wready,M_AXI_GP0_wstrb[3:0],M_AXI_GP0_wvalid,M_AXI_GP0_aruser[0:0],M_AXI_GP0_awuser[0:0],M_AXI_HP0_araddr[39:0],M_AXI_HP0_arburst[1:0],M_AXI_HP0_arcache[3:0],M_AXI_HP0_arlen[7:0],M_AXI_HP0_arlock[0:0],M_AXI_HP0_arprot[2:0],M_AXI_HP0_arqos[3:0],M_AXI_HP0_arready,M_AXI_HP0_arsize[2:0],M_AXI_HP0_arvalid,M_AXI_HP0_awaddr[39:0],M_AXI_HP0_awburst[1:0],M_AXI_HP0_awcache[3:0],M_AXI_HP0_awlen[7:0],M_AXI_HP0_awlock[0:0],M_AXI_HP0_awprot[2:0],M_AXI_HP0_awqos[3:0],M_AXI_HP0_awready,M_AXI_HP0_awsize[2:0],M_AXI_HP0_awvalid,M_AXI_HP0_bready,M_AXI_HP0_bresp[1:0],M_AXI_HP0_bvalid,M_AXI_HP0_rdata[127:0],M_AXI_HP0_rlast,M_AXI_HP0_rready,M_AXI_HP0_rresp[1:0],M_AXI_HP0_rvalid,M_AXI_HP0_wdata[127:0],M_AXI_HP0_wlast,M_AXI_HP0_wready,M_AXI_HP0_wstrb[15:0],M_AXI_HP0_wvalid,M_AXI_HP0_aruser[0:0],M_AXI_HP0_awuser[0:0],M_AXI_HP2_araddr[39:0],M_AXI_HP2_arburst[1:0],M_AXI_HP2_arcache[3:0],M_AXI_HP2_arlen[7:0],M_AXI_HP2_arlock[0:0],M_AXI_HP2_arprot[2:0],M_AXI_HP2_arqos[3:0],M_AXI_HP2_arready,M_AXI_HP2_arsize[2:0],M_AXI_HP2_arvalid,M_AXI_HP2_awaddr[39:0],M_AXI_HP2_awburst[1:0],M_AXI_HP2_awcache[3:0],M_AXI_HP2_awlen[7:0],M_AXI_HP2_awlock[0:0],M_AXI_HP2_awprot[2:0],M_AXI_HP2_awqos[3:0],M_AXI_HP2_awready,M_AXI_HP2_awsize[2:0],M_AXI_HP2_awvalid,M_AXI_HP2_bready,M_AXI_HP2_bresp[1:0],M_AXI_HP2_bvalid,M_AXI_HP2_rdata[127:0],M_AXI_HP2_rlast,M_AXI_HP2_rready,M_AXI_HP2_rresp[1:0],M_AXI_HP2_rvalid,M_AXI_HP2_wdata[127:0],M_AXI_HP2_wlast,M_AXI_HP2_wready,M_AXI_HP2_wstrb[15:0],M_AXI_HP2_wvalid,M_AXI_HP2_aruser[0:0],M_AXI_HP2_awuser[0:0],S_AXI_CONTROL_araddr[11:0],S_AXI_CONTROL_arready,S_AXI_CONTROL_arvalid,S_AXI_CONTROL_awaddr[11:0],S_AXI_CONTROL_awready,S_AXI_CONTROL_awvalid,S_AXI_CONTROL_bready,S_AXI_CONTROL_bresp[1:0],S_AXI_CONTROL_bvalid,S_AXI_CONTROL_rdata[31:0],S_AXI_CONTROL_rready,S_AXI_CONTROL_rresp[1:0],S_AXI_CONTROL_rvalid,S_AXI_CONTROL_wdata[31:0],S_AXI_CONTROL_wready,S_AXI_CONTROL_wstrb[3:0],S_AXI_CONTROL_wvalid,aclk,ap_clk_2,ap_rst_n_2,aresetn,interrupt" */;
  output [39:0]M_AXI_GP0_araddr;
  output [1:0]M_AXI_GP0_arburst;
  output [3:0]M_AXI_GP0_arcache;
  output [7:0]M_AXI_GP0_arlen;
  output [0:0]M_AXI_GP0_arlock;
  output [2:0]M_AXI_GP0_arprot;
  output [3:0]M_AXI_GP0_arqos;
  input M_AXI_GP0_arready;
  output [2:0]M_AXI_GP0_arsize;
  output M_AXI_GP0_arvalid;
  output [39:0]M_AXI_GP0_awaddr;
  output [1:0]M_AXI_GP0_awburst;
  output [3:0]M_AXI_GP0_awcache;
  output [7:0]M_AXI_GP0_awlen;
  output [0:0]M_AXI_GP0_awlock;
  output [2:0]M_AXI_GP0_awprot;
  output [3:0]M_AXI_GP0_awqos;
  input M_AXI_GP0_awready;
  output [2:0]M_AXI_GP0_awsize;
  output M_AXI_GP0_awvalid;
  output M_AXI_GP0_bready;
  input [1:0]M_AXI_GP0_bresp;
  input M_AXI_GP0_bvalid;
  input [31:0]M_AXI_GP0_rdata;
  input M_AXI_GP0_rlast;
  output M_AXI_GP0_rready;
  input [1:0]M_AXI_GP0_rresp;
  input M_AXI_GP0_rvalid;
  output [31:0]M_AXI_GP0_wdata;
  output M_AXI_GP0_wlast;
  input M_AXI_GP0_wready;
  output [3:0]M_AXI_GP0_wstrb;
  output M_AXI_GP0_wvalid;
  output [0:0]M_AXI_GP0_aruser;
  output [0:0]M_AXI_GP0_awuser;
  output [39:0]M_AXI_HP0_araddr;
  output [1:0]M_AXI_HP0_arburst;
  output [3:0]M_AXI_HP0_arcache;
  output [7:0]M_AXI_HP0_arlen;
  output [0:0]M_AXI_HP0_arlock;
  output [2:0]M_AXI_HP0_arprot;
  output [3:0]M_AXI_HP0_arqos;
  input M_AXI_HP0_arready;
  output [2:0]M_AXI_HP0_arsize;
  output M_AXI_HP0_arvalid;
  output [39:0]M_AXI_HP0_awaddr;
  output [1:0]M_AXI_HP0_awburst;
  output [3:0]M_AXI_HP0_awcache;
  output [7:0]M_AXI_HP0_awlen;
  output [0:0]M_AXI_HP0_awlock;
  output [2:0]M_AXI_HP0_awprot;
  output [3:0]M_AXI_HP0_awqos;
  input M_AXI_HP0_awready;
  output [2:0]M_AXI_HP0_awsize;
  output M_AXI_HP0_awvalid;
  output M_AXI_HP0_bready;
  input [1:0]M_AXI_HP0_bresp;
  input M_AXI_HP0_bvalid;
  input [127:0]M_AXI_HP0_rdata;
  input M_AXI_HP0_rlast;
  output M_AXI_HP0_rready;
  input [1:0]M_AXI_HP0_rresp;
  input M_AXI_HP0_rvalid;
  output [127:0]M_AXI_HP0_wdata;
  output M_AXI_HP0_wlast;
  input M_AXI_HP0_wready;
  output [15:0]M_AXI_HP0_wstrb;
  output M_AXI_HP0_wvalid;
  output [0:0]M_AXI_HP0_aruser;
  output [0:0]M_AXI_HP0_awuser;
  output [39:0]M_AXI_HP2_araddr;
  output [1:0]M_AXI_HP2_arburst;
  output [3:0]M_AXI_HP2_arcache;
  output [7:0]M_AXI_HP2_arlen;
  output [0:0]M_AXI_HP2_arlock;
  output [2:0]M_AXI_HP2_arprot;
  output [3:0]M_AXI_HP2_arqos;
  input M_AXI_HP2_arready;
  output [2:0]M_AXI_HP2_arsize;
  output M_AXI_HP2_arvalid;
  output [39:0]M_AXI_HP2_awaddr;
  output [1:0]M_AXI_HP2_awburst;
  output [3:0]M_AXI_HP2_awcache;
  output [7:0]M_AXI_HP2_awlen;
  output [0:0]M_AXI_HP2_awlock;
  output [2:0]M_AXI_HP2_awprot;
  output [3:0]M_AXI_HP2_awqos;
  input M_AXI_HP2_awready;
  output [2:0]M_AXI_HP2_awsize;
  output M_AXI_HP2_awvalid;
  output M_AXI_HP2_bready;
  input [1:0]M_AXI_HP2_bresp;
  input M_AXI_HP2_bvalid;
  input [127:0]M_AXI_HP2_rdata;
  input M_AXI_HP2_rlast;
  output M_AXI_HP2_rready;
  input [1:0]M_AXI_HP2_rresp;
  input M_AXI_HP2_rvalid;
  output [127:0]M_AXI_HP2_wdata;
  output M_AXI_HP2_wlast;
  input M_AXI_HP2_wready;
  output [15:0]M_AXI_HP2_wstrb;
  output M_AXI_HP2_wvalid;
  output [0:0]M_AXI_HP2_aruser;
  output [0:0]M_AXI_HP2_awuser;
  input [11:0]S_AXI_CONTROL_araddr;
  output S_AXI_CONTROL_arready;
  input S_AXI_CONTROL_arvalid;
  input [11:0]S_AXI_CONTROL_awaddr;
  output S_AXI_CONTROL_awready;
  input S_AXI_CONTROL_awvalid;
  input S_AXI_CONTROL_bready;
  output [1:0]S_AXI_CONTROL_bresp;
  output S_AXI_CONTROL_bvalid;
  output [31:0]S_AXI_CONTROL_rdata;
  input S_AXI_CONTROL_rready;
  output [1:0]S_AXI_CONTROL_rresp;
  output S_AXI_CONTROL_rvalid;
  input [31:0]S_AXI_CONTROL_wdata;
  output S_AXI_CONTROL_wready;
  input [3:0]S_AXI_CONTROL_wstrb;
  input S_AXI_CONTROL_wvalid;
  input aclk;
  input ap_clk_2;
  input ap_rst_n_2;
  input aresetn;
  output interrupt;
endmodule
