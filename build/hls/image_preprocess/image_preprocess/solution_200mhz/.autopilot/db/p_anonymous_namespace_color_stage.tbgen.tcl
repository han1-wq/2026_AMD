set moduleName p_anonymous_namespace_color_stage
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
set C_modelName {(anonymous namespace)color_stage}
set C_modelType { void 0 }
set C_modelArgList {
	{ in_pixels int 24 regular {fifo 0 volatile }  }
	{ pairs int 48 regular {fifo 1 volatile }  }
	{ hist_pixels int 8 regular {fifo 1 volatile }  }
	{ color_0 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ color_1 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ color_2 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ eq int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ p_read int 2 regular  }
	{ saturation int 14 regular  }
	{ eq_enabled int 1 regular  }
	{ p_read1 int 32 regular  }
	{ mul_ln363_loc_c int 32 regular {fifo 1}  }
}
set C_modelArgMapList {[ 
	{ "Name" : "in_pixels", "interface" : "fifo", "bitwidth" : 24, "direction" : "READONLY"} , 
 	{ "Name" : "pairs", "interface" : "fifo", "bitwidth" : 48, "direction" : "WRITEONLY"} , 
 	{ "Name" : "hist_pixels", "interface" : "fifo", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "color_0", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "color_1", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "color_2", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "eq", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "p_read", "interface" : "wire", "bitwidth" : 2, "direction" : "READONLY"} , 
 	{ "Name" : "saturation", "interface" : "wire", "bitwidth" : 14, "direction" : "READONLY"} , 
 	{ "Name" : "eq_enabled", "interface" : "wire", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "p_read1", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "mul_ln363_loc_c", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 43
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ in_pixels_dout sc_in sc_lv 24 signal 0 } 
	{ in_pixels_num_data_valid sc_in sc_lv 7 signal 0 } 
	{ in_pixels_fifo_cap sc_in sc_lv 7 signal 0 } 
	{ in_pixels_empty_n sc_in sc_logic 1 signal 0 } 
	{ in_pixels_read sc_out sc_logic 1 signal 0 } 
	{ pairs_din sc_out sc_lv 48 signal 1 } 
	{ pairs_num_data_valid sc_in sc_lv 7 signal 1 } 
	{ pairs_fifo_cap sc_in sc_lv 7 signal 1 } 
	{ pairs_full_n sc_in sc_logic 1 signal 1 } 
	{ pairs_write sc_out sc_logic 1 signal 1 } 
	{ hist_pixels_din sc_out sc_lv 8 signal 2 } 
	{ hist_pixels_num_data_valid sc_in sc_lv 7 signal 2 } 
	{ hist_pixels_fifo_cap sc_in sc_lv 7 signal 2 } 
	{ hist_pixels_full_n sc_in sc_logic 1 signal 2 } 
	{ hist_pixels_write sc_out sc_logic 1 signal 2 } 
	{ color_0_address0 sc_out sc_lv 8 signal 3 } 
	{ color_0_ce0 sc_out sc_logic 1 signal 3 } 
	{ color_0_q0 sc_in sc_lv 8 signal 3 } 
	{ color_1_address0 sc_out sc_lv 8 signal 4 } 
	{ color_1_ce0 sc_out sc_logic 1 signal 4 } 
	{ color_1_q0 sc_in sc_lv 8 signal 4 } 
	{ color_2_address0 sc_out sc_lv 8 signal 5 } 
	{ color_2_ce0 sc_out sc_logic 1 signal 5 } 
	{ color_2_q0 sc_in sc_lv 8 signal 5 } 
	{ eq_address0 sc_out sc_lv 8 signal 6 } 
	{ eq_ce0 sc_out sc_logic 1 signal 6 } 
	{ eq_q0 sc_in sc_lv 8 signal 6 } 
	{ p_read sc_in sc_lv 2 signal 7 } 
	{ saturation sc_in sc_lv 14 signal 8 } 
	{ eq_enabled sc_in sc_lv 1 signal 9 } 
	{ p_read1 sc_in sc_lv 32 signal 10 } 
	{ mul_ln363_loc_c_din sc_out sc_lv 32 signal 11 } 
	{ mul_ln363_loc_c_num_data_valid sc_in sc_lv 2 signal 11 } 
	{ mul_ln363_loc_c_fifo_cap sc_in sc_lv 2 signal 11 } 
	{ mul_ln363_loc_c_full_n sc_in sc_logic 1 signal 11 } 
	{ mul_ln363_loc_c_write sc_out sc_logic 1 signal 11 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "in_pixels_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":24, "type": "signal", "bundle":{"name": "in_pixels", "role": "dout" }} , 
 	{ "name": "in_pixels_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "in_pixels", "role": "num_data_valid" }} , 
 	{ "name": "in_pixels_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "in_pixels", "role": "fifo_cap" }} , 
 	{ "name": "in_pixels_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "in_pixels", "role": "empty_n" }} , 
 	{ "name": "in_pixels_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "in_pixels", "role": "read" }} , 
 	{ "name": "pairs_din", "direction": "out", "datatype": "sc_lv", "bitwidth":48, "type": "signal", "bundle":{"name": "pairs", "role": "din" }} , 
 	{ "name": "pairs_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "pairs", "role": "num_data_valid" }} , 
 	{ "name": "pairs_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "pairs", "role": "fifo_cap" }} , 
 	{ "name": "pairs_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "pairs", "role": "full_n" }} , 
 	{ "name": "pairs_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "pairs", "role": "write" }} , 
 	{ "name": "hist_pixels_din", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "hist_pixels", "role": "din" }} , 
 	{ "name": "hist_pixels_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "hist_pixels", "role": "num_data_valid" }} , 
 	{ "name": "hist_pixels_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "hist_pixels", "role": "fifo_cap" }} , 
 	{ "name": "hist_pixels_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist_pixels", "role": "full_n" }} , 
 	{ "name": "hist_pixels_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist_pixels", "role": "write" }} , 
 	{ "name": "color_0_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_0", "role": "address0" }} , 
 	{ "name": "color_0_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_0", "role": "ce0" }} , 
 	{ "name": "color_0_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_0", "role": "q0" }} , 
 	{ "name": "color_1_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_1", "role": "address0" }} , 
 	{ "name": "color_1_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_1", "role": "ce0" }} , 
 	{ "name": "color_1_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_1", "role": "q0" }} , 
 	{ "name": "color_2_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_2", "role": "address0" }} , 
 	{ "name": "color_2_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_2", "role": "ce0" }} , 
 	{ "name": "color_2_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_2", "role": "q0" }} , 
 	{ "name": "eq_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "eq", "role": "address0" }} , 
 	{ "name": "eq_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "eq", "role": "ce0" }} , 
 	{ "name": "eq_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "eq", "role": "q0" }} , 
 	{ "name": "p_read", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "p_read", "role": "default" }} , 
 	{ "name": "saturation", "direction": "in", "datatype": "sc_lv", "bitwidth":14, "type": "signal", "bundle":{"name": "saturation", "role": "default" }} , 
 	{ "name": "eq_enabled", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "eq_enabled", "role": "default" }} , 
 	{ "name": "p_read1", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_read1", "role": "default" }} , 
 	{ "name": "mul_ln363_loc_c_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "mul_ln363_loc_c", "role": "din" }} , 
 	{ "name": "mul_ln363_loc_c_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "mul_ln363_loc_c", "role": "num_data_valid" }} , 
 	{ "name": "mul_ln363_loc_c_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "mul_ln363_loc_c", "role": "fifo_cap" }} , 
 	{ "name": "mul_ln363_loc_c_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mul_ln363_loc_c", "role": "full_n" }} , 
 	{ "name": "mul_ln363_loc_c_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mul_ln363_loc_c", "role": "write" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1"],
		"CDFG" : "p_anonymous_namespace_color_stage",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "173077", "EstimateLatencyMax" : "2073621",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "in_pixels", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_183_1_fu_104", "Port" : "in_pixels", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "pairs", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_183_1_fu_104", "Port" : "pairs", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "hist_pixels", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_183_1_fu_104", "Port" : "hist_pixels", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "color_0", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_183_1_fu_104", "Port" : "color_0", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "color_1", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_183_1_fu_104", "Port" : "color_1", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "color_2", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_183_1_fu_104", "Port" : "color_2", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "eq", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_183_1_fu_104", "Port" : "eq", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "p_read", "Type" : "None", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "3", "DependentChanType" : "1"},
			{"Name" : "saturation", "Type" : "None", "Direction" : "I"},
			{"Name" : "eq_enabled", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read1", "Type" : "None", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "3", "DependentChanType" : "1"},
			{"Name" : "mul_ln363_loc_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "mul_ln363_loc_c_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_183_1_fu_104", "Parent" : "0", "Child" : ["2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19"],
		"CDFG" : "p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_183_1",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "173075", "EstimateLatencyMax" : "2073619",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "p_read1", "Type" : "None", "Direction" : "I"},
			{"Name" : "in_pixels", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "in_pixels_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "color_0", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "color_1", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "color_2", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "flags_cast_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "zext_ln183", "Type" : "None", "Direction" : "I"},
			{"Name" : "tobool25_i_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "hist_pixels", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "hist_pixels_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "eq", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "eq_enabled", "Type" : "None", "Direction" : "I"},
			{"Name" : "pairs", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "pairs_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_183_1", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter18", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter18", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "2", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_183_1_fu_104.mul_8ns_9ns_16_1_1_U139", "Parent" : "1"},
	{"ID" : "3", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_183_1_fu_104.mul_8ns_8s_16_1_1_U140", "Parent" : "1"},
	{"ID" : "4", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_183_1_fu_104.mul_8ns_8s_16_1_1_U141", "Parent" : "1"},
	{"ID" : "5", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_183_1_fu_104.mac_muladd_8ns_5ns_8ns_13_4_1_U142", "Parent" : "1"},
	{"ID" : "6", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_183_1_fu_104.mac_muladd_8ns_7ns_16ns_16_4_1_U143", "Parent" : "1"},
	{"ID" : "7", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_183_1_fu_104.mac_muladd_14ns_9s_20ns_24_4_1_U144", "Parent" : "1"},
	{"ID" : "8", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_183_1_fu_104.mac_muladd_14ns_9s_20ns_24_4_1_U145", "Parent" : "1"},
	{"ID" : "9", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_183_1_fu_104.mac_muladd_14ns_9s_20ns_24_4_1_U146", "Parent" : "1"},
	{"ID" : "10", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_183_1_fu_104.mac_muladd_8ns_5ns_8ns_13_4_1_U147", "Parent" : "1"},
	{"ID" : "11", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_183_1_fu_104.mac_muladd_8ns_7s_16s_16_4_1_U148", "Parent" : "1"},
	{"ID" : "12", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_183_1_fu_104.mac_muladd_8ns_6s_16s_16_4_1_U149", "Parent" : "1"},
	{"ID" : "13", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_183_1_fu_104.mac_muladd_8ns_7ns_13ns_15_4_1_U150", "Parent" : "1"},
	{"ID" : "14", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_183_1_fu_104.mac_muladd_8ns_8ns_15ns_16_4_1_U151", "Parent" : "1"},
	{"ID" : "15", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_183_1_fu_104.mac_muladd_8s_9ns_16ns_18_4_1_U152", "Parent" : "1"},
	{"ID" : "16", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_183_1_fu_104.mac_muladd_8s_8s_16ns_18_4_1_U153", "Parent" : "1"},
	{"ID" : "17", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_183_1_fu_104.mac_muladd_8s_9ns_16ns_18_4_1_U154", "Parent" : "1"},
	{"ID" : "18", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_183_1_fu_104.mac_muladd_8s_9s_18s_18_4_1_U155", "Parent" : "1"},
	{"ID" : "19", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_183_1_fu_104.flow_control_loop_pipe_sequential_init_U", "Parent" : "1"}]}


set ArgLastReadFirstWriteLatency {
	p_anonymous_namespace_color_stage {
		in_pixels {Type I LastRead 1 FirstWrite -1}
		pairs {Type O LastRead -1 FirstWrite 18}
		hist_pixels {Type O LastRead -1 FirstWrite 18}
		color_0 {Type I LastRead 1 FirstWrite -1}
		color_1 {Type I LastRead 3 FirstWrite -1}
		color_2 {Type I LastRead 1 FirstWrite -1}
		eq {Type I LastRead 14 FirstWrite -1}
		p_read {Type I LastRead 0 FirstWrite -1}
		saturation {Type I LastRead 0 FirstWrite -1}
		eq_enabled {Type I LastRead 0 FirstWrite -1}
		p_read1 {Type I LastRead 0 FirstWrite -1}
		mul_ln363_loc_c {Type O LastRead -1 FirstWrite 0}}
	p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_183_1 {
		p_read1 {Type I LastRead 0 FirstWrite -1}
		in_pixels {Type I LastRead 1 FirstWrite -1}
		color_0 {Type I LastRead 1 FirstWrite -1}
		color_1 {Type I LastRead 3 FirstWrite -1}
		color_2 {Type I LastRead 1 FirstWrite -1}
		flags_cast_i {Type I LastRead 0 FirstWrite -1}
		zext_ln183 {Type I LastRead 0 FirstWrite -1}
		tobool25_i_i {Type I LastRead 0 FirstWrite -1}
		hist_pixels {Type O LastRead -1 FirstWrite 18}
		eq {Type I LastRead 14 FirstWrite -1}
		eq_enabled {Type I LastRead 0 FirstWrite -1}
		pairs {Type O LastRead -1 FirstWrite 18}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "173077", "Max" : "2073621"}
	, {"Name" : "Interval", "Min" : "173077", "Max" : "2073621"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	in_pixels { ap_fifo {  { in_pixels_dout fifo_port_we 0 24 }  { in_pixels_num_data_valid fifo_status_num_data_valid 0 7 }  { in_pixels_fifo_cap fifo_update 0 7 }  { in_pixels_empty_n fifo_status 0 1 }  { in_pixels_read fifo_data 1 1 } } }
	pairs { ap_fifo {  { pairs_din fifo_port_we 1 48 }  { pairs_num_data_valid fifo_status_num_data_valid 0 7 }  { pairs_fifo_cap fifo_update 0 7 }  { pairs_full_n fifo_status 0 1 }  { pairs_write fifo_data 1 1 } } }
	hist_pixels { ap_fifo {  { hist_pixels_din fifo_port_we 1 8 }  { hist_pixels_num_data_valid fifo_status_num_data_valid 0 7 }  { hist_pixels_fifo_cap fifo_update 0 7 }  { hist_pixels_full_n fifo_status 0 1 }  { hist_pixels_write fifo_data 1 1 } } }
	color_0 { ap_memory {  { color_0_address0 mem_address 1 8 }  { color_0_ce0 mem_ce 1 1 }  { color_0_q0 mem_dout 0 8 } } }
	color_1 { ap_memory {  { color_1_address0 mem_address 1 8 }  { color_1_ce0 mem_ce 1 1 }  { color_1_q0 mem_dout 0 8 } } }
	color_2 { ap_memory {  { color_2_address0 mem_address 1 8 }  { color_2_ce0 mem_ce 1 1 }  { color_2_q0 mem_dout 0 8 } } }
	eq { ap_memory {  { eq_address0 mem_address 1 8 }  { eq_ce0 mem_ce 1 1 }  { eq_q0 mem_dout 0 8 } } }
	p_read { ap_none {  { p_read in_data 0 2 } } }
	saturation { ap_none {  { saturation in_data 0 14 } } }
	eq_enabled { ap_none {  { eq_enabled in_data 0 1 } } }
	p_read1 { ap_none {  { p_read1 in_data 0 32 } } }
	mul_ln363_loc_c { ap_fifo {  { mul_ln363_loc_c_din fifo_port_we 1 32 }  { mul_ln363_loc_c_num_data_valid fifo_status_num_data_valid 0 2 }  { mul_ln363_loc_c_fifo_cap fifo_update 0 2 }  { mul_ln363_loc_c_full_n fifo_status 0 1 }  { mul_ln363_loc_c_write fifo_data 1 1 } } }
}
set moduleName p_anonymous_namespace_color_stage
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
set C_modelName {(anonymous namespace)color_stage}
set C_modelType { void 0 }
set C_modelArgList {
	{ in_pixels int 24 regular {fifo 0 volatile }  }
	{ pairs int 48 regular {fifo 1 volatile }  }
	{ hist_pixels int 8 regular {fifo 1 volatile }  }
	{ color_0 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ color_1 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ color_2 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ eq int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ p_read int 2 regular  }
	{ saturation int 14 regular  }
	{ eq_enabled int 1 regular  }
	{ p_read1 int 22 regular  }
	{ ret_V_loc_c int 22 regular {fifo 1}  }
}
set C_modelArgMapList {[ 
	{ "Name" : "in_pixels", "interface" : "fifo", "bitwidth" : 24, "direction" : "READONLY"} , 
 	{ "Name" : "pairs", "interface" : "fifo", "bitwidth" : 48, "direction" : "WRITEONLY"} , 
 	{ "Name" : "hist_pixels", "interface" : "fifo", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "color_0", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "color_1", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "color_2", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "eq", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "p_read", "interface" : "wire", "bitwidth" : 2, "direction" : "READONLY"} , 
 	{ "Name" : "saturation", "interface" : "wire", "bitwidth" : 14, "direction" : "READONLY"} , 
 	{ "Name" : "eq_enabled", "interface" : "wire", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "p_read1", "interface" : "wire", "bitwidth" : 22, "direction" : "READONLY"} , 
 	{ "Name" : "ret_V_loc_c", "interface" : "fifo", "bitwidth" : 22, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 43
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ in_pixels_dout sc_in sc_lv 24 signal 0 } 
	{ in_pixels_num_data_valid sc_in sc_lv 7 signal 0 } 
	{ in_pixels_fifo_cap sc_in sc_lv 7 signal 0 } 
	{ in_pixels_empty_n sc_in sc_logic 1 signal 0 } 
	{ in_pixels_read sc_out sc_logic 1 signal 0 } 
	{ pairs_din sc_out sc_lv 48 signal 1 } 
	{ pairs_num_data_valid sc_in sc_lv 7 signal 1 } 
	{ pairs_fifo_cap sc_in sc_lv 7 signal 1 } 
	{ pairs_full_n sc_in sc_logic 1 signal 1 } 
	{ pairs_write sc_out sc_logic 1 signal 1 } 
	{ hist_pixels_din sc_out sc_lv 8 signal 2 } 
	{ hist_pixels_num_data_valid sc_in sc_lv 7 signal 2 } 
	{ hist_pixels_fifo_cap sc_in sc_lv 7 signal 2 } 
	{ hist_pixels_full_n sc_in sc_logic 1 signal 2 } 
	{ hist_pixels_write sc_out sc_logic 1 signal 2 } 
	{ color_0_address0 sc_out sc_lv 8 signal 3 } 
	{ color_0_ce0 sc_out sc_logic 1 signal 3 } 
	{ color_0_q0 sc_in sc_lv 8 signal 3 } 
	{ color_1_address0 sc_out sc_lv 8 signal 4 } 
	{ color_1_ce0 sc_out sc_logic 1 signal 4 } 
	{ color_1_q0 sc_in sc_lv 8 signal 4 } 
	{ color_2_address0 sc_out sc_lv 8 signal 5 } 
	{ color_2_ce0 sc_out sc_logic 1 signal 5 } 
	{ color_2_q0 sc_in sc_lv 8 signal 5 } 
	{ eq_address0 sc_out sc_lv 8 signal 6 } 
	{ eq_ce0 sc_out sc_logic 1 signal 6 } 
	{ eq_q0 sc_in sc_lv 8 signal 6 } 
	{ p_read sc_in sc_lv 2 signal 7 } 
	{ saturation sc_in sc_lv 14 signal 8 } 
	{ eq_enabled sc_in sc_lv 1 signal 9 } 
	{ p_read1 sc_in sc_lv 22 signal 10 } 
	{ ret_V_loc_c_din sc_out sc_lv 22 signal 11 } 
	{ ret_V_loc_c_num_data_valid sc_in sc_lv 2 signal 11 } 
	{ ret_V_loc_c_fifo_cap sc_in sc_lv 2 signal 11 } 
	{ ret_V_loc_c_full_n sc_in sc_logic 1 signal 11 } 
	{ ret_V_loc_c_write sc_out sc_logic 1 signal 11 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "in_pixels_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":24, "type": "signal", "bundle":{"name": "in_pixels", "role": "dout" }} , 
 	{ "name": "in_pixels_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "in_pixels", "role": "num_data_valid" }} , 
 	{ "name": "in_pixels_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "in_pixels", "role": "fifo_cap" }} , 
 	{ "name": "in_pixels_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "in_pixels", "role": "empty_n" }} , 
 	{ "name": "in_pixels_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "in_pixels", "role": "read" }} , 
 	{ "name": "pairs_din", "direction": "out", "datatype": "sc_lv", "bitwidth":48, "type": "signal", "bundle":{"name": "pairs", "role": "din" }} , 
 	{ "name": "pairs_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "pairs", "role": "num_data_valid" }} , 
 	{ "name": "pairs_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "pairs", "role": "fifo_cap" }} , 
 	{ "name": "pairs_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "pairs", "role": "full_n" }} , 
 	{ "name": "pairs_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "pairs", "role": "write" }} , 
 	{ "name": "hist_pixels_din", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "hist_pixels", "role": "din" }} , 
 	{ "name": "hist_pixels_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "hist_pixels", "role": "num_data_valid" }} , 
 	{ "name": "hist_pixels_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "hist_pixels", "role": "fifo_cap" }} , 
 	{ "name": "hist_pixels_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist_pixels", "role": "full_n" }} , 
 	{ "name": "hist_pixels_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist_pixels", "role": "write" }} , 
 	{ "name": "color_0_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_0", "role": "address0" }} , 
 	{ "name": "color_0_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_0", "role": "ce0" }} , 
 	{ "name": "color_0_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_0", "role": "q0" }} , 
 	{ "name": "color_1_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_1", "role": "address0" }} , 
 	{ "name": "color_1_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_1", "role": "ce0" }} , 
 	{ "name": "color_1_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_1", "role": "q0" }} , 
 	{ "name": "color_2_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_2", "role": "address0" }} , 
 	{ "name": "color_2_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_2", "role": "ce0" }} , 
 	{ "name": "color_2_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_2", "role": "q0" }} , 
 	{ "name": "eq_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "eq", "role": "address0" }} , 
 	{ "name": "eq_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "eq", "role": "ce0" }} , 
 	{ "name": "eq_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "eq", "role": "q0" }} , 
 	{ "name": "p_read", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "p_read", "role": "default" }} , 
 	{ "name": "saturation", "direction": "in", "datatype": "sc_lv", "bitwidth":14, "type": "signal", "bundle":{"name": "saturation", "role": "default" }} , 
 	{ "name": "eq_enabled", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "eq_enabled", "role": "default" }} , 
 	{ "name": "p_read1", "direction": "in", "datatype": "sc_lv", "bitwidth":22, "type": "signal", "bundle":{"name": "p_read1", "role": "default" }} , 
 	{ "name": "ret_V_loc_c_din", "direction": "out", "datatype": "sc_lv", "bitwidth":22, "type": "signal", "bundle":{"name": "ret_V_loc_c", "role": "din" }} , 
 	{ "name": "ret_V_loc_c_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "ret_V_loc_c", "role": "num_data_valid" }} , 
 	{ "name": "ret_V_loc_c_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "ret_V_loc_c", "role": "fifo_cap" }} , 
 	{ "name": "ret_V_loc_c_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "ret_V_loc_c", "role": "full_n" }} , 
 	{ "name": "ret_V_loc_c_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "ret_V_loc_c", "role": "write" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1"],
		"CDFG" : "p_anonymous_namespace_color_stage",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "173077", "EstimateLatencyMax" : "2073621",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "in_pixels", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_198_1_fu_104", "Port" : "in_pixels", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "pairs", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_198_1_fu_104", "Port" : "pairs", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "hist_pixels", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_198_1_fu_104", "Port" : "hist_pixels", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "color_0", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_198_1_fu_104", "Port" : "color_0", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "color_1", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_198_1_fu_104", "Port" : "color_1", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "color_2", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_198_1_fu_104", "Port" : "color_2", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "eq", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_198_1_fu_104", "Port" : "eq", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "p_read", "Type" : "None", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "3", "DependentChanType" : "1"},
			{"Name" : "saturation", "Type" : "None", "Direction" : "I"},
			{"Name" : "eq_enabled", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read1", "Type" : "None", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "3", "DependentChanType" : "1"},
			{"Name" : "ret_V_loc_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "ret_V_loc_c_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_198_1_fu_104", "Parent" : "0", "Child" : ["2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19"],
		"CDFG" : "p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_198_1",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "173075", "EstimateLatencyMax" : "2073619",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "p_read1", "Type" : "None", "Direction" : "I"},
			{"Name" : "in_pixels", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "in_pixels_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "color_0", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "color_1", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "color_2", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "flags_cast_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "zext_ln198", "Type" : "None", "Direction" : "I"},
			{"Name" : "tobool25_i_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "hist_pixels", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "hist_pixels_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "eq", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "eq_enabled", "Type" : "None", "Direction" : "I"},
			{"Name" : "pairs", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "pairs_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_198_1", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter18", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter18", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "2", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_198_1_fu_104.mul_8ns_9ns_16_1_1_U139", "Parent" : "1"},
	{"ID" : "3", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_198_1_fu_104.mul_8ns_8s_16_1_1_U140", "Parent" : "1"},
	{"ID" : "4", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_198_1_fu_104.mul_8ns_8s_16_1_1_U141", "Parent" : "1"},
	{"ID" : "5", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_198_1_fu_104.mac_muladd_8ns_5ns_8ns_13_4_1_U142", "Parent" : "1"},
	{"ID" : "6", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_198_1_fu_104.mac_muladd_8ns_7ns_16ns_16_4_1_U143", "Parent" : "1"},
	{"ID" : "7", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_198_1_fu_104.mac_muladd_14ns_9s_20ns_24_4_1_U144", "Parent" : "1"},
	{"ID" : "8", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_198_1_fu_104.mac_muladd_14ns_9s_20ns_24_4_1_U145", "Parent" : "1"},
	{"ID" : "9", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_198_1_fu_104.mac_muladd_14ns_9s_20ns_24_4_1_U146", "Parent" : "1"},
	{"ID" : "10", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_198_1_fu_104.mac_muladd_8ns_5ns_8ns_13_4_1_U147", "Parent" : "1"},
	{"ID" : "11", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_198_1_fu_104.mac_muladd_8ns_7s_16s_16_4_1_U148", "Parent" : "1"},
	{"ID" : "12", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_198_1_fu_104.mac_muladd_8ns_6s_16s_16_4_1_U149", "Parent" : "1"},
	{"ID" : "13", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_198_1_fu_104.mac_muladd_8ns_7ns_13ns_15_4_1_U150", "Parent" : "1"},
	{"ID" : "14", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_198_1_fu_104.mac_muladd_8ns_8ns_15ns_16_4_1_U151", "Parent" : "1"},
	{"ID" : "15", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_198_1_fu_104.mac_muladd_8s_9ns_16ns_18_4_1_U152", "Parent" : "1"},
	{"ID" : "16", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_198_1_fu_104.mac_muladd_8s_8s_16ns_18_4_1_U153", "Parent" : "1"},
	{"ID" : "17", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_198_1_fu_104.mac_muladd_8s_9ns_16ns_18_4_1_U154", "Parent" : "1"},
	{"ID" : "18", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_198_1_fu_104.mac_muladd_8s_9s_18s_18_4_1_U155", "Parent" : "1"},
	{"ID" : "19", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_198_1_fu_104.flow_control_loop_pipe_sequential_init_U", "Parent" : "1"}]}


set ArgLastReadFirstWriteLatency {
	p_anonymous_namespace_color_stage {
		in_pixels {Type I LastRead 1 FirstWrite -1}
		pairs {Type O LastRead -1 FirstWrite 18}
		hist_pixels {Type O LastRead -1 FirstWrite 18}
		color_0 {Type I LastRead 1 FirstWrite -1}
		color_1 {Type I LastRead 3 FirstWrite -1}
		color_2 {Type I LastRead 1 FirstWrite -1}
		eq {Type I LastRead 14 FirstWrite -1}
		p_read {Type I LastRead 0 FirstWrite -1}
		saturation {Type I LastRead 0 FirstWrite -1}
		eq_enabled {Type I LastRead 0 FirstWrite -1}
		p_read1 {Type I LastRead 0 FirstWrite -1}
		ret_V_loc_c {Type O LastRead -1 FirstWrite 0}}
	p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_198_1 {
		p_read1 {Type I LastRead 0 FirstWrite -1}
		in_pixels {Type I LastRead 1 FirstWrite -1}
		color_0 {Type I LastRead 1 FirstWrite -1}
		color_1 {Type I LastRead 3 FirstWrite -1}
		color_2 {Type I LastRead 1 FirstWrite -1}
		flags_cast_i {Type I LastRead 0 FirstWrite -1}
		zext_ln198 {Type I LastRead 0 FirstWrite -1}
		tobool25_i_i {Type I LastRead 0 FirstWrite -1}
		hist_pixels {Type O LastRead -1 FirstWrite 18}
		eq {Type I LastRead 14 FirstWrite -1}
		eq_enabled {Type I LastRead 0 FirstWrite -1}
		pairs {Type O LastRead -1 FirstWrite 18}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "173077", "Max" : "2073621"}
	, {"Name" : "Interval", "Min" : "173077", "Max" : "2073621"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	in_pixels { ap_fifo {  { in_pixels_dout fifo_port_we 0 24 }  { in_pixels_num_data_valid fifo_status_num_data_valid 0 7 }  { in_pixels_fifo_cap fifo_update 0 7 }  { in_pixels_empty_n fifo_status 0 1 }  { in_pixels_read fifo_data 1 1 } } }
	pairs { ap_fifo {  { pairs_din fifo_port_we 1 48 }  { pairs_num_data_valid fifo_status_num_data_valid 0 7 }  { pairs_fifo_cap fifo_update 0 7 }  { pairs_full_n fifo_status 0 1 }  { pairs_write fifo_data 1 1 } } }
	hist_pixels { ap_fifo {  { hist_pixels_din fifo_port_we 1 8 }  { hist_pixels_num_data_valid fifo_status_num_data_valid 0 7 }  { hist_pixels_fifo_cap fifo_update 0 7 }  { hist_pixels_full_n fifo_status 0 1 }  { hist_pixels_write fifo_data 1 1 } } }
	color_0 { ap_memory {  { color_0_address0 mem_address 1 8 }  { color_0_ce0 mem_ce 1 1 }  { color_0_q0 mem_dout 0 8 } } }
	color_1 { ap_memory {  { color_1_address0 mem_address 1 8 }  { color_1_ce0 mem_ce 1 1 }  { color_1_q0 mem_dout 0 8 } } }
	color_2 { ap_memory {  { color_2_address0 mem_address 1 8 }  { color_2_ce0 mem_ce 1 1 }  { color_2_q0 mem_dout 0 8 } } }
	eq { ap_memory {  { eq_address0 mem_address 1 8 }  { eq_ce0 mem_ce 1 1 }  { eq_q0 mem_dout 0 8 } } }
	p_read { ap_none {  { p_read in_data 0 2 } } }
	saturation { ap_none {  { saturation in_data 0 14 } } }
	eq_enabled { ap_none {  { eq_enabled in_data 0 1 } } }
	p_read1 { ap_none {  { p_read1 in_data 0 22 } } }
	ret_V_loc_c { ap_fifo {  { ret_V_loc_c_din fifo_port_we 1 22 }  { ret_V_loc_c_num_data_valid fifo_status_num_data_valid 0 2 }  { ret_V_loc_c_fifo_cap fifo_update 0 2 }  { ret_V_loc_c_full_n fifo_status 0 1 }  { ret_V_loc_c_write fifo_data 1 1 } } }
}
set moduleName p_anonymous_namespace_color_stage
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
set C_modelName {(anonymous namespace)color_stage}
set C_modelType { void 0 }
set C_modelArgList {
	{ in_pixels int 24 regular {fifo 0 volatile }  }
	{ pairs int 48 regular {fifo 1 volatile }  }
	{ hist_pixels int 8 regular {fifo 1 volatile }  }
	{ color_0 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ color_1 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ color_2 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ eq int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ p_read int 2 regular  }
	{ saturation int 14 regular  }
	{ eq_enabled int 1 regular  }
	{ p_read1 int 22 regular  }
	{ mul_ln1540_loc_c int 22 regular {fifo 1}  }
}
set C_modelArgMapList {[ 
	{ "Name" : "in_pixels", "interface" : "fifo", "bitwidth" : 24, "direction" : "READONLY"} , 
 	{ "Name" : "pairs", "interface" : "fifo", "bitwidth" : 48, "direction" : "WRITEONLY"} , 
 	{ "Name" : "hist_pixels", "interface" : "fifo", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "color_0", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "color_1", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "color_2", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "eq", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "p_read", "interface" : "wire", "bitwidth" : 2, "direction" : "READONLY"} , 
 	{ "Name" : "saturation", "interface" : "wire", "bitwidth" : 14, "direction" : "READONLY"} , 
 	{ "Name" : "eq_enabled", "interface" : "wire", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "p_read1", "interface" : "wire", "bitwidth" : 22, "direction" : "READONLY"} , 
 	{ "Name" : "mul_ln1540_loc_c", "interface" : "fifo", "bitwidth" : 22, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 43
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ in_pixels_dout sc_in sc_lv 24 signal 0 } 
	{ in_pixels_num_data_valid sc_in sc_lv 7 signal 0 } 
	{ in_pixels_fifo_cap sc_in sc_lv 7 signal 0 } 
	{ in_pixels_empty_n sc_in sc_logic 1 signal 0 } 
	{ in_pixels_read sc_out sc_logic 1 signal 0 } 
	{ pairs_din sc_out sc_lv 48 signal 1 } 
	{ pairs_num_data_valid sc_in sc_lv 7 signal 1 } 
	{ pairs_fifo_cap sc_in sc_lv 7 signal 1 } 
	{ pairs_full_n sc_in sc_logic 1 signal 1 } 
	{ pairs_write sc_out sc_logic 1 signal 1 } 
	{ hist_pixels_din sc_out sc_lv 8 signal 2 } 
	{ hist_pixels_num_data_valid sc_in sc_lv 7 signal 2 } 
	{ hist_pixels_fifo_cap sc_in sc_lv 7 signal 2 } 
	{ hist_pixels_full_n sc_in sc_logic 1 signal 2 } 
	{ hist_pixels_write sc_out sc_logic 1 signal 2 } 
	{ color_0_address0 sc_out sc_lv 8 signal 3 } 
	{ color_0_ce0 sc_out sc_logic 1 signal 3 } 
	{ color_0_q0 sc_in sc_lv 8 signal 3 } 
	{ color_1_address0 sc_out sc_lv 8 signal 4 } 
	{ color_1_ce0 sc_out sc_logic 1 signal 4 } 
	{ color_1_q0 sc_in sc_lv 8 signal 4 } 
	{ color_2_address0 sc_out sc_lv 8 signal 5 } 
	{ color_2_ce0 sc_out sc_logic 1 signal 5 } 
	{ color_2_q0 sc_in sc_lv 8 signal 5 } 
	{ eq_address0 sc_out sc_lv 8 signal 6 } 
	{ eq_ce0 sc_out sc_logic 1 signal 6 } 
	{ eq_q0 sc_in sc_lv 8 signal 6 } 
	{ p_read sc_in sc_lv 2 signal 7 } 
	{ saturation sc_in sc_lv 14 signal 8 } 
	{ eq_enabled sc_in sc_lv 1 signal 9 } 
	{ p_read1 sc_in sc_lv 22 signal 10 } 
	{ mul_ln1540_loc_c_din sc_out sc_lv 22 signal 11 } 
	{ mul_ln1540_loc_c_num_data_valid sc_in sc_lv 2 signal 11 } 
	{ mul_ln1540_loc_c_fifo_cap sc_in sc_lv 2 signal 11 } 
	{ mul_ln1540_loc_c_full_n sc_in sc_logic 1 signal 11 } 
	{ mul_ln1540_loc_c_write sc_out sc_logic 1 signal 11 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "in_pixels_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":24, "type": "signal", "bundle":{"name": "in_pixels", "role": "dout" }} , 
 	{ "name": "in_pixels_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "in_pixels", "role": "num_data_valid" }} , 
 	{ "name": "in_pixels_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "in_pixels", "role": "fifo_cap" }} , 
 	{ "name": "in_pixels_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "in_pixels", "role": "empty_n" }} , 
 	{ "name": "in_pixels_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "in_pixels", "role": "read" }} , 
 	{ "name": "pairs_din", "direction": "out", "datatype": "sc_lv", "bitwidth":48, "type": "signal", "bundle":{"name": "pairs", "role": "din" }} , 
 	{ "name": "pairs_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "pairs", "role": "num_data_valid" }} , 
 	{ "name": "pairs_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "pairs", "role": "fifo_cap" }} , 
 	{ "name": "pairs_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "pairs", "role": "full_n" }} , 
 	{ "name": "pairs_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "pairs", "role": "write" }} , 
 	{ "name": "hist_pixels_din", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "hist_pixels", "role": "din" }} , 
 	{ "name": "hist_pixels_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "hist_pixels", "role": "num_data_valid" }} , 
 	{ "name": "hist_pixels_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "hist_pixels", "role": "fifo_cap" }} , 
 	{ "name": "hist_pixels_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist_pixels", "role": "full_n" }} , 
 	{ "name": "hist_pixels_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist_pixels", "role": "write" }} , 
 	{ "name": "color_0_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_0", "role": "address0" }} , 
 	{ "name": "color_0_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_0", "role": "ce0" }} , 
 	{ "name": "color_0_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_0", "role": "q0" }} , 
 	{ "name": "color_1_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_1", "role": "address0" }} , 
 	{ "name": "color_1_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_1", "role": "ce0" }} , 
 	{ "name": "color_1_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_1", "role": "q0" }} , 
 	{ "name": "color_2_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_2", "role": "address0" }} , 
 	{ "name": "color_2_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_2", "role": "ce0" }} , 
 	{ "name": "color_2_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_2", "role": "q0" }} , 
 	{ "name": "eq_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "eq", "role": "address0" }} , 
 	{ "name": "eq_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "eq", "role": "ce0" }} , 
 	{ "name": "eq_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "eq", "role": "q0" }} , 
 	{ "name": "p_read", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "p_read", "role": "default" }} , 
 	{ "name": "saturation", "direction": "in", "datatype": "sc_lv", "bitwidth":14, "type": "signal", "bundle":{"name": "saturation", "role": "default" }} , 
 	{ "name": "eq_enabled", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "eq_enabled", "role": "default" }} , 
 	{ "name": "p_read1", "direction": "in", "datatype": "sc_lv", "bitwidth":22, "type": "signal", "bundle":{"name": "p_read1", "role": "default" }} , 
 	{ "name": "mul_ln1540_loc_c_din", "direction": "out", "datatype": "sc_lv", "bitwidth":22, "type": "signal", "bundle":{"name": "mul_ln1540_loc_c", "role": "din" }} , 
 	{ "name": "mul_ln1540_loc_c_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "mul_ln1540_loc_c", "role": "num_data_valid" }} , 
 	{ "name": "mul_ln1540_loc_c_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "mul_ln1540_loc_c", "role": "fifo_cap" }} , 
 	{ "name": "mul_ln1540_loc_c_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mul_ln1540_loc_c", "role": "full_n" }} , 
 	{ "name": "mul_ln1540_loc_c_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mul_ln1540_loc_c", "role": "write" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1"],
		"CDFG" : "p_anonymous_namespace_color_stage",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "173076", "EstimateLatencyMax" : "2073620",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "in_pixels", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_223_1_fu_104", "Port" : "in_pixels", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "pairs", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_223_1_fu_104", "Port" : "pairs", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "hist_pixels", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_223_1_fu_104", "Port" : "hist_pixels", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "color_0", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_223_1_fu_104", "Port" : "color_0", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "color_1", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_223_1_fu_104", "Port" : "color_1", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "color_2", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_223_1_fu_104", "Port" : "color_2", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "eq", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_223_1_fu_104", "Port" : "eq", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "p_read", "Type" : "None", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "3", "DependentChanType" : "1"},
			{"Name" : "saturation", "Type" : "None", "Direction" : "I"},
			{"Name" : "eq_enabled", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read1", "Type" : "None", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "3", "DependentChanType" : "1"},
			{"Name" : "mul_ln1540_loc_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "mul_ln1540_loc_c_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_223_1_fu_104", "Parent" : "0", "Child" : ["2", "3", "4", "5", "6", "7", "8", "9", "10"],
		"CDFG" : "p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_223_1",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "173074", "EstimateLatencyMax" : "2073618",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "p_read1", "Type" : "None", "Direction" : "I"},
			{"Name" : "in_pixels", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "in_pixels_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "color_0", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "color_1", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "color_2", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "flags_cast_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "zext_ln1540", "Type" : "None", "Direction" : "I"},
			{"Name" : "tobool31_i_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "hist_pixels", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "hist_pixels_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "eq", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "eq_enabled", "Type" : "None", "Direction" : "I"},
			{"Name" : "pairs", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "pairs_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_223_1", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter17", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter17", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "2", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_223_1_fu_104.mac_muladd_8ns_8ns_15s_17_4_1_U136", "Parent" : "1"},
	{"ID" : "3", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_223_1_fu_104.mac_muladd_8ns_7ns_17s_18_4_1_U137", "Parent" : "1"},
	{"ID" : "4", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_223_1_fu_104.mac_muladd_14ns_10s_22s_25_4_1_U138", "Parent" : "1"},
	{"ID" : "5", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_223_1_fu_104.mac_muladd_14ns_10s_22s_25_4_1_U139", "Parent" : "1"},
	{"ID" : "6", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_223_1_fu_104.mac_muladd_14ns_10s_22s_25_4_1_U140", "Parent" : "1"},
	{"ID" : "7", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_223_1_fu_104.mac_muladd_9s_9ns_14s_17_4_1_U141", "Parent" : "1"},
	{"ID" : "8", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_223_1_fu_104.mac_muladd_9s_8ns_14s_16_4_1_U142", "Parent" : "1"},
	{"ID" : "9", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_223_1_fu_104.mac_muladd_9s_9ns_15s_17_4_1_U143", "Parent" : "1"},
	{"ID" : "10", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_223_1_fu_104.flow_control_loop_pipe_sequential_init_U", "Parent" : "1"}]}


set ArgLastReadFirstWriteLatency {
	p_anonymous_namespace_color_stage {
		in_pixels {Type I LastRead 1 FirstWrite -1}
		pairs {Type O LastRead -1 FirstWrite 17}
		hist_pixels {Type O LastRead -1 FirstWrite 17}
		color_0 {Type I LastRead 3 FirstWrite -1}
		color_1 {Type I LastRead 1 FirstWrite -1}
		color_2 {Type I LastRead 2 FirstWrite -1}
		eq {Type I LastRead 15 FirstWrite -1}
		p_read {Type I LastRead 0 FirstWrite -1}
		saturation {Type I LastRead 0 FirstWrite -1}
		eq_enabled {Type I LastRead 0 FirstWrite -1}
		p_read1 {Type I LastRead 0 FirstWrite -1}
		mul_ln1540_loc_c {Type O LastRead -1 FirstWrite 0}}
	p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_223_1 {
		p_read1 {Type I LastRead 0 FirstWrite -1}
		in_pixels {Type I LastRead 1 FirstWrite -1}
		color_0 {Type I LastRead 3 FirstWrite -1}
		color_1 {Type I LastRead 1 FirstWrite -1}
		color_2 {Type I LastRead 2 FirstWrite -1}
		flags_cast_i {Type I LastRead 0 FirstWrite -1}
		zext_ln1540 {Type I LastRead 0 FirstWrite -1}
		tobool31_i_i {Type I LastRead 0 FirstWrite -1}
		hist_pixels {Type O LastRead -1 FirstWrite 17}
		eq {Type I LastRead 15 FirstWrite -1}
		eq_enabled {Type I LastRead 0 FirstWrite -1}
		pairs {Type O LastRead -1 FirstWrite 17}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "173076", "Max" : "2073620"}
	, {"Name" : "Interval", "Min" : "173076", "Max" : "2073620"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	in_pixels { ap_fifo {  { in_pixels_dout fifo_port_we 0 24 }  { in_pixels_num_data_valid fifo_status_num_data_valid 0 7 }  { in_pixels_fifo_cap fifo_update 0 7 }  { in_pixels_empty_n fifo_status 0 1 }  { in_pixels_read fifo_data 1 1 } } }
	pairs { ap_fifo {  { pairs_din fifo_port_we 1 48 }  { pairs_num_data_valid fifo_status_num_data_valid 0 7 }  { pairs_fifo_cap fifo_update 0 7 }  { pairs_full_n fifo_status 0 1 }  { pairs_write fifo_data 1 1 } } }
	hist_pixels { ap_fifo {  { hist_pixels_din fifo_port_we 1 8 }  { hist_pixels_num_data_valid fifo_status_num_data_valid 0 7 }  { hist_pixels_fifo_cap fifo_update 0 7 }  { hist_pixels_full_n fifo_status 0 1 }  { hist_pixels_write fifo_data 1 1 } } }
	color_0 { ap_memory {  { color_0_address0 mem_address 1 8 }  { color_0_ce0 mem_ce 1 1 }  { color_0_q0 mem_dout 0 8 } } }
	color_1 { ap_memory {  { color_1_address0 mem_address 1 8 }  { color_1_ce0 mem_ce 1 1 }  { color_1_q0 mem_dout 0 8 } } }
	color_2 { ap_memory {  { color_2_address0 mem_address 1 8 }  { color_2_ce0 mem_ce 1 1 }  { color_2_q0 mem_dout 0 8 } } }
	eq { ap_memory {  { eq_address0 mem_address 1 8 }  { eq_ce0 mem_ce 1 1 }  { eq_q0 mem_dout 0 8 } } }
	p_read { ap_none {  { p_read in_data 0 2 } } }
	saturation { ap_none {  { saturation in_data 0 14 } } }
	eq_enabled { ap_none {  { eq_enabled in_data 0 1 } } }
	p_read1 { ap_none {  { p_read1 in_data 0 22 } } }
	mul_ln1540_loc_c { ap_fifo {  { mul_ln1540_loc_c_din fifo_port_we 1 22 }  { mul_ln1540_loc_c_num_data_valid fifo_status_num_data_valid 0 2 }  { mul_ln1540_loc_c_fifo_cap fifo_update 0 2 }  { mul_ln1540_loc_c_full_n fifo_status 0 1 }  { mul_ln1540_loc_c_write fifo_data 1 1 } } }
}
set moduleName p_anonymous_namespace_color_stage
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
set C_modelName {(anonymous namespace)color_stage}
set C_modelType { void 0 }
set C_modelArgList {
	{ in_pixels int 24 regular {fifo 0 volatile }  }
	{ pairs int 48 regular {fifo 1 volatile }  }
	{ hist_pixels int 8 regular {fifo 1 volatile }  }
	{ color_0 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ color_1 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ color_2 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ eq int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ p_read int 2 regular  }
	{ saturation int 14 regular  }
	{ eq_enabled int 1 regular  }
	{ p_read1 int 22 regular  }
	{ mul_ln1540_loc_c int 22 regular {fifo 1}  }
}
set C_modelArgMapList {[ 
	{ "Name" : "in_pixels", "interface" : "fifo", "bitwidth" : 24, "direction" : "READONLY"} , 
 	{ "Name" : "pairs", "interface" : "fifo", "bitwidth" : 48, "direction" : "WRITEONLY"} , 
 	{ "Name" : "hist_pixels", "interface" : "fifo", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "color_0", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "color_1", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "color_2", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "eq", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "p_read", "interface" : "wire", "bitwidth" : 2, "direction" : "READONLY"} , 
 	{ "Name" : "saturation", "interface" : "wire", "bitwidth" : 14, "direction" : "READONLY"} , 
 	{ "Name" : "eq_enabled", "interface" : "wire", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "p_read1", "interface" : "wire", "bitwidth" : 22, "direction" : "READONLY"} , 
 	{ "Name" : "mul_ln1540_loc_c", "interface" : "fifo", "bitwidth" : 22, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 43
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ in_pixels_dout sc_in sc_lv 24 signal 0 } 
	{ in_pixels_num_data_valid sc_in sc_lv 7 signal 0 } 
	{ in_pixels_fifo_cap sc_in sc_lv 7 signal 0 } 
	{ in_pixels_empty_n sc_in sc_logic 1 signal 0 } 
	{ in_pixels_read sc_out sc_logic 1 signal 0 } 
	{ pairs_din sc_out sc_lv 48 signal 1 } 
	{ pairs_num_data_valid sc_in sc_lv 7 signal 1 } 
	{ pairs_fifo_cap sc_in sc_lv 7 signal 1 } 
	{ pairs_full_n sc_in sc_logic 1 signal 1 } 
	{ pairs_write sc_out sc_logic 1 signal 1 } 
	{ hist_pixels_din sc_out sc_lv 8 signal 2 } 
	{ hist_pixels_num_data_valid sc_in sc_lv 7 signal 2 } 
	{ hist_pixels_fifo_cap sc_in sc_lv 7 signal 2 } 
	{ hist_pixels_full_n sc_in sc_logic 1 signal 2 } 
	{ hist_pixels_write sc_out sc_logic 1 signal 2 } 
	{ color_0_address0 sc_out sc_lv 8 signal 3 } 
	{ color_0_ce0 sc_out sc_logic 1 signal 3 } 
	{ color_0_q0 sc_in sc_lv 8 signal 3 } 
	{ color_1_address0 sc_out sc_lv 8 signal 4 } 
	{ color_1_ce0 sc_out sc_logic 1 signal 4 } 
	{ color_1_q0 sc_in sc_lv 8 signal 4 } 
	{ color_2_address0 sc_out sc_lv 8 signal 5 } 
	{ color_2_ce0 sc_out sc_logic 1 signal 5 } 
	{ color_2_q0 sc_in sc_lv 8 signal 5 } 
	{ eq_address0 sc_out sc_lv 8 signal 6 } 
	{ eq_ce0 sc_out sc_logic 1 signal 6 } 
	{ eq_q0 sc_in sc_lv 8 signal 6 } 
	{ p_read sc_in sc_lv 2 signal 7 } 
	{ saturation sc_in sc_lv 14 signal 8 } 
	{ eq_enabled sc_in sc_lv 1 signal 9 } 
	{ p_read1 sc_in sc_lv 22 signal 10 } 
	{ mul_ln1540_loc_c_din sc_out sc_lv 22 signal 11 } 
	{ mul_ln1540_loc_c_num_data_valid sc_in sc_lv 2 signal 11 } 
	{ mul_ln1540_loc_c_fifo_cap sc_in sc_lv 2 signal 11 } 
	{ mul_ln1540_loc_c_full_n sc_in sc_logic 1 signal 11 } 
	{ mul_ln1540_loc_c_write sc_out sc_logic 1 signal 11 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "in_pixels_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":24, "type": "signal", "bundle":{"name": "in_pixels", "role": "dout" }} , 
 	{ "name": "in_pixels_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "in_pixels", "role": "num_data_valid" }} , 
 	{ "name": "in_pixels_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "in_pixels", "role": "fifo_cap" }} , 
 	{ "name": "in_pixels_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "in_pixels", "role": "empty_n" }} , 
 	{ "name": "in_pixels_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "in_pixels", "role": "read" }} , 
 	{ "name": "pairs_din", "direction": "out", "datatype": "sc_lv", "bitwidth":48, "type": "signal", "bundle":{"name": "pairs", "role": "din" }} , 
 	{ "name": "pairs_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "pairs", "role": "num_data_valid" }} , 
 	{ "name": "pairs_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "pairs", "role": "fifo_cap" }} , 
 	{ "name": "pairs_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "pairs", "role": "full_n" }} , 
 	{ "name": "pairs_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "pairs", "role": "write" }} , 
 	{ "name": "hist_pixels_din", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "hist_pixels", "role": "din" }} , 
 	{ "name": "hist_pixels_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "hist_pixels", "role": "num_data_valid" }} , 
 	{ "name": "hist_pixels_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "hist_pixels", "role": "fifo_cap" }} , 
 	{ "name": "hist_pixels_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist_pixels", "role": "full_n" }} , 
 	{ "name": "hist_pixels_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist_pixels", "role": "write" }} , 
 	{ "name": "color_0_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_0", "role": "address0" }} , 
 	{ "name": "color_0_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_0", "role": "ce0" }} , 
 	{ "name": "color_0_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_0", "role": "q0" }} , 
 	{ "name": "color_1_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_1", "role": "address0" }} , 
 	{ "name": "color_1_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_1", "role": "ce0" }} , 
 	{ "name": "color_1_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_1", "role": "q0" }} , 
 	{ "name": "color_2_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_2", "role": "address0" }} , 
 	{ "name": "color_2_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_2", "role": "ce0" }} , 
 	{ "name": "color_2_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_2", "role": "q0" }} , 
 	{ "name": "eq_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "eq", "role": "address0" }} , 
 	{ "name": "eq_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "eq", "role": "ce0" }} , 
 	{ "name": "eq_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "eq", "role": "q0" }} , 
 	{ "name": "p_read", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "p_read", "role": "default" }} , 
 	{ "name": "saturation", "direction": "in", "datatype": "sc_lv", "bitwidth":14, "type": "signal", "bundle":{"name": "saturation", "role": "default" }} , 
 	{ "name": "eq_enabled", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "eq_enabled", "role": "default" }} , 
 	{ "name": "p_read1", "direction": "in", "datatype": "sc_lv", "bitwidth":22, "type": "signal", "bundle":{"name": "p_read1", "role": "default" }} , 
 	{ "name": "mul_ln1540_loc_c_din", "direction": "out", "datatype": "sc_lv", "bitwidth":22, "type": "signal", "bundle":{"name": "mul_ln1540_loc_c", "role": "din" }} , 
 	{ "name": "mul_ln1540_loc_c_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "mul_ln1540_loc_c", "role": "num_data_valid" }} , 
 	{ "name": "mul_ln1540_loc_c_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "mul_ln1540_loc_c", "role": "fifo_cap" }} , 
 	{ "name": "mul_ln1540_loc_c_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mul_ln1540_loc_c", "role": "full_n" }} , 
 	{ "name": "mul_ln1540_loc_c_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mul_ln1540_loc_c", "role": "write" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1"],
		"CDFG" : "p_anonymous_namespace_color_stage",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "173076", "EstimateLatencyMax" : "2073620",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "in_pixels", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_238_1_fu_104", "Port" : "in_pixels", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "pairs", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_238_1_fu_104", "Port" : "pairs", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "hist_pixels", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_238_1_fu_104", "Port" : "hist_pixels", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "color_0", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_238_1_fu_104", "Port" : "color_0", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "color_1", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_238_1_fu_104", "Port" : "color_1", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "color_2", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_238_1_fu_104", "Port" : "color_2", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "eq", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_238_1_fu_104", "Port" : "eq", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "p_read", "Type" : "None", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "3", "DependentChanType" : "1"},
			{"Name" : "saturation", "Type" : "None", "Direction" : "I"},
			{"Name" : "eq_enabled", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read1", "Type" : "None", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "3", "DependentChanType" : "1"},
			{"Name" : "mul_ln1540_loc_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "mul_ln1540_loc_c_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_238_1_fu_104", "Parent" : "0", "Child" : ["2", "3", "4", "5", "6", "7", "8", "9", "10"],
		"CDFG" : "p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_238_1",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "173074", "EstimateLatencyMax" : "2073618",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "p_read1", "Type" : "None", "Direction" : "I"},
			{"Name" : "in_pixels", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "in_pixels_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "color_0", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "color_1", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "color_2", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "flags_cast_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "zext_ln1540", "Type" : "None", "Direction" : "I"},
			{"Name" : "tobool31_i_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "hist_pixels", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "hist_pixels_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "eq", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "eq_enabled", "Type" : "None", "Direction" : "I"},
			{"Name" : "pairs", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "pairs_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_238_1", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter17", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter17", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "2", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_238_1_fu_104.mac_muladd_8ns_8ns_15s_17_4_1_U132", "Parent" : "1"},
	{"ID" : "3", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_238_1_fu_104.mac_muladd_8ns_7ns_17s_18_4_1_U133", "Parent" : "1"},
	{"ID" : "4", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_238_1_fu_104.mac_muladd_14ns_10s_22s_25_4_1_U134", "Parent" : "1"},
	{"ID" : "5", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_238_1_fu_104.mac_muladd_14ns_10s_22s_25_4_1_U135", "Parent" : "1"},
	{"ID" : "6", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_238_1_fu_104.mac_muladd_14ns_10s_22s_25_4_1_U136", "Parent" : "1"},
	{"ID" : "7", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_238_1_fu_104.mac_muladd_9s_9ns_14s_17_4_1_U137", "Parent" : "1"},
	{"ID" : "8", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_238_1_fu_104.mac_muladd_9s_8ns_14s_16_4_1_U138", "Parent" : "1"},
	{"ID" : "9", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_238_1_fu_104.mac_muladd_9s_9ns_15s_17_4_1_U139", "Parent" : "1"},
	{"ID" : "10", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_238_1_fu_104.flow_control_loop_pipe_sequential_init_U", "Parent" : "1"}]}


set ArgLastReadFirstWriteLatency {
	p_anonymous_namespace_color_stage {
		in_pixels {Type I LastRead 1 FirstWrite -1}
		pairs {Type O LastRead -1 FirstWrite 17}
		hist_pixels {Type O LastRead -1 FirstWrite 17}
		color_0 {Type I LastRead 3 FirstWrite -1}
		color_1 {Type I LastRead 1 FirstWrite -1}
		color_2 {Type I LastRead 2 FirstWrite -1}
		eq {Type I LastRead 15 FirstWrite -1}
		p_read {Type I LastRead 0 FirstWrite -1}
		saturation {Type I LastRead 0 FirstWrite -1}
		eq_enabled {Type I LastRead 0 FirstWrite -1}
		p_read1 {Type I LastRead 0 FirstWrite -1}
		mul_ln1540_loc_c {Type O LastRead -1 FirstWrite 0}}
	p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_238_1 {
		p_read1 {Type I LastRead 0 FirstWrite -1}
		in_pixels {Type I LastRead 1 FirstWrite -1}
		color_0 {Type I LastRead 3 FirstWrite -1}
		color_1 {Type I LastRead 1 FirstWrite -1}
		color_2 {Type I LastRead 2 FirstWrite -1}
		flags_cast_i {Type I LastRead 0 FirstWrite -1}
		zext_ln1540 {Type I LastRead 0 FirstWrite -1}
		tobool31_i_i {Type I LastRead 0 FirstWrite -1}
		hist_pixels {Type O LastRead -1 FirstWrite 17}
		eq {Type I LastRead 15 FirstWrite -1}
		eq_enabled {Type I LastRead 0 FirstWrite -1}
		pairs {Type O LastRead -1 FirstWrite 17}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "173076", "Max" : "2073620"}
	, {"Name" : "Interval", "Min" : "173076", "Max" : "2073620"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	in_pixels { ap_fifo {  { in_pixels_dout fifo_port_we 0 24 }  { in_pixels_num_data_valid fifo_status_num_data_valid 0 7 }  { in_pixels_fifo_cap fifo_update 0 7 }  { in_pixels_empty_n fifo_status 0 1 }  { in_pixels_read fifo_data 1 1 } } }
	pairs { ap_fifo {  { pairs_din fifo_port_we 1 48 }  { pairs_num_data_valid fifo_status_num_data_valid 0 7 }  { pairs_fifo_cap fifo_update 0 7 }  { pairs_full_n fifo_status 0 1 }  { pairs_write fifo_data 1 1 } } }
	hist_pixels { ap_fifo {  { hist_pixels_din fifo_port_we 1 8 }  { hist_pixels_num_data_valid fifo_status_num_data_valid 0 7 }  { hist_pixels_fifo_cap fifo_update 0 7 }  { hist_pixels_full_n fifo_status 0 1 }  { hist_pixels_write fifo_data 1 1 } } }
	color_0 { ap_memory {  { color_0_address0 mem_address 1 8 }  { color_0_ce0 mem_ce 1 1 }  { color_0_q0 mem_dout 0 8 } } }
	color_1 { ap_memory {  { color_1_address0 mem_address 1 8 }  { color_1_ce0 mem_ce 1 1 }  { color_1_q0 mem_dout 0 8 } } }
	color_2 { ap_memory {  { color_2_address0 mem_address 1 8 }  { color_2_ce0 mem_ce 1 1 }  { color_2_q0 mem_dout 0 8 } } }
	eq { ap_memory {  { eq_address0 mem_address 1 8 }  { eq_ce0 mem_ce 1 1 }  { eq_q0 mem_dout 0 8 } } }
	p_read { ap_none {  { p_read in_data 0 2 } } }
	saturation { ap_none {  { saturation in_data 0 14 } } }
	eq_enabled { ap_none {  { eq_enabled in_data 0 1 } } }
	p_read1 { ap_none {  { p_read1 in_data 0 22 } } }
	mul_ln1540_loc_c { ap_fifo {  { mul_ln1540_loc_c_din fifo_port_we 1 22 }  { mul_ln1540_loc_c_num_data_valid fifo_status_num_data_valid 0 2 }  { mul_ln1540_loc_c_fifo_cap fifo_update 0 2 }  { mul_ln1540_loc_c_full_n fifo_status 0 1 }  { mul_ln1540_loc_c_write fifo_data 1 1 } } }
}
