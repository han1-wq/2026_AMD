//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2022.1 (lin64) Build 3526262 Mon Apr 18 15:47:01 MDT 2022
//Date        : Wed Oct 14 01:29:08 2026
//Host        : ubuntu running 64-bit Ubuntu 20.04.1 LTS
//Command     : generate_target kv260_hardware_platform.bd
//Design      : kv260_hardware_platform
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "kv260_hardware_platform,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=kv260_hardware_platform,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=53,numReposBlks=38,numNonXlnxBlks=2,numHierBlks=15,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=2,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=Vitis,da_axi4_cnt=2,da_board_cnt=16,da_clkrst_cnt=12,da_zynq_ultra_ps_e_cnt=1,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "kv260_hardware_platform.hwdef" *) 
module kv260_hardware_platform
   ();

  wire [39:0]DPUCZDX8G_1_M_AXI_GP0_ARADDR;
  wire [1:0]DPUCZDX8G_1_M_AXI_GP0_ARBURST;
  wire [3:0]DPUCZDX8G_1_M_AXI_GP0_ARCACHE;
  wire [7:0]DPUCZDX8G_1_M_AXI_GP0_ARLEN;
  wire [0:0]DPUCZDX8G_1_M_AXI_GP0_ARLOCK;
  wire [2:0]DPUCZDX8G_1_M_AXI_GP0_ARPROT;
  wire [3:0]DPUCZDX8G_1_M_AXI_GP0_ARQOS;
  wire DPUCZDX8G_1_M_AXI_GP0_ARREADY;
  wire [2:0]DPUCZDX8G_1_M_AXI_GP0_ARSIZE;
  wire DPUCZDX8G_1_M_AXI_GP0_ARVALID;
  wire [39:0]DPUCZDX8G_1_M_AXI_GP0_AWADDR;
  wire [1:0]DPUCZDX8G_1_M_AXI_GP0_AWBURST;
  wire [3:0]DPUCZDX8G_1_M_AXI_GP0_AWCACHE;
  wire [7:0]DPUCZDX8G_1_M_AXI_GP0_AWLEN;
  wire [0:0]DPUCZDX8G_1_M_AXI_GP0_AWLOCK;
  wire [2:0]DPUCZDX8G_1_M_AXI_GP0_AWPROT;
  wire [3:0]DPUCZDX8G_1_M_AXI_GP0_AWQOS;
  wire DPUCZDX8G_1_M_AXI_GP0_AWREADY;
  wire [2:0]DPUCZDX8G_1_M_AXI_GP0_AWSIZE;
  wire DPUCZDX8G_1_M_AXI_GP0_AWVALID;
  wire DPUCZDX8G_1_M_AXI_GP0_BREADY;
  wire [1:0]DPUCZDX8G_1_M_AXI_GP0_BRESP;
  wire DPUCZDX8G_1_M_AXI_GP0_BVALID;
  wire [31:0]DPUCZDX8G_1_M_AXI_GP0_RDATA;
  wire DPUCZDX8G_1_M_AXI_GP0_RLAST;
  wire DPUCZDX8G_1_M_AXI_GP0_RREADY;
  wire [1:0]DPUCZDX8G_1_M_AXI_GP0_RRESP;
  wire DPUCZDX8G_1_M_AXI_GP0_RVALID;
  wire [31:0]DPUCZDX8G_1_M_AXI_GP0_WDATA;
  wire DPUCZDX8G_1_M_AXI_GP0_WLAST;
  wire DPUCZDX8G_1_M_AXI_GP0_WREADY;
  wire [3:0]DPUCZDX8G_1_M_AXI_GP0_WSTRB;
  wire DPUCZDX8G_1_M_AXI_GP0_WVALID;
  wire [39:0]DPUCZDX8G_1_M_AXI_HP0_ARADDR;
  wire [1:0]DPUCZDX8G_1_M_AXI_HP0_ARBURST;
  wire [3:0]DPUCZDX8G_1_M_AXI_HP0_ARCACHE;
  wire [7:0]DPUCZDX8G_1_M_AXI_HP0_ARLEN;
  wire [0:0]DPUCZDX8G_1_M_AXI_HP0_ARLOCK;
  wire [2:0]DPUCZDX8G_1_M_AXI_HP0_ARPROT;
  wire [3:0]DPUCZDX8G_1_M_AXI_HP0_ARQOS;
  wire DPUCZDX8G_1_M_AXI_HP0_ARREADY;
  wire [2:0]DPUCZDX8G_1_M_AXI_HP0_ARSIZE;
  wire [0:0]DPUCZDX8G_1_M_AXI_HP0_ARUSER;
  wire DPUCZDX8G_1_M_AXI_HP0_ARVALID;
  wire [39:0]DPUCZDX8G_1_M_AXI_HP0_AWADDR;
  wire [1:0]DPUCZDX8G_1_M_AXI_HP0_AWBURST;
  wire [3:0]DPUCZDX8G_1_M_AXI_HP0_AWCACHE;
  wire [7:0]DPUCZDX8G_1_M_AXI_HP0_AWLEN;
  wire [0:0]DPUCZDX8G_1_M_AXI_HP0_AWLOCK;
  wire [2:0]DPUCZDX8G_1_M_AXI_HP0_AWPROT;
  wire [3:0]DPUCZDX8G_1_M_AXI_HP0_AWQOS;
  wire DPUCZDX8G_1_M_AXI_HP0_AWREADY;
  wire [2:0]DPUCZDX8G_1_M_AXI_HP0_AWSIZE;
  wire [0:0]DPUCZDX8G_1_M_AXI_HP0_AWUSER;
  wire DPUCZDX8G_1_M_AXI_HP0_AWVALID;
  wire DPUCZDX8G_1_M_AXI_HP0_BREADY;
  wire [1:0]DPUCZDX8G_1_M_AXI_HP0_BRESP;
  wire DPUCZDX8G_1_M_AXI_HP0_BVALID;
  wire [127:0]DPUCZDX8G_1_M_AXI_HP0_RDATA;
  wire DPUCZDX8G_1_M_AXI_HP0_RLAST;
  wire DPUCZDX8G_1_M_AXI_HP0_RREADY;
  wire [1:0]DPUCZDX8G_1_M_AXI_HP0_RRESP;
  wire DPUCZDX8G_1_M_AXI_HP0_RVALID;
  wire [127:0]DPUCZDX8G_1_M_AXI_HP0_WDATA;
  wire DPUCZDX8G_1_M_AXI_HP0_WLAST;
  wire DPUCZDX8G_1_M_AXI_HP0_WREADY;
  wire [15:0]DPUCZDX8G_1_M_AXI_HP0_WSTRB;
  wire DPUCZDX8G_1_M_AXI_HP0_WVALID;
  wire [39:0]DPUCZDX8G_1_M_AXI_HP2_ARADDR;
  wire [1:0]DPUCZDX8G_1_M_AXI_HP2_ARBURST;
  wire [3:0]DPUCZDX8G_1_M_AXI_HP2_ARCACHE;
  wire [7:0]DPUCZDX8G_1_M_AXI_HP2_ARLEN;
  wire [0:0]DPUCZDX8G_1_M_AXI_HP2_ARLOCK;
  wire [2:0]DPUCZDX8G_1_M_AXI_HP2_ARPROT;
  wire [3:0]DPUCZDX8G_1_M_AXI_HP2_ARQOS;
  wire DPUCZDX8G_1_M_AXI_HP2_ARREADY;
  wire [2:0]DPUCZDX8G_1_M_AXI_HP2_ARSIZE;
  wire [0:0]DPUCZDX8G_1_M_AXI_HP2_ARUSER;
  wire DPUCZDX8G_1_M_AXI_HP2_ARVALID;
  wire [39:0]DPUCZDX8G_1_M_AXI_HP2_AWADDR;
  wire [1:0]DPUCZDX8G_1_M_AXI_HP2_AWBURST;
  wire [3:0]DPUCZDX8G_1_M_AXI_HP2_AWCACHE;
  wire [7:0]DPUCZDX8G_1_M_AXI_HP2_AWLEN;
  wire [0:0]DPUCZDX8G_1_M_AXI_HP2_AWLOCK;
  wire [2:0]DPUCZDX8G_1_M_AXI_HP2_AWPROT;
  wire [3:0]DPUCZDX8G_1_M_AXI_HP2_AWQOS;
  wire DPUCZDX8G_1_M_AXI_HP2_AWREADY;
  wire [2:0]DPUCZDX8G_1_M_AXI_HP2_AWSIZE;
  wire [0:0]DPUCZDX8G_1_M_AXI_HP2_AWUSER;
  wire DPUCZDX8G_1_M_AXI_HP2_AWVALID;
  wire DPUCZDX8G_1_M_AXI_HP2_BREADY;
  wire [1:0]DPUCZDX8G_1_M_AXI_HP2_BRESP;
  wire DPUCZDX8G_1_M_AXI_HP2_BVALID;
  wire [127:0]DPUCZDX8G_1_M_AXI_HP2_RDATA;
  wire DPUCZDX8G_1_M_AXI_HP2_RLAST;
  wire DPUCZDX8G_1_M_AXI_HP2_RREADY;
  wire [1:0]DPUCZDX8G_1_M_AXI_HP2_RRESP;
  wire DPUCZDX8G_1_M_AXI_HP2_RVALID;
  wire [127:0]DPUCZDX8G_1_M_AXI_HP2_WDATA;
  wire DPUCZDX8G_1_M_AXI_HP2_WLAST;
  wire DPUCZDX8G_1_M_AXI_HP2_WREADY;
  wire [15:0]DPUCZDX8G_1_M_AXI_HP2_WSTRB;
  wire DPUCZDX8G_1_M_AXI_HP2_WVALID;
  wire DPUCZDX8G_1_interrupt;
  wire [48:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_ARADDR;
  wire [1:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_ARBURST;
  wire [3:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_ARCACHE;
  wire [0:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_ARID;
  wire [7:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_ARLEN;
  wire [0:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_ARLOCK;
  wire [2:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_ARPROT;
  wire [3:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_ARQOS;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_ARREADY;
  wire [2:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_ARSIZE;
  wire [0:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_ARUSER;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_ARVALID;
  wire [48:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_AWADDR;
  wire [1:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_AWBURST;
  wire [3:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_AWCACHE;
  wire [0:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_AWID;
  wire [7:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_AWLEN;
  wire [0:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_AWLOCK;
  wire [2:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_AWPROT;
  wire [3:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_AWQOS;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_AWREADY;
  wire [2:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_AWSIZE;
  wire [0:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_AWUSER;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_AWVALID;
  wire [5:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_BID;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_BREADY;
  wire [1:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_BRESP;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_BVALID;
  wire [127:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_RDATA;
  wire [5:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_RID;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_RLAST;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_RREADY;
  wire [1:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_RRESP;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_RVALID;
  wire [127:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_WDATA;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_WLAST;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_WREADY;
  wire [15:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_WSTRB;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_WVALID;
  wire [39:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_ARADDR;
  wire [1:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_ARBURST;
  wire [3:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_ARCACHE;
  wire [7:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_ARLEN;
  wire [0:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_ARLOCK;
  wire [2:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_ARPROT;
  wire [3:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_ARQOS;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_ARREADY;
  wire [2:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_ARSIZE;
  wire [0:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_ARUSER;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_ARVALID;
  wire [39:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_AWADDR;
  wire [1:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_AWBURST;
  wire [3:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_AWCACHE;
  wire [7:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_AWLEN;
  wire [0:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_AWLOCK;
  wire [2:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_AWPROT;
  wire [3:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_AWQOS;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_AWREADY;
  wire [2:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_AWSIZE;
  wire [0:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_AWUSER;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_AWVALID;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_BREADY;
  wire [1:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_BRESP;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_BVALID;
  wire [127:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_RDATA;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_RLAST;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_RREADY;
  wire [1:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_RRESP;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_RVALID;
  wire [127:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_WDATA;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_WLAST;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_WREADY;
  wire [15:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_WSTRB;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_WVALID;
  wire [39:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_ARADDR;
  wire [1:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_ARBURST;
  wire [3:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_ARCACHE;
  wire [7:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_ARLEN;
  wire [0:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_ARLOCK;
  wire [2:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_ARPROT;
  wire [3:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_ARQOS;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_ARREADY;
  wire [2:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_ARSIZE;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_ARVALID;
  wire [39:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_AWADDR;
  wire [1:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_AWBURST;
  wire [3:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_AWCACHE;
  wire [7:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_AWLEN;
  wire [0:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_AWLOCK;
  wire [2:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_AWPROT;
  wire [3:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_AWQOS;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_AWREADY;
  wire [2:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_AWSIZE;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_AWVALID;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_BREADY;
  wire [1:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_BRESP;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_BVALID;
  wire [127:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_RDATA;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_RLAST;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_RREADY;
  wire [1:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_RRESP;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_RVALID;
  wire [127:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_WDATA;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_WLAST;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_WREADY;
  wire [15:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_WSTRB;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_WVALID;
  wire [31:0]axi_intc_0_intr_1_interrupt_concat_dout;
  wire axi_intc_0_irq;
  wire clk_wiz_1_clk_out1;
  wire clk_wiz_1_clk_out2;
  wire clk_wiz_1_clk_out3;
  wire clk_wiz_1_clk_out4;
  wire clk_wiz_1_clk_out5;
  wire clk_wiz_1_clk_out6;
  wire clk_wiz_1_locked;
  wire image_preprocess_1_interrupt;
  wire [63:0]image_preprocess_1_m_axi_gmem_in_ARADDR;
  wire [1:0]image_preprocess_1_m_axi_gmem_in_ARBURST;
  wire [3:0]image_preprocess_1_m_axi_gmem_in_ARCACHE;
  wire [7:0]image_preprocess_1_m_axi_gmem_in_ARLEN;
  wire [1:0]image_preprocess_1_m_axi_gmem_in_ARLOCK;
  wire [2:0]image_preprocess_1_m_axi_gmem_in_ARPROT;
  wire [3:0]image_preprocess_1_m_axi_gmem_in_ARQOS;
  wire image_preprocess_1_m_axi_gmem_in_ARREADY;
  wire [2:0]image_preprocess_1_m_axi_gmem_in_ARSIZE;
  wire image_preprocess_1_m_axi_gmem_in_ARVALID;
  wire [127:0]image_preprocess_1_m_axi_gmem_in_RDATA;
  wire image_preprocess_1_m_axi_gmem_in_RLAST;
  wire image_preprocess_1_m_axi_gmem_in_RREADY;
  wire [1:0]image_preprocess_1_m_axi_gmem_in_RRESP;
  wire image_preprocess_1_m_axi_gmem_in_RVALID;
  wire [63:0]image_preprocess_1_m_axi_gmem_out_AWADDR;
  wire [1:0]image_preprocess_1_m_axi_gmem_out_AWBURST;
  wire [3:0]image_preprocess_1_m_axi_gmem_out_AWCACHE;
  wire [7:0]image_preprocess_1_m_axi_gmem_out_AWLEN;
  wire [1:0]image_preprocess_1_m_axi_gmem_out_AWLOCK;
  wire [2:0]image_preprocess_1_m_axi_gmem_out_AWPROT;
  wire [3:0]image_preprocess_1_m_axi_gmem_out_AWQOS;
  wire image_preprocess_1_m_axi_gmem_out_AWREADY;
  wire [2:0]image_preprocess_1_m_axi_gmem_out_AWSIZE;
  wire image_preprocess_1_m_axi_gmem_out_AWVALID;
  wire image_preprocess_1_m_axi_gmem_out_BREADY;
  wire [1:0]image_preprocess_1_m_axi_gmem_out_BRESP;
  wire image_preprocess_1_m_axi_gmem_out_BVALID;
  wire [127:0]image_preprocess_1_m_axi_gmem_out_WDATA;
  wire image_preprocess_1_m_axi_gmem_out_WLAST;
  wire image_preprocess_1_m_axi_gmem_out_WREADY;
  wire [15:0]image_preprocess_1_m_axi_gmem_out_WSTRB;
  wire image_preprocess_1_m_axi_gmem_out_WVALID;
  wire [63:0]image_preprocess_1_m_axi_gmem_preview_AWADDR;
  wire [1:0]image_preprocess_1_m_axi_gmem_preview_AWBURST;
  wire [3:0]image_preprocess_1_m_axi_gmem_preview_AWCACHE;
  wire [7:0]image_preprocess_1_m_axi_gmem_preview_AWLEN;
  wire [1:0]image_preprocess_1_m_axi_gmem_preview_AWLOCK;
  wire [2:0]image_preprocess_1_m_axi_gmem_preview_AWPROT;
  wire [3:0]image_preprocess_1_m_axi_gmem_preview_AWQOS;
  wire image_preprocess_1_m_axi_gmem_preview_AWREADY;
  wire [2:0]image_preprocess_1_m_axi_gmem_preview_AWSIZE;
  wire image_preprocess_1_m_axi_gmem_preview_AWVALID;
  wire image_preprocess_1_m_axi_gmem_preview_BREADY;
  wire [1:0]image_preprocess_1_m_axi_gmem_preview_BRESP;
  wire image_preprocess_1_m_axi_gmem_preview_BVALID;
  wire [127:0]image_preprocess_1_m_axi_gmem_preview_WDATA;
  wire image_preprocess_1_m_axi_gmem_preview_WLAST;
  wire image_preprocess_1_m_axi_gmem_preview_WREADY;
  wire [15:0]image_preprocess_1_m_axi_gmem_preview_WSTRB;
  wire image_preprocess_1_m_axi_gmem_preview_WVALID;
  wire [0:0]irq_const_tieoff_dout;
  wire [0:0]proc_sys_reset_0_interconnect_aresetn;
  wire [0:0]proc_sys_reset_0_peripheral_aresetn;
  wire [0:0]proc_sys_reset_2_interconnect_aresetn;
  wire [0:0]proc_sys_reset_2_peripheral_aresetn;
  wire [0:0]proc_sys_reset_3_peripheral_aresetn;
  wire [0:0]proc_sys_reset_5_peripheral_aresetn;
  wire [39:0]ps8_0_axi_periph_M00_AXI_ARADDR;
  wire ps8_0_axi_periph_M00_AXI_ARREADY;
  wire [0:0]ps8_0_axi_periph_M00_AXI_ARVALID;
  wire [39:0]ps8_0_axi_periph_M00_AXI_AWADDR;
  wire ps8_0_axi_periph_M00_AXI_AWREADY;
  wire [0:0]ps8_0_axi_periph_M00_AXI_AWVALID;
  wire [0:0]ps8_0_axi_periph_M00_AXI_BREADY;
  wire [1:0]ps8_0_axi_periph_M00_AXI_BRESP;
  wire ps8_0_axi_periph_M00_AXI_BVALID;
  wire [31:0]ps8_0_axi_periph_M00_AXI_RDATA;
  wire [0:0]ps8_0_axi_periph_M00_AXI_RREADY;
  wire [1:0]ps8_0_axi_periph_M00_AXI_RRESP;
  wire ps8_0_axi_periph_M00_AXI_RVALID;
  wire [31:0]ps8_0_axi_periph_M00_AXI_WDATA;
  wire ps8_0_axi_periph_M00_AXI_WREADY;
  wire [3:0]ps8_0_axi_periph_M00_AXI_WSTRB;
  wire [0:0]ps8_0_axi_periph_M00_AXI_WVALID;
  wire [8:0]ps8_0_axi_periph_M01_AXI_ARADDR;
  wire ps8_0_axi_periph_M01_AXI_ARREADY;
  wire ps8_0_axi_periph_M01_AXI_ARVALID;
  wire [8:0]ps8_0_axi_periph_M01_AXI_AWADDR;
  wire ps8_0_axi_periph_M01_AXI_AWREADY;
  wire ps8_0_axi_periph_M01_AXI_AWVALID;
  wire ps8_0_axi_periph_M01_AXI_BREADY;
  wire [1:0]ps8_0_axi_periph_M01_AXI_BRESP;
  wire ps8_0_axi_periph_M01_AXI_BVALID;
  wire [31:0]ps8_0_axi_periph_M01_AXI_RDATA;
  wire ps8_0_axi_periph_M01_AXI_RREADY;
  wire [1:0]ps8_0_axi_periph_M01_AXI_RRESP;
  wire ps8_0_axi_periph_M01_AXI_RVALID;
  wire [31:0]ps8_0_axi_periph_M01_AXI_WDATA;
  wire ps8_0_axi_periph_M01_AXI_WREADY;
  wire [3:0]ps8_0_axi_periph_M01_AXI_WSTRB;
  wire ps8_0_axi_periph_M01_AXI_WVALID;
  wire [7:0]ps8_0_axi_periph_M02_AXI_ARADDR;
  wire ps8_0_axi_periph_M02_AXI_ARREADY;
  wire ps8_0_axi_periph_M02_AXI_ARVALID;
  wire [7:0]ps8_0_axi_periph_M02_AXI_AWADDR;
  wire ps8_0_axi_periph_M02_AXI_AWREADY;
  wire ps8_0_axi_periph_M02_AXI_AWVALID;
  wire ps8_0_axi_periph_M02_AXI_BREADY;
  wire [1:0]ps8_0_axi_periph_M02_AXI_BRESP;
  wire ps8_0_axi_periph_M02_AXI_BVALID;
  wire [31:0]ps8_0_axi_periph_M02_AXI_RDATA;
  wire ps8_0_axi_periph_M02_AXI_RREADY;
  wire [1:0]ps8_0_axi_periph_M02_AXI_RRESP;
  wire ps8_0_axi_periph_M02_AXI_RVALID;
  wire [31:0]ps8_0_axi_periph_M02_AXI_WDATA;
  wire ps8_0_axi_periph_M02_AXI_WREADY;
  wire [3:0]ps8_0_axi_periph_M02_AXI_WSTRB;
  wire ps8_0_axi_periph_M02_AXI_WVALID;
  wire [11:0]ps8_0_axi_periph_M03_AXI_ARADDR;
  wire ps8_0_axi_periph_M03_AXI_ARREADY;
  wire ps8_0_axi_periph_M03_AXI_ARVALID;
  wire [11:0]ps8_0_axi_periph_M03_AXI_AWADDR;
  wire ps8_0_axi_periph_M03_AXI_AWREADY;
  wire ps8_0_axi_periph_M03_AXI_AWVALID;
  wire ps8_0_axi_periph_M03_AXI_BREADY;
  wire [1:0]ps8_0_axi_periph_M03_AXI_BRESP;
  wire ps8_0_axi_periph_M03_AXI_BVALID;
  wire [31:0]ps8_0_axi_periph_M03_AXI_RDATA;
  wire ps8_0_axi_periph_M03_AXI_RREADY;
  wire [1:0]ps8_0_axi_periph_M03_AXI_RRESP;
  wire ps8_0_axi_periph_M03_AXI_RVALID;
  wire [31:0]ps8_0_axi_periph_M03_AXI_WDATA;
  wire ps8_0_axi_periph_M03_AXI_WREADY;
  wire [3:0]ps8_0_axi_periph_M03_AXI_WSTRB;
  wire ps8_0_axi_periph_M03_AXI_WVALID;
  wire [11:0]ps8_0_axi_periph_M04_AXI_ARADDR;
  wire ps8_0_axi_periph_M04_AXI_ARREADY;
  wire ps8_0_axi_periph_M04_AXI_ARVALID;
  wire [11:0]ps8_0_axi_periph_M04_AXI_AWADDR;
  wire ps8_0_axi_periph_M04_AXI_AWREADY;
  wire ps8_0_axi_periph_M04_AXI_AWVALID;
  wire ps8_0_axi_periph_M04_AXI_BREADY;
  wire [1:0]ps8_0_axi_periph_M04_AXI_BRESP;
  wire ps8_0_axi_periph_M04_AXI_BVALID;
  wire [31:0]ps8_0_axi_periph_M04_AXI_RDATA;
  wire ps8_0_axi_periph_M04_AXI_RREADY;
  wire [1:0]ps8_0_axi_periph_M04_AXI_RRESP;
  wire ps8_0_axi_periph_M04_AXI_RVALID;
  wire [31:0]ps8_0_axi_periph_M04_AXI_WDATA;
  wire ps8_0_axi_periph_M04_AXI_WREADY;
  wire [3:0]ps8_0_axi_periph_M04_AXI_WSTRB;
  wire ps8_0_axi_periph_M04_AXI_WVALID;
  wire [0:0]rst_ps8_0_99M_peripheral_aresetn;
  wire [31:0]sfm_xrt_top_1_M_AXI_ARADDR;
  wire [1:0]sfm_xrt_top_1_M_AXI_ARBURST;
  wire [3:0]sfm_xrt_top_1_M_AXI_ARCACHE;
  wire [7:0]sfm_xrt_top_1_M_AXI_ARLEN;
  wire [0:0]sfm_xrt_top_1_M_AXI_ARLOCK;
  wire [2:0]sfm_xrt_top_1_M_AXI_ARPROT;
  wire [3:0]sfm_xrt_top_1_M_AXI_ARQOS;
  wire sfm_xrt_top_1_M_AXI_ARREADY;
  wire [2:0]sfm_xrt_top_1_M_AXI_ARSIZE;
  wire sfm_xrt_top_1_M_AXI_ARVALID;
  wire [31:0]sfm_xrt_top_1_M_AXI_AWADDR;
  wire [1:0]sfm_xrt_top_1_M_AXI_AWBURST;
  wire [3:0]sfm_xrt_top_1_M_AXI_AWCACHE;
  wire [7:0]sfm_xrt_top_1_M_AXI_AWLEN;
  wire [0:0]sfm_xrt_top_1_M_AXI_AWLOCK;
  wire [2:0]sfm_xrt_top_1_M_AXI_AWPROT;
  wire [3:0]sfm_xrt_top_1_M_AXI_AWQOS;
  wire sfm_xrt_top_1_M_AXI_AWREADY;
  wire [2:0]sfm_xrt_top_1_M_AXI_AWSIZE;
  wire sfm_xrt_top_1_M_AXI_AWVALID;
  wire sfm_xrt_top_1_M_AXI_BREADY;
  wire [1:0]sfm_xrt_top_1_M_AXI_BRESP;
  wire sfm_xrt_top_1_M_AXI_BVALID;
  wire [127:0]sfm_xrt_top_1_M_AXI_RDATA;
  wire sfm_xrt_top_1_M_AXI_RLAST;
  wire sfm_xrt_top_1_M_AXI_RREADY;
  wire [1:0]sfm_xrt_top_1_M_AXI_RRESP;
  wire sfm_xrt_top_1_M_AXI_RVALID;
  wire [127:0]sfm_xrt_top_1_M_AXI_WDATA;
  wire sfm_xrt_top_1_M_AXI_WLAST;
  wire sfm_xrt_top_1_M_AXI_WREADY;
  wire [15:0]sfm_xrt_top_1_M_AXI_WSTRB;
  wire sfm_xrt_top_1_M_AXI_WVALID;
  wire sfm_xrt_top_1_interrupt;
  wire [7:0]vision_irq_concat_dout;
  wire [5:0]vision_irq_zero_dout;
  wire [48:0]vision_read_sc_M00_AXI_ARADDR;
  wire [1:0]vision_read_sc_M00_AXI_ARBURST;
  wire [3:0]vision_read_sc_M00_AXI_ARCACHE;
  wire [7:0]vision_read_sc_M00_AXI_ARLEN;
  wire [0:0]vision_read_sc_M00_AXI_ARLOCK;
  wire [2:0]vision_read_sc_M00_AXI_ARPROT;
  wire [3:0]vision_read_sc_M00_AXI_ARQOS;
  wire vision_read_sc_M00_AXI_ARREADY;
  wire [2:0]vision_read_sc_M00_AXI_ARSIZE;
  wire vision_read_sc_M00_AXI_ARVALID;
  wire [127:0]vision_read_sc_M00_AXI_RDATA;
  wire vision_read_sc_M00_AXI_RLAST;
  wire vision_read_sc_M00_AXI_RREADY;
  wire [1:0]vision_read_sc_M00_AXI_RRESP;
  wire vision_read_sc_M00_AXI_RVALID;
  wire [48:0]vision_write_sc_M00_AXI_AWADDR;
  wire [1:0]vision_write_sc_M00_AXI_AWBURST;
  wire [3:0]vision_write_sc_M00_AXI_AWCACHE;
  wire [7:0]vision_write_sc_M00_AXI_AWLEN;
  wire [0:0]vision_write_sc_M00_AXI_AWLOCK;
  wire [2:0]vision_write_sc_M00_AXI_AWPROT;
  wire [3:0]vision_write_sc_M00_AXI_AWQOS;
  wire vision_write_sc_M00_AXI_AWREADY;
  wire [2:0]vision_write_sc_M00_AXI_AWSIZE;
  wire vision_write_sc_M00_AXI_AWVALID;
  wire vision_write_sc_M00_AXI_BREADY;
  wire [1:0]vision_write_sc_M00_AXI_BRESP;
  wire vision_write_sc_M00_AXI_BVALID;
  wire [127:0]vision_write_sc_M00_AXI_WDATA;
  wire vision_write_sc_M00_AXI_WLAST;
  wire vision_write_sc_M00_AXI_WREADY;
  wire [15:0]vision_write_sc_M00_AXI_WSTRB;
  wire vision_write_sc_M00_AXI_WVALID;
  wire yolo_postprocess_1_interrupt;
  wire [63:0]yolo_postprocess_1_m_axi_gmem_in_ARADDR;
  wire [1:0]yolo_postprocess_1_m_axi_gmem_in_ARBURST;
  wire [3:0]yolo_postprocess_1_m_axi_gmem_in_ARCACHE;
  wire [7:0]yolo_postprocess_1_m_axi_gmem_in_ARLEN;
  wire [1:0]yolo_postprocess_1_m_axi_gmem_in_ARLOCK;
  wire [2:0]yolo_postprocess_1_m_axi_gmem_in_ARPROT;
  wire [3:0]yolo_postprocess_1_m_axi_gmem_in_ARQOS;
  wire yolo_postprocess_1_m_axi_gmem_in_ARREADY;
  wire [2:0]yolo_postprocess_1_m_axi_gmem_in_ARSIZE;
  wire yolo_postprocess_1_m_axi_gmem_in_ARVALID;
  wire [127:0]yolo_postprocess_1_m_axi_gmem_in_RDATA;
  wire yolo_postprocess_1_m_axi_gmem_in_RLAST;
  wire yolo_postprocess_1_m_axi_gmem_in_RREADY;
  wire [1:0]yolo_postprocess_1_m_axi_gmem_in_RRESP;
  wire yolo_postprocess_1_m_axi_gmem_in_RVALID;
  wire [63:0]yolo_postprocess_1_m_axi_gmem_out_AWADDR;
  wire [1:0]yolo_postprocess_1_m_axi_gmem_out_AWBURST;
  wire [3:0]yolo_postprocess_1_m_axi_gmem_out_AWCACHE;
  wire [7:0]yolo_postprocess_1_m_axi_gmem_out_AWLEN;
  wire [1:0]yolo_postprocess_1_m_axi_gmem_out_AWLOCK;
  wire [2:0]yolo_postprocess_1_m_axi_gmem_out_AWPROT;
  wire [3:0]yolo_postprocess_1_m_axi_gmem_out_AWQOS;
  wire yolo_postprocess_1_m_axi_gmem_out_AWREADY;
  wire [2:0]yolo_postprocess_1_m_axi_gmem_out_AWSIZE;
  wire yolo_postprocess_1_m_axi_gmem_out_AWVALID;
  wire yolo_postprocess_1_m_axi_gmem_out_BREADY;
  wire [1:0]yolo_postprocess_1_m_axi_gmem_out_BRESP;
  wire yolo_postprocess_1_m_axi_gmem_out_BVALID;
  wire [255:0]yolo_postprocess_1_m_axi_gmem_out_WDATA;
  wire yolo_postprocess_1_m_axi_gmem_out_WLAST;
  wire yolo_postprocess_1_m_axi_gmem_out_WREADY;
  wire [31:0]yolo_postprocess_1_m_axi_gmem_out_WSTRB;
  wire yolo_postprocess_1_m_axi_gmem_out_WVALID;
  wire [39:0]zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_ARADDR;
  wire [1:0]zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_ARBURST;
  wire [3:0]zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_ARCACHE;
  wire [15:0]zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_ARID;
  wire [7:0]zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_ARLEN;
  wire zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_ARLOCK;
  wire [2:0]zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_ARPROT;
  wire [3:0]zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_ARQOS;
  wire zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_ARREADY;
  wire [2:0]zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_ARSIZE;
  wire zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_ARVALID;
  wire [39:0]zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_AWADDR;
  wire [1:0]zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_AWBURST;
  wire [3:0]zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_AWCACHE;
  wire [15:0]zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_AWID;
  wire [7:0]zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_AWLEN;
  wire zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_AWLOCK;
  wire [2:0]zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_AWPROT;
  wire [3:0]zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_AWQOS;
  wire zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_AWREADY;
  wire [2:0]zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_AWSIZE;
  wire zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_AWVALID;
  wire [15:0]zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_BID;
  wire zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_BREADY;
  wire [1:0]zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_BRESP;
  wire zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_BVALID;
  wire [31:0]zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_RDATA;
  wire [15:0]zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_RID;
  wire zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_RLAST;
  wire zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_RREADY;
  wire [1:0]zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_RRESP;
  wire zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_RVALID;
  wire [31:0]zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_WDATA;
  wire zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_WLAST;
  wire zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_WREADY;
  wire [3:0]zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_WSTRB;
  wire zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_WVALID;
  wire zynq_ultra_ps_e_0_pl_clk0;
  wire zynq_ultra_ps_e_0_pl_resetn0;

  (* \aclk.FREQ_HZ  = "300000000" *) 
  (* \aclk.FREQ_HZ_TOLERANCE  = "15000000" *) 
  (* \ap_clk_2.FREQ_HZ  = "600000000" *) 
  (* \ap_clk_2.FREQ_HZ_TOLERANCE  = "30000000" *) 
  kv260_hardware_platform_DPUCZDX8G_1_0 DPUCZDX8G_1
       (.M_AXI_GP0_araddr(DPUCZDX8G_1_M_AXI_GP0_ARADDR),
        .M_AXI_GP0_arburst(DPUCZDX8G_1_M_AXI_GP0_ARBURST),
        .M_AXI_GP0_arcache(DPUCZDX8G_1_M_AXI_GP0_ARCACHE),
        .M_AXI_GP0_arlen(DPUCZDX8G_1_M_AXI_GP0_ARLEN),
        .M_AXI_GP0_arlock(DPUCZDX8G_1_M_AXI_GP0_ARLOCK),
        .M_AXI_GP0_arprot(DPUCZDX8G_1_M_AXI_GP0_ARPROT),
        .M_AXI_GP0_arqos(DPUCZDX8G_1_M_AXI_GP0_ARQOS),
        .M_AXI_GP0_arready(DPUCZDX8G_1_M_AXI_GP0_ARREADY),
        .M_AXI_GP0_arsize(DPUCZDX8G_1_M_AXI_GP0_ARSIZE),
        .M_AXI_GP0_arvalid(DPUCZDX8G_1_M_AXI_GP0_ARVALID),
        .M_AXI_GP0_awaddr(DPUCZDX8G_1_M_AXI_GP0_AWADDR),
        .M_AXI_GP0_awburst(DPUCZDX8G_1_M_AXI_GP0_AWBURST),
        .M_AXI_GP0_awcache(DPUCZDX8G_1_M_AXI_GP0_AWCACHE),
        .M_AXI_GP0_awlen(DPUCZDX8G_1_M_AXI_GP0_AWLEN),
        .M_AXI_GP0_awlock(DPUCZDX8G_1_M_AXI_GP0_AWLOCK),
        .M_AXI_GP0_awprot(DPUCZDX8G_1_M_AXI_GP0_AWPROT),
        .M_AXI_GP0_awqos(DPUCZDX8G_1_M_AXI_GP0_AWQOS),
        .M_AXI_GP0_awready(DPUCZDX8G_1_M_AXI_GP0_AWREADY),
        .M_AXI_GP0_awsize(DPUCZDX8G_1_M_AXI_GP0_AWSIZE),
        .M_AXI_GP0_awvalid(DPUCZDX8G_1_M_AXI_GP0_AWVALID),
        .M_AXI_GP0_bready(DPUCZDX8G_1_M_AXI_GP0_BREADY),
        .M_AXI_GP0_bresp(DPUCZDX8G_1_M_AXI_GP0_BRESP),
        .M_AXI_GP0_bvalid(DPUCZDX8G_1_M_AXI_GP0_BVALID),
        .M_AXI_GP0_rdata(DPUCZDX8G_1_M_AXI_GP0_RDATA),
        .M_AXI_GP0_rlast(DPUCZDX8G_1_M_AXI_GP0_RLAST),
        .M_AXI_GP0_rready(DPUCZDX8G_1_M_AXI_GP0_RREADY),
        .M_AXI_GP0_rresp(DPUCZDX8G_1_M_AXI_GP0_RRESP),
        .M_AXI_GP0_rvalid(DPUCZDX8G_1_M_AXI_GP0_RVALID),
        .M_AXI_GP0_wdata(DPUCZDX8G_1_M_AXI_GP0_WDATA),
        .M_AXI_GP0_wlast(DPUCZDX8G_1_M_AXI_GP0_WLAST),
        .M_AXI_GP0_wready(DPUCZDX8G_1_M_AXI_GP0_WREADY),
        .M_AXI_GP0_wstrb(DPUCZDX8G_1_M_AXI_GP0_WSTRB),
        .M_AXI_GP0_wvalid(DPUCZDX8G_1_M_AXI_GP0_WVALID),
        .M_AXI_HP0_araddr(DPUCZDX8G_1_M_AXI_HP0_ARADDR),
        .M_AXI_HP0_arburst(DPUCZDX8G_1_M_AXI_HP0_ARBURST),
        .M_AXI_HP0_arcache(DPUCZDX8G_1_M_AXI_HP0_ARCACHE),
        .M_AXI_HP0_arlen(DPUCZDX8G_1_M_AXI_HP0_ARLEN),
        .M_AXI_HP0_arlock(DPUCZDX8G_1_M_AXI_HP0_ARLOCK),
        .M_AXI_HP0_arprot(DPUCZDX8G_1_M_AXI_HP0_ARPROT),
        .M_AXI_HP0_arqos(DPUCZDX8G_1_M_AXI_HP0_ARQOS),
        .M_AXI_HP0_arready(DPUCZDX8G_1_M_AXI_HP0_ARREADY),
        .M_AXI_HP0_arsize(DPUCZDX8G_1_M_AXI_HP0_ARSIZE),
        .M_AXI_HP0_aruser(DPUCZDX8G_1_M_AXI_HP0_ARUSER),
        .M_AXI_HP0_arvalid(DPUCZDX8G_1_M_AXI_HP0_ARVALID),
        .M_AXI_HP0_awaddr(DPUCZDX8G_1_M_AXI_HP0_AWADDR),
        .M_AXI_HP0_awburst(DPUCZDX8G_1_M_AXI_HP0_AWBURST),
        .M_AXI_HP0_awcache(DPUCZDX8G_1_M_AXI_HP0_AWCACHE),
        .M_AXI_HP0_awlen(DPUCZDX8G_1_M_AXI_HP0_AWLEN),
        .M_AXI_HP0_awlock(DPUCZDX8G_1_M_AXI_HP0_AWLOCK),
        .M_AXI_HP0_awprot(DPUCZDX8G_1_M_AXI_HP0_AWPROT),
        .M_AXI_HP0_awqos(DPUCZDX8G_1_M_AXI_HP0_AWQOS),
        .M_AXI_HP0_awready(DPUCZDX8G_1_M_AXI_HP0_AWREADY),
        .M_AXI_HP0_awsize(DPUCZDX8G_1_M_AXI_HP0_AWSIZE),
        .M_AXI_HP0_awuser(DPUCZDX8G_1_M_AXI_HP0_AWUSER),
        .M_AXI_HP0_awvalid(DPUCZDX8G_1_M_AXI_HP0_AWVALID),
        .M_AXI_HP0_bready(DPUCZDX8G_1_M_AXI_HP0_BREADY),
        .M_AXI_HP0_bresp(DPUCZDX8G_1_M_AXI_HP0_BRESP),
        .M_AXI_HP0_bvalid(DPUCZDX8G_1_M_AXI_HP0_BVALID),
        .M_AXI_HP0_rdata(DPUCZDX8G_1_M_AXI_HP0_RDATA),
        .M_AXI_HP0_rlast(DPUCZDX8G_1_M_AXI_HP0_RLAST),
        .M_AXI_HP0_rready(DPUCZDX8G_1_M_AXI_HP0_RREADY),
        .M_AXI_HP0_rresp(DPUCZDX8G_1_M_AXI_HP0_RRESP),
        .M_AXI_HP0_rvalid(DPUCZDX8G_1_M_AXI_HP0_RVALID),
        .M_AXI_HP0_wdata(DPUCZDX8G_1_M_AXI_HP0_WDATA),
        .M_AXI_HP0_wlast(DPUCZDX8G_1_M_AXI_HP0_WLAST),
        .M_AXI_HP0_wready(DPUCZDX8G_1_M_AXI_HP0_WREADY),
        .M_AXI_HP0_wstrb(DPUCZDX8G_1_M_AXI_HP0_WSTRB),
        .M_AXI_HP0_wvalid(DPUCZDX8G_1_M_AXI_HP0_WVALID),
        .M_AXI_HP2_araddr(DPUCZDX8G_1_M_AXI_HP2_ARADDR),
        .M_AXI_HP2_arburst(DPUCZDX8G_1_M_AXI_HP2_ARBURST),
        .M_AXI_HP2_arcache(DPUCZDX8G_1_M_AXI_HP2_ARCACHE),
        .M_AXI_HP2_arlen(DPUCZDX8G_1_M_AXI_HP2_ARLEN),
        .M_AXI_HP2_arlock(DPUCZDX8G_1_M_AXI_HP2_ARLOCK),
        .M_AXI_HP2_arprot(DPUCZDX8G_1_M_AXI_HP2_ARPROT),
        .M_AXI_HP2_arqos(DPUCZDX8G_1_M_AXI_HP2_ARQOS),
        .M_AXI_HP2_arready(DPUCZDX8G_1_M_AXI_HP2_ARREADY),
        .M_AXI_HP2_arsize(DPUCZDX8G_1_M_AXI_HP2_ARSIZE),
        .M_AXI_HP2_aruser(DPUCZDX8G_1_M_AXI_HP2_ARUSER),
        .M_AXI_HP2_arvalid(DPUCZDX8G_1_M_AXI_HP2_ARVALID),
        .M_AXI_HP2_awaddr(DPUCZDX8G_1_M_AXI_HP2_AWADDR),
        .M_AXI_HP2_awburst(DPUCZDX8G_1_M_AXI_HP2_AWBURST),
        .M_AXI_HP2_awcache(DPUCZDX8G_1_M_AXI_HP2_AWCACHE),
        .M_AXI_HP2_awlen(DPUCZDX8G_1_M_AXI_HP2_AWLEN),
        .M_AXI_HP2_awlock(DPUCZDX8G_1_M_AXI_HP2_AWLOCK),
        .M_AXI_HP2_awprot(DPUCZDX8G_1_M_AXI_HP2_AWPROT),
        .M_AXI_HP2_awqos(DPUCZDX8G_1_M_AXI_HP2_AWQOS),
        .M_AXI_HP2_awready(DPUCZDX8G_1_M_AXI_HP2_AWREADY),
        .M_AXI_HP2_awsize(DPUCZDX8G_1_M_AXI_HP2_AWSIZE),
        .M_AXI_HP2_awuser(DPUCZDX8G_1_M_AXI_HP2_AWUSER),
        .M_AXI_HP2_awvalid(DPUCZDX8G_1_M_AXI_HP2_AWVALID),
        .M_AXI_HP2_bready(DPUCZDX8G_1_M_AXI_HP2_BREADY),
        .M_AXI_HP2_bresp(DPUCZDX8G_1_M_AXI_HP2_BRESP),
        .M_AXI_HP2_bvalid(DPUCZDX8G_1_M_AXI_HP2_BVALID),
        .M_AXI_HP2_rdata(DPUCZDX8G_1_M_AXI_HP2_RDATA),
        .M_AXI_HP2_rlast(DPUCZDX8G_1_M_AXI_HP2_RLAST),
        .M_AXI_HP2_rready(DPUCZDX8G_1_M_AXI_HP2_RREADY),
        .M_AXI_HP2_rresp(DPUCZDX8G_1_M_AXI_HP2_RRESP),
        .M_AXI_HP2_rvalid(DPUCZDX8G_1_M_AXI_HP2_RVALID),
        .M_AXI_HP2_wdata(DPUCZDX8G_1_M_AXI_HP2_WDATA),
        .M_AXI_HP2_wlast(DPUCZDX8G_1_M_AXI_HP2_WLAST),
        .M_AXI_HP2_wready(DPUCZDX8G_1_M_AXI_HP2_WREADY),
        .M_AXI_HP2_wstrb(DPUCZDX8G_1_M_AXI_HP2_WSTRB),
        .M_AXI_HP2_wvalid(DPUCZDX8G_1_M_AXI_HP2_WVALID),
        .S_AXI_CONTROL_araddr(ps8_0_axi_periph_M03_AXI_ARADDR),
        .S_AXI_CONTROL_arready(ps8_0_axi_periph_M03_AXI_ARREADY),
        .S_AXI_CONTROL_arvalid(ps8_0_axi_periph_M03_AXI_ARVALID),
        .S_AXI_CONTROL_awaddr(ps8_0_axi_periph_M03_AXI_AWADDR),
        .S_AXI_CONTROL_awready(ps8_0_axi_periph_M03_AXI_AWREADY),
        .S_AXI_CONTROL_awvalid(ps8_0_axi_periph_M03_AXI_AWVALID),
        .S_AXI_CONTROL_bready(ps8_0_axi_periph_M03_AXI_BREADY),
        .S_AXI_CONTROL_bresp(ps8_0_axi_periph_M03_AXI_BRESP),
        .S_AXI_CONTROL_bvalid(ps8_0_axi_periph_M03_AXI_BVALID),
        .S_AXI_CONTROL_rdata(ps8_0_axi_periph_M03_AXI_RDATA),
        .S_AXI_CONTROL_rready(ps8_0_axi_periph_M03_AXI_RREADY),
        .S_AXI_CONTROL_rresp(ps8_0_axi_periph_M03_AXI_RRESP),
        .S_AXI_CONTROL_rvalid(ps8_0_axi_periph_M03_AXI_RVALID),
        .S_AXI_CONTROL_wdata(ps8_0_axi_periph_M03_AXI_WDATA),
        .S_AXI_CONTROL_wready(ps8_0_axi_periph_M03_AXI_WREADY),
        .S_AXI_CONTROL_wstrb(ps8_0_axi_periph_M03_AXI_WSTRB),
        .S_AXI_CONTROL_wvalid(ps8_0_axi_periph_M03_AXI_WVALID),
        .aclk(clk_wiz_1_clk_out4),
        .ap_clk_2(clk_wiz_1_clk_out6),
        .ap_rst_n_2(proc_sys_reset_5_peripheral_aresetn),
        .aresetn(proc_sys_reset_3_peripheral_aresetn),
        .interrupt(DPUCZDX8G_1_interrupt));
  kv260_hardware_platform_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_0 axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD
       (.ACLK(clk_wiz_1_clk_out1),
        .ARESETN(proc_sys_reset_0_peripheral_aresetn),
        .M00_ACLK(clk_wiz_1_clk_out4),
        .M00_ARESETN(proc_sys_reset_3_peripheral_aresetn),
        .M00_AXI_araddr(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_ARADDR),
        .M00_AXI_arburst(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_ARBURST),
        .M00_AXI_arcache(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_ARCACHE),
        .M00_AXI_arid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_ARID),
        .M00_AXI_arlen(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_ARLEN),
        .M00_AXI_arlock(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_ARLOCK),
        .M00_AXI_arprot(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_ARPROT),
        .M00_AXI_arqos(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_ARQOS),
        .M00_AXI_arready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_ARREADY),
        .M00_AXI_arsize(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_ARSIZE),
        .M00_AXI_aruser(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_ARUSER),
        .M00_AXI_arvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_ARVALID),
        .M00_AXI_awaddr(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_AWADDR),
        .M00_AXI_awburst(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_AWBURST),
        .M00_AXI_awcache(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_AWCACHE),
        .M00_AXI_awid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_AWID),
        .M00_AXI_awlen(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_AWLEN),
        .M00_AXI_awlock(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_AWLOCK),
        .M00_AXI_awprot(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_AWPROT),
        .M00_AXI_awqos(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_AWQOS),
        .M00_AXI_awready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_AWREADY),
        .M00_AXI_awsize(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_AWSIZE),
        .M00_AXI_awuser(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_AWUSER),
        .M00_AXI_awvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_AWVALID),
        .M00_AXI_bid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_BID),
        .M00_AXI_bready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_BREADY),
        .M00_AXI_bresp(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_BRESP),
        .M00_AXI_bvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_BVALID),
        .M00_AXI_rdata(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_RDATA),
        .M00_AXI_rid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_RID),
        .M00_AXI_rlast(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_RLAST),
        .M00_AXI_rready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_RREADY),
        .M00_AXI_rresp(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_RRESP),
        .M00_AXI_rvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_RVALID),
        .M00_AXI_wdata(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_WDATA),
        .M00_AXI_wlast(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_WLAST),
        .M00_AXI_wready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_WREADY),
        .M00_AXI_wstrb(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_WSTRB),
        .M00_AXI_wvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_WVALID),
        .S00_ACLK(clk_wiz_1_clk_out4),
        .S00_ARESETN(proc_sys_reset_3_peripheral_aresetn),
        .S00_AXI_araddr(DPUCZDX8G_1_M_AXI_HP0_ARADDR),
        .S00_AXI_arburst(DPUCZDX8G_1_M_AXI_HP0_ARBURST),
        .S00_AXI_arcache(DPUCZDX8G_1_M_AXI_HP0_ARCACHE),
        .S00_AXI_arlen(DPUCZDX8G_1_M_AXI_HP0_ARLEN),
        .S00_AXI_arlock(DPUCZDX8G_1_M_AXI_HP0_ARLOCK),
        .S00_AXI_arprot(DPUCZDX8G_1_M_AXI_HP0_ARPROT),
        .S00_AXI_arqos(DPUCZDX8G_1_M_AXI_HP0_ARQOS),
        .S00_AXI_arready(DPUCZDX8G_1_M_AXI_HP0_ARREADY),
        .S00_AXI_arsize(DPUCZDX8G_1_M_AXI_HP0_ARSIZE),
        .S00_AXI_aruser(DPUCZDX8G_1_M_AXI_HP0_ARUSER),
        .S00_AXI_arvalid(DPUCZDX8G_1_M_AXI_HP0_ARVALID),
        .S00_AXI_awaddr(DPUCZDX8G_1_M_AXI_HP0_AWADDR),
        .S00_AXI_awburst(DPUCZDX8G_1_M_AXI_HP0_AWBURST),
        .S00_AXI_awcache(DPUCZDX8G_1_M_AXI_HP0_AWCACHE),
        .S00_AXI_awlen(DPUCZDX8G_1_M_AXI_HP0_AWLEN),
        .S00_AXI_awlock(DPUCZDX8G_1_M_AXI_HP0_AWLOCK),
        .S00_AXI_awprot(DPUCZDX8G_1_M_AXI_HP0_AWPROT),
        .S00_AXI_awqos(DPUCZDX8G_1_M_AXI_HP0_AWQOS),
        .S00_AXI_awready(DPUCZDX8G_1_M_AXI_HP0_AWREADY),
        .S00_AXI_awsize(DPUCZDX8G_1_M_AXI_HP0_AWSIZE),
        .S00_AXI_awuser(DPUCZDX8G_1_M_AXI_HP0_AWUSER),
        .S00_AXI_awvalid(DPUCZDX8G_1_M_AXI_HP0_AWVALID),
        .S00_AXI_bready(DPUCZDX8G_1_M_AXI_HP0_BREADY),
        .S00_AXI_bresp(DPUCZDX8G_1_M_AXI_HP0_BRESP),
        .S00_AXI_bvalid(DPUCZDX8G_1_M_AXI_HP0_BVALID),
        .S00_AXI_rdata(DPUCZDX8G_1_M_AXI_HP0_RDATA),
        .S00_AXI_rlast(DPUCZDX8G_1_M_AXI_HP0_RLAST),
        .S00_AXI_rready(DPUCZDX8G_1_M_AXI_HP0_RREADY),
        .S00_AXI_rresp(DPUCZDX8G_1_M_AXI_HP0_RRESP),
        .S00_AXI_rvalid(DPUCZDX8G_1_M_AXI_HP0_RVALID),
        .S00_AXI_wdata(DPUCZDX8G_1_M_AXI_HP0_WDATA),
        .S00_AXI_wlast(DPUCZDX8G_1_M_AXI_HP0_WLAST),
        .S00_AXI_wready(DPUCZDX8G_1_M_AXI_HP0_WREADY),
        .S00_AXI_wstrb(DPUCZDX8G_1_M_AXI_HP0_WSTRB),
        .S00_AXI_wvalid(DPUCZDX8G_1_M_AXI_HP0_WVALID),
        .S01_ACLK(clk_wiz_1_clk_out1),
        .S01_ARESETN(proc_sys_reset_0_peripheral_aresetn),
        .S01_AXI_araddr(sfm_xrt_top_1_M_AXI_ARADDR),
        .S01_AXI_arburst(sfm_xrt_top_1_M_AXI_ARBURST),
        .S01_AXI_arcache(sfm_xrt_top_1_M_AXI_ARCACHE),
        .S01_AXI_arlen(sfm_xrt_top_1_M_AXI_ARLEN),
        .S01_AXI_arlock(sfm_xrt_top_1_M_AXI_ARLOCK),
        .S01_AXI_arprot(sfm_xrt_top_1_M_AXI_ARPROT),
        .S01_AXI_arqos(sfm_xrt_top_1_M_AXI_ARQOS),
        .S01_AXI_arready(sfm_xrt_top_1_M_AXI_ARREADY),
        .S01_AXI_arsize(sfm_xrt_top_1_M_AXI_ARSIZE),
        .S01_AXI_arvalid(sfm_xrt_top_1_M_AXI_ARVALID),
        .S01_AXI_awaddr(sfm_xrt_top_1_M_AXI_AWADDR),
        .S01_AXI_awburst(sfm_xrt_top_1_M_AXI_AWBURST),
        .S01_AXI_awcache(sfm_xrt_top_1_M_AXI_AWCACHE),
        .S01_AXI_awlen(sfm_xrt_top_1_M_AXI_AWLEN),
        .S01_AXI_awlock(sfm_xrt_top_1_M_AXI_AWLOCK),
        .S01_AXI_awprot(sfm_xrt_top_1_M_AXI_AWPROT),
        .S01_AXI_awqos(sfm_xrt_top_1_M_AXI_AWQOS),
        .S01_AXI_awready(sfm_xrt_top_1_M_AXI_AWREADY),
        .S01_AXI_awsize(sfm_xrt_top_1_M_AXI_AWSIZE),
        .S01_AXI_awvalid(sfm_xrt_top_1_M_AXI_AWVALID),
        .S01_AXI_bready(sfm_xrt_top_1_M_AXI_BREADY),
        .S01_AXI_bresp(sfm_xrt_top_1_M_AXI_BRESP),
        .S01_AXI_bvalid(sfm_xrt_top_1_M_AXI_BVALID),
        .S01_AXI_rdata(sfm_xrt_top_1_M_AXI_RDATA),
        .S01_AXI_rlast(sfm_xrt_top_1_M_AXI_RLAST),
        .S01_AXI_rready(sfm_xrt_top_1_M_AXI_RREADY),
        .S01_AXI_rresp(sfm_xrt_top_1_M_AXI_RRESP),
        .S01_AXI_rvalid(sfm_xrt_top_1_M_AXI_RVALID),
        .S01_AXI_wdata(sfm_xrt_top_1_M_AXI_WDATA),
        .S01_AXI_wlast(sfm_xrt_top_1_M_AXI_WLAST),
        .S01_AXI_wready(sfm_xrt_top_1_M_AXI_WREADY),
        .S01_AXI_wstrb(sfm_xrt_top_1_M_AXI_WSTRB),
        .S01_AXI_wvalid(sfm_xrt_top_1_M_AXI_WVALID));
  kv260_hardware_platform_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_0 axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD
       (.ACLK(clk_wiz_1_clk_out4),
        .ARESETN(proc_sys_reset_3_peripheral_aresetn),
        .M00_ACLK(clk_wiz_1_clk_out4),
        .M00_ARESETN(proc_sys_reset_3_peripheral_aresetn),
        .M00_AXI_araddr(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_ARADDR),
        .M00_AXI_arburst(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_ARBURST),
        .M00_AXI_arcache(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_ARCACHE),
        .M00_AXI_arlen(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_ARLEN),
        .M00_AXI_arlock(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_ARLOCK),
        .M00_AXI_arprot(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_ARPROT),
        .M00_AXI_arqos(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_ARQOS),
        .M00_AXI_arready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_ARREADY),
        .M00_AXI_arsize(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_ARSIZE),
        .M00_AXI_aruser(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_ARUSER),
        .M00_AXI_arvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_ARVALID),
        .M00_AXI_awaddr(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_AWADDR),
        .M00_AXI_awburst(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_AWBURST),
        .M00_AXI_awcache(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_AWCACHE),
        .M00_AXI_awlen(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_AWLEN),
        .M00_AXI_awlock(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_AWLOCK),
        .M00_AXI_awprot(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_AWPROT),
        .M00_AXI_awqos(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_AWQOS),
        .M00_AXI_awready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_AWREADY),
        .M00_AXI_awsize(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_AWSIZE),
        .M00_AXI_awuser(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_AWUSER),
        .M00_AXI_awvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_AWVALID),
        .M00_AXI_bready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_BREADY),
        .M00_AXI_bresp(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_BRESP),
        .M00_AXI_bvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_BVALID),
        .M00_AXI_rdata(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_RDATA),
        .M00_AXI_rlast(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_RLAST),
        .M00_AXI_rready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_RREADY),
        .M00_AXI_rresp(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_RRESP),
        .M00_AXI_rvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_RVALID),
        .M00_AXI_wdata(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_WDATA),
        .M00_AXI_wlast(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_WLAST),
        .M00_AXI_wready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_WREADY),
        .M00_AXI_wstrb(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_WSTRB),
        .M00_AXI_wvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_WVALID),
        .S00_ACLK(clk_wiz_1_clk_out4),
        .S00_ARESETN(proc_sys_reset_3_peripheral_aresetn),
        .S00_AXI_araddr(DPUCZDX8G_1_M_AXI_HP2_ARADDR),
        .S00_AXI_arburst(DPUCZDX8G_1_M_AXI_HP2_ARBURST),
        .S00_AXI_arcache(DPUCZDX8G_1_M_AXI_HP2_ARCACHE),
        .S00_AXI_arlen(DPUCZDX8G_1_M_AXI_HP2_ARLEN),
        .S00_AXI_arlock(DPUCZDX8G_1_M_AXI_HP2_ARLOCK),
        .S00_AXI_arprot(DPUCZDX8G_1_M_AXI_HP2_ARPROT),
        .S00_AXI_arqos(DPUCZDX8G_1_M_AXI_HP2_ARQOS),
        .S00_AXI_arready(DPUCZDX8G_1_M_AXI_HP2_ARREADY),
        .S00_AXI_arsize(DPUCZDX8G_1_M_AXI_HP2_ARSIZE),
        .S00_AXI_aruser(DPUCZDX8G_1_M_AXI_HP2_ARUSER),
        .S00_AXI_arvalid(DPUCZDX8G_1_M_AXI_HP2_ARVALID),
        .S00_AXI_awaddr(DPUCZDX8G_1_M_AXI_HP2_AWADDR),
        .S00_AXI_awburst(DPUCZDX8G_1_M_AXI_HP2_AWBURST),
        .S00_AXI_awcache(DPUCZDX8G_1_M_AXI_HP2_AWCACHE),
        .S00_AXI_awlen(DPUCZDX8G_1_M_AXI_HP2_AWLEN),
        .S00_AXI_awlock(DPUCZDX8G_1_M_AXI_HP2_AWLOCK),
        .S00_AXI_awprot(DPUCZDX8G_1_M_AXI_HP2_AWPROT),
        .S00_AXI_awqos(DPUCZDX8G_1_M_AXI_HP2_AWQOS),
        .S00_AXI_awready(DPUCZDX8G_1_M_AXI_HP2_AWREADY),
        .S00_AXI_awsize(DPUCZDX8G_1_M_AXI_HP2_AWSIZE),
        .S00_AXI_awuser(DPUCZDX8G_1_M_AXI_HP2_AWUSER),
        .S00_AXI_awvalid(DPUCZDX8G_1_M_AXI_HP2_AWVALID),
        .S00_AXI_bready(DPUCZDX8G_1_M_AXI_HP2_BREADY),
        .S00_AXI_bresp(DPUCZDX8G_1_M_AXI_HP2_BRESP),
        .S00_AXI_bvalid(DPUCZDX8G_1_M_AXI_HP2_BVALID),
        .S00_AXI_rdata(DPUCZDX8G_1_M_AXI_HP2_RDATA),
        .S00_AXI_rlast(DPUCZDX8G_1_M_AXI_HP2_RLAST),
        .S00_AXI_rready(DPUCZDX8G_1_M_AXI_HP2_RREADY),
        .S00_AXI_rresp(DPUCZDX8G_1_M_AXI_HP2_RRESP),
        .S00_AXI_rvalid(DPUCZDX8G_1_M_AXI_HP2_RVALID),
        .S00_AXI_wdata(DPUCZDX8G_1_M_AXI_HP2_WDATA),
        .S00_AXI_wlast(DPUCZDX8G_1_M_AXI_HP2_WLAST),
        .S00_AXI_wready(DPUCZDX8G_1_M_AXI_HP2_WREADY),
        .S00_AXI_wstrb(DPUCZDX8G_1_M_AXI_HP2_WSTRB),
        .S00_AXI_wvalid(DPUCZDX8G_1_M_AXI_HP2_WVALID));
  kv260_hardware_platform_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_0 axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD
       (.ACLK(clk_wiz_1_clk_out4),
        .ARESETN(proc_sys_reset_3_peripheral_aresetn),
        .M00_ACLK(clk_wiz_1_clk_out4),
        .M00_ARESETN(proc_sys_reset_3_peripheral_aresetn),
        .M00_AXI_araddr(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_ARADDR),
        .M00_AXI_arburst(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_ARBURST),
        .M00_AXI_arcache(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_ARCACHE),
        .M00_AXI_arlen(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_ARLEN),
        .M00_AXI_arlock(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_ARLOCK),
        .M00_AXI_arprot(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_ARPROT),
        .M00_AXI_arqos(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_ARQOS),
        .M00_AXI_arready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_ARREADY),
        .M00_AXI_arsize(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_ARSIZE),
        .M00_AXI_arvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_ARVALID),
        .M00_AXI_awaddr(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_AWADDR),
        .M00_AXI_awburst(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_AWBURST),
        .M00_AXI_awcache(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_AWCACHE),
        .M00_AXI_awlen(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_AWLEN),
        .M00_AXI_awlock(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_AWLOCK),
        .M00_AXI_awprot(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_AWPROT),
        .M00_AXI_awqos(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_AWQOS),
        .M00_AXI_awready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_AWREADY),
        .M00_AXI_awsize(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_AWSIZE),
        .M00_AXI_awvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_AWVALID),
        .M00_AXI_bready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_BREADY),
        .M00_AXI_bresp(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_BRESP),
        .M00_AXI_bvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_BVALID),
        .M00_AXI_rdata(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_RDATA),
        .M00_AXI_rlast(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_RLAST),
        .M00_AXI_rready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_RREADY),
        .M00_AXI_rresp(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_RRESP),
        .M00_AXI_rvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_RVALID),
        .M00_AXI_wdata(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_WDATA),
        .M00_AXI_wlast(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_WLAST),
        .M00_AXI_wready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_WREADY),
        .M00_AXI_wstrb(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_WSTRB),
        .M00_AXI_wvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_WVALID),
        .S00_ACLK(clk_wiz_1_clk_out4),
        .S00_ARESETN(proc_sys_reset_3_peripheral_aresetn),
        .S00_AXI_araddr(DPUCZDX8G_1_M_AXI_GP0_ARADDR),
        .S00_AXI_arburst(DPUCZDX8G_1_M_AXI_GP0_ARBURST),
        .S00_AXI_arcache(DPUCZDX8G_1_M_AXI_GP0_ARCACHE),
        .S00_AXI_arlen(DPUCZDX8G_1_M_AXI_GP0_ARLEN),
        .S00_AXI_arlock(DPUCZDX8G_1_M_AXI_GP0_ARLOCK),
        .S00_AXI_arprot(DPUCZDX8G_1_M_AXI_GP0_ARPROT),
        .S00_AXI_arqos(DPUCZDX8G_1_M_AXI_GP0_ARQOS),
        .S00_AXI_arready(DPUCZDX8G_1_M_AXI_GP0_ARREADY),
        .S00_AXI_arsize(DPUCZDX8G_1_M_AXI_GP0_ARSIZE),
        .S00_AXI_arvalid(DPUCZDX8G_1_M_AXI_GP0_ARVALID),
        .S00_AXI_awaddr(DPUCZDX8G_1_M_AXI_GP0_AWADDR),
        .S00_AXI_awburst(DPUCZDX8G_1_M_AXI_GP0_AWBURST),
        .S00_AXI_awcache(DPUCZDX8G_1_M_AXI_GP0_AWCACHE),
        .S00_AXI_awlen(DPUCZDX8G_1_M_AXI_GP0_AWLEN),
        .S00_AXI_awlock(DPUCZDX8G_1_M_AXI_GP0_AWLOCK),
        .S00_AXI_awprot(DPUCZDX8G_1_M_AXI_GP0_AWPROT),
        .S00_AXI_awqos(DPUCZDX8G_1_M_AXI_GP0_AWQOS),
        .S00_AXI_awready(DPUCZDX8G_1_M_AXI_GP0_AWREADY),
        .S00_AXI_awsize(DPUCZDX8G_1_M_AXI_GP0_AWSIZE),
        .S00_AXI_awvalid(DPUCZDX8G_1_M_AXI_GP0_AWVALID),
        .S00_AXI_bready(DPUCZDX8G_1_M_AXI_GP0_BREADY),
        .S00_AXI_bresp(DPUCZDX8G_1_M_AXI_GP0_BRESP),
        .S00_AXI_bvalid(DPUCZDX8G_1_M_AXI_GP0_BVALID),
        .S00_AXI_rdata(DPUCZDX8G_1_M_AXI_GP0_RDATA),
        .S00_AXI_rlast(DPUCZDX8G_1_M_AXI_GP0_RLAST),
        .S00_AXI_rready(DPUCZDX8G_1_M_AXI_GP0_RREADY),
        .S00_AXI_rresp(DPUCZDX8G_1_M_AXI_GP0_RRESP),
        .S00_AXI_rvalid(DPUCZDX8G_1_M_AXI_GP0_RVALID),
        .S00_AXI_wdata(DPUCZDX8G_1_M_AXI_GP0_WDATA),
        .S00_AXI_wlast(DPUCZDX8G_1_M_AXI_GP0_WLAST),
        .S00_AXI_wready(DPUCZDX8G_1_M_AXI_GP0_WREADY),
        .S00_AXI_wstrb(DPUCZDX8G_1_M_AXI_GP0_WSTRB),
        .S00_AXI_wvalid(DPUCZDX8G_1_M_AXI_GP0_WVALID));
  kv260_hardware_platform_axi_intc_0_0 axi_intc_0
       (.intr(axi_intc_0_intr_1_interrupt_concat_dout),
        .irq(axi_intc_0_irq),
        .s_axi_aclk(zynq_ultra_ps_e_0_pl_clk0),
        .s_axi_araddr(ps8_0_axi_periph_M00_AXI_ARADDR[8:0]),
        .s_axi_aresetn(rst_ps8_0_99M_peripheral_aresetn),
        .s_axi_arready(ps8_0_axi_periph_M00_AXI_ARREADY),
        .s_axi_arvalid(ps8_0_axi_periph_M00_AXI_ARVALID),
        .s_axi_awaddr(ps8_0_axi_periph_M00_AXI_AWADDR[8:0]),
        .s_axi_awready(ps8_0_axi_periph_M00_AXI_AWREADY),
        .s_axi_awvalid(ps8_0_axi_periph_M00_AXI_AWVALID),
        .s_axi_bready(ps8_0_axi_periph_M00_AXI_BREADY),
        .s_axi_bresp(ps8_0_axi_periph_M00_AXI_BRESP),
        .s_axi_bvalid(ps8_0_axi_periph_M00_AXI_BVALID),
        .s_axi_rdata(ps8_0_axi_periph_M00_AXI_RDATA),
        .s_axi_rready(ps8_0_axi_periph_M00_AXI_RREADY),
        .s_axi_rresp(ps8_0_axi_periph_M00_AXI_RRESP),
        .s_axi_rvalid(ps8_0_axi_periph_M00_AXI_RVALID),
        .s_axi_wdata(ps8_0_axi_periph_M00_AXI_WDATA),
        .s_axi_wready(ps8_0_axi_periph_M00_AXI_WREADY),
        .s_axi_wstrb(ps8_0_axi_periph_M00_AXI_WSTRB),
        .s_axi_wvalid(ps8_0_axi_periph_M00_AXI_WVALID));
  kv260_hardware_platform_axi_intc_0_intr_1_interrupt_concat_0 axi_intc_0_intr_1_interrupt_concat
       (.In0(sfm_xrt_top_1_interrupt),
        .In1(DPUCZDX8G_1_interrupt),
        .In10(irq_const_tieoff_dout),
        .In11(irq_const_tieoff_dout),
        .In12(irq_const_tieoff_dout),
        .In13(irq_const_tieoff_dout),
        .In14(irq_const_tieoff_dout),
        .In15(irq_const_tieoff_dout),
        .In16(irq_const_tieoff_dout),
        .In17(irq_const_tieoff_dout),
        .In18(irq_const_tieoff_dout),
        .In19(irq_const_tieoff_dout),
        .In2(irq_const_tieoff_dout),
        .In20(irq_const_tieoff_dout),
        .In21(irq_const_tieoff_dout),
        .In22(irq_const_tieoff_dout),
        .In23(irq_const_tieoff_dout),
        .In24(irq_const_tieoff_dout),
        .In25(irq_const_tieoff_dout),
        .In26(irq_const_tieoff_dout),
        .In27(irq_const_tieoff_dout),
        .In28(irq_const_tieoff_dout),
        .In29(irq_const_tieoff_dout),
        .In3(irq_const_tieoff_dout),
        .In30(irq_const_tieoff_dout),
        .In31(irq_const_tieoff_dout),
        .In4(irq_const_tieoff_dout),
        .In5(irq_const_tieoff_dout),
        .In6(irq_const_tieoff_dout),
        .In7(irq_const_tieoff_dout),
        .In8(irq_const_tieoff_dout),
        .In9(irq_const_tieoff_dout),
        .dout(axi_intc_0_intr_1_interrupt_concat_dout));
  kv260_hardware_platform_clk_wiz_0_1 clk_wiz_1
       (.clk_in1(zynq_ultra_ps_e_0_pl_clk0),
        .clk_out1(clk_wiz_1_clk_out1),
        .clk_out2(clk_wiz_1_clk_out2),
        .clk_out3(clk_wiz_1_clk_out3),
        .clk_out4(clk_wiz_1_clk_out4),
        .clk_out5(clk_wiz_1_clk_out5),
        .clk_out6(clk_wiz_1_clk_out6),
        .locked(clk_wiz_1_locked),
        .resetn(zynq_ultra_ps_e_0_pl_resetn0));
  kv260_hardware_platform_image_preprocess_1_0 image_preprocess_1
       (.ap_clk(clk_wiz_1_clk_out3),
        .ap_rst_n(proc_sys_reset_2_peripheral_aresetn),
        .interrupt(image_preprocess_1_interrupt),
        .m_axi_gmem_in_ARADDR(image_preprocess_1_m_axi_gmem_in_ARADDR),
        .m_axi_gmem_in_ARBURST(image_preprocess_1_m_axi_gmem_in_ARBURST),
        .m_axi_gmem_in_ARCACHE(image_preprocess_1_m_axi_gmem_in_ARCACHE),
        .m_axi_gmem_in_ARLEN(image_preprocess_1_m_axi_gmem_in_ARLEN),
        .m_axi_gmem_in_ARLOCK(image_preprocess_1_m_axi_gmem_in_ARLOCK),
        .m_axi_gmem_in_ARPROT(image_preprocess_1_m_axi_gmem_in_ARPROT),
        .m_axi_gmem_in_ARQOS(image_preprocess_1_m_axi_gmem_in_ARQOS),
        .m_axi_gmem_in_ARREADY(image_preprocess_1_m_axi_gmem_in_ARREADY),
        .m_axi_gmem_in_ARSIZE(image_preprocess_1_m_axi_gmem_in_ARSIZE),
        .m_axi_gmem_in_ARVALID(image_preprocess_1_m_axi_gmem_in_ARVALID),
        .m_axi_gmem_in_AWREADY(1'b0),
        .m_axi_gmem_in_BRESP({1'b0,1'b0}),
        .m_axi_gmem_in_BVALID(1'b0),
        .m_axi_gmem_in_RDATA(image_preprocess_1_m_axi_gmem_in_RDATA),
        .m_axi_gmem_in_RLAST(image_preprocess_1_m_axi_gmem_in_RLAST),
        .m_axi_gmem_in_RREADY(image_preprocess_1_m_axi_gmem_in_RREADY),
        .m_axi_gmem_in_RRESP(image_preprocess_1_m_axi_gmem_in_RRESP),
        .m_axi_gmem_in_RVALID(image_preprocess_1_m_axi_gmem_in_RVALID),
        .m_axi_gmem_in_WREADY(1'b0),
        .m_axi_gmem_out_ARREADY(1'b0),
        .m_axi_gmem_out_AWADDR(image_preprocess_1_m_axi_gmem_out_AWADDR),
        .m_axi_gmem_out_AWBURST(image_preprocess_1_m_axi_gmem_out_AWBURST),
        .m_axi_gmem_out_AWCACHE(image_preprocess_1_m_axi_gmem_out_AWCACHE),
        .m_axi_gmem_out_AWLEN(image_preprocess_1_m_axi_gmem_out_AWLEN),
        .m_axi_gmem_out_AWLOCK(image_preprocess_1_m_axi_gmem_out_AWLOCK),
        .m_axi_gmem_out_AWPROT(image_preprocess_1_m_axi_gmem_out_AWPROT),
        .m_axi_gmem_out_AWQOS(image_preprocess_1_m_axi_gmem_out_AWQOS),
        .m_axi_gmem_out_AWREADY(image_preprocess_1_m_axi_gmem_out_AWREADY),
        .m_axi_gmem_out_AWSIZE(image_preprocess_1_m_axi_gmem_out_AWSIZE),
        .m_axi_gmem_out_AWVALID(image_preprocess_1_m_axi_gmem_out_AWVALID),
        .m_axi_gmem_out_BREADY(image_preprocess_1_m_axi_gmem_out_BREADY),
        .m_axi_gmem_out_BRESP(image_preprocess_1_m_axi_gmem_out_BRESP),
        .m_axi_gmem_out_BVALID(image_preprocess_1_m_axi_gmem_out_BVALID),
        .m_axi_gmem_out_RDATA({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .m_axi_gmem_out_RLAST(1'b0),
        .m_axi_gmem_out_RRESP({1'b0,1'b0}),
        .m_axi_gmem_out_RVALID(1'b0),
        .m_axi_gmem_out_WDATA(image_preprocess_1_m_axi_gmem_out_WDATA),
        .m_axi_gmem_out_WLAST(image_preprocess_1_m_axi_gmem_out_WLAST),
        .m_axi_gmem_out_WREADY(image_preprocess_1_m_axi_gmem_out_WREADY),
        .m_axi_gmem_out_WSTRB(image_preprocess_1_m_axi_gmem_out_WSTRB),
        .m_axi_gmem_out_WVALID(image_preprocess_1_m_axi_gmem_out_WVALID),
        .m_axi_gmem_preview_ARREADY(1'b0),
        .m_axi_gmem_preview_AWADDR(image_preprocess_1_m_axi_gmem_preview_AWADDR),
        .m_axi_gmem_preview_AWBURST(image_preprocess_1_m_axi_gmem_preview_AWBURST),
        .m_axi_gmem_preview_AWCACHE(image_preprocess_1_m_axi_gmem_preview_AWCACHE),
        .m_axi_gmem_preview_AWLEN(image_preprocess_1_m_axi_gmem_preview_AWLEN),
        .m_axi_gmem_preview_AWLOCK(image_preprocess_1_m_axi_gmem_preview_AWLOCK),
        .m_axi_gmem_preview_AWPROT(image_preprocess_1_m_axi_gmem_preview_AWPROT),
        .m_axi_gmem_preview_AWQOS(image_preprocess_1_m_axi_gmem_preview_AWQOS),
        .m_axi_gmem_preview_AWREADY(image_preprocess_1_m_axi_gmem_preview_AWREADY),
        .m_axi_gmem_preview_AWSIZE(image_preprocess_1_m_axi_gmem_preview_AWSIZE),
        .m_axi_gmem_preview_AWVALID(image_preprocess_1_m_axi_gmem_preview_AWVALID),
        .m_axi_gmem_preview_BREADY(image_preprocess_1_m_axi_gmem_preview_BREADY),
        .m_axi_gmem_preview_BRESP(image_preprocess_1_m_axi_gmem_preview_BRESP),
        .m_axi_gmem_preview_BVALID(image_preprocess_1_m_axi_gmem_preview_BVALID),
        .m_axi_gmem_preview_RDATA({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .m_axi_gmem_preview_RLAST(1'b0),
        .m_axi_gmem_preview_RRESP({1'b0,1'b0}),
        .m_axi_gmem_preview_RVALID(1'b0),
        .m_axi_gmem_preview_WDATA(image_preprocess_1_m_axi_gmem_preview_WDATA),
        .m_axi_gmem_preview_WLAST(image_preprocess_1_m_axi_gmem_preview_WLAST),
        .m_axi_gmem_preview_WREADY(image_preprocess_1_m_axi_gmem_preview_WREADY),
        .m_axi_gmem_preview_WSTRB(image_preprocess_1_m_axi_gmem_preview_WSTRB),
        .m_axi_gmem_preview_WVALID(image_preprocess_1_m_axi_gmem_preview_WVALID),
        .s_axi_control_ARADDR(ps8_0_axi_periph_M01_AXI_ARADDR),
        .s_axi_control_ARREADY(ps8_0_axi_periph_M01_AXI_ARREADY),
        .s_axi_control_ARVALID(ps8_0_axi_periph_M01_AXI_ARVALID),
        .s_axi_control_AWADDR(ps8_0_axi_periph_M01_AXI_AWADDR),
        .s_axi_control_AWREADY(ps8_0_axi_periph_M01_AXI_AWREADY),
        .s_axi_control_AWVALID(ps8_0_axi_periph_M01_AXI_AWVALID),
        .s_axi_control_BREADY(ps8_0_axi_periph_M01_AXI_BREADY),
        .s_axi_control_BRESP(ps8_0_axi_periph_M01_AXI_BRESP),
        .s_axi_control_BVALID(ps8_0_axi_periph_M01_AXI_BVALID),
        .s_axi_control_RDATA(ps8_0_axi_periph_M01_AXI_RDATA),
        .s_axi_control_RREADY(ps8_0_axi_periph_M01_AXI_RREADY),
        .s_axi_control_RRESP(ps8_0_axi_periph_M01_AXI_RRESP),
        .s_axi_control_RVALID(ps8_0_axi_periph_M01_AXI_RVALID),
        .s_axi_control_WDATA(ps8_0_axi_periph_M01_AXI_WDATA),
        .s_axi_control_WREADY(ps8_0_axi_periph_M01_AXI_WREADY),
        .s_axi_control_WSTRB(ps8_0_axi_periph_M01_AXI_WSTRB),
        .s_axi_control_WVALID(ps8_0_axi_periph_M01_AXI_WVALID));
  kv260_hardware_platform_irq_const_tieoff_0 irq_const_tieoff
       (.dout(irq_const_tieoff_dout));
  kv260_hardware_platform_proc_sys_reset_0_6 proc_sys_reset_0
       (.aux_reset_in(1'b1),
        .dcm_locked(clk_wiz_1_locked),
        .ext_reset_in(zynq_ultra_ps_e_0_pl_resetn0),
        .interconnect_aresetn(proc_sys_reset_0_interconnect_aresetn),
        .mb_debug_sys_rst(1'b0),
        .peripheral_aresetn(proc_sys_reset_0_peripheral_aresetn),
        .slowest_sync_clk(clk_wiz_1_clk_out1));
  kv260_hardware_platform_proc_sys_reset_0_7 proc_sys_reset_1
       (.aux_reset_in(1'b1),
        .dcm_locked(clk_wiz_1_locked),
        .ext_reset_in(zynq_ultra_ps_e_0_pl_resetn0),
        .mb_debug_sys_rst(1'b0),
        .slowest_sync_clk(clk_wiz_1_clk_out2));
  kv260_hardware_platform_proc_sys_reset_0_8 proc_sys_reset_2
       (.aux_reset_in(1'b1),
        .dcm_locked(clk_wiz_1_locked),
        .ext_reset_in(zynq_ultra_ps_e_0_pl_resetn0),
        .interconnect_aresetn(proc_sys_reset_2_interconnect_aresetn),
        .mb_debug_sys_rst(1'b0),
        .peripheral_aresetn(proc_sys_reset_2_peripheral_aresetn),
        .slowest_sync_clk(clk_wiz_1_clk_out3));
  kv260_hardware_platform_proc_sys_reset_0_9 proc_sys_reset_3
       (.aux_reset_in(1'b1),
        .dcm_locked(clk_wiz_1_locked),
        .ext_reset_in(zynq_ultra_ps_e_0_pl_resetn0),
        .mb_debug_sys_rst(1'b0),
        .peripheral_aresetn(proc_sys_reset_3_peripheral_aresetn),
        .slowest_sync_clk(clk_wiz_1_clk_out4));
  kv260_hardware_platform_proc_sys_reset_0_10 proc_sys_reset_4
       (.aux_reset_in(1'b1),
        .dcm_locked(clk_wiz_1_locked),
        .ext_reset_in(zynq_ultra_ps_e_0_pl_resetn0),
        .mb_debug_sys_rst(1'b0),
        .slowest_sync_clk(clk_wiz_1_clk_out5));
  kv260_hardware_platform_proc_sys_reset_0_11 proc_sys_reset_5
       (.aux_reset_in(1'b1),
        .dcm_locked(clk_wiz_1_locked),
        .ext_reset_in(zynq_ultra_ps_e_0_pl_resetn0),
        .mb_debug_sys_rst(1'b0),
        .peripheral_aresetn(proc_sys_reset_5_peripheral_aresetn),
        .slowest_sync_clk(clk_wiz_1_clk_out6));
  kv260_hardware_platform_ps8_0_axi_periph_0 ps8_0_axi_periph
       (.ACLK(zynq_ultra_ps_e_0_pl_clk0),
        .ARESETN(rst_ps8_0_99M_peripheral_aresetn),
        .M00_ACLK(zynq_ultra_ps_e_0_pl_clk0),
        .M00_ARESETN(rst_ps8_0_99M_peripheral_aresetn),
        .M00_AXI_araddr(ps8_0_axi_periph_M00_AXI_ARADDR),
        .M00_AXI_arready(ps8_0_axi_periph_M00_AXI_ARREADY),
        .M00_AXI_arvalid(ps8_0_axi_periph_M00_AXI_ARVALID),
        .M00_AXI_awaddr(ps8_0_axi_periph_M00_AXI_AWADDR),
        .M00_AXI_awready(ps8_0_axi_periph_M00_AXI_AWREADY),
        .M00_AXI_awvalid(ps8_0_axi_periph_M00_AXI_AWVALID),
        .M00_AXI_bready(ps8_0_axi_periph_M00_AXI_BREADY),
        .M00_AXI_bresp(ps8_0_axi_periph_M00_AXI_BRESP),
        .M00_AXI_bvalid(ps8_0_axi_periph_M00_AXI_BVALID),
        .M00_AXI_rdata(ps8_0_axi_periph_M00_AXI_RDATA),
        .M00_AXI_rready(ps8_0_axi_periph_M00_AXI_RREADY),
        .M00_AXI_rresp(ps8_0_axi_periph_M00_AXI_RRESP),
        .M00_AXI_rvalid(ps8_0_axi_periph_M00_AXI_RVALID),
        .M00_AXI_wdata(ps8_0_axi_periph_M00_AXI_WDATA),
        .M00_AXI_wready(ps8_0_axi_periph_M00_AXI_WREADY),
        .M00_AXI_wstrb(ps8_0_axi_periph_M00_AXI_WSTRB),
        .M00_AXI_wvalid(ps8_0_axi_periph_M00_AXI_WVALID),
        .M01_ACLK(clk_wiz_1_clk_out3),
        .M01_ARESETN(proc_sys_reset_2_interconnect_aresetn),
        .M01_AXI_araddr(ps8_0_axi_periph_M01_AXI_ARADDR),
        .M01_AXI_arready(ps8_0_axi_periph_M01_AXI_ARREADY),
        .M01_AXI_arvalid(ps8_0_axi_periph_M01_AXI_ARVALID),
        .M01_AXI_awaddr(ps8_0_axi_periph_M01_AXI_AWADDR),
        .M01_AXI_awready(ps8_0_axi_periph_M01_AXI_AWREADY),
        .M01_AXI_awvalid(ps8_0_axi_periph_M01_AXI_AWVALID),
        .M01_AXI_bready(ps8_0_axi_periph_M01_AXI_BREADY),
        .M01_AXI_bresp(ps8_0_axi_periph_M01_AXI_BRESP),
        .M01_AXI_bvalid(ps8_0_axi_periph_M01_AXI_BVALID),
        .M01_AXI_rdata(ps8_0_axi_periph_M01_AXI_RDATA),
        .M01_AXI_rready(ps8_0_axi_periph_M01_AXI_RREADY),
        .M01_AXI_rresp(ps8_0_axi_periph_M01_AXI_RRESP),
        .M01_AXI_rvalid(ps8_0_axi_periph_M01_AXI_RVALID),
        .M01_AXI_wdata(ps8_0_axi_periph_M01_AXI_WDATA),
        .M01_AXI_wready(ps8_0_axi_periph_M01_AXI_WREADY),
        .M01_AXI_wstrb(ps8_0_axi_periph_M01_AXI_WSTRB),
        .M01_AXI_wvalid(ps8_0_axi_periph_M01_AXI_WVALID),
        .M02_ACLK(clk_wiz_1_clk_out3),
        .M02_ARESETN(proc_sys_reset_2_interconnect_aresetn),
        .M02_AXI_araddr(ps8_0_axi_periph_M02_AXI_ARADDR),
        .M02_AXI_arready(ps8_0_axi_periph_M02_AXI_ARREADY),
        .M02_AXI_arvalid(ps8_0_axi_periph_M02_AXI_ARVALID),
        .M02_AXI_awaddr(ps8_0_axi_periph_M02_AXI_AWADDR),
        .M02_AXI_awready(ps8_0_axi_periph_M02_AXI_AWREADY),
        .M02_AXI_awvalid(ps8_0_axi_periph_M02_AXI_AWVALID),
        .M02_AXI_bready(ps8_0_axi_periph_M02_AXI_BREADY),
        .M02_AXI_bresp(ps8_0_axi_periph_M02_AXI_BRESP),
        .M02_AXI_bvalid(ps8_0_axi_periph_M02_AXI_BVALID),
        .M02_AXI_rdata(ps8_0_axi_periph_M02_AXI_RDATA),
        .M02_AXI_rready(ps8_0_axi_periph_M02_AXI_RREADY),
        .M02_AXI_rresp(ps8_0_axi_periph_M02_AXI_RRESP),
        .M02_AXI_rvalid(ps8_0_axi_periph_M02_AXI_RVALID),
        .M02_AXI_wdata(ps8_0_axi_periph_M02_AXI_WDATA),
        .M02_AXI_wready(ps8_0_axi_periph_M02_AXI_WREADY),
        .M02_AXI_wstrb(ps8_0_axi_periph_M02_AXI_WSTRB),
        .M02_AXI_wvalid(ps8_0_axi_periph_M02_AXI_WVALID),
        .M03_ACLK(clk_wiz_1_clk_out4),
        .M03_ARESETN(proc_sys_reset_3_peripheral_aresetn),
        .M03_AXI_araddr(ps8_0_axi_periph_M03_AXI_ARADDR),
        .M03_AXI_arready(ps8_0_axi_periph_M03_AXI_ARREADY),
        .M03_AXI_arvalid(ps8_0_axi_periph_M03_AXI_ARVALID),
        .M03_AXI_awaddr(ps8_0_axi_periph_M03_AXI_AWADDR),
        .M03_AXI_awready(ps8_0_axi_periph_M03_AXI_AWREADY),
        .M03_AXI_awvalid(ps8_0_axi_periph_M03_AXI_AWVALID),
        .M03_AXI_bready(ps8_0_axi_periph_M03_AXI_BREADY),
        .M03_AXI_bresp(ps8_0_axi_periph_M03_AXI_BRESP),
        .M03_AXI_bvalid(ps8_0_axi_periph_M03_AXI_BVALID),
        .M03_AXI_rdata(ps8_0_axi_periph_M03_AXI_RDATA),
        .M03_AXI_rready(ps8_0_axi_periph_M03_AXI_RREADY),
        .M03_AXI_rresp(ps8_0_axi_periph_M03_AXI_RRESP),
        .M03_AXI_rvalid(ps8_0_axi_periph_M03_AXI_RVALID),
        .M03_AXI_wdata(ps8_0_axi_periph_M03_AXI_WDATA),
        .M03_AXI_wready(ps8_0_axi_periph_M03_AXI_WREADY),
        .M03_AXI_wstrb(ps8_0_axi_periph_M03_AXI_WSTRB),
        .M03_AXI_wvalid(ps8_0_axi_periph_M03_AXI_WVALID),
        .M04_ACLK(clk_wiz_1_clk_out1),
        .M04_ARESETN(proc_sys_reset_0_interconnect_aresetn),
        .M04_AXI_araddr(ps8_0_axi_periph_M04_AXI_ARADDR),
        .M04_AXI_arready(ps8_0_axi_periph_M04_AXI_ARREADY),
        .M04_AXI_arvalid(ps8_0_axi_periph_M04_AXI_ARVALID),
        .M04_AXI_awaddr(ps8_0_axi_periph_M04_AXI_AWADDR),
        .M04_AXI_awready(ps8_0_axi_periph_M04_AXI_AWREADY),
        .M04_AXI_awvalid(ps8_0_axi_periph_M04_AXI_AWVALID),
        .M04_AXI_bready(ps8_0_axi_periph_M04_AXI_BREADY),
        .M04_AXI_bresp(ps8_0_axi_periph_M04_AXI_BRESP),
        .M04_AXI_bvalid(ps8_0_axi_periph_M04_AXI_BVALID),
        .M04_AXI_rdata(ps8_0_axi_periph_M04_AXI_RDATA),
        .M04_AXI_rready(ps8_0_axi_periph_M04_AXI_RREADY),
        .M04_AXI_rresp(ps8_0_axi_periph_M04_AXI_RRESP),
        .M04_AXI_rvalid(ps8_0_axi_periph_M04_AXI_RVALID),
        .M04_AXI_wdata(ps8_0_axi_periph_M04_AXI_WDATA),
        .M04_AXI_wready(ps8_0_axi_periph_M04_AXI_WREADY),
        .M04_AXI_wstrb(ps8_0_axi_periph_M04_AXI_WSTRB),
        .M04_AXI_wvalid(ps8_0_axi_periph_M04_AXI_WVALID),
        .S00_ACLK(zynq_ultra_ps_e_0_pl_clk0),
        .S00_ARESETN(rst_ps8_0_99M_peripheral_aresetn),
        .S00_AXI_araddr(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_ARADDR),
        .S00_AXI_arburst(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_ARBURST),
        .S00_AXI_arcache(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_ARCACHE),
        .S00_AXI_arid(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_ARID),
        .S00_AXI_arlen(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_ARLEN),
        .S00_AXI_arlock(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_ARLOCK),
        .S00_AXI_arprot(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_ARPROT),
        .S00_AXI_arqos(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_ARQOS),
        .S00_AXI_arready(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_ARREADY),
        .S00_AXI_arsize(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_ARSIZE),
        .S00_AXI_arvalid(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_ARVALID),
        .S00_AXI_awaddr(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_AWADDR),
        .S00_AXI_awburst(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_AWBURST),
        .S00_AXI_awcache(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_AWCACHE),
        .S00_AXI_awid(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_AWID),
        .S00_AXI_awlen(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_AWLEN),
        .S00_AXI_awlock(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_AWLOCK),
        .S00_AXI_awprot(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_AWPROT),
        .S00_AXI_awqos(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_AWQOS),
        .S00_AXI_awready(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_AWREADY),
        .S00_AXI_awsize(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_AWSIZE),
        .S00_AXI_awvalid(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_AWVALID),
        .S00_AXI_bid(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_BID),
        .S00_AXI_bready(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_BREADY),
        .S00_AXI_bresp(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_BRESP),
        .S00_AXI_bvalid(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_BVALID),
        .S00_AXI_rdata(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_RDATA),
        .S00_AXI_rid(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_RID),
        .S00_AXI_rlast(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_RLAST),
        .S00_AXI_rready(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_RREADY),
        .S00_AXI_rresp(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_RRESP),
        .S00_AXI_rvalid(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_RVALID),
        .S00_AXI_wdata(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_WDATA),
        .S00_AXI_wlast(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_WLAST),
        .S00_AXI_wready(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_WREADY),
        .S00_AXI_wstrb(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_WSTRB),
        .S00_AXI_wvalid(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_WVALID));
  kv260_hardware_platform_rst_ps8_0_99M_0 rst_ps8_0_99M
       (.aux_reset_in(1'b1),
        .dcm_locked(1'b1),
        .ext_reset_in(zynq_ultra_ps_e_0_pl_resetn0),
        .mb_debug_sys_rst(1'b0),
        .peripheral_aresetn(rst_ps8_0_99M_peripheral_aresetn),
        .slowest_sync_clk(zynq_ultra_ps_e_0_pl_clk0));
  kv260_hardware_platform_sfm_xrt_top_1_0 sfm_xrt_top_1
       (.M_AXI_araddr(sfm_xrt_top_1_M_AXI_ARADDR),
        .M_AXI_arburst(sfm_xrt_top_1_M_AXI_ARBURST),
        .M_AXI_arcache(sfm_xrt_top_1_M_AXI_ARCACHE),
        .M_AXI_arlen(sfm_xrt_top_1_M_AXI_ARLEN),
        .M_AXI_arlock(sfm_xrt_top_1_M_AXI_ARLOCK),
        .M_AXI_arprot(sfm_xrt_top_1_M_AXI_ARPROT),
        .M_AXI_arqos(sfm_xrt_top_1_M_AXI_ARQOS),
        .M_AXI_arready(sfm_xrt_top_1_M_AXI_ARREADY),
        .M_AXI_arsize(sfm_xrt_top_1_M_AXI_ARSIZE),
        .M_AXI_arvalid(sfm_xrt_top_1_M_AXI_ARVALID),
        .M_AXI_awaddr(sfm_xrt_top_1_M_AXI_AWADDR),
        .M_AXI_awburst(sfm_xrt_top_1_M_AXI_AWBURST),
        .M_AXI_awcache(sfm_xrt_top_1_M_AXI_AWCACHE),
        .M_AXI_awlen(sfm_xrt_top_1_M_AXI_AWLEN),
        .M_AXI_awlock(sfm_xrt_top_1_M_AXI_AWLOCK),
        .M_AXI_awprot(sfm_xrt_top_1_M_AXI_AWPROT),
        .M_AXI_awqos(sfm_xrt_top_1_M_AXI_AWQOS),
        .M_AXI_awready(sfm_xrt_top_1_M_AXI_AWREADY),
        .M_AXI_awsize(sfm_xrt_top_1_M_AXI_AWSIZE),
        .M_AXI_awvalid(sfm_xrt_top_1_M_AXI_AWVALID),
        .M_AXI_bready(sfm_xrt_top_1_M_AXI_BREADY),
        .M_AXI_bresp(sfm_xrt_top_1_M_AXI_BRESP),
        .M_AXI_bvalid(sfm_xrt_top_1_M_AXI_BVALID),
        .M_AXI_rdata(sfm_xrt_top_1_M_AXI_RDATA),
        .M_AXI_rlast(sfm_xrt_top_1_M_AXI_RLAST),
        .M_AXI_rready(sfm_xrt_top_1_M_AXI_RREADY),
        .M_AXI_rresp(sfm_xrt_top_1_M_AXI_RRESP),
        .M_AXI_rvalid(sfm_xrt_top_1_M_AXI_RVALID),
        .M_AXI_wdata(sfm_xrt_top_1_M_AXI_WDATA),
        .M_AXI_wlast(sfm_xrt_top_1_M_AXI_WLAST),
        .M_AXI_wready(sfm_xrt_top_1_M_AXI_WREADY),
        .M_AXI_wstrb(sfm_xrt_top_1_M_AXI_WSTRB),
        .M_AXI_wvalid(sfm_xrt_top_1_M_AXI_WVALID),
        .aclk(clk_wiz_1_clk_out1),
        .aresetn(proc_sys_reset_0_peripheral_aresetn),
        .interrupt(sfm_xrt_top_1_interrupt),
        .s_axi_control_ARADDR(ps8_0_axi_periph_M04_AXI_ARADDR),
        .s_axi_control_ARREADY(ps8_0_axi_periph_M04_AXI_ARREADY),
        .s_axi_control_ARVALID(ps8_0_axi_periph_M04_AXI_ARVALID),
        .s_axi_control_AWADDR(ps8_0_axi_periph_M04_AXI_AWADDR),
        .s_axi_control_AWREADY(ps8_0_axi_periph_M04_AXI_AWREADY),
        .s_axi_control_AWVALID(ps8_0_axi_periph_M04_AXI_AWVALID),
        .s_axi_control_BREADY(ps8_0_axi_periph_M04_AXI_BREADY),
        .s_axi_control_BRESP(ps8_0_axi_periph_M04_AXI_BRESP),
        .s_axi_control_BVALID(ps8_0_axi_periph_M04_AXI_BVALID),
        .s_axi_control_RDATA(ps8_0_axi_periph_M04_AXI_RDATA),
        .s_axi_control_RREADY(ps8_0_axi_periph_M04_AXI_RREADY),
        .s_axi_control_RRESP(ps8_0_axi_periph_M04_AXI_RRESP),
        .s_axi_control_RVALID(ps8_0_axi_periph_M04_AXI_RVALID),
        .s_axi_control_WDATA(ps8_0_axi_periph_M04_AXI_WDATA),
        .s_axi_control_WREADY(ps8_0_axi_periph_M04_AXI_WREADY),
        .s_axi_control_WSTRB(ps8_0_axi_periph_M04_AXI_WSTRB),
        .s_axi_control_WVALID(ps8_0_axi_periph_M04_AXI_WVALID));
  kv260_hardware_platform_vision_irq_concat_0 vision_irq_concat
       (.In0(image_preprocess_1_interrupt),
        .In1(yolo_postprocess_1_interrupt),
        .In2(vision_irq_zero_dout),
        .dout(vision_irq_concat_dout));
  kv260_hardware_platform_vision_irq_zero_0 vision_irq_zero
       (.dout(vision_irq_zero_dout));
  kv260_hardware_platform_vision_read_sc_0 vision_read_sc
       (.M00_AXI_araddr(vision_read_sc_M00_AXI_ARADDR),
        .M00_AXI_arburst(vision_read_sc_M00_AXI_ARBURST),
        .M00_AXI_arcache(vision_read_sc_M00_AXI_ARCACHE),
        .M00_AXI_arlen(vision_read_sc_M00_AXI_ARLEN),
        .M00_AXI_arlock(vision_read_sc_M00_AXI_ARLOCK),
        .M00_AXI_arprot(vision_read_sc_M00_AXI_ARPROT),
        .M00_AXI_arqos(vision_read_sc_M00_AXI_ARQOS),
        .M00_AXI_arready(vision_read_sc_M00_AXI_ARREADY),
        .M00_AXI_arsize(vision_read_sc_M00_AXI_ARSIZE),
        .M00_AXI_arvalid(vision_read_sc_M00_AXI_ARVALID),
        .M00_AXI_rdata(vision_read_sc_M00_AXI_RDATA),
        .M00_AXI_rlast(vision_read_sc_M00_AXI_RLAST),
        .M00_AXI_rready(vision_read_sc_M00_AXI_RREADY),
        .M00_AXI_rresp(vision_read_sc_M00_AXI_RRESP),
        .M00_AXI_rvalid(vision_read_sc_M00_AXI_RVALID),
        .S00_AXI_araddr(image_preprocess_1_m_axi_gmem_in_ARADDR),
        .S00_AXI_arburst(image_preprocess_1_m_axi_gmem_in_ARBURST),
        .S00_AXI_arcache(image_preprocess_1_m_axi_gmem_in_ARCACHE),
        .S00_AXI_arlen(image_preprocess_1_m_axi_gmem_in_ARLEN),
        .S00_AXI_arlock(image_preprocess_1_m_axi_gmem_in_ARLOCK[0]),
        .S00_AXI_arprot(image_preprocess_1_m_axi_gmem_in_ARPROT),
        .S00_AXI_arqos(image_preprocess_1_m_axi_gmem_in_ARQOS),
        .S00_AXI_arready(image_preprocess_1_m_axi_gmem_in_ARREADY),
        .S00_AXI_arsize(image_preprocess_1_m_axi_gmem_in_ARSIZE),
        .S00_AXI_arvalid(image_preprocess_1_m_axi_gmem_in_ARVALID),
        .S00_AXI_rdata(image_preprocess_1_m_axi_gmem_in_RDATA),
        .S00_AXI_rlast(image_preprocess_1_m_axi_gmem_in_RLAST),
        .S00_AXI_rready(image_preprocess_1_m_axi_gmem_in_RREADY),
        .S00_AXI_rresp(image_preprocess_1_m_axi_gmem_in_RRESP),
        .S00_AXI_rvalid(image_preprocess_1_m_axi_gmem_in_RVALID),
        .S01_AXI_araddr(yolo_postprocess_1_m_axi_gmem_in_ARADDR),
        .S01_AXI_arburst(yolo_postprocess_1_m_axi_gmem_in_ARBURST),
        .S01_AXI_arcache(yolo_postprocess_1_m_axi_gmem_in_ARCACHE),
        .S01_AXI_arlen(yolo_postprocess_1_m_axi_gmem_in_ARLEN),
        .S01_AXI_arlock(yolo_postprocess_1_m_axi_gmem_in_ARLOCK[0]),
        .S01_AXI_arprot(yolo_postprocess_1_m_axi_gmem_in_ARPROT),
        .S01_AXI_arqos(yolo_postprocess_1_m_axi_gmem_in_ARQOS),
        .S01_AXI_arready(yolo_postprocess_1_m_axi_gmem_in_ARREADY),
        .S01_AXI_arsize(yolo_postprocess_1_m_axi_gmem_in_ARSIZE),
        .S01_AXI_arvalid(yolo_postprocess_1_m_axi_gmem_in_ARVALID),
        .S01_AXI_rdata(yolo_postprocess_1_m_axi_gmem_in_RDATA),
        .S01_AXI_rlast(yolo_postprocess_1_m_axi_gmem_in_RLAST),
        .S01_AXI_rready(yolo_postprocess_1_m_axi_gmem_in_RREADY),
        .S01_AXI_rresp(yolo_postprocess_1_m_axi_gmem_in_RRESP),
        .S01_AXI_rvalid(yolo_postprocess_1_m_axi_gmem_in_RVALID),
        .aclk(clk_wiz_1_clk_out3),
        .aresetn(proc_sys_reset_2_interconnect_aresetn));
  kv260_hardware_platform_vision_write_sc_0 vision_write_sc
       (.M00_AXI_awaddr(vision_write_sc_M00_AXI_AWADDR),
        .M00_AXI_awburst(vision_write_sc_M00_AXI_AWBURST),
        .M00_AXI_awcache(vision_write_sc_M00_AXI_AWCACHE),
        .M00_AXI_awlen(vision_write_sc_M00_AXI_AWLEN),
        .M00_AXI_awlock(vision_write_sc_M00_AXI_AWLOCK),
        .M00_AXI_awprot(vision_write_sc_M00_AXI_AWPROT),
        .M00_AXI_awqos(vision_write_sc_M00_AXI_AWQOS),
        .M00_AXI_awready(vision_write_sc_M00_AXI_AWREADY),
        .M00_AXI_awsize(vision_write_sc_M00_AXI_AWSIZE),
        .M00_AXI_awvalid(vision_write_sc_M00_AXI_AWVALID),
        .M00_AXI_bready(vision_write_sc_M00_AXI_BREADY),
        .M00_AXI_bresp(vision_write_sc_M00_AXI_BRESP),
        .M00_AXI_bvalid(vision_write_sc_M00_AXI_BVALID),
        .M00_AXI_wdata(vision_write_sc_M00_AXI_WDATA),
        .M00_AXI_wlast(vision_write_sc_M00_AXI_WLAST),
        .M00_AXI_wready(vision_write_sc_M00_AXI_WREADY),
        .M00_AXI_wstrb(vision_write_sc_M00_AXI_WSTRB),
        .M00_AXI_wvalid(vision_write_sc_M00_AXI_WVALID),
        .S00_AXI_awaddr(image_preprocess_1_m_axi_gmem_out_AWADDR),
        .S00_AXI_awburst(image_preprocess_1_m_axi_gmem_out_AWBURST),
        .S00_AXI_awcache(image_preprocess_1_m_axi_gmem_out_AWCACHE),
        .S00_AXI_awlen(image_preprocess_1_m_axi_gmem_out_AWLEN),
        .S00_AXI_awlock(image_preprocess_1_m_axi_gmem_out_AWLOCK[0]),
        .S00_AXI_awprot(image_preprocess_1_m_axi_gmem_out_AWPROT),
        .S00_AXI_awqos(image_preprocess_1_m_axi_gmem_out_AWQOS),
        .S00_AXI_awready(image_preprocess_1_m_axi_gmem_out_AWREADY),
        .S00_AXI_awsize(image_preprocess_1_m_axi_gmem_out_AWSIZE),
        .S00_AXI_awvalid(image_preprocess_1_m_axi_gmem_out_AWVALID),
        .S00_AXI_bready(image_preprocess_1_m_axi_gmem_out_BREADY),
        .S00_AXI_bresp(image_preprocess_1_m_axi_gmem_out_BRESP),
        .S00_AXI_bvalid(image_preprocess_1_m_axi_gmem_out_BVALID),
        .S00_AXI_wdata(image_preprocess_1_m_axi_gmem_out_WDATA),
        .S00_AXI_wlast(image_preprocess_1_m_axi_gmem_out_WLAST),
        .S00_AXI_wready(image_preprocess_1_m_axi_gmem_out_WREADY),
        .S00_AXI_wstrb(image_preprocess_1_m_axi_gmem_out_WSTRB),
        .S00_AXI_wvalid(image_preprocess_1_m_axi_gmem_out_WVALID),
        .S01_AXI_awaddr(image_preprocess_1_m_axi_gmem_preview_AWADDR),
        .S01_AXI_awburst(image_preprocess_1_m_axi_gmem_preview_AWBURST),
        .S01_AXI_awcache(image_preprocess_1_m_axi_gmem_preview_AWCACHE),
        .S01_AXI_awlen(image_preprocess_1_m_axi_gmem_preview_AWLEN),
        .S01_AXI_awlock(image_preprocess_1_m_axi_gmem_preview_AWLOCK[0]),
        .S01_AXI_awprot(image_preprocess_1_m_axi_gmem_preview_AWPROT),
        .S01_AXI_awqos(image_preprocess_1_m_axi_gmem_preview_AWQOS),
        .S01_AXI_awready(image_preprocess_1_m_axi_gmem_preview_AWREADY),
        .S01_AXI_awsize(image_preprocess_1_m_axi_gmem_preview_AWSIZE),
        .S01_AXI_awvalid(image_preprocess_1_m_axi_gmem_preview_AWVALID),
        .S01_AXI_bready(image_preprocess_1_m_axi_gmem_preview_BREADY),
        .S01_AXI_bresp(image_preprocess_1_m_axi_gmem_preview_BRESP),
        .S01_AXI_bvalid(image_preprocess_1_m_axi_gmem_preview_BVALID),
        .S01_AXI_wdata(image_preprocess_1_m_axi_gmem_preview_WDATA),
        .S01_AXI_wlast(image_preprocess_1_m_axi_gmem_preview_WLAST),
        .S01_AXI_wready(image_preprocess_1_m_axi_gmem_preview_WREADY),
        .S01_AXI_wstrb(image_preprocess_1_m_axi_gmem_preview_WSTRB),
        .S01_AXI_wvalid(image_preprocess_1_m_axi_gmem_preview_WVALID),
        .S02_AXI_awaddr(yolo_postprocess_1_m_axi_gmem_out_AWADDR),
        .S02_AXI_awburst(yolo_postprocess_1_m_axi_gmem_out_AWBURST),
        .S02_AXI_awcache(yolo_postprocess_1_m_axi_gmem_out_AWCACHE),
        .S02_AXI_awlen(yolo_postprocess_1_m_axi_gmem_out_AWLEN),
        .S02_AXI_awlock(yolo_postprocess_1_m_axi_gmem_out_AWLOCK[0]),
        .S02_AXI_awprot(yolo_postprocess_1_m_axi_gmem_out_AWPROT),
        .S02_AXI_awqos(yolo_postprocess_1_m_axi_gmem_out_AWQOS),
        .S02_AXI_awready(yolo_postprocess_1_m_axi_gmem_out_AWREADY),
        .S02_AXI_awsize(yolo_postprocess_1_m_axi_gmem_out_AWSIZE),
        .S02_AXI_awvalid(yolo_postprocess_1_m_axi_gmem_out_AWVALID),
        .S02_AXI_bready(yolo_postprocess_1_m_axi_gmem_out_BREADY),
        .S02_AXI_bresp(yolo_postprocess_1_m_axi_gmem_out_BRESP),
        .S02_AXI_bvalid(yolo_postprocess_1_m_axi_gmem_out_BVALID),
        .S02_AXI_wdata(yolo_postprocess_1_m_axi_gmem_out_WDATA),
        .S02_AXI_wlast(yolo_postprocess_1_m_axi_gmem_out_WLAST),
        .S02_AXI_wready(yolo_postprocess_1_m_axi_gmem_out_WREADY),
        .S02_AXI_wstrb(yolo_postprocess_1_m_axi_gmem_out_WSTRB),
        .S02_AXI_wvalid(yolo_postprocess_1_m_axi_gmem_out_WVALID),
        .aclk(clk_wiz_1_clk_out3),
        .aresetn(proc_sys_reset_2_interconnect_aresetn));
  kv260_hardware_platform_yolo_postprocess_1_0 yolo_postprocess_1
       (.ap_clk(clk_wiz_1_clk_out3),
        .ap_rst_n(proc_sys_reset_2_peripheral_aresetn),
        .interrupt(yolo_postprocess_1_interrupt),
        .m_axi_gmem_in_ARADDR(yolo_postprocess_1_m_axi_gmem_in_ARADDR),
        .m_axi_gmem_in_ARBURST(yolo_postprocess_1_m_axi_gmem_in_ARBURST),
        .m_axi_gmem_in_ARCACHE(yolo_postprocess_1_m_axi_gmem_in_ARCACHE),
        .m_axi_gmem_in_ARLEN(yolo_postprocess_1_m_axi_gmem_in_ARLEN),
        .m_axi_gmem_in_ARLOCK(yolo_postprocess_1_m_axi_gmem_in_ARLOCK),
        .m_axi_gmem_in_ARPROT(yolo_postprocess_1_m_axi_gmem_in_ARPROT),
        .m_axi_gmem_in_ARQOS(yolo_postprocess_1_m_axi_gmem_in_ARQOS),
        .m_axi_gmem_in_ARREADY(yolo_postprocess_1_m_axi_gmem_in_ARREADY),
        .m_axi_gmem_in_ARSIZE(yolo_postprocess_1_m_axi_gmem_in_ARSIZE),
        .m_axi_gmem_in_ARVALID(yolo_postprocess_1_m_axi_gmem_in_ARVALID),
        .m_axi_gmem_in_AWREADY(1'b0),
        .m_axi_gmem_in_BRESP({1'b0,1'b0}),
        .m_axi_gmem_in_BVALID(1'b0),
        .m_axi_gmem_in_RDATA(yolo_postprocess_1_m_axi_gmem_in_RDATA),
        .m_axi_gmem_in_RLAST(yolo_postprocess_1_m_axi_gmem_in_RLAST),
        .m_axi_gmem_in_RREADY(yolo_postprocess_1_m_axi_gmem_in_RREADY),
        .m_axi_gmem_in_RRESP(yolo_postprocess_1_m_axi_gmem_in_RRESP),
        .m_axi_gmem_in_RVALID(yolo_postprocess_1_m_axi_gmem_in_RVALID),
        .m_axi_gmem_in_WREADY(1'b0),
        .m_axi_gmem_out_ARREADY(1'b0),
        .m_axi_gmem_out_AWADDR(yolo_postprocess_1_m_axi_gmem_out_AWADDR),
        .m_axi_gmem_out_AWBURST(yolo_postprocess_1_m_axi_gmem_out_AWBURST),
        .m_axi_gmem_out_AWCACHE(yolo_postprocess_1_m_axi_gmem_out_AWCACHE),
        .m_axi_gmem_out_AWLEN(yolo_postprocess_1_m_axi_gmem_out_AWLEN),
        .m_axi_gmem_out_AWLOCK(yolo_postprocess_1_m_axi_gmem_out_AWLOCK),
        .m_axi_gmem_out_AWPROT(yolo_postprocess_1_m_axi_gmem_out_AWPROT),
        .m_axi_gmem_out_AWQOS(yolo_postprocess_1_m_axi_gmem_out_AWQOS),
        .m_axi_gmem_out_AWREADY(yolo_postprocess_1_m_axi_gmem_out_AWREADY),
        .m_axi_gmem_out_AWSIZE(yolo_postprocess_1_m_axi_gmem_out_AWSIZE),
        .m_axi_gmem_out_AWVALID(yolo_postprocess_1_m_axi_gmem_out_AWVALID),
        .m_axi_gmem_out_BREADY(yolo_postprocess_1_m_axi_gmem_out_BREADY),
        .m_axi_gmem_out_BRESP(yolo_postprocess_1_m_axi_gmem_out_BRESP),
        .m_axi_gmem_out_BVALID(yolo_postprocess_1_m_axi_gmem_out_BVALID),
        .m_axi_gmem_out_RDATA({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .m_axi_gmem_out_RLAST(1'b0),
        .m_axi_gmem_out_RRESP({1'b0,1'b0}),
        .m_axi_gmem_out_RVALID(1'b0),
        .m_axi_gmem_out_WDATA(yolo_postprocess_1_m_axi_gmem_out_WDATA),
        .m_axi_gmem_out_WLAST(yolo_postprocess_1_m_axi_gmem_out_WLAST),
        .m_axi_gmem_out_WREADY(yolo_postprocess_1_m_axi_gmem_out_WREADY),
        .m_axi_gmem_out_WSTRB(yolo_postprocess_1_m_axi_gmem_out_WSTRB),
        .m_axi_gmem_out_WVALID(yolo_postprocess_1_m_axi_gmem_out_WVALID),
        .s_axi_control_ARADDR(ps8_0_axi_periph_M02_AXI_ARADDR),
        .s_axi_control_ARREADY(ps8_0_axi_periph_M02_AXI_ARREADY),
        .s_axi_control_ARVALID(ps8_0_axi_periph_M02_AXI_ARVALID),
        .s_axi_control_AWADDR(ps8_0_axi_periph_M02_AXI_AWADDR),
        .s_axi_control_AWREADY(ps8_0_axi_periph_M02_AXI_AWREADY),
        .s_axi_control_AWVALID(ps8_0_axi_periph_M02_AXI_AWVALID),
        .s_axi_control_BREADY(ps8_0_axi_periph_M02_AXI_BREADY),
        .s_axi_control_BRESP(ps8_0_axi_periph_M02_AXI_BRESP),
        .s_axi_control_BVALID(ps8_0_axi_periph_M02_AXI_BVALID),
        .s_axi_control_RDATA(ps8_0_axi_periph_M02_AXI_RDATA),
        .s_axi_control_RREADY(ps8_0_axi_periph_M02_AXI_RREADY),
        .s_axi_control_RRESP(ps8_0_axi_periph_M02_AXI_RRESP),
        .s_axi_control_RVALID(ps8_0_axi_periph_M02_AXI_RVALID),
        .s_axi_control_WDATA(ps8_0_axi_periph_M02_AXI_WDATA),
        .s_axi_control_WREADY(ps8_0_axi_periph_M02_AXI_WREADY),
        .s_axi_control_WSTRB(ps8_0_axi_periph_M02_AXI_WSTRB),
        .s_axi_control_WVALID(ps8_0_axi_periph_M02_AXI_WVALID));
  (* \saxihp0_fpd_aclk.FREQ_HZ  = "300000000" *) 
  (* \saxihp0_fpd_aclk.FREQ_HZ_TOLERANCE  = "15000000" *) 
  (* \saxihp1_fpd_aclk.FREQ_HZ  = "300000000" *) 
  (* \saxihp1_fpd_aclk.FREQ_HZ_TOLERANCE  = "15000000" *) 
  (* \saxihpc0_fpd_aclk.FREQ_HZ  = "300000000" *) 
  (* \saxihpc0_fpd_aclk.FREQ_HZ_TOLERANCE  = "15000000" *) 
  kv260_hardware_platform_zynq_ultra_ps_e_0_0 zynq_ultra_ps_e_0
       (.maxigp2_araddr(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_ARADDR),
        .maxigp2_arburst(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_ARBURST),
        .maxigp2_arcache(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_ARCACHE),
        .maxigp2_arid(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_ARID),
        .maxigp2_arlen(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_ARLEN),
        .maxigp2_arlock(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_ARLOCK),
        .maxigp2_arprot(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_ARPROT),
        .maxigp2_arqos(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_ARQOS),
        .maxigp2_arready(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_ARREADY),
        .maxigp2_arsize(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_ARSIZE),
        .maxigp2_arvalid(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_ARVALID),
        .maxigp2_awaddr(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_AWADDR),
        .maxigp2_awburst(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_AWBURST),
        .maxigp2_awcache(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_AWCACHE),
        .maxigp2_awid(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_AWID),
        .maxigp2_awlen(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_AWLEN),
        .maxigp2_awlock(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_AWLOCK),
        .maxigp2_awprot(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_AWPROT),
        .maxigp2_awqos(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_AWQOS),
        .maxigp2_awready(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_AWREADY),
        .maxigp2_awsize(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_AWSIZE),
        .maxigp2_awvalid(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_AWVALID),
        .maxigp2_bid(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_BID),
        .maxigp2_bready(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_BREADY),
        .maxigp2_bresp(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_BRESP),
        .maxigp2_bvalid(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_BVALID),
        .maxigp2_rdata(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_RDATA),
        .maxigp2_rid(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_RID),
        .maxigp2_rlast(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_RLAST),
        .maxigp2_rready(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_RREADY),
        .maxigp2_rresp(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_RRESP),
        .maxigp2_rvalid(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_RVALID),
        .maxigp2_wdata(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_WDATA),
        .maxigp2_wlast(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_WLAST),
        .maxigp2_wready(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_WREADY),
        .maxigp2_wstrb(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_WSTRB),
        .maxigp2_wvalid(zynq_ultra_ps_e_0_M_AXI_HPM0_LPD_WVALID),
        .maxihpm0_lpd_aclk(zynq_ultra_ps_e_0_pl_clk0),
        .pl_clk0(zynq_ultra_ps_e_0_pl_clk0),
        .pl_ps_irq0(axi_intc_0_irq),
        .pl_ps_irq1(vision_irq_concat_dout),
        .pl_resetn0(zynq_ultra_ps_e_0_pl_resetn0),
        .saxigp0_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_ARADDR}),
        .saxigp0_arburst(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_ARBURST),
        .saxigp0_arcache(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_ARCACHE),
        .saxigp0_arid({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .saxigp0_arlen(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_ARLEN),
        .saxigp0_arlock(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_ARLOCK),
        .saxigp0_arprot(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_ARPROT),
        .saxigp0_arqos(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_ARQOS),
        .saxigp0_arready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_ARREADY),
        .saxigp0_arsize(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_ARSIZE),
        .saxigp0_aruser(1'b0),
        .saxigp0_arvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_ARVALID),
        .saxigp0_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_AWADDR}),
        .saxigp0_awburst(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_AWBURST),
        .saxigp0_awcache(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_AWCACHE),
        .saxigp0_awid({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .saxigp0_awlen(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_AWLEN),
        .saxigp0_awlock(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_AWLOCK),
        .saxigp0_awprot(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_AWPROT),
        .saxigp0_awqos(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_AWQOS),
        .saxigp0_awready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_AWREADY),
        .saxigp0_awsize(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_AWSIZE),
        .saxigp0_awuser(1'b0),
        .saxigp0_awvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_AWVALID),
        .saxigp0_bready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_BREADY),
        .saxigp0_bresp(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_BRESP),
        .saxigp0_bvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_BVALID),
        .saxigp0_rdata(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_RDATA),
        .saxigp0_rlast(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_RLAST),
        .saxigp0_rready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_RREADY),
        .saxigp0_rresp(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_RRESP),
        .saxigp0_rvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_RVALID),
        .saxigp0_wdata(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_WDATA),
        .saxigp0_wlast(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_WLAST),
        .saxigp0_wready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_WREADY),
        .saxigp0_wstrb(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_WSTRB),
        .saxigp0_wvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_M00_AXI_WVALID),
        .saxigp2_araddr(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_ARADDR),
        .saxigp2_arburst(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_ARBURST),
        .saxigp2_arcache(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_ARCACHE),
        .saxigp2_arid({1'b0,1'b0,1'b0,1'b0,1'b0,axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_ARID}),
        .saxigp2_arlen(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_ARLEN),
        .saxigp2_arlock(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_ARLOCK),
        .saxigp2_arprot(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_ARPROT),
        .saxigp2_arqos(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_ARQOS),
        .saxigp2_arready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_ARREADY),
        .saxigp2_arsize(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_ARSIZE),
        .saxigp2_aruser(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_ARUSER),
        .saxigp2_arvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_ARVALID),
        .saxigp2_awaddr(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_AWADDR),
        .saxigp2_awburst(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_AWBURST),
        .saxigp2_awcache(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_AWCACHE),
        .saxigp2_awid({1'b0,1'b0,1'b0,1'b0,1'b0,axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_AWID}),
        .saxigp2_awlen(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_AWLEN),
        .saxigp2_awlock(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_AWLOCK),
        .saxigp2_awprot(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_AWPROT),
        .saxigp2_awqos(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_AWQOS),
        .saxigp2_awready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_AWREADY),
        .saxigp2_awsize(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_AWSIZE),
        .saxigp2_awuser(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_AWUSER),
        .saxigp2_awvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_AWVALID),
        .saxigp2_bid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_BID),
        .saxigp2_bready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_BREADY),
        .saxigp2_bresp(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_BRESP),
        .saxigp2_bvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_BVALID),
        .saxigp2_rdata(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_RDATA),
        .saxigp2_rid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_RID),
        .saxigp2_rlast(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_RLAST),
        .saxigp2_rready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_RREADY),
        .saxigp2_rresp(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_RRESP),
        .saxigp2_rvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_RVALID),
        .saxigp2_wdata(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_WDATA),
        .saxigp2_wlast(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_WLAST),
        .saxigp2_wready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_WREADY),
        .saxigp2_wstrb(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_WSTRB),
        .saxigp2_wvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_M00_AXI_WVALID),
        .saxigp3_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_ARADDR}),
        .saxigp3_arburst(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_ARBURST),
        .saxigp3_arcache(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_ARCACHE),
        .saxigp3_arid({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .saxigp3_arlen(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_ARLEN),
        .saxigp3_arlock(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_ARLOCK),
        .saxigp3_arprot(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_ARPROT),
        .saxigp3_arqos(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_ARQOS),
        .saxigp3_arready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_ARREADY),
        .saxigp3_arsize(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_ARSIZE),
        .saxigp3_aruser(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_ARUSER),
        .saxigp3_arvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_ARVALID),
        .saxigp3_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_AWADDR}),
        .saxigp3_awburst(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_AWBURST),
        .saxigp3_awcache(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_AWCACHE),
        .saxigp3_awid({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .saxigp3_awlen(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_AWLEN),
        .saxigp3_awlock(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_AWLOCK),
        .saxigp3_awprot(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_AWPROT),
        .saxigp3_awqos(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_AWQOS),
        .saxigp3_awready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_AWREADY),
        .saxigp3_awsize(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_AWSIZE),
        .saxigp3_awuser(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_AWUSER),
        .saxigp3_awvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_AWVALID),
        .saxigp3_bready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_BREADY),
        .saxigp3_bresp(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_BRESP),
        .saxigp3_bvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_BVALID),
        .saxigp3_rdata(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_RDATA),
        .saxigp3_rlast(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_RLAST),
        .saxigp3_rready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_RREADY),
        .saxigp3_rresp(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_RRESP),
        .saxigp3_rvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_RVALID),
        .saxigp3_wdata(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_WDATA),
        .saxigp3_wlast(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_WLAST),
        .saxigp3_wready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_WREADY),
        .saxigp3_wstrb(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_WSTRB),
        .saxigp3_wvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_M00_AXI_WVALID),
        .saxigp4_araddr(vision_read_sc_M00_AXI_ARADDR),
        .saxigp4_arburst(vision_read_sc_M00_AXI_ARBURST),
        .saxigp4_arcache(vision_read_sc_M00_AXI_ARCACHE),
        .saxigp4_arid({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .saxigp4_arlen(vision_read_sc_M00_AXI_ARLEN),
        .saxigp4_arlock(vision_read_sc_M00_AXI_ARLOCK),
        .saxigp4_arprot(vision_read_sc_M00_AXI_ARPROT),
        .saxigp4_arqos(vision_read_sc_M00_AXI_ARQOS),
        .saxigp4_arready(vision_read_sc_M00_AXI_ARREADY),
        .saxigp4_arsize(vision_read_sc_M00_AXI_ARSIZE),
        .saxigp4_aruser(1'b0),
        .saxigp4_arvalid(vision_read_sc_M00_AXI_ARVALID),
        .saxigp4_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .saxigp4_awburst({1'b0,1'b1}),
        .saxigp4_awcache({1'b0,1'b0,1'b1,1'b1}),
        .saxigp4_awid({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .saxigp4_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .saxigp4_awlock(1'b0),
        .saxigp4_awprot({1'b0,1'b0,1'b0}),
        .saxigp4_awqos({1'b0,1'b0,1'b0,1'b0}),
        .saxigp4_awsize({1'b1,1'b0,1'b0}),
        .saxigp4_awuser(1'b0),
        .saxigp4_awvalid(1'b0),
        .saxigp4_bready(1'b0),
        .saxigp4_rdata(vision_read_sc_M00_AXI_RDATA),
        .saxigp4_rlast(vision_read_sc_M00_AXI_RLAST),
        .saxigp4_rready(vision_read_sc_M00_AXI_RREADY),
        .saxigp4_rresp(vision_read_sc_M00_AXI_RRESP),
        .saxigp4_rvalid(vision_read_sc_M00_AXI_RVALID),
        .saxigp4_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .saxigp4_wlast(1'b0),
        .saxigp4_wstrb({1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .saxigp4_wvalid(1'b0),
        .saxigp5_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .saxigp5_arburst({1'b0,1'b1}),
        .saxigp5_arcache({1'b0,1'b0,1'b1,1'b1}),
        .saxigp5_arid({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .saxigp5_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .saxigp5_arlock(1'b0),
        .saxigp5_arprot({1'b0,1'b0,1'b0}),
        .saxigp5_arqos({1'b0,1'b0,1'b0,1'b0}),
        .saxigp5_arsize({1'b1,1'b0,1'b0}),
        .saxigp5_aruser(1'b0),
        .saxigp5_arvalid(1'b0),
        .saxigp5_awaddr(vision_write_sc_M00_AXI_AWADDR),
        .saxigp5_awburst(vision_write_sc_M00_AXI_AWBURST),
        .saxigp5_awcache(vision_write_sc_M00_AXI_AWCACHE),
        .saxigp5_awid({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .saxigp5_awlen(vision_write_sc_M00_AXI_AWLEN),
        .saxigp5_awlock(vision_write_sc_M00_AXI_AWLOCK),
        .saxigp5_awprot(vision_write_sc_M00_AXI_AWPROT),
        .saxigp5_awqos(vision_write_sc_M00_AXI_AWQOS),
        .saxigp5_awready(vision_write_sc_M00_AXI_AWREADY),
        .saxigp5_awsize(vision_write_sc_M00_AXI_AWSIZE),
        .saxigp5_awuser(1'b0),
        .saxigp5_awvalid(vision_write_sc_M00_AXI_AWVALID),
        .saxigp5_bready(vision_write_sc_M00_AXI_BREADY),
        .saxigp5_bresp(vision_write_sc_M00_AXI_BRESP),
        .saxigp5_bvalid(vision_write_sc_M00_AXI_BVALID),
        .saxigp5_rready(1'b0),
        .saxigp5_wdata(vision_write_sc_M00_AXI_WDATA),
        .saxigp5_wlast(vision_write_sc_M00_AXI_WLAST),
        .saxigp5_wready(vision_write_sc_M00_AXI_WREADY),
        .saxigp5_wstrb(vision_write_sc_M00_AXI_WSTRB),
        .saxigp5_wvalid(vision_write_sc_M00_AXI_WVALID),
        .saxihp0_fpd_aclk(clk_wiz_1_clk_out4),
        .saxihp1_fpd_aclk(clk_wiz_1_clk_out4),
        .saxihp2_fpd_aclk(clk_wiz_1_clk_out3),
        .saxihp3_fpd_aclk(clk_wiz_1_clk_out3),
        .saxihpc0_fpd_aclk(clk_wiz_1_clk_out4));
endmodule

module kv260_hardware_platform_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_0
   (ACLK,
    ARESETN,
    M00_ACLK,
    M00_ARESETN,
    M00_AXI_araddr,
    M00_AXI_arburst,
    M00_AXI_arcache,
    M00_AXI_arid,
    M00_AXI_arlen,
    M00_AXI_arlock,
    M00_AXI_arprot,
    M00_AXI_arqos,
    M00_AXI_arready,
    M00_AXI_arsize,
    M00_AXI_aruser,
    M00_AXI_arvalid,
    M00_AXI_awaddr,
    M00_AXI_awburst,
    M00_AXI_awcache,
    M00_AXI_awid,
    M00_AXI_awlen,
    M00_AXI_awlock,
    M00_AXI_awprot,
    M00_AXI_awqos,
    M00_AXI_awready,
    M00_AXI_awsize,
    M00_AXI_awuser,
    M00_AXI_awvalid,
    M00_AXI_bid,
    M00_AXI_bready,
    M00_AXI_bresp,
    M00_AXI_bvalid,
    M00_AXI_rdata,
    M00_AXI_rid,
    M00_AXI_rlast,
    M00_AXI_rready,
    M00_AXI_rresp,
    M00_AXI_rvalid,
    M00_AXI_wdata,
    M00_AXI_wlast,
    M00_AXI_wready,
    M00_AXI_wstrb,
    M00_AXI_wvalid,
    S00_ACLK,
    S00_ARESETN,
    S00_AXI_araddr,
    S00_AXI_arburst,
    S00_AXI_arcache,
    S00_AXI_arlen,
    S00_AXI_arlock,
    S00_AXI_arprot,
    S00_AXI_arqos,
    S00_AXI_arready,
    S00_AXI_arsize,
    S00_AXI_aruser,
    S00_AXI_arvalid,
    S00_AXI_awaddr,
    S00_AXI_awburst,
    S00_AXI_awcache,
    S00_AXI_awlen,
    S00_AXI_awlock,
    S00_AXI_awprot,
    S00_AXI_awqos,
    S00_AXI_awready,
    S00_AXI_awsize,
    S00_AXI_awuser,
    S00_AXI_awvalid,
    S00_AXI_bready,
    S00_AXI_bresp,
    S00_AXI_bvalid,
    S00_AXI_rdata,
    S00_AXI_rlast,
    S00_AXI_rready,
    S00_AXI_rresp,
    S00_AXI_rvalid,
    S00_AXI_wdata,
    S00_AXI_wlast,
    S00_AXI_wready,
    S00_AXI_wstrb,
    S00_AXI_wvalid,
    S01_ACLK,
    S01_ARESETN,
    S01_AXI_araddr,
    S01_AXI_arburst,
    S01_AXI_arcache,
    S01_AXI_arlen,
    S01_AXI_arlock,
    S01_AXI_arprot,
    S01_AXI_arqos,
    S01_AXI_arready,
    S01_AXI_arsize,
    S01_AXI_arvalid,
    S01_AXI_awaddr,
    S01_AXI_awburst,
    S01_AXI_awcache,
    S01_AXI_awlen,
    S01_AXI_awlock,
    S01_AXI_awprot,
    S01_AXI_awqos,
    S01_AXI_awready,
    S01_AXI_awsize,
    S01_AXI_awvalid,
    S01_AXI_bready,
    S01_AXI_bresp,
    S01_AXI_bvalid,
    S01_AXI_rdata,
    S01_AXI_rlast,
    S01_AXI_rready,
    S01_AXI_rresp,
    S01_AXI_rvalid,
    S01_AXI_wdata,
    S01_AXI_wlast,
    S01_AXI_wready,
    S01_AXI_wstrb,
    S01_AXI_wvalid);
  input ACLK;
  input ARESETN;
  input M00_ACLK;
  input M00_ARESETN;
  output [48:0]M00_AXI_araddr;
  output [1:0]M00_AXI_arburst;
  output [3:0]M00_AXI_arcache;
  output [0:0]M00_AXI_arid;
  output [7:0]M00_AXI_arlen;
  output [0:0]M00_AXI_arlock;
  output [2:0]M00_AXI_arprot;
  output [3:0]M00_AXI_arqos;
  input M00_AXI_arready;
  output [2:0]M00_AXI_arsize;
  output [0:0]M00_AXI_aruser;
  output M00_AXI_arvalid;
  output [48:0]M00_AXI_awaddr;
  output [1:0]M00_AXI_awburst;
  output [3:0]M00_AXI_awcache;
  output [0:0]M00_AXI_awid;
  output [7:0]M00_AXI_awlen;
  output [0:0]M00_AXI_awlock;
  output [2:0]M00_AXI_awprot;
  output [3:0]M00_AXI_awqos;
  input M00_AXI_awready;
  output [2:0]M00_AXI_awsize;
  output [0:0]M00_AXI_awuser;
  output M00_AXI_awvalid;
  input [5:0]M00_AXI_bid;
  output M00_AXI_bready;
  input [1:0]M00_AXI_bresp;
  input M00_AXI_bvalid;
  input [127:0]M00_AXI_rdata;
  input [5:0]M00_AXI_rid;
  input M00_AXI_rlast;
  output M00_AXI_rready;
  input [1:0]M00_AXI_rresp;
  input M00_AXI_rvalid;
  output [127:0]M00_AXI_wdata;
  output M00_AXI_wlast;
  input M00_AXI_wready;
  output [15:0]M00_AXI_wstrb;
  output M00_AXI_wvalid;
  input S00_ACLK;
  input S00_ARESETN;
  input [39:0]S00_AXI_araddr;
  input [1:0]S00_AXI_arburst;
  input [3:0]S00_AXI_arcache;
  input [7:0]S00_AXI_arlen;
  input [0:0]S00_AXI_arlock;
  input [2:0]S00_AXI_arprot;
  input [3:0]S00_AXI_arqos;
  output S00_AXI_arready;
  input [2:0]S00_AXI_arsize;
  input [0:0]S00_AXI_aruser;
  input S00_AXI_arvalid;
  input [39:0]S00_AXI_awaddr;
  input [1:0]S00_AXI_awburst;
  input [3:0]S00_AXI_awcache;
  input [7:0]S00_AXI_awlen;
  input [0:0]S00_AXI_awlock;
  input [2:0]S00_AXI_awprot;
  input [3:0]S00_AXI_awqos;
  output S00_AXI_awready;
  input [2:0]S00_AXI_awsize;
  input [0:0]S00_AXI_awuser;
  input S00_AXI_awvalid;
  input S00_AXI_bready;
  output [1:0]S00_AXI_bresp;
  output S00_AXI_bvalid;
  output [127:0]S00_AXI_rdata;
  output S00_AXI_rlast;
  input S00_AXI_rready;
  output [1:0]S00_AXI_rresp;
  output S00_AXI_rvalid;
  input [127:0]S00_AXI_wdata;
  input S00_AXI_wlast;
  output S00_AXI_wready;
  input [15:0]S00_AXI_wstrb;
  input S00_AXI_wvalid;
  input S01_ACLK;
  input S01_ARESETN;
  input [31:0]S01_AXI_araddr;
  input [1:0]S01_AXI_arburst;
  input [3:0]S01_AXI_arcache;
  input [7:0]S01_AXI_arlen;
  input [0:0]S01_AXI_arlock;
  input [2:0]S01_AXI_arprot;
  input [3:0]S01_AXI_arqos;
  output S01_AXI_arready;
  input [2:0]S01_AXI_arsize;
  input S01_AXI_arvalid;
  input [31:0]S01_AXI_awaddr;
  input [1:0]S01_AXI_awburst;
  input [3:0]S01_AXI_awcache;
  input [7:0]S01_AXI_awlen;
  input [0:0]S01_AXI_awlock;
  input [2:0]S01_AXI_awprot;
  input [3:0]S01_AXI_awqos;
  output S01_AXI_awready;
  input [2:0]S01_AXI_awsize;
  input S01_AXI_awvalid;
  input S01_AXI_bready;
  output [1:0]S01_AXI_bresp;
  output S01_AXI_bvalid;
  output [127:0]S01_AXI_rdata;
  output S01_AXI_rlast;
  input S01_AXI_rready;
  output [1:0]S01_AXI_rresp;
  output S01_AXI_rvalid;
  input [127:0]S01_AXI_wdata;
  input S01_AXI_wlast;
  output S01_AXI_wready;
  input [15:0]S01_AXI_wstrb;
  input S01_AXI_wvalid;

  wire M00_ACLK_1;
  wire M00_ARESETN_1;
  wire S00_ACLK_1;
  wire S00_ARESETN_1;
  wire S01_ACLK_1;
  wire S01_ARESETN_1;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ACLK_net;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARESETN_net;
  wire [39:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_ARADDR;
  wire [1:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_ARBURST;
  wire [3:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_ARCACHE;
  wire [7:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_ARLEN;
  wire [0:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_ARLOCK;
  wire [2:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_ARPROT;
  wire [3:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_ARQOS;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_ARREADY;
  wire [2:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_ARSIZE;
  wire [0:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_ARUSER;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_ARVALID;
  wire [39:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_AWADDR;
  wire [1:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_AWBURST;
  wire [3:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_AWCACHE;
  wire [7:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_AWLEN;
  wire [0:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_AWLOCK;
  wire [2:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_AWPROT;
  wire [3:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_AWQOS;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_AWREADY;
  wire [2:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_AWSIZE;
  wire [0:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_AWUSER;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_AWVALID;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_BREADY;
  wire [1:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_BRESP;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_BVALID;
  wire [127:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_RDATA;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_RLAST;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_RREADY;
  wire [1:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_RRESP;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_RVALID;
  wire [127:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_WDATA;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_WLAST;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_WREADY;
  wire [15:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_WSTRB;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_WVALID;
  wire [31:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_ARADDR;
  wire [1:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_ARBURST;
  wire [3:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_ARCACHE;
  wire [7:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_ARLEN;
  wire [0:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_ARLOCK;
  wire [2:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_ARPROT;
  wire [3:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_ARQOS;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_ARREADY;
  wire [2:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_ARSIZE;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_ARVALID;
  wire [31:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_AWADDR;
  wire [1:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_AWBURST;
  wire [3:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_AWCACHE;
  wire [7:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_AWLEN;
  wire [0:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_AWLOCK;
  wire [2:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_AWPROT;
  wire [3:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_AWQOS;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_AWREADY;
  wire [2:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_AWSIZE;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_AWVALID;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_BREADY;
  wire [1:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_BRESP;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_BVALID;
  wire [127:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_RDATA;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_RLAST;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_RREADY;
  wire [1:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_RRESP;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_RVALID;
  wire [127:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_WDATA;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_WLAST;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_WREADY;
  wire [15:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_WSTRB;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_WVALID;
  wire [48:0]m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARADDR;
  wire [1:0]m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARBURST;
  wire [3:0]m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARCACHE;
  wire [0:0]m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARID;
  wire [7:0]m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARLEN;
  wire [0:0]m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARLOCK;
  wire [2:0]m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARPROT;
  wire [3:0]m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARQOS;
  wire m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARREADY;
  wire [2:0]m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARSIZE;
  wire [0:0]m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARUSER;
  wire m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARVALID;
  wire [48:0]m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_AWADDR;
  wire [1:0]m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_AWBURST;
  wire [3:0]m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_AWCACHE;
  wire [0:0]m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_AWID;
  wire [7:0]m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_AWLEN;
  wire [0:0]m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_AWLOCK;
  wire [2:0]m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_AWPROT;
  wire [3:0]m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_AWQOS;
  wire m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_AWREADY;
  wire [2:0]m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_AWSIZE;
  wire [0:0]m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_AWUSER;
  wire m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_AWVALID;
  wire [5:0]m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_BID;
  wire m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_BREADY;
  wire [1:0]m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_BRESP;
  wire m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_BVALID;
  wire [127:0]m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_RDATA;
  wire [5:0]m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_RID;
  wire m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_RLAST;
  wire m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_RREADY;
  wire [1:0]m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_RRESP;
  wire m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_RVALID;
  wire [127:0]m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_WDATA;
  wire m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_WLAST;
  wire m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_WREADY;
  wire [15:0]m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_WSTRB;
  wire m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_WVALID;
  wire [39:0]s00_couplers_to_xbar_ARADDR;
  wire [1:0]s00_couplers_to_xbar_ARBURST;
  wire [3:0]s00_couplers_to_xbar_ARCACHE;
  wire [7:0]s00_couplers_to_xbar_ARLEN;
  wire [0:0]s00_couplers_to_xbar_ARLOCK;
  wire [2:0]s00_couplers_to_xbar_ARPROT;
  wire [3:0]s00_couplers_to_xbar_ARQOS;
  wire [0:0]s00_couplers_to_xbar_ARREADY;
  wire [2:0]s00_couplers_to_xbar_ARSIZE;
  wire [0:0]s00_couplers_to_xbar_ARUSER;
  wire s00_couplers_to_xbar_ARVALID;
  wire [39:0]s00_couplers_to_xbar_AWADDR;
  wire [1:0]s00_couplers_to_xbar_AWBURST;
  wire [3:0]s00_couplers_to_xbar_AWCACHE;
  wire [7:0]s00_couplers_to_xbar_AWLEN;
  wire [0:0]s00_couplers_to_xbar_AWLOCK;
  wire [2:0]s00_couplers_to_xbar_AWPROT;
  wire [3:0]s00_couplers_to_xbar_AWQOS;
  wire [0:0]s00_couplers_to_xbar_AWREADY;
  wire [2:0]s00_couplers_to_xbar_AWSIZE;
  wire [0:0]s00_couplers_to_xbar_AWUSER;
  wire s00_couplers_to_xbar_AWVALID;
  wire s00_couplers_to_xbar_BREADY;
  wire [1:0]s00_couplers_to_xbar_BRESP;
  wire [0:0]s00_couplers_to_xbar_BVALID;
  wire [127:0]s00_couplers_to_xbar_RDATA;
  wire [0:0]s00_couplers_to_xbar_RLAST;
  wire s00_couplers_to_xbar_RREADY;
  wire [1:0]s00_couplers_to_xbar_RRESP;
  wire [0:0]s00_couplers_to_xbar_RVALID;
  wire [127:0]s00_couplers_to_xbar_WDATA;
  wire s00_couplers_to_xbar_WLAST;
  wire [0:0]s00_couplers_to_xbar_WREADY;
  wire [15:0]s00_couplers_to_xbar_WSTRB;
  wire s00_couplers_to_xbar_WVALID;
  wire [31:0]s01_couplers_to_xbar_ARADDR;
  wire [1:0]s01_couplers_to_xbar_ARBURST;
  wire [3:0]s01_couplers_to_xbar_ARCACHE;
  wire [7:0]s01_couplers_to_xbar_ARLEN;
  wire [0:0]s01_couplers_to_xbar_ARLOCK;
  wire [2:0]s01_couplers_to_xbar_ARPROT;
  wire [3:0]s01_couplers_to_xbar_ARQOS;
  wire [1:1]s01_couplers_to_xbar_ARREADY;
  wire [2:0]s01_couplers_to_xbar_ARSIZE;
  wire s01_couplers_to_xbar_ARVALID;
  wire [31:0]s01_couplers_to_xbar_AWADDR;
  wire [1:0]s01_couplers_to_xbar_AWBURST;
  wire [3:0]s01_couplers_to_xbar_AWCACHE;
  wire [7:0]s01_couplers_to_xbar_AWLEN;
  wire [0:0]s01_couplers_to_xbar_AWLOCK;
  wire [2:0]s01_couplers_to_xbar_AWPROT;
  wire [3:0]s01_couplers_to_xbar_AWQOS;
  wire [1:1]s01_couplers_to_xbar_AWREADY;
  wire [2:0]s01_couplers_to_xbar_AWSIZE;
  wire s01_couplers_to_xbar_AWVALID;
  wire s01_couplers_to_xbar_BREADY;
  wire [3:2]s01_couplers_to_xbar_BRESP;
  wire [1:1]s01_couplers_to_xbar_BVALID;
  wire [255:128]s01_couplers_to_xbar_RDATA;
  wire [1:1]s01_couplers_to_xbar_RLAST;
  wire s01_couplers_to_xbar_RREADY;
  wire [3:2]s01_couplers_to_xbar_RRESP;
  wire [1:1]s01_couplers_to_xbar_RVALID;
  wire [127:0]s01_couplers_to_xbar_WDATA;
  wire s01_couplers_to_xbar_WLAST;
  wire [1:1]s01_couplers_to_xbar_WREADY;
  wire [15:0]s01_couplers_to_xbar_WSTRB;
  wire s01_couplers_to_xbar_WVALID;
  wire [39:0]xbar_to_m00_couplers_ARADDR;
  wire [1:0]xbar_to_m00_couplers_ARBURST;
  wire [3:0]xbar_to_m00_couplers_ARCACHE;
  wire [0:0]xbar_to_m00_couplers_ARID;
  wire [7:0]xbar_to_m00_couplers_ARLEN;
  wire [0:0]xbar_to_m00_couplers_ARLOCK;
  wire [2:0]xbar_to_m00_couplers_ARPROT;
  wire [3:0]xbar_to_m00_couplers_ARQOS;
  wire xbar_to_m00_couplers_ARREADY;
  wire [3:0]xbar_to_m00_couplers_ARREGION;
  wire [2:0]xbar_to_m00_couplers_ARSIZE;
  wire [0:0]xbar_to_m00_couplers_ARUSER;
  wire [0:0]xbar_to_m00_couplers_ARVALID;
  wire [39:0]xbar_to_m00_couplers_AWADDR;
  wire [1:0]xbar_to_m00_couplers_AWBURST;
  wire [3:0]xbar_to_m00_couplers_AWCACHE;
  wire [0:0]xbar_to_m00_couplers_AWID;
  wire [7:0]xbar_to_m00_couplers_AWLEN;
  wire [0:0]xbar_to_m00_couplers_AWLOCK;
  wire [2:0]xbar_to_m00_couplers_AWPROT;
  wire [3:0]xbar_to_m00_couplers_AWQOS;
  wire xbar_to_m00_couplers_AWREADY;
  wire [3:0]xbar_to_m00_couplers_AWREGION;
  wire [2:0]xbar_to_m00_couplers_AWSIZE;
  wire [0:0]xbar_to_m00_couplers_AWUSER;
  wire [0:0]xbar_to_m00_couplers_AWVALID;
  wire [0:0]xbar_to_m00_couplers_BID;
  wire [0:0]xbar_to_m00_couplers_BREADY;
  wire [1:0]xbar_to_m00_couplers_BRESP;
  wire xbar_to_m00_couplers_BVALID;
  wire [127:0]xbar_to_m00_couplers_RDATA;
  wire [0:0]xbar_to_m00_couplers_RID;
  wire xbar_to_m00_couplers_RLAST;
  wire [0:0]xbar_to_m00_couplers_RREADY;
  wire [1:0]xbar_to_m00_couplers_RRESP;
  wire xbar_to_m00_couplers_RVALID;
  wire [127:0]xbar_to_m00_couplers_WDATA;
  wire [0:0]xbar_to_m00_couplers_WLAST;
  wire xbar_to_m00_couplers_WREADY;
  wire [15:0]xbar_to_m00_couplers_WSTRB;
  wire [0:0]xbar_to_m00_couplers_WVALID;

  assign M00_ACLK_1 = M00_ACLK;
  assign M00_ARESETN_1 = M00_ARESETN;
  assign M00_AXI_araddr[48:0] = m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARADDR;
  assign M00_AXI_arburst[1:0] = m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARBURST;
  assign M00_AXI_arcache[3:0] = m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARCACHE;
  assign M00_AXI_arid[0] = m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARID;
  assign M00_AXI_arlen[7:0] = m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARLEN;
  assign M00_AXI_arlock[0] = m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARLOCK;
  assign M00_AXI_arprot[2:0] = m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARPROT;
  assign M00_AXI_arqos[3:0] = m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARQOS;
  assign M00_AXI_arsize[2:0] = m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARSIZE;
  assign M00_AXI_aruser[0] = m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARUSER;
  assign M00_AXI_arvalid = m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARVALID;
  assign M00_AXI_awaddr[48:0] = m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_AWADDR;
  assign M00_AXI_awburst[1:0] = m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_AWBURST;
  assign M00_AXI_awcache[3:0] = m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_AWCACHE;
  assign M00_AXI_awid[0] = m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_AWID;
  assign M00_AXI_awlen[7:0] = m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_AWLEN;
  assign M00_AXI_awlock[0] = m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_AWLOCK;
  assign M00_AXI_awprot[2:0] = m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_AWPROT;
  assign M00_AXI_awqos[3:0] = m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_AWQOS;
  assign M00_AXI_awsize[2:0] = m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_AWSIZE;
  assign M00_AXI_awuser[0] = m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_AWUSER;
  assign M00_AXI_awvalid = m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_AWVALID;
  assign M00_AXI_bready = m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_BREADY;
  assign M00_AXI_rready = m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_RREADY;
  assign M00_AXI_wdata[127:0] = m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_WDATA;
  assign M00_AXI_wlast = m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_WLAST;
  assign M00_AXI_wstrb[15:0] = m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_WSTRB;
  assign M00_AXI_wvalid = m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_WVALID;
  assign S00_ACLK_1 = S00_ACLK;
  assign S00_ARESETN_1 = S00_ARESETN;
  assign S00_AXI_arready = axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_ARREADY;
  assign S00_AXI_awready = axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_AWREADY;
  assign S00_AXI_bresp[1:0] = axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_BRESP;
  assign S00_AXI_bvalid = axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_BVALID;
  assign S00_AXI_rdata[127:0] = axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_RDATA;
  assign S00_AXI_rlast = axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_RLAST;
  assign S00_AXI_rresp[1:0] = axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_RRESP;
  assign S00_AXI_rvalid = axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_RVALID;
  assign S00_AXI_wready = axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_WREADY;
  assign S01_ACLK_1 = S01_ACLK;
  assign S01_ARESETN_1 = S01_ARESETN;
  assign S01_AXI_arready = axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_ARREADY;
  assign S01_AXI_awready = axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_AWREADY;
  assign S01_AXI_bresp[1:0] = axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_BRESP;
  assign S01_AXI_bvalid = axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_BVALID;
  assign S01_AXI_rdata[127:0] = axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_RDATA;
  assign S01_AXI_rlast = axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_RLAST;
  assign S01_AXI_rresp[1:0] = axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_RRESP;
  assign S01_AXI_rvalid = axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_RVALID;
  assign S01_AXI_wready = axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_WREADY;
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ACLK_net = ACLK;
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARESETN_net = ARESETN;
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_ARADDR = S00_AXI_araddr[39:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_ARBURST = S00_AXI_arburst[1:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_ARCACHE = S00_AXI_arcache[3:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_ARLEN = S00_AXI_arlen[7:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_ARLOCK = S00_AXI_arlock[0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_ARPROT = S00_AXI_arprot[2:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_ARQOS = S00_AXI_arqos[3:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_ARSIZE = S00_AXI_arsize[2:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_ARUSER = S00_AXI_aruser[0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_ARVALID = S00_AXI_arvalid;
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_AWADDR = S00_AXI_awaddr[39:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_AWBURST = S00_AXI_awburst[1:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_AWCACHE = S00_AXI_awcache[3:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_AWLEN = S00_AXI_awlen[7:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_AWLOCK = S00_AXI_awlock[0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_AWPROT = S00_AXI_awprot[2:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_AWQOS = S00_AXI_awqos[3:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_AWSIZE = S00_AXI_awsize[2:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_AWUSER = S00_AXI_awuser[0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_AWVALID = S00_AXI_awvalid;
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_BREADY = S00_AXI_bready;
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_RREADY = S00_AXI_rready;
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_WDATA = S00_AXI_wdata[127:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_WLAST = S00_AXI_wlast;
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_WSTRB = S00_AXI_wstrb[15:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_WVALID = S00_AXI_wvalid;
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_ARADDR = S01_AXI_araddr[31:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_ARBURST = S01_AXI_arburst[1:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_ARCACHE = S01_AXI_arcache[3:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_ARLEN = S01_AXI_arlen[7:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_ARLOCK = S01_AXI_arlock[0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_ARPROT = S01_AXI_arprot[2:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_ARQOS = S01_AXI_arqos[3:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_ARSIZE = S01_AXI_arsize[2:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_ARVALID = S01_AXI_arvalid;
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_AWADDR = S01_AXI_awaddr[31:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_AWBURST = S01_AXI_awburst[1:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_AWCACHE = S01_AXI_awcache[3:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_AWLEN = S01_AXI_awlen[7:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_AWLOCK = S01_AXI_awlock[0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_AWPROT = S01_AXI_awprot[2:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_AWQOS = S01_AXI_awqos[3:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_AWSIZE = S01_AXI_awsize[2:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_AWVALID = S01_AXI_awvalid;
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_BREADY = S01_AXI_bready;
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_RREADY = S01_AXI_rready;
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_WDATA = S01_AXI_wdata[127:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_WLAST = S01_AXI_wlast;
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_WSTRB = S01_AXI_wstrb[15:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_WVALID = S01_AXI_wvalid;
  assign m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARREADY = M00_AXI_arready;
  assign m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_AWREADY = M00_AXI_awready;
  assign m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_BID = M00_AXI_bid[5:0];
  assign m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_BRESP = M00_AXI_bresp[1:0];
  assign m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_BVALID = M00_AXI_bvalid;
  assign m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_RDATA = M00_AXI_rdata[127:0];
  assign m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_RID = M00_AXI_rid[5:0];
  assign m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_RLAST = M00_AXI_rlast;
  assign m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_RRESP = M00_AXI_rresp[1:0];
  assign m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_RVALID = M00_AXI_rvalid;
  assign m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_WREADY = M00_AXI_wready;
  m00_couplers_imp_1I1E5EU m00_couplers
       (.M_ACLK(M00_ACLK_1),
        .M_ARESETN(M00_ARESETN_1),
        .M_AXI_araddr(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARADDR),
        .M_AXI_arburst(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARBURST),
        .M_AXI_arcache(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARCACHE),
        .M_AXI_arid(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARID),
        .M_AXI_arlen(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARLEN),
        .M_AXI_arlock(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARLOCK),
        .M_AXI_arprot(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARPROT),
        .M_AXI_arqos(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARQOS),
        .M_AXI_arready(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARREADY),
        .M_AXI_arsize(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARSIZE),
        .M_AXI_aruser(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARUSER),
        .M_AXI_arvalid(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARVALID),
        .M_AXI_awaddr(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_AWADDR),
        .M_AXI_awburst(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_AWBURST),
        .M_AXI_awcache(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_AWCACHE),
        .M_AXI_awid(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_AWID),
        .M_AXI_awlen(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_AWLEN),
        .M_AXI_awlock(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_AWLOCK),
        .M_AXI_awprot(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_AWPROT),
        .M_AXI_awqos(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_AWQOS),
        .M_AXI_awready(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_AWREADY),
        .M_AXI_awsize(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_AWSIZE),
        .M_AXI_awuser(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_AWUSER),
        .M_AXI_awvalid(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_AWVALID),
        .M_AXI_bid(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_BID),
        .M_AXI_bready(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_BREADY),
        .M_AXI_bresp(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_BRESP),
        .M_AXI_bvalid(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_BVALID),
        .M_AXI_rdata(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_RDATA),
        .M_AXI_rid(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_RID),
        .M_AXI_rlast(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_RLAST),
        .M_AXI_rready(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_RREADY),
        .M_AXI_rresp(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_RRESP),
        .M_AXI_rvalid(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_RVALID),
        .M_AXI_wdata(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_WDATA),
        .M_AXI_wlast(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_WLAST),
        .M_AXI_wready(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_WREADY),
        .M_AXI_wstrb(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_WSTRB),
        .M_AXI_wvalid(m00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_WVALID),
        .S_ACLK(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ACLK_net),
        .S_ARESETN(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARESETN_net),
        .S_AXI_araddr(xbar_to_m00_couplers_ARADDR),
        .S_AXI_arburst(xbar_to_m00_couplers_ARBURST),
        .S_AXI_arcache(xbar_to_m00_couplers_ARCACHE),
        .S_AXI_arid(xbar_to_m00_couplers_ARID),
        .S_AXI_arlen(xbar_to_m00_couplers_ARLEN),
        .S_AXI_arlock(xbar_to_m00_couplers_ARLOCK),
        .S_AXI_arprot(xbar_to_m00_couplers_ARPROT),
        .S_AXI_arqos(xbar_to_m00_couplers_ARQOS),
        .S_AXI_arready(xbar_to_m00_couplers_ARREADY),
        .S_AXI_arregion(xbar_to_m00_couplers_ARREGION),
        .S_AXI_arsize(xbar_to_m00_couplers_ARSIZE),
        .S_AXI_aruser(xbar_to_m00_couplers_ARUSER),
        .S_AXI_arvalid(xbar_to_m00_couplers_ARVALID),
        .S_AXI_awaddr(xbar_to_m00_couplers_AWADDR),
        .S_AXI_awburst(xbar_to_m00_couplers_AWBURST),
        .S_AXI_awcache(xbar_to_m00_couplers_AWCACHE),
        .S_AXI_awid(xbar_to_m00_couplers_AWID),
        .S_AXI_awlen(xbar_to_m00_couplers_AWLEN),
        .S_AXI_awlock(xbar_to_m00_couplers_AWLOCK),
        .S_AXI_awprot(xbar_to_m00_couplers_AWPROT),
        .S_AXI_awqos(xbar_to_m00_couplers_AWQOS),
        .S_AXI_awready(xbar_to_m00_couplers_AWREADY),
        .S_AXI_awregion(xbar_to_m00_couplers_AWREGION),
        .S_AXI_awsize(xbar_to_m00_couplers_AWSIZE),
        .S_AXI_awuser(xbar_to_m00_couplers_AWUSER),
        .S_AXI_awvalid(xbar_to_m00_couplers_AWVALID),
        .S_AXI_bid(xbar_to_m00_couplers_BID),
        .S_AXI_bready(xbar_to_m00_couplers_BREADY),
        .S_AXI_bresp(xbar_to_m00_couplers_BRESP),
        .S_AXI_bvalid(xbar_to_m00_couplers_BVALID),
        .S_AXI_rdata(xbar_to_m00_couplers_RDATA),
        .S_AXI_rid(xbar_to_m00_couplers_RID),
        .S_AXI_rlast(xbar_to_m00_couplers_RLAST),
        .S_AXI_rready(xbar_to_m00_couplers_RREADY),
        .S_AXI_rresp(xbar_to_m00_couplers_RRESP),
        .S_AXI_rvalid(xbar_to_m00_couplers_RVALID),
        .S_AXI_wdata(xbar_to_m00_couplers_WDATA),
        .S_AXI_wlast(xbar_to_m00_couplers_WLAST),
        .S_AXI_wready(xbar_to_m00_couplers_WREADY),
        .S_AXI_wstrb(xbar_to_m00_couplers_WSTRB),
        .S_AXI_wvalid(xbar_to_m00_couplers_WVALID));
  s00_couplers_imp_12R3ISB s00_couplers
       (.M_ACLK(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ACLK_net),
        .M_ARESETN(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARESETN_net),
        .M_AXI_araddr(s00_couplers_to_xbar_ARADDR),
        .M_AXI_arburst(s00_couplers_to_xbar_ARBURST),
        .M_AXI_arcache(s00_couplers_to_xbar_ARCACHE),
        .M_AXI_arlen(s00_couplers_to_xbar_ARLEN),
        .M_AXI_arlock(s00_couplers_to_xbar_ARLOCK),
        .M_AXI_arprot(s00_couplers_to_xbar_ARPROT),
        .M_AXI_arqos(s00_couplers_to_xbar_ARQOS),
        .M_AXI_arready(s00_couplers_to_xbar_ARREADY),
        .M_AXI_arsize(s00_couplers_to_xbar_ARSIZE),
        .M_AXI_aruser(s00_couplers_to_xbar_ARUSER),
        .M_AXI_arvalid(s00_couplers_to_xbar_ARVALID),
        .M_AXI_awaddr(s00_couplers_to_xbar_AWADDR),
        .M_AXI_awburst(s00_couplers_to_xbar_AWBURST),
        .M_AXI_awcache(s00_couplers_to_xbar_AWCACHE),
        .M_AXI_awlen(s00_couplers_to_xbar_AWLEN),
        .M_AXI_awlock(s00_couplers_to_xbar_AWLOCK),
        .M_AXI_awprot(s00_couplers_to_xbar_AWPROT),
        .M_AXI_awqos(s00_couplers_to_xbar_AWQOS),
        .M_AXI_awready(s00_couplers_to_xbar_AWREADY),
        .M_AXI_awsize(s00_couplers_to_xbar_AWSIZE),
        .M_AXI_awuser(s00_couplers_to_xbar_AWUSER),
        .M_AXI_awvalid(s00_couplers_to_xbar_AWVALID),
        .M_AXI_bready(s00_couplers_to_xbar_BREADY),
        .M_AXI_bresp(s00_couplers_to_xbar_BRESP),
        .M_AXI_bvalid(s00_couplers_to_xbar_BVALID),
        .M_AXI_rdata(s00_couplers_to_xbar_RDATA),
        .M_AXI_rlast(s00_couplers_to_xbar_RLAST),
        .M_AXI_rready(s00_couplers_to_xbar_RREADY),
        .M_AXI_rresp(s00_couplers_to_xbar_RRESP),
        .M_AXI_rvalid(s00_couplers_to_xbar_RVALID),
        .M_AXI_wdata(s00_couplers_to_xbar_WDATA),
        .M_AXI_wlast(s00_couplers_to_xbar_WLAST),
        .M_AXI_wready(s00_couplers_to_xbar_WREADY),
        .M_AXI_wstrb(s00_couplers_to_xbar_WSTRB),
        .M_AXI_wvalid(s00_couplers_to_xbar_WVALID),
        .S_ACLK(S00_ACLK_1),
        .S_ARESETN(S00_ARESETN_1),
        .S_AXI_araddr(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_ARADDR),
        .S_AXI_arburst(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_ARBURST),
        .S_AXI_arcache(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_ARCACHE),
        .S_AXI_arlen(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_ARLEN),
        .S_AXI_arlock(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_ARLOCK),
        .S_AXI_arprot(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_ARPROT),
        .S_AXI_arqos(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_ARQOS),
        .S_AXI_arready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_ARREADY),
        .S_AXI_arsize(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_ARSIZE),
        .S_AXI_aruser(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_ARUSER),
        .S_AXI_arvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_ARVALID),
        .S_AXI_awaddr(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_AWADDR),
        .S_AXI_awburst(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_AWBURST),
        .S_AXI_awcache(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_AWCACHE),
        .S_AXI_awlen(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_AWLEN),
        .S_AXI_awlock(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_AWLOCK),
        .S_AXI_awprot(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_AWPROT),
        .S_AXI_awqos(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_AWQOS),
        .S_AXI_awready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_AWREADY),
        .S_AXI_awsize(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_AWSIZE),
        .S_AXI_awuser(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_AWUSER),
        .S_AXI_awvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_AWVALID),
        .S_AXI_bready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_BREADY),
        .S_AXI_bresp(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_BRESP),
        .S_AXI_bvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_BVALID),
        .S_AXI_rdata(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_RDATA),
        .S_AXI_rlast(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_RLAST),
        .S_AXI_rready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_RREADY),
        .S_AXI_rresp(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_RRESP),
        .S_AXI_rvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_RVALID),
        .S_AXI_wdata(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_WDATA),
        .S_AXI_wlast(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_WLAST),
        .S_AXI_wready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_WREADY),
        .S_AXI_wstrb(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_WSTRB),
        .S_AXI_wvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s00_couplers_WVALID));
  s01_couplers_imp_1GJB8RS s01_couplers
       (.M_ACLK(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ACLK_net),
        .M_ARESETN(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARESETN_net),
        .M_AXI_araddr(s01_couplers_to_xbar_ARADDR),
        .M_AXI_arburst(s01_couplers_to_xbar_ARBURST),
        .M_AXI_arcache(s01_couplers_to_xbar_ARCACHE),
        .M_AXI_arlen(s01_couplers_to_xbar_ARLEN),
        .M_AXI_arlock(s01_couplers_to_xbar_ARLOCK),
        .M_AXI_arprot(s01_couplers_to_xbar_ARPROT),
        .M_AXI_arqos(s01_couplers_to_xbar_ARQOS),
        .M_AXI_arready(s01_couplers_to_xbar_ARREADY),
        .M_AXI_arsize(s01_couplers_to_xbar_ARSIZE),
        .M_AXI_arvalid(s01_couplers_to_xbar_ARVALID),
        .M_AXI_awaddr(s01_couplers_to_xbar_AWADDR),
        .M_AXI_awburst(s01_couplers_to_xbar_AWBURST),
        .M_AXI_awcache(s01_couplers_to_xbar_AWCACHE),
        .M_AXI_awlen(s01_couplers_to_xbar_AWLEN),
        .M_AXI_awlock(s01_couplers_to_xbar_AWLOCK),
        .M_AXI_awprot(s01_couplers_to_xbar_AWPROT),
        .M_AXI_awqos(s01_couplers_to_xbar_AWQOS),
        .M_AXI_awready(s01_couplers_to_xbar_AWREADY),
        .M_AXI_awsize(s01_couplers_to_xbar_AWSIZE),
        .M_AXI_awvalid(s01_couplers_to_xbar_AWVALID),
        .M_AXI_bready(s01_couplers_to_xbar_BREADY),
        .M_AXI_bresp(s01_couplers_to_xbar_BRESP),
        .M_AXI_bvalid(s01_couplers_to_xbar_BVALID),
        .M_AXI_rdata(s01_couplers_to_xbar_RDATA),
        .M_AXI_rlast(s01_couplers_to_xbar_RLAST),
        .M_AXI_rready(s01_couplers_to_xbar_RREADY),
        .M_AXI_rresp(s01_couplers_to_xbar_RRESP),
        .M_AXI_rvalid(s01_couplers_to_xbar_RVALID),
        .M_AXI_wdata(s01_couplers_to_xbar_WDATA),
        .M_AXI_wlast(s01_couplers_to_xbar_WLAST),
        .M_AXI_wready(s01_couplers_to_xbar_WREADY),
        .M_AXI_wstrb(s01_couplers_to_xbar_WSTRB),
        .M_AXI_wvalid(s01_couplers_to_xbar_WVALID),
        .S_ACLK(S01_ACLK_1),
        .S_ARESETN(S01_ARESETN_1),
        .S_AXI_araddr(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_ARADDR),
        .S_AXI_arburst(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_ARBURST),
        .S_AXI_arcache(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_ARCACHE),
        .S_AXI_arlen(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_ARLEN),
        .S_AXI_arlock(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_ARLOCK),
        .S_AXI_arprot(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_ARPROT),
        .S_AXI_arqos(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_ARQOS),
        .S_AXI_arready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_ARREADY),
        .S_AXI_arsize(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_ARSIZE),
        .S_AXI_arvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_ARVALID),
        .S_AXI_awaddr(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_AWADDR),
        .S_AXI_awburst(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_AWBURST),
        .S_AXI_awcache(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_AWCACHE),
        .S_AXI_awlen(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_AWLEN),
        .S_AXI_awlock(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_AWLOCK),
        .S_AXI_awprot(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_AWPROT),
        .S_AXI_awqos(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_AWQOS),
        .S_AXI_awready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_AWREADY),
        .S_AXI_awsize(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_AWSIZE),
        .S_AXI_awvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_AWVALID),
        .S_AXI_bready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_BREADY),
        .S_AXI_bresp(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_BRESP),
        .S_AXI_bvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_BVALID),
        .S_AXI_rdata(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_RDATA),
        .S_AXI_rlast(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_RLAST),
        .S_AXI_rready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_RREADY),
        .S_AXI_rresp(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_RRESP),
        .S_AXI_rvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_RVALID),
        .S_AXI_wdata(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_WDATA),
        .S_AXI_wlast(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_WLAST),
        .S_AXI_wready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_WREADY),
        .S_AXI_wstrb(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_WSTRB),
        .S_AXI_wvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_to_s01_couplers_WVALID));
  kv260_hardware_platform_xbar_1 xbar
       (.aclk(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ACLK_net),
        .aresetn(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD_ARESETN_net),
        .m_axi_araddr(xbar_to_m00_couplers_ARADDR),
        .m_axi_arburst(xbar_to_m00_couplers_ARBURST),
        .m_axi_arcache(xbar_to_m00_couplers_ARCACHE),
        .m_axi_arid(xbar_to_m00_couplers_ARID),
        .m_axi_arlen(xbar_to_m00_couplers_ARLEN),
        .m_axi_arlock(xbar_to_m00_couplers_ARLOCK),
        .m_axi_arprot(xbar_to_m00_couplers_ARPROT),
        .m_axi_arqos(xbar_to_m00_couplers_ARQOS),
        .m_axi_arready(xbar_to_m00_couplers_ARREADY),
        .m_axi_arregion(xbar_to_m00_couplers_ARREGION),
        .m_axi_arsize(xbar_to_m00_couplers_ARSIZE),
        .m_axi_aruser(xbar_to_m00_couplers_ARUSER),
        .m_axi_arvalid(xbar_to_m00_couplers_ARVALID),
        .m_axi_awaddr(xbar_to_m00_couplers_AWADDR),
        .m_axi_awburst(xbar_to_m00_couplers_AWBURST),
        .m_axi_awcache(xbar_to_m00_couplers_AWCACHE),
        .m_axi_awid(xbar_to_m00_couplers_AWID),
        .m_axi_awlen(xbar_to_m00_couplers_AWLEN),
        .m_axi_awlock(xbar_to_m00_couplers_AWLOCK),
        .m_axi_awprot(xbar_to_m00_couplers_AWPROT),
        .m_axi_awqos(xbar_to_m00_couplers_AWQOS),
        .m_axi_awready(xbar_to_m00_couplers_AWREADY),
        .m_axi_awregion(xbar_to_m00_couplers_AWREGION),
        .m_axi_awsize(xbar_to_m00_couplers_AWSIZE),
        .m_axi_awuser(xbar_to_m00_couplers_AWUSER),
        .m_axi_awvalid(xbar_to_m00_couplers_AWVALID),
        .m_axi_bid(xbar_to_m00_couplers_BID),
        .m_axi_bready(xbar_to_m00_couplers_BREADY),
        .m_axi_bresp(xbar_to_m00_couplers_BRESP),
        .m_axi_bvalid(xbar_to_m00_couplers_BVALID),
        .m_axi_rdata(xbar_to_m00_couplers_RDATA),
        .m_axi_rid(xbar_to_m00_couplers_RID),
        .m_axi_rlast(xbar_to_m00_couplers_RLAST),
        .m_axi_rready(xbar_to_m00_couplers_RREADY),
        .m_axi_rresp(xbar_to_m00_couplers_RRESP),
        .m_axi_rvalid(xbar_to_m00_couplers_RVALID),
        .m_axi_wdata(xbar_to_m00_couplers_WDATA),
        .m_axi_wlast(xbar_to_m00_couplers_WLAST),
        .m_axi_wready(xbar_to_m00_couplers_WREADY),
        .m_axi_wstrb(xbar_to_m00_couplers_WSTRB),
        .m_axi_wvalid(xbar_to_m00_couplers_WVALID),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s01_couplers_to_xbar_ARADDR,s00_couplers_to_xbar_ARADDR}),
        .s_axi_arburst({s01_couplers_to_xbar_ARBURST,s00_couplers_to_xbar_ARBURST}),
        .s_axi_arcache({s01_couplers_to_xbar_ARCACHE,s00_couplers_to_xbar_ARCACHE}),
        .s_axi_arid({1'b0,1'b0}),
        .s_axi_arlen({s01_couplers_to_xbar_ARLEN,s00_couplers_to_xbar_ARLEN}),
        .s_axi_arlock({s01_couplers_to_xbar_ARLOCK,s00_couplers_to_xbar_ARLOCK}),
        .s_axi_arprot({s01_couplers_to_xbar_ARPROT,s00_couplers_to_xbar_ARPROT}),
        .s_axi_arqos({s01_couplers_to_xbar_ARQOS,s00_couplers_to_xbar_ARQOS}),
        .s_axi_arready({s01_couplers_to_xbar_ARREADY,s00_couplers_to_xbar_ARREADY}),
        .s_axi_arsize({s01_couplers_to_xbar_ARSIZE,s00_couplers_to_xbar_ARSIZE}),
        .s_axi_aruser({1'b0,s00_couplers_to_xbar_ARUSER}),
        .s_axi_arvalid({s01_couplers_to_xbar_ARVALID,s00_couplers_to_xbar_ARVALID}),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s01_couplers_to_xbar_AWADDR,s00_couplers_to_xbar_AWADDR}),
        .s_axi_awburst({s01_couplers_to_xbar_AWBURST,s00_couplers_to_xbar_AWBURST}),
        .s_axi_awcache({s01_couplers_to_xbar_AWCACHE,s00_couplers_to_xbar_AWCACHE}),
        .s_axi_awid({1'b0,1'b0}),
        .s_axi_awlen({s01_couplers_to_xbar_AWLEN,s00_couplers_to_xbar_AWLEN}),
        .s_axi_awlock({s01_couplers_to_xbar_AWLOCK,s00_couplers_to_xbar_AWLOCK}),
        .s_axi_awprot({s01_couplers_to_xbar_AWPROT,s00_couplers_to_xbar_AWPROT}),
        .s_axi_awqos({s01_couplers_to_xbar_AWQOS,s00_couplers_to_xbar_AWQOS}),
        .s_axi_awready({s01_couplers_to_xbar_AWREADY,s00_couplers_to_xbar_AWREADY}),
        .s_axi_awsize({s01_couplers_to_xbar_AWSIZE,s00_couplers_to_xbar_AWSIZE}),
        .s_axi_awuser({1'b0,s00_couplers_to_xbar_AWUSER}),
        .s_axi_awvalid({s01_couplers_to_xbar_AWVALID,s00_couplers_to_xbar_AWVALID}),
        .s_axi_bready({s01_couplers_to_xbar_BREADY,s00_couplers_to_xbar_BREADY}),
        .s_axi_bresp({s01_couplers_to_xbar_BRESP,s00_couplers_to_xbar_BRESP}),
        .s_axi_bvalid({s01_couplers_to_xbar_BVALID,s00_couplers_to_xbar_BVALID}),
        .s_axi_rdata({s01_couplers_to_xbar_RDATA,s00_couplers_to_xbar_RDATA}),
        .s_axi_rlast({s01_couplers_to_xbar_RLAST,s00_couplers_to_xbar_RLAST}),
        .s_axi_rready({s01_couplers_to_xbar_RREADY,s00_couplers_to_xbar_RREADY}),
        .s_axi_rresp({s01_couplers_to_xbar_RRESP,s00_couplers_to_xbar_RRESP}),
        .s_axi_rvalid({s01_couplers_to_xbar_RVALID,s00_couplers_to_xbar_RVALID}),
        .s_axi_wdata({s01_couplers_to_xbar_WDATA,s00_couplers_to_xbar_WDATA}),
        .s_axi_wlast({s01_couplers_to_xbar_WLAST,s00_couplers_to_xbar_WLAST}),
        .s_axi_wready({s01_couplers_to_xbar_WREADY,s00_couplers_to_xbar_WREADY}),
        .s_axi_wstrb({s01_couplers_to_xbar_WSTRB,s00_couplers_to_xbar_WSTRB}),
        .s_axi_wvalid({s01_couplers_to_xbar_WVALID,s00_couplers_to_xbar_WVALID}));
endmodule

module kv260_hardware_platform_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_0
   (ACLK,
    ARESETN,
    M00_ACLK,
    M00_ARESETN,
    M00_AXI_araddr,
    M00_AXI_arburst,
    M00_AXI_arcache,
    M00_AXI_arlen,
    M00_AXI_arlock,
    M00_AXI_arprot,
    M00_AXI_arqos,
    M00_AXI_arready,
    M00_AXI_arsize,
    M00_AXI_aruser,
    M00_AXI_arvalid,
    M00_AXI_awaddr,
    M00_AXI_awburst,
    M00_AXI_awcache,
    M00_AXI_awlen,
    M00_AXI_awlock,
    M00_AXI_awprot,
    M00_AXI_awqos,
    M00_AXI_awready,
    M00_AXI_awsize,
    M00_AXI_awuser,
    M00_AXI_awvalid,
    M00_AXI_bready,
    M00_AXI_bresp,
    M00_AXI_bvalid,
    M00_AXI_rdata,
    M00_AXI_rlast,
    M00_AXI_rready,
    M00_AXI_rresp,
    M00_AXI_rvalid,
    M00_AXI_wdata,
    M00_AXI_wlast,
    M00_AXI_wready,
    M00_AXI_wstrb,
    M00_AXI_wvalid,
    S00_ACLK,
    S00_ARESETN,
    S00_AXI_araddr,
    S00_AXI_arburst,
    S00_AXI_arcache,
    S00_AXI_arlen,
    S00_AXI_arlock,
    S00_AXI_arprot,
    S00_AXI_arqos,
    S00_AXI_arready,
    S00_AXI_arsize,
    S00_AXI_aruser,
    S00_AXI_arvalid,
    S00_AXI_awaddr,
    S00_AXI_awburst,
    S00_AXI_awcache,
    S00_AXI_awlen,
    S00_AXI_awlock,
    S00_AXI_awprot,
    S00_AXI_awqos,
    S00_AXI_awready,
    S00_AXI_awsize,
    S00_AXI_awuser,
    S00_AXI_awvalid,
    S00_AXI_bready,
    S00_AXI_bresp,
    S00_AXI_bvalid,
    S00_AXI_rdata,
    S00_AXI_rlast,
    S00_AXI_rready,
    S00_AXI_rresp,
    S00_AXI_rvalid,
    S00_AXI_wdata,
    S00_AXI_wlast,
    S00_AXI_wready,
    S00_AXI_wstrb,
    S00_AXI_wvalid);
  input ACLK;
  input ARESETN;
  input M00_ACLK;
  input M00_ARESETN;
  output [39:0]M00_AXI_araddr;
  output [1:0]M00_AXI_arburst;
  output [3:0]M00_AXI_arcache;
  output [7:0]M00_AXI_arlen;
  output [0:0]M00_AXI_arlock;
  output [2:0]M00_AXI_arprot;
  output [3:0]M00_AXI_arqos;
  input M00_AXI_arready;
  output [2:0]M00_AXI_arsize;
  output [0:0]M00_AXI_aruser;
  output M00_AXI_arvalid;
  output [39:0]M00_AXI_awaddr;
  output [1:0]M00_AXI_awburst;
  output [3:0]M00_AXI_awcache;
  output [7:0]M00_AXI_awlen;
  output [0:0]M00_AXI_awlock;
  output [2:0]M00_AXI_awprot;
  output [3:0]M00_AXI_awqos;
  input M00_AXI_awready;
  output [2:0]M00_AXI_awsize;
  output [0:0]M00_AXI_awuser;
  output M00_AXI_awvalid;
  output M00_AXI_bready;
  input [1:0]M00_AXI_bresp;
  input M00_AXI_bvalid;
  input [127:0]M00_AXI_rdata;
  input M00_AXI_rlast;
  output M00_AXI_rready;
  input [1:0]M00_AXI_rresp;
  input M00_AXI_rvalid;
  output [127:0]M00_AXI_wdata;
  output M00_AXI_wlast;
  input M00_AXI_wready;
  output [15:0]M00_AXI_wstrb;
  output M00_AXI_wvalid;
  input S00_ACLK;
  input S00_ARESETN;
  input [39:0]S00_AXI_araddr;
  input [1:0]S00_AXI_arburst;
  input [3:0]S00_AXI_arcache;
  input [7:0]S00_AXI_arlen;
  input [0:0]S00_AXI_arlock;
  input [2:0]S00_AXI_arprot;
  input [3:0]S00_AXI_arqos;
  output S00_AXI_arready;
  input [2:0]S00_AXI_arsize;
  input [0:0]S00_AXI_aruser;
  input S00_AXI_arvalid;
  input [39:0]S00_AXI_awaddr;
  input [1:0]S00_AXI_awburst;
  input [3:0]S00_AXI_awcache;
  input [7:0]S00_AXI_awlen;
  input [0:0]S00_AXI_awlock;
  input [2:0]S00_AXI_awprot;
  input [3:0]S00_AXI_awqos;
  output S00_AXI_awready;
  input [2:0]S00_AXI_awsize;
  input [0:0]S00_AXI_awuser;
  input S00_AXI_awvalid;
  input S00_AXI_bready;
  output [1:0]S00_AXI_bresp;
  output S00_AXI_bvalid;
  output [127:0]S00_AXI_rdata;
  output S00_AXI_rlast;
  input S00_AXI_rready;
  output [1:0]S00_AXI_rresp;
  output S00_AXI_rvalid;
  input [127:0]S00_AXI_wdata;
  input S00_AXI_wlast;
  output S00_AXI_wready;
  input [15:0]S00_AXI_wstrb;
  input S00_AXI_wvalid;

  wire S00_ACLK_1;
  wire S00_ARESETN_1;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ACLK_net;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ARESETN_net;
  wire [39:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_ARADDR;
  wire [1:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_ARBURST;
  wire [3:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_ARCACHE;
  wire [7:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_ARLEN;
  wire [0:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_ARLOCK;
  wire [2:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_ARPROT;
  wire [3:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_ARQOS;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_ARREADY;
  wire [2:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_ARSIZE;
  wire [0:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_ARUSER;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_ARVALID;
  wire [39:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_AWADDR;
  wire [1:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_AWBURST;
  wire [3:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_AWCACHE;
  wire [7:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_AWLEN;
  wire [0:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_AWLOCK;
  wire [2:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_AWPROT;
  wire [3:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_AWQOS;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_AWREADY;
  wire [2:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_AWSIZE;
  wire [0:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_AWUSER;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_AWVALID;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_BREADY;
  wire [1:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_BRESP;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_BVALID;
  wire [127:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_RDATA;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_RLAST;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_RREADY;
  wire [1:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_RRESP;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_RVALID;
  wire [127:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_WDATA;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_WLAST;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_WREADY;
  wire [15:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_WSTRB;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_WVALID;
  wire [39:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ARADDR;
  wire [1:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ARBURST;
  wire [3:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ARCACHE;
  wire [7:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ARLEN;
  wire [0:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ARLOCK;
  wire [2:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ARPROT;
  wire [3:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ARQOS;
  wire s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ARREADY;
  wire [2:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ARSIZE;
  wire [0:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ARUSER;
  wire s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ARVALID;
  wire [39:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_AWADDR;
  wire [1:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_AWBURST;
  wire [3:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_AWCACHE;
  wire [7:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_AWLEN;
  wire [0:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_AWLOCK;
  wire [2:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_AWPROT;
  wire [3:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_AWQOS;
  wire s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_AWREADY;
  wire [2:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_AWSIZE;
  wire [0:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_AWUSER;
  wire s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_AWVALID;
  wire s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_BREADY;
  wire [1:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_BRESP;
  wire s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_BVALID;
  wire [127:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_RDATA;
  wire s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_RLAST;
  wire s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_RREADY;
  wire [1:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_RRESP;
  wire s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_RVALID;
  wire [127:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_WDATA;
  wire s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_WLAST;
  wire s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_WREADY;
  wire [15:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_WSTRB;
  wire s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_WVALID;

  assign M00_AXI_araddr[39:0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ARADDR;
  assign M00_AXI_arburst[1:0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ARBURST;
  assign M00_AXI_arcache[3:0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ARCACHE;
  assign M00_AXI_arlen[7:0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ARLEN;
  assign M00_AXI_arlock[0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ARLOCK;
  assign M00_AXI_arprot[2:0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ARPROT;
  assign M00_AXI_arqos[3:0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ARQOS;
  assign M00_AXI_arsize[2:0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ARSIZE;
  assign M00_AXI_aruser[0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ARUSER;
  assign M00_AXI_arvalid = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ARVALID;
  assign M00_AXI_awaddr[39:0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_AWADDR;
  assign M00_AXI_awburst[1:0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_AWBURST;
  assign M00_AXI_awcache[3:0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_AWCACHE;
  assign M00_AXI_awlen[7:0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_AWLEN;
  assign M00_AXI_awlock[0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_AWLOCK;
  assign M00_AXI_awprot[2:0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_AWPROT;
  assign M00_AXI_awqos[3:0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_AWQOS;
  assign M00_AXI_awsize[2:0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_AWSIZE;
  assign M00_AXI_awuser[0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_AWUSER;
  assign M00_AXI_awvalid = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_AWVALID;
  assign M00_AXI_bready = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_BREADY;
  assign M00_AXI_rready = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_RREADY;
  assign M00_AXI_wdata[127:0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_WDATA;
  assign M00_AXI_wlast = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_WLAST;
  assign M00_AXI_wstrb[15:0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_WSTRB;
  assign M00_AXI_wvalid = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_WVALID;
  assign S00_ACLK_1 = S00_ACLK;
  assign S00_ARESETN_1 = S00_ARESETN;
  assign S00_AXI_arready = axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_ARREADY;
  assign S00_AXI_awready = axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_AWREADY;
  assign S00_AXI_bresp[1:0] = axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_BRESP;
  assign S00_AXI_bvalid = axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_BVALID;
  assign S00_AXI_rdata[127:0] = axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_RDATA;
  assign S00_AXI_rlast = axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_RLAST;
  assign S00_AXI_rresp[1:0] = axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_RRESP;
  assign S00_AXI_rvalid = axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_RVALID;
  assign S00_AXI_wready = axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_WREADY;
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ACLK_net = M00_ACLK;
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ARESETN_net = M00_ARESETN;
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_ARADDR = S00_AXI_araddr[39:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_ARBURST = S00_AXI_arburst[1:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_ARCACHE = S00_AXI_arcache[3:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_ARLEN = S00_AXI_arlen[7:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_ARLOCK = S00_AXI_arlock[0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_ARPROT = S00_AXI_arprot[2:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_ARQOS = S00_AXI_arqos[3:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_ARSIZE = S00_AXI_arsize[2:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_ARUSER = S00_AXI_aruser[0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_ARVALID = S00_AXI_arvalid;
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_AWADDR = S00_AXI_awaddr[39:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_AWBURST = S00_AXI_awburst[1:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_AWCACHE = S00_AXI_awcache[3:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_AWLEN = S00_AXI_awlen[7:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_AWLOCK = S00_AXI_awlock[0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_AWPROT = S00_AXI_awprot[2:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_AWQOS = S00_AXI_awqos[3:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_AWSIZE = S00_AXI_awsize[2:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_AWUSER = S00_AXI_awuser[0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_AWVALID = S00_AXI_awvalid;
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_BREADY = S00_AXI_bready;
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_RREADY = S00_AXI_rready;
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_WDATA = S00_AXI_wdata[127:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_WLAST = S00_AXI_wlast;
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_WSTRB = S00_AXI_wstrb[15:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_WVALID = S00_AXI_wvalid;
  assign s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ARREADY = M00_AXI_arready;
  assign s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_AWREADY = M00_AXI_awready;
  assign s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_BRESP = M00_AXI_bresp[1:0];
  assign s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_BVALID = M00_AXI_bvalid;
  assign s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_RDATA = M00_AXI_rdata[127:0];
  assign s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_RLAST = M00_AXI_rlast;
  assign s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_RRESP = M00_AXI_rresp[1:0];
  assign s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_RVALID = M00_AXI_rvalid;
  assign s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_WREADY = M00_AXI_wready;
  s00_couplers_imp_RO9NQY s00_couplers
       (.M_ACLK(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ACLK_net),
        .M_ARESETN(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ARESETN_net),
        .M_AXI_araddr(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ARADDR),
        .M_AXI_arburst(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ARBURST),
        .M_AXI_arcache(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ARCACHE),
        .M_AXI_arlen(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ARLEN),
        .M_AXI_arlock(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ARLOCK),
        .M_AXI_arprot(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ARPROT),
        .M_AXI_arqos(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ARQOS),
        .M_AXI_arready(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ARREADY),
        .M_AXI_arsize(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ARSIZE),
        .M_AXI_aruser(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ARUSER),
        .M_AXI_arvalid(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_ARVALID),
        .M_AXI_awaddr(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_AWADDR),
        .M_AXI_awburst(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_AWBURST),
        .M_AXI_awcache(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_AWCACHE),
        .M_AXI_awlen(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_AWLEN),
        .M_AXI_awlock(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_AWLOCK),
        .M_AXI_awprot(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_AWPROT),
        .M_AXI_awqos(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_AWQOS),
        .M_AXI_awready(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_AWREADY),
        .M_AXI_awsize(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_AWSIZE),
        .M_AXI_awuser(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_AWUSER),
        .M_AXI_awvalid(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_AWVALID),
        .M_AXI_bready(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_BREADY),
        .M_AXI_bresp(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_BRESP),
        .M_AXI_bvalid(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_BVALID),
        .M_AXI_rdata(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_RDATA),
        .M_AXI_rlast(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_RLAST),
        .M_AXI_rready(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_RREADY),
        .M_AXI_rresp(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_RRESP),
        .M_AXI_rvalid(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_RVALID),
        .M_AXI_wdata(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_WDATA),
        .M_AXI_wlast(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_WLAST),
        .M_AXI_wready(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_WREADY),
        .M_AXI_wstrb(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_WSTRB),
        .M_AXI_wvalid(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_WVALID),
        .S_ACLK(S00_ACLK_1),
        .S_ARESETN(S00_ARESETN_1),
        .S_AXI_araddr(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_ARADDR),
        .S_AXI_arburst(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_ARBURST),
        .S_AXI_arcache(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_ARCACHE),
        .S_AXI_arlen(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_ARLEN),
        .S_AXI_arlock(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_ARLOCK),
        .S_AXI_arprot(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_ARPROT),
        .S_AXI_arqos(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_ARQOS),
        .S_AXI_arready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_ARREADY),
        .S_AXI_arsize(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_ARSIZE),
        .S_AXI_aruser(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_ARUSER),
        .S_AXI_arvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_ARVALID),
        .S_AXI_awaddr(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_AWADDR),
        .S_AXI_awburst(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_AWBURST),
        .S_AXI_awcache(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_AWCACHE),
        .S_AXI_awlen(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_AWLEN),
        .S_AXI_awlock(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_AWLOCK),
        .S_AXI_awprot(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_AWPROT),
        .S_AXI_awqos(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_AWQOS),
        .S_AXI_awready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_AWREADY),
        .S_AXI_awsize(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_AWSIZE),
        .S_AXI_awuser(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_AWUSER),
        .S_AXI_awvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_AWVALID),
        .S_AXI_bready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_BREADY),
        .S_AXI_bresp(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_BRESP),
        .S_AXI_bvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_BVALID),
        .S_AXI_rdata(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_RDATA),
        .S_AXI_rlast(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_RLAST),
        .S_AXI_rready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_RREADY),
        .S_AXI_rresp(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_RRESP),
        .S_AXI_rvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_RVALID),
        .S_AXI_wdata(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_WDATA),
        .S_AXI_wlast(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_WLAST),
        .S_AXI_wready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_WREADY),
        .S_AXI_wstrb(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_WSTRB),
        .S_AXI_wvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD_to_s00_couplers_WVALID));
endmodule

module kv260_hardware_platform_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_0
   (ACLK,
    ARESETN,
    M00_ACLK,
    M00_ARESETN,
    M00_AXI_araddr,
    M00_AXI_arburst,
    M00_AXI_arcache,
    M00_AXI_arlen,
    M00_AXI_arlock,
    M00_AXI_arprot,
    M00_AXI_arqos,
    M00_AXI_arready,
    M00_AXI_arsize,
    M00_AXI_arvalid,
    M00_AXI_awaddr,
    M00_AXI_awburst,
    M00_AXI_awcache,
    M00_AXI_awlen,
    M00_AXI_awlock,
    M00_AXI_awprot,
    M00_AXI_awqos,
    M00_AXI_awready,
    M00_AXI_awsize,
    M00_AXI_awvalid,
    M00_AXI_bready,
    M00_AXI_bresp,
    M00_AXI_bvalid,
    M00_AXI_rdata,
    M00_AXI_rlast,
    M00_AXI_rready,
    M00_AXI_rresp,
    M00_AXI_rvalid,
    M00_AXI_wdata,
    M00_AXI_wlast,
    M00_AXI_wready,
    M00_AXI_wstrb,
    M00_AXI_wvalid,
    S00_ACLK,
    S00_ARESETN,
    S00_AXI_araddr,
    S00_AXI_arburst,
    S00_AXI_arcache,
    S00_AXI_arlen,
    S00_AXI_arlock,
    S00_AXI_arprot,
    S00_AXI_arqos,
    S00_AXI_arready,
    S00_AXI_arsize,
    S00_AXI_arvalid,
    S00_AXI_awaddr,
    S00_AXI_awburst,
    S00_AXI_awcache,
    S00_AXI_awlen,
    S00_AXI_awlock,
    S00_AXI_awprot,
    S00_AXI_awqos,
    S00_AXI_awready,
    S00_AXI_awsize,
    S00_AXI_awvalid,
    S00_AXI_bready,
    S00_AXI_bresp,
    S00_AXI_bvalid,
    S00_AXI_rdata,
    S00_AXI_rlast,
    S00_AXI_rready,
    S00_AXI_rresp,
    S00_AXI_rvalid,
    S00_AXI_wdata,
    S00_AXI_wlast,
    S00_AXI_wready,
    S00_AXI_wstrb,
    S00_AXI_wvalid);
  input ACLK;
  input ARESETN;
  input M00_ACLK;
  input M00_ARESETN;
  output [39:0]M00_AXI_araddr;
  output [1:0]M00_AXI_arburst;
  output [3:0]M00_AXI_arcache;
  output [7:0]M00_AXI_arlen;
  output [0:0]M00_AXI_arlock;
  output [2:0]M00_AXI_arprot;
  output [3:0]M00_AXI_arqos;
  input M00_AXI_arready;
  output [2:0]M00_AXI_arsize;
  output M00_AXI_arvalid;
  output [39:0]M00_AXI_awaddr;
  output [1:0]M00_AXI_awburst;
  output [3:0]M00_AXI_awcache;
  output [7:0]M00_AXI_awlen;
  output [0:0]M00_AXI_awlock;
  output [2:0]M00_AXI_awprot;
  output [3:0]M00_AXI_awqos;
  input M00_AXI_awready;
  output [2:0]M00_AXI_awsize;
  output M00_AXI_awvalid;
  output M00_AXI_bready;
  input [1:0]M00_AXI_bresp;
  input M00_AXI_bvalid;
  input [127:0]M00_AXI_rdata;
  input M00_AXI_rlast;
  output M00_AXI_rready;
  input [1:0]M00_AXI_rresp;
  input M00_AXI_rvalid;
  output [127:0]M00_AXI_wdata;
  output M00_AXI_wlast;
  input M00_AXI_wready;
  output [15:0]M00_AXI_wstrb;
  output M00_AXI_wvalid;
  input S00_ACLK;
  input S00_ARESETN;
  input [39:0]S00_AXI_araddr;
  input [1:0]S00_AXI_arburst;
  input [3:0]S00_AXI_arcache;
  input [7:0]S00_AXI_arlen;
  input [0:0]S00_AXI_arlock;
  input [2:0]S00_AXI_arprot;
  input [3:0]S00_AXI_arqos;
  output S00_AXI_arready;
  input [2:0]S00_AXI_arsize;
  input S00_AXI_arvalid;
  input [39:0]S00_AXI_awaddr;
  input [1:0]S00_AXI_awburst;
  input [3:0]S00_AXI_awcache;
  input [7:0]S00_AXI_awlen;
  input [0:0]S00_AXI_awlock;
  input [2:0]S00_AXI_awprot;
  input [3:0]S00_AXI_awqos;
  output S00_AXI_awready;
  input [2:0]S00_AXI_awsize;
  input S00_AXI_awvalid;
  input S00_AXI_bready;
  output [1:0]S00_AXI_bresp;
  output S00_AXI_bvalid;
  output [31:0]S00_AXI_rdata;
  output S00_AXI_rlast;
  input S00_AXI_rready;
  output [1:0]S00_AXI_rresp;
  output S00_AXI_rvalid;
  input [31:0]S00_AXI_wdata;
  input S00_AXI_wlast;
  output S00_AXI_wready;
  input [3:0]S00_AXI_wstrb;
  input S00_AXI_wvalid;

  wire S00_ACLK_1;
  wire S00_ARESETN_1;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_ACLK_net;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_ARESETN_net;
  wire [39:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_ARADDR;
  wire [1:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_ARBURST;
  wire [3:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_ARCACHE;
  wire [7:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_ARLEN;
  wire [0:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_ARLOCK;
  wire [2:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_ARPROT;
  wire [3:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_ARQOS;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_ARREADY;
  wire [2:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_ARSIZE;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_ARVALID;
  wire [39:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_AWADDR;
  wire [1:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_AWBURST;
  wire [3:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_AWCACHE;
  wire [7:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_AWLEN;
  wire [0:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_AWLOCK;
  wire [2:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_AWPROT;
  wire [3:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_AWQOS;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_AWREADY;
  wire [2:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_AWSIZE;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_AWVALID;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_BREADY;
  wire [1:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_BRESP;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_BVALID;
  wire [31:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_RDATA;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_RLAST;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_RREADY;
  wire [1:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_RRESP;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_RVALID;
  wire [31:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_WDATA;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_WLAST;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_WREADY;
  wire [3:0]axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_WSTRB;
  wire axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_WVALID;
  wire [39:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_ARADDR;
  wire [1:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_ARBURST;
  wire [3:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_ARCACHE;
  wire [7:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_ARLEN;
  wire [0:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_ARLOCK;
  wire [2:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_ARPROT;
  wire [3:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_ARQOS;
  wire s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_ARREADY;
  wire [2:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_ARSIZE;
  wire s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_ARVALID;
  wire [39:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_AWADDR;
  wire [1:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_AWBURST;
  wire [3:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_AWCACHE;
  wire [7:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_AWLEN;
  wire [0:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_AWLOCK;
  wire [2:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_AWPROT;
  wire [3:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_AWQOS;
  wire s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_AWREADY;
  wire [2:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_AWSIZE;
  wire s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_AWVALID;
  wire s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_BREADY;
  wire [1:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_BRESP;
  wire s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_BVALID;
  wire [127:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_RDATA;
  wire s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_RLAST;
  wire s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_RREADY;
  wire [1:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_RRESP;
  wire s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_RVALID;
  wire [127:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_WDATA;
  wire s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_WLAST;
  wire s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_WREADY;
  wire [15:0]s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_WSTRB;
  wire s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_WVALID;

  assign M00_AXI_araddr[39:0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_ARADDR;
  assign M00_AXI_arburst[1:0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_ARBURST;
  assign M00_AXI_arcache[3:0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_ARCACHE;
  assign M00_AXI_arlen[7:0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_ARLEN;
  assign M00_AXI_arlock[0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_ARLOCK;
  assign M00_AXI_arprot[2:0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_ARPROT;
  assign M00_AXI_arqos[3:0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_ARQOS;
  assign M00_AXI_arsize[2:0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_ARSIZE;
  assign M00_AXI_arvalid = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_ARVALID;
  assign M00_AXI_awaddr[39:0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_AWADDR;
  assign M00_AXI_awburst[1:0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_AWBURST;
  assign M00_AXI_awcache[3:0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_AWCACHE;
  assign M00_AXI_awlen[7:0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_AWLEN;
  assign M00_AXI_awlock[0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_AWLOCK;
  assign M00_AXI_awprot[2:0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_AWPROT;
  assign M00_AXI_awqos[3:0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_AWQOS;
  assign M00_AXI_awsize[2:0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_AWSIZE;
  assign M00_AXI_awvalid = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_AWVALID;
  assign M00_AXI_bready = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_BREADY;
  assign M00_AXI_rready = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_RREADY;
  assign M00_AXI_wdata[127:0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_WDATA;
  assign M00_AXI_wlast = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_WLAST;
  assign M00_AXI_wstrb[15:0] = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_WSTRB;
  assign M00_AXI_wvalid = s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_WVALID;
  assign S00_ACLK_1 = S00_ACLK;
  assign S00_ARESETN_1 = S00_ARESETN;
  assign S00_AXI_arready = axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_ARREADY;
  assign S00_AXI_awready = axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_AWREADY;
  assign S00_AXI_bresp[1:0] = axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_BRESP;
  assign S00_AXI_bvalid = axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_BVALID;
  assign S00_AXI_rdata[31:0] = axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_RDATA;
  assign S00_AXI_rlast = axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_RLAST;
  assign S00_AXI_rresp[1:0] = axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_RRESP;
  assign S00_AXI_rvalid = axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_RVALID;
  assign S00_AXI_wready = axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_WREADY;
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_ACLK_net = M00_ACLK;
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_ARESETN_net = M00_ARESETN;
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_ARADDR = S00_AXI_araddr[39:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_ARBURST = S00_AXI_arburst[1:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_ARCACHE = S00_AXI_arcache[3:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_ARLEN = S00_AXI_arlen[7:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_ARLOCK = S00_AXI_arlock[0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_ARPROT = S00_AXI_arprot[2:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_ARQOS = S00_AXI_arqos[3:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_ARSIZE = S00_AXI_arsize[2:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_ARVALID = S00_AXI_arvalid;
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_AWADDR = S00_AXI_awaddr[39:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_AWBURST = S00_AXI_awburst[1:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_AWCACHE = S00_AXI_awcache[3:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_AWLEN = S00_AXI_awlen[7:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_AWLOCK = S00_AXI_awlock[0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_AWPROT = S00_AXI_awprot[2:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_AWQOS = S00_AXI_awqos[3:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_AWSIZE = S00_AXI_awsize[2:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_AWVALID = S00_AXI_awvalid;
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_BREADY = S00_AXI_bready;
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_RREADY = S00_AXI_rready;
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_WDATA = S00_AXI_wdata[31:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_WLAST = S00_AXI_wlast;
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_WSTRB = S00_AXI_wstrb[3:0];
  assign axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_WVALID = S00_AXI_wvalid;
  assign s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_ARREADY = M00_AXI_arready;
  assign s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_AWREADY = M00_AXI_awready;
  assign s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_BRESP = M00_AXI_bresp[1:0];
  assign s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_BVALID = M00_AXI_bvalid;
  assign s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_RDATA = M00_AXI_rdata[127:0];
  assign s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_RLAST = M00_AXI_rlast;
  assign s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_RRESP = M00_AXI_rresp[1:0];
  assign s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_RVALID = M00_AXI_rvalid;
  assign s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_WREADY = M00_AXI_wready;
  s00_couplers_imp_1X593XB s00_couplers
       (.M_ACLK(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_ACLK_net),
        .M_ARESETN(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_ARESETN_net),
        .M_AXI_araddr(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_ARADDR),
        .M_AXI_arburst(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_ARBURST),
        .M_AXI_arcache(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_ARCACHE),
        .M_AXI_arlen(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_ARLEN),
        .M_AXI_arlock(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_ARLOCK),
        .M_AXI_arprot(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_ARPROT),
        .M_AXI_arqos(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_ARQOS),
        .M_AXI_arready(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_ARREADY),
        .M_AXI_arsize(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_ARSIZE),
        .M_AXI_arvalid(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_ARVALID),
        .M_AXI_awaddr(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_AWADDR),
        .M_AXI_awburst(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_AWBURST),
        .M_AXI_awcache(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_AWCACHE),
        .M_AXI_awlen(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_AWLEN),
        .M_AXI_awlock(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_AWLOCK),
        .M_AXI_awprot(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_AWPROT),
        .M_AXI_awqos(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_AWQOS),
        .M_AXI_awready(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_AWREADY),
        .M_AXI_awsize(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_AWSIZE),
        .M_AXI_awvalid(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_AWVALID),
        .M_AXI_bready(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_BREADY),
        .M_AXI_bresp(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_BRESP),
        .M_AXI_bvalid(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_BVALID),
        .M_AXI_rdata(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_RDATA),
        .M_AXI_rlast(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_RLAST),
        .M_AXI_rready(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_RREADY),
        .M_AXI_rresp(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_RRESP),
        .M_AXI_rvalid(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_RVALID),
        .M_AXI_wdata(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_WDATA),
        .M_AXI_wlast(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_WLAST),
        .M_AXI_wready(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_WREADY),
        .M_AXI_wstrb(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_WSTRB),
        .M_AXI_wvalid(s00_couplers_to_axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_WVALID),
        .S_ACLK(S00_ACLK_1),
        .S_ARESETN(S00_ARESETN_1),
        .S_AXI_araddr(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_ARADDR),
        .S_AXI_arburst(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_ARBURST),
        .S_AXI_arcache(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_ARCACHE),
        .S_AXI_arlen(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_ARLEN),
        .S_AXI_arlock(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_ARLOCK),
        .S_AXI_arprot(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_ARPROT),
        .S_AXI_arqos(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_ARQOS),
        .S_AXI_arready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_ARREADY),
        .S_AXI_arsize(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_ARSIZE),
        .S_AXI_arvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_ARVALID),
        .S_AXI_awaddr(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_AWADDR),
        .S_AXI_awburst(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_AWBURST),
        .S_AXI_awcache(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_AWCACHE),
        .S_AXI_awlen(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_AWLEN),
        .S_AXI_awlock(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_AWLOCK),
        .S_AXI_awprot(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_AWPROT),
        .S_AXI_awqos(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_AWQOS),
        .S_AXI_awready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_AWREADY),
        .S_AXI_awsize(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_AWSIZE),
        .S_AXI_awvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_AWVALID),
        .S_AXI_bready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_BREADY),
        .S_AXI_bresp(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_BRESP),
        .S_AXI_bvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_BVALID),
        .S_AXI_rdata(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_RDATA),
        .S_AXI_rlast(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_RLAST),
        .S_AXI_rready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_RREADY),
        .S_AXI_rresp(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_RRESP),
        .S_AXI_rvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_RVALID),
        .S_AXI_wdata(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_WDATA),
        .S_AXI_wlast(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_WLAST),
        .S_AXI_wready(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_WREADY),
        .S_AXI_wstrb(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_WSTRB),
        .S_AXI_wvalid(axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD_to_s00_couplers_WVALID));
endmodule

module kv260_hardware_platform_ps8_0_axi_periph_0
   (ACLK,
    ARESETN,
    M00_ACLK,
    M00_ARESETN,
    M00_AXI_araddr,
    M00_AXI_arready,
    M00_AXI_arvalid,
    M00_AXI_awaddr,
    M00_AXI_awready,
    M00_AXI_awvalid,
    M00_AXI_bready,
    M00_AXI_bresp,
    M00_AXI_bvalid,
    M00_AXI_rdata,
    M00_AXI_rready,
    M00_AXI_rresp,
    M00_AXI_rvalid,
    M00_AXI_wdata,
    M00_AXI_wready,
    M00_AXI_wstrb,
    M00_AXI_wvalid,
    M01_ACLK,
    M01_ARESETN,
    M01_AXI_araddr,
    M01_AXI_arready,
    M01_AXI_arvalid,
    M01_AXI_awaddr,
    M01_AXI_awready,
    M01_AXI_awvalid,
    M01_AXI_bready,
    M01_AXI_bresp,
    M01_AXI_bvalid,
    M01_AXI_rdata,
    M01_AXI_rready,
    M01_AXI_rresp,
    M01_AXI_rvalid,
    M01_AXI_wdata,
    M01_AXI_wready,
    M01_AXI_wstrb,
    M01_AXI_wvalid,
    M02_ACLK,
    M02_ARESETN,
    M02_AXI_araddr,
    M02_AXI_arready,
    M02_AXI_arvalid,
    M02_AXI_awaddr,
    M02_AXI_awready,
    M02_AXI_awvalid,
    M02_AXI_bready,
    M02_AXI_bresp,
    M02_AXI_bvalid,
    M02_AXI_rdata,
    M02_AXI_rready,
    M02_AXI_rresp,
    M02_AXI_rvalid,
    M02_AXI_wdata,
    M02_AXI_wready,
    M02_AXI_wstrb,
    M02_AXI_wvalid,
    M03_ACLK,
    M03_ARESETN,
    M03_AXI_araddr,
    M03_AXI_arready,
    M03_AXI_arvalid,
    M03_AXI_awaddr,
    M03_AXI_awready,
    M03_AXI_awvalid,
    M03_AXI_bready,
    M03_AXI_bresp,
    M03_AXI_bvalid,
    M03_AXI_rdata,
    M03_AXI_rready,
    M03_AXI_rresp,
    M03_AXI_rvalid,
    M03_AXI_wdata,
    M03_AXI_wready,
    M03_AXI_wstrb,
    M03_AXI_wvalid,
    M04_ACLK,
    M04_ARESETN,
    M04_AXI_araddr,
    M04_AXI_arready,
    M04_AXI_arvalid,
    M04_AXI_awaddr,
    M04_AXI_awready,
    M04_AXI_awvalid,
    M04_AXI_bready,
    M04_AXI_bresp,
    M04_AXI_bvalid,
    M04_AXI_rdata,
    M04_AXI_rready,
    M04_AXI_rresp,
    M04_AXI_rvalid,
    M04_AXI_wdata,
    M04_AXI_wready,
    M04_AXI_wstrb,
    M04_AXI_wvalid,
    S00_ACLK,
    S00_ARESETN,
    S00_AXI_araddr,
    S00_AXI_arburst,
    S00_AXI_arcache,
    S00_AXI_arid,
    S00_AXI_arlen,
    S00_AXI_arlock,
    S00_AXI_arprot,
    S00_AXI_arqos,
    S00_AXI_arready,
    S00_AXI_arsize,
    S00_AXI_arvalid,
    S00_AXI_awaddr,
    S00_AXI_awburst,
    S00_AXI_awcache,
    S00_AXI_awid,
    S00_AXI_awlen,
    S00_AXI_awlock,
    S00_AXI_awprot,
    S00_AXI_awqos,
    S00_AXI_awready,
    S00_AXI_awsize,
    S00_AXI_awvalid,
    S00_AXI_bid,
    S00_AXI_bready,
    S00_AXI_bresp,
    S00_AXI_bvalid,
    S00_AXI_rdata,
    S00_AXI_rid,
    S00_AXI_rlast,
    S00_AXI_rready,
    S00_AXI_rresp,
    S00_AXI_rvalid,
    S00_AXI_wdata,
    S00_AXI_wlast,
    S00_AXI_wready,
    S00_AXI_wstrb,
    S00_AXI_wvalid);
  input ACLK;
  input ARESETN;
  input M00_ACLK;
  input M00_ARESETN;
  output [39:0]M00_AXI_araddr;
  input [0:0]M00_AXI_arready;
  output [0:0]M00_AXI_arvalid;
  output [39:0]M00_AXI_awaddr;
  input [0:0]M00_AXI_awready;
  output [0:0]M00_AXI_awvalid;
  output [0:0]M00_AXI_bready;
  input [1:0]M00_AXI_bresp;
  input [0:0]M00_AXI_bvalid;
  input [31:0]M00_AXI_rdata;
  output [0:0]M00_AXI_rready;
  input [1:0]M00_AXI_rresp;
  input [0:0]M00_AXI_rvalid;
  output [31:0]M00_AXI_wdata;
  input [0:0]M00_AXI_wready;
  output [3:0]M00_AXI_wstrb;
  output [0:0]M00_AXI_wvalid;
  input M01_ACLK;
  input M01_ARESETN;
  output [8:0]M01_AXI_araddr;
  input M01_AXI_arready;
  output M01_AXI_arvalid;
  output [8:0]M01_AXI_awaddr;
  input M01_AXI_awready;
  output M01_AXI_awvalid;
  output M01_AXI_bready;
  input [1:0]M01_AXI_bresp;
  input M01_AXI_bvalid;
  input [31:0]M01_AXI_rdata;
  output M01_AXI_rready;
  input [1:0]M01_AXI_rresp;
  input M01_AXI_rvalid;
  output [31:0]M01_AXI_wdata;
  input M01_AXI_wready;
  output [3:0]M01_AXI_wstrb;
  output M01_AXI_wvalid;
  input M02_ACLK;
  input M02_ARESETN;
  output [7:0]M02_AXI_araddr;
  input M02_AXI_arready;
  output M02_AXI_arvalid;
  output [7:0]M02_AXI_awaddr;
  input M02_AXI_awready;
  output M02_AXI_awvalid;
  output M02_AXI_bready;
  input [1:0]M02_AXI_bresp;
  input M02_AXI_bvalid;
  input [31:0]M02_AXI_rdata;
  output M02_AXI_rready;
  input [1:0]M02_AXI_rresp;
  input M02_AXI_rvalid;
  output [31:0]M02_AXI_wdata;
  input M02_AXI_wready;
  output [3:0]M02_AXI_wstrb;
  output M02_AXI_wvalid;
  input M03_ACLK;
  input M03_ARESETN;
  output [11:0]M03_AXI_araddr;
  input M03_AXI_arready;
  output M03_AXI_arvalid;
  output [11:0]M03_AXI_awaddr;
  input M03_AXI_awready;
  output M03_AXI_awvalid;
  output M03_AXI_bready;
  input [1:0]M03_AXI_bresp;
  input M03_AXI_bvalid;
  input [31:0]M03_AXI_rdata;
  output M03_AXI_rready;
  input [1:0]M03_AXI_rresp;
  input M03_AXI_rvalid;
  output [31:0]M03_AXI_wdata;
  input M03_AXI_wready;
  output [3:0]M03_AXI_wstrb;
  output M03_AXI_wvalid;
  input M04_ACLK;
  input M04_ARESETN;
  output [11:0]M04_AXI_araddr;
  input M04_AXI_arready;
  output M04_AXI_arvalid;
  output [11:0]M04_AXI_awaddr;
  input M04_AXI_awready;
  output M04_AXI_awvalid;
  output M04_AXI_bready;
  input [1:0]M04_AXI_bresp;
  input M04_AXI_bvalid;
  input [31:0]M04_AXI_rdata;
  output M04_AXI_rready;
  input [1:0]M04_AXI_rresp;
  input M04_AXI_rvalid;
  output [31:0]M04_AXI_wdata;
  input M04_AXI_wready;
  output [3:0]M04_AXI_wstrb;
  output M04_AXI_wvalid;
  input S00_ACLK;
  input S00_ARESETN;
  input [39:0]S00_AXI_araddr;
  input [1:0]S00_AXI_arburst;
  input [3:0]S00_AXI_arcache;
  input [15:0]S00_AXI_arid;
  input [7:0]S00_AXI_arlen;
  input [0:0]S00_AXI_arlock;
  input [2:0]S00_AXI_arprot;
  input [3:0]S00_AXI_arqos;
  output S00_AXI_arready;
  input [2:0]S00_AXI_arsize;
  input S00_AXI_arvalid;
  input [39:0]S00_AXI_awaddr;
  input [1:0]S00_AXI_awburst;
  input [3:0]S00_AXI_awcache;
  input [15:0]S00_AXI_awid;
  input [7:0]S00_AXI_awlen;
  input [0:0]S00_AXI_awlock;
  input [2:0]S00_AXI_awprot;
  input [3:0]S00_AXI_awqos;
  output S00_AXI_awready;
  input [2:0]S00_AXI_awsize;
  input S00_AXI_awvalid;
  output [15:0]S00_AXI_bid;
  input S00_AXI_bready;
  output [1:0]S00_AXI_bresp;
  output S00_AXI_bvalid;
  output [31:0]S00_AXI_rdata;
  output [15:0]S00_AXI_rid;
  output S00_AXI_rlast;
  input S00_AXI_rready;
  output [1:0]S00_AXI_rresp;
  output S00_AXI_rvalid;
  input [31:0]S00_AXI_wdata;
  input S00_AXI_wlast;
  output S00_AXI_wready;
  input [3:0]S00_AXI_wstrb;
  input S00_AXI_wvalid;

  wire M00_ACLK_1;
  wire M00_ARESETN_1;
  wire M01_ACLK_1;
  wire M01_ARESETN_1;
  wire M02_ACLK_1;
  wire M02_ARESETN_1;
  wire M03_ACLK_1;
  wire M03_ARESETN_1;
  wire M04_ACLK_1;
  wire M04_ARESETN_1;
  wire S00_ACLK_1;
  wire S00_ARESETN_1;
  wire [39:0]m00_couplers_to_ps8_0_axi_periph_ARADDR;
  wire [0:0]m00_couplers_to_ps8_0_axi_periph_ARREADY;
  wire [0:0]m00_couplers_to_ps8_0_axi_periph_ARVALID;
  wire [39:0]m00_couplers_to_ps8_0_axi_periph_AWADDR;
  wire [0:0]m00_couplers_to_ps8_0_axi_periph_AWREADY;
  wire [0:0]m00_couplers_to_ps8_0_axi_periph_AWVALID;
  wire [0:0]m00_couplers_to_ps8_0_axi_periph_BREADY;
  wire [1:0]m00_couplers_to_ps8_0_axi_periph_BRESP;
  wire [0:0]m00_couplers_to_ps8_0_axi_periph_BVALID;
  wire [31:0]m00_couplers_to_ps8_0_axi_periph_RDATA;
  wire [0:0]m00_couplers_to_ps8_0_axi_periph_RREADY;
  wire [1:0]m00_couplers_to_ps8_0_axi_periph_RRESP;
  wire [0:0]m00_couplers_to_ps8_0_axi_periph_RVALID;
  wire [31:0]m00_couplers_to_ps8_0_axi_periph_WDATA;
  wire [0:0]m00_couplers_to_ps8_0_axi_periph_WREADY;
  wire [3:0]m00_couplers_to_ps8_0_axi_periph_WSTRB;
  wire [0:0]m00_couplers_to_ps8_0_axi_periph_WVALID;
  wire [8:0]m01_couplers_to_ps8_0_axi_periph_ARADDR;
  wire m01_couplers_to_ps8_0_axi_periph_ARREADY;
  wire m01_couplers_to_ps8_0_axi_periph_ARVALID;
  wire [8:0]m01_couplers_to_ps8_0_axi_periph_AWADDR;
  wire m01_couplers_to_ps8_0_axi_periph_AWREADY;
  wire m01_couplers_to_ps8_0_axi_periph_AWVALID;
  wire m01_couplers_to_ps8_0_axi_periph_BREADY;
  wire [1:0]m01_couplers_to_ps8_0_axi_periph_BRESP;
  wire m01_couplers_to_ps8_0_axi_periph_BVALID;
  wire [31:0]m01_couplers_to_ps8_0_axi_periph_RDATA;
  wire m01_couplers_to_ps8_0_axi_periph_RREADY;
  wire [1:0]m01_couplers_to_ps8_0_axi_periph_RRESP;
  wire m01_couplers_to_ps8_0_axi_periph_RVALID;
  wire [31:0]m01_couplers_to_ps8_0_axi_periph_WDATA;
  wire m01_couplers_to_ps8_0_axi_periph_WREADY;
  wire [3:0]m01_couplers_to_ps8_0_axi_periph_WSTRB;
  wire m01_couplers_to_ps8_0_axi_periph_WVALID;
  wire [7:0]m02_couplers_to_ps8_0_axi_periph_ARADDR;
  wire m02_couplers_to_ps8_0_axi_periph_ARREADY;
  wire m02_couplers_to_ps8_0_axi_periph_ARVALID;
  wire [7:0]m02_couplers_to_ps8_0_axi_periph_AWADDR;
  wire m02_couplers_to_ps8_0_axi_periph_AWREADY;
  wire m02_couplers_to_ps8_0_axi_periph_AWVALID;
  wire m02_couplers_to_ps8_0_axi_periph_BREADY;
  wire [1:0]m02_couplers_to_ps8_0_axi_periph_BRESP;
  wire m02_couplers_to_ps8_0_axi_periph_BVALID;
  wire [31:0]m02_couplers_to_ps8_0_axi_periph_RDATA;
  wire m02_couplers_to_ps8_0_axi_periph_RREADY;
  wire [1:0]m02_couplers_to_ps8_0_axi_periph_RRESP;
  wire m02_couplers_to_ps8_0_axi_periph_RVALID;
  wire [31:0]m02_couplers_to_ps8_0_axi_periph_WDATA;
  wire m02_couplers_to_ps8_0_axi_periph_WREADY;
  wire [3:0]m02_couplers_to_ps8_0_axi_periph_WSTRB;
  wire m02_couplers_to_ps8_0_axi_periph_WVALID;
  wire [11:0]m03_couplers_to_ps8_0_axi_periph_ARADDR;
  wire m03_couplers_to_ps8_0_axi_periph_ARREADY;
  wire m03_couplers_to_ps8_0_axi_periph_ARVALID;
  wire [11:0]m03_couplers_to_ps8_0_axi_periph_AWADDR;
  wire m03_couplers_to_ps8_0_axi_periph_AWREADY;
  wire m03_couplers_to_ps8_0_axi_periph_AWVALID;
  wire m03_couplers_to_ps8_0_axi_periph_BREADY;
  wire [1:0]m03_couplers_to_ps8_0_axi_periph_BRESP;
  wire m03_couplers_to_ps8_0_axi_periph_BVALID;
  wire [31:0]m03_couplers_to_ps8_0_axi_periph_RDATA;
  wire m03_couplers_to_ps8_0_axi_periph_RREADY;
  wire [1:0]m03_couplers_to_ps8_0_axi_periph_RRESP;
  wire m03_couplers_to_ps8_0_axi_periph_RVALID;
  wire [31:0]m03_couplers_to_ps8_0_axi_periph_WDATA;
  wire m03_couplers_to_ps8_0_axi_periph_WREADY;
  wire [3:0]m03_couplers_to_ps8_0_axi_periph_WSTRB;
  wire m03_couplers_to_ps8_0_axi_periph_WVALID;
  wire [11:0]m04_couplers_to_ps8_0_axi_periph_ARADDR;
  wire m04_couplers_to_ps8_0_axi_periph_ARREADY;
  wire m04_couplers_to_ps8_0_axi_periph_ARVALID;
  wire [11:0]m04_couplers_to_ps8_0_axi_periph_AWADDR;
  wire m04_couplers_to_ps8_0_axi_periph_AWREADY;
  wire m04_couplers_to_ps8_0_axi_periph_AWVALID;
  wire m04_couplers_to_ps8_0_axi_periph_BREADY;
  wire [1:0]m04_couplers_to_ps8_0_axi_periph_BRESP;
  wire m04_couplers_to_ps8_0_axi_periph_BVALID;
  wire [31:0]m04_couplers_to_ps8_0_axi_periph_RDATA;
  wire m04_couplers_to_ps8_0_axi_periph_RREADY;
  wire [1:0]m04_couplers_to_ps8_0_axi_periph_RRESP;
  wire m04_couplers_to_ps8_0_axi_periph_RVALID;
  wire [31:0]m04_couplers_to_ps8_0_axi_periph_WDATA;
  wire m04_couplers_to_ps8_0_axi_periph_WREADY;
  wire [3:0]m04_couplers_to_ps8_0_axi_periph_WSTRB;
  wire m04_couplers_to_ps8_0_axi_periph_WVALID;
  wire ps8_0_axi_periph_ACLK_net;
  wire ps8_0_axi_periph_ARESETN_net;
  wire [39:0]ps8_0_axi_periph_to_s00_couplers_ARADDR;
  wire [1:0]ps8_0_axi_periph_to_s00_couplers_ARBURST;
  wire [3:0]ps8_0_axi_periph_to_s00_couplers_ARCACHE;
  wire [15:0]ps8_0_axi_periph_to_s00_couplers_ARID;
  wire [7:0]ps8_0_axi_periph_to_s00_couplers_ARLEN;
  wire [0:0]ps8_0_axi_periph_to_s00_couplers_ARLOCK;
  wire [2:0]ps8_0_axi_periph_to_s00_couplers_ARPROT;
  wire [3:0]ps8_0_axi_periph_to_s00_couplers_ARQOS;
  wire ps8_0_axi_periph_to_s00_couplers_ARREADY;
  wire [2:0]ps8_0_axi_periph_to_s00_couplers_ARSIZE;
  wire ps8_0_axi_periph_to_s00_couplers_ARVALID;
  wire [39:0]ps8_0_axi_periph_to_s00_couplers_AWADDR;
  wire [1:0]ps8_0_axi_periph_to_s00_couplers_AWBURST;
  wire [3:0]ps8_0_axi_periph_to_s00_couplers_AWCACHE;
  wire [15:0]ps8_0_axi_periph_to_s00_couplers_AWID;
  wire [7:0]ps8_0_axi_periph_to_s00_couplers_AWLEN;
  wire [0:0]ps8_0_axi_periph_to_s00_couplers_AWLOCK;
  wire [2:0]ps8_0_axi_periph_to_s00_couplers_AWPROT;
  wire [3:0]ps8_0_axi_periph_to_s00_couplers_AWQOS;
  wire ps8_0_axi_periph_to_s00_couplers_AWREADY;
  wire [2:0]ps8_0_axi_periph_to_s00_couplers_AWSIZE;
  wire ps8_0_axi_periph_to_s00_couplers_AWVALID;
  wire [15:0]ps8_0_axi_periph_to_s00_couplers_BID;
  wire ps8_0_axi_periph_to_s00_couplers_BREADY;
  wire [1:0]ps8_0_axi_periph_to_s00_couplers_BRESP;
  wire ps8_0_axi_periph_to_s00_couplers_BVALID;
  wire [31:0]ps8_0_axi_periph_to_s00_couplers_RDATA;
  wire [15:0]ps8_0_axi_periph_to_s00_couplers_RID;
  wire ps8_0_axi_periph_to_s00_couplers_RLAST;
  wire ps8_0_axi_periph_to_s00_couplers_RREADY;
  wire [1:0]ps8_0_axi_periph_to_s00_couplers_RRESP;
  wire ps8_0_axi_periph_to_s00_couplers_RVALID;
  wire [31:0]ps8_0_axi_periph_to_s00_couplers_WDATA;
  wire ps8_0_axi_periph_to_s00_couplers_WLAST;
  wire ps8_0_axi_periph_to_s00_couplers_WREADY;
  wire [3:0]ps8_0_axi_periph_to_s00_couplers_WSTRB;
  wire ps8_0_axi_periph_to_s00_couplers_WVALID;
  wire [39:0]s00_couplers_to_xbar_ARADDR;
  wire [2:0]s00_couplers_to_xbar_ARPROT;
  wire [0:0]s00_couplers_to_xbar_ARREADY;
  wire s00_couplers_to_xbar_ARVALID;
  wire [39:0]s00_couplers_to_xbar_AWADDR;
  wire [2:0]s00_couplers_to_xbar_AWPROT;
  wire [0:0]s00_couplers_to_xbar_AWREADY;
  wire s00_couplers_to_xbar_AWVALID;
  wire s00_couplers_to_xbar_BREADY;
  wire [1:0]s00_couplers_to_xbar_BRESP;
  wire [0:0]s00_couplers_to_xbar_BVALID;
  wire [31:0]s00_couplers_to_xbar_RDATA;
  wire s00_couplers_to_xbar_RREADY;
  wire [1:0]s00_couplers_to_xbar_RRESP;
  wire [0:0]s00_couplers_to_xbar_RVALID;
  wire [31:0]s00_couplers_to_xbar_WDATA;
  wire [0:0]s00_couplers_to_xbar_WREADY;
  wire [3:0]s00_couplers_to_xbar_WSTRB;
  wire s00_couplers_to_xbar_WVALID;
  wire [39:0]xbar_to_m00_couplers_ARADDR;
  wire [0:0]xbar_to_m00_couplers_ARREADY;
  wire [0:0]xbar_to_m00_couplers_ARVALID;
  wire [39:0]xbar_to_m00_couplers_AWADDR;
  wire [0:0]xbar_to_m00_couplers_AWREADY;
  wire [0:0]xbar_to_m00_couplers_AWVALID;
  wire [0:0]xbar_to_m00_couplers_BREADY;
  wire [1:0]xbar_to_m00_couplers_BRESP;
  wire [0:0]xbar_to_m00_couplers_BVALID;
  wire [31:0]xbar_to_m00_couplers_RDATA;
  wire [0:0]xbar_to_m00_couplers_RREADY;
  wire [1:0]xbar_to_m00_couplers_RRESP;
  wire [0:0]xbar_to_m00_couplers_RVALID;
  wire [31:0]xbar_to_m00_couplers_WDATA;
  wire [0:0]xbar_to_m00_couplers_WREADY;
  wire [3:0]xbar_to_m00_couplers_WSTRB;
  wire [0:0]xbar_to_m00_couplers_WVALID;
  wire [79:40]xbar_to_m01_couplers_ARADDR;
  wire [5:3]xbar_to_m01_couplers_ARPROT;
  wire xbar_to_m01_couplers_ARREADY;
  wire [1:1]xbar_to_m01_couplers_ARVALID;
  wire [79:40]xbar_to_m01_couplers_AWADDR;
  wire [5:3]xbar_to_m01_couplers_AWPROT;
  wire xbar_to_m01_couplers_AWREADY;
  wire [1:1]xbar_to_m01_couplers_AWVALID;
  wire [1:1]xbar_to_m01_couplers_BREADY;
  wire [1:0]xbar_to_m01_couplers_BRESP;
  wire xbar_to_m01_couplers_BVALID;
  wire [31:0]xbar_to_m01_couplers_RDATA;
  wire [1:1]xbar_to_m01_couplers_RREADY;
  wire [1:0]xbar_to_m01_couplers_RRESP;
  wire xbar_to_m01_couplers_RVALID;
  wire [63:32]xbar_to_m01_couplers_WDATA;
  wire xbar_to_m01_couplers_WREADY;
  wire [7:4]xbar_to_m01_couplers_WSTRB;
  wire [1:1]xbar_to_m01_couplers_WVALID;
  wire [119:80]xbar_to_m02_couplers_ARADDR;
  wire [8:6]xbar_to_m02_couplers_ARPROT;
  wire xbar_to_m02_couplers_ARREADY;
  wire [2:2]xbar_to_m02_couplers_ARVALID;
  wire [119:80]xbar_to_m02_couplers_AWADDR;
  wire [8:6]xbar_to_m02_couplers_AWPROT;
  wire xbar_to_m02_couplers_AWREADY;
  wire [2:2]xbar_to_m02_couplers_AWVALID;
  wire [2:2]xbar_to_m02_couplers_BREADY;
  wire [1:0]xbar_to_m02_couplers_BRESP;
  wire xbar_to_m02_couplers_BVALID;
  wire [31:0]xbar_to_m02_couplers_RDATA;
  wire [2:2]xbar_to_m02_couplers_RREADY;
  wire [1:0]xbar_to_m02_couplers_RRESP;
  wire xbar_to_m02_couplers_RVALID;
  wire [95:64]xbar_to_m02_couplers_WDATA;
  wire xbar_to_m02_couplers_WREADY;
  wire [11:8]xbar_to_m02_couplers_WSTRB;
  wire [2:2]xbar_to_m02_couplers_WVALID;
  wire [159:120]xbar_to_m03_couplers_ARADDR;
  wire [11:9]xbar_to_m03_couplers_ARPROT;
  wire xbar_to_m03_couplers_ARREADY;
  wire [3:3]xbar_to_m03_couplers_ARVALID;
  wire [159:120]xbar_to_m03_couplers_AWADDR;
  wire [11:9]xbar_to_m03_couplers_AWPROT;
  wire xbar_to_m03_couplers_AWREADY;
  wire [3:3]xbar_to_m03_couplers_AWVALID;
  wire [3:3]xbar_to_m03_couplers_BREADY;
  wire [1:0]xbar_to_m03_couplers_BRESP;
  wire xbar_to_m03_couplers_BVALID;
  wire [31:0]xbar_to_m03_couplers_RDATA;
  wire [3:3]xbar_to_m03_couplers_RREADY;
  wire [1:0]xbar_to_m03_couplers_RRESP;
  wire xbar_to_m03_couplers_RVALID;
  wire [127:96]xbar_to_m03_couplers_WDATA;
  wire xbar_to_m03_couplers_WREADY;
  wire [15:12]xbar_to_m03_couplers_WSTRB;
  wire [3:3]xbar_to_m03_couplers_WVALID;
  wire [199:160]xbar_to_m04_couplers_ARADDR;
  wire [14:12]xbar_to_m04_couplers_ARPROT;
  wire xbar_to_m04_couplers_ARREADY;
  wire [4:4]xbar_to_m04_couplers_ARVALID;
  wire [199:160]xbar_to_m04_couplers_AWADDR;
  wire [14:12]xbar_to_m04_couplers_AWPROT;
  wire xbar_to_m04_couplers_AWREADY;
  wire [4:4]xbar_to_m04_couplers_AWVALID;
  wire [4:4]xbar_to_m04_couplers_BREADY;
  wire [1:0]xbar_to_m04_couplers_BRESP;
  wire xbar_to_m04_couplers_BVALID;
  wire [31:0]xbar_to_m04_couplers_RDATA;
  wire [4:4]xbar_to_m04_couplers_RREADY;
  wire [1:0]xbar_to_m04_couplers_RRESP;
  wire xbar_to_m04_couplers_RVALID;
  wire [159:128]xbar_to_m04_couplers_WDATA;
  wire xbar_to_m04_couplers_WREADY;
  wire [19:16]xbar_to_m04_couplers_WSTRB;
  wire [4:4]xbar_to_m04_couplers_WVALID;
  wire [14:0]NLW_xbar_m_axi_arprot_UNCONNECTED;
  wire [14:0]NLW_xbar_m_axi_awprot_UNCONNECTED;

  assign M00_ACLK_1 = M00_ACLK;
  assign M00_ARESETN_1 = M00_ARESETN;
  assign M00_AXI_araddr[39:0] = m00_couplers_to_ps8_0_axi_periph_ARADDR;
  assign M00_AXI_arvalid[0] = m00_couplers_to_ps8_0_axi_periph_ARVALID;
  assign M00_AXI_awaddr[39:0] = m00_couplers_to_ps8_0_axi_periph_AWADDR;
  assign M00_AXI_awvalid[0] = m00_couplers_to_ps8_0_axi_periph_AWVALID;
  assign M00_AXI_bready[0] = m00_couplers_to_ps8_0_axi_periph_BREADY;
  assign M00_AXI_rready[0] = m00_couplers_to_ps8_0_axi_periph_RREADY;
  assign M00_AXI_wdata[31:0] = m00_couplers_to_ps8_0_axi_periph_WDATA;
  assign M00_AXI_wstrb[3:0] = m00_couplers_to_ps8_0_axi_periph_WSTRB;
  assign M00_AXI_wvalid[0] = m00_couplers_to_ps8_0_axi_periph_WVALID;
  assign M01_ACLK_1 = M01_ACLK;
  assign M01_ARESETN_1 = M01_ARESETN;
  assign M01_AXI_araddr[8:0] = m01_couplers_to_ps8_0_axi_periph_ARADDR;
  assign M01_AXI_arvalid = m01_couplers_to_ps8_0_axi_periph_ARVALID;
  assign M01_AXI_awaddr[8:0] = m01_couplers_to_ps8_0_axi_periph_AWADDR;
  assign M01_AXI_awvalid = m01_couplers_to_ps8_0_axi_periph_AWVALID;
  assign M01_AXI_bready = m01_couplers_to_ps8_0_axi_periph_BREADY;
  assign M01_AXI_rready = m01_couplers_to_ps8_0_axi_periph_RREADY;
  assign M01_AXI_wdata[31:0] = m01_couplers_to_ps8_0_axi_periph_WDATA;
  assign M01_AXI_wstrb[3:0] = m01_couplers_to_ps8_0_axi_periph_WSTRB;
  assign M01_AXI_wvalid = m01_couplers_to_ps8_0_axi_periph_WVALID;
  assign M02_ACLK_1 = M02_ACLK;
  assign M02_ARESETN_1 = M02_ARESETN;
  assign M02_AXI_araddr[7:0] = m02_couplers_to_ps8_0_axi_periph_ARADDR;
  assign M02_AXI_arvalid = m02_couplers_to_ps8_0_axi_periph_ARVALID;
  assign M02_AXI_awaddr[7:0] = m02_couplers_to_ps8_0_axi_periph_AWADDR;
  assign M02_AXI_awvalid = m02_couplers_to_ps8_0_axi_periph_AWVALID;
  assign M02_AXI_bready = m02_couplers_to_ps8_0_axi_periph_BREADY;
  assign M02_AXI_rready = m02_couplers_to_ps8_0_axi_periph_RREADY;
  assign M02_AXI_wdata[31:0] = m02_couplers_to_ps8_0_axi_periph_WDATA;
  assign M02_AXI_wstrb[3:0] = m02_couplers_to_ps8_0_axi_periph_WSTRB;
  assign M02_AXI_wvalid = m02_couplers_to_ps8_0_axi_periph_WVALID;
  assign M03_ACLK_1 = M03_ACLK;
  assign M03_ARESETN_1 = M03_ARESETN;
  assign M03_AXI_araddr[11:0] = m03_couplers_to_ps8_0_axi_periph_ARADDR;
  assign M03_AXI_arvalid = m03_couplers_to_ps8_0_axi_periph_ARVALID;
  assign M03_AXI_awaddr[11:0] = m03_couplers_to_ps8_0_axi_periph_AWADDR;
  assign M03_AXI_awvalid = m03_couplers_to_ps8_0_axi_periph_AWVALID;
  assign M03_AXI_bready = m03_couplers_to_ps8_0_axi_periph_BREADY;
  assign M03_AXI_rready = m03_couplers_to_ps8_0_axi_periph_RREADY;
  assign M03_AXI_wdata[31:0] = m03_couplers_to_ps8_0_axi_periph_WDATA;
  assign M03_AXI_wstrb[3:0] = m03_couplers_to_ps8_0_axi_periph_WSTRB;
  assign M03_AXI_wvalid = m03_couplers_to_ps8_0_axi_periph_WVALID;
  assign M04_ACLK_1 = M04_ACLK;
  assign M04_ARESETN_1 = M04_ARESETN;
  assign M04_AXI_araddr[11:0] = m04_couplers_to_ps8_0_axi_periph_ARADDR;
  assign M04_AXI_arvalid = m04_couplers_to_ps8_0_axi_periph_ARVALID;
  assign M04_AXI_awaddr[11:0] = m04_couplers_to_ps8_0_axi_periph_AWADDR;
  assign M04_AXI_awvalid = m04_couplers_to_ps8_0_axi_periph_AWVALID;
  assign M04_AXI_bready = m04_couplers_to_ps8_0_axi_periph_BREADY;
  assign M04_AXI_rready = m04_couplers_to_ps8_0_axi_periph_RREADY;
  assign M04_AXI_wdata[31:0] = m04_couplers_to_ps8_0_axi_periph_WDATA;
  assign M04_AXI_wstrb[3:0] = m04_couplers_to_ps8_0_axi_periph_WSTRB;
  assign M04_AXI_wvalid = m04_couplers_to_ps8_0_axi_periph_WVALID;
  assign S00_ACLK_1 = S00_ACLK;
  assign S00_ARESETN_1 = S00_ARESETN;
  assign S00_AXI_arready = ps8_0_axi_periph_to_s00_couplers_ARREADY;
  assign S00_AXI_awready = ps8_0_axi_periph_to_s00_couplers_AWREADY;
  assign S00_AXI_bid[15:0] = ps8_0_axi_periph_to_s00_couplers_BID;
  assign S00_AXI_bresp[1:0] = ps8_0_axi_periph_to_s00_couplers_BRESP;
  assign S00_AXI_bvalid = ps8_0_axi_periph_to_s00_couplers_BVALID;
  assign S00_AXI_rdata[31:0] = ps8_0_axi_periph_to_s00_couplers_RDATA;
  assign S00_AXI_rid[15:0] = ps8_0_axi_periph_to_s00_couplers_RID;
  assign S00_AXI_rlast = ps8_0_axi_periph_to_s00_couplers_RLAST;
  assign S00_AXI_rresp[1:0] = ps8_0_axi_periph_to_s00_couplers_RRESP;
  assign S00_AXI_rvalid = ps8_0_axi_periph_to_s00_couplers_RVALID;
  assign S00_AXI_wready = ps8_0_axi_periph_to_s00_couplers_WREADY;
  assign m00_couplers_to_ps8_0_axi_periph_ARREADY = M00_AXI_arready[0];
  assign m00_couplers_to_ps8_0_axi_periph_AWREADY = M00_AXI_awready[0];
  assign m00_couplers_to_ps8_0_axi_periph_BRESP = M00_AXI_bresp[1:0];
  assign m00_couplers_to_ps8_0_axi_periph_BVALID = M00_AXI_bvalid[0];
  assign m00_couplers_to_ps8_0_axi_periph_RDATA = M00_AXI_rdata[31:0];
  assign m00_couplers_to_ps8_0_axi_periph_RRESP = M00_AXI_rresp[1:0];
  assign m00_couplers_to_ps8_0_axi_periph_RVALID = M00_AXI_rvalid[0];
  assign m00_couplers_to_ps8_0_axi_periph_WREADY = M00_AXI_wready[0];
  assign m01_couplers_to_ps8_0_axi_periph_ARREADY = M01_AXI_arready;
  assign m01_couplers_to_ps8_0_axi_periph_AWREADY = M01_AXI_awready;
  assign m01_couplers_to_ps8_0_axi_periph_BRESP = M01_AXI_bresp[1:0];
  assign m01_couplers_to_ps8_0_axi_periph_BVALID = M01_AXI_bvalid;
  assign m01_couplers_to_ps8_0_axi_periph_RDATA = M01_AXI_rdata[31:0];
  assign m01_couplers_to_ps8_0_axi_periph_RRESP = M01_AXI_rresp[1:0];
  assign m01_couplers_to_ps8_0_axi_periph_RVALID = M01_AXI_rvalid;
  assign m01_couplers_to_ps8_0_axi_periph_WREADY = M01_AXI_wready;
  assign m02_couplers_to_ps8_0_axi_periph_ARREADY = M02_AXI_arready;
  assign m02_couplers_to_ps8_0_axi_periph_AWREADY = M02_AXI_awready;
  assign m02_couplers_to_ps8_0_axi_periph_BRESP = M02_AXI_bresp[1:0];
  assign m02_couplers_to_ps8_0_axi_periph_BVALID = M02_AXI_bvalid;
  assign m02_couplers_to_ps8_0_axi_periph_RDATA = M02_AXI_rdata[31:0];
  assign m02_couplers_to_ps8_0_axi_periph_RRESP = M02_AXI_rresp[1:0];
  assign m02_couplers_to_ps8_0_axi_periph_RVALID = M02_AXI_rvalid;
  assign m02_couplers_to_ps8_0_axi_periph_WREADY = M02_AXI_wready;
  assign m03_couplers_to_ps8_0_axi_periph_ARREADY = M03_AXI_arready;
  assign m03_couplers_to_ps8_0_axi_periph_AWREADY = M03_AXI_awready;
  assign m03_couplers_to_ps8_0_axi_periph_BRESP = M03_AXI_bresp[1:0];
  assign m03_couplers_to_ps8_0_axi_periph_BVALID = M03_AXI_bvalid;
  assign m03_couplers_to_ps8_0_axi_periph_RDATA = M03_AXI_rdata[31:0];
  assign m03_couplers_to_ps8_0_axi_periph_RRESP = M03_AXI_rresp[1:0];
  assign m03_couplers_to_ps8_0_axi_periph_RVALID = M03_AXI_rvalid;
  assign m03_couplers_to_ps8_0_axi_periph_WREADY = M03_AXI_wready;
  assign m04_couplers_to_ps8_0_axi_periph_ARREADY = M04_AXI_arready;
  assign m04_couplers_to_ps8_0_axi_periph_AWREADY = M04_AXI_awready;
  assign m04_couplers_to_ps8_0_axi_periph_BRESP = M04_AXI_bresp[1:0];
  assign m04_couplers_to_ps8_0_axi_periph_BVALID = M04_AXI_bvalid;
  assign m04_couplers_to_ps8_0_axi_periph_RDATA = M04_AXI_rdata[31:0];
  assign m04_couplers_to_ps8_0_axi_periph_RRESP = M04_AXI_rresp[1:0];
  assign m04_couplers_to_ps8_0_axi_periph_RVALID = M04_AXI_rvalid;
  assign m04_couplers_to_ps8_0_axi_periph_WREADY = M04_AXI_wready;
  assign ps8_0_axi_periph_ACLK_net = ACLK;
  assign ps8_0_axi_periph_ARESETN_net = ARESETN;
  assign ps8_0_axi_periph_to_s00_couplers_ARADDR = S00_AXI_araddr[39:0];
  assign ps8_0_axi_periph_to_s00_couplers_ARBURST = S00_AXI_arburst[1:0];
  assign ps8_0_axi_periph_to_s00_couplers_ARCACHE = S00_AXI_arcache[3:0];
  assign ps8_0_axi_periph_to_s00_couplers_ARID = S00_AXI_arid[15:0];
  assign ps8_0_axi_periph_to_s00_couplers_ARLEN = S00_AXI_arlen[7:0];
  assign ps8_0_axi_periph_to_s00_couplers_ARLOCK = S00_AXI_arlock[0];
  assign ps8_0_axi_periph_to_s00_couplers_ARPROT = S00_AXI_arprot[2:0];
  assign ps8_0_axi_periph_to_s00_couplers_ARQOS = S00_AXI_arqos[3:0];
  assign ps8_0_axi_periph_to_s00_couplers_ARSIZE = S00_AXI_arsize[2:0];
  assign ps8_0_axi_periph_to_s00_couplers_ARVALID = S00_AXI_arvalid;
  assign ps8_0_axi_periph_to_s00_couplers_AWADDR = S00_AXI_awaddr[39:0];
  assign ps8_0_axi_periph_to_s00_couplers_AWBURST = S00_AXI_awburst[1:0];
  assign ps8_0_axi_periph_to_s00_couplers_AWCACHE = S00_AXI_awcache[3:0];
  assign ps8_0_axi_periph_to_s00_couplers_AWID = S00_AXI_awid[15:0];
  assign ps8_0_axi_periph_to_s00_couplers_AWLEN = S00_AXI_awlen[7:0];
  assign ps8_0_axi_periph_to_s00_couplers_AWLOCK = S00_AXI_awlock[0];
  assign ps8_0_axi_periph_to_s00_couplers_AWPROT = S00_AXI_awprot[2:0];
  assign ps8_0_axi_periph_to_s00_couplers_AWQOS = S00_AXI_awqos[3:0];
  assign ps8_0_axi_periph_to_s00_couplers_AWSIZE = S00_AXI_awsize[2:0];
  assign ps8_0_axi_periph_to_s00_couplers_AWVALID = S00_AXI_awvalid;
  assign ps8_0_axi_periph_to_s00_couplers_BREADY = S00_AXI_bready;
  assign ps8_0_axi_periph_to_s00_couplers_RREADY = S00_AXI_rready;
  assign ps8_0_axi_periph_to_s00_couplers_WDATA = S00_AXI_wdata[31:0];
  assign ps8_0_axi_periph_to_s00_couplers_WLAST = S00_AXI_wlast;
  assign ps8_0_axi_periph_to_s00_couplers_WSTRB = S00_AXI_wstrb[3:0];
  assign ps8_0_axi_periph_to_s00_couplers_WVALID = S00_AXI_wvalid;
  m00_couplers_imp_1H7JJ68 m00_couplers
       (.M_ACLK(M00_ACLK_1),
        .M_ARESETN(M00_ARESETN_1),
        .M_AXI_araddr(m00_couplers_to_ps8_0_axi_periph_ARADDR),
        .M_AXI_arready(m00_couplers_to_ps8_0_axi_periph_ARREADY),
        .M_AXI_arvalid(m00_couplers_to_ps8_0_axi_periph_ARVALID),
        .M_AXI_awaddr(m00_couplers_to_ps8_0_axi_periph_AWADDR),
        .M_AXI_awready(m00_couplers_to_ps8_0_axi_periph_AWREADY),
        .M_AXI_awvalid(m00_couplers_to_ps8_0_axi_periph_AWVALID),
        .M_AXI_bready(m00_couplers_to_ps8_0_axi_periph_BREADY),
        .M_AXI_bresp(m00_couplers_to_ps8_0_axi_periph_BRESP),
        .M_AXI_bvalid(m00_couplers_to_ps8_0_axi_periph_BVALID),
        .M_AXI_rdata(m00_couplers_to_ps8_0_axi_periph_RDATA),
        .M_AXI_rready(m00_couplers_to_ps8_0_axi_periph_RREADY),
        .M_AXI_rresp(m00_couplers_to_ps8_0_axi_periph_RRESP),
        .M_AXI_rvalid(m00_couplers_to_ps8_0_axi_periph_RVALID),
        .M_AXI_wdata(m00_couplers_to_ps8_0_axi_periph_WDATA),
        .M_AXI_wready(m00_couplers_to_ps8_0_axi_periph_WREADY),
        .M_AXI_wstrb(m00_couplers_to_ps8_0_axi_periph_WSTRB),
        .M_AXI_wvalid(m00_couplers_to_ps8_0_axi_periph_WVALID),
        .S_ACLK(ps8_0_axi_periph_ACLK_net),
        .S_ARESETN(ps8_0_axi_periph_ARESETN_net),
        .S_AXI_araddr(xbar_to_m00_couplers_ARADDR),
        .S_AXI_arready(xbar_to_m00_couplers_ARREADY),
        .S_AXI_arvalid(xbar_to_m00_couplers_ARVALID),
        .S_AXI_awaddr(xbar_to_m00_couplers_AWADDR),
        .S_AXI_awready(xbar_to_m00_couplers_AWREADY),
        .S_AXI_awvalid(xbar_to_m00_couplers_AWVALID),
        .S_AXI_bready(xbar_to_m00_couplers_BREADY),
        .S_AXI_bresp(xbar_to_m00_couplers_BRESP),
        .S_AXI_bvalid(xbar_to_m00_couplers_BVALID),
        .S_AXI_rdata(xbar_to_m00_couplers_RDATA),
        .S_AXI_rready(xbar_to_m00_couplers_RREADY),
        .S_AXI_rresp(xbar_to_m00_couplers_RRESP),
        .S_AXI_rvalid(xbar_to_m00_couplers_RVALID),
        .S_AXI_wdata(xbar_to_m00_couplers_WDATA),
        .S_AXI_wready(xbar_to_m00_couplers_WREADY),
        .S_AXI_wstrb(xbar_to_m00_couplers_WSTRB),
        .S_AXI_wvalid(xbar_to_m00_couplers_WVALID));
  m01_couplers_imp_122MS6B m01_couplers
       (.M_ACLK(M01_ACLK_1),
        .M_ARESETN(M01_ARESETN_1),
        .M_AXI_araddr(m01_couplers_to_ps8_0_axi_periph_ARADDR),
        .M_AXI_arready(m01_couplers_to_ps8_0_axi_periph_ARREADY),
        .M_AXI_arvalid(m01_couplers_to_ps8_0_axi_periph_ARVALID),
        .M_AXI_awaddr(m01_couplers_to_ps8_0_axi_periph_AWADDR),
        .M_AXI_awready(m01_couplers_to_ps8_0_axi_periph_AWREADY),
        .M_AXI_awvalid(m01_couplers_to_ps8_0_axi_periph_AWVALID),
        .M_AXI_bready(m01_couplers_to_ps8_0_axi_periph_BREADY),
        .M_AXI_bresp(m01_couplers_to_ps8_0_axi_periph_BRESP),
        .M_AXI_bvalid(m01_couplers_to_ps8_0_axi_periph_BVALID),
        .M_AXI_rdata(m01_couplers_to_ps8_0_axi_periph_RDATA),
        .M_AXI_rready(m01_couplers_to_ps8_0_axi_periph_RREADY),
        .M_AXI_rresp(m01_couplers_to_ps8_0_axi_periph_RRESP),
        .M_AXI_rvalid(m01_couplers_to_ps8_0_axi_periph_RVALID),
        .M_AXI_wdata(m01_couplers_to_ps8_0_axi_periph_WDATA),
        .M_AXI_wready(m01_couplers_to_ps8_0_axi_periph_WREADY),
        .M_AXI_wstrb(m01_couplers_to_ps8_0_axi_periph_WSTRB),
        .M_AXI_wvalid(m01_couplers_to_ps8_0_axi_periph_WVALID),
        .S_ACLK(ps8_0_axi_periph_ACLK_net),
        .S_ARESETN(ps8_0_axi_periph_ARESETN_net),
        .S_AXI_araddr(xbar_to_m01_couplers_ARADDR),
        .S_AXI_arprot(xbar_to_m01_couplers_ARPROT),
        .S_AXI_arready(xbar_to_m01_couplers_ARREADY),
        .S_AXI_arvalid(xbar_to_m01_couplers_ARVALID),
        .S_AXI_awaddr(xbar_to_m01_couplers_AWADDR),
        .S_AXI_awprot(xbar_to_m01_couplers_AWPROT),
        .S_AXI_awready(xbar_to_m01_couplers_AWREADY),
        .S_AXI_awvalid(xbar_to_m01_couplers_AWVALID),
        .S_AXI_bready(xbar_to_m01_couplers_BREADY),
        .S_AXI_bresp(xbar_to_m01_couplers_BRESP),
        .S_AXI_bvalid(xbar_to_m01_couplers_BVALID),
        .S_AXI_rdata(xbar_to_m01_couplers_RDATA),
        .S_AXI_rready(xbar_to_m01_couplers_RREADY),
        .S_AXI_rresp(xbar_to_m01_couplers_RRESP),
        .S_AXI_rvalid(xbar_to_m01_couplers_RVALID),
        .S_AXI_wdata(xbar_to_m01_couplers_WDATA),
        .S_AXI_wready(xbar_to_m01_couplers_WREADY),
        .S_AXI_wstrb(xbar_to_m01_couplers_WSTRB),
        .S_AXI_wvalid(xbar_to_m01_couplers_WVALID));
  m02_couplers_imp_1MAW852 m02_couplers
       (.M_ACLK(M02_ACLK_1),
        .M_ARESETN(M02_ARESETN_1),
        .M_AXI_araddr(m02_couplers_to_ps8_0_axi_periph_ARADDR),
        .M_AXI_arready(m02_couplers_to_ps8_0_axi_periph_ARREADY),
        .M_AXI_arvalid(m02_couplers_to_ps8_0_axi_periph_ARVALID),
        .M_AXI_awaddr(m02_couplers_to_ps8_0_axi_periph_AWADDR),
        .M_AXI_awready(m02_couplers_to_ps8_0_axi_periph_AWREADY),
        .M_AXI_awvalid(m02_couplers_to_ps8_0_axi_periph_AWVALID),
        .M_AXI_bready(m02_couplers_to_ps8_0_axi_periph_BREADY),
        .M_AXI_bresp(m02_couplers_to_ps8_0_axi_periph_BRESP),
        .M_AXI_bvalid(m02_couplers_to_ps8_0_axi_periph_BVALID),
        .M_AXI_rdata(m02_couplers_to_ps8_0_axi_periph_RDATA),
        .M_AXI_rready(m02_couplers_to_ps8_0_axi_periph_RREADY),
        .M_AXI_rresp(m02_couplers_to_ps8_0_axi_periph_RRESP),
        .M_AXI_rvalid(m02_couplers_to_ps8_0_axi_periph_RVALID),
        .M_AXI_wdata(m02_couplers_to_ps8_0_axi_periph_WDATA),
        .M_AXI_wready(m02_couplers_to_ps8_0_axi_periph_WREADY),
        .M_AXI_wstrb(m02_couplers_to_ps8_0_axi_periph_WSTRB),
        .M_AXI_wvalid(m02_couplers_to_ps8_0_axi_periph_WVALID),
        .S_ACLK(ps8_0_axi_periph_ACLK_net),
        .S_ARESETN(ps8_0_axi_periph_ARESETN_net),
        .S_AXI_araddr(xbar_to_m02_couplers_ARADDR),
        .S_AXI_arprot(xbar_to_m02_couplers_ARPROT),
        .S_AXI_arready(xbar_to_m02_couplers_ARREADY),
        .S_AXI_arvalid(xbar_to_m02_couplers_ARVALID),
        .S_AXI_awaddr(xbar_to_m02_couplers_AWADDR),
        .S_AXI_awprot(xbar_to_m02_couplers_AWPROT),
        .S_AXI_awready(xbar_to_m02_couplers_AWREADY),
        .S_AXI_awvalid(xbar_to_m02_couplers_AWVALID),
        .S_AXI_bready(xbar_to_m02_couplers_BREADY),
        .S_AXI_bresp(xbar_to_m02_couplers_BRESP),
        .S_AXI_bvalid(xbar_to_m02_couplers_BVALID),
        .S_AXI_rdata(xbar_to_m02_couplers_RDATA),
        .S_AXI_rready(xbar_to_m02_couplers_RREADY),
        .S_AXI_rresp(xbar_to_m02_couplers_RRESP),
        .S_AXI_rvalid(xbar_to_m02_couplers_RVALID),
        .S_AXI_wdata(xbar_to_m02_couplers_WDATA),
        .S_AXI_wready(xbar_to_m02_couplers_WREADY),
        .S_AXI_wstrb(xbar_to_m02_couplers_WSTRB),
        .S_AXI_wvalid(xbar_to_m02_couplers_WVALID));
  m03_couplers_imp_1RHNQO5 m03_couplers
       (.M_ACLK(M03_ACLK_1),
        .M_ARESETN(M03_ARESETN_1),
        .M_AXI_araddr(m03_couplers_to_ps8_0_axi_periph_ARADDR),
        .M_AXI_arready(m03_couplers_to_ps8_0_axi_periph_ARREADY),
        .M_AXI_arvalid(m03_couplers_to_ps8_0_axi_periph_ARVALID),
        .M_AXI_awaddr(m03_couplers_to_ps8_0_axi_periph_AWADDR),
        .M_AXI_awready(m03_couplers_to_ps8_0_axi_periph_AWREADY),
        .M_AXI_awvalid(m03_couplers_to_ps8_0_axi_periph_AWVALID),
        .M_AXI_bready(m03_couplers_to_ps8_0_axi_periph_BREADY),
        .M_AXI_bresp(m03_couplers_to_ps8_0_axi_periph_BRESP),
        .M_AXI_bvalid(m03_couplers_to_ps8_0_axi_periph_BVALID),
        .M_AXI_rdata(m03_couplers_to_ps8_0_axi_periph_RDATA),
        .M_AXI_rready(m03_couplers_to_ps8_0_axi_periph_RREADY),
        .M_AXI_rresp(m03_couplers_to_ps8_0_axi_periph_RRESP),
        .M_AXI_rvalid(m03_couplers_to_ps8_0_axi_periph_RVALID),
        .M_AXI_wdata(m03_couplers_to_ps8_0_axi_periph_WDATA),
        .M_AXI_wready(m03_couplers_to_ps8_0_axi_periph_WREADY),
        .M_AXI_wstrb(m03_couplers_to_ps8_0_axi_periph_WSTRB),
        .M_AXI_wvalid(m03_couplers_to_ps8_0_axi_periph_WVALID),
        .S_ACLK(ps8_0_axi_periph_ACLK_net),
        .S_ARESETN(ps8_0_axi_periph_ARESETN_net),
        .S_AXI_araddr(xbar_to_m03_couplers_ARADDR),
        .S_AXI_arprot(xbar_to_m03_couplers_ARPROT),
        .S_AXI_arready(xbar_to_m03_couplers_ARREADY),
        .S_AXI_arvalid(xbar_to_m03_couplers_ARVALID),
        .S_AXI_awaddr(xbar_to_m03_couplers_AWADDR),
        .S_AXI_awprot(xbar_to_m03_couplers_AWPROT),
        .S_AXI_awready(xbar_to_m03_couplers_AWREADY),
        .S_AXI_awvalid(xbar_to_m03_couplers_AWVALID),
        .S_AXI_bready(xbar_to_m03_couplers_BREADY),
        .S_AXI_bresp(xbar_to_m03_couplers_BRESP),
        .S_AXI_bvalid(xbar_to_m03_couplers_BVALID),
        .S_AXI_rdata(xbar_to_m03_couplers_RDATA),
        .S_AXI_rready(xbar_to_m03_couplers_RREADY),
        .S_AXI_rresp(xbar_to_m03_couplers_RRESP),
        .S_AXI_rvalid(xbar_to_m03_couplers_RVALID),
        .S_AXI_wdata(xbar_to_m03_couplers_WDATA),
        .S_AXI_wready(xbar_to_m03_couplers_WREADY),
        .S_AXI_wstrb(xbar_to_m03_couplers_WSTRB),
        .S_AXI_wvalid(xbar_to_m03_couplers_WVALID));
  m04_couplers_imp_RRGH0C m04_couplers
       (.M_ACLK(M04_ACLK_1),
        .M_ARESETN(M04_ARESETN_1),
        .M_AXI_araddr(m04_couplers_to_ps8_0_axi_periph_ARADDR),
        .M_AXI_arready(m04_couplers_to_ps8_0_axi_periph_ARREADY),
        .M_AXI_arvalid(m04_couplers_to_ps8_0_axi_periph_ARVALID),
        .M_AXI_awaddr(m04_couplers_to_ps8_0_axi_periph_AWADDR),
        .M_AXI_awready(m04_couplers_to_ps8_0_axi_periph_AWREADY),
        .M_AXI_awvalid(m04_couplers_to_ps8_0_axi_periph_AWVALID),
        .M_AXI_bready(m04_couplers_to_ps8_0_axi_periph_BREADY),
        .M_AXI_bresp(m04_couplers_to_ps8_0_axi_periph_BRESP),
        .M_AXI_bvalid(m04_couplers_to_ps8_0_axi_periph_BVALID),
        .M_AXI_rdata(m04_couplers_to_ps8_0_axi_periph_RDATA),
        .M_AXI_rready(m04_couplers_to_ps8_0_axi_periph_RREADY),
        .M_AXI_rresp(m04_couplers_to_ps8_0_axi_periph_RRESP),
        .M_AXI_rvalid(m04_couplers_to_ps8_0_axi_periph_RVALID),
        .M_AXI_wdata(m04_couplers_to_ps8_0_axi_periph_WDATA),
        .M_AXI_wready(m04_couplers_to_ps8_0_axi_periph_WREADY),
        .M_AXI_wstrb(m04_couplers_to_ps8_0_axi_periph_WSTRB),
        .M_AXI_wvalid(m04_couplers_to_ps8_0_axi_periph_WVALID),
        .S_ACLK(ps8_0_axi_periph_ACLK_net),
        .S_ARESETN(ps8_0_axi_periph_ARESETN_net),
        .S_AXI_araddr(xbar_to_m04_couplers_ARADDR),
        .S_AXI_arprot(xbar_to_m04_couplers_ARPROT),
        .S_AXI_arready(xbar_to_m04_couplers_ARREADY),
        .S_AXI_arvalid(xbar_to_m04_couplers_ARVALID),
        .S_AXI_awaddr(xbar_to_m04_couplers_AWADDR),
        .S_AXI_awprot(xbar_to_m04_couplers_AWPROT),
        .S_AXI_awready(xbar_to_m04_couplers_AWREADY),
        .S_AXI_awvalid(xbar_to_m04_couplers_AWVALID),
        .S_AXI_bready(xbar_to_m04_couplers_BREADY),
        .S_AXI_bresp(xbar_to_m04_couplers_BRESP),
        .S_AXI_bvalid(xbar_to_m04_couplers_BVALID),
        .S_AXI_rdata(xbar_to_m04_couplers_RDATA),
        .S_AXI_rready(xbar_to_m04_couplers_RREADY),
        .S_AXI_rresp(xbar_to_m04_couplers_RRESP),
        .S_AXI_rvalid(xbar_to_m04_couplers_RVALID),
        .S_AXI_wdata(xbar_to_m04_couplers_WDATA),
        .S_AXI_wready(xbar_to_m04_couplers_WREADY),
        .S_AXI_wstrb(xbar_to_m04_couplers_WSTRB),
        .S_AXI_wvalid(xbar_to_m04_couplers_WVALID));
  s00_couplers_imp_1WG0C8D s00_couplers
       (.M_ACLK(ps8_0_axi_periph_ACLK_net),
        .M_ARESETN(ps8_0_axi_periph_ARESETN_net),
        .M_AXI_araddr(s00_couplers_to_xbar_ARADDR),
        .M_AXI_arprot(s00_couplers_to_xbar_ARPROT),
        .M_AXI_arready(s00_couplers_to_xbar_ARREADY),
        .M_AXI_arvalid(s00_couplers_to_xbar_ARVALID),
        .M_AXI_awaddr(s00_couplers_to_xbar_AWADDR),
        .M_AXI_awprot(s00_couplers_to_xbar_AWPROT),
        .M_AXI_awready(s00_couplers_to_xbar_AWREADY),
        .M_AXI_awvalid(s00_couplers_to_xbar_AWVALID),
        .M_AXI_bready(s00_couplers_to_xbar_BREADY),
        .M_AXI_bresp(s00_couplers_to_xbar_BRESP),
        .M_AXI_bvalid(s00_couplers_to_xbar_BVALID),
        .M_AXI_rdata(s00_couplers_to_xbar_RDATA),
        .M_AXI_rready(s00_couplers_to_xbar_RREADY),
        .M_AXI_rresp(s00_couplers_to_xbar_RRESP),
        .M_AXI_rvalid(s00_couplers_to_xbar_RVALID),
        .M_AXI_wdata(s00_couplers_to_xbar_WDATA),
        .M_AXI_wready(s00_couplers_to_xbar_WREADY),
        .M_AXI_wstrb(s00_couplers_to_xbar_WSTRB),
        .M_AXI_wvalid(s00_couplers_to_xbar_WVALID),
        .S_ACLK(S00_ACLK_1),
        .S_ARESETN(S00_ARESETN_1),
        .S_AXI_araddr(ps8_0_axi_periph_to_s00_couplers_ARADDR),
        .S_AXI_arburst(ps8_0_axi_periph_to_s00_couplers_ARBURST),
        .S_AXI_arcache(ps8_0_axi_periph_to_s00_couplers_ARCACHE),
        .S_AXI_arid(ps8_0_axi_periph_to_s00_couplers_ARID),
        .S_AXI_arlen(ps8_0_axi_periph_to_s00_couplers_ARLEN),
        .S_AXI_arlock(ps8_0_axi_periph_to_s00_couplers_ARLOCK),
        .S_AXI_arprot(ps8_0_axi_periph_to_s00_couplers_ARPROT),
        .S_AXI_arqos(ps8_0_axi_periph_to_s00_couplers_ARQOS),
        .S_AXI_arready(ps8_0_axi_periph_to_s00_couplers_ARREADY),
        .S_AXI_arsize(ps8_0_axi_periph_to_s00_couplers_ARSIZE),
        .S_AXI_arvalid(ps8_0_axi_periph_to_s00_couplers_ARVALID),
        .S_AXI_awaddr(ps8_0_axi_periph_to_s00_couplers_AWADDR),
        .S_AXI_awburst(ps8_0_axi_periph_to_s00_couplers_AWBURST),
        .S_AXI_awcache(ps8_0_axi_periph_to_s00_couplers_AWCACHE),
        .S_AXI_awid(ps8_0_axi_periph_to_s00_couplers_AWID),
        .S_AXI_awlen(ps8_0_axi_periph_to_s00_couplers_AWLEN),
        .S_AXI_awlock(ps8_0_axi_periph_to_s00_couplers_AWLOCK),
        .S_AXI_awprot(ps8_0_axi_periph_to_s00_couplers_AWPROT),
        .S_AXI_awqos(ps8_0_axi_periph_to_s00_couplers_AWQOS),
        .S_AXI_awready(ps8_0_axi_periph_to_s00_couplers_AWREADY),
        .S_AXI_awsize(ps8_0_axi_periph_to_s00_couplers_AWSIZE),
        .S_AXI_awvalid(ps8_0_axi_periph_to_s00_couplers_AWVALID),
        .S_AXI_bid(ps8_0_axi_periph_to_s00_couplers_BID),
        .S_AXI_bready(ps8_0_axi_periph_to_s00_couplers_BREADY),
        .S_AXI_bresp(ps8_0_axi_periph_to_s00_couplers_BRESP),
        .S_AXI_bvalid(ps8_0_axi_periph_to_s00_couplers_BVALID),
        .S_AXI_rdata(ps8_0_axi_periph_to_s00_couplers_RDATA),
        .S_AXI_rid(ps8_0_axi_periph_to_s00_couplers_RID),
        .S_AXI_rlast(ps8_0_axi_periph_to_s00_couplers_RLAST),
        .S_AXI_rready(ps8_0_axi_periph_to_s00_couplers_RREADY),
        .S_AXI_rresp(ps8_0_axi_periph_to_s00_couplers_RRESP),
        .S_AXI_rvalid(ps8_0_axi_periph_to_s00_couplers_RVALID),
        .S_AXI_wdata(ps8_0_axi_periph_to_s00_couplers_WDATA),
        .S_AXI_wlast(ps8_0_axi_periph_to_s00_couplers_WLAST),
        .S_AXI_wready(ps8_0_axi_periph_to_s00_couplers_WREADY),
        .S_AXI_wstrb(ps8_0_axi_periph_to_s00_couplers_WSTRB),
        .S_AXI_wvalid(ps8_0_axi_periph_to_s00_couplers_WVALID));
  kv260_hardware_platform_xbar_0 xbar
       (.aclk(ps8_0_axi_periph_ACLK_net),
        .aresetn(ps8_0_axi_periph_ARESETN_net),
        .m_axi_araddr({xbar_to_m04_couplers_ARADDR,xbar_to_m03_couplers_ARADDR,xbar_to_m02_couplers_ARADDR,xbar_to_m01_couplers_ARADDR,xbar_to_m00_couplers_ARADDR}),
        .m_axi_arprot({xbar_to_m04_couplers_ARPROT,xbar_to_m03_couplers_ARPROT,xbar_to_m02_couplers_ARPROT,xbar_to_m01_couplers_ARPROT,NLW_xbar_m_axi_arprot_UNCONNECTED[2:0]}),
        .m_axi_arready({xbar_to_m04_couplers_ARREADY,xbar_to_m03_couplers_ARREADY,xbar_to_m02_couplers_ARREADY,xbar_to_m01_couplers_ARREADY,xbar_to_m00_couplers_ARREADY}),
        .m_axi_arvalid({xbar_to_m04_couplers_ARVALID,xbar_to_m03_couplers_ARVALID,xbar_to_m02_couplers_ARVALID,xbar_to_m01_couplers_ARVALID,xbar_to_m00_couplers_ARVALID}),
        .m_axi_awaddr({xbar_to_m04_couplers_AWADDR,xbar_to_m03_couplers_AWADDR,xbar_to_m02_couplers_AWADDR,xbar_to_m01_couplers_AWADDR,xbar_to_m00_couplers_AWADDR}),
        .m_axi_awprot({xbar_to_m04_couplers_AWPROT,xbar_to_m03_couplers_AWPROT,xbar_to_m02_couplers_AWPROT,xbar_to_m01_couplers_AWPROT,NLW_xbar_m_axi_awprot_UNCONNECTED[2:0]}),
        .m_axi_awready({xbar_to_m04_couplers_AWREADY,xbar_to_m03_couplers_AWREADY,xbar_to_m02_couplers_AWREADY,xbar_to_m01_couplers_AWREADY,xbar_to_m00_couplers_AWREADY}),
        .m_axi_awvalid({xbar_to_m04_couplers_AWVALID,xbar_to_m03_couplers_AWVALID,xbar_to_m02_couplers_AWVALID,xbar_to_m01_couplers_AWVALID,xbar_to_m00_couplers_AWVALID}),
        .m_axi_bready({xbar_to_m04_couplers_BREADY,xbar_to_m03_couplers_BREADY,xbar_to_m02_couplers_BREADY,xbar_to_m01_couplers_BREADY,xbar_to_m00_couplers_BREADY}),
        .m_axi_bresp({xbar_to_m04_couplers_BRESP,xbar_to_m03_couplers_BRESP,xbar_to_m02_couplers_BRESP,xbar_to_m01_couplers_BRESP,xbar_to_m00_couplers_BRESP}),
        .m_axi_bvalid({xbar_to_m04_couplers_BVALID,xbar_to_m03_couplers_BVALID,xbar_to_m02_couplers_BVALID,xbar_to_m01_couplers_BVALID,xbar_to_m00_couplers_BVALID}),
        .m_axi_rdata({xbar_to_m04_couplers_RDATA,xbar_to_m03_couplers_RDATA,xbar_to_m02_couplers_RDATA,xbar_to_m01_couplers_RDATA,xbar_to_m00_couplers_RDATA}),
        .m_axi_rready({xbar_to_m04_couplers_RREADY,xbar_to_m03_couplers_RREADY,xbar_to_m02_couplers_RREADY,xbar_to_m01_couplers_RREADY,xbar_to_m00_couplers_RREADY}),
        .m_axi_rresp({xbar_to_m04_couplers_RRESP,xbar_to_m03_couplers_RRESP,xbar_to_m02_couplers_RRESP,xbar_to_m01_couplers_RRESP,xbar_to_m00_couplers_RRESP}),
        .m_axi_rvalid({xbar_to_m04_couplers_RVALID,xbar_to_m03_couplers_RVALID,xbar_to_m02_couplers_RVALID,xbar_to_m01_couplers_RVALID,xbar_to_m00_couplers_RVALID}),
        .m_axi_wdata({xbar_to_m04_couplers_WDATA,xbar_to_m03_couplers_WDATA,xbar_to_m02_couplers_WDATA,xbar_to_m01_couplers_WDATA,xbar_to_m00_couplers_WDATA}),
        .m_axi_wready({xbar_to_m04_couplers_WREADY,xbar_to_m03_couplers_WREADY,xbar_to_m02_couplers_WREADY,xbar_to_m01_couplers_WREADY,xbar_to_m00_couplers_WREADY}),
        .m_axi_wstrb({xbar_to_m04_couplers_WSTRB,xbar_to_m03_couplers_WSTRB,xbar_to_m02_couplers_WSTRB,xbar_to_m01_couplers_WSTRB,xbar_to_m00_couplers_WSTRB}),
        .m_axi_wvalid({xbar_to_m04_couplers_WVALID,xbar_to_m03_couplers_WVALID,xbar_to_m02_couplers_WVALID,xbar_to_m01_couplers_WVALID,xbar_to_m00_couplers_WVALID}),
        .s_axi_araddr(s00_couplers_to_xbar_ARADDR),
        .s_axi_arprot(s00_couplers_to_xbar_ARPROT),
        .s_axi_arready(s00_couplers_to_xbar_ARREADY),
        .s_axi_arvalid(s00_couplers_to_xbar_ARVALID),
        .s_axi_awaddr(s00_couplers_to_xbar_AWADDR),
        .s_axi_awprot(s00_couplers_to_xbar_AWPROT),
        .s_axi_awready(s00_couplers_to_xbar_AWREADY),
        .s_axi_awvalid(s00_couplers_to_xbar_AWVALID),
        .s_axi_bready(s00_couplers_to_xbar_BREADY),
        .s_axi_bresp(s00_couplers_to_xbar_BRESP),
        .s_axi_bvalid(s00_couplers_to_xbar_BVALID),
        .s_axi_rdata(s00_couplers_to_xbar_RDATA),
        .s_axi_rready(s00_couplers_to_xbar_RREADY),
        .s_axi_rresp(s00_couplers_to_xbar_RRESP),
        .s_axi_rvalid(s00_couplers_to_xbar_RVALID),
        .s_axi_wdata(s00_couplers_to_xbar_WDATA),
        .s_axi_wready(s00_couplers_to_xbar_WREADY),
        .s_axi_wstrb(s00_couplers_to_xbar_WSTRB),
        .s_axi_wvalid(s00_couplers_to_xbar_WVALID));
endmodule

module m00_couplers_imp_1H7JJ68
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arready,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awready,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arready,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awready,
    S_AXI_awvalid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [39:0]M_AXI_araddr;
  input [0:0]M_AXI_arready;
  output [0:0]M_AXI_arvalid;
  output [39:0]M_AXI_awaddr;
  input [0:0]M_AXI_awready;
  output [0:0]M_AXI_awvalid;
  output [0:0]M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input [0:0]M_AXI_bvalid;
  input [31:0]M_AXI_rdata;
  output [0:0]M_AXI_rready;
  input [1:0]M_AXI_rresp;
  input [0:0]M_AXI_rvalid;
  output [31:0]M_AXI_wdata;
  input [0:0]M_AXI_wready;
  output [3:0]M_AXI_wstrb;
  output [0:0]M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input [39:0]S_AXI_araddr;
  output [0:0]S_AXI_arready;
  input [0:0]S_AXI_arvalid;
  input [39:0]S_AXI_awaddr;
  output [0:0]S_AXI_awready;
  input [0:0]S_AXI_awvalid;
  input [0:0]S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output [0:0]S_AXI_bvalid;
  output [31:0]S_AXI_rdata;
  input [0:0]S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output [0:0]S_AXI_rvalid;
  input [31:0]S_AXI_wdata;
  output [0:0]S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input [0:0]S_AXI_wvalid;

  wire [39:0]m00_couplers_to_m00_couplers_ARADDR;
  wire [0:0]m00_couplers_to_m00_couplers_ARREADY;
  wire [0:0]m00_couplers_to_m00_couplers_ARVALID;
  wire [39:0]m00_couplers_to_m00_couplers_AWADDR;
  wire [0:0]m00_couplers_to_m00_couplers_AWREADY;
  wire [0:0]m00_couplers_to_m00_couplers_AWVALID;
  wire [0:0]m00_couplers_to_m00_couplers_BREADY;
  wire [1:0]m00_couplers_to_m00_couplers_BRESP;
  wire [0:0]m00_couplers_to_m00_couplers_BVALID;
  wire [31:0]m00_couplers_to_m00_couplers_RDATA;
  wire [0:0]m00_couplers_to_m00_couplers_RREADY;
  wire [1:0]m00_couplers_to_m00_couplers_RRESP;
  wire [0:0]m00_couplers_to_m00_couplers_RVALID;
  wire [31:0]m00_couplers_to_m00_couplers_WDATA;
  wire [0:0]m00_couplers_to_m00_couplers_WREADY;
  wire [3:0]m00_couplers_to_m00_couplers_WSTRB;
  wire [0:0]m00_couplers_to_m00_couplers_WVALID;

  assign M_AXI_araddr[39:0] = m00_couplers_to_m00_couplers_ARADDR;
  assign M_AXI_arvalid[0] = m00_couplers_to_m00_couplers_ARVALID;
  assign M_AXI_awaddr[39:0] = m00_couplers_to_m00_couplers_AWADDR;
  assign M_AXI_awvalid[0] = m00_couplers_to_m00_couplers_AWVALID;
  assign M_AXI_bready[0] = m00_couplers_to_m00_couplers_BREADY;
  assign M_AXI_rready[0] = m00_couplers_to_m00_couplers_RREADY;
  assign M_AXI_wdata[31:0] = m00_couplers_to_m00_couplers_WDATA;
  assign M_AXI_wstrb[3:0] = m00_couplers_to_m00_couplers_WSTRB;
  assign M_AXI_wvalid[0] = m00_couplers_to_m00_couplers_WVALID;
  assign S_AXI_arready[0] = m00_couplers_to_m00_couplers_ARREADY;
  assign S_AXI_awready[0] = m00_couplers_to_m00_couplers_AWREADY;
  assign S_AXI_bresp[1:0] = m00_couplers_to_m00_couplers_BRESP;
  assign S_AXI_bvalid[0] = m00_couplers_to_m00_couplers_BVALID;
  assign S_AXI_rdata[31:0] = m00_couplers_to_m00_couplers_RDATA;
  assign S_AXI_rresp[1:0] = m00_couplers_to_m00_couplers_RRESP;
  assign S_AXI_rvalid[0] = m00_couplers_to_m00_couplers_RVALID;
  assign S_AXI_wready[0] = m00_couplers_to_m00_couplers_WREADY;
  assign m00_couplers_to_m00_couplers_ARADDR = S_AXI_araddr[39:0];
  assign m00_couplers_to_m00_couplers_ARREADY = M_AXI_arready[0];
  assign m00_couplers_to_m00_couplers_ARVALID = S_AXI_arvalid[0];
  assign m00_couplers_to_m00_couplers_AWADDR = S_AXI_awaddr[39:0];
  assign m00_couplers_to_m00_couplers_AWREADY = M_AXI_awready[0];
  assign m00_couplers_to_m00_couplers_AWVALID = S_AXI_awvalid[0];
  assign m00_couplers_to_m00_couplers_BREADY = S_AXI_bready[0];
  assign m00_couplers_to_m00_couplers_BRESP = M_AXI_bresp[1:0];
  assign m00_couplers_to_m00_couplers_BVALID = M_AXI_bvalid[0];
  assign m00_couplers_to_m00_couplers_RDATA = M_AXI_rdata[31:0];
  assign m00_couplers_to_m00_couplers_RREADY = S_AXI_rready[0];
  assign m00_couplers_to_m00_couplers_RRESP = M_AXI_rresp[1:0];
  assign m00_couplers_to_m00_couplers_RVALID = M_AXI_rvalid[0];
  assign m00_couplers_to_m00_couplers_WDATA = S_AXI_wdata[31:0];
  assign m00_couplers_to_m00_couplers_WREADY = M_AXI_wready[0];
  assign m00_couplers_to_m00_couplers_WSTRB = S_AXI_wstrb[3:0];
  assign m00_couplers_to_m00_couplers_WVALID = S_AXI_wvalid[0];
endmodule

module m00_couplers_imp_1I1E5EU
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arburst,
    M_AXI_arcache,
    M_AXI_arid,
    M_AXI_arlen,
    M_AXI_arlock,
    M_AXI_arprot,
    M_AXI_arqos,
    M_AXI_arready,
    M_AXI_arsize,
    M_AXI_aruser,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awburst,
    M_AXI_awcache,
    M_AXI_awid,
    M_AXI_awlen,
    M_AXI_awlock,
    M_AXI_awprot,
    M_AXI_awqos,
    M_AXI_awready,
    M_AXI_awsize,
    M_AXI_awuser,
    M_AXI_awvalid,
    M_AXI_bid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rid,
    M_AXI_rlast,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wlast,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arburst,
    S_AXI_arcache,
    S_AXI_arid,
    S_AXI_arlen,
    S_AXI_arlock,
    S_AXI_arprot,
    S_AXI_arqos,
    S_AXI_arready,
    S_AXI_arregion,
    S_AXI_arsize,
    S_AXI_aruser,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awburst,
    S_AXI_awcache,
    S_AXI_awid,
    S_AXI_awlen,
    S_AXI_awlock,
    S_AXI_awprot,
    S_AXI_awqos,
    S_AXI_awready,
    S_AXI_awregion,
    S_AXI_awsize,
    S_AXI_awuser,
    S_AXI_awvalid,
    S_AXI_bid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rid,
    S_AXI_rlast,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wlast,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [48:0]M_AXI_araddr;
  output [1:0]M_AXI_arburst;
  output [3:0]M_AXI_arcache;
  output [0:0]M_AXI_arid;
  output [7:0]M_AXI_arlen;
  output [0:0]M_AXI_arlock;
  output [2:0]M_AXI_arprot;
  output [3:0]M_AXI_arqos;
  input M_AXI_arready;
  output [2:0]M_AXI_arsize;
  output [0:0]M_AXI_aruser;
  output M_AXI_arvalid;
  output [48:0]M_AXI_awaddr;
  output [1:0]M_AXI_awburst;
  output [3:0]M_AXI_awcache;
  output [0:0]M_AXI_awid;
  output [7:0]M_AXI_awlen;
  output [0:0]M_AXI_awlock;
  output [2:0]M_AXI_awprot;
  output [3:0]M_AXI_awqos;
  input M_AXI_awready;
  output [2:0]M_AXI_awsize;
  output [0:0]M_AXI_awuser;
  output M_AXI_awvalid;
  input [5:0]M_AXI_bid;
  output M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input M_AXI_bvalid;
  input [127:0]M_AXI_rdata;
  input [5:0]M_AXI_rid;
  input M_AXI_rlast;
  output M_AXI_rready;
  input [1:0]M_AXI_rresp;
  input M_AXI_rvalid;
  output [127:0]M_AXI_wdata;
  output M_AXI_wlast;
  input M_AXI_wready;
  output [15:0]M_AXI_wstrb;
  output M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input [39:0]S_AXI_araddr;
  input [1:0]S_AXI_arburst;
  input [3:0]S_AXI_arcache;
  input [0:0]S_AXI_arid;
  input [7:0]S_AXI_arlen;
  input [0:0]S_AXI_arlock;
  input [2:0]S_AXI_arprot;
  input [3:0]S_AXI_arqos;
  output S_AXI_arready;
  input [3:0]S_AXI_arregion;
  input [2:0]S_AXI_arsize;
  input [0:0]S_AXI_aruser;
  input S_AXI_arvalid;
  input [39:0]S_AXI_awaddr;
  input [1:0]S_AXI_awburst;
  input [3:0]S_AXI_awcache;
  input [0:0]S_AXI_awid;
  input [7:0]S_AXI_awlen;
  input [0:0]S_AXI_awlock;
  input [2:0]S_AXI_awprot;
  input [3:0]S_AXI_awqos;
  output S_AXI_awready;
  input [3:0]S_AXI_awregion;
  input [2:0]S_AXI_awsize;
  input [0:0]S_AXI_awuser;
  input S_AXI_awvalid;
  output [0:0]S_AXI_bid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output S_AXI_bvalid;
  output [127:0]S_AXI_rdata;
  output [0:0]S_AXI_rid;
  output S_AXI_rlast;
  input S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output S_AXI_rvalid;
  input [127:0]S_AXI_wdata;
  input S_AXI_wlast;
  output S_AXI_wready;
  input [15:0]S_AXI_wstrb;
  input S_AXI_wvalid;

  wire M_ACLK_1;
  wire M_ARESETN_1;
  wire S_ACLK_1;
  wire S_ARESETN_1;
  wire [48:0]auto_cc_to_m00_regslice_ARADDR;
  wire [1:0]auto_cc_to_m00_regslice_ARBURST;
  wire [3:0]auto_cc_to_m00_regslice_ARCACHE;
  wire [0:0]auto_cc_to_m00_regslice_ARID;
  wire [7:0]auto_cc_to_m00_regslice_ARLEN;
  wire [0:0]auto_cc_to_m00_regslice_ARLOCK;
  wire [2:0]auto_cc_to_m00_regslice_ARPROT;
  wire [3:0]auto_cc_to_m00_regslice_ARQOS;
  wire auto_cc_to_m00_regslice_ARREADY;
  wire [3:0]auto_cc_to_m00_regslice_ARREGION;
  wire [2:0]auto_cc_to_m00_regslice_ARSIZE;
  wire [0:0]auto_cc_to_m00_regslice_ARUSER;
  wire auto_cc_to_m00_regslice_ARVALID;
  wire [48:0]auto_cc_to_m00_regslice_AWADDR;
  wire [1:0]auto_cc_to_m00_regslice_AWBURST;
  wire [3:0]auto_cc_to_m00_regslice_AWCACHE;
  wire [0:0]auto_cc_to_m00_regslice_AWID;
  wire [7:0]auto_cc_to_m00_regslice_AWLEN;
  wire [0:0]auto_cc_to_m00_regslice_AWLOCK;
  wire [2:0]auto_cc_to_m00_regslice_AWPROT;
  wire [3:0]auto_cc_to_m00_regslice_AWQOS;
  wire auto_cc_to_m00_regslice_AWREADY;
  wire [3:0]auto_cc_to_m00_regslice_AWREGION;
  wire [2:0]auto_cc_to_m00_regslice_AWSIZE;
  wire [0:0]auto_cc_to_m00_regslice_AWUSER;
  wire auto_cc_to_m00_regslice_AWVALID;
  wire [0:0]auto_cc_to_m00_regslice_BID;
  wire auto_cc_to_m00_regslice_BREADY;
  wire [1:0]auto_cc_to_m00_regslice_BRESP;
  wire auto_cc_to_m00_regslice_BVALID;
  wire [127:0]auto_cc_to_m00_regslice_RDATA;
  wire [0:0]auto_cc_to_m00_regslice_RID;
  wire auto_cc_to_m00_regslice_RLAST;
  wire auto_cc_to_m00_regslice_RREADY;
  wire [1:0]auto_cc_to_m00_regslice_RRESP;
  wire auto_cc_to_m00_regslice_RVALID;
  wire [127:0]auto_cc_to_m00_regslice_WDATA;
  wire auto_cc_to_m00_regslice_WLAST;
  wire auto_cc_to_m00_regslice_WREADY;
  wire [15:0]auto_cc_to_m00_regslice_WSTRB;
  wire auto_cc_to_m00_regslice_WVALID;
  wire [39:0]m00_couplers_to_m00_data_fifo_ARADDR;
  wire [1:0]m00_couplers_to_m00_data_fifo_ARBURST;
  wire [3:0]m00_couplers_to_m00_data_fifo_ARCACHE;
  wire [0:0]m00_couplers_to_m00_data_fifo_ARID;
  wire [7:0]m00_couplers_to_m00_data_fifo_ARLEN;
  wire [0:0]m00_couplers_to_m00_data_fifo_ARLOCK;
  wire [2:0]m00_couplers_to_m00_data_fifo_ARPROT;
  wire [3:0]m00_couplers_to_m00_data_fifo_ARQOS;
  wire m00_couplers_to_m00_data_fifo_ARREADY;
  wire [3:0]m00_couplers_to_m00_data_fifo_ARREGION;
  wire [2:0]m00_couplers_to_m00_data_fifo_ARSIZE;
  wire [0:0]m00_couplers_to_m00_data_fifo_ARUSER;
  wire m00_couplers_to_m00_data_fifo_ARVALID;
  wire [39:0]m00_couplers_to_m00_data_fifo_AWADDR;
  wire [1:0]m00_couplers_to_m00_data_fifo_AWBURST;
  wire [3:0]m00_couplers_to_m00_data_fifo_AWCACHE;
  wire [0:0]m00_couplers_to_m00_data_fifo_AWID;
  wire [7:0]m00_couplers_to_m00_data_fifo_AWLEN;
  wire [0:0]m00_couplers_to_m00_data_fifo_AWLOCK;
  wire [2:0]m00_couplers_to_m00_data_fifo_AWPROT;
  wire [3:0]m00_couplers_to_m00_data_fifo_AWQOS;
  wire m00_couplers_to_m00_data_fifo_AWREADY;
  wire [3:0]m00_couplers_to_m00_data_fifo_AWREGION;
  wire [2:0]m00_couplers_to_m00_data_fifo_AWSIZE;
  wire [0:0]m00_couplers_to_m00_data_fifo_AWUSER;
  wire m00_couplers_to_m00_data_fifo_AWVALID;
  wire [0:0]m00_couplers_to_m00_data_fifo_BID;
  wire m00_couplers_to_m00_data_fifo_BREADY;
  wire [1:0]m00_couplers_to_m00_data_fifo_BRESP;
  wire m00_couplers_to_m00_data_fifo_BVALID;
  wire [127:0]m00_couplers_to_m00_data_fifo_RDATA;
  wire [0:0]m00_couplers_to_m00_data_fifo_RID;
  wire m00_couplers_to_m00_data_fifo_RLAST;
  wire m00_couplers_to_m00_data_fifo_RREADY;
  wire [1:0]m00_couplers_to_m00_data_fifo_RRESP;
  wire m00_couplers_to_m00_data_fifo_RVALID;
  wire [127:0]m00_couplers_to_m00_data_fifo_WDATA;
  wire m00_couplers_to_m00_data_fifo_WLAST;
  wire m00_couplers_to_m00_data_fifo_WREADY;
  wire [15:0]m00_couplers_to_m00_data_fifo_WSTRB;
  wire m00_couplers_to_m00_data_fifo_WVALID;
  wire [48:0]m00_data_fifo_to_auto_cc_ARADDR;
  wire [1:0]m00_data_fifo_to_auto_cc_ARBURST;
  wire [3:0]m00_data_fifo_to_auto_cc_ARCACHE;
  wire [0:0]m00_data_fifo_to_auto_cc_ARID;
  wire [7:0]m00_data_fifo_to_auto_cc_ARLEN;
  wire [0:0]m00_data_fifo_to_auto_cc_ARLOCK;
  wire [2:0]m00_data_fifo_to_auto_cc_ARPROT;
  wire [3:0]m00_data_fifo_to_auto_cc_ARQOS;
  wire m00_data_fifo_to_auto_cc_ARREADY;
  wire [3:0]m00_data_fifo_to_auto_cc_ARREGION;
  wire [2:0]m00_data_fifo_to_auto_cc_ARSIZE;
  wire [0:0]m00_data_fifo_to_auto_cc_ARUSER;
  wire m00_data_fifo_to_auto_cc_ARVALID;
  wire [48:0]m00_data_fifo_to_auto_cc_AWADDR;
  wire [1:0]m00_data_fifo_to_auto_cc_AWBURST;
  wire [3:0]m00_data_fifo_to_auto_cc_AWCACHE;
  wire [0:0]m00_data_fifo_to_auto_cc_AWID;
  wire [7:0]m00_data_fifo_to_auto_cc_AWLEN;
  wire [0:0]m00_data_fifo_to_auto_cc_AWLOCK;
  wire [2:0]m00_data_fifo_to_auto_cc_AWPROT;
  wire [3:0]m00_data_fifo_to_auto_cc_AWQOS;
  wire m00_data_fifo_to_auto_cc_AWREADY;
  wire [3:0]m00_data_fifo_to_auto_cc_AWREGION;
  wire [2:0]m00_data_fifo_to_auto_cc_AWSIZE;
  wire [0:0]m00_data_fifo_to_auto_cc_AWUSER;
  wire m00_data_fifo_to_auto_cc_AWVALID;
  wire [0:0]m00_data_fifo_to_auto_cc_BID;
  wire m00_data_fifo_to_auto_cc_BREADY;
  wire [1:0]m00_data_fifo_to_auto_cc_BRESP;
  wire m00_data_fifo_to_auto_cc_BVALID;
  wire [127:0]m00_data_fifo_to_auto_cc_RDATA;
  wire [0:0]m00_data_fifo_to_auto_cc_RID;
  wire m00_data_fifo_to_auto_cc_RLAST;
  wire m00_data_fifo_to_auto_cc_RREADY;
  wire [1:0]m00_data_fifo_to_auto_cc_RRESP;
  wire m00_data_fifo_to_auto_cc_RVALID;
  wire [127:0]m00_data_fifo_to_auto_cc_WDATA;
  wire m00_data_fifo_to_auto_cc_WLAST;
  wire m00_data_fifo_to_auto_cc_WREADY;
  wire [15:0]m00_data_fifo_to_auto_cc_WSTRB;
  wire m00_data_fifo_to_auto_cc_WVALID;
  wire [48:0]m00_regslice_to_m00_couplers_ARADDR;
  wire [1:0]m00_regslice_to_m00_couplers_ARBURST;
  wire [3:0]m00_regslice_to_m00_couplers_ARCACHE;
  wire [0:0]m00_regslice_to_m00_couplers_ARID;
  wire [7:0]m00_regslice_to_m00_couplers_ARLEN;
  wire [0:0]m00_regslice_to_m00_couplers_ARLOCK;
  wire [2:0]m00_regslice_to_m00_couplers_ARPROT;
  wire [3:0]m00_regslice_to_m00_couplers_ARQOS;
  wire m00_regslice_to_m00_couplers_ARREADY;
  wire [2:0]m00_regslice_to_m00_couplers_ARSIZE;
  wire [0:0]m00_regslice_to_m00_couplers_ARUSER;
  wire m00_regslice_to_m00_couplers_ARVALID;
  wire [48:0]m00_regslice_to_m00_couplers_AWADDR;
  wire [1:0]m00_regslice_to_m00_couplers_AWBURST;
  wire [3:0]m00_regslice_to_m00_couplers_AWCACHE;
  wire [0:0]m00_regslice_to_m00_couplers_AWID;
  wire [7:0]m00_regslice_to_m00_couplers_AWLEN;
  wire [0:0]m00_regslice_to_m00_couplers_AWLOCK;
  wire [2:0]m00_regslice_to_m00_couplers_AWPROT;
  wire [3:0]m00_regslice_to_m00_couplers_AWQOS;
  wire m00_regslice_to_m00_couplers_AWREADY;
  wire [2:0]m00_regslice_to_m00_couplers_AWSIZE;
  wire [0:0]m00_regslice_to_m00_couplers_AWUSER;
  wire m00_regslice_to_m00_couplers_AWVALID;
  wire [5:0]m00_regslice_to_m00_couplers_BID;
  wire m00_regslice_to_m00_couplers_BREADY;
  wire [1:0]m00_regslice_to_m00_couplers_BRESP;
  wire m00_regslice_to_m00_couplers_BVALID;
  wire [127:0]m00_regslice_to_m00_couplers_RDATA;
  wire [5:0]m00_regslice_to_m00_couplers_RID;
  wire m00_regslice_to_m00_couplers_RLAST;
  wire m00_regslice_to_m00_couplers_RREADY;
  wire [1:0]m00_regslice_to_m00_couplers_RRESP;
  wire m00_regslice_to_m00_couplers_RVALID;
  wire [127:0]m00_regslice_to_m00_couplers_WDATA;
  wire m00_regslice_to_m00_couplers_WLAST;
  wire m00_regslice_to_m00_couplers_WREADY;
  wire [15:0]m00_regslice_to_m00_couplers_WSTRB;
  wire m00_regslice_to_m00_couplers_WVALID;

  assign M_ACLK_1 = M_ACLK;
  assign M_ARESETN_1 = M_ARESETN;
  assign M_AXI_araddr[48:0] = m00_regslice_to_m00_couplers_ARADDR;
  assign M_AXI_arburst[1:0] = m00_regslice_to_m00_couplers_ARBURST;
  assign M_AXI_arcache[3:0] = m00_regslice_to_m00_couplers_ARCACHE;
  assign M_AXI_arid[0] = m00_regslice_to_m00_couplers_ARID;
  assign M_AXI_arlen[7:0] = m00_regslice_to_m00_couplers_ARLEN;
  assign M_AXI_arlock[0] = m00_regslice_to_m00_couplers_ARLOCK;
  assign M_AXI_arprot[2:0] = m00_regslice_to_m00_couplers_ARPROT;
  assign M_AXI_arqos[3:0] = m00_regslice_to_m00_couplers_ARQOS;
  assign M_AXI_arsize[2:0] = m00_regslice_to_m00_couplers_ARSIZE;
  assign M_AXI_aruser[0] = m00_regslice_to_m00_couplers_ARUSER;
  assign M_AXI_arvalid = m00_regslice_to_m00_couplers_ARVALID;
  assign M_AXI_awaddr[48:0] = m00_regslice_to_m00_couplers_AWADDR;
  assign M_AXI_awburst[1:0] = m00_regslice_to_m00_couplers_AWBURST;
  assign M_AXI_awcache[3:0] = m00_regslice_to_m00_couplers_AWCACHE;
  assign M_AXI_awid[0] = m00_regslice_to_m00_couplers_AWID;
  assign M_AXI_awlen[7:0] = m00_regslice_to_m00_couplers_AWLEN;
  assign M_AXI_awlock[0] = m00_regslice_to_m00_couplers_AWLOCK;
  assign M_AXI_awprot[2:0] = m00_regslice_to_m00_couplers_AWPROT;
  assign M_AXI_awqos[3:0] = m00_regslice_to_m00_couplers_AWQOS;
  assign M_AXI_awsize[2:0] = m00_regslice_to_m00_couplers_AWSIZE;
  assign M_AXI_awuser[0] = m00_regslice_to_m00_couplers_AWUSER;
  assign M_AXI_awvalid = m00_regslice_to_m00_couplers_AWVALID;
  assign M_AXI_bready = m00_regslice_to_m00_couplers_BREADY;
  assign M_AXI_rready = m00_regslice_to_m00_couplers_RREADY;
  assign M_AXI_wdata[127:0] = m00_regslice_to_m00_couplers_WDATA;
  assign M_AXI_wlast = m00_regslice_to_m00_couplers_WLAST;
  assign M_AXI_wstrb[15:0] = m00_regslice_to_m00_couplers_WSTRB;
  assign M_AXI_wvalid = m00_regslice_to_m00_couplers_WVALID;
  assign S_ACLK_1 = S_ACLK;
  assign S_ARESETN_1 = S_ARESETN;
  assign S_AXI_arready = m00_couplers_to_m00_data_fifo_ARREADY;
  assign S_AXI_awready = m00_couplers_to_m00_data_fifo_AWREADY;
  assign S_AXI_bid[0] = m00_couplers_to_m00_data_fifo_BID;
  assign S_AXI_bresp[1:0] = m00_couplers_to_m00_data_fifo_BRESP;
  assign S_AXI_bvalid = m00_couplers_to_m00_data_fifo_BVALID;
  assign S_AXI_rdata[127:0] = m00_couplers_to_m00_data_fifo_RDATA;
  assign S_AXI_rid[0] = m00_couplers_to_m00_data_fifo_RID;
  assign S_AXI_rlast = m00_couplers_to_m00_data_fifo_RLAST;
  assign S_AXI_rresp[1:0] = m00_couplers_to_m00_data_fifo_RRESP;
  assign S_AXI_rvalid = m00_couplers_to_m00_data_fifo_RVALID;
  assign S_AXI_wready = m00_couplers_to_m00_data_fifo_WREADY;
  assign m00_couplers_to_m00_data_fifo_ARADDR = S_AXI_araddr[39:0];
  assign m00_couplers_to_m00_data_fifo_ARBURST = S_AXI_arburst[1:0];
  assign m00_couplers_to_m00_data_fifo_ARCACHE = S_AXI_arcache[3:0];
  assign m00_couplers_to_m00_data_fifo_ARID = S_AXI_arid[0];
  assign m00_couplers_to_m00_data_fifo_ARLEN = S_AXI_arlen[7:0];
  assign m00_couplers_to_m00_data_fifo_ARLOCK = S_AXI_arlock[0];
  assign m00_couplers_to_m00_data_fifo_ARPROT = S_AXI_arprot[2:0];
  assign m00_couplers_to_m00_data_fifo_ARQOS = S_AXI_arqos[3:0];
  assign m00_couplers_to_m00_data_fifo_ARREGION = S_AXI_arregion[3:0];
  assign m00_couplers_to_m00_data_fifo_ARSIZE = S_AXI_arsize[2:0];
  assign m00_couplers_to_m00_data_fifo_ARUSER = S_AXI_aruser[0];
  assign m00_couplers_to_m00_data_fifo_ARVALID = S_AXI_arvalid;
  assign m00_couplers_to_m00_data_fifo_AWADDR = S_AXI_awaddr[39:0];
  assign m00_couplers_to_m00_data_fifo_AWBURST = S_AXI_awburst[1:0];
  assign m00_couplers_to_m00_data_fifo_AWCACHE = S_AXI_awcache[3:0];
  assign m00_couplers_to_m00_data_fifo_AWID = S_AXI_awid[0];
  assign m00_couplers_to_m00_data_fifo_AWLEN = S_AXI_awlen[7:0];
  assign m00_couplers_to_m00_data_fifo_AWLOCK = S_AXI_awlock[0];
  assign m00_couplers_to_m00_data_fifo_AWPROT = S_AXI_awprot[2:0];
  assign m00_couplers_to_m00_data_fifo_AWQOS = S_AXI_awqos[3:0];
  assign m00_couplers_to_m00_data_fifo_AWREGION = S_AXI_awregion[3:0];
  assign m00_couplers_to_m00_data_fifo_AWSIZE = S_AXI_awsize[2:0];
  assign m00_couplers_to_m00_data_fifo_AWUSER = S_AXI_awuser[0];
  assign m00_couplers_to_m00_data_fifo_AWVALID = S_AXI_awvalid;
  assign m00_couplers_to_m00_data_fifo_BREADY = S_AXI_bready;
  assign m00_couplers_to_m00_data_fifo_RREADY = S_AXI_rready;
  assign m00_couplers_to_m00_data_fifo_WDATA = S_AXI_wdata[127:0];
  assign m00_couplers_to_m00_data_fifo_WLAST = S_AXI_wlast;
  assign m00_couplers_to_m00_data_fifo_WSTRB = S_AXI_wstrb[15:0];
  assign m00_couplers_to_m00_data_fifo_WVALID = S_AXI_wvalid;
  assign m00_regslice_to_m00_couplers_ARREADY = M_AXI_arready;
  assign m00_regslice_to_m00_couplers_AWREADY = M_AXI_awready;
  assign m00_regslice_to_m00_couplers_BID = M_AXI_bid[5:0];
  assign m00_regslice_to_m00_couplers_BRESP = M_AXI_bresp[1:0];
  assign m00_regslice_to_m00_couplers_BVALID = M_AXI_bvalid;
  assign m00_regslice_to_m00_couplers_RDATA = M_AXI_rdata[127:0];
  assign m00_regslice_to_m00_couplers_RID = M_AXI_rid[5:0];
  assign m00_regslice_to_m00_couplers_RLAST = M_AXI_rlast;
  assign m00_regslice_to_m00_couplers_RRESP = M_AXI_rresp[1:0];
  assign m00_regslice_to_m00_couplers_RVALID = M_AXI_rvalid;
  assign m00_regslice_to_m00_couplers_WREADY = M_AXI_wready;
  kv260_hardware_platform_auto_cc_4 auto_cc
       (.m_axi_aclk(M_ACLK_1),
        .m_axi_araddr(auto_cc_to_m00_regslice_ARADDR),
        .m_axi_arburst(auto_cc_to_m00_regslice_ARBURST),
        .m_axi_arcache(auto_cc_to_m00_regslice_ARCACHE),
        .m_axi_aresetn(M_ARESETN_1),
        .m_axi_arid(auto_cc_to_m00_regslice_ARID),
        .m_axi_arlen(auto_cc_to_m00_regslice_ARLEN),
        .m_axi_arlock(auto_cc_to_m00_regslice_ARLOCK),
        .m_axi_arprot(auto_cc_to_m00_regslice_ARPROT),
        .m_axi_arqos(auto_cc_to_m00_regslice_ARQOS),
        .m_axi_arready(auto_cc_to_m00_regslice_ARREADY),
        .m_axi_arregion(auto_cc_to_m00_regslice_ARREGION),
        .m_axi_arsize(auto_cc_to_m00_regslice_ARSIZE),
        .m_axi_aruser(auto_cc_to_m00_regslice_ARUSER),
        .m_axi_arvalid(auto_cc_to_m00_regslice_ARVALID),
        .m_axi_awaddr(auto_cc_to_m00_regslice_AWADDR),
        .m_axi_awburst(auto_cc_to_m00_regslice_AWBURST),
        .m_axi_awcache(auto_cc_to_m00_regslice_AWCACHE),
        .m_axi_awid(auto_cc_to_m00_regslice_AWID),
        .m_axi_awlen(auto_cc_to_m00_regslice_AWLEN),
        .m_axi_awlock(auto_cc_to_m00_regslice_AWLOCK),
        .m_axi_awprot(auto_cc_to_m00_regslice_AWPROT),
        .m_axi_awqos(auto_cc_to_m00_regslice_AWQOS),
        .m_axi_awready(auto_cc_to_m00_regslice_AWREADY),
        .m_axi_awregion(auto_cc_to_m00_regslice_AWREGION),
        .m_axi_awsize(auto_cc_to_m00_regslice_AWSIZE),
        .m_axi_awuser(auto_cc_to_m00_regslice_AWUSER),
        .m_axi_awvalid(auto_cc_to_m00_regslice_AWVALID),
        .m_axi_bid(auto_cc_to_m00_regslice_BID),
        .m_axi_bready(auto_cc_to_m00_regslice_BREADY),
        .m_axi_bresp(auto_cc_to_m00_regslice_BRESP),
        .m_axi_bvalid(auto_cc_to_m00_regslice_BVALID),
        .m_axi_rdata(auto_cc_to_m00_regslice_RDATA),
        .m_axi_rid(auto_cc_to_m00_regslice_RID),
        .m_axi_rlast(auto_cc_to_m00_regslice_RLAST),
        .m_axi_rready(auto_cc_to_m00_regslice_RREADY),
        .m_axi_rresp(auto_cc_to_m00_regslice_RRESP),
        .m_axi_rvalid(auto_cc_to_m00_regslice_RVALID),
        .m_axi_wdata(auto_cc_to_m00_regslice_WDATA),
        .m_axi_wlast(auto_cc_to_m00_regslice_WLAST),
        .m_axi_wready(auto_cc_to_m00_regslice_WREADY),
        .m_axi_wstrb(auto_cc_to_m00_regslice_WSTRB),
        .m_axi_wvalid(auto_cc_to_m00_regslice_WVALID),
        .s_axi_aclk(S_ACLK_1),
        .s_axi_araddr(m00_data_fifo_to_auto_cc_ARADDR),
        .s_axi_arburst(m00_data_fifo_to_auto_cc_ARBURST),
        .s_axi_arcache(m00_data_fifo_to_auto_cc_ARCACHE),
        .s_axi_aresetn(S_ARESETN_1),
        .s_axi_arid(m00_data_fifo_to_auto_cc_ARID),
        .s_axi_arlen(m00_data_fifo_to_auto_cc_ARLEN),
        .s_axi_arlock(m00_data_fifo_to_auto_cc_ARLOCK),
        .s_axi_arprot(m00_data_fifo_to_auto_cc_ARPROT),
        .s_axi_arqos(m00_data_fifo_to_auto_cc_ARQOS),
        .s_axi_arready(m00_data_fifo_to_auto_cc_ARREADY),
        .s_axi_arregion(m00_data_fifo_to_auto_cc_ARREGION),
        .s_axi_arsize(m00_data_fifo_to_auto_cc_ARSIZE),
        .s_axi_aruser(m00_data_fifo_to_auto_cc_ARUSER),
        .s_axi_arvalid(m00_data_fifo_to_auto_cc_ARVALID),
        .s_axi_awaddr(m00_data_fifo_to_auto_cc_AWADDR),
        .s_axi_awburst(m00_data_fifo_to_auto_cc_AWBURST),
        .s_axi_awcache(m00_data_fifo_to_auto_cc_AWCACHE),
        .s_axi_awid(m00_data_fifo_to_auto_cc_AWID),
        .s_axi_awlen(m00_data_fifo_to_auto_cc_AWLEN),
        .s_axi_awlock(m00_data_fifo_to_auto_cc_AWLOCK),
        .s_axi_awprot(m00_data_fifo_to_auto_cc_AWPROT),
        .s_axi_awqos(m00_data_fifo_to_auto_cc_AWQOS),
        .s_axi_awready(m00_data_fifo_to_auto_cc_AWREADY),
        .s_axi_awregion(m00_data_fifo_to_auto_cc_AWREGION),
        .s_axi_awsize(m00_data_fifo_to_auto_cc_AWSIZE),
        .s_axi_awuser(m00_data_fifo_to_auto_cc_AWUSER),
        .s_axi_awvalid(m00_data_fifo_to_auto_cc_AWVALID),
        .s_axi_bid(m00_data_fifo_to_auto_cc_BID),
        .s_axi_bready(m00_data_fifo_to_auto_cc_BREADY),
        .s_axi_bresp(m00_data_fifo_to_auto_cc_BRESP),
        .s_axi_bvalid(m00_data_fifo_to_auto_cc_BVALID),
        .s_axi_rdata(m00_data_fifo_to_auto_cc_RDATA),
        .s_axi_rid(m00_data_fifo_to_auto_cc_RID),
        .s_axi_rlast(m00_data_fifo_to_auto_cc_RLAST),
        .s_axi_rready(m00_data_fifo_to_auto_cc_RREADY),
        .s_axi_rresp(m00_data_fifo_to_auto_cc_RRESP),
        .s_axi_rvalid(m00_data_fifo_to_auto_cc_RVALID),
        .s_axi_wdata(m00_data_fifo_to_auto_cc_WDATA),
        .s_axi_wlast(m00_data_fifo_to_auto_cc_WLAST),
        .s_axi_wready(m00_data_fifo_to_auto_cc_WREADY),
        .s_axi_wstrb(m00_data_fifo_to_auto_cc_WSTRB),
        .s_axi_wvalid(m00_data_fifo_to_auto_cc_WVALID));
  kv260_hardware_platform_m00_data_fifo_0 m00_data_fifo
       (.aclk(S_ACLK_1),
        .aresetn(S_ARESETN_1),
        .m_axi_araddr(m00_data_fifo_to_auto_cc_ARADDR),
        .m_axi_arburst(m00_data_fifo_to_auto_cc_ARBURST),
        .m_axi_arcache(m00_data_fifo_to_auto_cc_ARCACHE),
        .m_axi_arid(m00_data_fifo_to_auto_cc_ARID),
        .m_axi_arlen(m00_data_fifo_to_auto_cc_ARLEN),
        .m_axi_arlock(m00_data_fifo_to_auto_cc_ARLOCK),
        .m_axi_arprot(m00_data_fifo_to_auto_cc_ARPROT),
        .m_axi_arqos(m00_data_fifo_to_auto_cc_ARQOS),
        .m_axi_arready(m00_data_fifo_to_auto_cc_ARREADY),
        .m_axi_arregion(m00_data_fifo_to_auto_cc_ARREGION),
        .m_axi_arsize(m00_data_fifo_to_auto_cc_ARSIZE),
        .m_axi_aruser(m00_data_fifo_to_auto_cc_ARUSER),
        .m_axi_arvalid(m00_data_fifo_to_auto_cc_ARVALID),
        .m_axi_awaddr(m00_data_fifo_to_auto_cc_AWADDR),
        .m_axi_awburst(m00_data_fifo_to_auto_cc_AWBURST),
        .m_axi_awcache(m00_data_fifo_to_auto_cc_AWCACHE),
        .m_axi_awid(m00_data_fifo_to_auto_cc_AWID),
        .m_axi_awlen(m00_data_fifo_to_auto_cc_AWLEN),
        .m_axi_awlock(m00_data_fifo_to_auto_cc_AWLOCK),
        .m_axi_awprot(m00_data_fifo_to_auto_cc_AWPROT),
        .m_axi_awqos(m00_data_fifo_to_auto_cc_AWQOS),
        .m_axi_awready(m00_data_fifo_to_auto_cc_AWREADY),
        .m_axi_awregion(m00_data_fifo_to_auto_cc_AWREGION),
        .m_axi_awsize(m00_data_fifo_to_auto_cc_AWSIZE),
        .m_axi_awuser(m00_data_fifo_to_auto_cc_AWUSER),
        .m_axi_awvalid(m00_data_fifo_to_auto_cc_AWVALID),
        .m_axi_bid(m00_data_fifo_to_auto_cc_BID),
        .m_axi_bready(m00_data_fifo_to_auto_cc_BREADY),
        .m_axi_bresp(m00_data_fifo_to_auto_cc_BRESP),
        .m_axi_bvalid(m00_data_fifo_to_auto_cc_BVALID),
        .m_axi_rdata(m00_data_fifo_to_auto_cc_RDATA),
        .m_axi_rid(m00_data_fifo_to_auto_cc_RID),
        .m_axi_rlast(m00_data_fifo_to_auto_cc_RLAST),
        .m_axi_rready(m00_data_fifo_to_auto_cc_RREADY),
        .m_axi_rresp(m00_data_fifo_to_auto_cc_RRESP),
        .m_axi_rvalid(m00_data_fifo_to_auto_cc_RVALID),
        .m_axi_wdata(m00_data_fifo_to_auto_cc_WDATA),
        .m_axi_wlast(m00_data_fifo_to_auto_cc_WLAST),
        .m_axi_wready(m00_data_fifo_to_auto_cc_WREADY),
        .m_axi_wstrb(m00_data_fifo_to_auto_cc_WSTRB),
        .m_axi_wvalid(m00_data_fifo_to_auto_cc_WVALID),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,m00_couplers_to_m00_data_fifo_ARADDR}),
        .s_axi_arburst(m00_couplers_to_m00_data_fifo_ARBURST),
        .s_axi_arcache(m00_couplers_to_m00_data_fifo_ARCACHE),
        .s_axi_arid(m00_couplers_to_m00_data_fifo_ARID),
        .s_axi_arlen(m00_couplers_to_m00_data_fifo_ARLEN),
        .s_axi_arlock(m00_couplers_to_m00_data_fifo_ARLOCK),
        .s_axi_arprot(m00_couplers_to_m00_data_fifo_ARPROT),
        .s_axi_arqos(m00_couplers_to_m00_data_fifo_ARQOS),
        .s_axi_arready(m00_couplers_to_m00_data_fifo_ARREADY),
        .s_axi_arregion(m00_couplers_to_m00_data_fifo_ARREGION),
        .s_axi_arsize(m00_couplers_to_m00_data_fifo_ARSIZE),
        .s_axi_aruser(m00_couplers_to_m00_data_fifo_ARUSER),
        .s_axi_arvalid(m00_couplers_to_m00_data_fifo_ARVALID),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,m00_couplers_to_m00_data_fifo_AWADDR}),
        .s_axi_awburst(m00_couplers_to_m00_data_fifo_AWBURST),
        .s_axi_awcache(m00_couplers_to_m00_data_fifo_AWCACHE),
        .s_axi_awid(m00_couplers_to_m00_data_fifo_AWID),
        .s_axi_awlen(m00_couplers_to_m00_data_fifo_AWLEN),
        .s_axi_awlock(m00_couplers_to_m00_data_fifo_AWLOCK),
        .s_axi_awprot(m00_couplers_to_m00_data_fifo_AWPROT),
        .s_axi_awqos(m00_couplers_to_m00_data_fifo_AWQOS),
        .s_axi_awready(m00_couplers_to_m00_data_fifo_AWREADY),
        .s_axi_awregion(m00_couplers_to_m00_data_fifo_AWREGION),
        .s_axi_awsize(m00_couplers_to_m00_data_fifo_AWSIZE),
        .s_axi_awuser(m00_couplers_to_m00_data_fifo_AWUSER),
        .s_axi_awvalid(m00_couplers_to_m00_data_fifo_AWVALID),
        .s_axi_bid(m00_couplers_to_m00_data_fifo_BID),
        .s_axi_bready(m00_couplers_to_m00_data_fifo_BREADY),
        .s_axi_bresp(m00_couplers_to_m00_data_fifo_BRESP),
        .s_axi_bvalid(m00_couplers_to_m00_data_fifo_BVALID),
        .s_axi_rdata(m00_couplers_to_m00_data_fifo_RDATA),
        .s_axi_rid(m00_couplers_to_m00_data_fifo_RID),
        .s_axi_rlast(m00_couplers_to_m00_data_fifo_RLAST),
        .s_axi_rready(m00_couplers_to_m00_data_fifo_RREADY),
        .s_axi_rresp(m00_couplers_to_m00_data_fifo_RRESP),
        .s_axi_rvalid(m00_couplers_to_m00_data_fifo_RVALID),
        .s_axi_wdata(m00_couplers_to_m00_data_fifo_WDATA),
        .s_axi_wlast(m00_couplers_to_m00_data_fifo_WLAST),
        .s_axi_wready(m00_couplers_to_m00_data_fifo_WREADY),
        .s_axi_wstrb(m00_couplers_to_m00_data_fifo_WSTRB),
        .s_axi_wvalid(m00_couplers_to_m00_data_fifo_WVALID));
  kv260_hardware_platform_m00_regslice_0 m00_regslice
       (.aclk(M_ACLK_1),
        .aresetn(M_ARESETN_1),
        .m_axi_araddr(m00_regslice_to_m00_couplers_ARADDR),
        .m_axi_arburst(m00_regslice_to_m00_couplers_ARBURST),
        .m_axi_arcache(m00_regslice_to_m00_couplers_ARCACHE),
        .m_axi_arid(m00_regslice_to_m00_couplers_ARID),
        .m_axi_arlen(m00_regslice_to_m00_couplers_ARLEN),
        .m_axi_arlock(m00_regslice_to_m00_couplers_ARLOCK),
        .m_axi_arprot(m00_regslice_to_m00_couplers_ARPROT),
        .m_axi_arqos(m00_regslice_to_m00_couplers_ARQOS),
        .m_axi_arready(m00_regslice_to_m00_couplers_ARREADY),
        .m_axi_arsize(m00_regslice_to_m00_couplers_ARSIZE),
        .m_axi_aruser(m00_regslice_to_m00_couplers_ARUSER),
        .m_axi_arvalid(m00_regslice_to_m00_couplers_ARVALID),
        .m_axi_awaddr(m00_regslice_to_m00_couplers_AWADDR),
        .m_axi_awburst(m00_regslice_to_m00_couplers_AWBURST),
        .m_axi_awcache(m00_regslice_to_m00_couplers_AWCACHE),
        .m_axi_awid(m00_regslice_to_m00_couplers_AWID),
        .m_axi_awlen(m00_regslice_to_m00_couplers_AWLEN),
        .m_axi_awlock(m00_regslice_to_m00_couplers_AWLOCK),
        .m_axi_awprot(m00_regslice_to_m00_couplers_AWPROT),
        .m_axi_awqos(m00_regslice_to_m00_couplers_AWQOS),
        .m_axi_awready(m00_regslice_to_m00_couplers_AWREADY),
        .m_axi_awsize(m00_regslice_to_m00_couplers_AWSIZE),
        .m_axi_awuser(m00_regslice_to_m00_couplers_AWUSER),
        .m_axi_awvalid(m00_regslice_to_m00_couplers_AWVALID),
        .m_axi_bid(m00_regslice_to_m00_couplers_BID[0]),
        .m_axi_bready(m00_regslice_to_m00_couplers_BREADY),
        .m_axi_bresp(m00_regslice_to_m00_couplers_BRESP),
        .m_axi_bvalid(m00_regslice_to_m00_couplers_BVALID),
        .m_axi_rdata(m00_regslice_to_m00_couplers_RDATA),
        .m_axi_rid(m00_regslice_to_m00_couplers_RID[0]),
        .m_axi_rlast(m00_regslice_to_m00_couplers_RLAST),
        .m_axi_rready(m00_regslice_to_m00_couplers_RREADY),
        .m_axi_rresp(m00_regslice_to_m00_couplers_RRESP),
        .m_axi_rvalid(m00_regslice_to_m00_couplers_RVALID),
        .m_axi_wdata(m00_regslice_to_m00_couplers_WDATA),
        .m_axi_wlast(m00_regslice_to_m00_couplers_WLAST),
        .m_axi_wready(m00_regslice_to_m00_couplers_WREADY),
        .m_axi_wstrb(m00_regslice_to_m00_couplers_WSTRB),
        .m_axi_wvalid(m00_regslice_to_m00_couplers_WVALID),
        .s_axi_araddr(auto_cc_to_m00_regslice_ARADDR),
        .s_axi_arburst(auto_cc_to_m00_regslice_ARBURST),
        .s_axi_arcache(auto_cc_to_m00_regslice_ARCACHE),
        .s_axi_arid(auto_cc_to_m00_regslice_ARID),
        .s_axi_arlen(auto_cc_to_m00_regslice_ARLEN),
        .s_axi_arlock(auto_cc_to_m00_regslice_ARLOCK),
        .s_axi_arprot(auto_cc_to_m00_regslice_ARPROT),
        .s_axi_arqos(auto_cc_to_m00_regslice_ARQOS),
        .s_axi_arready(auto_cc_to_m00_regslice_ARREADY),
        .s_axi_arregion(auto_cc_to_m00_regslice_ARREGION),
        .s_axi_arsize(auto_cc_to_m00_regslice_ARSIZE),
        .s_axi_aruser(auto_cc_to_m00_regslice_ARUSER),
        .s_axi_arvalid(auto_cc_to_m00_regslice_ARVALID),
        .s_axi_awaddr(auto_cc_to_m00_regslice_AWADDR),
        .s_axi_awburst(auto_cc_to_m00_regslice_AWBURST),
        .s_axi_awcache(auto_cc_to_m00_regslice_AWCACHE),
        .s_axi_awid(auto_cc_to_m00_regslice_AWID),
        .s_axi_awlen(auto_cc_to_m00_regslice_AWLEN),
        .s_axi_awlock(auto_cc_to_m00_regslice_AWLOCK),
        .s_axi_awprot(auto_cc_to_m00_regslice_AWPROT),
        .s_axi_awqos(auto_cc_to_m00_regslice_AWQOS),
        .s_axi_awready(auto_cc_to_m00_regslice_AWREADY),
        .s_axi_awregion(auto_cc_to_m00_regslice_AWREGION),
        .s_axi_awsize(auto_cc_to_m00_regslice_AWSIZE),
        .s_axi_awuser(auto_cc_to_m00_regslice_AWUSER),
        .s_axi_awvalid(auto_cc_to_m00_regslice_AWVALID),
        .s_axi_bid(auto_cc_to_m00_regslice_BID),
        .s_axi_bready(auto_cc_to_m00_regslice_BREADY),
        .s_axi_bresp(auto_cc_to_m00_regslice_BRESP),
        .s_axi_bvalid(auto_cc_to_m00_regslice_BVALID),
        .s_axi_rdata(auto_cc_to_m00_regslice_RDATA),
        .s_axi_rid(auto_cc_to_m00_regslice_RID),
        .s_axi_rlast(auto_cc_to_m00_regslice_RLAST),
        .s_axi_rready(auto_cc_to_m00_regslice_RREADY),
        .s_axi_rresp(auto_cc_to_m00_regslice_RRESP),
        .s_axi_rvalid(auto_cc_to_m00_regslice_RVALID),
        .s_axi_wdata(auto_cc_to_m00_regslice_WDATA),
        .s_axi_wlast(auto_cc_to_m00_regslice_WLAST),
        .s_axi_wready(auto_cc_to_m00_regslice_WREADY),
        .s_axi_wstrb(auto_cc_to_m00_regslice_WSTRB),
        .s_axi_wvalid(auto_cc_to_m00_regslice_WVALID));
endmodule

module m01_couplers_imp_122MS6B
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arready,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awready,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arprot,
    S_AXI_arready,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awprot,
    S_AXI_awready,
    S_AXI_awvalid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [8:0]M_AXI_araddr;
  input M_AXI_arready;
  output M_AXI_arvalid;
  output [8:0]M_AXI_awaddr;
  input M_AXI_awready;
  output M_AXI_awvalid;
  output M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input M_AXI_bvalid;
  input [31:0]M_AXI_rdata;
  output M_AXI_rready;
  input [1:0]M_AXI_rresp;
  input M_AXI_rvalid;
  output [31:0]M_AXI_wdata;
  input M_AXI_wready;
  output [3:0]M_AXI_wstrb;
  output M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input [39:0]S_AXI_araddr;
  input [2:0]S_AXI_arprot;
  output S_AXI_arready;
  input S_AXI_arvalid;
  input [39:0]S_AXI_awaddr;
  input [2:0]S_AXI_awprot;
  output S_AXI_awready;
  input S_AXI_awvalid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output S_AXI_bvalid;
  output [31:0]S_AXI_rdata;
  input S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output S_AXI_rvalid;
  input [31:0]S_AXI_wdata;
  output S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input S_AXI_wvalid;

  wire M_ACLK_1;
  wire M_ARESETN_1;
  wire S_ACLK_1;
  wire S_ARESETN_1;
  wire [8:0]auto_cc_to_m01_couplers_ARADDR;
  wire auto_cc_to_m01_couplers_ARREADY;
  wire auto_cc_to_m01_couplers_ARVALID;
  wire [8:0]auto_cc_to_m01_couplers_AWADDR;
  wire auto_cc_to_m01_couplers_AWREADY;
  wire auto_cc_to_m01_couplers_AWVALID;
  wire auto_cc_to_m01_couplers_BREADY;
  wire [1:0]auto_cc_to_m01_couplers_BRESP;
  wire auto_cc_to_m01_couplers_BVALID;
  wire [31:0]auto_cc_to_m01_couplers_RDATA;
  wire auto_cc_to_m01_couplers_RREADY;
  wire [1:0]auto_cc_to_m01_couplers_RRESP;
  wire auto_cc_to_m01_couplers_RVALID;
  wire [31:0]auto_cc_to_m01_couplers_WDATA;
  wire auto_cc_to_m01_couplers_WREADY;
  wire [3:0]auto_cc_to_m01_couplers_WSTRB;
  wire auto_cc_to_m01_couplers_WVALID;
  wire [39:0]m01_couplers_to_auto_cc_ARADDR;
  wire [2:0]m01_couplers_to_auto_cc_ARPROT;
  wire m01_couplers_to_auto_cc_ARREADY;
  wire m01_couplers_to_auto_cc_ARVALID;
  wire [39:0]m01_couplers_to_auto_cc_AWADDR;
  wire [2:0]m01_couplers_to_auto_cc_AWPROT;
  wire m01_couplers_to_auto_cc_AWREADY;
  wire m01_couplers_to_auto_cc_AWVALID;
  wire m01_couplers_to_auto_cc_BREADY;
  wire [1:0]m01_couplers_to_auto_cc_BRESP;
  wire m01_couplers_to_auto_cc_BVALID;
  wire [31:0]m01_couplers_to_auto_cc_RDATA;
  wire m01_couplers_to_auto_cc_RREADY;
  wire [1:0]m01_couplers_to_auto_cc_RRESP;
  wire m01_couplers_to_auto_cc_RVALID;
  wire [31:0]m01_couplers_to_auto_cc_WDATA;
  wire m01_couplers_to_auto_cc_WREADY;
  wire [3:0]m01_couplers_to_auto_cc_WSTRB;
  wire m01_couplers_to_auto_cc_WVALID;

  assign M_ACLK_1 = M_ACLK;
  assign M_ARESETN_1 = M_ARESETN;
  assign M_AXI_araddr[8:0] = auto_cc_to_m01_couplers_ARADDR;
  assign M_AXI_arvalid = auto_cc_to_m01_couplers_ARVALID;
  assign M_AXI_awaddr[8:0] = auto_cc_to_m01_couplers_AWADDR;
  assign M_AXI_awvalid = auto_cc_to_m01_couplers_AWVALID;
  assign M_AXI_bready = auto_cc_to_m01_couplers_BREADY;
  assign M_AXI_rready = auto_cc_to_m01_couplers_RREADY;
  assign M_AXI_wdata[31:0] = auto_cc_to_m01_couplers_WDATA;
  assign M_AXI_wstrb[3:0] = auto_cc_to_m01_couplers_WSTRB;
  assign M_AXI_wvalid = auto_cc_to_m01_couplers_WVALID;
  assign S_ACLK_1 = S_ACLK;
  assign S_ARESETN_1 = S_ARESETN;
  assign S_AXI_arready = m01_couplers_to_auto_cc_ARREADY;
  assign S_AXI_awready = m01_couplers_to_auto_cc_AWREADY;
  assign S_AXI_bresp[1:0] = m01_couplers_to_auto_cc_BRESP;
  assign S_AXI_bvalid = m01_couplers_to_auto_cc_BVALID;
  assign S_AXI_rdata[31:0] = m01_couplers_to_auto_cc_RDATA;
  assign S_AXI_rresp[1:0] = m01_couplers_to_auto_cc_RRESP;
  assign S_AXI_rvalid = m01_couplers_to_auto_cc_RVALID;
  assign S_AXI_wready = m01_couplers_to_auto_cc_WREADY;
  assign auto_cc_to_m01_couplers_ARREADY = M_AXI_arready;
  assign auto_cc_to_m01_couplers_AWREADY = M_AXI_awready;
  assign auto_cc_to_m01_couplers_BRESP = M_AXI_bresp[1:0];
  assign auto_cc_to_m01_couplers_BVALID = M_AXI_bvalid;
  assign auto_cc_to_m01_couplers_RDATA = M_AXI_rdata[31:0];
  assign auto_cc_to_m01_couplers_RRESP = M_AXI_rresp[1:0];
  assign auto_cc_to_m01_couplers_RVALID = M_AXI_rvalid;
  assign auto_cc_to_m01_couplers_WREADY = M_AXI_wready;
  assign m01_couplers_to_auto_cc_ARADDR = S_AXI_araddr[39:0];
  assign m01_couplers_to_auto_cc_ARPROT = S_AXI_arprot[2:0];
  assign m01_couplers_to_auto_cc_ARVALID = S_AXI_arvalid;
  assign m01_couplers_to_auto_cc_AWADDR = S_AXI_awaddr[39:0];
  assign m01_couplers_to_auto_cc_AWPROT = S_AXI_awprot[2:0];
  assign m01_couplers_to_auto_cc_AWVALID = S_AXI_awvalid;
  assign m01_couplers_to_auto_cc_BREADY = S_AXI_bready;
  assign m01_couplers_to_auto_cc_RREADY = S_AXI_rready;
  assign m01_couplers_to_auto_cc_WDATA = S_AXI_wdata[31:0];
  assign m01_couplers_to_auto_cc_WSTRB = S_AXI_wstrb[3:0];
  assign m01_couplers_to_auto_cc_WVALID = S_AXI_wvalid;
  kv260_hardware_platform_auto_cc_0 auto_cc
       (.m_axi_aclk(M_ACLK_1),
        .m_axi_araddr(auto_cc_to_m01_couplers_ARADDR),
        .m_axi_aresetn(M_ARESETN_1),
        .m_axi_arready(auto_cc_to_m01_couplers_ARREADY),
        .m_axi_arvalid(auto_cc_to_m01_couplers_ARVALID),
        .m_axi_awaddr(auto_cc_to_m01_couplers_AWADDR),
        .m_axi_awready(auto_cc_to_m01_couplers_AWREADY),
        .m_axi_awvalid(auto_cc_to_m01_couplers_AWVALID),
        .m_axi_bready(auto_cc_to_m01_couplers_BREADY),
        .m_axi_bresp(auto_cc_to_m01_couplers_BRESP),
        .m_axi_bvalid(auto_cc_to_m01_couplers_BVALID),
        .m_axi_rdata(auto_cc_to_m01_couplers_RDATA),
        .m_axi_rready(auto_cc_to_m01_couplers_RREADY),
        .m_axi_rresp(auto_cc_to_m01_couplers_RRESP),
        .m_axi_rvalid(auto_cc_to_m01_couplers_RVALID),
        .m_axi_wdata(auto_cc_to_m01_couplers_WDATA),
        .m_axi_wready(auto_cc_to_m01_couplers_WREADY),
        .m_axi_wstrb(auto_cc_to_m01_couplers_WSTRB),
        .m_axi_wvalid(auto_cc_to_m01_couplers_WVALID),
        .s_axi_aclk(S_ACLK_1),
        .s_axi_araddr(m01_couplers_to_auto_cc_ARADDR[8:0]),
        .s_axi_aresetn(S_ARESETN_1),
        .s_axi_arprot(m01_couplers_to_auto_cc_ARPROT),
        .s_axi_arready(m01_couplers_to_auto_cc_ARREADY),
        .s_axi_arvalid(m01_couplers_to_auto_cc_ARVALID),
        .s_axi_awaddr(m01_couplers_to_auto_cc_AWADDR[8:0]),
        .s_axi_awprot(m01_couplers_to_auto_cc_AWPROT),
        .s_axi_awready(m01_couplers_to_auto_cc_AWREADY),
        .s_axi_awvalid(m01_couplers_to_auto_cc_AWVALID),
        .s_axi_bready(m01_couplers_to_auto_cc_BREADY),
        .s_axi_bresp(m01_couplers_to_auto_cc_BRESP),
        .s_axi_bvalid(m01_couplers_to_auto_cc_BVALID),
        .s_axi_rdata(m01_couplers_to_auto_cc_RDATA),
        .s_axi_rready(m01_couplers_to_auto_cc_RREADY),
        .s_axi_rresp(m01_couplers_to_auto_cc_RRESP),
        .s_axi_rvalid(m01_couplers_to_auto_cc_RVALID),
        .s_axi_wdata(m01_couplers_to_auto_cc_WDATA),
        .s_axi_wready(m01_couplers_to_auto_cc_WREADY),
        .s_axi_wstrb(m01_couplers_to_auto_cc_WSTRB),
        .s_axi_wvalid(m01_couplers_to_auto_cc_WVALID));
endmodule

module m02_couplers_imp_1MAW852
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arready,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awready,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arprot,
    S_AXI_arready,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awprot,
    S_AXI_awready,
    S_AXI_awvalid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [7:0]M_AXI_araddr;
  input M_AXI_arready;
  output M_AXI_arvalid;
  output [7:0]M_AXI_awaddr;
  input M_AXI_awready;
  output M_AXI_awvalid;
  output M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input M_AXI_bvalid;
  input [31:0]M_AXI_rdata;
  output M_AXI_rready;
  input [1:0]M_AXI_rresp;
  input M_AXI_rvalid;
  output [31:0]M_AXI_wdata;
  input M_AXI_wready;
  output [3:0]M_AXI_wstrb;
  output M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input [39:0]S_AXI_araddr;
  input [2:0]S_AXI_arprot;
  output S_AXI_arready;
  input S_AXI_arvalid;
  input [39:0]S_AXI_awaddr;
  input [2:0]S_AXI_awprot;
  output S_AXI_awready;
  input S_AXI_awvalid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output S_AXI_bvalid;
  output [31:0]S_AXI_rdata;
  input S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output S_AXI_rvalid;
  input [31:0]S_AXI_wdata;
  output S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input S_AXI_wvalid;

  wire M_ACLK_1;
  wire M_ARESETN_1;
  wire S_ACLK_1;
  wire S_ARESETN_1;
  wire [7:0]auto_cc_to_m02_couplers_ARADDR;
  wire auto_cc_to_m02_couplers_ARREADY;
  wire auto_cc_to_m02_couplers_ARVALID;
  wire [7:0]auto_cc_to_m02_couplers_AWADDR;
  wire auto_cc_to_m02_couplers_AWREADY;
  wire auto_cc_to_m02_couplers_AWVALID;
  wire auto_cc_to_m02_couplers_BREADY;
  wire [1:0]auto_cc_to_m02_couplers_BRESP;
  wire auto_cc_to_m02_couplers_BVALID;
  wire [31:0]auto_cc_to_m02_couplers_RDATA;
  wire auto_cc_to_m02_couplers_RREADY;
  wire [1:0]auto_cc_to_m02_couplers_RRESP;
  wire auto_cc_to_m02_couplers_RVALID;
  wire [31:0]auto_cc_to_m02_couplers_WDATA;
  wire auto_cc_to_m02_couplers_WREADY;
  wire [3:0]auto_cc_to_m02_couplers_WSTRB;
  wire auto_cc_to_m02_couplers_WVALID;
  wire [39:0]m02_couplers_to_auto_cc_ARADDR;
  wire [2:0]m02_couplers_to_auto_cc_ARPROT;
  wire m02_couplers_to_auto_cc_ARREADY;
  wire m02_couplers_to_auto_cc_ARVALID;
  wire [39:0]m02_couplers_to_auto_cc_AWADDR;
  wire [2:0]m02_couplers_to_auto_cc_AWPROT;
  wire m02_couplers_to_auto_cc_AWREADY;
  wire m02_couplers_to_auto_cc_AWVALID;
  wire m02_couplers_to_auto_cc_BREADY;
  wire [1:0]m02_couplers_to_auto_cc_BRESP;
  wire m02_couplers_to_auto_cc_BVALID;
  wire [31:0]m02_couplers_to_auto_cc_RDATA;
  wire m02_couplers_to_auto_cc_RREADY;
  wire [1:0]m02_couplers_to_auto_cc_RRESP;
  wire m02_couplers_to_auto_cc_RVALID;
  wire [31:0]m02_couplers_to_auto_cc_WDATA;
  wire m02_couplers_to_auto_cc_WREADY;
  wire [3:0]m02_couplers_to_auto_cc_WSTRB;
  wire m02_couplers_to_auto_cc_WVALID;

  assign M_ACLK_1 = M_ACLK;
  assign M_ARESETN_1 = M_ARESETN;
  assign M_AXI_araddr[7:0] = auto_cc_to_m02_couplers_ARADDR;
  assign M_AXI_arvalid = auto_cc_to_m02_couplers_ARVALID;
  assign M_AXI_awaddr[7:0] = auto_cc_to_m02_couplers_AWADDR;
  assign M_AXI_awvalid = auto_cc_to_m02_couplers_AWVALID;
  assign M_AXI_bready = auto_cc_to_m02_couplers_BREADY;
  assign M_AXI_rready = auto_cc_to_m02_couplers_RREADY;
  assign M_AXI_wdata[31:0] = auto_cc_to_m02_couplers_WDATA;
  assign M_AXI_wstrb[3:0] = auto_cc_to_m02_couplers_WSTRB;
  assign M_AXI_wvalid = auto_cc_to_m02_couplers_WVALID;
  assign S_ACLK_1 = S_ACLK;
  assign S_ARESETN_1 = S_ARESETN;
  assign S_AXI_arready = m02_couplers_to_auto_cc_ARREADY;
  assign S_AXI_awready = m02_couplers_to_auto_cc_AWREADY;
  assign S_AXI_bresp[1:0] = m02_couplers_to_auto_cc_BRESP;
  assign S_AXI_bvalid = m02_couplers_to_auto_cc_BVALID;
  assign S_AXI_rdata[31:0] = m02_couplers_to_auto_cc_RDATA;
  assign S_AXI_rresp[1:0] = m02_couplers_to_auto_cc_RRESP;
  assign S_AXI_rvalid = m02_couplers_to_auto_cc_RVALID;
  assign S_AXI_wready = m02_couplers_to_auto_cc_WREADY;
  assign auto_cc_to_m02_couplers_ARREADY = M_AXI_arready;
  assign auto_cc_to_m02_couplers_AWREADY = M_AXI_awready;
  assign auto_cc_to_m02_couplers_BRESP = M_AXI_bresp[1:0];
  assign auto_cc_to_m02_couplers_BVALID = M_AXI_bvalid;
  assign auto_cc_to_m02_couplers_RDATA = M_AXI_rdata[31:0];
  assign auto_cc_to_m02_couplers_RRESP = M_AXI_rresp[1:0];
  assign auto_cc_to_m02_couplers_RVALID = M_AXI_rvalid;
  assign auto_cc_to_m02_couplers_WREADY = M_AXI_wready;
  assign m02_couplers_to_auto_cc_ARADDR = S_AXI_araddr[39:0];
  assign m02_couplers_to_auto_cc_ARPROT = S_AXI_arprot[2:0];
  assign m02_couplers_to_auto_cc_ARVALID = S_AXI_arvalid;
  assign m02_couplers_to_auto_cc_AWADDR = S_AXI_awaddr[39:0];
  assign m02_couplers_to_auto_cc_AWPROT = S_AXI_awprot[2:0];
  assign m02_couplers_to_auto_cc_AWVALID = S_AXI_awvalid;
  assign m02_couplers_to_auto_cc_BREADY = S_AXI_bready;
  assign m02_couplers_to_auto_cc_RREADY = S_AXI_rready;
  assign m02_couplers_to_auto_cc_WDATA = S_AXI_wdata[31:0];
  assign m02_couplers_to_auto_cc_WSTRB = S_AXI_wstrb[3:0];
  assign m02_couplers_to_auto_cc_WVALID = S_AXI_wvalid;
  kv260_hardware_platform_auto_cc_1 auto_cc
       (.m_axi_aclk(M_ACLK_1),
        .m_axi_araddr(auto_cc_to_m02_couplers_ARADDR),
        .m_axi_aresetn(M_ARESETN_1),
        .m_axi_arready(auto_cc_to_m02_couplers_ARREADY),
        .m_axi_arvalid(auto_cc_to_m02_couplers_ARVALID),
        .m_axi_awaddr(auto_cc_to_m02_couplers_AWADDR),
        .m_axi_awready(auto_cc_to_m02_couplers_AWREADY),
        .m_axi_awvalid(auto_cc_to_m02_couplers_AWVALID),
        .m_axi_bready(auto_cc_to_m02_couplers_BREADY),
        .m_axi_bresp(auto_cc_to_m02_couplers_BRESP),
        .m_axi_bvalid(auto_cc_to_m02_couplers_BVALID),
        .m_axi_rdata(auto_cc_to_m02_couplers_RDATA),
        .m_axi_rready(auto_cc_to_m02_couplers_RREADY),
        .m_axi_rresp(auto_cc_to_m02_couplers_RRESP),
        .m_axi_rvalid(auto_cc_to_m02_couplers_RVALID),
        .m_axi_wdata(auto_cc_to_m02_couplers_WDATA),
        .m_axi_wready(auto_cc_to_m02_couplers_WREADY),
        .m_axi_wstrb(auto_cc_to_m02_couplers_WSTRB),
        .m_axi_wvalid(auto_cc_to_m02_couplers_WVALID),
        .s_axi_aclk(S_ACLK_1),
        .s_axi_araddr(m02_couplers_to_auto_cc_ARADDR[7:0]),
        .s_axi_aresetn(S_ARESETN_1),
        .s_axi_arprot(m02_couplers_to_auto_cc_ARPROT),
        .s_axi_arready(m02_couplers_to_auto_cc_ARREADY),
        .s_axi_arvalid(m02_couplers_to_auto_cc_ARVALID),
        .s_axi_awaddr(m02_couplers_to_auto_cc_AWADDR[7:0]),
        .s_axi_awprot(m02_couplers_to_auto_cc_AWPROT),
        .s_axi_awready(m02_couplers_to_auto_cc_AWREADY),
        .s_axi_awvalid(m02_couplers_to_auto_cc_AWVALID),
        .s_axi_bready(m02_couplers_to_auto_cc_BREADY),
        .s_axi_bresp(m02_couplers_to_auto_cc_BRESP),
        .s_axi_bvalid(m02_couplers_to_auto_cc_BVALID),
        .s_axi_rdata(m02_couplers_to_auto_cc_RDATA),
        .s_axi_rready(m02_couplers_to_auto_cc_RREADY),
        .s_axi_rresp(m02_couplers_to_auto_cc_RRESP),
        .s_axi_rvalid(m02_couplers_to_auto_cc_RVALID),
        .s_axi_wdata(m02_couplers_to_auto_cc_WDATA),
        .s_axi_wready(m02_couplers_to_auto_cc_WREADY),
        .s_axi_wstrb(m02_couplers_to_auto_cc_WSTRB),
        .s_axi_wvalid(m02_couplers_to_auto_cc_WVALID));
endmodule

module m03_couplers_imp_1RHNQO5
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arready,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awready,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arprot,
    S_AXI_arready,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awprot,
    S_AXI_awready,
    S_AXI_awvalid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [11:0]M_AXI_araddr;
  input M_AXI_arready;
  output M_AXI_arvalid;
  output [11:0]M_AXI_awaddr;
  input M_AXI_awready;
  output M_AXI_awvalid;
  output M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input M_AXI_bvalid;
  input [31:0]M_AXI_rdata;
  output M_AXI_rready;
  input [1:0]M_AXI_rresp;
  input M_AXI_rvalid;
  output [31:0]M_AXI_wdata;
  input M_AXI_wready;
  output [3:0]M_AXI_wstrb;
  output M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input [39:0]S_AXI_araddr;
  input [2:0]S_AXI_arprot;
  output S_AXI_arready;
  input S_AXI_arvalid;
  input [39:0]S_AXI_awaddr;
  input [2:0]S_AXI_awprot;
  output S_AXI_awready;
  input S_AXI_awvalid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output S_AXI_bvalid;
  output [31:0]S_AXI_rdata;
  input S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output S_AXI_rvalid;
  input [31:0]S_AXI_wdata;
  output S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input S_AXI_wvalid;

  wire M_ACLK_1;
  wire M_ARESETN_1;
  wire S_ACLK_1;
  wire S_ARESETN_1;
  wire [11:0]auto_cc_to_m03_regslice_ARADDR;
  wire [2:0]auto_cc_to_m03_regslice_ARPROT;
  wire auto_cc_to_m03_regslice_ARREADY;
  wire auto_cc_to_m03_regslice_ARVALID;
  wire [11:0]auto_cc_to_m03_regslice_AWADDR;
  wire [2:0]auto_cc_to_m03_regslice_AWPROT;
  wire auto_cc_to_m03_regslice_AWREADY;
  wire auto_cc_to_m03_regslice_AWVALID;
  wire auto_cc_to_m03_regslice_BREADY;
  wire [1:0]auto_cc_to_m03_regslice_BRESP;
  wire auto_cc_to_m03_regslice_BVALID;
  wire [31:0]auto_cc_to_m03_regslice_RDATA;
  wire auto_cc_to_m03_regslice_RREADY;
  wire [1:0]auto_cc_to_m03_regslice_RRESP;
  wire auto_cc_to_m03_regslice_RVALID;
  wire [31:0]auto_cc_to_m03_regslice_WDATA;
  wire auto_cc_to_m03_regslice_WREADY;
  wire [3:0]auto_cc_to_m03_regslice_WSTRB;
  wire auto_cc_to_m03_regslice_WVALID;
  wire [39:0]m03_couplers_to_auto_cc_ARADDR;
  wire [2:0]m03_couplers_to_auto_cc_ARPROT;
  wire m03_couplers_to_auto_cc_ARREADY;
  wire m03_couplers_to_auto_cc_ARVALID;
  wire [39:0]m03_couplers_to_auto_cc_AWADDR;
  wire [2:0]m03_couplers_to_auto_cc_AWPROT;
  wire m03_couplers_to_auto_cc_AWREADY;
  wire m03_couplers_to_auto_cc_AWVALID;
  wire m03_couplers_to_auto_cc_BREADY;
  wire [1:0]m03_couplers_to_auto_cc_BRESP;
  wire m03_couplers_to_auto_cc_BVALID;
  wire [31:0]m03_couplers_to_auto_cc_RDATA;
  wire m03_couplers_to_auto_cc_RREADY;
  wire [1:0]m03_couplers_to_auto_cc_RRESP;
  wire m03_couplers_to_auto_cc_RVALID;
  wire [31:0]m03_couplers_to_auto_cc_WDATA;
  wire m03_couplers_to_auto_cc_WREADY;
  wire [3:0]m03_couplers_to_auto_cc_WSTRB;
  wire m03_couplers_to_auto_cc_WVALID;
  wire [11:0]m03_regslice_to_m03_couplers_ARADDR;
  wire m03_regslice_to_m03_couplers_ARREADY;
  wire m03_regslice_to_m03_couplers_ARVALID;
  wire [11:0]m03_regslice_to_m03_couplers_AWADDR;
  wire m03_regslice_to_m03_couplers_AWREADY;
  wire m03_regslice_to_m03_couplers_AWVALID;
  wire m03_regslice_to_m03_couplers_BREADY;
  wire [1:0]m03_regslice_to_m03_couplers_BRESP;
  wire m03_regslice_to_m03_couplers_BVALID;
  wire [31:0]m03_regslice_to_m03_couplers_RDATA;
  wire m03_regslice_to_m03_couplers_RREADY;
  wire [1:0]m03_regslice_to_m03_couplers_RRESP;
  wire m03_regslice_to_m03_couplers_RVALID;
  wire [31:0]m03_regslice_to_m03_couplers_WDATA;
  wire m03_regslice_to_m03_couplers_WREADY;
  wire [3:0]m03_regslice_to_m03_couplers_WSTRB;
  wire m03_regslice_to_m03_couplers_WVALID;

  assign M_ACLK_1 = M_ACLK;
  assign M_ARESETN_1 = M_ARESETN;
  assign M_AXI_araddr[11:0] = m03_regslice_to_m03_couplers_ARADDR;
  assign M_AXI_arvalid = m03_regslice_to_m03_couplers_ARVALID;
  assign M_AXI_awaddr[11:0] = m03_regslice_to_m03_couplers_AWADDR;
  assign M_AXI_awvalid = m03_regslice_to_m03_couplers_AWVALID;
  assign M_AXI_bready = m03_regslice_to_m03_couplers_BREADY;
  assign M_AXI_rready = m03_regslice_to_m03_couplers_RREADY;
  assign M_AXI_wdata[31:0] = m03_regslice_to_m03_couplers_WDATA;
  assign M_AXI_wstrb[3:0] = m03_regslice_to_m03_couplers_WSTRB;
  assign M_AXI_wvalid = m03_regslice_to_m03_couplers_WVALID;
  assign S_ACLK_1 = S_ACLK;
  assign S_ARESETN_1 = S_ARESETN;
  assign S_AXI_arready = m03_couplers_to_auto_cc_ARREADY;
  assign S_AXI_awready = m03_couplers_to_auto_cc_AWREADY;
  assign S_AXI_bresp[1:0] = m03_couplers_to_auto_cc_BRESP;
  assign S_AXI_bvalid = m03_couplers_to_auto_cc_BVALID;
  assign S_AXI_rdata[31:0] = m03_couplers_to_auto_cc_RDATA;
  assign S_AXI_rresp[1:0] = m03_couplers_to_auto_cc_RRESP;
  assign S_AXI_rvalid = m03_couplers_to_auto_cc_RVALID;
  assign S_AXI_wready = m03_couplers_to_auto_cc_WREADY;
  assign m03_couplers_to_auto_cc_ARADDR = S_AXI_araddr[39:0];
  assign m03_couplers_to_auto_cc_ARPROT = S_AXI_arprot[2:0];
  assign m03_couplers_to_auto_cc_ARVALID = S_AXI_arvalid;
  assign m03_couplers_to_auto_cc_AWADDR = S_AXI_awaddr[39:0];
  assign m03_couplers_to_auto_cc_AWPROT = S_AXI_awprot[2:0];
  assign m03_couplers_to_auto_cc_AWVALID = S_AXI_awvalid;
  assign m03_couplers_to_auto_cc_BREADY = S_AXI_bready;
  assign m03_couplers_to_auto_cc_RREADY = S_AXI_rready;
  assign m03_couplers_to_auto_cc_WDATA = S_AXI_wdata[31:0];
  assign m03_couplers_to_auto_cc_WSTRB = S_AXI_wstrb[3:0];
  assign m03_couplers_to_auto_cc_WVALID = S_AXI_wvalid;
  assign m03_regslice_to_m03_couplers_ARREADY = M_AXI_arready;
  assign m03_regslice_to_m03_couplers_AWREADY = M_AXI_awready;
  assign m03_regslice_to_m03_couplers_BRESP = M_AXI_bresp[1:0];
  assign m03_regslice_to_m03_couplers_BVALID = M_AXI_bvalid;
  assign m03_regslice_to_m03_couplers_RDATA = M_AXI_rdata[31:0];
  assign m03_regslice_to_m03_couplers_RRESP = M_AXI_rresp[1:0];
  assign m03_regslice_to_m03_couplers_RVALID = M_AXI_rvalid;
  assign m03_regslice_to_m03_couplers_WREADY = M_AXI_wready;
  kv260_hardware_platform_auto_cc_2 auto_cc
       (.m_axi_aclk(M_ACLK_1),
        .m_axi_araddr(auto_cc_to_m03_regslice_ARADDR),
        .m_axi_aresetn(M_ARESETN_1),
        .m_axi_arprot(auto_cc_to_m03_regslice_ARPROT),
        .m_axi_arready(auto_cc_to_m03_regslice_ARREADY),
        .m_axi_arvalid(auto_cc_to_m03_regslice_ARVALID),
        .m_axi_awaddr(auto_cc_to_m03_regslice_AWADDR),
        .m_axi_awprot(auto_cc_to_m03_regslice_AWPROT),
        .m_axi_awready(auto_cc_to_m03_regslice_AWREADY),
        .m_axi_awvalid(auto_cc_to_m03_regslice_AWVALID),
        .m_axi_bready(auto_cc_to_m03_regslice_BREADY),
        .m_axi_bresp(auto_cc_to_m03_regslice_BRESP),
        .m_axi_bvalid(auto_cc_to_m03_regslice_BVALID),
        .m_axi_rdata(auto_cc_to_m03_regslice_RDATA),
        .m_axi_rready(auto_cc_to_m03_regslice_RREADY),
        .m_axi_rresp(auto_cc_to_m03_regslice_RRESP),
        .m_axi_rvalid(auto_cc_to_m03_regslice_RVALID),
        .m_axi_wdata(auto_cc_to_m03_regslice_WDATA),
        .m_axi_wready(auto_cc_to_m03_regslice_WREADY),
        .m_axi_wstrb(auto_cc_to_m03_regslice_WSTRB),
        .m_axi_wvalid(auto_cc_to_m03_regslice_WVALID),
        .s_axi_aclk(S_ACLK_1),
        .s_axi_araddr(m03_couplers_to_auto_cc_ARADDR[11:0]),
        .s_axi_aresetn(S_ARESETN_1),
        .s_axi_arprot(m03_couplers_to_auto_cc_ARPROT),
        .s_axi_arready(m03_couplers_to_auto_cc_ARREADY),
        .s_axi_arvalid(m03_couplers_to_auto_cc_ARVALID),
        .s_axi_awaddr(m03_couplers_to_auto_cc_AWADDR[11:0]),
        .s_axi_awprot(m03_couplers_to_auto_cc_AWPROT),
        .s_axi_awready(m03_couplers_to_auto_cc_AWREADY),
        .s_axi_awvalid(m03_couplers_to_auto_cc_AWVALID),
        .s_axi_bready(m03_couplers_to_auto_cc_BREADY),
        .s_axi_bresp(m03_couplers_to_auto_cc_BRESP),
        .s_axi_bvalid(m03_couplers_to_auto_cc_BVALID),
        .s_axi_rdata(m03_couplers_to_auto_cc_RDATA),
        .s_axi_rready(m03_couplers_to_auto_cc_RREADY),
        .s_axi_rresp(m03_couplers_to_auto_cc_RRESP),
        .s_axi_rvalid(m03_couplers_to_auto_cc_RVALID),
        .s_axi_wdata(m03_couplers_to_auto_cc_WDATA),
        .s_axi_wready(m03_couplers_to_auto_cc_WREADY),
        .s_axi_wstrb(m03_couplers_to_auto_cc_WSTRB),
        .s_axi_wvalid(m03_couplers_to_auto_cc_WVALID));
  kv260_hardware_platform_m03_regslice_0 m03_regslice
       (.aclk(M_ACLK_1),
        .aresetn(M_ARESETN_1),
        .m_axi_araddr(m03_regslice_to_m03_couplers_ARADDR),
        .m_axi_arready(m03_regslice_to_m03_couplers_ARREADY),
        .m_axi_arvalid(m03_regslice_to_m03_couplers_ARVALID),
        .m_axi_awaddr(m03_regslice_to_m03_couplers_AWADDR),
        .m_axi_awready(m03_regslice_to_m03_couplers_AWREADY),
        .m_axi_awvalid(m03_regslice_to_m03_couplers_AWVALID),
        .m_axi_bready(m03_regslice_to_m03_couplers_BREADY),
        .m_axi_bresp(m03_regslice_to_m03_couplers_BRESP),
        .m_axi_bvalid(m03_regslice_to_m03_couplers_BVALID),
        .m_axi_rdata(m03_regslice_to_m03_couplers_RDATA),
        .m_axi_rready(m03_regslice_to_m03_couplers_RREADY),
        .m_axi_rresp(m03_regslice_to_m03_couplers_RRESP),
        .m_axi_rvalid(m03_regslice_to_m03_couplers_RVALID),
        .m_axi_wdata(m03_regslice_to_m03_couplers_WDATA),
        .m_axi_wready(m03_regslice_to_m03_couplers_WREADY),
        .m_axi_wstrb(m03_regslice_to_m03_couplers_WSTRB),
        .m_axi_wvalid(m03_regslice_to_m03_couplers_WVALID),
        .s_axi_araddr(auto_cc_to_m03_regslice_ARADDR),
        .s_axi_arprot(auto_cc_to_m03_regslice_ARPROT),
        .s_axi_arready(auto_cc_to_m03_regslice_ARREADY),
        .s_axi_arvalid(auto_cc_to_m03_regslice_ARVALID),
        .s_axi_awaddr(auto_cc_to_m03_regslice_AWADDR),
        .s_axi_awprot(auto_cc_to_m03_regslice_AWPROT),
        .s_axi_awready(auto_cc_to_m03_regslice_AWREADY),
        .s_axi_awvalid(auto_cc_to_m03_regslice_AWVALID),
        .s_axi_bready(auto_cc_to_m03_regslice_BREADY),
        .s_axi_bresp(auto_cc_to_m03_regslice_BRESP),
        .s_axi_bvalid(auto_cc_to_m03_regslice_BVALID),
        .s_axi_rdata(auto_cc_to_m03_regslice_RDATA),
        .s_axi_rready(auto_cc_to_m03_regslice_RREADY),
        .s_axi_rresp(auto_cc_to_m03_regslice_RRESP),
        .s_axi_rvalid(auto_cc_to_m03_regslice_RVALID),
        .s_axi_wdata(auto_cc_to_m03_regslice_WDATA),
        .s_axi_wready(auto_cc_to_m03_regslice_WREADY),
        .s_axi_wstrb(auto_cc_to_m03_regslice_WSTRB),
        .s_axi_wvalid(auto_cc_to_m03_regslice_WVALID));
endmodule

module m04_couplers_imp_RRGH0C
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arready,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awready,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arprot,
    S_AXI_arready,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awprot,
    S_AXI_awready,
    S_AXI_awvalid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [11:0]M_AXI_araddr;
  input M_AXI_arready;
  output M_AXI_arvalid;
  output [11:0]M_AXI_awaddr;
  input M_AXI_awready;
  output M_AXI_awvalid;
  output M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input M_AXI_bvalid;
  input [31:0]M_AXI_rdata;
  output M_AXI_rready;
  input [1:0]M_AXI_rresp;
  input M_AXI_rvalid;
  output [31:0]M_AXI_wdata;
  input M_AXI_wready;
  output [3:0]M_AXI_wstrb;
  output M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input [39:0]S_AXI_araddr;
  input [2:0]S_AXI_arprot;
  output S_AXI_arready;
  input S_AXI_arvalid;
  input [39:0]S_AXI_awaddr;
  input [2:0]S_AXI_awprot;
  output S_AXI_awready;
  input S_AXI_awvalid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output S_AXI_bvalid;
  output [31:0]S_AXI_rdata;
  input S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output S_AXI_rvalid;
  input [31:0]S_AXI_wdata;
  output S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input S_AXI_wvalid;

  wire M_ACLK_1;
  wire M_ARESETN_1;
  wire S_ACLK_1;
  wire S_ARESETN_1;
  wire [11:0]auto_cc_to_m04_regslice_ARADDR;
  wire [2:0]auto_cc_to_m04_regslice_ARPROT;
  wire auto_cc_to_m04_regslice_ARREADY;
  wire auto_cc_to_m04_regslice_ARVALID;
  wire [11:0]auto_cc_to_m04_regslice_AWADDR;
  wire [2:0]auto_cc_to_m04_regslice_AWPROT;
  wire auto_cc_to_m04_regslice_AWREADY;
  wire auto_cc_to_m04_regslice_AWVALID;
  wire auto_cc_to_m04_regslice_BREADY;
  wire [1:0]auto_cc_to_m04_regslice_BRESP;
  wire auto_cc_to_m04_regslice_BVALID;
  wire [31:0]auto_cc_to_m04_regslice_RDATA;
  wire auto_cc_to_m04_regslice_RREADY;
  wire [1:0]auto_cc_to_m04_regslice_RRESP;
  wire auto_cc_to_m04_regslice_RVALID;
  wire [31:0]auto_cc_to_m04_regslice_WDATA;
  wire auto_cc_to_m04_regslice_WREADY;
  wire [3:0]auto_cc_to_m04_regslice_WSTRB;
  wire auto_cc_to_m04_regslice_WVALID;
  wire [39:0]m04_couplers_to_auto_cc_ARADDR;
  wire [2:0]m04_couplers_to_auto_cc_ARPROT;
  wire m04_couplers_to_auto_cc_ARREADY;
  wire m04_couplers_to_auto_cc_ARVALID;
  wire [39:0]m04_couplers_to_auto_cc_AWADDR;
  wire [2:0]m04_couplers_to_auto_cc_AWPROT;
  wire m04_couplers_to_auto_cc_AWREADY;
  wire m04_couplers_to_auto_cc_AWVALID;
  wire m04_couplers_to_auto_cc_BREADY;
  wire [1:0]m04_couplers_to_auto_cc_BRESP;
  wire m04_couplers_to_auto_cc_BVALID;
  wire [31:0]m04_couplers_to_auto_cc_RDATA;
  wire m04_couplers_to_auto_cc_RREADY;
  wire [1:0]m04_couplers_to_auto_cc_RRESP;
  wire m04_couplers_to_auto_cc_RVALID;
  wire [31:0]m04_couplers_to_auto_cc_WDATA;
  wire m04_couplers_to_auto_cc_WREADY;
  wire [3:0]m04_couplers_to_auto_cc_WSTRB;
  wire m04_couplers_to_auto_cc_WVALID;
  wire [11:0]m04_regslice_to_m04_couplers_ARADDR;
  wire m04_regslice_to_m04_couplers_ARREADY;
  wire m04_regslice_to_m04_couplers_ARVALID;
  wire [11:0]m04_regslice_to_m04_couplers_AWADDR;
  wire m04_regslice_to_m04_couplers_AWREADY;
  wire m04_regslice_to_m04_couplers_AWVALID;
  wire m04_regslice_to_m04_couplers_BREADY;
  wire [1:0]m04_regslice_to_m04_couplers_BRESP;
  wire m04_regslice_to_m04_couplers_BVALID;
  wire [31:0]m04_regslice_to_m04_couplers_RDATA;
  wire m04_regslice_to_m04_couplers_RREADY;
  wire [1:0]m04_regslice_to_m04_couplers_RRESP;
  wire m04_regslice_to_m04_couplers_RVALID;
  wire [31:0]m04_regslice_to_m04_couplers_WDATA;
  wire m04_regslice_to_m04_couplers_WREADY;
  wire [3:0]m04_regslice_to_m04_couplers_WSTRB;
  wire m04_regslice_to_m04_couplers_WVALID;

  assign M_ACLK_1 = M_ACLK;
  assign M_ARESETN_1 = M_ARESETN;
  assign M_AXI_araddr[11:0] = m04_regslice_to_m04_couplers_ARADDR;
  assign M_AXI_arvalid = m04_regslice_to_m04_couplers_ARVALID;
  assign M_AXI_awaddr[11:0] = m04_regslice_to_m04_couplers_AWADDR;
  assign M_AXI_awvalid = m04_regslice_to_m04_couplers_AWVALID;
  assign M_AXI_bready = m04_regslice_to_m04_couplers_BREADY;
  assign M_AXI_rready = m04_regslice_to_m04_couplers_RREADY;
  assign M_AXI_wdata[31:0] = m04_regslice_to_m04_couplers_WDATA;
  assign M_AXI_wstrb[3:0] = m04_regslice_to_m04_couplers_WSTRB;
  assign M_AXI_wvalid = m04_regslice_to_m04_couplers_WVALID;
  assign S_ACLK_1 = S_ACLK;
  assign S_ARESETN_1 = S_ARESETN;
  assign S_AXI_arready = m04_couplers_to_auto_cc_ARREADY;
  assign S_AXI_awready = m04_couplers_to_auto_cc_AWREADY;
  assign S_AXI_bresp[1:0] = m04_couplers_to_auto_cc_BRESP;
  assign S_AXI_bvalid = m04_couplers_to_auto_cc_BVALID;
  assign S_AXI_rdata[31:0] = m04_couplers_to_auto_cc_RDATA;
  assign S_AXI_rresp[1:0] = m04_couplers_to_auto_cc_RRESP;
  assign S_AXI_rvalid = m04_couplers_to_auto_cc_RVALID;
  assign S_AXI_wready = m04_couplers_to_auto_cc_WREADY;
  assign m04_couplers_to_auto_cc_ARADDR = S_AXI_araddr[39:0];
  assign m04_couplers_to_auto_cc_ARPROT = S_AXI_arprot[2:0];
  assign m04_couplers_to_auto_cc_ARVALID = S_AXI_arvalid;
  assign m04_couplers_to_auto_cc_AWADDR = S_AXI_awaddr[39:0];
  assign m04_couplers_to_auto_cc_AWPROT = S_AXI_awprot[2:0];
  assign m04_couplers_to_auto_cc_AWVALID = S_AXI_awvalid;
  assign m04_couplers_to_auto_cc_BREADY = S_AXI_bready;
  assign m04_couplers_to_auto_cc_RREADY = S_AXI_rready;
  assign m04_couplers_to_auto_cc_WDATA = S_AXI_wdata[31:0];
  assign m04_couplers_to_auto_cc_WSTRB = S_AXI_wstrb[3:0];
  assign m04_couplers_to_auto_cc_WVALID = S_AXI_wvalid;
  assign m04_regslice_to_m04_couplers_ARREADY = M_AXI_arready;
  assign m04_regslice_to_m04_couplers_AWREADY = M_AXI_awready;
  assign m04_regslice_to_m04_couplers_BRESP = M_AXI_bresp[1:0];
  assign m04_regslice_to_m04_couplers_BVALID = M_AXI_bvalid;
  assign m04_regslice_to_m04_couplers_RDATA = M_AXI_rdata[31:0];
  assign m04_regslice_to_m04_couplers_RRESP = M_AXI_rresp[1:0];
  assign m04_regslice_to_m04_couplers_RVALID = M_AXI_rvalid;
  assign m04_regslice_to_m04_couplers_WREADY = M_AXI_wready;
  kv260_hardware_platform_auto_cc_3 auto_cc
       (.m_axi_aclk(M_ACLK_1),
        .m_axi_araddr(auto_cc_to_m04_regslice_ARADDR),
        .m_axi_aresetn(M_ARESETN_1),
        .m_axi_arprot(auto_cc_to_m04_regslice_ARPROT),
        .m_axi_arready(auto_cc_to_m04_regslice_ARREADY),
        .m_axi_arvalid(auto_cc_to_m04_regslice_ARVALID),
        .m_axi_awaddr(auto_cc_to_m04_regslice_AWADDR),
        .m_axi_awprot(auto_cc_to_m04_regslice_AWPROT),
        .m_axi_awready(auto_cc_to_m04_regslice_AWREADY),
        .m_axi_awvalid(auto_cc_to_m04_regslice_AWVALID),
        .m_axi_bready(auto_cc_to_m04_regslice_BREADY),
        .m_axi_bresp(auto_cc_to_m04_regslice_BRESP),
        .m_axi_bvalid(auto_cc_to_m04_regslice_BVALID),
        .m_axi_rdata(auto_cc_to_m04_regslice_RDATA),
        .m_axi_rready(auto_cc_to_m04_regslice_RREADY),
        .m_axi_rresp(auto_cc_to_m04_regslice_RRESP),
        .m_axi_rvalid(auto_cc_to_m04_regslice_RVALID),
        .m_axi_wdata(auto_cc_to_m04_regslice_WDATA),
        .m_axi_wready(auto_cc_to_m04_regslice_WREADY),
        .m_axi_wstrb(auto_cc_to_m04_regslice_WSTRB),
        .m_axi_wvalid(auto_cc_to_m04_regslice_WVALID),
        .s_axi_aclk(S_ACLK_1),
        .s_axi_araddr(m04_couplers_to_auto_cc_ARADDR[11:0]),
        .s_axi_aresetn(S_ARESETN_1),
        .s_axi_arprot(m04_couplers_to_auto_cc_ARPROT),
        .s_axi_arready(m04_couplers_to_auto_cc_ARREADY),
        .s_axi_arvalid(m04_couplers_to_auto_cc_ARVALID),
        .s_axi_awaddr(m04_couplers_to_auto_cc_AWADDR[11:0]),
        .s_axi_awprot(m04_couplers_to_auto_cc_AWPROT),
        .s_axi_awready(m04_couplers_to_auto_cc_AWREADY),
        .s_axi_awvalid(m04_couplers_to_auto_cc_AWVALID),
        .s_axi_bready(m04_couplers_to_auto_cc_BREADY),
        .s_axi_bresp(m04_couplers_to_auto_cc_BRESP),
        .s_axi_bvalid(m04_couplers_to_auto_cc_BVALID),
        .s_axi_rdata(m04_couplers_to_auto_cc_RDATA),
        .s_axi_rready(m04_couplers_to_auto_cc_RREADY),
        .s_axi_rresp(m04_couplers_to_auto_cc_RRESP),
        .s_axi_rvalid(m04_couplers_to_auto_cc_RVALID),
        .s_axi_wdata(m04_couplers_to_auto_cc_WDATA),
        .s_axi_wready(m04_couplers_to_auto_cc_WREADY),
        .s_axi_wstrb(m04_couplers_to_auto_cc_WSTRB),
        .s_axi_wvalid(m04_couplers_to_auto_cc_WVALID));
  kv260_hardware_platform_m04_regslice_0 m04_regslice
       (.aclk(M_ACLK_1),
        .aresetn(M_ARESETN_1),
        .m_axi_araddr(m04_regslice_to_m04_couplers_ARADDR),
        .m_axi_arready(m04_regslice_to_m04_couplers_ARREADY),
        .m_axi_arvalid(m04_regslice_to_m04_couplers_ARVALID),
        .m_axi_awaddr(m04_regslice_to_m04_couplers_AWADDR),
        .m_axi_awready(m04_regslice_to_m04_couplers_AWREADY),
        .m_axi_awvalid(m04_regslice_to_m04_couplers_AWVALID),
        .m_axi_bready(m04_regslice_to_m04_couplers_BREADY),
        .m_axi_bresp(m04_regslice_to_m04_couplers_BRESP),
        .m_axi_bvalid(m04_regslice_to_m04_couplers_BVALID),
        .m_axi_rdata(m04_regslice_to_m04_couplers_RDATA),
        .m_axi_rready(m04_regslice_to_m04_couplers_RREADY),
        .m_axi_rresp(m04_regslice_to_m04_couplers_RRESP),
        .m_axi_rvalid(m04_regslice_to_m04_couplers_RVALID),
        .m_axi_wdata(m04_regslice_to_m04_couplers_WDATA),
        .m_axi_wready(m04_regslice_to_m04_couplers_WREADY),
        .m_axi_wstrb(m04_regslice_to_m04_couplers_WSTRB),
        .m_axi_wvalid(m04_regslice_to_m04_couplers_WVALID),
        .s_axi_araddr(auto_cc_to_m04_regslice_ARADDR),
        .s_axi_arprot(auto_cc_to_m04_regslice_ARPROT),
        .s_axi_arready(auto_cc_to_m04_regslice_ARREADY),
        .s_axi_arvalid(auto_cc_to_m04_regslice_ARVALID),
        .s_axi_awaddr(auto_cc_to_m04_regslice_AWADDR),
        .s_axi_awprot(auto_cc_to_m04_regslice_AWPROT),
        .s_axi_awready(auto_cc_to_m04_regslice_AWREADY),
        .s_axi_awvalid(auto_cc_to_m04_regslice_AWVALID),
        .s_axi_bready(auto_cc_to_m04_regslice_BREADY),
        .s_axi_bresp(auto_cc_to_m04_regslice_BRESP),
        .s_axi_bvalid(auto_cc_to_m04_regslice_BVALID),
        .s_axi_rdata(auto_cc_to_m04_regslice_RDATA),
        .s_axi_rready(auto_cc_to_m04_regslice_RREADY),
        .s_axi_rresp(auto_cc_to_m04_regslice_RRESP),
        .s_axi_rvalid(auto_cc_to_m04_regslice_RVALID),
        .s_axi_wdata(auto_cc_to_m04_regslice_WDATA),
        .s_axi_wready(auto_cc_to_m04_regslice_WREADY),
        .s_axi_wstrb(auto_cc_to_m04_regslice_WSTRB),
        .s_axi_wvalid(auto_cc_to_m04_regslice_WVALID));
endmodule

module s00_couplers_imp_12R3ISB
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arburst,
    M_AXI_arcache,
    M_AXI_arlen,
    M_AXI_arlock,
    M_AXI_arprot,
    M_AXI_arqos,
    M_AXI_arready,
    M_AXI_arsize,
    M_AXI_aruser,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awburst,
    M_AXI_awcache,
    M_AXI_awlen,
    M_AXI_awlock,
    M_AXI_awprot,
    M_AXI_awqos,
    M_AXI_awready,
    M_AXI_awsize,
    M_AXI_awuser,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rlast,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wlast,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arburst,
    S_AXI_arcache,
    S_AXI_arlen,
    S_AXI_arlock,
    S_AXI_arprot,
    S_AXI_arqos,
    S_AXI_arready,
    S_AXI_arsize,
    S_AXI_aruser,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awburst,
    S_AXI_awcache,
    S_AXI_awlen,
    S_AXI_awlock,
    S_AXI_awprot,
    S_AXI_awqos,
    S_AXI_awready,
    S_AXI_awsize,
    S_AXI_awuser,
    S_AXI_awvalid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rlast,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wlast,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [39:0]M_AXI_araddr;
  output [1:0]M_AXI_arburst;
  output [3:0]M_AXI_arcache;
  output [7:0]M_AXI_arlen;
  output [0:0]M_AXI_arlock;
  output [2:0]M_AXI_arprot;
  output [3:0]M_AXI_arqos;
  input M_AXI_arready;
  output [2:0]M_AXI_arsize;
  output [0:0]M_AXI_aruser;
  output M_AXI_arvalid;
  output [39:0]M_AXI_awaddr;
  output [1:0]M_AXI_awburst;
  output [3:0]M_AXI_awcache;
  output [7:0]M_AXI_awlen;
  output [0:0]M_AXI_awlock;
  output [2:0]M_AXI_awprot;
  output [3:0]M_AXI_awqos;
  input M_AXI_awready;
  output [2:0]M_AXI_awsize;
  output [0:0]M_AXI_awuser;
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
  input S_ACLK;
  input S_ARESETN;
  input [39:0]S_AXI_araddr;
  input [1:0]S_AXI_arburst;
  input [3:0]S_AXI_arcache;
  input [7:0]S_AXI_arlen;
  input [0:0]S_AXI_arlock;
  input [2:0]S_AXI_arprot;
  input [3:0]S_AXI_arqos;
  output S_AXI_arready;
  input [2:0]S_AXI_arsize;
  input [0:0]S_AXI_aruser;
  input S_AXI_arvalid;
  input [39:0]S_AXI_awaddr;
  input [1:0]S_AXI_awburst;
  input [3:0]S_AXI_awcache;
  input [7:0]S_AXI_awlen;
  input [0:0]S_AXI_awlock;
  input [2:0]S_AXI_awprot;
  input [3:0]S_AXI_awqos;
  output S_AXI_awready;
  input [2:0]S_AXI_awsize;
  input [0:0]S_AXI_awuser;
  input S_AXI_awvalid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output S_AXI_bvalid;
  output [127:0]S_AXI_rdata;
  output S_AXI_rlast;
  input S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output S_AXI_rvalid;
  input [127:0]S_AXI_wdata;
  input S_AXI_wlast;
  output S_AXI_wready;
  input [15:0]S_AXI_wstrb;
  input S_AXI_wvalid;

  wire M_ACLK_1;
  wire M_ARESETN_1;
  wire S_ACLK_1;
  wire S_ARESETN_1;
  wire [39:0]auto_cc_to_s00_data_fifo_ARADDR;
  wire [1:0]auto_cc_to_s00_data_fifo_ARBURST;
  wire [3:0]auto_cc_to_s00_data_fifo_ARCACHE;
  wire [7:0]auto_cc_to_s00_data_fifo_ARLEN;
  wire [0:0]auto_cc_to_s00_data_fifo_ARLOCK;
  wire [2:0]auto_cc_to_s00_data_fifo_ARPROT;
  wire [3:0]auto_cc_to_s00_data_fifo_ARQOS;
  wire auto_cc_to_s00_data_fifo_ARREADY;
  wire [3:0]auto_cc_to_s00_data_fifo_ARREGION;
  wire [2:0]auto_cc_to_s00_data_fifo_ARSIZE;
  wire [0:0]auto_cc_to_s00_data_fifo_ARUSER;
  wire auto_cc_to_s00_data_fifo_ARVALID;
  wire [39:0]auto_cc_to_s00_data_fifo_AWADDR;
  wire [1:0]auto_cc_to_s00_data_fifo_AWBURST;
  wire [3:0]auto_cc_to_s00_data_fifo_AWCACHE;
  wire [7:0]auto_cc_to_s00_data_fifo_AWLEN;
  wire [0:0]auto_cc_to_s00_data_fifo_AWLOCK;
  wire [2:0]auto_cc_to_s00_data_fifo_AWPROT;
  wire [3:0]auto_cc_to_s00_data_fifo_AWQOS;
  wire auto_cc_to_s00_data_fifo_AWREADY;
  wire [3:0]auto_cc_to_s00_data_fifo_AWREGION;
  wire [2:0]auto_cc_to_s00_data_fifo_AWSIZE;
  wire [0:0]auto_cc_to_s00_data_fifo_AWUSER;
  wire auto_cc_to_s00_data_fifo_AWVALID;
  wire auto_cc_to_s00_data_fifo_BREADY;
  wire [1:0]auto_cc_to_s00_data_fifo_BRESP;
  wire auto_cc_to_s00_data_fifo_BVALID;
  wire [127:0]auto_cc_to_s00_data_fifo_RDATA;
  wire auto_cc_to_s00_data_fifo_RLAST;
  wire auto_cc_to_s00_data_fifo_RREADY;
  wire [1:0]auto_cc_to_s00_data_fifo_RRESP;
  wire auto_cc_to_s00_data_fifo_RVALID;
  wire [127:0]auto_cc_to_s00_data_fifo_WDATA;
  wire auto_cc_to_s00_data_fifo_WLAST;
  wire auto_cc_to_s00_data_fifo_WREADY;
  wire [15:0]auto_cc_to_s00_data_fifo_WSTRB;
  wire auto_cc_to_s00_data_fifo_WVALID;
  wire [39:0]s00_couplers_to_s00_regslice_ARADDR;
  wire [1:0]s00_couplers_to_s00_regslice_ARBURST;
  wire [3:0]s00_couplers_to_s00_regslice_ARCACHE;
  wire [7:0]s00_couplers_to_s00_regslice_ARLEN;
  wire [0:0]s00_couplers_to_s00_regslice_ARLOCK;
  wire [2:0]s00_couplers_to_s00_regslice_ARPROT;
  wire [3:0]s00_couplers_to_s00_regslice_ARQOS;
  wire s00_couplers_to_s00_regslice_ARREADY;
  wire [2:0]s00_couplers_to_s00_regslice_ARSIZE;
  wire [0:0]s00_couplers_to_s00_regslice_ARUSER;
  wire s00_couplers_to_s00_regslice_ARVALID;
  wire [39:0]s00_couplers_to_s00_regslice_AWADDR;
  wire [1:0]s00_couplers_to_s00_regslice_AWBURST;
  wire [3:0]s00_couplers_to_s00_regslice_AWCACHE;
  wire [7:0]s00_couplers_to_s00_regslice_AWLEN;
  wire [0:0]s00_couplers_to_s00_regslice_AWLOCK;
  wire [2:0]s00_couplers_to_s00_regslice_AWPROT;
  wire [3:0]s00_couplers_to_s00_regslice_AWQOS;
  wire s00_couplers_to_s00_regslice_AWREADY;
  wire [2:0]s00_couplers_to_s00_regslice_AWSIZE;
  wire [0:0]s00_couplers_to_s00_regslice_AWUSER;
  wire s00_couplers_to_s00_regslice_AWVALID;
  wire s00_couplers_to_s00_regslice_BREADY;
  wire [1:0]s00_couplers_to_s00_regslice_BRESP;
  wire s00_couplers_to_s00_regslice_BVALID;
  wire [127:0]s00_couplers_to_s00_regslice_RDATA;
  wire s00_couplers_to_s00_regslice_RLAST;
  wire s00_couplers_to_s00_regslice_RREADY;
  wire [1:0]s00_couplers_to_s00_regslice_RRESP;
  wire s00_couplers_to_s00_regslice_RVALID;
  wire [127:0]s00_couplers_to_s00_regslice_WDATA;
  wire s00_couplers_to_s00_regslice_WLAST;
  wire s00_couplers_to_s00_regslice_WREADY;
  wire [15:0]s00_couplers_to_s00_regslice_WSTRB;
  wire s00_couplers_to_s00_regslice_WVALID;
  wire [39:0]s00_data_fifo_to_s00_couplers_ARADDR;
  wire [1:0]s00_data_fifo_to_s00_couplers_ARBURST;
  wire [3:0]s00_data_fifo_to_s00_couplers_ARCACHE;
  wire [7:0]s00_data_fifo_to_s00_couplers_ARLEN;
  wire [0:0]s00_data_fifo_to_s00_couplers_ARLOCK;
  wire [2:0]s00_data_fifo_to_s00_couplers_ARPROT;
  wire [3:0]s00_data_fifo_to_s00_couplers_ARQOS;
  wire s00_data_fifo_to_s00_couplers_ARREADY;
  wire [2:0]s00_data_fifo_to_s00_couplers_ARSIZE;
  wire [0:0]s00_data_fifo_to_s00_couplers_ARUSER;
  wire s00_data_fifo_to_s00_couplers_ARVALID;
  wire [39:0]s00_data_fifo_to_s00_couplers_AWADDR;
  wire [1:0]s00_data_fifo_to_s00_couplers_AWBURST;
  wire [3:0]s00_data_fifo_to_s00_couplers_AWCACHE;
  wire [7:0]s00_data_fifo_to_s00_couplers_AWLEN;
  wire [0:0]s00_data_fifo_to_s00_couplers_AWLOCK;
  wire [2:0]s00_data_fifo_to_s00_couplers_AWPROT;
  wire [3:0]s00_data_fifo_to_s00_couplers_AWQOS;
  wire s00_data_fifo_to_s00_couplers_AWREADY;
  wire [2:0]s00_data_fifo_to_s00_couplers_AWSIZE;
  wire [0:0]s00_data_fifo_to_s00_couplers_AWUSER;
  wire s00_data_fifo_to_s00_couplers_AWVALID;
  wire s00_data_fifo_to_s00_couplers_BREADY;
  wire [1:0]s00_data_fifo_to_s00_couplers_BRESP;
  wire s00_data_fifo_to_s00_couplers_BVALID;
  wire [127:0]s00_data_fifo_to_s00_couplers_RDATA;
  wire s00_data_fifo_to_s00_couplers_RLAST;
  wire s00_data_fifo_to_s00_couplers_RREADY;
  wire [1:0]s00_data_fifo_to_s00_couplers_RRESP;
  wire s00_data_fifo_to_s00_couplers_RVALID;
  wire [127:0]s00_data_fifo_to_s00_couplers_WDATA;
  wire s00_data_fifo_to_s00_couplers_WLAST;
  wire s00_data_fifo_to_s00_couplers_WREADY;
  wire [15:0]s00_data_fifo_to_s00_couplers_WSTRB;
  wire s00_data_fifo_to_s00_couplers_WVALID;
  wire [39:0]s00_regslice_to_auto_cc_ARADDR;
  wire [1:0]s00_regslice_to_auto_cc_ARBURST;
  wire [3:0]s00_regslice_to_auto_cc_ARCACHE;
  wire [7:0]s00_regslice_to_auto_cc_ARLEN;
  wire [0:0]s00_regslice_to_auto_cc_ARLOCK;
  wire [2:0]s00_regslice_to_auto_cc_ARPROT;
  wire [3:0]s00_regslice_to_auto_cc_ARQOS;
  wire s00_regslice_to_auto_cc_ARREADY;
  wire [3:0]s00_regslice_to_auto_cc_ARREGION;
  wire [2:0]s00_regslice_to_auto_cc_ARSIZE;
  wire [0:0]s00_regslice_to_auto_cc_ARUSER;
  wire s00_regslice_to_auto_cc_ARVALID;
  wire [39:0]s00_regslice_to_auto_cc_AWADDR;
  wire [1:0]s00_regslice_to_auto_cc_AWBURST;
  wire [3:0]s00_regslice_to_auto_cc_AWCACHE;
  wire [7:0]s00_regslice_to_auto_cc_AWLEN;
  wire [0:0]s00_regslice_to_auto_cc_AWLOCK;
  wire [2:0]s00_regslice_to_auto_cc_AWPROT;
  wire [3:0]s00_regslice_to_auto_cc_AWQOS;
  wire s00_regslice_to_auto_cc_AWREADY;
  wire [3:0]s00_regslice_to_auto_cc_AWREGION;
  wire [2:0]s00_regslice_to_auto_cc_AWSIZE;
  wire [0:0]s00_regslice_to_auto_cc_AWUSER;
  wire s00_regslice_to_auto_cc_AWVALID;
  wire s00_regslice_to_auto_cc_BREADY;
  wire [1:0]s00_regslice_to_auto_cc_BRESP;
  wire s00_regslice_to_auto_cc_BVALID;
  wire [127:0]s00_regslice_to_auto_cc_RDATA;
  wire s00_regslice_to_auto_cc_RLAST;
  wire s00_regslice_to_auto_cc_RREADY;
  wire [1:0]s00_regslice_to_auto_cc_RRESP;
  wire s00_regslice_to_auto_cc_RVALID;
  wire [127:0]s00_regslice_to_auto_cc_WDATA;
  wire s00_regslice_to_auto_cc_WLAST;
  wire s00_regslice_to_auto_cc_WREADY;
  wire [15:0]s00_regslice_to_auto_cc_WSTRB;
  wire s00_regslice_to_auto_cc_WVALID;

  assign M_ACLK_1 = M_ACLK;
  assign M_ARESETN_1 = M_ARESETN;
  assign M_AXI_araddr[39:0] = s00_data_fifo_to_s00_couplers_ARADDR;
  assign M_AXI_arburst[1:0] = s00_data_fifo_to_s00_couplers_ARBURST;
  assign M_AXI_arcache[3:0] = s00_data_fifo_to_s00_couplers_ARCACHE;
  assign M_AXI_arlen[7:0] = s00_data_fifo_to_s00_couplers_ARLEN;
  assign M_AXI_arlock[0] = s00_data_fifo_to_s00_couplers_ARLOCK;
  assign M_AXI_arprot[2:0] = s00_data_fifo_to_s00_couplers_ARPROT;
  assign M_AXI_arqos[3:0] = s00_data_fifo_to_s00_couplers_ARQOS;
  assign M_AXI_arsize[2:0] = s00_data_fifo_to_s00_couplers_ARSIZE;
  assign M_AXI_aruser[0] = s00_data_fifo_to_s00_couplers_ARUSER;
  assign M_AXI_arvalid = s00_data_fifo_to_s00_couplers_ARVALID;
  assign M_AXI_awaddr[39:0] = s00_data_fifo_to_s00_couplers_AWADDR;
  assign M_AXI_awburst[1:0] = s00_data_fifo_to_s00_couplers_AWBURST;
  assign M_AXI_awcache[3:0] = s00_data_fifo_to_s00_couplers_AWCACHE;
  assign M_AXI_awlen[7:0] = s00_data_fifo_to_s00_couplers_AWLEN;
  assign M_AXI_awlock[0] = s00_data_fifo_to_s00_couplers_AWLOCK;
  assign M_AXI_awprot[2:0] = s00_data_fifo_to_s00_couplers_AWPROT;
  assign M_AXI_awqos[3:0] = s00_data_fifo_to_s00_couplers_AWQOS;
  assign M_AXI_awsize[2:0] = s00_data_fifo_to_s00_couplers_AWSIZE;
  assign M_AXI_awuser[0] = s00_data_fifo_to_s00_couplers_AWUSER;
  assign M_AXI_awvalid = s00_data_fifo_to_s00_couplers_AWVALID;
  assign M_AXI_bready = s00_data_fifo_to_s00_couplers_BREADY;
  assign M_AXI_rready = s00_data_fifo_to_s00_couplers_RREADY;
  assign M_AXI_wdata[127:0] = s00_data_fifo_to_s00_couplers_WDATA;
  assign M_AXI_wlast = s00_data_fifo_to_s00_couplers_WLAST;
  assign M_AXI_wstrb[15:0] = s00_data_fifo_to_s00_couplers_WSTRB;
  assign M_AXI_wvalid = s00_data_fifo_to_s00_couplers_WVALID;
  assign S_ACLK_1 = S_ACLK;
  assign S_ARESETN_1 = S_ARESETN;
  assign S_AXI_arready = s00_couplers_to_s00_regslice_ARREADY;
  assign S_AXI_awready = s00_couplers_to_s00_regslice_AWREADY;
  assign S_AXI_bresp[1:0] = s00_couplers_to_s00_regslice_BRESP;
  assign S_AXI_bvalid = s00_couplers_to_s00_regslice_BVALID;
  assign S_AXI_rdata[127:0] = s00_couplers_to_s00_regslice_RDATA;
  assign S_AXI_rlast = s00_couplers_to_s00_regslice_RLAST;
  assign S_AXI_rresp[1:0] = s00_couplers_to_s00_regslice_RRESP;
  assign S_AXI_rvalid = s00_couplers_to_s00_regslice_RVALID;
  assign S_AXI_wready = s00_couplers_to_s00_regslice_WREADY;
  assign s00_couplers_to_s00_regslice_ARADDR = S_AXI_araddr[39:0];
  assign s00_couplers_to_s00_regslice_ARBURST = S_AXI_arburst[1:0];
  assign s00_couplers_to_s00_regslice_ARCACHE = S_AXI_arcache[3:0];
  assign s00_couplers_to_s00_regslice_ARLEN = S_AXI_arlen[7:0];
  assign s00_couplers_to_s00_regslice_ARLOCK = S_AXI_arlock[0];
  assign s00_couplers_to_s00_regslice_ARPROT = S_AXI_arprot[2:0];
  assign s00_couplers_to_s00_regslice_ARQOS = S_AXI_arqos[3:0];
  assign s00_couplers_to_s00_regslice_ARSIZE = S_AXI_arsize[2:0];
  assign s00_couplers_to_s00_regslice_ARUSER = S_AXI_aruser[0];
  assign s00_couplers_to_s00_regslice_ARVALID = S_AXI_arvalid;
  assign s00_couplers_to_s00_regslice_AWADDR = S_AXI_awaddr[39:0];
  assign s00_couplers_to_s00_regslice_AWBURST = S_AXI_awburst[1:0];
  assign s00_couplers_to_s00_regslice_AWCACHE = S_AXI_awcache[3:0];
  assign s00_couplers_to_s00_regslice_AWLEN = S_AXI_awlen[7:0];
  assign s00_couplers_to_s00_regslice_AWLOCK = S_AXI_awlock[0];
  assign s00_couplers_to_s00_regslice_AWPROT = S_AXI_awprot[2:0];
  assign s00_couplers_to_s00_regslice_AWQOS = S_AXI_awqos[3:0];
  assign s00_couplers_to_s00_regslice_AWSIZE = S_AXI_awsize[2:0];
  assign s00_couplers_to_s00_regslice_AWUSER = S_AXI_awuser[0];
  assign s00_couplers_to_s00_regslice_AWVALID = S_AXI_awvalid;
  assign s00_couplers_to_s00_regslice_BREADY = S_AXI_bready;
  assign s00_couplers_to_s00_regslice_RREADY = S_AXI_rready;
  assign s00_couplers_to_s00_regslice_WDATA = S_AXI_wdata[127:0];
  assign s00_couplers_to_s00_regslice_WLAST = S_AXI_wlast;
  assign s00_couplers_to_s00_regslice_WSTRB = S_AXI_wstrb[15:0];
  assign s00_couplers_to_s00_regslice_WVALID = S_AXI_wvalid;
  assign s00_data_fifo_to_s00_couplers_ARREADY = M_AXI_arready;
  assign s00_data_fifo_to_s00_couplers_AWREADY = M_AXI_awready;
  assign s00_data_fifo_to_s00_couplers_BRESP = M_AXI_bresp[1:0];
  assign s00_data_fifo_to_s00_couplers_BVALID = M_AXI_bvalid;
  assign s00_data_fifo_to_s00_couplers_RDATA = M_AXI_rdata[127:0];
  assign s00_data_fifo_to_s00_couplers_RLAST = M_AXI_rlast;
  assign s00_data_fifo_to_s00_couplers_RRESP = M_AXI_rresp[1:0];
  assign s00_data_fifo_to_s00_couplers_RVALID = M_AXI_rvalid;
  assign s00_data_fifo_to_s00_couplers_WREADY = M_AXI_wready;
  kv260_hardware_platform_auto_cc_5 auto_cc
       (.m_axi_aclk(M_ACLK_1),
        .m_axi_araddr(auto_cc_to_s00_data_fifo_ARADDR),
        .m_axi_arburst(auto_cc_to_s00_data_fifo_ARBURST),
        .m_axi_arcache(auto_cc_to_s00_data_fifo_ARCACHE),
        .m_axi_aresetn(M_ARESETN_1),
        .m_axi_arlen(auto_cc_to_s00_data_fifo_ARLEN),
        .m_axi_arlock(auto_cc_to_s00_data_fifo_ARLOCK),
        .m_axi_arprot(auto_cc_to_s00_data_fifo_ARPROT),
        .m_axi_arqos(auto_cc_to_s00_data_fifo_ARQOS),
        .m_axi_arready(auto_cc_to_s00_data_fifo_ARREADY),
        .m_axi_arregion(auto_cc_to_s00_data_fifo_ARREGION),
        .m_axi_arsize(auto_cc_to_s00_data_fifo_ARSIZE),
        .m_axi_aruser(auto_cc_to_s00_data_fifo_ARUSER),
        .m_axi_arvalid(auto_cc_to_s00_data_fifo_ARVALID),
        .m_axi_awaddr(auto_cc_to_s00_data_fifo_AWADDR),
        .m_axi_awburst(auto_cc_to_s00_data_fifo_AWBURST),
        .m_axi_awcache(auto_cc_to_s00_data_fifo_AWCACHE),
        .m_axi_awlen(auto_cc_to_s00_data_fifo_AWLEN),
        .m_axi_awlock(auto_cc_to_s00_data_fifo_AWLOCK),
        .m_axi_awprot(auto_cc_to_s00_data_fifo_AWPROT),
        .m_axi_awqos(auto_cc_to_s00_data_fifo_AWQOS),
        .m_axi_awready(auto_cc_to_s00_data_fifo_AWREADY),
        .m_axi_awregion(auto_cc_to_s00_data_fifo_AWREGION),
        .m_axi_awsize(auto_cc_to_s00_data_fifo_AWSIZE),
        .m_axi_awuser(auto_cc_to_s00_data_fifo_AWUSER),
        .m_axi_awvalid(auto_cc_to_s00_data_fifo_AWVALID),
        .m_axi_bready(auto_cc_to_s00_data_fifo_BREADY),
        .m_axi_bresp(auto_cc_to_s00_data_fifo_BRESP),
        .m_axi_bvalid(auto_cc_to_s00_data_fifo_BVALID),
        .m_axi_rdata(auto_cc_to_s00_data_fifo_RDATA),
        .m_axi_rlast(auto_cc_to_s00_data_fifo_RLAST),
        .m_axi_rready(auto_cc_to_s00_data_fifo_RREADY),
        .m_axi_rresp(auto_cc_to_s00_data_fifo_RRESP),
        .m_axi_rvalid(auto_cc_to_s00_data_fifo_RVALID),
        .m_axi_wdata(auto_cc_to_s00_data_fifo_WDATA),
        .m_axi_wlast(auto_cc_to_s00_data_fifo_WLAST),
        .m_axi_wready(auto_cc_to_s00_data_fifo_WREADY),
        .m_axi_wstrb(auto_cc_to_s00_data_fifo_WSTRB),
        .m_axi_wvalid(auto_cc_to_s00_data_fifo_WVALID),
        .s_axi_aclk(S_ACLK_1),
        .s_axi_araddr(s00_regslice_to_auto_cc_ARADDR),
        .s_axi_arburst(s00_regslice_to_auto_cc_ARBURST),
        .s_axi_arcache(s00_regslice_to_auto_cc_ARCACHE),
        .s_axi_aresetn(S_ARESETN_1),
        .s_axi_arlen(s00_regslice_to_auto_cc_ARLEN),
        .s_axi_arlock(s00_regslice_to_auto_cc_ARLOCK),
        .s_axi_arprot(s00_regslice_to_auto_cc_ARPROT),
        .s_axi_arqos(s00_regslice_to_auto_cc_ARQOS),
        .s_axi_arready(s00_regslice_to_auto_cc_ARREADY),
        .s_axi_arregion(s00_regslice_to_auto_cc_ARREGION),
        .s_axi_arsize(s00_regslice_to_auto_cc_ARSIZE),
        .s_axi_aruser(s00_regslice_to_auto_cc_ARUSER),
        .s_axi_arvalid(s00_regslice_to_auto_cc_ARVALID),
        .s_axi_awaddr(s00_regslice_to_auto_cc_AWADDR),
        .s_axi_awburst(s00_regslice_to_auto_cc_AWBURST),
        .s_axi_awcache(s00_regslice_to_auto_cc_AWCACHE),
        .s_axi_awlen(s00_regslice_to_auto_cc_AWLEN),
        .s_axi_awlock(s00_regslice_to_auto_cc_AWLOCK),
        .s_axi_awprot(s00_regslice_to_auto_cc_AWPROT),
        .s_axi_awqos(s00_regslice_to_auto_cc_AWQOS),
        .s_axi_awready(s00_regslice_to_auto_cc_AWREADY),
        .s_axi_awregion(s00_regslice_to_auto_cc_AWREGION),
        .s_axi_awsize(s00_regslice_to_auto_cc_AWSIZE),
        .s_axi_awuser(s00_regslice_to_auto_cc_AWUSER),
        .s_axi_awvalid(s00_regslice_to_auto_cc_AWVALID),
        .s_axi_bready(s00_regslice_to_auto_cc_BREADY),
        .s_axi_bresp(s00_regslice_to_auto_cc_BRESP),
        .s_axi_bvalid(s00_regslice_to_auto_cc_BVALID),
        .s_axi_rdata(s00_regslice_to_auto_cc_RDATA),
        .s_axi_rlast(s00_regslice_to_auto_cc_RLAST),
        .s_axi_rready(s00_regslice_to_auto_cc_RREADY),
        .s_axi_rresp(s00_regslice_to_auto_cc_RRESP),
        .s_axi_rvalid(s00_regslice_to_auto_cc_RVALID),
        .s_axi_wdata(s00_regslice_to_auto_cc_WDATA),
        .s_axi_wlast(s00_regslice_to_auto_cc_WLAST),
        .s_axi_wready(s00_regslice_to_auto_cc_WREADY),
        .s_axi_wstrb(s00_regslice_to_auto_cc_WSTRB),
        .s_axi_wvalid(s00_regslice_to_auto_cc_WVALID));
  kv260_hardware_platform_s00_data_fifo_0 s00_data_fifo
       (.aclk(M_ACLK_1),
        .aresetn(M_ARESETN_1),
        .m_axi_araddr(s00_data_fifo_to_s00_couplers_ARADDR),
        .m_axi_arburst(s00_data_fifo_to_s00_couplers_ARBURST),
        .m_axi_arcache(s00_data_fifo_to_s00_couplers_ARCACHE),
        .m_axi_arlen(s00_data_fifo_to_s00_couplers_ARLEN),
        .m_axi_arlock(s00_data_fifo_to_s00_couplers_ARLOCK),
        .m_axi_arprot(s00_data_fifo_to_s00_couplers_ARPROT),
        .m_axi_arqos(s00_data_fifo_to_s00_couplers_ARQOS),
        .m_axi_arready(s00_data_fifo_to_s00_couplers_ARREADY),
        .m_axi_arsize(s00_data_fifo_to_s00_couplers_ARSIZE),
        .m_axi_aruser(s00_data_fifo_to_s00_couplers_ARUSER),
        .m_axi_arvalid(s00_data_fifo_to_s00_couplers_ARVALID),
        .m_axi_awaddr(s00_data_fifo_to_s00_couplers_AWADDR),
        .m_axi_awburst(s00_data_fifo_to_s00_couplers_AWBURST),
        .m_axi_awcache(s00_data_fifo_to_s00_couplers_AWCACHE),
        .m_axi_awlen(s00_data_fifo_to_s00_couplers_AWLEN),
        .m_axi_awlock(s00_data_fifo_to_s00_couplers_AWLOCK),
        .m_axi_awprot(s00_data_fifo_to_s00_couplers_AWPROT),
        .m_axi_awqos(s00_data_fifo_to_s00_couplers_AWQOS),
        .m_axi_awready(s00_data_fifo_to_s00_couplers_AWREADY),
        .m_axi_awsize(s00_data_fifo_to_s00_couplers_AWSIZE),
        .m_axi_awuser(s00_data_fifo_to_s00_couplers_AWUSER),
        .m_axi_awvalid(s00_data_fifo_to_s00_couplers_AWVALID),
        .m_axi_bready(s00_data_fifo_to_s00_couplers_BREADY),
        .m_axi_bresp(s00_data_fifo_to_s00_couplers_BRESP),
        .m_axi_bvalid(s00_data_fifo_to_s00_couplers_BVALID),
        .m_axi_rdata(s00_data_fifo_to_s00_couplers_RDATA),
        .m_axi_rlast(s00_data_fifo_to_s00_couplers_RLAST),
        .m_axi_rready(s00_data_fifo_to_s00_couplers_RREADY),
        .m_axi_rresp(s00_data_fifo_to_s00_couplers_RRESP),
        .m_axi_rvalid(s00_data_fifo_to_s00_couplers_RVALID),
        .m_axi_wdata(s00_data_fifo_to_s00_couplers_WDATA),
        .m_axi_wlast(s00_data_fifo_to_s00_couplers_WLAST),
        .m_axi_wready(s00_data_fifo_to_s00_couplers_WREADY),
        .m_axi_wstrb(s00_data_fifo_to_s00_couplers_WSTRB),
        .m_axi_wvalid(s00_data_fifo_to_s00_couplers_WVALID),
        .s_axi_araddr(auto_cc_to_s00_data_fifo_ARADDR),
        .s_axi_arburst(auto_cc_to_s00_data_fifo_ARBURST),
        .s_axi_arcache(auto_cc_to_s00_data_fifo_ARCACHE),
        .s_axi_arlen(auto_cc_to_s00_data_fifo_ARLEN),
        .s_axi_arlock(auto_cc_to_s00_data_fifo_ARLOCK),
        .s_axi_arprot(auto_cc_to_s00_data_fifo_ARPROT),
        .s_axi_arqos(auto_cc_to_s00_data_fifo_ARQOS),
        .s_axi_arready(auto_cc_to_s00_data_fifo_ARREADY),
        .s_axi_arregion(auto_cc_to_s00_data_fifo_ARREGION),
        .s_axi_arsize(auto_cc_to_s00_data_fifo_ARSIZE),
        .s_axi_aruser(auto_cc_to_s00_data_fifo_ARUSER),
        .s_axi_arvalid(auto_cc_to_s00_data_fifo_ARVALID),
        .s_axi_awaddr(auto_cc_to_s00_data_fifo_AWADDR),
        .s_axi_awburst(auto_cc_to_s00_data_fifo_AWBURST),
        .s_axi_awcache(auto_cc_to_s00_data_fifo_AWCACHE),
        .s_axi_awlen(auto_cc_to_s00_data_fifo_AWLEN),
        .s_axi_awlock(auto_cc_to_s00_data_fifo_AWLOCK),
        .s_axi_awprot(auto_cc_to_s00_data_fifo_AWPROT),
        .s_axi_awqos(auto_cc_to_s00_data_fifo_AWQOS),
        .s_axi_awready(auto_cc_to_s00_data_fifo_AWREADY),
        .s_axi_awregion(auto_cc_to_s00_data_fifo_AWREGION),
        .s_axi_awsize(auto_cc_to_s00_data_fifo_AWSIZE),
        .s_axi_awuser(auto_cc_to_s00_data_fifo_AWUSER),
        .s_axi_awvalid(auto_cc_to_s00_data_fifo_AWVALID),
        .s_axi_bready(auto_cc_to_s00_data_fifo_BREADY),
        .s_axi_bresp(auto_cc_to_s00_data_fifo_BRESP),
        .s_axi_bvalid(auto_cc_to_s00_data_fifo_BVALID),
        .s_axi_rdata(auto_cc_to_s00_data_fifo_RDATA),
        .s_axi_rlast(auto_cc_to_s00_data_fifo_RLAST),
        .s_axi_rready(auto_cc_to_s00_data_fifo_RREADY),
        .s_axi_rresp(auto_cc_to_s00_data_fifo_RRESP),
        .s_axi_rvalid(auto_cc_to_s00_data_fifo_RVALID),
        .s_axi_wdata(auto_cc_to_s00_data_fifo_WDATA),
        .s_axi_wlast(auto_cc_to_s00_data_fifo_WLAST),
        .s_axi_wready(auto_cc_to_s00_data_fifo_WREADY),
        .s_axi_wstrb(auto_cc_to_s00_data_fifo_WSTRB),
        .s_axi_wvalid(auto_cc_to_s00_data_fifo_WVALID));
  kv260_hardware_platform_s00_regslice_0 s00_regslice
       (.aclk(S_ACLK_1),
        .aresetn(S_ARESETN_1),
        .m_axi_araddr(s00_regslice_to_auto_cc_ARADDR),
        .m_axi_arburst(s00_regslice_to_auto_cc_ARBURST),
        .m_axi_arcache(s00_regslice_to_auto_cc_ARCACHE),
        .m_axi_arlen(s00_regslice_to_auto_cc_ARLEN),
        .m_axi_arlock(s00_regslice_to_auto_cc_ARLOCK),
        .m_axi_arprot(s00_regslice_to_auto_cc_ARPROT),
        .m_axi_arqos(s00_regslice_to_auto_cc_ARQOS),
        .m_axi_arready(s00_regslice_to_auto_cc_ARREADY),
        .m_axi_arregion(s00_regslice_to_auto_cc_ARREGION),
        .m_axi_arsize(s00_regslice_to_auto_cc_ARSIZE),
        .m_axi_aruser(s00_regslice_to_auto_cc_ARUSER),
        .m_axi_arvalid(s00_regslice_to_auto_cc_ARVALID),
        .m_axi_awaddr(s00_regslice_to_auto_cc_AWADDR),
        .m_axi_awburst(s00_regslice_to_auto_cc_AWBURST),
        .m_axi_awcache(s00_regslice_to_auto_cc_AWCACHE),
        .m_axi_awlen(s00_regslice_to_auto_cc_AWLEN),
        .m_axi_awlock(s00_regslice_to_auto_cc_AWLOCK),
        .m_axi_awprot(s00_regslice_to_auto_cc_AWPROT),
        .m_axi_awqos(s00_regslice_to_auto_cc_AWQOS),
        .m_axi_awready(s00_regslice_to_auto_cc_AWREADY),
        .m_axi_awregion(s00_regslice_to_auto_cc_AWREGION),
        .m_axi_awsize(s00_regslice_to_auto_cc_AWSIZE),
        .m_axi_awuser(s00_regslice_to_auto_cc_AWUSER),
        .m_axi_awvalid(s00_regslice_to_auto_cc_AWVALID),
        .m_axi_bready(s00_regslice_to_auto_cc_BREADY),
        .m_axi_bresp(s00_regslice_to_auto_cc_BRESP),
        .m_axi_bvalid(s00_regslice_to_auto_cc_BVALID),
        .m_axi_rdata(s00_regslice_to_auto_cc_RDATA),
        .m_axi_rlast(s00_regslice_to_auto_cc_RLAST),
        .m_axi_rready(s00_regslice_to_auto_cc_RREADY),
        .m_axi_rresp(s00_regslice_to_auto_cc_RRESP),
        .m_axi_rvalid(s00_regslice_to_auto_cc_RVALID),
        .m_axi_wdata(s00_regslice_to_auto_cc_WDATA),
        .m_axi_wlast(s00_regslice_to_auto_cc_WLAST),
        .m_axi_wready(s00_regslice_to_auto_cc_WREADY),
        .m_axi_wstrb(s00_regslice_to_auto_cc_WSTRB),
        .m_axi_wvalid(s00_regslice_to_auto_cc_WVALID),
        .s_axi_araddr(s00_couplers_to_s00_regslice_ARADDR),
        .s_axi_arburst(s00_couplers_to_s00_regslice_ARBURST),
        .s_axi_arcache(s00_couplers_to_s00_regslice_ARCACHE),
        .s_axi_arlen(s00_couplers_to_s00_regslice_ARLEN),
        .s_axi_arlock(s00_couplers_to_s00_regslice_ARLOCK),
        .s_axi_arprot(s00_couplers_to_s00_regslice_ARPROT),
        .s_axi_arqos(s00_couplers_to_s00_regslice_ARQOS),
        .s_axi_arready(s00_couplers_to_s00_regslice_ARREADY),
        .s_axi_arregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arsize(s00_couplers_to_s00_regslice_ARSIZE),
        .s_axi_aruser(s00_couplers_to_s00_regslice_ARUSER),
        .s_axi_arvalid(s00_couplers_to_s00_regslice_ARVALID),
        .s_axi_awaddr(s00_couplers_to_s00_regslice_AWADDR),
        .s_axi_awburst(s00_couplers_to_s00_regslice_AWBURST),
        .s_axi_awcache(s00_couplers_to_s00_regslice_AWCACHE),
        .s_axi_awlen(s00_couplers_to_s00_regslice_AWLEN),
        .s_axi_awlock(s00_couplers_to_s00_regslice_AWLOCK),
        .s_axi_awprot(s00_couplers_to_s00_regslice_AWPROT),
        .s_axi_awqos(s00_couplers_to_s00_regslice_AWQOS),
        .s_axi_awready(s00_couplers_to_s00_regslice_AWREADY),
        .s_axi_awregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awsize(s00_couplers_to_s00_regslice_AWSIZE),
        .s_axi_awuser(s00_couplers_to_s00_regslice_AWUSER),
        .s_axi_awvalid(s00_couplers_to_s00_regslice_AWVALID),
        .s_axi_bready(s00_couplers_to_s00_regslice_BREADY),
        .s_axi_bresp(s00_couplers_to_s00_regslice_BRESP),
        .s_axi_bvalid(s00_couplers_to_s00_regslice_BVALID),
        .s_axi_rdata(s00_couplers_to_s00_regslice_RDATA),
        .s_axi_rlast(s00_couplers_to_s00_regslice_RLAST),
        .s_axi_rready(s00_couplers_to_s00_regslice_RREADY),
        .s_axi_rresp(s00_couplers_to_s00_regslice_RRESP),
        .s_axi_rvalid(s00_couplers_to_s00_regslice_RVALID),
        .s_axi_wdata(s00_couplers_to_s00_regslice_WDATA),
        .s_axi_wlast(s00_couplers_to_s00_regslice_WLAST),
        .s_axi_wready(s00_couplers_to_s00_regslice_WREADY),
        .s_axi_wstrb(s00_couplers_to_s00_regslice_WSTRB),
        .s_axi_wvalid(s00_couplers_to_s00_regslice_WVALID));
endmodule

module s00_couplers_imp_1WG0C8D
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arprot,
    M_AXI_arready,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awprot,
    M_AXI_awready,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arburst,
    S_AXI_arcache,
    S_AXI_arid,
    S_AXI_arlen,
    S_AXI_arlock,
    S_AXI_arprot,
    S_AXI_arqos,
    S_AXI_arready,
    S_AXI_arsize,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awburst,
    S_AXI_awcache,
    S_AXI_awid,
    S_AXI_awlen,
    S_AXI_awlock,
    S_AXI_awprot,
    S_AXI_awqos,
    S_AXI_awready,
    S_AXI_awsize,
    S_AXI_awvalid,
    S_AXI_bid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rid,
    S_AXI_rlast,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wlast,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [39:0]M_AXI_araddr;
  output [2:0]M_AXI_arprot;
  input M_AXI_arready;
  output M_AXI_arvalid;
  output [39:0]M_AXI_awaddr;
  output [2:0]M_AXI_awprot;
  input M_AXI_awready;
  output M_AXI_awvalid;
  output M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input M_AXI_bvalid;
  input [31:0]M_AXI_rdata;
  output M_AXI_rready;
  input [1:0]M_AXI_rresp;
  input M_AXI_rvalid;
  output [31:0]M_AXI_wdata;
  input M_AXI_wready;
  output [3:0]M_AXI_wstrb;
  output M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input [39:0]S_AXI_araddr;
  input [1:0]S_AXI_arburst;
  input [3:0]S_AXI_arcache;
  input [15:0]S_AXI_arid;
  input [7:0]S_AXI_arlen;
  input [0:0]S_AXI_arlock;
  input [2:0]S_AXI_arprot;
  input [3:0]S_AXI_arqos;
  output S_AXI_arready;
  input [2:0]S_AXI_arsize;
  input S_AXI_arvalid;
  input [39:0]S_AXI_awaddr;
  input [1:0]S_AXI_awburst;
  input [3:0]S_AXI_awcache;
  input [15:0]S_AXI_awid;
  input [7:0]S_AXI_awlen;
  input [0:0]S_AXI_awlock;
  input [2:0]S_AXI_awprot;
  input [3:0]S_AXI_awqos;
  output S_AXI_awready;
  input [2:0]S_AXI_awsize;
  input S_AXI_awvalid;
  output [15:0]S_AXI_bid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output S_AXI_bvalid;
  output [31:0]S_AXI_rdata;
  output [15:0]S_AXI_rid;
  output S_AXI_rlast;
  input S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output S_AXI_rvalid;
  input [31:0]S_AXI_wdata;
  input S_AXI_wlast;
  output S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input S_AXI_wvalid;

  wire S_ACLK_1;
  wire S_ARESETN_1;
  wire [39:0]auto_pc_to_s00_couplers_ARADDR;
  wire [2:0]auto_pc_to_s00_couplers_ARPROT;
  wire auto_pc_to_s00_couplers_ARREADY;
  wire auto_pc_to_s00_couplers_ARVALID;
  wire [39:0]auto_pc_to_s00_couplers_AWADDR;
  wire [2:0]auto_pc_to_s00_couplers_AWPROT;
  wire auto_pc_to_s00_couplers_AWREADY;
  wire auto_pc_to_s00_couplers_AWVALID;
  wire auto_pc_to_s00_couplers_BREADY;
  wire [1:0]auto_pc_to_s00_couplers_BRESP;
  wire auto_pc_to_s00_couplers_BVALID;
  wire [31:0]auto_pc_to_s00_couplers_RDATA;
  wire auto_pc_to_s00_couplers_RREADY;
  wire [1:0]auto_pc_to_s00_couplers_RRESP;
  wire auto_pc_to_s00_couplers_RVALID;
  wire [31:0]auto_pc_to_s00_couplers_WDATA;
  wire auto_pc_to_s00_couplers_WREADY;
  wire [3:0]auto_pc_to_s00_couplers_WSTRB;
  wire auto_pc_to_s00_couplers_WVALID;
  wire [39:0]s00_couplers_to_auto_pc_ARADDR;
  wire [1:0]s00_couplers_to_auto_pc_ARBURST;
  wire [3:0]s00_couplers_to_auto_pc_ARCACHE;
  wire [15:0]s00_couplers_to_auto_pc_ARID;
  wire [7:0]s00_couplers_to_auto_pc_ARLEN;
  wire [0:0]s00_couplers_to_auto_pc_ARLOCK;
  wire [2:0]s00_couplers_to_auto_pc_ARPROT;
  wire [3:0]s00_couplers_to_auto_pc_ARQOS;
  wire s00_couplers_to_auto_pc_ARREADY;
  wire [2:0]s00_couplers_to_auto_pc_ARSIZE;
  wire s00_couplers_to_auto_pc_ARVALID;
  wire [39:0]s00_couplers_to_auto_pc_AWADDR;
  wire [1:0]s00_couplers_to_auto_pc_AWBURST;
  wire [3:0]s00_couplers_to_auto_pc_AWCACHE;
  wire [15:0]s00_couplers_to_auto_pc_AWID;
  wire [7:0]s00_couplers_to_auto_pc_AWLEN;
  wire [0:0]s00_couplers_to_auto_pc_AWLOCK;
  wire [2:0]s00_couplers_to_auto_pc_AWPROT;
  wire [3:0]s00_couplers_to_auto_pc_AWQOS;
  wire s00_couplers_to_auto_pc_AWREADY;
  wire [2:0]s00_couplers_to_auto_pc_AWSIZE;
  wire s00_couplers_to_auto_pc_AWVALID;
  wire [15:0]s00_couplers_to_auto_pc_BID;
  wire s00_couplers_to_auto_pc_BREADY;
  wire [1:0]s00_couplers_to_auto_pc_BRESP;
  wire s00_couplers_to_auto_pc_BVALID;
  wire [31:0]s00_couplers_to_auto_pc_RDATA;
  wire [15:0]s00_couplers_to_auto_pc_RID;
  wire s00_couplers_to_auto_pc_RLAST;
  wire s00_couplers_to_auto_pc_RREADY;
  wire [1:0]s00_couplers_to_auto_pc_RRESP;
  wire s00_couplers_to_auto_pc_RVALID;
  wire [31:0]s00_couplers_to_auto_pc_WDATA;
  wire s00_couplers_to_auto_pc_WLAST;
  wire s00_couplers_to_auto_pc_WREADY;
  wire [3:0]s00_couplers_to_auto_pc_WSTRB;
  wire s00_couplers_to_auto_pc_WVALID;

  assign M_AXI_araddr[39:0] = auto_pc_to_s00_couplers_ARADDR;
  assign M_AXI_arprot[2:0] = auto_pc_to_s00_couplers_ARPROT;
  assign M_AXI_arvalid = auto_pc_to_s00_couplers_ARVALID;
  assign M_AXI_awaddr[39:0] = auto_pc_to_s00_couplers_AWADDR;
  assign M_AXI_awprot[2:0] = auto_pc_to_s00_couplers_AWPROT;
  assign M_AXI_awvalid = auto_pc_to_s00_couplers_AWVALID;
  assign M_AXI_bready = auto_pc_to_s00_couplers_BREADY;
  assign M_AXI_rready = auto_pc_to_s00_couplers_RREADY;
  assign M_AXI_wdata[31:0] = auto_pc_to_s00_couplers_WDATA;
  assign M_AXI_wstrb[3:0] = auto_pc_to_s00_couplers_WSTRB;
  assign M_AXI_wvalid = auto_pc_to_s00_couplers_WVALID;
  assign S_ACLK_1 = S_ACLK;
  assign S_ARESETN_1 = S_ARESETN;
  assign S_AXI_arready = s00_couplers_to_auto_pc_ARREADY;
  assign S_AXI_awready = s00_couplers_to_auto_pc_AWREADY;
  assign S_AXI_bid[15:0] = s00_couplers_to_auto_pc_BID;
  assign S_AXI_bresp[1:0] = s00_couplers_to_auto_pc_BRESP;
  assign S_AXI_bvalid = s00_couplers_to_auto_pc_BVALID;
  assign S_AXI_rdata[31:0] = s00_couplers_to_auto_pc_RDATA;
  assign S_AXI_rid[15:0] = s00_couplers_to_auto_pc_RID;
  assign S_AXI_rlast = s00_couplers_to_auto_pc_RLAST;
  assign S_AXI_rresp[1:0] = s00_couplers_to_auto_pc_RRESP;
  assign S_AXI_rvalid = s00_couplers_to_auto_pc_RVALID;
  assign S_AXI_wready = s00_couplers_to_auto_pc_WREADY;
  assign auto_pc_to_s00_couplers_ARREADY = M_AXI_arready;
  assign auto_pc_to_s00_couplers_AWREADY = M_AXI_awready;
  assign auto_pc_to_s00_couplers_BRESP = M_AXI_bresp[1:0];
  assign auto_pc_to_s00_couplers_BVALID = M_AXI_bvalid;
  assign auto_pc_to_s00_couplers_RDATA = M_AXI_rdata[31:0];
  assign auto_pc_to_s00_couplers_RRESP = M_AXI_rresp[1:0];
  assign auto_pc_to_s00_couplers_RVALID = M_AXI_rvalid;
  assign auto_pc_to_s00_couplers_WREADY = M_AXI_wready;
  assign s00_couplers_to_auto_pc_ARADDR = S_AXI_araddr[39:0];
  assign s00_couplers_to_auto_pc_ARBURST = S_AXI_arburst[1:0];
  assign s00_couplers_to_auto_pc_ARCACHE = S_AXI_arcache[3:0];
  assign s00_couplers_to_auto_pc_ARID = S_AXI_arid[15:0];
  assign s00_couplers_to_auto_pc_ARLEN = S_AXI_arlen[7:0];
  assign s00_couplers_to_auto_pc_ARLOCK = S_AXI_arlock[0];
  assign s00_couplers_to_auto_pc_ARPROT = S_AXI_arprot[2:0];
  assign s00_couplers_to_auto_pc_ARQOS = S_AXI_arqos[3:0];
  assign s00_couplers_to_auto_pc_ARSIZE = S_AXI_arsize[2:0];
  assign s00_couplers_to_auto_pc_ARVALID = S_AXI_arvalid;
  assign s00_couplers_to_auto_pc_AWADDR = S_AXI_awaddr[39:0];
  assign s00_couplers_to_auto_pc_AWBURST = S_AXI_awburst[1:0];
  assign s00_couplers_to_auto_pc_AWCACHE = S_AXI_awcache[3:0];
  assign s00_couplers_to_auto_pc_AWID = S_AXI_awid[15:0];
  assign s00_couplers_to_auto_pc_AWLEN = S_AXI_awlen[7:0];
  assign s00_couplers_to_auto_pc_AWLOCK = S_AXI_awlock[0];
  assign s00_couplers_to_auto_pc_AWPROT = S_AXI_awprot[2:0];
  assign s00_couplers_to_auto_pc_AWQOS = S_AXI_awqos[3:0];
  assign s00_couplers_to_auto_pc_AWSIZE = S_AXI_awsize[2:0];
  assign s00_couplers_to_auto_pc_AWVALID = S_AXI_awvalid;
  assign s00_couplers_to_auto_pc_BREADY = S_AXI_bready;
  assign s00_couplers_to_auto_pc_RREADY = S_AXI_rready;
  assign s00_couplers_to_auto_pc_WDATA = S_AXI_wdata[31:0];
  assign s00_couplers_to_auto_pc_WLAST = S_AXI_wlast;
  assign s00_couplers_to_auto_pc_WSTRB = S_AXI_wstrb[3:0];
  assign s00_couplers_to_auto_pc_WVALID = S_AXI_wvalid;
  kv260_hardware_platform_auto_pc_0 auto_pc
       (.aclk(S_ACLK_1),
        .aresetn(S_ARESETN_1),
        .m_axi_araddr(auto_pc_to_s00_couplers_ARADDR),
        .m_axi_arprot(auto_pc_to_s00_couplers_ARPROT),
        .m_axi_arready(auto_pc_to_s00_couplers_ARREADY),
        .m_axi_arvalid(auto_pc_to_s00_couplers_ARVALID),
        .m_axi_awaddr(auto_pc_to_s00_couplers_AWADDR),
        .m_axi_awprot(auto_pc_to_s00_couplers_AWPROT),
        .m_axi_awready(auto_pc_to_s00_couplers_AWREADY),
        .m_axi_awvalid(auto_pc_to_s00_couplers_AWVALID),
        .m_axi_bready(auto_pc_to_s00_couplers_BREADY),
        .m_axi_bresp(auto_pc_to_s00_couplers_BRESP),
        .m_axi_bvalid(auto_pc_to_s00_couplers_BVALID),
        .m_axi_rdata(auto_pc_to_s00_couplers_RDATA),
        .m_axi_rready(auto_pc_to_s00_couplers_RREADY),
        .m_axi_rresp(auto_pc_to_s00_couplers_RRESP),
        .m_axi_rvalid(auto_pc_to_s00_couplers_RVALID),
        .m_axi_wdata(auto_pc_to_s00_couplers_WDATA),
        .m_axi_wready(auto_pc_to_s00_couplers_WREADY),
        .m_axi_wstrb(auto_pc_to_s00_couplers_WSTRB),
        .m_axi_wvalid(auto_pc_to_s00_couplers_WVALID),
        .s_axi_araddr(s00_couplers_to_auto_pc_ARADDR),
        .s_axi_arburst(s00_couplers_to_auto_pc_ARBURST),
        .s_axi_arcache(s00_couplers_to_auto_pc_ARCACHE),
        .s_axi_arid(s00_couplers_to_auto_pc_ARID),
        .s_axi_arlen(s00_couplers_to_auto_pc_ARLEN),
        .s_axi_arlock(s00_couplers_to_auto_pc_ARLOCK),
        .s_axi_arprot(s00_couplers_to_auto_pc_ARPROT),
        .s_axi_arqos(s00_couplers_to_auto_pc_ARQOS),
        .s_axi_arready(s00_couplers_to_auto_pc_ARREADY),
        .s_axi_arregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arsize(s00_couplers_to_auto_pc_ARSIZE),
        .s_axi_arvalid(s00_couplers_to_auto_pc_ARVALID),
        .s_axi_awaddr(s00_couplers_to_auto_pc_AWADDR),
        .s_axi_awburst(s00_couplers_to_auto_pc_AWBURST),
        .s_axi_awcache(s00_couplers_to_auto_pc_AWCACHE),
        .s_axi_awid(s00_couplers_to_auto_pc_AWID),
        .s_axi_awlen(s00_couplers_to_auto_pc_AWLEN),
        .s_axi_awlock(s00_couplers_to_auto_pc_AWLOCK),
        .s_axi_awprot(s00_couplers_to_auto_pc_AWPROT),
        .s_axi_awqos(s00_couplers_to_auto_pc_AWQOS),
        .s_axi_awready(s00_couplers_to_auto_pc_AWREADY),
        .s_axi_awregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awsize(s00_couplers_to_auto_pc_AWSIZE),
        .s_axi_awvalid(s00_couplers_to_auto_pc_AWVALID),
        .s_axi_bid(s00_couplers_to_auto_pc_BID),
        .s_axi_bready(s00_couplers_to_auto_pc_BREADY),
        .s_axi_bresp(s00_couplers_to_auto_pc_BRESP),
        .s_axi_bvalid(s00_couplers_to_auto_pc_BVALID),
        .s_axi_rdata(s00_couplers_to_auto_pc_RDATA),
        .s_axi_rid(s00_couplers_to_auto_pc_RID),
        .s_axi_rlast(s00_couplers_to_auto_pc_RLAST),
        .s_axi_rready(s00_couplers_to_auto_pc_RREADY),
        .s_axi_rresp(s00_couplers_to_auto_pc_RRESP),
        .s_axi_rvalid(s00_couplers_to_auto_pc_RVALID),
        .s_axi_wdata(s00_couplers_to_auto_pc_WDATA),
        .s_axi_wlast(s00_couplers_to_auto_pc_WLAST),
        .s_axi_wready(s00_couplers_to_auto_pc_WREADY),
        .s_axi_wstrb(s00_couplers_to_auto_pc_WSTRB),
        .s_axi_wvalid(s00_couplers_to_auto_pc_WVALID));
endmodule

module s00_couplers_imp_1X593XB
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arburst,
    M_AXI_arcache,
    M_AXI_arlen,
    M_AXI_arlock,
    M_AXI_arprot,
    M_AXI_arqos,
    M_AXI_arready,
    M_AXI_arsize,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awburst,
    M_AXI_awcache,
    M_AXI_awlen,
    M_AXI_awlock,
    M_AXI_awprot,
    M_AXI_awqos,
    M_AXI_awready,
    M_AXI_awsize,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rlast,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wlast,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arburst,
    S_AXI_arcache,
    S_AXI_arlen,
    S_AXI_arlock,
    S_AXI_arprot,
    S_AXI_arqos,
    S_AXI_arready,
    S_AXI_arsize,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awburst,
    S_AXI_awcache,
    S_AXI_awlen,
    S_AXI_awlock,
    S_AXI_awprot,
    S_AXI_awqos,
    S_AXI_awready,
    S_AXI_awsize,
    S_AXI_awvalid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rlast,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wlast,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [39:0]M_AXI_araddr;
  output [1:0]M_AXI_arburst;
  output [3:0]M_AXI_arcache;
  output [7:0]M_AXI_arlen;
  output [0:0]M_AXI_arlock;
  output [2:0]M_AXI_arprot;
  output [3:0]M_AXI_arqos;
  input M_AXI_arready;
  output [2:0]M_AXI_arsize;
  output M_AXI_arvalid;
  output [39:0]M_AXI_awaddr;
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
  input S_ACLK;
  input S_ARESETN;
  input [39:0]S_AXI_araddr;
  input [1:0]S_AXI_arburst;
  input [3:0]S_AXI_arcache;
  input [7:0]S_AXI_arlen;
  input [0:0]S_AXI_arlock;
  input [2:0]S_AXI_arprot;
  input [3:0]S_AXI_arqos;
  output S_AXI_arready;
  input [2:0]S_AXI_arsize;
  input S_AXI_arvalid;
  input [39:0]S_AXI_awaddr;
  input [1:0]S_AXI_awburst;
  input [3:0]S_AXI_awcache;
  input [7:0]S_AXI_awlen;
  input [0:0]S_AXI_awlock;
  input [2:0]S_AXI_awprot;
  input [3:0]S_AXI_awqos;
  output S_AXI_awready;
  input [2:0]S_AXI_awsize;
  input S_AXI_awvalid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output S_AXI_bvalid;
  output [31:0]S_AXI_rdata;
  output S_AXI_rlast;
  input S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output S_AXI_rvalid;
  input [31:0]S_AXI_wdata;
  input S_AXI_wlast;
  output S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input S_AXI_wvalid;

  wire S_ACLK_1;
  wire S_ARESETN_1;
  wire [39:0]auto_us_to_s00_couplers_ARADDR;
  wire [1:0]auto_us_to_s00_couplers_ARBURST;
  wire [3:0]auto_us_to_s00_couplers_ARCACHE;
  wire [7:0]auto_us_to_s00_couplers_ARLEN;
  wire [0:0]auto_us_to_s00_couplers_ARLOCK;
  wire [2:0]auto_us_to_s00_couplers_ARPROT;
  wire [3:0]auto_us_to_s00_couplers_ARQOS;
  wire auto_us_to_s00_couplers_ARREADY;
  wire [2:0]auto_us_to_s00_couplers_ARSIZE;
  wire auto_us_to_s00_couplers_ARVALID;
  wire [39:0]auto_us_to_s00_couplers_AWADDR;
  wire [1:0]auto_us_to_s00_couplers_AWBURST;
  wire [3:0]auto_us_to_s00_couplers_AWCACHE;
  wire [7:0]auto_us_to_s00_couplers_AWLEN;
  wire [0:0]auto_us_to_s00_couplers_AWLOCK;
  wire [2:0]auto_us_to_s00_couplers_AWPROT;
  wire [3:0]auto_us_to_s00_couplers_AWQOS;
  wire auto_us_to_s00_couplers_AWREADY;
  wire [2:0]auto_us_to_s00_couplers_AWSIZE;
  wire auto_us_to_s00_couplers_AWVALID;
  wire auto_us_to_s00_couplers_BREADY;
  wire [1:0]auto_us_to_s00_couplers_BRESP;
  wire auto_us_to_s00_couplers_BVALID;
  wire [127:0]auto_us_to_s00_couplers_RDATA;
  wire auto_us_to_s00_couplers_RLAST;
  wire auto_us_to_s00_couplers_RREADY;
  wire [1:0]auto_us_to_s00_couplers_RRESP;
  wire auto_us_to_s00_couplers_RVALID;
  wire [127:0]auto_us_to_s00_couplers_WDATA;
  wire auto_us_to_s00_couplers_WLAST;
  wire auto_us_to_s00_couplers_WREADY;
  wire [15:0]auto_us_to_s00_couplers_WSTRB;
  wire auto_us_to_s00_couplers_WVALID;
  wire [39:0]s00_couplers_to_auto_us_ARADDR;
  wire [1:0]s00_couplers_to_auto_us_ARBURST;
  wire [3:0]s00_couplers_to_auto_us_ARCACHE;
  wire [7:0]s00_couplers_to_auto_us_ARLEN;
  wire [0:0]s00_couplers_to_auto_us_ARLOCK;
  wire [2:0]s00_couplers_to_auto_us_ARPROT;
  wire [3:0]s00_couplers_to_auto_us_ARQOS;
  wire s00_couplers_to_auto_us_ARREADY;
  wire [2:0]s00_couplers_to_auto_us_ARSIZE;
  wire s00_couplers_to_auto_us_ARVALID;
  wire [39:0]s00_couplers_to_auto_us_AWADDR;
  wire [1:0]s00_couplers_to_auto_us_AWBURST;
  wire [3:0]s00_couplers_to_auto_us_AWCACHE;
  wire [7:0]s00_couplers_to_auto_us_AWLEN;
  wire [0:0]s00_couplers_to_auto_us_AWLOCK;
  wire [2:0]s00_couplers_to_auto_us_AWPROT;
  wire [3:0]s00_couplers_to_auto_us_AWQOS;
  wire s00_couplers_to_auto_us_AWREADY;
  wire [2:0]s00_couplers_to_auto_us_AWSIZE;
  wire s00_couplers_to_auto_us_AWVALID;
  wire s00_couplers_to_auto_us_BREADY;
  wire [1:0]s00_couplers_to_auto_us_BRESP;
  wire s00_couplers_to_auto_us_BVALID;
  wire [31:0]s00_couplers_to_auto_us_RDATA;
  wire s00_couplers_to_auto_us_RLAST;
  wire s00_couplers_to_auto_us_RREADY;
  wire [1:0]s00_couplers_to_auto_us_RRESP;
  wire s00_couplers_to_auto_us_RVALID;
  wire [31:0]s00_couplers_to_auto_us_WDATA;
  wire s00_couplers_to_auto_us_WLAST;
  wire s00_couplers_to_auto_us_WREADY;
  wire [3:0]s00_couplers_to_auto_us_WSTRB;
  wire s00_couplers_to_auto_us_WVALID;

  assign M_AXI_araddr[39:0] = auto_us_to_s00_couplers_ARADDR;
  assign M_AXI_arburst[1:0] = auto_us_to_s00_couplers_ARBURST;
  assign M_AXI_arcache[3:0] = auto_us_to_s00_couplers_ARCACHE;
  assign M_AXI_arlen[7:0] = auto_us_to_s00_couplers_ARLEN;
  assign M_AXI_arlock[0] = auto_us_to_s00_couplers_ARLOCK;
  assign M_AXI_arprot[2:0] = auto_us_to_s00_couplers_ARPROT;
  assign M_AXI_arqos[3:0] = auto_us_to_s00_couplers_ARQOS;
  assign M_AXI_arsize[2:0] = auto_us_to_s00_couplers_ARSIZE;
  assign M_AXI_arvalid = auto_us_to_s00_couplers_ARVALID;
  assign M_AXI_awaddr[39:0] = auto_us_to_s00_couplers_AWADDR;
  assign M_AXI_awburst[1:0] = auto_us_to_s00_couplers_AWBURST;
  assign M_AXI_awcache[3:0] = auto_us_to_s00_couplers_AWCACHE;
  assign M_AXI_awlen[7:0] = auto_us_to_s00_couplers_AWLEN;
  assign M_AXI_awlock[0] = auto_us_to_s00_couplers_AWLOCK;
  assign M_AXI_awprot[2:0] = auto_us_to_s00_couplers_AWPROT;
  assign M_AXI_awqos[3:0] = auto_us_to_s00_couplers_AWQOS;
  assign M_AXI_awsize[2:0] = auto_us_to_s00_couplers_AWSIZE;
  assign M_AXI_awvalid = auto_us_to_s00_couplers_AWVALID;
  assign M_AXI_bready = auto_us_to_s00_couplers_BREADY;
  assign M_AXI_rready = auto_us_to_s00_couplers_RREADY;
  assign M_AXI_wdata[127:0] = auto_us_to_s00_couplers_WDATA;
  assign M_AXI_wlast = auto_us_to_s00_couplers_WLAST;
  assign M_AXI_wstrb[15:0] = auto_us_to_s00_couplers_WSTRB;
  assign M_AXI_wvalid = auto_us_to_s00_couplers_WVALID;
  assign S_ACLK_1 = S_ACLK;
  assign S_ARESETN_1 = S_ARESETN;
  assign S_AXI_arready = s00_couplers_to_auto_us_ARREADY;
  assign S_AXI_awready = s00_couplers_to_auto_us_AWREADY;
  assign S_AXI_bresp[1:0] = s00_couplers_to_auto_us_BRESP;
  assign S_AXI_bvalid = s00_couplers_to_auto_us_BVALID;
  assign S_AXI_rdata[31:0] = s00_couplers_to_auto_us_RDATA;
  assign S_AXI_rlast = s00_couplers_to_auto_us_RLAST;
  assign S_AXI_rresp[1:0] = s00_couplers_to_auto_us_RRESP;
  assign S_AXI_rvalid = s00_couplers_to_auto_us_RVALID;
  assign S_AXI_wready = s00_couplers_to_auto_us_WREADY;
  assign auto_us_to_s00_couplers_ARREADY = M_AXI_arready;
  assign auto_us_to_s00_couplers_AWREADY = M_AXI_awready;
  assign auto_us_to_s00_couplers_BRESP = M_AXI_bresp[1:0];
  assign auto_us_to_s00_couplers_BVALID = M_AXI_bvalid;
  assign auto_us_to_s00_couplers_RDATA = M_AXI_rdata[127:0];
  assign auto_us_to_s00_couplers_RLAST = M_AXI_rlast;
  assign auto_us_to_s00_couplers_RRESP = M_AXI_rresp[1:0];
  assign auto_us_to_s00_couplers_RVALID = M_AXI_rvalid;
  assign auto_us_to_s00_couplers_WREADY = M_AXI_wready;
  assign s00_couplers_to_auto_us_ARADDR = S_AXI_araddr[39:0];
  assign s00_couplers_to_auto_us_ARBURST = S_AXI_arburst[1:0];
  assign s00_couplers_to_auto_us_ARCACHE = S_AXI_arcache[3:0];
  assign s00_couplers_to_auto_us_ARLEN = S_AXI_arlen[7:0];
  assign s00_couplers_to_auto_us_ARLOCK = S_AXI_arlock[0];
  assign s00_couplers_to_auto_us_ARPROT = S_AXI_arprot[2:0];
  assign s00_couplers_to_auto_us_ARQOS = S_AXI_arqos[3:0];
  assign s00_couplers_to_auto_us_ARSIZE = S_AXI_arsize[2:0];
  assign s00_couplers_to_auto_us_ARVALID = S_AXI_arvalid;
  assign s00_couplers_to_auto_us_AWADDR = S_AXI_awaddr[39:0];
  assign s00_couplers_to_auto_us_AWBURST = S_AXI_awburst[1:0];
  assign s00_couplers_to_auto_us_AWCACHE = S_AXI_awcache[3:0];
  assign s00_couplers_to_auto_us_AWLEN = S_AXI_awlen[7:0];
  assign s00_couplers_to_auto_us_AWLOCK = S_AXI_awlock[0];
  assign s00_couplers_to_auto_us_AWPROT = S_AXI_awprot[2:0];
  assign s00_couplers_to_auto_us_AWQOS = S_AXI_awqos[3:0];
  assign s00_couplers_to_auto_us_AWSIZE = S_AXI_awsize[2:0];
  assign s00_couplers_to_auto_us_AWVALID = S_AXI_awvalid;
  assign s00_couplers_to_auto_us_BREADY = S_AXI_bready;
  assign s00_couplers_to_auto_us_RREADY = S_AXI_rready;
  assign s00_couplers_to_auto_us_WDATA = S_AXI_wdata[31:0];
  assign s00_couplers_to_auto_us_WLAST = S_AXI_wlast;
  assign s00_couplers_to_auto_us_WSTRB = S_AXI_wstrb[3:0];
  assign s00_couplers_to_auto_us_WVALID = S_AXI_wvalid;
  kv260_hardware_platform_auto_us_0 auto_us
       (.m_axi_araddr(auto_us_to_s00_couplers_ARADDR),
        .m_axi_arburst(auto_us_to_s00_couplers_ARBURST),
        .m_axi_arcache(auto_us_to_s00_couplers_ARCACHE),
        .m_axi_arlen(auto_us_to_s00_couplers_ARLEN),
        .m_axi_arlock(auto_us_to_s00_couplers_ARLOCK),
        .m_axi_arprot(auto_us_to_s00_couplers_ARPROT),
        .m_axi_arqos(auto_us_to_s00_couplers_ARQOS),
        .m_axi_arready(auto_us_to_s00_couplers_ARREADY),
        .m_axi_arsize(auto_us_to_s00_couplers_ARSIZE),
        .m_axi_arvalid(auto_us_to_s00_couplers_ARVALID),
        .m_axi_awaddr(auto_us_to_s00_couplers_AWADDR),
        .m_axi_awburst(auto_us_to_s00_couplers_AWBURST),
        .m_axi_awcache(auto_us_to_s00_couplers_AWCACHE),
        .m_axi_awlen(auto_us_to_s00_couplers_AWLEN),
        .m_axi_awlock(auto_us_to_s00_couplers_AWLOCK),
        .m_axi_awprot(auto_us_to_s00_couplers_AWPROT),
        .m_axi_awqos(auto_us_to_s00_couplers_AWQOS),
        .m_axi_awready(auto_us_to_s00_couplers_AWREADY),
        .m_axi_awsize(auto_us_to_s00_couplers_AWSIZE),
        .m_axi_awvalid(auto_us_to_s00_couplers_AWVALID),
        .m_axi_bready(auto_us_to_s00_couplers_BREADY),
        .m_axi_bresp(auto_us_to_s00_couplers_BRESP),
        .m_axi_bvalid(auto_us_to_s00_couplers_BVALID),
        .m_axi_rdata(auto_us_to_s00_couplers_RDATA),
        .m_axi_rlast(auto_us_to_s00_couplers_RLAST),
        .m_axi_rready(auto_us_to_s00_couplers_RREADY),
        .m_axi_rresp(auto_us_to_s00_couplers_RRESP),
        .m_axi_rvalid(auto_us_to_s00_couplers_RVALID),
        .m_axi_wdata(auto_us_to_s00_couplers_WDATA),
        .m_axi_wlast(auto_us_to_s00_couplers_WLAST),
        .m_axi_wready(auto_us_to_s00_couplers_WREADY),
        .m_axi_wstrb(auto_us_to_s00_couplers_WSTRB),
        .m_axi_wvalid(auto_us_to_s00_couplers_WVALID),
        .s_axi_aclk(S_ACLK_1),
        .s_axi_araddr(s00_couplers_to_auto_us_ARADDR),
        .s_axi_arburst(s00_couplers_to_auto_us_ARBURST),
        .s_axi_arcache(s00_couplers_to_auto_us_ARCACHE),
        .s_axi_aresetn(S_ARESETN_1),
        .s_axi_arlen(s00_couplers_to_auto_us_ARLEN),
        .s_axi_arlock(s00_couplers_to_auto_us_ARLOCK),
        .s_axi_arprot(s00_couplers_to_auto_us_ARPROT),
        .s_axi_arqos(s00_couplers_to_auto_us_ARQOS),
        .s_axi_arready(s00_couplers_to_auto_us_ARREADY),
        .s_axi_arregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arsize(s00_couplers_to_auto_us_ARSIZE),
        .s_axi_arvalid(s00_couplers_to_auto_us_ARVALID),
        .s_axi_awaddr(s00_couplers_to_auto_us_AWADDR),
        .s_axi_awburst(s00_couplers_to_auto_us_AWBURST),
        .s_axi_awcache(s00_couplers_to_auto_us_AWCACHE),
        .s_axi_awlen(s00_couplers_to_auto_us_AWLEN),
        .s_axi_awlock(s00_couplers_to_auto_us_AWLOCK),
        .s_axi_awprot(s00_couplers_to_auto_us_AWPROT),
        .s_axi_awqos(s00_couplers_to_auto_us_AWQOS),
        .s_axi_awready(s00_couplers_to_auto_us_AWREADY),
        .s_axi_awregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awsize(s00_couplers_to_auto_us_AWSIZE),
        .s_axi_awvalid(s00_couplers_to_auto_us_AWVALID),
        .s_axi_bready(s00_couplers_to_auto_us_BREADY),
        .s_axi_bresp(s00_couplers_to_auto_us_BRESP),
        .s_axi_bvalid(s00_couplers_to_auto_us_BVALID),
        .s_axi_rdata(s00_couplers_to_auto_us_RDATA),
        .s_axi_rlast(s00_couplers_to_auto_us_RLAST),
        .s_axi_rready(s00_couplers_to_auto_us_RREADY),
        .s_axi_rresp(s00_couplers_to_auto_us_RRESP),
        .s_axi_rvalid(s00_couplers_to_auto_us_RVALID),
        .s_axi_wdata(s00_couplers_to_auto_us_WDATA),
        .s_axi_wlast(s00_couplers_to_auto_us_WLAST),
        .s_axi_wready(s00_couplers_to_auto_us_WREADY),
        .s_axi_wstrb(s00_couplers_to_auto_us_WSTRB),
        .s_axi_wvalid(s00_couplers_to_auto_us_WVALID));
endmodule

module s00_couplers_imp_RO9NQY
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arburst,
    M_AXI_arcache,
    M_AXI_arlen,
    M_AXI_arlock,
    M_AXI_arprot,
    M_AXI_arqos,
    M_AXI_arready,
    M_AXI_arsize,
    M_AXI_aruser,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awburst,
    M_AXI_awcache,
    M_AXI_awlen,
    M_AXI_awlock,
    M_AXI_awprot,
    M_AXI_awqos,
    M_AXI_awready,
    M_AXI_awsize,
    M_AXI_awuser,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rlast,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wlast,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arburst,
    S_AXI_arcache,
    S_AXI_arlen,
    S_AXI_arlock,
    S_AXI_arprot,
    S_AXI_arqos,
    S_AXI_arready,
    S_AXI_arsize,
    S_AXI_aruser,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awburst,
    S_AXI_awcache,
    S_AXI_awlen,
    S_AXI_awlock,
    S_AXI_awprot,
    S_AXI_awqos,
    S_AXI_awready,
    S_AXI_awsize,
    S_AXI_awuser,
    S_AXI_awvalid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rlast,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wlast,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [39:0]M_AXI_araddr;
  output [1:0]M_AXI_arburst;
  output [3:0]M_AXI_arcache;
  output [7:0]M_AXI_arlen;
  output [0:0]M_AXI_arlock;
  output [2:0]M_AXI_arprot;
  output [3:0]M_AXI_arqos;
  input M_AXI_arready;
  output [2:0]M_AXI_arsize;
  output [0:0]M_AXI_aruser;
  output M_AXI_arvalid;
  output [39:0]M_AXI_awaddr;
  output [1:0]M_AXI_awburst;
  output [3:0]M_AXI_awcache;
  output [7:0]M_AXI_awlen;
  output [0:0]M_AXI_awlock;
  output [2:0]M_AXI_awprot;
  output [3:0]M_AXI_awqos;
  input M_AXI_awready;
  output [2:0]M_AXI_awsize;
  output [0:0]M_AXI_awuser;
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
  input S_ACLK;
  input S_ARESETN;
  input [39:0]S_AXI_araddr;
  input [1:0]S_AXI_arburst;
  input [3:0]S_AXI_arcache;
  input [7:0]S_AXI_arlen;
  input [0:0]S_AXI_arlock;
  input [2:0]S_AXI_arprot;
  input [3:0]S_AXI_arqos;
  output S_AXI_arready;
  input [2:0]S_AXI_arsize;
  input [0:0]S_AXI_aruser;
  input S_AXI_arvalid;
  input [39:0]S_AXI_awaddr;
  input [1:0]S_AXI_awburst;
  input [3:0]S_AXI_awcache;
  input [7:0]S_AXI_awlen;
  input [0:0]S_AXI_awlock;
  input [2:0]S_AXI_awprot;
  input [3:0]S_AXI_awqos;
  output S_AXI_awready;
  input [2:0]S_AXI_awsize;
  input [0:0]S_AXI_awuser;
  input S_AXI_awvalid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output S_AXI_bvalid;
  output [127:0]S_AXI_rdata;
  output S_AXI_rlast;
  input S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output S_AXI_rvalid;
  input [127:0]S_AXI_wdata;
  input S_AXI_wlast;
  output S_AXI_wready;
  input [15:0]S_AXI_wstrb;
  input S_AXI_wvalid;

  wire [39:0]s00_couplers_to_s00_couplers_ARADDR;
  wire [1:0]s00_couplers_to_s00_couplers_ARBURST;
  wire [3:0]s00_couplers_to_s00_couplers_ARCACHE;
  wire [7:0]s00_couplers_to_s00_couplers_ARLEN;
  wire [0:0]s00_couplers_to_s00_couplers_ARLOCK;
  wire [2:0]s00_couplers_to_s00_couplers_ARPROT;
  wire [3:0]s00_couplers_to_s00_couplers_ARQOS;
  wire s00_couplers_to_s00_couplers_ARREADY;
  wire [2:0]s00_couplers_to_s00_couplers_ARSIZE;
  wire [0:0]s00_couplers_to_s00_couplers_ARUSER;
  wire s00_couplers_to_s00_couplers_ARVALID;
  wire [39:0]s00_couplers_to_s00_couplers_AWADDR;
  wire [1:0]s00_couplers_to_s00_couplers_AWBURST;
  wire [3:0]s00_couplers_to_s00_couplers_AWCACHE;
  wire [7:0]s00_couplers_to_s00_couplers_AWLEN;
  wire [0:0]s00_couplers_to_s00_couplers_AWLOCK;
  wire [2:0]s00_couplers_to_s00_couplers_AWPROT;
  wire [3:0]s00_couplers_to_s00_couplers_AWQOS;
  wire s00_couplers_to_s00_couplers_AWREADY;
  wire [2:0]s00_couplers_to_s00_couplers_AWSIZE;
  wire [0:0]s00_couplers_to_s00_couplers_AWUSER;
  wire s00_couplers_to_s00_couplers_AWVALID;
  wire s00_couplers_to_s00_couplers_BREADY;
  wire [1:0]s00_couplers_to_s00_couplers_BRESP;
  wire s00_couplers_to_s00_couplers_BVALID;
  wire [127:0]s00_couplers_to_s00_couplers_RDATA;
  wire s00_couplers_to_s00_couplers_RLAST;
  wire s00_couplers_to_s00_couplers_RREADY;
  wire [1:0]s00_couplers_to_s00_couplers_RRESP;
  wire s00_couplers_to_s00_couplers_RVALID;
  wire [127:0]s00_couplers_to_s00_couplers_WDATA;
  wire s00_couplers_to_s00_couplers_WLAST;
  wire s00_couplers_to_s00_couplers_WREADY;
  wire [15:0]s00_couplers_to_s00_couplers_WSTRB;
  wire s00_couplers_to_s00_couplers_WVALID;

  assign M_AXI_araddr[39:0] = s00_couplers_to_s00_couplers_ARADDR;
  assign M_AXI_arburst[1:0] = s00_couplers_to_s00_couplers_ARBURST;
  assign M_AXI_arcache[3:0] = s00_couplers_to_s00_couplers_ARCACHE;
  assign M_AXI_arlen[7:0] = s00_couplers_to_s00_couplers_ARLEN;
  assign M_AXI_arlock[0] = s00_couplers_to_s00_couplers_ARLOCK;
  assign M_AXI_arprot[2:0] = s00_couplers_to_s00_couplers_ARPROT;
  assign M_AXI_arqos[3:0] = s00_couplers_to_s00_couplers_ARQOS;
  assign M_AXI_arsize[2:0] = s00_couplers_to_s00_couplers_ARSIZE;
  assign M_AXI_aruser[0] = s00_couplers_to_s00_couplers_ARUSER;
  assign M_AXI_arvalid = s00_couplers_to_s00_couplers_ARVALID;
  assign M_AXI_awaddr[39:0] = s00_couplers_to_s00_couplers_AWADDR;
  assign M_AXI_awburst[1:0] = s00_couplers_to_s00_couplers_AWBURST;
  assign M_AXI_awcache[3:0] = s00_couplers_to_s00_couplers_AWCACHE;
  assign M_AXI_awlen[7:0] = s00_couplers_to_s00_couplers_AWLEN;
  assign M_AXI_awlock[0] = s00_couplers_to_s00_couplers_AWLOCK;
  assign M_AXI_awprot[2:0] = s00_couplers_to_s00_couplers_AWPROT;
  assign M_AXI_awqos[3:0] = s00_couplers_to_s00_couplers_AWQOS;
  assign M_AXI_awsize[2:0] = s00_couplers_to_s00_couplers_AWSIZE;
  assign M_AXI_awuser[0] = s00_couplers_to_s00_couplers_AWUSER;
  assign M_AXI_awvalid = s00_couplers_to_s00_couplers_AWVALID;
  assign M_AXI_bready = s00_couplers_to_s00_couplers_BREADY;
  assign M_AXI_rready = s00_couplers_to_s00_couplers_RREADY;
  assign M_AXI_wdata[127:0] = s00_couplers_to_s00_couplers_WDATA;
  assign M_AXI_wlast = s00_couplers_to_s00_couplers_WLAST;
  assign M_AXI_wstrb[15:0] = s00_couplers_to_s00_couplers_WSTRB;
  assign M_AXI_wvalid = s00_couplers_to_s00_couplers_WVALID;
  assign S_AXI_arready = s00_couplers_to_s00_couplers_ARREADY;
  assign S_AXI_awready = s00_couplers_to_s00_couplers_AWREADY;
  assign S_AXI_bresp[1:0] = s00_couplers_to_s00_couplers_BRESP;
  assign S_AXI_bvalid = s00_couplers_to_s00_couplers_BVALID;
  assign S_AXI_rdata[127:0] = s00_couplers_to_s00_couplers_RDATA;
  assign S_AXI_rlast = s00_couplers_to_s00_couplers_RLAST;
  assign S_AXI_rresp[1:0] = s00_couplers_to_s00_couplers_RRESP;
  assign S_AXI_rvalid = s00_couplers_to_s00_couplers_RVALID;
  assign S_AXI_wready = s00_couplers_to_s00_couplers_WREADY;
  assign s00_couplers_to_s00_couplers_ARADDR = S_AXI_araddr[39:0];
  assign s00_couplers_to_s00_couplers_ARBURST = S_AXI_arburst[1:0];
  assign s00_couplers_to_s00_couplers_ARCACHE = S_AXI_arcache[3:0];
  assign s00_couplers_to_s00_couplers_ARLEN = S_AXI_arlen[7:0];
  assign s00_couplers_to_s00_couplers_ARLOCK = S_AXI_arlock[0];
  assign s00_couplers_to_s00_couplers_ARPROT = S_AXI_arprot[2:0];
  assign s00_couplers_to_s00_couplers_ARQOS = S_AXI_arqos[3:0];
  assign s00_couplers_to_s00_couplers_ARREADY = M_AXI_arready;
  assign s00_couplers_to_s00_couplers_ARSIZE = S_AXI_arsize[2:0];
  assign s00_couplers_to_s00_couplers_ARUSER = S_AXI_aruser[0];
  assign s00_couplers_to_s00_couplers_ARVALID = S_AXI_arvalid;
  assign s00_couplers_to_s00_couplers_AWADDR = S_AXI_awaddr[39:0];
  assign s00_couplers_to_s00_couplers_AWBURST = S_AXI_awburst[1:0];
  assign s00_couplers_to_s00_couplers_AWCACHE = S_AXI_awcache[3:0];
  assign s00_couplers_to_s00_couplers_AWLEN = S_AXI_awlen[7:0];
  assign s00_couplers_to_s00_couplers_AWLOCK = S_AXI_awlock[0];
  assign s00_couplers_to_s00_couplers_AWPROT = S_AXI_awprot[2:0];
  assign s00_couplers_to_s00_couplers_AWQOS = S_AXI_awqos[3:0];
  assign s00_couplers_to_s00_couplers_AWREADY = M_AXI_awready;
  assign s00_couplers_to_s00_couplers_AWSIZE = S_AXI_awsize[2:0];
  assign s00_couplers_to_s00_couplers_AWUSER = S_AXI_awuser[0];
  assign s00_couplers_to_s00_couplers_AWVALID = S_AXI_awvalid;
  assign s00_couplers_to_s00_couplers_BREADY = S_AXI_bready;
  assign s00_couplers_to_s00_couplers_BRESP = M_AXI_bresp[1:0];
  assign s00_couplers_to_s00_couplers_BVALID = M_AXI_bvalid;
  assign s00_couplers_to_s00_couplers_RDATA = M_AXI_rdata[127:0];
  assign s00_couplers_to_s00_couplers_RLAST = M_AXI_rlast;
  assign s00_couplers_to_s00_couplers_RREADY = S_AXI_rready;
  assign s00_couplers_to_s00_couplers_RRESP = M_AXI_rresp[1:0];
  assign s00_couplers_to_s00_couplers_RVALID = M_AXI_rvalid;
  assign s00_couplers_to_s00_couplers_WDATA = S_AXI_wdata[127:0];
  assign s00_couplers_to_s00_couplers_WLAST = S_AXI_wlast;
  assign s00_couplers_to_s00_couplers_WREADY = M_AXI_wready;
  assign s00_couplers_to_s00_couplers_WSTRB = S_AXI_wstrb[15:0];
  assign s00_couplers_to_s00_couplers_WVALID = S_AXI_wvalid;
endmodule

module s01_couplers_imp_1GJB8RS
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arburst,
    M_AXI_arcache,
    M_AXI_arlen,
    M_AXI_arlock,
    M_AXI_arprot,
    M_AXI_arqos,
    M_AXI_arready,
    M_AXI_arsize,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awburst,
    M_AXI_awcache,
    M_AXI_awlen,
    M_AXI_awlock,
    M_AXI_awprot,
    M_AXI_awqos,
    M_AXI_awready,
    M_AXI_awsize,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rlast,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wlast,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arburst,
    S_AXI_arcache,
    S_AXI_arlen,
    S_AXI_arlock,
    S_AXI_arprot,
    S_AXI_arqos,
    S_AXI_arready,
    S_AXI_arsize,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awburst,
    S_AXI_awcache,
    S_AXI_awlen,
    S_AXI_awlock,
    S_AXI_awprot,
    S_AXI_awqos,
    S_AXI_awready,
    S_AXI_awsize,
    S_AXI_awvalid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rlast,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wlast,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
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
  input S_ACLK;
  input S_ARESETN;
  input [31:0]S_AXI_araddr;
  input [1:0]S_AXI_arburst;
  input [3:0]S_AXI_arcache;
  input [7:0]S_AXI_arlen;
  input [0:0]S_AXI_arlock;
  input [2:0]S_AXI_arprot;
  input [3:0]S_AXI_arqos;
  output S_AXI_arready;
  input [2:0]S_AXI_arsize;
  input S_AXI_arvalid;
  input [31:0]S_AXI_awaddr;
  input [1:0]S_AXI_awburst;
  input [3:0]S_AXI_awcache;
  input [7:0]S_AXI_awlen;
  input [0:0]S_AXI_awlock;
  input [2:0]S_AXI_awprot;
  input [3:0]S_AXI_awqos;
  output S_AXI_awready;
  input [2:0]S_AXI_awsize;
  input S_AXI_awvalid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output S_AXI_bvalid;
  output [127:0]S_AXI_rdata;
  output S_AXI_rlast;
  input S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output S_AXI_rvalid;
  input [127:0]S_AXI_wdata;
  input S_AXI_wlast;
  output S_AXI_wready;
  input [15:0]S_AXI_wstrb;
  input S_AXI_wvalid;

  wire M_ACLK_1;
  wire M_ARESETN_1;
  wire S_ACLK_1;
  wire S_ARESETN_1;
  wire [31:0]s01_couplers_to_s01_regslice_ARADDR;
  wire [1:0]s01_couplers_to_s01_regslice_ARBURST;
  wire [3:0]s01_couplers_to_s01_regslice_ARCACHE;
  wire [7:0]s01_couplers_to_s01_regslice_ARLEN;
  wire [0:0]s01_couplers_to_s01_regslice_ARLOCK;
  wire [2:0]s01_couplers_to_s01_regslice_ARPROT;
  wire [3:0]s01_couplers_to_s01_regslice_ARQOS;
  wire s01_couplers_to_s01_regslice_ARREADY;
  wire [2:0]s01_couplers_to_s01_regslice_ARSIZE;
  wire s01_couplers_to_s01_regslice_ARVALID;
  wire [31:0]s01_couplers_to_s01_regslice_AWADDR;
  wire [1:0]s01_couplers_to_s01_regslice_AWBURST;
  wire [3:0]s01_couplers_to_s01_regslice_AWCACHE;
  wire [7:0]s01_couplers_to_s01_regslice_AWLEN;
  wire [0:0]s01_couplers_to_s01_regslice_AWLOCK;
  wire [2:0]s01_couplers_to_s01_regslice_AWPROT;
  wire [3:0]s01_couplers_to_s01_regslice_AWQOS;
  wire s01_couplers_to_s01_regslice_AWREADY;
  wire [2:0]s01_couplers_to_s01_regslice_AWSIZE;
  wire s01_couplers_to_s01_regslice_AWVALID;
  wire s01_couplers_to_s01_regslice_BREADY;
  wire [1:0]s01_couplers_to_s01_regslice_BRESP;
  wire s01_couplers_to_s01_regslice_BVALID;
  wire [127:0]s01_couplers_to_s01_regslice_RDATA;
  wire s01_couplers_to_s01_regslice_RLAST;
  wire s01_couplers_to_s01_regslice_RREADY;
  wire [1:0]s01_couplers_to_s01_regslice_RRESP;
  wire s01_couplers_to_s01_regslice_RVALID;
  wire [127:0]s01_couplers_to_s01_regslice_WDATA;
  wire s01_couplers_to_s01_regslice_WLAST;
  wire s01_couplers_to_s01_regslice_WREADY;
  wire [15:0]s01_couplers_to_s01_regslice_WSTRB;
  wire s01_couplers_to_s01_regslice_WVALID;
  wire [31:0]s01_data_fifo_to_s01_couplers_ARADDR;
  wire [1:0]s01_data_fifo_to_s01_couplers_ARBURST;
  wire [3:0]s01_data_fifo_to_s01_couplers_ARCACHE;
  wire [7:0]s01_data_fifo_to_s01_couplers_ARLEN;
  wire [0:0]s01_data_fifo_to_s01_couplers_ARLOCK;
  wire [2:0]s01_data_fifo_to_s01_couplers_ARPROT;
  wire [3:0]s01_data_fifo_to_s01_couplers_ARQOS;
  wire s01_data_fifo_to_s01_couplers_ARREADY;
  wire [2:0]s01_data_fifo_to_s01_couplers_ARSIZE;
  wire s01_data_fifo_to_s01_couplers_ARVALID;
  wire [31:0]s01_data_fifo_to_s01_couplers_AWADDR;
  wire [1:0]s01_data_fifo_to_s01_couplers_AWBURST;
  wire [3:0]s01_data_fifo_to_s01_couplers_AWCACHE;
  wire [7:0]s01_data_fifo_to_s01_couplers_AWLEN;
  wire [0:0]s01_data_fifo_to_s01_couplers_AWLOCK;
  wire [2:0]s01_data_fifo_to_s01_couplers_AWPROT;
  wire [3:0]s01_data_fifo_to_s01_couplers_AWQOS;
  wire s01_data_fifo_to_s01_couplers_AWREADY;
  wire [2:0]s01_data_fifo_to_s01_couplers_AWSIZE;
  wire s01_data_fifo_to_s01_couplers_AWVALID;
  wire s01_data_fifo_to_s01_couplers_BREADY;
  wire [1:0]s01_data_fifo_to_s01_couplers_BRESP;
  wire s01_data_fifo_to_s01_couplers_BVALID;
  wire [127:0]s01_data_fifo_to_s01_couplers_RDATA;
  wire s01_data_fifo_to_s01_couplers_RLAST;
  wire s01_data_fifo_to_s01_couplers_RREADY;
  wire [1:0]s01_data_fifo_to_s01_couplers_RRESP;
  wire s01_data_fifo_to_s01_couplers_RVALID;
  wire [127:0]s01_data_fifo_to_s01_couplers_WDATA;
  wire s01_data_fifo_to_s01_couplers_WLAST;
  wire s01_data_fifo_to_s01_couplers_WREADY;
  wire [15:0]s01_data_fifo_to_s01_couplers_WSTRB;
  wire s01_data_fifo_to_s01_couplers_WVALID;
  wire [31:0]s01_regslice_to_s01_data_fifo_ARADDR;
  wire [1:0]s01_regslice_to_s01_data_fifo_ARBURST;
  wire [3:0]s01_regslice_to_s01_data_fifo_ARCACHE;
  wire [7:0]s01_regslice_to_s01_data_fifo_ARLEN;
  wire [0:0]s01_regslice_to_s01_data_fifo_ARLOCK;
  wire [2:0]s01_regslice_to_s01_data_fifo_ARPROT;
  wire [3:0]s01_regslice_to_s01_data_fifo_ARQOS;
  wire s01_regslice_to_s01_data_fifo_ARREADY;
  wire [3:0]s01_regslice_to_s01_data_fifo_ARREGION;
  wire [2:0]s01_regslice_to_s01_data_fifo_ARSIZE;
  wire s01_regslice_to_s01_data_fifo_ARVALID;
  wire [31:0]s01_regslice_to_s01_data_fifo_AWADDR;
  wire [1:0]s01_regslice_to_s01_data_fifo_AWBURST;
  wire [3:0]s01_regslice_to_s01_data_fifo_AWCACHE;
  wire [7:0]s01_regslice_to_s01_data_fifo_AWLEN;
  wire [0:0]s01_regslice_to_s01_data_fifo_AWLOCK;
  wire [2:0]s01_regslice_to_s01_data_fifo_AWPROT;
  wire [3:0]s01_regslice_to_s01_data_fifo_AWQOS;
  wire s01_regslice_to_s01_data_fifo_AWREADY;
  wire [3:0]s01_regslice_to_s01_data_fifo_AWREGION;
  wire [2:0]s01_regslice_to_s01_data_fifo_AWSIZE;
  wire s01_regslice_to_s01_data_fifo_AWVALID;
  wire s01_regslice_to_s01_data_fifo_BREADY;
  wire [1:0]s01_regslice_to_s01_data_fifo_BRESP;
  wire s01_regslice_to_s01_data_fifo_BVALID;
  wire [127:0]s01_regslice_to_s01_data_fifo_RDATA;
  wire s01_regslice_to_s01_data_fifo_RLAST;
  wire s01_regslice_to_s01_data_fifo_RREADY;
  wire [1:0]s01_regslice_to_s01_data_fifo_RRESP;
  wire s01_regslice_to_s01_data_fifo_RVALID;
  wire [127:0]s01_regslice_to_s01_data_fifo_WDATA;
  wire s01_regslice_to_s01_data_fifo_WLAST;
  wire s01_regslice_to_s01_data_fifo_WREADY;
  wire [15:0]s01_regslice_to_s01_data_fifo_WSTRB;
  wire s01_regslice_to_s01_data_fifo_WVALID;

  assign M_ACLK_1 = M_ACLK;
  assign M_ARESETN_1 = M_ARESETN;
  assign M_AXI_araddr[31:0] = s01_data_fifo_to_s01_couplers_ARADDR;
  assign M_AXI_arburst[1:0] = s01_data_fifo_to_s01_couplers_ARBURST;
  assign M_AXI_arcache[3:0] = s01_data_fifo_to_s01_couplers_ARCACHE;
  assign M_AXI_arlen[7:0] = s01_data_fifo_to_s01_couplers_ARLEN;
  assign M_AXI_arlock[0] = s01_data_fifo_to_s01_couplers_ARLOCK;
  assign M_AXI_arprot[2:0] = s01_data_fifo_to_s01_couplers_ARPROT;
  assign M_AXI_arqos[3:0] = s01_data_fifo_to_s01_couplers_ARQOS;
  assign M_AXI_arsize[2:0] = s01_data_fifo_to_s01_couplers_ARSIZE;
  assign M_AXI_arvalid = s01_data_fifo_to_s01_couplers_ARVALID;
  assign M_AXI_awaddr[31:0] = s01_data_fifo_to_s01_couplers_AWADDR;
  assign M_AXI_awburst[1:0] = s01_data_fifo_to_s01_couplers_AWBURST;
  assign M_AXI_awcache[3:0] = s01_data_fifo_to_s01_couplers_AWCACHE;
  assign M_AXI_awlen[7:0] = s01_data_fifo_to_s01_couplers_AWLEN;
  assign M_AXI_awlock[0] = s01_data_fifo_to_s01_couplers_AWLOCK;
  assign M_AXI_awprot[2:0] = s01_data_fifo_to_s01_couplers_AWPROT;
  assign M_AXI_awqos[3:0] = s01_data_fifo_to_s01_couplers_AWQOS;
  assign M_AXI_awsize[2:0] = s01_data_fifo_to_s01_couplers_AWSIZE;
  assign M_AXI_awvalid = s01_data_fifo_to_s01_couplers_AWVALID;
  assign M_AXI_bready = s01_data_fifo_to_s01_couplers_BREADY;
  assign M_AXI_rready = s01_data_fifo_to_s01_couplers_RREADY;
  assign M_AXI_wdata[127:0] = s01_data_fifo_to_s01_couplers_WDATA;
  assign M_AXI_wlast = s01_data_fifo_to_s01_couplers_WLAST;
  assign M_AXI_wstrb[15:0] = s01_data_fifo_to_s01_couplers_WSTRB;
  assign M_AXI_wvalid = s01_data_fifo_to_s01_couplers_WVALID;
  assign S_ACLK_1 = S_ACLK;
  assign S_ARESETN_1 = S_ARESETN;
  assign S_AXI_arready = s01_couplers_to_s01_regslice_ARREADY;
  assign S_AXI_awready = s01_couplers_to_s01_regslice_AWREADY;
  assign S_AXI_bresp[1:0] = s01_couplers_to_s01_regslice_BRESP;
  assign S_AXI_bvalid = s01_couplers_to_s01_regslice_BVALID;
  assign S_AXI_rdata[127:0] = s01_couplers_to_s01_regslice_RDATA;
  assign S_AXI_rlast = s01_couplers_to_s01_regslice_RLAST;
  assign S_AXI_rresp[1:0] = s01_couplers_to_s01_regslice_RRESP;
  assign S_AXI_rvalid = s01_couplers_to_s01_regslice_RVALID;
  assign S_AXI_wready = s01_couplers_to_s01_regslice_WREADY;
  assign s01_couplers_to_s01_regslice_ARADDR = S_AXI_araddr[31:0];
  assign s01_couplers_to_s01_regslice_ARBURST = S_AXI_arburst[1:0];
  assign s01_couplers_to_s01_regslice_ARCACHE = S_AXI_arcache[3:0];
  assign s01_couplers_to_s01_regslice_ARLEN = S_AXI_arlen[7:0];
  assign s01_couplers_to_s01_regslice_ARLOCK = S_AXI_arlock[0];
  assign s01_couplers_to_s01_regslice_ARPROT = S_AXI_arprot[2:0];
  assign s01_couplers_to_s01_regslice_ARQOS = S_AXI_arqos[3:0];
  assign s01_couplers_to_s01_regslice_ARSIZE = S_AXI_arsize[2:0];
  assign s01_couplers_to_s01_regslice_ARVALID = S_AXI_arvalid;
  assign s01_couplers_to_s01_regslice_AWADDR = S_AXI_awaddr[31:0];
  assign s01_couplers_to_s01_regslice_AWBURST = S_AXI_awburst[1:0];
  assign s01_couplers_to_s01_regslice_AWCACHE = S_AXI_awcache[3:0];
  assign s01_couplers_to_s01_regslice_AWLEN = S_AXI_awlen[7:0];
  assign s01_couplers_to_s01_regslice_AWLOCK = S_AXI_awlock[0];
  assign s01_couplers_to_s01_regslice_AWPROT = S_AXI_awprot[2:0];
  assign s01_couplers_to_s01_regslice_AWQOS = S_AXI_awqos[3:0];
  assign s01_couplers_to_s01_regslice_AWSIZE = S_AXI_awsize[2:0];
  assign s01_couplers_to_s01_regslice_AWVALID = S_AXI_awvalid;
  assign s01_couplers_to_s01_regslice_BREADY = S_AXI_bready;
  assign s01_couplers_to_s01_regslice_RREADY = S_AXI_rready;
  assign s01_couplers_to_s01_regslice_WDATA = S_AXI_wdata[127:0];
  assign s01_couplers_to_s01_regslice_WLAST = S_AXI_wlast;
  assign s01_couplers_to_s01_regslice_WSTRB = S_AXI_wstrb[15:0];
  assign s01_couplers_to_s01_regslice_WVALID = S_AXI_wvalid;
  assign s01_data_fifo_to_s01_couplers_ARREADY = M_AXI_arready;
  assign s01_data_fifo_to_s01_couplers_AWREADY = M_AXI_awready;
  assign s01_data_fifo_to_s01_couplers_BRESP = M_AXI_bresp[1:0];
  assign s01_data_fifo_to_s01_couplers_BVALID = M_AXI_bvalid;
  assign s01_data_fifo_to_s01_couplers_RDATA = M_AXI_rdata[127:0];
  assign s01_data_fifo_to_s01_couplers_RLAST = M_AXI_rlast;
  assign s01_data_fifo_to_s01_couplers_RRESP = M_AXI_rresp[1:0];
  assign s01_data_fifo_to_s01_couplers_RVALID = M_AXI_rvalid;
  assign s01_data_fifo_to_s01_couplers_WREADY = M_AXI_wready;
  kv260_hardware_platform_s01_data_fifo_0 s01_data_fifo
       (.aclk(M_ACLK_1),
        .aresetn(M_ARESETN_1),
        .m_axi_araddr(s01_data_fifo_to_s01_couplers_ARADDR),
        .m_axi_arburst(s01_data_fifo_to_s01_couplers_ARBURST),
        .m_axi_arcache(s01_data_fifo_to_s01_couplers_ARCACHE),
        .m_axi_arlen(s01_data_fifo_to_s01_couplers_ARLEN),
        .m_axi_arlock(s01_data_fifo_to_s01_couplers_ARLOCK),
        .m_axi_arprot(s01_data_fifo_to_s01_couplers_ARPROT),
        .m_axi_arqos(s01_data_fifo_to_s01_couplers_ARQOS),
        .m_axi_arready(s01_data_fifo_to_s01_couplers_ARREADY),
        .m_axi_arsize(s01_data_fifo_to_s01_couplers_ARSIZE),
        .m_axi_arvalid(s01_data_fifo_to_s01_couplers_ARVALID),
        .m_axi_awaddr(s01_data_fifo_to_s01_couplers_AWADDR),
        .m_axi_awburst(s01_data_fifo_to_s01_couplers_AWBURST),
        .m_axi_awcache(s01_data_fifo_to_s01_couplers_AWCACHE),
        .m_axi_awlen(s01_data_fifo_to_s01_couplers_AWLEN),
        .m_axi_awlock(s01_data_fifo_to_s01_couplers_AWLOCK),
        .m_axi_awprot(s01_data_fifo_to_s01_couplers_AWPROT),
        .m_axi_awqos(s01_data_fifo_to_s01_couplers_AWQOS),
        .m_axi_awready(s01_data_fifo_to_s01_couplers_AWREADY),
        .m_axi_awsize(s01_data_fifo_to_s01_couplers_AWSIZE),
        .m_axi_awvalid(s01_data_fifo_to_s01_couplers_AWVALID),
        .m_axi_bready(s01_data_fifo_to_s01_couplers_BREADY),
        .m_axi_bresp(s01_data_fifo_to_s01_couplers_BRESP),
        .m_axi_bvalid(s01_data_fifo_to_s01_couplers_BVALID),
        .m_axi_rdata(s01_data_fifo_to_s01_couplers_RDATA),
        .m_axi_rlast(s01_data_fifo_to_s01_couplers_RLAST),
        .m_axi_rready(s01_data_fifo_to_s01_couplers_RREADY),
        .m_axi_rresp(s01_data_fifo_to_s01_couplers_RRESP),
        .m_axi_rvalid(s01_data_fifo_to_s01_couplers_RVALID),
        .m_axi_wdata(s01_data_fifo_to_s01_couplers_WDATA),
        .m_axi_wlast(s01_data_fifo_to_s01_couplers_WLAST),
        .m_axi_wready(s01_data_fifo_to_s01_couplers_WREADY),
        .m_axi_wstrb(s01_data_fifo_to_s01_couplers_WSTRB),
        .m_axi_wvalid(s01_data_fifo_to_s01_couplers_WVALID),
        .s_axi_araddr(s01_regslice_to_s01_data_fifo_ARADDR),
        .s_axi_arburst(s01_regslice_to_s01_data_fifo_ARBURST),
        .s_axi_arcache(s01_regslice_to_s01_data_fifo_ARCACHE),
        .s_axi_arlen(s01_regslice_to_s01_data_fifo_ARLEN),
        .s_axi_arlock(s01_regslice_to_s01_data_fifo_ARLOCK),
        .s_axi_arprot(s01_regslice_to_s01_data_fifo_ARPROT),
        .s_axi_arqos(s01_regslice_to_s01_data_fifo_ARQOS),
        .s_axi_arready(s01_regslice_to_s01_data_fifo_ARREADY),
        .s_axi_arregion(s01_regslice_to_s01_data_fifo_ARREGION),
        .s_axi_arsize(s01_regslice_to_s01_data_fifo_ARSIZE),
        .s_axi_arvalid(s01_regslice_to_s01_data_fifo_ARVALID),
        .s_axi_awaddr(s01_regslice_to_s01_data_fifo_AWADDR),
        .s_axi_awburst(s01_regslice_to_s01_data_fifo_AWBURST),
        .s_axi_awcache(s01_regslice_to_s01_data_fifo_AWCACHE),
        .s_axi_awlen(s01_regslice_to_s01_data_fifo_AWLEN),
        .s_axi_awlock(s01_regslice_to_s01_data_fifo_AWLOCK),
        .s_axi_awprot(s01_regslice_to_s01_data_fifo_AWPROT),
        .s_axi_awqos(s01_regslice_to_s01_data_fifo_AWQOS),
        .s_axi_awready(s01_regslice_to_s01_data_fifo_AWREADY),
        .s_axi_awregion(s01_regslice_to_s01_data_fifo_AWREGION),
        .s_axi_awsize(s01_regslice_to_s01_data_fifo_AWSIZE),
        .s_axi_awvalid(s01_regslice_to_s01_data_fifo_AWVALID),
        .s_axi_bready(s01_regslice_to_s01_data_fifo_BREADY),
        .s_axi_bresp(s01_regslice_to_s01_data_fifo_BRESP),
        .s_axi_bvalid(s01_regslice_to_s01_data_fifo_BVALID),
        .s_axi_rdata(s01_regslice_to_s01_data_fifo_RDATA),
        .s_axi_rlast(s01_regslice_to_s01_data_fifo_RLAST),
        .s_axi_rready(s01_regslice_to_s01_data_fifo_RREADY),
        .s_axi_rresp(s01_regslice_to_s01_data_fifo_RRESP),
        .s_axi_rvalid(s01_regslice_to_s01_data_fifo_RVALID),
        .s_axi_wdata(s01_regslice_to_s01_data_fifo_WDATA),
        .s_axi_wlast(s01_regslice_to_s01_data_fifo_WLAST),
        .s_axi_wready(s01_regslice_to_s01_data_fifo_WREADY),
        .s_axi_wstrb(s01_regslice_to_s01_data_fifo_WSTRB),
        .s_axi_wvalid(s01_regslice_to_s01_data_fifo_WVALID));
  kv260_hardware_platform_s01_regslice_0 s01_regslice
       (.aclk(S_ACLK_1),
        .aresetn(S_ARESETN_1),
        .m_axi_araddr(s01_regslice_to_s01_data_fifo_ARADDR),
        .m_axi_arburst(s01_regslice_to_s01_data_fifo_ARBURST),
        .m_axi_arcache(s01_regslice_to_s01_data_fifo_ARCACHE),
        .m_axi_arlen(s01_regslice_to_s01_data_fifo_ARLEN),
        .m_axi_arlock(s01_regslice_to_s01_data_fifo_ARLOCK),
        .m_axi_arprot(s01_regslice_to_s01_data_fifo_ARPROT),
        .m_axi_arqos(s01_regslice_to_s01_data_fifo_ARQOS),
        .m_axi_arready(s01_regslice_to_s01_data_fifo_ARREADY),
        .m_axi_arregion(s01_regslice_to_s01_data_fifo_ARREGION),
        .m_axi_arsize(s01_regslice_to_s01_data_fifo_ARSIZE),
        .m_axi_arvalid(s01_regslice_to_s01_data_fifo_ARVALID),
        .m_axi_awaddr(s01_regslice_to_s01_data_fifo_AWADDR),
        .m_axi_awburst(s01_regslice_to_s01_data_fifo_AWBURST),
        .m_axi_awcache(s01_regslice_to_s01_data_fifo_AWCACHE),
        .m_axi_awlen(s01_regslice_to_s01_data_fifo_AWLEN),
        .m_axi_awlock(s01_regslice_to_s01_data_fifo_AWLOCK),
        .m_axi_awprot(s01_regslice_to_s01_data_fifo_AWPROT),
        .m_axi_awqos(s01_regslice_to_s01_data_fifo_AWQOS),
        .m_axi_awready(s01_regslice_to_s01_data_fifo_AWREADY),
        .m_axi_awregion(s01_regslice_to_s01_data_fifo_AWREGION),
        .m_axi_awsize(s01_regslice_to_s01_data_fifo_AWSIZE),
        .m_axi_awvalid(s01_regslice_to_s01_data_fifo_AWVALID),
        .m_axi_bready(s01_regslice_to_s01_data_fifo_BREADY),
        .m_axi_bresp(s01_regslice_to_s01_data_fifo_BRESP),
        .m_axi_bvalid(s01_regslice_to_s01_data_fifo_BVALID),
        .m_axi_rdata(s01_regslice_to_s01_data_fifo_RDATA),
        .m_axi_rlast(s01_regslice_to_s01_data_fifo_RLAST),
        .m_axi_rready(s01_regslice_to_s01_data_fifo_RREADY),
        .m_axi_rresp(s01_regslice_to_s01_data_fifo_RRESP),
        .m_axi_rvalid(s01_regslice_to_s01_data_fifo_RVALID),
        .m_axi_wdata(s01_regslice_to_s01_data_fifo_WDATA),
        .m_axi_wlast(s01_regslice_to_s01_data_fifo_WLAST),
        .m_axi_wready(s01_regslice_to_s01_data_fifo_WREADY),
        .m_axi_wstrb(s01_regslice_to_s01_data_fifo_WSTRB),
        .m_axi_wvalid(s01_regslice_to_s01_data_fifo_WVALID),
        .s_axi_araddr(s01_couplers_to_s01_regslice_ARADDR),
        .s_axi_arburst(s01_couplers_to_s01_regslice_ARBURST),
        .s_axi_arcache(s01_couplers_to_s01_regslice_ARCACHE),
        .s_axi_arlen(s01_couplers_to_s01_regslice_ARLEN),
        .s_axi_arlock(s01_couplers_to_s01_regslice_ARLOCK),
        .s_axi_arprot(s01_couplers_to_s01_regslice_ARPROT),
        .s_axi_arqos(s01_couplers_to_s01_regslice_ARQOS),
        .s_axi_arready(s01_couplers_to_s01_regslice_ARREADY),
        .s_axi_arregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arsize(s01_couplers_to_s01_regslice_ARSIZE),
        .s_axi_arvalid(s01_couplers_to_s01_regslice_ARVALID),
        .s_axi_awaddr(s01_couplers_to_s01_regslice_AWADDR),
        .s_axi_awburst(s01_couplers_to_s01_regslice_AWBURST),
        .s_axi_awcache(s01_couplers_to_s01_regslice_AWCACHE),
        .s_axi_awlen(s01_couplers_to_s01_regslice_AWLEN),
        .s_axi_awlock(s01_couplers_to_s01_regslice_AWLOCK),
        .s_axi_awprot(s01_couplers_to_s01_regslice_AWPROT),
        .s_axi_awqos(s01_couplers_to_s01_regslice_AWQOS),
        .s_axi_awready(s01_couplers_to_s01_regslice_AWREADY),
        .s_axi_awregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awsize(s01_couplers_to_s01_regslice_AWSIZE),
        .s_axi_awvalid(s01_couplers_to_s01_regslice_AWVALID),
        .s_axi_bready(s01_couplers_to_s01_regslice_BREADY),
        .s_axi_bresp(s01_couplers_to_s01_regslice_BRESP),
        .s_axi_bvalid(s01_couplers_to_s01_regslice_BVALID),
        .s_axi_rdata(s01_couplers_to_s01_regslice_RDATA),
        .s_axi_rlast(s01_couplers_to_s01_regslice_RLAST),
        .s_axi_rready(s01_couplers_to_s01_regslice_RREADY),
        .s_axi_rresp(s01_couplers_to_s01_regslice_RRESP),
        .s_axi_rvalid(s01_couplers_to_s01_regslice_RVALID),
        .s_axi_wdata(s01_couplers_to_s01_regslice_WDATA),
        .s_axi_wlast(s01_couplers_to_s01_regslice_WLAST),
        .s_axi_wready(s01_couplers_to_s01_regslice_WREADY),
        .s_axi_wstrb(s01_couplers_to_s01_regslice_WSTRB),
        .s_axi_wvalid(s01_couplers_to_s01_regslice_WVALID));
endmodule
