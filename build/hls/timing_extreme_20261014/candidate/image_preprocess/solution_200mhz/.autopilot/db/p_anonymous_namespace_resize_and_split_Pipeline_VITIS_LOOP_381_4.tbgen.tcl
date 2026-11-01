set moduleName p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_381_4
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
set C_modelName {(anonymous namespace)resize_and_split_Pipeline_VITIS_LOOP_381_4}
set C_modelType { void 0 }
set C_modelArgList {
	{ px int 9 regular  }
	{ add_i244_i int 10 regular  }
	{ content_y int 1 regular  }
	{ xc_index int 11 regular {array 416 { 1 } 1 1 }  }
	{ xc_weight int 12 regular {array 416 { 1 } 1 1 }  }
	{ width_cast_i int 11 regular  }
	{ rows_V int 24 regular {array 1920 { 1 1 } 1 1 }  }
	{ rows_V_1 int 24 regular {array 1920 { 1 1 } 1 1 }  }
	{ trunc_ln5 int 1 regular  }
	{ sy1_V_1 int 1 regular  }
	{ zext_ln1540 int 12 regular  }
	{ quant_0 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ quant_1 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ quant_2 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ tensor_pixels int 24 regular {fifo 1 volatile }  }
}
set C_modelArgMapList {[ 
	{ "Name" : "px", "interface" : "wire", "bitwidth" : 9, "direction" : "READONLY"} , 
 	{ "Name" : "add_i244_i", "interface" : "wire", "bitwidth" : 10, "direction" : "READONLY"} , 
 	{ "Name" : "content_y", "interface" : "wire", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "xc_index", "interface" : "memory", "bitwidth" : 11, "direction" : "READONLY"} , 
 	{ "Name" : "xc_weight", "interface" : "memory", "bitwidth" : 12, "direction" : "READONLY"} , 
 	{ "Name" : "width_cast_i", "interface" : "wire", "bitwidth" : 11, "direction" : "READONLY"} , 
 	{ "Name" : "rows_V", "interface" : "memory", "bitwidth" : 24, "direction" : "READONLY"} , 
 	{ "Name" : "rows_V_1", "interface" : "memory", "bitwidth" : 24, "direction" : "READONLY"} , 
 	{ "Name" : "trunc_ln5", "interface" : "wire", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "sy1_V_1", "interface" : "wire", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "zext_ln1540", "interface" : "wire", "bitwidth" : 12, "direction" : "READONLY"} , 
 	{ "Name" : "quant_0", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "quant_1", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "quant_2", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "tensor_pixels", "interface" : "fifo", "bitwidth" : 24, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 45
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ tensor_pixels_din sc_out sc_lv 24 signal 14 } 
	{ tensor_pixels_num_data_valid sc_in sc_lv 7 signal 14 } 
	{ tensor_pixels_fifo_cap sc_in sc_lv 7 signal 14 } 
	{ tensor_pixels_full_n sc_in sc_logic 1 signal 14 } 
	{ tensor_pixels_write sc_out sc_logic 1 signal 14 } 
	{ px sc_in sc_lv 9 signal 0 } 
	{ add_i244_i sc_in sc_lv 10 signal 1 } 
	{ content_y sc_in sc_lv 1 signal 2 } 
	{ xc_index_address0 sc_out sc_lv 9 signal 3 } 
	{ xc_index_ce0 sc_out sc_logic 1 signal 3 } 
	{ xc_index_q0 sc_in sc_lv 11 signal 3 } 
	{ xc_weight_address0 sc_out sc_lv 9 signal 4 } 
	{ xc_weight_ce0 sc_out sc_logic 1 signal 4 } 
	{ xc_weight_q0 sc_in sc_lv 12 signal 4 } 
	{ width_cast_i sc_in sc_lv 11 signal 5 } 
	{ rows_V_address0 sc_out sc_lv 11 signal 6 } 
	{ rows_V_ce0 sc_out sc_logic 1 signal 6 } 
	{ rows_V_q0 sc_in sc_lv 24 signal 6 } 
	{ rows_V_address1 sc_out sc_lv 11 signal 6 } 
	{ rows_V_ce1 sc_out sc_logic 1 signal 6 } 
	{ rows_V_q1 sc_in sc_lv 24 signal 6 } 
	{ rows_V_1_address0 sc_out sc_lv 11 signal 7 } 
	{ rows_V_1_ce0 sc_out sc_logic 1 signal 7 } 
	{ rows_V_1_q0 sc_in sc_lv 24 signal 7 } 
	{ rows_V_1_address1 sc_out sc_lv 11 signal 7 } 
	{ rows_V_1_ce1 sc_out sc_logic 1 signal 7 } 
	{ rows_V_1_q1 sc_in sc_lv 24 signal 7 } 
	{ trunc_ln5 sc_in sc_lv 1 signal 8 } 
	{ sy1_V_1 sc_in sc_lv 1 signal 9 } 
	{ zext_ln1540 sc_in sc_lv 12 signal 10 } 
	{ quant_0_address0 sc_out sc_lv 8 signal 11 } 
	{ quant_0_ce0 sc_out sc_logic 1 signal 11 } 
	{ quant_0_q0 sc_in sc_lv 8 signal 11 } 
	{ quant_1_address0 sc_out sc_lv 8 signal 12 } 
	{ quant_1_ce0 sc_out sc_logic 1 signal 12 } 
	{ quant_1_q0 sc_in sc_lv 8 signal 12 } 
	{ quant_2_address0 sc_out sc_lv 8 signal 13 } 
	{ quant_2_ce0 sc_out sc_logic 1 signal 13 } 
	{ quant_2_q0 sc_in sc_lv 8 signal 13 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "tensor_pixels_din", "direction": "out", "datatype": "sc_lv", "bitwidth":24, "type": "signal", "bundle":{"name": "tensor_pixels", "role": "din" }} , 
 	{ "name": "tensor_pixels_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "tensor_pixels", "role": "num_data_valid" }} , 
 	{ "name": "tensor_pixels_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "tensor_pixels", "role": "fifo_cap" }} , 
 	{ "name": "tensor_pixels_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "tensor_pixels", "role": "full_n" }} , 
 	{ "name": "tensor_pixels_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "tensor_pixels", "role": "write" }} , 
 	{ "name": "px", "direction": "in", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "px", "role": "default" }} , 
 	{ "name": "add_i244_i", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "add_i244_i", "role": "default" }} , 
 	{ "name": "content_y", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "content_y", "role": "default" }} , 
 	{ "name": "xc_index_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "xc_index", "role": "address0" }} , 
 	{ "name": "xc_index_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xc_index", "role": "ce0" }} , 
 	{ "name": "xc_index_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "xc_index", "role": "q0" }} , 
 	{ "name": "xc_weight_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "xc_weight", "role": "address0" }} , 
 	{ "name": "xc_weight_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xc_weight", "role": "ce0" }} , 
 	{ "name": "xc_weight_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":12, "type": "signal", "bundle":{"name": "xc_weight", "role": "q0" }} , 
 	{ "name": "width_cast_i", "direction": "in", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "width_cast_i", "role": "default" }} , 
 	{ "name": "rows_V_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "rows_V", "role": "address0" }} , 
 	{ "name": "rows_V_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "rows_V", "role": "ce0" }} , 
 	{ "name": "rows_V_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":24, "type": "signal", "bundle":{"name": "rows_V", "role": "q0" }} , 
 	{ "name": "rows_V_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "rows_V", "role": "address1" }} , 
 	{ "name": "rows_V_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "rows_V", "role": "ce1" }} , 
 	{ "name": "rows_V_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":24, "type": "signal", "bundle":{"name": "rows_V", "role": "q1" }} , 
 	{ "name": "rows_V_1_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "rows_V_1", "role": "address0" }} , 
 	{ "name": "rows_V_1_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "rows_V_1", "role": "ce0" }} , 
 	{ "name": "rows_V_1_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":24, "type": "signal", "bundle":{"name": "rows_V_1", "role": "q0" }} , 
 	{ "name": "rows_V_1_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "rows_V_1", "role": "address1" }} , 
 	{ "name": "rows_V_1_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "rows_V_1", "role": "ce1" }} , 
 	{ "name": "rows_V_1_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":24, "type": "signal", "bundle":{"name": "rows_V_1", "role": "q1" }} , 
 	{ "name": "trunc_ln5", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "trunc_ln5", "role": "default" }} , 
 	{ "name": "sy1_V_1", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "sy1_V_1", "role": "default" }} , 
 	{ "name": "zext_ln1540", "direction": "in", "datatype": "sc_lv", "bitwidth":12, "type": "signal", "bundle":{"name": "zext_ln1540", "role": "default" }} , 
 	{ "name": "quant_0_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "quant_0", "role": "address0" }} , 
 	{ "name": "quant_0_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "quant_0", "role": "ce0" }} , 
 	{ "name": "quant_0_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "quant_0", "role": "q0" }} , 
 	{ "name": "quant_1_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "quant_1", "role": "address0" }} , 
 	{ "name": "quant_1_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "quant_1", "role": "ce0" }} , 
 	{ "name": "quant_1_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "quant_1", "role": "q0" }} , 
 	{ "name": "quant_2_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "quant_2", "role": "address0" }} , 
 	{ "name": "quant_2_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "quant_2", "role": "ce0" }} , 
 	{ "name": "quant_2_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "quant_2", "role": "q0" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14"],
		"CDFG" : "p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_381_4",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "428", "EstimateLatencyMax" : "428",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "px", "Type" : "None", "Direction" : "I"},
			{"Name" : "add_i244_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "content_y", "Type" : "None", "Direction" : "I"},
			{"Name" : "xc_index", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "xc_weight", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "width_cast_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "rows_V", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "rows_V_1", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "trunc_ln5", "Type" : "None", "Direction" : "I"},
			{"Name" : "sy1_V_1", "Type" : "None", "Direction" : "I"},
			{"Name" : "zext_ln1540", "Type" : "None", "Direction" : "I"},
			{"Name" : "quant_0", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "quant_1", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "quant_2", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "tensor_pixels", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "tensor_pixels_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_381_4", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter11", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter11", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mux_21_24_1_1_U197", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mux_21_24_1_1_U198", "Parent" : "0"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mux_21_24_1_1_U199", "Parent" : "0"},
	{"ID" : "4", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mux_21_24_1_1_U200", "Parent" : "0"},
	{"ID" : "5", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_12ns_9s_19ns_20_4_1_U201", "Parent" : "0"},
	{"ID" : "6", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_12ns_9s_19ns_20_4_1_U202", "Parent" : "0"},
	{"ID" : "7", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_12ns_9s_19ns_20_4_1_U203", "Parent" : "0"},
	{"ID" : "8", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_12ns_9s_20ns_20_4_1_U204", "Parent" : "0"},
	{"ID" : "9", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_12ns_9s_20ns_20_4_1_U205", "Parent" : "0"},
	{"ID" : "10", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_12ns_9s_20ns_20_4_1_U206", "Parent" : "0"},
	{"ID" : "11", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_20s_12ns_22ns_30_4_1_U207", "Parent" : "0"},
	{"ID" : "12", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_20s_12ns_22ns_30_4_1_U208", "Parent" : "0"},
	{"ID" : "13", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_20s_12ns_22ns_30_4_1_U209", "Parent" : "0"},
	{"ID" : "14", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.flow_control_loop_pipe_sequential_init_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_381_4 {
		px {Type I LastRead 0 FirstWrite -1}
		add_i244_i {Type I LastRead 0 FirstWrite -1}
		content_y {Type I LastRead 0 FirstWrite -1}
		xc_index {Type I LastRead 0 FirstWrite -1}
		xc_weight {Type I LastRead 2 FirstWrite -1}
		width_cast_i {Type I LastRead 0 FirstWrite -1}
		rows_V {Type I LastRead 3 FirstWrite -1}
		rows_V_1 {Type I LastRead 3 FirstWrite -1}
		trunc_ln5 {Type I LastRead 0 FirstWrite -1}
		sy1_V_1 {Type I LastRead 0 FirstWrite -1}
		zext_ln1540 {Type I LastRead 0 FirstWrite -1}
		quant_0 {Type I LastRead 10 FirstWrite -1}
		quant_1 {Type I LastRead 10 FirstWrite -1}
		quant_2 {Type I LastRead 10 FirstWrite -1}
		tensor_pixels {Type O LastRead -1 FirstWrite 11}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "428", "Max" : "428"}
	, {"Name" : "Interval", "Min" : "428", "Max" : "428"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	px { ap_none {  { px in_data 0 9 } } }
	add_i244_i { ap_none {  { add_i244_i in_data 0 10 } } }
	content_y { ap_none {  { content_y in_data 0 1 } } }
	xc_index { ap_memory {  { xc_index_address0 mem_address 1 9 }  { xc_index_ce0 mem_ce 1 1 }  { xc_index_q0 mem_dout 0 11 } } }
	xc_weight { ap_memory {  { xc_weight_address0 mem_address 1 9 }  { xc_weight_ce0 mem_ce 1 1 }  { xc_weight_q0 in_data 0 12 } } }
	width_cast_i { ap_none {  { width_cast_i in_data 0 11 } } }
	rows_V { ap_memory {  { rows_V_address0 mem_address 1 11 }  { rows_V_ce0 mem_ce 1 1 }  { rows_V_q0 in_data 0 24 }  { rows_V_address1 MemPortADDR2 1 11 }  { rows_V_ce1 MemPortCE2 1 1 }  { rows_V_q1 in_data 0 24 } } }
	rows_V_1 { ap_memory {  { rows_V_1_address0 mem_address 1 11 }  { rows_V_1_ce0 mem_ce 1 1 }  { rows_V_1_q0 in_data 0 24 }  { rows_V_1_address1 MemPortADDR2 1 11 }  { rows_V_1_ce1 MemPortCE2 1 1 }  { rows_V_1_q1 in_data 0 24 } } }
	trunc_ln5 { ap_none {  { trunc_ln5 in_data 0 1 } } }
	sy1_V_1 { ap_none {  { sy1_V_1 in_data 0 1 } } }
	zext_ln1540 { ap_none {  { zext_ln1540 in_data 0 12 } } }
	quant_0 { ap_memory {  { quant_0_address0 mem_address 1 8 }  { quant_0_ce0 mem_ce 1 1 }  { quant_0_q0 in_data 0 8 } } }
	quant_1 { ap_memory {  { quant_1_address0 mem_address 1 8 }  { quant_1_ce0 mem_ce 1 1 }  { quant_1_q0 in_data 0 8 } } }
	quant_2 { ap_memory {  { quant_2_address0 mem_address 1 8 }  { quant_2_ce0 mem_ce 1 1 }  { quant_2_q0 in_data 0 8 } } }
	tensor_pixels { ap_fifo {  { tensor_pixels_din fifo_port_we 1 24 }  { tensor_pixels_num_data_valid fifo_status_num_data_valid 0 7 }  { tensor_pixels_fifo_cap fifo_update 0 7 }  { tensor_pixels_full_n fifo_status 0 1 }  { tensor_pixels_write fifo_data 1 1 } } }
}
