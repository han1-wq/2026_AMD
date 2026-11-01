

#---------------------------
# Constant blocks
#---------------------------

#---------------------------
# Platform Parameters for kv260_hardware_platform
#---------------------------
set ps8_0_axi_periph [get_bd_cell /ps8_0_axi_periph]
    
set_property -dict [ list \
  CONFIG.NUM_SI 1 \
  CONFIG.NUM_MI 5 \
  CONFIG.M03_HAS_REGSLICE 1 \
  CONFIG.M04_HAS_REGSLICE 1 \
  ] $ps8_0_axi_periph
set zynq_ultra_ps_e_0 [get_bd_cell /zynq_ultra_ps_e_0]
    
set_property -dict [ list \
  CONFIG.PSU__USE__S_AXI_GP2 1 \
  CONFIG.PSU__USE__S_AXI_GP3 1 \
  CONFIG.PSU__USE__S_AXI_GP0 1 \
  ] $zynq_ultra_ps_e_0

#---------------------------
# Instantiating DPUCZDX8G_1
#---------------------------
set DPUCZDX8G_1 [create_bd_cell -type ip -vlnv xilinx.com:RTLKernel:DPUCZDX8G:1.0 DPUCZDX8G_1]
  

#---------------------------
# Instantiating sfm_xrt_top_1
#---------------------------
set sfm_xrt_top_1 [create_bd_cell -type ip -vlnv xilinx.com:RTLKernel:sfm_xrt_top:1.0 sfm_xrt_top_1]
  

#---------------------------
# Instantiating axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD
#---------------------------
set axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD]
  
set_property -dict [ list  \
  CONFIG.NUM_MI {1} \
  CONFIG.NUM_SI {1} \
  CONFIG.M00_HAS_REGSLICE {0} \
  CONFIG.S00_HAS_REGSLICE {0}  ] $axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD

#---------------------------
# Instantiating axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD
#---------------------------
set axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD]
  
set_property -dict [ list  \
  CONFIG.NUM_MI {1} \
  CONFIG.NUM_SI {2} \
  CONFIG.STRATEGY {2} \
  CONFIG.M00_HAS_REGSLICE {1} \
  CONFIG.M00_HAS_DATA_FIFO {2} \
  CONFIG.S00_HAS_REGSLICE {1} \
  CONFIG.S00_HAS_DATA_FIFO {2} \
  CONFIG.S01_HAS_REGSLICE {1} \
  CONFIG.S01_HAS_DATA_FIFO {2}  ] $axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD

#---------------------------
# Instantiating axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD
#---------------------------
set axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD]
  
set_property -dict [ list  \
  CONFIG.NUM_MI {1} \
  CONFIG.NUM_SI {1} \
  CONFIG.M00_HAS_REGSLICE {0} \
  CONFIG.S00_HAS_REGSLICE {0}  ] $axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD

#---------------------------
# Instantiating axi_intc_0_intr_1_interrupt_concat
#---------------------------
set axi_intc_0_intr_1_interrupt_concat [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 axi_intc_0_intr_1_interrupt_concat]
  
set_property -dict [ list  \
  CONFIG.NUM_PORTS {32}  ] $axi_intc_0_intr_1_interrupt_concat

#---------------------------
# Instantiating irq_const_tieoff
#---------------------------
set irq_const_tieoff [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 irq_const_tieoff]
  
set_property -dict [ list  \
  CONFIG.CONST_WIDTH {1} \
  CONFIG.CONST_VAL {0}  ] $irq_const_tieoff

#---------------------------
# Connectivity Phase 1
#---------------------------
connect_bd_intf_net \
  [get_bd_intf_pins -auto_enable /axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD/M00_AXI] \
  [get_bd_intf_pins -auto_enable /zynq_ultra_ps_e_0/S_AXI_HPC0_FPD] \

connect_bd_intf_net \
  [get_bd_intf_pins -auto_enable /axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD/M00_AXI] \
  [get_bd_intf_pins -auto_enable /zynq_ultra_ps_e_0/S_AXI_HP0_FPD] \

connect_bd_intf_net \
  [get_bd_intf_pins -auto_enable /axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD/M00_AXI] \
  [get_bd_intf_pins -auto_enable /zynq_ultra_ps_e_0/S_AXI_HP1_FPD] \

connect_bd_intf_net \
  [get_bd_intf_pins -auto_enable /ps8_0_axi_periph/M03_AXI] \
  [get_bd_intf_pins -auto_enable /DPUCZDX8G_1/S_AXI_CONTROL] \

connect_bd_intf_net \
  [get_bd_intf_pins -auto_enable /DPUCZDX8G_1/M_AXI_GP0] \
  [get_bd_intf_pins -auto_enable /axi_ic_zynq_ultra_ps_e_0_S_AXI_HPC0_FPD/S00_AXI] \

connect_bd_intf_net \
  [get_bd_intf_pins -auto_enable /DPUCZDX8G_1/M_AXI_HP0] \
  [get_bd_intf_pins -auto_enable /axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD/S00_AXI] \

connect_bd_intf_net \
  [get_bd_intf_pins -auto_enable /DPUCZDX8G_1/M_AXI_HP2] \
  [get_bd_intf_pins -auto_enable /axi_ic_zynq_ultra_ps_e_0_S_AXI_HP1_FPD/S00_AXI] \

connect_bd_intf_net \
  [get_bd_intf_pins -auto_enable /ps8_0_axi_periph/M04_AXI] \
  [get_bd_intf_pins -auto_enable /sfm_xrt_top_1/s_axi_control] \

connect_bd_intf_net \
  [get_bd_intf_pins -auto_enable /sfm_xrt_top_1/M_AXI] \
  [get_bd_intf_pins -auto_enable /axi_ic_zynq_ultra_ps_e_0_S_AXI_HP0_FPD/S01_AXI] \

connect_bd_net  \
  [get_bd_pins -auto_enable /clk_wiz_1/clk_out1] \
  [get_bd_pins -auto_enable /sfm_xrt_top_1/aclk] \
  [get_bd_pins -auto_enable /ps8_0_axi_periph/M04_ACLK] \

connect_bd_net  \
  [get_bd_pins -auto_enable /proc_sys_reset_0/interconnect_aresetn] \
  [get_bd_pins -auto_enable /ps8_0_axi_periph/M04_ARESETN] \

connect_bd_net  \
  [get_bd_pins -auto_enable /proc_sys_reset_0/peripheral_aresetn] \
  [get_bd_pins -auto_enable /sfm_xrt_top_1/aresetn] \

connect_bd_net  \
  [get_bd_pins -auto_enable /axi_intc_0_intr_1_interrupt_concat/dout] \
  [get_bd_pins -auto_enable /axi_intc_0/intr] \

connect_bd_net  \
  [get_bd_pins -auto_enable /DPUCZDX8G_1/interrupt] \
  [get_bd_pins -auto_enable /axi_intc_0_intr_1_interrupt_concat/In1] \

connect_bd_net  \
  [get_bd_pins -auto_enable /sfm_xrt_top_1/interrupt] \
  [get_bd_pins -auto_enable /axi_intc_0_intr_1_interrupt_concat/In0] \

connect_bd_net  \
  [get_bd_pins -auto_enable /irq_const_tieoff/dout] \
  [get_bd_pins -auto_enable /axi_intc_0_intr_1_interrupt_concat/In2] \
  [get_bd_pins -auto_enable /axi_intc_0_intr_1_interrupt_concat/In3] \
  [get_bd_pins -auto_enable /axi_intc_0_intr_1_interrupt_concat/In4] \
  [get_bd_pins -auto_enable /axi_intc_0_intr_1_interrupt_concat/In5] \
  [get_bd_pins -auto_enable /axi_intc_0_intr_1_interrupt_concat/In6] \
  [get_bd_pins -auto_enable /axi_intc_0_intr_1_interrupt_concat/In7] \
  [get_bd_pins -auto_enable /axi_intc_0_intr_1_interrupt_concat/In8] \
  [get_bd_pins -auto_enable /axi_intc_0_intr_1_interrupt_concat/In9] \
  [get_bd_pins -auto_enable /axi_intc_0_intr_1_interrupt_concat/In10] \
  [get_bd_pins -auto_enable /axi_intc_0_intr_1_interrupt_concat/In11] \
  [get_bd_pins -auto_enable /axi_intc_0_intr_1_interrupt_concat/In12] \
  [get_bd_pins -auto_enable /axi_intc_0_intr_1_interrupt_concat/In13] \
  [get_bd_pins -auto_enable /axi_intc_0_intr_1_interrupt_concat/In14] \
  [get_bd_pins -auto_enable /axi_intc_0_intr_1_interrupt_concat/In15] \
  [get_bd_pins -auto_enable /axi_intc_0_intr_1_interrupt_concat/In16] \
  [get_bd_pins -auto_enable /axi_intc_0_intr_1_interrupt_concat/In17] \
  [get_bd_pins -auto_enable /axi_intc_0_intr_1_interrupt_concat/In18] \
  [get_bd_pins -auto_enable /axi_intc_0_intr_1_interrupt_concat/In19] \
  [get_bd_pins -auto_enable /axi_intc_0_intr_1_interrupt_concat/In20] \
  [get_bd_pins -auto_enable /axi_intc_0_intr_1_interrupt_concat/In21] \
  [get_bd_pins -auto_enable /axi_intc_0_intr_1_interrupt_concat/In22] \
  [get_bd_pins -auto_enable /axi_intc_0_intr_1_interrupt_concat/In23] \
  [get_bd_pins -auto_enable /axi_intc_0_intr_1_interrupt_concat/In24] \
  [get_bd_pins -auto_enable /axi_intc_0_intr_1_interrupt_concat/In25] \
  [get_bd_pins -auto_enable /axi_intc_0_intr_1_interrupt_concat/In26] \
  [get_bd_pins -auto_enable /axi_intc_0_intr_1_interrupt_concat/In27] \
  [get_bd_pins -auto_enable /axi_intc_0_intr_1_interrupt_concat/In28] \
  [get_bd_pins -auto_enable /axi_intc_0_intr_1_interrupt_concat/In29] \
  [get_bd_pins -auto_enable /axi_intc_0_intr_1_interrupt_concat/In30] \
  [get_bd_pins -auto_enable /axi_intc_0_intr_1_interrupt_concat/In31] \


#---------------------------
# Clock/Reset Annotation
#---------------------------

set_property HDL_ATTRIBUTE.saxihpc0_fpd_aclk.FREQ_HZ {300000000} [get_bd_cells zynq_ultra_ps_e_0]
set_property HDL_ATTRIBUTE.saxihpc0_fpd_aclk.FREQ_HZ_TOLERANCE {15000000} [get_bd_cells zynq_ultra_ps_e_0]
set_property HDL_ATTRIBUTE.saxihp0_fpd_aclk.FREQ_HZ {300000000} [get_bd_cells zynq_ultra_ps_e_0]
set_property HDL_ATTRIBUTE.saxihp0_fpd_aclk.FREQ_HZ_TOLERANCE {15000000} [get_bd_cells zynq_ultra_ps_e_0]
set_property HDL_ATTRIBUTE.saxihp1_fpd_aclk.FREQ_HZ {300000000} [get_bd_cells zynq_ultra_ps_e_0]
set_property HDL_ATTRIBUTE.saxihp1_fpd_aclk.FREQ_HZ_TOLERANCE {15000000} [get_bd_cells zynq_ultra_ps_e_0]

set_property HDL_ATTRIBUTE.aclk.FREQ_HZ {300000000} $DPUCZDX8G_1
set_property HDL_ATTRIBUTE.aclk.FREQ_HZ_TOLERANCE {15000000} $DPUCZDX8G_1
set_property HDL_ATTRIBUTE.ap_clk_2.FREQ_HZ {600000000} $DPUCZDX8G_1
set_property HDL_ATTRIBUTE.ap_clk_2.FREQ_HZ_TOLERANCE {30000000} $DPUCZDX8G_1



#---------------------------
# Invoke clock automation
#---------------------------

set_param bd.clkrstautomationv2 1
::bd::clkrst::apply_clk_rst_automation



#---------------------------
# Connectivity Phase 2
#---------------------------

#---------------------------
# Create Stream Map file
#---------------------------
set stream_subsystems [get_bd_cells * -hierarchical -quiet -filter {VLNV =~ "*:*:sdx_stream_subsystem:*"}]
if {[string length $stream_subsystems] > 0} {    
  set xmlFile $vpl_output_dir/qdma_stream_map.xml
  set fp [open ${xmlFile} w]
  puts $fp "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
  puts $fp "<xd:streamMap xmlns:xd=\"http://www.xilinx.com/xd\">"
  foreach streamSS [get_bd_cells * -hierarchical -quiet -filter {VLNV =~ "*:*:sdx_stream_subsystem:*"}] {
    set ssInstance [string trimleft $streamSS /]
    set ssRegion [get_property CONFIG.SLR_ASSIGNMENTS $streamSS]
    foreach ssIntf [get_bd_intf_pins $streamSS/* -quiet -filter {NAME=~"S??_AXIS"}] {
      set pinName [get_property NAME $ssIntf]
      set routeId [sdx_stream_subsystem::get_routeid $ssIntf]
      set flowId [sdx_stream_subsystem::get_flowid $ssIntf]
      puts $fp "  <xd:streamRoute xd:instanceRef=\"$ssInstance\" xd:portRef=\"$pinName\" xd:route=\"$routeId\" xd:flow=\"$flowId\" xd:region=\"$ssRegion\">"
      foreach connection [find_bd_objs -relation connected_to $ssIntf -thru_hier] {
        set connectedRegion [get_property CONFIG.SLR_ASSIGNMENTS [bd::utils::get_parent $connection]]
        set connectedPort [bd::utils::get_short_name $connection]
        set connectedInst [string trimleft [bd::utils::get_parent $connection] /]
        puts $fp "    <xd:connection xd:instanceRef=\"$connectedInst\" xd:portRef=\"$connectedPort\" xd:region=\"$connectedRegion\"/>"
      }
      puts $fp "  </xd:streamRoute>"
    }
    foreach ssIntf [get_bd_intf_pins $streamSS/* -quiet -filter {NAME=~"M??_AXIS"}] {
      set pinName [get_property NAME $ssIntf]
      set routeId [sdx_stream_subsystem::get_routeid $ssIntf]
      set flowId [sdx_stream_subsystem::get_flowid $ssIntf]
      puts $fp "  <xd:streamRoute xd:instanceRef=\"$ssInstance\" xd:portRef=\"$pinName\" xd:route=\"$routeId\" xd:flow=\"$flowId\" xd:region=\"$ssRegion\">"
      foreach connection [find_bd_objs -relation connected_to $ssIntf -thru_hier] {
        set connectedRegion [get_property CONFIG.SLR_ASSIGNMENTS [bd::utils::get_parent $connection]]
        set connectedPort [bd::utils::get_short_name $connection]
        set connectedInst [string trimleft [bd::utils::get_parent $connection] /]
        puts $fp "    <xd:connection xd:instanceRef=\"$connectedInst\" xd:portRef=\"$connectedPort\" xd:region=\"$connectedRegion\"/>"
      }
      puts $fp "  </xd:streamRoute>"
    }
  }
  puts $fp "</xd:streamMap>"
  close $fp
}


