module rx_timed_to_freqd(
// Clock
    input   wire                                        sclk                                        ,
    input   wire                                        reset                                       ,
    input   wire                                        enable                                      ,
    input   wire            [15:0]                      sample_in_i                                 ,
    input   wire            [15:0]                      sample_in_q                                 ,
    input   wire                                        sample_in_valid                             ,
    output  wire            [22:0]                      fft_out_i                                   ,
    output  wire            [22:0]                      fft_out_q                                   ,
    output  reg                                         fft_out_valid                               ,
    output  reg             [31:0]                      pilot_neg_21                                ,
    output  reg             [31:0]                      pilot_neg_7                                 ,
    output  reg             [31:0]                      pilot_pos_7                                 ,
    output  reg             [31:0]                      pilot_pos_21                                ,
    output  reg                                         pilot_valid
);

    reg                 [7:0]                       r_lt_cnt;
    reg                                             r_sig_data_file;
    reg                 [7:0]                       r_sig_data_cnt;
    reg                                             r_gi_flag;

    wire                                            w_wr_fifo_en;

    reg                                             r_rd_fifo_en;
    wire                [9:0]                       w_fifo_data_counter;
    reg                 [5:0]                       r_rd_cnt;
    wire                [31:0]                      w_rd_data;

    wire                [31:0]                      w_fft_in;
    wire                                            w_fft_in_valid;
    wire                                            w_fft_in_ready;
    wire                                            w_fft_in_last;
    wire                [7:0]                       w_xk_index;
    wire                [47:0]                      w_fft_out;
    wire                                            w_fft_out_v;
    wire                                            w_m_axis_data_tlast;

    reg                                             r_wr_fft_out_fifo;
    reg                                             r_rd_fft_out_fifo;
    reg                 [5:0]                       r_rd_fft_cnt;
    wire                [45:0]                      w_rd_fft_out;

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_lt_cnt <= 'd0;
        end
        else if (enable == 1'b1 && sample_in_valid == 1'b1 && r_lt_cnt[7] == 1'b0) begin
            r_lt_cnt <= r_lt_cnt + 1'b1;
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_sig_data_file <= 1'b0;
        end
        else if (enable == 1'b1 && sample_in_valid == 1'b1 && r_lt_cnt == 'd127) begin
            r_sig_data_file <= 1'b1;
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_sig_data_cnt <= 'd0;
        end
        else if (enable == 1'b1) begin
            if (sample_in_valid == 1'b1 && r_sig_data_cnt != 'd79 && r_sig_data_file == 1'b1) begin
                r_sig_data_cnt <= r_sig_data_cnt + 1'b1;
            end
            else if (sample_in_valid == 1'b1 && r_sig_data_cnt == 'd79 && r_sig_data_file == 1'b1) begin
                r_sig_data_cnt <= 'd0;
            end
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_gi_flag <= 1'b0;
        end
        else if (enable == 1'b1) begin
            // The first sample after the two long-training symbols starts the
            // SIGNAL cyclic prefix.  Suppress that 16-sample CP before filling
            // the FFT FIFO; otherwise the first FFT window is CP[0:15] plus only
            // 48 SIGNAL samples and the SIGNAL length field is corrupted.
            if (sample_in_valid == 1'b1 && r_lt_cnt == 'd127) begin
                r_gi_flag <= 1'b1;
            end
            else if (sample_in_valid == 1'b1 && r_sig_data_file == 1'b1 && r_sig_data_cnt == 'd15) begin
                r_gi_flag <= 1'b0;
            end
            else if (sample_in_valid == 1'b1 && r_sig_data_file == 1'b1 && r_sig_data_cnt == 'd79) begin
                r_gi_flag <= 1'b1;
            end
        end
    end

    // lt_cnt is the index BEFORE this edge: index 127 is the last LTF sample.
    // gi_flag becomes high on the following edge, for CP sample zero.
    assign w_wr_fifo_en = enable && sample_in_valid && !r_gi_flag;

    fft_buffer_32x512 u_fft_buffer_32x512 (
        .clk                                          (sclk),  // input wire clk
        .srst                                         (reset),  // input wire srst
        .din                                          ({sample_in_q, sample_in_i}),  // input wire [31:0] din
        .wr_en                                        (w_wr_fifo_en),  // input wire wr_en
        .rd_en                                        (r_rd_fifo_en),  // input wire rd_en
        .dout                                         (w_rd_data),  // output wire [31:0] dout
        .full                                         (full),  // output wire full
        .empty                                        (empty),  // output wire empty
        .data_count                                   (w_fifo_data_counter)  // output wire [9:0] data_count
    );

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_rd_fifo_en <= 1'b0;
        end
        else if (enable == 1'b1) begin
            if (w_fifo_data_counter >= 'd64 && r_rd_fifo_en == 1'b0) begin
                r_rd_fifo_en <= 1'b1;
            end
            else if (r_rd_cnt == 'd63) begin
                r_rd_fifo_en <= 1'b0;
            end
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_rd_cnt <= 'd0;
        end
        else if (enable == 1'b1) begin
            if (r_rd_fifo_en == 1'b1) begin
                r_rd_cnt <= r_rd_cnt + 1'b1;
            end
            else begin
                r_rd_cnt <= 'd0;
            end
        end
    end

    assign w_fft_in = w_rd_data;
    assign w_fft_in_valid = r_rd_fifo_en;
    assign w_fft_in_last = (r_rd_cnt == 63);

    xfft_64 u_xfft_64 (
        .aclk                                         (sclk),  // input wire aclk
        .aresetn                                      (~reset),  // input wire aresetn
        .s_axis_config_tdata                          (8'd1),  // input wire [7:0] s_axis_config_tdata
        .s_axis_config_tvalid                         (1'b1),  // input wire s_axis_config_tvalid
        .s_axis_config_tready                         (),  // output wire s_axis_config_tready
        .s_axis_data_tdata                            (w_fft_in),  // input wire [31:0] s_axis_data_tdata
        .s_axis_data_tvalid                           (w_fft_in_valid),  // input wire s_axis_data_tvalid
        .s_axis_data_tready                           (w_fft_in_ready),  // output wire s_axis_data_tready
        .s_axis_data_tlast                            (w_fft_in_last),  // input wire s_axis_data_tlast
        .m_axis_data_tdata                            (w_fft_out),  // output wire [47:0] m_axis_data_tdata
        .m_axis_data_tuser                            (w_xk_index),  // output wire [7:0] m_axis_data_tuser
        .m_axis_data_tvalid                           (w_fft_out_v),  // output wire m_axis_data_tvalid
        .m_axis_data_tready                           (1'b1),  // input wire m_axis_data_tready
        .m_axis_data_tlast                            (w_m_axis_data_tlast),  // output wire m_axis_data_tlast
        .event_frame_started                          (event_frame_started),  // output wire event_frame_started
        .event_tlast_unexpected                       (event_tlast_unexpected),  // output wire event_tlast_unexpected
        .event_tlast_missing                          (event_tlast_missing),  // output wire event_tlast_missing
        .event_status_channel_halt                    (event_status_channel_halt),  // output wire event_status_channel_halt
        .event_data_in_channel_halt                   (event_data_in_channel_halt),  // output wire event_data_in_channel_halt
        .event_data_out_channel_halt                  (event_data_out_channel_halt)  // output wire event_data_out_channel_halt
    );

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_wr_fft_out_fifo <= 1'b0;
        end
        else if (enable == 1'b1) begin
            if (w_xk_index[5:0] == 'd0 && w_fft_out_v == 1'b1) begin
                r_wr_fft_out_fifo <= 1'b1;
            end
            else if (w_xk_index[5:0] == 'd26 && w_fft_out_v == 1'b1) begin
                r_wr_fft_out_fifo <= 1'b0;
            end
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_rd_fft_out_fifo <= 1'b0;
        end
        else if (enable == 1'b1) begin
            if (w_xk_index[5:0] == 'd63 && w_fft_out_v == 1'b1) begin
                r_rd_fft_out_fifo <= 1'b1;
            end
            else if (r_rd_fft_cnt == 'd25) begin
                r_rd_fft_out_fifo <= 1'b0;
            end
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_rd_fft_cnt <= 'd0;
        end
        else if (enable == 1'b1) begin
            if (r_rd_fft_out_fifo == 1'b1) begin
                r_rd_fft_cnt <= r_rd_fft_cnt + 1'b1;
            end
            else begin
                r_rd_fft_cnt <= 'd0;
            end
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            fft_out_valid <= 1'b0;
        end
        else if (enable == 1'b1) begin
            if (w_fft_out_v == 1'b1 && w_xk_index[5:0] == 'd37) begin
                fft_out_valid <= 1'b1;
            end
            else if (r_rd_fft_cnt == 'd25 && r_rd_fft_out_fifo == 1'b1) begin
                fft_out_valid <= 1'b0;
            end
        end
    end

    // The next FFT can start while the preceding positive bins are drained.
    // The FFT has 23 significant bits in each padded 24-bit AXI lane.
    // Keep all seven fractional bits formerly discarded at this boundary.
    assign fft_out_i = r_rd_fft_out_fifo ? w_rd_fft_out[22:0]:
        (w_fft_out_v && fft_out_valid) ? w_fft_out[22:0]: 23'd0;
    assign fft_out_q = r_rd_fft_out_fifo ? w_rd_fft_out[45:23]:
        (w_fft_out_v && fft_out_valid) ? w_fft_out[46:24]: 23'd0;

    pilot_stream_fifo #(.WIDTH(46)) u_fft_buffer_32x512_out (
        .clk                                          (sclk),  // input wire clk
        .srst                                         (reset),  // input wire srst
        .din                                          ({w_fft_out[46:24], w_fft_out[22:0]}),
        .wr_en                                        (r_wr_fft_out_fifo),  // input wire wr_en
        .rd_en                                        (r_rd_fft_out_fifo),  // input wire rd_en
        .dout                                         (w_rd_fft_out),  // output wire [31:0] dout
        .full                                         (),  // output wire full
        .empty                                        ()
    );

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            pilot_neg_21 <= 'd0;
        end
        else if (enable == 1'b1) begin
            if (w_xk_index[5:0] == 'd43 && w_fft_out_v == 1'b1) begin
                pilot_neg_21 <= {w_fft_out[46:31], w_fft_out[22:7]};
            end
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            pilot_neg_7 <= 'd0;
        end
        else if (enable == 1'b1) begin
            if (w_xk_index[5:0] == 'd57 && w_fft_out_v == 1'b1) begin
                pilot_neg_7 <= {w_fft_out[46:31], w_fft_out[22:7]};
            end
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            pilot_pos_7 <= 'd0;
        end
        else if (enable == 1'b1) begin
            if (r_rd_fft_cnt == 'd6 && r_rd_fft_out_fifo == 1'b1) begin
                pilot_pos_7 <= {w_rd_fft_out[45:30], w_rd_fft_out[22:7]};
            end
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            pilot_pos_21 <= 'd0;
        end
        else if (enable == 1'b1) begin
            if (r_rd_fft_cnt == 'd20 && r_rd_fft_out_fifo == 1'b1) begin
                pilot_pos_21 <= {w_rd_fft_out[45:30], w_rd_fft_out[22:7]};
            end
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            pilot_valid <= 'd0;
        end
        else if (enable == 1'b1) begin
            if (r_rd_fft_cnt == 'd20 && r_rd_fft_out_fifo == 1'b1) begin
                pilot_valid <= 1'b1;
            end
            else begin
                pilot_valid <= 1'b0;
            end
        end
    end

endmodule
