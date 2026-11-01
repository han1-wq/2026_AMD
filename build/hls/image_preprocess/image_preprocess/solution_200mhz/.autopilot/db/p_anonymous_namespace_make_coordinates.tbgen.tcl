set moduleName p_anonymous_namespace_make_coordinates
set isTopModule 0
set isCombinational 0
set isDatapathOnly 0
set isPipelined 0
set pipeline_type none
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set hasInterrupt 0
set C_modelName {(anonymous namespace)make_coordinates}
set C_modelType { void 0 }
set C_modelArgList {
	{ coordinates_index int 11 regular {array 416 { 0 } 0 1 }  }
	{ coordinates_weight int 12 regular {array 416 { 0 } 0 1 }  }
	{ src int 32 regular  }
	{ dst int 9 regular  }
}
set C_modelArgMapList {[ 
	{ "Name" : "coordinates_index", "interface" : "memory", "bitwidth" : 11, "direction" : "WRITEONLY"} , 
 	{ "Name" : "coordinates_weight", "interface" : "memory", "bitwidth" : 12, "direction" : "WRITEONLY"} , 
 	{ "Name" : "src", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "dst", "interface" : "wire", "bitwidth" : 9, "direction" : "READONLY"} ]}
# RTL Port declarations: 
set portNum 16
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ coordinates_index_address0 sc_out sc_lv 9 signal 0 } 
	{ coordinates_index_ce0 sc_out sc_logic 1 signal 0 } 
	{ coordinates_index_we0 sc_out sc_logic 1 signal 0 } 
	{ coordinates_index_d0 sc_out sc_lv 11 signal 0 } 
	{ coordinates_weight_address0 sc_out sc_lv 9 signal 1 } 
	{ coordinates_weight_ce0 sc_out sc_logic 1 signal 1 } 
	{ coordinates_weight_we0 sc_out sc_logic 1 signal 1 } 
	{ coordinates_weight_d0 sc_out sc_lv 12 signal 1 } 
	{ src sc_in sc_lv 32 signal 2 } 
	{ dst sc_in sc_lv 9 signal 3 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "coordinates_index_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "coordinates_index", "role": "address0" }} , 
 	{ "name": "coordinates_index_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "coordinates_index", "role": "ce0" }} , 
 	{ "name": "coordinates_index_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "coordinates_index", "role": "we0" }} , 
 	{ "name": "coordinates_index_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "coordinates_index", "role": "d0" }} , 
 	{ "name": "coordinates_weight_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "coordinates_weight", "role": "address0" }} , 
 	{ "name": "coordinates_weight_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "coordinates_weight", "role": "ce0" }} , 
 	{ "name": "coordinates_weight_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "coordinates_weight", "role": "we0" }} , 
 	{ "name": "coordinates_weight_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":12, "type": "signal", "bundle":{"name": "coordinates_weight", "role": "d0" }} , 
 	{ "name": "src", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "src", "role": "default" }} , 
 	{ "name": "dst", "direction": "in", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "dst", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "3", "4", "5"],
		"CDFG" : "p_anonymous_namespace_make_coordinates",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "31", "EstimateLatencyMax" : "26625",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "coordinates_index", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "coordinates_weight", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "src", "Type" : "None", "Direction" : "I"},
			{"Name" : "dst", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_160_1", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "65", "FirstState" : "ap_ST_fsm_state2", "LastState" : ["ap_ST_fsm_state65"], "QuitState" : ["ap_ST_fsm_state2"], "PreState" : ["ap_ST_fsm_state1"], "PostState" : ["ap_ST_fsm_state1"], "OneDepthLoop" : "0", "OneStateBlock": ""}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_10ns_32s_32_1_1_U14", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.udiv_32ns_10ns_32_36_seq_1_U15", "Parent" : "0"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.urem_32ns_10ns_10_36_seq_1_U16", "Parent" : "0"},
	{"ID" : "4", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.udiv_21ns_10ns_21_25_seq_1_U17", "Parent" : "0"},
	{"ID" : "5", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_mul_21ns_9ns_30_4_1_U18", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	p_anonymous_namespace_make_coordinates {
		coordinates_index {Type O LastRead -1 FirstWrite 38}
		coordinates_weight {Type O LastRead -1 FirstWrite 64}
		src {Type I LastRead 0 FirstWrite -1}
		dst {Type I LastRead 0 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "31", "Max" : "26625"}
	, {"Name" : "Interval", "Min" : "31", "Max" : "26625"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	coordinates_index { ap_memory {  { coordinates_index_address0 mem_address 1 9 }  { coordinates_index_ce0 mem_ce 1 1 }  { coordinates_index_we0 mem_we 1 1 }  { coordinates_index_d0 mem_din 1 11 } } }
	coordinates_weight { ap_memory {  { coordinates_weight_address0 mem_address 1 9 }  { coordinates_weight_ce0 mem_ce 1 1 }  { coordinates_weight_we0 mem_we 1 1 }  { coordinates_weight_d0 mem_din 1 12 } } }
	src { ap_none {  { src in_data 0 32 } } }
	dst { ap_none {  { dst in_data 0 9 } } }
}
set moduleName p_anonymous_namespace_make_coordinates
set isTopModule 0
set isCombinational 0
set isDatapathOnly 0
set isPipelined 0
set pipeline_type none
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set hasInterrupt 0
set C_modelName {(anonymous namespace)make_coordinates}
set C_modelType { void 0 }
set C_modelArgList {
	{ coordinates_index int 11 regular {array 416 { 0 } 0 1 }  }
	{ coordinates_weight int 12 regular {array 416 { 0 } 0 1 }  }
	{ src int 32 regular  }
	{ dst int 9 regular  }
}
set C_modelArgMapList {[ 
	{ "Name" : "coordinates_index", "interface" : "memory", "bitwidth" : 11, "direction" : "WRITEONLY"} , 
 	{ "Name" : "coordinates_weight", "interface" : "memory", "bitwidth" : 12, "direction" : "WRITEONLY"} , 
 	{ "Name" : "src", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "dst", "interface" : "wire", "bitwidth" : 9, "direction" : "READONLY"} ]}
# RTL Port declarations: 
set portNum 16
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ coordinates_index_address0 sc_out sc_lv 9 signal 0 } 
	{ coordinates_index_ce0 sc_out sc_logic 1 signal 0 } 
	{ coordinates_index_we0 sc_out sc_logic 1 signal 0 } 
	{ coordinates_index_d0 sc_out sc_lv 11 signal 0 } 
	{ coordinates_weight_address0 sc_out sc_lv 9 signal 1 } 
	{ coordinates_weight_ce0 sc_out sc_logic 1 signal 1 } 
	{ coordinates_weight_we0 sc_out sc_logic 1 signal 1 } 
	{ coordinates_weight_d0 sc_out sc_lv 12 signal 1 } 
	{ src sc_in sc_lv 32 signal 2 } 
	{ dst sc_in sc_lv 9 signal 3 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "coordinates_index_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "coordinates_index", "role": "address0" }} , 
 	{ "name": "coordinates_index_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "coordinates_index", "role": "ce0" }} , 
 	{ "name": "coordinates_index_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "coordinates_index", "role": "we0" }} , 
 	{ "name": "coordinates_index_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "coordinates_index", "role": "d0" }} , 
 	{ "name": "coordinates_weight_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "coordinates_weight", "role": "address0" }} , 
 	{ "name": "coordinates_weight_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "coordinates_weight", "role": "ce0" }} , 
 	{ "name": "coordinates_weight_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "coordinates_weight", "role": "we0" }} , 
 	{ "name": "coordinates_weight_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":12, "type": "signal", "bundle":{"name": "coordinates_weight", "role": "d0" }} , 
 	{ "name": "src", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "src", "role": "default" }} , 
 	{ "name": "dst", "direction": "in", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "dst", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "3", "4", "5"],
		"CDFG" : "p_anonymous_namespace_make_coordinates",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "31", "EstimateLatencyMax" : "26625",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "coordinates_index", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "coordinates_weight", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "src", "Type" : "None", "Direction" : "I"},
			{"Name" : "dst", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_175_1", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "65", "FirstState" : "ap_ST_fsm_state2", "LastState" : ["ap_ST_fsm_state65"], "QuitState" : ["ap_ST_fsm_state2"], "PreState" : ["ap_ST_fsm_state1"], "PostState" : ["ap_ST_fsm_state1"], "OneDepthLoop" : "0", "OneStateBlock": ""}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_10ns_32s_32_1_1_U14", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.udiv_32ns_10ns_32_36_seq_1_U15", "Parent" : "0"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.urem_32ns_10ns_10_36_seq_1_U16", "Parent" : "0"},
	{"ID" : "4", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.udiv_21ns_10ns_21_25_seq_1_U17", "Parent" : "0"},
	{"ID" : "5", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_mul_21ns_9ns_30_4_1_U18", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	p_anonymous_namespace_make_coordinates {
		coordinates_index {Type O LastRead -1 FirstWrite 38}
		coordinates_weight {Type O LastRead -1 FirstWrite 64}
		src {Type I LastRead 0 FirstWrite -1}
		dst {Type I LastRead 0 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "31", "Max" : "26625"}
	, {"Name" : "Interval", "Min" : "31", "Max" : "26625"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	coordinates_index { ap_memory {  { coordinates_index_address0 mem_address 1 9 }  { coordinates_index_ce0 mem_ce 1 1 }  { coordinates_index_we0 mem_we 1 1 }  { coordinates_index_d0 mem_din 1 11 } } }
	coordinates_weight { ap_memory {  { coordinates_weight_address0 mem_address 1 9 }  { coordinates_weight_ce0 mem_ce 1 1 }  { coordinates_weight_we0 mem_we 1 1 }  { coordinates_weight_d0 mem_din 1 12 } } }
	src { ap_none {  { src in_data 0 32 } } }
	dst { ap_none {  { dst in_data 0 9 } } }
}
set moduleName p_anonymous_namespace_make_coordinates
set isTopModule 0
set isCombinational 0
set isDatapathOnly 0
set isPipelined 0
set pipeline_type none
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set hasInterrupt 0
set C_modelName {(anonymous namespace)make_coordinates}
set C_modelType { void 0 }
set C_modelArgList {
	{ coordinates_index int 11 regular {array 416 { 0 } 0 1 }  }
	{ coordinates_weight int 12 regular {array 416 { 0 } 0 1 }  }
	{ src int 32 regular  }
	{ dst int 9 regular  }
}
set C_modelArgMapList {[ 
	{ "Name" : "coordinates_index", "interface" : "memory", "bitwidth" : 11, "direction" : "WRITEONLY"} , 
 	{ "Name" : "coordinates_weight", "interface" : "memory", "bitwidth" : 12, "direction" : "WRITEONLY"} , 
 	{ "Name" : "src", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "dst", "interface" : "wire", "bitwidth" : 9, "direction" : "READONLY"} ]}
# RTL Port declarations: 
set portNum 16
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ coordinates_index_address0 sc_out sc_lv 9 signal 0 } 
	{ coordinates_index_ce0 sc_out sc_logic 1 signal 0 } 
	{ coordinates_index_we0 sc_out sc_logic 1 signal 0 } 
	{ coordinates_index_d0 sc_out sc_lv 11 signal 0 } 
	{ coordinates_weight_address0 sc_out sc_lv 9 signal 1 } 
	{ coordinates_weight_ce0 sc_out sc_logic 1 signal 1 } 
	{ coordinates_weight_we0 sc_out sc_logic 1 signal 1 } 
	{ coordinates_weight_d0 sc_out sc_lv 12 signal 1 } 
	{ src sc_in sc_lv 32 signal 2 } 
	{ dst sc_in sc_lv 9 signal 3 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "coordinates_index_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "coordinates_index", "role": "address0" }} , 
 	{ "name": "coordinates_index_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "coordinates_index", "role": "ce0" }} , 
 	{ "name": "coordinates_index_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "coordinates_index", "role": "we0" }} , 
 	{ "name": "coordinates_index_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "coordinates_index", "role": "d0" }} , 
 	{ "name": "coordinates_weight_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "coordinates_weight", "role": "address0" }} , 
 	{ "name": "coordinates_weight_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "coordinates_weight", "role": "ce0" }} , 
 	{ "name": "coordinates_weight_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "coordinates_weight", "role": "we0" }} , 
 	{ "name": "coordinates_weight_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":12, "type": "signal", "bundle":{"name": "coordinates_weight", "role": "d0" }} , 
 	{ "name": "src", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "src", "role": "default" }} , 
 	{ "name": "dst", "direction": "in", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "dst", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "3", "4", "5"],
		"CDFG" : "p_anonymous_namespace_make_coordinates",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "31", "EstimateLatencyMax" : "26625",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "coordinates_index", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "coordinates_weight", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "src", "Type" : "None", "Direction" : "I"},
			{"Name" : "dst", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_200_1", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "65", "FirstState" : "ap_ST_fsm_state2", "LastState" : ["ap_ST_fsm_state65"], "QuitState" : ["ap_ST_fsm_state2"], "PreState" : ["ap_ST_fsm_state1"], "PostState" : ["ap_ST_fsm_state1"], "OneDepthLoop" : "0", "OneStateBlock": ""}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_10ns_32s_32_1_1_U14", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.udiv_32ns_10ns_32_36_seq_1_U15", "Parent" : "0"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.urem_32ns_10ns_10_36_seq_1_U16", "Parent" : "0"},
	{"ID" : "4", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.udiv_21ns_10ns_21_25_seq_1_U17", "Parent" : "0"},
	{"ID" : "5", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_mul_21ns_9ns_30_4_1_U18", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	p_anonymous_namespace_make_coordinates {
		coordinates_index {Type O LastRead -1 FirstWrite 38}
		coordinates_weight {Type O LastRead -1 FirstWrite 64}
		src {Type I LastRead 0 FirstWrite -1}
		dst {Type I LastRead 0 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "31", "Max" : "26625"}
	, {"Name" : "Interval", "Min" : "31", "Max" : "26625"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	coordinates_index { ap_memory {  { coordinates_index_address0 mem_address 1 9 }  { coordinates_index_ce0 mem_ce 1 1 }  { coordinates_index_we0 mem_we 1 1 }  { coordinates_index_d0 mem_din 1 11 } } }
	coordinates_weight { ap_memory {  { coordinates_weight_address0 mem_address 1 9 }  { coordinates_weight_ce0 mem_ce 1 1 }  { coordinates_weight_we0 mem_we 1 1 }  { coordinates_weight_d0 mem_din 1 12 } } }
	src { ap_none {  { src in_data 0 32 } } }
	dst { ap_none {  { dst in_data 0 9 } } }
}
set moduleName p_anonymous_namespace_make_coordinates
set isTopModule 0
set isCombinational 0
set isDatapathOnly 0
set isPipelined 0
set pipeline_type none
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set hasInterrupt 0
set C_modelName {(anonymous namespace)make_coordinates}
set C_modelType { void 0 }
set C_modelArgList {
	{ coordinates_index int 11 regular {array 416 { 0 } 0 1 }  }
	{ coordinates_weight int 12 regular {array 416 { 0 } 0 1 }  }
	{ src int 32 regular  }
	{ dst int 9 regular  }
}
set C_modelArgMapList {[ 
	{ "Name" : "coordinates_index", "interface" : "memory", "bitwidth" : 11, "direction" : "WRITEONLY"} , 
 	{ "Name" : "coordinates_weight", "interface" : "memory", "bitwidth" : 12, "direction" : "WRITEONLY"} , 
 	{ "Name" : "src", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "dst", "interface" : "wire", "bitwidth" : 9, "direction" : "READONLY"} ]}
# RTL Port declarations: 
set portNum 16
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ coordinates_index_address0 sc_out sc_lv 9 signal 0 } 
	{ coordinates_index_ce0 sc_out sc_logic 1 signal 0 } 
	{ coordinates_index_we0 sc_out sc_logic 1 signal 0 } 
	{ coordinates_index_d0 sc_out sc_lv 11 signal 0 } 
	{ coordinates_weight_address0 sc_out sc_lv 9 signal 1 } 
	{ coordinates_weight_ce0 sc_out sc_logic 1 signal 1 } 
	{ coordinates_weight_we0 sc_out sc_logic 1 signal 1 } 
	{ coordinates_weight_d0 sc_out sc_lv 12 signal 1 } 
	{ src sc_in sc_lv 32 signal 2 } 
	{ dst sc_in sc_lv 9 signal 3 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "coordinates_index_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "coordinates_index", "role": "address0" }} , 
 	{ "name": "coordinates_index_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "coordinates_index", "role": "ce0" }} , 
 	{ "name": "coordinates_index_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "coordinates_index", "role": "we0" }} , 
 	{ "name": "coordinates_index_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "coordinates_index", "role": "d0" }} , 
 	{ "name": "coordinates_weight_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "coordinates_weight", "role": "address0" }} , 
 	{ "name": "coordinates_weight_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "coordinates_weight", "role": "ce0" }} , 
 	{ "name": "coordinates_weight_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "coordinates_weight", "role": "we0" }} , 
 	{ "name": "coordinates_weight_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":12, "type": "signal", "bundle":{"name": "coordinates_weight", "role": "d0" }} , 
 	{ "name": "src", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "src", "role": "default" }} , 
 	{ "name": "dst", "direction": "in", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "dst", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "3", "4", "5"],
		"CDFG" : "p_anonymous_namespace_make_coordinates",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "31", "EstimateLatencyMax" : "26625",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "coordinates_index", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "coordinates_weight", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "src", "Type" : "None", "Direction" : "I"},
			{"Name" : "dst", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_215_1", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "65", "FirstState" : "ap_ST_fsm_state2", "LastState" : ["ap_ST_fsm_state65"], "QuitState" : ["ap_ST_fsm_state2"], "PreState" : ["ap_ST_fsm_state1"], "PostState" : ["ap_ST_fsm_state1"], "OneDepthLoop" : "0", "OneStateBlock": ""}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_10ns_32s_32_1_1_U14", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.udiv_32ns_10ns_32_36_seq_1_U15", "Parent" : "0"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.urem_32ns_10ns_10_36_seq_1_U16", "Parent" : "0"},
	{"ID" : "4", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.udiv_21ns_10ns_21_25_seq_1_U17", "Parent" : "0"},
	{"ID" : "5", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_mul_21ns_9ns_30_4_1_U18", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	p_anonymous_namespace_make_coordinates {
		coordinates_index {Type O LastRead -1 FirstWrite 38}
		coordinates_weight {Type O LastRead -1 FirstWrite 64}
		src {Type I LastRead 0 FirstWrite -1}
		dst {Type I LastRead 0 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "31", "Max" : "26625"}
	, {"Name" : "Interval", "Min" : "31", "Max" : "26625"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	coordinates_index { ap_memory {  { coordinates_index_address0 mem_address 1 9 }  { coordinates_index_ce0 mem_ce 1 1 }  { coordinates_index_we0 mem_we 1 1 }  { coordinates_index_d0 mem_din 1 11 } } }
	coordinates_weight { ap_memory {  { coordinates_weight_address0 mem_address 1 9 }  { coordinates_weight_ce0 mem_ce 1 1 }  { coordinates_weight_we0 mem_we 1 1 }  { coordinates_weight_d0 mem_din 1 12 } } }
	src { ap_none {  { src in_data 0 32 } } }
	dst { ap_none {  { dst in_data 0 9 } } }
}
