set moduleName yolo_postprocess_Pipeline_VITIS_LOOP_145_7
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
set C_modelName {yolo_postprocess_Pipeline_VITIS_LOOP_145_7}
set C_modelType { void 0 }
set C_modelArgList {
	{ select_ln127_8 int 21 regular  }
	{ word_V_2 int 128 regular  }
	{ gmem_in int 128 regular {axi_master 0}  }
	{ lut int 32 regular {array 1792 { 1 3 } 1 1 }  }
	{ input_r int 64 regular  }
	{ coords_3_out int 11 regular {pointer 1}  }
	{ coords_2_out int 11 regular {pointer 1}  }
	{ coords_1_out int 11 regular {pointer 1}  }
	{ coords_out int 11 regular {pointer 1}  }
	{ best_logit_out int 8 regular {pointer 1}  }
	{ cls_out int 32 regular {pointer 1}  }
	{ obj_out int 32 regular {pointer 1}  }
	{ word_V_3_out int 128 regular {pointer 1}  }
}
set C_modelArgMapList {[ 
	{ "Name" : "select_ln127_8", "interface" : "wire", "bitwidth" : 21, "direction" : "READONLY"} , 
 	{ "Name" : "word_V_2", "interface" : "wire", "bitwidth" : 128, "direction" : "READONLY"} , 
 	{ "Name" : "gmem_in", "interface" : "axi_master", "bitwidth" : 128, "direction" : "READONLY", "bitSlice":[ {"cElement": [{"cName": "input_r","offset": { "type": "dynamic","port_name": "input_r","bundle": "control"},"direction": "READONLY"},{"cName": "tables","offset": { "type": "dynamic","port_name": "tables","bundle": "control"},"direction": "READONLY"}]}]} , 
 	{ "Name" : "lut", "interface" : "memory", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "input_r", "interface" : "wire", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "coords_3_out", "interface" : "wire", "bitwidth" : 11, "direction" : "WRITEONLY"} , 
 	{ "Name" : "coords_2_out", "interface" : "wire", "bitwidth" : 11, "direction" : "WRITEONLY"} , 
 	{ "Name" : "coords_1_out", "interface" : "wire", "bitwidth" : 11, "direction" : "WRITEONLY"} , 
 	{ "Name" : "coords_out", "interface" : "wire", "bitwidth" : 11, "direction" : "WRITEONLY"} , 
 	{ "Name" : "best_logit_out", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "cls_out", "interface" : "wire", "bitwidth" : 32, "direction" : "WRITEONLY"} , 
 	{ "Name" : "obj_out", "interface" : "wire", "bitwidth" : 32, "direction" : "WRITEONLY"} , 
 	{ "Name" : "word_V_3_out", "interface" : "wire", "bitwidth" : 128, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 74
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ m_axi_gmem_in_AWVALID sc_out sc_logic 1 signal 2 } 
	{ m_axi_gmem_in_AWREADY sc_in sc_logic 1 signal 2 } 
	{ m_axi_gmem_in_AWADDR sc_out sc_lv 64 signal 2 } 
	{ m_axi_gmem_in_AWID sc_out sc_lv 1 signal 2 } 
	{ m_axi_gmem_in_AWLEN sc_out sc_lv 32 signal 2 } 
	{ m_axi_gmem_in_AWSIZE sc_out sc_lv 3 signal 2 } 
	{ m_axi_gmem_in_AWBURST sc_out sc_lv 2 signal 2 } 
	{ m_axi_gmem_in_AWLOCK sc_out sc_lv 2 signal 2 } 
	{ m_axi_gmem_in_AWCACHE sc_out sc_lv 4 signal 2 } 
	{ m_axi_gmem_in_AWPROT sc_out sc_lv 3 signal 2 } 
	{ m_axi_gmem_in_AWQOS sc_out sc_lv 4 signal 2 } 
	{ m_axi_gmem_in_AWREGION sc_out sc_lv 4 signal 2 } 
	{ m_axi_gmem_in_AWUSER sc_out sc_lv 1 signal 2 } 
	{ m_axi_gmem_in_WVALID sc_out sc_logic 1 signal 2 } 
	{ m_axi_gmem_in_WREADY sc_in sc_logic 1 signal 2 } 
	{ m_axi_gmem_in_WDATA sc_out sc_lv 128 signal 2 } 
	{ m_axi_gmem_in_WSTRB sc_out sc_lv 16 signal 2 } 
	{ m_axi_gmem_in_WLAST sc_out sc_logic 1 signal 2 } 
	{ m_axi_gmem_in_WID sc_out sc_lv 1 signal 2 } 
	{ m_axi_gmem_in_WUSER sc_out sc_lv 1 signal 2 } 
	{ m_axi_gmem_in_ARVALID sc_out sc_logic 1 signal 2 } 
	{ m_axi_gmem_in_ARREADY sc_in sc_logic 1 signal 2 } 
	{ m_axi_gmem_in_ARADDR sc_out sc_lv 64 signal 2 } 
	{ m_axi_gmem_in_ARID sc_out sc_lv 1 signal 2 } 
	{ m_axi_gmem_in_ARLEN sc_out sc_lv 32 signal 2 } 
	{ m_axi_gmem_in_ARSIZE sc_out sc_lv 3 signal 2 } 
	{ m_axi_gmem_in_ARBURST sc_out sc_lv 2 signal 2 } 
	{ m_axi_gmem_in_ARLOCK sc_out sc_lv 2 signal 2 } 
	{ m_axi_gmem_in_ARCACHE sc_out sc_lv 4 signal 2 } 
	{ m_axi_gmem_in_ARPROT sc_out sc_lv 3 signal 2 } 
	{ m_axi_gmem_in_ARQOS sc_out sc_lv 4 signal 2 } 
	{ m_axi_gmem_in_ARREGION sc_out sc_lv 4 signal 2 } 
	{ m_axi_gmem_in_ARUSER sc_out sc_lv 1 signal 2 } 
	{ m_axi_gmem_in_RVALID sc_in sc_logic 1 signal 2 } 
	{ m_axi_gmem_in_RREADY sc_out sc_logic 1 signal 2 } 
	{ m_axi_gmem_in_RDATA sc_in sc_lv 128 signal 2 } 
	{ m_axi_gmem_in_RLAST sc_in sc_logic 1 signal 2 } 
	{ m_axi_gmem_in_RID sc_in sc_lv 1 signal 2 } 
	{ m_axi_gmem_in_RFIFONUM sc_in sc_lv 7 signal 2 } 
	{ m_axi_gmem_in_RUSER sc_in sc_lv 1 signal 2 } 
	{ m_axi_gmem_in_RRESP sc_in sc_lv 2 signal 2 } 
	{ m_axi_gmem_in_BVALID sc_in sc_logic 1 signal 2 } 
	{ m_axi_gmem_in_BREADY sc_out sc_logic 1 signal 2 } 
	{ m_axi_gmem_in_BRESP sc_in sc_lv 2 signal 2 } 
	{ m_axi_gmem_in_BID sc_in sc_lv 1 signal 2 } 
	{ m_axi_gmem_in_BUSER sc_in sc_lv 1 signal 2 } 
	{ select_ln127_8 sc_in sc_lv 21 signal 0 } 
	{ word_V_2 sc_in sc_lv 128 signal 1 } 
	{ lut_address0 sc_out sc_lv 11 signal 3 } 
	{ lut_ce0 sc_out sc_logic 1 signal 3 } 
	{ lut_q0 sc_in sc_lv 32 signal 3 } 
	{ input_r sc_in sc_lv 64 signal 4 } 
	{ coords_3_out sc_out sc_lv 11 signal 5 } 
	{ coords_3_out_ap_vld sc_out sc_logic 1 outvld 5 } 
	{ coords_2_out sc_out sc_lv 11 signal 6 } 
	{ coords_2_out_ap_vld sc_out sc_logic 1 outvld 6 } 
	{ coords_1_out sc_out sc_lv 11 signal 7 } 
	{ coords_1_out_ap_vld sc_out sc_logic 1 outvld 7 } 
	{ coords_out sc_out sc_lv 11 signal 8 } 
	{ coords_out_ap_vld sc_out sc_logic 1 outvld 8 } 
	{ best_logit_out sc_out sc_lv 8 signal 9 } 
	{ best_logit_out_ap_vld sc_out sc_logic 1 outvld 9 } 
	{ cls_out sc_out sc_lv 32 signal 10 } 
	{ cls_out_ap_vld sc_out sc_logic 1 outvld 10 } 
	{ obj_out sc_out sc_lv 32 signal 11 } 
	{ obj_out_ap_vld sc_out sc_logic 1 outvld 11 } 
	{ word_V_3_out sc_out sc_lv 128 signal 12 } 
	{ word_V_3_out_ap_vld sc_out sc_logic 1 outvld 12 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "m_axi_gmem_in_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_in", "role": "AWVALID" }} , 
 	{ "name": "m_axi_gmem_in_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_in", "role": "AWREADY" }} , 
 	{ "name": "m_axi_gmem_in_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem_in", "role": "AWADDR" }} , 
 	{ "name": "m_axi_gmem_in_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_in", "role": "AWID" }} , 
 	{ "name": "m_axi_gmem_in_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem_in", "role": "AWLEN" }} , 
 	{ "name": "m_axi_gmem_in_AWSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem_in", "role": "AWSIZE" }} , 
 	{ "name": "m_axi_gmem_in_AWBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem_in", "role": "AWBURST" }} , 
 	{ "name": "m_axi_gmem_in_AWLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem_in", "role": "AWLOCK" }} , 
 	{ "name": "m_axi_gmem_in_AWCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem_in", "role": "AWCACHE" }} , 
 	{ "name": "m_axi_gmem_in_AWPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem_in", "role": "AWPROT" }} , 
 	{ "name": "m_axi_gmem_in_AWQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem_in", "role": "AWQOS" }} , 
 	{ "name": "m_axi_gmem_in_AWREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem_in", "role": "AWREGION" }} , 
 	{ "name": "m_axi_gmem_in_AWUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_in", "role": "AWUSER" }} , 
 	{ "name": "m_axi_gmem_in_WVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_in", "role": "WVALID" }} , 
 	{ "name": "m_axi_gmem_in_WREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_in", "role": "WREADY" }} , 
 	{ "name": "m_axi_gmem_in_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "gmem_in", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem_in_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "gmem_in", "role": "WSTRB" }} , 
 	{ "name": "m_axi_gmem_in_WLAST", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_in", "role": "WLAST" }} , 
 	{ "name": "m_axi_gmem_in_WID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_in", "role": "WID" }} , 
 	{ "name": "m_axi_gmem_in_WUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_in", "role": "WUSER" }} , 
 	{ "name": "m_axi_gmem_in_ARVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_in", "role": "ARVALID" }} , 
 	{ "name": "m_axi_gmem_in_ARREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_in", "role": "ARREADY" }} , 
 	{ "name": "m_axi_gmem_in_ARADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem_in", "role": "ARADDR" }} , 
 	{ "name": "m_axi_gmem_in_ARID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_in", "role": "ARID" }} , 
 	{ "name": "m_axi_gmem_in_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem_in", "role": "ARLEN" }} , 
 	{ "name": "m_axi_gmem_in_ARSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem_in", "role": "ARSIZE" }} , 
 	{ "name": "m_axi_gmem_in_ARBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem_in", "role": "ARBURST" }} , 
 	{ "name": "m_axi_gmem_in_ARLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem_in", "role": "ARLOCK" }} , 
 	{ "name": "m_axi_gmem_in_ARCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem_in", "role": "ARCACHE" }} , 
 	{ "name": "m_axi_gmem_in_ARPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem_in", "role": "ARPROT" }} , 
 	{ "name": "m_axi_gmem_in_ARQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem_in", "role": "ARQOS" }} , 
 	{ "name": "m_axi_gmem_in_ARREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem_in", "role": "ARREGION" }} , 
 	{ "name": "m_axi_gmem_in_ARUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_in", "role": "ARUSER" }} , 
 	{ "name": "m_axi_gmem_in_RVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_in", "role": "RVALID" }} , 
 	{ "name": "m_axi_gmem_in_RREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_in", "role": "RREADY" }} , 
 	{ "name": "m_axi_gmem_in_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "gmem_in", "role": "RDATA" }} , 
 	{ "name": "m_axi_gmem_in_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_in", "role": "RLAST" }} , 
 	{ "name": "m_axi_gmem_in_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_in", "role": "RID" }} , 
 	{ "name": "m_axi_gmem_in_RFIFONUM", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "gmem_in", "role": "RFIFONUM" }} , 
 	{ "name": "m_axi_gmem_in_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_in", "role": "RUSER" }} , 
 	{ "name": "m_axi_gmem_in_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem_in", "role": "RRESP" }} , 
 	{ "name": "m_axi_gmem_in_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_in", "role": "BVALID" }} , 
 	{ "name": "m_axi_gmem_in_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_in", "role": "BREADY" }} , 
 	{ "name": "m_axi_gmem_in_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem_in", "role": "BRESP" }} , 
 	{ "name": "m_axi_gmem_in_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_in", "role": "BID" }} , 
 	{ "name": "m_axi_gmem_in_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_in", "role": "BUSER" }} , 
 	{ "name": "select_ln127_8", "direction": "in", "datatype": "sc_lv", "bitwidth":21, "type": "signal", "bundle":{"name": "select_ln127_8", "role": "default" }} , 
 	{ "name": "word_V_2", "direction": "in", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "word_V_2", "role": "default" }} , 
 	{ "name": "lut_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "lut", "role": "address0" }} , 
 	{ "name": "lut_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "lut", "role": "ce0" }} , 
 	{ "name": "lut_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "lut", "role": "q0" }} , 
 	{ "name": "input_r", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "input_r", "role": "default" }} , 
 	{ "name": "coords_3_out", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "coords_3_out", "role": "default" }} , 
 	{ "name": "coords_3_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "coords_3_out", "role": "ap_vld" }} , 
 	{ "name": "coords_2_out", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "coords_2_out", "role": "default" }} , 
 	{ "name": "coords_2_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "coords_2_out", "role": "ap_vld" }} , 
 	{ "name": "coords_1_out", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "coords_1_out", "role": "default" }} , 
 	{ "name": "coords_1_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "coords_1_out", "role": "ap_vld" }} , 
 	{ "name": "coords_out", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "coords_out", "role": "default" }} , 
 	{ "name": "coords_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "coords_out", "role": "ap_vld" }} , 
 	{ "name": "best_logit_out", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "best_logit_out", "role": "default" }} , 
 	{ "name": "best_logit_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "best_logit_out", "role": "ap_vld" }} , 
 	{ "name": "cls_out", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "cls_out", "role": "default" }} , 
 	{ "name": "cls_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "cls_out", "role": "ap_vld" }} , 
 	{ "name": "obj_out", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "obj_out", "role": "default" }} , 
 	{ "name": "obj_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "obj_out", "role": "ap_vld" }} , 
 	{ "name": "word_V_3_out", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "word_V_3_out", "role": "default" }} , 
 	{ "name": "word_V_3_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "word_V_3_out", "role": "ap_vld" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1"],
		"CDFG" : "yolo_postprocess_Pipeline_VITIS_LOOP_145_7",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "97", "EstimateLatencyMax" : "97",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "select_ln127_8", "Type" : "None", "Direction" : "I"},
			{"Name" : "word_V_2", "Type" : "None", "Direction" : "I"},
			{"Name" : "gmem_in", "Type" : "MAXI", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "gmem_in_blk_n_AR", "Type" : "RtlSignal"},
					{"Name" : "gmem_in_blk_n_R", "Type" : "RtlSignal"}]},
			{"Name" : "lut", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "input_r", "Type" : "None", "Direction" : "I"},
			{"Name" : "coords_3_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "coords_2_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "coords_1_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "coords_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "best_logit_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "cls_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "obj_out", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "word_V_3_out", "Type" : "Vld", "Direction" : "O"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_145_7", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter11", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter10", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.flow_control_loop_pipe_sequential_init_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	yolo_postprocess_Pipeline_VITIS_LOOP_145_7 {
		select_ln127_8 {Type I LastRead 0 FirstWrite -1}
		word_V_2 {Type I LastRead 0 FirstWrite -1}
		gmem_in {Type I LastRead 8 FirstWrite -1}
		lut {Type I LastRead 10 FirstWrite -1}
		input_r {Type I LastRead 0 FirstWrite -1}
		coords_3_out {Type O LastRead -1 FirstWrite 10}
		coords_2_out {Type O LastRead -1 FirstWrite 10}
		coords_1_out {Type O LastRead -1 FirstWrite 10}
		coords_out {Type O LastRead -1 FirstWrite 10}
		best_logit_out {Type O LastRead -1 FirstWrite 10}
		cls_out {Type O LastRead -1 FirstWrite 10}
		obj_out {Type O LastRead -1 FirstWrite 10}
		word_V_3_out {Type O LastRead -1 FirstWrite 10}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "97", "Max" : "97"}
	, {"Name" : "Interval", "Min" : "97", "Max" : "97"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	select_ln127_8 { ap_none {  { select_ln127_8 in_data 0 21 } } }
	word_V_2 { ap_none {  { word_V_2 in_data 0 128 } } }
	 { m_axi {  { m_axi_gmem_in_AWVALID VALID 1 1 }  { m_axi_gmem_in_AWREADY READY 0 1 }  { m_axi_gmem_in_AWADDR ADDR 1 64 }  { m_axi_gmem_in_AWID ID 1 1 }  { m_axi_gmem_in_AWLEN SIZE 1 32 }  { m_axi_gmem_in_AWSIZE BURST 1 3 }  { m_axi_gmem_in_AWBURST LOCK 1 2 }  { m_axi_gmem_in_AWLOCK CACHE 1 2 }  { m_axi_gmem_in_AWCACHE PROT 1 4 }  { m_axi_gmem_in_AWPROT QOS 1 3 }  { m_axi_gmem_in_AWQOS REGION 1 4 }  { m_axi_gmem_in_AWREGION USER 1 4 }  { m_axi_gmem_in_AWUSER DATA 1 1 }  { m_axi_gmem_in_WVALID VALID 1 1 }  { m_axi_gmem_in_WREADY READY 0 1 }  { m_axi_gmem_in_WDATA FIFONUM 1 128 }  { m_axi_gmem_in_WSTRB STRB 1 16 }  { m_axi_gmem_in_WLAST LAST 1 1 }  { m_axi_gmem_in_WID ID 1 1 }  { m_axi_gmem_in_WUSER DATA 1 1 }  { m_axi_gmem_in_ARVALID VALID 1 1 }  { m_axi_gmem_in_ARREADY READY 0 1 }  { m_axi_gmem_in_ARADDR ADDR 1 64 }  { m_axi_gmem_in_ARID ID 1 1 }  { m_axi_gmem_in_ARLEN SIZE 1 32 }  { m_axi_gmem_in_ARSIZE BURST 1 3 }  { m_axi_gmem_in_ARBURST LOCK 1 2 }  { m_axi_gmem_in_ARLOCK CACHE 1 2 }  { m_axi_gmem_in_ARCACHE PROT 1 4 }  { m_axi_gmem_in_ARPROT QOS 1 3 }  { m_axi_gmem_in_ARQOS REGION 1 4 }  { m_axi_gmem_in_ARREGION USER 1 4 }  { m_axi_gmem_in_ARUSER DATA 1 1 }  { m_axi_gmem_in_RVALID VALID 0 1 }  { m_axi_gmem_in_RREADY READY 1 1 }  { m_axi_gmem_in_RDATA FIFONUM 0 128 }  { m_axi_gmem_in_RLAST LAST 0 1 }  { m_axi_gmem_in_RID ID 0 1 }  { m_axi_gmem_in_RFIFONUM LEN 0 7 }  { m_axi_gmem_in_RUSER DATA 0 1 }  { m_axi_gmem_in_RRESP RESP 0 2 }  { m_axi_gmem_in_BVALID VALID 0 1 }  { m_axi_gmem_in_BREADY READY 1 1 }  { m_axi_gmem_in_BRESP RESP 0 2 }  { m_axi_gmem_in_BID ID 0 1 }  { m_axi_gmem_in_BUSER DATA 0 1 } } }
	lut { ap_memory {  { lut_address0 mem_address 1 11 }  { lut_ce0 mem_ce 1 1 }  { lut_q0 in_data 0 32 } } }
	input_r { ap_none {  { input_r in_data 0 64 } } }
	coords_3_out { ap_vld {  { coords_3_out out_data 1 11 }  { coords_3_out_ap_vld out_vld 1 1 } } }
	coords_2_out { ap_vld {  { coords_2_out out_data 1 11 }  { coords_2_out_ap_vld out_vld 1 1 } } }
	coords_1_out { ap_vld {  { coords_1_out out_data 1 11 }  { coords_1_out_ap_vld out_vld 1 1 } } }
	coords_out { ap_vld {  { coords_out out_data 1 11 }  { coords_out_ap_vld out_vld 1 1 } } }
	best_logit_out { ap_vld {  { best_logit_out out_data 1 8 }  { best_logit_out_ap_vld out_vld 1 1 } } }
	cls_out { ap_vld {  { cls_out out_data 1 32 }  { cls_out_ap_vld out_vld 1 1 } } }
	obj_out { ap_vld {  { obj_out out_data 1 32 }  { obj_out_ap_vld out_vld 1 1 } } }
	word_V_3_out { ap_vld {  { word_V_3_out out_data 1 128 }  { word_V_3_out_ap_vld out_vld 1 1 } } }
}
