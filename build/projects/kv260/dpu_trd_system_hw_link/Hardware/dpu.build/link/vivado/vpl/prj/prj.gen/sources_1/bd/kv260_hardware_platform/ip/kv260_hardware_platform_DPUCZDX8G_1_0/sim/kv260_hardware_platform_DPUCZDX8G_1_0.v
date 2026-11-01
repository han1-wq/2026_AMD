// (c) Copyright 1995-2026 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: xilinx.com:RTLKernel:DPUCZDX8G:1.0
// IP Revision: 0

`timescale 1ns/1ps

(* IP_DEFINITION_SOURCE = "package_project" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module kv260_hardware_platform_DPUCZDX8G_1_0 (
  M_AXI_GP0_araddr,
  M_AXI_GP0_arburst,
  M_AXI_GP0_arcache,
  M_AXI_GP0_arlen,
  M_AXI_GP0_arlock,
  M_AXI_GP0_arprot,
  M_AXI_GP0_arqos,
  M_AXI_GP0_arready,
  M_AXI_GP0_arsize,
  M_AXI_GP0_arvalid,
  M_AXI_GP0_awaddr,
  M_AXI_GP0_awburst,
  M_AXI_GP0_awcache,
  M_AXI_GP0_awlen,
  M_AXI_GP0_awlock,
  M_AXI_GP0_awprot,
  M_AXI_GP0_awqos,
  M_AXI_GP0_awready,
  M_AXI_GP0_awsize,
  M_AXI_GP0_awvalid,
  M_AXI_GP0_bready,
  M_AXI_GP0_bresp,
  M_AXI_GP0_bvalid,
  M_AXI_GP0_rdata,
  M_AXI_GP0_rlast,
  M_AXI_GP0_rready,
  M_AXI_GP0_rresp,
  M_AXI_GP0_rvalid,
  M_AXI_GP0_wdata,
  M_AXI_GP0_wlast,
  M_AXI_GP0_wready,
  M_AXI_GP0_wstrb,
  M_AXI_GP0_wvalid,
  M_AXI_GP0_aruser,
  M_AXI_GP0_awuser,
  M_AXI_HP0_araddr,
  M_AXI_HP0_arburst,
  M_AXI_HP0_arcache,
  M_AXI_HP0_arlen,
  M_AXI_HP0_arlock,
  M_AXI_HP0_arprot,
  M_AXI_HP0_arqos,
  M_AXI_HP0_arready,
  M_AXI_HP0_arsize,
  M_AXI_HP0_arvalid,
  M_AXI_HP0_awaddr,
  M_AXI_HP0_awburst,
  M_AXI_HP0_awcache,
  M_AXI_HP0_awlen,
  M_AXI_HP0_awlock,
  M_AXI_HP0_awprot,
  M_AXI_HP0_awqos,
  M_AXI_HP0_awready,
  M_AXI_HP0_awsize,
  M_AXI_HP0_awvalid,
  M_AXI_HP0_bready,
  M_AXI_HP0_bresp,
  M_AXI_HP0_bvalid,
  M_AXI_HP0_rdata,
  M_AXI_HP0_rlast,
  M_AXI_HP0_rready,
  M_AXI_HP0_rresp,
  M_AXI_HP0_rvalid,
  M_AXI_HP0_wdata,
  M_AXI_HP0_wlast,
  M_AXI_HP0_wready,
  M_AXI_HP0_wstrb,
  M_AXI_HP0_wvalid,
  M_AXI_HP0_aruser,
  M_AXI_HP0_awuser,
  M_AXI_HP2_araddr,
  M_AXI_HP2_arburst,
  M_AXI_HP2_arcache,
  M_AXI_HP2_arlen,
  M_AXI_HP2_arlock,
  M_AXI_HP2_arprot,
  M_AXI_HP2_arqos,
  M_AXI_HP2_arready,
  M_AXI_HP2_arsize,
  M_AXI_HP2_arvalid,
  M_AXI_HP2_awaddr,
  M_AXI_HP2_awburst,
  M_AXI_HP2_awcache,
  M_AXI_HP2_awlen,
  M_AXI_HP2_awlock,
  M_AXI_HP2_awprot,
  M_AXI_HP2_awqos,
  M_AXI_HP2_awready,
  M_AXI_HP2_awsize,
  M_AXI_HP2_awvalid,
  M_AXI_HP2_bready,
  M_AXI_HP2_bresp,
  M_AXI_HP2_bvalid,
  M_AXI_HP2_rdata,
  M_AXI_HP2_rlast,
  M_AXI_HP2_rready,
  M_AXI_HP2_rresp,
  M_AXI_HP2_rvalid,
  M_AXI_HP2_wdata,
  M_AXI_HP2_wlast,
  M_AXI_HP2_wready,
  M_AXI_HP2_wstrb,
  M_AXI_HP2_wvalid,
  M_AXI_HP2_aruser,
  M_AXI_HP2_awuser,
  S_AXI_CONTROL_araddr,
  S_AXI_CONTROL_arready,
  S_AXI_CONTROL_arvalid,
  S_AXI_CONTROL_awaddr,
  S_AXI_CONTROL_awready,
  S_AXI_CONTROL_awvalid,
  S_AXI_CONTROL_bready,
  S_AXI_CONTROL_bresp,
  S_AXI_CONTROL_bvalid,
  S_AXI_CONTROL_rdata,
  S_AXI_CONTROL_rready,
  S_AXI_CONTROL_rresp,
  S_AXI_CONTROL_rvalid,
  S_AXI_CONTROL_wdata,
  S_AXI_CONTROL_wready,
  S_AXI_CONTROL_wstrb,
  S_AXI_CONTROL_wvalid,
  aclk,
  ap_clk_2,
  ap_rst_n_2,
  aresetn,
  interrupt
);

(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 ARADDR" *)
output wire [39 : 0] M_AXI_GP0_araddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 ARBURST" *)
output wire [1 : 0] M_AXI_GP0_arburst;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 ARCACHE" *)
output wire [3 : 0] M_AXI_GP0_arcache;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 ARLEN" *)
output wire [7 : 0] M_AXI_GP0_arlen;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 ARLOCK" *)
output wire [0 : 0] M_AXI_GP0_arlock;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 ARPROT" *)
output wire [2 : 0] M_AXI_GP0_arprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 ARQOS" *)
output wire [3 : 0] M_AXI_GP0_arqos;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 ARREADY" *)
input wire M_AXI_GP0_arready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 ARSIZE" *)
output wire [2 : 0] M_AXI_GP0_arsize;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 ARVALID" *)
output wire M_AXI_GP0_arvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 AWADDR" *)
output wire [39 : 0] M_AXI_GP0_awaddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 AWBURST" *)
output wire [1 : 0] M_AXI_GP0_awburst;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 AWCACHE" *)
output wire [3 : 0] M_AXI_GP0_awcache;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 AWLEN" *)
output wire [7 : 0] M_AXI_GP0_awlen;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 AWLOCK" *)
output wire [0 : 0] M_AXI_GP0_awlock;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 AWPROT" *)
output wire [2 : 0] M_AXI_GP0_awprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 AWQOS" *)
output wire [3 : 0] M_AXI_GP0_awqos;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 AWREADY" *)
input wire M_AXI_GP0_awready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 AWSIZE" *)
output wire [2 : 0] M_AXI_GP0_awsize;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 AWVALID" *)
output wire M_AXI_GP0_awvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 BREADY" *)
output wire M_AXI_GP0_bready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 BRESP" *)
input wire [1 : 0] M_AXI_GP0_bresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 BVALID" *)
input wire M_AXI_GP0_bvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 RDATA" *)
input wire [31 : 0] M_AXI_GP0_rdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 RLAST" *)
input wire M_AXI_GP0_rlast;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 RREADY" *)
output wire M_AXI_GP0_rready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 RRESP" *)
input wire [1 : 0] M_AXI_GP0_rresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 RVALID" *)
input wire M_AXI_GP0_rvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 WDATA" *)
output wire [31 : 0] M_AXI_GP0_wdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 WLAST" *)
output wire M_AXI_GP0_wlast;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 WREADY" *)
input wire M_AXI_GP0_wready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 WSTRB" *)
output wire [3 : 0] M_AXI_GP0_wstrb;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 WVALID" *)
output wire M_AXI_GP0_wvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 ARUSER" *)
output wire [0 : 0] M_AXI_GP0_aruser;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_AXI_GP0, DATA_WIDTH 32, PROTOCOL AXI4, FREQ_HZ 299997000, ID_WIDTH 0, ADDR_WIDTH 40, AWUSER_WIDTH 1, ARUSER_WIDTH 1, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 1, HAS_LOCK 1, HAS_PROT 1, HAS_CACHE 1, HAS_QOS 1, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 1, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 256, PHASE 0.0, CLK_DOMAIN kv260_hardware_platform_clk_wiz_0_1_clk_out1, NUM_READ_THR\
EADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 AWUSER" *)
output wire [0 : 0] M_AXI_GP0_awuser;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 ARADDR" *)
output wire [39 : 0] M_AXI_HP0_araddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 ARBURST" *)
output wire [1 : 0] M_AXI_HP0_arburst;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 ARCACHE" *)
output wire [3 : 0] M_AXI_HP0_arcache;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 ARLEN" *)
output wire [7 : 0] M_AXI_HP0_arlen;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 ARLOCK" *)
output wire [0 : 0] M_AXI_HP0_arlock;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 ARPROT" *)
output wire [2 : 0] M_AXI_HP0_arprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 ARQOS" *)
output wire [3 : 0] M_AXI_HP0_arqos;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 ARREADY" *)
input wire M_AXI_HP0_arready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 ARSIZE" *)
output wire [2 : 0] M_AXI_HP0_arsize;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 ARVALID" *)
output wire M_AXI_HP0_arvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 AWADDR" *)
output wire [39 : 0] M_AXI_HP0_awaddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 AWBURST" *)
output wire [1 : 0] M_AXI_HP0_awburst;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 AWCACHE" *)
output wire [3 : 0] M_AXI_HP0_awcache;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 AWLEN" *)
output wire [7 : 0] M_AXI_HP0_awlen;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 AWLOCK" *)
output wire [0 : 0] M_AXI_HP0_awlock;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 AWPROT" *)
output wire [2 : 0] M_AXI_HP0_awprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 AWQOS" *)
output wire [3 : 0] M_AXI_HP0_awqos;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 AWREADY" *)
input wire M_AXI_HP0_awready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 AWSIZE" *)
output wire [2 : 0] M_AXI_HP0_awsize;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 AWVALID" *)
output wire M_AXI_HP0_awvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 BREADY" *)
output wire M_AXI_HP0_bready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 BRESP" *)
input wire [1 : 0] M_AXI_HP0_bresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 BVALID" *)
input wire M_AXI_HP0_bvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 RDATA" *)
input wire [127 : 0] M_AXI_HP0_rdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 RLAST" *)
input wire M_AXI_HP0_rlast;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 RREADY" *)
output wire M_AXI_HP0_rready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 RRESP" *)
input wire [1 : 0] M_AXI_HP0_rresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 RVALID" *)
input wire M_AXI_HP0_rvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 WDATA" *)
output wire [127 : 0] M_AXI_HP0_wdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 WLAST" *)
output wire M_AXI_HP0_wlast;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 WREADY" *)
input wire M_AXI_HP0_wready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 WSTRB" *)
output wire [15 : 0] M_AXI_HP0_wstrb;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 WVALID" *)
output wire M_AXI_HP0_wvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 ARUSER" *)
output wire [0 : 0] M_AXI_HP0_aruser;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_AXI_HP0, DATA_WIDTH 128, PROTOCOL AXI4, FREQ_HZ 299997000, ID_WIDTH 0, ADDR_WIDTH 40, AWUSER_WIDTH 1, ARUSER_WIDTH 1, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 1, HAS_LOCK 1, HAS_PROT 1, HAS_CACHE 1, HAS_QOS 1, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 1, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 256, PHASE 0.0, CLK_DOMAIN kv260_hardware_platform_clk_wiz_0_1_clk_out1, NUM_READ_TH\
READS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 AWUSER" *)
output wire [0 : 0] M_AXI_HP0_awuser;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 ARADDR" *)
output wire [39 : 0] M_AXI_HP2_araddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 ARBURST" *)
output wire [1 : 0] M_AXI_HP2_arburst;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 ARCACHE" *)
output wire [3 : 0] M_AXI_HP2_arcache;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 ARLEN" *)
output wire [7 : 0] M_AXI_HP2_arlen;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 ARLOCK" *)
output wire [0 : 0] M_AXI_HP2_arlock;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 ARPROT" *)
output wire [2 : 0] M_AXI_HP2_arprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 ARQOS" *)
output wire [3 : 0] M_AXI_HP2_arqos;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 ARREADY" *)
input wire M_AXI_HP2_arready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 ARSIZE" *)
output wire [2 : 0] M_AXI_HP2_arsize;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 ARVALID" *)
output wire M_AXI_HP2_arvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 AWADDR" *)
output wire [39 : 0] M_AXI_HP2_awaddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 AWBURST" *)
output wire [1 : 0] M_AXI_HP2_awburst;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 AWCACHE" *)
output wire [3 : 0] M_AXI_HP2_awcache;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 AWLEN" *)
output wire [7 : 0] M_AXI_HP2_awlen;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 AWLOCK" *)
output wire [0 : 0] M_AXI_HP2_awlock;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 AWPROT" *)
output wire [2 : 0] M_AXI_HP2_awprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 AWQOS" *)
output wire [3 : 0] M_AXI_HP2_awqos;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 AWREADY" *)
input wire M_AXI_HP2_awready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 AWSIZE" *)
output wire [2 : 0] M_AXI_HP2_awsize;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 AWVALID" *)
output wire M_AXI_HP2_awvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 BREADY" *)
output wire M_AXI_HP2_bready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 BRESP" *)
input wire [1 : 0] M_AXI_HP2_bresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 BVALID" *)
input wire M_AXI_HP2_bvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 RDATA" *)
input wire [127 : 0] M_AXI_HP2_rdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 RLAST" *)
input wire M_AXI_HP2_rlast;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 RREADY" *)
output wire M_AXI_HP2_rready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 RRESP" *)
input wire [1 : 0] M_AXI_HP2_rresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 RVALID" *)
input wire M_AXI_HP2_rvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 WDATA" *)
output wire [127 : 0] M_AXI_HP2_wdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 WLAST" *)
output wire M_AXI_HP2_wlast;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 WREADY" *)
input wire M_AXI_HP2_wready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 WSTRB" *)
output wire [15 : 0] M_AXI_HP2_wstrb;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 WVALID" *)
output wire M_AXI_HP2_wvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 ARUSER" *)
output wire [0 : 0] M_AXI_HP2_aruser;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_AXI_HP2, DATA_WIDTH 128, PROTOCOL AXI4, FREQ_HZ 299997000, ID_WIDTH 0, ADDR_WIDTH 40, AWUSER_WIDTH 1, ARUSER_WIDTH 1, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 1, HAS_LOCK 1, HAS_PROT 1, HAS_CACHE 1, HAS_QOS 1, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 1, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 256, PHASE 0.0, CLK_DOMAIN kv260_hardware_platform_clk_wiz_0_1_clk_out1, NUM_READ_TH\
READS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 AWUSER" *)
output wire [0 : 0] M_AXI_HP2_awuser;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL ARADDR" *)
input wire [11 : 0] S_AXI_CONTROL_araddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL ARREADY" *)
output wire S_AXI_CONTROL_arready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL ARVALID" *)
input wire S_AXI_CONTROL_arvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL AWADDR" *)
input wire [11 : 0] S_AXI_CONTROL_awaddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL AWREADY" *)
output wire S_AXI_CONTROL_awready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL AWVALID" *)
input wire S_AXI_CONTROL_awvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL BREADY" *)
input wire S_AXI_CONTROL_bready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL BRESP" *)
output wire [1 : 0] S_AXI_CONTROL_bresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL BVALID" *)
output wire S_AXI_CONTROL_bvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL RDATA" *)
output wire [31 : 0] S_AXI_CONTROL_rdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL RREADY" *)
input wire S_AXI_CONTROL_rready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL RRESP" *)
output wire [1 : 0] S_AXI_CONTROL_rresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL RVALID" *)
output wire S_AXI_CONTROL_rvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL WDATA" *)
input wire [31 : 0] S_AXI_CONTROL_wdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL WREADY" *)
output wire S_AXI_CONTROL_wready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL WSTRB" *)
input wire [3 : 0] S_AXI_CONTROL_wstrb;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S_AXI_CONTROL, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 299997000, ID_WIDTH 0, ADDR_WIDTH 12, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN kv260_hardware_platform_clk_wiz_0_1_clk_out1, NUM_RE\
AD_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL WVALID" *)
input wire S_AXI_CONTROL_wvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aclk, ASSOCIATED_BUSIF M_AXI_GP0:M_AXI_HP0:M_AXI_HP2:S_AXI_CONTROL, ASSOCIATED_RESET aresetn, FREQ_HZ 299997000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN kv260_hardware_platform_clk_wiz_0_1_clk_out1, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 aclk CLK" *)
input wire aclk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME ap_clk_2, ASSOCIATED_RESET ap_rst_n_2, FREQ_HZ 599994000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN kv260_hardware_platform_clk_wiz_0_1_clk_out1, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 ap_clk_2 CLK" *)
input wire ap_clk_2;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME ap_rst_n_2, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 ap_rst_n_2 RST" *)
input wire ap_rst_n_2;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 aresetn RST" *)
input wire aresetn;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME interrupt, SENSITIVITY LEVEL_HIGH, PortWidth 1" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 interrupt INTERRUPT" *)
output wire interrupt;

(* SDX_KERNEL = "true" *)
(* SDX_KERNEL_TYPE = "rtl" *)
(* SDX_KERNEL_SIM_INST = "" *)
  DPUCZDX8G #(
    .DSP48_VER("DSP48E2"),
    .S_AXI_FREQ_MHZ(300),
    .M_AXI_FREQ_MHZ(300),
    .AWRLEN_BW(8),
    .AWRUSER_BW(1),
    .AWRLOCK_BW(1),
    .GP_ID_BW(6),
    .HP0_ID_BW(6),
    .HP1_ID_BW(6),
    .HP2_ID_BW(6),
    .HP3_ID_BW(6),
    .HP_DATA_BW(128),
    .SYS_IP_VER(32'H00000040),
    .SYS_IP_TYPE(32'H00000001),
    .SIZE_REGMAP_SIZE(32'H0000006B),
    .SYS_REGMAP_VER(2),
    .TIME_YEAR(22),
    .TIME_MONTH(5),
    .TIME_DAY(14),
    .TIME_HOUR(14),
    .TIME_QUARTER(2),
    .GIT_COMMIT_ID(28'H4772D51),
    .GIT_COMMIT_TIME(2022051323),
    .VER_IP_REV(32'H00000000),
    .VER_TARGET(12'H141),
    .ARCH_HP_BW(3),
    .ARCH_DATA_BW(1),
    .ARCH_IMG_BKGRP(2),
    .ARCH_PP(8),
    .ARCH_ICP(14),
    .ARCH_OCP(14),
    .RAM_DEPTH_MEAN(1),
    .RAM_DEPTH_BIAS(3),
    .RAM_DEPTH_WGT(3),
    .RAM_DEPTH_IMG(3),
    .UBANK_IMG_N(4),
    .UBANK_WGT_N(15),
    .UBANK_BIAS(1),
    .DBANK_IMG_N(0),
    .DBANK_WGT_N(0),
    .DBANK_BIAS(0),
    .LOAD_AUGM(1),
    .LOAD_IMG_MEAN(0),
    .LOAD_PARALLEL(2),
    .CONV_LEAKYRELU(1),
    .CONV_RELU6(1),
    .CONV_WR_PARALLEL(1),
    .CONV_DSP_CASC_MAX(4),
    .CONV_DSP_ACCU_ENA(1),
    .SAVE_PARALLEL(2),
    .ELEW_PARALLEL(4),
    .ALU_LEAKYRELU(0),
    .ALU_PARALLEL(4),
    .MISC_WR_PARALLEL(1),
    .DNNDK_PRINT("xrt test")
  ) inst (
    .M_AXI_GP0_araddr(M_AXI_GP0_araddr),
    .M_AXI_GP0_arburst(M_AXI_GP0_arburst),
    .M_AXI_GP0_arcache(M_AXI_GP0_arcache),
    .M_AXI_GP0_arlen(M_AXI_GP0_arlen),
    .M_AXI_GP0_arlock(M_AXI_GP0_arlock),
    .M_AXI_GP0_arprot(M_AXI_GP0_arprot),
    .M_AXI_GP0_arqos(M_AXI_GP0_arqos),
    .M_AXI_GP0_arready(M_AXI_GP0_arready),
    .M_AXI_GP0_arsize(M_AXI_GP0_arsize),
    .M_AXI_GP0_arvalid(M_AXI_GP0_arvalid),
    .M_AXI_GP0_awaddr(M_AXI_GP0_awaddr),
    .M_AXI_GP0_awburst(M_AXI_GP0_awburst),
    .M_AXI_GP0_awcache(M_AXI_GP0_awcache),
    .M_AXI_GP0_awlen(M_AXI_GP0_awlen),
    .M_AXI_GP0_awlock(M_AXI_GP0_awlock),
    .M_AXI_GP0_awprot(M_AXI_GP0_awprot),
    .M_AXI_GP0_awqos(M_AXI_GP0_awqos),
    .M_AXI_GP0_awready(M_AXI_GP0_awready),
    .M_AXI_GP0_awsize(M_AXI_GP0_awsize),
    .M_AXI_GP0_awvalid(M_AXI_GP0_awvalid),
    .M_AXI_GP0_bready(M_AXI_GP0_bready),
    .M_AXI_GP0_bresp(M_AXI_GP0_bresp),
    .M_AXI_GP0_bvalid(M_AXI_GP0_bvalid),
    .M_AXI_GP0_rdata(M_AXI_GP0_rdata),
    .M_AXI_GP0_rlast(M_AXI_GP0_rlast),
    .M_AXI_GP0_rready(M_AXI_GP0_rready),
    .M_AXI_GP0_rresp(M_AXI_GP0_rresp),
    .M_AXI_GP0_rvalid(M_AXI_GP0_rvalid),
    .M_AXI_GP0_wdata(M_AXI_GP0_wdata),
    .M_AXI_GP0_wlast(M_AXI_GP0_wlast),
    .M_AXI_GP0_wready(M_AXI_GP0_wready),
    .M_AXI_GP0_wstrb(M_AXI_GP0_wstrb),
    .M_AXI_GP0_wvalid(M_AXI_GP0_wvalid),
    .M_AXI_GP0_aruser(M_AXI_GP0_aruser),
    .M_AXI_GP0_awuser(M_AXI_GP0_awuser),
    .M_AXI_HP0_araddr(M_AXI_HP0_araddr),
    .M_AXI_HP0_arburst(M_AXI_HP0_arburst),
    .M_AXI_HP0_arcache(M_AXI_HP0_arcache),
    .M_AXI_HP0_arlen(M_AXI_HP0_arlen),
    .M_AXI_HP0_arlock(M_AXI_HP0_arlock),
    .M_AXI_HP0_arprot(M_AXI_HP0_arprot),
    .M_AXI_HP0_arqos(M_AXI_HP0_arqos),
    .M_AXI_HP0_arready(M_AXI_HP0_arready),
    .M_AXI_HP0_arsize(M_AXI_HP0_arsize),
    .M_AXI_HP0_arvalid(M_AXI_HP0_arvalid),
    .M_AXI_HP0_awaddr(M_AXI_HP0_awaddr),
    .M_AXI_HP0_awburst(M_AXI_HP0_awburst),
    .M_AXI_HP0_awcache(M_AXI_HP0_awcache),
    .M_AXI_HP0_awlen(M_AXI_HP0_awlen),
    .M_AXI_HP0_awlock(M_AXI_HP0_awlock),
    .M_AXI_HP0_awprot(M_AXI_HP0_awprot),
    .M_AXI_HP0_awqos(M_AXI_HP0_awqos),
    .M_AXI_HP0_awready(M_AXI_HP0_awready),
    .M_AXI_HP0_awsize(M_AXI_HP0_awsize),
    .M_AXI_HP0_awvalid(M_AXI_HP0_awvalid),
    .M_AXI_HP0_bready(M_AXI_HP0_bready),
    .M_AXI_HP0_bresp(M_AXI_HP0_bresp),
    .M_AXI_HP0_bvalid(M_AXI_HP0_bvalid),
    .M_AXI_HP0_rdata(M_AXI_HP0_rdata),
    .M_AXI_HP0_rlast(M_AXI_HP0_rlast),
    .M_AXI_HP0_rready(M_AXI_HP0_rready),
    .M_AXI_HP0_rresp(M_AXI_HP0_rresp),
    .M_AXI_HP0_rvalid(M_AXI_HP0_rvalid),
    .M_AXI_HP0_wdata(M_AXI_HP0_wdata),
    .M_AXI_HP0_wlast(M_AXI_HP0_wlast),
    .M_AXI_HP0_wready(M_AXI_HP0_wready),
    .M_AXI_HP0_wstrb(M_AXI_HP0_wstrb),
    .M_AXI_HP0_wvalid(M_AXI_HP0_wvalid),
    .M_AXI_HP0_aruser(M_AXI_HP0_aruser),
    .M_AXI_HP0_awuser(M_AXI_HP0_awuser),
    .M_AXI_HP2_araddr(M_AXI_HP2_araddr),
    .M_AXI_HP2_arburst(M_AXI_HP2_arburst),
    .M_AXI_HP2_arcache(M_AXI_HP2_arcache),
    .M_AXI_HP2_arlen(M_AXI_HP2_arlen),
    .M_AXI_HP2_arlock(M_AXI_HP2_arlock),
    .M_AXI_HP2_arprot(M_AXI_HP2_arprot),
    .M_AXI_HP2_arqos(M_AXI_HP2_arqos),
    .M_AXI_HP2_arready(M_AXI_HP2_arready),
    .M_AXI_HP2_arsize(M_AXI_HP2_arsize),
    .M_AXI_HP2_arvalid(M_AXI_HP2_arvalid),
    .M_AXI_HP2_awaddr(M_AXI_HP2_awaddr),
    .M_AXI_HP2_awburst(M_AXI_HP2_awburst),
    .M_AXI_HP2_awcache(M_AXI_HP2_awcache),
    .M_AXI_HP2_awlen(M_AXI_HP2_awlen),
    .M_AXI_HP2_awlock(M_AXI_HP2_awlock),
    .M_AXI_HP2_awprot(M_AXI_HP2_awprot),
    .M_AXI_HP2_awqos(M_AXI_HP2_awqos),
    .M_AXI_HP2_awready(M_AXI_HP2_awready),
    .M_AXI_HP2_awsize(M_AXI_HP2_awsize),
    .M_AXI_HP2_awvalid(M_AXI_HP2_awvalid),
    .M_AXI_HP2_bready(M_AXI_HP2_bready),
    .M_AXI_HP2_bresp(M_AXI_HP2_bresp),
    .M_AXI_HP2_bvalid(M_AXI_HP2_bvalid),
    .M_AXI_HP2_rdata(M_AXI_HP2_rdata),
    .M_AXI_HP2_rlast(M_AXI_HP2_rlast),
    .M_AXI_HP2_rready(M_AXI_HP2_rready),
    .M_AXI_HP2_rresp(M_AXI_HP2_rresp),
    .M_AXI_HP2_rvalid(M_AXI_HP2_rvalid),
    .M_AXI_HP2_wdata(M_AXI_HP2_wdata),
    .M_AXI_HP2_wlast(M_AXI_HP2_wlast),
    .M_AXI_HP2_wready(M_AXI_HP2_wready),
    .M_AXI_HP2_wstrb(M_AXI_HP2_wstrb),
    .M_AXI_HP2_wvalid(M_AXI_HP2_wvalid),
    .M_AXI_HP2_aruser(M_AXI_HP2_aruser),
    .M_AXI_HP2_awuser(M_AXI_HP2_awuser),
    .S_AXI_CONTROL_araddr(S_AXI_CONTROL_araddr),
    .S_AXI_CONTROL_arready(S_AXI_CONTROL_arready),
    .S_AXI_CONTROL_arvalid(S_AXI_CONTROL_arvalid),
    .S_AXI_CONTROL_awaddr(S_AXI_CONTROL_awaddr),
    .S_AXI_CONTROL_awready(S_AXI_CONTROL_awready),
    .S_AXI_CONTROL_awvalid(S_AXI_CONTROL_awvalid),
    .S_AXI_CONTROL_bready(S_AXI_CONTROL_bready),
    .S_AXI_CONTROL_bresp(S_AXI_CONTROL_bresp),
    .S_AXI_CONTROL_bvalid(S_AXI_CONTROL_bvalid),
    .S_AXI_CONTROL_rdata(S_AXI_CONTROL_rdata),
    .S_AXI_CONTROL_rready(S_AXI_CONTROL_rready),
    .S_AXI_CONTROL_rresp(S_AXI_CONTROL_rresp),
    .S_AXI_CONTROL_rvalid(S_AXI_CONTROL_rvalid),
    .S_AXI_CONTROL_wdata(S_AXI_CONTROL_wdata),
    .S_AXI_CONTROL_wready(S_AXI_CONTROL_wready),
    .S_AXI_CONTROL_wstrb(S_AXI_CONTROL_wstrb),
    .S_AXI_CONTROL_wvalid(S_AXI_CONTROL_wvalid),
    .aclk(aclk),
    .ap_clk_2(ap_clk_2),
    .ap_rst_n_2(ap_rst_n_2),
    .aresetn(aresetn),
    .interrupt(interrupt)
  );
endmodule
