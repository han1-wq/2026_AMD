-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2022.1 (lin64) Build 3526262 Mon Apr 18 15:47:01 MDT 2022
-- Date        : Wed Oct 14 01:46:18 2026
-- Host        : ubuntu running 64-bit Ubuntu 20.04.1 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/amd/Workspace/dpu_platform2/kv260_vitis_platform/dpu_trd_system_hw_link/Hardware/dpu.build/link/vivado/vpl/prj/prj.gen/sources_1/bd/kv260_hardware_platform/ip/kv260_hardware_platform_DPUCZDX8G_1_0/kv260_hardware_platform_DPUCZDX8G_1_0_stub.vhdl
-- Design      : kv260_hardware_platform_DPUCZDX8G_1_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xck26-sfvc784-2LV-c
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity kv260_hardware_platform_DPUCZDX8G_1_0 is
  Port ( 
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

end kv260_hardware_platform_DPUCZDX8G_1_0;

architecture stub of kv260_hardware_platform_DPUCZDX8G_1_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "M_AXI_GP0_araddr[39:0],M_AXI_GP0_arburst[1:0],M_AXI_GP0_arcache[3:0],M_AXI_GP0_arlen[7:0],M_AXI_GP0_arlock[0:0],M_AXI_GP0_arprot[2:0],M_AXI_GP0_arqos[3:0],M_AXI_GP0_arready,M_AXI_GP0_arsize[2:0],M_AXI_GP0_arvalid,M_AXI_GP0_awaddr[39:0],M_AXI_GP0_awburst[1:0],M_AXI_GP0_awcache[3:0],M_AXI_GP0_awlen[7:0],M_AXI_GP0_awlock[0:0],M_AXI_GP0_awprot[2:0],M_AXI_GP0_awqos[3:0],M_AXI_GP0_awready,M_AXI_GP0_awsize[2:0],M_AXI_GP0_awvalid,M_AXI_GP0_bready,M_AXI_GP0_bresp[1:0],M_AXI_GP0_bvalid,M_AXI_GP0_rdata[31:0],M_AXI_GP0_rlast,M_AXI_GP0_rready,M_AXI_GP0_rresp[1:0],M_AXI_GP0_rvalid,M_AXI_GP0_wdata[31:0],M_AXI_GP0_wlast,M_AXI_GP0_wready,M_AXI_GP0_wstrb[3:0],M_AXI_GP0_wvalid,M_AXI_GP0_aruser[0:0],M_AXI_GP0_awuser[0:0],M_AXI_HP0_araddr[39:0],M_AXI_HP0_arburst[1:0],M_AXI_HP0_arcache[3:0],M_AXI_HP0_arlen[7:0],M_AXI_HP0_arlock[0:0],M_AXI_HP0_arprot[2:0],M_AXI_HP0_arqos[3:0],M_AXI_HP0_arready,M_AXI_HP0_arsize[2:0],M_AXI_HP0_arvalid,M_AXI_HP0_awaddr[39:0],M_AXI_HP0_awburst[1:0],M_AXI_HP0_awcache[3:0],M_AXI_HP0_awlen[7:0],M_AXI_HP0_awlock[0:0],M_AXI_HP0_awprot[2:0],M_AXI_HP0_awqos[3:0],M_AXI_HP0_awready,M_AXI_HP0_awsize[2:0],M_AXI_HP0_awvalid,M_AXI_HP0_bready,M_AXI_HP0_bresp[1:0],M_AXI_HP0_bvalid,M_AXI_HP0_rdata[127:0],M_AXI_HP0_rlast,M_AXI_HP0_rready,M_AXI_HP0_rresp[1:0],M_AXI_HP0_rvalid,M_AXI_HP0_wdata[127:0],M_AXI_HP0_wlast,M_AXI_HP0_wready,M_AXI_HP0_wstrb[15:0],M_AXI_HP0_wvalid,M_AXI_HP0_aruser[0:0],M_AXI_HP0_awuser[0:0],M_AXI_HP2_araddr[39:0],M_AXI_HP2_arburst[1:0],M_AXI_HP2_arcache[3:0],M_AXI_HP2_arlen[7:0],M_AXI_HP2_arlock[0:0],M_AXI_HP2_arprot[2:0],M_AXI_HP2_arqos[3:0],M_AXI_HP2_arready,M_AXI_HP2_arsize[2:0],M_AXI_HP2_arvalid,M_AXI_HP2_awaddr[39:0],M_AXI_HP2_awburst[1:0],M_AXI_HP2_awcache[3:0],M_AXI_HP2_awlen[7:0],M_AXI_HP2_awlock[0:0],M_AXI_HP2_awprot[2:0],M_AXI_HP2_awqos[3:0],M_AXI_HP2_awready,M_AXI_HP2_awsize[2:0],M_AXI_HP2_awvalid,M_AXI_HP2_bready,M_AXI_HP2_bresp[1:0],M_AXI_HP2_bvalid,M_AXI_HP2_rdata[127:0],M_AXI_HP2_rlast,M_AXI_HP2_rready,M_AXI_HP2_rresp[1:0],M_AXI_HP2_rvalid,M_AXI_HP2_wdata[127:0],M_AXI_HP2_wlast,M_AXI_HP2_wready,M_AXI_HP2_wstrb[15:0],M_AXI_HP2_wvalid,M_AXI_HP2_aruser[0:0],M_AXI_HP2_awuser[0:0],S_AXI_CONTROL_araddr[11:0],S_AXI_CONTROL_arready,S_AXI_CONTROL_arvalid,S_AXI_CONTROL_awaddr[11:0],S_AXI_CONTROL_awready,S_AXI_CONTROL_awvalid,S_AXI_CONTROL_bready,S_AXI_CONTROL_bresp[1:0],S_AXI_CONTROL_bvalid,S_AXI_CONTROL_rdata[31:0],S_AXI_CONTROL_rready,S_AXI_CONTROL_rresp[1:0],S_AXI_CONTROL_rvalid,S_AXI_CONTROL_wdata[31:0],S_AXI_CONTROL_wready,S_AXI_CONTROL_wstrb[3:0],S_AXI_CONTROL_wvalid,aclk,ap_clk_2,ap_rst_n_2,aresetn,interrupt";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "DPUCZDX8G,Vivado 2022.1";
begin
end;
