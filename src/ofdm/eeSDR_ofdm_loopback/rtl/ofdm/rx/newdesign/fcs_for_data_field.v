// CRC state is retained over valid gaps; LENGTH determines the frame end.
module fcs_for_data_field(
    input   wire                                        clk                                         ,
    input   wire                                        rst                                         ,
    input   wire                                        fcs_data_in_valid                           ,
    input   wire            [7:0]                       fcs_data_in                                 ,
    output  reg                                         fcs_data_out_valid                          ,
    output  reg             [7:0]                       fcs_data_out                                ,
    output  reg                                         fcs_ok_strobe                               ,
    output  reg                                         fcs_ok                                      ,
    output  reg             [15:0]                      pkt_length                                  ,
    input   wire                                        data_field_param_gain_stb                   ,
    input   wire                                        data_field_param_gain_ok                    ,
    input   wire            [11:0]                      data_field_psdu_byte_length
);
    reg                 [11:0]                      r_byte_count;
    reg                 [11:0]                      r_psdu_length;
    reg                 [11:0]                      r_last_byte_index;
    reg                 [31:0]                      r_crc_state;
    reg                 [31:0]                      r_crc_next;
    integer bit_index;
    always @(*) begin
        r_crc_next = r_crc_state;
        for (bit_index = 0; bit_index < 8; bit_index = bit_index + 1) begin
            if (r_crc_next[0] ^ fcs_data_in[bit_index])
                r_crc_next = (r_crc_next >> 1) ^ 32'hedb88320;
            else r_crc_next = r_crc_next >> 1;
        end
    end
    always @(posedge clk) begin
        if (rst) begin
            r_byte_count <= 0;
            r_psdu_length <= 0;
            r_last_byte_index <= 12'hfff;
            pkt_length <= 0;
            r_crc_state <= 32'hffffffff;
            fcs_data_out_valid <= 0;
            fcs_data_out <= 0;
            fcs_ok_strobe <= 0;
            fcs_ok <= 0;
        end else begin
            fcs_data_out_valid <= 0;
            fcs_ok_strobe <= 0;
            fcs_ok <= 0;
            if (data_field_param_gain_stb && data_field_param_gain_ok) begin
                r_psdu_length <= data_field_psdu_byte_length;
                // Stable packet metadata: remove subtract-then-compare from
                // the final CRC decision without delaying payload or strobe.
                r_last_byte_index <= data_field_psdu_byte_length - 1'b1;
                pkt_length <= data_field_psdu_byte_length >= 4 ? data_field_psdu_byte_length - 4: 0;
                r_byte_count <= 0;
                r_crc_state <= 32'hffffffff;
            end else if (fcs_data_in_valid && r_byte_count < r_psdu_length) begin
                r_crc_state <= r_crc_next;
                r_byte_count <= r_byte_count + 1'b1;
                if (r_byte_count < pkt_length) begin
                    fcs_data_out_valid <= 1;
                    fcs_data_out <= fcs_data_in;
                end
                if (r_byte_count == r_last_byte_index) begin
                    fcs_ok_strobe <= 1;
                    fcs_ok <= r_crc_next == 32'hdebb20e3;
                end
            end
        end
    end
endmodule
