module bpsk_demodulation #(parameter CSI_WIDTH = 16, DATA_WIDTH = 32)(
    input wire clk, input wire rst,
    input wire [CSI_WIDTH-1:0] csi_i, input wire [CSI_WIDTH-1:0] csi_q,
    input wire csi_valid,
    input wire [DATA_WIDTH-1:0] chnl_data_i,
    input wire [DATA_WIDTH-1:0] chnl_data_q,
    input wire chnl_data_valid,
    output reg [2:0] demod_out, output reg demod_out_valid
);
    // Keep the complete widened CSI/data path through the threshold compare.
    reg signed [CSI_WIDTH-1:0] r_csi_i_dly, r_csi_i_dly2;
    reg signed [CSI_WIDTH-1:0] r_csi_i_dly3, r_csi_i_dly4;
    reg [2*CSI_WIDTH:0] r_csi_amp, r_one_quarter_amp;
    reg [2*CSI_WIDTH:0] r_two_quarters_amp, r_three_quarters_amp;
    reg r_csi_valid_dly4, r_csi_valid_dly3;
    reg r_csi_valid_dly2, r_csi_valid_dly;
    reg signed [DATA_WIDTH:0] r_chnl_i_dly3_abs_2x;
    reg signed [2*CSI_WIDTH-1:0] r_csi_i_square_1, r_csi_i_square_2;
    reg signed [2*CSI_WIDTH-1:0] w_csi_i_square;
    reg signed [2*CSI_WIDTH-1:0] r_csi_q_square_1, r_csi_q_square_2;
    reg signed [2*CSI_WIDTH-1:0] w_csi_q_square;
    reg signed [DATA_WIDTH-1:0] r_chnl_data_i_dly4;
    reg signed [DATA_WIDTH-1:0] r_chnl_data_i_dly3;
    reg signed [DATA_WIDTH-1:0] r_chnl_data_i_dly2;
    reg signed [DATA_WIDTH-1:0] r_chnl_data_i_dly;
    reg r_csi_valid_dly5, r_channel_sign_dly5;
    reg [DATA_WIDTH:0] r_channel_abs_dly5;

    // Three registered stages match the former square multiplier latency.
    always @(posedge clk) begin
        if (rst) begin
            r_csi_i_square_1 <= 'd0; r_csi_i_square_2 <= 'd0;
            w_csi_i_square <= 'd0; r_csi_q_square_1 <= 'd0;
            r_csi_q_square_2 <= 'd0; w_csi_q_square <= 'd0;
        end else begin
            r_csi_i_square_1 <= $signed({{CSI_WIDTH{csi_i[CSI_WIDTH-1]}}, csi_i}) *
                                $signed({{CSI_WIDTH{csi_i[CSI_WIDTH-1]}}, csi_i});
            r_csi_i_square_2 <= r_csi_i_square_1;
            w_csi_i_square <= r_csi_i_square_2;
            r_csi_q_square_1 <= $signed({{CSI_WIDTH{csi_q[CSI_WIDTH-1]}}, csi_q}) *
                                $signed({{CSI_WIDTH{csi_q[CSI_WIDTH-1]}}, csi_q});
            r_csi_q_square_2 <= r_csi_q_square_1;
            w_csi_q_square <= r_csi_q_square_2;
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            r_csi_amp <= 'd0; r_csi_valid_dly5 <= 1'b0;
            r_channel_sign_dly5 <= 1'b0; r_channel_abs_dly5 <= 'd0;
        end else begin
            r_csi_amp <= {1'b0, w_csi_i_square} + {1'b0, w_csi_q_square};
            r_csi_valid_dly5 <= r_csi_valid_dly4;
            r_channel_sign_dly5 <= r_chnl_data_i_dly4[DATA_WIDTH-1];
            r_channel_abs_dly5 <= r_chnl_i_dly3_abs_2x;
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            r_one_quarter_amp <= 'd0; r_two_quarters_amp <= 'd0;
            r_three_quarters_amp <= 'd0;
        end else begin
            r_one_quarter_amp <= r_csi_amp >> 2;
            r_two_quarters_amp <= r_csi_amp >> 1;
            r_three_quarters_amp <= (r_csi_amp >> 2) + (r_csi_amp >> 1);
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            r_csi_i_dly <= 'd0; r_csi_i_dly2 <= 'd0;
            r_csi_i_dly3 <= 'd0; r_csi_i_dly4 <= 'd0;
        end else begin
            r_csi_i_dly4 <= r_csi_i_dly3; r_csi_i_dly3 <= r_csi_i_dly2;
            r_csi_i_dly2 <= r_csi_i_dly; r_csi_i_dly <= csi_i;
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            r_csi_valid_dly <= 1'b0; r_csi_valid_dly2 <= 1'b0;
            r_csi_valid_dly3 <= 1'b0; r_csi_valid_dly4 <= 1'b0;
        end else begin
            r_csi_valid_dly4 <= r_csi_valid_dly3;
            r_csi_valid_dly3 <= r_csi_valid_dly2;
            r_csi_valid_dly2 <= r_csi_valid_dly;
            r_csi_valid_dly <= csi_valid;
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            r_chnl_data_i_dly <= 'd0; r_chnl_data_i_dly2 <= 'd0;
            r_chnl_data_i_dly3 <= 'd0; r_chnl_data_i_dly4 <= 'd0;
        end else begin
            r_chnl_data_i_dly4 <= r_chnl_data_i_dly3;
            r_chnl_data_i_dly3 <= r_chnl_data_i_dly2;
            r_chnl_data_i_dly2 <= r_chnl_data_i_dly;
            r_chnl_data_i_dly <= chnl_data_i;
        end
    end

    always @(posedge clk) begin
        if (rst) r_chnl_i_dly3_abs_2x <= 'd0;
        else if (!r_chnl_data_i_dly3[DATA_WIDTH-1])
            r_chnl_i_dly3_abs_2x <= {1'b0, r_chnl_data_i_dly3} << 1;
        else
            r_chnl_i_dly3_abs_2x <= {1'b0, (~r_chnl_data_i_dly3) + 1'b1} << 1;
    end

    always @(posedge clk) begin
        if (rst) begin
            demod_out <= 'd0; demod_out_valid <= 1'b0;
        end else begin
            demod_out_valid <= r_csi_valid_dly5;
            if (r_csi_valid_dly5) begin
                if (r_channel_sign_dly5) begin
                    if (r_channel_abs_dly5 < r_one_quarter_amp) demod_out <= 'd3;
                    else if (r_channel_abs_dly5 < r_two_quarters_amp) demod_out <= 'd2;
                    else if (r_channel_abs_dly5 < r_three_quarters_amp) demod_out <= 'd1;
                    else demod_out <= 'd0;
                end else begin
                    if (r_channel_abs_dly5 < r_one_quarter_amp) demod_out <= 'd4;
                    else if (r_channel_abs_dly5 < r_two_quarters_amp) demod_out <= 'd5;
                    else if (r_channel_abs_dly5 < r_three_quarters_amp) demod_out <= 'd6;
                    else demod_out <= 'd7;
                end
            end else demod_out <= 'd0;
        end
    end
endmodule