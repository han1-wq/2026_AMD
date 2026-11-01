set moduleName p_anonymous_namespace_pack_3_Pipeline_VITIS_LOOP_323_2
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
set C_modelName {(anonymous namespace)pack.3_Pipeline_VITIS_LOOP_323_2}
set C_modelType { void 0 }
set C_modelArgList {
	{ width_load int 32 regular  }
	{ preview_pixels int 24 regular {fifo 0 volatile }  }
	{ preview_words int 128 regular {fifo 1 volatile }  }
	{ bits_6_out int 32 regular {pointer 1}  }
	{ reservoir_V_out int 128 regular {pointer 1}  }
}
set C_modelArgMapList {[ 
	{ "Name" : "width_load", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "preview_pixels", "interface" : "fifo", "bitwidth" : 24, "direction" : "READONLY"} , 
 	{ "Name" : "preview_words", "interface" : "fifo", "bitwidth" : 128, "direction" : "WRITEONLY"} , 
 	{ "Name" : "bits_6_out", "interface" : "wire", "bitwidth" : 32, "direction" : "WRITEONLY"} , 
 	{ "Name" : "reservoir_V_out", "interface" : "wire", "bitwidth" : 128, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 21
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ preview_pixels_dout sc_in sc_lv 24 signal 1 } 
	{ preview_pixels_num_data_valid sc_in sc_lv 7 signal 1 } 
	{ preview_pixels_fifo_cap sc_in sc_lv 7 signal 1 } 
	{ preview_pixels_empty_n sc_in sc_logic 1 signal 1 } 
	{ preview_pixels_read sc_out sc_logic 1 signal 1 } 
	{ preview_words_din sc_out sc_lv 128 signal 2 } 
	{ preview_words_num_data_valid sc_in sc_lv 7 signal 2 } 
	{ preview_words_fifo_cap sc_in sc_lv 7 signal 2 } 
	{ preview_words_full_n sc_in sc_logic 1 signal 2 } 
	{ preview_words_write sc_out sc_logic 1 signal 2 } 
	{ width_load sc_in sc_lv 32 signal 0 } 
	{ bits_6_out sc_out sc_lv 32 signal 3 } 
	{ bits_6_out_ap_vld sc_out sc_logic 1 outvld 3 } 
	{ reservoir_V_out sc_out sc_lv 128 signal 4 } 
	{ reservoir_V_out_ap_vld sc_out sc_logic 1 outvld 4 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "preview_pixels_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":24, "type": "signal", "bundle":{"name": "preview_pixels", "role": "dout" }} , 
 	{ "name": "preview_pixels_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "preview_pixels", "role": "num_data_valid" }} , 
 	{ "name": "preview_pixels_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "preview_pixels", "role": "fifo_cap" }} , 
 	{ "name": "preview_pixels_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "preview_pixels", "role": "empty_n" }} , 
 	{ "name": "preview_pixels_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "preview_pixels", "role": "read" }} , 
 	{ "name": "preview_words_din", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "preview_words", "role": "din" }} , 
 	{ "name": "preview_words_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "preview_words", "role": "num_data_valid" }} , 
 	{ "name": "preview_words_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "preview_words", "role": "fifo_cap" }} , 
 	{ "name": "preview_words_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "preview_words", "role": "full_n" }} , 
 	{ "name": "preview_words_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "preview_words", "role": "write" }} , 
 	{ "name": "width_load", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "width_load", "role": "default" }} , 
 	{ "name": "bits_6_out", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "bits_6_out", "role": "default" }} , 
 	{ "name": "bits_6_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "bits_6_out", "role": "ap_vld" }} , 
 	{ "name": "reservoir_V_out", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "reservoir_V_out", "role": "default" }} , 
 	{ "name": "reservoir_V_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "reservoir_V_out", "role": "ap_vld" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1"],
		"CDFG" : "p_anonymous_namespace_pack_3_Pipeline_VITIS_LOOP_323_2",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "419", "EstimateLatencyMax" : "1923",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "width_load", "Type" : "None", "Direction" : "I"},
			{"Name" : "preview_pixels", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "preview_pixels_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "preview_words", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "preview_words_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "bits_6_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "reservoir_V_out", "Type" : "Vld", "Direction" : "O"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_323_2", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter2", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.flow_control_loop_pipe_sequential_init_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	p_anonymous_namespace_pack_3_Pipeline_VITIS_LOOP_323_2 {
		width_load {Type I LastRead 0 FirstWrite -1}
		preview_pixels {Type I LastRead 1 FirstWrite -1}
		preview_words {Type O LastRead -1 FirstWrite 2}
		bits_6_out {Type O LastRead -1 FirstWrite 1}
		reservoir_V_out {Type O LastRead -1 FirstWrite 1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "419", "Max" : "1923"}
	, {"Name" : "Interval", "Min" : "419", "Max" : "1923"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	width_load { ap_none {  { width_load in_data 0 32 } } }
	preview_pixels { ap_fifo {  { preview_pixels_dout fifo_port_we 0 24 }  { preview_pixels_num_data_valid fifo_status_num_data_valid 0 7 }  { preview_pixels_fifo_cap fifo_update 0 7 }  { preview_pixels_empty_n fifo_status 0 1 }  { preview_pixels_read fifo_data 1 1 } } }
	preview_words { ap_fifo {  { preview_words_din fifo_port_we 1 128 }  { preview_words_num_data_valid fifo_status_num_data_valid 0 7 }  { preview_words_fifo_cap fifo_update 0 7 }  { preview_words_full_n fifo_status 0 1 }  { preview_words_write fifo_data 1 1 } } }
	bits_6_out { ap_vld {  { bits_6_out out_data 1 32 }  { bits_6_out_ap_vld out_vld 1 1 } } }
	reservoir_V_out { ap_vld {  { reservoir_V_out out_data 1 128 }  { reservoir_V_out_ap_vld out_vld 1 1 } } }
}
