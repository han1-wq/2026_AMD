`timescale 1ns/1ps

module tx_generate_data (
    output  reg     [15:0]                  frame_symbols                                   ,
    input   wire                            clk_User                                        ,
    input   wire                            clk_Modulation                                  ,
    input   wire                            reset                                           ,
    input   wire    [5:0]                   tx_Rate                                         ,
    input   wire                            send_data_valid                                 ,
    input   wire    [7:0]                   send_data                                       ,
    input   wire    [15:0]                  packetlength                                    ,
    output  reg                             data_bit_valid                                  ,
    output  reg                             data_bit
);

    reg                                         r_send_data_valid_dly1;
    reg                                         r_send_data_valid_dly2;
    reg                 [7:0]                   r_send_data_dly1;
    reg                 [7:0]                   r_fifo_generator_8to1_inst_din;
    wire                                        w_fifo_generator_8to1_wren;
    wire                                        w_fifo_generator_8to1_rden;
    wire                                        w_fifo_generator_8to1_inst_empty;
    wire                                        w_fifo_generator_8to1_inst_full;
    reg                 [15:0]                  r_valid_bits_length;
    wire                                        w_send_data_valid_flag;
    reg                                         r_send_data_valid_flag_dly1;
    wire                [7:0]                   w_bits_ofdm_sym;
    reg                 [15:0]                  r_pad_num;
    reg                 [15:0]                  r_divide_bits;
    reg                 [15:0]                  r_divide_quotient;
    reg                 [7:0]                   r_divide_remainder;
    reg                 [7:0]                   r_divide_denominator;
    reg                 [4:0]                   r_divide_steps;
    reg                                         r_divide_done;
    wire                [8:0]                   w_trial_remainder = {r_divide_remainder, r_divide_bits[15]};
    wire                [8:0]                   w_trial_subtract = w_trial_remainder - {1'b0, r_divide_denominator};
    wire                                        w_quotient_bit = !w_trial_subtract[8];
    wire                                        w_fifo_generator_8to1_dout;
    reg                                         r_fifo_generator_8to1_rden_dly1;
    wire                                        w_fifo_generator_8to1_rden_end_flag;
    reg                 [1:0]                   r_pad_state;
    reg                 [15:0]                  r_cnt_6;

    always @(posedge clk_User) begin
        if (reset == 1'b1) begin
            r_send_data_valid_dly1 <= 'd0;
            r_send_data_valid_dly2 <= 'd0;
            r_send_data_dly1 <= 'd0;
        end
        else begin
            r_send_data_valid_dly1 <= send_data_valid;
            r_send_data_valid_dly2 <= r_send_data_valid_dly1;
            r_send_data_dly1 <= send_data;
        end
    end

    always @(posedge clk_User) begin
        if (reset == 1'b1) begin
            r_fifo_generator_8to1_inst_din <= 'd0;
        end
        else if (r_send_data_valid_dly1 == 1'b1) begin
            // The asymmetric FIFO emits its MSB first; reverse each PSDU byte
            // so the PHY transmits bit zero first (802.11 DATA bit ordering).
            r_fifo_generator_8to1_inst_din <= {r_send_data_dly1[0], r_send_data_dly1[1],
            r_send_data_dly1[2], r_send_data_dly1[3], r_send_data_dly1[4],
            r_send_data_dly1[5], r_send_data_dly1[6], r_send_data_dly1[7]};
        end
        else begin
            r_fifo_generator_8to1_inst_din <= 'd0;
        end
    end
    //add 16bit 0000 for service
    assign w_fifo_generator_8to1_wren = send_data_valid | r_send_data_valid_dly2;

    // no empty read fifo
    assign w_fifo_generator_8to1_rden = ~w_fifo_generator_8to1_inst_empty;
    //posedge send valid
    assign w_send_data_valid_flag = (~r_send_data_valid_dly1) & send_data_valid;

    always @(posedge clk_User) begin
        if (reset == 1'b1) begin
            r_valid_bits_length <= 'd0;
        end
        else if (w_send_data_valid_flag == 1'b1) begin
            // packetlength is the user payload length.  crc32 appends four
            // bytes before this block, and SIGNAL advertises payload+FCS, so
            // include those bytes when calculating the DATA OFDM padding.
            r_valid_bits_length <= ((packetlength + 16'd4) << 3) + 22;
        //service + tail = 16+6
        end
    end

    always @(posedge clk_User) begin
        if (reset) r_send_data_valid_flag_dly1 <= 0;
        else r_send_data_valid_flag_dly1 <= w_send_data_valid_flag;
    end

    assign w_bits_ofdm_sym = tx_Rate << 2;

    // One restoring-division step per clock. Metadata is ready in 18 user
    // clocks, before the shortest SERVICE + PSDU + FCS bit stream ends for
    // the existing equal-frequency clock contract. No multiplier is needed:
    // PAD = remainder ? N_DBPS - remainder : 0.
    always @(posedge clk_User) begin
        if (reset) begin
            r_divide_steps <= 0;
            r_divide_done <= 0;
            r_divide_bits <= 0;
            r_divide_quotient <= 0;
            r_divide_remainder <= 0;
            r_divide_denominator <= 0;
            frame_symbols <= 0;
            r_pad_num <= 0;
        end else begin
            r_divide_done <= 0;
            if (r_send_data_valid_flag_dly1) begin
                r_divide_bits <= r_valid_bits_length;
                r_divide_quotient <= 0;
                r_divide_remainder <= 0;
                r_divide_denominator <= w_bits_ofdm_sym;
                r_divide_steps <= 16;
            end else if (r_divide_steps != 0) begin
                r_divide_bits <= {r_divide_bits[14:0], 1'b0};
                r_divide_quotient <= {r_divide_quotient[14:0], w_quotient_bit};
                r_divide_remainder <= w_quotient_bit ? w_trial_subtract[7:0] : w_trial_remainder[7:0];
                r_divide_steps <= r_divide_steps - 1'b1;
                r_divide_done <= r_divide_steps == 1;
            end
            if (r_divide_done) begin
                frame_symbols <= r_divide_quotient + (r_divide_remainder != 0);
                r_pad_num <= r_divide_remainder == 0 ? 0 : r_divide_denominator - r_divide_remainder;
            end
        end
    end

    fifo_generator_8to1 u_fifo_generator_8to1 (
        .rst                                          (reset),  // input wire rst
        .wr_clk                                       (clk_User),  // input wire wr_clk
        .rd_clk                                       (clk_Modulation),  // input wire rd_clk
        .din                                          (r_fifo_generator_8to1_inst_din),  // input wire [7:0] din
        .wr_en                                        (w_fifo_generator_8to1_wren),  // input wire wr_en
        .rd_en                                        (w_fifo_generator_8to1_rden),  // input wire rd_en
        .dout                                         (w_fifo_generator_8to1_dout),  // output wire [0:0] dout
        .full                                         (w_fifo_generator_8to1_inst_full),  // output wire full
        .empty                                        (w_fifo_generator_8to1_inst_empty)  // output wire empty
    );

    always @(posedge clk_Modulation) begin
        r_fifo_generator_8to1_rden_dly1 <= w_fifo_generator_8to1_rden;
    end

    assign w_fifo_generator_8to1_rden_end_flag = (~w_fifo_generator_8to1_rden) & r_fifo_generator_8to1_rden_dly1;

    always @(posedge clk_Modulation) begin
        if (reset == 1'b1) begin
            r_pad_state <= 2'd0;
        end
        else if (data_bit_valid == 1'b0) begin
            r_pad_state <= 2'b00;
        end
        else if (r_cnt_6 == (r_pad_num + 'd5)) begin
            r_pad_state <= 2'b10;
        end
        else if (w_fifo_generator_8to1_rden_end_flag == 1'b1) begin
            r_pad_state <= 2'b01;
        end
    end

    always @(posedge clk_Modulation) begin
        if (reset == 1'b1) begin
            r_cnt_6 <= 'd0;
        end
        else if (w_fifo_generator_8to1_rden_end_flag == 1'b1 || r_pad_state == 2'b01) begin
            r_cnt_6 <= r_cnt_6 + 1'b1;
        end
        else begin
            r_cnt_6 <= 'd0;
        end
    end

    always @(posedge clk_Modulation) begin
        if (reset == 1'b1) begin
            data_bit <= 1'b0;
            data_bit_valid <= 1'b0;
        end
        else if (w_fifo_generator_8to1_rden == 1'b1) begin
            data_bit <= w_fifo_generator_8to1_dout;
            data_bit_valid <= 1'b1;
        end
        else if (w_fifo_generator_8to1_rden_end_flag == 1'b1 || r_pad_state == 2'b01) begin
            data_bit <= 1'b0;
            data_bit_valid <= 1'b1;
        end
        else begin
            data_bit <= 1'b0;
            data_bit_valid <= 1'b0;
        end
    end

endmodule
