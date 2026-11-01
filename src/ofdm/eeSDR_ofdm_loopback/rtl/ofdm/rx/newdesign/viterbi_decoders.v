// SIGNAL is an independent terminated codeword. DATA is one continuous
// codeword across all OFDM symbols; never inject flush bits between symbols.
module viterbi_decoders #(
    parameter                                       DATA_STREAM = 0
) (
    input   wire                                        clk                                         ,
    input   wire                                        rst                                         ,
    input   wire                                        bpsk_decoder_data_in_valid                  ,
    input   wire            [2:0]                       bpsk_decoder_data_in_chnl_0                 ,
    input   wire            [2:0]                       bpsk_decoder_data_in_chnl_1                 ,
    input   wire                                        qam64_decoder_data_in_valid                 ,
    input   wire            [2:0]                       qam64_decoder_data_in_chnl_0                ,
    input   wire            [2:0]                       qam64_decoder_data_in_chnl_1                ,
    output  wire                                        bpsk_decoder_data_out_valid                 ,
    output  wire                                        bpsk_decoder_data_out                       ,
    output  wire                                        qam64_decoder_data_out_valid                ,
    output  wire                                        qam64_decoder_data_out                      ,
    input   wire                                        data_field_param_gain_stb                   ,
    input   wire                                        data_field_param_gain_ok                    ,
    input   wire            [11:0]                      data_field_ofdm_nums                        ,
    input   wire            [5:0]                       data_field_rate                             ,
    input   wire            [1:0]                       data_field_modulation                       ,
    input   wire            [1:0]                       data_field_conv_code_rate                   ,
    input   wire            [1:0]                       data_erasures                               ,
    output  wire                                        data_ready
);
    generate if (!DATA_STREAM) begin : signal_decoder
            assign data_ready = 1'b1;
            viterbi_decoders_legacy u_impl (
                .clk                                          (clk),
                .rst                                          (rst),
                .bpsk_decoder_data_in_valid                   (bpsk_decoder_data_in_valid),
                .bpsk_decoder_data_in_chnl_0                  (bpsk_decoder_data_in_chnl_0),
                .bpsk_decoder_data_in_chnl_1                  (bpsk_decoder_data_in_chnl_1),
                .qam64_decoder_data_in_valid                  (qam64_decoder_data_in_valid),
                .qam64_decoder_data_in_chnl_0                 (qam64_decoder_data_in_chnl_0),
                .qam64_decoder_data_in_chnl_1                 (qam64_decoder_data_in_chnl_1),
                .bpsk_decoder_data_out_valid                  (bpsk_decoder_data_out_valid),
                .bpsk_decoder_data_out                        (bpsk_decoder_data_out),
                .qam64_decoder_data_out_valid                 (qam64_decoder_data_out_valid),
                .qam64_decoder_data_out                       (qam64_decoder_data_out),
                .data_field_param_gain_stb                    (data_field_param_gain_stb),
                .data_field_param_gain_ok                     (data_field_param_gain_ok),
                .data_field_ofdm_nums                         (data_field_ofdm_nums)
            );
        end else begin : data_decoder
            // The encoder starts each DATA codeword in state zero. The IP
            // starts with equal path metrics, so establish that known history
            // with unpunctured, high-confidence zeros before accepting DATA.
            // Match the configured traceback depth; discard only these outputs.
            localparam [6:0] LP_PREFIX_BITS = 7'd84;
            reg [6:0] r_prefix_input, r_prefix_output;
            wire w_prefix = r_prefix_input < LP_PREFIX_BITS;
            wire w_drop_prefix = r_prefix_output < LP_PREFIX_BITS;
            reg                 [15:0]                      r_input_count;
            reg                 [15:0]                      r_output_count;
            reg                 [15:0]                      r_bit_count;
            reg                 [15:0]                      r_input_next;
            reg                 [15:0]                      r_config_bit_count;
            reg                                             r_config_zero;
            reg                                             r_input_allowed;
            reg                                             r_config_pending;
            reg                 [3:0]                       r_config_count_lt;
            reg                 [3:0]                       r_config_count_eq;
            reg                                             r_config_count_zero;
            wire                [7:0]                       w_decoded;
            wire                                            w_decoded_valid;
            wire                                            w_ready;
            // One elastic AXIS stage separates frame-length comparisons from the
            // Viterbi IP's high-fanout clock enables. Count real pairs on enqueue;
            // a pending pair always precedes flush erasures, even under backpressure.
            reg                                             r_axis_valid;
            reg                 [15:0]                      r_axis_data;
            reg                 [7:0]                       r_axis_user;
            wire                                            w_advance = !r_axis_valid || w_ready;
            // Explicit shift/add products avoid synthesis sharing the rate cases
            // into a variable, unpipelined DSP multiply. Keep modulo-2^16 behavior.
            wire                [15:0]                      w_symbols = {4'd0, data_field_ofdm_nums};
            wire                [15:0]                      w_symbols_x3 = w_symbols + (w_symbols << 1);
            wire                [15:0]                      w_symbols_x9 = w_symbols + (w_symbols << 3);
            // 27*N = N + 2*N + 8*N + 16*N. Compress the four operands
            // without propagating carry, then use one final carry chain.
            // All intermediates retain the original modulo-2^16 contract.
            wire                [15:0]                      w_x27_sum0 = w_symbols ^ (w_symbols << 1) ^ (w_symbols << 3);
            wire                [15:0]                      w_x27_carry0 = ((w_symbols & (w_symbols << 1)) |
                (w_symbols & (w_symbols << 3)) | ((w_symbols << 1) & (w_symbols << 3))) << 1;
            wire                [15:0]                      w_x27_sum1 = w_x27_sum0 ^ w_x27_carry0 ^ (w_symbols << 4);
            wire                [15:0]                      w_x27_carry1 = ((w_x27_sum0 & w_x27_carry0) |
                (w_x27_sum0 & (w_symbols << 4)) | (w_x27_carry0 & (w_symbols << 4))) << 1;
            wire                [15:0]                      w_symbols_x27 = w_x27_sum1 + w_x27_carry1;
            wire                                            w_config_valid = data_field_param_gain_stb && data_field_param_gain_ok;
            // Register partial comparisons on a parameter write. The next
            // cycle's bypass only combines four registered nibble predicates,
            // not a wide counter comparator on the frontend's RAM enable.
            wire                                            w_config_allowed = r_config_count_zero ||
                r_config_count_lt[3] || (r_config_count_eq[3] && r_config_count_lt[2]) ||
                (&r_config_count_eq[3:2] && r_config_count_lt[1]) ||
                (&r_config_count_eq[3:1] && r_config_count_lt[0]);
            wire                                            w_input_allowed = r_config_pending ? w_config_allowed: r_input_allowed;
            wire                                            w_real_valid = (bpsk_decoder_data_in_valid || qam64_decoder_data_in_valid) &&
                w_input_allowed && !w_prefix;
            wire                                            w_accept_input = w_real_valid && w_advance;
            wire                [15:0]                      w_next_input_count = w_accept_input ? r_input_next: r_input_count;
            wire                                            w_flushing = r_bit_count != 0 && r_input_count == r_bit_count && r_output_count < r_bit_count;
            genvar g_count_nibble;
            for (g_count_nibble = 0; g_count_nibble < 4; g_count_nibble = g_count_nibble + 1) begin : g_count_compare
                always @(posedge clk) begin
                    if (rst) begin
                        r_config_count_lt[g_count_nibble] <= 1'b0;
                        r_config_count_eq[g_count_nibble] <= 1'b0;
                    end else if (w_config_valid) begin
                        r_config_count_lt[g_count_nibble] <= w_next_input_count[4*g_count_nibble +: 4] < r_config_bit_count[4*g_count_nibble +: 4];
                        r_config_count_eq[g_count_nibble] <= w_next_input_count[4*g_count_nibble +: 4] == r_config_bit_count[4*g_count_nibble +: 4];
                    end
                end
            end
            always @(*) begin
                case (data_field_rate)
                    6:       r_config_bit_count = w_symbols_x3 << 3;
                    9:       r_config_bit_count = w_symbols_x9 << 2;
                    12:      r_config_bit_count = w_symbols_x3 << 4;
                    18:      r_config_bit_count = w_symbols_x9 << 3;
                    24:      r_config_bit_count = w_symbols_x3 << 5;
                    36:      r_config_bit_count = w_symbols_x9 << 4;
                    48:      r_config_bit_count = w_symbols_x3 << 6;
                    54:      r_config_bit_count = w_symbols_x27 << 3;
                    default: r_config_bit_count = 16'd0;
                endcase
            end
            // Each legal N_DBPS is an odd factor times a power of two.
            // For the existing modulo-2^16 length, only those low symbol
            // bits can determine zero; do not put a reduction after x27.
            // In particular, 24/48 Mbps can wrap to zero at 2048/1024
            // symbols. Preserve those cases, as well as invalid-rate zero.
            always @(*) begin
                case (data_field_rate)
                    6, 9, 12, 18, 36, 54: r_config_zero = data_field_ofdm_nums == 12'd0;
                    24:                  r_config_zero = data_field_ofdm_nums[10:0] == 11'd0;
                    48:                  r_config_zero = data_field_ofdm_nums[9:0] == 10'd0;
                    default:             r_config_zero = 1'b1;
                endcase
            end
            always @(posedge clk) begin
                if (rst) begin
                    r_prefix_input <= 0;
                    r_prefix_output <= 0;
                    r_input_count <= 0;
                    r_output_count <= 0;
                    r_bit_count <= 0;
                    r_input_next <= 16'd1;
                    r_input_allowed <= 1'b1;
                    r_config_pending <= 1'b0;
                    r_config_count_zero <= 1'b1;
                    r_axis_valid <= 0;
                    r_axis_data <= 16'h0303;
                    r_axis_user <= 8'd3;
                end else begin
                    r_config_pending <= w_config_valid;
                    if (w_advance) begin
                        if (w_prefix) r_prefix_input <= r_prefix_input + 1'b1;
                        r_axis_valid <= w_prefix || w_real_valid || w_flushing;
                        r_axis_data <= w_prefix ? 16'h0000 : w_real_valid ?
                            (qam64_decoder_data_in_valid ?
                                {5'd0, qam64_decoder_data_in_chnl_1, 5'd0, qam64_decoder_data_in_chnl_0}:
                                {5'd0, bpsk_decoder_data_in_chnl_1, 5'd0, bpsk_decoder_data_in_chnl_0}): 16'h0303;
                        r_axis_user <= w_prefix ? 8'd0 : w_real_valid ? {6'd0, data_erasures}: 8'd3;
                    end
                    if (w_config_valid) begin
                        r_bit_count <= r_config_bit_count;
                        r_config_count_zero <= r_config_zero;
                    end
                    if (r_config_pending) begin
                        // With a nonzero length an accepted count cannot wrap:
                        // it is strictly below the registered length. Separate
                        // the terminal equality from the credit comparison.
                        r_input_allowed <= r_bit_count == 0 ||
                            (w_config_allowed && (!w_accept_input || r_input_next != r_bit_count));
                    end else if (w_accept_input) begin
                        // Look ahead on the final accepted pair: ready closes
                        // on exactly the old edge, without a wide return path.
                        r_input_allowed <= r_bit_count == 0 ||
                            r_input_next != r_bit_count;
                    end
                    if (w_accept_input) begin
                        r_input_count <= r_input_next;
                        r_input_next <= r_input_next + 1'b1;
                    end
                    if (w_decoded_valid && w_drop_prefix)
                        r_prefix_output <= r_prefix_output + 1'b1;
                    if (w_decoded_valid && !w_drop_prefix && r_output_count < r_bit_count)
                        r_output_count <= r_output_count + 1'b1;
                end
            end
            // One-bit registered credit replaces the input_count comparator in
            // the cross-module ready path. AXIS capacity remains combinational.
            assign data_ready = w_advance && w_input_allowed && !w_prefix;
            viterbi_0 u_core (
                .aclk                                         (clk),
                .aresetn                                      (~rst),
                .s_axis_data_tdata                            (r_axis_data),
                .s_axis_data_tuser                            (r_axis_user),
                .s_axis_data_tvalid                           (r_axis_valid),
                .s_axis_data_tready                           (w_ready),
                .m_axis_data_tdata                            (w_decoded),
                .m_axis_data_tvalid                           (w_decoded_valid)
            );
            assign bpsk_decoder_data_out = w_decoded[0];
            assign bpsk_decoder_data_out_valid = w_decoded_valid && !w_drop_prefix && r_output_count < r_bit_count;
            assign qam64_decoder_data_out = 1'b0;
            assign qam64_decoder_data_out_valid = 1'b0;
        end
    endgenerate
endmodule

module viterbi_decoders_legacy(
//这两个输入信号没用到
//
    input   wire                                        clk                                         ,
    input   wire                                        rst                                         ,
    input   wire                                        bpsk_decoder_data_in_valid                  ,
    input   wire            [2:0]                       bpsk_decoder_data_in_chnl_0                 ,
    input   wire            [2:0]                       bpsk_decoder_data_in_chnl_1                 ,
    input   wire                                        qam64_decoder_data_in_valid                 ,
    input   wire            [2:0]                       qam64_decoder_data_in_chnl_0                ,
    input   wire            [2:0]                       qam64_decoder_data_in_chnl_1                ,
    output  reg                                         bpsk_decoder_data_out_valid                 ,
    output  reg                                         bpsk_decoder_data_out                       ,
    output  reg                                         qam64_decoder_data_out_valid                ,
    output  reg                                         qam64_decoder_data_out                      ,
    input   wire                                        data_field_param_gain_stb                   ,
    input   wire                                        data_field_param_gain_ok                    ,
    input   wire            [11:0]                      data_field_ofdm_nums
);

    reg                                             r_bpsk_decoder_data_in_valid_reg;
    reg                 [2:0]                       r_bpsk_decoder_data_in_chnl_0_reg;
    reg                 [2:0]                       r_bpsk_decoder_data_in_chnl_1_reg;

    wire                                            w_bpsk_viterbi_data_in_start;
    wire                                            w_bpsk_viterbi_data_in_end;

    reg                                             r_bpsk_decoder_processing_flag;

    reg                                             r_viterbi_data_in_valid;
    reg                 [15:0]                      r_viterbi_data_in;

    reg                                             r_bpsk_viterbi_data_pad_valid;
    reg                 [7:0]                       r_bpsk_decoder_data_in_valid_cnt;

    wire                                            w_viterbi_dout_valid;
    wire                [7:0]                       w_viterbi_dout;

    wire                                            w_bpsk_viterbi_data_out_end;
    reg                                             r_bpsk_viterbi_data_out_end_dly;

    reg                                             r_viterbi_arstn;

    reg                 [15:0]                      r_bpsk_viterbi_data_out_cnt;

    reg                                             r_bpsk_decoder_data_in_valid_reg_dly;

    //-------------------64qam-------------------------------
    reg                                             r_qam64_decoder_data_in_valid_reg;
    reg                 [2:0]                       r_qam64_decoder_data_in_chnl_0_reg;
    reg                 [2:0]                       r_qam64_decoder_data_in_chnl_1_reg;
    reg                 [1:0]                       r_user_data_gen_cnt;
    reg                 [7:0]                       r_user_data;

    wire                                            w_qam64_viterbi_in_start;
    //wire          qam64_viterbi_in_end;

    // Keep the multiplier IP's three-cycle, low-eight-bit input contract.
    // Compute the last index in that pipeline, rather than subtracting after it.
    reg                 [11:0]                      r_legacy_symbols_x9;
    reg                 [12:0]                      r_legacy_symbols_x27;
    reg                 [15:0]                      r_ofdm_last_bit_index;
    reg                 [7:0]                       r_ofdm_num_cnt;
    reg                                             r_qam64_viterbi_pad_start;
    reg                                             r_qam64_viterbi_pad_valid;
    reg                 [15:0]                      r_qam64_decoder_dout_cnt;
    reg                                             r_qam64_viterbi_pad_valid_dly;
    wire                                            w_qam64_viterbi_pad_valid_end;
    reg                                             r_qam64_viterbi_pad_valid_end_dly;
    assign w_bpsk_viterbi_data_out_end = (~r_bpsk_viterbi_data_pad_valid) & bpsk_decoder_data_out_valid;

    always @(posedge clk) begin
        r_bpsk_viterbi_data_out_end_dly <= w_bpsk_viterbi_data_out_end;
    end

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            r_viterbi_arstn <= 1'b0;
        end
        else if (rst == 1'b1) begin
            r_viterbi_arstn <= 1'b0;
        end
        else if (w_bpsk_viterbi_data_out_end | r_bpsk_viterbi_data_out_end_dly) begin
            r_viterbi_arstn <= 1'b0;
        end
        else if (w_qam64_viterbi_pad_valid_end | r_qam64_viterbi_pad_valid_end_dly) begin
            r_viterbi_arstn <= 1'b0;
        end

        else begin
            r_viterbi_arstn <= 1'b1;
        end
    end

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            r_bpsk_decoder_data_in_valid_cnt <= 'd0;
        end
        else if (w_bpsk_viterbi_data_out_end == 1'b1) begin
            r_bpsk_decoder_data_in_valid_cnt <= 'd0;
        end
        else if (bpsk_decoder_data_in_valid == 1'b1) begin
            r_bpsk_decoder_data_in_valid_cnt <= r_bpsk_decoder_data_in_valid_cnt + 1'b1;
        end
    end

    always @(posedge clk) begin
        r_bpsk_decoder_data_in_valid_reg <= bpsk_decoder_data_in_valid;
        r_bpsk_decoder_data_in_chnl_0_reg <= bpsk_decoder_data_in_chnl_0;
        r_bpsk_decoder_data_in_chnl_1_reg <= bpsk_decoder_data_in_chnl_1;
    end

    assign w_bpsk_viterbi_data_in_start = bpsk_decoder_data_in_valid & (~r_bpsk_decoder_data_in_valid_reg);
    assign w_bpsk_viterbi_data_in_end = (~r_bpsk_decoder_data_in_valid_reg) & r_bpsk_decoder_data_in_valid_reg_dly;

    always @(posedge clk) begin
        r_bpsk_decoder_data_in_valid_reg_dly <= r_bpsk_decoder_data_in_valid_reg;
    end

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            r_bpsk_decoder_processing_flag <= 1'b0;
        end
        else if (w_bpsk_viterbi_data_out_end == 1'b1) begin
            r_bpsk_decoder_processing_flag <= 1'b0;
        end
        else if (w_bpsk_viterbi_data_in_start == 1'b1) begin
            r_bpsk_decoder_processing_flag <= 1'b1;
        end
    end

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            r_viterbi_data_in_valid <= 1'b0;
        end
        else if (r_bpsk_decoder_processing_flag == 1'b1) begin
            r_viterbi_data_in_valid <= r_bpsk_decoder_data_in_valid_reg;
        end
        else if (r_qam64_decoder_data_in_valid_reg == 1'b1) begin
            r_viterbi_data_in_valid <= 1'b1;
        end
        else begin
            r_viterbi_data_in_valid <= 1'b0;
        end
    end

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            r_viterbi_data_in <= {5'b0, 3'b011, 5'b0, 3'b011};
        end
        else if (r_bpsk_decoder_processing_flag == 1'b1) begin
            r_viterbi_data_in <= {5'b0, r_bpsk_decoder_data_in_chnl_1_reg, 5'b0, r_bpsk_decoder_data_in_chnl_0_reg};
        end
        else if (r_qam64_decoder_data_in_valid_reg == 1'b1) begin
            r_viterbi_data_in <= {5'b0, r_qam64_decoder_data_in_chnl_1_reg, 5'b0, r_qam64_decoder_data_in_chnl_0_reg};
        end
        else begin
            r_viterbi_data_in <= {5'b0, 3'b011, 5'b0, 3'b011};
        end
    end

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            r_bpsk_viterbi_data_pad_valid <= 1'b0;
        end
        else if (r_bpsk_viterbi_data_out_cnt == r_bpsk_decoder_data_in_valid_cnt - 1'b1) begin
            r_bpsk_viterbi_data_pad_valid <= 1'b0;
        end
        else if (w_bpsk_viterbi_data_in_end == 1'b1) begin
            r_bpsk_viterbi_data_pad_valid <= 1'b1;
        end
    end

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            r_bpsk_viterbi_data_out_cnt <= 'd0;
        end
        else if (r_bpsk_viterbi_data_out_cnt == r_bpsk_decoder_data_in_valid_cnt - 1'b1) begin
            r_bpsk_viterbi_data_out_cnt <= 'd0;
        end
        else if (r_bpsk_decoder_processing_flag == 1'b1 && w_viterbi_dout_valid == 1'b1) begin
            r_bpsk_viterbi_data_out_cnt <= r_bpsk_viterbi_data_out_cnt + 1'b1;
        end
    end

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            bpsk_decoder_data_out_valid <= 1'b0;
            bpsk_decoder_data_out <= 1'b0;
        end
        else if (r_bpsk_decoder_processing_flag == 1'b1) begin
            bpsk_decoder_data_out_valid <= w_viterbi_dout_valid;
            bpsk_decoder_data_out <= w_viterbi_dout;
        end
        else begin
            bpsk_decoder_data_out_valid <= 1'b0;
            bpsk_decoder_data_out <= 1'b0;
        end
    end

    viterbi_0 u_viterbi_0 (
        .aclk                                         (clk),  // input wire aclk
        .aresetn                                      (r_viterbi_arstn),  // input wire aresetn
        .s_axis_data_tdata                            (r_viterbi_data_in),  // input wire [15:0] s_axis_data_tdata
        .s_axis_data_tuser                            (r_user_data),  // input wire [7:0] s_axis_data_tuser
        .s_axis_data_tvalid                           (r_viterbi_data_in_valid | r_bpsk_viterbi_data_pad_valid | r_qam64_viterbi_pad_valid),  // input wire s_axis_data_tvalid
        .s_axis_data_tready                           (viterbi_tready),  // output wire s_axis_data_tready
        .m_axis_data_tdata                            (w_viterbi_dout),  // output wire [7:0] m_axis_data_tdata
        .m_axis_data_tvalid                           (w_viterbi_dout_valid)  // output wire m_axis_data_tvalid
    );

    always @(posedge clk) begin
        r_legacy_symbols_x9 <= {4'd0, data_field_ofdm_nums[7:0]} +
            {1'b0, data_field_ofdm_nums[7:0], 3'b000};
        r_legacy_symbols_x27 <= {1'b0, r_legacy_symbols_x9} +
            {r_legacy_symbols_x9, 1'b0};
        // (27*n)*8 - 1, including the original 16'hffff result for n=0.
        r_ofdm_last_bit_index <= {r_legacy_symbols_x27 - 13'd1, 3'b111};
    end

    always @(posedge clk) begin
        r_qam64_decoder_data_in_valid_reg <= qam64_decoder_data_in_valid;
        //再延后一拍送入到viterbi ip核
        r_qam64_decoder_data_in_chnl_0_reg <= qam64_decoder_data_in_chnl_0;
        r_qam64_decoder_data_in_chnl_1_reg <= qam64_decoder_data_in_chnl_1;
    end

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            r_user_data_gen_cnt <= 'd0;
        end
        else if (r_user_data_gen_cnt == 'd2) begin
            r_user_data_gen_cnt <= 1'b0;
        end
        else if (r_qam64_decoder_data_in_valid_reg == 1'b1) begin
            r_user_data_gen_cnt <= r_user_data_gen_cnt + 1'b1;
        end
    end

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            r_user_data <= 8'b11;
        end
        else if (r_qam64_decoder_data_in_valid_reg == 1'b1) begin
            if (r_user_data_gen_cnt == 'd0) begin
                r_user_data <= 8'b00;
            end
            else if (r_user_data_gen_cnt == 'd1) begin
                r_user_data <= 8'b10;
            end
            else if (r_user_data_gen_cnt == 'd2) begin
                r_user_data <= 8'b01;
            end
        end
        else if (r_bpsk_decoder_data_in_valid_reg == 1'b1) begin
            r_user_data <= 8'b00;
        end
        else begin
            r_user_data <= 8'b11;
        end
    end

    assign w_qam64_viterbi_in_start = r_qam64_decoder_data_in_valid_reg & (~r_viterbi_data_in_valid);
    //assign qam64_viterbi_in_end = (~qam64_decoder_data_in_valid_reg) & viterbi_data_in_valid;

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            r_ofdm_num_cnt <= 'd0;
        end
        else if (r_qam64_viterbi_pad_start == 1'b1) begin
            r_ofdm_num_cnt <= 'd0;
        end
        else if (w_qam64_viterbi_in_start == 1'b1) begin
            r_ofdm_num_cnt <= r_ofdm_num_cnt + 1'b1;
        end
    end

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            r_qam64_viterbi_pad_start <= 1'b0;
        end
        else if (r_ofdm_num_cnt == data_field_ofdm_nums) begin
            if ( (~w_viterbi_dout_valid) & qam64_decoder_data_out_valid) begin
                r_qam64_viterbi_pad_start <= 1'b1;
            end
            else begin
                r_qam64_viterbi_pad_start <= 1'b0;
            end
        end
        else begin
            r_qam64_viterbi_pad_start <= 1'b0;
        end
    end

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            r_qam64_viterbi_pad_valid <= 1'b0;
        end
        else if (r_qam64_decoder_dout_cnt == r_ofdm_last_bit_index) begin
            r_qam64_viterbi_pad_valid <= 1'b0;
        end
        else if (r_qam64_viterbi_pad_start == 1'b1) begin
            r_qam64_viterbi_pad_valid <= 1'b1;
        end
    end

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            r_qam64_decoder_dout_cnt <= 'd0;
        end
        else if (r_qam64_decoder_dout_cnt == r_ofdm_last_bit_index) begin
            r_qam64_decoder_dout_cnt <= 'd0;
        end
        else if (r_bpsk_decoder_processing_flag == 1'b0) begin
            if (w_viterbi_dout_valid == 1'b1 || r_qam64_viterbi_pad_valid == 1'b1) begin
                r_qam64_decoder_dout_cnt <= r_qam64_decoder_dout_cnt + 1'b1;
            end
        end
    end

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            qam64_decoder_data_out_valid <= 1'b0;
        end
        else if (r_bpsk_decoder_processing_flag == 1'b0) begin
            if (w_viterbi_dout_valid == 1'b1) begin
                qam64_decoder_data_out_valid <= 1'b1;
            end
            else begin
                qam64_decoder_data_out_valid <= 1'b0;
            end
        end
        else begin
            qam64_decoder_data_out_valid <= 1'b0;
        end
    end

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            qam64_decoder_data_out <= 1'b0;
        end
        else if (r_bpsk_decoder_processing_flag == 1'b0) begin
            if (w_viterbi_dout_valid == 1'b1) begin
                qam64_decoder_data_out <= w_viterbi_dout[0];
            end
            else begin
                qam64_decoder_data_out <= 1'b0;
            end
        end
        else begin
            qam64_decoder_data_out <= 1'b0;
        end
    end

    always @(posedge clk) begin
        r_qam64_viterbi_pad_valid_dly <= r_qam64_viterbi_pad_valid;
    end

    assign w_qam64_viterbi_pad_valid_end = (~r_qam64_viterbi_pad_valid) & r_qam64_viterbi_pad_valid_dly;

    always @(posedge clk) begin
        r_qam64_viterbi_pad_valid_end_dly <= w_qam64_viterbi_pad_valid_end;
    end

endmodule
