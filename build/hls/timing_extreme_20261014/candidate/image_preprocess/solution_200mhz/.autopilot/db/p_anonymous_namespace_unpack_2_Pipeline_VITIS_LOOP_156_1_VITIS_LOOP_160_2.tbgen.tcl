set moduleName p_anonymous_namespace_unpack_2_Pipeline_VITIS_LOOP_156_1_VITIS_LOOP_160_2
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
set C_modelName {(anonymous namespace)unpack.2_Pipeline_VITIS_LOOP_156_1_VITIS_LOOP_160_2}
set C_modelType { void 0 }
set C_modelArgList {
	{ bound int 64 regular  }
	{ in_pixels4 int 24 regular {fifo 1 volatile }  }
	{ width_load int 32 regular  }
	{ in_words1 int 128 regular {fifo 0 volatile }  }
}
set C_modelArgMapList {[ 
	{ "Name" : "bound", "interface" : "wire", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "in_pixels4", "interface" : "fifo", "bitwidth" : 24, "direction" : "WRITEONLY"} , 
 	{ "Name" : "width_load", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "in_words1", "interface" : "fifo", "bitwidth" : 128, "direction" : "READONLY"} ]}
# RTL Port declarations: 
set portNum 18
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ in_words1_dout sc_in sc_lv 128 signal 3 } 
	{ in_words1_num_data_valid sc_in sc_lv 7 signal 3 } 
	{ in_words1_fifo_cap sc_in sc_lv 7 signal 3 } 
	{ in_words1_empty_n sc_in sc_logic 1 signal 3 } 
	{ in_words1_read sc_out sc_logic 1 signal 3 } 
	{ in_pixels4_din sc_out sc_lv 24 signal 1 } 
	{ in_pixels4_num_data_valid sc_in sc_lv 7 signal 1 } 
	{ in_pixels4_fifo_cap sc_in sc_lv 7 signal 1 } 
	{ in_pixels4_full_n sc_in sc_logic 1 signal 1 } 
	{ in_pixels4_write sc_out sc_logic 1 signal 1 } 
	{ bound sc_in sc_lv 64 signal 0 } 
	{ width_load sc_in sc_lv 32 signal 2 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "in_words1_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "in_words1", "role": "dout" }} , 
 	{ "name": "in_words1_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "in_words1", "role": "num_data_valid" }} , 
 	{ "name": "in_words1_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "in_words1", "role": "fifo_cap" }} , 
 	{ "name": "in_words1_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "in_words1", "role": "empty_n" }} , 
 	{ "name": "in_words1_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "in_words1", "role": "read" }} , 
 	{ "name": "in_pixels4_din", "direction": "out", "datatype": "sc_lv", "bitwidth":24, "type": "signal", "bundle":{"name": "in_pixels4", "role": "din" }} , 
 	{ "name": "in_pixels4_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "in_pixels4", "role": "num_data_valid" }} , 
 	{ "name": "in_pixels4_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "in_pixels4", "role": "fifo_cap" }} , 
 	{ "name": "in_pixels4_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "in_pixels4", "role": "full_n" }} , 
 	{ "name": "in_pixels4_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "in_pixels4", "role": "write" }} , 
 	{ "name": "bound", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "bound", "role": "default" }} , 
 	{ "name": "width_load", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "width_load", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1"],
		"CDFG" : "p_anonymous_namespace_unpack_2_Pipeline_VITIS_LOOP_156_1_VITIS_LOOP_160_2",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "173060", "EstimateLatencyMax" : "2073604",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "bound", "Type" : "None", "Direction" : "I"},
			{"Name" : "in_pixels4", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "in_pixels4_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "width_load", "Type" : "None", "Direction" : "I"},
			{"Name" : "in_words1", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "in_words1_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_156_1_VITIS_LOOP_160_2", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter1", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.flow_control_loop_pipe_sequential_init_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	p_anonymous_namespace_unpack_2_Pipeline_VITIS_LOOP_156_1_VITIS_LOOP_160_2 {
		bound {Type I LastRead 0 FirstWrite -1}
		in_pixels4 {Type O LastRead -1 FirstWrite 4}
		width_load {Type I LastRead 0 FirstWrite -1}
		in_words1 {Type I LastRead 3 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "173060", "Max" : "2073604"}
	, {"Name" : "Interval", "Min" : "173060", "Max" : "2073604"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	bound { ap_none {  { bound in_data 0 64 } } }
	in_pixels4 { ap_fifo {  { in_pixels4_din fifo_port_we 1 24 }  { in_pixels4_num_data_valid fifo_status_num_data_valid 0 7 }  { in_pixels4_fifo_cap fifo_update 0 7 }  { in_pixels4_full_n fifo_status 0 1 }  { in_pixels4_write fifo_data 1 1 } } }
	width_load { ap_none {  { width_load in_data 0 32 } } }
	in_words1 { ap_fifo {  { in_words1_dout fifo_port_we 0 128 }  { in_words1_num_data_valid fifo_status_num_data_valid 0 7 }  { in_words1_fifo_cap fifo_update 0 7 }  { in_words1_empty_n fifo_status 0 1 }  { in_words1_read fifo_data 1 1 } } }
}
