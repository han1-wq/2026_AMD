`timescale 1ns / 1ps

module tx_gen_sig_freqd_to_timed (
    output  wire                            fft_config_valid                                ,
    output  wire                            fft_input_valid                                 ,
    output  wire                            fft_input_last                                  ,
    output  wire    [63:0]                  fft_input_data                                  ,
    input   wire    [79:0]                  fft_output_data                                 ,
    input   wire    [7:0]                   fft_output_index                                ,
    input   wire                            fft_output_valid                                ,
    input   wire                            clk_Modulation                                  ,
    input   wire                            reset                                           ,
    input   wire                            tx_freqd_to_timed_valid                         ,
    input   wire    [31:0]                  tx_freqd_to_timed_re                            ,
    input   wire    [31:0]                  tx_freqd_to_timed_im                            ,
    output  reg                             tx_add_cyclic_prefix_valid                      ,
    output  reg     [15:0]                  tx_add_cyclic_prefix_re                         ,
    output  reg     [15:0]                  tx_add_cyclic_prefix_im
);

    wire                                        w_tx_freqd_to_timed_valid_flag;
    wire                [31:0]                  w_fifo_re_dout;
    wire                [31:0]                  w_fifo_im_dout;
    wire                [63:0]                  w_ifft_in;
    wire                                        w_ifft_output_last;
    wire                [79:0]                  w_ifft_output_data;
    wire                [15:0]                  w_ifft_re_out;
    wire                [15:0]                  w_ifft_im_out;
    wire                [31:0]                  w_ifft_out;
    wire                                        w_ifft_output_valid;
    wire                [31:0]                  w_fifo_generator_tx_add_cyclic_prefix_dout;
    wire                [7:0]                   w_ifft_out_cnt;
    reg                                         r_ifft_in_valid;
    reg                 [31:0]                  r_ifft_re_in;
    reg                 [31:0]                  r_ifft_im_in;
    reg                                         r_tx_freqd_to_timed_valid_dly;
    reg                 [15:0]                  r_tx_add_cyclic_prefix_j;
    reg                 [15:0]                  r_tx_freqd_to_timed_j;
    reg                 [6:0]                   r_fifo_wr_cnt;
    reg                                         r_tx_freqd_to_timed_state;
    reg                                         r_ifft_data_in_last;
    reg                                         r_fifo_generator_tx_add_cyclic_prefix_rden;

    assign w_ifft_out = {w_ifft_re_out, w_ifft_im_out};
    assign w_ifft_im_out = w_ifft_output_data[77:62];
    assign w_ifft_re_out = w_ifft_output_data[37:22];
    assign w_tx_freqd_to_timed_valid_flag = tx_freqd_to_timed_valid & ~r_tx_freqd_to_timed_valid_dly;
    assign w_ifft_in = {r_ifft_im_in, r_ifft_re_in};

    always @(posedge clk_Modulation) begin
        if (reset) begin
            r_fifo_generator_tx_add_cyclic_prefix_rden <= 0;
        end
        else if (r_tx_add_cyclic_prefix_j == 159) begin
            r_fifo_generator_tx_add_cyclic_prefix_rden <= 0;
        end
        else if (r_tx_add_cyclic_prefix_j == 31) begin
            r_fifo_generator_tx_add_cyclic_prefix_rden <= 1;
        end
        else begin
            r_fifo_generator_tx_add_cyclic_prefix_rden <= r_fifo_generator_tx_add_cyclic_prefix_rden;
        end
    end

    always @(*) begin
        if (reset) begin
            tx_add_cyclic_prefix_re <= 0;
            tx_add_cyclic_prefix_im <= 0;
        end
        else if (r_tx_add_cyclic_prefix_j < 32) begin
            tx_add_cyclic_prefix_re <= w_ifft_re_out;
            tx_add_cyclic_prefix_im <= w_ifft_im_out;
        end
        else if ((r_tx_add_cyclic_prefix_j >= 32) && (r_tx_add_cyclic_prefix_j <= 159)) begin
            tx_add_cyclic_prefix_re <= w_fifo_generator_tx_add_cyclic_prefix_dout[31:16];
            tx_add_cyclic_prefix_im <= w_fifo_generator_tx_add_cyclic_prefix_dout[15:0];
        end
        else begin
            tx_add_cyclic_prefix_re <= 0;
            tx_add_cyclic_prefix_im <= 0;
        end
    end

    always @(posedge clk_Modulation) begin
        if (reset) begin
            tx_add_cyclic_prefix_valid <= 0;
        end
        else if (r_tx_add_cyclic_prefix_j == 159) begin
            tx_add_cyclic_prefix_valid <= 0;
        end
        else if (w_ifft_out_cnt == 95 && w_ifft_output_valid) begin
            tx_add_cyclic_prefix_valid <= 1;
        end
        else begin
            tx_add_cyclic_prefix_valid <= tx_add_cyclic_prefix_valid;
        end
    end

    always @(posedge clk_Modulation) begin
        if (reset) begin
            r_tx_add_cyclic_prefix_j <= 0;
        end
        else if (r_tx_add_cyclic_prefix_j == 159) begin
            r_tx_add_cyclic_prefix_j <= 0;
        end
        else if (tx_add_cyclic_prefix_valid) begin
            r_tx_add_cyclic_prefix_j <= r_tx_add_cyclic_prefix_j + 1;
        end
        else begin
            r_tx_add_cyclic_prefix_j <= 0;
        end
    end

    always @(posedge clk_Modulation) begin
        if (reset) begin
            r_ifft_data_in_last <= 0;
        end
        else if (r_tx_freqd_to_timed_j == 126) begin
            r_ifft_data_in_last <= 1;
        end
        else begin
            r_ifft_data_in_last <= 0;
        end
    end

    always @(posedge clk_Modulation) begin
        if (reset) begin
            r_ifft_re_in <= 0;
            r_ifft_im_in <= 0;
        end
        else if (r_tx_freqd_to_timed_state & (r_tx_freqd_to_timed_j < 26)) begin
            r_ifft_re_in <= tx_freqd_to_timed_re;
            r_ifft_im_in <= tx_freqd_to_timed_im;
        end
        else if (r_tx_freqd_to_timed_j > 100) begin
            r_ifft_re_in <= w_fifo_re_dout;
            r_ifft_im_in <= w_fifo_im_dout;
        end
        else begin
            r_ifft_re_in <= 0;
            r_ifft_im_in <= 0;
        end
    end

    always @(posedge clk_Modulation) begin
        if (reset) begin
            r_ifft_in_valid <= 0;
        end
        else if (r_tx_freqd_to_timed_j == 127) begin
            r_ifft_in_valid <= 0;
        end
        else if (r_fifo_wr_cnt == 25) begin
            r_ifft_in_valid <= 1;
        end
        else begin
            r_ifft_in_valid <= r_ifft_in_valid;
        end
    end

    always @(posedge clk_Modulation) begin
        if (reset) begin
            r_fifo_wr_cnt <= 0;
        end
        else if (r_fifo_wr_cnt == 51) begin
            r_fifo_wr_cnt <= 0;
        end
        else if (tx_freqd_to_timed_valid) begin
            r_fifo_wr_cnt <= r_fifo_wr_cnt + 1;
        end
        else begin
            r_fifo_wr_cnt <= 0;
        end
    end

    always @(posedge clk_Modulation) begin
        if (reset) begin
            r_tx_freqd_to_timed_valid_dly <= 0;
        end
        else begin
            r_tx_freqd_to_timed_valid_dly <= tx_freqd_to_timed_valid;
        end
    end

    always @(posedge clk_Modulation) begin
        if (reset) begin
            r_tx_freqd_to_timed_j <= 0;
        end
        else if (r_tx_freqd_to_timed_j == 127) begin
            r_tx_freqd_to_timed_j <= 0;
        end
        else if (r_tx_freqd_to_timed_state) begin
            r_tx_freqd_to_timed_j <= r_tx_freqd_to_timed_j + 1;
        end
        else begin
            r_tx_freqd_to_timed_j <= r_tx_freqd_to_timed_j;
        end
    end

    always @(posedge clk_Modulation) begin
        if (reset) begin
            r_tx_freqd_to_timed_state <= 0;
        end
        else if (r_tx_freqd_to_timed_j == 127) begin
            r_tx_freqd_to_timed_state <= 0;
        end
        else if (r_fifo_wr_cnt == 25) begin
            r_tx_freqd_to_timed_state <= 1;
        end
        else begin
            r_tx_freqd_to_timed_state <= r_tx_freqd_to_timed_state;
        end
    end

    tx_symbol_fifo #(
        .ADDR_WIDTH                                   (5),
        .RAM_STYLE                                    ("distributed")) u_fifo_generator_tx_freqd_to_timed_re (
        .reset                                        (reset),
        .clk                                          (clk_Modulation),  // input wire clk
        //.srst(reset),                // input wire srst
        .din                                          (tx_freqd_to_timed_re),  // input wire [31:0] din
        .wr_en                                        (tx_freqd_to_timed_valid & (r_fifo_wr_cnt < 26)),  // input wire wr_en
        .rd_en                                        ((r_tx_freqd_to_timed_j > 100) && (r_tx_freqd_to_timed_j < 127)),
        .dout                                         (w_fifo_re_dout),  // output wire [31:0] dout
        .full                                         (),  // output wire full
        .empty                                        ()  // output wire empty
    );

    tx_symbol_fifo #(
        .ADDR_WIDTH                                   (5),
        .RAM_STYLE                                    ("distributed")) u_fifo_generator_tx_freqd_to_timed_im (
        .reset                                        (reset),
        .clk                                          (clk_Modulation),  // input wire clk
        //.srst(reset),                // input wire srst
        .din                                          (tx_freqd_to_timed_im),  // input wire [31:0] din
        .wr_en                                        (tx_freqd_to_timed_valid & (r_fifo_wr_cnt < 26)),  // input wire wr_en
        .rd_en                                        ((r_tx_freqd_to_timed_j > 100) && (r_tx_freqd_to_timed_j < 127)),
        .dout                                         (w_fifo_im_dout),  // output wire [31:0] dout
        .full                                         (),  // output wire full
        .empty                                        ()  // output wire empty
    );

    assign fft_config_valid = w_tx_freqd_to_timed_valid_flag;
    assign fft_input_data = w_ifft_in;
    assign fft_input_valid = r_ifft_in_valid;
    assign fft_input_last = r_ifft_data_in_last;
    assign w_ifft_output_data = fft_output_data;
    assign w_ifft_out_cnt = fft_output_index;
    assign w_ifft_output_valid = fft_output_valid;

    tx_symbol_fifo #(
        .ADDR_WIDTH                                   (7)) u_fifo_generator_tx_add_cyclic_prefix (
        .reset                                        (reset),
        .clk                                          (clk_Modulation),  // input wire clk
        // .srst(reset),                // input wire srst
        .din                                          (w_ifft_out),  // input wire [31:0] din
        .wr_en                                        (w_ifft_output_valid),  // input wire wr_en
        .rd_en                                        (r_fifo_generator_tx_add_cyclic_prefix_rden),  // input wire rd_en
        .dout                                         (w_fifo_generator_tx_add_cyclic_prefix_dout),  // output wire [31:0] dout
        .full                                         (),  // output wire full
        .empty                                        ()  // output wire empty
    );

endmodule
