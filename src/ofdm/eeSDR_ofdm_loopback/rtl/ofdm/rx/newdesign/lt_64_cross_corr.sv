// -----------------------------------------------------------------------------
// Copyright (c) 2014-2022 All rights reserved
// -----------------------------------------------------------------------------
// Author : You Kaiyuan v3eduyky@126.com
// wechat ： 15921999232 (Tel)
// File   : lt_64_cross_corr.sv
// Create : 2022-04-28 14:32:08
// Revise : 2022-05-01 11:42:20
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
module lt_64_cross_corr(
    input   wire                                        sclk                                        ,
    input   wire                                        reset                                       ,
    input   wire                                        enable                                      ,
    input   wire            [15:0]                      sample_in_i                                 ,
    input   wire            [15:0]                      sample_in_q                                 ,
    input   wire                                        sample_in_valid                             ,
    output  reg             [31:0]                      cross_corr                                  ,
    output  reg                                         cross_corr_valid
);

    parameter           [15:0]                      LT_I[0:63] = {
    65216, 25, 188, 65348, 65530, 154, 65275, 65286,
    65464, 65420, 65412, 142, 168, 65267, 65419, 76,
    128, 244, 65490, 120, 50, 65256, 2, 109,
    200, 65458, 65300, 123, 43, 198, 81, 65526,
    320, 65526, 81, 198, 43, 123, 65300, 65458,
    200, 109, 2, 65256, 50, 120, 65490, 244,
    128, 76, 65419, 65267, 168, 142, 65412, 65420,
    65464, 65286, 65275, 154, 65530, 65348, 188, 25};
    parameter           [15:0]                      LT_Q[0:63] = {
    0, 65336, 65319, 65300, 65426, 152, 42, 34,
    309, 45, 65370, 65507, 65347, 65402, 65456, 65335,
    128, 8, 65207, 31, 120, 97, 236, 65528,
    53, 217, 113, 180, 65479, 65366, 228, 246,
    0, 65290, 65308, 170, 57, 65356, 65423, 65319,
    65483, 8, 65300, 65439, 65416, 65505, 329, 65528,
    65408, 201, 80, 134, 189, 29, 166, 65491,
    65227, 65502, 65494, 65384, 110, 236, 217, 200};

    reg                 [63:0]                      r_sg_i;
    reg                 [63:0]                      r_sg_q;
    //1=-1;0=+1

    reg                 [63:0]                      r_sg_i_r;
    reg                 [63:0]                      r_sg_q_r;

    // Bound every partial sum using the configured coefficients. Keep the legacy
    // modulo-16-bit result for arbitrary parameter overrides, but avoid carrying
    // redundant sign bits through the early levels (10..15 bits by default).
    function automatic integer sum_width(input integer level);
        integer k, ai, aq, bound, largest, bits;
        begin
            largest = 0;
            for (k = 0; k < 64; k = k + 1) begin
                ai = $signed(LT_I[k]);
                aq = $signed(LT_Q[k]);
                if (ai < 0) ai = - ai;
                if (aq < 0) aq = - aq;
                bound = ai + aq;
                if (bound > largest) largest = bound;
            end
            bound = largest << level;
            bits = 1;
            while (bound > 0) begin
                bits = bits + 1;
                bound = bound >> 1;
            end
            sum_width = (bits > 16) ? 16: bits;
        end
    endfunction

    reg         signed  [sum_width(0) - 1:0]        r_s_i[0:63];
    reg         signed  [sum_width(0) - 1:0]        r_s_q[0:63];

    reg         signed  [sum_width(0) - 1:0]        r_s_i_r[0:63];
    reg         signed  [sum_width(0) - 1:0]        r_s_q_r[0:63];

    reg         signed  [sum_width(1) - 1:0]        r_s1_i[0:31];
    reg         signed  [sum_width(1) - 1:0]        r_s1_q[0:31];

    reg         signed  [sum_width(1) - 1:0]        r_s1_i_r[0:31];
    reg         signed  [sum_width(1) - 1:0]        r_s1_q_r[0:31];

    reg         signed  [sum_width(2) - 1:0]        r_s2_i[0:15];
    reg         signed  [sum_width(2) - 1:0]        r_s2_q[0:15];

    reg         signed  [sum_width(2) - 1:0]        r_s2_i_r[0:15];
    reg         signed  [sum_width(2) - 1:0]        r_s2_q_r[0:15];

    reg         signed  [sum_width(3) - 1:0]        r_s3_i[0:7];
    reg         signed  [sum_width(3) - 1:0]        r_s3_q[0:7];

    reg         signed  [sum_width(3) - 1:0]        r_s3_i_r[0:7];
    reg         signed  [sum_width(3) - 1:0]        r_s3_q_r[0:7];

    reg         signed  [sum_width(4) - 1:0]        r_s4_i[0:3];
    reg         signed  [sum_width(4) - 1:0]        r_s4_q[0:3];

    reg         signed  [sum_width(4) - 1:0]        r_s4_i_r[0:3];
    reg         signed  [sum_width(4) - 1:0]        r_s4_q_r[0:3];

    reg         signed  [sum_width(5) - 1:0]        r_s5_i[0:1];
    reg         signed  [sum_width(5) - 1:0]        r_s5_q[0:1];

    reg         signed  [sum_width(5) - 1:0]        r_s5_i_r[0:1];
    reg         signed  [sum_width(5) - 1:0]        r_s5_q_r[0:1];

    reg                 [15:0]                      r_s6_i;
    reg                 [15:0]                      r_s6_q;

    reg                 [15:0]                      r_s6_i_r;
    reg                 [15:0]                      r_s6_q_r;

    reg                 [15:0]                      r_abs_i;
    reg                 [15:0]                      r_abs_q;
    reg                 [15:0]                      r_abs_i_r;
    reg                 [15:0]                      r_abs_q_r;

    reg                 [17:0]                      r_delay_reg;

    //latency 1
    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_sg_i <= 'd0;
            r_sg_q <= 'd0;
        end
        else if (enable == 1'b1 && sample_in_valid == 1'b1) begin
            r_sg_i <= {sample_in_i[15], r_sg_i[63:1]};
            r_sg_q <= {sample_in_q[15], r_sg_q[63:1]};
        end
    end

    //latency 1
    always @(posedge sclk) begin
        //add
        r_sg_i_r <= r_sg_i;
        r_sg_q_r <= r_sg_q;
    end

    //latency 1
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin
            always @(posedge sclk) begin
                if (reset == 1'b1) begin
                    r_s_i[i] <= 'd0;
                    r_s_q[i] <= 'd0;
                end
                else begin
                    case ({r_sg_i_r[i], r_sg_q_r[i]})
                        2'b00: begin
                            r_s_i[i] <= LT_I[i] + LT_Q[i];
                            r_s_q[i] <= LT_I[i] - LT_Q[i];
                        end
                        2'b01: begin
                            r_s_i[i] <= LT_I[i] - LT_Q[i];
                            r_s_q[i] <= (~LT_I[i]) + 1 - LT_Q[i];
                        end
                        2'b10: begin
                            r_s_i[i] <= LT_Q[i] - LT_I[i];
                            r_s_q[i] <= LT_I[i] + LT_Q[i];
                        end
                        2'b11: begin
                            r_s_i[i] <= (~LT_I[i]) + 1 - LT_Q[i];
                            r_s_q[i] <= LT_Q[i] - LT_I[i];
                        end
                    endcase
                end
            end
        end
    endgenerate

    //latency 1
    generate
        for (i = 0; i < 64; i = i + 1) begin
            always @(posedge sclk) begin
                r_s_i_r[i] <= r_s_i[i];
                r_s_q_r[i] <= r_s_q[i];
            end
        end
    endgenerate

    //latency 1
    generate
        for (i = 0; i < 32; i = i + 1) begin
            always @(posedge sclk) begin
                if (reset == 1'b1) begin
                    r_s1_i[i] <= 'd0;
                    r_s1_q[i] <= 'd0;
                end
                else begin
                    r_s1_i[i] <= r_s_i_r[i * 2 + 0] + r_s_i_r[i * 2 + 1];
                    r_s1_q[i] <= r_s_q_r[i * 2 + 0] + r_s_q_r[i * 2 + 1];
                end
            end
        end
    endgenerate

    //latency 1
    generate
        for (i = 0; i < 32; i = i + 1) begin
            always @(posedge sclk) begin
                r_s1_i_r[i] <= r_s1_i[i];
                r_s1_q_r[i] <= r_s1_q[i];
            end
        end
    endgenerate

    //latency 1
    generate
        for (i = 0; i < 16; i = i + 1) begin
            always @(posedge sclk) begin
                if (reset == 1'b1) begin
                    r_s2_i[i] <= 'd0;
                    r_s2_q[i] <= 'd0;
                end
                else begin
                    r_s2_i[i] <= r_s1_i_r[i * 2 + 0] + r_s1_i_r[i * 2 + 1];
                    r_s2_q[i] <= r_s1_q_r[i * 2 + 0] + r_s1_q_r[i * 2 + 1];
                end
            end
        end
    endgenerate

    //latency 1
    generate
        for (i = 0; i < 16; i = i + 1) begin
            always @(posedge sclk) begin
                r_s2_i_r[i] <= r_s2_i[i];
                r_s2_q_r[i] <= r_s2_q[i];
            end
        end
    endgenerate

    //latency 1
    generate
        for (i = 0; i < 8; i = i + 1) begin
            always @(posedge sclk) begin
                if (reset == 1'b1) begin
                    r_s3_i[i] <= 'd0;
                    r_s3_q[i] <= 'd0;
                end
                else begin
                    r_s3_i[i] <= r_s2_i_r[i * 2 + 0] + r_s2_i_r[i * 2 + 1];
                    r_s3_q[i] <= r_s2_q_r[i * 2 + 0] + r_s2_q_r[i * 2 + 1];
                end
            end
        end
    endgenerate

    //latency 1
    generate
        for (i = 0; i < 8; i = i + 1) begin
            always @(posedge sclk) begin
                r_s3_i_r[i] <= r_s3_i[i];
                r_s3_q_r[i] <= r_s3_q[i];
            end
        end
    endgenerate

    //latency 1
    generate
        for (i = 0; i < 4; i = i + 1) begin
            always @(posedge sclk) begin
                if (reset == 1'b1) begin
                    r_s4_i[i] <= 'd0;
                    r_s4_q[i] <= 'd0;
                end
                else begin
                    r_s4_i[i] <= r_s3_i_r[i * 2 + 0] + r_s3_i_r[i * 2 + 1];
                    r_s4_q[i] <= r_s3_q_r[i * 2 + 0] + r_s3_q_r[i * 2 + 1];
                end
            end
        end
    endgenerate

    //latency 1
    generate
        for (i = 0; i < 4; i = i + 1) begin
            always @(posedge sclk) begin
                r_s4_i_r[i] <= r_s4_i[i];
                r_s4_q_r[i] <= r_s4_q[i];
            end
        end
    endgenerate

    //latency 1
    generate
        for (i = 0; i < 2; i = i + 1) begin
            always @(posedge sclk) begin
                if (reset == 1'b1) begin
                    r_s5_i[i] <= 'd0;
                    r_s5_q[i] <= 'd0;
                end
                else begin
                    r_s5_i[i] <= r_s4_i_r[i * 2 + 0] + r_s4_i_r[i * 2 + 1];
                    r_s5_q[i] <= r_s4_q_r[i * 2 + 0] + r_s4_q_r[i * 2 + 1];
                end
            end
        end
    endgenerate

    //latency 1
    generate
        for (i = 0; i < 2; i = i + 1) begin
            always @(posedge sclk) begin
                r_s5_i_r[i] <= r_s5_i[i];
                r_s5_q_r[i] <= r_s5_q[i];
            end
        end
    endgenerate

    //latency 1
    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_s6_i <= 'd0;
            r_s6_q <= 'd0;
        end
        else begin
            r_s6_i <= r_s5_i_r[0] + r_s5_i_r[1];
            r_s6_q <= r_s5_q_r[0] + r_s5_q_r[1];
        end
    end

    //latency 1
    always @(posedge sclk) begin
        r_s6_i_r <= r_s6_i;
        r_s6_q_r <= r_s6_q;
    end

    //latency 1
    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_abs_i <= 'd0;
            r_abs_q <= 'd0;
        end
        else begin
            r_abs_i <= r_s6_i_r[15] ? (~r_s6_i_r) + 1: r_s6_i_r;
            r_abs_q <= r_s6_q_r[15] ? (~r_s6_q_r) + 1: r_s6_q_r;
        end
    end

    //latency 1
    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_abs_i_r <= 'd0;
            r_abs_q_r <= 'd0;
        end
        else begin
            r_abs_i_r <= r_abs_i;
            r_abs_q_r <= r_abs_q;
        end
    end

    //latency 1
    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            cross_corr <= 'd0;
        end
        else if (r_abs_i_r >= r_abs_q_r) begin
            cross_corr <= r_abs_i_r + r_abs_q_r[15:2];
        end
        else begin
            cross_corr <= r_abs_q_r + r_abs_i_r[15:2];
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_delay_reg <= 'd0;
        end
        else begin
            r_delay_reg <= {r_delay_reg[16:0], sample_in_valid};
        end
    end

    always @(posedge sclk) begin
        //latency 19
        if (reset == 1'b1) begin
            cross_corr_valid <= 1'b0;
        end
        else if (r_delay_reg[17] == 1'b1) begin
            cross_corr_valid <= 1'b1;
        end
        else begin
            cross_corr_valid <= 1'b0;
        end
    end

endmodule
