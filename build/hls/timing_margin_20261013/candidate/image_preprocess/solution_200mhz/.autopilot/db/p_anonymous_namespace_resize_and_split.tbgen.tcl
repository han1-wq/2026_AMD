set moduleName p_anonymous_namespace_resize_and_split
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
set C_modelName {(anonymous namespace)resize_and_split}
set C_modelType { void 0 }
set C_modelArgList {
	{ pairs int 48 regular {fifo 0 volatile }  }
	{ tensor_pixels5 int 24 regular {fifo 1 volatile }  }
	{ preview_pixels6 int 24 regular {fifo 1 volatile }  }
	{ width int 32 regular  }
	{ height int 32 regular  }
	{ resized_w int 32 regular  }
	{ resized_h int 32 regular  }
	{ pad_x int 32 regular  }
	{ pad_y int 32 regular  }
	{ mode int 32 regular  }
	{ flags int 3 regular  }
	{ xc_index int 11 regular {array 416 { 1 } 1 1 }  }
	{ xc_weight int 12 regular {array 416 { 1 } 1 1 }  }
	{ yc_index int 11 regular {array 416 { 1 } 1 1 }  }
	{ yc_weight int 12 regular {array 416 { 1 } 1 1 }  }
	{ quant_0 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ quant_1 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ quant_2 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ width_c30 int 32 regular {fifo 1}  }
	{ height_c32 int 32 regular {fifo 1}  }
}
set C_modelArgMapList {[ 
	{ "Name" : "pairs", "interface" : "fifo", "bitwidth" : 48, "direction" : "READONLY"} , 
 	{ "Name" : "tensor_pixels5", "interface" : "fifo", "bitwidth" : 24, "direction" : "WRITEONLY"} , 
 	{ "Name" : "preview_pixels6", "interface" : "fifo", "bitwidth" : 24, "direction" : "WRITEONLY"} , 
 	{ "Name" : "width", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "height", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "resized_w", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "resized_h", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "pad_x", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "pad_y", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "mode", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "flags", "interface" : "wire", "bitwidth" : 3, "direction" : "READONLY"} , 
 	{ "Name" : "xc_index", "interface" : "memory", "bitwidth" : 11, "direction" : "READONLY"} , 
 	{ "Name" : "xc_weight", "interface" : "memory", "bitwidth" : 12, "direction" : "READONLY"} , 
 	{ "Name" : "yc_index", "interface" : "memory", "bitwidth" : 11, "direction" : "READONLY"} , 
 	{ "Name" : "yc_weight", "interface" : "memory", "bitwidth" : 12, "direction" : "READONLY"} , 
 	{ "Name" : "quant_0", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "quant_1", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "quant_2", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "width_c30", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY"} , 
 	{ "Name" : "height_c32", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 61
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ pairs_dout sc_in sc_lv 48 signal 0 } 
	{ pairs_num_data_valid sc_in sc_lv 7 signal 0 } 
	{ pairs_fifo_cap sc_in sc_lv 7 signal 0 } 
	{ pairs_empty_n sc_in sc_logic 1 signal 0 } 
	{ pairs_read sc_out sc_logic 1 signal 0 } 
	{ tensor_pixels5_din sc_out sc_lv 24 signal 1 } 
	{ tensor_pixels5_num_data_valid sc_in sc_lv 7 signal 1 } 
	{ tensor_pixels5_fifo_cap sc_in sc_lv 7 signal 1 } 
	{ tensor_pixels5_full_n sc_in sc_logic 1 signal 1 } 
	{ tensor_pixels5_write sc_out sc_logic 1 signal 1 } 
	{ preview_pixels6_din sc_out sc_lv 24 signal 2 } 
	{ preview_pixels6_num_data_valid sc_in sc_lv 7 signal 2 } 
	{ preview_pixels6_fifo_cap sc_in sc_lv 7 signal 2 } 
	{ preview_pixels6_full_n sc_in sc_logic 1 signal 2 } 
	{ preview_pixels6_write sc_out sc_logic 1 signal 2 } 
	{ width sc_in sc_lv 32 signal 3 } 
	{ height sc_in sc_lv 32 signal 4 } 
	{ resized_w sc_in sc_lv 32 signal 5 } 
	{ resized_h sc_in sc_lv 32 signal 6 } 
	{ pad_x sc_in sc_lv 32 signal 7 } 
	{ pad_y sc_in sc_lv 32 signal 8 } 
	{ mode sc_in sc_lv 32 signal 9 } 
	{ flags sc_in sc_lv 3 signal 10 } 
	{ xc_index_address0 sc_out sc_lv 9 signal 11 } 
	{ xc_index_ce0 sc_out sc_logic 1 signal 11 } 
	{ xc_index_q0 sc_in sc_lv 11 signal 11 } 
	{ xc_weight_address0 sc_out sc_lv 9 signal 12 } 
	{ xc_weight_ce0 sc_out sc_logic 1 signal 12 } 
	{ xc_weight_q0 sc_in sc_lv 12 signal 12 } 
	{ yc_index_address0 sc_out sc_lv 9 signal 13 } 
	{ yc_index_ce0 sc_out sc_logic 1 signal 13 } 
	{ yc_index_q0 sc_in sc_lv 11 signal 13 } 
	{ yc_weight_address0 sc_out sc_lv 9 signal 14 } 
	{ yc_weight_ce0 sc_out sc_logic 1 signal 14 } 
	{ yc_weight_q0 sc_in sc_lv 12 signal 14 } 
	{ quant_0_address0 sc_out sc_lv 8 signal 15 } 
	{ quant_0_ce0 sc_out sc_logic 1 signal 15 } 
	{ quant_0_q0 sc_in sc_lv 8 signal 15 } 
	{ quant_1_address0 sc_out sc_lv 8 signal 16 } 
	{ quant_1_ce0 sc_out sc_logic 1 signal 16 } 
	{ quant_1_q0 sc_in sc_lv 8 signal 16 } 
	{ quant_2_address0 sc_out sc_lv 8 signal 17 } 
	{ quant_2_ce0 sc_out sc_logic 1 signal 17 } 
	{ quant_2_q0 sc_in sc_lv 8 signal 17 } 
	{ width_c30_din sc_out sc_lv 32 signal 18 } 
	{ width_c30_num_data_valid sc_in sc_lv 2 signal 18 } 
	{ width_c30_fifo_cap sc_in sc_lv 2 signal 18 } 
	{ width_c30_full_n sc_in sc_logic 1 signal 18 } 
	{ width_c30_write sc_out sc_logic 1 signal 18 } 
	{ height_c32_din sc_out sc_lv 32 signal 19 } 
	{ height_c32_num_data_valid sc_in sc_lv 2 signal 19 } 
	{ height_c32_fifo_cap sc_in sc_lv 2 signal 19 } 
	{ height_c32_full_n sc_in sc_logic 1 signal 19 } 
	{ height_c32_write sc_out sc_logic 1 signal 19 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "pairs_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":48, "type": "signal", "bundle":{"name": "pairs", "role": "dout" }} , 
 	{ "name": "pairs_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "pairs", "role": "num_data_valid" }} , 
 	{ "name": "pairs_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "pairs", "role": "fifo_cap" }} , 
 	{ "name": "pairs_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "pairs", "role": "empty_n" }} , 
 	{ "name": "pairs_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "pairs", "role": "read" }} , 
 	{ "name": "tensor_pixels5_din", "direction": "out", "datatype": "sc_lv", "bitwidth":24, "type": "signal", "bundle":{"name": "tensor_pixels5", "role": "din" }} , 
 	{ "name": "tensor_pixels5_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "tensor_pixels5", "role": "num_data_valid" }} , 
 	{ "name": "tensor_pixels5_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "tensor_pixels5", "role": "fifo_cap" }} , 
 	{ "name": "tensor_pixels5_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "tensor_pixels5", "role": "full_n" }} , 
 	{ "name": "tensor_pixels5_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "tensor_pixels5", "role": "write" }} , 
 	{ "name": "preview_pixels6_din", "direction": "out", "datatype": "sc_lv", "bitwidth":24, "type": "signal", "bundle":{"name": "preview_pixels6", "role": "din" }} , 
 	{ "name": "preview_pixels6_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "preview_pixels6", "role": "num_data_valid" }} , 
 	{ "name": "preview_pixels6_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "preview_pixels6", "role": "fifo_cap" }} , 
 	{ "name": "preview_pixels6_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "preview_pixels6", "role": "full_n" }} , 
 	{ "name": "preview_pixels6_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "preview_pixels6", "role": "write" }} , 
 	{ "name": "width", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "width", "role": "default" }} , 
 	{ "name": "height", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "height", "role": "default" }} , 
 	{ "name": "resized_w", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "resized_w", "role": "default" }} , 
 	{ "name": "resized_h", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "resized_h", "role": "default" }} , 
 	{ "name": "pad_x", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "pad_x", "role": "default" }} , 
 	{ "name": "pad_y", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "pad_y", "role": "default" }} , 
 	{ "name": "mode", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "mode", "role": "default" }} , 
 	{ "name": "flags", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "flags", "role": "default" }} , 
 	{ "name": "xc_index_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "xc_index", "role": "address0" }} , 
 	{ "name": "xc_index_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xc_index", "role": "ce0" }} , 
 	{ "name": "xc_index_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "xc_index", "role": "q0" }} , 
 	{ "name": "xc_weight_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "xc_weight", "role": "address0" }} , 
 	{ "name": "xc_weight_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xc_weight", "role": "ce0" }} , 
 	{ "name": "xc_weight_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":12, "type": "signal", "bundle":{"name": "xc_weight", "role": "q0" }} , 
 	{ "name": "yc_index_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "yc_index", "role": "address0" }} , 
 	{ "name": "yc_index_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "yc_index", "role": "ce0" }} , 
 	{ "name": "yc_index_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "yc_index", "role": "q0" }} , 
 	{ "name": "yc_weight_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "yc_weight", "role": "address0" }} , 
 	{ "name": "yc_weight_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "yc_weight", "role": "ce0" }} , 
 	{ "name": "yc_weight_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":12, "type": "signal", "bundle":{"name": "yc_weight", "role": "q0" }} , 
 	{ "name": "quant_0_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "quant_0", "role": "address0" }} , 
 	{ "name": "quant_0_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "quant_0", "role": "ce0" }} , 
 	{ "name": "quant_0_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "quant_0", "role": "q0" }} , 
 	{ "name": "quant_1_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "quant_1", "role": "address0" }} , 
 	{ "name": "quant_1_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "quant_1", "role": "ce0" }} , 
 	{ "name": "quant_1_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "quant_1", "role": "q0" }} , 
 	{ "name": "quant_2_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "quant_2", "role": "address0" }} , 
 	{ "name": "quant_2_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "quant_2", "role": "ce0" }} , 
 	{ "name": "quant_2_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "quant_2", "role": "q0" }} , 
 	{ "name": "width_c30_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "width_c30", "role": "din" }} , 
 	{ "name": "width_c30_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "width_c30", "role": "num_data_valid" }} , 
 	{ "name": "width_c30_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "width_c30", "role": "fifo_cap" }} , 
 	{ "name": "width_c30_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "width_c30", "role": "full_n" }} , 
 	{ "name": "width_c30_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "width_c30", "role": "write" }} , 
 	{ "name": "height_c32_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "height_c32", "role": "din" }} , 
 	{ "name": "height_c32_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "height_c32", "role": "num_data_valid" }} , 
 	{ "name": "height_c32_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "height_c32", "role": "fifo_cap" }} , 
 	{ "name": "height_c32_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "height_c32", "role": "full_n" }} , 
 	{ "name": "height_c32_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "height_c32", "role": "write" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "3", "5", "20", "22", "23"],
		"CDFG" : "p_anonymous_namespace_resize_and_split",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "6", "EstimateLatencyMax" : "6249414",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "pairs", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_342_2_VITIS_LOOP_344_3_fu_260", "Port" : "pairs", "Inst_start_state" : "5", "Inst_end_state" : "6"},
					{"ID" : "20", "SubInstance" : "grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_376_6_VITIS_LOOP_378_7_fu_302", "Port" : "pairs", "Inst_start_state" : "11", "Inst_end_state" : "12"}]},
			{"Name" : "tensor_pixels5", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "5", "SubInstance" : "grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275", "Port" : "tensor_pixels5", "Inst_start_state" : "8", "Inst_end_state" : "9"}]},
			{"Name" : "preview_pixels6", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_342_2_VITIS_LOOP_344_3_fu_260", "Port" : "preview_pixels6", "Inst_start_state" : "5", "Inst_end_state" : "6"},
					{"ID" : "20", "SubInstance" : "grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_376_6_VITIS_LOOP_378_7_fu_302", "Port" : "preview_pixels6", "Inst_start_state" : "11", "Inst_end_state" : "12"}]},
			{"Name" : "width", "Type" : "None", "Direction" : "I"},
			{"Name" : "height", "Type" : "None", "Direction" : "I"},
			{"Name" : "resized_w", "Type" : "None", "Direction" : "I"},
			{"Name" : "resized_h", "Type" : "None", "Direction" : "I"},
			{"Name" : "pad_x", "Type" : "None", "Direction" : "I"},
			{"Name" : "pad_y", "Type" : "None", "Direction" : "I"},
			{"Name" : "mode", "Type" : "None", "Direction" : "I"},
			{"Name" : "flags", "Type" : "None", "Direction" : "I"},
			{"Name" : "xc_index", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "5", "SubInstance" : "grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275", "Port" : "xc_index", "Inst_start_state" : "8", "Inst_end_state" : "9"}]},
			{"Name" : "xc_weight", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "5", "SubInstance" : "grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275", "Port" : "xc_weight", "Inst_start_state" : "8", "Inst_end_state" : "9"}]},
			{"Name" : "yc_index", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "yc_weight", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "quant_0", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "5", "SubInstance" : "grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275", "Port" : "quant_0", "Inst_start_state" : "8", "Inst_end_state" : "9"}]},
			{"Name" : "quant_1", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "5", "SubInstance" : "grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275", "Port" : "quant_1", "Inst_start_state" : "8", "Inst_end_state" : "9"}]},
			{"Name" : "quant_2", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "5", "SubInstance" : "grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275", "Port" : "quant_2", "Inst_start_state" : "8", "Inst_end_state" : "9"}]},
			{"Name" : "width_c30", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "width_c30_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "height_c32", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "height_c32_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_334_1", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "12", "FirstState" : "ap_ST_fsm_state2", "LastState" : ["ap_ST_fsm_state9"], "QuitState" : ["ap_ST_fsm_state2"], "PreState" : ["ap_ST_fsm_state1"], "PostState" : ["ap_ST_fsm_state10"], "OneDepthLoop" : "0", "OneStateBlock": ""}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.rows_V_U", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.rows_V_1_U", "Parent" : "0"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_342_2_VITIS_LOOP_344_3_fu_260", "Parent" : "0", "Child" : ["4"],
		"CDFG" : "p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_342_2_VITIS_LOOP_344_3",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "2", "EstimateLatencyMax" : "9602",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "consumed", "Type" : "None", "Direction" : "I"},
			{"Name" : "mul_ln342", "Type" : "None", "Direction" : "I"},
			{"Name" : "cmp31", "Type" : "None", "Direction" : "I"},
			{"Name" : "width", "Type" : "None", "Direction" : "I"},
			{"Name" : "pairs", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "pairs_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "rows_V", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "rows_V_1", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "tobool", "Type" : "None", "Direction" : "I"},
			{"Name" : "preview_pixels6", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "preview_pixels6_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_342_2_VITIS_LOOP_344_3", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter1", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter2", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "4", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_342_2_VITIS_LOOP_344_3_fu_260.flow_control_loop_pipe_sequential_init_U", "Parent" : "3"},
	{"ID" : "5", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275", "Parent" : "0", "Child" : ["6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19"],
		"CDFG" : "p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "428", "EstimateLatencyMax" : "428",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "pad_x", "Type" : "None", "Direction" : "I"},
			{"Name" : "add43", "Type" : "None", "Direction" : "I"},
			{"Name" : "content_y", "Type" : "None", "Direction" : "I"},
			{"Name" : "pad_x_cast", "Type" : "None", "Direction" : "I"},
			{"Name" : "xc_index", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "xc_weight", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "width", "Type" : "None", "Direction" : "I"},
			{"Name" : "rows_V", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "rows_V_1", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "trunc_ln5", "Type" : "None", "Direction" : "I"},
			{"Name" : "sy1", "Type" : "None", "Direction" : "I"},
			{"Name" : "zext_ln1540", "Type" : "None", "Direction" : "I"},
			{"Name" : "quant_0", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "quant_1", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "quant_2", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "tensor_pixels5", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "tensor_pixels5_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_354_4", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter11", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter11", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "6", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275.mux_21_24_1_1_U201", "Parent" : "5"},
	{"ID" : "7", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275.mux_21_24_1_1_U202", "Parent" : "5"},
	{"ID" : "8", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275.mux_21_24_1_1_U203", "Parent" : "5"},
	{"ID" : "9", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275.mux_21_24_1_1_U204", "Parent" : "5"},
	{"ID" : "10", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275.mac_muladd_12ns_9s_19ns_20_4_1_U205", "Parent" : "5"},
	{"ID" : "11", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275.mac_muladd_12ns_9s_19ns_20_4_1_U206", "Parent" : "5"},
	{"ID" : "12", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275.mac_muladd_12ns_9s_19ns_20_4_1_U207", "Parent" : "5"},
	{"ID" : "13", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275.mac_muladd_12ns_9s_20ns_20_4_1_U208", "Parent" : "5"},
	{"ID" : "14", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275.mac_muladd_12ns_9s_20ns_20_4_1_U209", "Parent" : "5"},
	{"ID" : "15", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275.mac_muladd_12ns_9s_20ns_20_4_1_U210", "Parent" : "5"},
	{"ID" : "16", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275.mac_muladd_20s_12ns_22ns_30_4_1_U211", "Parent" : "5"},
	{"ID" : "17", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275.mac_muladd_20s_12ns_22ns_30_4_1_U212", "Parent" : "5"},
	{"ID" : "18", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275.mac_muladd_20s_12ns_22ns_30_4_1_U213", "Parent" : "5"},
	{"ID" : "19", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275.flow_control_loop_pipe_sequential_init_U", "Parent" : "5"},
	{"ID" : "20", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_376_6_VITIS_LOOP_378_7_fu_302", "Parent" : "0", "Child" : ["21"],
		"CDFG" : "p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_376_6_VITIS_LOOP_378_7",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "2", "EstimateLatencyMax" : "2073602",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "mul_ln332", "Type" : "None", "Direction" : "I"},
			{"Name" : "pairs", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "pairs_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "cmp130", "Type" : "None", "Direction" : "I"},
			{"Name" : "preview_pixels6", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "preview_pixels6_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_376_6_VITIS_LOOP_378_7", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter1", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter2", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "21", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_376_6_VITIS_LOOP_378_7_fu_302.flow_control_loop_pipe_sequential_init_U", "Parent" : "20"},
	{"ID" : "22", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_32ns_32ns_64_1_1_U238", "Parent" : "0"},
	{"ID" : "23", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_32ns_32ns_64_1_1_U239", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	p_anonymous_namespace_resize_and_split {
		pairs {Type I LastRead 2 FirstWrite -1}
		tensor_pixels5 {Type O LastRead -1 FirstWrite 11}
		preview_pixels6 {Type O LastRead -1 FirstWrite 2}
		width {Type I LastRead 0 FirstWrite -1}
		height {Type I LastRead 0 FirstWrite -1}
		resized_w {Type I LastRead 0 FirstWrite -1}
		resized_h {Type I LastRead 0 FirstWrite -1}
		pad_x {Type I LastRead 0 FirstWrite -1}
		pad_y {Type I LastRead 0 FirstWrite -1}
		mode {Type I LastRead 0 FirstWrite -1}
		flags {Type I LastRead 0 FirstWrite -1}
		xc_index {Type I LastRead 0 FirstWrite -1}
		xc_weight {Type I LastRead 2 FirstWrite -1}
		yc_index {Type I LastRead 1 FirstWrite -1}
		yc_weight {Type I LastRead 1 FirstWrite -1}
		quant_0 {Type I LastRead 10 FirstWrite -1}
		quant_1 {Type I LastRead 10 FirstWrite -1}
		quant_2 {Type I LastRead 10 FirstWrite -1}
		width_c30 {Type O LastRead -1 FirstWrite 0}
		height_c32 {Type O LastRead -1 FirstWrite 0}}
	p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_342_2_VITIS_LOOP_344_3 {
		consumed {Type I LastRead 0 FirstWrite -1}
		mul_ln342 {Type I LastRead 0 FirstWrite -1}
		cmp31 {Type I LastRead 0 FirstWrite -1}
		width {Type I LastRead 0 FirstWrite -1}
		pairs {Type I LastRead 2 FirstWrite -1}
		rows_V {Type O LastRead -1 FirstWrite 2}
		rows_V_1 {Type O LastRead -1 FirstWrite 2}
		tobool {Type I LastRead 0 FirstWrite -1}
		preview_pixels6 {Type O LastRead -1 FirstWrite 2}}
	p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4 {
		pad_x {Type I LastRead 0 FirstWrite -1}
		add43 {Type I LastRead 0 FirstWrite -1}
		content_y {Type I LastRead 0 FirstWrite -1}
		pad_x_cast {Type I LastRead 0 FirstWrite -1}
		xc_index {Type I LastRead 0 FirstWrite -1}
		xc_weight {Type I LastRead 2 FirstWrite -1}
		width {Type I LastRead 0 FirstWrite -1}
		rows_V {Type I LastRead 3 FirstWrite -1}
		rows_V_1 {Type I LastRead 3 FirstWrite -1}
		trunc_ln5 {Type I LastRead 0 FirstWrite -1}
		sy1 {Type I LastRead 0 FirstWrite -1}
		zext_ln1540 {Type I LastRead 0 FirstWrite -1}
		quant_0 {Type I LastRead 10 FirstWrite -1}
		quant_1 {Type I LastRead 10 FirstWrite -1}
		quant_2 {Type I LastRead 10 FirstWrite -1}
		tensor_pixels5 {Type O LastRead -1 FirstWrite 11}}
	p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_376_6_VITIS_LOOP_378_7 {
		mul_ln332 {Type I LastRead 0 FirstWrite -1}
		pairs {Type I LastRead 2 FirstWrite -1}
		cmp130 {Type I LastRead 0 FirstWrite -1}
		preview_pixels6 {Type O LastRead -1 FirstWrite 2}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "6", "Max" : "6249414"}
	, {"Name" : "Interval", "Min" : "6", "Max" : "6249414"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	pairs { ap_fifo {  { pairs_dout fifo_port_we 0 48 }  { pairs_num_data_valid fifo_status_num_data_valid 0 7 }  { pairs_fifo_cap fifo_update 0 7 }  { pairs_empty_n fifo_status 0 1 }  { pairs_read fifo_data 1 1 } } }
	tensor_pixels5 { ap_fifo {  { tensor_pixels5_din fifo_port_we 1 24 }  { tensor_pixels5_num_data_valid fifo_status_num_data_valid 0 7 }  { tensor_pixels5_fifo_cap fifo_update 0 7 }  { tensor_pixels5_full_n fifo_status 0 1 }  { tensor_pixels5_write fifo_data 1 1 } } }
	preview_pixels6 { ap_fifo {  { preview_pixels6_din fifo_port_we 1 24 }  { preview_pixels6_num_data_valid fifo_status_num_data_valid 0 7 }  { preview_pixels6_fifo_cap fifo_update 0 7 }  { preview_pixels6_full_n fifo_status 0 1 }  { preview_pixels6_write fifo_data 1 1 } } }
	width { ap_none {  { width in_data 0 32 } } }
	height { ap_none {  { height in_data 0 32 } } }
	resized_w { ap_none {  { resized_w in_data 0 32 } } }
	resized_h { ap_none {  { resized_h in_data 0 32 } } }
	pad_x { ap_none {  { pad_x in_data 0 32 } } }
	pad_y { ap_none {  { pad_y in_data 0 32 } } }
	mode { ap_none {  { mode in_data 0 32 } } }
	flags { ap_none {  { flags in_data 0 3 } } }
	xc_index { ap_memory {  { xc_index_address0 mem_address 1 9 }  { xc_index_ce0 mem_ce 1 1 }  { xc_index_q0 mem_dout 0 11 } } }
	xc_weight { ap_memory {  { xc_weight_address0 mem_address 1 9 }  { xc_weight_ce0 mem_ce 1 1 }  { xc_weight_q0 mem_dout 0 12 } } }
	yc_index { ap_memory {  { yc_index_address0 mem_address 1 9 }  { yc_index_ce0 mem_ce 1 1 }  { yc_index_q0 mem_dout 0 11 } } }
	yc_weight { ap_memory {  { yc_weight_address0 mem_address 1 9 }  { yc_weight_ce0 mem_ce 1 1 }  { yc_weight_q0 mem_dout 0 12 } } }
	quant_0 { ap_memory {  { quant_0_address0 mem_address 1 8 }  { quant_0_ce0 mem_ce 1 1 }  { quant_0_q0 mem_dout 0 8 } } }
	quant_1 { ap_memory {  { quant_1_address0 mem_address 1 8 }  { quant_1_ce0 mem_ce 1 1 }  { quant_1_q0 mem_dout 0 8 } } }
	quant_2 { ap_memory {  { quant_2_address0 mem_address 1 8 }  { quant_2_ce0 mem_ce 1 1 }  { quant_2_q0 mem_dout 0 8 } } }
	width_c30 { ap_fifo {  { width_c30_din fifo_port_we 1 32 }  { width_c30_num_data_valid fifo_status_num_data_valid 0 2 }  { width_c30_fifo_cap fifo_update 0 2 }  { width_c30_full_n fifo_status 0 1 }  { width_c30_write fifo_data 1 1 } } }
	height_c32 { ap_fifo {  { height_c32_din fifo_port_we 1 32 }  { height_c32_num_data_valid fifo_status_num_data_valid 0 2 }  { height_c32_fifo_cap fifo_update 0 2 }  { height_c32_full_n fifo_status 0 1 }  { height_c32_write fifo_data 1 1 } } }
}
