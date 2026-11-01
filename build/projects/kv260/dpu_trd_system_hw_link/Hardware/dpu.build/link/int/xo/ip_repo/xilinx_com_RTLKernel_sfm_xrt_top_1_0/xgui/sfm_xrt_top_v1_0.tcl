# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  #Adding Page
  ipgui::add_page $IPINST -name "Page 0"


}

proc update_MODELPARAM_VALUE.C_S_AXI_CONTROL_ADDR_WIDTH { MODELPARAM_VALUE.C_S_AXI_CONTROL_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	# WARNING: There is no corresponding user parameter named "C_S_AXI_CONTROL_ADDR_WIDTH". Setting updated value from the model parameter.
set_property value 12 ${MODELPARAM_VALUE.C_S_AXI_CONTROL_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXI_CONTROL_DATA_WIDTH { MODELPARAM_VALUE.C_S_AXI_CONTROL_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	# WARNING: There is no corresponding user parameter named "C_S_AXI_CONTROL_DATA_WIDTH". Setting updated value from the model parameter.
set_property value 32 ${MODELPARAM_VALUE.C_S_AXI_CONTROL_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.AXI_ID_WIDTH { MODELPARAM_VALUE.AXI_ID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	# WARNING: There is no corresponding user parameter named "AXI_ID_WIDTH". Setting updated value from the model parameter.
set_property value 6 ${MODELPARAM_VALUE.AXI_ID_WIDTH}
}

proc update_MODELPARAM_VALUE.AXI_ID_LOAD_ID { MODELPARAM_VALUE.AXI_ID_LOAD_ID } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	# WARNING: There is no corresponding user parameter named "AXI_ID_LOAD_ID". Setting updated value from the model parameter.
set_property value 0 ${MODELPARAM_VALUE.AXI_ID_LOAD_ID}
}

proc update_MODELPARAM_VALUE.AXI_ID_SAVE_ID { MODELPARAM_VALUE.AXI_ID_SAVE_ID } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	# WARNING: There is no corresponding user parameter named "AXI_ID_SAVE_ID". Setting updated value from the model parameter.
set_property value 0 ${MODELPARAM_VALUE.AXI_ID_SAVE_ID}
}

proc update_MODELPARAM_VALUE.AXI_ADDR_WIDTH { MODELPARAM_VALUE.AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	# WARNING: There is no corresponding user parameter named "AXI_ADDR_WIDTH". Setting updated value from the model parameter.
set_property value 32 ${MODELPARAM_VALUE.AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.AXI_LEN_WIDTH { MODELPARAM_VALUE.AXI_LEN_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	# WARNING: There is no corresponding user parameter named "AXI_LEN_WIDTH". Setting updated value from the model parameter.
set_property value 8 ${MODELPARAM_VALUE.AXI_LEN_WIDTH}
}

proc update_MODELPARAM_VALUE.AXI_PROT_WIDTH { MODELPARAM_VALUE.AXI_PROT_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	# WARNING: There is no corresponding user parameter named "AXI_PROT_WIDTH". Setting updated value from the model parameter.
set_property value 3 ${MODELPARAM_VALUE.AXI_PROT_WIDTH}
}

proc update_MODELPARAM_VALUE.AXI_QOS_WIDTH { MODELPARAM_VALUE.AXI_QOS_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	# WARNING: There is no corresponding user parameter named "AXI_QOS_WIDTH". Setting updated value from the model parameter.
set_property value 4 ${MODELPARAM_VALUE.AXI_QOS_WIDTH}
}

proc update_MODELPARAM_VALUE.AXI_STRB_WIDTH { MODELPARAM_VALUE.AXI_STRB_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	# WARNING: There is no corresponding user parameter named "AXI_STRB_WIDTH". Setting updated value from the model parameter.
set_property value 16 ${MODELPARAM_VALUE.AXI_STRB_WIDTH}
}

proc update_MODELPARAM_VALUE.AXI_DATA_WIDTH { MODELPARAM_VALUE.AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	# WARNING: There is no corresponding user parameter named "AXI_DATA_WIDTH". Setting updated value from the model parameter.
set_property value 128 ${MODELPARAM_VALUE.AXI_DATA_WIDTH}
}

