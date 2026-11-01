set moduleName p_anonymous_namespace_collect_or_drain
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
set C_modelName {(anonymous namespace)collect_or_drain}
set C_modelType { void 0 }
set C_modelArgList {
	{ hist_pixels int 8 regular {fifo 0 volatile }  }
	{ hist int 32 regular {array 256 { 1 0 } 1 1 }  }
	{ collect int 1 regular {fifo 0}  }
	{ mul_ln363_loc int 32 regular {fifo 0}  }
}
set C_modelArgMapList {[ 
	{ "Name" : "hist_pixels", "interface" : "fifo", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "hist", "interface" : "memory", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "collect", "interface" : "fifo", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "mul_ln363_loc", "interface" : "fifo", "bitwidth" : 32, "direction" : "READONLY"} ]}
# RTL Port declarations: 
set portNum 29
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ hist_pixels_dout sc_in sc_lv 8 signal 0 } 
	{ hist_pixels_num_data_valid sc_in sc_lv 7 signal 0 } 
	{ hist_pixels_fifo_cap sc_in sc_lv 7 signal 0 } 
	{ hist_pixels_empty_n sc_in sc_logic 1 signal 0 } 
	{ hist_pixels_read sc_out sc_logic 1 signal 0 } 
	{ hist_address0 sc_out sc_lv 8 signal 1 } 
	{ hist_ce0 sc_out sc_logic 1 signal 1 } 
	{ hist_q0 sc_in sc_lv 32 signal 1 } 
	{ hist_address1 sc_out sc_lv 8 signal 1 } 
	{ hist_ce1 sc_out sc_logic 1 signal 1 } 
	{ hist_we1 sc_out sc_logic 1 signal 1 } 
	{ hist_d1 sc_out sc_lv 32 signal 1 } 
	{ collect_dout sc_in sc_lv 1 signal 2 } 
	{ collect_num_data_valid sc_in sc_lv 4 signal 2 } 
	{ collect_fifo_cap sc_in sc_lv 4 signal 2 } 
	{ collect_empty_n sc_in sc_logic 1 signal 2 } 
	{ collect_read sc_out sc_logic 1 signal 2 } 
	{ mul_ln363_loc_dout sc_in sc_lv 32 signal 3 } 
	{ mul_ln363_loc_num_data_valid sc_in sc_lv 2 signal 3 } 
	{ mul_ln363_loc_fifo_cap sc_in sc_lv 2 signal 3 } 
	{ mul_ln363_loc_empty_n sc_in sc_logic 1 signal 3 } 
	{ mul_ln363_loc_read sc_out sc_logic 1 signal 3 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "hist_pixels_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "hist_pixels", "role": "dout" }} , 
 	{ "name": "hist_pixels_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "hist_pixels", "role": "num_data_valid" }} , 
 	{ "name": "hist_pixels_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "hist_pixels", "role": "fifo_cap" }} , 
 	{ "name": "hist_pixels_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist_pixels", "role": "empty_n" }} , 
 	{ "name": "hist_pixels_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist_pixels", "role": "read" }} , 
 	{ "name": "hist_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "hist", "role": "address0" }} , 
 	{ "name": "hist_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist", "role": "ce0" }} , 
 	{ "name": "hist_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "hist", "role": "q0" }} , 
 	{ "name": "hist_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "hist", "role": "address1" }} , 
 	{ "name": "hist_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist", "role": "ce1" }} , 
 	{ "name": "hist_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist", "role": "we1" }} , 
 	{ "name": "hist_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "hist", "role": "d1" }} , 
 	{ "name": "collect_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "collect", "role": "dout" }} , 
 	{ "name": "collect_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "collect", "role": "num_data_valid" }} , 
 	{ "name": "collect_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "collect", "role": "fifo_cap" }} , 
 	{ "name": "collect_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "collect", "role": "empty_n" }} , 
 	{ "name": "collect_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "collect", "role": "read" }} , 
 	{ "name": "mul_ln363_loc_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "mul_ln363_loc", "role": "dout" }} , 
 	{ "name": "mul_ln363_loc_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "mul_ln363_loc", "role": "num_data_valid" }} , 
 	{ "name": "mul_ln363_loc_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "mul_ln363_loc", "role": "fifo_cap" }} , 
 	{ "name": "mul_ln363_loc_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mul_ln363_loc", "role": "empty_n" }} , 
 	{ "name": "mul_ln363_loc_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mul_ln363_loc", "role": "read" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "3"],
		"CDFG" : "p_anonymous_namespace_collect_or_drain",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "173060", "EstimateLatencyMax" : "4147204",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "hist_pixels", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_199_1_fu_65", "Port" : "hist_pixels", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_206_2_fu_58", "Port" : "hist_pixels", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "hist", "Type" : "Memory", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_199_1_fu_65", "Port" : "hist", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "collect", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "5", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "collect_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mul_ln363_loc", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "mul_ln363_loc_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_206_2_fu_58", "Parent" : "0", "Child" : ["2"],
		"CDFG" : "p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_206_2",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "173058", "EstimateLatencyMax" : "2073602",
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
					{"Name" : "hist_pixels_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_206_2", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter0", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "2", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_206_2_fu_58.flow_control_loop_pipe_sequential_init_U", "Parent" : "1"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_199_1_fu_65", "Parent" : "0", "Child" : ["4"],
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
	{"ID" : "4", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_199_1_fu_65.flow_control_loop_pipe_sequential_init_U", "Parent" : "3"}]}


set ArgLastReadFirstWriteLatency {
	p_anonymous_namespace_collect_or_drain {
		hist_pixels {Type I LastRead 1 FirstWrite -1}
		hist {Type IO LastRead 1 FirstWrite 2}
		collect {Type I LastRead 0 FirstWrite -1}
		mul_ln363_loc {Type I LastRead 0 FirstWrite -1}}
	p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_206_2 {
		mul_ln363_loc_load {Type I LastRead 0 FirstWrite -1}
		hist_pixels {Type I LastRead 1 FirstWrite -1}}
	p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_199_1 {
		mul_ln363_loc_load {Type I LastRead 0 FirstWrite -1}
		hist_pixels {Type I LastRead 1 FirstWrite -1}
		hist {Type IO LastRead 1 FirstWrite 2}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "173060", "Max" : "4147204"}
	, {"Name" : "Interval", "Min" : "173060", "Max" : "4147204"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	hist_pixels { ap_fifo {  { hist_pixels_dout fifo_port_we 0 8 }  { hist_pixels_num_data_valid fifo_status_num_data_valid 0 7 }  { hist_pixels_fifo_cap fifo_update 0 7 }  { hist_pixels_empty_n fifo_status 0 1 }  { hist_pixels_read fifo_data 1 1 } } }
	hist { ap_memory {  { hist_address0 mem_address 1 8 }  { hist_ce0 mem_ce 1 1 }  { hist_q0 mem_dout 0 32 }  { hist_address1 MemPortADDR2 1 8 }  { hist_ce1 MemPortCE2 1 1 }  { hist_we1 MemPortWE2 1 1 }  { hist_d1 MemPortDIN2 1 32 } } }
	collect { ap_fifo {  { collect_dout fifo_port_we 0 1 }  { collect_num_data_valid fifo_status_num_data_valid 0 4 }  { collect_fifo_cap fifo_update 0 4 }  { collect_empty_n fifo_status 0 1 }  { collect_read fifo_data 1 1 } } }
	mul_ln363_loc { ap_fifo {  { mul_ln363_loc_dout fifo_port_we 0 32 }  { mul_ln363_loc_num_data_valid fifo_status_num_data_valid 0 2 }  { mul_ln363_loc_fifo_cap fifo_update 0 2 }  { mul_ln363_loc_empty_n fifo_status 0 1 }  { mul_ln363_loc_read fifo_data 1 1 } } }
}
set moduleName p_anonymous_namespace_collect_or_drain
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
set C_modelName {(anonymous namespace)collect_or_drain}
set C_modelType { void 0 }
set C_modelArgList {
	{ hist_pixels int 8 regular {fifo 0 volatile }  }
	{ hist int 32 regular {array 256 { 1 0 } 1 1 }  }
	{ collect int 1 regular {fifo 0}  }
	{ ret_V_loc int 22 regular {fifo 0}  }
}
set C_modelArgMapList {[ 
	{ "Name" : "hist_pixels", "interface" : "fifo", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "hist", "interface" : "memory", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "collect", "interface" : "fifo", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "ret_V_loc", "interface" : "fifo", "bitwidth" : 22, "direction" : "READONLY"} ]}
# RTL Port declarations: 
set portNum 29
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ hist_pixels_dout sc_in sc_lv 8 signal 0 } 
	{ hist_pixels_num_data_valid sc_in sc_lv 7 signal 0 } 
	{ hist_pixels_fifo_cap sc_in sc_lv 7 signal 0 } 
	{ hist_pixels_empty_n sc_in sc_logic 1 signal 0 } 
	{ hist_pixels_read sc_out sc_logic 1 signal 0 } 
	{ hist_address0 sc_out sc_lv 8 signal 1 } 
	{ hist_ce0 sc_out sc_logic 1 signal 1 } 
	{ hist_q0 sc_in sc_lv 32 signal 1 } 
	{ hist_address1 sc_out sc_lv 8 signal 1 } 
	{ hist_ce1 sc_out sc_logic 1 signal 1 } 
	{ hist_we1 sc_out sc_logic 1 signal 1 } 
	{ hist_d1 sc_out sc_lv 32 signal 1 } 
	{ collect_dout sc_in sc_lv 1 signal 2 } 
	{ collect_num_data_valid sc_in sc_lv 4 signal 2 } 
	{ collect_fifo_cap sc_in sc_lv 4 signal 2 } 
	{ collect_empty_n sc_in sc_logic 1 signal 2 } 
	{ collect_read sc_out sc_logic 1 signal 2 } 
	{ ret_V_loc_dout sc_in sc_lv 22 signal 3 } 
	{ ret_V_loc_num_data_valid sc_in sc_lv 2 signal 3 } 
	{ ret_V_loc_fifo_cap sc_in sc_lv 2 signal 3 } 
	{ ret_V_loc_empty_n sc_in sc_logic 1 signal 3 } 
	{ ret_V_loc_read sc_out sc_logic 1 signal 3 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "hist_pixels_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "hist_pixels", "role": "dout" }} , 
 	{ "name": "hist_pixels_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "hist_pixels", "role": "num_data_valid" }} , 
 	{ "name": "hist_pixels_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "hist_pixels", "role": "fifo_cap" }} , 
 	{ "name": "hist_pixels_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist_pixels", "role": "empty_n" }} , 
 	{ "name": "hist_pixels_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist_pixels", "role": "read" }} , 
 	{ "name": "hist_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "hist", "role": "address0" }} , 
 	{ "name": "hist_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist", "role": "ce0" }} , 
 	{ "name": "hist_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "hist", "role": "q0" }} , 
 	{ "name": "hist_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "hist", "role": "address1" }} , 
 	{ "name": "hist_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist", "role": "ce1" }} , 
 	{ "name": "hist_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist", "role": "we1" }} , 
 	{ "name": "hist_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "hist", "role": "d1" }} , 
 	{ "name": "collect_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "collect", "role": "dout" }} , 
 	{ "name": "collect_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "collect", "role": "num_data_valid" }} , 
 	{ "name": "collect_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "collect", "role": "fifo_cap" }} , 
 	{ "name": "collect_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "collect", "role": "empty_n" }} , 
 	{ "name": "collect_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "collect", "role": "read" }} , 
 	{ "name": "ret_V_loc_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":22, "type": "signal", "bundle":{"name": "ret_V_loc", "role": "dout" }} , 
 	{ "name": "ret_V_loc_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "ret_V_loc", "role": "num_data_valid" }} , 
 	{ "name": "ret_V_loc_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "ret_V_loc", "role": "fifo_cap" }} , 
 	{ "name": "ret_V_loc_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "ret_V_loc", "role": "empty_n" }} , 
 	{ "name": "ret_V_loc_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "ret_V_loc", "role": "read" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "3"],
		"CDFG" : "p_anonymous_namespace_collect_or_drain",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "173060", "EstimateLatencyMax" : "4147204",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "hist_pixels", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_221_2_fu_58", "Port" : "hist_pixels", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "3", "SubInstance" : "grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_214_1_fu_65", "Port" : "hist_pixels", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "hist", "Type" : "Memory", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_214_1_fu_65", "Port" : "hist", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "collect", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "5", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "collect_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "ret_V_loc", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "ret_V_loc_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_221_2_fu_58", "Parent" : "0", "Child" : ["2"],
		"CDFG" : "p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_221_2",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "173058", "EstimateLatencyMax" : "2073602",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "ret_V_loc_load", "Type" : "None", "Direction" : "I"},
			{"Name" : "hist_pixels", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "hist_pixels_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_221_2", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter0", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "2", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_221_2_fu_58.flow_control_loop_pipe_sequential_init_U", "Parent" : "1"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_214_1_fu_65", "Parent" : "0", "Child" : ["4"],
		"CDFG" : "p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_214_1",
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
			{"Name" : "ret_V_loc_load", "Type" : "None", "Direction" : "I"},
			{"Name" : "hist_pixels", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "hist_pixels_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "hist", "Type" : "Memory", "Direction" : "IO"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_214_1", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "2", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter0", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "4", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_214_1_fu_65.flow_control_loop_pipe_sequential_init_U", "Parent" : "3"}]}


set ArgLastReadFirstWriteLatency {
	p_anonymous_namespace_collect_or_drain {
		hist_pixels {Type I LastRead 1 FirstWrite -1}
		hist {Type IO LastRead 1 FirstWrite 2}
		collect {Type I LastRead 0 FirstWrite -1}
		ret_V_loc {Type I LastRead 0 FirstWrite -1}}
	p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_221_2 {
		ret_V_loc_load {Type I LastRead 0 FirstWrite -1}
		hist_pixels {Type I LastRead 1 FirstWrite -1}}
	p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_214_1 {
		ret_V_loc_load {Type I LastRead 0 FirstWrite -1}
		hist_pixels {Type I LastRead 1 FirstWrite -1}
		hist {Type IO LastRead 1 FirstWrite 2}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "173060", "Max" : "4147204"}
	, {"Name" : "Interval", "Min" : "173060", "Max" : "4147204"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	hist_pixels { ap_fifo {  { hist_pixels_dout fifo_port_we 0 8 }  { hist_pixels_num_data_valid fifo_status_num_data_valid 0 7 }  { hist_pixels_fifo_cap fifo_update 0 7 }  { hist_pixels_empty_n fifo_status 0 1 }  { hist_pixels_read fifo_data 1 1 } } }
	hist { ap_memory {  { hist_address0 mem_address 1 8 }  { hist_ce0 mem_ce 1 1 }  { hist_q0 mem_dout 0 32 }  { hist_address1 MemPortADDR2 1 8 }  { hist_ce1 MemPortCE2 1 1 }  { hist_we1 MemPortWE2 1 1 }  { hist_d1 MemPortDIN2 1 32 } } }
	collect { ap_fifo {  { collect_dout fifo_port_we 0 1 }  { collect_num_data_valid fifo_status_num_data_valid 0 4 }  { collect_fifo_cap fifo_update 0 4 }  { collect_empty_n fifo_status 0 1 }  { collect_read fifo_data 1 1 } } }
	ret_V_loc { ap_fifo {  { ret_V_loc_dout fifo_port_we 0 22 }  { ret_V_loc_num_data_valid fifo_status_num_data_valid 0 2 }  { ret_V_loc_fifo_cap fifo_update 0 2 }  { ret_V_loc_empty_n fifo_status 0 1 }  { ret_V_loc_read fifo_data 1 1 } } }
}
set moduleName p_anonymous_namespace_collect_or_drain
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
set C_modelName {(anonymous namespace)collect_or_drain}
set C_modelType { void 0 }
set C_modelArgList {
	{ hist_pixels int 8 regular {fifo 0 volatile }  }
	{ hist int 32 regular {array 256 { 1 0 } 1 1 }  }
	{ collect int 1 regular {fifo 0}  }
	{ mul_ln1540_loc int 22 regular {fifo 0}  }
}
set C_modelArgMapList {[ 
	{ "Name" : "hist_pixels", "interface" : "fifo", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "hist", "interface" : "memory", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "collect", "interface" : "fifo", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "mul_ln1540_loc", "interface" : "fifo", "bitwidth" : 22, "direction" : "READONLY"} ]}
# RTL Port declarations: 
set portNum 29
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ hist_pixels_dout sc_in sc_lv 8 signal 0 } 
	{ hist_pixels_num_data_valid sc_in sc_lv 7 signal 0 } 
	{ hist_pixels_fifo_cap sc_in sc_lv 7 signal 0 } 
	{ hist_pixels_empty_n sc_in sc_logic 1 signal 0 } 
	{ hist_pixels_read sc_out sc_logic 1 signal 0 } 
	{ hist_address0 sc_out sc_lv 8 signal 1 } 
	{ hist_ce0 sc_out sc_logic 1 signal 1 } 
	{ hist_q0 sc_in sc_lv 32 signal 1 } 
	{ hist_address1 sc_out sc_lv 8 signal 1 } 
	{ hist_ce1 sc_out sc_logic 1 signal 1 } 
	{ hist_we1 sc_out sc_logic 1 signal 1 } 
	{ hist_d1 sc_out sc_lv 32 signal 1 } 
	{ collect_dout sc_in sc_lv 1 signal 2 } 
	{ collect_num_data_valid sc_in sc_lv 4 signal 2 } 
	{ collect_fifo_cap sc_in sc_lv 4 signal 2 } 
	{ collect_empty_n sc_in sc_logic 1 signal 2 } 
	{ collect_read sc_out sc_logic 1 signal 2 } 
	{ mul_ln1540_loc_dout sc_in sc_lv 22 signal 3 } 
	{ mul_ln1540_loc_num_data_valid sc_in sc_lv 2 signal 3 } 
	{ mul_ln1540_loc_fifo_cap sc_in sc_lv 2 signal 3 } 
	{ mul_ln1540_loc_empty_n sc_in sc_logic 1 signal 3 } 
	{ mul_ln1540_loc_read sc_out sc_logic 1 signal 3 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "hist_pixels_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "hist_pixels", "role": "dout" }} , 
 	{ "name": "hist_pixels_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "hist_pixels", "role": "num_data_valid" }} , 
 	{ "name": "hist_pixels_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "hist_pixels", "role": "fifo_cap" }} , 
 	{ "name": "hist_pixels_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist_pixels", "role": "empty_n" }} , 
 	{ "name": "hist_pixels_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist_pixels", "role": "read" }} , 
 	{ "name": "hist_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "hist", "role": "address0" }} , 
 	{ "name": "hist_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist", "role": "ce0" }} , 
 	{ "name": "hist_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "hist", "role": "q0" }} , 
 	{ "name": "hist_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "hist", "role": "address1" }} , 
 	{ "name": "hist_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist", "role": "ce1" }} , 
 	{ "name": "hist_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist", "role": "we1" }} , 
 	{ "name": "hist_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "hist", "role": "d1" }} , 
 	{ "name": "collect_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "collect", "role": "dout" }} , 
 	{ "name": "collect_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "collect", "role": "num_data_valid" }} , 
 	{ "name": "collect_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "collect", "role": "fifo_cap" }} , 
 	{ "name": "collect_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "collect", "role": "empty_n" }} , 
 	{ "name": "collect_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "collect", "role": "read" }} , 
 	{ "name": "mul_ln1540_loc_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":22, "type": "signal", "bundle":{"name": "mul_ln1540_loc", "role": "dout" }} , 
 	{ "name": "mul_ln1540_loc_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "mul_ln1540_loc", "role": "num_data_valid" }} , 
 	{ "name": "mul_ln1540_loc_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "mul_ln1540_loc", "role": "fifo_cap" }} , 
 	{ "name": "mul_ln1540_loc_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mul_ln1540_loc", "role": "empty_n" }} , 
 	{ "name": "mul_ln1540_loc_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mul_ln1540_loc", "role": "read" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "3"],
		"CDFG" : "p_anonymous_namespace_collect_or_drain",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "173060", "EstimateLatencyMax" : "4147204",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "hist_pixels", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_246_2_fu_58", "Port" : "hist_pixels", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "3", "SubInstance" : "grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_239_1_fu_65", "Port" : "hist_pixels", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "hist", "Type" : "Memory", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_239_1_fu_65", "Port" : "hist", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "collect", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "5", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "collect_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mul_ln1540_loc", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "mul_ln1540_loc_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_246_2_fu_58", "Parent" : "0", "Child" : ["2"],
		"CDFG" : "p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_246_2",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "173058", "EstimateLatencyMax" : "2073602",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "mul_ln1540_loc_load", "Type" : "None", "Direction" : "I"},
			{"Name" : "hist_pixels", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "hist_pixels_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_246_2", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter0", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "2", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_246_2_fu_58.flow_control_loop_pipe_sequential_init_U", "Parent" : "1"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_239_1_fu_65", "Parent" : "0", "Child" : ["4"],
		"CDFG" : "p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_239_1",
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
			{"Name" : "mul_ln1540_loc_load", "Type" : "None", "Direction" : "I"},
			{"Name" : "hist_pixels", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "hist_pixels_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "hist", "Type" : "Memory", "Direction" : "IO"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_239_1", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "2", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter0", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "4", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_239_1_fu_65.flow_control_loop_pipe_sequential_init_U", "Parent" : "3"}]}


set ArgLastReadFirstWriteLatency {
	p_anonymous_namespace_collect_or_drain {
		hist_pixels {Type I LastRead 1 FirstWrite -1}
		hist {Type IO LastRead 1 FirstWrite 2}
		collect {Type I LastRead 0 FirstWrite -1}
		mul_ln1540_loc {Type I LastRead 0 FirstWrite -1}}
	p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_246_2 {
		mul_ln1540_loc_load {Type I LastRead 0 FirstWrite -1}
		hist_pixels {Type I LastRead 1 FirstWrite -1}}
	p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_239_1 {
		mul_ln1540_loc_load {Type I LastRead 0 FirstWrite -1}
		hist_pixels {Type I LastRead 1 FirstWrite -1}
		hist {Type IO LastRead 1 FirstWrite 2}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "173060", "Max" : "4147204"}
	, {"Name" : "Interval", "Min" : "173060", "Max" : "4147204"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	hist_pixels { ap_fifo {  { hist_pixels_dout fifo_port_we 0 8 }  { hist_pixels_num_data_valid fifo_status_num_data_valid 0 7 }  { hist_pixels_fifo_cap fifo_update 0 7 }  { hist_pixels_empty_n fifo_status 0 1 }  { hist_pixels_read fifo_data 1 1 } } }
	hist { ap_memory {  { hist_address0 mem_address 1 8 }  { hist_ce0 mem_ce 1 1 }  { hist_q0 mem_dout 0 32 }  { hist_address1 MemPortADDR2 1 8 }  { hist_ce1 MemPortCE2 1 1 }  { hist_we1 MemPortWE2 1 1 }  { hist_d1 MemPortDIN2 1 32 } } }
	collect { ap_fifo {  { collect_dout fifo_port_we 0 1 }  { collect_num_data_valid fifo_status_num_data_valid 0 4 }  { collect_fifo_cap fifo_update 0 4 }  { collect_empty_n fifo_status 0 1 }  { collect_read fifo_data 1 1 } } }
	mul_ln1540_loc { ap_fifo {  { mul_ln1540_loc_dout fifo_port_we 0 22 }  { mul_ln1540_loc_num_data_valid fifo_status_num_data_valid 0 2 }  { mul_ln1540_loc_fifo_cap fifo_update 0 2 }  { mul_ln1540_loc_empty_n fifo_status 0 1 }  { mul_ln1540_loc_read fifo_data 1 1 } } }
}
set moduleName p_anonymous_namespace_collect_or_drain
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
set C_modelName {(anonymous namespace)collect_or_drain}
set C_modelType { void 0 }
set C_modelArgList {
	{ hist_pixels int 8 regular {fifo 0 volatile }  }
	{ hist int 32 regular {array 256 { 1 0 } 1 1 }  }
	{ collect int 1 regular {fifo 0}  }
	{ mul_ln1540_loc int 22 regular {fifo 0}  }
}
set C_modelArgMapList {[ 
	{ "Name" : "hist_pixels", "interface" : "fifo", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "hist", "interface" : "memory", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "collect", "interface" : "fifo", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "mul_ln1540_loc", "interface" : "fifo", "bitwidth" : 22, "direction" : "READONLY"} ]}
# RTL Port declarations: 
set portNum 29
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ hist_pixels_dout sc_in sc_lv 8 signal 0 } 
	{ hist_pixels_num_data_valid sc_in sc_lv 7 signal 0 } 
	{ hist_pixels_fifo_cap sc_in sc_lv 7 signal 0 } 
	{ hist_pixels_empty_n sc_in sc_logic 1 signal 0 } 
	{ hist_pixels_read sc_out sc_logic 1 signal 0 } 
	{ hist_address0 sc_out sc_lv 8 signal 1 } 
	{ hist_ce0 sc_out sc_logic 1 signal 1 } 
	{ hist_q0 sc_in sc_lv 32 signal 1 } 
	{ hist_address1 sc_out sc_lv 8 signal 1 } 
	{ hist_ce1 sc_out sc_logic 1 signal 1 } 
	{ hist_we1 sc_out sc_logic 1 signal 1 } 
	{ hist_d1 sc_out sc_lv 32 signal 1 } 
	{ collect_dout sc_in sc_lv 1 signal 2 } 
	{ collect_num_data_valid sc_in sc_lv 4 signal 2 } 
	{ collect_fifo_cap sc_in sc_lv 4 signal 2 } 
	{ collect_empty_n sc_in sc_logic 1 signal 2 } 
	{ collect_read sc_out sc_logic 1 signal 2 } 
	{ mul_ln1540_loc_dout sc_in sc_lv 22 signal 3 } 
	{ mul_ln1540_loc_num_data_valid sc_in sc_lv 2 signal 3 } 
	{ mul_ln1540_loc_fifo_cap sc_in sc_lv 2 signal 3 } 
	{ mul_ln1540_loc_empty_n sc_in sc_logic 1 signal 3 } 
	{ mul_ln1540_loc_read sc_out sc_logic 1 signal 3 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "hist_pixels_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "hist_pixels", "role": "dout" }} , 
 	{ "name": "hist_pixels_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "hist_pixels", "role": "num_data_valid" }} , 
 	{ "name": "hist_pixels_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "hist_pixels", "role": "fifo_cap" }} , 
 	{ "name": "hist_pixels_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist_pixels", "role": "empty_n" }} , 
 	{ "name": "hist_pixels_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist_pixels", "role": "read" }} , 
 	{ "name": "hist_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "hist", "role": "address0" }} , 
 	{ "name": "hist_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist", "role": "ce0" }} , 
 	{ "name": "hist_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "hist", "role": "q0" }} , 
 	{ "name": "hist_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "hist", "role": "address1" }} , 
 	{ "name": "hist_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist", "role": "ce1" }} , 
 	{ "name": "hist_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist", "role": "we1" }} , 
 	{ "name": "hist_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "hist", "role": "d1" }} , 
 	{ "name": "collect_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "collect", "role": "dout" }} , 
 	{ "name": "collect_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "collect", "role": "num_data_valid" }} , 
 	{ "name": "collect_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "collect", "role": "fifo_cap" }} , 
 	{ "name": "collect_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "collect", "role": "empty_n" }} , 
 	{ "name": "collect_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "collect", "role": "read" }} , 
 	{ "name": "mul_ln1540_loc_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":22, "type": "signal", "bundle":{"name": "mul_ln1540_loc", "role": "dout" }} , 
 	{ "name": "mul_ln1540_loc_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "mul_ln1540_loc", "role": "num_data_valid" }} , 
 	{ "name": "mul_ln1540_loc_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "mul_ln1540_loc", "role": "fifo_cap" }} , 
 	{ "name": "mul_ln1540_loc_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mul_ln1540_loc", "role": "empty_n" }} , 
 	{ "name": "mul_ln1540_loc_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mul_ln1540_loc", "role": "read" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "3"],
		"CDFG" : "p_anonymous_namespace_collect_or_drain",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "173060", "EstimateLatencyMax" : "4147204",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "hist_pixels", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_254_1_fu_65", "Port" : "hist_pixels", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "1", "SubInstance" : "grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_261_2_fu_58", "Port" : "hist_pixels", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "hist", "Type" : "Memory", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_254_1_fu_65", "Port" : "hist", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "collect", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "5", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "collect_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mul_ln1540_loc", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "mul_ln1540_loc_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_261_2_fu_58", "Parent" : "0", "Child" : ["2"],
		"CDFG" : "p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_261_2",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "173058", "EstimateLatencyMax" : "2073602",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "mul_ln1540_loc_load", "Type" : "None", "Direction" : "I"},
			{"Name" : "hist_pixels", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "hist_pixels_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_261_2", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter0", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "2", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_261_2_fu_58.flow_control_loop_pipe_sequential_init_U", "Parent" : "1"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_254_1_fu_65", "Parent" : "0", "Child" : ["4"],
		"CDFG" : "p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_254_1",
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
			{"Name" : "mul_ln1540_loc_load", "Type" : "None", "Direction" : "I"},
			{"Name" : "hist_pixels", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "hist_pixels_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "hist", "Type" : "Memory", "Direction" : "IO"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_254_1", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "2", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter0", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "4", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_254_1_fu_65.flow_control_loop_pipe_sequential_init_U", "Parent" : "3"}]}


set ArgLastReadFirstWriteLatency {
	p_anonymous_namespace_collect_or_drain {
		hist_pixels {Type I LastRead 1 FirstWrite -1}
		hist {Type IO LastRead 1 FirstWrite 2}
		collect {Type I LastRead 0 FirstWrite -1}
		mul_ln1540_loc {Type I LastRead 0 FirstWrite -1}}
	p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_261_2 {
		mul_ln1540_loc_load {Type I LastRead 0 FirstWrite -1}
		hist_pixels {Type I LastRead 1 FirstWrite -1}}
	p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_254_1 {
		mul_ln1540_loc_load {Type I LastRead 0 FirstWrite -1}
		hist_pixels {Type I LastRead 1 FirstWrite -1}
		hist {Type IO LastRead 1 FirstWrite 2}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "173060", "Max" : "4147204"}
	, {"Name" : "Interval", "Min" : "173060", "Max" : "4147204"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	hist_pixels { ap_fifo {  { hist_pixels_dout fifo_port_we 0 8 }  { hist_pixels_num_data_valid fifo_status_num_data_valid 0 7 }  { hist_pixels_fifo_cap fifo_update 0 7 }  { hist_pixels_empty_n fifo_status 0 1 }  { hist_pixels_read fifo_data 1 1 } } }
	hist { ap_memory {  { hist_address0 mem_address 1 8 }  { hist_ce0 mem_ce 1 1 }  { hist_q0 mem_dout 0 32 }  { hist_address1 MemPortADDR2 1 8 }  { hist_ce1 MemPortCE2 1 1 }  { hist_we1 MemPortWE2 1 1 }  { hist_d1 MemPortDIN2 1 32 } } }
	collect { ap_fifo {  { collect_dout fifo_port_we 0 1 }  { collect_num_data_valid fifo_status_num_data_valid 0 4 }  { collect_fifo_cap fifo_update 0 4 }  { collect_empty_n fifo_status 0 1 }  { collect_read fifo_data 1 1 } } }
	mul_ln1540_loc { ap_fifo {  { mul_ln1540_loc_dout fifo_port_we 0 22 }  { mul_ln1540_loc_num_data_valid fifo_status_num_data_valid 0 2 }  { mul_ln1540_loc_fifo_cap fifo_update 0 2 }  { mul_ln1540_loc_empty_n fifo_status 0 1 }  { mul_ln1540_loc_read fifo_data 1 1 } } }
}
