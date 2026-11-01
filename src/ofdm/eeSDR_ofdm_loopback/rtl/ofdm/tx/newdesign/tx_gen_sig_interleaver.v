`timescale 1ns / 1ps

module tx_gen_sig_interleaver (
    input   wire                            clk_Modulation                                  ,
    input   wire                            reset                                           ,
    input   wire                            tx_gen_sig_interleaver_in_valid                 ,
    input   wire    [1:0]                   tx_gen_sig_interleaver_in_bit                   ,
    output  reg                             tx_gen_sig_interleaver_valid                    ,
    output  wire                            tx_gen_sig_interleaver_bit
);

    wire                                        w_tx_gen_sig_interleaver_in_valid_end_flag;
    wire                                        w_write_ram_ok;
    wire                [5:0]                   w_intlvr_patt;
    reg                                         r_state_tmp;
    reg                                         r_state_tmp_dly;
    reg                                         r_state_tmp_dly2;
    reg                                         r_state_tmp_dly3;
    reg                 [47:0]                  r_in_bits_fifo;
    reg                 [5:0]                   r_cnt_48;
    reg                 [5:0]                   r_cnt_48_dly;
    reg                 [5:0]                   r_cnt_48_dly2;
    reg                 [5:0]                   r_cnt_48_dly3;
    reg                 [5:0]                   r_out_48;
    reg                                         r_tx_gen_sig_interleaver_in_valid_dly;
    reg                 [5:0]                   r_ram_addr;
    reg                                         r_state;
    reg                                         r_state_dly;
    reg                                         r_state_dly2;

    assign w_write_ram_ok = ~r_state_tmp_dly2 & r_state_tmp_dly3;
    assign w_tx_gen_sig_interleaver_in_valid_end_flag = ~tx_gen_sig_interleaver_in_valid & r_tx_gen_sig_interleaver_in_valid_dly;

    always @(posedge clk_Modulation) begin
        if (reset) begin
            r_state_tmp_dly <= 0;
            r_state_tmp_dly2 <= 0;
            r_state_tmp_dly3 <= 0;
            r_cnt_48_dly <= 0;
            r_cnt_48_dly2 <= 0;
            r_cnt_48_dly3 <= 0;
            r_state_dly <= 0;
            r_state_dly2 <= 0;
            tx_gen_sig_interleaver_valid <= 0;
        end
        else begin
            r_state_tmp_dly <= r_state_tmp;
            r_state_tmp_dly2 <= r_state_tmp_dly;
            r_state_tmp_dly3 <= r_state_tmp_dly2;
            r_cnt_48_dly <= r_cnt_48;
            r_cnt_48_dly2 <= r_cnt_48_dly;
            r_cnt_48_dly3 <= r_cnt_48_dly2;
            r_state_dly <= r_state;
            r_state_dly2 <= r_state_dly;
            tx_gen_sig_interleaver_valid <= r_state_dly2;
        end
    end

    always @(posedge clk_Modulation) begin
        if (reset) begin
            r_state_tmp <= 0;
        end
        else if (r_cnt_48 == 47) begin
            r_state_tmp <= 0;
        end
        else if (w_tx_gen_sig_interleaver_in_valid_end_flag) begin
            r_state_tmp <= 1;
        end
        else begin
            r_state_tmp <= r_state_tmp;
        end
    end

    always @(posedge clk_Modulation) begin
        if (reset) begin
            r_cnt_48 <= 0;
        end
        else if (r_cnt_48 == 47) begin
            r_cnt_48 <= 0;
        end
        else if (r_state_tmp) begin
            r_cnt_48 <= r_cnt_48 + 1;
        end
        else begin
            r_cnt_48 <= r_cnt_48;
        end
    end

    always @(posedge clk_Modulation) begin
        if (reset) begin
            r_tx_gen_sig_interleaver_in_valid_dly <= 0;
        end
        else begin
            r_tx_gen_sig_interleaver_in_valid_dly <= tx_gen_sig_interleaver_in_valid;
        end
    end

    always @(posedge clk_Modulation) begin
        if (reset) begin
            r_in_bits_fifo <= 0;
        end
        else if (tx_gen_sig_interleaver_in_valid) begin
            r_in_bits_fifo <= {tx_gen_sig_interleaver_in_bit[0], tx_gen_sig_interleaver_in_bit[1], r_in_bits_fifo[47:2]};
        end
        else begin
            r_in_bits_fifo <= r_in_bits_fifo;
        end
    end

    always @(posedge clk_Modulation) begin
        if (reset) begin
            r_state <= 0;
        end
        else if (r_out_48 == 47) begin
            r_state <= 0;
        end
        else if (w_write_ram_ok) begin
            r_state <= 1;
        end
        else begin
            r_state <= r_state;
        end
    end

    always @(posedge clk_Modulation) begin
        if (reset) begin
            r_ram_addr <= 0;
        end
        else if (r_state == 0) begin
            r_ram_addr <= w_intlvr_patt;
        end
        else if (r_state == 1) begin
            r_ram_addr <= r_out_48;
        end
        else begin
            r_ram_addr <= r_ram_addr;
        end
    end

    always @(posedge clk_Modulation) begin
        if (reset) begin
            r_out_48 <= 0;
        end
        else if (r_out_48 == 47) begin
            r_out_48 <= 0;
        end
        else if (r_state == 1) begin
            r_out_48 <= r_out_48 + 1;
        end
        else begin
            r_out_48 <= r_out_48;
        end
    end

    blk_mem_tx_gen_sig_interleaver u_blk_mem_tx_gen_sig_interleaver (
        .clka                                         (clk_Modulation),  // input wire clka
        .addra                                        (r_cnt_48),  // input wire [5:0] addra
        .douta                                        (w_intlvr_patt)  // output wire [5:0] douta
    );

    blk_mem_gen_tx_gen_interleaved_bits u_blk_mem_gen_tx_gen_interleaved_bits (
        .clka                                         (clk_Modulation),  // input wire clka
        .wea                                          (r_state_tmp_dly3),  // input wire [0:0] wea
        .addra                                        (r_ram_addr),  // input wire [5:0] addra
        .dina                                         (r_in_bits_fifo[r_cnt_48_dly3]),  // input wire [0:0] dina
        .douta                                        (tx_gen_sig_interleaver_bit)  // output wire [0:0] douta
    );

endmodule
