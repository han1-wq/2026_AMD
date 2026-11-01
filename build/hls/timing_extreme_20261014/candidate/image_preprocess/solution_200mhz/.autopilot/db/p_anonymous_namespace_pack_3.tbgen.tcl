set moduleName p_anonymous_namespace_pack_3
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
set C_modelName {(anonymous namespace)pack.3}
set C_modelType { void 0 }
set C_modelArgList {
	{ preview_pixels int 24 regular {fifo 0 volatile }  }
	{ preview_words int 128 regular {fifo 1 volatile }  }
	{ width int 32 regular {fifo 0}  }
	{ height int 32 regular {fifo 0}  }
	{ p_read int 1 regular  }
	{ width_c int 32 regular {fifo 1}  }
	{ height_c int 32 regular {fifo 1}  }
	{ icmp_ln483_loc_c int 1 regular {fifo 1}  }
}
set C_modelArgMapList {[ 
	{ "Name" : "preview_pixels", "interface" : "fifo", "bitwidth" : 24, "direction" : "READONLY"} , 
 	{ "Name" : "preview_words", "interface" : "fifo", "bitwidth" : 128, "direction" : "WRITEONLY"} , 
 	{ "Name" : "width", "interface" : "fifo", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "height", "interface" : "fifo", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "p_read", "interface" : "wire", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "width_c", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY"} , 
 	{ "Name" : "height_c", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY"} , 
 	{ "Name" : "icmp_ln483_loc_c", "interface" : "fifo", "bitwidth" : 1, "direction" : "WRITEONLY"} ]}
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
	{ preview_pixels_dout sc_in sc_lv 24 signal 0 } 
	{ preview_pixels_num_data_valid sc_in sc_lv 7 signal 0 } 
	{ preview_pixels_fifo_cap sc_in sc_lv 7 signal 0 } 
	{ preview_pixels_empty_n sc_in sc_logic 1 signal 0 } 
	{ preview_pixels_read sc_out sc_logic 1 signal 0 } 
	{ preview_words_din sc_out sc_lv 128 signal 1 } 
	{ preview_words_num_data_valid sc_in sc_lv 7 signal 1 } 
	{ preview_words_fifo_cap sc_in sc_lv 7 signal 1 } 
	{ preview_words_full_n sc_in sc_logic 1 signal 1 } 
	{ preview_words_write sc_out sc_logic 1 signal 1 } 
	{ width_dout sc_in sc_lv 32 signal 2 } 
	{ width_num_data_valid sc_in sc_lv 3 signal 2 } 
	{ width_fifo_cap sc_in sc_lv 3 signal 2 } 
	{ width_empty_n sc_in sc_logic 1 signal 2 } 
	{ width_read sc_out sc_logic 1 signal 2 } 
	{ height_dout sc_in sc_lv 32 signal 3 } 
	{ height_num_data_valid sc_in sc_lv 3 signal 3 } 
	{ height_fifo_cap sc_in sc_lv 3 signal 3 } 
	{ height_empty_n sc_in sc_logic 1 signal 3 } 
	{ height_read sc_out sc_logic 1 signal 3 } 
	{ p_read sc_in sc_lv 1 signal 4 } 
	{ width_c_din sc_out sc_lv 32 signal 5 } 
	{ width_c_num_data_valid sc_in sc_lv 2 signal 5 } 
	{ width_c_fifo_cap sc_in sc_lv 2 signal 5 } 
	{ width_c_full_n sc_in sc_logic 1 signal 5 } 
	{ width_c_write sc_out sc_logic 1 signal 5 } 
	{ height_c_din sc_out sc_lv 32 signal 6 } 
	{ height_c_num_data_valid sc_in sc_lv 2 signal 6 } 
	{ height_c_fifo_cap sc_in sc_lv 2 signal 6 } 
	{ height_c_full_n sc_in sc_logic 1 signal 6 } 
	{ height_c_write sc_out sc_logic 1 signal 6 } 
	{ icmp_ln483_loc_c_din sc_out sc_lv 1 signal 7 } 
	{ icmp_ln483_loc_c_num_data_valid sc_in sc_lv 2 signal 7 } 
	{ icmp_ln483_loc_c_fifo_cap sc_in sc_lv 2 signal 7 } 
	{ icmp_ln483_loc_c_full_n sc_in sc_logic 1 signal 7 } 
	{ icmp_ln483_loc_c_write sc_out sc_logic 1 signal 7 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
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
 	{ "name": "width_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "width", "role": "dout" }} , 
 	{ "name": "width_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "width", "role": "num_data_valid" }} , 
 	{ "name": "width_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "width", "role": "fifo_cap" }} , 
 	{ "name": "width_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "width", "role": "empty_n" }} , 
 	{ "name": "width_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "width", "role": "read" }} , 
 	{ "name": "height_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "height", "role": "dout" }} , 
 	{ "name": "height_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "height", "role": "num_data_valid" }} , 
 	{ "name": "height_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "height", "role": "fifo_cap" }} , 
 	{ "name": "height_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "height", "role": "empty_n" }} , 
 	{ "name": "height_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "height", "role": "read" }} , 
 	{ "name": "p_read", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "p_read", "role": "default" }} , 
 	{ "name": "width_c_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "width_c", "role": "din" }} , 
 	{ "name": "width_c_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "width_c", "role": "num_data_valid" }} , 
 	{ "name": "width_c_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "width_c", "role": "fifo_cap" }} , 
 	{ "name": "width_c_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "width_c", "role": "full_n" }} , 
 	{ "name": "width_c_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "width_c", "role": "write" }} , 
 	{ "name": "height_c_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "height_c", "role": "din" }} , 
 	{ "name": "height_c_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "height_c", "role": "num_data_valid" }} , 
 	{ "name": "height_c_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "height_c", "role": "fifo_cap" }} , 
 	{ "name": "height_c_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "height_c", "role": "full_n" }} , 
 	{ "name": "height_c_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "height_c", "role": "write" }} , 
 	{ "name": "icmp_ln483_loc_c_din", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "icmp_ln483_loc_c", "role": "din" }} , 
 	{ "name": "icmp_ln483_loc_c_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "icmp_ln483_loc_c", "role": "num_data_valid" }} , 
 	{ "name": "icmp_ln483_loc_c_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "icmp_ln483_loc_c", "role": "fifo_cap" }} , 
 	{ "name": "icmp_ln483_loc_c_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "icmp_ln483_loc_c", "role": "full_n" }} , 
 	{ "name": "icmp_ln483_loc_c_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "icmp_ln483_loc_c", "role": "write" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1"],
		"CDFG" : "p_anonymous_namespace_pack_3",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "1", "EstimateLatencyMax" : "2080081",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "preview_pixels", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_pack_3_Pipeline_VITIS_LOOP_423_2_fu_127", "Port" : "preview_pixels", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "preview_words", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "preview_words_blk_n", "Type" : "RtlSignal"}],
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_pack_3_Pipeline_VITIS_LOOP_423_2_fu_127", "Port" : "preview_words", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "width", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "4", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "width_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "height", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "4", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "height_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "p_read", "Type" : "None", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "5", "DependentChanType" : "1"},
			{"Name" : "width_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "width_c_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "height_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "height_c_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "icmp_ln483_loc_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "icmp_ln483_loc_c_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_419_1", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "4", "FirstState" : "ap_ST_fsm_state2", "LastState" : ["ap_ST_fsm_state4"], "QuitState" : ["ap_ST_fsm_state2"], "PreState" : ["ap_ST_fsm_state1"], "PostState" : ["ap_ST_fsm_state1"], "OneDepthLoop" : "0", "OneStateBlock": ""}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_pack_3_Pipeline_VITIS_LOOP_423_2_fu_127", "Parent" : "0", "Child" : ["2"],
		"CDFG" : "p_anonymous_namespace_pack_3_Pipeline_VITIS_LOOP_423_2",
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
			{"Name" : "VITIS_LOOP_423_2", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter2", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "2", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_pack_3_Pipeline_VITIS_LOOP_423_2_fu_127.flow_control_loop_pipe_sequential_init_U", "Parent" : "1"}]}


set ArgLastReadFirstWriteLatency {
	p_anonymous_namespace_pack_3 {
		preview_pixels {Type I LastRead 1 FirstWrite -1}
		preview_words {Type O LastRead -1 FirstWrite 2}
		width {Type I LastRead 0 FirstWrite -1}
		height {Type I LastRead 0 FirstWrite -1}
		p_read {Type I LastRead 0 FirstWrite -1}
		width_c {Type O LastRead -1 FirstWrite 0}
		height_c {Type O LastRead -1 FirstWrite 0}
		icmp_ln483_loc_c {Type O LastRead -1 FirstWrite 0}}
	p_anonymous_namespace_pack_3_Pipeline_VITIS_LOOP_423_2 {
		width_load {Type I LastRead 0 FirstWrite -1}
		preview_pixels {Type I LastRead 1 FirstWrite -1}
		preview_words {Type O LastRead -1 FirstWrite 2}
		bits_6_out {Type O LastRead -1 FirstWrite 1}
		reservoir_V_out {Type O LastRead -1 FirstWrite 1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "1", "Max" : "2080081"}
	, {"Name" : "Interval", "Min" : "1", "Max" : "2080081"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	preview_pixels { ap_fifo {  { preview_pixels_dout fifo_port_we 0 24 }  { preview_pixels_num_data_valid fifo_status_num_data_valid 0 7 }  { preview_pixels_fifo_cap fifo_update 0 7 }  { preview_pixels_empty_n fifo_status 0 1 }  { preview_pixels_read fifo_data 1 1 } } }
	preview_words { ap_fifo {  { preview_words_din fifo_port_we 1 128 }  { preview_words_num_data_valid fifo_status_num_data_valid 0 7 }  { preview_words_fifo_cap fifo_update 0 7 }  { preview_words_full_n fifo_status 0 1 }  { preview_words_write fifo_data 1 1 } } }
	width { ap_fifo {  { width_dout fifo_port_we 0 32 }  { width_num_data_valid fifo_status_num_data_valid 0 3 }  { width_fifo_cap fifo_update 0 3 }  { width_empty_n fifo_status 0 1 }  { width_read fifo_data 1 1 } } }
	height { ap_fifo {  { height_dout fifo_port_we 0 32 }  { height_num_data_valid fifo_status_num_data_valid 0 3 }  { height_fifo_cap fifo_update 0 3 }  { height_empty_n fifo_status 0 1 }  { height_read fifo_data 1 1 } } }
	p_read { ap_none {  { p_read in_data 0 1 } } }
	width_c { ap_fifo {  { width_c_din fifo_port_we 1 32 }  { width_c_num_data_valid fifo_status_num_data_valid 0 2 }  { width_c_fifo_cap fifo_update 0 2 }  { width_c_full_n fifo_status 0 1 }  { width_c_write fifo_data 1 1 } } }
	height_c { ap_fifo {  { height_c_din fifo_port_we 1 32 }  { height_c_num_data_valid fifo_status_num_data_valid 0 2 }  { height_c_fifo_cap fifo_update 0 2 }  { height_c_full_n fifo_status 0 1 }  { height_c_write fifo_data 1 1 } } }
	icmp_ln483_loc_c { ap_fifo {  { icmp_ln483_loc_c_din fifo_port_we 1 1 }  { icmp_ln483_loc_c_num_data_valid fifo_status_num_data_valid 0 2 }  { icmp_ln483_loc_c_fifo_cap fifo_update 0 2 }  { icmp_ln483_loc_c_full_n fifo_status 0 1 }  { icmp_ln483_loc_c_write fifo_data 1 1 } } }
}
