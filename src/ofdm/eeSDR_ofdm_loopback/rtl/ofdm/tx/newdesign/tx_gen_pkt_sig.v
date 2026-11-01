module tx_gen_pkt_sig (
    input   wire                            clk_Modulation                                  ,
    input   wire                            reset                                           ,
    input   wire    [5:0]                   tx_Rate                                         ,
    input   wire                            preamble_ready                                  ,
    input   wire    [15:0]                  packetlength                                    ,
    output  reg                             tx_gen_pkt_sig_valid                            ,
    output  reg                             tx_gen_pkt_sig_out
);

    reg                 [3:0]                   r_sig_rate;
    //{R1R2R3R4}
    reg                 [11:0]                  r_reverse_packetlength_12bit;
    reg                                         r_reverse_packetlength_12bit_valid;
    wire                [15:0]                  w_l;
    wire                [16:0]                  w_signal_d;
    wire                [16:0]                  w_s;
    reg                                         r_signal_d_17;
    reg                 [23:0]                  r_signal_pkt_order;
    reg                 [4:0]                   r_cnt_24;

    // packetlength is the user payload length; the TX appends a four-byte FCS,
    // so SIGNAL advertises the complete PSDU length to the receiver.
    assign w_l = packetlength + 16'd4;

    always @(*) begin
        case (tx_Rate)
            6'd6: r_sig_rate <= 4'b1101;
            6'd9: r_sig_rate <= 4'b1111;
            6'd12: r_sig_rate <= 4'b0101;
            6'd18: r_sig_rate <= 4'b0111;
            6'd24: r_sig_rate <= 4'b1001;
            6'd36: r_sig_rate <= 4'b1011;
            6'd48: r_sig_rate <= 4'b0001;
            6'd54: r_sig_rate <= 4'b0011;
            default: r_sig_rate <= 4'b1101;
        endcase
    end

    always @(posedge clk_Modulation) begin
        if (reset == 1'b1) begin
            r_reverse_packetlength_12bit <= 'd0;
        end
        else if (preamble_ready == 1'b1) begin
            // The RX SIGNAL parser shifts each received length bit into the
            // MSB; transmit the length least-significant bit first.
            r_reverse_packetlength_12bit <= {w_l[0], w_l[1], w_l[2], w_l[3], w_l[4], w_l[5],
            w_l[6], w_l[7], w_l[8], w_l[9], w_l[10], w_l[11]};
        end
    end

    always @(posedge clk_Modulation) begin
        if (reset == 1'b1) begin
            r_reverse_packetlength_12bit_valid <= 1'b0;
        end
        else if (preamble_ready == 1'b1) begin
            r_reverse_packetlength_12bit_valid <= 1'b1;
        end
        else begin
            r_reverse_packetlength_12bit_valid <= 1'b0;
        end
    end

    assign w_signal_d = {r_sig_rate, 1'b0, r_reverse_packetlength_12bit};

    assign w_s = w_signal_d;

    always @(posedge clk_Modulation) begin
        if (reset == 1'b1) begin
            r_signal_d_17 <= 1'b0;
        end
        else if (r_reverse_packetlength_12bit_valid == 1'b1) begin
            r_signal_d_17 <= w_s[0] ^ w_s[1] ^ w_s[2] ^ w_s[3] ^ w_s[4] ^ w_s[5] ^ w_s[6] ^ w_s[7] ^ w_s[8] ^ w_s[9] ^ w_s[10] ^
                w_s[11] ^ w_s[12] ^ w_s[13] ^ w_s[14] ^ w_s[15] ^ w_s[16];
        end
    end

    always @(posedge clk_Modulation) begin
        if (reset == 1'b1) begin
            r_signal_pkt_order <= 'd0;
        end
        else if (r_reverse_packetlength_12bit_valid == 1'b1) begin
            r_signal_pkt_order <= {r_sig_rate, 1'b0, r_reverse_packetlength_12bit, 1'b0, 6'b000000};
        end
        else if (tx_gen_pkt_sig_valid == 1'b1) begin
            r_signal_pkt_order <= r_signal_pkt_order << 1;
        end
    end

    always @(posedge clk_Modulation) begin
        if (reset == 1'b1) begin
            tx_gen_pkt_sig_valid <= 1'b0;
        end
        else if (r_cnt_24 == 'd23) begin
            tx_gen_pkt_sig_valid <= 1'b0;
        end
        else if (r_reverse_packetlength_12bit_valid == 1'b1) begin
            tx_gen_pkt_sig_valid <= 1'b1;
        end
    end

    always @(posedge clk_Modulation) begin
        if (reset == 1'b1) begin
            r_cnt_24 <= 'd0;
        end
        else if (tx_gen_pkt_sig_valid == 1'b1) begin
            r_cnt_24 <= r_cnt_24 + 1'b1;
        end
        else begin
            r_cnt_24 <= 'd0;
        end
    end

    always @(*) begin
        if (r_cnt_24 == 'd17) begin
            tx_gen_pkt_sig_out <= r_signal_d_17;
        end
        else if (tx_gen_pkt_sig_valid == 1'b1) begin
            tx_gen_pkt_sig_out <= r_signal_pkt_order[23];
        end
        else begin
            tx_gen_pkt_sig_out <= 'd0;
        end
    end
endmodule
