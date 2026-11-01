// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
// Tool Version Limit: 2022.04
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// ==============================================================

`timescale 1 ns / 1 ps

module AESL_axi_slave_control (
    clk,
    reset,
    TRAN_s_axi_control_AWADDR,
    TRAN_s_axi_control_AWVALID,
    TRAN_s_axi_control_AWREADY,
    TRAN_s_axi_control_WVALID,
    TRAN_s_axi_control_WREADY,
    TRAN_s_axi_control_WDATA,
    TRAN_s_axi_control_WSTRB,
    TRAN_s_axi_control_ARADDR,
    TRAN_s_axi_control_ARVALID,
    TRAN_s_axi_control_ARREADY,
    TRAN_s_axi_control_RVALID,
    TRAN_s_axi_control_RREADY,
    TRAN_s_axi_control_RDATA,
    TRAN_s_axi_control_RRESP,
    TRAN_s_axi_control_BVALID,
    TRAN_s_axi_control_BREADY,
    TRAN_s_axi_control_BRESP,
    TRAN_control_write_data_finish,
    TRAN_control_read_data_finish,
    TRAN_control_start_in,
    TRAN_control_idle_out,
    TRAN_control_ready_out,
    TRAN_control_ready_in,
    TRAN_control_done_out,
    TRAN_control_write_start_in   ,
    TRAN_control_write_start_finish,
    TRAN_control_interrupt,
    TRAN_control_transaction_done_in
    );

//------------------------Parameter----------------------
`define TV_IN_input_r "../tv/cdatafile/c.yolo_postprocess.autotvin_input_r.dat"
`define TV_IN_tables "../tv/cdatafile/c.yolo_postprocess.autotvin_tables.dat"
`define TV_IN_output_r "../tv/cdatafile/c.yolo_postprocess.autotvin_output_r.dat"
`define TV_IN_input_words "../tv/cdatafile/c.yolo_postprocess.autotvin_input_words.dat"
`define TV_IN_table_words "../tv/cdatafile/c.yolo_postprocess.autotvin_table_words.dat"
`define TV_IN_output_capacity "../tv/cdatafile/c.yolo_postprocess.autotvin_output_capacity.dat"
`define TV_IN_confidence_q30 "../tv/cdatafile/c.yolo_postprocess.autotvin_confidence_q30.dat"
`define TV_IN_nms_q16 "../tv/cdatafile/c.yolo_postprocess.autotvin_nms_q16.dat"
`define TV_IN_enable_nms "../tv/cdatafile/c.yolo_postprocess.autotvin_enable_nms.dat"
`define TV_OUT_candidate_count "../tv/rtldatafile/rtl.yolo_postprocess.autotvout_candidate_count.dat"
`define TV_OUT_detection_count "../tv/rtldatafile/rtl.yolo_postprocess.autotvout_detection_count.dat"
`define TV_OUT_ap_return "../tv/rtldatafile/rtl.yolo_postprocess.autotvout_ap_return.dat"
parameter ADDR_WIDTH = 8;
parameter DATA_WIDTH = 32;
parameter input_r_DEPTH = 1;
reg [31 : 0] input_r_OPERATE_DEPTH = 0;
parameter input_r_c_bitwidth = 64;
parameter tables_DEPTH = 1;
reg [31 : 0] tables_OPERATE_DEPTH = 0;
parameter tables_c_bitwidth = 64;
parameter output_r_DEPTH = 1;
reg [31 : 0] output_r_OPERATE_DEPTH = 0;
parameter output_r_c_bitwidth = 64;
parameter input_words_DEPTH = 1;
reg [31 : 0] input_words_OPERATE_DEPTH = 0;
parameter input_words_c_bitwidth = 32;
parameter table_words_DEPTH = 1;
reg [31 : 0] table_words_OPERATE_DEPTH = 0;
parameter table_words_c_bitwidth = 32;
parameter output_capacity_DEPTH = 1;
reg [31 : 0] output_capacity_OPERATE_DEPTH = 0;
parameter output_capacity_c_bitwidth = 32;
parameter confidence_q30_DEPTH = 1;
reg [31 : 0] confidence_q30_OPERATE_DEPTH = 0;
parameter confidence_q30_c_bitwidth = 32;
parameter nms_q16_DEPTH = 1;
reg [31 : 0] nms_q16_OPERATE_DEPTH = 0;
parameter nms_q16_c_bitwidth = 32;
parameter enable_nms_DEPTH = 1;
reg [31 : 0] enable_nms_OPERATE_DEPTH = 0;
parameter enable_nms_c_bitwidth = 32;
parameter candidate_count_DEPTH = 1;
reg [31 : 0] candidate_count_OPERATE_DEPTH = 0;
parameter candidate_count_c_bitwidth = 32;
parameter detection_count_DEPTH = 1;
reg [31 : 0] detection_count_OPERATE_DEPTH = 0;
parameter detection_count_c_bitwidth = 32;
parameter ap_return_DEPTH = 1;
reg [31 : 0] ap_return_OPERATE_DEPTH = 0;
parameter ap_return_c_bitwidth = 32;
parameter START_ADDR = 0;
parameter yolo_postprocess_continue_addr = 0;
parameter yolo_postprocess_auto_start_addr = 0;
parameter input_r_data_in_addr = 24;
parameter tables_data_in_addr = 36;
parameter output_r_data_in_addr = 48;
parameter input_words_data_in_addr = 60;
parameter table_words_data_in_addr = 68;
parameter output_capacity_data_in_addr = 76;
parameter confidence_q30_data_in_addr = 84;
parameter nms_q16_data_in_addr = 92;
parameter enable_nms_data_in_addr = 100;
parameter ap_return_data_out_addr = 16;
parameter candidate_count_data_out_addr = 108;
parameter candidate_count_valid_out_addr = 112;
parameter detection_count_data_out_addr = 124;
parameter detection_count_valid_out_addr = 128;
parameter STATUS_ADDR = 0;

output [ADDR_WIDTH - 1 : 0] TRAN_s_axi_control_AWADDR;
output  TRAN_s_axi_control_AWVALID;
input  TRAN_s_axi_control_AWREADY;
output  TRAN_s_axi_control_WVALID;
input  TRAN_s_axi_control_WREADY;
output [DATA_WIDTH - 1 : 0] TRAN_s_axi_control_WDATA;
output [DATA_WIDTH/8 - 1 : 0] TRAN_s_axi_control_WSTRB;
output [ADDR_WIDTH - 1 : 0] TRAN_s_axi_control_ARADDR;
output  TRAN_s_axi_control_ARVALID;
input  TRAN_s_axi_control_ARREADY;
input  TRAN_s_axi_control_RVALID;
output  TRAN_s_axi_control_RREADY;
input [DATA_WIDTH - 1 : 0] TRAN_s_axi_control_RDATA;
input [2 - 1 : 0] TRAN_s_axi_control_RRESP;
input  TRAN_s_axi_control_BVALID;
output  TRAN_s_axi_control_BREADY;
input [2 - 1 : 0] TRAN_s_axi_control_BRESP;
output TRAN_control_write_data_finish;
output TRAN_control_read_data_finish;
input     clk;
input     reset;
input     TRAN_control_start_in;
output    TRAN_control_done_out;
output    TRAN_control_ready_out;
input     TRAN_control_ready_in;
output    TRAN_control_idle_out;
input  TRAN_control_write_start_in   ;
output TRAN_control_write_start_finish;
input     TRAN_control_interrupt;
input     TRAN_control_transaction_done_in;

reg [ADDR_WIDTH - 1 : 0] AWADDR_reg = 0;
reg  AWVALID_reg = 0;
reg  WVALID_reg = 0;
reg [DATA_WIDTH - 1 : 0] WDATA_reg = 0;
reg [DATA_WIDTH/8 - 1 : 0] WSTRB_reg = 0;
reg [ADDR_WIDTH - 1 : 0] ARADDR_reg = 0;
reg  ARVALID_reg = 0;
reg  RREADY_reg = 0;
reg [DATA_WIDTH - 1 : 0] RDATA_reg = 0;
reg  BREADY_reg = 0;
reg [input_r_c_bitwidth - 1 : 0] mem_input_r [input_r_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_input_r [ (input_r_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * input_r_DEPTH -1 : 0] = '{default : 'hz};
reg input_r_write_data_finish;
reg [tables_c_bitwidth - 1 : 0] mem_tables [tables_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_tables [ (tables_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * tables_DEPTH -1 : 0] = '{default : 'hz};
reg tables_write_data_finish;
reg [output_r_c_bitwidth - 1 : 0] mem_output_r [output_r_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_output_r [ (output_r_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * output_r_DEPTH -1 : 0] = '{default : 'hz};
reg output_r_write_data_finish;
reg [DATA_WIDTH - 1 : 0] mem_input_words [input_words_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_input_words [ (input_words_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * input_words_DEPTH -1 : 0] = '{default : 'hz};
reg input_words_write_data_finish;
reg [DATA_WIDTH - 1 : 0] mem_table_words [table_words_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_table_words [ (table_words_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * table_words_DEPTH -1 : 0] = '{default : 'hz};
reg table_words_write_data_finish;
reg [DATA_WIDTH - 1 : 0] mem_output_capacity [output_capacity_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_output_capacity [ (output_capacity_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * output_capacity_DEPTH -1 : 0] = '{default : 'hz};
reg output_capacity_write_data_finish;
reg [DATA_WIDTH - 1 : 0] mem_confidence_q30 [confidence_q30_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_confidence_q30 [ (confidence_q30_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * confidence_q30_DEPTH -1 : 0] = '{default : 'hz};
reg confidence_q30_write_data_finish;
reg [DATA_WIDTH - 1 : 0] mem_nms_q16 [nms_q16_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_nms_q16 [ (nms_q16_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * nms_q16_DEPTH -1 : 0] = '{default : 'hz};
reg nms_q16_write_data_finish;
reg [DATA_WIDTH - 1 : 0] mem_enable_nms [enable_nms_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_enable_nms [ (enable_nms_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * enable_nms_DEPTH -1 : 0] = '{default : 'hz};
reg enable_nms_write_data_finish;
reg [DATA_WIDTH - 1 : 0] mem_candidate_count [candidate_count_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_candidate_count [ (candidate_count_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * candidate_count_DEPTH -1 : 0] = '{default : 'hz};
reg candidate_count_read_data_finish;
reg [DATA_WIDTH - 1 : 0] mem_detection_count [detection_count_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_detection_count [ (detection_count_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * detection_count_DEPTH -1 : 0] = '{default : 'hz};
reg detection_count_read_data_finish;
reg [DATA_WIDTH - 1 : 0] mem_ap_return [ap_return_DEPTH - 1 : 0] = '{default : 'h0};
reg [DATA_WIDTH-1 : 0] image_mem_ap_return [ (ap_return_c_bitwidth+DATA_WIDTH-1)/DATA_WIDTH * ap_return_DEPTH -1 : 0] = '{default : 'hz};
reg ap_return_read_data_finish;
reg AESL_ready_out_index_reg = 0;
reg AESL_write_start_finish = 0;
reg AESL_ready_reg;
reg ready_initial;
reg AESL_done_index_reg = 0;
reg AESL_idle_index_reg = 0;
reg AESL_auto_restart_index_reg;
reg process_0_finish = 0;
reg process_1_finish = 0;
reg process_2_finish = 0;
reg process_3_finish = 0;
reg process_4_finish = 0;
reg process_5_finish = 0;
reg process_6_finish = 0;
reg process_7_finish = 0;
reg process_8_finish = 0;
reg process_9_finish = 0;
reg process_10_finish = 0;
reg process_11_finish = 0;
reg process_12_finish = 0;
reg process_13_finish = 0;
//write input_r reg
reg [31 : 0] write_input_r_count = 0;
reg write_input_r_run_flag = 0;
reg write_one_input_r_data_done = 0;
//write tables reg
reg [31 : 0] write_tables_count = 0;
reg write_tables_run_flag = 0;
reg write_one_tables_data_done = 0;
//write output_r reg
reg [31 : 0] write_output_r_count = 0;
reg write_output_r_run_flag = 0;
reg write_one_output_r_data_done = 0;
//write input_words reg
reg [31 : 0] write_input_words_count = 0;
reg write_input_words_run_flag = 0;
reg write_one_input_words_data_done = 0;
//write table_words reg
reg [31 : 0] write_table_words_count = 0;
reg write_table_words_run_flag = 0;
reg write_one_table_words_data_done = 0;
//write output_capacity reg
reg [31 : 0] write_output_capacity_count = 0;
reg write_output_capacity_run_flag = 0;
reg write_one_output_capacity_data_done = 0;
//write confidence_q30 reg
reg [31 : 0] write_confidence_q30_count = 0;
reg write_confidence_q30_run_flag = 0;
reg write_one_confidence_q30_data_done = 0;
//write nms_q16 reg
reg [31 : 0] write_nms_q16_count = 0;
reg write_nms_q16_run_flag = 0;
reg write_one_nms_q16_data_done = 0;
//write enable_nms reg
reg [31 : 0] write_enable_nms_count = 0;
reg write_enable_nms_run_flag = 0;
reg write_one_enable_nms_data_done = 0;
//read candidate_count reg
reg [31 : 0] read_candidate_count_count = 0;
reg read_candidate_count_run_flag = 0;
reg read_one_candidate_count_data_done = 0;
//read detection_count reg
reg [31 : 0] read_detection_count_count = 0;
reg read_detection_count_run_flag = 0;
reg read_one_detection_count_data_done = 0;
//read ap_return reg
reg [31 : 0] read_ap_return_count = 0;
reg read_ap_return_run_flag = 0;
reg read_one_ap_return_data_done = 0;
reg [31 : 0] write_start_count = 0;
reg write_start_run_flag = 0;

//===================process control=================
reg [31 : 0] ongoing_process_number = 0;
//process number depends on how much processes needed.
reg process_busy = 0;

//=================== signal connection ==============
assign TRAN_s_axi_control_AWADDR = AWADDR_reg;
assign TRAN_s_axi_control_AWVALID = AWVALID_reg;
assign TRAN_s_axi_control_WVALID = WVALID_reg;
assign TRAN_s_axi_control_WDATA = WDATA_reg;
assign TRAN_s_axi_control_WSTRB = WSTRB_reg;
assign TRAN_s_axi_control_ARADDR = ARADDR_reg;
assign TRAN_s_axi_control_ARVALID = ARVALID_reg;
assign TRAN_s_axi_control_RREADY = RREADY_reg;
assign TRAN_s_axi_control_BREADY = BREADY_reg;
assign TRAN_control_write_start_finish = AESL_write_start_finish;
assign TRAN_control_done_out = AESL_done_index_reg;
assign TRAN_control_ready_out = AESL_ready_out_index_reg;
assign TRAN_control_idle_out = AESL_idle_index_reg;
assign TRAN_control_read_data_finish = 1 & candidate_count_read_data_finish & detection_count_read_data_finish & ap_return_read_data_finish;
assign TRAN_control_write_data_finish = 1 & input_r_write_data_finish & tables_write_data_finish & output_r_write_data_finish & input_words_write_data_finish & table_words_write_data_finish & output_capacity_write_data_finish & confidence_q30_write_data_finish & nms_q16_write_data_finish & enable_nms_write_data_finish;
always @(TRAN_control_ready_in or ready_initial) 
begin
    AESL_ready_reg <= TRAN_control_ready_in | ready_initial;
end

always @(reset or process_0_finish or process_1_finish or process_2_finish or process_3_finish or process_4_finish or process_5_finish or process_6_finish or process_7_finish or process_8_finish or process_9_finish or process_10_finish or process_11_finish or process_12_finish or process_13_finish ) begin
    if (reset == 0) begin
        ongoing_process_number <= 0;
    end
    else if (ongoing_process_number == 0 && process_0_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 1 && process_1_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 2 && process_2_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 3 && process_3_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 4 && process_4_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 5 && process_5_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 6 && process_6_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 7 && process_7_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 8 && process_8_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 9 && process_9_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 10 && process_10_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 11 && process_11_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 12 && process_12_finish == 1) begin
            ongoing_process_number <= ongoing_process_number + 1;
    end
    else if (ongoing_process_number == 13 && process_13_finish == 1) begin
            ongoing_process_number <= 0;
    end
end

task count_c_data_four_byte_num_by_bitwidth;
input  integer bitwidth;
output integer num;
integer factor;
integer i;
begin
    factor = 32;
    for (i = 1; i <= 1024; i = i + 1) begin
        if (bitwidth <= factor && bitwidth > factor - 32) begin
            num = i;
        end
        factor = factor + 32;
    end
end    
endtask

task count_seperate_factor_by_bitwidth;
input  integer bitwidth;
output integer factor;
begin
    if (bitwidth <= 8) begin
        factor=4;
    end
    if (bitwidth <= 16 & bitwidth > 8 ) begin
        factor=2;
    end
    if (bitwidth <= 32 & bitwidth > 16 ) begin
        factor=1;
    end
    if (bitwidth > 32 ) begin
        factor=1;
    end
end    
endtask

task count_operate_depth_by_bitwidth_and_depth;
input  integer bitwidth;
input  integer depth;
output integer operate_depth;
integer factor;
integer remain;
begin
    count_seperate_factor_by_bitwidth (bitwidth , factor);
    operate_depth = depth / factor;
    remain = depth % factor;
    if (remain > 0) begin
        operate_depth = operate_depth + 1;
    end
end    
endtask

task write; /*{{{*/
    input  reg [ADDR_WIDTH - 1:0] waddr;   // write address
    input  reg [DATA_WIDTH - 1:0] wdata;   // write data
    output reg wresp;
    reg aw_flag;
    reg w_flag;
    reg [DATA_WIDTH/8 - 1:0] wstrb_reg;
    integer i;
begin 
    wresp = 0;
    aw_flag = 0;
    w_flag = 0;
//=======================one single write operate======================
    AWADDR_reg <= waddr;
    AWVALID_reg <= 1;
    WDATA_reg <= wdata;
    WVALID_reg <= 1;
    for (i = 0; i < DATA_WIDTH/8; i = i + 1) begin
        wstrb_reg [i] = 1;
    end    
    WSTRB_reg <= wstrb_reg;
    while (!(aw_flag && w_flag)) begin
        @(posedge clk);
        if (aw_flag != 1)
            aw_flag = TRAN_s_axi_control_AWREADY & AWVALID_reg;
        if (w_flag != 1)
            w_flag = TRAN_s_axi_control_WREADY & WVALID_reg;
        AWVALID_reg <= !aw_flag;
        WVALID_reg <= !w_flag;
    end

    BREADY_reg <= 1;
    while (TRAN_s_axi_control_BVALID != 1) begin
        //wait for response 
        @(posedge clk);
    end
    @(posedge clk);
    BREADY_reg <= 0;
    if (TRAN_s_axi_control_BRESP === 2'b00) begin
        wresp = 1;
        //input success. in fact BRESP is always 2'b00
    end   
//=======================one single write operate======================

end
endtask/*}}}*/

task read (/*{{{*/
    input  [ADDR_WIDTH - 1:0] raddr ,   // write address
    output [DATA_WIDTH - 1:0] RDATA_result ,
    output rresp
);
begin 
    rresp = 0;
//=======================one single read operate======================
    ARADDR_reg <= raddr;
    ARVALID_reg <= 1;
    while (TRAN_s_axi_control_ARREADY !== 1) begin
        @(posedge clk);
    end
    @(posedge clk);
    ARVALID_reg <= 0;
    RREADY_reg <= 1;
    while (TRAN_s_axi_control_RVALID !== 1) begin
        //wait for response 
        @(posedge clk);
    end
    @(posedge clk);
    RDATA_result  <= TRAN_s_axi_control_RDATA;
    RREADY_reg <= 0;
    if (TRAN_s_axi_control_RRESP === 2'b00 ) begin
        rresp <= 1;
        //output success. in fact RRESP is always 2'b00
    end  
    @(posedge clk);

//=======================one single read operate end======================

end
endtask/*}}}*/

initial begin : ready_initial_process
    ready_initial = 0;
    wait(reset === 1);
    @(posedge clk);
    ready_initial = 1;
    @(posedge clk);
    ready_initial = 0;
end

initial begin : update_status
    integer process_num ;
    integer read_status_resp;
    wait(reset === 1);
    @(posedge clk);
    process_num = 0;
    while (1) begin
        process_0_finish = 0;
        AESL_done_index_reg         <= 0;
        AESL_ready_out_index_reg        <= 0;
        if (ongoing_process_number === process_num && process_busy === 0) begin
            process_busy = 1;
            read (STATUS_ADDR, RDATA_reg, read_status_resp);
                AESL_done_index_reg         <= RDATA_reg[1 : 1];
                AESL_ready_out_index_reg    <= RDATA_reg[1 : 1];
                AESL_idle_index_reg         <= RDATA_reg[2 : 2];
            process_0_finish = 1;
            process_busy = 0;
        end 
        @(posedge clk);
    end
end

always @(reset or posedge clk) begin
    if (reset == 0) begin
        input_r_write_data_finish <= 0;
        write_input_r_run_flag <= 0; 
        write_input_r_count = 0;
        count_operate_depth_by_bitwidth_and_depth (input_r_c_bitwidth, input_r_DEPTH, input_r_OPERATE_DEPTH);
    end
    else begin
        if (TRAN_control_start_in === 1) begin
            input_r_write_data_finish <= 0;
        end
        if (AESL_ready_reg === 1) begin
            write_input_r_run_flag <= 1; 
            write_input_r_count = 0;
        end
        if (write_one_input_r_data_done === 1) begin
            write_input_r_count = write_input_r_count + 1;
            if (write_input_r_count == input_r_OPERATE_DEPTH) begin
                write_input_r_run_flag <= 0; 
                input_r_write_data_finish <= 1;
            end
        end
    end
end

initial begin : write_input_r
    integer write_input_r_resp;
    integer process_num ;
    integer get_ack;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;
    reg [31 : 0] input_r_data_tmp_reg;
    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = input_r_c_bitwidth;
    process_num = 1;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_1_finish <= 0;

        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            get_ack = 1;
            if (write_input_r_run_flag === 1 && get_ack === 1) begin
                process_busy = 1;
                //write input_r data 
                for (i = 0 ; i < four_byte_num ; i = i+1) begin
                    if (input_r_c_bitwidth < 32) begin
                        input_r_data_tmp_reg = mem_input_r[write_input_r_count];
                    end
                    else begin
                        for (j=0 ; j<32 ; j = j + 1) begin
                            if (i*32 + j < input_r_c_bitwidth) begin
                                input_r_data_tmp_reg[j] = mem_input_r[write_input_r_count][i*32 + j];
                            end
                            else begin
                                input_r_data_tmp_reg[j] = 0;
                            end
                        end
                    end
                    if(image_mem_input_r[write_input_r_count * four_byte_num  + i]!==input_r_data_tmp_reg) begin
                    write (input_r_data_in_addr + write_input_r_count * four_byte_num * 4 + i * 4, input_r_data_tmp_reg, write_input_r_resp);
                    image_mem_input_r[write_input_r_count * four_byte_num + i]=input_r_data_tmp_reg;
                    end
                end
                process_busy = 0;
                write_one_input_r_data_done <= 1;
                @(posedge clk);
                write_one_input_r_data_done <= 0;
            end   
            process_1_finish <= 1;
        end
        @(posedge clk);
    end    
end
always @(reset or posedge clk) begin
    if (reset == 0) begin
        tables_write_data_finish <= 0;
        write_tables_run_flag <= 0; 
        write_tables_count = 0;
        count_operate_depth_by_bitwidth_and_depth (tables_c_bitwidth, tables_DEPTH, tables_OPERATE_DEPTH);
    end
    else begin
        if (TRAN_control_start_in === 1) begin
            tables_write_data_finish <= 0;
        end
        if (AESL_ready_reg === 1) begin
            write_tables_run_flag <= 1; 
            write_tables_count = 0;
        end
        if (write_one_tables_data_done === 1) begin
            write_tables_count = write_tables_count + 1;
            if (write_tables_count == tables_OPERATE_DEPTH) begin
                write_tables_run_flag <= 0; 
                tables_write_data_finish <= 1;
            end
        end
    end
end

initial begin : write_tables
    integer write_tables_resp;
    integer process_num ;
    integer get_ack;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;
    reg [31 : 0] tables_data_tmp_reg;
    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = tables_c_bitwidth;
    process_num = 2;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_2_finish <= 0;

        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            get_ack = 1;
            if (write_tables_run_flag === 1 && get_ack === 1) begin
                process_busy = 1;
                //write tables data 
                for (i = 0 ; i < four_byte_num ; i = i+1) begin
                    if (tables_c_bitwidth < 32) begin
                        tables_data_tmp_reg = mem_tables[write_tables_count];
                    end
                    else begin
                        for (j=0 ; j<32 ; j = j + 1) begin
                            if (i*32 + j < tables_c_bitwidth) begin
                                tables_data_tmp_reg[j] = mem_tables[write_tables_count][i*32 + j];
                            end
                            else begin
                                tables_data_tmp_reg[j] = 0;
                            end
                        end
                    end
                    if(image_mem_tables[write_tables_count * four_byte_num  + i]!==tables_data_tmp_reg) begin
                    write (tables_data_in_addr + write_tables_count * four_byte_num * 4 + i * 4, tables_data_tmp_reg, write_tables_resp);
                    image_mem_tables[write_tables_count * four_byte_num + i]=tables_data_tmp_reg;
                    end
                end
                process_busy = 0;
                write_one_tables_data_done <= 1;
                @(posedge clk);
                write_one_tables_data_done <= 0;
            end   
            process_2_finish <= 1;
        end
        @(posedge clk);
    end    
end
always @(reset or posedge clk) begin
    if (reset == 0) begin
        output_r_write_data_finish <= 0;
        write_output_r_run_flag <= 0; 
        write_output_r_count = 0;
        count_operate_depth_by_bitwidth_and_depth (output_r_c_bitwidth, output_r_DEPTH, output_r_OPERATE_DEPTH);
    end
    else begin
        if (TRAN_control_start_in === 1) begin
            output_r_write_data_finish <= 0;
        end
        if (AESL_ready_reg === 1) begin
            write_output_r_run_flag <= 1; 
            write_output_r_count = 0;
        end
        if (write_one_output_r_data_done === 1) begin
            write_output_r_count = write_output_r_count + 1;
            if (write_output_r_count == output_r_OPERATE_DEPTH) begin
                write_output_r_run_flag <= 0; 
                output_r_write_data_finish <= 1;
            end
        end
    end
end

initial begin : write_output_r
    integer write_output_r_resp;
    integer process_num ;
    integer get_ack;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;
    reg [31 : 0] output_r_data_tmp_reg;
    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = output_r_c_bitwidth;
    process_num = 3;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_3_finish <= 0;

        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            get_ack = 1;
            if (write_output_r_run_flag === 1 && get_ack === 1) begin
                process_busy = 1;
                //write output_r data 
                for (i = 0 ; i < four_byte_num ; i = i+1) begin
                    if (output_r_c_bitwidth < 32) begin
                        output_r_data_tmp_reg = mem_output_r[write_output_r_count];
                    end
                    else begin
                        for (j=0 ; j<32 ; j = j + 1) begin
                            if (i*32 + j < output_r_c_bitwidth) begin
                                output_r_data_tmp_reg[j] = mem_output_r[write_output_r_count][i*32 + j];
                            end
                            else begin
                                output_r_data_tmp_reg[j] = 0;
                            end
                        end
                    end
                    if(image_mem_output_r[write_output_r_count * four_byte_num  + i]!==output_r_data_tmp_reg) begin
                    write (output_r_data_in_addr + write_output_r_count * four_byte_num * 4 + i * 4, output_r_data_tmp_reg, write_output_r_resp);
                    image_mem_output_r[write_output_r_count * four_byte_num + i]=output_r_data_tmp_reg;
                    end
                end
                process_busy = 0;
                write_one_output_r_data_done <= 1;
                @(posedge clk);
                write_one_output_r_data_done <= 0;
            end   
            process_3_finish <= 1;
        end
        @(posedge clk);
    end    
end
always @(reset or posedge clk) begin
    if (reset == 0) begin
        input_words_write_data_finish <= 0;
        write_input_words_run_flag <= 0; 
        write_input_words_count = 0;
        count_operate_depth_by_bitwidth_and_depth (input_words_c_bitwidth, input_words_DEPTH, input_words_OPERATE_DEPTH);
    end
    else begin
        if (TRAN_control_start_in === 1) begin
            input_words_write_data_finish <= 0;
        end
        if (AESL_ready_reg === 1) begin
            write_input_words_run_flag <= 1; 
            write_input_words_count = 0;
        end
        if (write_one_input_words_data_done === 1) begin
            write_input_words_count = write_input_words_count + 1;
            if (write_input_words_count == input_words_OPERATE_DEPTH) begin
                write_input_words_run_flag <= 0; 
                input_words_write_data_finish <= 1;
            end
        end
    end
end

initial begin : write_input_words
    integer write_input_words_resp;
    integer process_num ;
    integer get_ack;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;
    reg [31 : 0] input_words_data_tmp_reg;
    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = input_words_c_bitwidth;
    process_num = 4;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_4_finish <= 0;

        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            get_ack = 1;
            if (write_input_words_run_flag === 1 && get_ack === 1) begin
                process_busy = 1;
                //write input_words data 
                for (i = 0 ; i < four_byte_num ; i = i+1) begin
                    if (input_words_c_bitwidth < 32) begin
                        input_words_data_tmp_reg = mem_input_words[write_input_words_count];
                    end
                    else begin
                        for (j=0 ; j<32 ; j = j + 1) begin
                            if (i*32 + j < input_words_c_bitwidth) begin
                                input_words_data_tmp_reg[j] = mem_input_words[write_input_words_count][i*32 + j];
                            end
                            else begin
                                input_words_data_tmp_reg[j] = 0;
                            end
                        end
                    end
                    if(image_mem_input_words[write_input_words_count * four_byte_num  + i]!==input_words_data_tmp_reg) begin
                    write (input_words_data_in_addr + write_input_words_count * four_byte_num * 4 + i * 4, input_words_data_tmp_reg, write_input_words_resp);
                    image_mem_input_words[write_input_words_count * four_byte_num + i]=input_words_data_tmp_reg;
                    end
                end
                process_busy = 0;
                write_one_input_words_data_done <= 1;
                @(posedge clk);
                write_one_input_words_data_done <= 0;
            end   
            process_4_finish <= 1;
        end
        @(posedge clk);
    end    
end
always @(reset or posedge clk) begin
    if (reset == 0) begin
        table_words_write_data_finish <= 0;
        write_table_words_run_flag <= 0; 
        write_table_words_count = 0;
        count_operate_depth_by_bitwidth_and_depth (table_words_c_bitwidth, table_words_DEPTH, table_words_OPERATE_DEPTH);
    end
    else begin
        if (TRAN_control_start_in === 1) begin
            table_words_write_data_finish <= 0;
        end
        if (AESL_ready_reg === 1) begin
            write_table_words_run_flag <= 1; 
            write_table_words_count = 0;
        end
        if (write_one_table_words_data_done === 1) begin
            write_table_words_count = write_table_words_count + 1;
            if (write_table_words_count == table_words_OPERATE_DEPTH) begin
                write_table_words_run_flag <= 0; 
                table_words_write_data_finish <= 1;
            end
        end
    end
end

initial begin : write_table_words
    integer write_table_words_resp;
    integer process_num ;
    integer get_ack;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;
    reg [31 : 0] table_words_data_tmp_reg;
    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = table_words_c_bitwidth;
    process_num = 5;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_5_finish <= 0;

        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            get_ack = 1;
            if (write_table_words_run_flag === 1 && get_ack === 1) begin
                process_busy = 1;
                //write table_words data 
                for (i = 0 ; i < four_byte_num ; i = i+1) begin
                    if (table_words_c_bitwidth < 32) begin
                        table_words_data_tmp_reg = mem_table_words[write_table_words_count];
                    end
                    else begin
                        for (j=0 ; j<32 ; j = j + 1) begin
                            if (i*32 + j < table_words_c_bitwidth) begin
                                table_words_data_tmp_reg[j] = mem_table_words[write_table_words_count][i*32 + j];
                            end
                            else begin
                                table_words_data_tmp_reg[j] = 0;
                            end
                        end
                    end
                    if(image_mem_table_words[write_table_words_count * four_byte_num  + i]!==table_words_data_tmp_reg) begin
                    write (table_words_data_in_addr + write_table_words_count * four_byte_num * 4 + i * 4, table_words_data_tmp_reg, write_table_words_resp);
                    image_mem_table_words[write_table_words_count * four_byte_num + i]=table_words_data_tmp_reg;
                    end
                end
                process_busy = 0;
                write_one_table_words_data_done <= 1;
                @(posedge clk);
                write_one_table_words_data_done <= 0;
            end   
            process_5_finish <= 1;
        end
        @(posedge clk);
    end    
end
always @(reset or posedge clk) begin
    if (reset == 0) begin
        output_capacity_write_data_finish <= 0;
        write_output_capacity_run_flag <= 0; 
        write_output_capacity_count = 0;
        count_operate_depth_by_bitwidth_and_depth (output_capacity_c_bitwidth, output_capacity_DEPTH, output_capacity_OPERATE_DEPTH);
    end
    else begin
        if (TRAN_control_start_in === 1) begin
            output_capacity_write_data_finish <= 0;
        end
        if (AESL_ready_reg === 1) begin
            write_output_capacity_run_flag <= 1; 
            write_output_capacity_count = 0;
        end
        if (write_one_output_capacity_data_done === 1) begin
            write_output_capacity_count = write_output_capacity_count + 1;
            if (write_output_capacity_count == output_capacity_OPERATE_DEPTH) begin
                write_output_capacity_run_flag <= 0; 
                output_capacity_write_data_finish <= 1;
            end
        end
    end
end

initial begin : write_output_capacity
    integer write_output_capacity_resp;
    integer process_num ;
    integer get_ack;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;
    reg [31 : 0] output_capacity_data_tmp_reg;
    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = output_capacity_c_bitwidth;
    process_num = 6;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_6_finish <= 0;

        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            get_ack = 1;
            if (write_output_capacity_run_flag === 1 && get_ack === 1) begin
                process_busy = 1;
                //write output_capacity data 
                for (i = 0 ; i < four_byte_num ; i = i+1) begin
                    if (output_capacity_c_bitwidth < 32) begin
                        output_capacity_data_tmp_reg = mem_output_capacity[write_output_capacity_count];
                    end
                    else begin
                        for (j=0 ; j<32 ; j = j + 1) begin
                            if (i*32 + j < output_capacity_c_bitwidth) begin
                                output_capacity_data_tmp_reg[j] = mem_output_capacity[write_output_capacity_count][i*32 + j];
                            end
                            else begin
                                output_capacity_data_tmp_reg[j] = 0;
                            end
                        end
                    end
                    if(image_mem_output_capacity[write_output_capacity_count * four_byte_num  + i]!==output_capacity_data_tmp_reg) begin
                    write (output_capacity_data_in_addr + write_output_capacity_count * four_byte_num * 4 + i * 4, output_capacity_data_tmp_reg, write_output_capacity_resp);
                    image_mem_output_capacity[write_output_capacity_count * four_byte_num + i]=output_capacity_data_tmp_reg;
                    end
                end
                process_busy = 0;
                write_one_output_capacity_data_done <= 1;
                @(posedge clk);
                write_one_output_capacity_data_done <= 0;
            end   
            process_6_finish <= 1;
        end
        @(posedge clk);
    end    
end
always @(reset or posedge clk) begin
    if (reset == 0) begin
        confidence_q30_write_data_finish <= 0;
        write_confidence_q30_run_flag <= 0; 
        write_confidence_q30_count = 0;
        count_operate_depth_by_bitwidth_and_depth (confidence_q30_c_bitwidth, confidence_q30_DEPTH, confidence_q30_OPERATE_DEPTH);
    end
    else begin
        if (TRAN_control_start_in === 1) begin
            confidence_q30_write_data_finish <= 0;
        end
        if (AESL_ready_reg === 1) begin
            write_confidence_q30_run_flag <= 1; 
            write_confidence_q30_count = 0;
        end
        if (write_one_confidence_q30_data_done === 1) begin
            write_confidence_q30_count = write_confidence_q30_count + 1;
            if (write_confidence_q30_count == confidence_q30_OPERATE_DEPTH) begin
                write_confidence_q30_run_flag <= 0; 
                confidence_q30_write_data_finish <= 1;
            end
        end
    end
end

initial begin : write_confidence_q30
    integer write_confidence_q30_resp;
    integer process_num ;
    integer get_ack;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;
    reg [31 : 0] confidence_q30_data_tmp_reg;
    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = confidence_q30_c_bitwidth;
    process_num = 7;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_7_finish <= 0;

        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            get_ack = 1;
            if (write_confidence_q30_run_flag === 1 && get_ack === 1) begin
                process_busy = 1;
                //write confidence_q30 data 
                for (i = 0 ; i < four_byte_num ; i = i+1) begin
                    if (confidence_q30_c_bitwidth < 32) begin
                        confidence_q30_data_tmp_reg = mem_confidence_q30[write_confidence_q30_count];
                    end
                    else begin
                        for (j=0 ; j<32 ; j = j + 1) begin
                            if (i*32 + j < confidence_q30_c_bitwidth) begin
                                confidence_q30_data_tmp_reg[j] = mem_confidence_q30[write_confidence_q30_count][i*32 + j];
                            end
                            else begin
                                confidence_q30_data_tmp_reg[j] = 0;
                            end
                        end
                    end
                    if(image_mem_confidence_q30[write_confidence_q30_count * four_byte_num  + i]!==confidence_q30_data_tmp_reg) begin
                    write (confidence_q30_data_in_addr + write_confidence_q30_count * four_byte_num * 4 + i * 4, confidence_q30_data_tmp_reg, write_confidence_q30_resp);
                    image_mem_confidence_q30[write_confidence_q30_count * four_byte_num + i]=confidence_q30_data_tmp_reg;
                    end
                end
                process_busy = 0;
                write_one_confidence_q30_data_done <= 1;
                @(posedge clk);
                write_one_confidence_q30_data_done <= 0;
            end   
            process_7_finish <= 1;
        end
        @(posedge clk);
    end    
end
always @(reset or posedge clk) begin
    if (reset == 0) begin
        nms_q16_write_data_finish <= 0;
        write_nms_q16_run_flag <= 0; 
        write_nms_q16_count = 0;
        count_operate_depth_by_bitwidth_and_depth (nms_q16_c_bitwidth, nms_q16_DEPTH, nms_q16_OPERATE_DEPTH);
    end
    else begin
        if (TRAN_control_start_in === 1) begin
            nms_q16_write_data_finish <= 0;
        end
        if (AESL_ready_reg === 1) begin
            write_nms_q16_run_flag <= 1; 
            write_nms_q16_count = 0;
        end
        if (write_one_nms_q16_data_done === 1) begin
            write_nms_q16_count = write_nms_q16_count + 1;
            if (write_nms_q16_count == nms_q16_OPERATE_DEPTH) begin
                write_nms_q16_run_flag <= 0; 
                nms_q16_write_data_finish <= 1;
            end
        end
    end
end

initial begin : write_nms_q16
    integer write_nms_q16_resp;
    integer process_num ;
    integer get_ack;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;
    reg [31 : 0] nms_q16_data_tmp_reg;
    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = nms_q16_c_bitwidth;
    process_num = 8;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_8_finish <= 0;

        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            get_ack = 1;
            if (write_nms_q16_run_flag === 1 && get_ack === 1) begin
                process_busy = 1;
                //write nms_q16 data 
                for (i = 0 ; i < four_byte_num ; i = i+1) begin
                    if (nms_q16_c_bitwidth < 32) begin
                        nms_q16_data_tmp_reg = mem_nms_q16[write_nms_q16_count];
                    end
                    else begin
                        for (j=0 ; j<32 ; j = j + 1) begin
                            if (i*32 + j < nms_q16_c_bitwidth) begin
                                nms_q16_data_tmp_reg[j] = mem_nms_q16[write_nms_q16_count][i*32 + j];
                            end
                            else begin
                                nms_q16_data_tmp_reg[j] = 0;
                            end
                        end
                    end
                    if(image_mem_nms_q16[write_nms_q16_count * four_byte_num  + i]!==nms_q16_data_tmp_reg) begin
                    write (nms_q16_data_in_addr + write_nms_q16_count * four_byte_num * 4 + i * 4, nms_q16_data_tmp_reg, write_nms_q16_resp);
                    image_mem_nms_q16[write_nms_q16_count * four_byte_num + i]=nms_q16_data_tmp_reg;
                    end
                end
                process_busy = 0;
                write_one_nms_q16_data_done <= 1;
                @(posedge clk);
                write_one_nms_q16_data_done <= 0;
            end   
            process_8_finish <= 1;
        end
        @(posedge clk);
    end    
end
always @(reset or posedge clk) begin
    if (reset == 0) begin
        enable_nms_write_data_finish <= 0;
        write_enable_nms_run_flag <= 0; 
        write_enable_nms_count = 0;
        count_operate_depth_by_bitwidth_and_depth (enable_nms_c_bitwidth, enable_nms_DEPTH, enable_nms_OPERATE_DEPTH);
    end
    else begin
        if (TRAN_control_start_in === 1) begin
            enable_nms_write_data_finish <= 0;
        end
        if (AESL_ready_reg === 1) begin
            write_enable_nms_run_flag <= 1; 
            write_enable_nms_count = 0;
        end
        if (write_one_enable_nms_data_done === 1) begin
            write_enable_nms_count = write_enable_nms_count + 1;
            if (write_enable_nms_count == enable_nms_OPERATE_DEPTH) begin
                write_enable_nms_run_flag <= 0; 
                enable_nms_write_data_finish <= 1;
            end
        end
    end
end

initial begin : write_enable_nms
    integer write_enable_nms_resp;
    integer process_num ;
    integer get_ack;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;
    reg [31 : 0] enable_nms_data_tmp_reg;
    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = enable_nms_c_bitwidth;
    process_num = 9;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_9_finish <= 0;

        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            get_ack = 1;
            if (write_enable_nms_run_flag === 1 && get_ack === 1) begin
                process_busy = 1;
                //write enable_nms data 
                for (i = 0 ; i < four_byte_num ; i = i+1) begin
                    if (enable_nms_c_bitwidth < 32) begin
                        enable_nms_data_tmp_reg = mem_enable_nms[write_enable_nms_count];
                    end
                    else begin
                        for (j=0 ; j<32 ; j = j + 1) begin
                            if (i*32 + j < enable_nms_c_bitwidth) begin
                                enable_nms_data_tmp_reg[j] = mem_enable_nms[write_enable_nms_count][i*32 + j];
                            end
                            else begin
                                enable_nms_data_tmp_reg[j] = 0;
                            end
                        end
                    end
                    if(image_mem_enable_nms[write_enable_nms_count * four_byte_num  + i]!==enable_nms_data_tmp_reg) begin
                    write (enable_nms_data_in_addr + write_enable_nms_count * four_byte_num * 4 + i * 4, enable_nms_data_tmp_reg, write_enable_nms_resp);
                    image_mem_enable_nms[write_enable_nms_count * four_byte_num + i]=enable_nms_data_tmp_reg;
                    end
                end
                process_busy = 0;
                write_one_enable_nms_data_done <= 1;
                @(posedge clk);
                write_one_enable_nms_data_done <= 0;
            end   
            process_9_finish <= 1;
        end
        @(posedge clk);
    end    
end

always @(reset or posedge clk) begin
    if (reset == 0) begin
        write_start_run_flag <= 0; 
        write_start_count <= 0;
    end
    else begin
        if (write_start_count >= 5) begin
            write_start_run_flag <= 0; 
        end
        else if (TRAN_control_write_start_in === 1) begin
            write_start_run_flag <= 1; 
        end
        if (AESL_write_start_finish === 1) begin
            write_start_count <= write_start_count + 1;
            write_start_run_flag <= 0; 
        end
    end
end

initial begin : write_start
    reg [DATA_WIDTH - 1 : 0] write_start_tmp;
    integer process_num;
    integer write_start_resp;
    wait(reset === 1);
    @(posedge clk);
    process_num = 10;
    while (1) begin
        process_10_finish = 0;
        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            if (write_start_run_flag === 1) begin
                process_busy = 1;
                write_start_tmp=0;
                write_start_tmp[0 : 0] = 1;
                write (START_ADDR, write_start_tmp, write_start_resp);
                process_busy = 0;
                AESL_write_start_finish <= 1;
                @(posedge clk);
                AESL_write_start_finish <= 0;
            end
            process_10_finish <= 1;
        end 
        @(posedge clk);
    end
end

always @(reset or posedge clk) begin
    if (reset == 0) begin
        candidate_count_read_data_finish <= 0;
        read_candidate_count_run_flag <= 0; 
        read_candidate_count_count = 0;
        count_operate_depth_by_bitwidth_and_depth (candidate_count_c_bitwidth, candidate_count_DEPTH, candidate_count_OPERATE_DEPTH);
    end
    else begin
        if (AESL_done_index_reg === 1) begin
            read_candidate_count_run_flag = 1; 
        end
        if (TRAN_control_transaction_done_in === 1) begin
            candidate_count_read_data_finish <= 0;
            read_candidate_count_count = 0; 
        end
        if (read_one_candidate_count_data_done === 1) begin
            read_candidate_count_count = read_candidate_count_count + 1;
            if (read_candidate_count_count == candidate_count_OPERATE_DEPTH) begin
                read_candidate_count_run_flag <= 0; 
                candidate_count_read_data_finish <= 1;
            end
        end
    end
end

initial begin : read_candidate_count
    integer read_candidate_count_resp;
    integer process_num;
    integer get_vld;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;

    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = candidate_count_c_bitwidth;
    process_num = 11;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_11_finish <= 0;
        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            if (read_candidate_count_run_flag === 1) begin
                process_busy = 1;
                get_vld = 0;
                //read candidate_count vld
                read (candidate_count_valid_out_addr, RDATA_reg, read_candidate_count_resp);
                if (RDATA_reg[0 : 0] == 1) begin
                    get_vld = 1;
                end
                if (get_vld == 1) begin
                    //read candidate_count data 
                    for (i = 0 ; i < four_byte_num ; i = i+1) begin
                        read (candidate_count_data_out_addr + read_candidate_count_count * four_byte_num * 4 + i * 4, RDATA_reg, read_candidate_count_resp);
                        if (candidate_count_c_bitwidth < 32) begin
                            mem_candidate_count[read_candidate_count_count] <= RDATA_reg;
                        end
                        else begin
                            for (j=0 ; j < 32 ; j = j + 1) begin
                                if (i*32 + j < candidate_count_c_bitwidth) begin
                                    mem_candidate_count[read_candidate_count_count][i*32 + j] <= RDATA_reg[j];
                                end
                            end
                        end
                    end
                    
                    read_one_candidate_count_data_done <= 1;
                    @(posedge clk);
                    read_one_candidate_count_data_done <= 0;
                end    
                process_busy = 0;
            end    
            process_11_finish <= 1;
        end
        @(posedge clk);
    end    
end
always @(reset or posedge clk) begin
    if (reset == 0) begin
        detection_count_read_data_finish <= 0;
        read_detection_count_run_flag <= 0; 
        read_detection_count_count = 0;
        count_operate_depth_by_bitwidth_and_depth (detection_count_c_bitwidth, detection_count_DEPTH, detection_count_OPERATE_DEPTH);
    end
    else begin
        if (AESL_done_index_reg === 1) begin
            read_detection_count_run_flag = 1; 
        end
        if (TRAN_control_transaction_done_in === 1) begin
            detection_count_read_data_finish <= 0;
            read_detection_count_count = 0; 
        end
        if (read_one_detection_count_data_done === 1) begin
            read_detection_count_count = read_detection_count_count + 1;
            if (read_detection_count_count == detection_count_OPERATE_DEPTH) begin
                read_detection_count_run_flag <= 0; 
                detection_count_read_data_finish <= 1;
            end
        end
    end
end

initial begin : read_detection_count
    integer read_detection_count_resp;
    integer process_num;
    integer get_vld;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;

    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = detection_count_c_bitwidth;
    process_num = 12;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_12_finish <= 0;
        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            if (read_detection_count_run_flag === 1) begin
                process_busy = 1;
                get_vld = 0;
                //read detection_count vld
                read (detection_count_valid_out_addr, RDATA_reg, read_detection_count_resp);
                if (RDATA_reg[0 : 0] == 1) begin
                    get_vld = 1;
                end
                if (get_vld == 1) begin
                    //read detection_count data 
                    for (i = 0 ; i < four_byte_num ; i = i+1) begin
                        read (detection_count_data_out_addr + read_detection_count_count * four_byte_num * 4 + i * 4, RDATA_reg, read_detection_count_resp);
                        if (detection_count_c_bitwidth < 32) begin
                            mem_detection_count[read_detection_count_count] <= RDATA_reg;
                        end
                        else begin
                            for (j=0 ; j < 32 ; j = j + 1) begin
                                if (i*32 + j < detection_count_c_bitwidth) begin
                                    mem_detection_count[read_detection_count_count][i*32 + j] <= RDATA_reg[j];
                                end
                            end
                        end
                    end
                    
                    read_one_detection_count_data_done <= 1;
                    @(posedge clk);
                    read_one_detection_count_data_done <= 0;
                end    
                process_busy = 0;
            end    
            process_12_finish <= 1;
        end
        @(posedge clk);
    end    
end
always @(reset or posedge clk) begin
    if (reset == 0) begin
        ap_return_read_data_finish <= 0;
        read_ap_return_run_flag <= 0; 
        read_ap_return_count = 0;
        count_operate_depth_by_bitwidth_and_depth (ap_return_c_bitwidth, ap_return_DEPTH, ap_return_OPERATE_DEPTH);
    end
    else begin
        if (AESL_done_index_reg === 1) begin
            read_ap_return_run_flag = 1; 
        end
        if (TRAN_control_transaction_done_in === 1) begin
            ap_return_read_data_finish <= 0;
            read_ap_return_count = 0; 
        end
        if (read_one_ap_return_data_done === 1) begin
            read_ap_return_count = read_ap_return_count + 1;
            if (read_ap_return_count == ap_return_OPERATE_DEPTH) begin
                read_ap_return_run_flag <= 0; 
                ap_return_read_data_finish <= 1;
            end
        end
    end
end

initial begin : read_ap_return
    integer read_ap_return_resp;
    integer process_num;
    integer get_vld;
    integer four_byte_num;
    integer c_bitwidth;
    integer i;
    integer j;

    wait(reset === 1);
    @(posedge clk);
    c_bitwidth = ap_return_c_bitwidth;
    process_num = 13;
    count_c_data_four_byte_num_by_bitwidth (c_bitwidth , four_byte_num) ;
    while (1) begin
        process_13_finish <= 0;
        if (ongoing_process_number === process_num && process_busy === 0 ) begin
            if (read_ap_return_run_flag === 1) begin
                process_busy = 1;
                get_vld = 1;
                if (get_vld == 1) begin
                    //read ap_return data 
                    for (i = 0 ; i < four_byte_num ; i = i+1) begin
                        read (ap_return_data_out_addr + read_ap_return_count * four_byte_num * 4 + i * 4, RDATA_reg, read_ap_return_resp);
                        if (ap_return_c_bitwidth < 32) begin
                            mem_ap_return[read_ap_return_count] <= RDATA_reg;
                        end
                        else begin
                            for (j=0 ; j < 32 ; j = j + 1) begin
                                if (i*32 + j < ap_return_c_bitwidth) begin
                                    mem_ap_return[read_ap_return_count][i*32 + j] <= RDATA_reg[j];
                                end
                            end
                        end
                    end
                    
                    read_one_ap_return_data_done <= 1;
                    @(posedge clk);
                    read_one_ap_return_data_done <= 0;
                end    
                process_busy = 0;
            end    
            process_13_finish <= 1;
        end
        @(posedge clk);
    end    
end
//------------------------Task and function-------------- 
task read_token; 
    input integer fp; 
    output reg [151 : 0] token;
    integer ret;
    begin
        token = "";
        ret = 0;
        ret = $fscanf(fp,"%s",token);
    end 
endtask 
 
//------------------------Read file------------------------ 
 
// Read data from file 
initial begin : read_input_r_file_process 
  integer fp; 
  integer ret; 
  integer factor; 
  reg [151 : 0] token; 
  reg [151 : 0] token_tmp; 
  //reg [input_r_c_bitwidth - 1 : 0] token_tmp; 
  reg [DATA_WIDTH - 1 : 0] tmp_cache_mem; 
  reg [ 8*5 : 1] str;
    reg [63:0] trans_depth;
  integer transaction_idx; 
  integer i; 
  transaction_idx = 0; 
  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
  count_seperate_factor_by_bitwidth (input_r_c_bitwidth , factor);
  fp = $fopen(`TV_IN_input_r ,"r"); 
  if(fp == 0) begin                               // Failed to open file 
      $display("Failed to open file \"%s\"!", `TV_IN_input_r); 
      $finish; 
  end 
  read_token(fp, token); 
  if (token != "[[[runtime]]]") begin             // Illegal format 
      $display("ERROR: Simulation using HLS TB failed.");
      $finish; 
  end 
  read_token(fp, token); 
  while (token != "[[[/runtime]]]") begin 
      if (token != "[[transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token);                        // skip transaction number 
      @(posedge clk);
      # 0.2;
      while(AESL_ready_reg !== 1) begin
          @(posedge clk); 
          # 0.2;
      end
      for(i = 0; i < input_r_DEPTH; i = i + 1) begin 
          read_token(fp, token); 
          ret = $sscanf(token, "0x%x", token_tmp); 
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [7 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [15 : 8] = token_tmp;
              end
              if (i%factor == 2) begin
                  tmp_cache_mem [23 : 16] = token_tmp;
              end
              if (i%factor == 3) begin
                  tmp_cache_mem [31 : 24] = token_tmp;
                  mem_input_r [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
              end
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [15 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [31 : 16] = token_tmp;
                  mem_input_r [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1: 0] = 0;
              end
          end
          if (factor == 1) begin
              mem_input_r [i] = token_tmp;
          end
      end 
      if (factor == 4) begin
          if (i%factor != 0) begin
              mem_input_r [i/factor] = tmp_cache_mem;
          end
      end
      if (factor == 2) begin
          if (i%factor != 0) begin
              mem_input_r [i/factor] = tmp_cache_mem;
          end
      end 
      read_token(fp, token); 
      if(token != "[[/transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token); 
      transaction_idx = transaction_idx + 1; 
  end 
  $fclose(fp); 
end 
 
task write_binary_input_r;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
//------------------------Read file------------------------ 
 
// Read data from file 
initial begin : read_tables_file_process 
  integer fp; 
  integer ret; 
  integer factor; 
  reg [151 : 0] token; 
  reg [151 : 0] token_tmp; 
  //reg [tables_c_bitwidth - 1 : 0] token_tmp; 
  reg [DATA_WIDTH - 1 : 0] tmp_cache_mem; 
  reg [ 8*5 : 1] str;
    reg [63:0] trans_depth;
  integer transaction_idx; 
  integer i; 
  transaction_idx = 0; 
  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
  count_seperate_factor_by_bitwidth (tables_c_bitwidth , factor);
  fp = $fopen(`TV_IN_tables ,"r"); 
  if(fp == 0) begin                               // Failed to open file 
      $display("Failed to open file \"%s\"!", `TV_IN_tables); 
      $finish; 
  end 
  read_token(fp, token); 
  if (token != "[[[runtime]]]") begin             // Illegal format 
      $display("ERROR: Simulation using HLS TB failed.");
      $finish; 
  end 
  read_token(fp, token); 
  while (token != "[[[/runtime]]]") begin 
      if (token != "[[transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token);                        // skip transaction number 
      @(posedge clk);
      # 0.2;
      while(AESL_ready_reg !== 1) begin
          @(posedge clk); 
          # 0.2;
      end
      for(i = 0; i < tables_DEPTH; i = i + 1) begin 
          read_token(fp, token); 
          ret = $sscanf(token, "0x%x", token_tmp); 
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [7 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [15 : 8] = token_tmp;
              end
              if (i%factor == 2) begin
                  tmp_cache_mem [23 : 16] = token_tmp;
              end
              if (i%factor == 3) begin
                  tmp_cache_mem [31 : 24] = token_tmp;
                  mem_tables [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
              end
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [15 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [31 : 16] = token_tmp;
                  mem_tables [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1: 0] = 0;
              end
          end
          if (factor == 1) begin
              mem_tables [i] = token_tmp;
          end
      end 
      if (factor == 4) begin
          if (i%factor != 0) begin
              mem_tables [i/factor] = tmp_cache_mem;
          end
      end
      if (factor == 2) begin
          if (i%factor != 0) begin
              mem_tables [i/factor] = tmp_cache_mem;
          end
      end 
      read_token(fp, token); 
      if(token != "[[/transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token); 
      transaction_idx = transaction_idx + 1; 
  end 
  $fclose(fp); 
end 
 
task write_binary_tables;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
//------------------------Read file------------------------ 
 
// Read data from file 
initial begin : read_output_r_file_process 
  integer fp; 
  integer ret; 
  integer factor; 
  reg [151 : 0] token; 
  reg [151 : 0] token_tmp; 
  //reg [output_r_c_bitwidth - 1 : 0] token_tmp; 
  reg [DATA_WIDTH - 1 : 0] tmp_cache_mem; 
  reg [ 8*5 : 1] str;
    reg [63:0] trans_depth;
  integer transaction_idx; 
  integer i; 
  transaction_idx = 0; 
  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
  count_seperate_factor_by_bitwidth (output_r_c_bitwidth , factor);
  fp = $fopen(`TV_IN_output_r ,"r"); 
  if(fp == 0) begin                               // Failed to open file 
      $display("Failed to open file \"%s\"!", `TV_IN_output_r); 
      $finish; 
  end 
  read_token(fp, token); 
  if (token != "[[[runtime]]]") begin             // Illegal format 
      $display("ERROR: Simulation using HLS TB failed.");
      $finish; 
  end 
  read_token(fp, token); 
  while (token != "[[[/runtime]]]") begin 
      if (token != "[[transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token);                        // skip transaction number 
      @(posedge clk);
      # 0.2;
      while(AESL_ready_reg !== 1) begin
          @(posedge clk); 
          # 0.2;
      end
      for(i = 0; i < output_r_DEPTH; i = i + 1) begin 
          read_token(fp, token); 
          ret = $sscanf(token, "0x%x", token_tmp); 
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [7 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [15 : 8] = token_tmp;
              end
              if (i%factor == 2) begin
                  tmp_cache_mem [23 : 16] = token_tmp;
              end
              if (i%factor == 3) begin
                  tmp_cache_mem [31 : 24] = token_tmp;
                  mem_output_r [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
              end
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [15 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [31 : 16] = token_tmp;
                  mem_output_r [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1: 0] = 0;
              end
          end
          if (factor == 1) begin
              mem_output_r [i] = token_tmp;
          end
      end 
      if (factor == 4) begin
          if (i%factor != 0) begin
              mem_output_r [i/factor] = tmp_cache_mem;
          end
      end
      if (factor == 2) begin
          if (i%factor != 0) begin
              mem_output_r [i/factor] = tmp_cache_mem;
          end
      end 
      read_token(fp, token); 
      if(token != "[[/transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token); 
      transaction_idx = transaction_idx + 1; 
  end 
  $fclose(fp); 
end 
 
task write_binary_output_r;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
//------------------------Read file------------------------ 
 
// Read data from file 
initial begin : read_input_words_file_process 
  integer fp; 
  integer ret; 
  integer factor; 
  reg [127 : 0] token; 
  reg [127 : 0] token_tmp; 
  //reg [input_words_c_bitwidth - 1 : 0] token_tmp; 
  reg [DATA_WIDTH - 1 : 0] tmp_cache_mem; 
  reg [ 8*5 : 1] str;
    reg [63:0] trans_depth;
  integer transaction_idx; 
  integer i; 
  transaction_idx = 0; 
  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
  count_seperate_factor_by_bitwidth (input_words_c_bitwidth , factor);
  fp = $fopen(`TV_IN_input_words ,"r"); 
  if(fp == 0) begin                               // Failed to open file 
      $display("Failed to open file \"%s\"!", `TV_IN_input_words); 
      $finish; 
  end 
  read_token(fp, token); 
  if (token != "[[[runtime]]]") begin             // Illegal format 
      $display("ERROR: Simulation using HLS TB failed.");
      $finish; 
  end 
  read_token(fp, token); 
  while (token != "[[[/runtime]]]") begin 
      if (token != "[[transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token);                        // skip transaction number 
      @(posedge clk);
      # 0.2;
      while(AESL_ready_reg !== 1) begin
          @(posedge clk); 
          # 0.2;
      end
      for(i = 0; i < input_words_DEPTH; i = i + 1) begin 
          read_token(fp, token); 
          ret = $sscanf(token, "0x%x", token_tmp); 
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [7 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [15 : 8] = token_tmp;
              end
              if (i%factor == 2) begin
                  tmp_cache_mem [23 : 16] = token_tmp;
              end
              if (i%factor == 3) begin
                  tmp_cache_mem [31 : 24] = token_tmp;
                  mem_input_words [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
              end
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [15 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [31 : 16] = token_tmp;
                  mem_input_words [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1: 0] = 0;
              end
          end
          if (factor == 1) begin
              mem_input_words [i] = token_tmp;
          end
      end 
      if (factor == 4) begin
          if (i%factor != 0) begin
              mem_input_words [i/factor] = tmp_cache_mem;
          end
      end
      if (factor == 2) begin
          if (i%factor != 0) begin
              mem_input_words [i/factor] = tmp_cache_mem;
          end
      end 
      read_token(fp, token); 
      if(token != "[[/transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token); 
      transaction_idx = transaction_idx + 1; 
  end 
  $fclose(fp); 
end 
 
task write_binary_input_words;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
//------------------------Read file------------------------ 
 
// Read data from file 
initial begin : read_table_words_file_process 
  integer fp; 
  integer ret; 
  integer factor; 
  reg [127 : 0] token; 
  reg [127 : 0] token_tmp; 
  //reg [table_words_c_bitwidth - 1 : 0] token_tmp; 
  reg [DATA_WIDTH - 1 : 0] tmp_cache_mem; 
  reg [ 8*5 : 1] str;
    reg [63:0] trans_depth;
  integer transaction_idx; 
  integer i; 
  transaction_idx = 0; 
  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
  count_seperate_factor_by_bitwidth (table_words_c_bitwidth , factor);
  fp = $fopen(`TV_IN_table_words ,"r"); 
  if(fp == 0) begin                               // Failed to open file 
      $display("Failed to open file \"%s\"!", `TV_IN_table_words); 
      $finish; 
  end 
  read_token(fp, token); 
  if (token != "[[[runtime]]]") begin             // Illegal format 
      $display("ERROR: Simulation using HLS TB failed.");
      $finish; 
  end 
  read_token(fp, token); 
  while (token != "[[[/runtime]]]") begin 
      if (token != "[[transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token);                        // skip transaction number 
      @(posedge clk);
      # 0.2;
      while(AESL_ready_reg !== 1) begin
          @(posedge clk); 
          # 0.2;
      end
      for(i = 0; i < table_words_DEPTH; i = i + 1) begin 
          read_token(fp, token); 
          ret = $sscanf(token, "0x%x", token_tmp); 
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [7 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [15 : 8] = token_tmp;
              end
              if (i%factor == 2) begin
                  tmp_cache_mem [23 : 16] = token_tmp;
              end
              if (i%factor == 3) begin
                  tmp_cache_mem [31 : 24] = token_tmp;
                  mem_table_words [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
              end
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [15 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [31 : 16] = token_tmp;
                  mem_table_words [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1: 0] = 0;
              end
          end
          if (factor == 1) begin
              mem_table_words [i] = token_tmp;
          end
      end 
      if (factor == 4) begin
          if (i%factor != 0) begin
              mem_table_words [i/factor] = tmp_cache_mem;
          end
      end
      if (factor == 2) begin
          if (i%factor != 0) begin
              mem_table_words [i/factor] = tmp_cache_mem;
          end
      end 
      read_token(fp, token); 
      if(token != "[[/transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token); 
      transaction_idx = transaction_idx + 1; 
  end 
  $fclose(fp); 
end 
 
task write_binary_table_words;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
//------------------------Read file------------------------ 
 
// Read data from file 
initial begin : read_output_capacity_file_process 
  integer fp; 
  integer ret; 
  integer factor; 
  reg [127 : 0] token; 
  reg [127 : 0] token_tmp; 
  //reg [output_capacity_c_bitwidth - 1 : 0] token_tmp; 
  reg [DATA_WIDTH - 1 : 0] tmp_cache_mem; 
  reg [ 8*5 : 1] str;
    reg [63:0] trans_depth;
  integer transaction_idx; 
  integer i; 
  transaction_idx = 0; 
  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
  count_seperate_factor_by_bitwidth (output_capacity_c_bitwidth , factor);
  fp = $fopen(`TV_IN_output_capacity ,"r"); 
  if(fp == 0) begin                               // Failed to open file 
      $display("Failed to open file \"%s\"!", `TV_IN_output_capacity); 
      $finish; 
  end 
  read_token(fp, token); 
  if (token != "[[[runtime]]]") begin             // Illegal format 
      $display("ERROR: Simulation using HLS TB failed.");
      $finish; 
  end 
  read_token(fp, token); 
  while (token != "[[[/runtime]]]") begin 
      if (token != "[[transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token);                        // skip transaction number 
      @(posedge clk);
      # 0.2;
      while(AESL_ready_reg !== 1) begin
          @(posedge clk); 
          # 0.2;
      end
      for(i = 0; i < output_capacity_DEPTH; i = i + 1) begin 
          read_token(fp, token); 
          ret = $sscanf(token, "0x%x", token_tmp); 
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [7 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [15 : 8] = token_tmp;
              end
              if (i%factor == 2) begin
                  tmp_cache_mem [23 : 16] = token_tmp;
              end
              if (i%factor == 3) begin
                  tmp_cache_mem [31 : 24] = token_tmp;
                  mem_output_capacity [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
              end
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [15 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [31 : 16] = token_tmp;
                  mem_output_capacity [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1: 0] = 0;
              end
          end
          if (factor == 1) begin
              mem_output_capacity [i] = token_tmp;
          end
      end 
      if (factor == 4) begin
          if (i%factor != 0) begin
              mem_output_capacity [i/factor] = tmp_cache_mem;
          end
      end
      if (factor == 2) begin
          if (i%factor != 0) begin
              mem_output_capacity [i/factor] = tmp_cache_mem;
          end
      end 
      read_token(fp, token); 
      if(token != "[[/transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token); 
      transaction_idx = transaction_idx + 1; 
  end 
  $fclose(fp); 
end 
 
task write_binary_output_capacity;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
//------------------------Read file------------------------ 
 
// Read data from file 
initial begin : read_confidence_q30_file_process 
  integer fp; 
  integer ret; 
  integer factor; 
  reg [127 : 0] token; 
  reg [127 : 0] token_tmp; 
  //reg [confidence_q30_c_bitwidth - 1 : 0] token_tmp; 
  reg [DATA_WIDTH - 1 : 0] tmp_cache_mem; 
  reg [ 8*5 : 1] str;
    reg [63:0] trans_depth;
  integer transaction_idx; 
  integer i; 
  transaction_idx = 0; 
  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
  count_seperate_factor_by_bitwidth (confidence_q30_c_bitwidth , factor);
  fp = $fopen(`TV_IN_confidence_q30 ,"r"); 
  if(fp == 0) begin                               // Failed to open file 
      $display("Failed to open file \"%s\"!", `TV_IN_confidence_q30); 
      $finish; 
  end 
  read_token(fp, token); 
  if (token != "[[[runtime]]]") begin             // Illegal format 
      $display("ERROR: Simulation using HLS TB failed.");
      $finish; 
  end 
  read_token(fp, token); 
  while (token != "[[[/runtime]]]") begin 
      if (token != "[[transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token);                        // skip transaction number 
      @(posedge clk);
      # 0.2;
      while(AESL_ready_reg !== 1) begin
          @(posedge clk); 
          # 0.2;
      end
      for(i = 0; i < confidence_q30_DEPTH; i = i + 1) begin 
          read_token(fp, token); 
          ret = $sscanf(token, "0x%x", token_tmp); 
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [7 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [15 : 8] = token_tmp;
              end
              if (i%factor == 2) begin
                  tmp_cache_mem [23 : 16] = token_tmp;
              end
              if (i%factor == 3) begin
                  tmp_cache_mem [31 : 24] = token_tmp;
                  mem_confidence_q30 [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
              end
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [15 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [31 : 16] = token_tmp;
                  mem_confidence_q30 [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1: 0] = 0;
              end
          end
          if (factor == 1) begin
              mem_confidence_q30 [i] = token_tmp;
          end
      end 
      if (factor == 4) begin
          if (i%factor != 0) begin
              mem_confidence_q30 [i/factor] = tmp_cache_mem;
          end
      end
      if (factor == 2) begin
          if (i%factor != 0) begin
              mem_confidence_q30 [i/factor] = tmp_cache_mem;
          end
      end 
      read_token(fp, token); 
      if(token != "[[/transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token); 
      transaction_idx = transaction_idx + 1; 
  end 
  $fclose(fp); 
end 
 
task write_binary_confidence_q30;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
//------------------------Read file------------------------ 
 
// Read data from file 
initial begin : read_nms_q16_file_process 
  integer fp; 
  integer ret; 
  integer factor; 
  reg [127 : 0] token; 
  reg [127 : 0] token_tmp; 
  //reg [nms_q16_c_bitwidth - 1 : 0] token_tmp; 
  reg [DATA_WIDTH - 1 : 0] tmp_cache_mem; 
  reg [ 8*5 : 1] str;
    reg [63:0] trans_depth;
  integer transaction_idx; 
  integer i; 
  transaction_idx = 0; 
  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
  count_seperate_factor_by_bitwidth (nms_q16_c_bitwidth , factor);
  fp = $fopen(`TV_IN_nms_q16 ,"r"); 
  if(fp == 0) begin                               // Failed to open file 
      $display("Failed to open file \"%s\"!", `TV_IN_nms_q16); 
      $finish; 
  end 
  read_token(fp, token); 
  if (token != "[[[runtime]]]") begin             // Illegal format 
      $display("ERROR: Simulation using HLS TB failed.");
      $finish; 
  end 
  read_token(fp, token); 
  while (token != "[[[/runtime]]]") begin 
      if (token != "[[transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token);                        // skip transaction number 
      @(posedge clk);
      # 0.2;
      while(AESL_ready_reg !== 1) begin
          @(posedge clk); 
          # 0.2;
      end
      for(i = 0; i < nms_q16_DEPTH; i = i + 1) begin 
          read_token(fp, token); 
          ret = $sscanf(token, "0x%x", token_tmp); 
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [7 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [15 : 8] = token_tmp;
              end
              if (i%factor == 2) begin
                  tmp_cache_mem [23 : 16] = token_tmp;
              end
              if (i%factor == 3) begin
                  tmp_cache_mem [31 : 24] = token_tmp;
                  mem_nms_q16 [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
              end
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [15 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [31 : 16] = token_tmp;
                  mem_nms_q16 [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1: 0] = 0;
              end
          end
          if (factor == 1) begin
              mem_nms_q16 [i] = token_tmp;
          end
      end 
      if (factor == 4) begin
          if (i%factor != 0) begin
              mem_nms_q16 [i/factor] = tmp_cache_mem;
          end
      end
      if (factor == 2) begin
          if (i%factor != 0) begin
              mem_nms_q16 [i/factor] = tmp_cache_mem;
          end
      end 
      read_token(fp, token); 
      if(token != "[[/transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token); 
      transaction_idx = transaction_idx + 1; 
  end 
  $fclose(fp); 
end 
 
task write_binary_nms_q16;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
//------------------------Read file------------------------ 
 
// Read data from file 
initial begin : read_enable_nms_file_process 
  integer fp; 
  integer ret; 
  integer factor; 
  reg [127 : 0] token; 
  reg [127 : 0] token_tmp; 
  //reg [enable_nms_c_bitwidth - 1 : 0] token_tmp; 
  reg [DATA_WIDTH - 1 : 0] tmp_cache_mem; 
  reg [ 8*5 : 1] str;
    reg [63:0] trans_depth;
  integer transaction_idx; 
  integer i; 
  transaction_idx = 0; 
  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
  count_seperate_factor_by_bitwidth (enable_nms_c_bitwidth , factor);
  fp = $fopen(`TV_IN_enable_nms ,"r"); 
  if(fp == 0) begin                               // Failed to open file 
      $display("Failed to open file \"%s\"!", `TV_IN_enable_nms); 
      $finish; 
  end 
  read_token(fp, token); 
  if (token != "[[[runtime]]]") begin             // Illegal format 
      $display("ERROR: Simulation using HLS TB failed.");
      $finish; 
  end 
  read_token(fp, token); 
  while (token != "[[[/runtime]]]") begin 
      if (token != "[[transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token);                        // skip transaction number 
      @(posedge clk);
      # 0.2;
      while(AESL_ready_reg !== 1) begin
          @(posedge clk); 
          # 0.2;
      end
      for(i = 0; i < enable_nms_DEPTH; i = i + 1) begin 
          read_token(fp, token); 
          ret = $sscanf(token, "0x%x", token_tmp); 
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [7 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [15 : 8] = token_tmp;
              end
              if (i%factor == 2) begin
                  tmp_cache_mem [23 : 16] = token_tmp;
              end
              if (i%factor == 3) begin
                  tmp_cache_mem [31 : 24] = token_tmp;
                  mem_enable_nms [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1 : 0] = 0;
              end
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem [15 : 0] = token_tmp;
              end
              if (i%factor == 1) begin
                  tmp_cache_mem [31 : 16] = token_tmp;
                  mem_enable_nms [i/factor] = tmp_cache_mem;
                  tmp_cache_mem [DATA_WIDTH - 1: 0] = 0;
              end
          end
          if (factor == 1) begin
              mem_enable_nms [i] = token_tmp;
          end
      end 
      if (factor == 4) begin
          if (i%factor != 0) begin
              mem_enable_nms [i/factor] = tmp_cache_mem;
          end
      end
      if (factor == 2) begin
          if (i%factor != 0) begin
              mem_enable_nms [i/factor] = tmp_cache_mem;
          end
      end 
      read_token(fp, token); 
      if(token != "[[/transaction]]") begin 
          $display("ERROR: Simulation using HLS TB failed.");
          $finish; 
      end 
      read_token(fp, token); 
      transaction_idx = transaction_idx + 1; 
  end 
  $fclose(fp); 
end 
 
task write_binary_enable_nms;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
task write_binary_candidate_count;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
//------------------------Write file----------------------- 
 
// Write data to file 
 
initial begin : write_candidate_count_file_proc 
  integer fp; 
  integer factor; 
  integer transaction_idx; 
  reg [candidate_count_c_bitwidth - 1 : 0] tmp_cache_mem; 
  reg [ 100*8 : 1] str;
  reg [63:0] bin_data;
  integer i; 
  transaction_idx = 0; 
  count_seperate_factor_by_bitwidth (candidate_count_c_bitwidth , factor);
  while(1) begin 
      @(posedge clk);
      while (candidate_count_read_data_finish !== 1 || TRAN_control_transaction_done_in === 1) begin
          @(posedge clk);
      end
      # 0.1;
      fp = $fopen(`TV_OUT_candidate_count, "a"); 
      if(fp == 0) begin       // Failed to open file 
          $display("Failed to open file \"%s\"!", `TV_OUT_candidate_count); 
          $finish; 
      end 
      $fdisplay(fp, "[[transaction]] %d", transaction_idx);
      for (i = 0; i < (candidate_count_DEPTH - candidate_count_DEPTH % factor); i = i + 1) begin
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem = mem_candidate_count[i/factor][7:0];
              end
              if (i%factor == 1) begin
                  tmp_cache_mem = mem_candidate_count[i/factor][15:8];
              end
              if (i%factor == 2) begin
                  tmp_cache_mem = mem_candidate_count[i/factor][23:16];
              end
              if (i%factor == 3) begin
                  tmp_cache_mem = mem_candidate_count[i/factor][31:24];
              end
              $fdisplay(fp,"0x%x",tmp_cache_mem);
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem = mem_candidate_count[i/factor][15:0];
              end
              if (i%factor == 1) begin
                  tmp_cache_mem = mem_candidate_count[i/factor][31:16];
              end
              $fdisplay(fp,"0x%x",tmp_cache_mem);
          end
          if (factor == 1) begin
              $fdisplay(fp,"0x%x",mem_candidate_count[i]);
          end
      end 
      if (factor == 4) begin
          if ((candidate_count_DEPTH - 1) % factor == 2) begin
              $fdisplay(fp,"0x%x",mem_candidate_count[candidate_count_DEPTH / factor][7:0]);
              $fdisplay(fp,"0x%x",mem_candidate_count[candidate_count_DEPTH / factor][15:8]);
              $fdisplay(fp,"0x%x",mem_candidate_count[candidate_count_DEPTH / factor][23:16]);
          end
          if ((candidate_count_DEPTH - 1) % factor == 1) begin
              $fdisplay(fp,"0x%x",mem_candidate_count[candidate_count_DEPTH / factor][7:0]);
              $fdisplay(fp,"0x%x",mem_candidate_count[candidate_count_DEPTH / factor][15:8]);
          end
          if ((candidate_count_DEPTH - 1) % factor == 0) begin
              $fdisplay(fp,"0x%x",mem_candidate_count[candidate_count_DEPTH / factor][7:0]);
          end
      end
      if (factor == 2) begin
          if ((candidate_count_DEPTH - 1) % factor == 0) begin
              $fdisplay(fp,"0x%x",mem_candidate_count[candidate_count_DEPTH / factor][15:0]);
          end
      end
      $fdisplay(fp, "[[/transaction]]");
      transaction_idx = transaction_idx + 1;
      $fclose(fp); 
      while (TRAN_control_start_in !== 1) begin
          @(posedge clk);
      end
  end 
end 
 
task write_binary_detection_count;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
//------------------------Write file----------------------- 
 
// Write data to file 
 
initial begin : write_detection_count_file_proc 
  integer fp; 
  integer factor; 
  integer transaction_idx; 
  reg [detection_count_c_bitwidth - 1 : 0] tmp_cache_mem; 
  reg [ 100*8 : 1] str;
  reg [63:0] bin_data;
  integer i; 
  transaction_idx = 0; 
  count_seperate_factor_by_bitwidth (detection_count_c_bitwidth , factor);
  while(1) begin 
      @(posedge clk);
      while (detection_count_read_data_finish !== 1 || TRAN_control_transaction_done_in === 1) begin
          @(posedge clk);
      end
      # 0.1;
      fp = $fopen(`TV_OUT_detection_count, "a"); 
      if(fp == 0) begin       // Failed to open file 
          $display("Failed to open file \"%s\"!", `TV_OUT_detection_count); 
          $finish; 
      end 
      $fdisplay(fp, "[[transaction]] %d", transaction_idx);
      for (i = 0; i < (detection_count_DEPTH - detection_count_DEPTH % factor); i = i + 1) begin
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem = mem_detection_count[i/factor][7:0];
              end
              if (i%factor == 1) begin
                  tmp_cache_mem = mem_detection_count[i/factor][15:8];
              end
              if (i%factor == 2) begin
                  tmp_cache_mem = mem_detection_count[i/factor][23:16];
              end
              if (i%factor == 3) begin
                  tmp_cache_mem = mem_detection_count[i/factor][31:24];
              end
              $fdisplay(fp,"0x%x",tmp_cache_mem);
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem = mem_detection_count[i/factor][15:0];
              end
              if (i%factor == 1) begin
                  tmp_cache_mem = mem_detection_count[i/factor][31:16];
              end
              $fdisplay(fp,"0x%x",tmp_cache_mem);
          end
          if (factor == 1) begin
              $fdisplay(fp,"0x%x",mem_detection_count[i]);
          end
      end 
      if (factor == 4) begin
          if ((detection_count_DEPTH - 1) % factor == 2) begin
              $fdisplay(fp,"0x%x",mem_detection_count[detection_count_DEPTH / factor][7:0]);
              $fdisplay(fp,"0x%x",mem_detection_count[detection_count_DEPTH / factor][15:8]);
              $fdisplay(fp,"0x%x",mem_detection_count[detection_count_DEPTH / factor][23:16]);
          end
          if ((detection_count_DEPTH - 1) % factor == 1) begin
              $fdisplay(fp,"0x%x",mem_detection_count[detection_count_DEPTH / factor][7:0]);
              $fdisplay(fp,"0x%x",mem_detection_count[detection_count_DEPTH / factor][15:8]);
          end
          if ((detection_count_DEPTH - 1) % factor == 0) begin
              $fdisplay(fp,"0x%x",mem_detection_count[detection_count_DEPTH / factor][7:0]);
          end
      end
      if (factor == 2) begin
          if ((detection_count_DEPTH - 1) % factor == 0) begin
              $fdisplay(fp,"0x%x",mem_detection_count[detection_count_DEPTH / factor][15:0]);
          end
      end
      $fdisplay(fp, "[[/transaction]]");
      transaction_idx = transaction_idx + 1;
      $fclose(fp); 
      while (TRAN_control_start_in !== 1) begin
          @(posedge clk);
      end
  end 
end 
 
task write_binary_ap_return;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;
//------------------------Write file----------------------- 
 
// Write data to file 
 
initial begin : write_ap_return_file_proc 
  integer fp; 
  integer factor; 
  integer transaction_idx; 
  reg [ap_return_c_bitwidth - 1 : 0] tmp_cache_mem; 
  reg [ 100*8 : 1] str;
  reg [63:0] bin_data;
  integer i; 
  transaction_idx = 0; 
  count_seperate_factor_by_bitwidth (ap_return_c_bitwidth , factor);
  while(1) begin 
      @(posedge clk);
      while (TRAN_control_transaction_done_in !== 1) begin
          @(posedge clk);
      end
      # 0.1;
      fp = $fopen(`TV_OUT_ap_return, "a"); 
      if(fp == 0) begin       // Failed to open file 
          $display("Failed to open file \"%s\"!", `TV_OUT_ap_return); 
          $finish; 
      end 
      $fdisplay(fp, "[[transaction]] %d", transaction_idx);
      for (i = 0; i < (ap_return_DEPTH - ap_return_DEPTH % factor); i = i + 1) begin
          if (factor == 4) begin
              if (i%factor == 0) begin
                  tmp_cache_mem = mem_ap_return[i/factor][7:0];
              end
              if (i%factor == 1) begin
                  tmp_cache_mem = mem_ap_return[i/factor][15:8];
              end
              if (i%factor == 2) begin
                  tmp_cache_mem = mem_ap_return[i/factor][23:16];
              end
              if (i%factor == 3) begin
                  tmp_cache_mem = mem_ap_return[i/factor][31:24];
              end
              $fdisplay(fp,"0x%x",tmp_cache_mem);
          end
          if (factor == 2) begin
              if (i%factor == 0) begin
                  tmp_cache_mem = mem_ap_return[i/factor][15:0];
              end
              if (i%factor == 1) begin
                  tmp_cache_mem = mem_ap_return[i/factor][31:16];
              end
              $fdisplay(fp,"0x%x",tmp_cache_mem);
          end
          if (factor == 1) begin
              $fdisplay(fp,"0x%x",mem_ap_return[i]);
          end
      end 
      if (factor == 4) begin
          if ((ap_return_DEPTH - 1) % factor == 2) begin
              $fdisplay(fp,"0x%x",mem_ap_return[ap_return_DEPTH / factor][7:0]);
              $fdisplay(fp,"0x%x",mem_ap_return[ap_return_DEPTH / factor][15:8]);
              $fdisplay(fp,"0x%x",mem_ap_return[ap_return_DEPTH / factor][23:16]);
          end
          if ((ap_return_DEPTH - 1) % factor == 1) begin
              $fdisplay(fp,"0x%x",mem_ap_return[ap_return_DEPTH / factor][7:0]);
              $fdisplay(fp,"0x%x",mem_ap_return[ap_return_DEPTH / factor][15:8]);
          end
          if ((ap_return_DEPTH - 1) % factor == 0) begin
              $fdisplay(fp,"0x%x",mem_ap_return[ap_return_DEPTH / factor][7:0]);
          end
      end
      if (factor == 2) begin
          if ((ap_return_DEPTH - 1) % factor == 0) begin
              $fdisplay(fp,"0x%x",mem_ap_return[ap_return_DEPTH / factor][15:0]);
          end
      end
      $fdisplay(fp, "[[/transaction]]");
      transaction_idx = transaction_idx + 1;
      $fclose(fp); 
  end 
end 
 
endmodule
