// Continuous, rate-independent DATA descrambler.
// Recover the LFSR from the first seven scrambled SERVICE zeros.  Valid
// gaps and non-byte-aligned OFDM boundaries (notably 9 Mbps) do not reset it.
module qam64_descramble #(parameter DATA_BYTES_PER_OFDM = 27) (
    input   wire                                        clk                                         ,
    input   wire                                        rst                                         ,
    input   wire                                        data_field_param_gain_stb                   ,
    input   wire                                        data_field_param_gain_ok                    ,
    input   wire            [11:0]                      data_field_ofdm_nums                        ,
    input   wire            [11:0]                      data_field_psdu_byte_length                 ,
    input   wire                                        qam64_descramble_din_valid                  ,
    input   wire                                        qam64_descramble_din                        ,
    output  reg                                         qam64_descramble_dout_valid                 ,
    output  reg             [7:0]                       qam64_descramble_dout
);
    reg                 [6:0]                       r_lfsr;
    reg                 [15:0]                      r_bit_count;
    reg                 [15:0]                      r_psdu_end;
    reg                 [7:0]                       r_byte_shift;
    reg                                             r_active;
    wire                                            w_decoded_bit = qam64_descramble_din ^ r_lfsr[6] ^ r_lfsr[3];
    always @(posedge clk) begin
        if (rst) begin
            r_lfsr <= 0;
            r_bit_count <= 0;
            r_psdu_end <= 0;
            r_byte_shift <= 0;
            r_active <= 0;
            qam64_descramble_dout_valid <= 0;
            qam64_descramble_dout <= 0;
        end else begin
            qam64_descramble_dout_valid <= 0;
            if (data_field_param_gain_stb && data_field_param_gain_ok) begin
                r_bit_count <= 0;
                r_lfsr <= 0;
                r_byte_shift <= 0;
                r_active <= 1;
                r_psdu_end <= 16 + ({4'd0, data_field_psdu_byte_length} << 3);
            end else if (qam64_descramble_din_valid && r_active) begin
                r_bit_count <= r_bit_count + 1'b1;
                if (r_bit_count < 7) r_lfsr <= {r_lfsr[5:0], qam64_descramble_din};
                else r_lfsr <= {r_lfsr[5:0], r_lfsr[6] ^ r_lfsr[3]};
                if (r_bit_count >= 16 && r_bit_count < r_psdu_end) begin
                    r_byte_shift <= {w_decoded_bit, r_byte_shift[7:1]};
                    if (r_bit_count[2:0] == 7) begin
                        qam64_descramble_dout <= {w_decoded_bit, r_byte_shift[7:1]};
                        qam64_descramble_dout_valid <= 1;
                    end
                end
                if (r_bit_count + 1 == r_psdu_end) r_active <= 0;
            end
        end
    end
endmodule
