# This script segment is generated automatically by AutoPilot

set axilite_register_dict [dict create]
set port_control {
ap_start { }
ap_done { }
ap_ready { }
ap_idle { }
ap_return { 
	dir o
	width 32
	depth 1
	mode ap_ctrl_hs
	offset 16
	offset_end 0
}
src { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 24
	offset_end 35
}
tensor { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 36
	offset_end 47
}
preview { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 48
	offset_end 59
}
luts { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 60
	offset_end 71
}
width { 
	dir I
	width 32
	depth 1
	mode ap_none
	offset 72
	offset_end 79
}
height { 
	dir I
	width 32
	depth 1
	mode ap_none
	offset 80
	offset_end 87
}
src_stride { 
	dir I
	width 32
	depth 1
	mode ap_none
	offset 88
	offset_end 95
}
src_capacity { 
	dir I
	width 32
	depth 1
	mode ap_none
	offset 96
	offset_end 103
}
tensor_capacity { 
	dir I
	width 32
	depth 1
	mode ap_none
	offset 104
	offset_end 111
}
preview_stride { 
	dir I
	width 32
	depth 1
	mode ap_none
	offset 112
	offset_end 119
}
preview_capacity { 
	dir I
	width 32
	depth 1
	mode ap_none
	offset 120
	offset_end 127
}
resized_w { 
	dir I
	width 32
	depth 1
	mode ap_none
	offset 128
	offset_end 135
}
resized_h { 
	dir I
	width 32
	depth 1
	mode ap_none
	offset 136
	offset_end 143
}
pad_x { 
	dir I
	width 32
	depth 1
	mode ap_none
	offset 144
	offset_end 151
}
pad_y { 
	dir I
	width 32
	depth 1
	mode ap_none
	offset 152
	offset_end 159
}
output_mode { 
	dir I
	width 32
	depth 1
	mode ap_none
	offset 160
	offset_end 167
}
flags { 
	dir I
	width 32
	depth 1
	mode ap_none
	offset 168
	offset_end 175
}
eq_mode { 
	dir I
	width 32
	depth 1
	mode ap_none
	offset 176
	offset_end 183
}
saturation_q12 { 
	dir I
	width 32
	depth 1
	mode ap_none
	offset 184
	offset_end 191
}
frame_id { 
	dir I
	width 32
	depth 1
	mode ap_none
	offset 192
	offset_end 199
}
config_id { 
	dir I
	width 32
	depth 1
	mode ap_none
	offset 200
	offset_end 207
}
completed_frame_id { 
	dir O
	width 32
	depth 1
	mode ap_vld
	offset 208
	offset_end 215
}
completed_config_id { 
	dir O
	width 32
	depth 1
	mode ap_vld
	offset 224
	offset_end 231
}
tensor_bytes { 
	dir O
	width 32
	depth 1
	mode ap_vld
	offset 240
	offset_end 247
}
preview_bytes { 
	dir O
	width 32
	depth 1
	mode ap_vld
	offset 256
	offset_end 263
}
abi_version { 
	dir O
	width 32
	depth 1
	mode ap_vld
	offset 272
	offset_end 279
}
interrupt {
}
}
dict set axilite_register_dict control $port_control


