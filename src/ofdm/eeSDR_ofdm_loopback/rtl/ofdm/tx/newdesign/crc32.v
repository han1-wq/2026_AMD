// polynomial: x^32 + x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x^1 + 1
// data width: 8
// convention: the first serial bit is D[7]

module crc32 (
    input   wire                            clk_User                                        ,
    input   wire                            reset                                           ,
    input   wire                            crc_en                                          ,
    input   wire    [7:0]                   data_in                                         ,
    output  reg                             crc_data_valid                                  ,
    output  reg     [7:0]                   crc_data
);

    reg                 [31:0]                  r_lfsr_c;
    reg                 [31:0]                  r_lfsr_q;
    wire                [7:0]                   w_d;
    reg                                         r_crc_en_dly;
    wire                                        w_data_in_end_flag;
    reg                                         r_state;
    reg                 [3:0]                   r_cnt_4;
    wire                [31:0]                  w_crc_out;

    assign w_data_in_end_flag = (~crc_en) & (r_crc_en_dly);

    always @(posedge clk_User) begin
        if (reset == 1'b1) begin
            r_crc_en_dly <= 1'b0;
        end
        else begin
            r_crc_en_dly <= crc_en;
        end
    end

    always @(posedge clk_User) begin
        if (reset == 1'b1) begin
            r_state <= 1'b0;
        end
        else if (r_cnt_4 == 'd3) begin
            r_state <= 1'b0;
        end
        else if (w_data_in_end_flag == 1'b1) begin
            r_state <= 1'b1;
        end
    end

    always @(posedge clk_User) begin
        if (reset == 1'b1) begin
            r_cnt_4 <= 'd0;
        end
        else if (r_cnt_4 == 'd3) begin
            r_cnt_4 <= 'd0;
        end
        else if (w_data_in_end_flag || r_state) begin
            r_cnt_4 <= r_cnt_4 + 1'b1;
        end
        else begin
            r_cnt_4 <= 'd0;
        end
    end

    // Reverse the internal MSB-first remainder to reflected IEEE CRC-32.
    genvar crc_bit;
    generate for (crc_bit = 0; crc_bit < 32; crc_bit = crc_bit + 1) begin
            assign w_crc_out[crc_bit] = ~r_lfsr_q[31 - crc_bit];
        end
    endgenerate

    always @(posedge clk_User) begin
        if (reset == 1'b1) begin
            crc_data <= 'd0;
        end
        else if (w_data_in_end_flag || r_state) begin
            //最后4拍CRC
            if (r_cnt_4 == 'd0) begin
                crc_data <= w_crc_out[7:0];
            end
            else if (r_cnt_4 == 'd1) begin
                crc_data <= w_crc_out[15:8];
            end
            else if (r_cnt_4 == 'd2) begin
                crc_data <= w_crc_out[23:16];
            end
            else if (r_cnt_4 == 'd3) begin
                crc_data <= w_crc_out[31:24];
            end
        end
        else begin
            crc_data <= data_in;
        end
    end

    always @(posedge clk_User) begin
        if (reset == 1'b1) begin
            crc_data_valid <= 1'b0;
        end
        else begin
            crc_data_valid <= (crc_en | w_data_in_end_flag | r_state);
        end
    end

    assign w_d = {data_in[0], data_in[1], data_in[2], data_in[3],
    data_in[4], data_in[5], data_in[6], data_in[7]};

    always @(*) begin
        r_lfsr_c[0] = w_d[6] ^ w_d[0] ^ r_lfsr_q[24] ^ r_lfsr_q[30];
        r_lfsr_c[1] = w_d[7] ^ w_d[6] ^ w_d[1] ^ w_d[0] ^ r_lfsr_q[24] ^ r_lfsr_q[25] ^ r_lfsr_q[30] ^ r_lfsr_q[31];
        r_lfsr_c[2] = w_d[7] ^ w_d[6] ^ w_d[2] ^ w_d[1] ^ w_d[0] ^ r_lfsr_q[24] ^ r_lfsr_q[25] ^ r_lfsr_q[26] ^ r_lfsr_q[30] ^
            r_lfsr_q[31];
        r_lfsr_c[3] = w_d[7] ^ w_d[3] ^ w_d[2] ^ w_d[1] ^ r_lfsr_q[25] ^ r_lfsr_q[26] ^ r_lfsr_q[27] ^ r_lfsr_q[31];
        r_lfsr_c[4] = w_d[6] ^ w_d[4] ^ w_d[3] ^ w_d[2] ^ w_d[0] ^ r_lfsr_q[24] ^ r_lfsr_q[26] ^ r_lfsr_q[27] ^ r_lfsr_q[28] ^
            r_lfsr_q[30];
        r_lfsr_c[5] = w_d[7] ^ w_d[6] ^ w_d[5] ^ w_d[4] ^ w_d[3] ^ w_d[1] ^ w_d[0] ^ r_lfsr_q[24] ^ r_lfsr_q[25] ^ r_lfsr_q[27] ^
            r_lfsr_q[28] ^ r_lfsr_q[29] ^ r_lfsr_q[30] ^ r_lfsr_q[31];
        r_lfsr_c[6] = w_d[7] ^ w_d[6] ^ w_d[5] ^ w_d[4] ^ w_d[2] ^ w_d[1] ^ r_lfsr_q[25] ^ r_lfsr_q[26] ^ r_lfsr_q[28] ^
            r_lfsr_q[29] ^ r_lfsr_q[30] ^ r_lfsr_q[31];
        r_lfsr_c[7] = w_d[7] ^ w_d[5] ^ w_d[3] ^ w_d[2] ^ w_d[0] ^ r_lfsr_q[24] ^ r_lfsr_q[26] ^ r_lfsr_q[27] ^ r_lfsr_q[29] ^
            r_lfsr_q[31];
        r_lfsr_c[8] = w_d[4] ^ w_d[3] ^ w_d[1] ^ w_d[0] ^ r_lfsr_q[0] ^ r_lfsr_q[24] ^ r_lfsr_q[25] ^ r_lfsr_q[27] ^
            r_lfsr_q[28];
        r_lfsr_c[9] = w_d[5] ^ w_d[4] ^ w_d[2] ^ w_d[1] ^ r_lfsr_q[1] ^ r_lfsr_q[25] ^ r_lfsr_q[26] ^ r_lfsr_q[28] ^
            r_lfsr_q[29];
        r_lfsr_c[10] = w_d[5] ^ w_d[3] ^ w_d[2] ^ w_d[0] ^ r_lfsr_q[2] ^ r_lfsr_q[24] ^ r_lfsr_q[26] ^ r_lfsr_q[27] ^
            r_lfsr_q[29];
        r_lfsr_c[11] = w_d[4] ^ w_d[3] ^ w_d[1] ^ w_d[0] ^ r_lfsr_q[3] ^ r_lfsr_q[24] ^ r_lfsr_q[25] ^ r_lfsr_q[27] ^
            r_lfsr_q[28];
        r_lfsr_c[12] = w_d[6] ^ w_d[5] ^ w_d[4] ^ w_d[2] ^ w_d[1] ^ w_d[0] ^ r_lfsr_q[4] ^ r_lfsr_q[24] ^ r_lfsr_q[25] ^
            r_lfsr_q[26] ^ r_lfsr_q[28] ^ r_lfsr_q[29] ^ r_lfsr_q[30];
        r_lfsr_c[13] = w_d[7] ^ w_d[6] ^ w_d[5] ^ w_d[3] ^ w_d[2] ^ w_d[1] ^ r_lfsr_q[5] ^ r_lfsr_q[25] ^ r_lfsr_q[26] ^
            r_lfsr_q[27] ^ r_lfsr_q[29] ^ r_lfsr_q[30] ^ r_lfsr_q[31];
        r_lfsr_c[14] = w_d[7] ^ w_d[6] ^ w_d[4] ^ w_d[3] ^ w_d[2] ^ r_lfsr_q[6] ^ r_lfsr_q[26] ^ r_lfsr_q[27] ^ r_lfsr_q[28] ^
            r_lfsr_q[30] ^ r_lfsr_q[31];
        r_lfsr_c[15] = w_d[7] ^ w_d[5] ^ w_d[4] ^ w_d[3] ^ r_lfsr_q[7] ^ r_lfsr_q[27] ^ r_lfsr_q[28] ^ r_lfsr_q[29] ^
            r_lfsr_q[31];
        r_lfsr_c[16] = w_d[5] ^ w_d[4] ^ w_d[0] ^ r_lfsr_q[8] ^ r_lfsr_q[24] ^ r_lfsr_q[28] ^ r_lfsr_q[29];
        r_lfsr_c[17] = w_d[6] ^ w_d[5] ^ w_d[1] ^ r_lfsr_q[9] ^ r_lfsr_q[25] ^ r_lfsr_q[29] ^ r_lfsr_q[30];
        r_lfsr_c[18] = w_d[7] ^ w_d[6] ^ w_d[2] ^ r_lfsr_q[10] ^ r_lfsr_q[26] ^ r_lfsr_q[30] ^ r_lfsr_q[31];
        r_lfsr_c[19] = w_d[7] ^ w_d[3] ^ r_lfsr_q[11] ^ r_lfsr_q[27] ^ r_lfsr_q[31];
        r_lfsr_c[20] = w_d[4] ^ r_lfsr_q[12] ^ r_lfsr_q[28];
        r_lfsr_c[21] = w_d[5] ^ r_lfsr_q[13] ^ r_lfsr_q[29];
        r_lfsr_c[22] = w_d[0] ^ r_lfsr_q[14] ^ r_lfsr_q[24];
        r_lfsr_c[23] = w_d[6] ^ w_d[1] ^ w_d[0] ^ r_lfsr_q[15] ^ r_lfsr_q[24] ^ r_lfsr_q[25] ^ r_lfsr_q[30];
        r_lfsr_c[24] = w_d[7] ^ w_d[2] ^ w_d[1] ^ r_lfsr_q[16] ^ r_lfsr_q[25] ^ r_lfsr_q[26] ^ r_lfsr_q[31];
        r_lfsr_c[25] = w_d[3] ^ w_d[2] ^ r_lfsr_q[17] ^ r_lfsr_q[26] ^ r_lfsr_q[27];
        r_lfsr_c[26] = w_d[6] ^ w_d[4] ^ w_d[3] ^ w_d[0] ^ r_lfsr_q[18] ^ r_lfsr_q[24] ^ r_lfsr_q[27] ^ r_lfsr_q[28] ^
            r_lfsr_q[30];
        r_lfsr_c[27] = w_d[7] ^ w_d[5] ^ w_d[4] ^ w_d[1] ^ r_lfsr_q[19] ^ r_lfsr_q[25] ^ r_lfsr_q[28] ^ r_lfsr_q[29] ^
            r_lfsr_q[31];
        r_lfsr_c[28] = w_d[6] ^ w_d[5] ^ w_d[2] ^ r_lfsr_q[20] ^ r_lfsr_q[26] ^ r_lfsr_q[29] ^ r_lfsr_q[30];
        r_lfsr_c[29] = w_d[7] ^ w_d[6] ^ w_d[3] ^ r_lfsr_q[21] ^ r_lfsr_q[27] ^ r_lfsr_q[30] ^ r_lfsr_q[31];
        r_lfsr_c[30] = w_d[7] ^ w_d[4] ^ r_lfsr_q[22] ^ r_lfsr_q[28] ^ r_lfsr_q[31];
        r_lfsr_c[31] = w_d[5] ^ r_lfsr_q[23] ^ r_lfsr_q[29];
    end

    always @(posedge clk_User) begin
        if (reset == 1'b1) begin
            r_lfsr_q <= {32 {1'b1}};
        end
        else if (r_cnt_4 == 'd3 && r_state == 1'b1) begin
            r_lfsr_q <= {32 {1'b1}};
        //一次crc计算完成恢复初始值
        end
        else if (crc_en == 1'b1) begin
            r_lfsr_q <= r_lfsr_c;
        end
    end

endmodule
