`timescale 1ns / 1ps
module tx_freqd_to_timed (
    output  wire                            fft_config_valid                                ,
    output  wire                            fft_input_valid                                 ,
    output  wire                            fft_input_last                                  ,
    output  wire    [63:0]                  fft_input_data                                  ,
    input   wire    [79:0]                  fft_output_data                                 ,
    input   wire    [7:0]                   fft_output_index                                ,
    input   wire                            fft_output_valid                                ,
    input   wire                            clk_Modulation                                  ,
    input   wire                            reset                                           ,
    input   wire    [15:0]                  n_ofdm_syms                                     ,
    input   wire                            tx_freqd_to_timed_valid                         ,
    input   wire    [31:0]                  tx_freqd_to_timed_re                            ,
    input   wire    [31:0]                  tx_freqd_to_timed_im                            ,
    output  reg                             tx_freq_to_timed_cycle_flag                     ,
    output  reg                             tx_add_cyclic_prefix_valid                      ,
    output  reg                             tx_add_cyclic_prefix_end                        ,
    output  reg     [15:0]                  tx_add_cyclic_prefix_re                         ,
    output  reg     [15:0]                  tx_add_cyclic_prefix_im
);

    reg                 [5:0]                   r_fifo_wr_cnt;
    wire                                        w_fifo_generator_tx_freqd_to_timed_wren;
    reg                                         r_ifft_in_valid;
    reg                 [7:0]                   r_tx_freqd_to_timed_j;
    reg                 [31:0]                  r_ifft_re_in;
    reg                 [31:0]                  r_ifft_im_in;
    wire                                        w_fifo_generator_tx_freqd_to_timed_rden;
    wire                [31:0]                  w_fifo_re_dout;
    wire                [31:0]                  w_fifo_im_dout;
    reg                                         r_tx_freqd_to_timed_valid_dly;
    wire                                        w_tx_freqd_to_timed_valid_flag;
    wire                [63:0]                  w_ifft_in;
    reg                                         r_ifft_in_last;

    wire                                        w_ifft_output_valid;
    wire                [7:0]                   w_ifft_out_cnt;
    wire                [79:0]                  w_ifft_output_data;
    wire                                        w_ifft_output_last;
    reg                 [15:0]                  r_ifft_im_out;
    reg                 [15:0]                  r_ifft_re_out;
    wire                [31:0]                  w_ifft_out;
    reg                 [7:0]                   r_tx_add_cyclic_prefix_j;
    reg                                         r_fifo_generator_tx_add_cyclic_prefix_rden;
    wire                [31:0]                  w_fifo_generator_tx_add_cyclic_prefix_dout;

    reg                 [15:0]                  r_tx_freq_to_timed_cycle_flag_cnt;
    reg                 [15:0]                  r_symbol_last;
    // Metadata has settled before the mapper begins its first carrier burst.
    always @(posedge clk_Modulation) begin
        if (reset) r_symbol_last <= 0;
        else if (w_tx_freqd_to_timed_valid_flag) r_symbol_last <= n_ofdm_syms - 16'd1;
    end

    assign w_fifo_generator_tx_freqd_to_timed_wren = (tx_freqd_to_timed_valid == 1'b1) && (r_fifo_wr_cnt < 'd26);
    assign w_fifo_generator_tx_freqd_to_timed_rden = (r_tx_freqd_to_timed_j > 'd100) && (r_tx_freqd_to_timed_j < 'd127);

    assign w_tx_freqd_to_timed_valid_flag = (~r_tx_freqd_to_timed_valid_dly) & tx_freqd_to_timed_valid;

    assign w_ifft_in = {r_ifft_im_in, r_ifft_re_in};

    always @(posedge clk_Modulation) begin
        r_tx_freqd_to_timed_valid_dly <= !reset && tx_freqd_to_timed_valid;
    end

    always @(posedge clk_Modulation) begin
        if (reset == 1'b1) begin
            r_fifo_wr_cnt <= 'd0;
        end
        else if (tx_freqd_to_timed_valid == 1'b1 && r_fifo_wr_cnt == 'd51) begin
            r_fifo_wr_cnt <= 'd0;
        end
        else if (tx_freqd_to_timed_valid == 1'b1) begin
            r_fifo_wr_cnt <= r_fifo_wr_cnt + 1'b1;
        end
    end

    always @(posedge clk_Modulation) begin
        if (reset == 1'b1) begin
            r_ifft_in_valid <= 1'b0;
        end
        else if (r_tx_freqd_to_timed_j == 'd127) begin
            r_ifft_in_valid <= 1'b0;
        end
        else if (r_fifo_wr_cnt == 'd25) begin
            r_ifft_in_valid <= 1'b1;
        end
    end

    always @(posedge clk_Modulation) begin
        if (reset == 1'b1) begin
            r_tx_freqd_to_timed_j <= 'd0;
        end
        else if (r_ifft_in_valid == 1'b1 && r_tx_freqd_to_timed_j == 'd127) begin
            r_tx_freqd_to_timed_j <= 'd0;
        end
        else if (r_ifft_in_valid == 1'b1) begin
            r_tx_freqd_to_timed_j <= r_tx_freqd_to_timed_j + 1'b1;
        end
    end

    always @(posedge clk_Modulation) begin
        if (reset == 1'b1) begin
            r_ifft_im_in <= 'd0;
            r_ifft_re_in <= 'd0;
        end
        else if (r_ifft_in_valid == 1'b1 && r_tx_freqd_to_timed_j < 'd26) begin
            r_ifft_re_in <= tx_freqd_to_timed_re;
            r_ifft_im_in <= tx_freqd_to_timed_im;
        end
        else if (r_ifft_in_valid == 1'b1 && r_tx_freqd_to_timed_j > 'd100 && r_tx_freqd_to_timed_j < 'd127) begin
            r_ifft_re_in <= w_fifo_re_dout;
            r_ifft_im_in <= w_fifo_im_dout;
        end
        else begin
            r_ifft_im_in <= 'd0;
            r_ifft_re_in <= 'd0;
        end
    end

    always @(posedge clk_Modulation) begin
        if (reset == 1'b1) begin
            r_ifft_in_last <= 1'b0;
        end
        else if (r_tx_freqd_to_timed_j == 'd126) begin
            r_ifft_in_last <= 1'b1;
        end
        else begin
            r_ifft_in_last <= 1'b0;
        end
    end

    //ifft_im_out
    always @(*) begin
        if (w_ifft_output_data[79:77] == 3'b111 || w_ifft_output_data[79:77] == 3'b000) begin
            r_ifft_im_out <= w_ifft_output_data[77:62];
        end
        else if (w_ifft_output_data[79] == 1'b1) begin
            r_ifft_im_out <= 16'h8000;
        //-32768
        end
        else if (w_ifft_output_data[79] == 1'b0) begin
            r_ifft_im_out <= 16'h7fff;
        //32767
        end
        else begin
            r_ifft_im_out <= 16'd0;
        end
    end

    always @(*) begin
        if (w_ifft_output_data[39:37] == 3'b111 || w_ifft_output_data[39:37] == 3'b000) begin
            r_ifft_re_out <= w_ifft_output_data[37:22];
        end
        else if (w_ifft_output_data[39] == 1'b1) begin
            r_ifft_re_out <= 16'h8000;
        //-32768
        end
        else if (w_ifft_output_data[39] == 1'b0) begin
            r_ifft_re_out <= 16'h7fff;
        //32767
        end
        else begin
            r_ifft_re_out <= 16'd0;
        end
    end

    assign w_ifft_out = {r_ifft_im_out, r_ifft_re_out};

    always @(posedge clk_Modulation) begin
        if (reset == 1'b1) begin
            tx_add_cyclic_prefix_valid <= 1'b0;
        end
        else if (w_ifft_out_cnt == 'd95 && w_ifft_output_valid == 1'b1) begin
            tx_add_cyclic_prefix_valid <= 1'b1;
        end
        else if (r_tx_add_cyclic_prefix_j == 'd159) begin
            tx_add_cyclic_prefix_valid <= 1'b0;
        end
    end

    always @(posedge clk_Modulation) begin
        if (reset == 1'b1) begin
            r_tx_add_cyclic_prefix_j <= 'd0;
        end
        else if (tx_add_cyclic_prefix_valid == 1'b1 && r_tx_add_cyclic_prefix_j == 'd159) begin
            r_tx_add_cyclic_prefix_j <= 'd0;
        end
        else if (tx_add_cyclic_prefix_valid == 1'b1) begin
            r_tx_add_cyclic_prefix_j <= r_tx_add_cyclic_prefix_j + 1'b1;
        end
    end

    always @(*) begin
        // rd_en is asserted one clock before the boundary to hide the FIFO
        // registered read latency.  Keep the mux on direct IFFT data through
        // j=31; the FIFO data starts at the first non-CP point, j=32.
        if (tx_add_cyclic_prefix_valid == 1'b1 && r_tx_add_cyclic_prefix_j >= 'd32) begin
            tx_add_cyclic_prefix_im <= w_fifo_generator_tx_add_cyclic_prefix_dout[31:16];
            tx_add_cyclic_prefix_re <= w_fifo_generator_tx_add_cyclic_prefix_dout[15:0];
        end
        else if (tx_add_cyclic_prefix_valid == 1'b1 && r_tx_add_cyclic_prefix_j < 'd32) begin
            tx_add_cyclic_prefix_im <= r_ifft_im_out;
            tx_add_cyclic_prefix_re <= r_ifft_re_out;
        end
        else begin
            tx_add_cyclic_prefix_im <= 'd0;
            tx_add_cyclic_prefix_re <= 'd0;
        end
    end

    always @(posedge clk_Modulation) begin
        if (reset == 1'b1) begin
            r_fifo_generator_tx_add_cyclic_prefix_rden <= 1'b0;
        end
        else if (r_tx_add_cyclic_prefix_j == 'd159) begin
            r_fifo_generator_tx_add_cyclic_prefix_rden <= 1'b0;
        end
        // FWFT: assert rd_en for j=32..159, exactly 128 reads per IFFT.
        // Starting one cycle later leaves one word in the FIFO per symbol and
        // causes an accumulating sample/phase error in subsequent symbols.
        else if (r_tx_add_cyclic_prefix_j == 'd31) begin
            r_fifo_generator_tx_add_cyclic_prefix_rden <= 1'b1;
        end
    end

    always @(posedge clk_Modulation) begin
        if (reset == 1'b1) begin
            tx_freq_to_timed_cycle_flag <= 1'b0;
        end
        else if (r_tx_add_cyclic_prefix_j == 'd159) begin
            tx_freq_to_timed_cycle_flag <= 1'b1;
        end
        else begin
            tx_freq_to_timed_cycle_flag <= 1'b0;
        end
    end

    always @(posedge clk_Modulation) begin
        if (reset == 1'b1) begin
            r_tx_freq_to_timed_cycle_flag_cnt <= 'd0;
        end
        else if (tx_freq_to_timed_cycle_flag == 1'b1 && r_tx_freq_to_timed_cycle_flag_cnt == r_symbol_last) begin
            r_tx_freq_to_timed_cycle_flag_cnt <= 'd0;
        end
        else if (tx_freq_to_timed_cycle_flag == 1'b1) begin
            r_tx_freq_to_timed_cycle_flag_cnt <= r_tx_freq_to_timed_cycle_flag_cnt + 1'b1;
        end
    end

    always @(posedge clk_Modulation) begin
        if (reset == 1'b1) begin
            tx_add_cyclic_prefix_end <= 1'b0;
        end
        else if (tx_freq_to_timed_cycle_flag == 1'b1 && r_tx_freq_to_timed_cycle_flag_cnt == r_symbol_last) begin
            tx_add_cyclic_prefix_end <= 1'b1;
        end
        else begin
            tx_add_cyclic_prefix_end <= 1'b0;
        end
    end

    tx_symbol_fifo #(
        .ADDR_WIDTH                                   (5),
        .RAM_STYLE                                    ("distributed")) u_fifo_generator_tx_freqd_to_timed_re (
        .reset                                        (reset),
        .clk                                          (clk_Modulation),  // input wire clk
        .din                                          (tx_freqd_to_timed_re),  // input wire [31:0] din
        .wr_en                                        (w_fifo_generator_tx_freqd_to_timed_wren),  // input wire wr_en
        .rd_en                                        (w_fifo_generator_tx_freqd_to_timed_rden),  // input wire rd_en
        .dout                                         (w_fifo_re_dout),  // output wire [31:0] dout
        .full                                         (),  // output wire full
        .empty                                        ()  // output wire empty
    );

    tx_symbol_fifo #(
        .ADDR_WIDTH                                   (5),
        .RAM_STYLE                                    ("distributed")) u_fifo_generator_tx_freqd_to_timed_im (
        .reset                                        (reset),
        .clk                                          (clk_Modulation),  // input wire clk
        .din                                          (tx_freqd_to_timed_im),  // input wire [31:0] din
        .wr_en                                        (w_fifo_generator_tx_freqd_to_timed_wren),  // input wire wr_en
        .rd_en                                        (w_fifo_generator_tx_freqd_to_timed_rden),  // input wire rd_en
        .dout                                         (w_fifo_im_dout),  // output wire [31:0] dout
        .full                                         (),  // output wire full
        .empty                                        ()  // output wire empty
    );

    // The top-level owns the single IFFT shared by SIGNAL and DATA.
    assign fft_config_valid = w_tx_freqd_to_timed_valid_flag;
    assign fft_input_data = w_ifft_in;
    assign fft_input_valid = r_ifft_in_valid;
    assign fft_input_last = r_ifft_in_last;
    assign w_ifft_output_data = fft_output_data;
    assign w_ifft_out_cnt = fft_output_index;
    assign w_ifft_output_valid = fft_output_valid;

    tx_symbol_fifo #(
        .ADDR_WIDTH                                   (7)) u_fifo_generator_tx_add_cyclic_prefix (
        .reset                                        (reset),
        .clk                                          (clk_Modulation),  // input wire clk
        .din                                          (w_ifft_out),  // input wire [31:0] din
        .wr_en                                        (w_ifft_output_valid),  // input wire wr_en
        .rd_en                                        (r_fifo_generator_tx_add_cyclic_prefix_rden),  // input wire rd_en
        .dout                                         (w_fifo_generator_tx_add_cyclic_prefix_dout),  // output wire [31:0] dout
        .full                                         (),  // output wire full
        .empty                                        ()  // output wire empty
    );
endmodule

// Resettable FWFT queue for one symbol. Output register plus synchronous read
// preserve a RAM-friendly data path. Pointer reset discards aborted symbols;
// memory contents need no reset. Exposed capacity is 2**ADDR_WIDTH RAM words
// plus the output register. A FWFT consumer never reads while empty.
module tx_symbol_fifo #(
    parameter                                   ADDR_WIDTH = 7,
    parameter                                   RAM_STYLE = "block"
) (
    input   wire                            clk                                             ,
    input   wire                            reset                                           ,
    input   wire    [31:0]                  din                                             ,
    input   wire                            wr_en                                           ,
    input   wire                            rd_en                                           ,
    output  reg     [31:0]                  dout                                            ,
    output  wire                            full                                            ,
    output  wire                            empty
);
    (* ram_style = RAM_STYLE *) reg [31:0] r_mem[0:(1 << ADDR_WIDTH) - 1];
    reg                 [ADDR_WIDTH:0]          r_wr_ptr;
    reg                 [ADDR_WIDTH:0]          r_rd_ptr;
    reg                                         r_valid;
    wire                                        w_ram_empty = r_wr_ptr == r_rd_ptr;
    wire                                        w_fetch = (!r_valid || rd_en) && !w_ram_empty;
    assign empty = !r_valid;
    assign full = r_wr_ptr[ADDR_WIDTH] != r_rd_ptr[ADDR_WIDTH] &&
        r_wr_ptr[ADDR_WIDTH - 1:0] == r_rd_ptr[ADDR_WIDTH - 1:0];
    always @(posedge clk) begin
        if (!reset && wr_en) r_mem[r_wr_ptr[ADDR_WIDTH - 1:0]] <= din;
        if (w_fetch) dout <= r_mem[r_rd_ptr[ADDR_WIDTH - 1:0]];
        if (reset) begin
            r_wr_ptr <= 0;
            r_rd_ptr <= 0;
            r_valid <= 0;
        end
        else begin
            if (wr_en) r_wr_ptr <= r_wr_ptr + 1'b1;
            if (w_fetch) begin
                r_rd_ptr <= r_rd_ptr + 1'b1;
                r_valid <= 1;
            end
            else if (rd_en) r_valid <= 0;
        end
    end
    // synthesis translate_off
    always @(posedge clk) if (!reset) begin
        if (wr_en && full) $fatal(1, "TX symbol FIFO overflow");
        if (rd_en && empty) $fatal(1, "TX symbol FIFO underflow");
    end
// synthesis translate_on
endmodule
