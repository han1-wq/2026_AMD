// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (lin64) Build 3526262 Mon Apr 18 15:47:01 MDT 2022
// Date        : Wed Oct 14 01:46:18 2026
// Host        : ubuntu running 64-bit Ubuntu 20.04.1 LTS
// Command     : write_verilog -force -mode funcsim
//               /home/amd/Workspace/dpu_platform2/kv260_vitis_platform/dpu_trd_system_hw_link/Hardware/dpu.build/link/vivado/vpl/prj/prj.gen/sources_1/bd/kv260_hardware_platform/ip/kv260_hardware_platform_DPUCZDX8G_1_0/kv260_hardware_platform_DPUCZDX8G_1_0_sim_netlist.v
// Design      : kv260_hardware_platform_DPUCZDX8G_1_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xck26-sfvc784-2LV-c
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "kv260_hardware_platform_DPUCZDX8G_1_0,DPUCZDX8G,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* IP_DEFINITION_SOURCE = "package_project" *) 
(* X_CORE_INFO = "DPUCZDX8G,Vivado 2022.1" *) 
(* NotValidForBitStream *)
module kv260_hardware_platform_DPUCZDX8G_1_0
   (M_AXI_GP0_araddr,
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
    interrupt);
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 ARADDR" *) output [39:0]M_AXI_GP0_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 ARBURST" *) output [1:0]M_AXI_GP0_arburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 ARCACHE" *) output [3:0]M_AXI_GP0_arcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 ARLEN" *) output [7:0]M_AXI_GP0_arlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 ARLOCK" *) output [0:0]M_AXI_GP0_arlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 ARPROT" *) output [2:0]M_AXI_GP0_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 ARQOS" *) output [3:0]M_AXI_GP0_arqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 ARREADY" *) input M_AXI_GP0_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 ARSIZE" *) output [2:0]M_AXI_GP0_arsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 ARVALID" *) output M_AXI_GP0_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 AWADDR" *) output [39:0]M_AXI_GP0_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 AWBURST" *) output [1:0]M_AXI_GP0_awburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 AWCACHE" *) output [3:0]M_AXI_GP0_awcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 AWLEN" *) output [7:0]M_AXI_GP0_awlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 AWLOCK" *) output [0:0]M_AXI_GP0_awlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 AWPROT" *) output [2:0]M_AXI_GP0_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 AWQOS" *) output [3:0]M_AXI_GP0_awqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 AWREADY" *) input M_AXI_GP0_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 AWSIZE" *) output [2:0]M_AXI_GP0_awsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 AWVALID" *) output M_AXI_GP0_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 BREADY" *) output M_AXI_GP0_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 BRESP" *) input [1:0]M_AXI_GP0_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 BVALID" *) input M_AXI_GP0_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 RDATA" *) input [31:0]M_AXI_GP0_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 RLAST" *) input M_AXI_GP0_rlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 RREADY" *) output M_AXI_GP0_rready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 RRESP" *) input [1:0]M_AXI_GP0_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 RVALID" *) input M_AXI_GP0_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 WDATA" *) output [31:0]M_AXI_GP0_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 WLAST" *) output M_AXI_GP0_wlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 WREADY" *) input M_AXI_GP0_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 WSTRB" *) output [3:0]M_AXI_GP0_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 WVALID" *) output M_AXI_GP0_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 ARUSER" *) output [0:0]M_AXI_GP0_aruser;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_GP0 AWUSER" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_AXI_GP0, DATA_WIDTH 32, PROTOCOL AXI4, FREQ_HZ 299997000, ID_WIDTH 0, ADDR_WIDTH 40, AWUSER_WIDTH 1, ARUSER_WIDTH 1, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 1, HAS_LOCK 1, HAS_PROT 1, HAS_CACHE 1, HAS_QOS 1, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 1, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 256, PHASE 0.0, CLK_DOMAIN kv260_hardware_platform_clk_wiz_0_1_clk_out1, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *) output [0:0]M_AXI_GP0_awuser;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 ARADDR" *) output [39:0]M_AXI_HP0_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 ARBURST" *) output [1:0]M_AXI_HP0_arburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 ARCACHE" *) output [3:0]M_AXI_HP0_arcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 ARLEN" *) output [7:0]M_AXI_HP0_arlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 ARLOCK" *) output [0:0]M_AXI_HP0_arlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 ARPROT" *) output [2:0]M_AXI_HP0_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 ARQOS" *) output [3:0]M_AXI_HP0_arqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 ARREADY" *) input M_AXI_HP0_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 ARSIZE" *) output [2:0]M_AXI_HP0_arsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 ARVALID" *) output M_AXI_HP0_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 AWADDR" *) output [39:0]M_AXI_HP0_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 AWBURST" *) output [1:0]M_AXI_HP0_awburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 AWCACHE" *) output [3:0]M_AXI_HP0_awcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 AWLEN" *) output [7:0]M_AXI_HP0_awlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 AWLOCK" *) output [0:0]M_AXI_HP0_awlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 AWPROT" *) output [2:0]M_AXI_HP0_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 AWQOS" *) output [3:0]M_AXI_HP0_awqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 AWREADY" *) input M_AXI_HP0_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 AWSIZE" *) output [2:0]M_AXI_HP0_awsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 AWVALID" *) output M_AXI_HP0_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 BREADY" *) output M_AXI_HP0_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 BRESP" *) input [1:0]M_AXI_HP0_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 BVALID" *) input M_AXI_HP0_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 RDATA" *) input [127:0]M_AXI_HP0_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 RLAST" *) input M_AXI_HP0_rlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 RREADY" *) output M_AXI_HP0_rready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 RRESP" *) input [1:0]M_AXI_HP0_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 RVALID" *) input M_AXI_HP0_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 WDATA" *) output [127:0]M_AXI_HP0_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 WLAST" *) output M_AXI_HP0_wlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 WREADY" *) input M_AXI_HP0_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 WSTRB" *) output [15:0]M_AXI_HP0_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 WVALID" *) output M_AXI_HP0_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 ARUSER" *) output [0:0]M_AXI_HP0_aruser;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP0 AWUSER" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_AXI_HP0, DATA_WIDTH 128, PROTOCOL AXI4, FREQ_HZ 299997000, ID_WIDTH 0, ADDR_WIDTH 40, AWUSER_WIDTH 1, ARUSER_WIDTH 1, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 1, HAS_LOCK 1, HAS_PROT 1, HAS_CACHE 1, HAS_QOS 1, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 1, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 256, PHASE 0.0, CLK_DOMAIN kv260_hardware_platform_clk_wiz_0_1_clk_out1, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *) output [0:0]M_AXI_HP0_awuser;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 ARADDR" *) output [39:0]M_AXI_HP2_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 ARBURST" *) output [1:0]M_AXI_HP2_arburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 ARCACHE" *) output [3:0]M_AXI_HP2_arcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 ARLEN" *) output [7:0]M_AXI_HP2_arlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 ARLOCK" *) output [0:0]M_AXI_HP2_arlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 ARPROT" *) output [2:0]M_AXI_HP2_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 ARQOS" *) output [3:0]M_AXI_HP2_arqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 ARREADY" *) input M_AXI_HP2_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 ARSIZE" *) output [2:0]M_AXI_HP2_arsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 ARVALID" *) output M_AXI_HP2_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 AWADDR" *) output [39:0]M_AXI_HP2_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 AWBURST" *) output [1:0]M_AXI_HP2_awburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 AWCACHE" *) output [3:0]M_AXI_HP2_awcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 AWLEN" *) output [7:0]M_AXI_HP2_awlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 AWLOCK" *) output [0:0]M_AXI_HP2_awlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 AWPROT" *) output [2:0]M_AXI_HP2_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 AWQOS" *) output [3:0]M_AXI_HP2_awqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 AWREADY" *) input M_AXI_HP2_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 AWSIZE" *) output [2:0]M_AXI_HP2_awsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 AWVALID" *) output M_AXI_HP2_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 BREADY" *) output M_AXI_HP2_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 BRESP" *) input [1:0]M_AXI_HP2_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 BVALID" *) input M_AXI_HP2_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 RDATA" *) input [127:0]M_AXI_HP2_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 RLAST" *) input M_AXI_HP2_rlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 RREADY" *) output M_AXI_HP2_rready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 RRESP" *) input [1:0]M_AXI_HP2_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 RVALID" *) input M_AXI_HP2_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 WDATA" *) output [127:0]M_AXI_HP2_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 WLAST" *) output M_AXI_HP2_wlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 WREADY" *) input M_AXI_HP2_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 WSTRB" *) output [15:0]M_AXI_HP2_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 WVALID" *) output M_AXI_HP2_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 ARUSER" *) output [0:0]M_AXI_HP2_aruser;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_HP2 AWUSER" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_AXI_HP2, DATA_WIDTH 128, PROTOCOL AXI4, FREQ_HZ 299997000, ID_WIDTH 0, ADDR_WIDTH 40, AWUSER_WIDTH 1, ARUSER_WIDTH 1, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 1, HAS_LOCK 1, HAS_PROT 1, HAS_CACHE 1, HAS_QOS 1, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 1, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 256, PHASE 0.0, CLK_DOMAIN kv260_hardware_platform_clk_wiz_0_1_clk_out1, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *) output [0:0]M_AXI_HP2_awuser;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL ARADDR" *) input [11:0]S_AXI_CONTROL_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL ARREADY" *) output S_AXI_CONTROL_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL ARVALID" *) input S_AXI_CONTROL_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL AWADDR" *) input [11:0]S_AXI_CONTROL_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL AWREADY" *) output S_AXI_CONTROL_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL AWVALID" *) input S_AXI_CONTROL_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL BREADY" *) input S_AXI_CONTROL_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL BRESP" *) output [1:0]S_AXI_CONTROL_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL BVALID" *) output S_AXI_CONTROL_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL RDATA" *) output [31:0]S_AXI_CONTROL_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL RREADY" *) input S_AXI_CONTROL_rready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL RRESP" *) output [1:0]S_AXI_CONTROL_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL RVALID" *) output S_AXI_CONTROL_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL WDATA" *) input [31:0]S_AXI_CONTROL_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL WREADY" *) output S_AXI_CONTROL_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL WSTRB" *) input [3:0]S_AXI_CONTROL_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL WVALID" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S_AXI_CONTROL, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 299997000, ID_WIDTH 0, ADDR_WIDTH 12, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN kv260_hardware_platform_clk_wiz_0_1_clk_out1, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *) input S_AXI_CONTROL_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 aclk CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aclk, ASSOCIATED_BUSIF M_AXI_GP0:M_AXI_HP0:M_AXI_HP2:S_AXI_CONTROL, ASSOCIATED_RESET aresetn, FREQ_HZ 299997000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN kv260_hardware_platform_clk_wiz_0_1_clk_out1, INSERT_VIP 0" *) input aclk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 ap_clk_2 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME ap_clk_2, ASSOCIATED_RESET ap_rst_n_2, FREQ_HZ 599994000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN kv260_hardware_platform_clk_wiz_0_1_clk_out1, INSERT_VIP 0" *) input ap_clk_2;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 ap_rst_n_2 RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME ap_rst_n_2, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input ap_rst_n_2;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 aresetn RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input aresetn;
  (* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 interrupt INTERRUPT" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME interrupt, SENSITIVITY LEVEL_HIGH, PortWidth 1" *) output interrupt;

  wire \<const0> ;
  wire \<const1> ;
  wire [39:3]\^M_AXI_GP0_araddr ;
  wire M_AXI_GP0_arready;
  wire M_AXI_GP0_arvalid;
  wire M_AXI_GP0_awready;
  wire [31:0]M_AXI_GP0_rdata;
  wire M_AXI_GP0_rlast;
  wire M_AXI_GP0_rready;
  wire M_AXI_GP0_rvalid;
  wire M_AXI_GP0_wready;
  wire [39:0]M_AXI_HP0_araddr;
  wire [3:0]\^M_AXI_HP0_arlen ;
  wire M_AXI_HP0_arready;
  wire M_AXI_HP0_arvalid;
  wire [39:0]M_AXI_HP0_awaddr;
  wire [7:0]M_AXI_HP0_awlen;
  wire M_AXI_HP0_awready;
  wire M_AXI_HP0_awvalid;
  wire M_AXI_HP0_bvalid;
  wire [127:0]M_AXI_HP0_rdata;
  wire M_AXI_HP0_rlast;
  wire M_AXI_HP0_rready;
  wire M_AXI_HP0_rvalid;
  wire [127:0]M_AXI_HP0_wdata;
  wire M_AXI_HP0_wlast;
  wire M_AXI_HP0_wready;
  wire [15:0]M_AXI_HP0_wstrb;
  wire M_AXI_HP0_wvalid;
  wire [39:0]M_AXI_HP2_araddr;
  wire [3:0]\^M_AXI_HP2_arlen ;
  wire M_AXI_HP2_arready;
  wire M_AXI_HP2_arvalid;
  wire [39:0]M_AXI_HP2_awaddr;
  wire [7:0]M_AXI_HP2_awlen;
  wire M_AXI_HP2_awready;
  wire M_AXI_HP2_awvalid;
  wire M_AXI_HP2_bvalid;
  wire [127:0]M_AXI_HP2_rdata;
  wire M_AXI_HP2_rlast;
  wire M_AXI_HP2_rready;
  wire M_AXI_HP2_rvalid;
  wire [127:0]M_AXI_HP2_wdata;
  wire M_AXI_HP2_wlast;
  wire M_AXI_HP2_wready;
  wire [15:0]M_AXI_HP2_wstrb;
  wire M_AXI_HP2_wvalid;
  wire [11:0]S_AXI_CONTROL_araddr;
  wire S_AXI_CONTROL_arready;
  wire S_AXI_CONTROL_arvalid;
  wire [11:0]S_AXI_CONTROL_awaddr;
  wire S_AXI_CONTROL_awready;
  wire S_AXI_CONTROL_awvalid;
  wire S_AXI_CONTROL_bready;
  wire S_AXI_CONTROL_bvalid;
  wire [31:0]S_AXI_CONTROL_rdata;
  wire S_AXI_CONTROL_rready;
  wire S_AXI_CONTROL_rvalid;
  wire [31:0]S_AXI_CONTROL_wdata;
  wire S_AXI_CONTROL_wready;
  wire [3:0]S_AXI_CONTROL_wstrb;
  wire S_AXI_CONTROL_wvalid;
  wire aclk;
  wire ap_clk_2;
  wire aresetn;
  wire interrupt;
  wire NLW_inst_M_AXI_GP0_awvalid_UNCONNECTED;
  wire NLW_inst_M_AXI_GP0_bready_UNCONNECTED;
  wire NLW_inst_M_AXI_GP0_wlast_UNCONNECTED;
  wire NLW_inst_M_AXI_GP0_wvalid_UNCONNECTED;
  wire NLW_inst_M_AXI_HP0_bready_UNCONNECTED;
  wire NLW_inst_M_AXI_HP2_bready_UNCONNECTED;
  wire [2:0]NLW_inst_M_AXI_GP0_araddr_UNCONNECTED;
  wire [1:0]NLW_inst_M_AXI_GP0_arburst_UNCONNECTED;
  wire [3:0]NLW_inst_M_AXI_GP0_arcache_UNCONNECTED;
  wire [7:0]NLW_inst_M_AXI_GP0_arlen_UNCONNECTED;
  wire [0:0]NLW_inst_M_AXI_GP0_arlock_UNCONNECTED;
  wire [2:0]NLW_inst_M_AXI_GP0_arprot_UNCONNECTED;
  wire [3:0]NLW_inst_M_AXI_GP0_arqos_UNCONNECTED;
  wire [2:0]NLW_inst_M_AXI_GP0_arsize_UNCONNECTED;
  wire [0:0]NLW_inst_M_AXI_GP0_aruser_UNCONNECTED;
  wire [39:0]NLW_inst_M_AXI_GP0_awaddr_UNCONNECTED;
  wire [1:0]NLW_inst_M_AXI_GP0_awburst_UNCONNECTED;
  wire [3:0]NLW_inst_M_AXI_GP0_awcache_UNCONNECTED;
  wire [7:0]NLW_inst_M_AXI_GP0_awlen_UNCONNECTED;
  wire [0:0]NLW_inst_M_AXI_GP0_awlock_UNCONNECTED;
  wire [2:0]NLW_inst_M_AXI_GP0_awprot_UNCONNECTED;
  wire [3:0]NLW_inst_M_AXI_GP0_awqos_UNCONNECTED;
  wire [2:0]NLW_inst_M_AXI_GP0_awsize_UNCONNECTED;
  wire [0:0]NLW_inst_M_AXI_GP0_awuser_UNCONNECTED;
  wire [31:0]NLW_inst_M_AXI_GP0_wdata_UNCONNECTED;
  wire [3:0]NLW_inst_M_AXI_GP0_wstrb_UNCONNECTED;
  wire [1:0]NLW_inst_M_AXI_HP0_arburst_UNCONNECTED;
  wire [3:0]NLW_inst_M_AXI_HP0_arcache_UNCONNECTED;
  wire [7:4]NLW_inst_M_AXI_HP0_arlen_UNCONNECTED;
  wire [0:0]NLW_inst_M_AXI_HP0_arlock_UNCONNECTED;
  wire [2:0]NLW_inst_M_AXI_HP0_arprot_UNCONNECTED;
  wire [3:0]NLW_inst_M_AXI_HP0_arqos_UNCONNECTED;
  wire [2:0]NLW_inst_M_AXI_HP0_arsize_UNCONNECTED;
  wire [0:0]NLW_inst_M_AXI_HP0_aruser_UNCONNECTED;
  wire [1:0]NLW_inst_M_AXI_HP0_awburst_UNCONNECTED;
  wire [3:0]NLW_inst_M_AXI_HP0_awcache_UNCONNECTED;
  wire [0:0]NLW_inst_M_AXI_HP0_awlock_UNCONNECTED;
  wire [2:0]NLW_inst_M_AXI_HP0_awprot_UNCONNECTED;
  wire [3:0]NLW_inst_M_AXI_HP0_awqos_UNCONNECTED;
  wire [2:0]NLW_inst_M_AXI_HP0_awsize_UNCONNECTED;
  wire [0:0]NLW_inst_M_AXI_HP0_awuser_UNCONNECTED;
  wire [1:0]NLW_inst_M_AXI_HP2_arburst_UNCONNECTED;
  wire [3:0]NLW_inst_M_AXI_HP2_arcache_UNCONNECTED;
  wire [7:4]NLW_inst_M_AXI_HP2_arlen_UNCONNECTED;
  wire [0:0]NLW_inst_M_AXI_HP2_arlock_UNCONNECTED;
  wire [2:0]NLW_inst_M_AXI_HP2_arprot_UNCONNECTED;
  wire [3:0]NLW_inst_M_AXI_HP2_arqos_UNCONNECTED;
  wire [2:0]NLW_inst_M_AXI_HP2_arsize_UNCONNECTED;
  wire [0:0]NLW_inst_M_AXI_HP2_aruser_UNCONNECTED;
  wire [1:0]NLW_inst_M_AXI_HP2_awburst_UNCONNECTED;
  wire [3:0]NLW_inst_M_AXI_HP2_awcache_UNCONNECTED;
  wire [0:0]NLW_inst_M_AXI_HP2_awlock_UNCONNECTED;
  wire [2:0]NLW_inst_M_AXI_HP2_awprot_UNCONNECTED;
  wire [3:0]NLW_inst_M_AXI_HP2_awqos_UNCONNECTED;
  wire [2:0]NLW_inst_M_AXI_HP2_awsize_UNCONNECTED;
  wire [0:0]NLW_inst_M_AXI_HP2_awuser_UNCONNECTED;
  wire [1:0]NLW_inst_S_AXI_CONTROL_bresp_UNCONNECTED;
  wire [1:0]NLW_inst_S_AXI_CONTROL_rresp_UNCONNECTED;

  assign M_AXI_GP0_araddr[39:3] = \^M_AXI_GP0_araddr [39:3];
  assign M_AXI_GP0_araddr[2] = \<const0> ;
  assign M_AXI_GP0_araddr[1] = \<const0> ;
  assign M_AXI_GP0_araddr[0] = \<const0> ;
  assign M_AXI_GP0_arburst[1] = \<const0> ;
  assign M_AXI_GP0_arburst[0] = \<const1> ;
  assign M_AXI_GP0_arcache[3] = \<const0> ;
  assign M_AXI_GP0_arcache[2] = \<const0> ;
  assign M_AXI_GP0_arcache[1] = \<const0> ;
  assign M_AXI_GP0_arcache[0] = \<const0> ;
  assign M_AXI_GP0_arlen[7] = \<const0> ;
  assign M_AXI_GP0_arlen[6] = \<const0> ;
  assign M_AXI_GP0_arlen[5] = \<const0> ;
  assign M_AXI_GP0_arlen[4] = \<const0> ;
  assign M_AXI_GP0_arlen[3] = \<const0> ;
  assign M_AXI_GP0_arlen[2] = \<const0> ;
  assign M_AXI_GP0_arlen[1] = \<const1> ;
  assign M_AXI_GP0_arlen[0] = \<const1> ;
  assign M_AXI_GP0_arlock[0] = \<const0> ;
  assign M_AXI_GP0_arprot[2] = \<const0> ;
  assign M_AXI_GP0_arprot[1] = \<const0> ;
  assign M_AXI_GP0_arprot[0] = \<const0> ;
  assign M_AXI_GP0_arqos[3] = \<const0> ;
  assign M_AXI_GP0_arqos[2] = \<const0> ;
  assign M_AXI_GP0_arqos[1] = \<const0> ;
  assign M_AXI_GP0_arqos[0] = \<const0> ;
  assign M_AXI_GP0_arsize[2] = \<const0> ;
  assign M_AXI_GP0_arsize[1] = \<const1> ;
  assign M_AXI_GP0_arsize[0] = \<const0> ;
  assign M_AXI_GP0_aruser[0] = \<const0> ;
  assign M_AXI_GP0_awaddr[39] = \<const0> ;
  assign M_AXI_GP0_awaddr[38] = \<const0> ;
  assign M_AXI_GP0_awaddr[37] = \<const0> ;
  assign M_AXI_GP0_awaddr[36] = \<const0> ;
  assign M_AXI_GP0_awaddr[35] = \<const0> ;
  assign M_AXI_GP0_awaddr[34] = \<const0> ;
  assign M_AXI_GP0_awaddr[33] = \<const0> ;
  assign M_AXI_GP0_awaddr[32] = \<const0> ;
  assign M_AXI_GP0_awaddr[31] = \<const0> ;
  assign M_AXI_GP0_awaddr[30] = \<const0> ;
  assign M_AXI_GP0_awaddr[29] = \<const0> ;
  assign M_AXI_GP0_awaddr[28] = \<const0> ;
  assign M_AXI_GP0_awaddr[27] = \<const0> ;
  assign M_AXI_GP0_awaddr[26] = \<const0> ;
  assign M_AXI_GP0_awaddr[25] = \<const0> ;
  assign M_AXI_GP0_awaddr[24] = \<const0> ;
  assign M_AXI_GP0_awaddr[23] = \<const0> ;
  assign M_AXI_GP0_awaddr[22] = \<const0> ;
  assign M_AXI_GP0_awaddr[21] = \<const0> ;
  assign M_AXI_GP0_awaddr[20] = \<const0> ;
  assign M_AXI_GP0_awaddr[19] = \<const0> ;
  assign M_AXI_GP0_awaddr[18] = \<const0> ;
  assign M_AXI_GP0_awaddr[17] = \<const0> ;
  assign M_AXI_GP0_awaddr[16] = \<const0> ;
  assign M_AXI_GP0_awaddr[15] = \<const0> ;
  assign M_AXI_GP0_awaddr[14] = \<const0> ;
  assign M_AXI_GP0_awaddr[13] = \<const0> ;
  assign M_AXI_GP0_awaddr[12] = \<const0> ;
  assign M_AXI_GP0_awaddr[11] = \<const0> ;
  assign M_AXI_GP0_awaddr[10] = \<const0> ;
  assign M_AXI_GP0_awaddr[9] = \<const0> ;
  assign M_AXI_GP0_awaddr[8] = \<const0> ;
  assign M_AXI_GP0_awaddr[7] = \<const0> ;
  assign M_AXI_GP0_awaddr[6] = \<const0> ;
  assign M_AXI_GP0_awaddr[5] = \<const0> ;
  assign M_AXI_GP0_awaddr[4] = \<const0> ;
  assign M_AXI_GP0_awaddr[3] = \<const0> ;
  assign M_AXI_GP0_awaddr[2] = \<const0> ;
  assign M_AXI_GP0_awaddr[1] = \<const0> ;
  assign M_AXI_GP0_awaddr[0] = \<const0> ;
  assign M_AXI_GP0_awburst[1] = \<const0> ;
  assign M_AXI_GP0_awburst[0] = \<const1> ;
  assign M_AXI_GP0_awcache[3] = \<const0> ;
  assign M_AXI_GP0_awcache[2] = \<const0> ;
  assign M_AXI_GP0_awcache[1] = \<const0> ;
  assign M_AXI_GP0_awcache[0] = \<const0> ;
  assign M_AXI_GP0_awlen[7] = \<const0> ;
  assign M_AXI_GP0_awlen[6] = \<const0> ;
  assign M_AXI_GP0_awlen[5] = \<const0> ;
  assign M_AXI_GP0_awlen[4] = \<const0> ;
  assign M_AXI_GP0_awlen[3] = \<const0> ;
  assign M_AXI_GP0_awlen[2] = \<const0> ;
  assign M_AXI_GP0_awlen[1] = \<const0> ;
  assign M_AXI_GP0_awlen[0] = \<const0> ;
  assign M_AXI_GP0_awlock[0] = \<const0> ;
  assign M_AXI_GP0_awprot[2] = \<const0> ;
  assign M_AXI_GP0_awprot[1] = \<const0> ;
  assign M_AXI_GP0_awprot[0] = \<const0> ;
  assign M_AXI_GP0_awqos[3] = \<const0> ;
  assign M_AXI_GP0_awqos[2] = \<const0> ;
  assign M_AXI_GP0_awqos[1] = \<const0> ;
  assign M_AXI_GP0_awqos[0] = \<const0> ;
  assign M_AXI_GP0_awsize[2] = \<const0> ;
  assign M_AXI_GP0_awsize[1] = \<const1> ;
  assign M_AXI_GP0_awsize[0] = \<const0> ;
  assign M_AXI_GP0_awuser[0] = \<const0> ;
  assign M_AXI_GP0_awvalid = \<const0> ;
  assign M_AXI_GP0_bready = \<const1> ;
  assign M_AXI_GP0_wdata[31] = \<const0> ;
  assign M_AXI_GP0_wdata[30] = \<const0> ;
  assign M_AXI_GP0_wdata[29] = \<const0> ;
  assign M_AXI_GP0_wdata[28] = \<const0> ;
  assign M_AXI_GP0_wdata[27] = \<const0> ;
  assign M_AXI_GP0_wdata[26] = \<const0> ;
  assign M_AXI_GP0_wdata[25] = \<const0> ;
  assign M_AXI_GP0_wdata[24] = \<const0> ;
  assign M_AXI_GP0_wdata[23] = \<const0> ;
  assign M_AXI_GP0_wdata[22] = \<const0> ;
  assign M_AXI_GP0_wdata[21] = \<const0> ;
  assign M_AXI_GP0_wdata[20] = \<const0> ;
  assign M_AXI_GP0_wdata[19] = \<const0> ;
  assign M_AXI_GP0_wdata[18] = \<const0> ;
  assign M_AXI_GP0_wdata[17] = \<const0> ;
  assign M_AXI_GP0_wdata[16] = \<const0> ;
  assign M_AXI_GP0_wdata[15] = \<const0> ;
  assign M_AXI_GP0_wdata[14] = \<const0> ;
  assign M_AXI_GP0_wdata[13] = \<const0> ;
  assign M_AXI_GP0_wdata[12] = \<const0> ;
  assign M_AXI_GP0_wdata[11] = \<const0> ;
  assign M_AXI_GP0_wdata[10] = \<const0> ;
  assign M_AXI_GP0_wdata[9] = \<const0> ;
  assign M_AXI_GP0_wdata[8] = \<const0> ;
  assign M_AXI_GP0_wdata[7] = \<const0> ;
  assign M_AXI_GP0_wdata[6] = \<const0> ;
  assign M_AXI_GP0_wdata[5] = \<const0> ;
  assign M_AXI_GP0_wdata[4] = \<const0> ;
  assign M_AXI_GP0_wdata[3] = \<const0> ;
  assign M_AXI_GP0_wdata[2] = \<const0> ;
  assign M_AXI_GP0_wdata[1] = \<const0> ;
  assign M_AXI_GP0_wdata[0] = \<const0> ;
  assign M_AXI_GP0_wlast = \<const1> ;
  assign M_AXI_GP0_wstrb[3] = \<const1> ;
  assign M_AXI_GP0_wstrb[2] = \<const1> ;
  assign M_AXI_GP0_wstrb[1] = \<const1> ;
  assign M_AXI_GP0_wstrb[0] = \<const1> ;
  assign M_AXI_GP0_wvalid = \<const0> ;
  assign M_AXI_HP0_arburst[1] = \<const0> ;
  assign M_AXI_HP0_arburst[0] = \<const1> ;
  assign M_AXI_HP0_arcache[3] = \<const0> ;
  assign M_AXI_HP0_arcache[2] = \<const0> ;
  assign M_AXI_HP0_arcache[1] = \<const0> ;
  assign M_AXI_HP0_arcache[0] = \<const0> ;
  assign M_AXI_HP0_arlen[7] = \<const0> ;
  assign M_AXI_HP0_arlen[6] = \<const0> ;
  assign M_AXI_HP0_arlen[5] = \<const0> ;
  assign M_AXI_HP0_arlen[4] = \<const0> ;
  assign M_AXI_HP0_arlen[3:0] = \^M_AXI_HP0_arlen [3:0];
  assign M_AXI_HP0_arlock[0] = \<const0> ;
  assign M_AXI_HP0_arprot[2] = \<const0> ;
  assign M_AXI_HP0_arprot[1] = \<const0> ;
  assign M_AXI_HP0_arprot[0] = \<const0> ;
  assign M_AXI_HP0_arqos[3] = \<const0> ;
  assign M_AXI_HP0_arqos[2] = \<const0> ;
  assign M_AXI_HP0_arqos[1] = \<const0> ;
  assign M_AXI_HP0_arqos[0] = \<const0> ;
  assign M_AXI_HP0_arsize[2] = \<const1> ;
  assign M_AXI_HP0_arsize[1] = \<const0> ;
  assign M_AXI_HP0_arsize[0] = \<const0> ;
  assign M_AXI_HP0_aruser[0] = \<const0> ;
  assign M_AXI_HP0_awburst[1] = \<const0> ;
  assign M_AXI_HP0_awburst[0] = \<const1> ;
  assign M_AXI_HP0_awcache[3] = \<const0> ;
  assign M_AXI_HP0_awcache[2] = \<const0> ;
  assign M_AXI_HP0_awcache[1] = \<const0> ;
  assign M_AXI_HP0_awcache[0] = \<const0> ;
  assign M_AXI_HP0_awlock[0] = \<const0> ;
  assign M_AXI_HP0_awprot[2] = \<const0> ;
  assign M_AXI_HP0_awprot[1] = \<const0> ;
  assign M_AXI_HP0_awprot[0] = \<const0> ;
  assign M_AXI_HP0_awqos[3] = \<const0> ;
  assign M_AXI_HP0_awqos[2] = \<const0> ;
  assign M_AXI_HP0_awqos[1] = \<const0> ;
  assign M_AXI_HP0_awqos[0] = \<const0> ;
  assign M_AXI_HP0_awsize[2] = \<const1> ;
  assign M_AXI_HP0_awsize[1] = \<const0> ;
  assign M_AXI_HP0_awsize[0] = \<const0> ;
  assign M_AXI_HP0_awuser[0] = \<const0> ;
  assign M_AXI_HP0_bready = \<const1> ;
  assign M_AXI_HP2_arburst[1] = \<const0> ;
  assign M_AXI_HP2_arburst[0] = \<const1> ;
  assign M_AXI_HP2_arcache[3] = \<const0> ;
  assign M_AXI_HP2_arcache[2] = \<const0> ;
  assign M_AXI_HP2_arcache[1] = \<const0> ;
  assign M_AXI_HP2_arcache[0] = \<const0> ;
  assign M_AXI_HP2_arlen[7] = \<const0> ;
  assign M_AXI_HP2_arlen[6] = \<const0> ;
  assign M_AXI_HP2_arlen[5] = \<const0> ;
  assign M_AXI_HP2_arlen[4] = \<const0> ;
  assign M_AXI_HP2_arlen[3:0] = \^M_AXI_HP2_arlen [3:0];
  assign M_AXI_HP2_arlock[0] = \<const0> ;
  assign M_AXI_HP2_arprot[2] = \<const0> ;
  assign M_AXI_HP2_arprot[1] = \<const0> ;
  assign M_AXI_HP2_arprot[0] = \<const0> ;
  assign M_AXI_HP2_arqos[3] = \<const0> ;
  assign M_AXI_HP2_arqos[2] = \<const0> ;
  assign M_AXI_HP2_arqos[1] = \<const0> ;
  assign M_AXI_HP2_arqos[0] = \<const0> ;
  assign M_AXI_HP2_arsize[2] = \<const1> ;
  assign M_AXI_HP2_arsize[1] = \<const0> ;
  assign M_AXI_HP2_arsize[0] = \<const0> ;
  assign M_AXI_HP2_aruser[0] = \<const0> ;
  assign M_AXI_HP2_awburst[1] = \<const0> ;
  assign M_AXI_HP2_awburst[0] = \<const1> ;
  assign M_AXI_HP2_awcache[3] = \<const0> ;
  assign M_AXI_HP2_awcache[2] = \<const0> ;
  assign M_AXI_HP2_awcache[1] = \<const0> ;
  assign M_AXI_HP2_awcache[0] = \<const0> ;
  assign M_AXI_HP2_awlock[0] = \<const0> ;
  assign M_AXI_HP2_awprot[2] = \<const0> ;
  assign M_AXI_HP2_awprot[1] = \<const0> ;
  assign M_AXI_HP2_awprot[0] = \<const0> ;
  assign M_AXI_HP2_awqos[3] = \<const0> ;
  assign M_AXI_HP2_awqos[2] = \<const0> ;
  assign M_AXI_HP2_awqos[1] = \<const0> ;
  assign M_AXI_HP2_awqos[0] = \<const0> ;
  assign M_AXI_HP2_awsize[2] = \<const1> ;
  assign M_AXI_HP2_awsize[1] = \<const0> ;
  assign M_AXI_HP2_awsize[0] = \<const0> ;
  assign M_AXI_HP2_awuser[0] = \<const0> ;
  assign M_AXI_HP2_bready = \<const1> ;
  assign S_AXI_CONTROL_bresp[1] = \<const0> ;
  assign S_AXI_CONTROL_bresp[0] = \<const0> ;
  assign S_AXI_CONTROL_rresp[1] = \<const0> ;
  assign S_AXI_CONTROL_rresp[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  (* ALU_LEAKYRELU = "0" *) 
  (* ALU_PARALLEL = "4" *) 
  (* ARCH_DATA_BW = "1" *) 
  (* ARCH_HP_BW = "3" *) 
  (* ARCH_ICP = "14" *) 
  (* ARCH_IMG_BKGRP = "2" *) 
  (* ARCH_OCP = "14" *) 
  (* ARCH_PP = "8" *) 
  (* AWRLEN_BW = "8" *) 
  (* AWRLOCK_BW = "1" *) 
  (* AWRUSER_BW = "1" *) 
  (* CONV_DSP_ACCU_ENA = "1" *) 
  (* CONV_DSP_CASC_MAX = "4" *) 
  (* CONV_LEAKYRELU = "1" *) 
  (* CONV_RELU6 = "1" *) 
  (* CONV_RELU_ADDON = "4'b0011" *) 
  (* CONV_RM_0x80_ENA = "0" *) 
  (* CONV_WR_PARALLEL = "1" *) 
  (* DBANK_BIAS = "0" *) 
  (* DBANK_IMG_N = "0" *) 
  (* DBANK_WGT_N = "0" *) 
  (* DNNDK_PRINT = "xrt test" *) 
  (* DPU_WORK_CNT_EN = "0" *) 
  (* DSP48_VER = "DSP48E2" *) 
  (* ELEW_PARALLEL = "4" *) 
  (* GIT_COMMIT_ID = "28'b0100011101110010110101010001" *) 
  (* GIT_COMMIT_TIME = "2022051323" *) 
  (* GP_ID_BW = "6" *) 
  (* HP0_ID_BW = "6" *) 
  (* HP1_ID_BW = "6" *) 
  (* HP2_ID_BW = "6" *) 
  (* HP3_ID_BW = "6" *) 
  (* HP_DATA_BW = "128" *) 
  (* LOAD_AUGM = "1" *) 
  (* LOAD_IMG_MEAN = "0" *) 
  (* LOAD_PARALLEL = "2" *) 
  (* MISC_WR_PARALLEL = "1" *) 
  (* M_AXI_FREQ_MHZ = "300" *) 
  (* RAM_DEPTH_BIAS = "3" *) 
  (* RAM_DEPTH_IMG = "3" *) 
  (* RAM_DEPTH_MEAN = "1" *) 
  (* RAM_DEPTH_WGT = "3" *) 
  (* SAVE_PARALLEL = "2" *) 
  (* SDX_KERNEL = "true" *) 
  (* SDX_KERNEL_SYNTH_INST = "inst" *) 
  (* SDX_KERNEL_TYPE = "rtl" *) 
  (* SIZE_REGMAP_SIZE = "107" *) 
  (* SYS_IP_TYPE = "1" *) 
  (* SYS_IP_VER = "64" *) 
  (* SYS_REGMAP_VER = "2" *) 
  (* S_AXI_FREQ_MHZ = "300" *) 
  (* TIME_DAY = "14" *) 
  (* TIME_HOUR = "14" *) 
  (* TIME_MONTH = "5" *) 
  (* TIME_QUARTER = "2" *) 
  (* TIME_YEAR = "22" *) 
  (* UBANK_BIAS = "1" *) 
  (* UBANK_IMG_N = "4" *) 
  (* UBANK_WGT_N = "15" *) 
  (* VER_IP_REV = "0" *) 
  (* VER_TARGET = "12'b000101000001" *) 
  (* is_du_within_envelope = "true" *) 
  kv260_hardware_platform_DPUCZDX8G_1_0_DPUCZDX8G inst
       (.M_AXI_GP0_araddr({\^M_AXI_GP0_araddr ,NLW_inst_M_AXI_GP0_araddr_UNCONNECTED[2:0]}),
        .M_AXI_GP0_arburst(NLW_inst_M_AXI_GP0_arburst_UNCONNECTED[1:0]),
        .M_AXI_GP0_arcache(NLW_inst_M_AXI_GP0_arcache_UNCONNECTED[3:0]),
        .M_AXI_GP0_arlen(NLW_inst_M_AXI_GP0_arlen_UNCONNECTED[7:0]),
        .M_AXI_GP0_arlock(NLW_inst_M_AXI_GP0_arlock_UNCONNECTED[0]),
        .M_AXI_GP0_arprot(NLW_inst_M_AXI_GP0_arprot_UNCONNECTED[2:0]),
        .M_AXI_GP0_arqos(NLW_inst_M_AXI_GP0_arqos_UNCONNECTED[3:0]),
        .M_AXI_GP0_arready(M_AXI_GP0_arready),
        .M_AXI_GP0_arsize(NLW_inst_M_AXI_GP0_arsize_UNCONNECTED[2:0]),
        .M_AXI_GP0_aruser(NLW_inst_M_AXI_GP0_aruser_UNCONNECTED[0]),
        .M_AXI_GP0_arvalid(M_AXI_GP0_arvalid),
        .M_AXI_GP0_awaddr(NLW_inst_M_AXI_GP0_awaddr_UNCONNECTED[39:0]),
        .M_AXI_GP0_awburst(NLW_inst_M_AXI_GP0_awburst_UNCONNECTED[1:0]),
        .M_AXI_GP0_awcache(NLW_inst_M_AXI_GP0_awcache_UNCONNECTED[3:0]),
        .M_AXI_GP0_awlen(NLW_inst_M_AXI_GP0_awlen_UNCONNECTED[7:0]),
        .M_AXI_GP0_awlock(NLW_inst_M_AXI_GP0_awlock_UNCONNECTED[0]),
        .M_AXI_GP0_awprot(NLW_inst_M_AXI_GP0_awprot_UNCONNECTED[2:0]),
        .M_AXI_GP0_awqos(NLW_inst_M_AXI_GP0_awqos_UNCONNECTED[3:0]),
        .M_AXI_GP0_awready(M_AXI_GP0_awready),
        .M_AXI_GP0_awsize(NLW_inst_M_AXI_GP0_awsize_UNCONNECTED[2:0]),
        .M_AXI_GP0_awuser(NLW_inst_M_AXI_GP0_awuser_UNCONNECTED[0]),
        .M_AXI_GP0_awvalid(NLW_inst_M_AXI_GP0_awvalid_UNCONNECTED),
        .M_AXI_GP0_bready(NLW_inst_M_AXI_GP0_bready_UNCONNECTED),
        .M_AXI_GP0_bresp({1'b0,1'b0}),
        .M_AXI_GP0_bvalid(1'b0),
        .M_AXI_GP0_rdata(M_AXI_GP0_rdata),
        .M_AXI_GP0_rlast(M_AXI_GP0_rlast),
        .M_AXI_GP0_rready(M_AXI_GP0_rready),
        .M_AXI_GP0_rresp({1'b0,1'b0}),
        .M_AXI_GP0_rvalid(M_AXI_GP0_rvalid),
        .M_AXI_GP0_wdata(NLW_inst_M_AXI_GP0_wdata_UNCONNECTED[31:0]),
        .M_AXI_GP0_wlast(NLW_inst_M_AXI_GP0_wlast_UNCONNECTED),
        .M_AXI_GP0_wready(M_AXI_GP0_wready),
        .M_AXI_GP0_wstrb(NLW_inst_M_AXI_GP0_wstrb_UNCONNECTED[3:0]),
        .M_AXI_GP0_wvalid(NLW_inst_M_AXI_GP0_wvalid_UNCONNECTED),
        .M_AXI_HP0_araddr(M_AXI_HP0_araddr),
        .M_AXI_HP0_arburst(NLW_inst_M_AXI_HP0_arburst_UNCONNECTED[1:0]),
        .M_AXI_HP0_arcache(NLW_inst_M_AXI_HP0_arcache_UNCONNECTED[3:0]),
        .M_AXI_HP0_arlen({NLW_inst_M_AXI_HP0_arlen_UNCONNECTED[7:4],\^M_AXI_HP0_arlen }),
        .M_AXI_HP0_arlock(NLW_inst_M_AXI_HP0_arlock_UNCONNECTED[0]),
        .M_AXI_HP0_arprot(NLW_inst_M_AXI_HP0_arprot_UNCONNECTED[2:0]),
        .M_AXI_HP0_arqos(NLW_inst_M_AXI_HP0_arqos_UNCONNECTED[3:0]),
        .M_AXI_HP0_arready(M_AXI_HP0_arready),
        .M_AXI_HP0_arsize(NLW_inst_M_AXI_HP0_arsize_UNCONNECTED[2:0]),
        .M_AXI_HP0_aruser(NLW_inst_M_AXI_HP0_aruser_UNCONNECTED[0]),
        .M_AXI_HP0_arvalid(M_AXI_HP0_arvalid),
        .M_AXI_HP0_awaddr(M_AXI_HP0_awaddr),
        .M_AXI_HP0_awburst(NLW_inst_M_AXI_HP0_awburst_UNCONNECTED[1:0]),
        .M_AXI_HP0_awcache(NLW_inst_M_AXI_HP0_awcache_UNCONNECTED[3:0]),
        .M_AXI_HP0_awlen(M_AXI_HP0_awlen),
        .M_AXI_HP0_awlock(NLW_inst_M_AXI_HP0_awlock_UNCONNECTED[0]),
        .M_AXI_HP0_awprot(NLW_inst_M_AXI_HP0_awprot_UNCONNECTED[2:0]),
        .M_AXI_HP0_awqos(NLW_inst_M_AXI_HP0_awqos_UNCONNECTED[3:0]),
        .M_AXI_HP0_awready(M_AXI_HP0_awready),
        .M_AXI_HP0_awsize(NLW_inst_M_AXI_HP0_awsize_UNCONNECTED[2:0]),
        .M_AXI_HP0_awuser(NLW_inst_M_AXI_HP0_awuser_UNCONNECTED[0]),
        .M_AXI_HP0_awvalid(M_AXI_HP0_awvalid),
        .M_AXI_HP0_bready(NLW_inst_M_AXI_HP0_bready_UNCONNECTED),
        .M_AXI_HP0_bresp({1'b0,1'b0}),
        .M_AXI_HP0_bvalid(M_AXI_HP0_bvalid),
        .M_AXI_HP0_rdata(M_AXI_HP0_rdata),
        .M_AXI_HP0_rlast(M_AXI_HP0_rlast),
        .M_AXI_HP0_rready(M_AXI_HP0_rready),
        .M_AXI_HP0_rresp({1'b0,1'b0}),
        .M_AXI_HP0_rvalid(M_AXI_HP0_rvalid),
        .M_AXI_HP0_wdata(M_AXI_HP0_wdata),
        .M_AXI_HP0_wlast(M_AXI_HP0_wlast),
        .M_AXI_HP0_wready(M_AXI_HP0_wready),
        .M_AXI_HP0_wstrb(M_AXI_HP0_wstrb),
        .M_AXI_HP0_wvalid(M_AXI_HP0_wvalid),
        .M_AXI_HP2_araddr(M_AXI_HP2_araddr),
        .M_AXI_HP2_arburst(NLW_inst_M_AXI_HP2_arburst_UNCONNECTED[1:0]),
        .M_AXI_HP2_arcache(NLW_inst_M_AXI_HP2_arcache_UNCONNECTED[3:0]),
        .M_AXI_HP2_arlen({NLW_inst_M_AXI_HP2_arlen_UNCONNECTED[7:4],\^M_AXI_HP2_arlen }),
        .M_AXI_HP2_arlock(NLW_inst_M_AXI_HP2_arlock_UNCONNECTED[0]),
        .M_AXI_HP2_arprot(NLW_inst_M_AXI_HP2_arprot_UNCONNECTED[2:0]),
        .M_AXI_HP2_arqos(NLW_inst_M_AXI_HP2_arqos_UNCONNECTED[3:0]),
        .M_AXI_HP2_arready(M_AXI_HP2_arready),
        .M_AXI_HP2_arsize(NLW_inst_M_AXI_HP2_arsize_UNCONNECTED[2:0]),
        .M_AXI_HP2_aruser(NLW_inst_M_AXI_HP2_aruser_UNCONNECTED[0]),
        .M_AXI_HP2_arvalid(M_AXI_HP2_arvalid),
        .M_AXI_HP2_awaddr(M_AXI_HP2_awaddr),
        .M_AXI_HP2_awburst(NLW_inst_M_AXI_HP2_awburst_UNCONNECTED[1:0]),
        .M_AXI_HP2_awcache(NLW_inst_M_AXI_HP2_awcache_UNCONNECTED[3:0]),
        .M_AXI_HP2_awlen(M_AXI_HP2_awlen),
        .M_AXI_HP2_awlock(NLW_inst_M_AXI_HP2_awlock_UNCONNECTED[0]),
        .M_AXI_HP2_awprot(NLW_inst_M_AXI_HP2_awprot_UNCONNECTED[2:0]),
        .M_AXI_HP2_awqos(NLW_inst_M_AXI_HP2_awqos_UNCONNECTED[3:0]),
        .M_AXI_HP2_awready(M_AXI_HP2_awready),
        .M_AXI_HP2_awsize(NLW_inst_M_AXI_HP2_awsize_UNCONNECTED[2:0]),
        .M_AXI_HP2_awuser(NLW_inst_M_AXI_HP2_awuser_UNCONNECTED[0]),
        .M_AXI_HP2_awvalid(M_AXI_HP2_awvalid),
        .M_AXI_HP2_bready(NLW_inst_M_AXI_HP2_bready_UNCONNECTED),
        .M_AXI_HP2_bresp({1'b0,1'b0}),
        .M_AXI_HP2_bvalid(M_AXI_HP2_bvalid),
        .M_AXI_HP2_rdata(M_AXI_HP2_rdata),
        .M_AXI_HP2_rlast(M_AXI_HP2_rlast),
        .M_AXI_HP2_rready(M_AXI_HP2_rready),
        .M_AXI_HP2_rresp({1'b0,1'b0}),
        .M_AXI_HP2_rvalid(M_AXI_HP2_rvalid),
        .M_AXI_HP2_wdata(M_AXI_HP2_wdata),
        .M_AXI_HP2_wlast(M_AXI_HP2_wlast),
        .M_AXI_HP2_wready(M_AXI_HP2_wready),
        .M_AXI_HP2_wstrb(M_AXI_HP2_wstrb),
        .M_AXI_HP2_wvalid(M_AXI_HP2_wvalid),
        .S_AXI_CONTROL_araddr(S_AXI_CONTROL_araddr),
        .S_AXI_CONTROL_arready(S_AXI_CONTROL_arready),
        .S_AXI_CONTROL_arvalid(S_AXI_CONTROL_arvalid),
        .S_AXI_CONTROL_awaddr(S_AXI_CONTROL_awaddr),
        .S_AXI_CONTROL_awready(S_AXI_CONTROL_awready),
        .S_AXI_CONTROL_awvalid(S_AXI_CONTROL_awvalid),
        .S_AXI_CONTROL_bready(S_AXI_CONTROL_bready),
        .S_AXI_CONTROL_bresp(NLW_inst_S_AXI_CONTROL_bresp_UNCONNECTED[1:0]),
        .S_AXI_CONTROL_bvalid(S_AXI_CONTROL_bvalid),
        .S_AXI_CONTROL_rdata(S_AXI_CONTROL_rdata),
        .S_AXI_CONTROL_rready(S_AXI_CONTROL_rready),
        .S_AXI_CONTROL_rresp(NLW_inst_S_AXI_CONTROL_rresp_UNCONNECTED[1:0]),
        .S_AXI_CONTROL_rvalid(S_AXI_CONTROL_rvalid),
        .S_AXI_CONTROL_wdata(S_AXI_CONTROL_wdata),
        .S_AXI_CONTROL_wready(S_AXI_CONTROL_wready),
        .S_AXI_CONTROL_wstrb({1'b0,1'b0,1'b0,S_AXI_CONTROL_wstrb[0]}),
        .S_AXI_CONTROL_wvalid(S_AXI_CONTROL_wvalid),
        .aclk(aclk),
        .ap_clk_2(ap_clk_2),
        .ap_rst_n_2(1'b0),
        .aresetn(aresetn),
        .interrupt(interrupt));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
