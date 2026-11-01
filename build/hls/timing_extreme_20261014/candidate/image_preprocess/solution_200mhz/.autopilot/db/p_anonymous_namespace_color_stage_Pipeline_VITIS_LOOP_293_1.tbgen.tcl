set moduleName p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_293_1
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
set C_modelName {(anonymous namespace)color_stage_Pipeline_VITIS_LOOP_293_1}
set C_modelType { void 0 }
set C_modelArgList {
	{ p_read1 int 22 regular  }
	{ in_pixels int 24 regular {fifo 0 volatile }  }
	{ color_0 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ color_1 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ color_2 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ flags_cast_i int 1 regular  }
	{ zext_ln1540 int 14 regular  }
	{ tobool31_i_i int 1 regular  }
	{ hist_pixels int 8 regular {fifo 1 volatile }  }
	{ eq int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ eq_enabled int 1 regular  }
	{ pairs int 48 regular {fifo 1 volatile }  }
}
set C_modelArgMapList {[ 
	{ "Name" : "p_read1", "interface" : "wire", "bitwidth" : 22, "direction" : "READONLY"} , 
 	{ "Name" : "in_pixels", "interface" : "fifo", "bitwidth" : 24, "direction" : "READONLY"} , 
 	{ "Name" : "color_0", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "color_1", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "color_2", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "flags_cast_i", "interface" : "wire", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "zext_ln1540", "interface" : "wire", "bitwidth" : 14, "direction" : "READONLY"} , 
 	{ "Name" : "tobool31_i_i", "interface" : "wire", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "hist_pixels", "interface" : "fifo", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "eq", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "eq_enabled", "interface" : "wire", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "pairs", "interface" : "fifo", "bitwidth" : 48, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 38
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ in_pixels_dout sc_in sc_lv 24 signal 1 } 
	{ in_pixels_num_data_valid sc_in sc_lv 7 signal 1 } 
	{ in_pixels_fifo_cap sc_in sc_lv 7 signal 1 } 
	{ in_pixels_empty_n sc_in sc_logic 1 signal 1 } 
	{ in_pixels_read sc_out sc_logic 1 signal 1 } 
	{ hist_pixels_din sc_out sc_lv 8 signal 8 } 
	{ hist_pixels_num_data_valid sc_in sc_lv 7 signal 8 } 
	{ hist_pixels_fifo_cap sc_in sc_lv 7 signal 8 } 
	{ hist_pixels_full_n sc_in sc_logic 1 signal 8 } 
	{ hist_pixels_write sc_out sc_logic 1 signal 8 } 
	{ pairs_din sc_out sc_lv 48 signal 11 } 
	{ pairs_num_data_valid sc_in sc_lv 7 signal 11 } 
	{ pairs_fifo_cap sc_in sc_lv 7 signal 11 } 
	{ pairs_full_n sc_in sc_logic 1 signal 11 } 
	{ pairs_write sc_out sc_logic 1 signal 11 } 
	{ p_read1 sc_in sc_lv 22 signal 0 } 
	{ color_0_address0 sc_out sc_lv 8 signal 2 } 
	{ color_0_ce0 sc_out sc_logic 1 signal 2 } 
	{ color_0_q0 sc_in sc_lv 8 signal 2 } 
	{ color_1_address0 sc_out sc_lv 8 signal 3 } 
	{ color_1_ce0 sc_out sc_logic 1 signal 3 } 
	{ color_1_q0 sc_in sc_lv 8 signal 3 } 
	{ color_2_address0 sc_out sc_lv 8 signal 4 } 
	{ color_2_ce0 sc_out sc_logic 1 signal 4 } 
	{ color_2_q0 sc_in sc_lv 8 signal 4 } 
	{ flags_cast_i sc_in sc_lv 1 signal 5 } 
	{ zext_ln1540 sc_in sc_lv 14 signal 6 } 
	{ tobool31_i_i sc_in sc_lv 1 signal 7 } 
	{ eq_address0 sc_out sc_lv 8 signal 9 } 
	{ eq_ce0 sc_out sc_logic 1 signal 9 } 
	{ eq_q0 sc_in sc_lv 8 signal 9 } 
	{ eq_enabled sc_in sc_lv 1 signal 10 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "in_pixels_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":24, "type": "signal", "bundle":{"name": "in_pixels", "role": "dout" }} , 
 	{ "name": "in_pixels_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "in_pixels", "role": "num_data_valid" }} , 
 	{ "name": "in_pixels_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "in_pixels", "role": "fifo_cap" }} , 
 	{ "name": "in_pixels_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "in_pixels", "role": "empty_n" }} , 
 	{ "name": "in_pixels_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "in_pixels", "role": "read" }} , 
 	{ "name": "hist_pixels_din", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "hist_pixels", "role": "din" }} , 
 	{ "name": "hist_pixels_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "hist_pixels", "role": "num_data_valid" }} , 
 	{ "name": "hist_pixels_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "hist_pixels", "role": "fifo_cap" }} , 
 	{ "name": "hist_pixels_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist_pixels", "role": "full_n" }} , 
 	{ "name": "hist_pixels_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist_pixels", "role": "write" }} , 
 	{ "name": "pairs_din", "direction": "out", "datatype": "sc_lv", "bitwidth":48, "type": "signal", "bundle":{"name": "pairs", "role": "din" }} , 
 	{ "name": "pairs_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "pairs", "role": "num_data_valid" }} , 
 	{ "name": "pairs_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "pairs", "role": "fifo_cap" }} , 
 	{ "name": "pairs_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "pairs", "role": "full_n" }} , 
 	{ "name": "pairs_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "pairs", "role": "write" }} , 
 	{ "name": "p_read1", "direction": "in", "datatype": "sc_lv", "bitwidth":22, "type": "signal", "bundle":{"name": "p_read1", "role": "default" }} , 
 	{ "name": "color_0_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_0", "role": "address0" }} , 
 	{ "name": "color_0_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_0", "role": "ce0" }} , 
 	{ "name": "color_0_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_0", "role": "q0" }} , 
 	{ "name": "color_1_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_1", "role": "address0" }} , 
 	{ "name": "color_1_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_1", "role": "ce0" }} , 
 	{ "name": "color_1_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_1", "role": "q0" }} , 
 	{ "name": "color_2_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_2", "role": "address0" }} , 
 	{ "name": "color_2_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_2", "role": "ce0" }} , 
 	{ "name": "color_2_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_2", "role": "q0" }} , 
 	{ "name": "flags_cast_i", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "flags_cast_i", "role": "default" }} , 
 	{ "name": "zext_ln1540", "direction": "in", "datatype": "sc_lv", "bitwidth":14, "type": "signal", "bundle":{"name": "zext_ln1540", "role": "default" }} , 
 	{ "name": "tobool31_i_i", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "tobool31_i_i", "role": "default" }} , 
 	{ "name": "eq_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "eq", "role": "address0" }} , 
 	{ "name": "eq_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "eq", "role": "ce0" }} , 
 	{ "name": "eq_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "eq", "role": "q0" }} , 
 	{ "name": "eq_enabled", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "eq_enabled", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "3", "4", "5", "6", "7", "8", "9"],
		"CDFG" : "p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_293_1",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "173074", "EstimateLatencyMax" : "2073618",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "p_read1", "Type" : "None", "Direction" : "I"},
			{"Name" : "in_pixels", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "in_pixels_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "color_0", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "color_1", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "color_2", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "flags_cast_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "zext_ln1540", "Type" : "None", "Direction" : "I"},
			{"Name" : "tobool31_i_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "hist_pixels", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "hist_pixels_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "eq", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "eq_enabled", "Type" : "None", "Direction" : "I"},
			{"Name" : "pairs", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "pairs_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_293_1", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter17", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter17", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_8ns_8ns_15s_17_4_1_U144", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_8ns_7ns_17s_18_4_1_U145", "Parent" : "0"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_14ns_10s_22s_25_4_1_U146", "Parent" : "0"},
	{"ID" : "4", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_14ns_10s_22s_25_4_1_U147", "Parent" : "0"},
	{"ID" : "5", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_14ns_10s_22s_25_4_1_U148", "Parent" : "0"},
	{"ID" : "6", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_9s_9ns_14s_17_4_1_U149", "Parent" : "0"},
	{"ID" : "7", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_9s_8ns_14s_16_4_1_U150", "Parent" : "0"},
	{"ID" : "8", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_9s_9ns_15s_17_4_1_U151", "Parent" : "0"},
	{"ID" : "9", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.flow_control_loop_pipe_sequential_init_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_293_1 {
		p_read1 {Type I LastRead 0 FirstWrite -1}
		in_pixels {Type I LastRead 1 FirstWrite -1}
		color_0 {Type I LastRead 3 FirstWrite -1}
		color_1 {Type I LastRead 1 FirstWrite -1}
		color_2 {Type I LastRead 2 FirstWrite -1}
		flags_cast_i {Type I LastRead 0 FirstWrite -1}
		zext_ln1540 {Type I LastRead 0 FirstWrite -1}
		tobool31_i_i {Type I LastRead 0 FirstWrite -1}
		hist_pixels {Type O LastRead -1 FirstWrite 17}
		eq {Type I LastRead 15 FirstWrite -1}
		eq_enabled {Type I LastRead 0 FirstWrite -1}
		pairs {Type O LastRead -1 FirstWrite 17}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "173074", "Max" : "2073618"}
	, {"Name" : "Interval", "Min" : "173074", "Max" : "2073618"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	p_read1 { ap_none {  { p_read1 in_data 0 22 } } }
	in_pixels { ap_fifo {  { in_pixels_dout fifo_port_we 0 24 }  { in_pixels_num_data_valid fifo_status_num_data_valid 0 7 }  { in_pixels_fifo_cap fifo_update 0 7 }  { in_pixels_empty_n fifo_status 0 1 }  { in_pixels_read fifo_data 1 1 } } }
	color_0 { ap_memory {  { color_0_address0 mem_address 1 8 }  { color_0_ce0 mem_ce 1 1 }  { color_0_q0 in_data 0 8 } } }
	color_1 { ap_memory {  { color_1_address0 mem_address 1 8 }  { color_1_ce0 mem_ce 1 1 }  { color_1_q0 in_data 0 8 } } }
	color_2 { ap_memory {  { color_2_address0 mem_address 1 8 }  { color_2_ce0 mem_ce 1 1 }  { color_2_q0 in_data 0 8 } } }
	flags_cast_i { ap_none {  { flags_cast_i in_data 0 1 } } }
	zext_ln1540 { ap_none {  { zext_ln1540 in_data 0 14 } } }
	tobool31_i_i { ap_none {  { tobool31_i_i in_data 0 1 } } }
	hist_pixels { ap_fifo {  { hist_pixels_din fifo_port_we 1 8 }  { hist_pixels_num_data_valid fifo_status_num_data_valid 0 7 }  { hist_pixels_fifo_cap fifo_update 0 7 }  { hist_pixels_full_n fifo_status 0 1 }  { hist_pixels_write fifo_data 1 1 } } }
	eq { ap_memory {  { eq_address0 mem_address 1 8 }  { eq_ce0 mem_ce 1 1 }  { eq_q0 in_data 0 8 } } }
	eq_enabled { ap_none {  { eq_enabled in_data 0 1 } } }
	pairs { ap_fifo {  { pairs_din fifo_port_we 1 48 }  { pairs_num_data_valid fifo_status_num_data_valid 0 7 }  { pairs_fifo_cap fifo_update 0 7 }  { pairs_full_n fifo_status 0 1 }  { pairs_write fifo_data 1 1 } } }
}
