// -----------------------------------------------------------------------------
// Copyright (c) 2014-2022 All rights reserved
// -----------------------------------------------------------------------------
// Author : You Kaiyuan v3eduyky@126.com
// wechat ： 15921999232 (Tel)
// File   : fix_atan2.v
// Create : 2022-04-13 16:53:53
// Revise : 2022-04-25 00:00:29
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
module fix_atan2(
//这两个信号没有被使用
//用来计算频率控制字的输出数据有效信号
    input   wire                                        sclk                                        ,
    input   wire                                        reset                                       ,
    input   wire                                        enable                                      ,
    input   wire    signed  [31:0]                      y_in                                        ,
    input   wire    signed  [31:0]                      x_in                                        ,
    input   wire                                        xy_in_valid                                 ,
    output  reg     signed  [31:0]                      angle_out                                   ,
    output  reg                                         angle_out_valid                             ,
    output  reg     signed  [31:0]                      angle_out_div16x2pi                         ,
    output  reg                                         angle_out_div16x2pi_valid
);

    //% M_PI_4*x - x*(fabs(x) - 1)*(0.2447 + 0.0663*fabs(x))
    parameter                                       IDLE = 7'b000_0001;
    //1
    parameter                                       DIVS = 7'b000_0010;
    //2
    parameter                                       FXPI4 = 7'b000_0100;
    //4
    parameter                                       FXABSF_1 = 7'b000_1000;
    //8
    parameter                                       ABSFX663 = 7'b001_0000;
    //16
    parameter                                       MULT_LAST = 7'b010_0000;
    //32
    parameter                                       RESULT_ADD = 7'b100_0000;
    //64

    parameter                                       PI4 = 843314842 / 4;
    //fix32_28 (3.1415926*2^28)/4 //都是用定点数来表示的
    parameter                                       FIX1 = 268435456;
    //2^28=fix1 fix32_28
    parameter                                       FIXP0663 = 17797271;
    //0.0663*2^28 fix32_28
    parameter                                       FIXP2447 = 65686156;
    //0.2447*2^28
    parameter                                       FIXDIV16X2PI = 2670177;
    //2^28*(1/(16*2*pi)

    reg                 [6:0]                       r_state;
    reg         signed  [31:0]                      r_y_in_r;
    reg         signed  [31:0]                      r_x_in_r;
    reg                                             r_div_in_valid;
    wire                                            w_div_out_valid;
    reg                                             r_div_out_valid_dly;
    //used to solve timing violation
    wire        signed  [63:0]                      w_div_out;
    reg         signed  [31:0]                      r_div_out_r;
    //fix32_28
    reg                                             r_mult_in_valid;
    reg         signed  [31:0]                      r_mult_in_a;
    reg         signed  [31:0]                      r_mult_in_b;
    //fix32_28
    wire        signed  [63:0]                      w_mult_out;
    //fix64_56
    reg                                             r_mult_out_valid;
    reg                 [5:0]                       r_mult_in_valid_buf;
    reg         signed  [31:0]                      r_absf_1;
    reg         signed  [31:0]                      r_value_fxpi4;
    reg         signed  [31:0]                      r_value_fxabsf_1;
    reg         signed  [31:0]                      r_absf;
    reg         signed  [31:0]                      r_value_absfx663;
    reg         signed  [31:0]                      r_value_mult_last;
    reg         signed  [31:0]                      r_arctan_est_val;
    //add
    reg                                             r_mult_out_valid_dly;
    //add

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_state <= IDLE;
        end
        else begin
            case (r_state)
                IDLE: begin
                    if (xy_in_valid == 1'b1 && enable == 1'b1) begin
                        r_state <= DIVS;
                        //1
                    end
                end
                DIVS: begin
                    if (r_div_out_valid_dly == 1'b1) begin
                        //previous： div_out_valid
                        r_state <= FXPI4;
                        //2
                    end
                end
                FXPI4: begin
                    if (r_mult_out_valid_dly == 1'b1) begin
                        r_state <= FXABSF_1;
                        //4
                    end
                end
                FXABSF_1: begin
                    if (r_mult_out_valid_dly == 1'b1) begin
                        r_state <= ABSFX663;
                        //8
                    end
                end
                ABSFX663: begin
                    if (r_mult_out_valid_dly == 1'b1) begin
                        r_state <= MULT_LAST;
                        //32
                    end
                end
                MULT_LAST: begin
                    if (r_mult_out_valid_dly == 1'b1) begin
                        r_state <= RESULT_ADD;
                        //64
                    end
                end
                RESULT_ADD: begin
                    if (r_mult_out_valid_dly == 1'b1) begin
                        r_state <= IDLE;
                    end
                end
                default: r_state <= IDLE;
            endcase
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_div_in_valid <= 1'b0;
        end
        else if (r_state == IDLE && enable == 1'b1 && xy_in_valid == 1'b1) begin
            r_div_in_valid <= 1'b1;
        end
        else begin
            r_div_in_valid <= 1'b0;
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_y_in_r <= 'd0;
            r_x_in_r <= 'd0;
        end
        else if (r_state == IDLE && enable == 1'b1 && xy_in_valid == 1'b1) begin
            r_y_in_r <= y_in;
            r_x_in_r <= (x_in == 'd0) ? 'd1: x_in;
            //detect 0
        end
    end

    always @(posedge sclk) begin
        r_div_out_valid_dly <= w_div_out_valid;
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_mult_in_valid <= 1'b0;
            r_mult_in_a <= 'd0;
            r_mult_in_b <= 'd0;
        end
        else if (r_state == DIVS && r_div_out_valid_dly == 1'b1) begin
            r_mult_in_valid <= 1'b1;
            r_mult_in_a <= PI4;
            r_mult_in_b <= r_div_out_r;
            // case({div_out[63],div_out[31]})
            //  2'b00:mult_in_b <={div_out[35:32],div_out[30:3]};
            //  2'b01:mult_in_b <={~div_out[34:32],div_out[31:3]};
            //  2'b10:mult_in_b <={div_out[34:32],~div_out[31:3]};
            //  2'b11:mult_in_b <={div_out[34:3]};
            // endcase
        end
        else if (r_state == FXPI4 && r_mult_out_valid == 1'b1) begin
            r_mult_in_valid <= 1'b1;
            r_mult_in_a <= r_absf_1;
            r_mult_in_b <= r_div_out_r;
        end
        else if (r_state == FXABSF_1 && r_mult_out_valid == 1'b1) begin
            r_mult_in_valid <= 1'b1;
            r_mult_in_a <= FIXP0663;
            r_mult_in_b <= r_absf;
        end
        else if (r_state == ABSFX663 && r_mult_out_valid == 1'b1) begin
            r_mult_in_valid <= 1'b1;
            r_mult_in_a <= r_value_fxabsf_1;
            r_mult_in_b <= r_value_absfx663;
            //value_absfx663 是组合逻辑计算得到的，只有一个时钟周期有效
        end
        else if (r_state == MULT_LAST && r_mult_out_valid_dly == 1'b1) begin
            r_mult_in_valid <= 1'b1;
            r_mult_in_a <= FIXDIV16X2PI;
            r_mult_in_b <= r_arctan_est_val;
            //value_fxpi4 - {mult_out[63],mult_out[58:56],mult_out[55:28]}; //correction
        end
        else begin
            r_mult_in_valid <= 1'b0;
        end
    end

    always @(posedge sclk) begin
        r_mult_out_valid_dly <= r_mult_out_valid;
    end

    always @(posedge sclk) begin
        //add for timing violation
        if (reset == 1'b1) begin
            r_arctan_est_val <= 'd0;
        end
        else if (r_state == MULT_LAST && r_mult_out_valid) begin
            r_arctan_est_val <= r_value_fxpi4 - {w_mult_out[63], w_mult_out[58:56], w_mult_out[55:28]};
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_div_out_r <= 'd0;
        end
        else if (r_state == DIVS && w_div_out_valid == 1'b1) begin
            case ({w_div_out[63], w_div_out[31]})
                2'b00: r_div_out_r <= {w_div_out[63], w_div_out[34:32], w_div_out[30:3]};
                2'b01: r_div_out_r <= {~w_div_out[34:32], w_div_out[31:3]};
                2'b10: r_div_out_r <= {w_div_out[63], w_div_out[34:32], 28'd0};
                2'b11: r_div_out_r <= {w_div_out[63], w_div_out[34:32] - 1'b1, w_div_out[30:3]};
            endcase
        end
    end

    always @(posedge sclk) begin
        r_absf_1 <= r_div_out_r[31] ? (~r_div_out_r) + 1 - FIX1: r_div_out_r - FIX1;
        //fabs(x)-1;
        r_absf <= r_div_out_r[31] ? (~r_div_out_r) + 1: r_div_out_r;
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_value_fxpi4 <= 'd0;
        end
        else if (r_state == FXPI4 && r_mult_out_valid == 1'b1) begin
            r_value_fxpi4 <= {w_mult_out[63], w_mult_out[58:56], w_mult_out[55:28]};
            // fix64_56 -> fix32_28
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_value_fxabsf_1 <= 'd0;
        end
        else if (r_state == FXABSF_1 && r_mult_out_valid == 1'b1) begin
            r_value_fxabsf_1 <= {w_mult_out[63], w_mult_out[58:56], w_mult_out[55:28]};
            // fix64_56 -> fix32_28
        end
    end

    always @(*) begin
        if (r_state == ABSFX663 && r_mult_out_valid == 1'b1) begin
            r_value_absfx663 = {w_mult_out[63], w_mult_out[58:56], w_mult_out[55:28]} + FIXP2447;
            // (0.2447 + 0.0663*fabs(x)
        end
        else begin
            r_value_absfx663 = 'd0;
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_value_mult_last <= 'd0;
        end
        else if (r_state == MULT_LAST && r_mult_out_valid == 1'b1) begin
            r_value_mult_last <= {w_mult_out[63], w_mult_out[58:56], w_mult_out[55:28]};
            // fix64_56 -> fix32_28
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            angle_out <= 'd0;
        end
        //% M_PI_4*x - x*(fabs(x) - 1)*(0.2447 + 0.0663*fabs(x))
        else if (r_state == RESULT_ADD && enable == 1'b1 && r_mult_out_valid == 1'b1) begin
            angle_out <= r_value_fxpi4 - r_value_mult_last;
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            angle_out_valid <= 1'b0;
        end
        else if (r_state == RESULT_ADD && enable == 1'b1 && r_mult_out_valid == 1'b1) begin
            angle_out_valid <= 1'b1;
        end
        else begin
            angle_out_valid <= 1'b0;
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            angle_out_div16x2pi <= 'd0;
        end
        //% M_PI_4*x - x*(fabs(x) - 1)*(0.2447 + 0.0663*fabs(x))
        else if (r_state == RESULT_ADD && enable == 1'b1 && r_mult_out_valid == 1'b1) begin
            angle_out_div16x2pi <= {w_mult_out[63], w_mult_out[58:56], w_mult_out[55:28]};
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            angle_out_div16x2pi_valid <= 1'b0;
        end
        else if (r_state == RESULT_ADD && enable == 1'b1 && r_mult_out_valid == 1'b1) begin
            angle_out_div16x2pi_valid <= 1'b1;
        end
        else begin
            angle_out_div16x2pi_valid <= 1'b0;
        end
    end

    div_atan2_s32in u_div_atan2_s32in (
        .aclk                                         (sclk),  // input wire aclk
        .s_axis_divisor_tvalid                        (r_div_in_valid),  // input wire s_axis_divisor_tvalid
        .s_axis_divisor_tdata                         (r_x_in_r),  // input wire [31:0] s_axis_divisor_tdata
        .s_axis_dividend_tvalid                       (r_div_in_valid),  // input wire s_axis_dividend_tvalid
        .s_axis_dividend_tdata                        (r_y_in_r),  // input wire [31:0] s_axis_dividend_tdata
        .m_axis_dout_tvalid                           (w_div_out_valid),  // output wire m_axis_dout_tvalid
        .m_axis_dout_tdata                            (w_div_out)  // output wire [63:0] m_axis_dout_tdata
    );

    mult_atan2_s32 u_mult_atan2_s32 (
        .CLK                                          (sclk),  // input wire CLK
        .A                                            (r_mult_in_a),  // input wire [31:0] A
        .B                                            (r_mult_in_b),  // input wire [31:0] B
        .P                                            (w_mult_out)  // output wire [63:0] P
    );

    //before: latency 3 clyle clocks
    //now: extra 4 clyle clock latency,   is used for solving timing violation
    always @(posedge sclk) begin
        {r_mult_out_valid, r_mult_in_valid_buf} <= {r_mult_in_valid_buf, r_mult_in_valid};
    end

endmodule
