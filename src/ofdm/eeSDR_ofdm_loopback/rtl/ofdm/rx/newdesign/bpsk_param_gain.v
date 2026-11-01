module bpsk_param_gain #(
    parameter                                       DEBUG_ILA = 1'b0
) (
    input   wire                                        clk                                         ,
    input   wire                                        rst                                         ,
    input   wire                                        bpsk_decoded_data_in_valid                  ,
    input   wire                                        bpsk_decoded_data_in                        ,
    output  reg                                         data_field_param_gain_stb                   ,
    output  reg                                         data_field_param_gain_ok                    ,
    output  reg             [11:0]                      data_field_ofdm_nums                        ,
    output  reg             [5:0]                       data_field_rate                             ,
    output  reg             [11:0]                      data_field_psdu_byte_length                 ,
    output  reg             [1:0]                       data_field_modulation                       ,
    output  reg             [1:0]                       data_field_conv_code_rate
);

    reg                 [4:0]                       r_bpsk_decoded_data_in_valid_cnt;
    reg                                             r_p_temp;
    reg                 [3:0]                       r_rate_reg;
    reg                 [5:0]                       r_rate_temp;
    reg                 [11:0]                      r_length_temp;
    reg                 [15:0]                      r_length_without_pad_bits;
    reg                 [7:0]                       r_divisor_tdata;
    wire                                            w_div_data_out_valid;
    wire                [23:0]                      w_div_data_out;
    reg                 [11:0]                      r_ofdm_nums_temp;
    reg                                             r_parity_check_ok;
    reg                                             r_dividend_and_divisor_tvalid;
    reg                                             r_data_field_param_gain_stb_gen;

    always @(posedge clk) begin
        r_data_field_param_gain_stb_gen <= w_div_data_out_valid;
    end

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            r_bpsk_decoded_data_in_valid_cnt <= 'd0;
        end
        else if (r_bpsk_decoded_data_in_valid_cnt == 'd23) begin
            r_bpsk_decoded_data_in_valid_cnt <= 'd0;
        end
        else if (bpsk_decoded_data_in_valid == 1'b1) begin
            r_bpsk_decoded_data_in_valid_cnt <= r_bpsk_decoded_data_in_valid_cnt + 1'b1;
        end
        else begin
            r_bpsk_decoded_data_in_valid_cnt <= 'd0;
        end
    end

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            r_p_temp <= 1'b0;
        end
        else if (r_data_field_param_gain_stb_gen == 1'b1) begin
            r_p_temp <= 1'b0;
        end
        else if (bpsk_decoded_data_in_valid == 1'b1 && r_bpsk_decoded_data_in_valid_cnt <= 'd16) begin
            r_p_temp <= r_p_temp ^ bpsk_decoded_data_in;
        end
    end

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            r_parity_check_ok <= 1'b0;
        end
        else if (r_data_field_param_gain_stb_gen == 1'b1) begin
            r_parity_check_ok <= 1'b0;
        end
        else if (bpsk_decoded_data_in_valid == 1'b1 && r_bpsk_decoded_data_in_valid_cnt == 'd17) begin
            r_parity_check_ok <= ! (r_p_temp ^ bpsk_decoded_data_in);
        end
    end

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            r_rate_reg <= 'b1101;
        end
        else if (bpsk_decoded_data_in_valid == 1'b1 && r_bpsk_decoded_data_in_valid_cnt <= 'd3) begin
            r_rate_reg <= {r_rate_reg[2:0], bpsk_decoded_data_in};
        end
    end

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            r_rate_temp <= 'd6;
        end
        else if (bpsk_decoded_data_in_valid == 1'b1 && r_bpsk_decoded_data_in_valid_cnt == 'd4) begin
            case (r_rate_reg)
                4'b1101: r_rate_temp <= 'd6;
                4'b1111: r_rate_temp <= 'd9;
                4'b0101: r_rate_temp <= 'd12;
                4'b0111: r_rate_temp <= 'd18;
                4'b1001: r_rate_temp <= 'd24;
                4'b1011: r_rate_temp <= 'd36;
                4'b0001: r_rate_temp <= 'd48;
                4'b0011: r_rate_temp <= 'd54;
                default: r_rate_temp <= 'd6;
            endcase
        end
    end

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            r_length_temp <= 'd0;
        end
        else if (bpsk_decoded_data_in_valid == 1'b1 && r_bpsk_decoded_data_in_valid_cnt >= 'd5 && r_bpsk_decoded_data_in_valid_cnt <= 'd16) begin
            r_length_temp <= {bpsk_decoded_data_in, r_length_temp[11:1]};
        end
    end

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            r_length_without_pad_bits <= 'd0;
        end
        else if (bpsk_decoded_data_in_valid == 1'b1 && r_bpsk_decoded_data_in_valid_cnt == 'd17) begin
            r_length_without_pad_bits <= (r_length_temp << 3) + 'd22;
        end
    end

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            r_dividend_and_divisor_tvalid <= 1'b0;
        end
        else if (bpsk_decoded_data_in_valid == 1'b1 && r_bpsk_decoded_data_in_valid_cnt == 'd17) begin
            r_dividend_and_divisor_tvalid <= 1'b1;
        end
        else begin
            r_dividend_and_divisor_tvalid <= 1'b0;
        end
    end

    always @(posedge clk) begin
        case (r_rate_temp)
            'd6: r_divisor_tdata <= 'd24;
            'd9: r_divisor_tdata <= 'd36;
            'd12: r_divisor_tdata <= 'd48;
            'd18: r_divisor_tdata <= 'd72;
            'd24: r_divisor_tdata <= 'd96;
            'd36: r_divisor_tdata <= 'd144;
            'd48: r_divisor_tdata <= 'd192;
            'd54: r_divisor_tdata <= 'd216;
            default: r_divisor_tdata <= 'd24;
        endcase
    end

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            r_ofdm_nums_temp <= 'd0;
        end
        else if (w_div_data_out_valid == 1'b1) begin
            r_ofdm_nums_temp <= w_div_data_out[19:8] + (| w_div_data_out[7:0]);
        end
        else begin
            r_ofdm_nums_temp <= r_ofdm_nums_temp;
        end
    end

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            data_field_param_gain_ok <= 1'b0;
        end
        else if (r_data_field_param_gain_stb_gen == 1'b1 && r_parity_check_ok == 1'b1) begin
            data_field_param_gain_ok <= 1'b1;
        end
        else begin
            data_field_param_gain_ok <= 1'b0;
        end
    end

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            data_field_modulation <= 2'd0;
            data_field_conv_code_rate <= 2'd0;
            data_field_ofdm_nums <= 'd0;
            data_field_rate <= 'd0;
            data_field_psdu_byte_length <= 'd0;
        end
        else if (r_data_field_param_gain_stb_gen == 1'b1 && r_parity_check_ok == 1'b1) begin
            case (r_rate_temp)
                6, 9: begin
                    data_field_modulation <= 2'd0;
                    data_field_conv_code_rate <= (r_rate_temp == 6) ? 2'd0: 2'd2;
                end
                12, 18: begin
                    data_field_modulation <= 2'd1;
                    data_field_conv_code_rate <= (r_rate_temp == 12) ? 2'd0: 2'd2;
                end
                24, 36: begin
                    data_field_modulation <= 2'd2;
                    data_field_conv_code_rate <= (r_rate_temp == 24) ? 2'd0: 2'd2;
                end
                48: begin
                    data_field_modulation <= 2'd3;
                    data_field_conv_code_rate <= 2'd1;
                end
                54: begin
                    data_field_modulation <= 2'd3;
                    data_field_conv_code_rate <= 2'd2;
                end
                default: begin
                    data_field_modulation <= 2'd0;
                    data_field_conv_code_rate <= 2'd0;
                end
            endcase
            data_field_ofdm_nums <= r_ofdm_nums_temp;
            data_field_rate <= r_rate_temp;
            data_field_psdu_byte_length <= r_length_temp;
        end
    end

    always @(posedge clk) begin
        data_field_param_gain_stb <= r_data_field_param_gain_stb_gen;
    end

    ofdm_signal_nums_cal_div u_ofdm_signal_nums_cal_div (
        .aclk                                         (clk),  // input wire aclk
        .s_axis_divisor_tvalid                        (r_dividend_and_divisor_tvalid),  // input wire s_axis_divisor_tvalid
        .s_axis_divisor_tdata                         (r_divisor_tdata),  // input wire [7:0] s_axis_divisor_tdata
        .s_axis_dividend_tvalid                       (r_dividend_and_divisor_tvalid),  // input wire s_axis_dividend_tvalid
        .s_axis_dividend_tdata                        (r_length_without_pad_bits),  // input wire [15:0] s_axis_dividend_tdata
        .m_axis_dout_tvalid                           (w_div_data_out_valid),  // output wire m_axis_dout_tvalid
        .m_axis_dout_tdata                            (w_div_data_out)  // output wire [23:0] m_axis_dout_tdata
    );

    //////////////////////////////
    //bpsk 解码成功计数
    //////////////////////////////

    // Production builds do not carry a private debug core. Enable explicitly
    // when integrating a supported debug hub and clock in the board design.
    generate if (DEBUG_ILA) begin : debug
            reg                 [31:0]                      r_bpsk_parm_gain_success_count = 0;

            always @(posedge clk) begin
                if (data_field_param_gain_stb == 1'b1 && data_field_param_gain_ok == 1'b1) begin
                    r_bpsk_parm_gain_success_count <= r_bpsk_parm_gain_success_count + 1'b1;
                end
            end

            ila_for_bpsk_param_gain u_ila_for_bpsk_param_gain (
                .clk                                          (clk),  // input wire clk
                .probe0                                       ({
                30'd0,
                r_bpsk_parm_gain_success_count,
                data_field_param_gain_stb,
                data_field_param_gain_ok
                })  // input wire [63:0] probe0
            );
        end
    endgenerate

endmodule
