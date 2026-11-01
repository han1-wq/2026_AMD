set moduleName p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_199_1
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
set C_modelName {(anonymous namespace)collect_or_drain_Pipeline_VITIS_LOOP_199_1}
set C_modelType { void 0 }
set C_modelArgList {
	{ mul_ln363_loc_load int 32 regular  }
	{ hist_pixels int 8 regular {fifo 0 volatile }  }
	{ hist int 32 regular {array 256 { 1 0 } 1 1 }  }
}
set C_modelArgMapList {[ 
	{ "Name" : "mul_ln363_loc_load", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "hist_pixels", "interface" : "fifo", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "hist", "interface" : "memory", "bitwidth" : 32, "direction" : "READWRITE"} ]}
# RTL Port declarations: 
set portNum 19
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ hist_pixels_dout sc_in sc_lv 8 signal 1 } 
	{ hist_pixels_num_data_valid sc_in sc_lv 7 signal 1 } 
	{ hist_pixels_fifo_cap sc_in sc_lv 7 signal 1 } 
	{ hist_pixels_empty_n sc_in sc_logic 1 signal 1 } 
	{ hist_pixels_read sc_out sc_logic 1 signal 1 } 
	{ mul_ln363_loc_load sc_in sc_lv 32 signal 0 } 
	{ hist_address0 sc_out sc_lv 8 signal 2 } 
	{ hist_ce0 sc_out sc_logic 1 signal 2 } 
	{ hist_q0 sc_in sc_lv 32 signal 2 } 
	{ hist_address1 sc_out sc_lv 8 signal 2 } 
	{ hist_ce1 sc_out sc_logic 1 signal 2 } 
	{ hist_we1 sc_out sc_logic 1 signal 2 } 
	{ hist_d1 sc_out sc_lv 32 signal 2 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "hist_pixels_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "hist_pixels", "role": "dout" }} , 
 	{ "name": "hist_pixels_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "hist_pixels", "role": "num_data_valid" }} , 
 	{ "name": "hist_pixels_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "hist_pixels", "role": "fifo_cap" }} , 
 	{ "name": "hist_pixels_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist_pixels", "role": "empty_n" }} , 
 	{ "name": "hist_pixels_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist_pixels", "role": "read" }} , 
 	{ "name": "mul_ln363_loc_load", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "mul_ln363_loc_load", "role": "default" }} , 
 	{ "name": "hist_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "hist", "role": "address0" }} , 
 	{ "name": "hist_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist", "role": "ce0" }} , 
 	{ "name": "hist_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "hist", "role": "q0" }} , 
 	{ "name": "hist_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "hist", "role": "address1" }} , 
 	{ "name": "hist_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist", "role": "ce1" }} , 
 	{ "name": "hist_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist", "role": "we1" }} , 
 	{ "name": "hist_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "hist", "role": "d1" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1"],
		"CDFG" : "p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_199_1",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "346114", "EstimateLatencyMax" : "4147202",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "mul_ln363_loc_load", "Type" : "None", "Direction" : "I"},
			{"Name" : "hist_pixels", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "hist_pixels_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "hist", "Type" : "Memory", "Direction" : "IO"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_199_1", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "2", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter0", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.flow_control_loop_pipe_sequential_init_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_199_1 {
		mul_ln363_loc_load {Type I LastRead 0 FirstWrite -1}
		hist_pixels {Type I LastRead 1 FirstWrite -1}
		hist {Type IO LastRead 1 FirstWrite 2}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "346114", "Max" : "4147202"}
	, {"Name" : "Interval", "Min" : "346114", "Max" : "4147202"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	mul_ln363_loc_load { ap_none {  { mul_ln363_loc_load in_data 0 32 } } }
	hist_pixels { ap_fifo {  { hist_pixels_dout fifo_port_we 0 8 }  { hist_pixels_num_data_valid fifo_status_num_data_valid 0 7 }  { hist_pixels_fifo_cap fifo_update 0 7 }  { hist_pixels_empty_n fifo_status 0 1 }  { hist_pixels_read fifo_data 1 1 } } }
	hist { ap_memory {  { hist_address0 mem_address 1 8 }  { hist_ce0 mem_ce 1 1 }  { hist_q0 in_data 0 32 }  { hist_address1 MemPortADDR2 1 8 }  { hist_ce1 MemPortCE2 1 1 }  { hist_we1 MemPortWE2 1 1 }  { hist_d1 MemPortDIN2 1 32 } } }
}
