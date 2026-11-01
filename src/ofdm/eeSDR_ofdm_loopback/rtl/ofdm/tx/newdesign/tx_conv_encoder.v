module tx_conv_encoder (
    input   wire                            clk_Modulation                                  ,
    input   wire                            reset                                           ,
    input   wire                            tx_conv_encoder_valid                           ,
    input   wire                            tx_conv_encoder_bit                             ,
    output  reg                             tx_conv_valid                                   ,
    output  wire    [1:0]                   tx_conv_bit
);

    wire                [6:0]                   w_conv1_coef;
    wire                [6:0]                   w_conv2_coef;

    reg                 [6:0]                   r_conv_win;
    reg                                         r_conv_flag;
    reg                                         r_conv1_result;
    reg                                         r_conv2_result;
    reg                                         r_tx_conv_valid_dly;
    wire                                        w_tx_conv_valid_end_flag;

    assign w_tx_conv_valid_end_flag = (~tx_conv_valid) & r_tx_conv_valid_dly;

    assign w_conv1_coef = 7'b1101101;
    assign w_conv2_coef = 7'b1001111;

    always @(posedge clk_Modulation) begin
        if (reset == 1'b1) begin
            r_conv_win <= 7'd0;
        end
        else if (w_tx_conv_valid_end_flag == 1'b1) begin
            r_conv_win <= 7'd0;
        end
        else if (tx_conv_encoder_valid == 1'b1) begin
            r_conv_win <= {r_conv_win[5:0], tx_conv_encoder_bit};
        end
    end

    always @(posedge clk_Modulation) begin
        if (reset == 1'b1) begin
            r_conv_flag <= 1'b0;
            r_tx_conv_valid_dly <= 1'b0;
            tx_conv_valid <= 1'b0;
        end
        else begin
            r_conv_flag <= tx_conv_encoder_valid;
            tx_conv_valid <= r_conv_flag;
            r_tx_conv_valid_dly <= tx_conv_valid;
        end
    end

    always @(posedge clk_Modulation) begin
        if (reset == 1'b1) begin
            r_conv1_result <= 1'b0;
            r_conv2_result <= 1'b0;
        end
        else if (w_tx_conv_valid_end_flag == 1'b1) begin
            r_conv1_result <= 1'b0;
            r_conv2_result <= 1'b0;
        end
        else if (r_conv_flag == 1'b1) begin
            r_conv1_result <= (w_conv1_coef[6] & r_conv_win[6]) ^ (w_conv1_coef[5] & r_conv_win[5]) ^
                (w_conv1_coef[4] & r_conv_win[4]) ^ (w_conv1_coef[3] & r_conv_win[3]) ^ (w_conv1_coef[2] & r_conv_win[2]) ^
                (w_conv1_coef[1] & r_conv_win[1]) ^ (w_conv1_coef[0] & r_conv_win[0]);
            r_conv2_result <= (w_conv2_coef[6] & r_conv_win[6]) ^ (w_conv2_coef[5] & r_conv_win[5]) ^
                (w_conv2_coef[4] & r_conv_win[4]) ^ (w_conv2_coef[3] & r_conv_win[3]) ^ (w_conv2_coef[2] & r_conv_win[2]) ^
                (w_conv2_coef[1] & r_conv_win[1]) ^ (w_conv2_coef[0] & r_conv_win[0]);
        end
    end

    assign tx_conv_bit = {r_conv1_result, r_conv2_result};
endmodule
