set moduleName yolo_postprocess_Pipeline_VITIS_LOOP_183_11
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
set C_modelName {yolo_postprocess_Pipeline_VITIS_LOOP_183_11}
set C_modelType { void 0 }
set C_modelArgList {
	{ count int 32 regular  }
	{ boxes_x1 int 32 regular {array 256 { 1 3 } 1 1 }  }
	{ boxes_y1 int 32 regular {array 256 { 1 3 } 1 1 }  }
	{ boxes_x2 int 32 regular {array 256 { 1 3 } 1 1 }  }
	{ boxes_y2 int 32 regular {array 256 { 1 3 } 1 1 }  }
	{ boxes_score int 32 regular {array 256 { 1 0 } 1 1 }  }
	{ boxes_cls int 32 regular {array 256 { 1 3 } 1 1 }  }
	{ selected_cls int 32 regular  }
	{ selected_x1 int 32 regular  }
	{ selected_y1 int 32 regular  }
	{ selected_x2 int 32 regular  }
	{ selected_y2 int 32 regular  }
	{ nms_q16_cast int 17 regular  }
}
set C_modelArgMapList {[ 
	{ "Name" : "count", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "boxes_x1", "interface" : "memory", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "boxes_y1", "interface" : "memory", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "boxes_x2", "interface" : "memory", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "boxes_y2", "interface" : "memory", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "boxes_score", "interface" : "memory", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "boxes_cls", "interface" : "memory", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "selected_cls", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "selected_x1", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "selected_y1", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "selected_x2", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "selected_y2", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "nms_q16_cast", "interface" : "wire", "bitwidth" : 17, "direction" : "READONLY"} ]}
# RTL Port declarations: 
set portNum 35
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ count sc_in sc_lv 32 signal 0 } 
	{ boxes_x1_address0 sc_out sc_lv 8 signal 1 } 
	{ boxes_x1_ce0 sc_out sc_logic 1 signal 1 } 
	{ boxes_x1_q0 sc_in sc_lv 32 signal 1 } 
	{ boxes_y1_address0 sc_out sc_lv 8 signal 2 } 
	{ boxes_y1_ce0 sc_out sc_logic 1 signal 2 } 
	{ boxes_y1_q0 sc_in sc_lv 32 signal 2 } 
	{ boxes_x2_address0 sc_out sc_lv 8 signal 3 } 
	{ boxes_x2_ce0 sc_out sc_logic 1 signal 3 } 
	{ boxes_x2_q0 sc_in sc_lv 32 signal 3 } 
	{ boxes_y2_address0 sc_out sc_lv 8 signal 4 } 
	{ boxes_y2_ce0 sc_out sc_logic 1 signal 4 } 
	{ boxes_y2_q0 sc_in sc_lv 32 signal 4 } 
	{ boxes_score_address0 sc_out sc_lv 8 signal 5 } 
	{ boxes_score_ce0 sc_out sc_logic 1 signal 5 } 
	{ boxes_score_q0 sc_in sc_lv 32 signal 5 } 
	{ boxes_score_address1 sc_out sc_lv 8 signal 5 } 
	{ boxes_score_ce1 sc_out sc_logic 1 signal 5 } 
	{ boxes_score_we1 sc_out sc_logic 1 signal 5 } 
	{ boxes_score_d1 sc_out sc_lv 32 signal 5 } 
	{ boxes_cls_address0 sc_out sc_lv 8 signal 6 } 
	{ boxes_cls_ce0 sc_out sc_logic 1 signal 6 } 
	{ boxes_cls_q0 sc_in sc_lv 32 signal 6 } 
	{ selected_cls sc_in sc_lv 32 signal 7 } 
	{ selected_x1 sc_in sc_lv 32 signal 8 } 
	{ selected_y1 sc_in sc_lv 32 signal 9 } 
	{ selected_x2 sc_in sc_lv 32 signal 10 } 
	{ selected_y2 sc_in sc_lv 32 signal 11 } 
	{ nms_q16_cast sc_in sc_lv 17 signal 12 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "count", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "count", "role": "default" }} , 
 	{ "name": "boxes_x1_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "boxes_x1", "role": "address0" }} , 
 	{ "name": "boxes_x1_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "boxes_x1", "role": "ce0" }} , 
 	{ "name": "boxes_x1_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "boxes_x1", "role": "q0" }} , 
 	{ "name": "boxes_y1_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "boxes_y1", "role": "address0" }} , 
 	{ "name": "boxes_y1_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "boxes_y1", "role": "ce0" }} , 
 	{ "name": "boxes_y1_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "boxes_y1", "role": "q0" }} , 
 	{ "name": "boxes_x2_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "boxes_x2", "role": "address0" }} , 
 	{ "name": "boxes_x2_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "boxes_x2", "role": "ce0" }} , 
 	{ "name": "boxes_x2_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "boxes_x2", "role": "q0" }} , 
 	{ "name": "boxes_y2_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "boxes_y2", "role": "address0" }} , 
 	{ "name": "boxes_y2_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "boxes_y2", "role": "ce0" }} , 
 	{ "name": "boxes_y2_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "boxes_y2", "role": "q0" }} , 
 	{ "name": "boxes_score_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "boxes_score", "role": "address0" }} , 
 	{ "name": "boxes_score_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "boxes_score", "role": "ce0" }} , 
 	{ "name": "boxes_score_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "boxes_score", "role": "q0" }} , 
 	{ "name": "boxes_score_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "boxes_score", "role": "address1" }} , 
 	{ "name": "boxes_score_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "boxes_score", "role": "ce1" }} , 
 	{ "name": "boxes_score_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "boxes_score", "role": "we1" }} , 
 	{ "name": "boxes_score_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "boxes_score", "role": "d1" }} , 
 	{ "name": "boxes_cls_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "boxes_cls", "role": "address0" }} , 
 	{ "name": "boxes_cls_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "boxes_cls", "role": "ce0" }} , 
 	{ "name": "boxes_cls_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "boxes_cls", "role": "q0" }} , 
 	{ "name": "selected_cls", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "selected_cls", "role": "default" }} , 
 	{ "name": "selected_x1", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "selected_x1", "role": "default" }} , 
 	{ "name": "selected_y1", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "selected_y1", "role": "default" }} , 
 	{ "name": "selected_x2", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "selected_x2", "role": "default" }} , 
 	{ "name": "selected_y2", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "selected_y2", "role": "default" }} , 
 	{ "name": "nms_q16_cast", "direction": "in", "datatype": "sc_lv", "bitwidth":17, "type": "signal", "bundle":{"name": "nms_q16_cast", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "37"],
		"CDFG" : "yolo_postprocess_Pipeline_VITIS_LOOP_183_11",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "-1", "EstimateLatencyMax" : "-1",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "count", "Type" : "None", "Direction" : "I"},
			{"Name" : "boxes_x1", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "boxes_y1", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "boxes_x2", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "boxes_y2", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "boxes_score", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "boxes_cls", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "selected_cls", "Type" : "None", "Direction" : "I"},
			{"Name" : "selected_x1", "Type" : "None", "Direction" : "I"},
			{"Name" : "selected_y1", "Type" : "None", "Direction" : "I"},
			{"Name" : "selected_x2", "Type" : "None", "Direction" : "I"},
			{"Name" : "selected_y2", "Type" : "None", "Direction" : "I"},
			{"Name" : "nms_q16_cast", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_183_11", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter21", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter21", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_suppress_fu_185", "Parent" : "0", "Child" : ["2", "10", "18", "26", "35", "36"],
		"CDFG" : "p_anonymous_namespace_suppress",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "0", "ap_start" : "0", "ap_ready" : "0", "ap_done" : "0", "ap_continue" : "0", "ap_idle" : "0", "real_start" : "0",
		"Pipeline" : "Aligned", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "1",
		"VariableLatency" : "0", "ExactLatency" : "18", "EstimateLatencyMin" : "18", "EstimateLatencyMax" : "18",
		"Combinational" : "0",
		"Datapath" : "1",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "p_read", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read1", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read2", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read3", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read4", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read5", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read6", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read7", "Type" : "None", "Direction" : "I"},
			{"Name" : "threshold", "Type" : "None", "Direction" : "I"}]},
	{"ID" : "2", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_suppress_fu_185.grp_p_anonymous_namespace_area_fu_117", "Parent" : "1", "Child" : ["3", "4", "5", "6", "7", "8", "9"],
		"CDFG" : "p_anonymous_namespace_area",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "0", "ap_start" : "0", "ap_ready" : "0", "ap_done" : "0", "ap_continue" : "0", "ap_idle" : "0", "real_start" : "0",
		"Pipeline" : "Aligned", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "1",
		"VariableLatency" : "0", "ExactLatency" : "6", "EstimateLatencyMin" : "6", "EstimateLatencyMax" : "6",
		"Combinational" : "0",
		"Datapath" : "1",
		"ClockEnable" : "1",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "w", "Type" : "None", "Direction" : "I"},
			{"Name" : "h", "Type" : "None", "Direction" : "I"}]},
	{"ID" : "3", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_suppress_fu_185.grp_p_anonymous_namespace_area_fu_117.add_33ns_33ns_33_2_0_U23", "Parent" : "2"},
	{"ID" : "4", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_suppress_fu_185.grp_p_anonymous_namespace_area_fu_117.add_33ns_33ns_33_2_0_U24", "Parent" : "2"},
	{"ID" : "5", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_suppress_fu_185.grp_p_anonymous_namespace_area_fu_117.add_32ns_32ns_32_2_0_U25", "Parent" : "2"},
	{"ID" : "6", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_suppress_fu_185.grp_p_anonymous_namespace_area_fu_117.mul_mul_16ns_16ns_32_4_0_U26", "Parent" : "2"},
	{"ID" : "7", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_suppress_fu_185.grp_p_anonymous_namespace_area_fu_117.mul_mul_16ns_16ns_32_4_0_U27", "Parent" : "2"},
	{"ID" : "8", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_suppress_fu_185.grp_p_anonymous_namespace_area_fu_117.mul_mul_16ns_16ns_32_4_0_U28", "Parent" : "2"},
	{"ID" : "9", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_suppress_fu_185.grp_p_anonymous_namespace_area_fu_117.mul_mul_16ns_16ns_32_4_0_U29", "Parent" : "2"},
	{"ID" : "10", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_suppress_fu_185.grp_p_anonymous_namespace_area_fu_123", "Parent" : "1", "Child" : ["11", "12", "13", "14", "15", "16", "17"],
		"CDFG" : "p_anonymous_namespace_area",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "0", "ap_start" : "0", "ap_ready" : "0", "ap_done" : "0", "ap_continue" : "0", "ap_idle" : "0", "real_start" : "0",
		"Pipeline" : "Aligned", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "1",
		"VariableLatency" : "0", "ExactLatency" : "6", "EstimateLatencyMin" : "6", "EstimateLatencyMax" : "6",
		"Combinational" : "0",
		"Datapath" : "1",
		"ClockEnable" : "1",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "w", "Type" : "None", "Direction" : "I"},
			{"Name" : "h", "Type" : "None", "Direction" : "I"}]},
	{"ID" : "11", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_suppress_fu_185.grp_p_anonymous_namespace_area_fu_123.add_33ns_33ns_33_2_0_U23", "Parent" : "10"},
	{"ID" : "12", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_suppress_fu_185.grp_p_anonymous_namespace_area_fu_123.add_33ns_33ns_33_2_0_U24", "Parent" : "10"},
	{"ID" : "13", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_suppress_fu_185.grp_p_anonymous_namespace_area_fu_123.add_32ns_32ns_32_2_0_U25", "Parent" : "10"},
	{"ID" : "14", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_suppress_fu_185.grp_p_anonymous_namespace_area_fu_123.mul_mul_16ns_16ns_32_4_0_U26", "Parent" : "10"},
	{"ID" : "15", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_suppress_fu_185.grp_p_anonymous_namespace_area_fu_123.mul_mul_16ns_16ns_32_4_0_U27", "Parent" : "10"},
	{"ID" : "16", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_suppress_fu_185.grp_p_anonymous_namespace_area_fu_123.mul_mul_16ns_16ns_32_4_0_U28", "Parent" : "10"},
	{"ID" : "17", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_suppress_fu_185.grp_p_anonymous_namespace_area_fu_123.mul_mul_16ns_16ns_32_4_0_U29", "Parent" : "10"},
	{"ID" : "18", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_suppress_fu_185.grp_p_anonymous_namespace_area_fu_129", "Parent" : "1", "Child" : ["19", "20", "21", "22", "23", "24", "25"],
		"CDFG" : "p_anonymous_namespace_area",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "0", "ap_start" : "0", "ap_ready" : "0", "ap_done" : "0", "ap_continue" : "0", "ap_idle" : "0", "real_start" : "0",
		"Pipeline" : "Aligned", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "1",
		"VariableLatency" : "0", "ExactLatency" : "6", "EstimateLatencyMin" : "6", "EstimateLatencyMax" : "6",
		"Combinational" : "0",
		"Datapath" : "1",
		"ClockEnable" : "1",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "w", "Type" : "None", "Direction" : "I"},
			{"Name" : "h", "Type" : "None", "Direction" : "I"}]},
	{"ID" : "19", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_suppress_fu_185.grp_p_anonymous_namespace_area_fu_129.add_33ns_33ns_33_2_0_U23", "Parent" : "18"},
	{"ID" : "20", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_suppress_fu_185.grp_p_anonymous_namespace_area_fu_129.add_33ns_33ns_33_2_0_U24", "Parent" : "18"},
	{"ID" : "21", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_suppress_fu_185.grp_p_anonymous_namespace_area_fu_129.add_32ns_32ns_32_2_0_U25", "Parent" : "18"},
	{"ID" : "22", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_suppress_fu_185.grp_p_anonymous_namespace_area_fu_129.mul_mul_16ns_16ns_32_4_0_U26", "Parent" : "18"},
	{"ID" : "23", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_suppress_fu_185.grp_p_anonymous_namespace_area_fu_129.mul_mul_16ns_16ns_32_4_0_U27", "Parent" : "18"},
	{"ID" : "24", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_suppress_fu_185.grp_p_anonymous_namespace_area_fu_129.mul_mul_16ns_16ns_32_4_0_U28", "Parent" : "18"},
	{"ID" : "25", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_suppress_fu_185.grp_p_anonymous_namespace_area_fu_129.mul_mul_16ns_16ns_32_4_0_U29", "Parent" : "18"},
	{"ID" : "26", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_suppress_fu_185.grp_p_anonymous_namespace_threshold_product_fu_135", "Parent" : "1", "Child" : ["27", "28", "29", "30", "31", "32", "33", "34"],
		"CDFG" : "p_anonymous_namespace_threshold_product",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "0", "ap_start" : "0", "ap_ready" : "0", "ap_done" : "0", "ap_continue" : "0", "ap_idle" : "0", "real_start" : "0",
		"Pipeline" : "Aligned", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "1",
		"VariableLatency" : "0", "ExactLatency" : "6", "EstimateLatencyMin" : "6", "EstimateLatencyMax" : "6",
		"Combinational" : "0",
		"Datapath" : "1",
		"ClockEnable" : "1",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "total", "Type" : "None", "Direction" : "I"},
			{"Name" : "threshold", "Type" : "None", "Direction" : "I"}]},
	{"ID" : "27", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_suppress_fu_185.grp_p_anonymous_namespace_threshold_product_fu_135.add_16ns_16ns_16_2_0_U35", "Parent" : "26"},
	{"ID" : "28", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_suppress_fu_185.grp_p_anonymous_namespace_threshold_product_fu_135.add_33ns_33ns_33_2_0_U36", "Parent" : "26"},
	{"ID" : "29", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_suppress_fu_185.grp_p_anonymous_namespace_threshold_product_fu_135.add_33ns_33ns_33_2_0_U37", "Parent" : "26"},
	{"ID" : "30", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_suppress_fu_185.grp_p_anonymous_namespace_threshold_product_fu_135.add_18ns_18ns_18_2_0_U38", "Parent" : "26"},
	{"ID" : "31", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_suppress_fu_185.grp_p_anonymous_namespace_threshold_product_fu_135.mul_mul_17ns_16ns_33_4_0_U39", "Parent" : "26"},
	{"ID" : "32", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_suppress_fu_185.grp_p_anonymous_namespace_threshold_product_fu_135.mul_mul_17ns_16ns_33_4_0_U40", "Parent" : "26"},
	{"ID" : "33", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_suppress_fu_185.grp_p_anonymous_namespace_threshold_product_fu_135.mul_mul_17ns_16ns_33_4_0_U41", "Parent" : "26"},
	{"ID" : "34", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_suppress_fu_185.grp_p_anonymous_namespace_threshold_product_fu_135.mul_mul_17ns_16ns_33_4_0_U42", "Parent" : "26"},
	{"ID" : "35", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_suppress_fu_185.add_65ns_65ns_65_3_1_U48", "Parent" : "1"},
	{"ID" : "36", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_suppress_fu_185.sub_65ns_65ns_65_3_1_U49", "Parent" : "1"},
	{"ID" : "37", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.flow_control_loop_pipe_sequential_init_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	yolo_postprocess_Pipeline_VITIS_LOOP_183_11 {
		count {Type I LastRead 0 FirstWrite -1}
		boxes_x1 {Type I LastRead 0 FirstWrite -1}
		boxes_y1 {Type I LastRead 0 FirstWrite -1}
		boxes_x2 {Type I LastRead 0 FirstWrite -1}
		boxes_y2 {Type I LastRead 0 FirstWrite -1}
		boxes_score {Type IO LastRead 0 FirstWrite 21}
		boxes_cls {Type I LastRead 0 FirstWrite -1}
		selected_cls {Type I LastRead 0 FirstWrite -1}
		selected_x1 {Type I LastRead 0 FirstWrite -1}
		selected_y1 {Type I LastRead 0 FirstWrite -1}
		selected_x2 {Type I LastRead 0 FirstWrite -1}
		selected_y2 {Type I LastRead 0 FirstWrite -1}
		nms_q16_cast {Type I LastRead 0 FirstWrite -1}}
	p_anonymous_namespace_suppress {
		p_read {Type I LastRead 0 FirstWrite -1}
		p_read1 {Type I LastRead 0 FirstWrite -1}
		p_read2 {Type I LastRead 0 FirstWrite -1}
		p_read3 {Type I LastRead 0 FirstWrite -1}
		p_read4 {Type I LastRead 0 FirstWrite -1}
		p_read5 {Type I LastRead 0 FirstWrite -1}
		p_read6 {Type I LastRead 0 FirstWrite -1}
		p_read7 {Type I LastRead 0 FirstWrite -1}
		threshold {Type I LastRead 0 FirstWrite -1}}
	p_anonymous_namespace_area {
		w {Type I LastRead 0 FirstWrite -1}
		h {Type I LastRead 0 FirstWrite -1}}
	p_anonymous_namespace_area {
		w {Type I LastRead 0 FirstWrite -1}
		h {Type I LastRead 0 FirstWrite -1}}
	p_anonymous_namespace_area {
		w {Type I LastRead 0 FirstWrite -1}
		h {Type I LastRead 0 FirstWrite -1}}
	p_anonymous_namespace_threshold_product {
		total {Type I LastRead 0 FirstWrite -1}
		threshold {Type I LastRead 0 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "-1", "Max" : "-1"}
	, {"Name" : "Interval", "Min" : "-1", "Max" : "-1"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	count { ap_none {  { count in_data 0 32 } } }
	boxes_x1 { ap_memory {  { boxes_x1_address0 mem_address 1 8 }  { boxes_x1_ce0 mem_ce 1 1 }  { boxes_x1_q0 mem_dout 0 32 } } }
	boxes_y1 { ap_memory {  { boxes_y1_address0 mem_address 1 8 }  { boxes_y1_ce0 mem_ce 1 1 }  { boxes_y1_q0 mem_dout 0 32 } } }
	boxes_x2 { ap_memory {  { boxes_x2_address0 mem_address 1 8 }  { boxes_x2_ce0 mem_ce 1 1 }  { boxes_x2_q0 mem_dout 0 32 } } }
	boxes_y2 { ap_memory {  { boxes_y2_address0 mem_address 1 8 }  { boxes_y2_ce0 mem_ce 1 1 }  { boxes_y2_q0 mem_dout 0 32 } } }
	boxes_score { ap_memory {  { boxes_score_address0 mem_address 1 8 }  { boxes_score_ce0 mem_ce 1 1 }  { boxes_score_q0 in_data 0 32 }  { boxes_score_address1 MemPortADDR2 1 8 }  { boxes_score_ce1 MemPortCE2 1 1 }  { boxes_score_we1 MemPortWE2 1 1 }  { boxes_score_d1 MemPortDIN2 1 32 } } }
	boxes_cls { ap_memory {  { boxes_cls_address0 mem_address 1 8 }  { boxes_cls_ce0 mem_ce 1 1 }  { boxes_cls_q0 in_data 0 32 } } }
	selected_cls { ap_none {  { selected_cls in_data 0 32 } } }
	selected_x1 { ap_none {  { selected_x1 in_data 0 32 } } }
	selected_y1 { ap_none {  { selected_y1 in_data 0 32 } } }
	selected_x2 { ap_none {  { selected_x2 in_data 0 32 } } }
	selected_y2 { ap_none {  { selected_y2 in_data 0 32 } } }
	nms_q16_cast { ap_none {  { nms_q16_cast in_data 0 17 } } }
}
