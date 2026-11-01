set moduleName p_anonymous_namespace_validate_settings
set isTopModule 0
set isCombinational 0
set isDatapathOnly 1
set isPipelined 1
set pipeline_type function
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set hasInterrupt 0
set C_modelName {(anonymous namespace)validate_settings}
set C_modelType { int 3 }
set C_modelArgList {
	{ width int 32 regular  }
	{ height int 32 regular  }
	{ src_stride int 32 regular  }
	{ src_capacity int 32 regular  }
	{ tensor_capacity int 32 regular  }
	{ preview_stride int 32 regular  }
	{ preview_capacity int 32 regular  }
	{ resized_w int 32 regular  }
	{ resized_h int 32 regular  }
	{ pad_x int 32 regular  }
	{ pad_y int 32 regular  }
	{ output_mode int 32 regular  }
	{ flags int 32 regular  }
	{ eq_mode int 32 regular  }
	{ saturation_q12 int 32 regular  }
}
set C_modelArgMapList {[ 
	{ "Name" : "width", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "height", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "src_stride", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "src_capacity", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "tensor_capacity", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "preview_stride", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "preview_capacity", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "resized_w", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "resized_h", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "pad_x", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "pad_y", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "output_mode", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "flags", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "eq_mode", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "saturation_q12", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "ap_return", "interface" : "wire", "bitwidth" : 3} ]}
# RTL Port declarations: 
set portNum 18
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ width sc_in sc_lv 32 signal 0 } 
	{ height sc_in sc_lv 32 signal 1 } 
	{ src_stride sc_in sc_lv 32 signal 2 } 
	{ src_capacity sc_in sc_lv 32 signal 3 } 
	{ tensor_capacity sc_in sc_lv 32 signal 4 } 
	{ preview_stride sc_in sc_lv 32 signal 5 } 
	{ preview_capacity sc_in sc_lv 32 signal 6 } 
	{ resized_w sc_in sc_lv 32 signal 7 } 
	{ resized_h sc_in sc_lv 32 signal 8 } 
	{ pad_x sc_in sc_lv 32 signal 9 } 
	{ pad_y sc_in sc_lv 32 signal 10 } 
	{ output_mode sc_in sc_lv 32 signal 11 } 
	{ flags sc_in sc_lv 32 signal 12 } 
	{ eq_mode sc_in sc_lv 32 signal 13 } 
	{ saturation_q12 sc_in sc_lv 32 signal 14 } 
	{ ap_return sc_out sc_lv 3 signal -1 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "width", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "width", "role": "default" }} , 
 	{ "name": "height", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "height", "role": "default" }} , 
 	{ "name": "src_stride", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "src_stride", "role": "default" }} , 
 	{ "name": "src_capacity", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "src_capacity", "role": "default" }} , 
 	{ "name": "tensor_capacity", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "tensor_capacity", "role": "default" }} , 
 	{ "name": "preview_stride", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "preview_stride", "role": "default" }} , 
 	{ "name": "preview_capacity", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "preview_capacity", "role": "default" }} , 
 	{ "name": "resized_w", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "resized_w", "role": "default" }} , 
 	{ "name": "resized_h", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "resized_h", "role": "default" }} , 
 	{ "name": "pad_x", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "pad_x", "role": "default" }} , 
 	{ "name": "pad_y", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "pad_y", "role": "default" }} , 
 	{ "name": "output_mode", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "output_mode", "role": "default" }} , 
 	{ "name": "flags", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "flags", "role": "default" }} , 
 	{ "name": "eq_mode", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "eq_mode", "role": "default" }} , 
 	{ "name": "saturation_q12", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "saturation_q12", "role": "default" }} , 
 	{ "name": "ap_return", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "ap_return", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2"],
		"CDFG" : "p_anonymous_namespace_validate_settings",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "0", "ap_start" : "0", "ap_ready" : "0", "ap_done" : "0", "ap_continue" : "0", "ap_idle" : "0", "real_start" : "0",
		"Pipeline" : "Aligned", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "1",
		"VariableLatency" : "0", "ExactLatency" : "3", "EstimateLatencyMin" : "3", "EstimateLatencyMax" : "3",
		"Combinational" : "0",
		"Datapath" : "1",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "width", "Type" : "None", "Direction" : "I"},
			{"Name" : "height", "Type" : "None", "Direction" : "I"},
			{"Name" : "src_stride", "Type" : "None", "Direction" : "I"},
			{"Name" : "src_capacity", "Type" : "None", "Direction" : "I"},
			{"Name" : "tensor_capacity", "Type" : "None", "Direction" : "I"},
			{"Name" : "preview_stride", "Type" : "None", "Direction" : "I"},
			{"Name" : "preview_capacity", "Type" : "None", "Direction" : "I"},
			{"Name" : "resized_w", "Type" : "None", "Direction" : "I"},
			{"Name" : "resized_h", "Type" : "None", "Direction" : "I"},
			{"Name" : "pad_x", "Type" : "None", "Direction" : "I"},
			{"Name" : "pad_y", "Type" : "None", "Direction" : "I"},
			{"Name" : "output_mode", "Type" : "None", "Direction" : "I"},
			{"Name" : "flags", "Type" : "None", "Direction" : "I"},
			{"Name" : "eq_mode", "Type" : "None", "Direction" : "I"},
			{"Name" : "saturation_q12", "Type" : "None", "Direction" : "I"}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_13ns_11ns_24_3_1_U1", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_13ns_11ns_24_3_1_U2", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	p_anonymous_namespace_validate_settings {
		width {Type I LastRead 0 FirstWrite -1}
		height {Type I LastRead 0 FirstWrite -1}
		src_stride {Type I LastRead 0 FirstWrite -1}
		src_capacity {Type I LastRead 0 FirstWrite -1}
		tensor_capacity {Type I LastRead 0 FirstWrite -1}
		preview_stride {Type I LastRead 0 FirstWrite -1}
		preview_capacity {Type I LastRead 0 FirstWrite -1}
		resized_w {Type I LastRead 0 FirstWrite -1}
		resized_h {Type I LastRead 0 FirstWrite -1}
		pad_x {Type I LastRead 0 FirstWrite -1}
		pad_y {Type I LastRead 0 FirstWrite -1}
		output_mode {Type I LastRead 0 FirstWrite -1}
		flags {Type I LastRead 0 FirstWrite -1}
		eq_mode {Type I LastRead 0 FirstWrite -1}
		saturation_q12 {Type I LastRead 0 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "3", "Max" : "3"}
	, {"Name" : "Interval", "Min" : "1", "Max" : "1"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	width { ap_none {  { width in_data 0 32 } } }
	height { ap_none {  { height in_data 0 32 } } }
	src_stride { ap_none {  { src_stride in_data 0 32 } } }
	src_capacity { ap_none {  { src_capacity in_data 0 32 } } }
	tensor_capacity { ap_none {  { tensor_capacity in_data 0 32 } } }
	preview_stride { ap_none {  { preview_stride in_data 0 32 } } }
	preview_capacity { ap_none {  { preview_capacity in_data 0 32 } } }
	resized_w { ap_none {  { resized_w in_data 0 32 } } }
	resized_h { ap_none {  { resized_h in_data 0 32 } } }
	pad_x { ap_none {  { pad_x in_data 0 32 } } }
	pad_y { ap_none {  { pad_y in_data 0 32 } } }
	output_mode { ap_none {  { output_mode in_data 0 32 } } }
	flags { ap_none {  { flags in_data 0 32 } } }
	eq_mode { ap_none {  { eq_mode in_data 0 32 } } }
	saturation_q12 { ap_none {  { saturation_q12 in_data 0 32 } } }
}
