set moduleName p_anonymous_namespace_histogram_pixels
set isTopModule 0
set isCombinational 0
set isDatapathOnly 0
set isPipelined 1
set pipeline_type none
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set hasInterrupt 0
set C_modelName {(anonymous namespace)histogram_pixels}
set C_modelType { void 0 }
set C_modelArgList {
	{ pixels int 24 regular {fifo 0 volatile }  }
	{ hist int 32 regular {array 256 { 1 0 } 1 1 }  }
	{ color_0 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ color_1 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ color_2 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ flags int 2 regular  }
	{ saturation int 14 regular  }
	{ p_read int 32 regular  }
}
set C_modelArgMapList {[ 
	{ "Name" : "pixels", "interface" : "fifo", "bitwidth" : 24, "direction" : "READONLY"} , 
 	{ "Name" : "hist", "interface" : "memory", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "color_0", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "color_1", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "color_2", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "flags", "interface" : "wire", "bitwidth" : 2, "direction" : "READONLY"} , 
 	{ "Name" : "saturation", "interface" : "wire", "bitwidth" : 14, "direction" : "READONLY"} , 
 	{ "Name" : "p_read", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} ]}
# RTL Port declarations: 
set portNum 31
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ pixels_dout sc_in sc_lv 24 signal 0 } 
	{ pixels_num_data_valid sc_in sc_lv 7 signal 0 } 
	{ pixels_fifo_cap sc_in sc_lv 7 signal 0 } 
	{ pixels_empty_n sc_in sc_logic 1 signal 0 } 
	{ pixels_read sc_out sc_logic 1 signal 0 } 
	{ hist_address0 sc_out sc_lv 8 signal 1 } 
	{ hist_ce0 sc_out sc_logic 1 signal 1 } 
	{ hist_q0 sc_in sc_lv 32 signal 1 } 
	{ hist_address1 sc_out sc_lv 8 signal 1 } 
	{ hist_ce1 sc_out sc_logic 1 signal 1 } 
	{ hist_we1 sc_out sc_logic 1 signal 1 } 
	{ hist_d1 sc_out sc_lv 32 signal 1 } 
	{ color_0_address0 sc_out sc_lv 8 signal 2 } 
	{ color_0_ce0 sc_out sc_logic 1 signal 2 } 
	{ color_0_q0 sc_in sc_lv 8 signal 2 } 
	{ color_1_address0 sc_out sc_lv 8 signal 3 } 
	{ color_1_ce0 sc_out sc_logic 1 signal 3 } 
	{ color_1_q0 sc_in sc_lv 8 signal 3 } 
	{ color_2_address0 sc_out sc_lv 8 signal 4 } 
	{ color_2_ce0 sc_out sc_logic 1 signal 4 } 
	{ color_2_q0 sc_in sc_lv 8 signal 4 } 
	{ flags sc_in sc_lv 2 signal 5 } 
	{ saturation sc_in sc_lv 14 signal 6 } 
	{ p_read sc_in sc_lv 32 signal 7 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "pixels_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":24, "type": "signal", "bundle":{"name": "pixels", "role": "dout" }} , 
 	{ "name": "pixels_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "pixels", "role": "num_data_valid" }} , 
 	{ "name": "pixels_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "pixels", "role": "fifo_cap" }} , 
 	{ "name": "pixels_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "pixels", "role": "empty_n" }} , 
 	{ "name": "pixels_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "pixels", "role": "read" }} , 
 	{ "name": "hist_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "hist", "role": "address0" }} , 
 	{ "name": "hist_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist", "role": "ce0" }} , 
 	{ "name": "hist_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "hist", "role": "q0" }} , 
 	{ "name": "hist_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "hist", "role": "address1" }} , 
 	{ "name": "hist_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist", "role": "ce1" }} , 
 	{ "name": "hist_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist", "role": "we1" }} , 
 	{ "name": "hist_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "hist", "role": "d1" }} , 
 	{ "name": "color_0_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_0", "role": "address0" }} , 
 	{ "name": "color_0_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_0", "role": "ce0" }} , 
 	{ "name": "color_0_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_0", "role": "q0" }} , 
 	{ "name": "color_1_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_1", "role": "address0" }} , 
 	{ "name": "color_1_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_1", "role": "ce0" }} , 
 	{ "name": "color_1_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_1", "role": "q0" }} , 
 	{ "name": "color_2_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_2", "role": "address0" }} , 
 	{ "name": "color_2_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_2", "role": "ce0" }} , 
 	{ "name": "color_2_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_2", "role": "q0" }} , 
 	{ "name": "flags", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "flags", "role": "default" }} , 
 	{ "name": "saturation", "direction": "in", "datatype": "sc_lv", "bitwidth":14, "type": "signal", "bundle":{"name": "saturation", "role": "default" }} , 
 	{ "name": "p_read", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_read", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
		"CDFG" : "p_anonymous_namespace_histogram_pixels",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "346128", "EstimateLatencyMax" : "4147216",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "pixels", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "pixels_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "hist", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "color_0", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "color_1", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "color_2", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "flags", "Type" : "None", "Direction" : "I"},
			{"Name" : "saturation", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read", "Type" : "None", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "3", "DependentChanType" : "1"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_109_1", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "2", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter8", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter8", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "1"}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_8ns_9ns_16_1_1_U56", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_8ns_5ns_8ns_13_4_1_U57", "Parent" : "0"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_8ns_7ns_16ns_16_4_1_U58", "Parent" : "0"},
	{"ID" : "4", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_14ns_9s_20ns_24_4_1_U59", "Parent" : "0"},
	{"ID" : "5", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_14ns_9s_20ns_24_4_1_U60", "Parent" : "0"},
	{"ID" : "6", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_14ns_9s_20ns_24_4_1_U61", "Parent" : "0"},
	{"ID" : "7", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_8ns_5ns_8ns_13_4_1_U62", "Parent" : "0"},
	{"ID" : "8", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_8ns_7ns_13ns_15_4_1_U63", "Parent" : "0"},
	{"ID" : "9", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_8ns_8ns_15ns_16_4_1_U64", "Parent" : "0"},
	{"ID" : "10", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.flow_control_loop_delay_pipe_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	p_anonymous_namespace_histogram_pixels {
		pixels {Type I LastRead 1 FirstWrite -1}
		hist {Type IO LastRead 15 FirstWrite 16}
		color_0 {Type I LastRead 1 FirstWrite -1}
		color_1 {Type I LastRead 3 FirstWrite -1}
		color_2 {Type I LastRead 1 FirstWrite -1}
		flags {Type I LastRead 0 FirstWrite -1}
		saturation {Type I LastRead 0 FirstWrite -1}
		p_read {Type I LastRead 0 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "346128", "Max" : "4147216"}
	, {"Name" : "Interval", "Min" : "346128", "Max" : "4147216"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	pixels { ap_fifo {  { pixels_dout fifo_port_we 0 24 }  { pixels_num_data_valid fifo_status_num_data_valid 0 7 }  { pixels_fifo_cap fifo_update 0 7 }  { pixels_empty_n fifo_status 0 1 }  { pixels_read fifo_data 1 1 } } }
	hist { ap_memory {  { hist_address0 mem_address 1 8 }  { hist_ce0 mem_ce 1 1 }  { hist_q0 in_data 0 32 }  { hist_address1 MemPortADDR2 1 8 }  { hist_ce1 MemPortCE2 1 1 }  { hist_we1 MemPortWE2 1 1 }  { hist_d1 MemPortDIN2 1 32 } } }
	color_0 { ap_memory {  { color_0_address0 mem_address 1 8 }  { color_0_ce0 mem_ce 1 1 }  { color_0_q0 in_data 0 8 } } }
	color_1 { ap_memory {  { color_1_address0 mem_address 1 8 }  { color_1_ce0 mem_ce 1 1 }  { color_1_q0 in_data 0 8 } } }
	color_2 { ap_memory {  { color_2_address0 mem_address 1 8 }  { color_2_ce0 mem_ce 1 1 }  { color_2_q0 in_data 0 8 } } }
	flags { ap_none {  { flags in_data 0 2 } } }
	saturation { ap_none {  { saturation in_data 0 14 } } }
	p_read { ap_none {  { p_read in_data 0 32 } } }
}
set moduleName p_anonymous_namespace_histogram_pixels
set isTopModule 0
set isCombinational 0
set isDatapathOnly 0
set isPipelined 1
set pipeline_type none
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set hasInterrupt 0
set C_modelName {(anonymous namespace)histogram_pixels}
set C_modelType { void 0 }
set C_modelArgList {
	{ pixels int 24 regular {fifo 0 volatile }  }
	{ hist int 32 regular {array 256 { 1 0 } 1 1 }  }
	{ color_0 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ color_1 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ color_2 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ flags int 2 regular  }
	{ saturation int 14 regular  }
	{ p_read int 22 regular  }
}
set C_modelArgMapList {[ 
	{ "Name" : "pixels", "interface" : "fifo", "bitwidth" : 24, "direction" : "READONLY"} , 
 	{ "Name" : "hist", "interface" : "memory", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "color_0", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "color_1", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "color_2", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "flags", "interface" : "wire", "bitwidth" : 2, "direction" : "READONLY"} , 
 	{ "Name" : "saturation", "interface" : "wire", "bitwidth" : 14, "direction" : "READONLY"} , 
 	{ "Name" : "p_read", "interface" : "wire", "bitwidth" : 22, "direction" : "READONLY"} ]}
# RTL Port declarations: 
set portNum 31
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ pixels_dout sc_in sc_lv 24 signal 0 } 
	{ pixels_num_data_valid sc_in sc_lv 7 signal 0 } 
	{ pixels_fifo_cap sc_in sc_lv 7 signal 0 } 
	{ pixels_empty_n sc_in sc_logic 1 signal 0 } 
	{ pixels_read sc_out sc_logic 1 signal 0 } 
	{ hist_address0 sc_out sc_lv 8 signal 1 } 
	{ hist_ce0 sc_out sc_logic 1 signal 1 } 
	{ hist_q0 sc_in sc_lv 32 signal 1 } 
	{ hist_address1 sc_out sc_lv 8 signal 1 } 
	{ hist_ce1 sc_out sc_logic 1 signal 1 } 
	{ hist_we1 sc_out sc_logic 1 signal 1 } 
	{ hist_d1 sc_out sc_lv 32 signal 1 } 
	{ color_0_address0 sc_out sc_lv 8 signal 2 } 
	{ color_0_ce0 sc_out sc_logic 1 signal 2 } 
	{ color_0_q0 sc_in sc_lv 8 signal 2 } 
	{ color_1_address0 sc_out sc_lv 8 signal 3 } 
	{ color_1_ce0 sc_out sc_logic 1 signal 3 } 
	{ color_1_q0 sc_in sc_lv 8 signal 3 } 
	{ color_2_address0 sc_out sc_lv 8 signal 4 } 
	{ color_2_ce0 sc_out sc_logic 1 signal 4 } 
	{ color_2_q0 sc_in sc_lv 8 signal 4 } 
	{ flags sc_in sc_lv 2 signal 5 } 
	{ saturation sc_in sc_lv 14 signal 6 } 
	{ p_read sc_in sc_lv 22 signal 7 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "pixels_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":24, "type": "signal", "bundle":{"name": "pixels", "role": "dout" }} , 
 	{ "name": "pixels_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "pixels", "role": "num_data_valid" }} , 
 	{ "name": "pixels_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "pixels", "role": "fifo_cap" }} , 
 	{ "name": "pixels_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "pixels", "role": "empty_n" }} , 
 	{ "name": "pixels_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "pixels", "role": "read" }} , 
 	{ "name": "hist_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "hist", "role": "address0" }} , 
 	{ "name": "hist_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist", "role": "ce0" }} , 
 	{ "name": "hist_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "hist", "role": "q0" }} , 
 	{ "name": "hist_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "hist", "role": "address1" }} , 
 	{ "name": "hist_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist", "role": "ce1" }} , 
 	{ "name": "hist_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist", "role": "we1" }} , 
 	{ "name": "hist_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "hist", "role": "d1" }} , 
 	{ "name": "color_0_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_0", "role": "address0" }} , 
 	{ "name": "color_0_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_0", "role": "ce0" }} , 
 	{ "name": "color_0_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_0", "role": "q0" }} , 
 	{ "name": "color_1_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_1", "role": "address0" }} , 
 	{ "name": "color_1_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_1", "role": "ce0" }} , 
 	{ "name": "color_1_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_1", "role": "q0" }} , 
 	{ "name": "color_2_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_2", "role": "address0" }} , 
 	{ "name": "color_2_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_2", "role": "ce0" }} , 
 	{ "name": "color_2_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_2", "role": "q0" }} , 
 	{ "name": "flags", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "flags", "role": "default" }} , 
 	{ "name": "saturation", "direction": "in", "datatype": "sc_lv", "bitwidth":14, "type": "signal", "bundle":{"name": "saturation", "role": "default" }} , 
 	{ "name": "p_read", "direction": "in", "datatype": "sc_lv", "bitwidth":22, "type": "signal", "bundle":{"name": "p_read", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
		"CDFG" : "p_anonymous_namespace_histogram_pixels",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "346128", "EstimateLatencyMax" : "4147216",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "pixels", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "pixels_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "hist", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "color_0", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "color_1", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "color_2", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "flags", "Type" : "None", "Direction" : "I"},
			{"Name" : "saturation", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read", "Type" : "None", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "3", "DependentChanType" : "1"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_124_1", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "2", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter8", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter8", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "1"}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_8ns_9ns_16_1_1_U56", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_8ns_5ns_8ns_13_4_1_U57", "Parent" : "0"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_8ns_7ns_16ns_16_4_1_U58", "Parent" : "0"},
	{"ID" : "4", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_14ns_9s_20ns_24_4_1_U59", "Parent" : "0"},
	{"ID" : "5", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_14ns_9s_20ns_24_4_1_U60", "Parent" : "0"},
	{"ID" : "6", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_14ns_9s_20ns_24_4_1_U61", "Parent" : "0"},
	{"ID" : "7", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_8ns_5ns_8ns_13_4_1_U62", "Parent" : "0"},
	{"ID" : "8", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_8ns_7ns_13ns_15_4_1_U63", "Parent" : "0"},
	{"ID" : "9", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_8ns_8ns_15ns_16_4_1_U64", "Parent" : "0"},
	{"ID" : "10", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.flow_control_loop_delay_pipe_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	p_anonymous_namespace_histogram_pixels {
		pixels {Type I LastRead 1 FirstWrite -1}
		hist {Type IO LastRead 15 FirstWrite 16}
		color_0 {Type I LastRead 1 FirstWrite -1}
		color_1 {Type I LastRead 3 FirstWrite -1}
		color_2 {Type I LastRead 1 FirstWrite -1}
		flags {Type I LastRead 0 FirstWrite -1}
		saturation {Type I LastRead 0 FirstWrite -1}
		p_read {Type I LastRead 0 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "346128", "Max" : "4147216"}
	, {"Name" : "Interval", "Min" : "346128", "Max" : "4147216"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	pixels { ap_fifo {  { pixels_dout fifo_port_we 0 24 }  { pixels_num_data_valid fifo_status_num_data_valid 0 7 }  { pixels_fifo_cap fifo_update 0 7 }  { pixels_empty_n fifo_status 0 1 }  { pixels_read fifo_data 1 1 } } }
	hist { ap_memory {  { hist_address0 mem_address 1 8 }  { hist_ce0 mem_ce 1 1 }  { hist_q0 in_data 0 32 }  { hist_address1 MemPortADDR2 1 8 }  { hist_ce1 MemPortCE2 1 1 }  { hist_we1 MemPortWE2 1 1 }  { hist_d1 MemPortDIN2 1 32 } } }
	color_0 { ap_memory {  { color_0_address0 mem_address 1 8 }  { color_0_ce0 mem_ce 1 1 }  { color_0_q0 in_data 0 8 } } }
	color_1 { ap_memory {  { color_1_address0 mem_address 1 8 }  { color_1_ce0 mem_ce 1 1 }  { color_1_q0 in_data 0 8 } } }
	color_2 { ap_memory {  { color_2_address0 mem_address 1 8 }  { color_2_ce0 mem_ce 1 1 }  { color_2_q0 in_data 0 8 } } }
	flags { ap_none {  { flags in_data 0 2 } } }
	saturation { ap_none {  { saturation in_data 0 14 } } }
	p_read { ap_none {  { p_read in_data 0 22 } } }
}
set moduleName p_anonymous_namespace_histogram_pixels
set isTopModule 0
set isCombinational 0
set isDatapathOnly 0
set isPipelined 1
set pipeline_type none
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set hasInterrupt 0
set C_modelName {(anonymous namespace)histogram_pixels}
set C_modelType { void 0 }
set C_modelArgList {
	{ pixels int 24 regular {fifo 0 volatile }  }
	{ hist int 32 regular {array 256 { 1 0 } 1 1 }  }
	{ color_0 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ color_1 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ color_2 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ flags int 2 regular  }
	{ saturation int 14 regular  }
	{ p_read int 22 regular  }
}
set C_modelArgMapList {[ 
	{ "Name" : "pixels", "interface" : "fifo", "bitwidth" : 24, "direction" : "READONLY"} , 
 	{ "Name" : "hist", "interface" : "memory", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "color_0", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "color_1", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "color_2", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "flags", "interface" : "wire", "bitwidth" : 2, "direction" : "READONLY"} , 
 	{ "Name" : "saturation", "interface" : "wire", "bitwidth" : 14, "direction" : "READONLY"} , 
 	{ "Name" : "p_read", "interface" : "wire", "bitwidth" : 22, "direction" : "READONLY"} ]}
# RTL Port declarations: 
set portNum 31
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ pixels_dout sc_in sc_lv 24 signal 0 } 
	{ pixels_num_data_valid sc_in sc_lv 7 signal 0 } 
	{ pixels_fifo_cap sc_in sc_lv 7 signal 0 } 
	{ pixels_empty_n sc_in sc_logic 1 signal 0 } 
	{ pixels_read sc_out sc_logic 1 signal 0 } 
	{ hist_address0 sc_out sc_lv 8 signal 1 } 
	{ hist_ce0 sc_out sc_logic 1 signal 1 } 
	{ hist_q0 sc_in sc_lv 32 signal 1 } 
	{ hist_address1 sc_out sc_lv 8 signal 1 } 
	{ hist_ce1 sc_out sc_logic 1 signal 1 } 
	{ hist_we1 sc_out sc_logic 1 signal 1 } 
	{ hist_d1 sc_out sc_lv 32 signal 1 } 
	{ color_0_address0 sc_out sc_lv 8 signal 2 } 
	{ color_0_ce0 sc_out sc_logic 1 signal 2 } 
	{ color_0_q0 sc_in sc_lv 8 signal 2 } 
	{ color_1_address0 sc_out sc_lv 8 signal 3 } 
	{ color_1_ce0 sc_out sc_logic 1 signal 3 } 
	{ color_1_q0 sc_in sc_lv 8 signal 3 } 
	{ color_2_address0 sc_out sc_lv 8 signal 4 } 
	{ color_2_ce0 sc_out sc_logic 1 signal 4 } 
	{ color_2_q0 sc_in sc_lv 8 signal 4 } 
	{ flags sc_in sc_lv 2 signal 5 } 
	{ saturation sc_in sc_lv 14 signal 6 } 
	{ p_read sc_in sc_lv 22 signal 7 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "pixels_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":24, "type": "signal", "bundle":{"name": "pixels", "role": "dout" }} , 
 	{ "name": "pixels_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "pixels", "role": "num_data_valid" }} , 
 	{ "name": "pixels_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "pixels", "role": "fifo_cap" }} , 
 	{ "name": "pixels_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "pixels", "role": "empty_n" }} , 
 	{ "name": "pixels_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "pixels", "role": "read" }} , 
 	{ "name": "hist_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "hist", "role": "address0" }} , 
 	{ "name": "hist_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist", "role": "ce0" }} , 
 	{ "name": "hist_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "hist", "role": "q0" }} , 
 	{ "name": "hist_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "hist", "role": "address1" }} , 
 	{ "name": "hist_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist", "role": "ce1" }} , 
 	{ "name": "hist_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist", "role": "we1" }} , 
 	{ "name": "hist_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "hist", "role": "d1" }} , 
 	{ "name": "color_0_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_0", "role": "address0" }} , 
 	{ "name": "color_0_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_0", "role": "ce0" }} , 
 	{ "name": "color_0_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_0", "role": "q0" }} , 
 	{ "name": "color_1_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_1", "role": "address0" }} , 
 	{ "name": "color_1_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_1", "role": "ce0" }} , 
 	{ "name": "color_1_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_1", "role": "q0" }} , 
 	{ "name": "color_2_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_2", "role": "address0" }} , 
 	{ "name": "color_2_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_2", "role": "ce0" }} , 
 	{ "name": "color_2_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_2", "role": "q0" }} , 
 	{ "name": "flags", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "flags", "role": "default" }} , 
 	{ "name": "saturation", "direction": "in", "datatype": "sc_lv", "bitwidth":14, "type": "signal", "bundle":{"name": "saturation", "role": "default" }} , 
 	{ "name": "p_read", "direction": "in", "datatype": "sc_lv", "bitwidth":22, "type": "signal", "bundle":{"name": "p_read", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "3", "4", "5", "6", "7", "8"],
		"CDFG" : "p_anonymous_namespace_histogram_pixels",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "346129", "EstimateLatencyMax" : "4147217",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "pixels", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "pixels_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "hist", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "color_0", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "color_1", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "color_2", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "flags", "Type" : "None", "Direction" : "I"},
			{"Name" : "saturation", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read", "Type" : "None", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "3", "DependentChanType" : "1"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_149_1", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "2", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage1", "LastStateIter" : "ap_enable_reg_pp0_iter8", "LastStateBlock" : "ap_block_pp0_stage1_subdone", "QuitState" : "ap_ST_fsm_pp0_stage1", "QuitStateIter" : "ap_enable_reg_pp0_iter8", "QuitStateBlock" : "ap_block_pp0_stage1_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "1"}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_8ns_8ns_15s_17_4_1_U56", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_8ns_7ns_17s_18_4_1_U57", "Parent" : "0"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_14ns_10s_22s_25_4_1_U58", "Parent" : "0"},
	{"ID" : "4", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_14ns_10s_22s_25_4_1_U59", "Parent" : "0"},
	{"ID" : "5", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_14ns_10s_22s_25_4_1_U60", "Parent" : "0"},
	{"ID" : "6", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_8ns_8ns_15s_16_4_1_U61", "Parent" : "0"},
	{"ID" : "7", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_8ns_7ns_16s_16_4_1_U62", "Parent" : "0"},
	{"ID" : "8", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.flow_control_loop_delay_pipe_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	p_anonymous_namespace_histogram_pixels {
		pixels {Type I LastRead 1 FirstWrite -1}
		hist {Type IO LastRead 16 FirstWrite 17}
		color_0 {Type I LastRead 3 FirstWrite -1}
		color_1 {Type I LastRead 1 FirstWrite -1}
		color_2 {Type I LastRead 1 FirstWrite -1}
		flags {Type I LastRead 0 FirstWrite -1}
		saturation {Type I LastRead 0 FirstWrite -1}
		p_read {Type I LastRead 0 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "346129", "Max" : "4147217"}
	, {"Name" : "Interval", "Min" : "346129", "Max" : "4147217"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	pixels { ap_fifo {  { pixels_dout fifo_port_we 0 24 }  { pixels_num_data_valid fifo_status_num_data_valid 0 7 }  { pixels_fifo_cap fifo_update 0 7 }  { pixels_empty_n fifo_status 0 1 }  { pixels_read fifo_data 1 1 } } }
	hist { ap_memory {  { hist_address0 mem_address 1 8 }  { hist_ce0 mem_ce 1 1 }  { hist_q0 in_data 0 32 }  { hist_address1 MemPortADDR2 1 8 }  { hist_ce1 MemPortCE2 1 1 }  { hist_we1 MemPortWE2 1 1 }  { hist_d1 MemPortDIN2 1 32 } } }
	color_0 { ap_memory {  { color_0_address0 mem_address 1 8 }  { color_0_ce0 mem_ce 1 1 }  { color_0_q0 in_data 0 8 } } }
	color_1 { ap_memory {  { color_1_address0 mem_address 1 8 }  { color_1_ce0 mem_ce 1 1 }  { color_1_q0 in_data 0 8 } } }
	color_2 { ap_memory {  { color_2_address0 mem_address 1 8 }  { color_2_ce0 mem_ce 1 1 }  { color_2_q0 in_data 0 8 } } }
	flags { ap_none {  { flags in_data 0 2 } } }
	saturation { ap_none {  { saturation in_data 0 14 } } }
	p_read { ap_none {  { p_read in_data 0 22 } } }
}
set moduleName p_anonymous_namespace_histogram_pixels
set isTopModule 0
set isCombinational 0
set isDatapathOnly 0
set isPipelined 1
set pipeline_type none
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set hasInterrupt 0
set C_modelName {(anonymous namespace)histogram_pixels}
set C_modelType { void 0 }
set C_modelArgList {
	{ pixels int 24 regular {fifo 0 volatile }  }
	{ hist int 32 regular {array 256 { 1 0 } 1 1 }  }
	{ color_0 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ color_1 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ color_2 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ flags int 2 regular  }
	{ saturation int 14 regular  }
	{ p_read int 22 regular  }
}
set C_modelArgMapList {[ 
	{ "Name" : "pixels", "interface" : "fifo", "bitwidth" : 24, "direction" : "READONLY"} , 
 	{ "Name" : "hist", "interface" : "memory", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "color_0", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "color_1", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "color_2", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "flags", "interface" : "wire", "bitwidth" : 2, "direction" : "READONLY"} , 
 	{ "Name" : "saturation", "interface" : "wire", "bitwidth" : 14, "direction" : "READONLY"} , 
 	{ "Name" : "p_read", "interface" : "wire", "bitwidth" : 22, "direction" : "READONLY"} ]}
# RTL Port declarations: 
set portNum 31
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ pixels_dout sc_in sc_lv 24 signal 0 } 
	{ pixels_num_data_valid sc_in sc_lv 7 signal 0 } 
	{ pixels_fifo_cap sc_in sc_lv 7 signal 0 } 
	{ pixels_empty_n sc_in sc_logic 1 signal 0 } 
	{ pixels_read sc_out sc_logic 1 signal 0 } 
	{ hist_address0 sc_out sc_lv 8 signal 1 } 
	{ hist_ce0 sc_out sc_logic 1 signal 1 } 
	{ hist_q0 sc_in sc_lv 32 signal 1 } 
	{ hist_address1 sc_out sc_lv 8 signal 1 } 
	{ hist_ce1 sc_out sc_logic 1 signal 1 } 
	{ hist_we1 sc_out sc_logic 1 signal 1 } 
	{ hist_d1 sc_out sc_lv 32 signal 1 } 
	{ color_0_address0 sc_out sc_lv 8 signal 2 } 
	{ color_0_ce0 sc_out sc_logic 1 signal 2 } 
	{ color_0_q0 sc_in sc_lv 8 signal 2 } 
	{ color_1_address0 sc_out sc_lv 8 signal 3 } 
	{ color_1_ce0 sc_out sc_logic 1 signal 3 } 
	{ color_1_q0 sc_in sc_lv 8 signal 3 } 
	{ color_2_address0 sc_out sc_lv 8 signal 4 } 
	{ color_2_ce0 sc_out sc_logic 1 signal 4 } 
	{ color_2_q0 sc_in sc_lv 8 signal 4 } 
	{ flags sc_in sc_lv 2 signal 5 } 
	{ saturation sc_in sc_lv 14 signal 6 } 
	{ p_read sc_in sc_lv 22 signal 7 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "pixels_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":24, "type": "signal", "bundle":{"name": "pixels", "role": "dout" }} , 
 	{ "name": "pixels_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "pixels", "role": "num_data_valid" }} , 
 	{ "name": "pixels_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "pixels", "role": "fifo_cap" }} , 
 	{ "name": "pixels_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "pixels", "role": "empty_n" }} , 
 	{ "name": "pixels_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "pixels", "role": "read" }} , 
 	{ "name": "hist_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "hist", "role": "address0" }} , 
 	{ "name": "hist_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist", "role": "ce0" }} , 
 	{ "name": "hist_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "hist", "role": "q0" }} , 
 	{ "name": "hist_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "hist", "role": "address1" }} , 
 	{ "name": "hist_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist", "role": "ce1" }} , 
 	{ "name": "hist_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist", "role": "we1" }} , 
 	{ "name": "hist_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "hist", "role": "d1" }} , 
 	{ "name": "color_0_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_0", "role": "address0" }} , 
 	{ "name": "color_0_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_0", "role": "ce0" }} , 
 	{ "name": "color_0_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_0", "role": "q0" }} , 
 	{ "name": "color_1_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_1", "role": "address0" }} , 
 	{ "name": "color_1_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_1", "role": "ce0" }} , 
 	{ "name": "color_1_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_1", "role": "q0" }} , 
 	{ "name": "color_2_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_2", "role": "address0" }} , 
 	{ "name": "color_2_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_2", "role": "ce0" }} , 
 	{ "name": "color_2_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_2", "role": "q0" }} , 
 	{ "name": "flags", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "flags", "role": "default" }} , 
 	{ "name": "saturation", "direction": "in", "datatype": "sc_lv", "bitwidth":14, "type": "signal", "bundle":{"name": "saturation", "role": "default" }} , 
 	{ "name": "p_read", "direction": "in", "datatype": "sc_lv", "bitwidth":22, "type": "signal", "bundle":{"name": "p_read", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "3", "4", "5", "6", "7", "8"],
		"CDFG" : "p_anonymous_namespace_histogram_pixels",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "346129", "EstimateLatencyMax" : "4147217",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "pixels", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "pixels_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "hist", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "color_0", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "color_1", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "color_2", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "flags", "Type" : "None", "Direction" : "I"},
			{"Name" : "saturation", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read", "Type" : "None", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "3", "DependentChanType" : "1"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_149_1", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "2", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage1", "LastStateIter" : "ap_enable_reg_pp0_iter8", "LastStateBlock" : "ap_block_pp0_stage1_subdone", "QuitState" : "ap_ST_fsm_pp0_stage1", "QuitStateIter" : "ap_enable_reg_pp0_iter8", "QuitStateBlock" : "ap_block_pp0_stage1_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "1"}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_8ns_8ns_15s_17_4_1_U56", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_8ns_7ns_17s_18_4_1_U57", "Parent" : "0"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_14ns_10s_22s_25_4_1_U58", "Parent" : "0"},
	{"ID" : "4", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_14ns_10s_22s_25_4_1_U59", "Parent" : "0"},
	{"ID" : "5", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_14ns_10s_22s_25_4_1_U60", "Parent" : "0"},
	{"ID" : "6", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_8ns_8ns_15s_16_4_1_U61", "Parent" : "0"},
	{"ID" : "7", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_8ns_7ns_16s_16_4_1_U62", "Parent" : "0"},
	{"ID" : "8", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.flow_control_loop_delay_pipe_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	p_anonymous_namespace_histogram_pixels {
		pixels {Type I LastRead 1 FirstWrite -1}
		hist {Type IO LastRead 16 FirstWrite 17}
		color_0 {Type I LastRead 3 FirstWrite -1}
		color_1 {Type I LastRead 1 FirstWrite -1}
		color_2 {Type I LastRead 1 FirstWrite -1}
		flags {Type I LastRead 0 FirstWrite -1}
		saturation {Type I LastRead 0 FirstWrite -1}
		p_read {Type I LastRead 0 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "346129", "Max" : "4147217"}
	, {"Name" : "Interval", "Min" : "346129", "Max" : "4147217"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	pixels { ap_fifo {  { pixels_dout fifo_port_we 0 24 }  { pixels_num_data_valid fifo_status_num_data_valid 0 7 }  { pixels_fifo_cap fifo_update 0 7 }  { pixels_empty_n fifo_status 0 1 }  { pixels_read fifo_data 1 1 } } }
	hist { ap_memory {  { hist_address0 mem_address 1 8 }  { hist_ce0 mem_ce 1 1 }  { hist_q0 in_data 0 32 }  { hist_address1 MemPortADDR2 1 8 }  { hist_ce1 MemPortCE2 1 1 }  { hist_we1 MemPortWE2 1 1 }  { hist_d1 MemPortDIN2 1 32 } } }
	color_0 { ap_memory {  { color_0_address0 mem_address 1 8 }  { color_0_ce0 mem_ce 1 1 }  { color_0_q0 in_data 0 8 } } }
	color_1 { ap_memory {  { color_1_address0 mem_address 1 8 }  { color_1_ce0 mem_ce 1 1 }  { color_1_q0 in_data 0 8 } } }
	color_2 { ap_memory {  { color_2_address0 mem_address 1 8 }  { color_2_ce0 mem_ce 1 1 }  { color_2_q0 in_data 0 8 } } }
	flags { ap_none {  { flags in_data 0 2 } } }
	saturation { ap_none {  { saturation in_data 0 14 } } }
	p_read { ap_none {  { p_read in_data 0 22 } } }
}
