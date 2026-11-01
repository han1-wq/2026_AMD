set moduleName image_preprocess_Pipeline_VITIS_LOOP_567_4
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
set C_modelName {image_preprocess_Pipeline_VITIS_LOOP_567_4}
set C_modelType { void 0 }
set C_modelArgList {
	{ hist_V int 32 regular {array 256 { 3 0 } 0 1 }  }
	{ use_history int 1 regular  }
	{ eq_V int 8 regular {array 256 { 3 0 } 0 1 }  }
	{ previous_V int 8 regular {array 256 { 1 3 } 1 1 } {global 0}  }
}
set C_modelArgMapList {[ 
	{ "Name" : "hist_V", "interface" : "memory", "bitwidth" : 32, "direction" : "WRITEONLY"} , 
 	{ "Name" : "use_history", "interface" : "wire", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "eq_V", "interface" : "memory", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "previous_V", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY", "extern" : 0} ]}
# RTL Port declarations: 
set portNum 18
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ hist_V_address1 sc_out sc_lv 8 signal 0 } 
	{ hist_V_ce1 sc_out sc_logic 1 signal 0 } 
	{ hist_V_we1 sc_out sc_logic 1 signal 0 } 
	{ hist_V_d1 sc_out sc_lv 32 signal 0 } 
	{ use_history sc_in sc_lv 1 signal 1 } 
	{ eq_V_address1 sc_out sc_lv 8 signal 2 } 
	{ eq_V_ce1 sc_out sc_logic 1 signal 2 } 
	{ eq_V_we1 sc_out sc_logic 1 signal 2 } 
	{ eq_V_d1 sc_out sc_lv 8 signal 2 } 
	{ previous_V_address0 sc_out sc_lv 8 signal 3 } 
	{ previous_V_ce0 sc_out sc_logic 1 signal 3 } 
	{ previous_V_q0 sc_in sc_lv 8 signal 3 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "hist_V_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "hist_V", "role": "address1" }} , 
 	{ "name": "hist_V_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist_V", "role": "ce1" }} , 
 	{ "name": "hist_V_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist_V", "role": "we1" }} , 
 	{ "name": "hist_V_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "hist_V", "role": "d1" }} , 
 	{ "name": "use_history", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "use_history", "role": "default" }} , 
 	{ "name": "eq_V_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "eq_V", "role": "address1" }} , 
 	{ "name": "eq_V_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "eq_V", "role": "ce1" }} , 
 	{ "name": "eq_V_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "eq_V", "role": "we1" }} , 
 	{ "name": "eq_V_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "eq_V", "role": "d1" }} , 
 	{ "name": "previous_V_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "previous_V", "role": "address0" }} , 
 	{ "name": "previous_V_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "previous_V", "role": "ce0" }} , 
 	{ "name": "previous_V_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "previous_V", "role": "q0" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1"],
		"CDFG" : "image_preprocess_Pipeline_VITIS_LOOP_567_4",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "258", "EstimateLatencyMax" : "258",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "hist_V", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "use_history", "Type" : "None", "Direction" : "I"},
			{"Name" : "eq_V", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "previous_V", "Type" : "Memory", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_567_4", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter0", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.flow_control_loop_pipe_sequential_init_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	image_preprocess_Pipeline_VITIS_LOOP_567_4 {
		hist_V {Type O LastRead -1 FirstWrite 0}
		use_history {Type I LastRead 0 FirstWrite -1}
		eq_V {Type O LastRead -1 FirstWrite 1}
		previous_V {Type I LastRead 0 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "258", "Max" : "258"}
	, {"Name" : "Interval", "Min" : "258", "Max" : "258"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	hist_V { ap_memory {  { hist_V_address1 MemPortADDR2 1 8 }  { hist_V_ce1 MemPortCE2 1 1 }  { hist_V_we1 MemPortWE2 1 1 }  { hist_V_d1 MemPortDIN2 1 32 } } }
	use_history { ap_none {  { use_history in_data 0 1 } } }
	eq_V { ap_memory {  { eq_V_address1 MemPortADDR2 1 8 }  { eq_V_ce1 MemPortCE2 1 1 }  { eq_V_we1 MemPortWE2 1 1 }  { eq_V_d1 MemPortDIN2 1 8 } } }
	previous_V { ap_memory {  { previous_V_address0 mem_address 1 8 }  { previous_V_ce0 mem_ce 1 1 }  { previous_V_q0 in_data 0 8 } } }
}
