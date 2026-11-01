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
input_r { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 24
	offset_end 35
}
tables { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 36
	offset_end 47
}
output_r { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 48
	offset_end 59
}
input_words { 
	dir I
	width 32
	depth 1
	mode ap_none
	offset 60
	offset_end 67
}
table_words { 
	dir I
	width 32
	depth 1
	mode ap_none
	offset 68
	offset_end 75
}
output_capacity { 
	dir I
	width 32
	depth 1
	mode ap_none
	offset 76
	offset_end 83
}
confidence_q30 { 
	dir I
	width 32
	depth 1
	mode ap_none
	offset 84
	offset_end 91
}
nms_q16 { 
	dir I
	width 32
	depth 1
	mode ap_none
	offset 92
	offset_end 99
}
enable_nms { 
	dir I
	width 32
	depth 1
	mode ap_none
	offset 100
	offset_end 107
}
candidate_count { 
	dir O
	width 32
	depth 1
	mode ap_vld
	offset 108
	offset_end 115
}
detection_count { 
	dir O
	width 32
	depth 1
	mode ap_vld
	offset 124
	offset_end 131
}
interrupt {
}
}
dict set axilite_register_dict control $port_control


