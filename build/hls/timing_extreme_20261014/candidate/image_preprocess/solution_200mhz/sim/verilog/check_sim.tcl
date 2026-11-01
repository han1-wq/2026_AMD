# ==============================================================
# Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
# Tool Version Limit: 2022.04
# Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
# ==============================================================
proc sc_sim_check {ret err logfile} {
	if {$::AESL_AUTOSIM::gDebug == 1} {
		puts stdout "[debug_prompt arg check_sim.tcl] start...";
	}
    set errfile "err.log"
    if {[file exists $errfile] && [file size $errfile] != 0} {
        set fl [open $errfile r]
        while {[gets $fl line] >= 0} {
            if {[string first "AESL_mErrNo = " $line] == 0} {
                set mismatch_num [string range $line [string length "AESL_mErrNo = "] end]
                if {$mismatch_num != 0} {
                    ::AP::printMsg ERR COSIM 403 COSIM_403_986 ${mismatch_num}
                    break
                }
            }
        }
    }
    if {$ret || $err != ""} {
        if { [lindex $::errorCode 0] eq "CHILDSTATUS"} {
            set status [lindex $::errorCode 2]
            if {$status != ""} {
                ::AP::printMsg ERR COSIM 404 COSIM_404_987 $status
            } else {
                ::AP::printMsg ERR COSIM 405 COSIM_405_988
            }
        } else {
            ::AP::printMsg ERR COSIM 405 COSIM_405_989
        }
    }
    if {[file exists $logfile]} {
        set cmdret [catch {eval exec "grep \"Error:\" $logfile"} err]
        file delete -force $logfile
        if {$cmdret == 0} {
            ::AP::printMsg ERR COSIM 405 COSIM_405_990
        }
    }
	if {$::AESL_AUTOSIM::gDebug == 1} {
		puts stdout "[debug_prompt arg check_sim.tcl] finish...";
	}
}

proc rtl_sim_check {} {
	if {$::AESL_AUTOSIM::gDebug == 1} {
		puts stdout "[debug_prompt arg check_sim.tcl] start...";
	}
    set errfile "err.log"
    if {[file exists $errfile] && [file size $errfile] != 0} {
        set fl [open $errfile r]
        set unmatch_num 0
        while {[gets $fl line] >= 0} {
            if {[string first "unmatched" $line] != -1} {
                set unmatch_num [expr $unmatch_num + 1]
            }
        }
        if {$unmatch_num != 0} {
            ::AP::printMsg ERR COSIM 406 COSIM_406_991 ${unmatch_num}
        }
    }
    if {[file exists ".aesl_error"]} {
        set errfl [open ".aesl_error" r]
        gets $errfl line
        if {$line != 0} {
            ::AP::printMsg ERR COSIM 407 COSIM_407_992 $line
        }
    }
    if {[file exists ".exit.err"]} {
        ::AP::printMsg ERR COSIM 405 COSIM_405_993
    }
	if {$::AESL_AUTOSIM::gDebug == 1} {
		puts stdout "[debug_prompt arg check_sim.tcl] finish...";
	}
}

proc check_tvin_file {} {
	if {$::AESL_AUTOSIM::gDebug == 1} {
		puts stdout "[debug_prompt arg check_sim.tcl] start...";
	}
    set rtlfilelist {
         "c.image_preprocess.autotvin_gmem_in.dat"
         "c.image_preprocess.autotvin_src.dat"
         "c.image_preprocess.autotvin_tensor.dat"
         "c.image_preprocess.autotvin_preview.dat"
         "c.image_preprocess.autotvin_luts.dat"
         "c.image_preprocess.autotvin_width.dat"
         "c.image_preprocess.autotvin_height.dat"
         "c.image_preprocess.autotvin_src_stride.dat"
         "c.image_preprocess.autotvin_src_capacity.dat"
         "c.image_preprocess.autotvin_tensor_capacity.dat"
         "c.image_preprocess.autotvin_preview_stride.dat"
         "c.image_preprocess.autotvin_preview_capacity.dat"
         "c.image_preprocess.autotvin_resized_w.dat"
         "c.image_preprocess.autotvin_resized_h.dat"
         "c.image_preprocess.autotvin_pad_x.dat"
         "c.image_preprocess.autotvin_pad_y.dat"
         "c.image_preprocess.autotvin_output_mode.dat"
         "c.image_preprocess.autotvin_flags.dat"
         "c.image_preprocess.autotvin_eq_mode.dat"
         "c.image_preprocess.autotvin_saturation_q12.dat"
         "c.image_preprocess.autotvin_frame_id.dat"
         "c.image_preprocess.autotvin_config_id.dat"
    }
    foreach rtlfile $rtlfilelist {
        if {[file isfile $rtlfile]} {
        } else {
            ::AP::printMsg ERR COSIM 320 COSIM_320_994
            return 1
        }
    }
	if {$::AESL_AUTOSIM::gDebug == 1} {
		puts stdout "[debug_prompt arg check_sim.tcl] finish...";
	}
    return 0
}

proc check_tvout_file {} {
	if {$::AESL_AUTOSIM::gDebug == 1} {
		puts stdout "[debug_prompt arg check_sim.tcl] start...";
	}
    set rtlfilelist {
         "rtl.image_preprocess.autotvout_gmem_out.dat"
         "rtl.image_preprocess.autotvout_gmem_preview.dat"
         "rtl.image_preprocess.autotvout_completed_frame_id.dat"
         "rtl.image_preprocess.autotvout_completed_config_id.dat"
         "rtl.image_preprocess.autotvout_tensor_bytes.dat"
         "rtl.image_preprocess.autotvout_preview_bytes.dat"
         "rtl.image_preprocess.autotvout_abi_version.dat"
         "rtl.image_preprocess.autotvout_ap_return.dat"
    }
    foreach rtlfile $rtlfilelist {
        if {[file isfile $rtlfile]} {
        } else {
            ::AP::printMsg ERR COSIM 303 COSIM_303_996
            return 1
        }
    }
	if {$::AESL_AUTOSIM::gDebug == 1} {
		puts stdout "[debug_prompt arg check_sim.tcl] finish...";
	}
    return 0
}
