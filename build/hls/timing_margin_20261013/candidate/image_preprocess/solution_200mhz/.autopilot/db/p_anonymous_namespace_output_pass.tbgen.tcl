set moduleName p_anonymous_namespace_output_pass
set isTopModule 0
set isCombinational 0
set isDatapathOnly 0
set isPipelined 1
set pipeline_type dataflow
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set hasInterrupt 0
set C_modelName {(anonymous namespace)output_pass}
set C_modelType { void 0 }
set C_modelArgList {
	{ gmem_in int 128 regular {axi_master 0}  }
	{ src int 64 regular  }
	{ gmem_out int 128 regular {axi_master 1}  }
	{ tensor int 64 regular  }
	{ gmem_preview int 128 regular {axi_master 1}  }
	{ preview int 64 regular  }
	{ width int 32 regular  }
	{ height int 32 regular  }
	{ stride int 13 regular  }
	{ preview_stride int 13 regular  }
	{ rw int 32 regular  }
	{ rh int 32 regular  }
	{ px int 32 regular  }
	{ py int 32 regular  }
	{ mode int 32 regular  }
	{ flags int 3 regular  }
	{ saturation int 14 regular  }
	{ eq_enabled uint 1 regular  }
	{ collect uint 1 regular  }
	{ color_0 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ color_1 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ color_2 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ quant_0 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ quant_1 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ quant_2 int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ eq int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ hist int 32 regular {array 256 { 1 0 } 1 1 }  }
	{ xc_index int 11 regular {array 416 { 1 } 1 1 }  }
	{ xc_weight int 12 regular {array 416 { 1 } 1 1 }  }
	{ yc_index int 11 regular {array 416 { 1 } 1 1 }  }
	{ yc_weight int 12 regular {array 416 { 1 } 1 1 }  }
}
set C_modelArgMapList {[ 
	{ "Name" : "gmem_in", "interface" : "axi_master", "bitwidth" : 128, "direction" : "READONLY", "bitSlice":[ {"cElement": [{"cName": "src","offset": { "type": "dynamic","port_name": "src","bundle": "control"},"direction": "READONLY"},{"cName": "luts","offset": { "type": "dynamic","port_name": "luts","bundle": "control"},"direction": "READONLY"}]}]} , 
 	{ "Name" : "src", "interface" : "wire", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "gmem_out", "interface" : "axi_master", "bitwidth" : 128, "direction" : "WRITEONLY", "bitSlice":[ {"cElement": [{"cName": "tensor","offset": { "type": "dynamic","port_name": "tensor","bundle": "control"},"direction": "WRITEONLY"}]}]} , 
 	{ "Name" : "tensor", "interface" : "wire", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "gmem_preview", "interface" : "axi_master", "bitwidth" : 128, "direction" : "WRITEONLY", "bitSlice":[ {"cElement": [{"cName": "preview","offset": { "type": "dynamic","port_name": "preview","bundle": "control"},"direction": "WRITEONLY"}]}]} , 
 	{ "Name" : "preview", "interface" : "wire", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "width", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "height", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "stride", "interface" : "wire", "bitwidth" : 13, "direction" : "READONLY"} , 
 	{ "Name" : "preview_stride", "interface" : "wire", "bitwidth" : 13, "direction" : "READONLY"} , 
 	{ "Name" : "rw", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "rh", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "px", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "py", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "mode", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "flags", "interface" : "wire", "bitwidth" : 3, "direction" : "READONLY"} , 
 	{ "Name" : "saturation", "interface" : "wire", "bitwidth" : 14, "direction" : "READONLY"} , 
 	{ "Name" : "eq_enabled", "interface" : "wire", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "collect", "interface" : "wire", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "color_0", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "color_1", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "color_2", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "quant_0", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "quant_1", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "quant_2", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "eq", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "hist", "interface" : "memory", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "xc_index", "interface" : "memory", "bitwidth" : 11, "direction" : "READONLY"} , 
 	{ "Name" : "xc_weight", "interface" : "memory", "bitwidth" : 12, "direction" : "READONLY"} , 
 	{ "Name" : "yc_index", "interface" : "memory", "bitwidth" : 11, "direction" : "READONLY"} , 
 	{ "Name" : "yc_weight", "interface" : "memory", "bitwidth" : 12, "direction" : "READONLY"} ]}
# RTL Port declarations: 
set portNum 277
set portList { 
	{ m_axi_gmem_in_AWVALID sc_out sc_logic 1 signal 0 } 
	{ m_axi_gmem_in_AWREADY sc_in sc_logic 1 signal 0 } 
	{ m_axi_gmem_in_AWADDR sc_out sc_lv 64 signal 0 } 
	{ m_axi_gmem_in_AWID sc_out sc_lv 1 signal 0 } 
	{ m_axi_gmem_in_AWLEN sc_out sc_lv 32 signal 0 } 
	{ m_axi_gmem_in_AWSIZE sc_out sc_lv 3 signal 0 } 
	{ m_axi_gmem_in_AWBURST sc_out sc_lv 2 signal 0 } 
	{ m_axi_gmem_in_AWLOCK sc_out sc_lv 2 signal 0 } 
	{ m_axi_gmem_in_AWCACHE sc_out sc_lv 4 signal 0 } 
	{ m_axi_gmem_in_AWPROT sc_out sc_lv 3 signal 0 } 
	{ m_axi_gmem_in_AWQOS sc_out sc_lv 4 signal 0 } 
	{ m_axi_gmem_in_AWREGION sc_out sc_lv 4 signal 0 } 
	{ m_axi_gmem_in_AWUSER sc_out sc_lv 1 signal 0 } 
	{ m_axi_gmem_in_WVALID sc_out sc_logic 1 signal 0 } 
	{ m_axi_gmem_in_WREADY sc_in sc_logic 1 signal 0 } 
	{ m_axi_gmem_in_WDATA sc_out sc_lv 128 signal 0 } 
	{ m_axi_gmem_in_WSTRB sc_out sc_lv 16 signal 0 } 
	{ m_axi_gmem_in_WLAST sc_out sc_logic 1 signal 0 } 
	{ m_axi_gmem_in_WID sc_out sc_lv 1 signal 0 } 
	{ m_axi_gmem_in_WUSER sc_out sc_lv 1 signal 0 } 
	{ m_axi_gmem_in_ARVALID sc_out sc_logic 1 signal 0 } 
	{ m_axi_gmem_in_ARREADY sc_in sc_logic 1 signal 0 } 
	{ m_axi_gmem_in_ARADDR sc_out sc_lv 64 signal 0 } 
	{ m_axi_gmem_in_ARID sc_out sc_lv 1 signal 0 } 
	{ m_axi_gmem_in_ARLEN sc_out sc_lv 32 signal 0 } 
	{ m_axi_gmem_in_ARSIZE sc_out sc_lv 3 signal 0 } 
	{ m_axi_gmem_in_ARBURST sc_out sc_lv 2 signal 0 } 
	{ m_axi_gmem_in_ARLOCK sc_out sc_lv 2 signal 0 } 
	{ m_axi_gmem_in_ARCACHE sc_out sc_lv 4 signal 0 } 
	{ m_axi_gmem_in_ARPROT sc_out sc_lv 3 signal 0 } 
	{ m_axi_gmem_in_ARQOS sc_out sc_lv 4 signal 0 } 
	{ m_axi_gmem_in_ARREGION sc_out sc_lv 4 signal 0 } 
	{ m_axi_gmem_in_ARUSER sc_out sc_lv 1 signal 0 } 
	{ m_axi_gmem_in_RVALID sc_in sc_logic 1 signal 0 } 
	{ m_axi_gmem_in_RREADY sc_out sc_logic 1 signal 0 } 
	{ m_axi_gmem_in_RDATA sc_in sc_lv 128 signal 0 } 
	{ m_axi_gmem_in_RLAST sc_in sc_logic 1 signal 0 } 
	{ m_axi_gmem_in_RID sc_in sc_lv 1 signal 0 } 
	{ m_axi_gmem_in_RFIFONUM sc_in sc_lv 7 signal 0 } 
	{ m_axi_gmem_in_RUSER sc_in sc_lv 1 signal 0 } 
	{ m_axi_gmem_in_RRESP sc_in sc_lv 2 signal 0 } 
	{ m_axi_gmem_in_BVALID sc_in sc_logic 1 signal 0 } 
	{ m_axi_gmem_in_BREADY sc_out sc_logic 1 signal 0 } 
	{ m_axi_gmem_in_BRESP sc_in sc_lv 2 signal 0 } 
	{ m_axi_gmem_in_BID sc_in sc_lv 1 signal 0 } 
	{ m_axi_gmem_in_BUSER sc_in sc_lv 1 signal 0 } 
	{ src sc_in sc_lv 64 signal 1 } 
	{ m_axi_gmem_out_AWVALID sc_out sc_logic 1 signal 2 } 
	{ m_axi_gmem_out_AWREADY sc_in sc_logic 1 signal 2 } 
	{ m_axi_gmem_out_AWADDR sc_out sc_lv 64 signal 2 } 
	{ m_axi_gmem_out_AWID sc_out sc_lv 1 signal 2 } 
	{ m_axi_gmem_out_AWLEN sc_out sc_lv 32 signal 2 } 
	{ m_axi_gmem_out_AWSIZE sc_out sc_lv 3 signal 2 } 
	{ m_axi_gmem_out_AWBURST sc_out sc_lv 2 signal 2 } 
	{ m_axi_gmem_out_AWLOCK sc_out sc_lv 2 signal 2 } 
	{ m_axi_gmem_out_AWCACHE sc_out sc_lv 4 signal 2 } 
	{ m_axi_gmem_out_AWPROT sc_out sc_lv 3 signal 2 } 
	{ m_axi_gmem_out_AWQOS sc_out sc_lv 4 signal 2 } 
	{ m_axi_gmem_out_AWREGION sc_out sc_lv 4 signal 2 } 
	{ m_axi_gmem_out_AWUSER sc_out sc_lv 1 signal 2 } 
	{ m_axi_gmem_out_WVALID sc_out sc_logic 1 signal 2 } 
	{ m_axi_gmem_out_WREADY sc_in sc_logic 1 signal 2 } 
	{ m_axi_gmem_out_WDATA sc_out sc_lv 128 signal 2 } 
	{ m_axi_gmem_out_WSTRB sc_out sc_lv 16 signal 2 } 
	{ m_axi_gmem_out_WLAST sc_out sc_logic 1 signal 2 } 
	{ m_axi_gmem_out_WID sc_out sc_lv 1 signal 2 } 
	{ m_axi_gmem_out_WUSER sc_out sc_lv 1 signal 2 } 
	{ m_axi_gmem_out_ARVALID sc_out sc_logic 1 signal 2 } 
	{ m_axi_gmem_out_ARREADY sc_in sc_logic 1 signal 2 } 
	{ m_axi_gmem_out_ARADDR sc_out sc_lv 64 signal 2 } 
	{ m_axi_gmem_out_ARID sc_out sc_lv 1 signal 2 } 
	{ m_axi_gmem_out_ARLEN sc_out sc_lv 32 signal 2 } 
	{ m_axi_gmem_out_ARSIZE sc_out sc_lv 3 signal 2 } 
	{ m_axi_gmem_out_ARBURST sc_out sc_lv 2 signal 2 } 
	{ m_axi_gmem_out_ARLOCK sc_out sc_lv 2 signal 2 } 
	{ m_axi_gmem_out_ARCACHE sc_out sc_lv 4 signal 2 } 
	{ m_axi_gmem_out_ARPROT sc_out sc_lv 3 signal 2 } 
	{ m_axi_gmem_out_ARQOS sc_out sc_lv 4 signal 2 } 
	{ m_axi_gmem_out_ARREGION sc_out sc_lv 4 signal 2 } 
	{ m_axi_gmem_out_ARUSER sc_out sc_lv 1 signal 2 } 
	{ m_axi_gmem_out_RVALID sc_in sc_logic 1 signal 2 } 
	{ m_axi_gmem_out_RREADY sc_out sc_logic 1 signal 2 } 
	{ m_axi_gmem_out_RDATA sc_in sc_lv 128 signal 2 } 
	{ m_axi_gmem_out_RLAST sc_in sc_logic 1 signal 2 } 
	{ m_axi_gmem_out_RID sc_in sc_lv 1 signal 2 } 
	{ m_axi_gmem_out_RFIFONUM sc_in sc_lv 9 signal 2 } 
	{ m_axi_gmem_out_RUSER sc_in sc_lv 1 signal 2 } 
	{ m_axi_gmem_out_RRESP sc_in sc_lv 2 signal 2 } 
	{ m_axi_gmem_out_BVALID sc_in sc_logic 1 signal 2 } 
	{ m_axi_gmem_out_BREADY sc_out sc_logic 1 signal 2 } 
	{ m_axi_gmem_out_BRESP sc_in sc_lv 2 signal 2 } 
	{ m_axi_gmem_out_BID sc_in sc_lv 1 signal 2 } 
	{ m_axi_gmem_out_BUSER sc_in sc_lv 1 signal 2 } 
	{ tensor sc_in sc_lv 64 signal 3 } 
	{ m_axi_gmem_preview_AWVALID sc_out sc_logic 1 signal 4 } 
	{ m_axi_gmem_preview_AWREADY sc_in sc_logic 1 signal 4 } 
	{ m_axi_gmem_preview_AWADDR sc_out sc_lv 64 signal 4 } 
	{ m_axi_gmem_preview_AWID sc_out sc_lv 1 signal 4 } 
	{ m_axi_gmem_preview_AWLEN sc_out sc_lv 32 signal 4 } 
	{ m_axi_gmem_preview_AWSIZE sc_out sc_lv 3 signal 4 } 
	{ m_axi_gmem_preview_AWBURST sc_out sc_lv 2 signal 4 } 
	{ m_axi_gmem_preview_AWLOCK sc_out sc_lv 2 signal 4 } 
	{ m_axi_gmem_preview_AWCACHE sc_out sc_lv 4 signal 4 } 
	{ m_axi_gmem_preview_AWPROT sc_out sc_lv 3 signal 4 } 
	{ m_axi_gmem_preview_AWQOS sc_out sc_lv 4 signal 4 } 
	{ m_axi_gmem_preview_AWREGION sc_out sc_lv 4 signal 4 } 
	{ m_axi_gmem_preview_AWUSER sc_out sc_lv 1 signal 4 } 
	{ m_axi_gmem_preview_WVALID sc_out sc_logic 1 signal 4 } 
	{ m_axi_gmem_preview_WREADY sc_in sc_logic 1 signal 4 } 
	{ m_axi_gmem_preview_WDATA sc_out sc_lv 128 signal 4 } 
	{ m_axi_gmem_preview_WSTRB sc_out sc_lv 16 signal 4 } 
	{ m_axi_gmem_preview_WLAST sc_out sc_logic 1 signal 4 } 
	{ m_axi_gmem_preview_WID sc_out sc_lv 1 signal 4 } 
	{ m_axi_gmem_preview_WUSER sc_out sc_lv 1 signal 4 } 
	{ m_axi_gmem_preview_ARVALID sc_out sc_logic 1 signal 4 } 
	{ m_axi_gmem_preview_ARREADY sc_in sc_logic 1 signal 4 } 
	{ m_axi_gmem_preview_ARADDR sc_out sc_lv 64 signal 4 } 
	{ m_axi_gmem_preview_ARID sc_out sc_lv 1 signal 4 } 
	{ m_axi_gmem_preview_ARLEN sc_out sc_lv 32 signal 4 } 
	{ m_axi_gmem_preview_ARSIZE sc_out sc_lv 3 signal 4 } 
	{ m_axi_gmem_preview_ARBURST sc_out sc_lv 2 signal 4 } 
	{ m_axi_gmem_preview_ARLOCK sc_out sc_lv 2 signal 4 } 
	{ m_axi_gmem_preview_ARCACHE sc_out sc_lv 4 signal 4 } 
	{ m_axi_gmem_preview_ARPROT sc_out sc_lv 3 signal 4 } 
	{ m_axi_gmem_preview_ARQOS sc_out sc_lv 4 signal 4 } 
	{ m_axi_gmem_preview_ARREGION sc_out sc_lv 4 signal 4 } 
	{ m_axi_gmem_preview_ARUSER sc_out sc_lv 1 signal 4 } 
	{ m_axi_gmem_preview_RVALID sc_in sc_logic 1 signal 4 } 
	{ m_axi_gmem_preview_RREADY sc_out sc_logic 1 signal 4 } 
	{ m_axi_gmem_preview_RDATA sc_in sc_lv 128 signal 4 } 
	{ m_axi_gmem_preview_RLAST sc_in sc_logic 1 signal 4 } 
	{ m_axi_gmem_preview_RID sc_in sc_lv 1 signal 4 } 
	{ m_axi_gmem_preview_RFIFONUM sc_in sc_lv 9 signal 4 } 
	{ m_axi_gmem_preview_RUSER sc_in sc_lv 1 signal 4 } 
	{ m_axi_gmem_preview_RRESP sc_in sc_lv 2 signal 4 } 
	{ m_axi_gmem_preview_BVALID sc_in sc_logic 1 signal 4 } 
	{ m_axi_gmem_preview_BREADY sc_out sc_logic 1 signal 4 } 
	{ m_axi_gmem_preview_BRESP sc_in sc_lv 2 signal 4 } 
	{ m_axi_gmem_preview_BID sc_in sc_lv 1 signal 4 } 
	{ m_axi_gmem_preview_BUSER sc_in sc_lv 1 signal 4 } 
	{ preview sc_in sc_lv 64 signal 5 } 
	{ width sc_in sc_lv 32 signal 6 } 
	{ height sc_in sc_lv 32 signal 7 } 
	{ stride sc_in sc_lv 13 signal 8 } 
	{ preview_stride sc_in sc_lv 13 signal 9 } 
	{ rw sc_in sc_lv 32 signal 10 } 
	{ rh sc_in sc_lv 32 signal 11 } 
	{ px sc_in sc_lv 32 signal 12 } 
	{ py sc_in sc_lv 32 signal 13 } 
	{ mode sc_in sc_lv 32 signal 14 } 
	{ flags sc_in sc_lv 3 signal 15 } 
	{ saturation sc_in sc_lv 14 signal 16 } 
	{ eq_enabled sc_in sc_logic 1 signal 17 } 
	{ collect sc_in sc_logic 1 signal 18 } 
	{ color_0_address0 sc_out sc_lv 8 signal 19 } 
	{ color_0_ce0 sc_out sc_logic 1 signal 19 } 
	{ color_0_d0 sc_out sc_lv 8 signal 19 } 
	{ color_0_q0 sc_in sc_lv 8 signal 19 } 
	{ color_0_we0 sc_out sc_logic 1 signal 19 } 
	{ color_0_address1 sc_out sc_lv 8 signal 19 } 
	{ color_0_ce1 sc_out sc_logic 1 signal 19 } 
	{ color_0_d1 sc_out sc_lv 8 signal 19 } 
	{ color_0_q1 sc_in sc_lv 8 signal 19 } 
	{ color_0_we1 sc_out sc_logic 1 signal 19 } 
	{ color_1_address0 sc_out sc_lv 8 signal 20 } 
	{ color_1_ce0 sc_out sc_logic 1 signal 20 } 
	{ color_1_d0 sc_out sc_lv 8 signal 20 } 
	{ color_1_q0 sc_in sc_lv 8 signal 20 } 
	{ color_1_we0 sc_out sc_logic 1 signal 20 } 
	{ color_1_address1 sc_out sc_lv 8 signal 20 } 
	{ color_1_ce1 sc_out sc_logic 1 signal 20 } 
	{ color_1_d1 sc_out sc_lv 8 signal 20 } 
	{ color_1_q1 sc_in sc_lv 8 signal 20 } 
	{ color_1_we1 sc_out sc_logic 1 signal 20 } 
	{ color_2_address0 sc_out sc_lv 8 signal 21 } 
	{ color_2_ce0 sc_out sc_logic 1 signal 21 } 
	{ color_2_d0 sc_out sc_lv 8 signal 21 } 
	{ color_2_q0 sc_in sc_lv 8 signal 21 } 
	{ color_2_we0 sc_out sc_logic 1 signal 21 } 
	{ color_2_address1 sc_out sc_lv 8 signal 21 } 
	{ color_2_ce1 sc_out sc_logic 1 signal 21 } 
	{ color_2_d1 sc_out sc_lv 8 signal 21 } 
	{ color_2_q1 sc_in sc_lv 8 signal 21 } 
	{ color_2_we1 sc_out sc_logic 1 signal 21 } 
	{ quant_0_address0 sc_out sc_lv 8 signal 22 } 
	{ quant_0_ce0 sc_out sc_logic 1 signal 22 } 
	{ quant_0_d0 sc_out sc_lv 8 signal 22 } 
	{ quant_0_q0 sc_in sc_lv 8 signal 22 } 
	{ quant_0_we0 sc_out sc_logic 1 signal 22 } 
	{ quant_0_address1 sc_out sc_lv 8 signal 22 } 
	{ quant_0_ce1 sc_out sc_logic 1 signal 22 } 
	{ quant_0_d1 sc_out sc_lv 8 signal 22 } 
	{ quant_0_q1 sc_in sc_lv 8 signal 22 } 
	{ quant_0_we1 sc_out sc_logic 1 signal 22 } 
	{ quant_1_address0 sc_out sc_lv 8 signal 23 } 
	{ quant_1_ce0 sc_out sc_logic 1 signal 23 } 
	{ quant_1_d0 sc_out sc_lv 8 signal 23 } 
	{ quant_1_q0 sc_in sc_lv 8 signal 23 } 
	{ quant_1_we0 sc_out sc_logic 1 signal 23 } 
	{ quant_1_address1 sc_out sc_lv 8 signal 23 } 
	{ quant_1_ce1 sc_out sc_logic 1 signal 23 } 
	{ quant_1_d1 sc_out sc_lv 8 signal 23 } 
	{ quant_1_q1 sc_in sc_lv 8 signal 23 } 
	{ quant_1_we1 sc_out sc_logic 1 signal 23 } 
	{ quant_2_address0 sc_out sc_lv 8 signal 24 } 
	{ quant_2_ce0 sc_out sc_logic 1 signal 24 } 
	{ quant_2_d0 sc_out sc_lv 8 signal 24 } 
	{ quant_2_q0 sc_in sc_lv 8 signal 24 } 
	{ quant_2_we0 sc_out sc_logic 1 signal 24 } 
	{ quant_2_address1 sc_out sc_lv 8 signal 24 } 
	{ quant_2_ce1 sc_out sc_logic 1 signal 24 } 
	{ quant_2_d1 sc_out sc_lv 8 signal 24 } 
	{ quant_2_q1 sc_in sc_lv 8 signal 24 } 
	{ quant_2_we1 sc_out sc_logic 1 signal 24 } 
	{ eq_address0 sc_out sc_lv 8 signal 25 } 
	{ eq_ce0 sc_out sc_logic 1 signal 25 } 
	{ eq_d0 sc_out sc_lv 8 signal 25 } 
	{ eq_q0 sc_in sc_lv 8 signal 25 } 
	{ eq_we0 sc_out sc_logic 1 signal 25 } 
	{ eq_address1 sc_out sc_lv 8 signal 25 } 
	{ eq_ce1 sc_out sc_logic 1 signal 25 } 
	{ eq_d1 sc_out sc_lv 8 signal 25 } 
	{ eq_q1 sc_in sc_lv 8 signal 25 } 
	{ eq_we1 sc_out sc_logic 1 signal 25 } 
	{ hist_address0 sc_out sc_lv 8 signal 26 } 
	{ hist_ce0 sc_out sc_logic 1 signal 26 } 
	{ hist_d0 sc_out sc_lv 32 signal 26 } 
	{ hist_q0 sc_in sc_lv 32 signal 26 } 
	{ hist_we0 sc_out sc_logic 1 signal 26 } 
	{ hist_address1 sc_out sc_lv 8 signal 26 } 
	{ hist_ce1 sc_out sc_logic 1 signal 26 } 
	{ hist_d1 sc_out sc_lv 32 signal 26 } 
	{ hist_q1 sc_in sc_lv 32 signal 26 } 
	{ hist_we1 sc_out sc_logic 1 signal 26 } 
	{ xc_index_address0 sc_out sc_lv 9 signal 27 } 
	{ xc_index_ce0 sc_out sc_logic 1 signal 27 } 
	{ xc_index_d0 sc_out sc_lv 11 signal 27 } 
	{ xc_index_q0 sc_in sc_lv 11 signal 27 } 
	{ xc_index_we0 sc_out sc_logic 1 signal 27 } 
	{ xc_weight_address0 sc_out sc_lv 9 signal 28 } 
	{ xc_weight_ce0 sc_out sc_logic 1 signal 28 } 
	{ xc_weight_d0 sc_out sc_lv 12 signal 28 } 
	{ xc_weight_q0 sc_in sc_lv 12 signal 28 } 
	{ xc_weight_we0 sc_out sc_logic 1 signal 28 } 
	{ yc_index_address0 sc_out sc_lv 9 signal 29 } 
	{ yc_index_ce0 sc_out sc_logic 1 signal 29 } 
	{ yc_index_d0 sc_out sc_lv 11 signal 29 } 
	{ yc_index_q0 sc_in sc_lv 11 signal 29 } 
	{ yc_index_we0 sc_out sc_logic 1 signal 29 } 
	{ yc_weight_address0 sc_out sc_lv 9 signal 30 } 
	{ yc_weight_ce0 sc_out sc_logic 1 signal 30 } 
	{ yc_weight_d0 sc_out sc_lv 12 signal 30 } 
	{ yc_weight_q0 sc_in sc_lv 12 signal 30 } 
	{ yc_weight_we0 sc_out sc_logic 1 signal 30 } 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ tensor_ap_vld sc_in sc_logic 1 invld 3 } 
	{ preview_ap_vld sc_in sc_logic 1 invld 5 } 
	{ preview_stride_ap_vld sc_in sc_logic 1 invld 9 } 
	{ collect_ap_vld sc_in sc_logic 1 invld 18 } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ src_ap_vld sc_in sc_logic 1 invld 1 } 
	{ width_ap_vld sc_in sc_logic 1 invld 6 } 
	{ height_ap_vld sc_in sc_logic 1 invld 7 } 
	{ stride_ap_vld sc_in sc_logic 1 invld 8 } 
	{ flags_ap_vld sc_in sc_logic 1 invld 15 } 
	{ saturation_ap_vld sc_in sc_logic 1 invld 16 } 
	{ eq_enabled_ap_vld sc_in sc_logic 1 invld 17 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ rw_ap_vld sc_in sc_logic 1 invld 10 } 
	{ rh_ap_vld sc_in sc_logic 1 invld 11 } 
	{ px_ap_vld sc_in sc_logic 1 invld 12 } 
	{ py_ap_vld sc_in sc_logic 1 invld 13 } 
	{ mode_ap_vld sc_in sc_logic 1 invld 14 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
}
set NewPortList {[ 
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
 	{ "name": "src", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "src", "role": "default" }} , 
 	{ "name": "m_axi_gmem_out_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_out", "role": "AWVALID" }} , 
 	{ "name": "m_axi_gmem_out_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_out", "role": "AWREADY" }} , 
 	{ "name": "m_axi_gmem_out_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem_out", "role": "AWADDR" }} , 
 	{ "name": "m_axi_gmem_out_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_out", "role": "AWID" }} , 
 	{ "name": "m_axi_gmem_out_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem_out", "role": "AWLEN" }} , 
 	{ "name": "m_axi_gmem_out_AWSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem_out", "role": "AWSIZE" }} , 
 	{ "name": "m_axi_gmem_out_AWBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem_out", "role": "AWBURST" }} , 
 	{ "name": "m_axi_gmem_out_AWLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem_out", "role": "AWLOCK" }} , 
 	{ "name": "m_axi_gmem_out_AWCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem_out", "role": "AWCACHE" }} , 
 	{ "name": "m_axi_gmem_out_AWPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem_out", "role": "AWPROT" }} , 
 	{ "name": "m_axi_gmem_out_AWQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem_out", "role": "AWQOS" }} , 
 	{ "name": "m_axi_gmem_out_AWREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem_out", "role": "AWREGION" }} , 
 	{ "name": "m_axi_gmem_out_AWUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_out", "role": "AWUSER" }} , 
 	{ "name": "m_axi_gmem_out_WVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_out", "role": "WVALID" }} , 
 	{ "name": "m_axi_gmem_out_WREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_out", "role": "WREADY" }} , 
 	{ "name": "m_axi_gmem_out_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "gmem_out", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem_out_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "gmem_out", "role": "WSTRB" }} , 
 	{ "name": "m_axi_gmem_out_WLAST", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_out", "role": "WLAST" }} , 
 	{ "name": "m_axi_gmem_out_WID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_out", "role": "WID" }} , 
 	{ "name": "m_axi_gmem_out_WUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_out", "role": "WUSER" }} , 
 	{ "name": "m_axi_gmem_out_ARVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_out", "role": "ARVALID" }} , 
 	{ "name": "m_axi_gmem_out_ARREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_out", "role": "ARREADY" }} , 
 	{ "name": "m_axi_gmem_out_ARADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem_out", "role": "ARADDR" }} , 
 	{ "name": "m_axi_gmem_out_ARID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_out", "role": "ARID" }} , 
 	{ "name": "m_axi_gmem_out_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem_out", "role": "ARLEN" }} , 
 	{ "name": "m_axi_gmem_out_ARSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem_out", "role": "ARSIZE" }} , 
 	{ "name": "m_axi_gmem_out_ARBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem_out", "role": "ARBURST" }} , 
 	{ "name": "m_axi_gmem_out_ARLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem_out", "role": "ARLOCK" }} , 
 	{ "name": "m_axi_gmem_out_ARCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem_out", "role": "ARCACHE" }} , 
 	{ "name": "m_axi_gmem_out_ARPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem_out", "role": "ARPROT" }} , 
 	{ "name": "m_axi_gmem_out_ARQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem_out", "role": "ARQOS" }} , 
 	{ "name": "m_axi_gmem_out_ARREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem_out", "role": "ARREGION" }} , 
 	{ "name": "m_axi_gmem_out_ARUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_out", "role": "ARUSER" }} , 
 	{ "name": "m_axi_gmem_out_RVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_out", "role": "RVALID" }} , 
 	{ "name": "m_axi_gmem_out_RREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_out", "role": "RREADY" }} , 
 	{ "name": "m_axi_gmem_out_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "gmem_out", "role": "RDATA" }} , 
 	{ "name": "m_axi_gmem_out_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_out", "role": "RLAST" }} , 
 	{ "name": "m_axi_gmem_out_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_out", "role": "RID" }} , 
 	{ "name": "m_axi_gmem_out_RFIFONUM", "direction": "in", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "gmem_out", "role": "RFIFONUM" }} , 
 	{ "name": "m_axi_gmem_out_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_out", "role": "RUSER" }} , 
 	{ "name": "m_axi_gmem_out_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem_out", "role": "RRESP" }} , 
 	{ "name": "m_axi_gmem_out_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_out", "role": "BVALID" }} , 
 	{ "name": "m_axi_gmem_out_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_out", "role": "BREADY" }} , 
 	{ "name": "m_axi_gmem_out_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem_out", "role": "BRESP" }} , 
 	{ "name": "m_axi_gmem_out_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_out", "role": "BID" }} , 
 	{ "name": "m_axi_gmem_out_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_out", "role": "BUSER" }} , 
 	{ "name": "tensor", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "tensor", "role": "default" }} , 
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
 	{ "name": "preview", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "preview", "role": "default" }} , 
 	{ "name": "width", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "width", "role": "default" }} , 
 	{ "name": "height", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "height", "role": "default" }} , 
 	{ "name": "stride", "direction": "in", "datatype": "sc_lv", "bitwidth":13, "type": "signal", "bundle":{"name": "stride", "role": "default" }} , 
 	{ "name": "preview_stride", "direction": "in", "datatype": "sc_lv", "bitwidth":13, "type": "signal", "bundle":{"name": "preview_stride", "role": "default" }} , 
 	{ "name": "rw", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "rw", "role": "default" }} , 
 	{ "name": "rh", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "rh", "role": "default" }} , 
 	{ "name": "px", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "px", "role": "default" }} , 
 	{ "name": "py", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "py", "role": "default" }} , 
 	{ "name": "mode", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "mode", "role": "default" }} , 
 	{ "name": "flags", "direction": "in", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "flags", "role": "default" }} , 
 	{ "name": "saturation", "direction": "in", "datatype": "sc_lv", "bitwidth":14, "type": "signal", "bundle":{"name": "saturation", "role": "default" }} , 
 	{ "name": "eq_enabled", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "eq_enabled", "role": "default" }} , 
 	{ "name": "collect", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "collect", "role": "default" }} , 
 	{ "name": "color_0_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_0", "role": "address0" }} , 
 	{ "name": "color_0_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_0", "role": "ce0" }} , 
 	{ "name": "color_0_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_0", "role": "d0" }} , 
 	{ "name": "color_0_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_0", "role": "q0" }} , 
 	{ "name": "color_0_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_0", "role": "we0" }} , 
 	{ "name": "color_0_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_0", "role": "address1" }} , 
 	{ "name": "color_0_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_0", "role": "ce1" }} , 
 	{ "name": "color_0_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_0", "role": "d1" }} , 
 	{ "name": "color_0_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_0", "role": "q1" }} , 
 	{ "name": "color_0_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_0", "role": "we1" }} , 
 	{ "name": "color_1_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_1", "role": "address0" }} , 
 	{ "name": "color_1_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_1", "role": "ce0" }} , 
 	{ "name": "color_1_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_1", "role": "d0" }} , 
 	{ "name": "color_1_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_1", "role": "q0" }} , 
 	{ "name": "color_1_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_1", "role": "we0" }} , 
 	{ "name": "color_1_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_1", "role": "address1" }} , 
 	{ "name": "color_1_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_1", "role": "ce1" }} , 
 	{ "name": "color_1_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_1", "role": "d1" }} , 
 	{ "name": "color_1_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_1", "role": "q1" }} , 
 	{ "name": "color_1_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_1", "role": "we1" }} , 
 	{ "name": "color_2_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_2", "role": "address0" }} , 
 	{ "name": "color_2_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_2", "role": "ce0" }} , 
 	{ "name": "color_2_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_2", "role": "d0" }} , 
 	{ "name": "color_2_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_2", "role": "q0" }} , 
 	{ "name": "color_2_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_2", "role": "we0" }} , 
 	{ "name": "color_2_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_2", "role": "address1" }} , 
 	{ "name": "color_2_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_2", "role": "ce1" }} , 
 	{ "name": "color_2_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_2", "role": "d1" }} , 
 	{ "name": "color_2_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "color_2", "role": "q1" }} , 
 	{ "name": "color_2_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "color_2", "role": "we1" }} , 
 	{ "name": "quant_0_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "quant_0", "role": "address0" }} , 
 	{ "name": "quant_0_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "quant_0", "role": "ce0" }} , 
 	{ "name": "quant_0_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "quant_0", "role": "d0" }} , 
 	{ "name": "quant_0_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "quant_0", "role": "q0" }} , 
 	{ "name": "quant_0_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "quant_0", "role": "we0" }} , 
 	{ "name": "quant_0_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "quant_0", "role": "address1" }} , 
 	{ "name": "quant_0_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "quant_0", "role": "ce1" }} , 
 	{ "name": "quant_0_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "quant_0", "role": "d1" }} , 
 	{ "name": "quant_0_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "quant_0", "role": "q1" }} , 
 	{ "name": "quant_0_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "quant_0", "role": "we1" }} , 
 	{ "name": "quant_1_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "quant_1", "role": "address0" }} , 
 	{ "name": "quant_1_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "quant_1", "role": "ce0" }} , 
 	{ "name": "quant_1_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "quant_1", "role": "d0" }} , 
 	{ "name": "quant_1_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "quant_1", "role": "q0" }} , 
 	{ "name": "quant_1_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "quant_1", "role": "we0" }} , 
 	{ "name": "quant_1_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "quant_1", "role": "address1" }} , 
 	{ "name": "quant_1_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "quant_1", "role": "ce1" }} , 
 	{ "name": "quant_1_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "quant_1", "role": "d1" }} , 
 	{ "name": "quant_1_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "quant_1", "role": "q1" }} , 
 	{ "name": "quant_1_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "quant_1", "role": "we1" }} , 
 	{ "name": "quant_2_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "quant_2", "role": "address0" }} , 
 	{ "name": "quant_2_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "quant_2", "role": "ce0" }} , 
 	{ "name": "quant_2_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "quant_2", "role": "d0" }} , 
 	{ "name": "quant_2_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "quant_2", "role": "q0" }} , 
 	{ "name": "quant_2_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "quant_2", "role": "we0" }} , 
 	{ "name": "quant_2_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "quant_2", "role": "address1" }} , 
 	{ "name": "quant_2_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "quant_2", "role": "ce1" }} , 
 	{ "name": "quant_2_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "quant_2", "role": "d1" }} , 
 	{ "name": "quant_2_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "quant_2", "role": "q1" }} , 
 	{ "name": "quant_2_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "quant_2", "role": "we1" }} , 
 	{ "name": "eq_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "eq", "role": "address0" }} , 
 	{ "name": "eq_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "eq", "role": "ce0" }} , 
 	{ "name": "eq_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "eq", "role": "d0" }} , 
 	{ "name": "eq_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "eq", "role": "q0" }} , 
 	{ "name": "eq_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "eq", "role": "we0" }} , 
 	{ "name": "eq_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "eq", "role": "address1" }} , 
 	{ "name": "eq_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "eq", "role": "ce1" }} , 
 	{ "name": "eq_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "eq", "role": "d1" }} , 
 	{ "name": "eq_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "eq", "role": "q1" }} , 
 	{ "name": "eq_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "eq", "role": "we1" }} , 
 	{ "name": "hist_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "hist", "role": "address0" }} , 
 	{ "name": "hist_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist", "role": "ce0" }} , 
 	{ "name": "hist_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "hist", "role": "d0" }} , 
 	{ "name": "hist_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "hist", "role": "q0" }} , 
 	{ "name": "hist_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist", "role": "we0" }} , 
 	{ "name": "hist_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "hist", "role": "address1" }} , 
 	{ "name": "hist_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist", "role": "ce1" }} , 
 	{ "name": "hist_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "hist", "role": "d1" }} , 
 	{ "name": "hist_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "hist", "role": "q1" }} , 
 	{ "name": "hist_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "hist", "role": "we1" }} , 
 	{ "name": "xc_index_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "xc_index", "role": "address0" }} , 
 	{ "name": "xc_index_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xc_index", "role": "ce0" }} , 
 	{ "name": "xc_index_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "xc_index", "role": "d0" }} , 
 	{ "name": "xc_index_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "xc_index", "role": "q0" }} , 
 	{ "name": "xc_index_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xc_index", "role": "we0" }} , 
 	{ "name": "xc_weight_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "xc_weight", "role": "address0" }} , 
 	{ "name": "xc_weight_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xc_weight", "role": "ce0" }} , 
 	{ "name": "xc_weight_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":12, "type": "signal", "bundle":{"name": "xc_weight", "role": "d0" }} , 
 	{ "name": "xc_weight_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":12, "type": "signal", "bundle":{"name": "xc_weight", "role": "q0" }} , 
 	{ "name": "xc_weight_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "xc_weight", "role": "we0" }} , 
 	{ "name": "yc_index_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "yc_index", "role": "address0" }} , 
 	{ "name": "yc_index_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "yc_index", "role": "ce0" }} , 
 	{ "name": "yc_index_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "yc_index", "role": "d0" }} , 
 	{ "name": "yc_index_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "yc_index", "role": "q0" }} , 
 	{ "name": "yc_index_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "yc_index", "role": "we0" }} , 
 	{ "name": "yc_weight_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "yc_weight", "role": "address0" }} , 
 	{ "name": "yc_weight_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "yc_weight", "role": "ce0" }} , 
 	{ "name": "yc_weight_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":12, "type": "signal", "bundle":{"name": "yc_weight", "role": "d0" }} , 
 	{ "name": "yc_weight_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":12, "type": "signal", "bundle":{"name": "yc_weight", "role": "q0" }} , 
 	{ "name": "yc_weight_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "yc_weight", "role": "we0" }} , 
 	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "tensor_ap_vld", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "tensor", "role": "ap_vld" }} , 
 	{ "name": "preview_ap_vld", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "preview", "role": "ap_vld" }} , 
 	{ "name": "preview_stride_ap_vld", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "preview_stride", "role": "ap_vld" }} , 
 	{ "name": "collect_ap_vld", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "collect", "role": "ap_vld" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "src_ap_vld", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "src", "role": "ap_vld" }} , 
 	{ "name": "width_ap_vld", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "width", "role": "ap_vld" }} , 
 	{ "name": "height_ap_vld", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "height", "role": "ap_vld" }} , 
 	{ "name": "stride_ap_vld", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "stride", "role": "ap_vld" }} , 
 	{ "name": "flags_ap_vld", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "flags", "role": "ap_vld" }} , 
 	{ "name": "saturation_ap_vld", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "saturation", "role": "ap_vld" }} , 
 	{ "name": "eq_enabled_ap_vld", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "eq_enabled", "role": "ap_vld" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "rw_ap_vld", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "rw", "role": "ap_vld" }} , 
 	{ "name": "rh_ap_vld", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "rh", "role": "ap_vld" }} , 
 	{ "name": "px_ap_vld", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "px", "role": "ap_vld" }} , 
 	{ "name": "py_ap_vld", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "py", "role": "ap_vld" }} , 
 	{ "name": "mode_ap_vld", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "mode", "role": "ap_vld" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "6", "10", "12", "23", "28", "52", "53", "56", "57", "60", "63", "67", "68", "69", "70", "71", "72", "73", "74", "75", "76", "77", "78", "79", "80", "81", "82", "83", "84", "85", "86", "87", "88", "89", "90", "91", "92", "93", "94"],
		"CDFG" : "p_anonymous_namespace_output_pass",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "Dataflow", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "1",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "4010177", "EstimateLatencyMax" : "6249444",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "1",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"InputProcess" : [
			{"ID" : "1", "Name" : "entry_proc_U0"},
			{"ID" : "2", "Name" : "p_anonymous_namespace_read_words_1_U0"},
			{"ID" : "10", "Name" : "p_anonymous_namespace_output_pass_Block_entry47_proc_U0"},
			{"ID" : "12", "Name" : "p_anonymous_namespace_color_stage_U0"},
			{"ID" : "23", "Name" : "p_anonymous_namespace_collect_or_drain_U0"},
			{"ID" : "28", "Name" : "p_anonymous_namespace_resize_and_split_U0"},
			{"ID" : "52", "Name" : "p_anonymous_namespace_output_pass_Block_entry412_proc_U0"},
			{"ID" : "56", "Name" : "p_anonymous_namespace_output_pass_Block_entry414_proc_U0"}],
		"OutputProcess" : [
			{"ID" : "23", "Name" : "p_anonymous_namespace_collect_or_drain_U0"},
			{"ID" : "60", "Name" : "p_anonymous_namespace_write_words_U0"},
			{"ID" : "63", "Name" : "p_anonymous_namespace_write_words_4_U0"}],
		"Port" : [
			{"Name" : "gmem_in", "Type" : "MAXI", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "p_anonymous_namespace_read_words_1_U0", "Port" : "gmem_in"}]},
			{"Name" : "src", "Type" : "None", "Direction" : "I"},
			{"Name" : "gmem_out", "Type" : "MAXI", "Direction" : "O",
				"SubConnect" : [
					{"ID" : "60", "SubInstance" : "p_anonymous_namespace_write_words_U0", "Port" : "gmem_out"}]},
			{"Name" : "tensor", "Type" : "None", "Direction" : "I"},
			{"Name" : "gmem_preview", "Type" : "MAXI", "Direction" : "O",
				"SubConnect" : [
					{"ID" : "63", "SubInstance" : "p_anonymous_namespace_write_words_4_U0", "Port" : "gmem_preview"}]},
			{"Name" : "preview", "Type" : "None", "Direction" : "I"},
			{"Name" : "width", "Type" : "None", "Direction" : "I"},
			{"Name" : "height", "Type" : "None", "Direction" : "I"},
			{"Name" : "stride", "Type" : "None", "Direction" : "I"},
			{"Name" : "preview_stride", "Type" : "None", "Direction" : "I"},
			{"Name" : "rw", "Type" : "None", "Direction" : "I"},
			{"Name" : "rh", "Type" : "None", "Direction" : "I"},
			{"Name" : "px", "Type" : "None", "Direction" : "I"},
			{"Name" : "py", "Type" : "None", "Direction" : "I"},
			{"Name" : "mode", "Type" : "None", "Direction" : "I"},
			{"Name" : "flags", "Type" : "None", "Direction" : "I"},
			{"Name" : "saturation", "Type" : "None", "Direction" : "I"},
			{"Name" : "eq_enabled", "Type" : "None", "Direction" : "I"},
			{"Name" : "collect", "Type" : "None", "Direction" : "I"},
			{"Name" : "color_0", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "12", "SubInstance" : "p_anonymous_namespace_color_stage_U0", "Port" : "color_0"}]},
			{"Name" : "color_1", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "12", "SubInstance" : "p_anonymous_namespace_color_stage_U0", "Port" : "color_1"}]},
			{"Name" : "color_2", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "12", "SubInstance" : "p_anonymous_namespace_color_stage_U0", "Port" : "color_2"}]},
			{"Name" : "quant_0", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "28", "SubInstance" : "p_anonymous_namespace_resize_and_split_U0", "Port" : "quant_0"}]},
			{"Name" : "quant_1", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "28", "SubInstance" : "p_anonymous_namespace_resize_and_split_U0", "Port" : "quant_1"}]},
			{"Name" : "quant_2", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "28", "SubInstance" : "p_anonymous_namespace_resize_and_split_U0", "Port" : "quant_2"}]},
			{"Name" : "eq", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "12", "SubInstance" : "p_anonymous_namespace_color_stage_U0", "Port" : "eq"}]},
			{"Name" : "hist", "Type" : "Memory", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "23", "SubInstance" : "p_anonymous_namespace_collect_or_drain_U0", "Port" : "hist"}]},
			{"Name" : "xc_index", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "28", "SubInstance" : "p_anonymous_namespace_resize_and_split_U0", "Port" : "xc_index"}]},
			{"Name" : "xc_weight", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "28", "SubInstance" : "p_anonymous_namespace_resize_and_split_U0", "Port" : "xc_weight"}]},
			{"Name" : "yc_index", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "28", "SubInstance" : "p_anonymous_namespace_resize_and_split_U0", "Port" : "yc_index"}]},
			{"Name" : "yc_weight", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "28", "SubInstance" : "p_anonymous_namespace_resize_and_split_U0", "Port" : "yc_weight"}]}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.entry_proc_U0", "Parent" : "0",
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
			{"Name" : "tensor_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["60"], "DependentChan" : "67", "DependentChanDepth" : "7", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "tensor_c_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "preview", "Type" : "None", "Direction" : "I"},
			{"Name" : "preview_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["63"], "DependentChan" : "68", "DependentChanDepth" : "7", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "preview_c_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "preview_stride", "Type" : "None", "Direction" : "I"},
			{"Name" : "preview_stride_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["63"], "DependentChan" : "69", "DependentChanDepth" : "7", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "preview_stride_c_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "collect", "Type" : "None", "Direction" : "I"},
			{"Name" : "collect_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["23"], "DependentChan" : "70", "DependentChanDepth" : "5", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "collect_c_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_read_words_1_U0", "Parent" : "0", "Child" : ["3", "5"],
		"CDFG" : "p_anonymous_namespace_read_words_1",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "1",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "2081", "EstimateLatencyMax" : "406081",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "gmem_in", "Type" : "MAXI", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "gmem_in_blk_n_AR", "Type" : "RtlSignal"}],
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_p_anonymous_namespace_read_words_1_Pipeline_VITIS_LOOP_145_2_fu_146", "Port" : "gmem_in", "Inst_start_state" : "13", "Inst_end_state" : "14"}]},
			{"Name" : "src", "Type" : "None", "Direction" : "I"},
			{"Name" : "in_words1", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["6"], "DependentChan" : "71", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_p_anonymous_namespace_read_words_1_Pipeline_VITIS_LOOP_145_2_fu_146", "Port" : "in_words1", "Inst_start_state" : "13", "Inst_end_state" : "14"}]},
			{"Name" : "width", "Type" : "None", "Direction" : "I"},
			{"Name" : "height", "Type" : "None", "Direction" : "I"},
			{"Name" : "stride", "Type" : "None", "Direction" : "I"},
			{"Name" : "width_c31", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["6"], "DependentChan" : "72", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "width_c31_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "height_c33", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["6"], "DependentChan" : "73", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "height_c33_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_143_1", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "14", "FirstState" : "ap_ST_fsm_state2", "LastState" : ["ap_ST_fsm_state14"], "QuitState" : ["ap_ST_fsm_state2"], "PreState" : ["ap_ST_fsm_state1"], "PostState" : ["ap_ST_fsm_state1"], "OneDepthLoop" : "0", "OneStateBlock": ""}}]},
	{"ID" : "3", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_read_words_1_U0.grp_p_anonymous_namespace_read_words_1_Pipeline_VITIS_LOOP_145_2_fu_146", "Parent" : "2", "Child" : ["4"],
		"CDFG" : "p_anonymous_namespace_read_words_1_Pipeline_VITIS_LOOP_145_2",
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
			{"Name" : "gmem_in", "Type" : "MAXI", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "gmem_in_blk_n_R", "Type" : "RtlSignal"}]},
			{"Name" : "sext_ln145", "Type" : "None", "Direction" : "I"},
			{"Name" : "count", "Type" : "None", "Direction" : "I"},
			{"Name" : "in_words1", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "in_words1_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_145_2", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter2", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "4", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_read_words_1_U0.grp_p_anonymous_namespace_read_words_1_Pipeline_VITIS_LOOP_145_2_fu_146.flow_control_loop_pipe_sequential_init_U", "Parent" : "3"},
	{"ID" : "5", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_read_words_1_U0.mul_mul_9ns_11ns_20_4_1_U126", "Parent" : "2"},
	{"ID" : "6", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_unpack_2_U0", "Parent" : "0", "Child" : ["7", "9"],
		"CDFG" : "p_anonymous_namespace_unpack_2",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "173062", "EstimateLatencyMax" : "2073606",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"StartSource" : "2",
		"StartFifo" : "start_for_p_anonymous_namespace_unpack_2_U0_U",
		"Port" : [
			{"Name" : "in_words1", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["2"], "DependentChan" : "71", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "7", "SubInstance" : "grp_p_anonymous_namespace_unpack_2_Pipeline_VITIS_LOOP_156_1_VITIS_LOOP_160_2_fu_46", "Port" : "in_words1", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "in_pixels4", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["12"], "DependentChan" : "74", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "7", "SubInstance" : "grp_p_anonymous_namespace_unpack_2_Pipeline_VITIS_LOOP_156_1_VITIS_LOOP_160_2_fu_46", "Port" : "in_pixels4", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "width", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["2"], "DependentChan" : "72", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "width_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "height", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["2"], "DependentChan" : "73", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "height_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "7", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_unpack_2_U0.grp_p_anonymous_namespace_unpack_2_Pipeline_VITIS_LOOP_156_1_VITIS_LOOP_160_2_fu_46", "Parent" : "6", "Child" : ["8"],
		"CDFG" : "p_anonymous_namespace_unpack_2_Pipeline_VITIS_LOOP_156_1_VITIS_LOOP_160_2",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "173060", "EstimateLatencyMax" : "2073604",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "bound", "Type" : "None", "Direction" : "I"},
			{"Name" : "in_pixels4", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "in_pixels4_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "width_load", "Type" : "None", "Direction" : "I"},
			{"Name" : "in_words1", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "in_words1_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_156_1_VITIS_LOOP_160_2", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter1", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "8", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_unpack_2_U0.grp_p_anonymous_namespace_unpack_2_Pipeline_VITIS_LOOP_156_1_VITIS_LOOP_160_2_fu_46.flow_control_loop_pipe_sequential_init_U", "Parent" : "7"},
	{"ID" : "9", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_unpack_2_U0.mul_32ns_32ns_64_1_1_U139", "Parent" : "6"},
	{"ID" : "10", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_output_pass_Block_entry47_proc_U0", "Parent" : "0", "Child" : ["11"],
		"CDFG" : "p_anonymous_namespace_output_pass_Block_entry47_proc",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
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
			{"Name" : "height", "Type" : "None", "Direction" : "I"},
			{"Name" : "width", "Type" : "None", "Direction" : "I"},
			{"Name" : "flags", "Type" : "None", "Direction" : "I"}]},
	{"ID" : "11", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_output_pass_Block_entry47_proc_U0.mul_11ns_11ns_22_1_1_U144", "Parent" : "10"},
	{"ID" : "12", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_color_stage_U0", "Parent" : "0", "Child" : ["13"],
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
			{"Name" : "in_pixels", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["6"], "DependentChan" : "74", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "13", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_267_1_fu_104", "Port" : "in_pixels", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "pairs", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["28"], "DependentChan" : "77", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "13", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_267_1_fu_104", "Port" : "pairs", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "hist_pixels", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["23"], "DependentChan" : "78", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "13", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_267_1_fu_104", "Port" : "hist_pixels", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "color_0", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "13", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_267_1_fu_104", "Port" : "color_0", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "color_1", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "13", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_267_1_fu_104", "Port" : "color_1", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "color_2", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "13", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_267_1_fu_104", "Port" : "color_2", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "eq", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "13", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_267_1_fu_104", "Port" : "eq", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "p_read", "Type" : "None", "Direction" : "I", "DependentProc" : ["10"], "DependentChan" : "75", "DependentChanDepth" : "3", "DependentChanType" : "1"},
			{"Name" : "saturation", "Type" : "None", "Direction" : "I"},
			{"Name" : "eq_enabled", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read1", "Type" : "None", "Direction" : "I", "DependentProc" : ["10"], "DependentChan" : "76", "DependentChanDepth" : "3", "DependentChanType" : "1"},
			{"Name" : "mul_ln1540_loc_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["23"], "DependentChan" : "79", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "mul_ln1540_loc_c_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "13", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_color_stage_U0.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_267_1_fu_104", "Parent" : "12", "Child" : ["14", "15", "16", "17", "18", "19", "20", "21", "22"],
		"CDFG" : "p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_267_1",
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
			{"Name" : "VITIS_LOOP_267_1", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter17", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter17", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "14", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_color_stage_U0.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_267_1_fu_104.mac_muladd_8ns_8ns_15s_17_4_1_U148", "Parent" : "13"},
	{"ID" : "15", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_color_stage_U0.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_267_1_fu_104.mac_muladd_8ns_7ns_17s_18_4_1_U149", "Parent" : "13"},
	{"ID" : "16", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_color_stage_U0.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_267_1_fu_104.mac_muladd_14ns_10s_22s_25_4_1_U150", "Parent" : "13"},
	{"ID" : "17", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_color_stage_U0.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_267_1_fu_104.mac_muladd_14ns_10s_22s_25_4_1_U151", "Parent" : "13"},
	{"ID" : "18", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_color_stage_U0.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_267_1_fu_104.mac_muladd_14ns_10s_22s_25_4_1_U152", "Parent" : "13"},
	{"ID" : "19", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_color_stage_U0.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_267_1_fu_104.mac_muladd_9s_9ns_14s_17_4_1_U153", "Parent" : "13"},
	{"ID" : "20", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_color_stage_U0.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_267_1_fu_104.mac_muladd_9s_8ns_14s_16_4_1_U154", "Parent" : "13"},
	{"ID" : "21", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_color_stage_U0.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_267_1_fu_104.mac_muladd_9s_9ns_15s_17_4_1_U155", "Parent" : "13"},
	{"ID" : "22", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_color_stage_U0.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_267_1_fu_104.flow_control_loop_pipe_sequential_init_U", "Parent" : "13"},
	{"ID" : "23", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_collect_or_drain_U0", "Parent" : "0", "Child" : ["24", "26"],
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
			{"Name" : "hist_pixels", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["12"], "DependentChan" : "78", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "26", "SubInstance" : "grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_283_1_fu_65", "Port" : "hist_pixels", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "24", "SubInstance" : "grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_290_2_fu_58", "Port" : "hist_pixels", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "hist", "Type" : "Memory", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "26", "SubInstance" : "grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_283_1_fu_65", "Port" : "hist", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "collect", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["1"], "DependentChan" : "70", "DependentChanDepth" : "5", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "collect_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mul_ln1540_loc", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["12"], "DependentChan" : "79", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "mul_ln1540_loc_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "24", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_collect_or_drain_U0.grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_290_2_fu_58", "Parent" : "23", "Child" : ["25"],
		"CDFG" : "p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_290_2",
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
			{"Name" : "VITIS_LOOP_290_2", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter0", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "25", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_collect_or_drain_U0.grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_290_2_fu_58.flow_control_loop_pipe_sequential_init_U", "Parent" : "24"},
	{"ID" : "26", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_collect_or_drain_U0.grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_283_1_fu_65", "Parent" : "23", "Child" : ["27"],
		"CDFG" : "p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_283_1",
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
			{"Name" : "VITIS_LOOP_283_1", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "2", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter0", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "27", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_collect_or_drain_U0.grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_283_1_fu_65.flow_control_loop_pipe_sequential_init_U", "Parent" : "26"},
	{"ID" : "28", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_resize_and_split_U0", "Parent" : "0", "Child" : ["29", "30", "31", "33", "48", "50", "51"],
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
			{"Name" : "pairs", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["12"], "DependentChan" : "77", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "31", "SubInstance" : "grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_342_2_VITIS_LOOP_344_3_fu_260", "Port" : "pairs", "Inst_start_state" : "5", "Inst_end_state" : "6"},
					{"ID" : "48", "SubInstance" : "grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_376_6_VITIS_LOOP_378_7_fu_302", "Port" : "pairs", "Inst_start_state" : "11", "Inst_end_state" : "12"}]},
			{"Name" : "tensor_pixels5", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["53"], "DependentChan" : "80", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "33", "SubInstance" : "grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275", "Port" : "tensor_pixels5", "Inst_start_state" : "8", "Inst_end_state" : "9"}]},
			{"Name" : "preview_pixels6", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["57"], "DependentChan" : "81", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "31", "SubInstance" : "grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_342_2_VITIS_LOOP_344_3_fu_260", "Port" : "preview_pixels6", "Inst_start_state" : "5", "Inst_end_state" : "6"},
					{"ID" : "48", "SubInstance" : "grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_376_6_VITIS_LOOP_378_7_fu_302", "Port" : "preview_pixels6", "Inst_start_state" : "11", "Inst_end_state" : "12"}]},
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
					{"ID" : "33", "SubInstance" : "grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275", "Port" : "xc_index", "Inst_start_state" : "8", "Inst_end_state" : "9"}]},
			{"Name" : "xc_weight", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "33", "SubInstance" : "grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275", "Port" : "xc_weight", "Inst_start_state" : "8", "Inst_end_state" : "9"}]},
			{"Name" : "yc_index", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "yc_weight", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "quant_0", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "33", "SubInstance" : "grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275", "Port" : "quant_0", "Inst_start_state" : "8", "Inst_end_state" : "9"}]},
			{"Name" : "quant_1", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "33", "SubInstance" : "grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275", "Port" : "quant_1", "Inst_start_state" : "8", "Inst_end_state" : "9"}]},
			{"Name" : "quant_2", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "33", "SubInstance" : "grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275", "Port" : "quant_2", "Inst_start_state" : "8", "Inst_end_state" : "9"}]},
			{"Name" : "width_c30", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["57"], "DependentChan" : "82", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "width_c30_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "height_c32", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["57"], "DependentChan" : "83", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "height_c32_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_334_1", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "12", "FirstState" : "ap_ST_fsm_state2", "LastState" : ["ap_ST_fsm_state9"], "QuitState" : ["ap_ST_fsm_state2"], "PreState" : ["ap_ST_fsm_state1"], "PostState" : ["ap_ST_fsm_state10"], "OneDepthLoop" : "0", "OneStateBlock": ""}}]},
	{"ID" : "29", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_resize_and_split_U0.rows_V_U", "Parent" : "28"},
	{"ID" : "30", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_resize_and_split_U0.rows_V_1_U", "Parent" : "28"},
	{"ID" : "31", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_342_2_VITIS_LOOP_344_3_fu_260", "Parent" : "28", "Child" : ["32"],
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
	{"ID" : "32", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_342_2_VITIS_LOOP_344_3_fu_260.flow_control_loop_pipe_sequential_init_U", "Parent" : "31"},
	{"ID" : "33", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275", "Parent" : "28", "Child" : ["34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47"],
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
	{"ID" : "34", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275.mux_21_24_1_1_U201", "Parent" : "33"},
	{"ID" : "35", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275.mux_21_24_1_1_U202", "Parent" : "33"},
	{"ID" : "36", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275.mux_21_24_1_1_U203", "Parent" : "33"},
	{"ID" : "37", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275.mux_21_24_1_1_U204", "Parent" : "33"},
	{"ID" : "38", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275.mac_muladd_12ns_9s_19ns_20_4_1_U205", "Parent" : "33"},
	{"ID" : "39", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275.mac_muladd_12ns_9s_19ns_20_4_1_U206", "Parent" : "33"},
	{"ID" : "40", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275.mac_muladd_12ns_9s_19ns_20_4_1_U207", "Parent" : "33"},
	{"ID" : "41", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275.mac_muladd_12ns_9s_20ns_20_4_1_U208", "Parent" : "33"},
	{"ID" : "42", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275.mac_muladd_12ns_9s_20ns_20_4_1_U209", "Parent" : "33"},
	{"ID" : "43", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275.mac_muladd_12ns_9s_20ns_20_4_1_U210", "Parent" : "33"},
	{"ID" : "44", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275.mac_muladd_20s_12ns_22ns_30_4_1_U211", "Parent" : "33"},
	{"ID" : "45", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275.mac_muladd_20s_12ns_22ns_30_4_1_U212", "Parent" : "33"},
	{"ID" : "46", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275.mac_muladd_20s_12ns_22ns_30_4_1_U213", "Parent" : "33"},
	{"ID" : "47", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_354_4_fu_275.flow_control_loop_pipe_sequential_init_U", "Parent" : "33"},
	{"ID" : "48", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_376_6_VITIS_LOOP_378_7_fu_302", "Parent" : "28", "Child" : ["49"],
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
	{"ID" : "49", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_376_6_VITIS_LOOP_378_7_fu_302.flow_control_loop_pipe_sequential_init_U", "Parent" : "48"},
	{"ID" : "50", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_resize_and_split_U0.mul_32ns_32ns_64_1_1_U238", "Parent" : "28"},
	{"ID" : "51", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_resize_and_split_U0.mul_32ns_32ns_64_1_1_U239", "Parent" : "28"},
	{"ID" : "52", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_output_pass_Block_entry412_proc_U0", "Parent" : "0",
		"CDFG" : "p_anonymous_namespace_output_pass_Block_entry412_proc",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
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
			{"Name" : "mode", "Type" : "None", "Direction" : "I"}]},
	{"ID" : "53", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_pack_U0", "Parent" : "0", "Child" : ["54"],
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
			{"Name" : "tensor_pixels", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["28"], "DependentChan" : "80", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "54", "SubInstance" : "grp_p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_396_2_fu_89", "Port" : "tensor_pixels", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "tensor_words", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["60"], "DependentChan" : "85", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "tensor_words_blk_n", "Type" : "RtlSignal"}],
				"SubConnect" : [
					{"ID" : "54", "SubInstance" : "grp_p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_396_2_fu_89", "Port" : "tensor_words", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "p_read", "Type" : "None", "Direction" : "I", "DependentProc" : ["52"], "DependentChan" : "84", "DependentChanDepth" : "5", "DependentChanType" : "1"},
			{"Name" : "icmp_ln455_loc_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["60"], "DependentChan" : "86", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "icmp_ln455_loc_c_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_392_1", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "4", "FirstState" : "ap_ST_fsm_state2", "LastState" : ["ap_ST_fsm_state4"], "QuitState" : ["ap_ST_fsm_state2"], "PreState" : ["ap_ST_fsm_state1"], "PostState" : ["ap_ST_fsm_state1"], "OneDepthLoop" : "0", "OneStateBlock": ""}}]},
	{"ID" : "54", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_pack_U0.grp_p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_396_2_fu_89", "Parent" : "53", "Child" : ["55"],
		"CDFG" : "p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_396_2",
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
			{"Name" : "VITIS_LOOP_396_2", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter2", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "55", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_pack_U0.grp_p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_396_2_fu_89.flow_control_loop_pipe_sequential_init_U", "Parent" : "54"},
	{"ID" : "56", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_output_pass_Block_entry414_proc_U0", "Parent" : "0",
		"CDFG" : "p_anonymous_namespace_output_pass_Block_entry414_proc",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
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
			{"Name" : "mode", "Type" : "None", "Direction" : "I"}]},
	{"ID" : "57", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_pack_3_U0", "Parent" : "0", "Child" : ["58"],
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
			{"Name" : "preview_pixels", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["28"], "DependentChan" : "81", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "58", "SubInstance" : "grp_p_anonymous_namespace_pack_3_Pipeline_VITIS_LOOP_396_2_fu_127", "Port" : "preview_pixels", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "preview_words", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["63"], "DependentChan" : "88", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "preview_words_blk_n", "Type" : "RtlSignal"}],
				"SubConnect" : [
					{"ID" : "58", "SubInstance" : "grp_p_anonymous_namespace_pack_3_Pipeline_VITIS_LOOP_396_2_fu_127", "Port" : "preview_words", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "width", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["28"], "DependentChan" : "82", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "width_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "height", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["28"], "DependentChan" : "83", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "height_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "p_read", "Type" : "None", "Direction" : "I", "DependentProc" : ["56"], "DependentChan" : "87", "DependentChanDepth" : "5", "DependentChanType" : "1"},
			{"Name" : "width_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["63"], "DependentChan" : "89", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "width_c_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "height_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["63"], "DependentChan" : "90", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "height_c_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "icmp_ln456_loc_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["63"], "DependentChan" : "91", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "icmp_ln456_loc_c_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_392_1", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "4", "FirstState" : "ap_ST_fsm_state2", "LastState" : ["ap_ST_fsm_state4"], "QuitState" : ["ap_ST_fsm_state2"], "PreState" : ["ap_ST_fsm_state1"], "PostState" : ["ap_ST_fsm_state1"], "OneDepthLoop" : "0", "OneStateBlock": ""}}]},
	{"ID" : "58", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_pack_3_U0.grp_p_anonymous_namespace_pack_3_Pipeline_VITIS_LOOP_396_2_fu_127", "Parent" : "57", "Child" : ["59"],
		"CDFG" : "p_anonymous_namespace_pack_3_Pipeline_VITIS_LOOP_396_2",
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
			{"Name" : "VITIS_LOOP_396_2", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter2", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "59", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_pack_3_U0.grp_p_anonymous_namespace_pack_3_Pipeline_VITIS_LOOP_396_2_fu_127.flow_control_loop_pipe_sequential_init_U", "Parent" : "58"},
	{"ID" : "60", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_write_words_U0", "Parent" : "0", "Child" : ["61"],
		"CDFG" : "p_anonymous_namespace_write_words",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "1", "EstimateLatencyMax" : "32459",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"StartSource" : "1",
		"StartFifo" : "start_for_p_anonymous_namespace_write_words_U0_U",
		"Port" : [
			{"Name" : "gmem_out", "Type" : "MAXI", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "gmem_out_blk_n_AW", "Type" : "RtlSignal"},
					{"Name" : "gmem_out_blk_n_B", "Type" : "RtlSignal"}],
				"SubConnect" : [
					{"ID" : "61", "SubInstance" : "grp_p_anonymous_namespace_write_words_Pipeline_VITIS_LOOP_417_1_VITIS_LOOP_419_2_fu_76", "Port" : "gmem_out", "Inst_start_state" : "3", "Inst_end_state" : "4"}]},
			{"Name" : "tensor", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["1"], "DependentChan" : "67", "DependentChanDepth" : "7", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "tensor_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "tensor_words", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["53"], "DependentChan" : "85", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "61", "SubInstance" : "grp_p_anonymous_namespace_write_words_Pipeline_VITIS_LOOP_417_1_VITIS_LOOP_419_2_fu_76", "Port" : "tensor_words", "Inst_start_state" : "3", "Inst_end_state" : "4"}]},
			{"Name" : "icmp_ln455_loc", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["53"], "DependentChan" : "86", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "icmp_ln455_loc_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "61", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_write_words_U0.grp_p_anonymous_namespace_write_words_Pipeline_VITIS_LOOP_417_1_VITIS_LOOP_419_2_fu_76", "Parent" : "60", "Child" : ["62"],
		"CDFG" : "p_anonymous_namespace_write_words_Pipeline_VITIS_LOOP_417_1_VITIS_LOOP_419_2",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "32451", "EstimateLatencyMax" : "32451",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "gmem_out", "Type" : "MAXI", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "gmem_out_blk_n_W", "Type" : "RtlSignal"}]},
			{"Name" : "sext_ln417", "Type" : "None", "Direction" : "I"},
			{"Name" : "tensor_words", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "tensor_words_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_417_1_VITIS_LOOP_419_2", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter2", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "62", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_write_words_U0.grp_p_anonymous_namespace_write_words_Pipeline_VITIS_LOOP_417_1_VITIS_LOOP_419_2_fu_76.flow_control_loop_pipe_sequential_init_U", "Parent" : "61"},
	{"ID" : "63", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_write_words_4_U0", "Parent" : "0", "Child" : ["64", "66"],
		"CDFG" : "p_anonymous_namespace_write_words_4",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "1", "EstimateLatencyMax" : "405001",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"StartSource" : "1",
		"StartFifo" : "start_for_p_anonymous_namespace_write_words_4_U0_U",
		"Port" : [
			{"Name" : "gmem_preview", "Type" : "MAXI", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "gmem_preview_blk_n_AW", "Type" : "RtlSignal"},
					{"Name" : "gmem_preview_blk_n_B", "Type" : "RtlSignal"}],
				"SubConnect" : [
					{"ID" : "64", "SubInstance" : "grp_p_anonymous_namespace_write_words_4_Pipeline_VITIS_LOOP_419_2_fu_137", "Port" : "gmem_preview", "Inst_start_state" : "7", "Inst_end_state" : "8"}]},
			{"Name" : "preview", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["1"], "DependentChan" : "68", "DependentChanDepth" : "7", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "preview_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "preview_words", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["57"], "DependentChan" : "88", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "64", "SubInstance" : "grp_p_anonymous_namespace_write_words_4_Pipeline_VITIS_LOOP_419_2_fu_137", "Port" : "preview_words", "Inst_start_state" : "7", "Inst_end_state" : "8"}]},
			{"Name" : "width", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["57"], "DependentChan" : "89", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "width_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "height", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["57"], "DependentChan" : "90", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "height_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "preview_stride", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["1"], "DependentChan" : "69", "DependentChanDepth" : "7", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "preview_stride_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "icmp_ln456_loc", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["57"], "DependentChan" : "91", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "icmp_ln456_loc_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_417_1", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "13", "FirstState" : "ap_ST_fsm_state2", "LastState" : ["ap_ST_fsm_state13"], "QuitState" : ["ap_ST_fsm_state2"], "PreState" : ["ap_ST_fsm_state1"], "PostState" : ["ap_ST_fsm_state1"], "OneDepthLoop" : "0", "OneStateBlock": ""}}]},
	{"ID" : "64", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_write_words_4_U0.grp_p_anonymous_namespace_write_words_4_Pipeline_VITIS_LOOP_419_2_fu_137", "Parent" : "63", "Child" : ["65"],
		"CDFG" : "p_anonymous_namespace_write_words_4_Pipeline_VITIS_LOOP_419_2",
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
			{"Name" : "sext_ln419", "Type" : "None", "Direction" : "I"},
			{"Name" : "count", "Type" : "None", "Direction" : "I"},
			{"Name" : "preview_words", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "preview_words_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_419_2", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter2", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "65", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_write_words_4_U0.grp_p_anonymous_namespace_write_words_4_Pipeline_VITIS_LOOP_419_2_fu_137.flow_control_loop_pipe_sequential_init_U", "Parent" : "64"},
	{"ID" : "66", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.p_anonymous_namespace_write_words_4_U0.mul_mul_9ns_11ns_20_4_1_U295", "Parent" : "63"},
	{"ID" : "67", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.tensor_c_U", "Parent" : "0"},
	{"ID" : "68", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.preview_c_U", "Parent" : "0"},
	{"ID" : "69", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.preview_stride_c_U", "Parent" : "0"},
	{"ID" : "70", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.collect_c_U", "Parent" : "0"},
	{"ID" : "71", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.in_words_U", "Parent" : "0"},
	{"ID" : "72", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.width_c31_U", "Parent" : "0"},
	{"ID" : "73", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.height_c33_U", "Parent" : "0"},
	{"ID" : "74", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.in_pixels_U", "Parent" : "0"},
	{"ID" : "75", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.flags_cast_loc_channel_U", "Parent" : "0"},
	{"ID" : "76", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_ln1540_loc_c36_channel_U", "Parent" : "0"},
	{"ID" : "77", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.pairs_U", "Parent" : "0"},
	{"ID" : "78", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.hist_pixels_U", "Parent" : "0"},
	{"ID" : "79", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_ln1540_loc_c_U", "Parent" : "0"},
	{"ID" : "80", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.tensor_pixels_U", "Parent" : "0"},
	{"ID" : "81", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.preview_pixels_U", "Parent" : "0"},
	{"ID" : "82", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.width_c30_U", "Parent" : "0"},
	{"ID" : "83", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.height_c32_U", "Parent" : "0"},
	{"ID" : "84", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.icmp_ln455_loc_c35_channel_U", "Parent" : "0"},
	{"ID" : "85", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.tensor_words_U", "Parent" : "0"},
	{"ID" : "86", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.icmp_ln455_loc_c_U", "Parent" : "0"},
	{"ID" : "87", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.icmp_ln456_loc_c34_channel_U", "Parent" : "0"},
	{"ID" : "88", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.preview_words_U", "Parent" : "0"},
	{"ID" : "89", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.width_c_U", "Parent" : "0"},
	{"ID" : "90", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.height_c_U", "Parent" : "0"},
	{"ID" : "91", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.icmp_ln456_loc_c_U", "Parent" : "0"},
	{"ID" : "92", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.start_for_p_anonymous_namespace_write_words_U0_U", "Parent" : "0"},
	{"ID" : "93", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.start_for_p_anonymous_namespace_write_words_4_U0_U", "Parent" : "0"},
	{"ID" : "94", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.start_for_p_anonymous_namespace_unpack_2_U0_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	p_anonymous_namespace_output_pass {
		gmem_in {Type I LastRead 5 FirstWrite -1}
		src {Type I LastRead 0 FirstWrite -1}
		gmem_out {Type O LastRead 4 FirstWrite 2}
		tensor {Type I LastRead 0 FirstWrite -1}
		gmem_preview {Type O LastRead 8 FirstWrite 2}
		preview {Type I LastRead 0 FirstWrite -1}
		width {Type I LastRead 0 FirstWrite -1}
		height {Type I LastRead 0 FirstWrite -1}
		stride {Type I LastRead 0 FirstWrite -1}
		preview_stride {Type I LastRead 0 FirstWrite -1}
		rw {Type I LastRead 6 FirstWrite -1}
		rh {Type I LastRead 6 FirstWrite -1}
		px {Type I LastRead 6 FirstWrite -1}
		py {Type I LastRead 6 FirstWrite -1}
		mode {Type I LastRead 6 FirstWrite -1}
		flags {Type I LastRead 3 FirstWrite -1}
		saturation {Type I LastRead 4 FirstWrite -1}
		eq_enabled {Type I LastRead 4 FirstWrite -1}
		collect {Type I LastRead 0 FirstWrite -1}
		color_0 {Type I LastRead 3 FirstWrite -1}
		color_1 {Type I LastRead 1 FirstWrite -1}
		color_2 {Type I LastRead 2 FirstWrite -1}
		quant_0 {Type I LastRead 10 FirstWrite -1}
		quant_1 {Type I LastRead 10 FirstWrite -1}
		quant_2 {Type I LastRead 10 FirstWrite -1}
		eq {Type I LastRead 15 FirstWrite -1}
		hist {Type IO LastRead 1 FirstWrite 2}
		xc_index {Type I LastRead 0 FirstWrite -1}
		xc_weight {Type I LastRead 2 FirstWrite -1}
		yc_index {Type I LastRead 1 FirstWrite -1}
		yc_weight {Type I LastRead 1 FirstWrite -1}}
	entry_proc {
		tensor {Type I LastRead 0 FirstWrite -1}
		tensor_c {Type O LastRead -1 FirstWrite 0}
		preview {Type I LastRead 0 FirstWrite -1}
		preview_c {Type O LastRead -1 FirstWrite 0}
		preview_stride {Type I LastRead 0 FirstWrite -1}
		preview_stride_c {Type O LastRead -1 FirstWrite 0}
		collect {Type I LastRead 0 FirstWrite -1}
		collect_c {Type O LastRead -1 FirstWrite 0}}
	p_anonymous_namespace_read_words_1 {
		gmem_in {Type I LastRead 5 FirstWrite -1}
		src {Type I LastRead 0 FirstWrite -1}
		in_words1 {Type O LastRead -1 FirstWrite 2}
		width {Type I LastRead 0 FirstWrite -1}
		height {Type I LastRead 0 FirstWrite -1}
		stride {Type I LastRead 0 FirstWrite -1}
		width_c31 {Type O LastRead -1 FirstWrite 0}
		height_c33 {Type O LastRead -1 FirstWrite 0}}
	p_anonymous_namespace_read_words_1_Pipeline_VITIS_LOOP_145_2 {
		gmem_in {Type I LastRead 1 FirstWrite -1}
		sext_ln145 {Type I LastRead 0 FirstWrite -1}
		count {Type I LastRead 0 FirstWrite -1}
		in_words1 {Type O LastRead -1 FirstWrite 2}}
	p_anonymous_namespace_unpack_2 {
		in_words1 {Type I LastRead 3 FirstWrite -1}
		in_pixels4 {Type O LastRead -1 FirstWrite 4}
		width {Type I LastRead 0 FirstWrite -1}
		height {Type I LastRead 0 FirstWrite -1}}
	p_anonymous_namespace_unpack_2_Pipeline_VITIS_LOOP_156_1_VITIS_LOOP_160_2 {
		bound {Type I LastRead 0 FirstWrite -1}
		in_pixels4 {Type O LastRead -1 FirstWrite 4}
		width_load {Type I LastRead 0 FirstWrite -1}
		in_words1 {Type I LastRead 3 FirstWrite -1}}
	p_anonymous_namespace_output_pass_Block_entry47_proc {
		height {Type I LastRead 0 FirstWrite -1}
		width {Type I LastRead 0 FirstWrite -1}
		flags {Type I LastRead 0 FirstWrite -1}}
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
	p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_267_1 {
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
		pairs {Type O LastRead -1 FirstWrite 17}}
	p_anonymous_namespace_collect_or_drain {
		hist_pixels {Type I LastRead 1 FirstWrite -1}
		hist {Type IO LastRead 1 FirstWrite 2}
		collect {Type I LastRead 0 FirstWrite -1}
		mul_ln1540_loc {Type I LastRead 0 FirstWrite -1}}
	p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_290_2 {
		mul_ln1540_loc_load {Type I LastRead 0 FirstWrite -1}
		hist_pixels {Type I LastRead 1 FirstWrite -1}}
	p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_283_1 {
		mul_ln1540_loc_load {Type I LastRead 0 FirstWrite -1}
		hist_pixels {Type I LastRead 1 FirstWrite -1}
		hist {Type IO LastRead 1 FirstWrite 2}}
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
		preview_pixels6 {Type O LastRead -1 FirstWrite 2}}
	p_anonymous_namespace_output_pass_Block_entry412_proc {
		mode {Type I LastRead 0 FirstWrite -1}}
	p_anonymous_namespace_pack {
		tensor_pixels {Type I LastRead 1 FirstWrite -1}
		tensor_words {Type O LastRead -1 FirstWrite 2}
		p_read {Type I LastRead 0 FirstWrite -1}
		icmp_ln455_loc_c {Type O LastRead -1 FirstWrite 0}}
	p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_396_2 {
		tensor_pixels {Type I LastRead 1 FirstWrite -1}
		tensor_words {Type O LastRead -1 FirstWrite 2}
		bits_9_out {Type O LastRead -1 FirstWrite 1}
		reservoir_V_out {Type O LastRead -1 FirstWrite 1}}
	p_anonymous_namespace_output_pass_Block_entry414_proc {
		mode {Type I LastRead 0 FirstWrite -1}}
	p_anonymous_namespace_pack_3 {
		preview_pixels {Type I LastRead 1 FirstWrite -1}
		preview_words {Type O LastRead -1 FirstWrite 2}
		width {Type I LastRead 0 FirstWrite -1}
		height {Type I LastRead 0 FirstWrite -1}
		p_read {Type I LastRead 0 FirstWrite -1}
		width_c {Type O LastRead -1 FirstWrite 0}
		height_c {Type O LastRead -1 FirstWrite 0}
		icmp_ln456_loc_c {Type O LastRead -1 FirstWrite 0}}
	p_anonymous_namespace_pack_3_Pipeline_VITIS_LOOP_396_2 {
		width_load {Type I LastRead 0 FirstWrite -1}
		preview_pixels {Type I LastRead 1 FirstWrite -1}
		preview_words {Type O LastRead -1 FirstWrite 2}
		bits_6_out {Type O LastRead -1 FirstWrite 1}
		reservoir_V_out {Type O LastRead -1 FirstWrite 1}}
	p_anonymous_namespace_write_words {
		gmem_out {Type O LastRead 4 FirstWrite 2}
		tensor {Type I LastRead 0 FirstWrite -1}
		tensor_words {Type I LastRead 1 FirstWrite -1}
		icmp_ln455_loc {Type I LastRead 0 FirstWrite -1}}
	p_anonymous_namespace_write_words_Pipeline_VITIS_LOOP_417_1_VITIS_LOOP_419_2 {
		gmem_out {Type O LastRead -1 FirstWrite 2}
		sext_ln417 {Type I LastRead 0 FirstWrite -1}
		tensor_words {Type I LastRead 1 FirstWrite -1}}
	p_anonymous_namespace_write_words_4 {
		gmem_preview {Type O LastRead 8 FirstWrite 2}
		preview {Type I LastRead 0 FirstWrite -1}
		preview_words {Type I LastRead 1 FirstWrite -1}
		width {Type I LastRead 0 FirstWrite -1}
		height {Type I LastRead 0 FirstWrite -1}
		preview_stride {Type I LastRead 0 FirstWrite -1}
		icmp_ln456_loc {Type I LastRead 0 FirstWrite -1}}
	p_anonymous_namespace_write_words_4_Pipeline_VITIS_LOOP_419_2 {
		gmem_preview {Type O LastRead -1 FirstWrite 2}
		sext_ln419 {Type I LastRead 0 FirstWrite -1}
		count {Type I LastRead 0 FirstWrite -1}
		preview_words {Type I LastRead 1 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "4010177", "Max" : "6249444"}
	, {"Name" : "Interval", "Min" : "173077", "Max" : "6249415"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	 { m_axi {  { m_axi_gmem_in_AWVALID VALID 1 1 }  { m_axi_gmem_in_AWREADY READY 0 1 }  { m_axi_gmem_in_AWADDR ADDR 1 64 }  { m_axi_gmem_in_AWID ID 1 1 }  { m_axi_gmem_in_AWLEN SIZE 1 32 }  { m_axi_gmem_in_AWSIZE BURST 1 3 }  { m_axi_gmem_in_AWBURST LOCK 1 2 }  { m_axi_gmem_in_AWLOCK CACHE 1 2 }  { m_axi_gmem_in_AWCACHE PROT 1 4 }  { m_axi_gmem_in_AWPROT QOS 1 3 }  { m_axi_gmem_in_AWQOS REGION 1 4 }  { m_axi_gmem_in_AWREGION USER 1 4 }  { m_axi_gmem_in_AWUSER DATA 1 1 }  { m_axi_gmem_in_WVALID VALID 1 1 }  { m_axi_gmem_in_WREADY READY 0 1 }  { m_axi_gmem_in_WDATA FIFONUM 1 128 }  { m_axi_gmem_in_WSTRB STRB 1 16 }  { m_axi_gmem_in_WLAST LAST 1 1 }  { m_axi_gmem_in_WID ID 1 1 }  { m_axi_gmem_in_WUSER DATA 1 1 }  { m_axi_gmem_in_ARVALID VALID 1 1 }  { m_axi_gmem_in_ARREADY READY 0 1 }  { m_axi_gmem_in_ARADDR ADDR 1 64 }  { m_axi_gmem_in_ARID ID 1 1 }  { m_axi_gmem_in_ARLEN SIZE 1 32 }  { m_axi_gmem_in_ARSIZE BURST 1 3 }  { m_axi_gmem_in_ARBURST LOCK 1 2 }  { m_axi_gmem_in_ARLOCK CACHE 1 2 }  { m_axi_gmem_in_ARCACHE PROT 1 4 }  { m_axi_gmem_in_ARPROT QOS 1 3 }  { m_axi_gmem_in_ARQOS REGION 1 4 }  { m_axi_gmem_in_ARREGION USER 1 4 }  { m_axi_gmem_in_ARUSER DATA 1 1 }  { m_axi_gmem_in_RVALID VALID 0 1 }  { m_axi_gmem_in_RREADY READY 1 1 }  { m_axi_gmem_in_RDATA FIFONUM 0 128 }  { m_axi_gmem_in_RLAST LAST 0 1 }  { m_axi_gmem_in_RID ID 0 1 }  { m_axi_gmem_in_RFIFONUM LEN 0 7 }  { m_axi_gmem_in_RUSER DATA 0 1 }  { m_axi_gmem_in_RRESP RESP 0 2 }  { m_axi_gmem_in_BVALID VALID 0 1 }  { m_axi_gmem_in_BREADY READY 1 1 }  { m_axi_gmem_in_BRESP RESP 0 2 }  { m_axi_gmem_in_BID ID 0 1 }  { m_axi_gmem_in_BUSER DATA 0 1 } } }
	src { ap_none {  { src in_data 0 64 }  { src_ap_vld in_vld 0 1 } } }
	 { m_axi {  { m_axi_gmem_out_AWVALID VALID 1 1 }  { m_axi_gmem_out_AWREADY READY 0 1 }  { m_axi_gmem_out_AWADDR ADDR 1 64 }  { m_axi_gmem_out_AWID ID 1 1 }  { m_axi_gmem_out_AWLEN SIZE 1 32 }  { m_axi_gmem_out_AWSIZE BURST 1 3 }  { m_axi_gmem_out_AWBURST LOCK 1 2 }  { m_axi_gmem_out_AWLOCK CACHE 1 2 }  { m_axi_gmem_out_AWCACHE PROT 1 4 }  { m_axi_gmem_out_AWPROT QOS 1 3 }  { m_axi_gmem_out_AWQOS REGION 1 4 }  { m_axi_gmem_out_AWREGION USER 1 4 }  { m_axi_gmem_out_AWUSER DATA 1 1 }  { m_axi_gmem_out_WVALID VALID 1 1 }  { m_axi_gmem_out_WREADY READY 0 1 }  { m_axi_gmem_out_WDATA FIFONUM 1 128 }  { m_axi_gmem_out_WSTRB STRB 1 16 }  { m_axi_gmem_out_WLAST LAST 1 1 }  { m_axi_gmem_out_WID ID 1 1 }  { m_axi_gmem_out_WUSER DATA 1 1 }  { m_axi_gmem_out_ARVALID VALID 1 1 }  { m_axi_gmem_out_ARREADY READY 0 1 }  { m_axi_gmem_out_ARADDR ADDR 1 64 }  { m_axi_gmem_out_ARID ID 1 1 }  { m_axi_gmem_out_ARLEN SIZE 1 32 }  { m_axi_gmem_out_ARSIZE BURST 1 3 }  { m_axi_gmem_out_ARBURST LOCK 1 2 }  { m_axi_gmem_out_ARLOCK CACHE 1 2 }  { m_axi_gmem_out_ARCACHE PROT 1 4 }  { m_axi_gmem_out_ARPROT QOS 1 3 }  { m_axi_gmem_out_ARQOS REGION 1 4 }  { m_axi_gmem_out_ARREGION USER 1 4 }  { m_axi_gmem_out_ARUSER DATA 1 1 }  { m_axi_gmem_out_RVALID VALID 0 1 }  { m_axi_gmem_out_RREADY READY 1 1 }  { m_axi_gmem_out_RDATA FIFONUM 0 128 }  { m_axi_gmem_out_RLAST LAST 0 1 }  { m_axi_gmem_out_RID ID 0 1 }  { m_axi_gmem_out_RFIFONUM LEN 0 9 }  { m_axi_gmem_out_RUSER DATA 0 1 }  { m_axi_gmem_out_RRESP RESP 0 2 }  { m_axi_gmem_out_BVALID VALID 0 1 }  { m_axi_gmem_out_BREADY READY 1 1 }  { m_axi_gmem_out_BRESP RESP 0 2 }  { m_axi_gmem_out_BID ID 0 1 }  { m_axi_gmem_out_BUSER DATA 0 1 } } }
	tensor { ap_none {  { tensor in_data 0 64 }  { tensor_ap_vld in_vld 0 1 } } }
	 { m_axi {  { m_axi_gmem_preview_AWVALID VALID 1 1 }  { m_axi_gmem_preview_AWREADY READY 0 1 }  { m_axi_gmem_preview_AWADDR ADDR 1 64 }  { m_axi_gmem_preview_AWID ID 1 1 }  { m_axi_gmem_preview_AWLEN SIZE 1 32 }  { m_axi_gmem_preview_AWSIZE BURST 1 3 }  { m_axi_gmem_preview_AWBURST LOCK 1 2 }  { m_axi_gmem_preview_AWLOCK CACHE 1 2 }  { m_axi_gmem_preview_AWCACHE PROT 1 4 }  { m_axi_gmem_preview_AWPROT QOS 1 3 }  { m_axi_gmem_preview_AWQOS REGION 1 4 }  { m_axi_gmem_preview_AWREGION USER 1 4 }  { m_axi_gmem_preview_AWUSER DATA 1 1 }  { m_axi_gmem_preview_WVALID VALID 1 1 }  { m_axi_gmem_preview_WREADY READY 0 1 }  { m_axi_gmem_preview_WDATA FIFONUM 1 128 }  { m_axi_gmem_preview_WSTRB STRB 1 16 }  { m_axi_gmem_preview_WLAST LAST 1 1 }  { m_axi_gmem_preview_WID ID 1 1 }  { m_axi_gmem_preview_WUSER DATA 1 1 }  { m_axi_gmem_preview_ARVALID VALID 1 1 }  { m_axi_gmem_preview_ARREADY READY 0 1 }  { m_axi_gmem_preview_ARADDR ADDR 1 64 }  { m_axi_gmem_preview_ARID ID 1 1 }  { m_axi_gmem_preview_ARLEN SIZE 1 32 }  { m_axi_gmem_preview_ARSIZE BURST 1 3 }  { m_axi_gmem_preview_ARBURST LOCK 1 2 }  { m_axi_gmem_preview_ARLOCK CACHE 1 2 }  { m_axi_gmem_preview_ARCACHE PROT 1 4 }  { m_axi_gmem_preview_ARPROT QOS 1 3 }  { m_axi_gmem_preview_ARQOS REGION 1 4 }  { m_axi_gmem_preview_ARREGION USER 1 4 }  { m_axi_gmem_preview_ARUSER DATA 1 1 }  { m_axi_gmem_preview_RVALID VALID 0 1 }  { m_axi_gmem_preview_RREADY READY 1 1 }  { m_axi_gmem_preview_RDATA FIFONUM 0 128 }  { m_axi_gmem_preview_RLAST LAST 0 1 }  { m_axi_gmem_preview_RID ID 0 1 }  { m_axi_gmem_preview_RFIFONUM LEN 0 9 }  { m_axi_gmem_preview_RUSER DATA 0 1 }  { m_axi_gmem_preview_RRESP RESP 0 2 }  { m_axi_gmem_preview_BVALID VALID 0 1 }  { m_axi_gmem_preview_BREADY READY 1 1 }  { m_axi_gmem_preview_BRESP RESP 0 2 }  { m_axi_gmem_preview_BID ID 0 1 }  { m_axi_gmem_preview_BUSER DATA 0 1 } } }
	preview { ap_none {  { preview in_data 0 64 }  { preview_ap_vld in_vld 0 1 } } }
	width { ap_none {  { width in_data 0 32 }  { width_ap_vld in_vld 0 1 } } }
	height { ap_none {  { height in_data 0 32 }  { height_ap_vld in_vld 0 1 } } }
	stride { ap_none {  { stride in_data 0 13 }  { stride_ap_vld in_vld 0 1 } } }
	preview_stride { ap_none {  { preview_stride in_data 0 13 }  { preview_stride_ap_vld in_vld 0 1 } } }
	rw { ap_none {  { rw in_data 0 32 }  { rw_ap_vld in_vld 0 1 } } }
	rh { ap_none {  { rh in_data 0 32 }  { rh_ap_vld in_vld 0 1 } } }
	px { ap_none {  { px in_data 0 32 }  { px_ap_vld in_vld 0 1 } } }
	py { ap_none {  { py in_data 0 32 }  { py_ap_vld in_vld 0 1 } } }
	mode { ap_none {  { mode in_data 0 32 }  { mode_ap_vld in_vld 0 1 } } }
	flags { ap_none {  { flags in_data 0 3 }  { flags_ap_vld in_vld 0 1 } } }
	saturation { ap_none {  { saturation in_data 0 14 }  { saturation_ap_vld in_vld 0 1 } } }
	eq_enabled { ap_none {  { eq_enabled in_data 0 1 }  { eq_enabled_ap_vld in_vld 0 1 } } }
	collect { ap_none {  { collect in_data 0 1 }  { collect_ap_vld in_vld 0 1 } } }
	color_0 { ap_memory {  { color_0_address0 mem_address 1 8 }  { color_0_ce0 mem_ce 1 1 }  { color_0_d0 mem_din 1 8 }  { color_0_q0 mem_dout 0 8 }  { color_0_we0 mem_we 1 1 }  { color_0_address1 mem_address 1 8 }  { color_0_ce1 mem_ce 1 1 }  { color_0_d1 mem_din 1 8 }  { color_0_q1 mem_dout 0 8 }  { color_0_we1 mem_we 1 1 } } }
	color_1 { ap_memory {  { color_1_address0 mem_address 1 8 }  { color_1_ce0 mem_ce 1 1 }  { color_1_d0 mem_din 1 8 }  { color_1_q0 mem_dout 0 8 }  { color_1_we0 mem_we 1 1 }  { color_1_address1 mem_address 1 8 }  { color_1_ce1 mem_ce 1 1 }  { color_1_d1 mem_din 1 8 }  { color_1_q1 mem_dout 0 8 }  { color_1_we1 mem_we 1 1 } } }
	color_2 { ap_memory {  { color_2_address0 mem_address 1 8 }  { color_2_ce0 mem_ce 1 1 }  { color_2_d0 mem_din 1 8 }  { color_2_q0 mem_dout 0 8 }  { color_2_we0 mem_we 1 1 }  { color_2_address1 mem_address 1 8 }  { color_2_ce1 mem_ce 1 1 }  { color_2_d1 mem_din 1 8 }  { color_2_q1 mem_dout 0 8 }  { color_2_we1 mem_we 1 1 } } }
	quant_0 { ap_memory {  { quant_0_address0 mem_address 1 8 }  { quant_0_ce0 mem_ce 1 1 }  { quant_0_d0 mem_din 1 8 }  { quant_0_q0 mem_dout 0 8 }  { quant_0_we0 mem_we 1 1 }  { quant_0_address1 mem_address 1 8 }  { quant_0_ce1 mem_ce 1 1 }  { quant_0_d1 mem_din 1 8 }  { quant_0_q1 mem_dout 0 8 }  { quant_0_we1 mem_we 1 1 } } }
	quant_1 { ap_memory {  { quant_1_address0 mem_address 1 8 }  { quant_1_ce0 mem_ce 1 1 }  { quant_1_d0 mem_din 1 8 }  { quant_1_q0 mem_dout 0 8 }  { quant_1_we0 mem_we 1 1 }  { quant_1_address1 mem_address 1 8 }  { quant_1_ce1 mem_ce 1 1 }  { quant_1_d1 mem_din 1 8 }  { quant_1_q1 mem_dout 0 8 }  { quant_1_we1 mem_we 1 1 } } }
	quant_2 { ap_memory {  { quant_2_address0 mem_address 1 8 }  { quant_2_ce0 mem_ce 1 1 }  { quant_2_d0 mem_din 1 8 }  { quant_2_q0 mem_dout 0 8 }  { quant_2_we0 mem_we 1 1 }  { quant_2_address1 mem_address 1 8 }  { quant_2_ce1 mem_ce 1 1 }  { quant_2_d1 mem_din 1 8 }  { quant_2_q1 mem_dout 0 8 }  { quant_2_we1 mem_we 1 1 } } }
	eq { ap_memory {  { eq_address0 mem_address 1 8 }  { eq_ce0 mem_ce 1 1 }  { eq_d0 mem_din 1 8 }  { eq_q0 mem_dout 0 8 }  { eq_we0 mem_we 1 1 }  { eq_address1 mem_address 1 8 }  { eq_ce1 mem_ce 1 1 }  { eq_d1 mem_din 1 8 }  { eq_q1 mem_dout 0 8 }  { eq_we1 mem_we 1 1 } } }
	hist { ap_memory {  { hist_address0 mem_address 1 8 }  { hist_ce0 mem_ce 1 1 }  { hist_d0 mem_din 1 32 }  { hist_q0 mem_dout 0 32 }  { hist_we0 mem_we 1 1 }  { hist_address1 MemPortADDR2 1 8 }  { hist_ce1 MemPortCE2 1 1 }  { hist_d1 MemPortDIN2 1 32 }  { hist_q1 mem_dout 0 32 }  { hist_we1 MemPortWE2 1 1 } } }
	xc_index { ap_memory {  { xc_index_address0 mem_address 1 9 }  { xc_index_ce0 mem_ce 1 1 }  { xc_index_d0 mem_din 1 11 }  { xc_index_q0 mem_dout 0 11 }  { xc_index_we0 mem_we 1 1 } } }
	xc_weight { ap_memory {  { xc_weight_address0 mem_address 1 9 }  { xc_weight_ce0 mem_ce 1 1 }  { xc_weight_d0 mem_din 1 12 }  { xc_weight_q0 mem_dout 0 12 }  { xc_weight_we0 mem_we 1 1 } } }
	yc_index { ap_memory {  { yc_index_address0 mem_address 1 9 }  { yc_index_ce0 mem_ce 1 1 }  { yc_index_d0 mem_din 1 11 }  { yc_index_q0 mem_dout 0 11 }  { yc_index_we0 mem_we 1 1 } } }
	yc_weight { ap_memory {  { yc_weight_address0 mem_address 1 9 }  { yc_weight_ce0 mem_ce 1 1 }  { yc_weight_d0 mem_din 1 12 }  { yc_weight_q0 mem_dout 0 12 }  { yc_weight_we0 mem_we 1 1 } } }
}
