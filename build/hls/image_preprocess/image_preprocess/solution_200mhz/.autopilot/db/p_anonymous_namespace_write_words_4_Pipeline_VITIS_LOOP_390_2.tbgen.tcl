set moduleName p_anonymous_namespace_write_words_4_Pipeline_VITIS_LOOP_390_2
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
set C_modelName {(anonymous namespace)write_words.4_Pipeline_VITIS_LOOP_390_2}
set C_modelType { void 0 }
set C_modelArgList {
	{ gmem_preview int 128 regular {axi_master 1}  }
	{ sext_ln390 int 60 regular  }
	{ count int 28 regular  }
	{ preview_words int 128 regular {fifo 0 volatile }  }
}
set C_modelArgMapList {[ 
	{ "Name" : "gmem_preview", "interface" : "axi_master", "bitwidth" : 128, "direction" : "WRITEONLY", "bitSlice":[ {"cElement": [{"cName": "preview","offset": { "type": "dynamic","port_name": "preview","bundle": "control"},"direction": "WRITEONLY"}]}]} , 
 	{ "Name" : "sext_ln390", "interface" : "wire", "bitwidth" : 60, "direction" : "READONLY"} , 
 	{ "Name" : "count", "interface" : "wire", "bitwidth" : 28, "direction" : "READONLY"} , 
 	{ "Name" : "preview_words", "interface" : "fifo", "bitwidth" : 128, "direction" : "READONLY"} ]}
# RTL Port declarations: 
set portNum 59
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ preview_words_dout sc_in sc_lv 128 signal 3 } 
	{ preview_words_num_data_valid sc_in sc_lv 7 signal 3 } 
	{ preview_words_fifo_cap sc_in sc_lv 7 signal 3 } 
	{ preview_words_empty_n sc_in sc_logic 1 signal 3 } 
	{ preview_words_read sc_out sc_logic 1 signal 3 } 
	{ m_axi_gmem_preview_AWVALID sc_out sc_logic 1 signal 0 } 
	{ m_axi_gmem_preview_AWREADY sc_in sc_logic 1 signal 0 } 
	{ m_axi_gmem_preview_AWADDR sc_out sc_lv 64 signal 0 } 
	{ m_axi_gmem_preview_AWID sc_out sc_lv 1 signal 0 } 
	{ m_axi_gmem_preview_AWLEN sc_out sc_lv 32 signal 0 } 
	{ m_axi_gmem_preview_AWSIZE sc_out sc_lv 3 signal 0 } 
	{ m_axi_gmem_preview_AWBURST sc_out sc_lv 2 signal 0 } 
	{ m_axi_gmem_preview_AWLOCK sc_out sc_lv 2 signal 0 } 
	{ m_axi_gmem_preview_AWCACHE sc_out sc_lv 4 signal 0 } 
	{ m_axi_gmem_preview_AWPROT sc_out sc_lv 3 signal 0 } 
	{ m_axi_gmem_preview_AWQOS sc_out sc_lv 4 signal 0 } 
	{ m_axi_gmem_preview_AWREGION sc_out sc_lv 4 signal 0 } 
	{ m_axi_gmem_preview_AWUSER sc_out sc_lv 1 signal 0 } 
	{ m_axi_gmem_preview_WVALID sc_out sc_logic 1 signal 0 } 
	{ m_axi_gmem_preview_WREADY sc_in sc_logic 1 signal 0 } 
	{ m_axi_gmem_preview_WDATA sc_out sc_lv 128 signal 0 } 
	{ m_axi_gmem_preview_WSTRB sc_out sc_lv 16 signal 0 } 
	{ m_axi_gmem_preview_WLAST sc_out sc_logic 1 signal 0 } 
	{ m_axi_gmem_preview_WID sc_out sc_lv 1 signal 0 } 
	{ m_axi_gmem_preview_WUSER sc_out sc_lv 1 signal 0 } 
	{ m_axi_gmem_preview_ARVALID sc_out sc_logic 1 signal 0 } 
	{ m_axi_gmem_preview_ARREADY sc_in sc_logic 1 signal 0 } 
	{ m_axi_gmem_preview_ARADDR sc_out sc_lv 64 signal 0 } 
	{ m_axi_gmem_preview_ARID sc_out sc_lv 1 signal 0 } 
	{ m_axi_gmem_preview_ARLEN sc_out sc_lv 32 signal 0 } 
	{ m_axi_gmem_preview_ARSIZE sc_out sc_lv 3 signal 0 } 
	{ m_axi_gmem_preview_ARBURST sc_out sc_lv 2 signal 0 } 
	{ m_axi_gmem_preview_ARLOCK sc_out sc_lv 2 signal 0 } 
	{ m_axi_gmem_preview_ARCACHE sc_out sc_lv 4 signal 0 } 
	{ m_axi_gmem_preview_ARPROT sc_out sc_lv 3 signal 0 } 
	{ m_axi_gmem_preview_ARQOS sc_out sc_lv 4 signal 0 } 
	{ m_axi_gmem_preview_ARREGION sc_out sc_lv 4 signal 0 } 
	{ m_axi_gmem_preview_ARUSER sc_out sc_lv 1 signal 0 } 
	{ m_axi_gmem_preview_RVALID sc_in sc_logic 1 signal 0 } 
	{ m_axi_gmem_preview_RREADY sc_out sc_logic 1 signal 0 } 
	{ m_axi_gmem_preview_RDATA sc_in sc_lv 128 signal 0 } 
	{ m_axi_gmem_preview_RLAST sc_in sc_logic 1 signal 0 } 
	{ m_axi_gmem_preview_RID sc_in sc_lv 1 signal 0 } 
	{ m_axi_gmem_preview_RFIFONUM sc_in sc_lv 9 signal 0 } 
	{ m_axi_gmem_preview_RUSER sc_in sc_lv 1 signal 0 } 
	{ m_axi_gmem_preview_RRESP sc_in sc_lv 2 signal 0 } 
	{ m_axi_gmem_preview_BVALID sc_in sc_logic 1 signal 0 } 
	{ m_axi_gmem_preview_BREADY sc_out sc_logic 1 signal 0 } 
	{ m_axi_gmem_preview_BRESP sc_in sc_lv 2 signal 0 } 
	{ m_axi_gmem_preview_BID sc_in sc_lv 1 signal 0 } 
	{ m_axi_gmem_preview_BUSER sc_in sc_lv 1 signal 0 } 
	{ sext_ln390 sc_in sc_lv 60 signal 1 } 
	{ count sc_in sc_lv 28 signal 2 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "preview_words_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "preview_words", "role": "dout" }} , 
 	{ "name": "preview_words_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "preview_words", "role": "num_data_valid" }} , 
 	{ "name": "preview_words_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "preview_words", "role": "fifo_cap" }} , 
 	{ "name": "preview_words_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "preview_words", "role": "empty_n" }} , 
 	{ "name": "preview_words_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "preview_words", "role": "read" }} , 
 	{ "name": "m_axi_gmem_preview_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_preview", "role": "AWVALID" }} , 
 	{ "name": "m_axi_gmem_preview_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_preview", "role": "AWREADY" }} , 
 	{ "name": "m_axi_gmem_preview_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem_preview", "role": "AWADDR" }} , 
 	{ "name": "m_axi_gmem_preview_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_preview", "role": "AWID" }} , 
 	{ "name": "m_axi_gmem_preview_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem_preview", "role": "AWLEN" }} , 
 	{ "name": "m_axi_gmem_preview_AWSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem_preview", "role": "AWSIZE" }} , 
 	{ "name": "m_axi_gmem_preview_AWBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem_preview", "role": "AWBURST" }} , 
 	{ "name": "m_axi_gmem_preview_AWLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem_preview", "role": "AWLOCK" }} , 
 	{ "name": "m_axi_gmem_preview_AWCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem_preview", "role": "AWCACHE" }} , 
 	{ "name": "m_axi_gmem_preview_AWPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem_preview", "role": "AWPROT" }} , 
 	{ "name": "m_axi_gmem_preview_AWQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem_preview", "role": "AWQOS" }} , 
 	{ "name": "m_axi_gmem_preview_AWREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem_preview", "role": "AWREGION" }} , 
 	{ "name": "m_axi_gmem_preview_AWUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_preview", "role": "AWUSER" }} , 
 	{ "name": "m_axi_gmem_preview_WVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_preview", "role": "WVALID" }} , 
 	{ "name": "m_axi_gmem_preview_WREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_preview", "role": "WREADY" }} , 
 	{ "name": "m_axi_gmem_preview_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "gmem_preview", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem_preview_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "gmem_preview", "role": "WSTRB" }} , 
 	{ "name": "m_axi_gmem_preview_WLAST", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_preview", "role": "WLAST" }} , 
 	{ "name": "m_axi_gmem_preview_WID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_preview", "role": "WID" }} , 
 	{ "name": "m_axi_gmem_preview_WUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_preview", "role": "WUSER" }} , 
 	{ "name": "m_axi_gmem_preview_ARVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_preview", "role": "ARVALID" }} , 
 	{ "name": "m_axi_gmem_preview_ARREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_preview", "role": "ARREADY" }} , 
 	{ "name": "m_axi_gmem_preview_ARADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem_preview", "role": "ARADDR" }} , 
 	{ "name": "m_axi_gmem_preview_ARID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_preview", "role": "ARID" }} , 
 	{ "name": "m_axi_gmem_preview_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem_preview", "role": "ARLEN" }} , 
 	{ "name": "m_axi_gmem_preview_ARSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem_preview", "role": "ARSIZE" }} , 
 	{ "name": "m_axi_gmem_preview_ARBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem_preview", "role": "ARBURST" }} , 
 	{ "name": "m_axi_gmem_preview_ARLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem_preview", "role": "ARLOCK" }} , 
 	{ "name": "m_axi_gmem_preview_ARCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem_preview", "role": "ARCACHE" }} , 
 	{ "name": "m_axi_gmem_preview_ARPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem_preview", "role": "ARPROT" }} , 
 	{ "name": "m_axi_gmem_preview_ARQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem_preview", "role": "ARQOS" }} , 
 	{ "name": "m_axi_gmem_preview_ARREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem_preview", "role": "ARREGION" }} , 
 	{ "name": "m_axi_gmem_preview_ARUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_preview", "role": "ARUSER" }} , 
 	{ "name": "m_axi_gmem_preview_RVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_preview", "role": "RVALID" }} , 
 	{ "name": "m_axi_gmem_preview_RREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_preview", "role": "RREADY" }} , 
 	{ "name": "m_axi_gmem_preview_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "gmem_preview", "role": "RDATA" }} , 
 	{ "name": "m_axi_gmem_preview_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_preview", "role": "RLAST" }} , 
 	{ "name": "m_axi_gmem_preview_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_preview", "role": "RID" }} , 
 	{ "name": "m_axi_gmem_preview_RFIFONUM", "direction": "in", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "gmem_preview", "role": "RFIFONUM" }} , 
 	{ "name": "m_axi_gmem_preview_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_preview", "role": "RUSER" }} , 
 	{ "name": "m_axi_gmem_preview_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem_preview", "role": "RRESP" }} , 
 	{ "name": "m_axi_gmem_preview_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_preview", "role": "BVALID" }} , 
 	{ "name": "m_axi_gmem_preview_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_preview", "role": "BREADY" }} , 
 	{ "name": "m_axi_gmem_preview_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem_preview", "role": "BRESP" }} , 
 	{ "name": "m_axi_gmem_preview_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_preview", "role": "BID" }} , 
 	{ "name": "m_axi_gmem_preview_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_preview", "role": "BUSER" }} , 
 	{ "name": "sext_ln390", "direction": "in", "datatype": "sc_lv", "bitwidth":60, "type": "signal", "bundle":{"name": "sext_ln390", "role": "default" }} , 
 	{ "name": "count", "direction": "in", "datatype": "sc_lv", "bitwidth":28, "type": "signal", "bundle":{"name": "count", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1"],
		"CDFG" : "p_anonymous_namespace_write_words_4_Pipeline_VITIS_LOOP_390_2",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "81", "EstimateLatencyMax" : "363",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "gmem_preview", "Type" : "MAXI", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "gmem_preview_blk_n_W", "Type" : "RtlSignal"}]},
			{"Name" : "sext_ln390", "Type" : "None", "Direction" : "I"},
			{"Name" : "count", "Type" : "None", "Direction" : "I"},
			{"Name" : "preview_words", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "preview_words_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_390_2", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter2", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.flow_control_loop_pipe_sequential_init_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	p_anonymous_namespace_write_words_4_Pipeline_VITIS_LOOP_390_2 {
		gmem_preview {Type O LastRead -1 FirstWrite 2}
		sext_ln390 {Type I LastRead 0 FirstWrite -1}
		count {Type I LastRead 0 FirstWrite -1}
		preview_words {Type I LastRead 1 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "81", "Max" : "363"}
	, {"Name" : "Interval", "Min" : "81", "Max" : "363"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	 { m_axi {  { m_axi_gmem_preview_AWVALID VALID 1 1 }  { m_axi_gmem_preview_AWREADY READY 0 1 }  { m_axi_gmem_preview_AWADDR ADDR 1 64 }  { m_axi_gmem_preview_AWID ID 1 1 }  { m_axi_gmem_preview_AWLEN SIZE 1 32 }  { m_axi_gmem_preview_AWSIZE BURST 1 3 }  { m_axi_gmem_preview_AWBURST LOCK 1 2 }  { m_axi_gmem_preview_AWLOCK CACHE 1 2 }  { m_axi_gmem_preview_AWCACHE PROT 1 4 }  { m_axi_gmem_preview_AWPROT QOS 1 3 }  { m_axi_gmem_preview_AWQOS REGION 1 4 }  { m_axi_gmem_preview_AWREGION USER 1 4 }  { m_axi_gmem_preview_AWUSER DATA 1 1 }  { m_axi_gmem_preview_WVALID VALID 1 1 }  { m_axi_gmem_preview_WREADY READY 0 1 }  { m_axi_gmem_preview_WDATA FIFONUM 1 128 }  { m_axi_gmem_preview_WSTRB STRB 1 16 }  { m_axi_gmem_preview_WLAST LAST 1 1 }  { m_axi_gmem_preview_WID ID 1 1 }  { m_axi_gmem_preview_WUSER DATA 1 1 }  { m_axi_gmem_preview_ARVALID VALID 1 1 }  { m_axi_gmem_preview_ARREADY READY 0 1 }  { m_axi_gmem_preview_ARADDR ADDR 1 64 }  { m_axi_gmem_preview_ARID ID 1 1 }  { m_axi_gmem_preview_ARLEN SIZE 1 32 }  { m_axi_gmem_preview_ARSIZE BURST 1 3 }  { m_axi_gmem_preview_ARBURST LOCK 1 2 }  { m_axi_gmem_preview_ARLOCK CACHE 1 2 }  { m_axi_gmem_preview_ARCACHE PROT 1 4 }  { m_axi_gmem_preview_ARPROT QOS 1 3 }  { m_axi_gmem_preview_ARQOS REGION 1 4 }  { m_axi_gmem_preview_ARREGION USER 1 4 }  { m_axi_gmem_preview_ARUSER DATA 1 1 }  { m_axi_gmem_preview_RVALID VALID 0 1 }  { m_axi_gmem_preview_RREADY READY 1 1 }  { m_axi_gmem_preview_RDATA FIFONUM 0 128 }  { m_axi_gmem_preview_RLAST LAST 0 1 }  { m_axi_gmem_preview_RID ID 0 1 }  { m_axi_gmem_preview_RFIFONUM LEN 0 9 }  { m_axi_gmem_preview_RUSER DATA 0 1 }  { m_axi_gmem_preview_RRESP RESP 0 2 }  { m_axi_gmem_preview_BVALID VALID 0 1 }  { m_axi_gmem_preview_BREADY READY 1 1 }  { m_axi_gmem_preview_BRESP RESP 0 2 }  { m_axi_gmem_preview_BID ID 0 1 }  { m_axi_gmem_preview_BUSER DATA 0 1 } } }
	sext_ln390 { ap_none {  { sext_ln390 in_data 0 60 } } }
	count { ap_none {  { count in_data 0 28 } } }
	preview_words { ap_fifo {  { preview_words_dout fifo_port_we 0 128 }  { preview_words_num_data_valid fifo_status_num_data_valid 0 7 }  { preview_words_fifo_cap fifo_update 0 7 }  { preview_words_empty_n fifo_status 0 1 }  { preview_words_read fifo_data 1 1 } } }
}
