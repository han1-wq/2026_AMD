set moduleName p_anonymous_namespace_pack
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
set C_modelName {(anonymous namespace)pack}
set C_modelType { void 0 }
set C_modelArgList {
	{ tensor_pixels int 24 regular {fifo 0 volatile }  }
	{ tensor_words int 128 regular {fifo 1 volatile }  }
	{ p_read int 1 regular  }
	{ icmp_ln367_loc_c int 1 regular {fifo 1}  }
}
set C_modelArgMapList {[ 
	{ "Name" : "tensor_pixels", "interface" : "fifo", "bitwidth" : 24, "direction" : "READONLY"} , 
 	{ "Name" : "tensor_words", "interface" : "fifo", "bitwidth" : 128, "direction" : "WRITEONLY"} , 
 	{ "Name" : "p_read", "interface" : "wire", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "icmp_ln367_loc_c", "interface" : "fifo", "bitwidth" : 1, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 23
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ tensor_pixels_dout sc_in sc_lv 24 signal 0 } 
	{ tensor_pixels_num_data_valid sc_in sc_lv 7 signal 0 } 
	{ tensor_pixels_fifo_cap sc_in sc_lv 7 signal 0 } 
	{ tensor_pixels_empty_n sc_in sc_logic 1 signal 0 } 
	{ tensor_pixels_read sc_out sc_logic 1 signal 0 } 
	{ tensor_words_din sc_out sc_lv 128 signal 1 } 
	{ tensor_words_num_data_valid sc_in sc_lv 7 signal 1 } 
	{ tensor_words_fifo_cap sc_in sc_lv 7 signal 1 } 
	{ tensor_words_full_n sc_in sc_logic 1 signal 1 } 
	{ tensor_words_write sc_out sc_logic 1 signal 1 } 
	{ p_read sc_in sc_lv 1 signal 2 } 
	{ icmp_ln367_loc_c_din sc_out sc_lv 1 signal 3 } 
	{ icmp_ln367_loc_c_num_data_valid sc_in sc_lv 2 signal 3 } 
	{ icmp_ln367_loc_c_fifo_cap sc_in sc_lv 2 signal 3 } 
	{ icmp_ln367_loc_c_full_n sc_in sc_logic 1 signal 3 } 
	{ icmp_ln367_loc_c_write sc_out sc_logic 1 signal 3 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "tensor_pixels_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":24, "type": "signal", "bundle":{"name": "tensor_pixels", "role": "dout" }} , 
 	{ "name": "tensor_pixels_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "tensor_pixels", "role": "num_data_valid" }} , 
 	{ "name": "tensor_pixels_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "tensor_pixels", "role": "fifo_cap" }} , 
 	{ "name": "tensor_pixels_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "tensor_pixels", "role": "empty_n" }} , 
 	{ "name": "tensor_pixels_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "tensor_pixels", "role": "read" }} , 
 	{ "name": "tensor_words_din", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "tensor_words", "role": "din" }} , 
 	{ "name": "tensor_words_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "tensor_words", "role": "num_data_valid" }} , 
 	{ "name": "tensor_words_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "tensor_words", "role": "fifo_cap" }} , 
 	{ "name": "tensor_words_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "tensor_words", "role": "full_n" }} , 
 	{ "name": "tensor_words_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "tensor_words", "role": "write" }} , 
 	{ "name": "p_read", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "p_read", "role": "default" }} , 
 	{ "name": "icmp_ln367_loc_c_din", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "icmp_ln367_loc_c", "role": "din" }} , 
 	{ "name": "icmp_ln367_loc_c_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "icmp_ln367_loc_c", "role": "num_data_valid" }} , 
 	{ "name": "icmp_ln367_loc_c_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "icmp_ln367_loc_c", "role": "fifo_cap" }} , 
 	{ "name": "icmp_ln367_loc_c_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "icmp_ln367_loc_c", "role": "full_n" }} , 
 	{ "name": "icmp_ln367_loc_c_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "icmp_ln367_loc_c", "role": "write" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1"],
		"CDFG" : "p_anonymous_namespace_pack",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "1", "EstimateLatencyMax" : "175553",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "tensor_pixels", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_308_2_fu_89", "Port" : "tensor_pixels", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "tensor_words", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "tensor_words_blk_n", "Type" : "RtlSignal"}],
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_308_2_fu_89", "Port" : "tensor_words", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "p_read", "Type" : "None", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "5", "DependentChanType" : "1"},
			{"Name" : "icmp_ln367_loc_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "icmp_ln367_loc_c_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_304_1", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "4", "FirstState" : "ap_ST_fsm_state2", "LastState" : ["ap_ST_fsm_state4"], "QuitState" : ["ap_ST_fsm_state2"], "PreState" : ["ap_ST_fsm_state1"], "PostState" : ["ap_ST_fsm_state1"], "OneDepthLoop" : "0", "OneStateBlock": ""}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_308_2_fu_89", "Parent" : "0", "Child" : ["2"],
		"CDFG" : "p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_308_2",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "419", "EstimateLatencyMax" : "419",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "tensor_pixels", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "tensor_pixels_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "tensor_words", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "tensor_words_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "bits_9_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "reservoir_V_out", "Type" : "Vld", "Direction" : "O"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_308_2", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter2", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "2", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_308_2_fu_89.flow_control_loop_pipe_sequential_init_U", "Parent" : "1"}]}


set ArgLastReadFirstWriteLatency {
	p_anonymous_namespace_pack {
		tensor_pixels {Type I LastRead 1 FirstWrite -1}
		tensor_words {Type O LastRead -1 FirstWrite 2}
		p_read {Type I LastRead 0 FirstWrite -1}
		icmp_ln367_loc_c {Type O LastRead -1 FirstWrite 0}}
	p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_308_2 {
		tensor_pixels {Type I LastRead 1 FirstWrite -1}
		tensor_words {Type O LastRead -1 FirstWrite 2}
		bits_9_out {Type O LastRead -1 FirstWrite 1}
		reservoir_V_out {Type O LastRead -1 FirstWrite 1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "1", "Max" : "175553"}
	, {"Name" : "Interval", "Min" : "1", "Max" : "175553"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	tensor_pixels { ap_fifo {  { tensor_pixels_dout fifo_port_we 0 24 }  { tensor_pixels_num_data_valid fifo_status_num_data_valid 0 7 }  { tensor_pixels_fifo_cap fifo_update 0 7 }  { tensor_pixels_empty_n fifo_status 0 1 }  { tensor_pixels_read fifo_data 1 1 } } }
	tensor_words { ap_fifo {  { tensor_words_din fifo_port_we 1 128 }  { tensor_words_num_data_valid fifo_status_num_data_valid 0 7 }  { tensor_words_fifo_cap fifo_update 0 7 }  { tensor_words_full_n fifo_status 0 1 }  { tensor_words_write fifo_data 1 1 } } }
	p_read { ap_none {  { p_read in_data 0 1 } } }
	icmp_ln367_loc_c { ap_fifo {  { icmp_ln367_loc_c_din fifo_port_we 1 1 }  { icmp_ln367_loc_c_num_data_valid fifo_status_num_data_valid 0 2 }  { icmp_ln367_loc_c_fifo_cap fifo_update 0 2 }  { icmp_ln367_loc_c_full_n fifo_status 0 1 }  { icmp_ln367_loc_c_write fifo_data 1 1 } } }
}
set moduleName p_anonymous_namespace_pack
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
set C_modelName {(anonymous namespace)pack}
set C_modelType { void 0 }
set C_modelArgList {
	{ tensor_pixels int 24 regular {fifo 0 volatile }  }
	{ tensor_words int 128 regular {fifo 1 volatile }  }
	{ p_read int 1 regular  }
	{ icmp_ln382_loc_c int 1 regular {fifo 1}  }
}
set C_modelArgMapList {[ 
	{ "Name" : "tensor_pixels", "interface" : "fifo", "bitwidth" : 24, "direction" : "READONLY"} , 
 	{ "Name" : "tensor_words", "interface" : "fifo", "bitwidth" : 128, "direction" : "WRITEONLY"} , 
 	{ "Name" : "p_read", "interface" : "wire", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "icmp_ln382_loc_c", "interface" : "fifo", "bitwidth" : 1, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 23
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ tensor_pixels_dout sc_in sc_lv 24 signal 0 } 
	{ tensor_pixels_num_data_valid sc_in sc_lv 7 signal 0 } 
	{ tensor_pixels_fifo_cap sc_in sc_lv 7 signal 0 } 
	{ tensor_pixels_empty_n sc_in sc_logic 1 signal 0 } 
	{ tensor_pixels_read sc_out sc_logic 1 signal 0 } 
	{ tensor_words_din sc_out sc_lv 128 signal 1 } 
	{ tensor_words_num_data_valid sc_in sc_lv 7 signal 1 } 
	{ tensor_words_fifo_cap sc_in sc_lv 7 signal 1 } 
	{ tensor_words_full_n sc_in sc_logic 1 signal 1 } 
	{ tensor_words_write sc_out sc_logic 1 signal 1 } 
	{ p_read sc_in sc_lv 1 signal 2 } 
	{ icmp_ln382_loc_c_din sc_out sc_lv 1 signal 3 } 
	{ icmp_ln382_loc_c_num_data_valid sc_in sc_lv 2 signal 3 } 
	{ icmp_ln382_loc_c_fifo_cap sc_in sc_lv 2 signal 3 } 
	{ icmp_ln382_loc_c_full_n sc_in sc_logic 1 signal 3 } 
	{ icmp_ln382_loc_c_write sc_out sc_logic 1 signal 3 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "tensor_pixels_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":24, "type": "signal", "bundle":{"name": "tensor_pixels", "role": "dout" }} , 
 	{ "name": "tensor_pixels_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "tensor_pixels", "role": "num_data_valid" }} , 
 	{ "name": "tensor_pixels_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "tensor_pixels", "role": "fifo_cap" }} , 
 	{ "name": "tensor_pixels_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "tensor_pixels", "role": "empty_n" }} , 
 	{ "name": "tensor_pixels_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "tensor_pixels", "role": "read" }} , 
 	{ "name": "tensor_words_din", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "tensor_words", "role": "din" }} , 
 	{ "name": "tensor_words_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "tensor_words", "role": "num_data_valid" }} , 
 	{ "name": "tensor_words_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "tensor_words", "role": "fifo_cap" }} , 
 	{ "name": "tensor_words_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "tensor_words", "role": "full_n" }} , 
 	{ "name": "tensor_words_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "tensor_words", "role": "write" }} , 
 	{ "name": "p_read", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "p_read", "role": "default" }} , 
 	{ "name": "icmp_ln382_loc_c_din", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "icmp_ln382_loc_c", "role": "din" }} , 
 	{ "name": "icmp_ln382_loc_c_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "icmp_ln382_loc_c", "role": "num_data_valid" }} , 
 	{ "name": "icmp_ln382_loc_c_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "icmp_ln382_loc_c", "role": "fifo_cap" }} , 
 	{ "name": "icmp_ln382_loc_c_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "icmp_ln382_loc_c", "role": "full_n" }} , 
 	{ "name": "icmp_ln382_loc_c_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "icmp_ln382_loc_c", "role": "write" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1"],
		"CDFG" : "p_anonymous_namespace_pack",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "1", "EstimateLatencyMax" : "175553",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "tensor_pixels", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_323_2_fu_89", "Port" : "tensor_pixels", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "tensor_words", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "tensor_words_blk_n", "Type" : "RtlSignal"}],
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_323_2_fu_89", "Port" : "tensor_words", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "p_read", "Type" : "None", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "5", "DependentChanType" : "1"},
			{"Name" : "icmp_ln382_loc_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "icmp_ln382_loc_c_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_319_1", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "4", "FirstState" : "ap_ST_fsm_state2", "LastState" : ["ap_ST_fsm_state4"], "QuitState" : ["ap_ST_fsm_state2"], "PreState" : ["ap_ST_fsm_state1"], "PostState" : ["ap_ST_fsm_state1"], "OneDepthLoop" : "0", "OneStateBlock": ""}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_323_2_fu_89", "Parent" : "0", "Child" : ["2"],
		"CDFG" : "p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_323_2",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "419", "EstimateLatencyMax" : "419",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "tensor_pixels", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "tensor_pixels_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "tensor_words", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "tensor_words_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "bits_9_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "reservoir_V_out", "Type" : "Vld", "Direction" : "O"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_323_2", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter2", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "2", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_323_2_fu_89.flow_control_loop_pipe_sequential_init_U", "Parent" : "1"}]}


set ArgLastReadFirstWriteLatency {
	p_anonymous_namespace_pack {
		tensor_pixels {Type I LastRead 1 FirstWrite -1}
		tensor_words {Type O LastRead -1 FirstWrite 2}
		p_read {Type I LastRead 0 FirstWrite -1}
		icmp_ln382_loc_c {Type O LastRead -1 FirstWrite 0}}
	p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_323_2 {
		tensor_pixels {Type I LastRead 1 FirstWrite -1}
		tensor_words {Type O LastRead -1 FirstWrite 2}
		bits_9_out {Type O LastRead -1 FirstWrite 1}
		reservoir_V_out {Type O LastRead -1 FirstWrite 1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "1", "Max" : "175553"}
	, {"Name" : "Interval", "Min" : "1", "Max" : "175553"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	tensor_pixels { ap_fifo {  { tensor_pixels_dout fifo_port_we 0 24 }  { tensor_pixels_num_data_valid fifo_status_num_data_valid 0 7 }  { tensor_pixels_fifo_cap fifo_update 0 7 }  { tensor_pixels_empty_n fifo_status 0 1 }  { tensor_pixels_read fifo_data 1 1 } } }
	tensor_words { ap_fifo {  { tensor_words_din fifo_port_we 1 128 }  { tensor_words_num_data_valid fifo_status_num_data_valid 0 7 }  { tensor_words_fifo_cap fifo_update 0 7 }  { tensor_words_full_n fifo_status 0 1 }  { tensor_words_write fifo_data 1 1 } } }
	p_read { ap_none {  { p_read in_data 0 1 } } }
	icmp_ln382_loc_c { ap_fifo {  { icmp_ln382_loc_c_din fifo_port_we 1 1 }  { icmp_ln382_loc_c_num_data_valid fifo_status_num_data_valid 0 2 }  { icmp_ln382_loc_c_fifo_cap fifo_update 0 2 }  { icmp_ln382_loc_c_full_n fifo_status 0 1 }  { icmp_ln382_loc_c_write fifo_data 1 1 } } }
}
set moduleName p_anonymous_namespace_pack
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
set C_modelName {(anonymous namespace)pack}
set C_modelType { void 0 }
set C_modelArgList {
	{ tensor_pixels int 24 regular {fifo 0 volatile }  }
	{ tensor_words int 128 regular {fifo 1 volatile }  }
	{ p_read int 1 regular  }
	{ icmp_ln411_loc_c int 1 regular {fifo 1}  }
}
set C_modelArgMapList {[ 
	{ "Name" : "tensor_pixels", "interface" : "fifo", "bitwidth" : 24, "direction" : "READONLY"} , 
 	{ "Name" : "tensor_words", "interface" : "fifo", "bitwidth" : 128, "direction" : "WRITEONLY"} , 
 	{ "Name" : "p_read", "interface" : "wire", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "icmp_ln411_loc_c", "interface" : "fifo", "bitwidth" : 1, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 23
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ tensor_pixels_dout sc_in sc_lv 24 signal 0 } 
	{ tensor_pixels_num_data_valid sc_in sc_lv 7 signal 0 } 
	{ tensor_pixels_fifo_cap sc_in sc_lv 7 signal 0 } 
	{ tensor_pixels_empty_n sc_in sc_logic 1 signal 0 } 
	{ tensor_pixels_read sc_out sc_logic 1 signal 0 } 
	{ tensor_words_din sc_out sc_lv 128 signal 1 } 
	{ tensor_words_num_data_valid sc_in sc_lv 7 signal 1 } 
	{ tensor_words_fifo_cap sc_in sc_lv 7 signal 1 } 
	{ tensor_words_full_n sc_in sc_logic 1 signal 1 } 
	{ tensor_words_write sc_out sc_logic 1 signal 1 } 
	{ p_read sc_in sc_lv 1 signal 2 } 
	{ icmp_ln411_loc_c_din sc_out sc_lv 1 signal 3 } 
	{ icmp_ln411_loc_c_num_data_valid sc_in sc_lv 2 signal 3 } 
	{ icmp_ln411_loc_c_fifo_cap sc_in sc_lv 2 signal 3 } 
	{ icmp_ln411_loc_c_full_n sc_in sc_logic 1 signal 3 } 
	{ icmp_ln411_loc_c_write sc_out sc_logic 1 signal 3 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "tensor_pixels_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":24, "type": "signal", "bundle":{"name": "tensor_pixels", "role": "dout" }} , 
 	{ "name": "tensor_pixels_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "tensor_pixels", "role": "num_data_valid" }} , 
 	{ "name": "tensor_pixels_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "tensor_pixels", "role": "fifo_cap" }} , 
 	{ "name": "tensor_pixels_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "tensor_pixels", "role": "empty_n" }} , 
 	{ "name": "tensor_pixels_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "tensor_pixels", "role": "read" }} , 
 	{ "name": "tensor_words_din", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "tensor_words", "role": "din" }} , 
 	{ "name": "tensor_words_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "tensor_words", "role": "num_data_valid" }} , 
 	{ "name": "tensor_words_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "tensor_words", "role": "fifo_cap" }} , 
 	{ "name": "tensor_words_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "tensor_words", "role": "full_n" }} , 
 	{ "name": "tensor_words_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "tensor_words", "role": "write" }} , 
 	{ "name": "p_read", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "p_read", "role": "default" }} , 
 	{ "name": "icmp_ln411_loc_c_din", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "icmp_ln411_loc_c", "role": "din" }} , 
 	{ "name": "icmp_ln411_loc_c_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "icmp_ln411_loc_c", "role": "num_data_valid" }} , 
 	{ "name": "icmp_ln411_loc_c_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "icmp_ln411_loc_c", "role": "fifo_cap" }} , 
 	{ "name": "icmp_ln411_loc_c_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "icmp_ln411_loc_c", "role": "full_n" }} , 
 	{ "name": "icmp_ln411_loc_c_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "icmp_ln411_loc_c", "role": "write" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1"],
		"CDFG" : "p_anonymous_namespace_pack",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "1", "EstimateLatencyMax" : "175553",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "tensor_pixels", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_352_2_fu_89", "Port" : "tensor_pixels", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "tensor_words", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "tensor_words_blk_n", "Type" : "RtlSignal"}],
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_352_2_fu_89", "Port" : "tensor_words", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "p_read", "Type" : "None", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "5", "DependentChanType" : "1"},
			{"Name" : "icmp_ln411_loc_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "icmp_ln411_loc_c_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_348_1", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "4", "FirstState" : "ap_ST_fsm_state2", "LastState" : ["ap_ST_fsm_state4"], "QuitState" : ["ap_ST_fsm_state2"], "PreState" : ["ap_ST_fsm_state1"], "PostState" : ["ap_ST_fsm_state1"], "OneDepthLoop" : "0", "OneStateBlock": ""}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_352_2_fu_89", "Parent" : "0", "Child" : ["2"],
		"CDFG" : "p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_352_2",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "419", "EstimateLatencyMax" : "419",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "tensor_pixels", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "tensor_pixels_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "tensor_words", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "tensor_words_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "bits_9_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "reservoir_V_out", "Type" : "Vld", "Direction" : "O"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_352_2", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter2", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "2", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_352_2_fu_89.flow_control_loop_pipe_sequential_init_U", "Parent" : "1"}]}


set ArgLastReadFirstWriteLatency {
	p_anonymous_namespace_pack {
		tensor_pixels {Type I LastRead 1 FirstWrite -1}
		tensor_words {Type O LastRead -1 FirstWrite 2}
		p_read {Type I LastRead 0 FirstWrite -1}
		icmp_ln411_loc_c {Type O LastRead -1 FirstWrite 0}}
	p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_352_2 {
		tensor_pixels {Type I LastRead 1 FirstWrite -1}
		tensor_words {Type O LastRead -1 FirstWrite 2}
		bits_9_out {Type O LastRead -1 FirstWrite 1}
		reservoir_V_out {Type O LastRead -1 FirstWrite 1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "1", "Max" : "175553"}
	, {"Name" : "Interval", "Min" : "1", "Max" : "175553"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	tensor_pixels { ap_fifo {  { tensor_pixels_dout fifo_port_we 0 24 }  { tensor_pixels_num_data_valid fifo_status_num_data_valid 0 7 }  { tensor_pixels_fifo_cap fifo_update 0 7 }  { tensor_pixels_empty_n fifo_status 0 1 }  { tensor_pixels_read fifo_data 1 1 } } }
	tensor_words { ap_fifo {  { tensor_words_din fifo_port_we 1 128 }  { tensor_words_num_data_valid fifo_status_num_data_valid 0 7 }  { tensor_words_fifo_cap fifo_update 0 7 }  { tensor_words_full_n fifo_status 0 1 }  { tensor_words_write fifo_data 1 1 } } }
	p_read { ap_none {  { p_read in_data 0 1 } } }
	icmp_ln411_loc_c { ap_fifo {  { icmp_ln411_loc_c_din fifo_port_we 1 1 }  { icmp_ln411_loc_c_num_data_valid fifo_status_num_data_valid 0 2 }  { icmp_ln411_loc_c_fifo_cap fifo_update 0 2 }  { icmp_ln411_loc_c_full_n fifo_status 0 1 }  { icmp_ln411_loc_c_write fifo_data 1 1 } } }
}
set moduleName p_anonymous_namespace_pack
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
set C_modelName {(anonymous namespace)pack}
set C_modelType { void 0 }
set C_modelArgList {
	{ tensor_pixels int 24 regular {fifo 0 volatile }  }
	{ tensor_words int 128 regular {fifo 1 volatile }  }
	{ p_read int 1 regular  }
	{ icmp_ln426_loc_c int 1 regular {fifo 1}  }
}
set C_modelArgMapList {[ 
	{ "Name" : "tensor_pixels", "interface" : "fifo", "bitwidth" : 24, "direction" : "READONLY"} , 
 	{ "Name" : "tensor_words", "interface" : "fifo", "bitwidth" : 128, "direction" : "WRITEONLY"} , 
 	{ "Name" : "p_read", "interface" : "wire", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "icmp_ln426_loc_c", "interface" : "fifo", "bitwidth" : 1, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 23
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ tensor_pixels_dout sc_in sc_lv 24 signal 0 } 
	{ tensor_pixels_num_data_valid sc_in sc_lv 7 signal 0 } 
	{ tensor_pixels_fifo_cap sc_in sc_lv 7 signal 0 } 
	{ tensor_pixels_empty_n sc_in sc_logic 1 signal 0 } 
	{ tensor_pixels_read sc_out sc_logic 1 signal 0 } 
	{ tensor_words_din sc_out sc_lv 128 signal 1 } 
	{ tensor_words_num_data_valid sc_in sc_lv 7 signal 1 } 
	{ tensor_words_fifo_cap sc_in sc_lv 7 signal 1 } 
	{ tensor_words_full_n sc_in sc_logic 1 signal 1 } 
	{ tensor_words_write sc_out sc_logic 1 signal 1 } 
	{ p_read sc_in sc_lv 1 signal 2 } 
	{ icmp_ln426_loc_c_din sc_out sc_lv 1 signal 3 } 
	{ icmp_ln426_loc_c_num_data_valid sc_in sc_lv 2 signal 3 } 
	{ icmp_ln426_loc_c_fifo_cap sc_in sc_lv 2 signal 3 } 
	{ icmp_ln426_loc_c_full_n sc_in sc_logic 1 signal 3 } 
	{ icmp_ln426_loc_c_write sc_out sc_logic 1 signal 3 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "tensor_pixels_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":24, "type": "signal", "bundle":{"name": "tensor_pixels", "role": "dout" }} , 
 	{ "name": "tensor_pixels_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "tensor_pixels", "role": "num_data_valid" }} , 
 	{ "name": "tensor_pixels_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "tensor_pixels", "role": "fifo_cap" }} , 
 	{ "name": "tensor_pixels_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "tensor_pixels", "role": "empty_n" }} , 
 	{ "name": "tensor_pixels_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "tensor_pixels", "role": "read" }} , 
 	{ "name": "tensor_words_din", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "tensor_words", "role": "din" }} , 
 	{ "name": "tensor_words_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "tensor_words", "role": "num_data_valid" }} , 
 	{ "name": "tensor_words_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "tensor_words", "role": "fifo_cap" }} , 
 	{ "name": "tensor_words_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "tensor_words", "role": "full_n" }} , 
 	{ "name": "tensor_words_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "tensor_words", "role": "write" }} , 
 	{ "name": "p_read", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "p_read", "role": "default" }} , 
 	{ "name": "icmp_ln426_loc_c_din", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "icmp_ln426_loc_c", "role": "din" }} , 
 	{ "name": "icmp_ln426_loc_c_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "icmp_ln426_loc_c", "role": "num_data_valid" }} , 
 	{ "name": "icmp_ln426_loc_c_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "icmp_ln426_loc_c", "role": "fifo_cap" }} , 
 	{ "name": "icmp_ln426_loc_c_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "icmp_ln426_loc_c", "role": "full_n" }} , 
 	{ "name": "icmp_ln426_loc_c_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "icmp_ln426_loc_c", "role": "write" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1"],
		"CDFG" : "p_anonymous_namespace_pack",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "1", "EstimateLatencyMax" : "175553",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "tensor_pixels", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_367_2_fu_89", "Port" : "tensor_pixels", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "tensor_words", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "tensor_words_blk_n", "Type" : "RtlSignal"}],
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_367_2_fu_89", "Port" : "tensor_words", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "p_read", "Type" : "None", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "5", "DependentChanType" : "1"},
			{"Name" : "icmp_ln426_loc_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "icmp_ln426_loc_c_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_363_1", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "4", "FirstState" : "ap_ST_fsm_state2", "LastState" : ["ap_ST_fsm_state4"], "QuitState" : ["ap_ST_fsm_state2"], "PreState" : ["ap_ST_fsm_state1"], "PostState" : ["ap_ST_fsm_state1"], "OneDepthLoop" : "0", "OneStateBlock": ""}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_367_2_fu_89", "Parent" : "0", "Child" : ["2"],
		"CDFG" : "p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_367_2",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "419", "EstimateLatencyMax" : "419",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "tensor_pixels", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "tensor_pixels_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "tensor_words", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "tensor_words_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "bits_9_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "reservoir_V_out", "Type" : "Vld", "Direction" : "O"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_367_2", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter2", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "2", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_367_2_fu_89.flow_control_loop_pipe_sequential_init_U", "Parent" : "1"}]}


set ArgLastReadFirstWriteLatency {
	p_anonymous_namespace_pack {
		tensor_pixels {Type I LastRead 1 FirstWrite -1}
		tensor_words {Type O LastRead -1 FirstWrite 2}
		p_read {Type I LastRead 0 FirstWrite -1}
		icmp_ln426_loc_c {Type O LastRead -1 FirstWrite 0}}
	p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_367_2 {
		tensor_pixels {Type I LastRead 1 FirstWrite -1}
		tensor_words {Type O LastRead -1 FirstWrite 2}
		bits_9_out {Type O LastRead -1 FirstWrite 1}
		reservoir_V_out {Type O LastRead -1 FirstWrite 1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "1", "Max" : "175553"}
	, {"Name" : "Interval", "Min" : "1", "Max" : "175553"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	tensor_pixels { ap_fifo {  { tensor_pixels_dout fifo_port_we 0 24 }  { tensor_pixels_num_data_valid fifo_status_num_data_valid 0 7 }  { tensor_pixels_fifo_cap fifo_update 0 7 }  { tensor_pixels_empty_n fifo_status 0 1 }  { tensor_pixels_read fifo_data 1 1 } } }
	tensor_words { ap_fifo {  { tensor_words_din fifo_port_we 1 128 }  { tensor_words_num_data_valid fifo_status_num_data_valid 0 7 }  { tensor_words_fifo_cap fifo_update 0 7 }  { tensor_words_full_n fifo_status 0 1 }  { tensor_words_write fifo_data 1 1 } } }
	p_read { ap_none {  { p_read in_data 0 1 } } }
	icmp_ln426_loc_c { ap_fifo {  { icmp_ln426_loc_c_din fifo_port_we 1 1 }  { icmp_ln426_loc_c_num_data_valid fifo_status_num_data_valid 0 2 }  { icmp_ln426_loc_c_fifo_cap fifo_update 0 2 }  { icmp_ln426_loc_c_full_n fifo_status 0 1 }  { icmp_ln426_loc_c_write fifo_data 1 1 } } }
}
