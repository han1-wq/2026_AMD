module rx_estimate_channel_info #(parameter CHANNEL_SMOOTH = 1)(
// Clock
    input   wire                                        sclk                                        ,
    input   wire                                        reset                                       ,
    input   wire                                        enable                                      ,
    input   wire            [22:0]                      sample_in_i                                 ,
    input   wire            [22:0]                      sample_in_q                                 ,
    input   wire                                        sample_in_valid                             ,
    output  reg             [24:0]                      h_csi_out_i                                 ,
    output  reg             [24:0]                      h_csi_out_q                                 ,
    output  reg                                         h_csi_out_valid                             ,
    output  wire            [50:0]                      channel_data_i                              ,
    output  wire            [50:0]                      channel_data_q                              ,
    output  wire                                        channel_data_valid
);

    parameter                                       LT = 52'b0011001010000001100101000001100101011111001101010000;

    wire                                            w_wr_lt_buf_en;
    reg                                             r_lt2_flag;
    reg                                             r_sig_data_flag;
    wire                [49:0]                      w_wr_lt_buf_data;
    reg                 [6:0]                       r_wr_lt_buf_addr;
    wire                                            w_rd_lt_buf_en;
    reg                 [6:0]                       r_rd_lt_buf_addr;
    wire        signed  [24:0]                      w_rd_ram_data_i;
    wire        signed  [24:0]                      w_rd_ram_data_q;
    reg         signed  [24:0]                      r_sample_in_i_dly1;
    reg         signed  [24:0]                      r_sample_in_q_dly1;
    reg                                             r_rd_lt_buf_en_dly1;
    reg                                             r_rd_lt_buf_en_dly2;
    reg                                             r_rd_lt_buf_en_dly3;
    // Both operands are even (2*FFT), so these shifts lose no bits.
    reg         signed  [24:0]                      r_tmp_data_i;
    reg         signed  [24:0]                      r_tmp_data_q;
    reg                 [51:0]                      r_lt_sign;
    reg         signed  [24:0]                      r_lt_avg_x_lts_i;
    reg         signed  [24:0]                      r_lt_avg_x_lts_q;

    wire                                            w_complex_mult_in_valid;
    wire                [49:0]                      w_complex_mult_a;
    wire                [49:0]                      w_complex_mult_b;

    assign w_wr_lt_buf_en = enable ? ( (sample_in_valid & (~r_lt2_flag) & (~r_sig_data_flag)) | (r_lt2_flag & r_rd_lt_buf_en_dly3)): 1'b0;
    assign w_wr_lt_buf_data = r_lt2_flag ? {r_lt_avg_x_lts_q, r_lt_avg_x_lts_i}: {sample_in_q[22], sample_in_q, 1'b0, sample_in_i[22], sample_in_i, 1'b0};

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_wr_lt_buf_addr <= 'd0;
        end
        else if (enable == 1'b1) begin
            if (w_wr_lt_buf_en == 1'b1 && r_wr_lt_buf_addr != 'd51) begin
                r_wr_lt_buf_addr <= r_wr_lt_buf_addr + 1'b1;
            end
            else if (w_wr_lt_buf_en == 1'b1 && r_wr_lt_buf_addr == 'd51) begin
                r_wr_lt_buf_addr <= 'd0;
            end
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_lt2_flag <= 1'b0;
        end
        else if (enable == 1'b1) begin
            if (r_wr_lt_buf_addr == 'd51 && sample_in_valid == 1'b1 && r_lt2_flag == 1'b0 && r_sig_data_flag == 1'b0) begin
                r_lt2_flag <= 1'b1;
            end
            else if (r_wr_lt_buf_addr == 'd51 && w_wr_lt_buf_en == 1'b1 && r_lt2_flag == 1'b1) begin
                r_lt2_flag <= 1'b0;
            end
        end
    end

    assign w_rd_lt_buf_en = (r_lt2_flag | r_sig_data_flag) ? sample_in_valid: 1'b0;

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_rd_lt_buf_addr <= 'd0;
        end
        else if (enable == 1'b1) begin
            if (w_rd_lt_buf_en == 1'b1 && r_rd_lt_buf_addr != 'd51) begin
                r_rd_lt_buf_addr <= r_rd_lt_buf_addr + 1'b1;
            end
            else if (w_rd_lt_buf_en == 1'b1 && r_rd_lt_buf_addr == 'd51) begin
                r_rd_lt_buf_addr <= 'd0;
            end
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_sample_in_i_dly1 <= 'd0;
            r_sample_in_q_dly1 <= 'd0;
        end
        else begin
            r_sample_in_i_dly1 <= {sample_in_i[22], sample_in_i, 1'b0};
            r_sample_in_q_dly1 <= {sample_in_q[22], sample_in_q, 1'b0};
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_tmp_data_i <= 'd0;
            r_tmp_data_q <= 'd0;
        end
        else if (enable == 1'b1) begin
            r_tmp_data_i <= (w_rd_ram_data_i >>> 1) + (r_sample_in_i_dly1 >>> 1);
            r_tmp_data_q <= (w_rd_ram_data_q >>> 1) + (r_sample_in_q_dly1 >>> 1);
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_rd_lt_buf_en_dly1 <= 'd0;
            r_rd_lt_buf_en_dly2 <= 'd0;
            r_rd_lt_buf_en_dly3 <= 'd0;
        end
        else if (enable == 1'b1) begin
            r_rd_lt_buf_en_dly1 <= w_rd_lt_buf_en;
            r_rd_lt_buf_en_dly2 <= r_rd_lt_buf_en_dly1;
            r_rd_lt_buf_en_dly3 <= r_rd_lt_buf_en_dly2;
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_lt_sign <= LT;
        end
        else if (enable == 1'b1 && r_rd_lt_buf_addr == 'd0 && w_rd_lt_buf_en == 1'b1 && r_lt2_flag == 1'b1) begin
            r_lt_sign <= LT;
        end
        else if (enable == 1'b1 && r_rd_lt_buf_en_dly2 == 1'b1 && r_lt2_flag == 1'b1) begin
            r_lt_sign <= {r_lt_sign[50:0], r_lt_sign[51]};
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_lt_avg_x_lts_i <= 'd0;
            r_lt_avg_x_lts_q <= 'd0;
        end
        else if (enable == 1'b1 && r_rd_lt_buf_en_dly2 == 1'b1 && r_lt2_flag == 1'b1) begin
            r_lt_avg_x_lts_i <= (r_lt_sign[51]) ? (~r_tmp_data_i) + 1: r_tmp_data_i;
            r_lt_avg_x_lts_q <= (r_lt_sign[51]) ? (~r_tmp_data_q) + 1: r_tmp_data_q;
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_sig_data_flag <= 1'b0;
        end
        else if (enable == 1'b1) begin
            if (r_wr_lt_buf_addr == 'd51 && w_wr_lt_buf_en == 1'b1 && r_lt2_flag == 1'b1) begin
                r_sig_data_flag <= 1'b1;
            end
        end
    end

    // One-cycle synchronous read, matching the former dual-port LTF BRAM.
    // Five-bin binomial smoothing reduces training quantization noise.
    // Keep the two sides of DC separate and replicate band-edge bins.
    // Disable CHANNEL_SMOOTH for channels with sharp frequency selectivity.
    (* ram_style = "distributed" *) reg [49:0] r_lt_memory[0:51];
    reg [49:0] r_lt_read_data;
    // Addresses are only 0..51. Avoid the old 32-bit integer arithmetic here:
    // its generic add/compare tree was the routed 80 MHz critical path.
    function [5:0] f_neighbor_m2;
        input [6:0] address;
        begin
            if (address < 26) f_neighbor_m2 = address < 2 ? 0 : address - 2;
            else f_neighbor_m2 = address < 28 ? 26 : address - 2;
        end
    endfunction
    function [5:0] f_neighbor_m1;
        input [6:0] address;
        begin
            if (address < 26) f_neighbor_m1 = address == 0 ? 0 : address - 1;
            else f_neighbor_m1 = address == 26 ? 26 : address - 1;
        end
    endfunction
    function [5:0] f_neighbor_p1;
        input [6:0] address;
        begin
            if (address < 26) f_neighbor_p1 = address == 25 ? 25 : address + 1;
            else f_neighbor_p1 = address == 51 ? 51 : address + 1;
        end
    endfunction
    function [5:0] f_neighbor_p2;
        input [6:0] address;
        begin
            if (address < 26) f_neighbor_p2 = address >= 24 ? 25 : address + 2;
            else f_neighbor_p2 = address >= 50 ? 51 : address + 2;
        end
    endfunction
    wire [49:0] w_hm2 = r_lt_memory[f_neighbor_m2(r_rd_lt_buf_addr)];
    wire [49:0] w_hm1 = r_lt_memory[f_neighbor_m1(r_rd_lt_buf_addr)];
    wire [49:0] w_h0 = r_lt_memory[r_rd_lt_buf_addr];
    wire [49:0] w_hp1 = r_lt_memory[f_neighbor_p1(r_rd_lt_buf_addr)];
    wire [49:0] w_hp2 = r_lt_memory[f_neighbor_p2(r_rd_lt_buf_addr)];
    function [24:0] f_smooth;
        input signed [24:0] hm2, hm1, h0, hp1, hp2;
        reg signed [28:0] sum;
        begin
            sum = {{4{hm2[24]}},hm2} +
                  ($signed({{4{hm1[24]}},hm1}) <<< 2) +
                  ($signed({{4{h0[24]}},h0}) <<< 2) +
                  ($signed({{4{h0[24]}},h0}) <<< 1) +
                  ($signed({{4{hp1[24]}},hp1}) <<< 2) +
                  {{4{hp2[24]}},hp2};
            f_smooth = sum >>> 4;
        end
    endfunction
    always @(posedge sclk) begin
        if (w_wr_lt_buf_en) r_lt_memory[r_wr_lt_buf_addr] <= w_wr_lt_buf_data;
        if (CHANNEL_SMOOTH && r_sig_data_flag)
            r_lt_read_data <= {f_smooth(w_hm2[49:25], w_hm1[49:25], w_h0[49:25], w_hp1[49:25], w_hp2[49:25]),
                               f_smooth(w_hm2[24:0], w_hm1[24:0], w_h0[24:0], w_hp1[24:0], w_hp2[24:0])};
        else r_lt_read_data <= w_h0;
    end
    assign {w_rd_ram_data_q, w_rd_ram_data_i} = r_lt_read_data;

    assign w_complex_mult_in_valid = r_sig_data_flag & r_rd_lt_buf_en_dly1;
    assign w_complex_mult_a = {r_sample_in_q_dly1, r_sample_in_i_dly1};
    assign w_complex_mult_b[49:25] = (~w_rd_ram_data_q) + 1;
    assign w_complex_mult_b[24:0] = w_rd_ram_data_i;

    // Cut the BRAM/conjugation-to-DSP path. Both operands and valid move together;
    // the CSI sideband below receives the same extra cycle.
    reg                 [49:0]                      r_complex_mult_a_pipe;
    reg                 [49:0]                      r_complex_mult_b_pipe;
    reg                                             r_complex_mult_valid_pipe;
    always @(posedge sclk) begin
        r_complex_mult_a_pipe <= w_complex_mult_a;
        r_complex_mult_b_pipe <= w_complex_mult_b;
        r_complex_mult_valid_pipe <= w_complex_mult_in_valid;
    end

    // 25x25 products and a guard bit preserve the complete complex sum.
    // Match the previous multiplier's three-cycle latency and /2 scale.
    reg signed [49:0] r_ii, r_qq, r_iq, r_qi;
    reg signed [50:0] r_sum_i, r_sum_q;
    reg signed [50:0] r_product_i, r_product_q;
    reg [2:0] r_product_valid;
    always @(posedge sclk) begin
        if (reset) r_product_valid <= 0;
        else r_product_valid <= {r_product_valid[1:0], r_complex_mult_valid_pipe};
        r_ii <= $signed(r_complex_mult_a_pipe[24:0]) * $signed(r_complex_mult_b_pipe[24:0]);
        r_qq <= $signed(r_complex_mult_a_pipe[49:25]) * $signed(r_complex_mult_b_pipe[49:25]);
        r_iq <= $signed(r_complex_mult_a_pipe[24:0]) * $signed(r_complex_mult_b_pipe[49:25]);
        r_qi <= $signed(r_complex_mult_a_pipe[49:25]) * $signed(r_complex_mult_b_pipe[24:0]);
        r_sum_i <= {r_ii[49], r_ii} - {r_qq[49], r_qq};
        r_sum_q <= {r_iq[49], r_iq} + {r_qi[49], r_qi};
        r_product_i <= r_sum_i >>> 1;
        r_product_q <= r_sum_q >>> 1;
    end
    assign channel_data_i = r_product_i;
    assign channel_data_q = r_product_q;
    assign channel_data_valid = r_product_valid[2];

    reg                 [24:0]                      r_h_csi_out_valid_gen;
    reg                 [24:0]                      r_h_csi_out_valid_gen_pre;
    reg                 [24:0]                      r_h_csi_out_q_gen;
    reg                 [24:0]                      r_h_csi_out_q_gen_pre;
    reg                 [24:0]                      r_h_csi_out_i_gen;
    reg                 [24:0]                      r_h_csi_out_i_gen_pre;
    reg                                             r_h_csi_valid_pipe;
    reg                 [24:0]                      r_h_csi_i_pipe;
    reg                 [24:0]                      r_h_csi_q_pipe;

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_h_csi_out_valid_gen_pre <= 1'b0;
        end
        else if (r_sig_data_flag & r_rd_lt_buf_en_dly1) begin
            r_h_csi_out_valid_gen_pre <= 1'b1;
        end
        else begin
            r_h_csi_out_valid_gen_pre <= 1'b0;
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_h_csi_out_q_gen_pre <= 'd0;
        end
        else begin
            r_h_csi_out_q_gen_pre <= w_rd_ram_data_q;
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_h_csi_out_i_gen_pre <= 'd0;
        end
        else begin
            r_h_csi_out_i_gen_pre <= w_rd_ram_data_i;
        end
    end

    always @(posedge sclk) begin
        r_h_csi_valid_pipe <= r_h_csi_out_valid_gen;
        r_h_csi_i_pipe <= r_h_csi_out_i_gen;
        r_h_csi_q_pipe <= r_h_csi_out_q_gen;
        h_csi_out_valid <= r_h_csi_valid_pipe;
        r_h_csi_out_valid_gen <= r_h_csi_out_valid_gen_pre;
        h_csi_out_q <= r_h_csi_q_pipe;
        r_h_csi_out_q_gen <= r_h_csi_out_q_gen_pre;
        h_csi_out_i <= r_h_csi_i_pipe;
        r_h_csi_out_i_gen <= r_h_csi_out_i_gen_pre;
    end

endmodule
