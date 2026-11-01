dict set slaves control {ports {ap_start {type ap_ctrl width 1} ap_done {type ap_ctrl width 1} ap_ready {type ap_ctrl width 1} ap_idle {type ap_ctrl width 1} ap_return {type ap_return width 32} input_r {type i_ap_none width 64} tables {type i_ap_none width 64} output_r {type i_ap_none width 64} input_words {type i_ap_none width 32} table_words {type i_ap_none width 32} output_capacity {type i_ap_none width 32} confidence_q30 {type i_ap_none width 32} nms_q16 {type i_ap_none width 32} enable_nms {type i_ap_none width 32} candidate_count {type o_ap_vld width 32} detection_count {type o_ap_vld width 32}} mems {} has_ctrl 1}
set datawidth 32
set addrwidth 64
set intr_clr_mode COR
