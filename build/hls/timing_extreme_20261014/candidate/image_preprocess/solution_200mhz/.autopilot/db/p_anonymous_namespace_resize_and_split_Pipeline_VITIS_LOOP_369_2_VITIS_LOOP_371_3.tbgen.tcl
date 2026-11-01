set moduleName p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_369_2_VITIS_LOOP_371_3
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
set C_modelName {(anonymous namespace)resize_and_split_Pipeline_VITIS_LOOP_369_2_VITIS_LOOP_371_3}
set C_modelType { void 0 }
set C_modelArgList {
	{ consumed_V int 11 regular  }
	{ mul_ln1085 int 22 regular  }
	{ cmp32_i int 1 regular  }
	{ p_read int 11 regular  }
	{ pairs int 48 regular {fifo 0 volatile }  }
	{ rows_V int 24 regular {array 1920 { 3 0 } 0 1 }  }
	{ rows_V_1 int 24 regular {array 1920 { 3 0 } 0 1 }  }
	{ tobool_i int 1 regular  }
	{ preview_pixels int 24 regular {fifo 1 volatile }  }
}
set C_modelArgMapList {[ 
	{ "Name" : "consumed_V", "interface" : "wire", "bitwidth" : 11, "direction" : "READONLY"} , 
 	{ "Name" : "mul_ln1085", "interface" : "wire", "bitwidth" : 22, "direction" : "READONLY"} , 
 	{ "Name" : "cmp32_i", "interface" : "wire", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "p_read", "interface" : "wire", "bitwidth" : 11, "direction" : "READONLY"} , 
 	{ "Name" : "pairs", "interface" : "fifo", "bitwidth" : 48, "direction" : "READONLY"} , 
 	{ "Name" : "rows_V", "interface" : "memory", "bitwidth" : 24, "direction" : "WRITEONLY"} , 
 	{ "Name" : "rows_V_1", "interface" : "memory", "bitwidth" : 24, "direction" : "WRITEONLY"} , 
 	{ "Name" : "tobool_i", "interface" : "wire", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "preview_pixels", "interface" : "fifo", "bitwidth" : 24, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 29
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ pairs_dout sc_in sc_lv 48 signal 4 } 
	{ pairs_num_data_valid sc_in sc_lv 7 signal 4 } 
	{ pairs_fifo_cap sc_in sc_lv 7 signal 4 } 
	{ pairs_empty_n sc_in sc_logic 1 signal 4 } 
	{ pairs_read sc_out sc_logic 1 signal 4 } 
	{ preview_pixels_din sc_out sc_lv 24 signal 8 } 
	{ preview_pixels_num_data_valid sc_in sc_lv 7 signal 8 } 
	{ preview_pixels_fifo_cap sc_in sc_lv 7 signal 8 } 
	{ preview_pixels_full_n sc_in sc_logic 1 signal 8 } 
	{ preview_pixels_write sc_out sc_logic 1 signal 8 } 
	{ consumed_V sc_in sc_lv 11 signal 0 } 
	{ mul_ln1085 sc_in sc_lv 22 signal 1 } 
	{ cmp32_i sc_in sc_lv 1 signal 2 } 
	{ p_read sc_in sc_lv 11 signal 3 } 
	{ rows_V_address1 sc_out sc_lv 11 signal 5 } 
	{ rows_V_ce1 sc_out sc_logic 1 signal 5 } 
	{ rows_V_we1 sc_out sc_logic 1 signal 5 } 
	{ rows_V_d1 sc_out sc_lv 24 signal 5 } 
	{ rows_V_1_address1 sc_out sc_lv 11 signal 6 } 
	{ rows_V_1_ce1 sc_out sc_logic 1 signal 6 } 
	{ rows_V_1_we1 sc_out sc_logic 1 signal 6 } 
	{ rows_V_1_d1 sc_out sc_lv 24 signal 6 } 
	{ tobool_i sc_in sc_lv 1 signal 7 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "pairs_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":48, "type": "signal", "bundle":{"name": "pairs", "role": "dout" }} , 
 	{ "name": "pairs_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "pairs", "role": "num_data_valid" }} , 
 	{ "name": "pairs_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "pairs", "role": "fifo_cap" }} , 
 	{ "name": "pairs_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "pairs", "role": "empty_n" }} , 
 	{ "name": "pairs_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "pairs", "role": "read" }} , 
 	{ "name": "preview_pixels_din", "direction": "out", "datatype": "sc_lv", "bitwidth":24, "type": "signal", "bundle":{"name": "preview_pixels", "role": "din" }} , 
 	{ "name": "preview_pixels_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "preview_pixels", "role": "num_data_valid" }} , 
 	{ "name": "preview_pixels_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "preview_pixels", "role": "fifo_cap" }} , 
 	{ "name": "preview_pixels_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "preview_pixels", "role": "full_n" }} , 
 	{ "name": "preview_pixels_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "preview_pixels", "role": "write" }} , 
 	{ "name": "consumed_V", "direction": "in", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "consumed_V", "role": "default" }} , 
 	{ "name": "mul_ln1085", "direction": "in", "datatype": "sc_lv", "bitwidth":22, "type": "signal", "bundle":{"name": "mul_ln1085", "role": "default" }} , 
 	{ "name": "cmp32_i", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "cmp32_i", "role": "default" }} , 
 	{ "name": "p_read", "direction": "in", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "p_read", "role": "default" }} , 
 	{ "name": "rows_V_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "rows_V", "role": "address1" }} , 
 	{ "name": "rows_V_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "rows_V", "role": "ce1" }} , 
 	{ "name": "rows_V_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "rows_V", "role": "we1" }} , 
 	{ "name": "rows_V_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":24, "type": "signal", "bundle":{"name": "rows_V", "role": "d1" }} , 
 	{ "name": "rows_V_1_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "rows_V_1", "role": "address1" }} , 
 	{ "name": "rows_V_1_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "rows_V_1", "role": "ce1" }} , 
 	{ "name": "rows_V_1_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "rows_V_1", "role": "we1" }} , 
 	{ "name": "rows_V_1_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":24, "type": "signal", "bundle":{"name": "rows_V_1", "role": "d1" }} , 
 	{ "name": "tobool_i", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "tobool_i", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1"],
		"CDFG" : "p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_369_2_VITIS_LOOP_371_3",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "2", "EstimateLatencyMax" : "9602",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "consumed_V", "Type" : "None", "Direction" : "I"},
			{"Name" : "mul_ln1085", "Type" : "None", "Direction" : "I"},
			{"Name" : "cmp32_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read", "Type" : "None", "Direction" : "I"},
			{"Name" : "pairs", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "pairs_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "rows_V", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "rows_V_1", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "tobool_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "preview_pixels", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "preview_pixels_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_369_2_VITIS_LOOP_371_3", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter0", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.flow_control_loop_pipe_sequential_init_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_369_2_VITIS_LOOP_371_3 {
		consumed_V {Type I LastRead 0 FirstWrite -1}
		mul_ln1085 {Type I LastRead 0 FirstWrite -1}
		cmp32_i {Type I LastRead 0 FirstWrite -1}
		p_read {Type I LastRead 0 FirstWrite -1}
		pairs {Type I LastRead 1 FirstWrite -1}
		rows_V {Type O LastRead -1 FirstWrite 1}
		rows_V_1 {Type O LastRead -1 FirstWrite 1}
		tobool_i {Type I LastRead 0 FirstWrite -1}
		preview_pixels {Type O LastRead -1 FirstWrite 1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "2", "Max" : "9602"}
	, {"Name" : "Interval", "Min" : "2", "Max" : "9602"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	consumed_V { ap_none {  { consumed_V in_data 0 11 } } }
	mul_ln1085 { ap_none {  { mul_ln1085 in_data 0 22 } } }
	cmp32_i { ap_none {  { cmp32_i in_data 0 1 } } }
	p_read { ap_none {  { p_read in_data 0 11 } } }
	pairs { ap_fifo {  { pairs_dout fifo_port_we 0 48 }  { pairs_num_data_valid fifo_status_num_data_valid 0 7 }  { pairs_fifo_cap fifo_update 0 7 }  { pairs_empty_n fifo_status 0 1 }  { pairs_read fifo_data 1 1 } } }
	rows_V { ap_memory {  { rows_V_address1 MemPortADDR2 1 11 }  { rows_V_ce1 MemPortCE2 1 1 }  { rows_V_we1 MemPortWE2 1 1 }  { rows_V_d1 MemPortDIN2 1 24 } } }
	rows_V_1 { ap_memory {  { rows_V_1_address1 MemPortADDR2 1 11 }  { rows_V_1_ce1 MemPortCE2 1 1 }  { rows_V_1_we1 MemPortWE2 1 1 }  { rows_V_1_d1 MemPortDIN2 1 24 } } }
	tobool_i { ap_none {  { tobool_i in_data 0 1 } } }
	preview_pixels { ap_fifo {  { preview_pixels_din fifo_port_we 1 24 }  { preview_pixels_num_data_valid fifo_status_num_data_valid 0 7 }  { preview_pixels_fifo_cap fifo_update 0 7 }  { preview_pixels_full_n fifo_status 0 1 }  { preview_pixels_write fifo_data 1 1 } } }
}
