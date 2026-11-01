`timescale 1 ns / 1 ps

module AESL_deadlock_detector (
    input dl_reset,
    input all_finish,
    input dl_clock);

    wire [2:0] proc_0_data_FIFO_blk;
    wire [2:0] proc_0_data_PIPO_blk;
    wire [2:0] proc_0_start_FIFO_blk;
    wire [2:0] proc_0_TLF_FIFO_blk;
    wire [2:0] proc_0_input_sync_blk;
    wire [2:0] proc_0_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_0;
    reg [2:0] proc_dep_vld_vec_0_reg;
    wire [2:0] in_chan_dep_vld_vec_0;
    wire [50:0] in_chan_dep_data_vec_0;
    wire [2:0] token_in_vec_0;
    wire [2:0] out_chan_dep_vld_vec_0;
    wire [16:0] out_chan_dep_data_0;
    wire [2:0] token_out_vec_0;
    wire dl_detect_out_0;
    wire dep_chan_vld_1_0;
    wire [16:0] dep_chan_data_1_0;
    wire token_1_0;
    wire dep_chan_vld_2_0;
    wire [16:0] dep_chan_data_2_0;
    wire token_2_0;
    wire dep_chan_vld_3_0;
    wire [16:0] dep_chan_data_3_0;
    wire token_3_0;
    wire [1:0] proc_1_data_FIFO_blk;
    wire [1:0] proc_1_data_PIPO_blk;
    wire [1:0] proc_1_start_FIFO_blk;
    wire [1:0] proc_1_TLF_FIFO_blk;
    wire [1:0] proc_1_input_sync_blk;
    wire [1:0] proc_1_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_1;
    reg [1:0] proc_dep_vld_vec_1_reg;
    wire [1:0] in_chan_dep_vld_vec_1;
    wire [33:0] in_chan_dep_data_vec_1;
    wire [1:0] token_in_vec_1;
    wire [1:0] out_chan_dep_vld_vec_1;
    wire [16:0] out_chan_dep_data_1;
    wire [1:0] token_out_vec_1;
    wire dl_detect_out_1;
    wire dep_chan_vld_0_1;
    wire [16:0] dep_chan_data_0_1;
    wire token_0_1;
    wire dep_chan_vld_3_1;
    wire [16:0] dep_chan_data_3_1;
    wire token_3_1;
    wire [1:0] proc_2_data_FIFO_blk;
    wire [1:0] proc_2_data_PIPO_blk;
    wire [1:0] proc_2_start_FIFO_blk;
    wire [1:0] proc_2_TLF_FIFO_blk;
    wire [1:0] proc_2_input_sync_blk;
    wire [1:0] proc_2_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_2;
    reg [1:0] proc_dep_vld_vec_2_reg;
    wire [1:0] in_chan_dep_vld_vec_2;
    wire [33:0] in_chan_dep_data_vec_2;
    wire [1:0] token_in_vec_2;
    wire [1:0] out_chan_dep_vld_vec_2;
    wire [16:0] out_chan_dep_data_2;
    wire [1:0] token_out_vec_2;
    wire dl_detect_out_2;
    wire dep_chan_vld_0_2;
    wire [16:0] dep_chan_data_0_2;
    wire token_0_2;
    wire dep_chan_vld_3_2;
    wire [16:0] dep_chan_data_3_2;
    wire token_3_2;
    wire [2:0] proc_3_data_FIFO_blk;
    wire [2:0] proc_3_data_PIPO_blk;
    wire [2:0] proc_3_start_FIFO_blk;
    wire [2:0] proc_3_TLF_FIFO_blk;
    wire [2:0] proc_3_input_sync_blk;
    wire [2:0] proc_3_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_3;
    reg [2:0] proc_dep_vld_vec_3_reg;
    wire [2:0] in_chan_dep_vld_vec_3;
    wire [50:0] in_chan_dep_data_vec_3;
    wire [2:0] token_in_vec_3;
    wire [2:0] out_chan_dep_vld_vec_3;
    wire [16:0] out_chan_dep_data_3;
    wire [2:0] token_out_vec_3;
    wire dl_detect_out_3;
    wire dep_chan_vld_0_3;
    wire [16:0] dep_chan_data_0_3;
    wire token_0_3;
    wire dep_chan_vld_1_3;
    wire [16:0] dep_chan_data_1_3;
    wire token_1_3;
    wire dep_chan_vld_2_3;
    wire [16:0] dep_chan_data_2_3;
    wire token_2_3;
    wire [8:0] proc_4_data_FIFO_blk;
    wire [8:0] proc_4_data_PIPO_blk;
    wire [8:0] proc_4_start_FIFO_blk;
    wire [8:0] proc_4_TLF_FIFO_blk;
    wire [8:0] proc_4_input_sync_blk;
    wire [8:0] proc_4_output_sync_blk;
    wire [8:0] proc_dep_vld_vec_4;
    reg [8:0] proc_dep_vld_vec_4_reg;
    wire [8:0] in_chan_dep_vld_vec_4;
    wire [152:0] in_chan_dep_data_vec_4;
    wire [8:0] token_in_vec_4;
    wire [8:0] out_chan_dep_vld_vec_4;
    wire [16:0] out_chan_dep_data_4;
    wire [8:0] token_out_vec_4;
    wire dl_detect_out_4;
    wire dep_chan_vld_5_4;
    wire [16:0] dep_chan_data_5_4;
    wire token_5_4;
    wire dep_chan_vld_7_4;
    wire [16:0] dep_chan_data_7_4;
    wire token_7_4;
    wire dep_chan_vld_8_4;
    wire [16:0] dep_chan_data_8_4;
    wire token_8_4;
    wire dep_chan_vld_9_4;
    wire [16:0] dep_chan_data_9_4;
    wire token_9_4;
    wire dep_chan_vld_10_4;
    wire [16:0] dep_chan_data_10_4;
    wire token_10_4;
    wire dep_chan_vld_11_4;
    wire [16:0] dep_chan_data_11_4;
    wire token_11_4;
    wire dep_chan_vld_13_4;
    wire [16:0] dep_chan_data_13_4;
    wire token_13_4;
    wire dep_chan_vld_15_4;
    wire [16:0] dep_chan_data_15_4;
    wire token_15_4;
    wire dep_chan_vld_16_4;
    wire [16:0] dep_chan_data_16_4;
    wire token_16_4;
    wire [7:0] proc_5_data_FIFO_blk;
    wire [7:0] proc_5_data_PIPO_blk;
    wire [7:0] proc_5_start_FIFO_blk;
    wire [7:0] proc_5_TLF_FIFO_blk;
    wire [7:0] proc_5_input_sync_blk;
    wire [7:0] proc_5_output_sync_blk;
    wire [7:0] proc_dep_vld_vec_5;
    reg [7:0] proc_dep_vld_vec_5_reg;
    wire [7:0] in_chan_dep_vld_vec_5;
    wire [135:0] in_chan_dep_data_vec_5;
    wire [7:0] token_in_vec_5;
    wire [7:0] out_chan_dep_vld_vec_5;
    wire [16:0] out_chan_dep_data_5;
    wire [7:0] token_out_vec_5;
    wire dl_detect_out_5;
    wire dep_chan_vld_4_5;
    wire [16:0] dep_chan_data_4_5;
    wire token_4_5;
    wire dep_chan_vld_6_5;
    wire [16:0] dep_chan_data_6_5;
    wire token_6_5;
    wire dep_chan_vld_7_5;
    wire [16:0] dep_chan_data_7_5;
    wire token_7_5;
    wire dep_chan_vld_8_5;
    wire [16:0] dep_chan_data_8_5;
    wire token_8_5;
    wire dep_chan_vld_9_5;
    wire [16:0] dep_chan_data_9_5;
    wire token_9_5;
    wire dep_chan_vld_10_5;
    wire [16:0] dep_chan_data_10_5;
    wire token_10_5;
    wire dep_chan_vld_11_5;
    wire [16:0] dep_chan_data_11_5;
    wire token_11_5;
    wire dep_chan_vld_13_5;
    wire [16:0] dep_chan_data_13_5;
    wire token_13_5;
    wire [2:0] proc_6_data_FIFO_blk;
    wire [2:0] proc_6_data_PIPO_blk;
    wire [2:0] proc_6_start_FIFO_blk;
    wire [2:0] proc_6_TLF_FIFO_blk;
    wire [2:0] proc_6_input_sync_blk;
    wire [2:0] proc_6_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_6;
    reg [2:0] proc_dep_vld_vec_6_reg;
    wire [2:0] in_chan_dep_vld_vec_6;
    wire [50:0] in_chan_dep_data_vec_6;
    wire [2:0] token_in_vec_6;
    wire [2:0] out_chan_dep_vld_vec_6;
    wire [16:0] out_chan_dep_data_6;
    wire [2:0] token_out_vec_6;
    wire dl_detect_out_6;
    wire dep_chan_vld_5_6;
    wire [16:0] dep_chan_data_5_6;
    wire token_5_6;
    wire dep_chan_vld_8_6;
    wire [16:0] dep_chan_data_8_6;
    wire token_8_6;
    wire dep_chan_vld_14_6;
    wire [16:0] dep_chan_data_14_6;
    wire token_14_6;
    wire [6:0] proc_7_data_FIFO_blk;
    wire [6:0] proc_7_data_PIPO_blk;
    wire [6:0] proc_7_start_FIFO_blk;
    wire [6:0] proc_7_TLF_FIFO_blk;
    wire [6:0] proc_7_input_sync_blk;
    wire [6:0] proc_7_output_sync_blk;
    wire [6:0] proc_dep_vld_vec_7;
    reg [6:0] proc_dep_vld_vec_7_reg;
    wire [6:0] in_chan_dep_vld_vec_7;
    wire [118:0] in_chan_dep_data_vec_7;
    wire [6:0] token_in_vec_7;
    wire [6:0] out_chan_dep_vld_vec_7;
    wire [16:0] out_chan_dep_data_7;
    wire [6:0] token_out_vec_7;
    wire dl_detect_out_7;
    wire dep_chan_vld_4_7;
    wire [16:0] dep_chan_data_4_7;
    wire token_4_7;
    wire dep_chan_vld_5_7;
    wire [16:0] dep_chan_data_5_7;
    wire token_5_7;
    wire dep_chan_vld_8_7;
    wire [16:0] dep_chan_data_8_7;
    wire token_8_7;
    wire dep_chan_vld_9_7;
    wire [16:0] dep_chan_data_9_7;
    wire token_9_7;
    wire dep_chan_vld_10_7;
    wire [16:0] dep_chan_data_10_7;
    wire token_10_7;
    wire dep_chan_vld_11_7;
    wire [16:0] dep_chan_data_11_7;
    wire token_11_7;
    wire dep_chan_vld_13_7;
    wire [16:0] dep_chan_data_13_7;
    wire token_13_7;
    wire [7:0] proc_8_data_FIFO_blk;
    wire [7:0] proc_8_data_PIPO_blk;
    wire [7:0] proc_8_start_FIFO_blk;
    wire [7:0] proc_8_TLF_FIFO_blk;
    wire [7:0] proc_8_input_sync_blk;
    wire [7:0] proc_8_output_sync_blk;
    wire [7:0] proc_dep_vld_vec_8;
    reg [7:0] proc_dep_vld_vec_8_reg;
    wire [7:0] in_chan_dep_vld_vec_8;
    wire [135:0] in_chan_dep_data_vec_8;
    wire [7:0] token_in_vec_8;
    wire [7:0] out_chan_dep_vld_vec_8;
    wire [16:0] out_chan_dep_data_8;
    wire [7:0] token_out_vec_8;
    wire dl_detect_out_8;
    wire dep_chan_vld_4_8;
    wire [16:0] dep_chan_data_4_8;
    wire token_4_8;
    wire dep_chan_vld_5_8;
    wire [16:0] dep_chan_data_5_8;
    wire token_5_8;
    wire dep_chan_vld_6_8;
    wire [16:0] dep_chan_data_6_8;
    wire token_6_8;
    wire dep_chan_vld_7_8;
    wire [16:0] dep_chan_data_7_8;
    wire token_7_8;
    wire dep_chan_vld_9_8;
    wire [16:0] dep_chan_data_9_8;
    wire token_9_8;
    wire dep_chan_vld_10_8;
    wire [16:0] dep_chan_data_10_8;
    wire token_10_8;
    wire dep_chan_vld_11_8;
    wire [16:0] dep_chan_data_11_8;
    wire token_11_8;
    wire dep_chan_vld_13_8;
    wire [16:0] dep_chan_data_13_8;
    wire token_13_8;
    wire [8:0] proc_9_data_FIFO_blk;
    wire [8:0] proc_9_data_PIPO_blk;
    wire [8:0] proc_9_start_FIFO_blk;
    wire [8:0] proc_9_TLF_FIFO_blk;
    wire [8:0] proc_9_input_sync_blk;
    wire [8:0] proc_9_output_sync_blk;
    wire [8:0] proc_dep_vld_vec_9;
    reg [8:0] proc_dep_vld_vec_9_reg;
    wire [8:0] in_chan_dep_vld_vec_9;
    wire [152:0] in_chan_dep_data_vec_9;
    wire [8:0] token_in_vec_9;
    wire [8:0] out_chan_dep_vld_vec_9;
    wire [16:0] out_chan_dep_data_9;
    wire [8:0] token_out_vec_9;
    wire dl_detect_out_9;
    wire dep_chan_vld_4_9;
    wire [16:0] dep_chan_data_4_9;
    wire token_4_9;
    wire dep_chan_vld_5_9;
    wire [16:0] dep_chan_data_5_9;
    wire token_5_9;
    wire dep_chan_vld_7_9;
    wire [16:0] dep_chan_data_7_9;
    wire token_7_9;
    wire dep_chan_vld_8_9;
    wire [16:0] dep_chan_data_8_9;
    wire token_8_9;
    wire dep_chan_vld_10_9;
    wire [16:0] dep_chan_data_10_9;
    wire token_10_9;
    wire dep_chan_vld_11_9;
    wire [16:0] dep_chan_data_11_9;
    wire token_11_9;
    wire dep_chan_vld_13_9;
    wire [16:0] dep_chan_data_13_9;
    wire token_13_9;
    wire dep_chan_vld_15_9;
    wire [16:0] dep_chan_data_15_9;
    wire token_15_9;
    wire dep_chan_vld_16_9;
    wire [16:0] dep_chan_data_16_9;
    wire token_16_9;
    wire [8:0] proc_10_data_FIFO_blk;
    wire [8:0] proc_10_data_PIPO_blk;
    wire [8:0] proc_10_start_FIFO_blk;
    wire [8:0] proc_10_TLF_FIFO_blk;
    wire [8:0] proc_10_input_sync_blk;
    wire [8:0] proc_10_output_sync_blk;
    wire [8:0] proc_dep_vld_vec_10;
    reg [8:0] proc_dep_vld_vec_10_reg;
    wire [8:0] in_chan_dep_vld_vec_10;
    wire [152:0] in_chan_dep_data_vec_10;
    wire [8:0] token_in_vec_10;
    wire [8:0] out_chan_dep_vld_vec_10;
    wire [16:0] out_chan_dep_data_10;
    wire [8:0] token_out_vec_10;
    wire dl_detect_out_10;
    wire dep_chan_vld_4_10;
    wire [16:0] dep_chan_data_4_10;
    wire token_4_10;
    wire dep_chan_vld_5_10;
    wire [16:0] dep_chan_data_5_10;
    wire token_5_10;
    wire dep_chan_vld_7_10;
    wire [16:0] dep_chan_data_7_10;
    wire token_7_10;
    wire dep_chan_vld_8_10;
    wire [16:0] dep_chan_data_8_10;
    wire token_8_10;
    wire dep_chan_vld_9_10;
    wire [16:0] dep_chan_data_9_10;
    wire token_9_10;
    wire dep_chan_vld_11_10;
    wire [16:0] dep_chan_data_11_10;
    wire token_11_10;
    wire dep_chan_vld_12_10;
    wire [16:0] dep_chan_data_12_10;
    wire token_12_10;
    wire dep_chan_vld_13_10;
    wire [16:0] dep_chan_data_13_10;
    wire token_13_10;
    wire dep_chan_vld_14_10;
    wire [16:0] dep_chan_data_14_10;
    wire token_14_10;
    wire [6:0] proc_11_data_FIFO_blk;
    wire [6:0] proc_11_data_PIPO_blk;
    wire [6:0] proc_11_start_FIFO_blk;
    wire [6:0] proc_11_TLF_FIFO_blk;
    wire [6:0] proc_11_input_sync_blk;
    wire [6:0] proc_11_output_sync_blk;
    wire [6:0] proc_dep_vld_vec_11;
    reg [6:0] proc_dep_vld_vec_11_reg;
    wire [7:0] in_chan_dep_vld_vec_11;
    wire [135:0] in_chan_dep_data_vec_11;
    wire [7:0] token_in_vec_11;
    wire [6:0] out_chan_dep_vld_vec_11;
    wire [16:0] out_chan_dep_data_11;
    wire [6:0] token_out_vec_11;
    wire dl_detect_out_11;
    wire dep_chan_vld_4_11;
    wire [16:0] dep_chan_data_4_11;
    wire token_4_11;
    wire dep_chan_vld_5_11;
    wire [16:0] dep_chan_data_5_11;
    wire token_5_11;
    wire dep_chan_vld_7_11;
    wire [16:0] dep_chan_data_7_11;
    wire token_7_11;
    wire dep_chan_vld_8_11;
    wire [16:0] dep_chan_data_8_11;
    wire token_8_11;
    wire dep_chan_vld_9_11;
    wire [16:0] dep_chan_data_9_11;
    wire token_9_11;
    wire dep_chan_vld_10_11;
    wire [16:0] dep_chan_data_10_11;
    wire token_10_11;
    wire dep_chan_vld_12_11;
    wire [16:0] dep_chan_data_12_11;
    wire token_12_11;
    wire dep_chan_vld_13_11;
    wire [16:0] dep_chan_data_13_11;
    wire token_13_11;
    wire [2:0] proc_12_data_FIFO_blk;
    wire [2:0] proc_12_data_PIPO_blk;
    wire [2:0] proc_12_start_FIFO_blk;
    wire [2:0] proc_12_TLF_FIFO_blk;
    wire [2:0] proc_12_input_sync_blk;
    wire [2:0] proc_12_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_12;
    reg [2:0] proc_dep_vld_vec_12_reg;
    wire [1:0] in_chan_dep_vld_vec_12;
    wire [33:0] in_chan_dep_data_vec_12;
    wire [1:0] token_in_vec_12;
    wire [2:0] out_chan_dep_vld_vec_12;
    wire [16:0] out_chan_dep_data_12;
    wire [2:0] token_out_vec_12;
    wire dl_detect_out_12;
    wire dep_chan_vld_10_12;
    wire [16:0] dep_chan_data_10_12;
    wire token_10_12;
    wire dep_chan_vld_15_12;
    wire [16:0] dep_chan_data_15_12;
    wire token_15_12;
    wire [6:0] proc_13_data_FIFO_blk;
    wire [6:0] proc_13_data_PIPO_blk;
    wire [6:0] proc_13_start_FIFO_blk;
    wire [6:0] proc_13_TLF_FIFO_blk;
    wire [6:0] proc_13_input_sync_blk;
    wire [6:0] proc_13_output_sync_blk;
    wire [6:0] proc_dep_vld_vec_13;
    reg [6:0] proc_dep_vld_vec_13_reg;
    wire [7:0] in_chan_dep_vld_vec_13;
    wire [135:0] in_chan_dep_data_vec_13;
    wire [7:0] token_in_vec_13;
    wire [6:0] out_chan_dep_vld_vec_13;
    wire [16:0] out_chan_dep_data_13;
    wire [6:0] token_out_vec_13;
    wire dl_detect_out_13;
    wire dep_chan_vld_4_13;
    wire [16:0] dep_chan_data_4_13;
    wire token_4_13;
    wire dep_chan_vld_5_13;
    wire [16:0] dep_chan_data_5_13;
    wire token_5_13;
    wire dep_chan_vld_7_13;
    wire [16:0] dep_chan_data_7_13;
    wire token_7_13;
    wire dep_chan_vld_8_13;
    wire [16:0] dep_chan_data_8_13;
    wire token_8_13;
    wire dep_chan_vld_9_13;
    wire [16:0] dep_chan_data_9_13;
    wire token_9_13;
    wire dep_chan_vld_10_13;
    wire [16:0] dep_chan_data_10_13;
    wire token_10_13;
    wire dep_chan_vld_11_13;
    wire [16:0] dep_chan_data_11_13;
    wire token_11_13;
    wire dep_chan_vld_14_13;
    wire [16:0] dep_chan_data_14_13;
    wire token_14_13;
    wire [3:0] proc_14_data_FIFO_blk;
    wire [3:0] proc_14_data_PIPO_blk;
    wire [3:0] proc_14_start_FIFO_blk;
    wire [3:0] proc_14_TLF_FIFO_blk;
    wire [3:0] proc_14_input_sync_blk;
    wire [3:0] proc_14_output_sync_blk;
    wire [3:0] proc_dep_vld_vec_14;
    reg [3:0] proc_dep_vld_vec_14_reg;
    wire [2:0] in_chan_dep_vld_vec_14;
    wire [50:0] in_chan_dep_data_vec_14;
    wire [2:0] token_in_vec_14;
    wire [3:0] out_chan_dep_vld_vec_14;
    wire [16:0] out_chan_dep_data_14;
    wire [3:0] token_out_vec_14;
    wire dl_detect_out_14;
    wire dep_chan_vld_6_14;
    wire [16:0] dep_chan_data_6_14;
    wire token_6_14;
    wire dep_chan_vld_10_14;
    wire [16:0] dep_chan_data_10_14;
    wire token_10_14;
    wire dep_chan_vld_16_14;
    wire [16:0] dep_chan_data_16_14;
    wire token_16_14;
    wire [3:0] proc_15_data_FIFO_blk;
    wire [3:0] proc_15_data_PIPO_blk;
    wire [3:0] proc_15_start_FIFO_blk;
    wire [3:0] proc_15_TLF_FIFO_blk;
    wire [3:0] proc_15_input_sync_blk;
    wire [3:0] proc_15_output_sync_blk;
    wire [3:0] proc_dep_vld_vec_15;
    reg [3:0] proc_dep_vld_vec_15_reg;
    wire [3:0] in_chan_dep_vld_vec_15;
    wire [67:0] in_chan_dep_data_vec_15;
    wire [3:0] token_in_vec_15;
    wire [3:0] out_chan_dep_vld_vec_15;
    wire [16:0] out_chan_dep_data_15;
    wire [3:0] token_out_vec_15;
    wire dl_detect_out_15;
    wire dep_chan_vld_4_15;
    wire [16:0] dep_chan_data_4_15;
    wire token_4_15;
    wire dep_chan_vld_9_15;
    wire [16:0] dep_chan_data_9_15;
    wire token_9_15;
    wire dep_chan_vld_12_15;
    wire [16:0] dep_chan_data_12_15;
    wire token_12_15;
    wire dep_chan_vld_16_15;
    wire [16:0] dep_chan_data_16_15;
    wire token_16_15;
    wire [3:0] proc_16_data_FIFO_blk;
    wire [3:0] proc_16_data_PIPO_blk;
    wire [3:0] proc_16_start_FIFO_blk;
    wire [3:0] proc_16_TLF_FIFO_blk;
    wire [3:0] proc_16_input_sync_blk;
    wire [3:0] proc_16_output_sync_blk;
    wire [3:0] proc_dep_vld_vec_16;
    reg [3:0] proc_dep_vld_vec_16_reg;
    wire [3:0] in_chan_dep_vld_vec_16;
    wire [67:0] in_chan_dep_data_vec_16;
    wire [3:0] token_in_vec_16;
    wire [3:0] out_chan_dep_vld_vec_16;
    wire [16:0] out_chan_dep_data_16;
    wire [3:0] token_out_vec_16;
    wire dl_detect_out_16;
    wire dep_chan_vld_4_16;
    wire [16:0] dep_chan_data_4_16;
    wire token_4_16;
    wire dep_chan_vld_9_16;
    wire [16:0] dep_chan_data_9_16;
    wire token_9_16;
    wire dep_chan_vld_14_16;
    wire [16:0] dep_chan_data_14_16;
    wire token_14_16;
    wire dep_chan_vld_15_16;
    wire [16:0] dep_chan_data_15_16;
    wire token_15_16;
    wire [16:0] dl_in_vec;
    wire dl_detect_out;
    wire token_clear;
    wire [16:0] origin;

    reg ap_done_reg_0;// for module AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_histogram_pixels_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_0 <= 'b0;
        end
        else begin
            ap_done_reg_0 <= AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_histogram_pixels_U0.ap_done & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_histogram_pixels_U0.ap_continue;
        end
    end

    reg ap_done_reg_1;// for module AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_color_stage_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_1 <= 'b0;
        end
        else begin
            ap_done_reg_1 <= AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_color_stage_U0.ap_done & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_color_stage_U0.ap_continue;
        end
    end

    reg ap_done_reg_2;// for module AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_2 <= 'b0;
        end
        else begin
            ap_done_reg_2 <= AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0.ap_done & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0.ap_continue;
        end
    end

    reg ap_done_reg_3;// for module AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_pack_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_3 <= 'b0;
        end
        else begin
            ap_done_reg_3 <= AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_pack_U0.ap_done & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_pack_U0.ap_continue;
        end
    end

    reg ap_done_reg_4;// for module AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_pack_3_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_4 <= 'b0;
        end
        else begin
            ap_done_reg_4 <= AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_pack_3_U0.ap_done & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_pack_3_U0.ap_continue;
        end
    end

    reg ap_done_reg_5;// for module AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_collect_or_drain_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_5 <= 'b0;
        end
        else begin
            ap_done_reg_5 <= AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_collect_or_drain_U0.ap_done & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_collect_or_drain_U0.ap_continue;
        end
    end

    reg ap_done_reg_6;// for module AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_write_words_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_6 <= 'b0;
        end
        else begin
            ap_done_reg_6 <= AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_write_words_U0.ap_done & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_write_words_U0.ap_continue;
        end
    end

    reg ap_done_reg_7;// for module AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_write_words_4_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_7 <= 'b0;
        end
        else begin
            ap_done_reg_7 <= AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_write_words_4_U0.ap_done & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_write_words_4_U0.ap_continue;
        end
    end

reg [15:0] trans_in_cnt_0;// for process AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_read_words_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_0 <= 16'h0;
    end
    else if (AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_read_words_U0.start_write == 1'b1) begin
        trans_in_cnt_0 <= trans_in_cnt_0 + 16'h1;
    end
    else begin
        trans_in_cnt_0 <= trans_in_cnt_0;
    end
end

reg [15:0] trans_out_cnt_0;// for process AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_read_words_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_0 <= 16'h0;
    end
    else if (AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_read_words_U0.ap_done == 1'b1 && AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_read_words_U0.ap_continue == 1'b1) begin
        trans_out_cnt_0 <= trans_out_cnt_0 + 16'h1;
    end
    else begin
        trans_out_cnt_0 <= trans_out_cnt_0;
    end
end

reg [15:0] trans_in_cnt_1;// for process AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_read_words_1_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_1 <= 16'h0;
    end
    else if (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_read_words_1_U0.start_write == 1'b1) begin
        trans_in_cnt_1 <= trans_in_cnt_1 + 16'h1;
    end
    else begin
        trans_in_cnt_1 <= trans_in_cnt_1;
    end
end

reg [15:0] trans_out_cnt_1;// for process AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_read_words_1_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_1 <= 16'h0;
    end
    else if (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_read_words_1_U0.ap_done == 1'b1 && AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_read_words_1_U0.ap_continue == 1'b1) begin
        trans_out_cnt_1 <= trans_out_cnt_1 + 16'h1;
    end
    else begin
        trans_out_cnt_1 <= trans_out_cnt_1;
    end
end

reg [15:0] trans_in_cnt_2;// for process AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.entry_proc_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_in_cnt_2 <= 16'h0;
    end
    else if (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.entry_proc_U0.start_write == 1'b1) begin
        trans_in_cnt_2 <= trans_in_cnt_2 + 16'h1;
    end
    else begin
        trans_in_cnt_2 <= trans_in_cnt_2;
    end
end

reg [15:0] trans_out_cnt_2;// for process AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.entry_proc_U0
always @(negedge dl_reset or posedge dl_clock) begin
    if (~dl_reset) begin
         trans_out_cnt_2 <= 16'h0;
    end
    else if (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.entry_proc_U0.ap_done == 1'b1 && AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.entry_proc_U0.ap_continue == 1'b1) begin
        trans_out_cnt_2 <= trans_out_cnt_2 + 16'h1;
    end
    else begin
        trans_out_cnt_2 <= trans_out_cnt_2;
    end
end

    // Process: AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_read_words_U0
    AESL_deadlock_detect_unit #(17, 0, 3, 3) AESL_deadlock_detect_unit_0 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_0),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_0),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_0),
        .token_in_vec(token_in_vec_0),
        .dl_detect_in(dl_detect_out),
        .origin(origin[0]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_0),
        .out_chan_dep_data(out_chan_dep_data_0),
        .token_out_vec(token_out_vec_0),
        .dl_detect_out(dl_in_vec[0]));

    assign proc_0_data_FIFO_blk[0] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_read_words_U0.grp_p_anonymous_namespace_read_words_Pipeline_VITIS_LOOP_145_2_fu_146.words1_blk_n) | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_read_words_U0.width_c_blk_n) | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_read_words_U0.height_c_blk_n);
    assign proc_0_data_PIPO_blk[0] = 1'b0;
    assign proc_0_start_FIFO_blk[0] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.start_for_p_anonymous_namespace_unpack_U0_U.if_full_n & AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_read_words_U0.ap_start & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_read_words_U0.real_start & (trans_in_cnt_0 == trans_out_cnt_0) & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.start_for_p_anonymous_namespace_unpack_U0_U.if_read);
    assign proc_0_TLF_FIFO_blk[0] = 1'b0;
    assign proc_0_input_sync_blk[0] = 1'b0;
    assign proc_0_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_0[0] = dl_detect_out ? proc_dep_vld_vec_0_reg[0] : (proc_0_data_FIFO_blk[0] | proc_0_data_PIPO_blk[0] | proc_0_start_FIFO_blk[0] | proc_0_TLF_FIFO_blk[0] | proc_0_input_sync_blk[0] | proc_0_output_sync_blk[0]);
    assign proc_0_data_FIFO_blk[1] = 1'b0;
    assign proc_0_data_PIPO_blk[1] = 1'b0;
    assign proc_0_start_FIFO_blk[1] = 1'b0;
    assign proc_0_TLF_FIFO_blk[1] = 1'b0;
    assign proc_0_input_sync_blk[1] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.ap_sync_p_anonymous_namespace_read_words_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_read_words_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.ap_sync_p_anonymous_namespace_statistics_pass_Block_entry36_proc_U0_ap_ready);
    assign proc_0_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_0[1] = dl_detect_out ? proc_dep_vld_vec_0_reg[1] : (proc_0_data_FIFO_blk[1] | proc_0_data_PIPO_blk[1] | proc_0_start_FIFO_blk[1] | proc_0_TLF_FIFO_blk[1] | proc_0_input_sync_blk[1] | proc_0_output_sync_blk[1]);
    assign proc_0_data_FIFO_blk[2] = 1'b0;
    assign proc_0_data_PIPO_blk[2] = 1'b0;
    assign proc_0_start_FIFO_blk[2] = 1'b0;
    assign proc_0_TLF_FIFO_blk[2] = 1'b0;
    assign proc_0_input_sync_blk[2] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.ap_sync_p_anonymous_namespace_read_words_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_read_words_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.ap_sync_p_anonymous_namespace_histogram_pixels_U0_ap_ready);
    assign proc_0_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_0[2] = dl_detect_out ? proc_dep_vld_vec_0_reg[2] : (proc_0_data_FIFO_blk[2] | proc_0_data_PIPO_blk[2] | proc_0_start_FIFO_blk[2] | proc_0_TLF_FIFO_blk[2] | proc_0_input_sync_blk[2] | proc_0_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_0_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_0_reg <= proc_dep_vld_vec_0;
        end
    end
    assign in_chan_dep_vld_vec_0[0] = dep_chan_vld_1_0;
    assign in_chan_dep_data_vec_0[16 : 0] = dep_chan_data_1_0;
    assign token_in_vec_0[0] = token_1_0;
    assign in_chan_dep_vld_vec_0[1] = dep_chan_vld_2_0;
    assign in_chan_dep_data_vec_0[33 : 17] = dep_chan_data_2_0;
    assign token_in_vec_0[1] = token_2_0;
    assign in_chan_dep_vld_vec_0[2] = dep_chan_vld_3_0;
    assign in_chan_dep_data_vec_0[50 : 34] = dep_chan_data_3_0;
    assign token_in_vec_0[2] = token_3_0;
    assign dep_chan_vld_0_1 = out_chan_dep_vld_vec_0[0];
    assign dep_chan_data_0_1 = out_chan_dep_data_0;
    assign token_0_1 = token_out_vec_0[0];
    assign dep_chan_vld_0_2 = out_chan_dep_vld_vec_0[1];
    assign dep_chan_data_0_2 = out_chan_dep_data_0;
    assign token_0_2 = token_out_vec_0[1];
    assign dep_chan_vld_0_3 = out_chan_dep_vld_vec_0[2];
    assign dep_chan_data_0_3 = out_chan_dep_data_0;
    assign token_0_3 = token_out_vec_0[2];

    // Process: AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_unpack_U0
    AESL_deadlock_detect_unit #(17, 1, 2, 2) AESL_deadlock_detect_unit_1 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_1),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_1),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_1),
        .token_in_vec(token_in_vec_1),
        .dl_detect_in(dl_detect_out),
        .origin(origin[1]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_1),
        .out_chan_dep_data(out_chan_dep_data_1),
        .token_out_vec(token_out_vec_1),
        .dl_detect_out(dl_in_vec[1]));

    assign proc_1_data_FIFO_blk[0] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_unpack_U0.grp_p_anonymous_namespace_unpack_Pipeline_VITIS_LOOP_156_1_VITIS_LOOP_160_2_fu_46.words1_blk_n) | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_unpack_U0.width_blk_n) | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_unpack_U0.height_blk_n);
    assign proc_1_data_PIPO_blk[0] = 1'b0;
    assign proc_1_start_FIFO_blk[0] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.start_for_p_anonymous_namespace_unpack_U0_U.if_empty_n & AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_unpack_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.start_for_p_anonymous_namespace_unpack_U0_U.if_write);
    assign proc_1_TLF_FIFO_blk[0] = 1'b0;
    assign proc_1_input_sync_blk[0] = 1'b0;
    assign proc_1_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_1[0] = dl_detect_out ? proc_dep_vld_vec_1_reg[0] : (proc_1_data_FIFO_blk[0] | proc_1_data_PIPO_blk[0] | proc_1_start_FIFO_blk[0] | proc_1_TLF_FIFO_blk[0] | proc_1_input_sync_blk[0] | proc_1_output_sync_blk[0]);
    assign proc_1_data_FIFO_blk[1] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_unpack_U0.grp_p_anonymous_namespace_unpack_Pipeline_VITIS_LOOP_156_1_VITIS_LOOP_160_2_fu_46.pixels2_blk_n);
    assign proc_1_data_PIPO_blk[1] = 1'b0;
    assign proc_1_start_FIFO_blk[1] = 1'b0;
    assign proc_1_TLF_FIFO_blk[1] = 1'b0;
    assign proc_1_input_sync_blk[1] = 1'b0;
    assign proc_1_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_1[1] = dl_detect_out ? proc_dep_vld_vec_1_reg[1] : (proc_1_data_FIFO_blk[1] | proc_1_data_PIPO_blk[1] | proc_1_start_FIFO_blk[1] | proc_1_TLF_FIFO_blk[1] | proc_1_input_sync_blk[1] | proc_1_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_1_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_1_reg <= proc_dep_vld_vec_1;
        end
    end
    assign in_chan_dep_vld_vec_1[0] = dep_chan_vld_0_1;
    assign in_chan_dep_data_vec_1[16 : 0] = dep_chan_data_0_1;
    assign token_in_vec_1[0] = token_0_1;
    assign in_chan_dep_vld_vec_1[1] = dep_chan_vld_3_1;
    assign in_chan_dep_data_vec_1[33 : 17] = dep_chan_data_3_1;
    assign token_in_vec_1[1] = token_3_1;
    assign dep_chan_vld_1_0 = out_chan_dep_vld_vec_1[0];
    assign dep_chan_data_1_0 = out_chan_dep_data_1;
    assign token_1_0 = token_out_vec_1[0];
    assign dep_chan_vld_1_3 = out_chan_dep_vld_vec_1[1];
    assign dep_chan_data_1_3 = out_chan_dep_data_1;
    assign token_1_3 = token_out_vec_1[1];

    // Process: AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_statistics_pass_Block_entry36_proc_U0
    AESL_deadlock_detect_unit #(17, 2, 2, 2) AESL_deadlock_detect_unit_2 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_2),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_2),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_2),
        .token_in_vec(token_in_vec_2),
        .dl_detect_in(dl_detect_out),
        .origin(origin[2]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_2),
        .out_chan_dep_data(out_chan_dep_data_2),
        .token_out_vec(token_out_vec_2),
        .dl_detect_out(dl_in_vec[2]));

    assign proc_2_data_FIFO_blk[0] = 1'b0;
    assign proc_2_data_PIPO_blk[0] = 1'b0;
    assign proc_2_start_FIFO_blk[0] = 1'b0;
    assign proc_2_TLF_FIFO_blk[0] = 1'b0;
    assign proc_2_input_sync_blk[0] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.ap_sync_p_anonymous_namespace_statistics_pass_Block_entry36_proc_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_statistics_pass_Block_entry36_proc_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.ap_sync_p_anonymous_namespace_read_words_U0_ap_ready);
    assign proc_2_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_2[0] = dl_detect_out ? proc_dep_vld_vec_2_reg[0] : (proc_2_data_FIFO_blk[0] | proc_2_data_PIPO_blk[0] | proc_2_start_FIFO_blk[0] | proc_2_TLF_FIFO_blk[0] | proc_2_input_sync_blk[0] | proc_2_output_sync_blk[0]);
    assign proc_2_data_FIFO_blk[1] = 1'b0;
    assign proc_2_data_PIPO_blk[1] = 1'b0;
    assign proc_2_start_FIFO_blk[1] = 1'b0;
    assign proc_2_TLF_FIFO_blk[1] = 1'b0;
    assign proc_2_input_sync_blk[1] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.ap_sync_p_anonymous_namespace_statistics_pass_Block_entry36_proc_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_statistics_pass_Block_entry36_proc_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.ap_sync_p_anonymous_namespace_histogram_pixels_U0_ap_ready);
    assign proc_2_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_2[1] = dl_detect_out ? proc_dep_vld_vec_2_reg[1] : (proc_2_data_FIFO_blk[1] | proc_2_data_PIPO_blk[1] | proc_2_start_FIFO_blk[1] | proc_2_TLF_FIFO_blk[1] | proc_2_input_sync_blk[1] | proc_2_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_2_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_2_reg <= proc_dep_vld_vec_2;
        end
    end
    assign in_chan_dep_vld_vec_2[0] = dep_chan_vld_0_2;
    assign in_chan_dep_data_vec_2[16 : 0] = dep_chan_data_0_2;
    assign token_in_vec_2[0] = token_0_2;
    assign in_chan_dep_vld_vec_2[1] = dep_chan_vld_3_2;
    assign in_chan_dep_data_vec_2[33 : 17] = dep_chan_data_3_2;
    assign token_in_vec_2[1] = token_3_2;
    assign dep_chan_vld_2_0 = out_chan_dep_vld_vec_2[0];
    assign dep_chan_data_2_0 = out_chan_dep_data_2;
    assign token_2_0 = token_out_vec_2[0];
    assign dep_chan_vld_2_3 = out_chan_dep_vld_vec_2[1];
    assign dep_chan_data_2_3 = out_chan_dep_data_2;
    assign token_2_3 = token_out_vec_2[1];

    // Process: AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_histogram_pixels_U0
    AESL_deadlock_detect_unit #(17, 3, 3, 3) AESL_deadlock_detect_unit_3 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_3),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_3),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_3),
        .token_in_vec(token_in_vec_3),
        .dl_detect_in(dl_detect_out),
        .origin(origin[3]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_3),
        .out_chan_dep_data(out_chan_dep_data_3),
        .token_out_vec(token_out_vec_3),
        .dl_detect_out(dl_in_vec[3]));

    assign proc_3_data_FIFO_blk[0] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_histogram_pixels_U0.pixels_blk_n);
    assign proc_3_data_PIPO_blk[0] = 1'b0;
    assign proc_3_start_FIFO_blk[0] = 1'b0;
    assign proc_3_TLF_FIFO_blk[0] = 1'b0;
    assign proc_3_input_sync_blk[0] = 1'b0;
    assign proc_3_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_3[0] = dl_detect_out ? proc_dep_vld_vec_3_reg[0] : (proc_3_data_FIFO_blk[0] | proc_3_data_PIPO_blk[0] | proc_3_start_FIFO_blk[0] | proc_3_TLF_FIFO_blk[0] | proc_3_input_sync_blk[0] | proc_3_output_sync_blk[0]);
    assign proc_3_data_FIFO_blk[1] = 1'b0;
    assign proc_3_data_PIPO_blk[1] = 1'b0;
    assign proc_3_start_FIFO_blk[1] = 1'b0;
    assign proc_3_TLF_FIFO_blk[1] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.tmp_U.if_empty_n & AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_histogram_pixels_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.tmp_U.if_write);
    assign proc_3_input_sync_blk[1] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.ap_sync_p_anonymous_namespace_histogram_pixels_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_histogram_pixels_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.ap_sync_p_anonymous_namespace_statistics_pass_Block_entry36_proc_U0_ap_ready);
    assign proc_3_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_3[1] = dl_detect_out ? proc_dep_vld_vec_3_reg[1] : (proc_3_data_FIFO_blk[1] | proc_3_data_PIPO_blk[1] | proc_3_start_FIFO_blk[1] | proc_3_TLF_FIFO_blk[1] | proc_3_input_sync_blk[1] | proc_3_output_sync_blk[1]);
    assign proc_3_data_FIFO_blk[2] = 1'b0;
    assign proc_3_data_PIPO_blk[2] = 1'b0;
    assign proc_3_start_FIFO_blk[2] = 1'b0;
    assign proc_3_TLF_FIFO_blk[2] = 1'b0;
    assign proc_3_input_sync_blk[2] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.ap_sync_p_anonymous_namespace_histogram_pixels_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.p_anonymous_namespace_histogram_pixels_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_statistics_pass_fu_594.ap_sync_p_anonymous_namespace_read_words_U0_ap_ready);
    assign proc_3_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_3[2] = dl_detect_out ? proc_dep_vld_vec_3_reg[2] : (proc_3_data_FIFO_blk[2] | proc_3_data_PIPO_blk[2] | proc_3_start_FIFO_blk[2] | proc_3_TLF_FIFO_blk[2] | proc_3_input_sync_blk[2] | proc_3_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_3_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_3_reg <= proc_dep_vld_vec_3;
        end
    end
    assign in_chan_dep_vld_vec_3[0] = dep_chan_vld_0_3;
    assign in_chan_dep_data_vec_3[16 : 0] = dep_chan_data_0_3;
    assign token_in_vec_3[0] = token_0_3;
    assign in_chan_dep_vld_vec_3[1] = dep_chan_vld_1_3;
    assign in_chan_dep_data_vec_3[33 : 17] = dep_chan_data_1_3;
    assign token_in_vec_3[1] = token_1_3;
    assign in_chan_dep_vld_vec_3[2] = dep_chan_vld_2_3;
    assign in_chan_dep_data_vec_3[50 : 34] = dep_chan_data_2_3;
    assign token_in_vec_3[2] = token_2_3;
    assign dep_chan_vld_3_1 = out_chan_dep_vld_vec_3[0];
    assign dep_chan_data_3_1 = out_chan_dep_data_3;
    assign token_3_1 = token_out_vec_3[0];
    assign dep_chan_vld_3_2 = out_chan_dep_vld_vec_3[1];
    assign dep_chan_data_3_2 = out_chan_dep_data_3;
    assign token_3_2 = token_out_vec_3[1];
    assign dep_chan_vld_3_0 = out_chan_dep_vld_vec_3[2];
    assign dep_chan_data_3_0 = out_chan_dep_data_3;
    assign token_3_0 = token_out_vec_3[2];

    // Process: AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.entry_proc_U0
    AESL_deadlock_detect_unit #(17, 4, 9, 9) AESL_deadlock_detect_unit_4 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_4),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_4),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_4),
        .token_in_vec(token_in_vec_4),
        .dl_detect_in(dl_detect_out),
        .origin(origin[4]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_4),
        .out_chan_dep_data(out_chan_dep_data_4),
        .token_out_vec(token_out_vec_4),
        .dl_detect_out(dl_in_vec[4]));

    assign proc_4_data_FIFO_blk[0] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.entry_proc_U0.tensor_c_blk_n);
    assign proc_4_data_PIPO_blk[0] = 1'b0;
    assign proc_4_start_FIFO_blk[0] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.start_for_p_anonymous_namespace_write_words_U0_U.if_full_n & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.entry_proc_U0.ap_start & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.entry_proc_U0.real_start & (trans_in_cnt_2 == trans_out_cnt_2) & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.start_for_p_anonymous_namespace_write_words_U0_U.if_read);
    assign proc_4_TLF_FIFO_blk[0] = 1'b0;
    assign proc_4_input_sync_blk[0] = 1'b0;
    assign proc_4_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_4[0] = dl_detect_out ? proc_dep_vld_vec_4_reg[0] : (proc_4_data_FIFO_blk[0] | proc_4_data_PIPO_blk[0] | proc_4_start_FIFO_blk[0] | proc_4_TLF_FIFO_blk[0] | proc_4_input_sync_blk[0] | proc_4_output_sync_blk[0]);
    assign proc_4_data_FIFO_blk[1] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.entry_proc_U0.preview_c_blk_n) | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.entry_proc_U0.preview_stride_c_blk_n);
    assign proc_4_data_PIPO_blk[1] = 1'b0;
    assign proc_4_start_FIFO_blk[1] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.start_for_p_anonymous_namespace_write_words_4_U0_U.if_full_n & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.entry_proc_U0.ap_start & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.entry_proc_U0.real_start & (trans_in_cnt_2 == trans_out_cnt_2) & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.start_for_p_anonymous_namespace_write_words_4_U0_U.if_read);
    assign proc_4_TLF_FIFO_blk[1] = 1'b0;
    assign proc_4_input_sync_blk[1] = 1'b0;
    assign proc_4_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_4[1] = dl_detect_out ? proc_dep_vld_vec_4_reg[1] : (proc_4_data_FIFO_blk[1] | proc_4_data_PIPO_blk[1] | proc_4_start_FIFO_blk[1] | proc_4_TLF_FIFO_blk[1] | proc_4_input_sync_blk[1] | proc_4_output_sync_blk[1]);
    assign proc_4_data_FIFO_blk[2] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.entry_proc_U0.collect_c_blk_n);
    assign proc_4_data_PIPO_blk[2] = 1'b0;
    assign proc_4_start_FIFO_blk[2] = 1'b0;
    assign proc_4_TLF_FIFO_blk[2] = 1'b0;
    assign proc_4_input_sync_blk[2] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_entry_proc_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.entry_proc_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_collect_or_drain_U0_ap_ready);
    assign proc_4_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_4[2] = dl_detect_out ? proc_dep_vld_vec_4_reg[2] : (proc_4_data_FIFO_blk[2] | proc_4_data_PIPO_blk[2] | proc_4_start_FIFO_blk[2] | proc_4_TLF_FIFO_blk[2] | proc_4_input_sync_blk[2] | proc_4_output_sync_blk[2]);
    assign proc_4_data_FIFO_blk[3] = 1'b0;
    assign proc_4_data_PIPO_blk[3] = 1'b0;
    assign proc_4_start_FIFO_blk[3] = 1'b0;
    assign proc_4_TLF_FIFO_blk[3] = 1'b0;
    assign proc_4_input_sync_blk[3] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_entry_proc_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.entry_proc_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_read_words_1_U0_ap_ready);
    assign proc_4_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_4[3] = dl_detect_out ? proc_dep_vld_vec_4_reg[3] : (proc_4_data_FIFO_blk[3] | proc_4_data_PIPO_blk[3] | proc_4_start_FIFO_blk[3] | proc_4_TLF_FIFO_blk[3] | proc_4_input_sync_blk[3] | proc_4_output_sync_blk[3]);
    assign proc_4_data_FIFO_blk[4] = 1'b0;
    assign proc_4_data_PIPO_blk[4] = 1'b0;
    assign proc_4_start_FIFO_blk[4] = 1'b0;
    assign proc_4_TLF_FIFO_blk[4] = 1'b0;
    assign proc_4_input_sync_blk[4] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_entry_proc_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.entry_proc_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry47_proc_U0_ap_ready);
    assign proc_4_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_4[4] = dl_detect_out ? proc_dep_vld_vec_4_reg[4] : (proc_4_data_FIFO_blk[4] | proc_4_data_PIPO_blk[4] | proc_4_start_FIFO_blk[4] | proc_4_TLF_FIFO_blk[4] | proc_4_input_sync_blk[4] | proc_4_output_sync_blk[4]);
    assign proc_4_data_FIFO_blk[5] = 1'b0;
    assign proc_4_data_PIPO_blk[5] = 1'b0;
    assign proc_4_start_FIFO_blk[5] = 1'b0;
    assign proc_4_TLF_FIFO_blk[5] = 1'b0;
    assign proc_4_input_sync_blk[5] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_entry_proc_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.entry_proc_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_color_stage_U0_ap_ready);
    assign proc_4_output_sync_blk[5] = 1'b0;
    assign proc_dep_vld_vec_4[5] = dl_detect_out ? proc_dep_vld_vec_4_reg[5] : (proc_4_data_FIFO_blk[5] | proc_4_data_PIPO_blk[5] | proc_4_start_FIFO_blk[5] | proc_4_TLF_FIFO_blk[5] | proc_4_input_sync_blk[5] | proc_4_output_sync_blk[5]);
    assign proc_4_data_FIFO_blk[6] = 1'b0;
    assign proc_4_data_PIPO_blk[6] = 1'b0;
    assign proc_4_start_FIFO_blk[6] = 1'b0;
    assign proc_4_TLF_FIFO_blk[6] = 1'b0;
    assign proc_4_input_sync_blk[6] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_entry_proc_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.entry_proc_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_resize_and_split_U0_ap_ready);
    assign proc_4_output_sync_blk[6] = 1'b0;
    assign proc_dep_vld_vec_4[6] = dl_detect_out ? proc_dep_vld_vec_4_reg[6] : (proc_4_data_FIFO_blk[6] | proc_4_data_PIPO_blk[6] | proc_4_start_FIFO_blk[6] | proc_4_TLF_FIFO_blk[6] | proc_4_input_sync_blk[6] | proc_4_output_sync_blk[6]);
    assign proc_4_data_FIFO_blk[7] = 1'b0;
    assign proc_4_data_PIPO_blk[7] = 1'b0;
    assign proc_4_start_FIFO_blk[7] = 1'b0;
    assign proc_4_TLF_FIFO_blk[7] = 1'b0;
    assign proc_4_input_sync_blk[7] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_entry_proc_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.entry_proc_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry412_proc_U0_ap_ready);
    assign proc_4_output_sync_blk[7] = 1'b0;
    assign proc_dep_vld_vec_4[7] = dl_detect_out ? proc_dep_vld_vec_4_reg[7] : (proc_4_data_FIFO_blk[7] | proc_4_data_PIPO_blk[7] | proc_4_start_FIFO_blk[7] | proc_4_TLF_FIFO_blk[7] | proc_4_input_sync_blk[7] | proc_4_output_sync_blk[7]);
    assign proc_4_data_FIFO_blk[8] = 1'b0;
    assign proc_4_data_PIPO_blk[8] = 1'b0;
    assign proc_4_start_FIFO_blk[8] = 1'b0;
    assign proc_4_TLF_FIFO_blk[8] = 1'b0;
    assign proc_4_input_sync_blk[8] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_entry_proc_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.entry_proc_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry414_proc_U0_ap_ready);
    assign proc_4_output_sync_blk[8] = 1'b0;
    assign proc_dep_vld_vec_4[8] = dl_detect_out ? proc_dep_vld_vec_4_reg[8] : (proc_4_data_FIFO_blk[8] | proc_4_data_PIPO_blk[8] | proc_4_start_FIFO_blk[8] | proc_4_TLF_FIFO_blk[8] | proc_4_input_sync_blk[8] | proc_4_output_sync_blk[8]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_4_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_4_reg <= proc_dep_vld_vec_4;
        end
    end
    assign in_chan_dep_vld_vec_4[0] = dep_chan_vld_5_4;
    assign in_chan_dep_data_vec_4[16 : 0] = dep_chan_data_5_4;
    assign token_in_vec_4[0] = token_5_4;
    assign in_chan_dep_vld_vec_4[1] = dep_chan_vld_7_4;
    assign in_chan_dep_data_vec_4[33 : 17] = dep_chan_data_7_4;
    assign token_in_vec_4[1] = token_7_4;
    assign in_chan_dep_vld_vec_4[2] = dep_chan_vld_8_4;
    assign in_chan_dep_data_vec_4[50 : 34] = dep_chan_data_8_4;
    assign token_in_vec_4[2] = token_8_4;
    assign in_chan_dep_vld_vec_4[3] = dep_chan_vld_9_4;
    assign in_chan_dep_data_vec_4[67 : 51] = dep_chan_data_9_4;
    assign token_in_vec_4[3] = token_9_4;
    assign in_chan_dep_vld_vec_4[4] = dep_chan_vld_10_4;
    assign in_chan_dep_data_vec_4[84 : 68] = dep_chan_data_10_4;
    assign token_in_vec_4[4] = token_10_4;
    assign in_chan_dep_vld_vec_4[5] = dep_chan_vld_11_4;
    assign in_chan_dep_data_vec_4[101 : 85] = dep_chan_data_11_4;
    assign token_in_vec_4[5] = token_11_4;
    assign in_chan_dep_vld_vec_4[6] = dep_chan_vld_13_4;
    assign in_chan_dep_data_vec_4[118 : 102] = dep_chan_data_13_4;
    assign token_in_vec_4[6] = token_13_4;
    assign in_chan_dep_vld_vec_4[7] = dep_chan_vld_15_4;
    assign in_chan_dep_data_vec_4[135 : 119] = dep_chan_data_15_4;
    assign token_in_vec_4[7] = token_15_4;
    assign in_chan_dep_vld_vec_4[8] = dep_chan_vld_16_4;
    assign in_chan_dep_data_vec_4[152 : 136] = dep_chan_data_16_4;
    assign token_in_vec_4[8] = token_16_4;
    assign dep_chan_vld_4_15 = out_chan_dep_vld_vec_4[0];
    assign dep_chan_data_4_15 = out_chan_dep_data_4;
    assign token_4_15 = token_out_vec_4[0];
    assign dep_chan_vld_4_16 = out_chan_dep_vld_vec_4[1];
    assign dep_chan_data_4_16 = out_chan_dep_data_4;
    assign token_4_16 = token_out_vec_4[1];
    assign dep_chan_vld_4_9 = out_chan_dep_vld_vec_4[2];
    assign dep_chan_data_4_9 = out_chan_dep_data_4;
    assign token_4_9 = token_out_vec_4[2];
    assign dep_chan_vld_4_5 = out_chan_dep_vld_vec_4[3];
    assign dep_chan_data_4_5 = out_chan_dep_data_4;
    assign token_4_5 = token_out_vec_4[3];
    assign dep_chan_vld_4_7 = out_chan_dep_vld_vec_4[4];
    assign dep_chan_data_4_7 = out_chan_dep_data_4;
    assign token_4_7 = token_out_vec_4[4];
    assign dep_chan_vld_4_8 = out_chan_dep_vld_vec_4[5];
    assign dep_chan_data_4_8 = out_chan_dep_data_4;
    assign token_4_8 = token_out_vec_4[5];
    assign dep_chan_vld_4_10 = out_chan_dep_vld_vec_4[6];
    assign dep_chan_data_4_10 = out_chan_dep_data_4;
    assign token_4_10 = token_out_vec_4[6];
    assign dep_chan_vld_4_11 = out_chan_dep_vld_vec_4[7];
    assign dep_chan_data_4_11 = out_chan_dep_data_4;
    assign token_4_11 = token_out_vec_4[7];
    assign dep_chan_vld_4_13 = out_chan_dep_vld_vec_4[8];
    assign dep_chan_data_4_13 = out_chan_dep_data_4;
    assign token_4_13 = token_out_vec_4[8];

    // Process: AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_read_words_1_U0
    AESL_deadlock_detect_unit #(17, 5, 8, 8) AESL_deadlock_detect_unit_5 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_5),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_5),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_5),
        .token_in_vec(token_in_vec_5),
        .dl_detect_in(dl_detect_out),
        .origin(origin[5]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_5),
        .out_chan_dep_data(out_chan_dep_data_5),
        .token_out_vec(token_out_vec_5),
        .dl_detect_out(dl_in_vec[5]));

    assign proc_5_data_FIFO_blk[0] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_read_words_1_U0.grp_p_anonymous_namespace_read_words_1_Pipeline_VITIS_LOOP_145_2_fu_146.in_words1_blk_n) | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_read_words_1_U0.width_c31_blk_n) | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_read_words_1_U0.height_c33_blk_n);
    assign proc_5_data_PIPO_blk[0] = 1'b0;
    assign proc_5_start_FIFO_blk[0] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.start_for_p_anonymous_namespace_unpack_2_U0_U.if_full_n & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_read_words_1_U0.ap_start & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_read_words_1_U0.real_start & (trans_in_cnt_1 == trans_out_cnt_1) & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.start_for_p_anonymous_namespace_unpack_2_U0_U.if_read);
    assign proc_5_TLF_FIFO_blk[0] = 1'b0;
    assign proc_5_input_sync_blk[0] = 1'b0;
    assign proc_5_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_5[0] = dl_detect_out ? proc_dep_vld_vec_5_reg[0] : (proc_5_data_FIFO_blk[0] | proc_5_data_PIPO_blk[0] | proc_5_start_FIFO_blk[0] | proc_5_TLF_FIFO_blk[0] | proc_5_input_sync_blk[0] | proc_5_output_sync_blk[0]);
    assign proc_5_data_FIFO_blk[1] = 1'b0;
    assign proc_5_data_PIPO_blk[1] = 1'b0;
    assign proc_5_start_FIFO_blk[1] = 1'b0;
    assign proc_5_TLF_FIFO_blk[1] = 1'b0;
    assign proc_5_input_sync_blk[1] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_read_words_1_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_read_words_1_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_entry_proc_U0_ap_ready);
    assign proc_5_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_5[1] = dl_detect_out ? proc_dep_vld_vec_5_reg[1] : (proc_5_data_FIFO_blk[1] | proc_5_data_PIPO_blk[1] | proc_5_start_FIFO_blk[1] | proc_5_TLF_FIFO_blk[1] | proc_5_input_sync_blk[1] | proc_5_output_sync_blk[1]);
    assign proc_5_data_FIFO_blk[2] = 1'b0;
    assign proc_5_data_PIPO_blk[2] = 1'b0;
    assign proc_5_start_FIFO_blk[2] = 1'b0;
    assign proc_5_TLF_FIFO_blk[2] = 1'b0;
    assign proc_5_input_sync_blk[2] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_read_words_1_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_read_words_1_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry47_proc_U0_ap_ready);
    assign proc_5_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_5[2] = dl_detect_out ? proc_dep_vld_vec_5_reg[2] : (proc_5_data_FIFO_blk[2] | proc_5_data_PIPO_blk[2] | proc_5_start_FIFO_blk[2] | proc_5_TLF_FIFO_blk[2] | proc_5_input_sync_blk[2] | proc_5_output_sync_blk[2]);
    assign proc_5_data_FIFO_blk[3] = 1'b0;
    assign proc_5_data_PIPO_blk[3] = 1'b0;
    assign proc_5_start_FIFO_blk[3] = 1'b0;
    assign proc_5_TLF_FIFO_blk[3] = 1'b0;
    assign proc_5_input_sync_blk[3] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_read_words_1_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_read_words_1_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_color_stage_U0_ap_ready);
    assign proc_5_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_5[3] = dl_detect_out ? proc_dep_vld_vec_5_reg[3] : (proc_5_data_FIFO_blk[3] | proc_5_data_PIPO_blk[3] | proc_5_start_FIFO_blk[3] | proc_5_TLF_FIFO_blk[3] | proc_5_input_sync_blk[3] | proc_5_output_sync_blk[3]);
    assign proc_5_data_FIFO_blk[4] = 1'b0;
    assign proc_5_data_PIPO_blk[4] = 1'b0;
    assign proc_5_start_FIFO_blk[4] = 1'b0;
    assign proc_5_TLF_FIFO_blk[4] = 1'b0;
    assign proc_5_input_sync_blk[4] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_read_words_1_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_read_words_1_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_collect_or_drain_U0_ap_ready);
    assign proc_5_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_5[4] = dl_detect_out ? proc_dep_vld_vec_5_reg[4] : (proc_5_data_FIFO_blk[4] | proc_5_data_PIPO_blk[4] | proc_5_start_FIFO_blk[4] | proc_5_TLF_FIFO_blk[4] | proc_5_input_sync_blk[4] | proc_5_output_sync_blk[4]);
    assign proc_5_data_FIFO_blk[5] = 1'b0;
    assign proc_5_data_PIPO_blk[5] = 1'b0;
    assign proc_5_start_FIFO_blk[5] = 1'b0;
    assign proc_5_TLF_FIFO_blk[5] = 1'b0;
    assign proc_5_input_sync_blk[5] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_read_words_1_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_read_words_1_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_resize_and_split_U0_ap_ready);
    assign proc_5_output_sync_blk[5] = 1'b0;
    assign proc_dep_vld_vec_5[5] = dl_detect_out ? proc_dep_vld_vec_5_reg[5] : (proc_5_data_FIFO_blk[5] | proc_5_data_PIPO_blk[5] | proc_5_start_FIFO_blk[5] | proc_5_TLF_FIFO_blk[5] | proc_5_input_sync_blk[5] | proc_5_output_sync_blk[5]);
    assign proc_5_data_FIFO_blk[6] = 1'b0;
    assign proc_5_data_PIPO_blk[6] = 1'b0;
    assign proc_5_start_FIFO_blk[6] = 1'b0;
    assign proc_5_TLF_FIFO_blk[6] = 1'b0;
    assign proc_5_input_sync_blk[6] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_read_words_1_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_read_words_1_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry412_proc_U0_ap_ready);
    assign proc_5_output_sync_blk[6] = 1'b0;
    assign proc_dep_vld_vec_5[6] = dl_detect_out ? proc_dep_vld_vec_5_reg[6] : (proc_5_data_FIFO_blk[6] | proc_5_data_PIPO_blk[6] | proc_5_start_FIFO_blk[6] | proc_5_TLF_FIFO_blk[6] | proc_5_input_sync_blk[6] | proc_5_output_sync_blk[6]);
    assign proc_5_data_FIFO_blk[7] = 1'b0;
    assign proc_5_data_PIPO_blk[7] = 1'b0;
    assign proc_5_start_FIFO_blk[7] = 1'b0;
    assign proc_5_TLF_FIFO_blk[7] = 1'b0;
    assign proc_5_input_sync_blk[7] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_read_words_1_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_read_words_1_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry414_proc_U0_ap_ready);
    assign proc_5_output_sync_blk[7] = 1'b0;
    assign proc_dep_vld_vec_5[7] = dl_detect_out ? proc_dep_vld_vec_5_reg[7] : (proc_5_data_FIFO_blk[7] | proc_5_data_PIPO_blk[7] | proc_5_start_FIFO_blk[7] | proc_5_TLF_FIFO_blk[7] | proc_5_input_sync_blk[7] | proc_5_output_sync_blk[7]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_5_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_5_reg <= proc_dep_vld_vec_5;
        end
    end
    assign in_chan_dep_vld_vec_5[0] = dep_chan_vld_4_5;
    assign in_chan_dep_data_vec_5[16 : 0] = dep_chan_data_4_5;
    assign token_in_vec_5[0] = token_4_5;
    assign in_chan_dep_vld_vec_5[1] = dep_chan_vld_6_5;
    assign in_chan_dep_data_vec_5[33 : 17] = dep_chan_data_6_5;
    assign token_in_vec_5[1] = token_6_5;
    assign in_chan_dep_vld_vec_5[2] = dep_chan_vld_7_5;
    assign in_chan_dep_data_vec_5[50 : 34] = dep_chan_data_7_5;
    assign token_in_vec_5[2] = token_7_5;
    assign in_chan_dep_vld_vec_5[3] = dep_chan_vld_8_5;
    assign in_chan_dep_data_vec_5[67 : 51] = dep_chan_data_8_5;
    assign token_in_vec_5[3] = token_8_5;
    assign in_chan_dep_vld_vec_5[4] = dep_chan_vld_9_5;
    assign in_chan_dep_data_vec_5[84 : 68] = dep_chan_data_9_5;
    assign token_in_vec_5[4] = token_9_5;
    assign in_chan_dep_vld_vec_5[5] = dep_chan_vld_10_5;
    assign in_chan_dep_data_vec_5[101 : 85] = dep_chan_data_10_5;
    assign token_in_vec_5[5] = token_10_5;
    assign in_chan_dep_vld_vec_5[6] = dep_chan_vld_11_5;
    assign in_chan_dep_data_vec_5[118 : 102] = dep_chan_data_11_5;
    assign token_in_vec_5[6] = token_11_5;
    assign in_chan_dep_vld_vec_5[7] = dep_chan_vld_13_5;
    assign in_chan_dep_data_vec_5[135 : 119] = dep_chan_data_13_5;
    assign token_in_vec_5[7] = token_13_5;
    assign dep_chan_vld_5_6 = out_chan_dep_vld_vec_5[0];
    assign dep_chan_data_5_6 = out_chan_dep_data_5;
    assign token_5_6 = token_out_vec_5[0];
    assign dep_chan_vld_5_4 = out_chan_dep_vld_vec_5[1];
    assign dep_chan_data_5_4 = out_chan_dep_data_5;
    assign token_5_4 = token_out_vec_5[1];
    assign dep_chan_vld_5_7 = out_chan_dep_vld_vec_5[2];
    assign dep_chan_data_5_7 = out_chan_dep_data_5;
    assign token_5_7 = token_out_vec_5[2];
    assign dep_chan_vld_5_8 = out_chan_dep_vld_vec_5[3];
    assign dep_chan_data_5_8 = out_chan_dep_data_5;
    assign token_5_8 = token_out_vec_5[3];
    assign dep_chan_vld_5_9 = out_chan_dep_vld_vec_5[4];
    assign dep_chan_data_5_9 = out_chan_dep_data_5;
    assign token_5_9 = token_out_vec_5[4];
    assign dep_chan_vld_5_10 = out_chan_dep_vld_vec_5[5];
    assign dep_chan_data_5_10 = out_chan_dep_data_5;
    assign token_5_10 = token_out_vec_5[5];
    assign dep_chan_vld_5_11 = out_chan_dep_vld_vec_5[6];
    assign dep_chan_data_5_11 = out_chan_dep_data_5;
    assign token_5_11 = token_out_vec_5[6];
    assign dep_chan_vld_5_13 = out_chan_dep_vld_vec_5[7];
    assign dep_chan_data_5_13 = out_chan_dep_data_5;
    assign token_5_13 = token_out_vec_5[7];

    // Process: AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_unpack_2_U0
    AESL_deadlock_detect_unit #(17, 6, 3, 3) AESL_deadlock_detect_unit_6 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_6),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_6),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_6),
        .token_in_vec(token_in_vec_6),
        .dl_detect_in(dl_detect_out),
        .origin(origin[6]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_6),
        .out_chan_dep_data(out_chan_dep_data_6),
        .token_out_vec(token_out_vec_6),
        .dl_detect_out(dl_in_vec[6]));

    assign proc_6_data_FIFO_blk[0] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_unpack_2_U0.grp_p_anonymous_namespace_unpack_2_Pipeline_VITIS_LOOP_156_1_VITIS_LOOP_160_2_fu_68.in_words1_blk_n) | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_unpack_2_U0.width_blk_n) | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_unpack_2_U0.height_blk_n);
    assign proc_6_data_PIPO_blk[0] = 1'b0;
    assign proc_6_start_FIFO_blk[0] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.start_for_p_anonymous_namespace_unpack_2_U0_U.if_empty_n & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_unpack_2_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.start_for_p_anonymous_namespace_unpack_2_U0_U.if_write);
    assign proc_6_TLF_FIFO_blk[0] = 1'b0;
    assign proc_6_input_sync_blk[0] = 1'b0;
    assign proc_6_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_6[0] = dl_detect_out ? proc_dep_vld_vec_6_reg[0] : (proc_6_data_FIFO_blk[0] | proc_6_data_PIPO_blk[0] | proc_6_start_FIFO_blk[0] | proc_6_TLF_FIFO_blk[0] | proc_6_input_sync_blk[0] | proc_6_output_sync_blk[0]);
    assign proc_6_data_FIFO_blk[1] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_unpack_2_U0.grp_p_anonymous_namespace_unpack_2_Pipeline_VITIS_LOOP_156_1_VITIS_LOOP_160_2_fu_68.in_pixels4_blk_n);
    assign proc_6_data_PIPO_blk[1] = 1'b0;
    assign proc_6_start_FIFO_blk[1] = 1'b0;
    assign proc_6_TLF_FIFO_blk[1] = 1'b0;
    assign proc_6_input_sync_blk[1] = 1'b0;
    assign proc_6_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_6[1] = dl_detect_out ? proc_dep_vld_vec_6_reg[1] : (proc_6_data_FIFO_blk[1] | proc_6_data_PIPO_blk[1] | proc_6_start_FIFO_blk[1] | proc_6_TLF_FIFO_blk[1] | proc_6_input_sync_blk[1] | proc_6_output_sync_blk[1]);
    assign proc_6_data_FIFO_blk[2] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_unpack_2_U0.width_c30_blk_n) | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_unpack_2_U0.height_c32_blk_n);
    assign proc_6_data_PIPO_blk[2] = 1'b0;
    assign proc_6_start_FIFO_blk[2] = 1'b0;
    assign proc_6_TLF_FIFO_blk[2] = 1'b0;
    assign proc_6_input_sync_blk[2] = 1'b0;
    assign proc_6_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_6[2] = dl_detect_out ? proc_dep_vld_vec_6_reg[2] : (proc_6_data_FIFO_blk[2] | proc_6_data_PIPO_blk[2] | proc_6_start_FIFO_blk[2] | proc_6_TLF_FIFO_blk[2] | proc_6_input_sync_blk[2] | proc_6_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_6_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_6_reg <= proc_dep_vld_vec_6;
        end
    end
    assign in_chan_dep_vld_vec_6[0] = dep_chan_vld_5_6;
    assign in_chan_dep_data_vec_6[16 : 0] = dep_chan_data_5_6;
    assign token_in_vec_6[0] = token_5_6;
    assign in_chan_dep_vld_vec_6[1] = dep_chan_vld_8_6;
    assign in_chan_dep_data_vec_6[33 : 17] = dep_chan_data_8_6;
    assign token_in_vec_6[1] = token_8_6;
    assign in_chan_dep_vld_vec_6[2] = dep_chan_vld_14_6;
    assign in_chan_dep_data_vec_6[50 : 34] = dep_chan_data_14_6;
    assign token_in_vec_6[2] = token_14_6;
    assign dep_chan_vld_6_5 = out_chan_dep_vld_vec_6[0];
    assign dep_chan_data_6_5 = out_chan_dep_data_6;
    assign token_6_5 = token_out_vec_6[0];
    assign dep_chan_vld_6_8 = out_chan_dep_vld_vec_6[1];
    assign dep_chan_data_6_8 = out_chan_dep_data_6;
    assign token_6_8 = token_out_vec_6[1];
    assign dep_chan_vld_6_14 = out_chan_dep_vld_vec_6[2];
    assign dep_chan_data_6_14 = out_chan_dep_data_6;
    assign token_6_14 = token_out_vec_6[2];

    // Process: AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_output_pass_Block_entry47_proc_U0
    AESL_deadlock_detect_unit #(17, 7, 7, 7) AESL_deadlock_detect_unit_7 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_7),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_7),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_7),
        .token_in_vec(token_in_vec_7),
        .dl_detect_in(dl_detect_out),
        .origin(origin[7]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_7),
        .out_chan_dep_data(out_chan_dep_data_7),
        .token_out_vec(token_out_vec_7),
        .dl_detect_out(dl_in_vec[7]));

    assign proc_7_data_FIFO_blk[0] = 1'b0;
    assign proc_7_data_PIPO_blk[0] = 1'b0;
    assign proc_7_start_FIFO_blk[0] = 1'b0;
    assign proc_7_TLF_FIFO_blk[0] = 1'b0;
    assign proc_7_input_sync_blk[0] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry47_proc_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_output_pass_Block_entry47_proc_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_entry_proc_U0_ap_ready);
    assign proc_7_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_7[0] = dl_detect_out ? proc_dep_vld_vec_7_reg[0] : (proc_7_data_FIFO_blk[0] | proc_7_data_PIPO_blk[0] | proc_7_start_FIFO_blk[0] | proc_7_TLF_FIFO_blk[0] | proc_7_input_sync_blk[0] | proc_7_output_sync_blk[0]);
    assign proc_7_data_FIFO_blk[1] = 1'b0;
    assign proc_7_data_PIPO_blk[1] = 1'b0;
    assign proc_7_start_FIFO_blk[1] = 1'b0;
    assign proc_7_TLF_FIFO_blk[1] = 1'b0;
    assign proc_7_input_sync_blk[1] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry47_proc_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_output_pass_Block_entry47_proc_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_read_words_1_U0_ap_ready);
    assign proc_7_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_7[1] = dl_detect_out ? proc_dep_vld_vec_7_reg[1] : (proc_7_data_FIFO_blk[1] | proc_7_data_PIPO_blk[1] | proc_7_start_FIFO_blk[1] | proc_7_TLF_FIFO_blk[1] | proc_7_input_sync_blk[1] | proc_7_output_sync_blk[1]);
    assign proc_7_data_FIFO_blk[2] = 1'b0;
    assign proc_7_data_PIPO_blk[2] = 1'b0;
    assign proc_7_start_FIFO_blk[2] = 1'b0;
    assign proc_7_TLF_FIFO_blk[2] = 1'b0;
    assign proc_7_input_sync_blk[2] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry47_proc_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_output_pass_Block_entry47_proc_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_color_stage_U0_ap_ready);
    assign proc_7_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_7[2] = dl_detect_out ? proc_dep_vld_vec_7_reg[2] : (proc_7_data_FIFO_blk[2] | proc_7_data_PIPO_blk[2] | proc_7_start_FIFO_blk[2] | proc_7_TLF_FIFO_blk[2] | proc_7_input_sync_blk[2] | proc_7_output_sync_blk[2]);
    assign proc_7_data_FIFO_blk[3] = 1'b0;
    assign proc_7_data_PIPO_blk[3] = 1'b0;
    assign proc_7_start_FIFO_blk[3] = 1'b0;
    assign proc_7_TLF_FIFO_blk[3] = 1'b0;
    assign proc_7_input_sync_blk[3] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry47_proc_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_output_pass_Block_entry47_proc_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_collect_or_drain_U0_ap_ready);
    assign proc_7_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_7[3] = dl_detect_out ? proc_dep_vld_vec_7_reg[3] : (proc_7_data_FIFO_blk[3] | proc_7_data_PIPO_blk[3] | proc_7_start_FIFO_blk[3] | proc_7_TLF_FIFO_blk[3] | proc_7_input_sync_blk[3] | proc_7_output_sync_blk[3]);
    assign proc_7_data_FIFO_blk[4] = 1'b0;
    assign proc_7_data_PIPO_blk[4] = 1'b0;
    assign proc_7_start_FIFO_blk[4] = 1'b0;
    assign proc_7_TLF_FIFO_blk[4] = 1'b0;
    assign proc_7_input_sync_blk[4] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry47_proc_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_output_pass_Block_entry47_proc_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_resize_and_split_U0_ap_ready);
    assign proc_7_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_7[4] = dl_detect_out ? proc_dep_vld_vec_7_reg[4] : (proc_7_data_FIFO_blk[4] | proc_7_data_PIPO_blk[4] | proc_7_start_FIFO_blk[4] | proc_7_TLF_FIFO_blk[4] | proc_7_input_sync_blk[4] | proc_7_output_sync_blk[4]);
    assign proc_7_data_FIFO_blk[5] = 1'b0;
    assign proc_7_data_PIPO_blk[5] = 1'b0;
    assign proc_7_start_FIFO_blk[5] = 1'b0;
    assign proc_7_TLF_FIFO_blk[5] = 1'b0;
    assign proc_7_input_sync_blk[5] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry47_proc_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_output_pass_Block_entry47_proc_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry412_proc_U0_ap_ready);
    assign proc_7_output_sync_blk[5] = 1'b0;
    assign proc_dep_vld_vec_7[5] = dl_detect_out ? proc_dep_vld_vec_7_reg[5] : (proc_7_data_FIFO_blk[5] | proc_7_data_PIPO_blk[5] | proc_7_start_FIFO_blk[5] | proc_7_TLF_FIFO_blk[5] | proc_7_input_sync_blk[5] | proc_7_output_sync_blk[5]);
    assign proc_7_data_FIFO_blk[6] = 1'b0;
    assign proc_7_data_PIPO_blk[6] = 1'b0;
    assign proc_7_start_FIFO_blk[6] = 1'b0;
    assign proc_7_TLF_FIFO_blk[6] = 1'b0;
    assign proc_7_input_sync_blk[6] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry47_proc_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_output_pass_Block_entry47_proc_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry414_proc_U0_ap_ready);
    assign proc_7_output_sync_blk[6] = 1'b0;
    assign proc_dep_vld_vec_7[6] = dl_detect_out ? proc_dep_vld_vec_7_reg[6] : (proc_7_data_FIFO_blk[6] | proc_7_data_PIPO_blk[6] | proc_7_start_FIFO_blk[6] | proc_7_TLF_FIFO_blk[6] | proc_7_input_sync_blk[6] | proc_7_output_sync_blk[6]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_7_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_7_reg <= proc_dep_vld_vec_7;
        end
    end
    assign in_chan_dep_vld_vec_7[0] = dep_chan_vld_4_7;
    assign in_chan_dep_data_vec_7[16 : 0] = dep_chan_data_4_7;
    assign token_in_vec_7[0] = token_4_7;
    assign in_chan_dep_vld_vec_7[1] = dep_chan_vld_5_7;
    assign in_chan_dep_data_vec_7[33 : 17] = dep_chan_data_5_7;
    assign token_in_vec_7[1] = token_5_7;
    assign in_chan_dep_vld_vec_7[2] = dep_chan_vld_8_7;
    assign in_chan_dep_data_vec_7[50 : 34] = dep_chan_data_8_7;
    assign token_in_vec_7[2] = token_8_7;
    assign in_chan_dep_vld_vec_7[3] = dep_chan_vld_9_7;
    assign in_chan_dep_data_vec_7[67 : 51] = dep_chan_data_9_7;
    assign token_in_vec_7[3] = token_9_7;
    assign in_chan_dep_vld_vec_7[4] = dep_chan_vld_10_7;
    assign in_chan_dep_data_vec_7[84 : 68] = dep_chan_data_10_7;
    assign token_in_vec_7[4] = token_10_7;
    assign in_chan_dep_vld_vec_7[5] = dep_chan_vld_11_7;
    assign in_chan_dep_data_vec_7[101 : 85] = dep_chan_data_11_7;
    assign token_in_vec_7[5] = token_11_7;
    assign in_chan_dep_vld_vec_7[6] = dep_chan_vld_13_7;
    assign in_chan_dep_data_vec_7[118 : 102] = dep_chan_data_13_7;
    assign token_in_vec_7[6] = token_13_7;
    assign dep_chan_vld_7_4 = out_chan_dep_vld_vec_7[0];
    assign dep_chan_data_7_4 = out_chan_dep_data_7;
    assign token_7_4 = token_out_vec_7[0];
    assign dep_chan_vld_7_5 = out_chan_dep_vld_vec_7[1];
    assign dep_chan_data_7_5 = out_chan_dep_data_7;
    assign token_7_5 = token_out_vec_7[1];
    assign dep_chan_vld_7_8 = out_chan_dep_vld_vec_7[2];
    assign dep_chan_data_7_8 = out_chan_dep_data_7;
    assign token_7_8 = token_out_vec_7[2];
    assign dep_chan_vld_7_9 = out_chan_dep_vld_vec_7[3];
    assign dep_chan_data_7_9 = out_chan_dep_data_7;
    assign token_7_9 = token_out_vec_7[3];
    assign dep_chan_vld_7_10 = out_chan_dep_vld_vec_7[4];
    assign dep_chan_data_7_10 = out_chan_dep_data_7;
    assign token_7_10 = token_out_vec_7[4];
    assign dep_chan_vld_7_11 = out_chan_dep_vld_vec_7[5];
    assign dep_chan_data_7_11 = out_chan_dep_data_7;
    assign token_7_11 = token_out_vec_7[5];
    assign dep_chan_vld_7_13 = out_chan_dep_vld_vec_7[6];
    assign dep_chan_data_7_13 = out_chan_dep_data_7;
    assign token_7_13 = token_out_vec_7[6];

    // Process: AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_color_stage_U0
    AESL_deadlock_detect_unit #(17, 8, 8, 8) AESL_deadlock_detect_unit_8 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_8),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_8),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_8),
        .token_in_vec(token_in_vec_8),
        .dl_detect_in(dl_detect_out),
        .origin(origin[8]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_8),
        .out_chan_dep_data(out_chan_dep_data_8),
        .token_out_vec(token_out_vec_8),
        .dl_detect_out(dl_in_vec[8]));

    assign proc_8_data_FIFO_blk[0] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_color_stage_U0.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_293_1_fu_104.in_pixels_blk_n);
    assign proc_8_data_PIPO_blk[0] = 1'b0;
    assign proc_8_start_FIFO_blk[0] = 1'b0;
    assign proc_8_TLF_FIFO_blk[0] = 1'b0;
    assign proc_8_input_sync_blk[0] = 1'b0;
    assign proc_8_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_8[0] = dl_detect_out ? proc_dep_vld_vec_8_reg[0] : (proc_8_data_FIFO_blk[0] | proc_8_data_PIPO_blk[0] | proc_8_start_FIFO_blk[0] | proc_8_TLF_FIFO_blk[0] | proc_8_input_sync_blk[0] | proc_8_output_sync_blk[0]);
    assign proc_8_data_FIFO_blk[1] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_color_stage_U0.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_293_1_fu_104.pairs_blk_n);
    assign proc_8_data_PIPO_blk[1] = 1'b0;
    assign proc_8_start_FIFO_blk[1] = 1'b0;
    assign proc_8_TLF_FIFO_blk[1] = 1'b0;
    assign proc_8_input_sync_blk[1] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_color_stage_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_color_stage_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_resize_and_split_U0_ap_ready);
    assign proc_8_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_8[1] = dl_detect_out ? proc_dep_vld_vec_8_reg[1] : (proc_8_data_FIFO_blk[1] | proc_8_data_PIPO_blk[1] | proc_8_start_FIFO_blk[1] | proc_8_TLF_FIFO_blk[1] | proc_8_input_sync_blk[1] | proc_8_output_sync_blk[1]);
    assign proc_8_data_FIFO_blk[2] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_color_stage_U0.grp_p_anonymous_namespace_color_stage_Pipeline_VITIS_LOOP_293_1_fu_104.hist_pixels_blk_n) | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_color_stage_U0.mul_ln1540_loc_c_blk_n);
    assign proc_8_data_PIPO_blk[2] = 1'b0;
    assign proc_8_start_FIFO_blk[2] = 1'b0;
    assign proc_8_TLF_FIFO_blk[2] = 1'b0;
    assign proc_8_input_sync_blk[2] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_color_stage_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_color_stage_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_collect_or_drain_U0_ap_ready);
    assign proc_8_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_8[2] = dl_detect_out ? proc_dep_vld_vec_8_reg[2] : (proc_8_data_FIFO_blk[2] | proc_8_data_PIPO_blk[2] | proc_8_start_FIFO_blk[2] | proc_8_TLF_FIFO_blk[2] | proc_8_input_sync_blk[2] | proc_8_output_sync_blk[2]);
    assign proc_8_data_FIFO_blk[3] = 1'b0;
    assign proc_8_data_PIPO_blk[3] = 1'b0;
    assign proc_8_start_FIFO_blk[3] = 1'b0;
    assign proc_8_TLF_FIFO_blk[3] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.flags_cast_loc_channel_U.if_empty_n & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_color_stage_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.flags_cast_loc_channel_U.if_write) | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.mul_ln1540_loc_c36_channel_U.if_empty_n & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_color_stage_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.mul_ln1540_loc_c36_channel_U.if_write);
    assign proc_8_input_sync_blk[3] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_color_stage_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_color_stage_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry47_proc_U0_ap_ready);
    assign proc_8_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_8[3] = dl_detect_out ? proc_dep_vld_vec_8_reg[3] : (proc_8_data_FIFO_blk[3] | proc_8_data_PIPO_blk[3] | proc_8_start_FIFO_blk[3] | proc_8_TLF_FIFO_blk[3] | proc_8_input_sync_blk[3] | proc_8_output_sync_blk[3]);
    assign proc_8_data_FIFO_blk[4] = 1'b0;
    assign proc_8_data_PIPO_blk[4] = 1'b0;
    assign proc_8_start_FIFO_blk[4] = 1'b0;
    assign proc_8_TLF_FIFO_blk[4] = 1'b0;
    assign proc_8_input_sync_blk[4] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_color_stage_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_color_stage_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_entry_proc_U0_ap_ready);
    assign proc_8_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_8[4] = dl_detect_out ? proc_dep_vld_vec_8_reg[4] : (proc_8_data_FIFO_blk[4] | proc_8_data_PIPO_blk[4] | proc_8_start_FIFO_blk[4] | proc_8_TLF_FIFO_blk[4] | proc_8_input_sync_blk[4] | proc_8_output_sync_blk[4]);
    assign proc_8_data_FIFO_blk[5] = 1'b0;
    assign proc_8_data_PIPO_blk[5] = 1'b0;
    assign proc_8_start_FIFO_blk[5] = 1'b0;
    assign proc_8_TLF_FIFO_blk[5] = 1'b0;
    assign proc_8_input_sync_blk[5] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_color_stage_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_color_stage_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_read_words_1_U0_ap_ready);
    assign proc_8_output_sync_blk[5] = 1'b0;
    assign proc_dep_vld_vec_8[5] = dl_detect_out ? proc_dep_vld_vec_8_reg[5] : (proc_8_data_FIFO_blk[5] | proc_8_data_PIPO_blk[5] | proc_8_start_FIFO_blk[5] | proc_8_TLF_FIFO_blk[5] | proc_8_input_sync_blk[5] | proc_8_output_sync_blk[5]);
    assign proc_8_data_FIFO_blk[6] = 1'b0;
    assign proc_8_data_PIPO_blk[6] = 1'b0;
    assign proc_8_start_FIFO_blk[6] = 1'b0;
    assign proc_8_TLF_FIFO_blk[6] = 1'b0;
    assign proc_8_input_sync_blk[6] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_color_stage_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_color_stage_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry412_proc_U0_ap_ready);
    assign proc_8_output_sync_blk[6] = 1'b0;
    assign proc_dep_vld_vec_8[6] = dl_detect_out ? proc_dep_vld_vec_8_reg[6] : (proc_8_data_FIFO_blk[6] | proc_8_data_PIPO_blk[6] | proc_8_start_FIFO_blk[6] | proc_8_TLF_FIFO_blk[6] | proc_8_input_sync_blk[6] | proc_8_output_sync_blk[6]);
    assign proc_8_data_FIFO_blk[7] = 1'b0;
    assign proc_8_data_PIPO_blk[7] = 1'b0;
    assign proc_8_start_FIFO_blk[7] = 1'b0;
    assign proc_8_TLF_FIFO_blk[7] = 1'b0;
    assign proc_8_input_sync_blk[7] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_color_stage_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_color_stage_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry414_proc_U0_ap_ready);
    assign proc_8_output_sync_blk[7] = 1'b0;
    assign proc_dep_vld_vec_8[7] = dl_detect_out ? proc_dep_vld_vec_8_reg[7] : (proc_8_data_FIFO_blk[7] | proc_8_data_PIPO_blk[7] | proc_8_start_FIFO_blk[7] | proc_8_TLF_FIFO_blk[7] | proc_8_input_sync_blk[7] | proc_8_output_sync_blk[7]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_8_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_8_reg <= proc_dep_vld_vec_8;
        end
    end
    assign in_chan_dep_vld_vec_8[0] = dep_chan_vld_4_8;
    assign in_chan_dep_data_vec_8[16 : 0] = dep_chan_data_4_8;
    assign token_in_vec_8[0] = token_4_8;
    assign in_chan_dep_vld_vec_8[1] = dep_chan_vld_5_8;
    assign in_chan_dep_data_vec_8[33 : 17] = dep_chan_data_5_8;
    assign token_in_vec_8[1] = token_5_8;
    assign in_chan_dep_vld_vec_8[2] = dep_chan_vld_6_8;
    assign in_chan_dep_data_vec_8[50 : 34] = dep_chan_data_6_8;
    assign token_in_vec_8[2] = token_6_8;
    assign in_chan_dep_vld_vec_8[3] = dep_chan_vld_7_8;
    assign in_chan_dep_data_vec_8[67 : 51] = dep_chan_data_7_8;
    assign token_in_vec_8[3] = token_7_8;
    assign in_chan_dep_vld_vec_8[4] = dep_chan_vld_9_8;
    assign in_chan_dep_data_vec_8[84 : 68] = dep_chan_data_9_8;
    assign token_in_vec_8[4] = token_9_8;
    assign in_chan_dep_vld_vec_8[5] = dep_chan_vld_10_8;
    assign in_chan_dep_data_vec_8[101 : 85] = dep_chan_data_10_8;
    assign token_in_vec_8[5] = token_10_8;
    assign in_chan_dep_vld_vec_8[6] = dep_chan_vld_11_8;
    assign in_chan_dep_data_vec_8[118 : 102] = dep_chan_data_11_8;
    assign token_in_vec_8[6] = token_11_8;
    assign in_chan_dep_vld_vec_8[7] = dep_chan_vld_13_8;
    assign in_chan_dep_data_vec_8[135 : 119] = dep_chan_data_13_8;
    assign token_in_vec_8[7] = token_13_8;
    assign dep_chan_vld_8_6 = out_chan_dep_vld_vec_8[0];
    assign dep_chan_data_8_6 = out_chan_dep_data_8;
    assign token_8_6 = token_out_vec_8[0];
    assign dep_chan_vld_8_10 = out_chan_dep_vld_vec_8[1];
    assign dep_chan_data_8_10 = out_chan_dep_data_8;
    assign token_8_10 = token_out_vec_8[1];
    assign dep_chan_vld_8_9 = out_chan_dep_vld_vec_8[2];
    assign dep_chan_data_8_9 = out_chan_dep_data_8;
    assign token_8_9 = token_out_vec_8[2];
    assign dep_chan_vld_8_7 = out_chan_dep_vld_vec_8[3];
    assign dep_chan_data_8_7 = out_chan_dep_data_8;
    assign token_8_7 = token_out_vec_8[3];
    assign dep_chan_vld_8_4 = out_chan_dep_vld_vec_8[4];
    assign dep_chan_data_8_4 = out_chan_dep_data_8;
    assign token_8_4 = token_out_vec_8[4];
    assign dep_chan_vld_8_5 = out_chan_dep_vld_vec_8[5];
    assign dep_chan_data_8_5 = out_chan_dep_data_8;
    assign token_8_5 = token_out_vec_8[5];
    assign dep_chan_vld_8_11 = out_chan_dep_vld_vec_8[6];
    assign dep_chan_data_8_11 = out_chan_dep_data_8;
    assign token_8_11 = token_out_vec_8[6];
    assign dep_chan_vld_8_13 = out_chan_dep_vld_vec_8[7];
    assign dep_chan_data_8_13 = out_chan_dep_data_8;
    assign token_8_13 = token_out_vec_8[7];

    // Process: AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_collect_or_drain_U0
    AESL_deadlock_detect_unit #(17, 9, 9, 9) AESL_deadlock_detect_unit_9 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_9),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_9),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_9),
        .token_in_vec(token_in_vec_9),
        .dl_detect_in(dl_detect_out),
        .origin(origin[9]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_9),
        .out_chan_dep_data(out_chan_dep_data_9),
        .token_out_vec(token_out_vec_9),
        .dl_detect_out(dl_in_vec[9]));

    assign proc_9_data_FIFO_blk[0] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_collect_or_drain_U0.grp_p_anonymous_namespace_collect_or_drain_Pipeline_VITIS_LOOP_316_2_fu_58.hist_pixels_blk_n) | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_collect_or_drain_U0.mul_ln1540_loc_blk_n);
    assign proc_9_data_PIPO_blk[0] = 1'b0;
    assign proc_9_start_FIFO_blk[0] = 1'b0;
    assign proc_9_TLF_FIFO_blk[0] = 1'b0;
    assign proc_9_input_sync_blk[0] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_collect_or_drain_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_collect_or_drain_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_color_stage_U0_ap_ready);
    assign proc_9_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_9[0] = dl_detect_out ? proc_dep_vld_vec_9_reg[0] : (proc_9_data_FIFO_blk[0] | proc_9_data_PIPO_blk[0] | proc_9_start_FIFO_blk[0] | proc_9_TLF_FIFO_blk[0] | proc_9_input_sync_blk[0] | proc_9_output_sync_blk[0]);
    assign proc_9_data_FIFO_blk[1] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_collect_or_drain_U0.collect_blk_n);
    assign proc_9_data_PIPO_blk[1] = 1'b0;
    assign proc_9_start_FIFO_blk[1] = 1'b0;
    assign proc_9_TLF_FIFO_blk[1] = 1'b0;
    assign proc_9_input_sync_blk[1] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_collect_or_drain_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_collect_or_drain_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_entry_proc_U0_ap_ready);
    assign proc_9_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_9[1] = dl_detect_out ? proc_dep_vld_vec_9_reg[1] : (proc_9_data_FIFO_blk[1] | proc_9_data_PIPO_blk[1] | proc_9_start_FIFO_blk[1] | proc_9_TLF_FIFO_blk[1] | proc_9_input_sync_blk[1] | proc_9_output_sync_blk[1]);
    assign proc_9_data_FIFO_blk[2] = 1'b0;
    assign proc_9_data_PIPO_blk[2] = 1'b0;
    assign proc_9_start_FIFO_blk[2] = 1'b0;
    assign proc_9_TLF_FIFO_blk[2] = 1'b0;
    assign proc_9_input_sync_blk[2] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_collect_or_drain_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_collect_or_drain_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_read_words_1_U0_ap_ready);
    assign proc_9_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_9[2] = dl_detect_out ? proc_dep_vld_vec_9_reg[2] : (proc_9_data_FIFO_blk[2] | proc_9_data_PIPO_blk[2] | proc_9_start_FIFO_blk[2] | proc_9_TLF_FIFO_blk[2] | proc_9_input_sync_blk[2] | proc_9_output_sync_blk[2]);
    assign proc_9_data_FIFO_blk[3] = 1'b0;
    assign proc_9_data_PIPO_blk[3] = 1'b0;
    assign proc_9_start_FIFO_blk[3] = 1'b0;
    assign proc_9_TLF_FIFO_blk[3] = 1'b0;
    assign proc_9_input_sync_blk[3] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_collect_or_drain_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_collect_or_drain_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry47_proc_U0_ap_ready);
    assign proc_9_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_9[3] = dl_detect_out ? proc_dep_vld_vec_9_reg[3] : (proc_9_data_FIFO_blk[3] | proc_9_data_PIPO_blk[3] | proc_9_start_FIFO_blk[3] | proc_9_TLF_FIFO_blk[3] | proc_9_input_sync_blk[3] | proc_9_output_sync_blk[3]);
    assign proc_9_data_FIFO_blk[4] = 1'b0;
    assign proc_9_data_PIPO_blk[4] = 1'b0;
    assign proc_9_start_FIFO_blk[4] = 1'b0;
    assign proc_9_TLF_FIFO_blk[4] = 1'b0;
    assign proc_9_input_sync_blk[4] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_collect_or_drain_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_collect_or_drain_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_resize_and_split_U0_ap_ready);
    assign proc_9_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_9[4] = dl_detect_out ? proc_dep_vld_vec_9_reg[4] : (proc_9_data_FIFO_blk[4] | proc_9_data_PIPO_blk[4] | proc_9_start_FIFO_blk[4] | proc_9_TLF_FIFO_blk[4] | proc_9_input_sync_blk[4] | proc_9_output_sync_blk[4]);
    assign proc_9_data_FIFO_blk[5] = 1'b0;
    assign proc_9_data_PIPO_blk[5] = 1'b0;
    assign proc_9_start_FIFO_blk[5] = 1'b0;
    assign proc_9_TLF_FIFO_blk[5] = 1'b0;
    assign proc_9_input_sync_blk[5] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_collect_or_drain_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_collect_or_drain_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry412_proc_U0_ap_ready);
    assign proc_9_output_sync_blk[5] = 1'b0;
    assign proc_dep_vld_vec_9[5] = dl_detect_out ? proc_dep_vld_vec_9_reg[5] : (proc_9_data_FIFO_blk[5] | proc_9_data_PIPO_blk[5] | proc_9_start_FIFO_blk[5] | proc_9_TLF_FIFO_blk[5] | proc_9_input_sync_blk[5] | proc_9_output_sync_blk[5]);
    assign proc_9_data_FIFO_blk[6] = 1'b0;
    assign proc_9_data_PIPO_blk[6] = 1'b0;
    assign proc_9_start_FIFO_blk[6] = 1'b0;
    assign proc_9_TLF_FIFO_blk[6] = 1'b0;
    assign proc_9_input_sync_blk[6] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_collect_or_drain_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_collect_or_drain_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry414_proc_U0_ap_ready);
    assign proc_9_output_sync_blk[6] = 1'b0;
    assign proc_dep_vld_vec_9[6] = dl_detect_out ? proc_dep_vld_vec_9_reg[6] : (proc_9_data_FIFO_blk[6] | proc_9_data_PIPO_blk[6] | proc_9_start_FIFO_blk[6] | proc_9_TLF_FIFO_blk[6] | proc_9_input_sync_blk[6] | proc_9_output_sync_blk[6]);
    assign proc_9_data_FIFO_blk[7] = 1'b0;
    assign proc_9_data_PIPO_blk[7] = 1'b0;
    assign proc_9_start_FIFO_blk[7] = 1'b0;
    assign proc_9_TLF_FIFO_blk[7] = 1'b0;
    assign proc_9_input_sync_blk[7] = 1'b0;
    assign proc_9_output_sync_blk[7] = 1'b0 | (ap_done_reg_5 & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_collect_or_drain_U0.ap_done & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_write_words_U0.ap_done);
    assign proc_dep_vld_vec_9[7] = dl_detect_out ? proc_dep_vld_vec_9_reg[7] : (proc_9_data_FIFO_blk[7] | proc_9_data_PIPO_blk[7] | proc_9_start_FIFO_blk[7] | proc_9_TLF_FIFO_blk[7] | proc_9_input_sync_blk[7] | proc_9_output_sync_blk[7]);
    assign proc_9_data_FIFO_blk[8] = 1'b0;
    assign proc_9_data_PIPO_blk[8] = 1'b0;
    assign proc_9_start_FIFO_blk[8] = 1'b0;
    assign proc_9_TLF_FIFO_blk[8] = 1'b0;
    assign proc_9_input_sync_blk[8] = 1'b0;
    assign proc_9_output_sync_blk[8] = 1'b0 | (ap_done_reg_5 & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_collect_or_drain_U0.ap_done & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_write_words_4_U0.ap_done);
    assign proc_dep_vld_vec_9[8] = dl_detect_out ? proc_dep_vld_vec_9_reg[8] : (proc_9_data_FIFO_blk[8] | proc_9_data_PIPO_blk[8] | proc_9_start_FIFO_blk[8] | proc_9_TLF_FIFO_blk[8] | proc_9_input_sync_blk[8] | proc_9_output_sync_blk[8]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_9_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_9_reg <= proc_dep_vld_vec_9;
        end
    end
    assign in_chan_dep_vld_vec_9[0] = dep_chan_vld_4_9;
    assign in_chan_dep_data_vec_9[16 : 0] = dep_chan_data_4_9;
    assign token_in_vec_9[0] = token_4_9;
    assign in_chan_dep_vld_vec_9[1] = dep_chan_vld_5_9;
    assign in_chan_dep_data_vec_9[33 : 17] = dep_chan_data_5_9;
    assign token_in_vec_9[1] = token_5_9;
    assign in_chan_dep_vld_vec_9[2] = dep_chan_vld_7_9;
    assign in_chan_dep_data_vec_9[50 : 34] = dep_chan_data_7_9;
    assign token_in_vec_9[2] = token_7_9;
    assign in_chan_dep_vld_vec_9[3] = dep_chan_vld_8_9;
    assign in_chan_dep_data_vec_9[67 : 51] = dep_chan_data_8_9;
    assign token_in_vec_9[3] = token_8_9;
    assign in_chan_dep_vld_vec_9[4] = dep_chan_vld_10_9;
    assign in_chan_dep_data_vec_9[84 : 68] = dep_chan_data_10_9;
    assign token_in_vec_9[4] = token_10_9;
    assign in_chan_dep_vld_vec_9[5] = dep_chan_vld_11_9;
    assign in_chan_dep_data_vec_9[101 : 85] = dep_chan_data_11_9;
    assign token_in_vec_9[5] = token_11_9;
    assign in_chan_dep_vld_vec_9[6] = dep_chan_vld_13_9;
    assign in_chan_dep_data_vec_9[118 : 102] = dep_chan_data_13_9;
    assign token_in_vec_9[6] = token_13_9;
    assign in_chan_dep_vld_vec_9[7] = dep_chan_vld_15_9;
    assign in_chan_dep_data_vec_9[135 : 119] = dep_chan_data_15_9;
    assign token_in_vec_9[7] = token_15_9;
    assign in_chan_dep_vld_vec_9[8] = dep_chan_vld_16_9;
    assign in_chan_dep_data_vec_9[152 : 136] = dep_chan_data_16_9;
    assign token_in_vec_9[8] = token_16_9;
    assign dep_chan_vld_9_8 = out_chan_dep_vld_vec_9[0];
    assign dep_chan_data_9_8 = out_chan_dep_data_9;
    assign token_9_8 = token_out_vec_9[0];
    assign dep_chan_vld_9_4 = out_chan_dep_vld_vec_9[1];
    assign dep_chan_data_9_4 = out_chan_dep_data_9;
    assign token_9_4 = token_out_vec_9[1];
    assign dep_chan_vld_9_5 = out_chan_dep_vld_vec_9[2];
    assign dep_chan_data_9_5 = out_chan_dep_data_9;
    assign token_9_5 = token_out_vec_9[2];
    assign dep_chan_vld_9_7 = out_chan_dep_vld_vec_9[3];
    assign dep_chan_data_9_7 = out_chan_dep_data_9;
    assign token_9_7 = token_out_vec_9[3];
    assign dep_chan_vld_9_10 = out_chan_dep_vld_vec_9[4];
    assign dep_chan_data_9_10 = out_chan_dep_data_9;
    assign token_9_10 = token_out_vec_9[4];
    assign dep_chan_vld_9_11 = out_chan_dep_vld_vec_9[5];
    assign dep_chan_data_9_11 = out_chan_dep_data_9;
    assign token_9_11 = token_out_vec_9[5];
    assign dep_chan_vld_9_13 = out_chan_dep_vld_vec_9[6];
    assign dep_chan_data_9_13 = out_chan_dep_data_9;
    assign token_9_13 = token_out_vec_9[6];
    assign dep_chan_vld_9_15 = out_chan_dep_vld_vec_9[7];
    assign dep_chan_data_9_15 = out_chan_dep_data_9;
    assign token_9_15 = token_out_vec_9[7];
    assign dep_chan_vld_9_16 = out_chan_dep_vld_vec_9[8];
    assign dep_chan_data_9_16 = out_chan_dep_data_9;
    assign token_9_16 = token_out_vec_9[8];

    // Process: AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0
    AESL_deadlock_detect_unit #(17, 10, 9, 9) AESL_deadlock_detect_unit_10 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_10),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_10),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_10),
        .token_in_vec(token_in_vec_10),
        .dl_detect_in(dl_detect_out),
        .origin(origin[10]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_10),
        .out_chan_dep_data(out_chan_dep_data_10),
        .token_out_vec(token_out_vec_10),
        .dl_detect_out(dl_in_vec[10]));

    assign proc_10_data_FIFO_blk[0] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_369_2_VITIS_LOOP_371_3_fu_236.pairs_blk_n);
    assign proc_10_data_PIPO_blk[0] = 1'b0;
    assign proc_10_start_FIFO_blk[0] = 1'b0;
    assign proc_10_TLF_FIFO_blk[0] = 1'b0;
    assign proc_10_input_sync_blk[0] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_resize_and_split_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_color_stage_U0_ap_ready);
    assign proc_10_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_10[0] = dl_detect_out ? proc_dep_vld_vec_10_reg[0] : (proc_10_data_FIFO_blk[0] | proc_10_data_PIPO_blk[0] | proc_10_start_FIFO_blk[0] | proc_10_TLF_FIFO_blk[0] | proc_10_input_sync_blk[0] | proc_10_output_sync_blk[0]);
    assign proc_10_data_FIFO_blk[1] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_381_4_fu_251.tensor_pixels_blk_n);
    assign proc_10_data_PIPO_blk[1] = 1'b0;
    assign proc_10_start_FIFO_blk[1] = 1'b0;
    assign proc_10_TLF_FIFO_blk[1] = 1'b0;
    assign proc_10_input_sync_blk[1] = 1'b0;
    assign proc_10_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_10[1] = dl_detect_out ? proc_dep_vld_vec_10_reg[1] : (proc_10_data_FIFO_blk[1] | proc_10_data_PIPO_blk[1] | proc_10_start_FIFO_blk[1] | proc_10_TLF_FIFO_blk[1] | proc_10_input_sync_blk[1] | proc_10_output_sync_blk[1]);
    assign proc_10_data_FIFO_blk[2] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0.grp_p_anonymous_namespace_resize_and_split_Pipeline_VITIS_LOOP_369_2_VITIS_LOOP_371_3_fu_236.preview_pixels_blk_n);
    assign proc_10_data_PIPO_blk[2] = 1'b0;
    assign proc_10_start_FIFO_blk[2] = 1'b0;
    assign proc_10_TLF_FIFO_blk[2] = 1'b0;
    assign proc_10_input_sync_blk[2] = 1'b0;
    assign proc_10_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_10[2] = dl_detect_out ? proc_dep_vld_vec_10_reg[2] : (proc_10_data_FIFO_blk[2] | proc_10_data_PIPO_blk[2] | proc_10_start_FIFO_blk[2] | proc_10_TLF_FIFO_blk[2] | proc_10_input_sync_blk[2] | proc_10_output_sync_blk[2]);
    assign proc_10_data_FIFO_blk[3] = 1'b0;
    assign proc_10_data_PIPO_blk[3] = 1'b0;
    assign proc_10_start_FIFO_blk[3] = 1'b0;
    assign proc_10_TLF_FIFO_blk[3] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.w_V_loc_channel_U.if_empty_n & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.w_V_loc_channel_U.if_write) | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.h_V_loc_channel_U.if_empty_n & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.h_V_loc_channel_U.if_write);
    assign proc_10_input_sync_blk[3] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_resize_and_split_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry47_proc_U0_ap_ready);
    assign proc_10_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_10[3] = dl_detect_out ? proc_dep_vld_vec_10_reg[3] : (proc_10_data_FIFO_blk[3] | proc_10_data_PIPO_blk[3] | proc_10_start_FIFO_blk[3] | proc_10_TLF_FIFO_blk[3] | proc_10_input_sync_blk[3] | proc_10_output_sync_blk[3]);
    assign proc_10_data_FIFO_blk[4] = 1'b0;
    assign proc_10_data_PIPO_blk[4] = 1'b0;
    assign proc_10_start_FIFO_blk[4] = 1'b0;
    assign proc_10_TLF_FIFO_blk[4] = 1'b0;
    assign proc_10_input_sync_blk[4] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_resize_and_split_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_entry_proc_U0_ap_ready);
    assign proc_10_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_10[4] = dl_detect_out ? proc_dep_vld_vec_10_reg[4] : (proc_10_data_FIFO_blk[4] | proc_10_data_PIPO_blk[4] | proc_10_start_FIFO_blk[4] | proc_10_TLF_FIFO_blk[4] | proc_10_input_sync_blk[4] | proc_10_output_sync_blk[4]);
    assign proc_10_data_FIFO_blk[5] = 1'b0;
    assign proc_10_data_PIPO_blk[5] = 1'b0;
    assign proc_10_start_FIFO_blk[5] = 1'b0;
    assign proc_10_TLF_FIFO_blk[5] = 1'b0;
    assign proc_10_input_sync_blk[5] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_resize_and_split_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_read_words_1_U0_ap_ready);
    assign proc_10_output_sync_blk[5] = 1'b0;
    assign proc_dep_vld_vec_10[5] = dl_detect_out ? proc_dep_vld_vec_10_reg[5] : (proc_10_data_FIFO_blk[5] | proc_10_data_PIPO_blk[5] | proc_10_start_FIFO_blk[5] | proc_10_TLF_FIFO_blk[5] | proc_10_input_sync_blk[5] | proc_10_output_sync_blk[5]);
    assign proc_10_data_FIFO_blk[6] = 1'b0;
    assign proc_10_data_PIPO_blk[6] = 1'b0;
    assign proc_10_start_FIFO_blk[6] = 1'b0;
    assign proc_10_TLF_FIFO_blk[6] = 1'b0;
    assign proc_10_input_sync_blk[6] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_resize_and_split_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_collect_or_drain_U0_ap_ready);
    assign proc_10_output_sync_blk[6] = 1'b0;
    assign proc_dep_vld_vec_10[6] = dl_detect_out ? proc_dep_vld_vec_10_reg[6] : (proc_10_data_FIFO_blk[6] | proc_10_data_PIPO_blk[6] | proc_10_start_FIFO_blk[6] | proc_10_TLF_FIFO_blk[6] | proc_10_input_sync_blk[6] | proc_10_output_sync_blk[6]);
    assign proc_10_data_FIFO_blk[7] = 1'b0;
    assign proc_10_data_PIPO_blk[7] = 1'b0;
    assign proc_10_start_FIFO_blk[7] = 1'b0;
    assign proc_10_TLF_FIFO_blk[7] = 1'b0;
    assign proc_10_input_sync_blk[7] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_resize_and_split_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry412_proc_U0_ap_ready);
    assign proc_10_output_sync_blk[7] = 1'b0;
    assign proc_dep_vld_vec_10[7] = dl_detect_out ? proc_dep_vld_vec_10_reg[7] : (proc_10_data_FIFO_blk[7] | proc_10_data_PIPO_blk[7] | proc_10_start_FIFO_blk[7] | proc_10_TLF_FIFO_blk[7] | proc_10_input_sync_blk[7] | proc_10_output_sync_blk[7]);
    assign proc_10_data_FIFO_blk[8] = 1'b0;
    assign proc_10_data_PIPO_blk[8] = 1'b0;
    assign proc_10_start_FIFO_blk[8] = 1'b0;
    assign proc_10_TLF_FIFO_blk[8] = 1'b0;
    assign proc_10_input_sync_blk[8] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_resize_and_split_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_resize_and_split_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry414_proc_U0_ap_ready);
    assign proc_10_output_sync_blk[8] = 1'b0;
    assign proc_dep_vld_vec_10[8] = dl_detect_out ? proc_dep_vld_vec_10_reg[8] : (proc_10_data_FIFO_blk[8] | proc_10_data_PIPO_blk[8] | proc_10_start_FIFO_blk[8] | proc_10_TLF_FIFO_blk[8] | proc_10_input_sync_blk[8] | proc_10_output_sync_blk[8]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_10_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_10_reg <= proc_dep_vld_vec_10;
        end
    end
    assign in_chan_dep_vld_vec_10[0] = dep_chan_vld_4_10;
    assign in_chan_dep_data_vec_10[16 : 0] = dep_chan_data_4_10;
    assign token_in_vec_10[0] = token_4_10;
    assign in_chan_dep_vld_vec_10[1] = dep_chan_vld_5_10;
    assign in_chan_dep_data_vec_10[33 : 17] = dep_chan_data_5_10;
    assign token_in_vec_10[1] = token_5_10;
    assign in_chan_dep_vld_vec_10[2] = dep_chan_vld_7_10;
    assign in_chan_dep_data_vec_10[50 : 34] = dep_chan_data_7_10;
    assign token_in_vec_10[2] = token_7_10;
    assign in_chan_dep_vld_vec_10[3] = dep_chan_vld_8_10;
    assign in_chan_dep_data_vec_10[67 : 51] = dep_chan_data_8_10;
    assign token_in_vec_10[3] = token_8_10;
    assign in_chan_dep_vld_vec_10[4] = dep_chan_vld_9_10;
    assign in_chan_dep_data_vec_10[84 : 68] = dep_chan_data_9_10;
    assign token_in_vec_10[4] = token_9_10;
    assign in_chan_dep_vld_vec_10[5] = dep_chan_vld_11_10;
    assign in_chan_dep_data_vec_10[101 : 85] = dep_chan_data_11_10;
    assign token_in_vec_10[5] = token_11_10;
    assign in_chan_dep_vld_vec_10[6] = dep_chan_vld_12_10;
    assign in_chan_dep_data_vec_10[118 : 102] = dep_chan_data_12_10;
    assign token_in_vec_10[6] = token_12_10;
    assign in_chan_dep_vld_vec_10[7] = dep_chan_vld_13_10;
    assign in_chan_dep_data_vec_10[135 : 119] = dep_chan_data_13_10;
    assign token_in_vec_10[7] = token_13_10;
    assign in_chan_dep_vld_vec_10[8] = dep_chan_vld_14_10;
    assign in_chan_dep_data_vec_10[152 : 136] = dep_chan_data_14_10;
    assign token_in_vec_10[8] = token_14_10;
    assign dep_chan_vld_10_8 = out_chan_dep_vld_vec_10[0];
    assign dep_chan_data_10_8 = out_chan_dep_data_10;
    assign token_10_8 = token_out_vec_10[0];
    assign dep_chan_vld_10_12 = out_chan_dep_vld_vec_10[1];
    assign dep_chan_data_10_12 = out_chan_dep_data_10;
    assign token_10_12 = token_out_vec_10[1];
    assign dep_chan_vld_10_14 = out_chan_dep_vld_vec_10[2];
    assign dep_chan_data_10_14 = out_chan_dep_data_10;
    assign token_10_14 = token_out_vec_10[2];
    assign dep_chan_vld_10_7 = out_chan_dep_vld_vec_10[3];
    assign dep_chan_data_10_7 = out_chan_dep_data_10;
    assign token_10_7 = token_out_vec_10[3];
    assign dep_chan_vld_10_4 = out_chan_dep_vld_vec_10[4];
    assign dep_chan_data_10_4 = out_chan_dep_data_10;
    assign token_10_4 = token_out_vec_10[4];
    assign dep_chan_vld_10_5 = out_chan_dep_vld_vec_10[5];
    assign dep_chan_data_10_5 = out_chan_dep_data_10;
    assign token_10_5 = token_out_vec_10[5];
    assign dep_chan_vld_10_9 = out_chan_dep_vld_vec_10[6];
    assign dep_chan_data_10_9 = out_chan_dep_data_10;
    assign token_10_9 = token_out_vec_10[6];
    assign dep_chan_vld_10_11 = out_chan_dep_vld_vec_10[7];
    assign dep_chan_data_10_11 = out_chan_dep_data_10;
    assign token_10_11 = token_out_vec_10[7];
    assign dep_chan_vld_10_13 = out_chan_dep_vld_vec_10[8];
    assign dep_chan_data_10_13 = out_chan_dep_data_10;
    assign token_10_13 = token_out_vec_10[8];

    // Process: AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_output_pass_Block_entry412_proc_U0
    AESL_deadlock_detect_unit #(17, 11, 8, 7) AESL_deadlock_detect_unit_11 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_11),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_11),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_11),
        .token_in_vec(token_in_vec_11),
        .dl_detect_in(dl_detect_out),
        .origin(origin[11]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_11),
        .out_chan_dep_data(out_chan_dep_data_11),
        .token_out_vec(token_out_vec_11),
        .dl_detect_out(dl_in_vec[11]));

    assign proc_11_data_FIFO_blk[0] = 1'b0;
    assign proc_11_data_PIPO_blk[0] = 1'b0;
    assign proc_11_start_FIFO_blk[0] = 1'b0;
    assign proc_11_TLF_FIFO_blk[0] = 1'b0;
    assign proc_11_input_sync_blk[0] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry412_proc_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_output_pass_Block_entry412_proc_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_entry_proc_U0_ap_ready);
    assign proc_11_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_11[0] = dl_detect_out ? proc_dep_vld_vec_11_reg[0] : (proc_11_data_FIFO_blk[0] | proc_11_data_PIPO_blk[0] | proc_11_start_FIFO_blk[0] | proc_11_TLF_FIFO_blk[0] | proc_11_input_sync_blk[0] | proc_11_output_sync_blk[0]);
    assign proc_11_data_FIFO_blk[1] = 1'b0;
    assign proc_11_data_PIPO_blk[1] = 1'b0;
    assign proc_11_start_FIFO_blk[1] = 1'b0;
    assign proc_11_TLF_FIFO_blk[1] = 1'b0;
    assign proc_11_input_sync_blk[1] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry412_proc_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_output_pass_Block_entry412_proc_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_read_words_1_U0_ap_ready);
    assign proc_11_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_11[1] = dl_detect_out ? proc_dep_vld_vec_11_reg[1] : (proc_11_data_FIFO_blk[1] | proc_11_data_PIPO_blk[1] | proc_11_start_FIFO_blk[1] | proc_11_TLF_FIFO_blk[1] | proc_11_input_sync_blk[1] | proc_11_output_sync_blk[1]);
    assign proc_11_data_FIFO_blk[2] = 1'b0;
    assign proc_11_data_PIPO_blk[2] = 1'b0;
    assign proc_11_start_FIFO_blk[2] = 1'b0;
    assign proc_11_TLF_FIFO_blk[2] = 1'b0;
    assign proc_11_input_sync_blk[2] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry412_proc_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_output_pass_Block_entry412_proc_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry47_proc_U0_ap_ready);
    assign proc_11_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_11[2] = dl_detect_out ? proc_dep_vld_vec_11_reg[2] : (proc_11_data_FIFO_blk[2] | proc_11_data_PIPO_blk[2] | proc_11_start_FIFO_blk[2] | proc_11_TLF_FIFO_blk[2] | proc_11_input_sync_blk[2] | proc_11_output_sync_blk[2]);
    assign proc_11_data_FIFO_blk[3] = 1'b0;
    assign proc_11_data_PIPO_blk[3] = 1'b0;
    assign proc_11_start_FIFO_blk[3] = 1'b0;
    assign proc_11_TLF_FIFO_blk[3] = 1'b0;
    assign proc_11_input_sync_blk[3] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry412_proc_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_output_pass_Block_entry412_proc_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_color_stage_U0_ap_ready);
    assign proc_11_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_11[3] = dl_detect_out ? proc_dep_vld_vec_11_reg[3] : (proc_11_data_FIFO_blk[3] | proc_11_data_PIPO_blk[3] | proc_11_start_FIFO_blk[3] | proc_11_TLF_FIFO_blk[3] | proc_11_input_sync_blk[3] | proc_11_output_sync_blk[3]);
    assign proc_11_data_FIFO_blk[4] = 1'b0;
    assign proc_11_data_PIPO_blk[4] = 1'b0;
    assign proc_11_start_FIFO_blk[4] = 1'b0;
    assign proc_11_TLF_FIFO_blk[4] = 1'b0;
    assign proc_11_input_sync_blk[4] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry412_proc_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_output_pass_Block_entry412_proc_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_collect_or_drain_U0_ap_ready);
    assign proc_11_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_11[4] = dl_detect_out ? proc_dep_vld_vec_11_reg[4] : (proc_11_data_FIFO_blk[4] | proc_11_data_PIPO_blk[4] | proc_11_start_FIFO_blk[4] | proc_11_TLF_FIFO_blk[4] | proc_11_input_sync_blk[4] | proc_11_output_sync_blk[4]);
    assign proc_11_data_FIFO_blk[5] = 1'b0;
    assign proc_11_data_PIPO_blk[5] = 1'b0;
    assign proc_11_start_FIFO_blk[5] = 1'b0;
    assign proc_11_TLF_FIFO_blk[5] = 1'b0;
    assign proc_11_input_sync_blk[5] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry412_proc_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_output_pass_Block_entry412_proc_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_resize_and_split_U0_ap_ready);
    assign proc_11_output_sync_blk[5] = 1'b0;
    assign proc_dep_vld_vec_11[5] = dl_detect_out ? proc_dep_vld_vec_11_reg[5] : (proc_11_data_FIFO_blk[5] | proc_11_data_PIPO_blk[5] | proc_11_start_FIFO_blk[5] | proc_11_TLF_FIFO_blk[5] | proc_11_input_sync_blk[5] | proc_11_output_sync_blk[5]);
    assign proc_11_data_FIFO_blk[6] = 1'b0;
    assign proc_11_data_PIPO_blk[6] = 1'b0;
    assign proc_11_start_FIFO_blk[6] = 1'b0;
    assign proc_11_TLF_FIFO_blk[6] = 1'b0;
    assign proc_11_input_sync_blk[6] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry412_proc_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_output_pass_Block_entry412_proc_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry414_proc_U0_ap_ready);
    assign proc_11_output_sync_blk[6] = 1'b0;
    assign proc_dep_vld_vec_11[6] = dl_detect_out ? proc_dep_vld_vec_11_reg[6] : (proc_11_data_FIFO_blk[6] | proc_11_data_PIPO_blk[6] | proc_11_start_FIFO_blk[6] | proc_11_TLF_FIFO_blk[6] | proc_11_input_sync_blk[6] | proc_11_output_sync_blk[6]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_11_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_11_reg <= proc_dep_vld_vec_11;
        end
    end
    assign in_chan_dep_vld_vec_11[0] = dep_chan_vld_4_11;
    assign in_chan_dep_data_vec_11[16 : 0] = dep_chan_data_4_11;
    assign token_in_vec_11[0] = token_4_11;
    assign in_chan_dep_vld_vec_11[1] = dep_chan_vld_5_11;
    assign in_chan_dep_data_vec_11[33 : 17] = dep_chan_data_5_11;
    assign token_in_vec_11[1] = token_5_11;
    assign in_chan_dep_vld_vec_11[2] = dep_chan_vld_7_11;
    assign in_chan_dep_data_vec_11[50 : 34] = dep_chan_data_7_11;
    assign token_in_vec_11[2] = token_7_11;
    assign in_chan_dep_vld_vec_11[3] = dep_chan_vld_8_11;
    assign in_chan_dep_data_vec_11[67 : 51] = dep_chan_data_8_11;
    assign token_in_vec_11[3] = token_8_11;
    assign in_chan_dep_vld_vec_11[4] = dep_chan_vld_9_11;
    assign in_chan_dep_data_vec_11[84 : 68] = dep_chan_data_9_11;
    assign token_in_vec_11[4] = token_9_11;
    assign in_chan_dep_vld_vec_11[5] = dep_chan_vld_10_11;
    assign in_chan_dep_data_vec_11[101 : 85] = dep_chan_data_10_11;
    assign token_in_vec_11[5] = token_10_11;
    assign in_chan_dep_vld_vec_11[6] = dep_chan_vld_12_11;
    assign in_chan_dep_data_vec_11[118 : 102] = dep_chan_data_12_11;
    assign token_in_vec_11[6] = token_12_11;
    assign in_chan_dep_vld_vec_11[7] = dep_chan_vld_13_11;
    assign in_chan_dep_data_vec_11[135 : 119] = dep_chan_data_13_11;
    assign token_in_vec_11[7] = token_13_11;
    assign dep_chan_vld_11_4 = out_chan_dep_vld_vec_11[0];
    assign dep_chan_data_11_4 = out_chan_dep_data_11;
    assign token_11_4 = token_out_vec_11[0];
    assign dep_chan_vld_11_5 = out_chan_dep_vld_vec_11[1];
    assign dep_chan_data_11_5 = out_chan_dep_data_11;
    assign token_11_5 = token_out_vec_11[1];
    assign dep_chan_vld_11_7 = out_chan_dep_vld_vec_11[2];
    assign dep_chan_data_11_7 = out_chan_dep_data_11;
    assign token_11_7 = token_out_vec_11[2];
    assign dep_chan_vld_11_8 = out_chan_dep_vld_vec_11[3];
    assign dep_chan_data_11_8 = out_chan_dep_data_11;
    assign token_11_8 = token_out_vec_11[3];
    assign dep_chan_vld_11_9 = out_chan_dep_vld_vec_11[4];
    assign dep_chan_data_11_9 = out_chan_dep_data_11;
    assign token_11_9 = token_out_vec_11[4];
    assign dep_chan_vld_11_10 = out_chan_dep_vld_vec_11[5];
    assign dep_chan_data_11_10 = out_chan_dep_data_11;
    assign token_11_10 = token_out_vec_11[5];
    assign dep_chan_vld_11_13 = out_chan_dep_vld_vec_11[6];
    assign dep_chan_data_11_13 = out_chan_dep_data_11;
    assign token_11_13 = token_out_vec_11[6];

    // Process: AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_pack_U0
    AESL_deadlock_detect_unit #(17, 12, 2, 3) AESL_deadlock_detect_unit_12 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_12),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_12),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_12),
        .token_in_vec(token_in_vec_12),
        .dl_detect_in(dl_detect_out),
        .origin(origin[12]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_12),
        .out_chan_dep_data(out_chan_dep_data_12),
        .token_out_vec(token_out_vec_12),
        .dl_detect_out(dl_in_vec[12]));

    assign proc_12_data_FIFO_blk[0] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_pack_U0.grp_p_anonymous_namespace_pack_Pipeline_VITIS_LOOP_423_2_fu_89.tensor_pixels_blk_n);
    assign proc_12_data_PIPO_blk[0] = 1'b0;
    assign proc_12_start_FIFO_blk[0] = 1'b0;
    assign proc_12_TLF_FIFO_blk[0] = 1'b0;
    assign proc_12_input_sync_blk[0] = 1'b0;
    assign proc_12_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_12[0] = dl_detect_out ? proc_dep_vld_vec_12_reg[0] : (proc_12_data_FIFO_blk[0] | proc_12_data_PIPO_blk[0] | proc_12_start_FIFO_blk[0] | proc_12_TLF_FIFO_blk[0] | proc_12_input_sync_blk[0] | proc_12_output_sync_blk[0]);
    assign proc_12_data_FIFO_blk[1] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_pack_U0.tensor_words_blk_n) | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_pack_U0.icmp_ln482_loc_c_blk_n);
    assign proc_12_data_PIPO_blk[1] = 1'b0;
    assign proc_12_start_FIFO_blk[1] = 1'b0;
    assign proc_12_TLF_FIFO_blk[1] = 1'b0;
    assign proc_12_input_sync_blk[1] = 1'b0;
    assign proc_12_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_12[1] = dl_detect_out ? proc_dep_vld_vec_12_reg[1] : (proc_12_data_FIFO_blk[1] | proc_12_data_PIPO_blk[1] | proc_12_start_FIFO_blk[1] | proc_12_TLF_FIFO_blk[1] | proc_12_input_sync_blk[1] | proc_12_output_sync_blk[1]);
    assign proc_12_data_FIFO_blk[2] = 1'b0;
    assign proc_12_data_PIPO_blk[2] = 1'b0;
    assign proc_12_start_FIFO_blk[2] = 1'b0;
    assign proc_12_TLF_FIFO_blk[2] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.icmp_ln482_loc_c35_channel_U.if_empty_n & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_pack_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.icmp_ln482_loc_c35_channel_U.if_write);
    assign proc_12_input_sync_blk[2] = 1'b0;
    assign proc_12_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_12[2] = dl_detect_out ? proc_dep_vld_vec_12_reg[2] : (proc_12_data_FIFO_blk[2] | proc_12_data_PIPO_blk[2] | proc_12_start_FIFO_blk[2] | proc_12_TLF_FIFO_blk[2] | proc_12_input_sync_blk[2] | proc_12_output_sync_blk[2]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_12_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_12_reg <= proc_dep_vld_vec_12;
        end
    end
    assign in_chan_dep_vld_vec_12[0] = dep_chan_vld_10_12;
    assign in_chan_dep_data_vec_12[16 : 0] = dep_chan_data_10_12;
    assign token_in_vec_12[0] = token_10_12;
    assign in_chan_dep_vld_vec_12[1] = dep_chan_vld_15_12;
    assign in_chan_dep_data_vec_12[33 : 17] = dep_chan_data_15_12;
    assign token_in_vec_12[1] = token_15_12;
    assign dep_chan_vld_12_10 = out_chan_dep_vld_vec_12[0];
    assign dep_chan_data_12_10 = out_chan_dep_data_12;
    assign token_12_10 = token_out_vec_12[0];
    assign dep_chan_vld_12_15 = out_chan_dep_vld_vec_12[1];
    assign dep_chan_data_12_15 = out_chan_dep_data_12;
    assign token_12_15 = token_out_vec_12[1];
    assign dep_chan_vld_12_11 = out_chan_dep_vld_vec_12[2];
    assign dep_chan_data_12_11 = out_chan_dep_data_12;
    assign token_12_11 = token_out_vec_12[2];

    // Process: AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_output_pass_Block_entry414_proc_U0
    AESL_deadlock_detect_unit #(17, 13, 8, 7) AESL_deadlock_detect_unit_13 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_13),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_13),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_13),
        .token_in_vec(token_in_vec_13),
        .dl_detect_in(dl_detect_out),
        .origin(origin[13]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_13),
        .out_chan_dep_data(out_chan_dep_data_13),
        .token_out_vec(token_out_vec_13),
        .dl_detect_out(dl_in_vec[13]));

    assign proc_13_data_FIFO_blk[0] = 1'b0;
    assign proc_13_data_PIPO_blk[0] = 1'b0;
    assign proc_13_start_FIFO_blk[0] = 1'b0;
    assign proc_13_TLF_FIFO_blk[0] = 1'b0;
    assign proc_13_input_sync_blk[0] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry414_proc_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_output_pass_Block_entry414_proc_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_entry_proc_U0_ap_ready);
    assign proc_13_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_13[0] = dl_detect_out ? proc_dep_vld_vec_13_reg[0] : (proc_13_data_FIFO_blk[0] | proc_13_data_PIPO_blk[0] | proc_13_start_FIFO_blk[0] | proc_13_TLF_FIFO_blk[0] | proc_13_input_sync_blk[0] | proc_13_output_sync_blk[0]);
    assign proc_13_data_FIFO_blk[1] = 1'b0;
    assign proc_13_data_PIPO_blk[1] = 1'b0;
    assign proc_13_start_FIFO_blk[1] = 1'b0;
    assign proc_13_TLF_FIFO_blk[1] = 1'b0;
    assign proc_13_input_sync_blk[1] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry414_proc_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_output_pass_Block_entry414_proc_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_read_words_1_U0_ap_ready);
    assign proc_13_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_13[1] = dl_detect_out ? proc_dep_vld_vec_13_reg[1] : (proc_13_data_FIFO_blk[1] | proc_13_data_PIPO_blk[1] | proc_13_start_FIFO_blk[1] | proc_13_TLF_FIFO_blk[1] | proc_13_input_sync_blk[1] | proc_13_output_sync_blk[1]);
    assign proc_13_data_FIFO_blk[2] = 1'b0;
    assign proc_13_data_PIPO_blk[2] = 1'b0;
    assign proc_13_start_FIFO_blk[2] = 1'b0;
    assign proc_13_TLF_FIFO_blk[2] = 1'b0;
    assign proc_13_input_sync_blk[2] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry414_proc_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_output_pass_Block_entry414_proc_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry47_proc_U0_ap_ready);
    assign proc_13_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_13[2] = dl_detect_out ? proc_dep_vld_vec_13_reg[2] : (proc_13_data_FIFO_blk[2] | proc_13_data_PIPO_blk[2] | proc_13_start_FIFO_blk[2] | proc_13_TLF_FIFO_blk[2] | proc_13_input_sync_blk[2] | proc_13_output_sync_blk[2]);
    assign proc_13_data_FIFO_blk[3] = 1'b0;
    assign proc_13_data_PIPO_blk[3] = 1'b0;
    assign proc_13_start_FIFO_blk[3] = 1'b0;
    assign proc_13_TLF_FIFO_blk[3] = 1'b0;
    assign proc_13_input_sync_blk[3] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry414_proc_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_output_pass_Block_entry414_proc_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_color_stage_U0_ap_ready);
    assign proc_13_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_13[3] = dl_detect_out ? proc_dep_vld_vec_13_reg[3] : (proc_13_data_FIFO_blk[3] | proc_13_data_PIPO_blk[3] | proc_13_start_FIFO_blk[3] | proc_13_TLF_FIFO_blk[3] | proc_13_input_sync_blk[3] | proc_13_output_sync_blk[3]);
    assign proc_13_data_FIFO_blk[4] = 1'b0;
    assign proc_13_data_PIPO_blk[4] = 1'b0;
    assign proc_13_start_FIFO_blk[4] = 1'b0;
    assign proc_13_TLF_FIFO_blk[4] = 1'b0;
    assign proc_13_input_sync_blk[4] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry414_proc_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_output_pass_Block_entry414_proc_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_collect_or_drain_U0_ap_ready);
    assign proc_13_output_sync_blk[4] = 1'b0;
    assign proc_dep_vld_vec_13[4] = dl_detect_out ? proc_dep_vld_vec_13_reg[4] : (proc_13_data_FIFO_blk[4] | proc_13_data_PIPO_blk[4] | proc_13_start_FIFO_blk[4] | proc_13_TLF_FIFO_blk[4] | proc_13_input_sync_blk[4] | proc_13_output_sync_blk[4]);
    assign proc_13_data_FIFO_blk[5] = 1'b0;
    assign proc_13_data_PIPO_blk[5] = 1'b0;
    assign proc_13_start_FIFO_blk[5] = 1'b0;
    assign proc_13_TLF_FIFO_blk[5] = 1'b0;
    assign proc_13_input_sync_blk[5] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry414_proc_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_output_pass_Block_entry414_proc_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_resize_and_split_U0_ap_ready);
    assign proc_13_output_sync_blk[5] = 1'b0;
    assign proc_dep_vld_vec_13[5] = dl_detect_out ? proc_dep_vld_vec_13_reg[5] : (proc_13_data_FIFO_blk[5] | proc_13_data_PIPO_blk[5] | proc_13_start_FIFO_blk[5] | proc_13_TLF_FIFO_blk[5] | proc_13_input_sync_blk[5] | proc_13_output_sync_blk[5]);
    assign proc_13_data_FIFO_blk[6] = 1'b0;
    assign proc_13_data_PIPO_blk[6] = 1'b0;
    assign proc_13_start_FIFO_blk[6] = 1'b0;
    assign proc_13_TLF_FIFO_blk[6] = 1'b0;
    assign proc_13_input_sync_blk[6] = 1'b0 | (AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry414_proc_U0_ap_ready & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_output_pass_Block_entry414_proc_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.ap_sync_p_anonymous_namespace_output_pass_Block_entry412_proc_U0_ap_ready);
    assign proc_13_output_sync_blk[6] = 1'b0;
    assign proc_dep_vld_vec_13[6] = dl_detect_out ? proc_dep_vld_vec_13_reg[6] : (proc_13_data_FIFO_blk[6] | proc_13_data_PIPO_blk[6] | proc_13_start_FIFO_blk[6] | proc_13_TLF_FIFO_blk[6] | proc_13_input_sync_blk[6] | proc_13_output_sync_blk[6]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_13_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_13_reg <= proc_dep_vld_vec_13;
        end
    end
    assign in_chan_dep_vld_vec_13[0] = dep_chan_vld_4_13;
    assign in_chan_dep_data_vec_13[16 : 0] = dep_chan_data_4_13;
    assign token_in_vec_13[0] = token_4_13;
    assign in_chan_dep_vld_vec_13[1] = dep_chan_vld_5_13;
    assign in_chan_dep_data_vec_13[33 : 17] = dep_chan_data_5_13;
    assign token_in_vec_13[1] = token_5_13;
    assign in_chan_dep_vld_vec_13[2] = dep_chan_vld_7_13;
    assign in_chan_dep_data_vec_13[50 : 34] = dep_chan_data_7_13;
    assign token_in_vec_13[2] = token_7_13;
    assign in_chan_dep_vld_vec_13[3] = dep_chan_vld_8_13;
    assign in_chan_dep_data_vec_13[67 : 51] = dep_chan_data_8_13;
    assign token_in_vec_13[3] = token_8_13;
    assign in_chan_dep_vld_vec_13[4] = dep_chan_vld_9_13;
    assign in_chan_dep_data_vec_13[84 : 68] = dep_chan_data_9_13;
    assign token_in_vec_13[4] = token_9_13;
    assign in_chan_dep_vld_vec_13[5] = dep_chan_vld_10_13;
    assign in_chan_dep_data_vec_13[101 : 85] = dep_chan_data_10_13;
    assign token_in_vec_13[5] = token_10_13;
    assign in_chan_dep_vld_vec_13[6] = dep_chan_vld_11_13;
    assign in_chan_dep_data_vec_13[118 : 102] = dep_chan_data_11_13;
    assign token_in_vec_13[6] = token_11_13;
    assign in_chan_dep_vld_vec_13[7] = dep_chan_vld_14_13;
    assign in_chan_dep_data_vec_13[135 : 119] = dep_chan_data_14_13;
    assign token_in_vec_13[7] = token_14_13;
    assign dep_chan_vld_13_4 = out_chan_dep_vld_vec_13[0];
    assign dep_chan_data_13_4 = out_chan_dep_data_13;
    assign token_13_4 = token_out_vec_13[0];
    assign dep_chan_vld_13_5 = out_chan_dep_vld_vec_13[1];
    assign dep_chan_data_13_5 = out_chan_dep_data_13;
    assign token_13_5 = token_out_vec_13[1];
    assign dep_chan_vld_13_7 = out_chan_dep_vld_vec_13[2];
    assign dep_chan_data_13_7 = out_chan_dep_data_13;
    assign token_13_7 = token_out_vec_13[2];
    assign dep_chan_vld_13_8 = out_chan_dep_vld_vec_13[3];
    assign dep_chan_data_13_8 = out_chan_dep_data_13;
    assign token_13_8 = token_out_vec_13[3];
    assign dep_chan_vld_13_9 = out_chan_dep_vld_vec_13[4];
    assign dep_chan_data_13_9 = out_chan_dep_data_13;
    assign token_13_9 = token_out_vec_13[4];
    assign dep_chan_vld_13_10 = out_chan_dep_vld_vec_13[5];
    assign dep_chan_data_13_10 = out_chan_dep_data_13;
    assign token_13_10 = token_out_vec_13[5];
    assign dep_chan_vld_13_11 = out_chan_dep_vld_vec_13[6];
    assign dep_chan_data_13_11 = out_chan_dep_data_13;
    assign token_13_11 = token_out_vec_13[6];

    // Process: AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_pack_3_U0
    AESL_deadlock_detect_unit #(17, 14, 3, 4) AESL_deadlock_detect_unit_14 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_14),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_14),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_14),
        .token_in_vec(token_in_vec_14),
        .dl_detect_in(dl_detect_out),
        .origin(origin[14]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_14),
        .out_chan_dep_data(out_chan_dep_data_14),
        .token_out_vec(token_out_vec_14),
        .dl_detect_out(dl_in_vec[14]));

    assign proc_14_data_FIFO_blk[0] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_pack_3_U0.grp_p_anonymous_namespace_pack_3_Pipeline_VITIS_LOOP_423_2_fu_127.preview_pixels_blk_n);
    assign proc_14_data_PIPO_blk[0] = 1'b0;
    assign proc_14_start_FIFO_blk[0] = 1'b0;
    assign proc_14_TLF_FIFO_blk[0] = 1'b0;
    assign proc_14_input_sync_blk[0] = 1'b0;
    assign proc_14_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_14[0] = dl_detect_out ? proc_dep_vld_vec_14_reg[0] : (proc_14_data_FIFO_blk[0] | proc_14_data_PIPO_blk[0] | proc_14_start_FIFO_blk[0] | proc_14_TLF_FIFO_blk[0] | proc_14_input_sync_blk[0] | proc_14_output_sync_blk[0]);
    assign proc_14_data_FIFO_blk[1] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_pack_3_U0.preview_words_blk_n) | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_pack_3_U0.width_c_blk_n) | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_pack_3_U0.height_c_blk_n) | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_pack_3_U0.icmp_ln483_loc_c_blk_n);
    assign proc_14_data_PIPO_blk[1] = 1'b0;
    assign proc_14_start_FIFO_blk[1] = 1'b0;
    assign proc_14_TLF_FIFO_blk[1] = 1'b0;
    assign proc_14_input_sync_blk[1] = 1'b0;
    assign proc_14_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_14[1] = dl_detect_out ? proc_dep_vld_vec_14_reg[1] : (proc_14_data_FIFO_blk[1] | proc_14_data_PIPO_blk[1] | proc_14_start_FIFO_blk[1] | proc_14_TLF_FIFO_blk[1] | proc_14_input_sync_blk[1] | proc_14_output_sync_blk[1]);
    assign proc_14_data_FIFO_blk[2] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_pack_3_U0.width_blk_n) | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_pack_3_U0.height_blk_n);
    assign proc_14_data_PIPO_blk[2] = 1'b0;
    assign proc_14_start_FIFO_blk[2] = 1'b0;
    assign proc_14_TLF_FIFO_blk[2] = 1'b0;
    assign proc_14_input_sync_blk[2] = 1'b0;
    assign proc_14_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_14[2] = dl_detect_out ? proc_dep_vld_vec_14_reg[2] : (proc_14_data_FIFO_blk[2] | proc_14_data_PIPO_blk[2] | proc_14_start_FIFO_blk[2] | proc_14_TLF_FIFO_blk[2] | proc_14_input_sync_blk[2] | proc_14_output_sync_blk[2]);
    assign proc_14_data_FIFO_blk[3] = 1'b0;
    assign proc_14_data_PIPO_blk[3] = 1'b0;
    assign proc_14_start_FIFO_blk[3] = 1'b0;
    assign proc_14_TLF_FIFO_blk[3] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.icmp_ln483_loc_c34_channel_U.if_empty_n & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_pack_3_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.icmp_ln483_loc_c34_channel_U.if_write);
    assign proc_14_input_sync_blk[3] = 1'b0;
    assign proc_14_output_sync_blk[3] = 1'b0;
    assign proc_dep_vld_vec_14[3] = dl_detect_out ? proc_dep_vld_vec_14_reg[3] : (proc_14_data_FIFO_blk[3] | proc_14_data_PIPO_blk[3] | proc_14_start_FIFO_blk[3] | proc_14_TLF_FIFO_blk[3] | proc_14_input_sync_blk[3] | proc_14_output_sync_blk[3]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_14_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_14_reg <= proc_dep_vld_vec_14;
        end
    end
    assign in_chan_dep_vld_vec_14[0] = dep_chan_vld_6_14;
    assign in_chan_dep_data_vec_14[16 : 0] = dep_chan_data_6_14;
    assign token_in_vec_14[0] = token_6_14;
    assign in_chan_dep_vld_vec_14[1] = dep_chan_vld_10_14;
    assign in_chan_dep_data_vec_14[33 : 17] = dep_chan_data_10_14;
    assign token_in_vec_14[1] = token_10_14;
    assign in_chan_dep_vld_vec_14[2] = dep_chan_vld_16_14;
    assign in_chan_dep_data_vec_14[50 : 34] = dep_chan_data_16_14;
    assign token_in_vec_14[2] = token_16_14;
    assign dep_chan_vld_14_10 = out_chan_dep_vld_vec_14[0];
    assign dep_chan_data_14_10 = out_chan_dep_data_14;
    assign token_14_10 = token_out_vec_14[0];
    assign dep_chan_vld_14_16 = out_chan_dep_vld_vec_14[1];
    assign dep_chan_data_14_16 = out_chan_dep_data_14;
    assign token_14_16 = token_out_vec_14[1];
    assign dep_chan_vld_14_6 = out_chan_dep_vld_vec_14[2];
    assign dep_chan_data_14_6 = out_chan_dep_data_14;
    assign token_14_6 = token_out_vec_14[2];
    assign dep_chan_vld_14_13 = out_chan_dep_vld_vec_14[3];
    assign dep_chan_data_14_13 = out_chan_dep_data_14;
    assign token_14_13 = token_out_vec_14[3];

    // Process: AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_write_words_U0
    AESL_deadlock_detect_unit #(17, 15, 4, 4) AESL_deadlock_detect_unit_15 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_15),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_15),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_15),
        .token_in_vec(token_in_vec_15),
        .dl_detect_in(dl_detect_out),
        .origin(origin[15]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_15),
        .out_chan_dep_data(out_chan_dep_data_15),
        .token_out_vec(token_out_vec_15),
        .dl_detect_out(dl_in_vec[15]));

    assign proc_15_data_FIFO_blk[0] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_write_words_U0.tensor_blk_n);
    assign proc_15_data_PIPO_blk[0] = 1'b0;
    assign proc_15_start_FIFO_blk[0] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.start_for_p_anonymous_namespace_write_words_U0_U.if_empty_n & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_write_words_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.start_for_p_anonymous_namespace_write_words_U0_U.if_write);
    assign proc_15_TLF_FIFO_blk[0] = 1'b0;
    assign proc_15_input_sync_blk[0] = 1'b0;
    assign proc_15_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_15[0] = dl_detect_out ? proc_dep_vld_vec_15_reg[0] : (proc_15_data_FIFO_blk[0] | proc_15_data_PIPO_blk[0] | proc_15_start_FIFO_blk[0] | proc_15_TLF_FIFO_blk[0] | proc_15_input_sync_blk[0] | proc_15_output_sync_blk[0]);
    assign proc_15_data_FIFO_blk[1] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_write_words_U0.grp_p_anonymous_namespace_write_words_Pipeline_VITIS_LOOP_444_1_VITIS_LOOP_446_2_fu_76.tensor_words_blk_n) | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_write_words_U0.icmp_ln482_loc_blk_n);
    assign proc_15_data_PIPO_blk[1] = 1'b0;
    assign proc_15_start_FIFO_blk[1] = 1'b0;
    assign proc_15_TLF_FIFO_blk[1] = 1'b0;
    assign proc_15_input_sync_blk[1] = 1'b0;
    assign proc_15_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_15[1] = dl_detect_out ? proc_dep_vld_vec_15_reg[1] : (proc_15_data_FIFO_blk[1] | proc_15_data_PIPO_blk[1] | proc_15_start_FIFO_blk[1] | proc_15_TLF_FIFO_blk[1] | proc_15_input_sync_blk[1] | proc_15_output_sync_blk[1]);
    assign proc_15_data_FIFO_blk[2] = 1'b0;
    assign proc_15_data_PIPO_blk[2] = 1'b0;
    assign proc_15_start_FIFO_blk[2] = 1'b0;
    assign proc_15_TLF_FIFO_blk[2] = 1'b0;
    assign proc_15_input_sync_blk[2] = 1'b0;
    assign proc_15_output_sync_blk[2] = 1'b0 | (ap_done_reg_6 & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_write_words_U0.ap_done & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_collect_or_drain_U0.ap_done);
    assign proc_dep_vld_vec_15[2] = dl_detect_out ? proc_dep_vld_vec_15_reg[2] : (proc_15_data_FIFO_blk[2] | proc_15_data_PIPO_blk[2] | proc_15_start_FIFO_blk[2] | proc_15_TLF_FIFO_blk[2] | proc_15_input_sync_blk[2] | proc_15_output_sync_blk[2]);
    assign proc_15_data_FIFO_blk[3] = 1'b0;
    assign proc_15_data_PIPO_blk[3] = 1'b0;
    assign proc_15_start_FIFO_blk[3] = 1'b0;
    assign proc_15_TLF_FIFO_blk[3] = 1'b0;
    assign proc_15_input_sync_blk[3] = 1'b0;
    assign proc_15_output_sync_blk[3] = 1'b0 | (ap_done_reg_6 & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_write_words_U0.ap_done & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_write_words_4_U0.ap_done);
    assign proc_dep_vld_vec_15[3] = dl_detect_out ? proc_dep_vld_vec_15_reg[3] : (proc_15_data_FIFO_blk[3] | proc_15_data_PIPO_blk[3] | proc_15_start_FIFO_blk[3] | proc_15_TLF_FIFO_blk[3] | proc_15_input_sync_blk[3] | proc_15_output_sync_blk[3]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_15_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_15_reg <= proc_dep_vld_vec_15;
        end
    end
    assign in_chan_dep_vld_vec_15[0] = dep_chan_vld_4_15;
    assign in_chan_dep_data_vec_15[16 : 0] = dep_chan_data_4_15;
    assign token_in_vec_15[0] = token_4_15;
    assign in_chan_dep_vld_vec_15[1] = dep_chan_vld_9_15;
    assign in_chan_dep_data_vec_15[33 : 17] = dep_chan_data_9_15;
    assign token_in_vec_15[1] = token_9_15;
    assign in_chan_dep_vld_vec_15[2] = dep_chan_vld_12_15;
    assign in_chan_dep_data_vec_15[50 : 34] = dep_chan_data_12_15;
    assign token_in_vec_15[2] = token_12_15;
    assign in_chan_dep_vld_vec_15[3] = dep_chan_vld_16_15;
    assign in_chan_dep_data_vec_15[67 : 51] = dep_chan_data_16_15;
    assign token_in_vec_15[3] = token_16_15;
    assign dep_chan_vld_15_4 = out_chan_dep_vld_vec_15[0];
    assign dep_chan_data_15_4 = out_chan_dep_data_15;
    assign token_15_4 = token_out_vec_15[0];
    assign dep_chan_vld_15_12 = out_chan_dep_vld_vec_15[1];
    assign dep_chan_data_15_12 = out_chan_dep_data_15;
    assign token_15_12 = token_out_vec_15[1];
    assign dep_chan_vld_15_9 = out_chan_dep_vld_vec_15[2];
    assign dep_chan_data_15_9 = out_chan_dep_data_15;
    assign token_15_9 = token_out_vec_15[2];
    assign dep_chan_vld_15_16 = out_chan_dep_vld_vec_15[3];
    assign dep_chan_data_15_16 = out_chan_dep_data_15;
    assign token_15_16 = token_out_vec_15[3];

    // Process: AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_write_words_4_U0
    AESL_deadlock_detect_unit #(17, 16, 4, 4) AESL_deadlock_detect_unit_16 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_16),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_16),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_16),
        .token_in_vec(token_in_vec_16),
        .dl_detect_in(dl_detect_out),
        .origin(origin[16]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_16),
        .out_chan_dep_data(out_chan_dep_data_16),
        .token_out_vec(token_out_vec_16),
        .dl_detect_out(dl_in_vec[16]));

    assign proc_16_data_FIFO_blk[0] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_write_words_4_U0.preview_blk_n) | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_write_words_4_U0.preview_stride_blk_n);
    assign proc_16_data_PIPO_blk[0] = 1'b0;
    assign proc_16_start_FIFO_blk[0] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.start_for_p_anonymous_namespace_write_words_4_U0_U.if_empty_n & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_write_words_4_U0.ap_idle & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.start_for_p_anonymous_namespace_write_words_4_U0_U.if_write);
    assign proc_16_TLF_FIFO_blk[0] = 1'b0;
    assign proc_16_input_sync_blk[0] = 1'b0;
    assign proc_16_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_16[0] = dl_detect_out ? proc_dep_vld_vec_16_reg[0] : (proc_16_data_FIFO_blk[0] | proc_16_data_PIPO_blk[0] | proc_16_start_FIFO_blk[0] | proc_16_TLF_FIFO_blk[0] | proc_16_input_sync_blk[0] | proc_16_output_sync_blk[0]);
    assign proc_16_data_FIFO_blk[1] = 1'b0 | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_write_words_4_U0.grp_p_anonymous_namespace_write_words_4_Pipeline_VITIS_LOOP_446_2_fu_137.preview_words_blk_n) | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_write_words_4_U0.width_blk_n) | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_write_words_4_U0.height_blk_n) | (~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_write_words_4_U0.icmp_ln483_loc_blk_n);
    assign proc_16_data_PIPO_blk[1] = 1'b0;
    assign proc_16_start_FIFO_blk[1] = 1'b0;
    assign proc_16_TLF_FIFO_blk[1] = 1'b0;
    assign proc_16_input_sync_blk[1] = 1'b0;
    assign proc_16_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_16[1] = dl_detect_out ? proc_dep_vld_vec_16_reg[1] : (proc_16_data_FIFO_blk[1] | proc_16_data_PIPO_blk[1] | proc_16_start_FIFO_blk[1] | proc_16_TLF_FIFO_blk[1] | proc_16_input_sync_blk[1] | proc_16_output_sync_blk[1]);
    assign proc_16_data_FIFO_blk[2] = 1'b0;
    assign proc_16_data_PIPO_blk[2] = 1'b0;
    assign proc_16_start_FIFO_blk[2] = 1'b0;
    assign proc_16_TLF_FIFO_blk[2] = 1'b0;
    assign proc_16_input_sync_blk[2] = 1'b0;
    assign proc_16_output_sync_blk[2] = 1'b0 | (ap_done_reg_7 & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_write_words_4_U0.ap_done & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_collect_or_drain_U0.ap_done);
    assign proc_dep_vld_vec_16[2] = dl_detect_out ? proc_dep_vld_vec_16_reg[2] : (proc_16_data_FIFO_blk[2] | proc_16_data_PIPO_blk[2] | proc_16_start_FIFO_blk[2] | proc_16_TLF_FIFO_blk[2] | proc_16_input_sync_blk[2] | proc_16_output_sync_blk[2]);
    assign proc_16_data_FIFO_blk[3] = 1'b0;
    assign proc_16_data_PIPO_blk[3] = 1'b0;
    assign proc_16_start_FIFO_blk[3] = 1'b0;
    assign proc_16_TLF_FIFO_blk[3] = 1'b0;
    assign proc_16_input_sync_blk[3] = 1'b0;
    assign proc_16_output_sync_blk[3] = 1'b0 | (ap_done_reg_7 & AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_write_words_4_U0.ap_done & ~AESL_inst_image_preprocess.grp_p_anonymous_namespace_output_pass_fu_618.p_anonymous_namespace_write_words_U0.ap_done);
    assign proc_dep_vld_vec_16[3] = dl_detect_out ? proc_dep_vld_vec_16_reg[3] : (proc_16_data_FIFO_blk[3] | proc_16_data_PIPO_blk[3] | proc_16_start_FIFO_blk[3] | proc_16_TLF_FIFO_blk[3] | proc_16_input_sync_blk[3] | proc_16_output_sync_blk[3]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_16_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_16_reg <= proc_dep_vld_vec_16;
        end
    end
    assign in_chan_dep_vld_vec_16[0] = dep_chan_vld_4_16;
    assign in_chan_dep_data_vec_16[16 : 0] = dep_chan_data_4_16;
    assign token_in_vec_16[0] = token_4_16;
    assign in_chan_dep_vld_vec_16[1] = dep_chan_vld_9_16;
    assign in_chan_dep_data_vec_16[33 : 17] = dep_chan_data_9_16;
    assign token_in_vec_16[1] = token_9_16;
    assign in_chan_dep_vld_vec_16[2] = dep_chan_vld_14_16;
    assign in_chan_dep_data_vec_16[50 : 34] = dep_chan_data_14_16;
    assign token_in_vec_16[2] = token_14_16;
    assign in_chan_dep_vld_vec_16[3] = dep_chan_vld_15_16;
    assign in_chan_dep_data_vec_16[67 : 51] = dep_chan_data_15_16;
    assign token_in_vec_16[3] = token_15_16;
    assign dep_chan_vld_16_4 = out_chan_dep_vld_vec_16[0];
    assign dep_chan_data_16_4 = out_chan_dep_data_16;
    assign token_16_4 = token_out_vec_16[0];
    assign dep_chan_vld_16_14 = out_chan_dep_vld_vec_16[1];
    assign dep_chan_data_16_14 = out_chan_dep_data_16;
    assign token_16_14 = token_out_vec_16[1];
    assign dep_chan_vld_16_9 = out_chan_dep_vld_vec_16[2];
    assign dep_chan_data_16_9 = out_chan_dep_data_16;
    assign token_16_9 = token_out_vec_16[2];
    assign dep_chan_vld_16_15 = out_chan_dep_vld_vec_16[3];
    assign dep_chan_data_16_15 = out_chan_dep_data_16;
    assign token_16_15 = token_out_vec_16[3];


    wire [16:0] dl_in_vec_comb = dl_in_vec & ~{16{all_finish}};
    AESL_deadlock_report_unit #(17) AESL_deadlock_report_unit_inst (
        .dl_reset(dl_reset),
        .dl_clock(dl_clock),
        .dl_in_vec(dl_in_vec_comb),
        .trans_in_cnt_0(trans_in_cnt_0),
        .trans_out_cnt_0(trans_out_cnt_0),
        .trans_in_cnt_1(trans_in_cnt_1),
        .trans_out_cnt_1(trans_out_cnt_1),
        .trans_in_cnt_2(trans_in_cnt_2),
        .trans_out_cnt_2(trans_out_cnt_2),
        .ap_done_reg_0(ap_done_reg_0),
        .ap_done_reg_1(ap_done_reg_1),
        .ap_done_reg_2(ap_done_reg_2),
        .ap_done_reg_3(ap_done_reg_3),
        .ap_done_reg_4(ap_done_reg_4),
        .ap_done_reg_5(ap_done_reg_5),
        .ap_done_reg_6(ap_done_reg_6),
        .ap_done_reg_7(ap_done_reg_7),
        .dl_detect_out(dl_detect_out),
        .origin(origin),
        .token_clear(token_clear));

endmodule
