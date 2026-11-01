set moduleName entry_proc
set isTopModule 0
set isCombinational 0
set isDatapathOnly 0
set isPipelined 0
set pipeline_type none
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 1
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set hasInterrupt 0
set C_modelName {entry_proc}
set C_modelType { void 0 }
set C_modelArgList {
	{ tensor int 64 regular  }
	{ tensor_c int 64 regular {fifo 1}  }
	{ preview int 64 regular  }
	{ preview_c int 64 regular {fifo 1}  }
	{ preview_stride int 13 regular  }
	{ preview_stride_c int 13 regular {fifo 1}  }
	{ collect int 1 regular  }
	{ collect_c int 1 regular {fifo 1}  }
}
set C_modelArgMapList {[ 
	{ "Name" : "tensor", "interface" : "wire", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "tensor_c", "interface" : "fifo", "bitwidth" : 64, "direction" : "WRITEONLY"} , 
 	{ "Name" : "preview", "interface" : "wire", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "preview_c", "interface" : "fifo", "bitwidth" : 64, "direction" : "WRITEONLY"} , 
 	{ "Name" : "preview_stride", "interface" : "wire", "bitwidth" : 13, "direction" : "READONLY"} , 
 	{ "Name" : "preview_stride_c", "interface" : "fifo", "bitwidth" : 13, "direction" : "WRITEONLY"} , 
 	{ "Name" : "collect", "interface" : "wire", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "collect_c", "interface" : "fifo", "bitwidth" : 1, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 34
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ start_full_n sc_in sc_logic 1 signal -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ start_out sc_out sc_logic 1 signal -1 } 
	{ start_write sc_out sc_logic 1 signal -1 } 
	{ tensor sc_in sc_lv 64 signal 0 } 
	{ tensor_c_din sc_out sc_lv 64 signal 1 } 
	{ tensor_c_num_data_valid sc_in sc_lv 4 signal 1 } 
	{ tensor_c_fifo_cap sc_in sc_lv 4 signal 1 } 
	{ tensor_c_full_n sc_in sc_logic 1 signal 1 } 
	{ tensor_c_write sc_out sc_logic 1 signal 1 } 
	{ preview sc_in sc_lv 64 signal 2 } 
	{ preview_c_din sc_out sc_lv 64 signal 3 } 
	{ preview_c_num_data_valid sc_in sc_lv 4 signal 3 } 
	{ preview_c_fifo_cap sc_in sc_lv 4 signal 3 } 
	{ preview_c_full_n sc_in sc_logic 1 signal 3 } 
	{ preview_c_write sc_out sc_logic 1 signal 3 } 
	{ preview_stride sc_in sc_lv 13 signal 4 } 
	{ preview_stride_c_din sc_out sc_lv 13 signal 5 } 
	{ preview_stride_c_num_data_valid sc_in sc_lv 4 signal 5 } 
	{ preview_stride_c_fifo_cap sc_in sc_lv 4 signal 5 } 
	{ preview_stride_c_full_n sc_in sc_logic 1 signal 5 } 
	{ preview_stride_c_write sc_out sc_logic 1 signal 5 } 
	{ collect sc_in sc_lv 1 signal 6 } 
	{ collect_c_din sc_out sc_lv 1 signal 7 } 
	{ collect_c_num_data_valid sc_in sc_lv 4 signal 7 } 
	{ collect_c_fifo_cap sc_in sc_lv 4 signal 7 } 
	{ collect_c_full_n sc_in sc_logic 1 signal 7 } 
	{ collect_c_write sc_out sc_logic 1 signal 7 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "start_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "start_full_n", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "start_out", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "start_out", "role": "default" }} , 
 	{ "name": "start_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "start_write", "role": "default" }} , 
 	{ "name": "tensor", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "tensor", "role": "default" }} , 
 	{ "name": "tensor_c_din", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "tensor_c", "role": "din" }} , 
 	{ "name": "tensor_c_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "tensor_c", "role": "num_data_valid" }} , 
 	{ "name": "tensor_c_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "tensor_c", "role": "fifo_cap" }} , 
 	{ "name": "tensor_c_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "tensor_c", "role": "full_n" }} , 
 	{ "name": "tensor_c_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "tensor_c", "role": "write" }} , 
 	{ "name": "preview", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "preview", "role": "default" }} , 
 	{ "name": "preview_c_din", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "preview_c", "role": "din" }} , 
 	{ "name": "preview_c_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "preview_c", "role": "num_data_valid" }} , 
 	{ "name": "preview_c_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "preview_c", "role": "fifo_cap" }} , 
 	{ "name": "preview_c_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "preview_c", "role": "full_n" }} , 
 	{ "name": "preview_c_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "preview_c", "role": "write" }} , 
 	{ "name": "preview_stride", "direction": "in", "datatype": "sc_lv", "bitwidth":13, "type": "signal", "bundle":{"name": "preview_stride", "role": "default" }} , 
 	{ "name": "preview_stride_c_din", "direction": "out", "datatype": "sc_lv", "bitwidth":13, "type": "signal", "bundle":{"name": "preview_stride_c", "role": "din" }} , 
 	{ "name": "preview_stride_c_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "preview_stride_c", "role": "num_data_valid" }} , 
 	{ "name": "preview_stride_c_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "preview_stride_c", "role": "fifo_cap" }} , 
 	{ "name": "preview_stride_c_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "preview_stride_c", "role": "full_n" }} , 
 	{ "name": "preview_stride_c_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "preview_stride_c", "role": "write" }} , 
 	{ "name": "collect", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "collect", "role": "default" }} , 
 	{ "name": "collect_c_din", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "collect_c", "role": "din" }} , 
 	{ "name": "collect_c_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "collect_c", "role": "num_data_valid" }} , 
 	{ "name": "collect_c_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "collect_c", "role": "fifo_cap" }} , 
 	{ "name": "collect_c_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "collect_c", "role": "full_n" }} , 
 	{ "name": "collect_c_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "collect_c", "role": "write" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "",
		"CDFG" : "entry_proc",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "1",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "1",
		"VariableLatency" : "0", "ExactLatency" : "0", "EstimateLatencyMin" : "0", "EstimateLatencyMax" : "0",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "tensor", "Type" : "None", "Direction" : "I"},
			{"Name" : "tensor_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "7", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "tensor_c_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "preview", "Type" : "None", "Direction" : "I"},
			{"Name" : "preview_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "7", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "preview_c_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "preview_stride", "Type" : "None", "Direction" : "I"},
			{"Name" : "preview_stride_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "7", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "preview_stride_c_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "collect", "Type" : "None", "Direction" : "I"},
			{"Name" : "collect_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "5", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "collect_c_blk_n", "Type" : "RtlSignal"}]}]}]}


set ArgLastReadFirstWriteLatency {
	entry_proc {
		tensor {Type I LastRead 0 FirstWrite -1}
		tensor_c {Type O LastRead -1 FirstWrite 0}
		preview {Type I LastRead 0 FirstWrite -1}
		preview_c {Type O LastRead -1 FirstWrite 0}
		preview_stride {Type I LastRead 0 FirstWrite -1}
		preview_stride_c {Type O LastRead -1 FirstWrite 0}
		collect {Type I LastRead 0 FirstWrite -1}
		collect_c {Type O LastRead -1 FirstWrite 0}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "0", "Max" : "0"}
	, {"Name" : "Interval", "Min" : "0", "Max" : "0"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	tensor { ap_none {  { tensor in_data 0 64 } } }
	tensor_c { ap_fifo {  { tensor_c_din fifo_port_we 1 64 }  { tensor_c_num_data_valid fifo_status_num_data_valid 0 4 }  { tensor_c_fifo_cap fifo_update 0 4 }  { tensor_c_full_n fifo_status 0 1 }  { tensor_c_write fifo_data 1 1 } } }
	preview { ap_none {  { preview in_data 0 64 } } }
	preview_c { ap_fifo {  { preview_c_din fifo_port_we 1 64 }  { preview_c_num_data_valid fifo_status_num_data_valid 0 4 }  { preview_c_fifo_cap fifo_update 0 4 }  { preview_c_full_n fifo_status 0 1 }  { preview_c_write fifo_data 1 1 } } }
	preview_stride { ap_none {  { preview_stride in_data 0 13 } } }
	preview_stride_c { ap_fifo {  { preview_stride_c_din fifo_port_we 1 13 }  { preview_stride_c_num_data_valid fifo_status_num_data_valid 0 4 }  { preview_stride_c_fifo_cap fifo_update 0 4 }  { preview_stride_c_full_n fifo_status 0 1 }  { preview_stride_c_write fifo_data 1 1 } } }
	collect { ap_none {  { collect in_data 0 1 } } }
	collect_c { ap_fifo {  { collect_c_din fifo_port_we 1 1 }  { collect_c_num_data_valid fifo_status_num_data_valid 0 4 }  { collect_c_fifo_cap fifo_update 0 4 }  { collect_c_full_n fifo_status 0 1 }  { collect_c_write fifo_data 1 1 } } }
}
