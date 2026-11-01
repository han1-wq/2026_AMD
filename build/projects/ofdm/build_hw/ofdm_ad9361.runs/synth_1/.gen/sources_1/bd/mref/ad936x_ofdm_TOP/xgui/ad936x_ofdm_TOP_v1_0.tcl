# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "DMA_ENABLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "RS_ENABLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "RS_INTERLEAVE" -parent ${Page_0}


}

proc update_PARAM_VALUE.DMA_ENABLE { PARAM_VALUE.DMA_ENABLE } {
	# Procedure called to update DMA_ENABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DMA_ENABLE { PARAM_VALUE.DMA_ENABLE } {
	# Procedure called to validate DMA_ENABLE
	return true
}

proc update_PARAM_VALUE.RS_ENABLE { PARAM_VALUE.RS_ENABLE } {
	# Procedure called to update RS_ENABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RS_ENABLE { PARAM_VALUE.RS_ENABLE } {
	# Procedure called to validate RS_ENABLE
	return true
}

proc update_PARAM_VALUE.RS_INTERLEAVE { PARAM_VALUE.RS_INTERLEAVE } {
	# Procedure called to update RS_INTERLEAVE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RS_INTERLEAVE { PARAM_VALUE.RS_INTERLEAVE } {
	# Procedure called to validate RS_INTERLEAVE
	return true
}


proc update_MODELPARAM_VALUE.DMA_ENABLE { MODELPARAM_VALUE.DMA_ENABLE PARAM_VALUE.DMA_ENABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DMA_ENABLE}] ${MODELPARAM_VALUE.DMA_ENABLE}
}

proc update_MODELPARAM_VALUE.RS_ENABLE { MODELPARAM_VALUE.RS_ENABLE PARAM_VALUE.RS_ENABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RS_ENABLE}] ${MODELPARAM_VALUE.RS_ENABLE}
}

proc update_MODELPARAM_VALUE.RS_INTERLEAVE { MODELPARAM_VALUE.RS_INTERLEAVE PARAM_VALUE.RS_INTERLEAVE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RS_INTERLEAVE}] ${MODELPARAM_VALUE.RS_INTERLEAVE}
}

