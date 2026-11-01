set moduleName p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_332_6_VITIS_LOOP_334_7
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
set C_modelName {(anonymous namespace)resize_and_split_Pipeline_VITIS_LOOP_332_6_VITIS_LOOP_334_7}
set C_modelType { void 0 }
set C_modelArgList {
	{ mul_ln288 int 64 regular  }
	{ pairs int 48 regular {fifo 0 volatile }  }
	{ cmp130 int 1 regular  }
	{ preview_pixels6 int 24 regular {fifo 1 volatile }  }
}
set C_modelArgMapList {[ 
	{ "Name" : "mul_ln288", "interface" : "wire", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "pairs", "interface" : "fifo", "bitwidth" : 48, "direction" : "READONLY"} , 
 	{ "Name" : "cmp130", "interface" : "wire", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "preview_pixels6", "interface" : "fifo", "bitwidth" : 24, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 18
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ pairs_dout sc_in sc_lv 48 signal 1 } 
	{ pairs_num_data_valid sc_in sc_lv 7 signal 1 } 
	{ pairs_fifo_cap sc_in sc_lv 7 signal 1 } 
	{ pairs_empty_n sc_in sc_logic 1 signal 1 } 
	{ pairs_read sc_out sc_logic 1 signal 1 } 
	{ preview_pixels6_din sc_out sc_lv 24 signal 3 } 
	{ preview_pixels6_num_data_valid sc_in sc_lv 7 signal 3 } 
	{ preview_pixels6_fifo_cap sc_in sc_lv 7 signal 3 } 
	{ preview_pixels6_full_n sc_in sc_logic 1 signal 3 } 
	{ preview_pixels6_write sc_out sc_logic 1 signal 3 } 
	{ mul_ln288 sc_in sc_lv 64 signal 0 } 
	{ cmp130 sc_in sc_lv 1 signal 2 } 
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
 	{ "name": "preview_pixels6_din", "direction": "out", "datatype": "sc_lv", "bitwidth":24, "type": "signal", "bundle":{"name": "preview_pixels6", "role": "din" }} , 
 	{ "name": "preview_pixels6_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "preview_pixels6", "role": "num_data_valid" }} , 
 	{ "name": "preview_pixels6_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "preview_pixels6", "role": "fifo_cap" }} , 
 	{ "name": "preview_pixels6_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "preview_pixels6", "role": "full_n" }} , 
 	{ "name": "preview_pixels6_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "preview_pixels6", "role": "write" }} , 
 	{ "name": "mul_ln288", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "mul_ln288", "role": "default" }} , 
 	{ "name": "cmp130", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "cmp130", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1"],
		"CDFG" : "p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_332_6_VITIS_LOOP_334_7",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "2", "EstimateLatencyMax" : "2073602",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "mul_ln288", "Type" : "None", "Direction" : "I"},
			{"Name" : "pairs", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "pairs_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "cmp130", "Type" : "None", "Direction" : "I"},
			{"Name" : "preview_pixels6", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "preview_pixels6_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_332_6_VITIS_LOOP_334_7", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter1", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter2", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.flow_control_loop_pipe_sequential_init_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_332_6_VITIS_LOOP_334_7 {
		mul_ln288 {Type I LastRead 0 FirstWrite -1}
		pairs {Type I LastRead 2 FirstWrite -1}
		cmp130 {Type I LastRead 0 FirstWrite -1}
		preview_pixels6 {Type O LastRead -1 FirstWrite 2}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "2", "Max" : "2073602"}
	, {"Name" : "Interval", "Min" : "2", "Max" : "2073602"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	mul_ln288 { ap_none {  { mul_ln288 in_data 0 64 } } }
	pairs { ap_fifo {  { pairs_dout fifo_port_we 0 48 }  { pairs_num_data_valid fifo_status_num_data_valid 0 7 }  { pairs_fifo_cap fifo_update 0 7 }  { pairs_empty_n fifo_status 0 1 }  { pairs_read fifo_data 1 1 } } }
	cmp130 { ap_none {  { cmp130 in_data 0 1 } } }
	preview_pixels6 { ap_fifo {  { preview_pixels6_din fifo_port_we 1 24 }  { preview_pixels6_num_data_valid fifo_status_num_data_valid 0 7 }  { preview_pixels6_fifo_cap fifo_update 0 7 }  { preview_pixels6_full_n fifo_status 0 1 }  { preview_pixels6_write fifo_data 1 1 } } }
}
