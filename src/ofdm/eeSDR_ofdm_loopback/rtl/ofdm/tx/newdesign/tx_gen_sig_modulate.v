`timescale 1ns / 1ps

module tx_gen_sig_modulate (
    input   wire                            clk_Modulation                                  ,
    input   wire                            reset                                           ,
    input   wire                            tx_gen_sig_modulate_in_valid                    ,
    input   wire                            tx_gen_sig_modulate_in_bit                      ,
    output  reg                             tx_gen_sig_modulate_valid                       ,
    output  reg     [31:0]                  tx_gen_sig_modulate_re                          ,
    output  reg     [31:0]                  tx_gen_sig_modulate_im
);

    parameter           [31:0]                  table_re_0 = 32'hc0000000;
    //-1
    parameter           [31:0]                  table_re_1 = 32'h40000000;
    // 1

    wire                                        w_tx_gen_sig_modulate_in_valid_start_flag;
    reg                                         r_tx_gen_sig_modulate_in_valid_start_flag_dly1;
    reg                                         r_tx_gen_sig_modulate_in_valid_start_flag_dly2;
    //reg tx_gen_sig_modulate_in_valid_start_flag_dly3;
    reg                                         r_tx_gen_sig_modulate_in_valid_dly;
    reg                 [5:0]                   r_cnt_52;
    reg                                         r_state;
    reg                                         r_fifo_rd_en;
    wire                                        w_fifo_dout;

    assign w_tx_gen_sig_modulate_in_valid_start_flag = tx_gen_sig_modulate_in_valid & ~r_tx_gen_sig_modulate_in_valid_dly;

    always @(*) begin
        if (reset) begin
            tx_gen_sig_modulate_valid <= 0;
        end
        else if (r_state == 1) begin
            tx_gen_sig_modulate_valid <= 1;
        end
        else begin
            tx_gen_sig_modulate_valid <= 0;
        end
    end

    always @(*) begin
        if (reset) begin
            r_fifo_rd_en <= 0;
        end
        if ((r_cnt_52 == 5) || (r_cnt_52 == 19) || (r_cnt_52 == 32) || (r_cnt_52 == 46)) begin
            r_fifo_rd_en <= 0;
        end
        else if (r_state) begin
            r_fifo_rd_en <= 1;
        end
        else begin
            r_fifo_rd_en <= 0;
        end
    end

    always @(posedge clk_Modulation) begin
        if (reset) begin
            r_cnt_52 <= 0;
        end
        else if (r_cnt_52 == 51) begin
            r_cnt_52 <= 0;
        end
        else if (r_state == 1) begin
            r_cnt_52 <= r_cnt_52 + 1;
        end
        else begin
            r_cnt_52 <= r_cnt_52;
        end
    end

    always @(posedge clk_Modulation) begin
        if (reset) begin
            r_state <= 0;
        end
        else if (r_cnt_52 == 51) begin
            r_state <= 0;
        end
        else if (r_tx_gen_sig_modulate_in_valid_start_flag_dly2) begin
            r_state <= 1;
        end
        else begin
            r_state <= r_state;
        end
    end

    always @(posedge clk_Modulation) begin
        if (reset) begin
            r_tx_gen_sig_modulate_in_valid_dly <= 0;
            r_tx_gen_sig_modulate_in_valid_start_flag_dly1 <= 0;
            r_tx_gen_sig_modulate_in_valid_start_flag_dly2 <= 0;
        //        tx_gen_sig_modulate_in_valid_start_flag_dly3 <= 0;
        end
        else begin
            r_tx_gen_sig_modulate_in_valid_dly <= tx_gen_sig_modulate_in_valid;
            r_tx_gen_sig_modulate_in_valid_start_flag_dly1 <= w_tx_gen_sig_modulate_in_valid_start_flag;
            r_tx_gen_sig_modulate_in_valid_start_flag_dly2 <= r_tx_gen_sig_modulate_in_valid_start_flag_dly1;
        //        tx_gen_sig_modulate_in_valid_start_flag_dly3 <= tx_gen_sig_modulate_in_valid_start_flag_dly2;
        end
    end

    always @(*) begin
        if (reset) begin
            tx_gen_sig_modulate_re <= 0;
            tx_gen_sig_modulate_im <= 0;
        end
        else if ((r_cnt_52 == 5) || (r_cnt_52 == 19) || (r_cnt_52 == 32)) begin
            tx_gen_sig_modulate_re <= table_re_1;
            tx_gen_sig_modulate_im <= 0;
        end
        else if (r_cnt_52 == 46) begin
            tx_gen_sig_modulate_re <= table_re_0;
            tx_gen_sig_modulate_im <= 0;
        end
        else if (w_fifo_dout == 0) begin
            tx_gen_sig_modulate_re <= table_re_0;
            tx_gen_sig_modulate_im <= 0;
        end
        else if (w_fifo_dout == 1) begin
            tx_gen_sig_modulate_re <= table_re_1;
            tx_gen_sig_modulate_im <= 0;
        end
        else begin
            tx_gen_sig_modulate_re <= 0;
            tx_gen_sig_modulate_im <= 0;
        end
    end

    fifo_tx_gen_sig_modulate_48_52 u_fifo_tx_gen_sig_modulate_48_52 (
        .clk                                          (clk_Modulation),  // input wire clk
        .srst                                         (reset),  // input wire srst
        .din                                          (tx_gen_sig_modulate_in_bit),  // input wire [0:0] din
        .wr_en                                        (tx_gen_sig_modulate_in_valid),  // input wire wr_en
        .rd_en                                        (r_fifo_rd_en),  // input wire rd_en
        .dout                                         (w_fifo_dout),  // output wire [0:0] dout
        .full                                         (),  // output wire full
        .empty                                        ()  // output wire empty
    );

endmodule
