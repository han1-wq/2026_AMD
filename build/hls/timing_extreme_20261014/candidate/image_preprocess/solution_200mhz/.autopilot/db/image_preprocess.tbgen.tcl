set moduleName image_preprocess
set isTopModule 1
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
set C_modelName {image_preprocess}
set C_modelType { int 32 }
set C_modelArgList {
	{ gmem_in int 128 regular {axi_master 0}  }
	{ gmem_out int 128 regular {axi_master 1}  }
	{ gmem_preview int 128 regular {axi_master 1}  }
	{ src int 64 regular {axi_slave 0}  }
	{ tensor int 64 regular {axi_slave 0}  }
	{ preview int 64 regular {axi_slave 0}  }
	{ luts int 64 regular {axi_slave 0}  }
	{ width int 32 regular {axi_slave 0}  }
	{ height int 32 regular {axi_slave 0}  }
	{ src_stride int 32 regular {axi_slave 0}  }
	{ src_capacity int 32 regular {axi_slave 0}  }
	{ tensor_capacity int 32 regular {axi_slave 0}  }
	{ preview_stride int 32 regular {axi_slave 0}  }
	{ preview_capacity int 32 regular {axi_slave 0}  }
	{ resized_w int 32 regular {axi_slave 0}  }
	{ resized_h int 32 regular {axi_slave 0}  }
	{ pad_x int 32 regular {axi_slave 0}  }
	{ pad_y int 32 regular {axi_slave 0}  }
	{ output_mode int 32 regular {axi_slave 0}  }
	{ flags int 32 regular {axi_slave 0}  }
	{ eq_mode int 32 regular {axi_slave 0}  }
	{ saturation_q12 int 32 regular {axi_slave 0}  }
	{ frame_id int 32 regular {axi_slave 0}  }
	{ config_id int 32 regular {axi_slave 0}  }
	{ completed_frame_id int 32 regular {axi_slave 1}  }
	{ completed_config_id int 32 regular {axi_slave 1}  }
	{ tensor_bytes int 32 regular {axi_slave 1}  }
	{ preview_bytes int 32 regular {axi_slave 1}  }
	{ abi_version int 32 regular {axi_slave 1}  }
}
set C_modelArgMapList {[ 
	{ "Name" : "gmem_in", "interface" : "axi_master", "bitwidth" : 128, "direction" : "READONLY", "bitSlice":[ {"cElement": [{"cName": "src","offset": { "type": "dynamic","port_name": "src","bundle": "control"},"direction": "READONLY"},{"cName": "luts","offset": { "type": "dynamic","port_name": "luts","bundle": "control"},"direction": "READONLY"}]}]} , 
 	{ "Name" : "gmem_out", "interface" : "axi_master", "bitwidth" : 128, "direction" : "WRITEONLY", "bitSlice":[ {"cElement": [{"cName": "tensor","offset": { "type": "dynamic","port_name": "tensor","bundle": "control"},"direction": "WRITEONLY"}]}]} , 
 	{ "Name" : "gmem_preview", "interface" : "axi_master", "bitwidth" : 128, "direction" : "WRITEONLY", "bitSlice":[ {"cElement": [{"cName": "preview","offset": { "type": "dynamic","port_name": "preview","bundle": "control"},"direction": "WRITEONLY"}]}]} , 
 	{ "Name" : "src", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":24}, "offset_end" : {"in":35}} , 
 	{ "Name" : "tensor", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":36}, "offset_end" : {"in":47}} , 
 	{ "Name" : "preview", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":48}, "offset_end" : {"in":59}} , 
 	{ "Name" : "luts", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":60}, "offset_end" : {"in":71}} , 
 	{ "Name" : "width", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 32, "direction" : "READONLY", "offset" : {"in":72}, "offset_end" : {"in":79}} , 
 	{ "Name" : "height", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 32, "direction" : "READONLY", "offset" : {"in":80}, "offset_end" : {"in":87}} , 
 	{ "Name" : "src_stride", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 32, "direction" : "READONLY", "offset" : {"in":88}, "offset_end" : {"in":95}} , 
 	{ "Name" : "src_capacity", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 32, "direction" : "READONLY", "offset" : {"in":96}, "offset_end" : {"in":103}} , 
 	{ "Name" : "tensor_capacity", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 32, "direction" : "READONLY", "offset" : {"in":104}, "offset_end" : {"in":111}} , 
 	{ "Name" : "preview_stride", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 32, "direction" : "READONLY", "offset" : {"in":112}, "offset_end" : {"in":119}} , 
 	{ "Name" : "preview_capacity", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 32, "direction" : "READONLY", "offset" : {"in":120}, "offset_end" : {"in":127}} , 
 	{ "Name" : "resized_w", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 32, "direction" : "READONLY", "offset" : {"in":128}, "offset_end" : {"in":135}} , 
 	{ "Name" : "resized_h", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 32, "direction" : "READONLY", "offset" : {"in":136}, "offset_end" : {"in":143}} , 
 	{ "Name" : "pad_x", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 32, "direction" : "READONLY", "offset" : {"in":144}, "offset_end" : {"in":151}} , 
 	{ "Name" : "pad_y", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 32, "direction" : "READONLY", "offset" : {"in":152}, "offset_end" : {"in":159}} , 
 	{ "Name" : "output_mode", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 32, "direction" : "READONLY", "offset" : {"in":160}, "offset_end" : {"in":167}} , 
 	{ "Name" : "flags", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 32, "direction" : "READONLY", "offset" : {"in":168}, "offset_end" : {"in":175}} , 
 	{ "Name" : "eq_mode", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 32, "direction" : "READONLY", "offset" : {"in":176}, "offset_end" : {"in":183}} , 
 	{ "Name" : "saturation_q12", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 32, "direction" : "READONLY", "offset" : {"in":184}, "offset_end" : {"in":191}} , 
 	{ "Name" : "frame_id", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 32, "direction" : "READONLY", "offset" : {"in":192}, "offset_end" : {"in":199}} , 
 	{ "Name" : "config_id", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 32, "direction" : "READONLY", "offset" : {"in":200}, "offset_end" : {"in":207}} , 
 	{ "Name" : "completed_frame_id", "interface" : "axi_slave", "bundle":"control","type":"ap_vld","bitwidth" : 32, "direction" : "WRITEONLY", "offset" : {"out":208}, "offset_end" : {"out":215}} , 
 	{ "Name" : "completed_config_id", "interface" : "axi_slave", "bundle":"control","type":"ap_vld","bitwidth" : 32, "direction" : "WRITEONLY", "offset" : {"out":224}, "offset_end" : {"out":231}} , 
 	{ "Name" : "tensor_bytes", "interface" : "axi_slave", "bundle":"control","type":"ap_vld","bitwidth" : 32, "direction" : "WRITEONLY", "offset" : {"out":240}, "offset_end" : {"out":247}} , 
 	{ "Name" : "preview_bytes", "interface" : "axi_slave", "bundle":"control","type":"ap_vld","bitwidth" : 32, "direction" : "WRITEONLY", "offset" : {"out":256}, "offset_end" : {"out":263}} , 
 	{ "Name" : "abi_version", "interface" : "axi_slave", "bundle":"control","type":"ap_vld","bitwidth" : 32, "direction" : "WRITEONLY", "offset" : {"out":272}, "offset_end" : {"out":279}} , 
 	{ "Name" : "ap_return", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 32, "offset" : {"out":16}} ]}
# RTL Port declarations: 
set portNum 155
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst_n sc_in sc_logic 1 reset -1 active_low_sync } 
	{ m_axi_gmem_in_AWVALID sc_out sc_logic 1 signal 0 } 
	{ m_axi_gmem_in_AWREADY sc_in sc_logic 1 signal 0 } 
	{ m_axi_gmem_in_AWADDR sc_out sc_lv 64 signal 0 } 
	{ m_axi_gmem_in_AWID sc_out sc_lv 1 signal 0 } 
	{ m_axi_gmem_in_AWLEN sc_out sc_lv 8 signal 0 } 
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
	{ m_axi_gmem_in_ARLEN sc_out sc_lv 8 signal 0 } 
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
	{ m_axi_gmem_in_RUSER sc_in sc_lv 1 signal 0 } 
	{ m_axi_gmem_in_RRESP sc_in sc_lv 2 signal 0 } 
	{ m_axi_gmem_in_BVALID sc_in sc_logic 1 signal 0 } 
	{ m_axi_gmem_in_BREADY sc_out sc_logic 1 signal 0 } 
	{ m_axi_gmem_in_BRESP sc_in sc_lv 2 signal 0 } 
	{ m_axi_gmem_in_BID sc_in sc_lv 1 signal 0 } 
	{ m_axi_gmem_in_BUSER sc_in sc_lv 1 signal 0 } 
	{ m_axi_gmem_out_AWVALID sc_out sc_logic 1 signal 1 } 
	{ m_axi_gmem_out_AWREADY sc_in sc_logic 1 signal 1 } 
	{ m_axi_gmem_out_AWADDR sc_out sc_lv 64 signal 1 } 
	{ m_axi_gmem_out_AWID sc_out sc_lv 1 signal 1 } 
	{ m_axi_gmem_out_AWLEN sc_out sc_lv 8 signal 1 } 
	{ m_axi_gmem_out_AWSIZE sc_out sc_lv 3 signal 1 } 
	{ m_axi_gmem_out_AWBURST sc_out sc_lv 2 signal 1 } 
	{ m_axi_gmem_out_AWLOCK sc_out sc_lv 2 signal 1 } 
	{ m_axi_gmem_out_AWCACHE sc_out sc_lv 4 signal 1 } 
	{ m_axi_gmem_out_AWPROT sc_out sc_lv 3 signal 1 } 
	{ m_axi_gmem_out_AWQOS sc_out sc_lv 4 signal 1 } 
	{ m_axi_gmem_out_AWREGION sc_out sc_lv 4 signal 1 } 
	{ m_axi_gmem_out_AWUSER sc_out sc_lv 1 signal 1 } 
	{ m_axi_gmem_out_WVALID sc_out sc_logic 1 signal 1 } 
	{ m_axi_gmem_out_WREADY sc_in sc_logic 1 signal 1 } 
	{ m_axi_gmem_out_WDATA sc_out sc_lv 128 signal 1 } 
	{ m_axi_gmem_out_WSTRB sc_out sc_lv 16 signal 1 } 
	{ m_axi_gmem_out_WLAST sc_out sc_logic 1 signal 1 } 
	{ m_axi_gmem_out_WID sc_out sc_lv 1 signal 1 } 
	{ m_axi_gmem_out_WUSER sc_out sc_lv 1 signal 1 } 
	{ m_axi_gmem_out_ARVALID sc_out sc_logic 1 signal 1 } 
	{ m_axi_gmem_out_ARREADY sc_in sc_logic 1 signal 1 } 
	{ m_axi_gmem_out_ARADDR sc_out sc_lv 64 signal 1 } 
	{ m_axi_gmem_out_ARID sc_out sc_lv 1 signal 1 } 
	{ m_axi_gmem_out_ARLEN sc_out sc_lv 8 signal 1 } 
	{ m_axi_gmem_out_ARSIZE sc_out sc_lv 3 signal 1 } 
	{ m_axi_gmem_out_ARBURST sc_out sc_lv 2 signal 1 } 
	{ m_axi_gmem_out_ARLOCK sc_out sc_lv 2 signal 1 } 
	{ m_axi_gmem_out_ARCACHE sc_out sc_lv 4 signal 1 } 
	{ m_axi_gmem_out_ARPROT sc_out sc_lv 3 signal 1 } 
	{ m_axi_gmem_out_ARQOS sc_out sc_lv 4 signal 1 } 
	{ m_axi_gmem_out_ARREGION sc_out sc_lv 4 signal 1 } 
	{ m_axi_gmem_out_ARUSER sc_out sc_lv 1 signal 1 } 
	{ m_axi_gmem_out_RVALID sc_in sc_logic 1 signal 1 } 
	{ m_axi_gmem_out_RREADY sc_out sc_logic 1 signal 1 } 
	{ m_axi_gmem_out_RDATA sc_in sc_lv 128 signal 1 } 
	{ m_axi_gmem_out_RLAST sc_in sc_logic 1 signal 1 } 
	{ m_axi_gmem_out_RID sc_in sc_lv 1 signal 1 } 
	{ m_axi_gmem_out_RUSER sc_in sc_lv 1 signal 1 } 
	{ m_axi_gmem_out_RRESP sc_in sc_lv 2 signal 1 } 
	{ m_axi_gmem_out_BVALID sc_in sc_logic 1 signal 1 } 
	{ m_axi_gmem_out_BREADY sc_out sc_logic 1 signal 1 } 
	{ m_axi_gmem_out_BRESP sc_in sc_lv 2 signal 1 } 
	{ m_axi_gmem_out_BID sc_in sc_lv 1 signal 1 } 
	{ m_axi_gmem_out_BUSER sc_in sc_lv 1 signal 1 } 
	{ m_axi_gmem_preview_AWVALID sc_out sc_logic 1 signal 2 } 
	{ m_axi_gmem_preview_AWREADY sc_in sc_logic 1 signal 2 } 
	{ m_axi_gmem_preview_AWADDR sc_out sc_lv 64 signal 2 } 
	{ m_axi_gmem_preview_AWID sc_out sc_lv 1 signal 2 } 
	{ m_axi_gmem_preview_AWLEN sc_out sc_lv 8 signal 2 } 
	{ m_axi_gmem_preview_AWSIZE sc_out sc_lv 3 signal 2 } 
	{ m_axi_gmem_preview_AWBURST sc_out sc_lv 2 signal 2 } 
	{ m_axi_gmem_preview_AWLOCK sc_out sc_lv 2 signal 2 } 
	{ m_axi_gmem_preview_AWCACHE sc_out sc_lv 4 signal 2 } 
	{ m_axi_gmem_preview_AWPROT sc_out sc_lv 3 signal 2 } 
	{ m_axi_gmem_preview_AWQOS sc_out sc_lv 4 signal 2 } 
	{ m_axi_gmem_preview_AWREGION sc_out sc_lv 4 signal 2 } 
	{ m_axi_gmem_preview_AWUSER sc_out sc_lv 1 signal 2 } 
	{ m_axi_gmem_preview_WVALID sc_out sc_logic 1 signal 2 } 
	{ m_axi_gmem_preview_WREADY sc_in sc_logic 1 signal 2 } 
	{ m_axi_gmem_preview_WDATA sc_out sc_lv 128 signal 2 } 
	{ m_axi_gmem_preview_WSTRB sc_out sc_lv 16 signal 2 } 
	{ m_axi_gmem_preview_WLAST sc_out sc_logic 1 signal 2 } 
	{ m_axi_gmem_preview_WID sc_out sc_lv 1 signal 2 } 
	{ m_axi_gmem_preview_WUSER sc_out sc_lv 1 signal 2 } 
	{ m_axi_gmem_preview_ARVALID sc_out sc_logic 1 signal 2 } 
	{ m_axi_gmem_preview_ARREADY sc_in sc_logic 1 signal 2 } 
	{ m_axi_gmem_preview_ARADDR sc_out sc_lv 64 signal 2 } 
	{ m_axi_gmem_preview_ARID sc_out sc_lv 1 signal 2 } 
	{ m_axi_gmem_preview_ARLEN sc_out sc_lv 8 signal 2 } 
	{ m_axi_gmem_preview_ARSIZE sc_out sc_lv 3 signal 2 } 
	{ m_axi_gmem_preview_ARBURST sc_out sc_lv 2 signal 2 } 
	{ m_axi_gmem_preview_ARLOCK sc_out sc_lv 2 signal 2 } 
	{ m_axi_gmem_preview_ARCACHE sc_out sc_lv 4 signal 2 } 
	{ m_axi_gmem_preview_ARPROT sc_out sc_lv 3 signal 2 } 
	{ m_axi_gmem_preview_ARQOS sc_out sc_lv 4 signal 2 } 
	{ m_axi_gmem_preview_ARREGION sc_out sc_lv 4 signal 2 } 
	{ m_axi_gmem_preview_ARUSER sc_out sc_lv 1 signal 2 } 
	{ m_axi_gmem_preview_RVALID sc_in sc_logic 1 signal 2 } 
	{ m_axi_gmem_preview_RREADY sc_out sc_logic 1 signal 2 } 
	{ m_axi_gmem_preview_RDATA sc_in sc_lv 128 signal 2 } 
	{ m_axi_gmem_preview_RLAST sc_in sc_logic 1 signal 2 } 
	{ m_axi_gmem_preview_RID sc_in sc_lv 1 signal 2 } 
	{ m_axi_gmem_preview_RUSER sc_in sc_lv 1 signal 2 } 
	{ m_axi_gmem_preview_RRESP sc_in sc_lv 2 signal 2 } 
	{ m_axi_gmem_preview_BVALID sc_in sc_logic 1 signal 2 } 
	{ m_axi_gmem_preview_BREADY sc_out sc_logic 1 signal 2 } 
	{ m_axi_gmem_preview_BRESP sc_in sc_lv 2 signal 2 } 
	{ m_axi_gmem_preview_BID sc_in sc_lv 1 signal 2 } 
	{ m_axi_gmem_preview_BUSER sc_in sc_lv 1 signal 2 } 
	{ s_axi_control_AWVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_AWREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_AWADDR sc_in sc_lv 9 signal -1 } 
	{ s_axi_control_WVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_WREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_WDATA sc_in sc_lv 32 signal -1 } 
	{ s_axi_control_WSTRB sc_in sc_lv 4 signal -1 } 
	{ s_axi_control_ARVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_ARREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_ARADDR sc_in sc_lv 9 signal -1 } 
	{ s_axi_control_RVALID sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_RREADY sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_RDATA sc_out sc_lv 32 signal -1 } 
	{ s_axi_control_RRESP sc_out sc_lv 2 signal -1 } 
	{ s_axi_control_BVALID sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_BREADY sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_BRESP sc_out sc_lv 2 signal -1 } 
	{ interrupt sc_out sc_logic 1 signal -1 } 
}
set NewPortList {[ 
	{ "name": "s_axi_control_AWADDR", "direction": "in", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "control", "role": "AWADDR" },"address":[{"name":"image_preprocess","role":"start","value":"0","valid_bit":"0"},{"name":"image_preprocess","role":"continue","value":"0","valid_bit":"4"},{"name":"image_preprocess","role":"auto_start","value":"0","valid_bit":"7"},{"name":"src","role":"data","value":"24"},{"name":"tensor","role":"data","value":"36"},{"name":"preview","role":"data","value":"48"},{"name":"luts","role":"data","value":"60"},{"name":"width","role":"data","value":"72"},{"name":"height","role":"data","value":"80"},{"name":"src_stride","role":"data","value":"88"},{"name":"src_capacity","role":"data","value":"96"},{"name":"tensor_capacity","role":"data","value":"104"},{"name":"preview_stride","role":"data","value":"112"},{"name":"preview_capacity","role":"data","value":"120"},{"name":"resized_w","role":"data","value":"128"},{"name":"resized_h","role":"data","value":"136"},{"name":"pad_x","role":"data","value":"144"},{"name":"pad_y","role":"data","value":"152"},{"name":"output_mode","role":"data","value":"160"},{"name":"flags","role":"data","value":"168"},{"name":"eq_mode","role":"data","value":"176"},{"name":"saturation_q12","role":"data","value":"184"},{"name":"frame_id","role":"data","value":"192"},{"name":"config_id","role":"data","value":"200"}] },
	{ "name": "s_axi_control_AWVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "AWVALID" } },
	{ "name": "s_axi_control_AWREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "AWREADY" } },
	{ "name": "s_axi_control_WVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "WVALID" } },
	{ "name": "s_axi_control_WREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "WREADY" } },
	{ "name": "s_axi_control_WDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "control", "role": "WDATA" } },
	{ "name": "s_axi_control_WSTRB", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "control", "role": "WSTRB" } },
	{ "name": "s_axi_control_ARADDR", "direction": "in", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "control", "role": "ARADDR" },"address":[{"name":"image_preprocess","role":"start","value":"0","valid_bit":"0"},{"name":"image_preprocess","role":"done","value":"0","valid_bit":"1"},{"name":"image_preprocess","role":"idle","value":"0","valid_bit":"2"},{"name":"image_preprocess","role":"ready","value":"0","valid_bit":"3"},{"name":"image_preprocess","role":"auto_start","value":"0","valid_bit":"7"},{"name":"return","role":"data","value":"16"},{"name":"completed_frame_id","role":"data","value":"208"}, {"name":"completed_frame_id","role":"valid","value":"212","valid_bit":"0"},{"name":"completed_config_id","role":"data","value":"224"}, {"name":"completed_config_id","role":"valid","value":"228","valid_bit":"0"},{"name":"tensor_bytes","role":"data","value":"240"}, {"name":"tensor_bytes","role":"valid","value":"244","valid_bit":"0"},{"name":"preview_bytes","role":"data","value":"256"}, {"name":"preview_bytes","role":"valid","value":"260","valid_bit":"0"},{"name":"abi_version","role":"data","value":"272"}, {"name":"abi_version","role":"valid","value":"276","valid_bit":"0"}] },
	{ "name": "s_axi_control_ARVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "ARVALID" } },
	{ "name": "s_axi_control_ARREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "ARREADY" } },
	{ "name": "s_axi_control_RVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "RVALID" } },
	{ "name": "s_axi_control_RREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "RREADY" } },
	{ "name": "s_axi_control_RDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "control", "role": "RDATA" } },
	{ "name": "s_axi_control_RRESP", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "control", "role": "RRESP" } },
	{ "name": "s_axi_control_BVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "BVALID" } },
	{ "name": "s_axi_control_BREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "BREADY" } },
	{ "name": "s_axi_control_BRESP", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "control", "role": "BRESP" } },
	{ "name": "interrupt", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "interrupt" } }, 
 	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst_n", "role": "default" }} , 
 	{ "name": "m_axi_gmem_in_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_in", "role": "AWVALID" }} , 
 	{ "name": "m_axi_gmem_in_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_in", "role": "AWREADY" }} , 
 	{ "name": "m_axi_gmem_in_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem_in", "role": "AWADDR" }} , 
 	{ "name": "m_axi_gmem_in_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_in", "role": "AWID" }} , 
 	{ "name": "m_axi_gmem_in_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem_in", "role": "AWLEN" }} , 
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
 	{ "name": "m_axi_gmem_in_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem_in", "role": "ARLEN" }} , 
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
 	{ "name": "m_axi_gmem_in_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_in", "role": "RUSER" }} , 
 	{ "name": "m_axi_gmem_in_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem_in", "role": "RRESP" }} , 
 	{ "name": "m_axi_gmem_in_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_in", "role": "BVALID" }} , 
 	{ "name": "m_axi_gmem_in_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_in", "role": "BREADY" }} , 
 	{ "name": "m_axi_gmem_in_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem_in", "role": "BRESP" }} , 
 	{ "name": "m_axi_gmem_in_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_in", "role": "BID" }} , 
 	{ "name": "m_axi_gmem_in_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_in", "role": "BUSER" }} , 
 	{ "name": "m_axi_gmem_out_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_out", "role": "AWVALID" }} , 
 	{ "name": "m_axi_gmem_out_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_out", "role": "AWREADY" }} , 
 	{ "name": "m_axi_gmem_out_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem_out", "role": "AWADDR" }} , 
 	{ "name": "m_axi_gmem_out_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_out", "role": "AWID" }} , 
 	{ "name": "m_axi_gmem_out_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem_out", "role": "AWLEN" }} , 
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
 	{ "name": "m_axi_gmem_out_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem_out", "role": "ARLEN" }} , 
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
 	{ "name": "m_axi_gmem_out_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_out", "role": "RUSER" }} , 
 	{ "name": "m_axi_gmem_out_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem_out", "role": "RRESP" }} , 
 	{ "name": "m_axi_gmem_out_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_out", "role": "BVALID" }} , 
 	{ "name": "m_axi_gmem_out_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_out", "role": "BREADY" }} , 
 	{ "name": "m_axi_gmem_out_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem_out", "role": "BRESP" }} , 
 	{ "name": "m_axi_gmem_out_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_out", "role": "BID" }} , 
 	{ "name": "m_axi_gmem_out_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_out", "role": "BUSER" }} , 
 	{ "name": "m_axi_gmem_preview_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_preview", "role": "AWVALID" }} , 
 	{ "name": "m_axi_gmem_preview_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_preview", "role": "AWREADY" }} , 
 	{ "name": "m_axi_gmem_preview_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem_preview", "role": "AWADDR" }} , 
 	{ "name": "m_axi_gmem_preview_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_preview", "role": "AWID" }} , 
 	{ "name": "m_axi_gmem_preview_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem_preview", "role": "AWLEN" }} , 
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
 	{ "name": "m_axi_gmem_preview_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem_preview", "role": "ARLEN" }} , 
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
 	{ "name": "m_axi_gmem_preview_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_preview", "role": "RUSER" }} , 
 	{ "name": "m_axi_gmem_preview_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem_preview", "role": "RRESP" }} , 
 	{ "name": "m_axi_gmem_preview_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_preview", "role": "BVALID" }} , 
 	{ "name": "m_axi_gmem_preview_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_preview", "role": "BREADY" }} , 
 	{ "name": "m_axi_gmem_preview_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem_preview", "role": "BRESP" }} , 
 	{ "name": "m_axi_gmem_preview_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_preview", "role": "BID" }} , 
 	{ "name": "m_axi_gmem_preview_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem_preview", "role": "BUSER" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "17", "19", "21", "23", "25", "51", "54", "151", "152", "153", "154", "155", "156", "157"],
		"CDFG" : "image_preprocess",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "5", "EstimateLatencyMax" : "10425286",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "1",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "gmem_in", "Type" : "MAXI", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "gmem_in_blk_n_AR", "Type" : "RtlSignal"},
					{"Name" : "gmem_in_blk_n_R", "Type" : "RtlSignal"}],
				"SubConnect" : [
					{"ID" : "54", "SubInstance" : "grp_p_anonymous_namespace_output_pass_fu_618", "Port" : "gmem_in", "Inst_start_state" : "22", "Inst_end_state" : "23"},
					{"ID" : "25", "SubInstance" : "grp_p_anonymous_namespace_statistics_pass_fu_594", "Port" : "gmem_in", "Inst_start_state" : "18", "Inst_end_state" : "19"}]},
			{"Name" : "gmem_out", "Type" : "MAXI", "Direction" : "O",
				"SubConnect" : [
					{"ID" : "54", "SubInstance" : "grp_p_anonymous_namespace_output_pass_fu_618", "Port" : "gmem_out", "Inst_start_state" : "22", "Inst_end_state" : "23"}]},
			{"Name" : "gmem_preview", "Type" : "MAXI", "Direction" : "O",
				"SubConnect" : [
					{"ID" : "54", "SubInstance" : "grp_p_anonymous_namespace_output_pass_fu_618", "Port" : "gmem_preview", "Inst_start_state" : "22", "Inst_end_state" : "23"}]},
			{"Name" : "src", "Type" : "None", "Direction" : "I"},
			{"Name" : "tensor", "Type" : "None", "Direction" : "I"},
			{"Name" : "preview", "Type" : "None", "Direction" : "I"},
			{"Name" : "luts", "Type" : "None", "Direction" : "I"},
			{"Name" : "width", "Type" : "None", "Direction" : "I"},
			{"Name" : "height", "Type" : "None", "Direction" : "I"},
			{"Name" : "src_stride", "Type" : "None", "Direction" : "I"},
			{"Name" : "src_capacity", "Type" : "None", "Direction" : "I"},
			{"Name" : "tensor_capacity", "Type" : "None", "Direction" : "I"},
			{"Name" : "preview_stride", "Type" : "None", "Direction" : "I"},
			{"Name" : "preview_capacity", "Type" : "None", "Direction" : "I"},
			{"Name" : "resized_w", "Type" : "None", "Direction" : "I"},
			{"Name" : "resized_h", "Type" : "None", "Direction" : "I"},
			{"Name" : "pad_x", "Type" : "None", "Direction" : "I"},
			{"Name" : "pad_y", "Type" : "None", "Direction" : "I"},
			{"Name" : "output_mode", "Type" : "None", "Direction" : "I"},
			{"Name" : "flags", "Type" : "None", "Direction" : "I"},
			{"Name" : "eq_mode", "Type" : "None", "Direction" : "I"},
			{"Name" : "saturation_q12", "Type" : "None", "Direction" : "I"},
			{"Name" : "frame_id", "Type" : "None", "Direction" : "I"},
			{"Name" : "config_id", "Type" : "None", "Direction" : "I"},
			{"Name" : "completed_frame_id", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "completed_config_id", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "tensor_bytes", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "preview_bytes", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "abi_version", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "history_valid", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "previous_width", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "previous_height", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "previous_config", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "previous_flags", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "previous_saturation", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "previous_V", "Type" : "Memory", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "17", "SubInstance" : "grp_image_preprocess_Pipeline_VITIS_LOOP_567_4_fu_556", "Port" : "previous_V", "Inst_start_state" : "13", "Inst_end_state" : "17"},
					{"ID" : "51", "SubInstance" : "grp_p_anonymous_namespace_build_lut_fu_610", "Port" : "lut", "Inst_start_state" : "24", "Inst_end_state" : "25"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_555_1", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "26", "FirstState" : "ap_ST_fsm_state13", "LastState" : ["ap_ST_fsm_state16"], "QuitState" : ["ap_ST_fsm_state13"], "PreState" : ["ap_ST_fsm_state12"], "PostState" : ["ap_ST_fsm_state17"], "OneDepthLoop" : "0", "OneStateBlock": ""}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.previous_V_U", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.color_V_U", "Parent" : "0"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.color_V_1_U", "Parent" : "0"},
	{"ID" : "4", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.color_V_2_U", "Parent" : "0"},
	{"ID" : "5", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.quant_V_U", "Parent" : "0"},
	{"ID" : "6", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.quant_V_1_U", "Parent" : "0"},
	{"ID" : "7", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.quant_V_2_U", "Parent" : "0"},
	{"ID" : "8", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.eq_V_U", "Parent" : "0"},
	{"ID" : "9", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.hist_V_U", "Parent" : "0"},
	{"ID" : "10", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xc_index_V_U", "Parent" : "0"},
	{"ID" : "11", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.xc_weight_V_U", "Parent" : "0"},
	{"ID" : "12", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.yc_index_V_U", "Parent" : "0"},
	{"ID" : "13", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.yc_weight_V_U", "Parent" : "0"},
	{"ID" : "14", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_validate_settings_fu_522", "Parent" : "0", "Child" : ["15", "16"],
		"CDFG" : "p_anonymous_namespace_validate_settings",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "0", "ap_start" : "0", "ap_ready" : "0", "ap_done" : "0", "ap_continue" : "0", "ap_idle" : "0", "real_start" : "0",
		"Pipeline" : "Aligned", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "1",
		"VariableLatency" : "0", "ExactLatency" : "3", "EstimateLatencyMin" : "3", "EstimateLatencyMax" : "3",
		"Combinational" : "0",
		"Datapath" : "1",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "width", "Type" : "None", "Direction" : "I"},
			{"Name" : "height", "Type" : "None", "Direction" : "I"},
			{"Name" : "src_stride", "Type" : "None", "Direction" : "I"},
			{"Name" : "src_capacity", "Type" : "None", "Direction" : "I"},
			{"Name" : "tensor_capacity", "Type" : "None", "Direction" : "I"},
			{"Name" : "preview_stride", "Type" : "None", "Direction" : "I"},
			{"Name" : "preview_capacity", "Type" : "None", "Direction" : "I"},
			{"Name" : "resized_w", "Type" : "None", "Direction" : "I"},
			{"Name" : "resized_h", "Type" : "None", "Direction" : "I"},
			{"Name" : "pad_x", "Type" : "None", "Direction" : "I"},
			{"Name" : "pad_y", "Type" : "None", "Direction" : "I"},
			{"Name" : "output_mode", "Type" : "None", "Direction" : "I"},
			{"Name" : "flags", "Type" : "None", "Direction" : "I"},
			{"Name" : "eq_mode", "Type" : "None", "Direction" : "I"},
			{"Name" : "saturation_q12", "Type" : "None", "Direction" : "I"}]},
	{"ID" : "15", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_validate_settings_fu_522.mul_13ns_11ns_24_3_1_U1", "Parent" : "14"},
	{"ID" : "16", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_validate_settings_fu_522.mul_13ns_11ns_24_3_1_U2", "Parent" : "14"},
	{"ID" : "17", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_image_preprocess_Pipeline_VITIS_LOOP_567_4_fu_556", "Parent" : "0", "Child" : ["18"],
		"CDFG" : "image_preprocess_Pipeline_VITIS_LOOP_567_4",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "258", "EstimateLatencyMax" : "258",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "hist_V", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "use_history", "Type" : "None", "Direction" : "I"},
			{"Name" : "eq_V", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "previous_V", "Type" : "Memory", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_567_4", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter0", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "18", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_image_preprocess_Pipeline_VITIS_LOOP_567_4_fu_556.flow_control_loop_pipe_sequential_init_U", "Parent" : "17"},
	{"ID" : "19", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_make_coordinates_fu_565", "Parent" : "0", "Child" : ["20"],
		"CDFG" : "p_anonymous_namespace_make_coordinates",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "50", "EstimateLatencyMax" : "20385",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "coordinates_index", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "coordinates_weight", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "src", "Type" : "None", "Direction" : "I"},
			{"Name" : "dst", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_272_1", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "4", "FirstState" : "ap_ST_fsm_state2", "LastState" : ["ap_ST_fsm_state4"], "QuitState" : ["ap_ST_fsm_state2"], "PreState" : ["ap_ST_fsm_state1"], "PostState" : ["ap_ST_fsm_state1"], "OneDepthLoop" : "0", "OneStateBlock": ""}}]},
	{"ID" : "20", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_make_coordinates_fu_565.grp_p_anonymous_namespace_coordinate_divide_fu_106", "Parent" : "19",
		"CDFG" : "p_anonymous_namespace_coordinate_divide",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "23", "EstimateLatencyMax" : "23",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "numerator", "Type" : "None", "Direction" : "I"},
			{"Name" : "denominator", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_249_1", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "2", "FirstState" : "ap_ST_fsm_state2", "LastState" : ["ap_ST_fsm_state2"], "QuitState" : ["ap_ST_fsm_state2"], "PreState" : ["ap_ST_fsm_state1"], "PostState" : ["ap_ST_fsm_state1"], "OneDepthLoop" : "1", "OneStateBlock": "ap_ST_fsm_state2_blk"}}]},
	{"ID" : "21", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_make_coordinates_fu_573", "Parent" : "0", "Child" : ["22"],
		"CDFG" : "p_anonymous_namespace_make_coordinates",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "50", "EstimateLatencyMax" : "20385",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "coordinates_index", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "coordinates_weight", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "src", "Type" : "None", "Direction" : "I"},
			{"Name" : "dst", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_272_1", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "4", "FirstState" : "ap_ST_fsm_state2", "LastState" : ["ap_ST_fsm_state4"], "QuitState" : ["ap_ST_fsm_state2"], "PreState" : ["ap_ST_fsm_state1"], "PostState" : ["ap_ST_fsm_state1"], "OneDepthLoop" : "0", "OneStateBlock": ""}}]},
	{"ID" : "22", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_make_coordinates_fu_573.grp_p_anonymous_namespace_coordinate_divide_fu_106", "Parent" : "21",
		"CDFG" : "p_anonymous_namespace_coordinate_divide",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "23", "EstimateLatencyMax" : "23",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "numerator", "Type" : "None", "Direction" : "I"},
			{"Name" : "denominator", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_249_1", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "2", "FirstState" : "ap_ST_fsm_state2", "LastState" : ["ap_ST_fsm_state2"], "QuitState" : ["ap_ST_fsm_state2"], "PreState" : ["ap_ST_fsm_state1"], "PostState" : ["ap_ST_fsm_state1"], "OneDepthLoop" : "1", "OneStateBlock": "ap_ST_fsm_state2_blk"}}]},
	{"ID" : "23", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_image_preprocess_Pipeline_VITIS_LOOP_557_2_fu_581", "Parent" : "0", "Child" : ["24"],
		"CDFG" : "image_preprocess_Pipeline_VITIS_LOOP_557_2",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "18", "EstimateLatencyMax" : "18",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "quant_V", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "quant_V_1", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "quant_V_2", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "color_V_2", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "color_V_1", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "color_V", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "and_r", "Type" : "None", "Direction" : "I"},
			{"Name" : "v_V", "Type" : "None", "Direction" : "I"},
			{"Name" : "cmp64", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_557_2", "PipelineType" : "NotSupport"}]},
	{"ID" : "24", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_image_preprocess_Pipeline_VITIS_LOOP_557_2_fu_581.flow_control_loop_pipe_sequential_init_U", "Parent" : "23"},
	{"ID" : "25", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_statistics_pass_fu_594", "Parent" : "0", "Child" : ["26", "30", "34", "36", "45", "46", "47", "48", "49", "50"],
		"CDFG" : "p_anonymous_namespace_statistics_pass",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "Dataflow", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "1",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "346145", "EstimateLatencyMax" : "4147233",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "1",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"InputProcess" : [
			{"ID" : "26", "Name" : "p_anonymous_namespace_read_words_U0"},
			{"ID" : "34", "Name" : "p_anonymous_namespace_statistics_pass_Block_entry36_proc_U0"},
			{"ID" : "36", "Name" : "p_anonymous_namespace_histogram_pixels_U0"}],
		"OutputProcess" : [
			{"ID" : "36", "Name" : "p_anonymous_namespace_histogram_pixels_U0"}],
		"Port" : [
			{"Name" : "gmem_in", "Type" : "MAXI", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "26", "SubInstance" : "p_anonymous_namespace_read_words_U0", "Port" : "gmem_in"}]},
			{"Name" : "src", "Type" : "None", "Direction" : "I"},
			{"Name" : "width", "Type" : "None", "Direction" : "I"},
			{"Name" : "height", "Type" : "None", "Direction" : "I"},
			{"Name" : "stride", "Type" : "None", "Direction" : "I"},
			{"Name" : "color_0", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "36", "SubInstance" : "p_anonymous_namespace_histogram_pixels_U0", "Port" : "color_0"}]},
			{"Name" : "color_1", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "36", "SubInstance" : "p_anonymous_namespace_histogram_pixels_U0", "Port" : "color_1"}]},
			{"Name" : "color_2", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "36", "SubInstance" : "p_anonymous_namespace_histogram_pixels_U0", "Port" : "color_2"}]},
			{"Name" : "flags", "Type" : "None", "Direction" : "I"},
			{"Name" : "saturation", "Type" : "None", "Direction" : "I"},
			{"Name" : "hist", "Type" : "Memory", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "36", "SubInstance" : "p_anonymous_namespace_histogram_pixels_U0", "Port" : "hist"}]}]},
	{"ID" : "26", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_read_words_U0", "Parent" : "25", "Child" : ["27", "29"],
		"CDFG" : "p_anonymous_namespace_read_words",
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
					{"ID" : "27", "SubInstance" : "grp_p_anonymous_namespace_read_words_Pipeline_VITIS_LOOP_145_2_fu_146", "Port" : "gmem_in", "Inst_start_state" : "13", "Inst_end_state" : "14"}]},
			{"Name" : "src", "Type" : "None", "Direction" : "I"},
			{"Name" : "words1", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["30"], "DependentChan" : "45", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "27", "SubInstance" : "grp_p_anonymous_namespace_read_words_Pipeline_VITIS_LOOP_145_2_fu_146", "Port" : "words1", "Inst_start_state" : "13", "Inst_end_state" : "14"}]},
			{"Name" : "width", "Type" : "None", "Direction" : "I"},
			{"Name" : "height", "Type" : "None", "Direction" : "I"},
			{"Name" : "stride", "Type" : "None", "Direction" : "I"},
			{"Name" : "width_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["30"], "DependentChan" : "46", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "width_c_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "height_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["30"], "DependentChan" : "47", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "height_c_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_143_1", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "14", "FirstState" : "ap_ST_fsm_state2", "LastState" : ["ap_ST_fsm_state14"], "QuitState" : ["ap_ST_fsm_state2"], "PreState" : ["ap_ST_fsm_state1"], "PostState" : ["ap_ST_fsm_state1"], "OneDepthLoop" : "0", "OneStateBlock": ""}}]},
	{"ID" : "27", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_read_words_U0.grp_p_anonymous_namespace_read_words_Pipeline_VITIS_LOOP_145_2_fu_146", "Parent" : "26", "Child" : ["28"],
		"CDFG" : "p_anonymous_namespace_read_words_Pipeline_VITIS_LOOP_145_2",
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
			{"Name" : "words1", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "words1_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_145_2", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter2", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "28", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_read_words_U0.grp_p_anonymous_namespace_read_words_Pipeline_VITIS_LOOP_145_2_fu_146.flow_control_loop_pipe_sequential_init_U", "Parent" : "27"},
	{"ID" : "29", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_read_words_U0.mul_mul_9ns_11ns_20_4_1_U42", "Parent" : "26"},
	{"ID" : "30", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_unpack_U0", "Parent" : "25", "Child" : ["31", "33"],
		"CDFG" : "p_anonymous_namespace_unpack",
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
		"StartSource" : "26",
		"StartFifo" : "start_for_p_anonymous_namespace_unpack_U0_U",
		"Port" : [
			{"Name" : "words1", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["26"], "DependentChan" : "45", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "31", "SubInstance" : "grp_p_anonymous_namespace_unpack_Pipeline_VITIS_LOOP_156_1_VITIS_LOOP_160_2_fu_46", "Port" : "words1", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "pixels2", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["36"], "DependentChan" : "48", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "31", "SubInstance" : "grp_p_anonymous_namespace_unpack_Pipeline_VITIS_LOOP_156_1_VITIS_LOOP_160_2_fu_46", "Port" : "pixels2", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "width", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["26"], "DependentChan" : "46", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "width_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "height", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["26"], "DependentChan" : "47", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "height_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "31", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_unpack_U0.grp_p_anonymous_namespace_unpack_Pipeline_VITIS_LOOP_156_1_VITIS_LOOP_160_2_fu_46", "Parent" : "30", "Child" : ["32"],
		"CDFG" : "p_anonymous_namespace_unpack_Pipeline_VITIS_LOOP_156_1_VITIS_LOOP_160_2",
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
			{"Name" : "pixels2", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "pixels2_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "width_load", "Type" : "None", "Direction" : "I"},
			{"Name" : "words1", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "words1_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_156_1_VITIS_LOOP_160_2", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter1", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "32", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_unpack_U0.grp_p_anonymous_namespace_unpack_Pipeline_VITIS_LOOP_156_1_VITIS_LOOP_160_2_fu_46.flow_control_loop_pipe_sequential_init_U", "Parent" : "31"},
	{"ID" : "33", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_unpack_U0.mul_32ns_32ns_64_1_1_U56", "Parent" : "30"},
	{"ID" : "34", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_statistics_pass_Block_entry36_proc_U0", "Parent" : "25", "Child" : ["35"],
		"CDFG" : "p_anonymous_namespace_statistics_pass_Block_entry36_proc",
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
			{"Name" : "width", "Type" : "None", "Direction" : "I"}]},
	{"ID" : "35", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_statistics_pass_Block_entry36_proc_U0.mul_11ns_11ns_22_1_1_U62", "Parent" : "34"},
	{"ID" : "36", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_histogram_pixels_U0", "Parent" : "25", "Child" : ["37", "38", "39", "40", "41", "42", "43", "44"],
		"CDFG" : "p_anonymous_namespace_histogram_pixels",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "346129", "EstimateLatencyMax" : "4147217",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "pixels", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["30"], "DependentChan" : "48", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "pixels_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "hist", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "color_0", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "color_1", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "color_2", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "flags", "Type" : "None", "Direction" : "I"},
			{"Name" : "saturation", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read", "Type" : "None", "Direction" : "I", "DependentProc" : ["34"], "DependentChan" : "49", "DependentChanDepth" : "3", "DependentChanType" : "1"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_178_1", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "2", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage1", "LastStateIter" : "ap_enable_reg_pp0_iter8", "LastStateBlock" : "ap_block_pp0_stage1_subdone", "QuitState" : "ap_ST_fsm_pp0_stage1", "QuitStateIter" : "ap_enable_reg_pp0_iter8", "QuitStateBlock" : "ap_block_pp0_stage1_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "1"}}]},
	{"ID" : "37", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_histogram_pixels_U0.mac_muladd_8ns_8ns_15s_17_4_1_U66", "Parent" : "36"},
	{"ID" : "38", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_histogram_pixels_U0.mac_muladd_8ns_7ns_17s_18_4_1_U67", "Parent" : "36"},
	{"ID" : "39", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_histogram_pixels_U0.mac_muladd_14ns_10s_22s_25_4_1_U68", "Parent" : "36"},
	{"ID" : "40", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_histogram_pixels_U0.mac_muladd_14ns_10s_22s_25_4_1_U69", "Parent" : "36"},
	{"ID" : "41", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_histogram_pixels_U0.mac_muladd_14ns_10s_22s_25_4_1_U70", "Parent" : "36"},
	{"ID" : "42", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_histogram_pixels_U0.mac_muladd_8ns_8ns_15s_16_4_1_U71", "Parent" : "36"},
	{"ID" : "43", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_histogram_pixels_U0.mac_muladd_8ns_7ns_16s_16_4_1_U72", "Parent" : "36"},
	{"ID" : "44", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_histogram_pixels_U0.flow_control_loop_delay_pipe_U", "Parent" : "36"},
	{"ID" : "45", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_statistics_pass_fu_594.words_U", "Parent" : "25"},
	{"ID" : "46", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_statistics_pass_fu_594.width_c_U", "Parent" : "25"},
	{"ID" : "47", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_statistics_pass_fu_594.height_c_U", "Parent" : "25"},
	{"ID" : "48", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_statistics_pass_fu_594.pixels_U", "Parent" : "25"},
	{"ID" : "49", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_statistics_pass_fu_594.tmp_U", "Parent" : "25"},
	{"ID" : "50", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_statistics_pass_fu_594.start_for_p_anonymous_namespace_unpack_U0_U", "Parent" : "25"},
	{"ID" : "51", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_build_lut_fu_610", "Parent" : "0", "Child" : ["52"],
		"CDFG" : "p_anonymous_namespace_build_lut",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "1029", "EstimateLatencyMax" : "3333",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "hist", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "52", "SubInstance" : "grp_p_anonymous_namespace_build_lut_Pipeline_VITIS_LOOP_206_1_fu_156", "Port" : "hist", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "lut", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "n", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_226_3", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "7", "FirstState" : "ap_ST_fsm_state7", "LastState" : ["ap_ST_fsm_state7"], "QuitState" : ["ap_ST_fsm_state7"], "PreState" : ["ap_ST_fsm_state6", "ap_ST_fsm_state5"], "PostState" : ["ap_ST_fsm_state4"], "OneDepthLoop" : "1", "OneStateBlock": "ap_ST_fsm_state7_blk"}},
			{"Name" : "VITIS_LOOP_214_2", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "7", "FirstState" : "ap_ST_fsm_state4", "LastState" : ["ap_ST_fsm_state7"], "QuitState" : ["ap_ST_fsm_state4"], "PreState" : ["ap_ST_fsm_state3"], "PostState" : ["ap_ST_fsm_state1"], "OneDepthLoop" : "0", "OneStateBlock": ""}}]},
	{"ID" : "52", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_build_lut_fu_610.grp_p_anonymous_namespace_build_lut_Pipeline_VITIS_LOOP_206_1_fu_156", "Parent" : "51", "Child" : ["53"],
		"CDFG" : "p_anonymous_namespace_build_lut_Pipeline_VITIS_LOOP_206_1",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "258", "EstimateLatencyMax" : "258",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "hist", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "first_out", "Type" : "Vld", "Direction" : "O"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_206_1", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter0", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "53", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_build_lut_fu_610.grp_p_anonymous_namespace_build_lut_Pipeline_VITIS_LOOP_206_1_fu_156.flow_control_loop_pipe_sequential_init_U", "Parent" : "52"},
	{"ID" : "54", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618", "Parent" : "0", "Child" : ["55", "56", "60", "64", "66", "77", "82", "106", "107", "110", "111", "114", "117", "121", "122", "123", "124", "125", "126", "127", "128", "129", "130", "131", "132", "133", "134", "135", "136", "137", "138", "139", "140", "141", "142", "143", "144", "145", "146", "147", "148", "149", "150"],
		"CDFG" : "p_anonymous_namespace_output_pass",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "Dataflow", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "1",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "4011007", "EstimateLatencyMax" : "6250276",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "1",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"InputProcess" : [
			{"ID" : "55", "Name" : "entry_proc_U0"},
			{"ID" : "56", "Name" : "p_anonymous_namespace_read_words_1_U0"},
			{"ID" : "64", "Name" : "p_anonymous_namespace_output_pass_Block_entry47_proc_U0"},
			{"ID" : "66", "Name" : "p_anonymous_namespace_color_stage_U0"},
			{"ID" : "77", "Name" : "p_anonymous_namespace_collect_or_drain_U0"},
			{"ID" : "82", "Name" : "p_anonymous_namespace_resize_and_split_U0"},
			{"ID" : "106", "Name" : "p_anonymous_namespace_output_pass_Block_entry412_proc_U0"},
			{"ID" : "110", "Name" : "p_anonymous_namespace_output_pass_Block_entry414_proc_U0"}],
		"OutputProcess" : [
			{"ID" : "77", "Name" : "p_anonymous_namespace_collect_or_drain_U0"},
			{"ID" : "114", "Name" : "p_anonymous_namespace_write_words_U0"},
			{"ID" : "117", "Name" : "p_anonymous_namespace_write_words_4_U0"}],
		"Port" : [
			{"Name" : "gmem_in", "Type" : "MAXI", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "56", "SubInstance" : "p_anonymous_namespace_read_words_1_U0", "Port" : "gmem_in"}]},
			{"Name" : "src", "Type" : "None", "Direction" : "I"},
			{"Name" : "gmem_out", "Type" : "MAXI", "Direction" : "O",
				"SubConnect" : [
					{"ID" : "114", "SubInstance" : "p_anonymous_namespace_write_words_U0", "Port" : "gmem_out"}]},
			{"Name" : "tensor", "Type" : "None", "Direction" : "I"},
			{"Name" : "gmem_preview", "Type" : "MAXI", "Direction" : "O",
				"SubConnect" : [
					{"ID" : "117", "SubInstance" : "p_anonymous_namespace_write_words_4_U0", "Port" : "gmem_preview"}]},
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
					{"ID" : "66", "SubInstance" : "p_anonymous_namespace_color_stage_U0", "Port" : "color_0"}]},
			{"Name" : "color_1", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "66", "SubInstance" : "p_anonymous_namespace_color_stage_U0", "Port" : "color_1"}]},
			{"Name" : "color_2", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "66", "SubInstance" : "p_anonymous_namespace_color_stage_U0", "Port" : "color_2"}]},
			{"Name" : "quant_0", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "82", "SubInstance" : "p_anonymous_namespace_resize_and_split_U0", "Port" : "quant_0"}]},
			{"Name" : "quant_1", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "82", "SubInstance" : "p_anonymous_namespace_resize_and_split_U0", "Port" : "quant_1"}]},
			{"Name" : "quant_2", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "82", "SubInstance" : "p_anonymous_namespace_resize_and_split_U0", "Port" : "quant_2"}]},
			{"Name" : "eq", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "66", "SubInstance" : "p_anonymous_namespace_color_stage_U0", "Port" : "eq"}]},
			{"Name" : "hist", "Type" : "Memory", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "77", "SubInstance" : "p_anonymous_namespace_collect_or_drain_U0", "Port" : "hist"}]},
			{"Name" : "xc_index", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "82", "SubInstance" : "p_anonymous_namespace_resize_and_split_U0", "Port" : "xc_index"}]},
			{"Name" : "xc_weight", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "82", "SubInstance" : "p_anonymous_namespace_resize_and_split_U0", "Port" : "xc_weight"}]},
			{"Name" : "yc_index", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "82", "SubInstance" : "p_anonymous_namespace_resize_and_split_U0", "Port" : "yc_index"}]},
			{"Name" : "yc_weight", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "82", "SubInstance" : "p_anonymous_namespace_resize_and_split_U0", "Port" : "yc_weight"}]}]},
	{"ID" : "55", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.entry_proc_U0", "Parent" : "54",
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
			{"Name" : "tensor_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["114"], "DependentChan" : "121", "DependentChanDepth" : "7", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "tensor_c_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "preview", "Type" : "None", "Direction" : "I"},
			{"Name" : "preview_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["117"], "DependentChan" : "122", "DependentChanDepth" : "7", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "preview_c_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "preview_stride", "Type" : "None", "Direction" : "I"},
			{"Name" : "preview_stride_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["117"], "DependentChan" : "123", "DependentChanDepth" : "7", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "preview_stride_c_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "collect", "Type" : "None", "Direction" : "I"},
			{"Name" : "collect_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["77"], "DependentChan" : "124", "DependentChanDepth" : "5", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "collect_c_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "56", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_read_words_1_U0", "Parent" : "54", "Child" : ["57", "59"],
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
					{"ID" : "57", "SubInstance" : "grp_p_anonymous_namespace_read_words_1_Pipeline_VITIS_LOOP_145_2_fu_146", "Port" : "gmem_in", "Inst_start_state" : "13", "Inst_end_state" : "14"}]},
			{"Name" : "src", "Type" : "None", "Direction" : "I"},
			{"Name" : "in_words1", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["60"], "DependentChan" : "125", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "57", "SubInstance" : "grp_p_anonymous_namespace_read_words_1_Pipeline_VITIS_LOOP_145_2_fu_146", "Port" : "in_words1", "Inst_start_state" : "13", "Inst_end_state" : "14"}]},
			{"Name" : "width", "Type" : "None", "Direction" : "I"},
			{"Name" : "height", "Type" : "None", "Direction" : "I"},
			{"Name" : "stride", "Type" : "None", "Direction" : "I"},
			{"Name" : "width_c31", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["60"], "DependentChan" : "126", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "width_c31_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "height_c33", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["60"], "DependentChan" : "127", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "height_c33_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_143_1", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "14", "FirstState" : "ap_ST_fsm_state2", "LastState" : ["ap_ST_fsm_state14"], "QuitState" : ["ap_ST_fsm_state2"], "PreState" : ["ap_ST_fsm_state1"], "PostState" : ["ap_ST_fsm_state1"], "OneDepthLoop" : "0", "OneStateBlock": ""}}]},
	{"ID" : "57", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_read_words_1_U0.grp_p_anonymous_namespace_read_words_1_Pipeline_VITIS_LOOP_145_2_fu_146", "Parent" : "56", "Child" : ["58"],
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
	{"ID" : "58", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_read_words_1_U0.grp_p_anonymous_namespace_read_words_1_Pipeline_VITIS_LOOP_145_2_fu_146.flow_control_loop_pipe_sequential_init_U", "Parent" : "57"},
	{"ID" : "59", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_read_words_1_U0.mul_mul_9ns_11ns_20_4_1_U120", "Parent" : "56"},
	{"ID" : "60", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_unpack_2_U0", "Parent" : "54", "Child" : ["61", "63"],
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
		"StartSource" : "56",
		"StartFifo" : "start_for_p_anonymous_namespace_unpack_2_U0_U",
		"Port" : [
			{"Name" : "in_words1", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["56"], "DependentChan" : "125", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "61", "SubInstance" : "grp_p_anonymous_namespace_unpack_2_Pipeline_VITIS_LOOP_156_1_VITIS_LOOP_160_2_fu_68", "Port" : "in_words1", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "in_pixels4", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["66"], "DependentChan" : "128", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "61", "SubInstance" : "grp_p_anonymous_namespace_unpack_2_Pipeline_VITIS_LOOP_156_1_VITIS_LOOP_160_2_fu_68", "Port" : "in_pixels4", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "width", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["56"], "DependentChan" : "126", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "width_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "height", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["56"], "DependentChan" : "127", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "height_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "width_c30", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["111"], "DependentChan" : "129", "DependentChanDepth" : "4", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "width_c30_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "height_c32", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["111"], "DependentChan" : "130", "DependentChanDepth" : "4", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "height_c32_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "61", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_unpack_2_U0.grp_p_anonymous_namespace_unpack_2_Pipeline_VITIS_LOOP_156_1_VITIS_LOOP_160_2_fu_68", "Parent" : "60", "Child" : ["62"],
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
	{"ID" : "62", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_unpack_2_U0.grp_p_anonymous_namespace_unpack_2_Pipeline_VITIS_LOOP_156_1_VITIS_LOOP_160_2_fu_68.flow_control_loop_pipe_sequential_init_U", "Parent" : "61"},
	{"ID" : "63", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_unpack_2_U0.mul_32ns_32ns_64_1_1_U133", "Parent" : "60"},
	{"ID" : "64", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_output_pass_Block_entry47_proc_U0", "Parent" : "54", "Child" : ["65"],
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
			{"Name" : "width", "Type" : "None", "Direction" : "I"},
			{"Name" : "height", "Type" : "None", "Direction" : "I"},
			{"Name" : "flags", "Type" : "None", "Direction" : "I"}]},
	{"ID" : "65", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_output_pass_Block_entry47_proc_U0.mul_11ns_11ns_22_1_1_U140", "Parent" : "64"},
	{"ID" : "66", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_color_stage_U0", "Parent" : "54", "Child" : ["67"],
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
			{"Name" : "in_pixels", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["60"], "DependentChan" : "128", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "67", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_293_1_fu_104", "Port" : "in_pixels", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "pairs", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["82"], "DependentChan" : "135", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "67", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_293_1_fu_104", "Port" : "pairs", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "hist_pixels", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["77"], "DependentChan" : "136", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "67", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_293_1_fu_104", "Port" : "hist_pixels", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "color_0", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "67", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_293_1_fu_104", "Port" : "color_0", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "color_1", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "67", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_293_1_fu_104", "Port" : "color_1", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "color_2", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "67", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_293_1_fu_104", "Port" : "color_2", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "eq", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "67", "SubInstance" : "grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_293_1_fu_104", "Port" : "eq", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "p_read", "Type" : "None", "Direction" : "I", "DependentProc" : ["64"], "DependentChan" : "133", "DependentChanDepth" : "3", "DependentChanType" : "1"},
			{"Name" : "saturation", "Type" : "None", "Direction" : "I"},
			{"Name" : "eq_enabled", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read1", "Type" : "None", "Direction" : "I", "DependentProc" : ["64"], "DependentChan" : "134", "DependentChanDepth" : "3", "DependentChanType" : "1"},
			{"Name" : "mul_ln1540_loc_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["77"], "DependentChan" : "137", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "mul_ln1540_loc_c_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "67", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_color_stage_U0.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_293_1_fu_104", "Parent" : "66", "Child" : ["68", "69", "70", "71", "72", "73", "74", "75", "76"],
		"CDFG" : "p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_293_1",
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
			{"Name" : "VITIS_LOOP_293_1", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter17", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter17", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "68", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_color_stage_U0.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_293_1_fu_104.mac_muladd_8ns_8ns_15s_17_4_1_U144", "Parent" : "67"},
	{"ID" : "69", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_color_stage_U0.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_293_1_fu_104.mac_muladd_8ns_7ns_17s_18_4_1_U145", "Parent" : "67"},
	{"ID" : "70", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_color_stage_U0.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_293_1_fu_104.mac_muladd_14ns_10s_22s_25_4_1_U146", "Parent" : "67"},
	{"ID" : "71", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_color_stage_U0.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_293_1_fu_104.mac_muladd_14ns_10s_22s_25_4_1_U147", "Parent" : "67"},
	{"ID" : "72", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_color_stage_U0.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_293_1_fu_104.mac_muladd_14ns_10s_22s_25_4_1_U148", "Parent" : "67"},
	{"ID" : "73", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_color_stage_U0.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_293_1_fu_104.mac_muladd_9s_9ns_14s_17_4_1_U149", "Parent" : "67"},
	{"ID" : "74", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_color_stage_U0.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_293_1_fu_104.mac_muladd_9s_8ns_14s_16_4_1_U150", "Parent" : "67"},
	{"ID" : "75", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_color_stage_U0.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_293_1_fu_104.mac_muladd_9s_9ns_15s_17_4_1_U151", "Parent" : "67"},
	{"ID" : "76", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_color_stage_U0.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_293_1_fu_104.flow_control_loop_pipe_sequential_init_U", "Parent" : "67"},
	{"ID" : "77", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_collect_or_drain_U0", "Parent" : "54", "Child" : ["78", "80"],
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
			{"Name" : "hist_pixels", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "136", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "78", "SubInstance" : "grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_316_2_fu_58", "Port" : "hist_pixels", "Inst_start_state" : "2", "Inst_end_state" : "3"},
					{"ID" : "80", "SubInstance" : "grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_309_1_fu_65", "Port" : "hist_pixels", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "hist", "Type" : "Memory", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "80", "SubInstance" : "grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_309_1_fu_65", "Port" : "hist", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "collect", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["55"], "DependentChan" : "124", "DependentChanDepth" : "5", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "collect_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "mul_ln1540_loc", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "137", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "mul_ln1540_loc_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "78", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_collect_or_drain_U0.grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_316_2_fu_58", "Parent" : "77", "Child" : ["79"],
		"CDFG" : "p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_316_2",
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
			{"Name" : "VITIS_LOOP_316_2", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter0", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "79", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_collect_or_drain_U0.grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_316_2_fu_58.flow_control_loop_pipe_sequential_init_U", "Parent" : "78"},
	{"ID" : "80", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_collect_or_drain_U0.grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_309_1_fu_65", "Parent" : "77", "Child" : ["81"],
		"CDFG" : "p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_309_1",
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
			{"Name" : "VITIS_LOOP_309_1", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "2", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter0", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "81", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_collect_or_drain_U0.grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_309_1_fu_65.flow_control_loop_pipe_sequential_init_U", "Parent" : "80"},
	{"ID" : "82", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0", "Parent" : "54", "Child" : ["83", "84", "85", "87", "102", "104", "105"],
		"CDFG" : "p_anonymous_namespace_resize_and_split",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "8", "EstimateLatencyMax" : "6250248",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "pairs", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "135", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "85", "SubInstance" : "grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_369_2_VITIS_LOOP_371_3_fu_236", "Port" : "pairs", "Inst_start_state" : "7", "Inst_end_state" : "8"},
					{"ID" : "102", "SubInstance" : "grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_403_6_VITIS_LOOP_405_7_fu_277", "Port" : "pairs", "Inst_start_state" : "15", "Inst_end_state" : "16"}]},
			{"Name" : "tensor_pixels", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["107"], "DependentChan" : "138", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "87", "SubInstance" : "grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_381_4_fu_251", "Port" : "tensor_pixels", "Inst_start_state" : "10", "Inst_end_state" : "11"}]},
			{"Name" : "preview_pixels", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["111"], "DependentChan" : "139", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "85", "SubInstance" : "grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_369_2_VITIS_LOOP_371_3_fu_236", "Port" : "preview_pixels", "Inst_start_state" : "7", "Inst_end_state" : "8"},
					{"ID" : "102", "SubInstance" : "grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_403_6_VITIS_LOOP_405_7_fu_277", "Port" : "preview_pixels", "Inst_start_state" : "15", "Inst_end_state" : "16"}]},
			{"Name" : "p_read", "Type" : "None", "Direction" : "I", "DependentProc" : ["64"], "DependentChan" : "131", "DependentChanDepth" : "4", "DependentChanType" : "1"},
			{"Name" : "p_read1", "Type" : "None", "Direction" : "I", "DependentProc" : ["64"], "DependentChan" : "132", "DependentChanDepth" : "4", "DependentChanType" : "1"},
			{"Name" : "rw", "Type" : "None", "Direction" : "I"},
			{"Name" : "rh", "Type" : "None", "Direction" : "I"},
			{"Name" : "px", "Type" : "None", "Direction" : "I"},
			{"Name" : "py", "Type" : "None", "Direction" : "I"},
			{"Name" : "mode", "Type" : "None", "Direction" : "I"},
			{"Name" : "flags", "Type" : "None", "Direction" : "I"},
			{"Name" : "xc_index", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "87", "SubInstance" : "grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_381_4_fu_251", "Port" : "xc_index", "Inst_start_state" : "10", "Inst_end_state" : "11"}]},
			{"Name" : "xc_weight", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "87", "SubInstance" : "grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_381_4_fu_251", "Port" : "xc_weight", "Inst_start_state" : "10", "Inst_end_state" : "11"}]},
			{"Name" : "yc_index", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "yc_weight", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "quant_0", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "87", "SubInstance" : "grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_381_4_fu_251", "Port" : "quant_0", "Inst_start_state" : "10", "Inst_end_state" : "11"}]},
			{"Name" : "quant_1", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "87", "SubInstance" : "grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_381_4_fu_251", "Port" : "quant_1", "Inst_start_state" : "10", "Inst_end_state" : "11"}]},
			{"Name" : "quant_2", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "87", "SubInstance" : "grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_381_4_fu_251", "Port" : "quant_2", "Inst_start_state" : "10", "Inst_end_state" : "11"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_360_1", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "16", "FirstState" : "ap_ST_fsm_state2", "LastState" : ["ap_ST_fsm_state11"], "QuitState" : ["ap_ST_fsm_state2"], "PreState" : ["ap_ST_fsm_state1"], "PostState" : ["ap_ST_fsm_state12"], "OneDepthLoop" : "0", "OneStateBlock": ""}}]},
	{"ID" : "83", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0.rows_V_U", "Parent" : "82"},
	{"ID" : "84", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0.rows_V_1_U", "Parent" : "82"},
	{"ID" : "85", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_369_2_VITIS_LOOP_371_3_fu_236", "Parent" : "82", "Child" : ["86"],
		"CDFG" : "p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_369_2_VITIS_LOOP_371_3",
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
			{"Name" : "consumed_V", "Type" : "None", "Direction" : "I"},
			{"Name" : "mul_ln1085", "Type" : "None", "Direction" : "I"},
			{"Name" : "cmp32_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read", "Type" : "None", "Direction" : "I"},
			{"Name" : "pairs", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "pairs_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "rows_V", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "rows_V_1", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "tobool_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "preview_pixels", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "preview_pixels_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_369_2_VITIS_LOOP_371_3", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter0", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "86", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_369_2_VITIS_LOOP_371_3_fu_236.flow_control_loop_pipe_sequential_init_U", "Parent" : "85"},
	{"ID" : "87", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_381_4_fu_251", "Parent" : "82", "Child" : ["88", "89", "90", "91", "92", "93", "94", "95", "96", "97", "98", "99", "100", "101"],
		"CDFG" : "p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_381_4",
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
			{"Name" : "px", "Type" : "None", "Direction" : "I"},
			{"Name" : "add_i244_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "content_y", "Type" : "None", "Direction" : "I"},
			{"Name" : "xc_index", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "xc_weight", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "width_cast_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "rows_V", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "rows_V_1", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "trunc_ln5", "Type" : "None", "Direction" : "I"},
			{"Name" : "sy1_V_1", "Type" : "None", "Direction" : "I"},
			{"Name" : "zext_ln1540", "Type" : "None", "Direction" : "I"},
			{"Name" : "quant_0", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "quant_1", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "quant_2", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "tensor_pixels", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "tensor_pixels_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_381_4", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter11", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter11", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "88", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_381_4_fu_251.mux_21_24_1_1_U197", "Parent" : "87"},
	{"ID" : "89", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_381_4_fu_251.mux_21_24_1_1_U198", "Parent" : "87"},
	{"ID" : "90", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_381_4_fu_251.mux_21_24_1_1_U199", "Parent" : "87"},
	{"ID" : "91", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_381_4_fu_251.mux_21_24_1_1_U200", "Parent" : "87"},
	{"ID" : "92", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_381_4_fu_251.mac_muladd_12ns_9s_19ns_20_4_1_U201", "Parent" : "87"},
	{"ID" : "93", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_381_4_fu_251.mac_muladd_12ns_9s_19ns_20_4_1_U202", "Parent" : "87"},
	{"ID" : "94", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_381_4_fu_251.mac_muladd_12ns_9s_19ns_20_4_1_U203", "Parent" : "87"},
	{"ID" : "95", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_381_4_fu_251.mac_muladd_12ns_9s_20ns_20_4_1_U204", "Parent" : "87"},
	{"ID" : "96", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_381_4_fu_251.mac_muladd_12ns_9s_20ns_20_4_1_U205", "Parent" : "87"},
	{"ID" : "97", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_381_4_fu_251.mac_muladd_12ns_9s_20ns_20_4_1_U206", "Parent" : "87"},
	{"ID" : "98", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_381_4_fu_251.mac_muladd_20s_12ns_22ns_30_4_1_U207", "Parent" : "87"},
	{"ID" : "99", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_381_4_fu_251.mac_muladd_20s_12ns_22ns_30_4_1_U208", "Parent" : "87"},
	{"ID" : "100", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_381_4_fu_251.mac_muladd_20s_12ns_22ns_30_4_1_U209", "Parent" : "87"},
	{"ID" : "101", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_381_4_fu_251.flow_control_loop_pipe_sequential_init_U", "Parent" : "87"},
	{"ID" : "102", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_403_6_VITIS_LOOP_405_7_fu_277", "Parent" : "82", "Child" : ["103"],
		"CDFG" : "p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_403_6_VITIS_LOOP_405_7",
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
			{"Name" : "mul_ln358", "Type" : "None", "Direction" : "I"},
			{"Name" : "pairs", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "pairs_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "cmp139_i", "Type" : "None", "Direction" : "I"},
			{"Name" : "preview_pixels", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "preview_pixels_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_403_6_VITIS_LOOP_405_7", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter0", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "103", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_403_6_VITIS_LOOP_405_7_fu_277.flow_control_loop_pipe_sequential_init_U", "Parent" : "102"},
	{"ID" : "104", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0.mul_mul_11ns_11ns_22_4_1_U233", "Parent" : "82"},
	{"ID" : "105", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0.mul_mul_11ns_11ns_22_4_1_U234", "Parent" : "82"},
	{"ID" : "106", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_output_pass_Block_entry412_proc_U0", "Parent" : "54",
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
	{"ID" : "107", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_pack_U0", "Parent" : "54", "Child" : ["108"],
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
			{"Name" : "tensor_pixels", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["82"], "DependentChan" : "138", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "108", "SubInstance" : "grp_p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_423_2_fu_89", "Port" : "tensor_pixels", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "tensor_words", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["114"], "DependentChan" : "141", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "tensor_words_blk_n", "Type" : "RtlSignal"}],
				"SubConnect" : [
					{"ID" : "108", "SubInstance" : "grp_p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_423_2_fu_89", "Port" : "tensor_words", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "p_read", "Type" : "None", "Direction" : "I", "DependentProc" : ["106"], "DependentChan" : "140", "DependentChanDepth" : "5", "DependentChanType" : "1"},
			{"Name" : "icmp_ln482_loc_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["114"], "DependentChan" : "142", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "icmp_ln482_loc_c_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_419_1", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "4", "FirstState" : "ap_ST_fsm_state2", "LastState" : ["ap_ST_fsm_state4"], "QuitState" : ["ap_ST_fsm_state2"], "PreState" : ["ap_ST_fsm_state1"], "PostState" : ["ap_ST_fsm_state1"], "OneDepthLoop" : "0", "OneStateBlock": ""}}]},
	{"ID" : "108", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_pack_U0.grp_p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_423_2_fu_89", "Parent" : "107", "Child" : ["109"],
		"CDFG" : "p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_423_2",
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
			{"Name" : "VITIS_LOOP_423_2", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter2", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "109", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_pack_U0.grp_p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_423_2_fu_89.flow_control_loop_pipe_sequential_init_U", "Parent" : "108"},
	{"ID" : "110", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_output_pass_Block_entry414_proc_U0", "Parent" : "54",
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
	{"ID" : "111", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_pack_3_U0", "Parent" : "54", "Child" : ["112"],
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
			{"Name" : "preview_pixels", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["82"], "DependentChan" : "139", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "112", "SubInstance" : "grp_p_anonymous_namespace_pack_3_Pipeline_VITIS_LOOP_423_2_fu_127", "Port" : "preview_pixels", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "preview_words", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["117"], "DependentChan" : "144", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "preview_words_blk_n", "Type" : "RtlSignal"}],
				"SubConnect" : [
					{"ID" : "112", "SubInstance" : "grp_p_anonymous_namespace_pack_3_Pipeline_VITIS_LOOP_423_2_fu_127", "Port" : "preview_words", "Inst_start_state" : "2", "Inst_end_state" : "3"}]},
			{"Name" : "width", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["60"], "DependentChan" : "129", "DependentChanDepth" : "4", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "width_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "height", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["60"], "DependentChan" : "130", "DependentChanDepth" : "4", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "height_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "p_read", "Type" : "None", "Direction" : "I", "DependentProc" : ["110"], "DependentChan" : "143", "DependentChanDepth" : "5", "DependentChanType" : "1"},
			{"Name" : "width_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["117"], "DependentChan" : "145", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "width_c_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "height_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["117"], "DependentChan" : "146", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "height_c_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "icmp_ln483_loc_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["117"], "DependentChan" : "147", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "icmp_ln483_loc_c_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_419_1", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "4", "FirstState" : "ap_ST_fsm_state2", "LastState" : ["ap_ST_fsm_state4"], "QuitState" : ["ap_ST_fsm_state2"], "PreState" : ["ap_ST_fsm_state1"], "PostState" : ["ap_ST_fsm_state1"], "OneDepthLoop" : "0", "OneStateBlock": ""}}]},
	{"ID" : "112", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_pack_3_U0.grp_p_anonymous_namespace_pack_3_Pipeline_VITIS_LOOP_423_2_fu_127", "Parent" : "111", "Child" : ["113"],
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
	{"ID" : "113", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_pack_3_U0.grp_p_anonymous_namespace_pack_3_Pipeline_VITIS_LOOP_423_2_fu_127.flow_control_loop_pipe_sequential_init_U", "Parent" : "112"},
	{"ID" : "114", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_write_words_U0", "Parent" : "54", "Child" : ["115"],
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
		"StartSource" : "55",
		"StartFifo" : "start_for_p_anonymous_namespace_write_words_U0_U",
		"Port" : [
			{"Name" : "gmem_out", "Type" : "MAXI", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "gmem_out_blk_n_AW", "Type" : "RtlSignal"},
					{"Name" : "gmem_out_blk_n_B", "Type" : "RtlSignal"}],
				"SubConnect" : [
					{"ID" : "115", "SubInstance" : "grp_p_anonymous_namespace_write_words_Pipeline_VITIS_LOOP_444_1_VITIS_LOOP_446_2_fu_76", "Port" : "gmem_out", "Inst_start_state" : "3", "Inst_end_state" : "4"}]},
			{"Name" : "tensor", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["55"], "DependentChan" : "121", "DependentChanDepth" : "7", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "tensor_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "tensor_words", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["107"], "DependentChan" : "141", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "115", "SubInstance" : "grp_p_anonymous_namespace_write_words_Pipeline_VITIS_LOOP_444_1_VITIS_LOOP_446_2_fu_76", "Port" : "tensor_words", "Inst_start_state" : "3", "Inst_end_state" : "4"}]},
			{"Name" : "icmp_ln482_loc", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["107"], "DependentChan" : "142", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "icmp_ln482_loc_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "115", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_write_words_U0.grp_p_anonymous_namespace_write_words_Pipeline_VITIS_LOOP_444_1_VITIS_LOOP_446_2_fu_76", "Parent" : "114", "Child" : ["116"],
		"CDFG" : "p_anonymous_namespace_write_words_Pipeline_VITIS_LOOP_444_1_VITIS_LOOP_446_2",
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
			{"Name" : "sext_ln444", "Type" : "None", "Direction" : "I"},
			{"Name" : "tensor_words", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "tensor_words_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_444_1_VITIS_LOOP_446_2", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter2", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "116", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_write_words_U0.grp_p_anonymous_namespace_write_words_Pipeline_VITIS_LOOP_444_1_VITIS_LOOP_446_2_fu_76.flow_control_loop_pipe_sequential_init_U", "Parent" : "115"},
	{"ID" : "117", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_write_words_4_U0", "Parent" : "54", "Child" : ["118", "120"],
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
		"StartSource" : "55",
		"StartFifo" : "start_for_p_anonymous_namespace_write_words_4_U0_U",
		"Port" : [
			{"Name" : "gmem_preview", "Type" : "MAXI", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "gmem_preview_blk_n_AW", "Type" : "RtlSignal"},
					{"Name" : "gmem_preview_blk_n_B", "Type" : "RtlSignal"}],
				"SubConnect" : [
					{"ID" : "118", "SubInstance" : "grp_p_anonymous_namespace_write_words_4_Pipeline_VITIS_LOOP_446_2_fu_137", "Port" : "gmem_preview", "Inst_start_state" : "7", "Inst_end_state" : "8"}]},
			{"Name" : "preview", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["55"], "DependentChan" : "122", "DependentChanDepth" : "7", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "preview_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "preview_words", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["111"], "DependentChan" : "144", "DependentChanDepth" : "64", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "118", "SubInstance" : "grp_p_anonymous_namespace_write_words_4_Pipeline_VITIS_LOOP_446_2_fu_137", "Port" : "preview_words", "Inst_start_state" : "7", "Inst_end_state" : "8"}]},
			{"Name" : "width", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["111"], "DependentChan" : "145", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "width_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "height", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["111"], "DependentChan" : "146", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "height_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "preview_stride", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["55"], "DependentChan" : "123", "DependentChanDepth" : "7", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "preview_stride_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "icmp_ln483_loc", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["111"], "DependentChan" : "147", "DependentChanDepth" : "2", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "icmp_ln483_loc_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_444_1", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "13", "FirstState" : "ap_ST_fsm_state2", "LastState" : ["ap_ST_fsm_state13"], "QuitState" : ["ap_ST_fsm_state2"], "PreState" : ["ap_ST_fsm_state1"], "PostState" : ["ap_ST_fsm_state1"], "OneDepthLoop" : "0", "OneStateBlock": ""}}]},
	{"ID" : "118", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_write_words_4_U0.grp_p_anonymous_namespace_write_words_4_Pipeline_VITIS_LOOP_446_2_fu_137", "Parent" : "117", "Child" : ["119"],
		"CDFG" : "p_anonymous_namespace_write_words_4_Pipeline_VITIS_LOOP_446_2",
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
			{"Name" : "sext_ln446", "Type" : "None", "Direction" : "I"},
			{"Name" : "count", "Type" : "None", "Direction" : "I"},
			{"Name" : "preview_words", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "preview_words_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_446_2", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter2", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "119", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_write_words_4_U0.grp_p_anonymous_namespace_write_words_4_Pipeline_VITIS_LOOP_446_2_fu_137.flow_control_loop_pipe_sequential_init_U", "Parent" : "118"},
	{"ID" : "120", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_write_words_4_U0.mul_mul_9ns_11ns_20_4_1_U289", "Parent" : "117"},
	{"ID" : "121", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.tensor_c_U", "Parent" : "54"},
	{"ID" : "122", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.preview_c_U", "Parent" : "54"},
	{"ID" : "123", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.preview_stride_c_U", "Parent" : "54"},
	{"ID" : "124", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.collect_c_U", "Parent" : "54"},
	{"ID" : "125", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.in_words_U", "Parent" : "54"},
	{"ID" : "126", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.width_c31_U", "Parent" : "54"},
	{"ID" : "127", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.height_c33_U", "Parent" : "54"},
	{"ID" : "128", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.in_pixels_U", "Parent" : "54"},
	{"ID" : "129", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.width_c30_U", "Parent" : "54"},
	{"ID" : "130", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.height_c32_U", "Parent" : "54"},
	{"ID" : "131", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.w_V_loc_channel_U", "Parent" : "54"},
	{"ID" : "132", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.h_V_loc_channel_U", "Parent" : "54"},
	{"ID" : "133", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.flags_cast_loc_channel_U", "Parent" : "54"},
	{"ID" : "134", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.mul_ln1540_loc_c36_channel_U", "Parent" : "54"},
	{"ID" : "135", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.pairs_U", "Parent" : "54"},
	{"ID" : "136", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.hist_pixels_U", "Parent" : "54"},
	{"ID" : "137", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.mul_ln1540_loc_c_U", "Parent" : "54"},
	{"ID" : "138", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.tensor_pixels_U", "Parent" : "54"},
	{"ID" : "139", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.preview_pixels_U", "Parent" : "54"},
	{"ID" : "140", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.icmp_ln482_loc_c35_channel_U", "Parent" : "54"},
	{"ID" : "141", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.tensor_words_U", "Parent" : "54"},
	{"ID" : "142", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.icmp_ln482_loc_c_U", "Parent" : "54"},
	{"ID" : "143", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.icmp_ln483_loc_c34_channel_U", "Parent" : "54"},
	{"ID" : "144", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.preview_words_U", "Parent" : "54"},
	{"ID" : "145", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.width_c_U", "Parent" : "54"},
	{"ID" : "146", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.height_c_U", "Parent" : "54"},
	{"ID" : "147", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.icmp_ln483_loc_c_U", "Parent" : "54"},
	{"ID" : "148", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.start_for_p_anonymous_namespace_write_words_U0_U", "Parent" : "54"},
	{"ID" : "149", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.start_for_p_anonymous_namespace_write_words_4_U0_U", "Parent" : "54"},
	{"ID" : "150", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_p_anonymous_namespace_output_pass_fu_618.start_for_p_anonymous_namespace_unpack_2_U0_U", "Parent" : "54"},
	{"ID" : "151", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.control_s_axi_U", "Parent" : "0"},
	{"ID" : "152", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.gmem_in_m_axi_U", "Parent" : "0"},
	{"ID" : "153", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.gmem_out_m_axi_U", "Parent" : "0"},
	{"ID" : "154", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.gmem_preview_m_axi_U", "Parent" : "0"},
	{"ID" : "155", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_11ns_11ns_22_1_1_U358", "Parent" : "0"},
	{"ID" : "156", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_11ns_11ns_22_1_1_U359", "Parent" : "0"},
	{"ID" : "157", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_11ns_11ns_22_1_1_U360", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	image_preprocess {
		gmem_in {Type I LastRead 13 FirstWrite -1}
		gmem_out {Type O LastRead 4 FirstWrite 2}
		gmem_preview {Type O LastRead 8 FirstWrite 2}
		src {Type I LastRead 0 FirstWrite -1}
		tensor {Type I LastRead 0 FirstWrite -1}
		preview {Type I LastRead 0 FirstWrite -1}
		luts {Type I LastRead 0 FirstWrite -1}
		width {Type I LastRead 0 FirstWrite -1}
		height {Type I LastRead 0 FirstWrite -1}
		src_stride {Type I LastRead 0 FirstWrite -1}
		src_capacity {Type I LastRead 0 FirstWrite -1}
		tensor_capacity {Type I LastRead 0 FirstWrite -1}
		preview_stride {Type I LastRead 0 FirstWrite -1}
		preview_capacity {Type I LastRead 0 FirstWrite -1}
		resized_w {Type I LastRead 0 FirstWrite -1}
		resized_h {Type I LastRead 0 FirstWrite -1}
		pad_x {Type I LastRead 0 FirstWrite -1}
		pad_y {Type I LastRead 0 FirstWrite -1}
		output_mode {Type I LastRead 0 FirstWrite -1}
		flags {Type I LastRead 0 FirstWrite -1}
		eq_mode {Type I LastRead 0 FirstWrite -1}
		saturation_q12 {Type I LastRead 0 FirstWrite -1}
		frame_id {Type I LastRead 0 FirstWrite -1}
		config_id {Type I LastRead 0 FirstWrite -1}
		completed_frame_id {Type O LastRead -1 FirstWrite 0}
		completed_config_id {Type O LastRead -1 FirstWrite 0}
		tensor_bytes {Type O LastRead -1 FirstWrite 0}
		preview_bytes {Type O LastRead -1 FirstWrite 0}
		abi_version {Type O LastRead -1 FirstWrite 0}
		history_valid {Type IO LastRead -1 FirstWrite -1}
		previous_width {Type IO LastRead -1 FirstWrite -1}
		previous_height {Type IO LastRead -1 FirstWrite -1}
		previous_config {Type IO LastRead -1 FirstWrite -1}
		previous_flags {Type IO LastRead -1 FirstWrite -1}
		previous_saturation {Type IO LastRead -1 FirstWrite -1}
		previous_V {Type IO LastRead -1 FirstWrite -1}}
	p_anonymous_namespace_validate_settings {
		width {Type I LastRead 0 FirstWrite -1}
		height {Type I LastRead 0 FirstWrite -1}
		src_stride {Type I LastRead 0 FirstWrite -1}
		src_capacity {Type I LastRead 0 FirstWrite -1}
		tensor_capacity {Type I LastRead 0 FirstWrite -1}
		preview_stride {Type I LastRead 0 FirstWrite -1}
		preview_capacity {Type I LastRead 0 FirstWrite -1}
		resized_w {Type I LastRead 0 FirstWrite -1}
		resized_h {Type I LastRead 0 FirstWrite -1}
		pad_x {Type I LastRead 0 FirstWrite -1}
		pad_y {Type I LastRead 0 FirstWrite -1}
		output_mode {Type I LastRead 0 FirstWrite -1}
		flags {Type I LastRead 0 FirstWrite -1}
		eq_mode {Type I LastRead 0 FirstWrite -1}
		saturation_q12 {Type I LastRead 0 FirstWrite -1}}
	image_preprocess_Pipeline_VITIS_LOOP_567_4 {
		hist_V {Type O LastRead -1 FirstWrite 0}
		use_history {Type I LastRead 0 FirstWrite -1}
		eq_V {Type O LastRead -1 FirstWrite 1}
		previous_V {Type I LastRead 0 FirstWrite -1}}
	p_anonymous_namespace_make_coordinates {
		coordinates_index {Type O LastRead -1 FirstWrite 2}
		coordinates_weight {Type O LastRead -1 FirstWrite 3}
		src {Type I LastRead 0 FirstWrite -1}
		dst {Type I LastRead 0 FirstWrite -1}}
	p_anonymous_namespace_coordinate_divide {
		numerator {Type I LastRead 0 FirstWrite -1}
		denominator {Type I LastRead 0 FirstWrite -1}}
	p_anonymous_namespace_make_coordinates {
		coordinates_index {Type O LastRead -1 FirstWrite 2}
		coordinates_weight {Type O LastRead -1 FirstWrite 3}
		src {Type I LastRead 0 FirstWrite -1}
		dst {Type I LastRead 0 FirstWrite -1}}
	p_anonymous_namespace_coordinate_divide {
		numerator {Type I LastRead 0 FirstWrite -1}
		denominator {Type I LastRead 0 FirstWrite -1}}
	image_preprocess_Pipeline_VITIS_LOOP_557_2 {
		quant_V {Type O LastRead -1 FirstWrite 0}
		quant_V_1 {Type O LastRead -1 FirstWrite 0}
		quant_V_2 {Type O LastRead -1 FirstWrite 0}
		color_V_2 {Type O LastRead -1 FirstWrite 0}
		color_V_1 {Type O LastRead -1 FirstWrite 0}
		color_V {Type O LastRead -1 FirstWrite 0}
		and_r {Type I LastRead 0 FirstWrite -1}
		v_V {Type I LastRead 0 FirstWrite -1}
		cmp64 {Type I LastRead 0 FirstWrite -1}}
	p_anonymous_namespace_statistics_pass {
		gmem_in {Type I LastRead 5 FirstWrite -1}
		src {Type I LastRead 0 FirstWrite -1}
		width {Type I LastRead 0 FirstWrite -1}
		height {Type I LastRead 0 FirstWrite -1}
		stride {Type I LastRead 0 FirstWrite -1}
		color_0 {Type I LastRead 3 FirstWrite -1}
		color_1 {Type I LastRead 1 FirstWrite -1}
		color_2 {Type I LastRead 1 FirstWrite -1}
		flags {Type I LastRead 4 FirstWrite -1}
		saturation {Type I LastRead 4 FirstWrite -1}
		hist {Type IO LastRead 16 FirstWrite 17}}
	p_anonymous_namespace_read_words {
		gmem_in {Type I LastRead 5 FirstWrite -1}
		src {Type I LastRead 0 FirstWrite -1}
		words1 {Type O LastRead -1 FirstWrite 2}
		width {Type I LastRead 0 FirstWrite -1}
		height {Type I LastRead 0 FirstWrite -1}
		stride {Type I LastRead 0 FirstWrite -1}
		width_c {Type O LastRead -1 FirstWrite 0}
		height_c {Type O LastRead -1 FirstWrite 0}}
	p_anonymous_namespace_read_words_Pipeline_VITIS_LOOP_145_2 {
		gmem_in {Type I LastRead 1 FirstWrite -1}
		sext_ln145 {Type I LastRead 0 FirstWrite -1}
		count {Type I LastRead 0 FirstWrite -1}
		words1 {Type O LastRead -1 FirstWrite 2}}
	p_anonymous_namespace_unpack {
		words1 {Type I LastRead 3 FirstWrite -1}
		pixels2 {Type O LastRead -1 FirstWrite 4}
		width {Type I LastRead 0 FirstWrite -1}
		height {Type I LastRead 0 FirstWrite -1}}
	p_anonymous_namespace_unpack_Pipeline_VITIS_LOOP_156_1_VITIS_LOOP_160_2 {
		bound {Type I LastRead 0 FirstWrite -1}
		pixels2 {Type O LastRead -1 FirstWrite 4}
		width_load {Type I LastRead 0 FirstWrite -1}
		words1 {Type I LastRead 3 FirstWrite -1}}
	p_anonymous_namespace_statistics_pass_Block_entry36_proc {
		height {Type I LastRead 0 FirstWrite -1}
		width {Type I LastRead 0 FirstWrite -1}}
	p_anonymous_namespace_histogram_pixels {
		pixels {Type I LastRead 1 FirstWrite -1}
		hist {Type IO LastRead 16 FirstWrite 17}
		color_0 {Type I LastRead 3 FirstWrite -1}
		color_1 {Type I LastRead 1 FirstWrite -1}
		color_2 {Type I LastRead 1 FirstWrite -1}
		flags {Type I LastRead 0 FirstWrite -1}
		saturation {Type I LastRead 0 FirstWrite -1}
		p_read {Type I LastRead 0 FirstWrite -1}}
	p_anonymous_namespace_build_lut {
		hist {Type I LastRead 3 FirstWrite -1}
		lut {Type O LastRead -1 FirstWrite 6}
		n {Type I LastRead 2 FirstWrite -1}}
	p_anonymous_namespace_build_lut_Pipeline_VITIS_LOOP_206_1 {
		hist {Type I LastRead 0 FirstWrite -1}
		first_out {Type O LastRead -1 FirstWrite 0}}
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
		height {Type I LastRead 0 FirstWrite -1}
		width_c30 {Type O LastRead -1 FirstWrite 0}
		height_c32 {Type O LastRead -1 FirstWrite 0}}
	p_anonymous_namespace_unpack_2_Pipeline_VITIS_LOOP_156_1_VITIS_LOOP_160_2 {
		bound {Type I LastRead 0 FirstWrite -1}
		in_pixels4 {Type O LastRead -1 FirstWrite 4}
		width_load {Type I LastRead 0 FirstWrite -1}
		in_words1 {Type I LastRead 3 FirstWrite -1}}
	p_anonymous_namespace_output_pass_Block_entry47_proc {
		width {Type I LastRead 0 FirstWrite -1}
		height {Type I LastRead 0 FirstWrite -1}
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
	p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_293_1 {
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
	p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_316_2 {
		mul_ln1540_loc_load {Type I LastRead 0 FirstWrite -1}
		hist_pixels {Type I LastRead 1 FirstWrite -1}}
	p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_309_1 {
		mul_ln1540_loc_load {Type I LastRead 0 FirstWrite -1}
		hist_pixels {Type I LastRead 1 FirstWrite -1}
		hist {Type IO LastRead 1 FirstWrite 2}}
	p_anonymous_namespace_resize_and_split {
		pairs {Type I LastRead 1 FirstWrite -1}
		tensor_pixels {Type O LastRead -1 FirstWrite 11}
		preview_pixels {Type O LastRead -1 FirstWrite 1}
		p_read {Type I LastRead 0 FirstWrite -1}
		p_read1 {Type I LastRead 0 FirstWrite -1}
		rw {Type I LastRead 0 FirstWrite -1}
		rh {Type I LastRead 0 FirstWrite -1}
		px {Type I LastRead 0 FirstWrite -1}
		py {Type I LastRead 0 FirstWrite -1}
		mode {Type I LastRead 0 FirstWrite -1}
		flags {Type I LastRead 0 FirstWrite -1}
		xc_index {Type I LastRead 0 FirstWrite -1}
		xc_weight {Type I LastRead 2 FirstWrite -1}
		yc_index {Type I LastRead 1 FirstWrite -1}
		yc_weight {Type I LastRead 1 FirstWrite -1}
		quant_0 {Type I LastRead 10 FirstWrite -1}
		quant_1 {Type I LastRead 10 FirstWrite -1}
		quant_2 {Type I LastRead 10 FirstWrite -1}}
	p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_369_2_VITIS_LOOP_371_3 {
		consumed_V {Type I LastRead 0 FirstWrite -1}
		mul_ln1085 {Type I LastRead 0 FirstWrite -1}
		cmp32_i {Type I LastRead 0 FirstWrite -1}
		p_read {Type I LastRead 0 FirstWrite -1}
		pairs {Type I LastRead 1 FirstWrite -1}
		rows_V {Type O LastRead -1 FirstWrite 1}
		rows_V_1 {Type O LastRead -1 FirstWrite 1}
		tobool_i {Type I LastRead 0 FirstWrite -1}
		preview_pixels {Type O LastRead -1 FirstWrite 1}}
	p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_381_4 {
		px {Type I LastRead 0 FirstWrite -1}
		add_i244_i {Type I LastRead 0 FirstWrite -1}
		content_y {Type I LastRead 0 FirstWrite -1}
		xc_index {Type I LastRead 0 FirstWrite -1}
		xc_weight {Type I LastRead 2 FirstWrite -1}
		width_cast_i {Type I LastRead 0 FirstWrite -1}
		rows_V {Type I LastRead 3 FirstWrite -1}
		rows_V_1 {Type I LastRead 3 FirstWrite -1}
		trunc_ln5 {Type I LastRead 0 FirstWrite -1}
		sy1_V_1 {Type I LastRead 0 FirstWrite -1}
		zext_ln1540 {Type I LastRead 0 FirstWrite -1}
		quant_0 {Type I LastRead 10 FirstWrite -1}
		quant_1 {Type I LastRead 10 FirstWrite -1}
		quant_2 {Type I LastRead 10 FirstWrite -1}
		tensor_pixels {Type O LastRead -1 FirstWrite 11}}
	p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_403_6_VITIS_LOOP_405_7 {
		mul_ln358 {Type I LastRead 0 FirstWrite -1}
		pairs {Type I LastRead 1 FirstWrite -1}
		cmp139_i {Type I LastRead 0 FirstWrite -1}
		preview_pixels {Type O LastRead -1 FirstWrite 1}}
	p_anonymous_namespace_output_pass_Block_entry412_proc {
		mode {Type I LastRead 0 FirstWrite -1}}
	p_anonymous_namespace_pack {
		tensor_pixels {Type I LastRead 1 FirstWrite -1}
		tensor_words {Type O LastRead -1 FirstWrite 2}
		p_read {Type I LastRead 0 FirstWrite -1}
		icmp_ln482_loc_c {Type O LastRead -1 FirstWrite 0}}
	p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_423_2 {
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
		icmp_ln483_loc_c {Type O LastRead -1 FirstWrite 0}}
	p_anonymous_namespace_pack_3_Pipeline_VITIS_LOOP_423_2 {
		width_load {Type I LastRead 0 FirstWrite -1}
		preview_pixels {Type I LastRead 1 FirstWrite -1}
		preview_words {Type O LastRead -1 FirstWrite 2}
		bits_6_out {Type O LastRead -1 FirstWrite 1}
		reservoir_V_out {Type O LastRead -1 FirstWrite 1}}
	p_anonymous_namespace_write_words {
		gmem_out {Type O LastRead 4 FirstWrite 2}
		tensor {Type I LastRead 0 FirstWrite -1}
		tensor_words {Type I LastRead 1 FirstWrite -1}
		icmp_ln482_loc {Type I LastRead 0 FirstWrite -1}}
	p_anonymous_namespace_write_words_Pipeline_VITIS_LOOP_444_1_VITIS_LOOP_446_2 {
		gmem_out {Type O LastRead -1 FirstWrite 2}
		sext_ln444 {Type I LastRead 0 FirstWrite -1}
		tensor_words {Type I LastRead 1 FirstWrite -1}}
	p_anonymous_namespace_write_words_4 {
		gmem_preview {Type O LastRead 8 FirstWrite 2}
		preview {Type I LastRead 0 FirstWrite -1}
		preview_words {Type I LastRead 1 FirstWrite -1}
		width {Type I LastRead 0 FirstWrite -1}
		height {Type I LastRead 0 FirstWrite -1}
		preview_stride {Type I LastRead 0 FirstWrite -1}
		icmp_ln483_loc {Type I LastRead 0 FirstWrite -1}}
	p_anonymous_namespace_write_words_4_Pipeline_VITIS_LOOP_446_2 {
		gmem_preview {Type O LastRead -1 FirstWrite 2}
		sext_ln446 {Type I LastRead 0 FirstWrite -1}
		count {Type I LastRead 0 FirstWrite -1}
		preview_words {Type I LastRead 1 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "5", "Max" : "10425286"}
	, {"Name" : "Interval", "Min" : "6", "Max" : "10425287"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	gmem_in { m_axi {  { m_axi_gmem_in_AWVALID VALID 1 1 }  { m_axi_gmem_in_AWREADY READY 0 1 }  { m_axi_gmem_in_AWADDR ADDR 1 64 }  { m_axi_gmem_in_AWID ID 1 1 }  { m_axi_gmem_in_AWLEN SIZE 1 8 }  { m_axi_gmem_in_AWSIZE BURST 1 3 }  { m_axi_gmem_in_AWBURST LOCK 1 2 }  { m_axi_gmem_in_AWLOCK CACHE 1 2 }  { m_axi_gmem_in_AWCACHE PROT 1 4 }  { m_axi_gmem_in_AWPROT QOS 1 3 }  { m_axi_gmem_in_AWQOS REGION 1 4 }  { m_axi_gmem_in_AWREGION USER 1 4 }  { m_axi_gmem_in_AWUSER DATA 1 1 }  { m_axi_gmem_in_WVALID VALID 1 1 }  { m_axi_gmem_in_WREADY READY 0 1 }  { m_axi_gmem_in_WDATA FIFONUM 1 128 }  { m_axi_gmem_in_WSTRB STRB 1 16 }  { m_axi_gmem_in_WLAST LAST 1 1 }  { m_axi_gmem_in_WID ID 1 1 }  { m_axi_gmem_in_WUSER DATA 1 1 }  { m_axi_gmem_in_ARVALID VALID 1 1 }  { m_axi_gmem_in_ARREADY READY 0 1 }  { m_axi_gmem_in_ARADDR ADDR 1 64 }  { m_axi_gmem_in_ARID ID 1 1 }  { m_axi_gmem_in_ARLEN SIZE 1 8 }  { m_axi_gmem_in_ARSIZE BURST 1 3 }  { m_axi_gmem_in_ARBURST LOCK 1 2 }  { m_axi_gmem_in_ARLOCK CACHE 1 2 }  { m_axi_gmem_in_ARCACHE PROT 1 4 }  { m_axi_gmem_in_ARPROT QOS 1 3 }  { m_axi_gmem_in_ARQOS REGION 1 4 }  { m_axi_gmem_in_ARREGION USER 1 4 }  { m_axi_gmem_in_ARUSER DATA 1 1 }  { m_axi_gmem_in_RVALID VALID 0 1 }  { m_axi_gmem_in_RREADY READY 1 1 }  { m_axi_gmem_in_RDATA FIFONUM 0 128 }  { m_axi_gmem_in_RLAST LAST 0 1 }  { m_axi_gmem_in_RID ID 0 1 }  { m_axi_gmem_in_RUSER DATA 0 1 }  { m_axi_gmem_in_RRESP RESP 0 2 }  { m_axi_gmem_in_BVALID VALID 0 1 }  { m_axi_gmem_in_BREADY READY 1 1 }  { m_axi_gmem_in_BRESP RESP 0 2 }  { m_axi_gmem_in_BID ID 0 1 }  { m_axi_gmem_in_BUSER DATA 0 1 } } }
	gmem_out { m_axi {  { m_axi_gmem_out_AWVALID VALID 1 1 }  { m_axi_gmem_out_AWREADY READY 0 1 }  { m_axi_gmem_out_AWADDR ADDR 1 64 }  { m_axi_gmem_out_AWID ID 1 1 }  { m_axi_gmem_out_AWLEN SIZE 1 8 }  { m_axi_gmem_out_AWSIZE BURST 1 3 }  { m_axi_gmem_out_AWBURST LOCK 1 2 }  { m_axi_gmem_out_AWLOCK CACHE 1 2 }  { m_axi_gmem_out_AWCACHE PROT 1 4 }  { m_axi_gmem_out_AWPROT QOS 1 3 }  { m_axi_gmem_out_AWQOS REGION 1 4 }  { m_axi_gmem_out_AWREGION USER 1 4 }  { m_axi_gmem_out_AWUSER DATA 1 1 }  { m_axi_gmem_out_WVALID VALID 1 1 }  { m_axi_gmem_out_WREADY READY 0 1 }  { m_axi_gmem_out_WDATA FIFONUM 1 128 }  { m_axi_gmem_out_WSTRB STRB 1 16 }  { m_axi_gmem_out_WLAST LAST 1 1 }  { m_axi_gmem_out_WID ID 1 1 }  { m_axi_gmem_out_WUSER DATA 1 1 }  { m_axi_gmem_out_ARVALID VALID 1 1 }  { m_axi_gmem_out_ARREADY READY 0 1 }  { m_axi_gmem_out_ARADDR ADDR 1 64 }  { m_axi_gmem_out_ARID ID 1 1 }  { m_axi_gmem_out_ARLEN SIZE 1 8 }  { m_axi_gmem_out_ARSIZE BURST 1 3 }  { m_axi_gmem_out_ARBURST LOCK 1 2 }  { m_axi_gmem_out_ARLOCK CACHE 1 2 }  { m_axi_gmem_out_ARCACHE PROT 1 4 }  { m_axi_gmem_out_ARPROT QOS 1 3 }  { m_axi_gmem_out_ARQOS REGION 1 4 }  { m_axi_gmem_out_ARREGION USER 1 4 }  { m_axi_gmem_out_ARUSER DATA 1 1 }  { m_axi_gmem_out_RVALID VALID 0 1 }  { m_axi_gmem_out_RREADY READY 1 1 }  { m_axi_gmem_out_RDATA FIFONUM 0 128 }  { m_axi_gmem_out_RLAST LAST 0 1 }  { m_axi_gmem_out_RID ID 0 1 }  { m_axi_gmem_out_RUSER DATA 0 1 }  { m_axi_gmem_out_RRESP RESP 0 2 }  { m_axi_gmem_out_BVALID VALID 0 1 }  { m_axi_gmem_out_BREADY READY 1 1 }  { m_axi_gmem_out_BRESP RESP 0 2 }  { m_axi_gmem_out_BID ID 0 1 }  { m_axi_gmem_out_BUSER DATA 0 1 } } }
	gmem_preview { m_axi {  { m_axi_gmem_preview_AWVALID VALID 1 1 }  { m_axi_gmem_preview_AWREADY READY 0 1 }  { m_axi_gmem_preview_AWADDR ADDR 1 64 }  { m_axi_gmem_preview_AWID ID 1 1 }  { m_axi_gmem_preview_AWLEN SIZE 1 8 }  { m_axi_gmem_preview_AWSIZE BURST 1 3 }  { m_axi_gmem_preview_AWBURST LOCK 1 2 }  { m_axi_gmem_preview_AWLOCK CACHE 1 2 }  { m_axi_gmem_preview_AWCACHE PROT 1 4 }  { m_axi_gmem_preview_AWPROT QOS 1 3 }  { m_axi_gmem_preview_AWQOS REGION 1 4 }  { m_axi_gmem_preview_AWREGION USER 1 4 }  { m_axi_gmem_preview_AWUSER DATA 1 1 }  { m_axi_gmem_preview_WVALID VALID 1 1 }  { m_axi_gmem_preview_WREADY READY 0 1 }  { m_axi_gmem_preview_WDATA FIFONUM 1 128 }  { m_axi_gmem_preview_WSTRB STRB 1 16 }  { m_axi_gmem_preview_WLAST LAST 1 1 }  { m_axi_gmem_preview_WID ID 1 1 }  { m_axi_gmem_preview_WUSER DATA 1 1 }  { m_axi_gmem_preview_ARVALID VALID 1 1 }  { m_axi_gmem_preview_ARREADY READY 0 1 }  { m_axi_gmem_preview_ARADDR ADDR 1 64 }  { m_axi_gmem_preview_ARID ID 1 1 }  { m_axi_gmem_preview_ARLEN SIZE 1 8 }  { m_axi_gmem_preview_ARSIZE BURST 1 3 }  { m_axi_gmem_preview_ARBURST LOCK 1 2 }  { m_axi_gmem_preview_ARLOCK CACHE 1 2 }  { m_axi_gmem_preview_ARCACHE PROT 1 4 }  { m_axi_gmem_preview_ARPROT QOS 1 3 }  { m_axi_gmem_preview_ARQOS REGION 1 4 }  { m_axi_gmem_preview_ARREGION USER 1 4 }  { m_axi_gmem_preview_ARUSER DATA 1 1 }  { m_axi_gmem_preview_RVALID VALID 0 1 }  { m_axi_gmem_preview_RREADY READY 1 1 }  { m_axi_gmem_preview_RDATA FIFONUM 0 128 }  { m_axi_gmem_preview_RLAST LAST 0 1 }  { m_axi_gmem_preview_RID ID 0 1 }  { m_axi_gmem_preview_RUSER DATA 0 1 }  { m_axi_gmem_preview_RRESP RESP 0 2 }  { m_axi_gmem_preview_BVALID VALID 0 1 }  { m_axi_gmem_preview_BREADY READY 1 1 }  { m_axi_gmem_preview_BRESP RESP 0 2 }  { m_axi_gmem_preview_BID ID 0 1 }  { m_axi_gmem_preview_BUSER DATA 0 1 } } }
}

set maxi_interface_dict [dict create]
dict set maxi_interface_dict gmem_in {NUM_READ_OUTSTANDING 2 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 32 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE READ_ONLY}
dict set maxi_interface_dict gmem_out {NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 2 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 32 READ_WRITE_MODE WRITE_ONLY}
dict set maxi_interface_dict gmem_preview {NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 2 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 32 READ_WRITE_MODE WRITE_ONLY}

# RTL port scheduling information:
set fifoSchedulingInfoList { 
}

# RTL bus port read request latency information:
set busReadReqLatencyList { 
	{ gmem_in 1 }
	{ gmem_out 1 }
	{ gmem_preview 1 }
}

# RTL bus port write response latency information:
set busWriteResLatencyList { 
	{ gmem_in 1 }
	{ gmem_out 1 }
	{ gmem_preview 1 }
}

# RTL array port load latency information:
set memoryLoadLatencyList { 
}
