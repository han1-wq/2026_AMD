set moduleName image_preprocess_Pipeline_VITIS_LOOP_468_2
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
set C_modelName {image_preprocess_Pipeline_VITIS_LOOP_468_2}
set C_modelType { void 0 }
set C_modelArgList {
	{ quant_V int 8 regular {array 256 { 3 0 } 0 1 }  }
	{ quant_V_1 int 8 regular {array 256 { 3 0 } 0 1 }  }
	{ quant_V_2 int 8 regular {array 256 { 3 0 } 0 1 }  }
	{ color_V_2 int 8 regular {array 256 { 3 0 } 0 1 }  }
	{ color_V_1 int 8 regular {array 256 { 3 0 } 0 1 }  }
	{ color_V int 8 regular {array 256 { 3 0 } 0 1 }  }
	{ and_r int 8 regular  }
	{ v_V int 128 regular  }
	{ cmp128 int 1 regular  }
}
set C_modelArgMapList {[ 
	{ "Name" : "quant_V", "interface" : "memory", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "quant_V_1", "interface" : "memory", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "quant_V_2", "interface" : "memory", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "color_V_2", "interface" : "memory", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "color_V_1", "interface" : "memory", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "color_V", "interface" : "memory", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "and_r", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "v_V", "interface" : "wire", "bitwidth" : 128, "direction" : "READONLY"} , 
 	{ "Name" : "cmp128", "interface" : "wire", "bitwidth" : 1, "direction" : "READONLY"} ]}
# RTL Port declarations: 
set portNum 33
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ quant_V_address1 sc_out sc_lv 8 signal 0 } 
	{ quant_V_ce1 sc_out sc_logic 1 signal 0 } 
	{ quant_V_we1 sc_out sc_logic 1 signal 0 } 
	{ quant_V_d1 sc_out sc_lv 8 signal 0 } 
	{ quant_V_1_address1 sc_out sc_lv 8 signal 1 } 
	{ quant_V_1_ce1 sc_out sc_logic 1 signal 1 } 
	{ quant_V_1_we1 sc_out sc_logic 1 signal 1 } 
	{ quant_V_1_d1 sc_out sc_lv 8 signal 1 } 
	{ quant_V_2_address1 sc_out sc_lv 8 signal 2 } 
	{ quant_V_2_ce1 sc_out sc_logic 1 signal 2 } 
	{ quant_V_2_we1 sc_out sc_logic 1 signal 2 } 
	{ quant_V_2_d1 sc_out sc_lv 8 signal 2 } 
	{ color_V_2_address1 sc_out sc_lv 8 signal 3 } 
	{ color_V_2_ce1 sc_out sc_logic 1 signal 3 } 
	{ color_V_2_we1 sc_out sc_logic 1 signal 3 } 
	{ color_V_2_d1 sc_out sc_lv 8 signal 3 } 
	{ color_V_1_address1 sc_out sc_lv 8 signal 4 } 
	{ color_V_1_ce1 sc_out sc_logic 1 signal 4 } 
	{ color_V_1_we1 sc_out sc_logic 1 signal 4 } 
	{ color_V_1_d1 sc_out sc_lv 8 signal 4 } 
	{ color_V_address1 sc_out sc_lv 8 signal 5 } 
	{ color_V_ce1 sc_out sc_logic 1 signal 5 } 
	{ color_V_we1 sc_out sc_logic 1 signal 5 } 
	{ color_V_d1 sc_out sc_lv 8 signal 5 } 
	{ and_r sc_in sc_lv 8 signal 6 } 
	{ v_V sc_in sc_lv 128 signal 7 } 
	{ cmp128 sc_in sc_lv 1 signal 8 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "quant_V_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "quant_V", "role": "address1" }} , 
 	{ "name": "quant_V_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "quant_V", "role": "ce1" }} , 
 	{ "name": "quant_V_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "quant_V", "role": "we1" }} , 
 	{ "name": "quant_V_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "quant_V", "role": "d1" }} , 
 	{ "name": "quant_V_1_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "quant_V_1", "role": "address1" }} , 
 	{ "name": "quant_V_1_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "quant_V_1", "role": "ce1" }} , 
 	{ "name": "quant_V_1_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "quant_V_1", "role": "we1" }} , 
 	{ "name": "quant_V_1_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "quant_V_1", "role": "d1" }} , 
 	{ "name": "quant_V_2_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "quant_V_2", "role": "address1" }} , 
 	{ "name": "quant_V_2_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "quant_V_2", "role": "ce1" }} , 
 	{ "name": "quant_V_2_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "quant_V_2", "role": "we1" }} , 
 	{ "name": "quant_V_2_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "quant_V_2", "role": "d1" }} , 
 	{ "name": "color_V_2_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_V_2", "role": "address1" }} , 
 	{ "name": "color_V_2_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_V_2", "role": "ce1" }} , 
 	{ "name": "color_V_2_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_V_2", "role": "we1" }} , 
 	{ "name": "color_V_2_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_V_2", "role": "d1" }} , 
 	{ "name": "color_V_1_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_V_1", "role": "address1" }} , 
 	{ "name": "color_V_1_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_V_1", "role": "ce1" }} , 
 	{ "name": "color_V_1_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_V_1", "role": "we1" }} , 
 	{ "name": "color_V_1_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_V_1", "role": "d1" }} , 
 	{ "name": "color_V_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_V", "role": "address1" }} , 
 	{ "name": "color_V_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_V", "role": "ce1" }} , 
 	{ "name": "color_V_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_V", "role": "we1" }} , 
 	{ "name": "color_V_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_V", "role": "d1" }} , 
 	{ "name": "and_r", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "and_r", "role": "default" }} , 
 	{ "name": "v_V", "direction": "in", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "v_V", "role": "default" }} , 
 	{ "name": "cmp128", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "cmp128", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1"],
		"CDFG" : "image_preprocess_Pipeline_VITIS_LOOP_468_2",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "18", "EstimateLatencyMax" : "18",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "quant_V", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "quant_V_1", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "quant_V_2", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "color_V_2", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "color_V_1", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "color_V", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "and_r", "Type" : "None", "Direction" : "I"},
			{"Name" : "v_V", "Type" : "None", "Direction" : "I"},
			{"Name" : "cmp128", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_468_2", "PipelineType" : "NotSupport"}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.flow_control_loop_pipe_sequential_init_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	image_preprocess_Pipeline_VITIS_LOOP_468_2 {
		quant_V {Type O LastRead -1 FirstWrite 0}
		quant_V_1 {Type O LastRead -1 FirstWrite 0}
		quant_V_2 {Type O LastRead -1 FirstWrite 0}
		color_V_2 {Type O LastRead -1 FirstWrite 0}
		color_V_1 {Type O LastRead -1 FirstWrite 0}
		color_V {Type O LastRead -1 FirstWrite 0}
		and_r {Type I LastRead 0 FirstWrite -1}
		v_V {Type I LastRead 0 FirstWrite -1}
		cmp128 {Type I LastRead 0 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "18", "Max" : "18"}
	, {"Name" : "Interval", "Min" : "18", "Max" : "18"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	quant_V { ap_memory {  { quant_V_address1 MemPortADDR2 1 8 }  { quant_V_ce1 MemPortCE2 1 1 }  { quant_V_we1 MemPortWE2 1 1 }  { quant_V_d1 MemPortDIN2 1 8 } } }
	quant_V_1 { ap_memory {  { quant_V_1_address1 MemPortADDR2 1 8 }  { quant_V_1_ce1 MemPortCE2 1 1 }  { quant_V_1_we1 MemPortWE2 1 1 }  { quant_V_1_d1 MemPortDIN2 1 8 } } }
	quant_V_2 { ap_memory {  { quant_V_2_address1 MemPortADDR2 1 8 }  { quant_V_2_ce1 MemPortCE2 1 1 }  { quant_V_2_we1 MemPortWE2 1 1 }  { quant_V_2_d1 MemPortDIN2 1 8 } } }
	color_V_2 { ap_memory {  { color_V_2_address1 MemPortADDR2 1 8 }  { color_V_2_ce1 MemPortCE2 1 1 }  { color_V_2_we1 MemPortWE2 1 1 }  { color_V_2_d1 MemPortDIN2 1 8 } } }
	color_V_1 { ap_memory {  { color_V_1_address1 MemPortADDR2 1 8 }  { color_V_1_ce1 MemPortCE2 1 1 }  { color_V_1_we1 MemPortWE2 1 1 }  { color_V_1_d1 MemPortDIN2 1 8 } } }
	color_V { ap_memory {  { color_V_address1 MemPortADDR2 1 8 }  { color_V_ce1 MemPortCE2 1 1 }  { color_V_we1 MemPortWE2 1 1 }  { color_V_d1 MemPortDIN2 1 8 } } }
	and_r { ap_none {  { and_r in_data 0 8 } } }
	v_V { ap_none {  { v_V in_data 0 128 } } }
	cmp128 { ap_none {  { cmp128 in_data 0 1 } } }
}
