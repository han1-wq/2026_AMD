-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2022.1 (lin64) Build 3526262 Mon Apr 18 15:47:01 MDT 2022
-- Date        : Wed Oct 14 01:46:18 2026
-- Host        : ubuntu running 64-bit Ubuntu 20.04.1 LTS
-- Command     : write_vhdl -force -mode funcsim
--               /home/amd/Workspace/dpu_platform2/kv260_vitis_platform/dpu_trd_system_hw_link/Hardware/dpu.build/link/vivado/vpl/prj/prj.gen/sources_1/bd/kv260_hardware_platform/ip/kv260_hardware_platform_DPUCZDX8G_1_0/kv260_hardware_platform_DPUCZDX8G_1_0_sim_netlist.vhdl
-- Design      : kv260_hardware_platform_DPUCZDX8G_1_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xck26-sfvc784-2LV-c
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity kv260_hardware_platform_DPUCZDX8G_1_0 is
  port (
    M_AXI_GP0_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_GP0_arburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_GP0_arcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_arlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    M_AXI_GP0_arlock : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_GP0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_GP0_arqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_arready : in STD_LOGIC;
    M_AXI_GP0_arsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_GP0_arvalid : out STD_LOGIC;
    M_AXI_GP0_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_GP0_awburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_GP0_awcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_awlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    M_AXI_GP0_awlock : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_GP0_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_GP0_awqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_awready : in STD_LOGIC;
    M_AXI_GP0_awsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_GP0_awvalid : out STD_LOGIC;
    M_AXI_GP0_bready : out STD_LOGIC;
    M_AXI_GP0_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_GP0_bvalid : in STD_LOGIC;
    M_AXI_GP0_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_GP0_rlast : in STD_LOGIC;
    M_AXI_GP0_rready : out STD_LOGIC;
    M_AXI_GP0_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_GP0_rvalid : in STD_LOGIC;
    M_AXI_GP0_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_GP0_wlast : out STD_LOGIC;
    M_AXI_GP0_wready : in STD_LOGIC;
    M_AXI_GP0_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_wvalid : out STD_LOGIC;
    M_AXI_GP0_aruser : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_GP0_awuser : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_HP0_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_HP0_arburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_HP0_arcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_HP0_arlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    M_AXI_HP0_arlock : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_HP0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_HP0_arqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_HP0_arready : in STD_LOGIC;
    M_AXI_HP0_arsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_HP0_arvalid : out STD_LOGIC;
    M_AXI_HP0_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_HP0_awburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_HP0_awcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_HP0_awlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    M_AXI_HP0_awlock : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_HP0_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_HP0_awqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_HP0_awready : in STD_LOGIC;
    M_AXI_HP0_awsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_HP0_awvalid : out STD_LOGIC;
    M_AXI_HP0_bready : out STD_LOGIC;
    M_AXI_HP0_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_HP0_bvalid : in STD_LOGIC;
    M_AXI_HP0_rdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    M_AXI_HP0_rlast : in STD_LOGIC;
    M_AXI_HP0_rready : out STD_LOGIC;
    M_AXI_HP0_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_HP0_rvalid : in STD_LOGIC;
    M_AXI_HP0_wdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    M_AXI_HP0_wlast : out STD_LOGIC;
    M_AXI_HP0_wready : in STD_LOGIC;
    M_AXI_HP0_wstrb : out STD_LOGIC_VECTOR ( 15 downto 0 );
    M_AXI_HP0_wvalid : out STD_LOGIC;
    M_AXI_HP0_aruser : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_HP0_awuser : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_HP2_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_HP2_arburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_HP2_arcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_HP2_arlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    M_AXI_HP2_arlock : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_HP2_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_HP2_arqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_HP2_arready : in STD_LOGIC;
    M_AXI_HP2_arsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_HP2_arvalid : out STD_LOGIC;
    M_AXI_HP2_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_HP2_awburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_HP2_awcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_HP2_awlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    M_AXI_HP2_awlock : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_HP2_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_HP2_awqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_HP2_awready : in STD_LOGIC;
    M_AXI_HP2_awsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_HP2_awvalid : out STD_LOGIC;
    M_AXI_HP2_bready : out STD_LOGIC;
    M_AXI_HP2_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_HP2_bvalid : in STD_LOGIC;
    M_AXI_HP2_rdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    M_AXI_HP2_rlast : in STD_LOGIC;
    M_AXI_HP2_rready : out STD_LOGIC;
    M_AXI_HP2_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_HP2_rvalid : in STD_LOGIC;
    M_AXI_HP2_wdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    M_AXI_HP2_wlast : out STD_LOGIC;
    M_AXI_HP2_wready : in STD_LOGIC;
    M_AXI_HP2_wstrb : out STD_LOGIC_VECTOR ( 15 downto 0 );
    M_AXI_HP2_wvalid : out STD_LOGIC;
    M_AXI_HP2_aruser : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_HP2_awuser : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_CONTROL_araddr : in STD_LOGIC_VECTOR ( 11 downto 0 );
    S_AXI_CONTROL_arready : out STD_LOGIC;
    S_AXI_CONTROL_arvalid : in STD_LOGIC;
    S_AXI_CONTROL_awaddr : in STD_LOGIC_VECTOR ( 11 downto 0 );
    S_AXI_CONTROL_awready : out STD_LOGIC;
    S_AXI_CONTROL_awvalid : in STD_LOGIC;
    S_AXI_CONTROL_bready : in STD_LOGIC;
    S_AXI_CONTROL_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_CONTROL_bvalid : out STD_LOGIC;
    S_AXI_CONTROL_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_CONTROL_rready : in STD_LOGIC;
    S_AXI_CONTROL_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_CONTROL_rvalid : out STD_LOGIC;
    S_AXI_CONTROL_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_CONTROL_wready : out STD_LOGIC;
    S_AXI_CONTROL_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_CONTROL_wvalid : in STD_LOGIC;
    aclk : in STD_LOGIC;
    ap_clk_2 : in STD_LOGIC;
    ap_rst_n_2 : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    interrupt : out STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of kv260_hardware_platform_DPUCZDX8G_1_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of kv260_hardware_platform_DPUCZDX8G_1_0 : entity is "kv260_hardware_platform_DPUCZDX8G_1_0,DPUCZDX8G,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of kv260_hardware_platform_DPUCZDX8G_1_0 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of kv260_hardware_platform_DPUCZDX8G_1_0 : entity is "package_project";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of kv260_hardware_platform_DPUCZDX8G_1_0 : entity is "DPUCZDX8G,Vivado 2022.1";
end kv260_hardware_platform_DPUCZDX8G_1_0;

architecture STRUCTURE of kv260_hardware_platform_DPUCZDX8G_1_0 is
  component kv260_hardware_platform_DPUCZDX8G_1_0_DPUCZDX8G is
  port (
    M_AXI_GP0_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_GP0_arburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_GP0_arcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_arlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    M_AXI_GP0_arlock : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_GP0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_GP0_arqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_arready : in STD_LOGIC;
    M_AXI_GP0_arsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_GP0_arvalid : out STD_LOGIC;
    M_AXI_GP0_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_GP0_awburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_GP0_awcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_awlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    M_AXI_GP0_awlock : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_GP0_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_GP0_awqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_awready : in STD_LOGIC;
    M_AXI_GP0_awsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_GP0_awvalid : out STD_LOGIC;
    M_AXI_GP0_bready : out STD_LOGIC;
    M_AXI_GP0_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_GP0_bvalid : in STD_LOGIC;
    M_AXI_GP0_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_GP0_rlast : in STD_LOGIC;
    M_AXI_GP0_rready : out STD_LOGIC;
    M_AXI_GP0_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_GP0_rvalid : in STD_LOGIC;
    M_AXI_GP0_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_GP0_wlast : out STD_LOGIC;
    M_AXI_GP0_wready : in STD_LOGIC;
    M_AXI_GP0_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_wvalid : out STD_LOGIC;
    M_AXI_GP0_aruser : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_GP0_awuser : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_HP0_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_HP0_arburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_HP0_arcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_HP0_arlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    M_AXI_HP0_arlock : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_HP0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_HP0_arqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_HP0_arready : in STD_LOGIC;
    M_AXI_HP0_arsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_HP0_arvalid : out STD_LOGIC;
    M_AXI_HP0_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_HP0_awburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_HP0_awcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_HP0_awlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    M_AXI_HP0_awlock : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_HP0_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_HP0_awqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_HP0_awready : in STD_LOGIC;
    M_AXI_HP0_awsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_HP0_awvalid : out STD_LOGIC;
    M_AXI_HP0_bready : out STD_LOGIC;
    M_AXI_HP0_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_HP0_bvalid : in STD_LOGIC;
    M_AXI_HP0_rdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    M_AXI_HP0_rlast : in STD_LOGIC;
    M_AXI_HP0_rready : out STD_LOGIC;
    M_AXI_HP0_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_HP0_rvalid : in STD_LOGIC;
    M_AXI_HP0_wdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    M_AXI_HP0_wlast : out STD_LOGIC;
    M_AXI_HP0_wready : in STD_LOGIC;
    M_AXI_HP0_wstrb : out STD_LOGIC_VECTOR ( 15 downto 0 );
    M_AXI_HP0_wvalid : out STD_LOGIC;
    M_AXI_HP0_aruser : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_HP0_awuser : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_HP2_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_HP2_arburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_HP2_arcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_HP2_arlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    M_AXI_HP2_arlock : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_HP2_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_HP2_arqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_HP2_arready : in STD_LOGIC;
    M_AXI_HP2_arsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_HP2_arvalid : out STD_LOGIC;
    M_AXI_HP2_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_HP2_awburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_HP2_awcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_HP2_awlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    M_AXI_HP2_awlock : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_HP2_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_HP2_awqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_HP2_awready : in STD_LOGIC;
    M_AXI_HP2_awsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_HP2_awvalid : out STD_LOGIC;
    M_AXI_HP2_bready : out STD_LOGIC;
    M_AXI_HP2_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_HP2_bvalid : in STD_LOGIC;
    M_AXI_HP2_rdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    M_AXI_HP2_rlast : in STD_LOGIC;
    M_AXI_HP2_rready : out STD_LOGIC;
    M_AXI_HP2_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_HP2_rvalid : in STD_LOGIC;
    M_AXI_HP2_wdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    M_AXI_HP2_wlast : out STD_LOGIC;
    M_AXI_HP2_wready : in STD_LOGIC;
    M_AXI_HP2_wstrb : out STD_LOGIC_VECTOR ( 15 downto 0 );
    M_AXI_HP2_wvalid : out STD_LOGIC;
    M_AXI_HP2_aruser : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_HP2_awuser : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_CONTROL_araddr : in STD_LOGIC_VECTOR ( 11 downto 0 );
    S_AXI_CONTROL_arready : out STD_LOGIC;
    S_AXI_CONTROL_arvalid : in STD_LOGIC;
    S_AXI_CONTROL_awaddr : in STD_LOGIC_VECTOR ( 11 downto 0 );
    S_AXI_CONTROL_awready : out STD_LOGIC;
    S_AXI_CONTROL_awvalid : in STD_LOGIC;
    S_AXI_CONTROL_bready : in STD_LOGIC;
    S_AXI_CONTROL_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_CONTROL_bvalid : out STD_LOGIC;
    S_AXI_CONTROL_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_CONTROL_rready : in STD_LOGIC;
    S_AXI_CONTROL_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_CONTROL_rvalid : out STD_LOGIC;
    S_AXI_CONTROL_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_CONTROL_wready : out STD_LOGIC;
    S_AXI_CONTROL_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_CONTROL_wvalid : in STD_LOGIC;
    aclk : in STD_LOGIC;
    ap_clk_2 : in STD_LOGIC;
    ap_rst_n_2 : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    interrupt : out STD_LOGIC
  );
  end component kv260_hardware_platform_DPUCZDX8G_1_0_DPUCZDX8G;
  signal \<const0>\ : STD_LOGIC;
  signal \<const1>\ : STD_LOGIC;
  signal \^m_axi_gp0_araddr\ : STD_LOGIC_VECTOR ( 39 downto 3 );
  signal \^m_axi_hp0_arlen\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \^m_axi_hp2_arlen\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_inst_M_AXI_GP0_awvalid_UNCONNECTED : STD_LOGIC;
  signal NLW_inst_M_AXI_GP0_bready_UNCONNECTED : STD_LOGIC;
  signal NLW_inst_M_AXI_GP0_wlast_UNCONNECTED : STD_LOGIC;
  signal NLW_inst_M_AXI_GP0_wvalid_UNCONNECTED : STD_LOGIC;
  signal NLW_inst_M_AXI_HP0_bready_UNCONNECTED : STD_LOGIC;
  signal NLW_inst_M_AXI_HP2_bready_UNCONNECTED : STD_LOGIC;
  signal NLW_inst_M_AXI_GP0_araddr_UNCONNECTED : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal NLW_inst_M_AXI_GP0_arburst_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_inst_M_AXI_GP0_arcache_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_inst_M_AXI_GP0_arlen_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_inst_M_AXI_GP0_arlock_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_inst_M_AXI_GP0_arprot_UNCONNECTED : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal NLW_inst_M_AXI_GP0_arqos_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_inst_M_AXI_GP0_arsize_UNCONNECTED : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal NLW_inst_M_AXI_GP0_aruser_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_inst_M_AXI_GP0_awaddr_UNCONNECTED : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal NLW_inst_M_AXI_GP0_awburst_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_inst_M_AXI_GP0_awcache_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_inst_M_AXI_GP0_awlen_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_inst_M_AXI_GP0_awlock_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_inst_M_AXI_GP0_awprot_UNCONNECTED : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal NLW_inst_M_AXI_GP0_awqos_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_inst_M_AXI_GP0_awsize_UNCONNECTED : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal NLW_inst_M_AXI_GP0_awuser_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_inst_M_AXI_GP0_wdata_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_inst_M_AXI_GP0_wstrb_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_inst_M_AXI_HP0_arburst_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_inst_M_AXI_HP0_arcache_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_inst_M_AXI_HP0_arlen_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 4 );
  signal NLW_inst_M_AXI_HP0_arlock_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_inst_M_AXI_HP0_arprot_UNCONNECTED : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal NLW_inst_M_AXI_HP0_arqos_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_inst_M_AXI_HP0_arsize_UNCONNECTED : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal NLW_inst_M_AXI_HP0_aruser_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_inst_M_AXI_HP0_awburst_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_inst_M_AXI_HP0_awcache_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_inst_M_AXI_HP0_awlock_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_inst_M_AXI_HP0_awprot_UNCONNECTED : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal NLW_inst_M_AXI_HP0_awqos_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_inst_M_AXI_HP0_awsize_UNCONNECTED : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal NLW_inst_M_AXI_HP0_awuser_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_inst_M_AXI_HP2_arburst_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_inst_M_AXI_HP2_arcache_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_inst_M_AXI_HP2_arlen_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 4 );
  signal NLW_inst_M_AXI_HP2_arlock_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_inst_M_AXI_HP2_arprot_UNCONNECTED : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal NLW_inst_M_AXI_HP2_arqos_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_inst_M_AXI_HP2_arsize_UNCONNECTED : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal NLW_inst_M_AXI_HP2_aruser_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_inst_M_AXI_HP2_awburst_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_inst_M_AXI_HP2_awcache_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_inst_M_AXI_HP2_awlock_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_inst_M_AXI_HP2_awprot_UNCONNECTED : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal NLW_inst_M_AXI_HP2_awqos_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_inst_M_AXI_HP2_awsize_UNCONNECTED : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal NLW_inst_M_AXI_HP2_awuser_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_inst_S_AXI_CONTROL_bresp_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_inst_S_AXI_CONTROL_rresp_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  attribute ALU_LEAKYRELU : integer;
  attribute ALU_LEAKYRELU of inst : label is 0;
  attribute ALU_PARALLEL : integer;
  attribute ALU_PARALLEL of inst : label is 4;
  attribute ARCH_DATA_BW : integer;
  attribute ARCH_DATA_BW of inst : label is 1;
  attribute ARCH_HP_BW : integer;
  attribute ARCH_HP_BW of inst : label is 3;
  attribute ARCH_ICP : integer;
  attribute ARCH_ICP of inst : label is 14;
  attribute ARCH_IMG_BKGRP : integer;
  attribute ARCH_IMG_BKGRP of inst : label is 2;
  attribute ARCH_OCP : integer;
  attribute ARCH_OCP of inst : label is 14;
  attribute ARCH_PP : integer;
  attribute ARCH_PP of inst : label is 8;
  attribute AWRLEN_BW : integer;
  attribute AWRLEN_BW of inst : label is 8;
  attribute AWRLOCK_BW : integer;
  attribute AWRLOCK_BW of inst : label is 1;
  attribute AWRUSER_BW : integer;
  attribute AWRUSER_BW of inst : label is 1;
  attribute CONV_DSP_ACCU_ENA : integer;
  attribute CONV_DSP_ACCU_ENA of inst : label is 1;
  attribute CONV_DSP_CASC_MAX : integer;
  attribute CONV_DSP_CASC_MAX of inst : label is 4;
  attribute CONV_LEAKYRELU : integer;
  attribute CONV_LEAKYRELU of inst : label is 1;
  attribute CONV_RELU6 : integer;
  attribute CONV_RELU6 of inst : label is 1;
  attribute CONV_RELU_ADDON : string;
  attribute CONV_RELU_ADDON of inst : label is "4'b0011";
  attribute CONV_RM_0x80_ENA : integer;
  attribute CONV_RM_0x80_ENA of inst : label is 0;
  attribute CONV_WR_PARALLEL : integer;
  attribute CONV_WR_PARALLEL of inst : label is 1;
  attribute DBANK_BIAS : integer;
  attribute DBANK_BIAS of inst : label is 0;
  attribute DBANK_IMG_N : integer;
  attribute DBANK_IMG_N of inst : label is 0;
  attribute DBANK_WGT_N : integer;
  attribute DBANK_WGT_N of inst : label is 0;
  attribute DNNDK_PRINT : string;
  attribute DNNDK_PRINT of inst : label is "xrt test";
  attribute DPU_WORK_CNT_EN : integer;
  attribute DPU_WORK_CNT_EN of inst : label is 0;
  attribute DSP48_VER : string;
  attribute DSP48_VER of inst : label is "DSP48E2";
  attribute ELEW_PARALLEL : integer;
  attribute ELEW_PARALLEL of inst : label is 4;
  attribute GIT_COMMIT_ID : string;
  attribute GIT_COMMIT_ID of inst : label is "28'b0100011101110010110101010001";
  attribute GIT_COMMIT_TIME : integer;
  attribute GIT_COMMIT_TIME of inst : label is 2022051323;
  attribute GP_ID_BW : integer;
  attribute GP_ID_BW of inst : label is 6;
  attribute HP0_ID_BW : integer;
  attribute HP0_ID_BW of inst : label is 6;
  attribute HP1_ID_BW : integer;
  attribute HP1_ID_BW of inst : label is 6;
  attribute HP2_ID_BW : integer;
  attribute HP2_ID_BW of inst : label is 6;
  attribute HP3_ID_BW : integer;
  attribute HP3_ID_BW of inst : label is 6;
  attribute HP_DATA_BW : integer;
  attribute HP_DATA_BW of inst : label is 128;
  attribute LOAD_AUGM : integer;
  attribute LOAD_AUGM of inst : label is 1;
  attribute LOAD_IMG_MEAN : integer;
  attribute LOAD_IMG_MEAN of inst : label is 0;
  attribute LOAD_PARALLEL : integer;
  attribute LOAD_PARALLEL of inst : label is 2;
  attribute MISC_WR_PARALLEL : integer;
  attribute MISC_WR_PARALLEL of inst : label is 1;
  attribute M_AXI_FREQ_MHZ : integer;
  attribute M_AXI_FREQ_MHZ of inst : label is 300;
  attribute RAM_DEPTH_BIAS : integer;
  attribute RAM_DEPTH_BIAS of inst : label is 3;
  attribute RAM_DEPTH_IMG : integer;
  attribute RAM_DEPTH_IMG of inst : label is 3;
  attribute RAM_DEPTH_MEAN : integer;
  attribute RAM_DEPTH_MEAN of inst : label is 1;
  attribute RAM_DEPTH_WGT : integer;
  attribute RAM_DEPTH_WGT of inst : label is 3;
  attribute SAVE_PARALLEL : integer;
  attribute SAVE_PARALLEL of inst : label is 2;
  attribute SDX_KERNEL : string;
  attribute SDX_KERNEL of inst : label is "true";
  attribute SDX_KERNEL_SYNTH_INST : string;
  attribute SDX_KERNEL_SYNTH_INST of inst : label is "inst";
  attribute SDX_KERNEL_TYPE : string;
  attribute SDX_KERNEL_TYPE of inst : label is "rtl";
  attribute SIZE_REGMAP_SIZE : integer;
  attribute SIZE_REGMAP_SIZE of inst : label is 107;
  attribute SYS_IP_TYPE : integer;
  attribute SYS_IP_TYPE of inst : label is 1;
  attribute SYS_IP_VER : integer;
  attribute SYS_IP_VER of inst : label is 64;
  attribute SYS_REGMAP_VER : integer;
  attribute SYS_REGMAP_VER of inst : label is 2;
  attribute S_AXI_FREQ_MHZ : integer;
  attribute S_AXI_FREQ_MHZ of inst : label is 300;
  attribute TIME_DAY : integer;
  attribute TIME_DAY of inst : label is 14;
  attribute TIME_HOUR : integer;
  attribute TIME_HOUR of inst : label is 14;
  attribute TIME_MONTH : integer;
  attribute TIME_MONTH of inst : label is 5;
  attribute TIME_QUARTER : integer;
  attribute TIME_QUARTER of inst : label is 2;
  attribute TIME_YEAR : integer;
  attribute TIME_YEAR of inst : label is 22;
  attribute UBANK_BIAS : integer;
  attribute UBANK_BIAS of inst : label is 1;
  attribute UBANK_IMG_N : integer;
  attribute UBANK_IMG_N of inst : label is 4;
  attribute UBANK_WGT_N : integer;
  attribute UBANK_WGT_N of inst : label is 15;
  attribute VER_IP_REV : integer;
  attribute VER_IP_REV of inst : label is 0;
  attribute VER_TARGET : string;
  attribute VER_TARGET of inst : label is "12'b000101000001";
  attribute is_du_within_envelope : string;
  attribute is_du_within_envelope of inst : label is "true";
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of M_AXI_GP0_arready : signal is "xilinx.com:interface:aximm:1.0 M_AXI_GP0 ARREADY";
  attribute X_INTERFACE_INFO of M_AXI_GP0_arvalid : signal is "xilinx.com:interface:aximm:1.0 M_AXI_GP0 ARVALID";
  attribute X_INTERFACE_INFO of M_AXI_GP0_awready : signal is "xilinx.com:interface:aximm:1.0 M_AXI_GP0 AWREADY";
  attribute X_INTERFACE_INFO of M_AXI_GP0_awvalid : signal is "xilinx.com:interface:aximm:1.0 M_AXI_GP0 AWVALID";
  attribute X_INTERFACE_INFO of M_AXI_GP0_bready : signal is "xilinx.com:interface:aximm:1.0 M_AXI_GP0 BREADY";
  attribute X_INTERFACE_INFO of M_AXI_GP0_bvalid : signal is "xilinx.com:interface:aximm:1.0 M_AXI_GP0 BVALID";
  attribute X_INTERFACE_INFO of M_AXI_GP0_rlast : signal is "xilinx.com:interface:aximm:1.0 M_AXI_GP0 RLAST";
  attribute X_INTERFACE_INFO of M_AXI_GP0_rready : signal is "xilinx.com:interface:aximm:1.0 M_AXI_GP0 RREADY";
  attribute X_INTERFACE_INFO of M_AXI_GP0_rvalid : signal is "xilinx.com:interface:aximm:1.0 M_AXI_GP0 RVALID";
  attribute X_INTERFACE_INFO of M_AXI_GP0_wlast : signal is "xilinx.com:interface:aximm:1.0 M_AXI_GP0 WLAST";
  attribute X_INTERFACE_INFO of M_AXI_GP0_wready : signal is "xilinx.com:interface:aximm:1.0 M_AXI_GP0 WREADY";
  attribute X_INTERFACE_INFO of M_AXI_GP0_wvalid : signal is "xilinx.com:interface:aximm:1.0 M_AXI_GP0 WVALID";
  attribute X_INTERFACE_INFO of M_AXI_HP0_arready : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP0 ARREADY";
  attribute X_INTERFACE_INFO of M_AXI_HP0_arvalid : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP0 ARVALID";
  attribute X_INTERFACE_INFO of M_AXI_HP0_awready : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP0 AWREADY";
  attribute X_INTERFACE_INFO of M_AXI_HP0_awvalid : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP0 AWVALID";
  attribute X_INTERFACE_INFO of M_AXI_HP0_bready : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP0 BREADY";
  attribute X_INTERFACE_INFO of M_AXI_HP0_bvalid : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP0 BVALID";
  attribute X_INTERFACE_INFO of M_AXI_HP0_rlast : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP0 RLAST";
  attribute X_INTERFACE_INFO of M_AXI_HP0_rready : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP0 RREADY";
  attribute X_INTERFACE_INFO of M_AXI_HP0_rvalid : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP0 RVALID";
  attribute X_INTERFACE_INFO of M_AXI_HP0_wlast : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP0 WLAST";
  attribute X_INTERFACE_INFO of M_AXI_HP0_wready : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP0 WREADY";
  attribute X_INTERFACE_INFO of M_AXI_HP0_wvalid : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP0 WVALID";
  attribute X_INTERFACE_INFO of M_AXI_HP2_arready : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP2 ARREADY";
  attribute X_INTERFACE_INFO of M_AXI_HP2_arvalid : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP2 ARVALID";
  attribute X_INTERFACE_INFO of M_AXI_HP2_awready : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP2 AWREADY";
  attribute X_INTERFACE_INFO of M_AXI_HP2_awvalid : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP2 AWVALID";
  attribute X_INTERFACE_INFO of M_AXI_HP2_bready : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP2 BREADY";
  attribute X_INTERFACE_INFO of M_AXI_HP2_bvalid : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP2 BVALID";
  attribute X_INTERFACE_INFO of M_AXI_HP2_rlast : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP2 RLAST";
  attribute X_INTERFACE_INFO of M_AXI_HP2_rready : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP2 RREADY";
  attribute X_INTERFACE_INFO of M_AXI_HP2_rvalid : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP2 RVALID";
  attribute X_INTERFACE_INFO of M_AXI_HP2_wlast : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP2 WLAST";
  attribute X_INTERFACE_INFO of M_AXI_HP2_wready : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP2 WREADY";
  attribute X_INTERFACE_INFO of M_AXI_HP2_wvalid : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP2 WVALID";
  attribute X_INTERFACE_INFO of S_AXI_CONTROL_arready : signal is "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL ARREADY";
  attribute X_INTERFACE_INFO of S_AXI_CONTROL_arvalid : signal is "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL ARVALID";
  attribute X_INTERFACE_INFO of S_AXI_CONTROL_awready : signal is "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL AWREADY";
  attribute X_INTERFACE_INFO of S_AXI_CONTROL_awvalid : signal is "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL AWVALID";
  attribute X_INTERFACE_INFO of S_AXI_CONTROL_bready : signal is "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL BREADY";
  attribute X_INTERFACE_INFO of S_AXI_CONTROL_bvalid : signal is "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL BVALID";
  attribute X_INTERFACE_INFO of S_AXI_CONTROL_rready : signal is "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL RREADY";
  attribute X_INTERFACE_INFO of S_AXI_CONTROL_rvalid : signal is "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL RVALID";
  attribute X_INTERFACE_INFO of S_AXI_CONTROL_wready : signal is "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL WREADY";
  attribute X_INTERFACE_INFO of S_AXI_CONTROL_wvalid : signal is "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL WVALID";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of S_AXI_CONTROL_wvalid : signal is "XIL_INTERFACENAME S_AXI_CONTROL, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 299997000, ID_WIDTH 0, ADDR_WIDTH 12, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN kv260_hardware_platform_clk_wiz_0_1_clk_out1, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of aclk : signal is "xilinx.com:signal:clock:1.0 aclk CLK";
  attribute X_INTERFACE_PARAMETER of aclk : signal is "XIL_INTERFACENAME aclk, ASSOCIATED_BUSIF M_AXI_GP0:M_AXI_HP0:M_AXI_HP2:S_AXI_CONTROL, ASSOCIATED_RESET aresetn, FREQ_HZ 299997000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN kv260_hardware_platform_clk_wiz_0_1_clk_out1, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of ap_clk_2 : signal is "xilinx.com:signal:clock:1.0 ap_clk_2 CLK";
  attribute X_INTERFACE_PARAMETER of ap_clk_2 : signal is "XIL_INTERFACENAME ap_clk_2, ASSOCIATED_RESET ap_rst_n_2, FREQ_HZ 599994000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN kv260_hardware_platform_clk_wiz_0_1_clk_out1, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of ap_rst_n_2 : signal is "xilinx.com:signal:reset:1.0 ap_rst_n_2 RST";
  attribute X_INTERFACE_PARAMETER of ap_rst_n_2 : signal is "XIL_INTERFACENAME ap_rst_n_2, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of aresetn : signal is "xilinx.com:signal:reset:1.0 aresetn RST";
  attribute X_INTERFACE_PARAMETER of aresetn : signal is "XIL_INTERFACENAME aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of interrupt : signal is "xilinx.com:signal:interrupt:1.0 interrupt INTERRUPT";
  attribute X_INTERFACE_PARAMETER of interrupt : signal is "XIL_INTERFACENAME interrupt, SENSITIVITY LEVEL_HIGH, PortWidth 1";
  attribute X_INTERFACE_INFO of M_AXI_GP0_araddr : signal is "xilinx.com:interface:aximm:1.0 M_AXI_GP0 ARADDR";
  attribute X_INTERFACE_INFO of M_AXI_GP0_arburst : signal is "xilinx.com:interface:aximm:1.0 M_AXI_GP0 ARBURST";
  attribute X_INTERFACE_INFO of M_AXI_GP0_arcache : signal is "xilinx.com:interface:aximm:1.0 M_AXI_GP0 ARCACHE";
  attribute X_INTERFACE_INFO of M_AXI_GP0_arlen : signal is "xilinx.com:interface:aximm:1.0 M_AXI_GP0 ARLEN";
  attribute X_INTERFACE_INFO of M_AXI_GP0_arlock : signal is "xilinx.com:interface:aximm:1.0 M_AXI_GP0 ARLOCK";
  attribute X_INTERFACE_INFO of M_AXI_GP0_arprot : signal is "xilinx.com:interface:aximm:1.0 M_AXI_GP0 ARPROT";
  attribute X_INTERFACE_INFO of M_AXI_GP0_arqos : signal is "xilinx.com:interface:aximm:1.0 M_AXI_GP0 ARQOS";
  attribute X_INTERFACE_INFO of M_AXI_GP0_arsize : signal is "xilinx.com:interface:aximm:1.0 M_AXI_GP0 ARSIZE";
  attribute X_INTERFACE_INFO of M_AXI_GP0_aruser : signal is "xilinx.com:interface:aximm:1.0 M_AXI_GP0 ARUSER";
  attribute X_INTERFACE_INFO of M_AXI_GP0_awaddr : signal is "xilinx.com:interface:aximm:1.0 M_AXI_GP0 AWADDR";
  attribute X_INTERFACE_INFO of M_AXI_GP0_awburst : signal is "xilinx.com:interface:aximm:1.0 M_AXI_GP0 AWBURST";
  attribute X_INTERFACE_INFO of M_AXI_GP0_awcache : signal is "xilinx.com:interface:aximm:1.0 M_AXI_GP0 AWCACHE";
  attribute X_INTERFACE_INFO of M_AXI_GP0_awlen : signal is "xilinx.com:interface:aximm:1.0 M_AXI_GP0 AWLEN";
  attribute X_INTERFACE_INFO of M_AXI_GP0_awlock : signal is "xilinx.com:interface:aximm:1.0 M_AXI_GP0 AWLOCK";
  attribute X_INTERFACE_INFO of M_AXI_GP0_awprot : signal is "xilinx.com:interface:aximm:1.0 M_AXI_GP0 AWPROT";
  attribute X_INTERFACE_INFO of M_AXI_GP0_awqos : signal is "xilinx.com:interface:aximm:1.0 M_AXI_GP0 AWQOS";
  attribute X_INTERFACE_INFO of M_AXI_GP0_awsize : signal is "xilinx.com:interface:aximm:1.0 M_AXI_GP0 AWSIZE";
  attribute X_INTERFACE_INFO of M_AXI_GP0_awuser : signal is "xilinx.com:interface:aximm:1.0 M_AXI_GP0 AWUSER";
  attribute X_INTERFACE_PARAMETER of M_AXI_GP0_awuser : signal is "XIL_INTERFACENAME M_AXI_GP0, DATA_WIDTH 32, PROTOCOL AXI4, FREQ_HZ 299997000, ID_WIDTH 0, ADDR_WIDTH 40, AWUSER_WIDTH 1, ARUSER_WIDTH 1, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 1, HAS_LOCK 1, HAS_PROT 1, HAS_CACHE 1, HAS_QOS 1, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 1, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 256, PHASE 0.0, CLK_DOMAIN kv260_hardware_platform_clk_wiz_0_1_clk_out1, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of M_AXI_GP0_bresp : signal is "xilinx.com:interface:aximm:1.0 M_AXI_GP0 BRESP";
  attribute X_INTERFACE_INFO of M_AXI_GP0_rdata : signal is "xilinx.com:interface:aximm:1.0 M_AXI_GP0 RDATA";
  attribute X_INTERFACE_INFO of M_AXI_GP0_rresp : signal is "xilinx.com:interface:aximm:1.0 M_AXI_GP0 RRESP";
  attribute X_INTERFACE_INFO of M_AXI_GP0_wdata : signal is "xilinx.com:interface:aximm:1.0 M_AXI_GP0 WDATA";
  attribute X_INTERFACE_INFO of M_AXI_GP0_wstrb : signal is "xilinx.com:interface:aximm:1.0 M_AXI_GP0 WSTRB";
  attribute X_INTERFACE_INFO of M_AXI_HP0_araddr : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP0 ARADDR";
  attribute X_INTERFACE_INFO of M_AXI_HP0_arburst : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP0 ARBURST";
  attribute X_INTERFACE_INFO of M_AXI_HP0_arcache : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP0 ARCACHE";
  attribute X_INTERFACE_INFO of M_AXI_HP0_arlen : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP0 ARLEN";
  attribute X_INTERFACE_INFO of M_AXI_HP0_arlock : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP0 ARLOCK";
  attribute X_INTERFACE_INFO of M_AXI_HP0_arprot : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP0 ARPROT";
  attribute X_INTERFACE_INFO of M_AXI_HP0_arqos : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP0 ARQOS";
  attribute X_INTERFACE_INFO of M_AXI_HP0_arsize : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP0 ARSIZE";
  attribute X_INTERFACE_INFO of M_AXI_HP0_aruser : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP0 ARUSER";
  attribute X_INTERFACE_INFO of M_AXI_HP0_awaddr : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP0 AWADDR";
  attribute X_INTERFACE_INFO of M_AXI_HP0_awburst : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP0 AWBURST";
  attribute X_INTERFACE_INFO of M_AXI_HP0_awcache : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP0 AWCACHE";
  attribute X_INTERFACE_INFO of M_AXI_HP0_awlen : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP0 AWLEN";
  attribute X_INTERFACE_INFO of M_AXI_HP0_awlock : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP0 AWLOCK";
  attribute X_INTERFACE_INFO of M_AXI_HP0_awprot : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP0 AWPROT";
  attribute X_INTERFACE_INFO of M_AXI_HP0_awqos : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP0 AWQOS";
  attribute X_INTERFACE_INFO of M_AXI_HP0_awsize : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP0 AWSIZE";
  attribute X_INTERFACE_INFO of M_AXI_HP0_awuser : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP0 AWUSER";
  attribute X_INTERFACE_PARAMETER of M_AXI_HP0_awuser : signal is "XIL_INTERFACENAME M_AXI_HP0, DATA_WIDTH 128, PROTOCOL AXI4, FREQ_HZ 299997000, ID_WIDTH 0, ADDR_WIDTH 40, AWUSER_WIDTH 1, ARUSER_WIDTH 1, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 1, HAS_LOCK 1, HAS_PROT 1, HAS_CACHE 1, HAS_QOS 1, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 1, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 256, PHASE 0.0, CLK_DOMAIN kv260_hardware_platform_clk_wiz_0_1_clk_out1, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of M_AXI_HP0_bresp : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP0 BRESP";
  attribute X_INTERFACE_INFO of M_AXI_HP0_rdata : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP0 RDATA";
  attribute X_INTERFACE_INFO of M_AXI_HP0_rresp : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP0 RRESP";
  attribute X_INTERFACE_INFO of M_AXI_HP0_wdata : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP0 WDATA";
  attribute X_INTERFACE_INFO of M_AXI_HP0_wstrb : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP0 WSTRB";
  attribute X_INTERFACE_INFO of M_AXI_HP2_araddr : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP2 ARADDR";
  attribute X_INTERFACE_INFO of M_AXI_HP2_arburst : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP2 ARBURST";
  attribute X_INTERFACE_INFO of M_AXI_HP2_arcache : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP2 ARCACHE";
  attribute X_INTERFACE_INFO of M_AXI_HP2_arlen : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP2 ARLEN";
  attribute X_INTERFACE_INFO of M_AXI_HP2_arlock : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP2 ARLOCK";
  attribute X_INTERFACE_INFO of M_AXI_HP2_arprot : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP2 ARPROT";
  attribute X_INTERFACE_INFO of M_AXI_HP2_arqos : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP2 ARQOS";
  attribute X_INTERFACE_INFO of M_AXI_HP2_arsize : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP2 ARSIZE";
  attribute X_INTERFACE_INFO of M_AXI_HP2_aruser : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP2 ARUSER";
  attribute X_INTERFACE_INFO of M_AXI_HP2_awaddr : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP2 AWADDR";
  attribute X_INTERFACE_INFO of M_AXI_HP2_awburst : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP2 AWBURST";
  attribute X_INTERFACE_INFO of M_AXI_HP2_awcache : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP2 AWCACHE";
  attribute X_INTERFACE_INFO of M_AXI_HP2_awlen : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP2 AWLEN";
  attribute X_INTERFACE_INFO of M_AXI_HP2_awlock : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP2 AWLOCK";
  attribute X_INTERFACE_INFO of M_AXI_HP2_awprot : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP2 AWPROT";
  attribute X_INTERFACE_INFO of M_AXI_HP2_awqos : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP2 AWQOS";
  attribute X_INTERFACE_INFO of M_AXI_HP2_awsize : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP2 AWSIZE";
  attribute X_INTERFACE_INFO of M_AXI_HP2_awuser : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP2 AWUSER";
  attribute X_INTERFACE_PARAMETER of M_AXI_HP2_awuser : signal is "XIL_INTERFACENAME M_AXI_HP2, DATA_WIDTH 128, PROTOCOL AXI4, FREQ_HZ 299997000, ID_WIDTH 0, ADDR_WIDTH 40, AWUSER_WIDTH 1, ARUSER_WIDTH 1, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 1, HAS_LOCK 1, HAS_PROT 1, HAS_CACHE 1, HAS_QOS 1, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 1, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 256, PHASE 0.0, CLK_DOMAIN kv260_hardware_platform_clk_wiz_0_1_clk_out1, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of M_AXI_HP2_bresp : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP2 BRESP";
  attribute X_INTERFACE_INFO of M_AXI_HP2_rdata : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP2 RDATA";
  attribute X_INTERFACE_INFO of M_AXI_HP2_rresp : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP2 RRESP";
  attribute X_INTERFACE_INFO of M_AXI_HP2_wdata : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP2 WDATA";
  attribute X_INTERFACE_INFO of M_AXI_HP2_wstrb : signal is "xilinx.com:interface:aximm:1.0 M_AXI_HP2 WSTRB";
  attribute X_INTERFACE_INFO of S_AXI_CONTROL_araddr : signal is "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL ARADDR";
  attribute X_INTERFACE_INFO of S_AXI_CONTROL_awaddr : signal is "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL AWADDR";
  attribute X_INTERFACE_INFO of S_AXI_CONTROL_bresp : signal is "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL BRESP";
  attribute X_INTERFACE_INFO of S_AXI_CONTROL_rdata : signal is "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL RDATA";
  attribute X_INTERFACE_INFO of S_AXI_CONTROL_rresp : signal is "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL RRESP";
  attribute X_INTERFACE_INFO of S_AXI_CONTROL_wdata : signal is "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL WDATA";
  attribute X_INTERFACE_INFO of S_AXI_CONTROL_wstrb : signal is "xilinx.com:interface:aximm:1.0 S_AXI_CONTROL WSTRB";
begin
  M_AXI_GP0_araddr(39 downto 3) <= \^m_axi_gp0_araddr\(39 downto 3);
  M_AXI_GP0_araddr(2) <= \<const0>\;
  M_AXI_GP0_araddr(1) <= \<const0>\;
  M_AXI_GP0_araddr(0) <= \<const0>\;
  M_AXI_GP0_arburst(1) <= \<const0>\;
  M_AXI_GP0_arburst(0) <= \<const1>\;
  M_AXI_GP0_arcache(3) <= \<const0>\;
  M_AXI_GP0_arcache(2) <= \<const0>\;
  M_AXI_GP0_arcache(1) <= \<const0>\;
  M_AXI_GP0_arcache(0) <= \<const0>\;
  M_AXI_GP0_arlen(7) <= \<const0>\;
  M_AXI_GP0_arlen(6) <= \<const0>\;
  M_AXI_GP0_arlen(5) <= \<const0>\;
  M_AXI_GP0_arlen(4) <= \<const0>\;
  M_AXI_GP0_arlen(3) <= \<const0>\;
  M_AXI_GP0_arlen(2) <= \<const0>\;
  M_AXI_GP0_arlen(1) <= \<const1>\;
  M_AXI_GP0_arlen(0) <= \<const1>\;
  M_AXI_GP0_arlock(0) <= \<const0>\;
  M_AXI_GP0_arprot(2) <= \<const0>\;
  M_AXI_GP0_arprot(1) <= \<const0>\;
  M_AXI_GP0_arprot(0) <= \<const0>\;
  M_AXI_GP0_arqos(3) <= \<const0>\;
  M_AXI_GP0_arqos(2) <= \<const0>\;
  M_AXI_GP0_arqos(1) <= \<const0>\;
  M_AXI_GP0_arqos(0) <= \<const0>\;
  M_AXI_GP0_arsize(2) <= \<const0>\;
  M_AXI_GP0_arsize(1) <= \<const1>\;
  M_AXI_GP0_arsize(0) <= \<const0>\;
  M_AXI_GP0_aruser(0) <= \<const0>\;
  M_AXI_GP0_awaddr(39) <= \<const0>\;
  M_AXI_GP0_awaddr(38) <= \<const0>\;
  M_AXI_GP0_awaddr(37) <= \<const0>\;
  M_AXI_GP0_awaddr(36) <= \<const0>\;
  M_AXI_GP0_awaddr(35) <= \<const0>\;
  M_AXI_GP0_awaddr(34) <= \<const0>\;
  M_AXI_GP0_awaddr(33) <= \<const0>\;
  M_AXI_GP0_awaddr(32) <= \<const0>\;
  M_AXI_GP0_awaddr(31) <= \<const0>\;
  M_AXI_GP0_awaddr(30) <= \<const0>\;
  M_AXI_GP0_awaddr(29) <= \<const0>\;
  M_AXI_GP0_awaddr(28) <= \<const0>\;
  M_AXI_GP0_awaddr(27) <= \<const0>\;
  M_AXI_GP0_awaddr(26) <= \<const0>\;
  M_AXI_GP0_awaddr(25) <= \<const0>\;
  M_AXI_GP0_awaddr(24) <= \<const0>\;
  M_AXI_GP0_awaddr(23) <= \<const0>\;
  M_AXI_GP0_awaddr(22) <= \<const0>\;
  M_AXI_GP0_awaddr(21) <= \<const0>\;
  M_AXI_GP0_awaddr(20) <= \<const0>\;
  M_AXI_GP0_awaddr(19) <= \<const0>\;
  M_AXI_GP0_awaddr(18) <= \<const0>\;
  M_AXI_GP0_awaddr(17) <= \<const0>\;
  M_AXI_GP0_awaddr(16) <= \<const0>\;
  M_AXI_GP0_awaddr(15) <= \<const0>\;
  M_AXI_GP0_awaddr(14) <= \<const0>\;
  M_AXI_GP0_awaddr(13) <= \<const0>\;
  M_AXI_GP0_awaddr(12) <= \<const0>\;
  M_AXI_GP0_awaddr(11) <= \<const0>\;
  M_AXI_GP0_awaddr(10) <= \<const0>\;
  M_AXI_GP0_awaddr(9) <= \<const0>\;
  M_AXI_GP0_awaddr(8) <= \<const0>\;
  M_AXI_GP0_awaddr(7) <= \<const0>\;
  M_AXI_GP0_awaddr(6) <= \<const0>\;
  M_AXI_GP0_awaddr(5) <= \<const0>\;
  M_AXI_GP0_awaddr(4) <= \<const0>\;
  M_AXI_GP0_awaddr(3) <= \<const0>\;
  M_AXI_GP0_awaddr(2) <= \<const0>\;
  M_AXI_GP0_awaddr(1) <= \<const0>\;
  M_AXI_GP0_awaddr(0) <= \<const0>\;
  M_AXI_GP0_awburst(1) <= \<const0>\;
  M_AXI_GP0_awburst(0) <= \<const1>\;
  M_AXI_GP0_awcache(3) <= \<const0>\;
  M_AXI_GP0_awcache(2) <= \<const0>\;
  M_AXI_GP0_awcache(1) <= \<const0>\;
  M_AXI_GP0_awcache(0) <= \<const0>\;
  M_AXI_GP0_awlen(7) <= \<const0>\;
  M_AXI_GP0_awlen(6) <= \<const0>\;
  M_AXI_GP0_awlen(5) <= \<const0>\;
  M_AXI_GP0_awlen(4) <= \<const0>\;
  M_AXI_GP0_awlen(3) <= \<const0>\;
  M_AXI_GP0_awlen(2) <= \<const0>\;
  M_AXI_GP0_awlen(1) <= \<const0>\;
  M_AXI_GP0_awlen(0) <= \<const0>\;
  M_AXI_GP0_awlock(0) <= \<const0>\;
  M_AXI_GP0_awprot(2) <= \<const0>\;
  M_AXI_GP0_awprot(1) <= \<const0>\;
  M_AXI_GP0_awprot(0) <= \<const0>\;
  M_AXI_GP0_awqos(3) <= \<const0>\;
  M_AXI_GP0_awqos(2) <= \<const0>\;
  M_AXI_GP0_awqos(1) <= \<const0>\;
  M_AXI_GP0_awqos(0) <= \<const0>\;
  M_AXI_GP0_awsize(2) <= \<const0>\;
  M_AXI_GP0_awsize(1) <= \<const1>\;
  M_AXI_GP0_awsize(0) <= \<const0>\;
  M_AXI_GP0_awuser(0) <= \<const0>\;
  M_AXI_GP0_awvalid <= \<const0>\;
  M_AXI_GP0_bready <= \<const1>\;
  M_AXI_GP0_wdata(31) <= \<const0>\;
  M_AXI_GP0_wdata(30) <= \<const0>\;
  M_AXI_GP0_wdata(29) <= \<const0>\;
  M_AXI_GP0_wdata(28) <= \<const0>\;
  M_AXI_GP0_wdata(27) <= \<const0>\;
  M_AXI_GP0_wdata(26) <= \<const0>\;
  M_AXI_GP0_wdata(25) <= \<const0>\;
  M_AXI_GP0_wdata(24) <= \<const0>\;
  M_AXI_GP0_wdata(23) <= \<const0>\;
  M_AXI_GP0_wdata(22) <= \<const0>\;
  M_AXI_GP0_wdata(21) <= \<const0>\;
  M_AXI_GP0_wdata(20) <= \<const0>\;
  M_AXI_GP0_wdata(19) <= \<const0>\;
  M_AXI_GP0_wdata(18) <= \<const0>\;
  M_AXI_GP0_wdata(17) <= \<const0>\;
  M_AXI_GP0_wdata(16) <= \<const0>\;
  M_AXI_GP0_wdata(15) <= \<const0>\;
  M_AXI_GP0_wdata(14) <= \<const0>\;
  M_AXI_GP0_wdata(13) <= \<const0>\;
  M_AXI_GP0_wdata(12) <= \<const0>\;
  M_AXI_GP0_wdata(11) <= \<const0>\;
  M_AXI_GP0_wdata(10) <= \<const0>\;
  M_AXI_GP0_wdata(9) <= \<const0>\;
  M_AXI_GP0_wdata(8) <= \<const0>\;
  M_AXI_GP0_wdata(7) <= \<const0>\;
  M_AXI_GP0_wdata(6) <= \<const0>\;
  M_AXI_GP0_wdata(5) <= \<const0>\;
  M_AXI_GP0_wdata(4) <= \<const0>\;
  M_AXI_GP0_wdata(3) <= \<const0>\;
  M_AXI_GP0_wdata(2) <= \<const0>\;
  M_AXI_GP0_wdata(1) <= \<const0>\;
  M_AXI_GP0_wdata(0) <= \<const0>\;
  M_AXI_GP0_wlast <= \<const1>\;
  M_AXI_GP0_wstrb(3) <= \<const1>\;
  M_AXI_GP0_wstrb(2) <= \<const1>\;
  M_AXI_GP0_wstrb(1) <= \<const1>\;
  M_AXI_GP0_wstrb(0) <= \<const1>\;
  M_AXI_GP0_wvalid <= \<const0>\;
  M_AXI_HP0_arburst(1) <= \<const0>\;
  M_AXI_HP0_arburst(0) <= \<const1>\;
  M_AXI_HP0_arcache(3) <= \<const0>\;
  M_AXI_HP0_arcache(2) <= \<const0>\;
  M_AXI_HP0_arcache(1) <= \<const0>\;
  M_AXI_HP0_arcache(0) <= \<const0>\;
  M_AXI_HP0_arlen(7) <= \<const0>\;
  M_AXI_HP0_arlen(6) <= \<const0>\;
  M_AXI_HP0_arlen(5) <= \<const0>\;
  M_AXI_HP0_arlen(4) <= \<const0>\;
  M_AXI_HP0_arlen(3 downto 0) <= \^m_axi_hp0_arlen\(3 downto 0);
  M_AXI_HP0_arlock(0) <= \<const0>\;
  M_AXI_HP0_arprot(2) <= \<const0>\;
  M_AXI_HP0_arprot(1) <= \<const0>\;
  M_AXI_HP0_arprot(0) <= \<const0>\;
  M_AXI_HP0_arqos(3) <= \<const0>\;
  M_AXI_HP0_arqos(2) <= \<const0>\;
  M_AXI_HP0_arqos(1) <= \<const0>\;
  M_AXI_HP0_arqos(0) <= \<const0>\;
  M_AXI_HP0_arsize(2) <= \<const1>\;
  M_AXI_HP0_arsize(1) <= \<const0>\;
  M_AXI_HP0_arsize(0) <= \<const0>\;
  M_AXI_HP0_aruser(0) <= \<const0>\;
  M_AXI_HP0_awburst(1) <= \<const0>\;
  M_AXI_HP0_awburst(0) <= \<const1>\;
  M_AXI_HP0_awcache(3) <= \<const0>\;
  M_AXI_HP0_awcache(2) <= \<const0>\;
  M_AXI_HP0_awcache(1) <= \<const0>\;
  M_AXI_HP0_awcache(0) <= \<const0>\;
  M_AXI_HP0_awlock(0) <= \<const0>\;
  M_AXI_HP0_awprot(2) <= \<const0>\;
  M_AXI_HP0_awprot(1) <= \<const0>\;
  M_AXI_HP0_awprot(0) <= \<const0>\;
  M_AXI_HP0_awqos(3) <= \<const0>\;
  M_AXI_HP0_awqos(2) <= \<const0>\;
  M_AXI_HP0_awqos(1) <= \<const0>\;
  M_AXI_HP0_awqos(0) <= \<const0>\;
  M_AXI_HP0_awsize(2) <= \<const1>\;
  M_AXI_HP0_awsize(1) <= \<const0>\;
  M_AXI_HP0_awsize(0) <= \<const0>\;
  M_AXI_HP0_awuser(0) <= \<const0>\;
  M_AXI_HP0_bready <= \<const1>\;
  M_AXI_HP2_arburst(1) <= \<const0>\;
  M_AXI_HP2_arburst(0) <= \<const1>\;
  M_AXI_HP2_arcache(3) <= \<const0>\;
  M_AXI_HP2_arcache(2) <= \<const0>\;
  M_AXI_HP2_arcache(1) <= \<const0>\;
  M_AXI_HP2_arcache(0) <= \<const0>\;
  M_AXI_HP2_arlen(7) <= \<const0>\;
  M_AXI_HP2_arlen(6) <= \<const0>\;
  M_AXI_HP2_arlen(5) <= \<const0>\;
  M_AXI_HP2_arlen(4) <= \<const0>\;
  M_AXI_HP2_arlen(3 downto 0) <= \^m_axi_hp2_arlen\(3 downto 0);
  M_AXI_HP2_arlock(0) <= \<const0>\;
  M_AXI_HP2_arprot(2) <= \<const0>\;
  M_AXI_HP2_arprot(1) <= \<const0>\;
  M_AXI_HP2_arprot(0) <= \<const0>\;
  M_AXI_HP2_arqos(3) <= \<const0>\;
  M_AXI_HP2_arqos(2) <= \<const0>\;
  M_AXI_HP2_arqos(1) <= \<const0>\;
  M_AXI_HP2_arqos(0) <= \<const0>\;
  M_AXI_HP2_arsize(2) <= \<const1>\;
  M_AXI_HP2_arsize(1) <= \<const0>\;
  M_AXI_HP2_arsize(0) <= \<const0>\;
  M_AXI_HP2_aruser(0) <= \<const0>\;
  M_AXI_HP2_awburst(1) <= \<const0>\;
  M_AXI_HP2_awburst(0) <= \<const1>\;
  M_AXI_HP2_awcache(3) <= \<const0>\;
  M_AXI_HP2_awcache(2) <= \<const0>\;
  M_AXI_HP2_awcache(1) <= \<const0>\;
  M_AXI_HP2_awcache(0) <= \<const0>\;
  M_AXI_HP2_awlock(0) <= \<const0>\;
  M_AXI_HP2_awprot(2) <= \<const0>\;
  M_AXI_HP2_awprot(1) <= \<const0>\;
  M_AXI_HP2_awprot(0) <= \<const0>\;
  M_AXI_HP2_awqos(3) <= \<const0>\;
  M_AXI_HP2_awqos(2) <= \<const0>\;
  M_AXI_HP2_awqos(1) <= \<const0>\;
  M_AXI_HP2_awqos(0) <= \<const0>\;
  M_AXI_HP2_awsize(2) <= \<const1>\;
  M_AXI_HP2_awsize(1) <= \<const0>\;
  M_AXI_HP2_awsize(0) <= \<const0>\;
  M_AXI_HP2_awuser(0) <= \<const0>\;
  M_AXI_HP2_bready <= \<const1>\;
  S_AXI_CONTROL_bresp(1) <= \<const0>\;
  S_AXI_CONTROL_bresp(0) <= \<const0>\;
  S_AXI_CONTROL_rresp(1) <= \<const0>\;
  S_AXI_CONTROL_rresp(0) <= \<const0>\;
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
VCC: unisim.vcomponents.VCC
     port map (
      P => \<const1>\
    );
inst: component kv260_hardware_platform_DPUCZDX8G_1_0_DPUCZDX8G
     port map (
      M_AXI_GP0_araddr(39 downto 3) => \^m_axi_gp0_araddr\(39 downto 3),
      M_AXI_GP0_araddr(2 downto 0) => NLW_inst_M_AXI_GP0_araddr_UNCONNECTED(2 downto 0),
      M_AXI_GP0_arburst(1 downto 0) => NLW_inst_M_AXI_GP0_arburst_UNCONNECTED(1 downto 0),
      M_AXI_GP0_arcache(3 downto 0) => NLW_inst_M_AXI_GP0_arcache_UNCONNECTED(3 downto 0),
      M_AXI_GP0_arlen(7 downto 0) => NLW_inst_M_AXI_GP0_arlen_UNCONNECTED(7 downto 0),
      M_AXI_GP0_arlock(0) => NLW_inst_M_AXI_GP0_arlock_UNCONNECTED(0),
      M_AXI_GP0_arprot(2 downto 0) => NLW_inst_M_AXI_GP0_arprot_UNCONNECTED(2 downto 0),
      M_AXI_GP0_arqos(3 downto 0) => NLW_inst_M_AXI_GP0_arqos_UNCONNECTED(3 downto 0),
      M_AXI_GP0_arready => M_AXI_GP0_arready,
      M_AXI_GP0_arsize(2 downto 0) => NLW_inst_M_AXI_GP0_arsize_UNCONNECTED(2 downto 0),
      M_AXI_GP0_aruser(0) => NLW_inst_M_AXI_GP0_aruser_UNCONNECTED(0),
      M_AXI_GP0_arvalid => M_AXI_GP0_arvalid,
      M_AXI_GP0_awaddr(39 downto 0) => NLW_inst_M_AXI_GP0_awaddr_UNCONNECTED(39 downto 0),
      M_AXI_GP0_awburst(1 downto 0) => NLW_inst_M_AXI_GP0_awburst_UNCONNECTED(1 downto 0),
      M_AXI_GP0_awcache(3 downto 0) => NLW_inst_M_AXI_GP0_awcache_UNCONNECTED(3 downto 0),
      M_AXI_GP0_awlen(7 downto 0) => NLW_inst_M_AXI_GP0_awlen_UNCONNECTED(7 downto 0),
      M_AXI_GP0_awlock(0) => NLW_inst_M_AXI_GP0_awlock_UNCONNECTED(0),
      M_AXI_GP0_awprot(2 downto 0) => NLW_inst_M_AXI_GP0_awprot_UNCONNECTED(2 downto 0),
      M_AXI_GP0_awqos(3 downto 0) => NLW_inst_M_AXI_GP0_awqos_UNCONNECTED(3 downto 0),
      M_AXI_GP0_awready => M_AXI_GP0_awready,
      M_AXI_GP0_awsize(2 downto 0) => NLW_inst_M_AXI_GP0_awsize_UNCONNECTED(2 downto 0),
      M_AXI_GP0_awuser(0) => NLW_inst_M_AXI_GP0_awuser_UNCONNECTED(0),
      M_AXI_GP0_awvalid => NLW_inst_M_AXI_GP0_awvalid_UNCONNECTED,
      M_AXI_GP0_bready => NLW_inst_M_AXI_GP0_bready_UNCONNECTED,
      M_AXI_GP0_bresp(1 downto 0) => B"00",
      M_AXI_GP0_bvalid => '0',
      M_AXI_GP0_rdata(31 downto 0) => M_AXI_GP0_rdata(31 downto 0),
      M_AXI_GP0_rlast => M_AXI_GP0_rlast,
      M_AXI_GP0_rready => M_AXI_GP0_rready,
      M_AXI_GP0_rresp(1 downto 0) => B"00",
      M_AXI_GP0_rvalid => M_AXI_GP0_rvalid,
      M_AXI_GP0_wdata(31 downto 0) => NLW_inst_M_AXI_GP0_wdata_UNCONNECTED(31 downto 0),
      M_AXI_GP0_wlast => NLW_inst_M_AXI_GP0_wlast_UNCONNECTED,
      M_AXI_GP0_wready => M_AXI_GP0_wready,
      M_AXI_GP0_wstrb(3 downto 0) => NLW_inst_M_AXI_GP0_wstrb_UNCONNECTED(3 downto 0),
      M_AXI_GP0_wvalid => NLW_inst_M_AXI_GP0_wvalid_UNCONNECTED,
      M_AXI_HP0_araddr(39 downto 0) => M_AXI_HP0_araddr(39 downto 0),
      M_AXI_HP0_arburst(1 downto 0) => NLW_inst_M_AXI_HP0_arburst_UNCONNECTED(1 downto 0),
      M_AXI_HP0_arcache(3 downto 0) => NLW_inst_M_AXI_HP0_arcache_UNCONNECTED(3 downto 0),
      M_AXI_HP0_arlen(7 downto 4) => NLW_inst_M_AXI_HP0_arlen_UNCONNECTED(7 downto 4),
      M_AXI_HP0_arlen(3 downto 0) => \^m_axi_hp0_arlen\(3 downto 0),
      M_AXI_HP0_arlock(0) => NLW_inst_M_AXI_HP0_arlock_UNCONNECTED(0),
      M_AXI_HP0_arprot(2 downto 0) => NLW_inst_M_AXI_HP0_arprot_UNCONNECTED(2 downto 0),
      M_AXI_HP0_arqos(3 downto 0) => NLW_inst_M_AXI_HP0_arqos_UNCONNECTED(3 downto 0),
      M_AXI_HP0_arready => M_AXI_HP0_arready,
      M_AXI_HP0_arsize(2 downto 0) => NLW_inst_M_AXI_HP0_arsize_UNCONNECTED(2 downto 0),
      M_AXI_HP0_aruser(0) => NLW_inst_M_AXI_HP0_aruser_UNCONNECTED(0),
      M_AXI_HP0_arvalid => M_AXI_HP0_arvalid,
      M_AXI_HP0_awaddr(39 downto 0) => M_AXI_HP0_awaddr(39 downto 0),
      M_AXI_HP0_awburst(1 downto 0) => NLW_inst_M_AXI_HP0_awburst_UNCONNECTED(1 downto 0),
      M_AXI_HP0_awcache(3 downto 0) => NLW_inst_M_AXI_HP0_awcache_UNCONNECTED(3 downto 0),
      M_AXI_HP0_awlen(7 downto 0) => M_AXI_HP0_awlen(7 downto 0),
      M_AXI_HP0_awlock(0) => NLW_inst_M_AXI_HP0_awlock_UNCONNECTED(0),
      M_AXI_HP0_awprot(2 downto 0) => NLW_inst_M_AXI_HP0_awprot_UNCONNECTED(2 downto 0),
      M_AXI_HP0_awqos(3 downto 0) => NLW_inst_M_AXI_HP0_awqos_UNCONNECTED(3 downto 0),
      M_AXI_HP0_awready => M_AXI_HP0_awready,
      M_AXI_HP0_awsize(2 downto 0) => NLW_inst_M_AXI_HP0_awsize_UNCONNECTED(2 downto 0),
      M_AXI_HP0_awuser(0) => NLW_inst_M_AXI_HP0_awuser_UNCONNECTED(0),
      M_AXI_HP0_awvalid => M_AXI_HP0_awvalid,
      M_AXI_HP0_bready => NLW_inst_M_AXI_HP0_bready_UNCONNECTED,
      M_AXI_HP0_bresp(1 downto 0) => B"00",
      M_AXI_HP0_bvalid => M_AXI_HP0_bvalid,
      M_AXI_HP0_rdata(127 downto 0) => M_AXI_HP0_rdata(127 downto 0),
      M_AXI_HP0_rlast => M_AXI_HP0_rlast,
      M_AXI_HP0_rready => M_AXI_HP0_rready,
      M_AXI_HP0_rresp(1 downto 0) => B"00",
      M_AXI_HP0_rvalid => M_AXI_HP0_rvalid,
      M_AXI_HP0_wdata(127 downto 0) => M_AXI_HP0_wdata(127 downto 0),
      M_AXI_HP0_wlast => M_AXI_HP0_wlast,
      M_AXI_HP0_wready => M_AXI_HP0_wready,
      M_AXI_HP0_wstrb(15 downto 0) => M_AXI_HP0_wstrb(15 downto 0),
      M_AXI_HP0_wvalid => M_AXI_HP0_wvalid,
      M_AXI_HP2_araddr(39 downto 0) => M_AXI_HP2_araddr(39 downto 0),
      M_AXI_HP2_arburst(1 downto 0) => NLW_inst_M_AXI_HP2_arburst_UNCONNECTED(1 downto 0),
      M_AXI_HP2_arcache(3 downto 0) => NLW_inst_M_AXI_HP2_arcache_UNCONNECTED(3 downto 0),
      M_AXI_HP2_arlen(7 downto 4) => NLW_inst_M_AXI_HP2_arlen_UNCONNECTED(7 downto 4),
      M_AXI_HP2_arlen(3 downto 0) => \^m_axi_hp2_arlen\(3 downto 0),
      M_AXI_HP2_arlock(0) => NLW_inst_M_AXI_HP2_arlock_UNCONNECTED(0),
      M_AXI_HP2_arprot(2 downto 0) => NLW_inst_M_AXI_HP2_arprot_UNCONNECTED(2 downto 0),
      M_AXI_HP2_arqos(3 downto 0) => NLW_inst_M_AXI_HP2_arqos_UNCONNECTED(3 downto 0),
      M_AXI_HP2_arready => M_AXI_HP2_arready,
      M_AXI_HP2_arsize(2 downto 0) => NLW_inst_M_AXI_HP2_arsize_UNCONNECTED(2 downto 0),
      M_AXI_HP2_aruser(0) => NLW_inst_M_AXI_HP2_aruser_UNCONNECTED(0),
      M_AXI_HP2_arvalid => M_AXI_HP2_arvalid,
      M_AXI_HP2_awaddr(39 downto 0) => M_AXI_HP2_awaddr(39 downto 0),
      M_AXI_HP2_awburst(1 downto 0) => NLW_inst_M_AXI_HP2_awburst_UNCONNECTED(1 downto 0),
      M_AXI_HP2_awcache(3 downto 0) => NLW_inst_M_AXI_HP2_awcache_UNCONNECTED(3 downto 0),
      M_AXI_HP2_awlen(7 downto 0) => M_AXI_HP2_awlen(7 downto 0),
      M_AXI_HP2_awlock(0) => NLW_inst_M_AXI_HP2_awlock_UNCONNECTED(0),
      M_AXI_HP2_awprot(2 downto 0) => NLW_inst_M_AXI_HP2_awprot_UNCONNECTED(2 downto 0),
      M_AXI_HP2_awqos(3 downto 0) => NLW_inst_M_AXI_HP2_awqos_UNCONNECTED(3 downto 0),
      M_AXI_HP2_awready => M_AXI_HP2_awready,
      M_AXI_HP2_awsize(2 downto 0) => NLW_inst_M_AXI_HP2_awsize_UNCONNECTED(2 downto 0),
      M_AXI_HP2_awuser(0) => NLW_inst_M_AXI_HP2_awuser_UNCONNECTED(0),
      M_AXI_HP2_awvalid => M_AXI_HP2_awvalid,
      M_AXI_HP2_bready => NLW_inst_M_AXI_HP2_bready_UNCONNECTED,
      M_AXI_HP2_bresp(1 downto 0) => B"00",
      M_AXI_HP2_bvalid => M_AXI_HP2_bvalid,
      M_AXI_HP2_rdata(127 downto 0) => M_AXI_HP2_rdata(127 downto 0),
      M_AXI_HP2_rlast => M_AXI_HP2_rlast,
      M_AXI_HP2_rready => M_AXI_HP2_rready,
      M_AXI_HP2_rresp(1 downto 0) => B"00",
      M_AXI_HP2_rvalid => M_AXI_HP2_rvalid,
      M_AXI_HP2_wdata(127 downto 0) => M_AXI_HP2_wdata(127 downto 0),
      M_AXI_HP2_wlast => M_AXI_HP2_wlast,
      M_AXI_HP2_wready => M_AXI_HP2_wready,
      M_AXI_HP2_wstrb(15 downto 0) => M_AXI_HP2_wstrb(15 downto 0),
      M_AXI_HP2_wvalid => M_AXI_HP2_wvalid,
      S_AXI_CONTROL_araddr(11 downto 0) => S_AXI_CONTROL_araddr(11 downto 0),
      S_AXI_CONTROL_arready => S_AXI_CONTROL_arready,
      S_AXI_CONTROL_arvalid => S_AXI_CONTROL_arvalid,
      S_AXI_CONTROL_awaddr(11 downto 0) => S_AXI_CONTROL_awaddr(11 downto 0),
      S_AXI_CONTROL_awready => S_AXI_CONTROL_awready,
      S_AXI_CONTROL_awvalid => S_AXI_CONTROL_awvalid,
      S_AXI_CONTROL_bready => S_AXI_CONTROL_bready,
      S_AXI_CONTROL_bresp(1 downto 0) => NLW_inst_S_AXI_CONTROL_bresp_UNCONNECTED(1 downto 0),
      S_AXI_CONTROL_bvalid => S_AXI_CONTROL_bvalid,
      S_AXI_CONTROL_rdata(31 downto 0) => S_AXI_CONTROL_rdata(31 downto 0),
      S_AXI_CONTROL_rready => S_AXI_CONTROL_rready,
      S_AXI_CONTROL_rresp(1 downto 0) => NLW_inst_S_AXI_CONTROL_rresp_UNCONNECTED(1 downto 0),
      S_AXI_CONTROL_rvalid => S_AXI_CONTROL_rvalid,
      S_AXI_CONTROL_wdata(31 downto 0) => S_AXI_CONTROL_wdata(31 downto 0),
      S_AXI_CONTROL_wready => S_AXI_CONTROL_wready,
      S_AXI_CONTROL_wstrb(3 downto 1) => B"000",
      S_AXI_CONTROL_wstrb(0) => S_AXI_CONTROL_wstrb(0),
      S_AXI_CONTROL_wvalid => S_AXI_CONTROL_wvalid,
      aclk => aclk,
      ap_clk_2 => ap_clk_2,
      ap_rst_n_2 => '0',
      aresetn => aresetn,
      interrupt => interrupt
    );
end STRUCTURE;
