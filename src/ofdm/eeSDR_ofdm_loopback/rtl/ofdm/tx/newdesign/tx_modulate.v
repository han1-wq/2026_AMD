// Compact frame store: six-bit constellation indices, never time-domain samples.
// Capture finishes before replay. A 52-carrier burst is issued every 160/320
// clocks so the pipelined IFFT sustains the legacy output sample cadence.
module tx_modulate (
    input   wire                            clk_Modulation                                  ,
    input   wire                            reset                                           ,
    input   wire    [5:0]                   tx_Rate                                         ,
    input   wire    [1:0]                   tx_Modulation                                   ,
    input   wire                            tx_modulate_in_valid                            ,
    input   wire                            tx_modulate_in_bit                              ,
    input   wire                            tx_modulate_in_last                             ,
    output  wire                            in_ready                                        ,
    input   wire    [15:0]                  frame_symbols                                   ,
    input   wire                            data_start_allowed                              ,
    input   wire    [1:0]                   tx_Upsample                                     ,
    input   wire                            tx_freq_to_timed_cycle_flag                     ,
    output  wire    [15:0]                  n_ofdm_syms                                     ,
    output  wire                            tx_modulate_out_valid                           ,
    output  reg     [31:0]                  tx_modulate_re_out                              ,
    output  reg     [31:0]                  tx_modulate_im_out
);
    localparam          [31:0]                  LP_BPSK_POS = 32'h40000000;
    localparam          [31:0]                  LP_BPSK_NEG = 32'hc0000000;
    localparam                                  LP_LOAD = 0;
    localparam                                  LP_WAIT = 1;
    localparam                                  LP_SEND = 2;
    localparam                                  LP_DRAIN = 3;
    reg                 [1:0]                   r_state;
    // Worst case with RS: 371 BPSK symbols * 48 data carriers.
    localparam MAX_CARRIERS = 17808;
    (* ram_style = "block" *) reg [5:0] r_carriers[0:MAX_CARRIERS-1];
    reg                 [5:0]                   r_group_bits;
    reg                 [2:0]                   r_group_count;
    reg                 [14:0]                  r_write_carrier;
    reg                 [14:0]                  r_read_carrier;
    reg                 [14:0]                  r_frame_last;
    reg                 [14:0]                  r_read_next;
    reg                 [5:0]                   r_slot_count;
    reg                 [5:0]                   r_symbol_bits;
    reg                 [5:0]                   r_decode_bits;
    reg                 [5:0]                   r_decode_slot;
    reg                 [1:0]                   r_decode_modulation;
    reg                                         r_decode_valid;
    reg                                         r_decode_is_pilot;
    reg                                         r_decode_polarity;
    reg                                         r_input_valid_q;
    reg                                         r_input_bit_q;
    reg                                         r_input_last_q;
    reg                 [8:0]                   r_launch_count;
    reg                                         r_final_symbol;
    reg                 [6:0]                   r_pilot_addr;
    wire                                        w_pilot_scramble_value;
    wire                [2:0]                   w_bpsc = tx_Modulation == 0 ? 3'd1 : tx_Modulation == 1 ? 3'd2:
        tx_Modulation == 2 ? 3'd4 : 3'd6;
    wire                                        w_is_pilot = r_slot_count == 5 || r_slot_count == 19 || r_slot_count == 32 || r_slot_count == 46;
    assign n_ofdm_syms = frame_symbols;
    assign in_ready = r_state == LP_LOAD && !(r_input_valid_q && r_input_last_q);
    assign tx_modulate_out_valid = r_decode_valid;
    wire                                        w_accept = tx_modulate_in_valid && in_ready;
    wire                                        w_push = r_input_valid_q;
    reg                 [5:0]                   r_assembled;
    always @(*) begin
        r_assembled = r_group_bits;
        r_assembled[r_group_count] = r_input_bit_q;
    end
    function [31:0] qpsk_level(input positive);
        begin
            qpsk_level = positive ? 32'h2d41_3ccd : 32'hd2be_c333;
        end
    endfunction

    function [31:0] qam16_level(input [1:0] pair);
        begin
            case (pair)
                2'b00: qam16_level = 32'hc348_c5d9;
                2'b01: qam16_level = 32'h3cb7_3a27;
                2'b10: qam16_level = 32'hebc2_ec9e;
                default: qam16_level = 32'h143d_1362;
            endcase
        end
    endfunction

    function [31:0] qam64_level(input [2:0] triplet);
        begin
            case (triplet)
                3'b000: qam64_level = 32'hbadf_41e5;
                3'b001: qam64_level = 32'h4520_be1b;
                3'b010: qam64_level = 32'hf61f_e4d8;
                3'b011: qam64_level = 32'h09e0_1b28;
                3'b100: qam64_level = 32'hce9f_7836;
                3'b101: qam64_level = 32'h3160_87ca;
                3'b110: qam64_level = 32'he25f_ae87;
                default: qam64_level = 32'h1da0_5179;
            endcase
        end
    endfunction

    // Isolate the interleaver's distributed-RAM read and last-bit comparator
    // from the mapper's capture control. Every accepted bit keeps its last tag.
    always @(posedge clk_Modulation) begin
        if (reset) begin
            r_input_valid_q <= 0;
            r_input_bit_q <= 0;
            r_input_last_q <= 0;
        end else begin
            r_input_valid_q <= w_accept;
            if (w_accept) begin
                r_input_bit_q <= tx_modulate_in_bit;
                r_input_last_q <= tx_modulate_in_last;
            end
        end
    end

    // Separate BRAM readout from constellation decoding. Delay the entire
    // carrier tag, including pilot polarity, so burst order/cadence is unchanged.
    always @(posedge clk_Modulation) begin
        r_decode_bits <= r_symbol_bits;
        r_decode_slot <= r_slot_count;
        r_decode_modulation <= tx_Modulation;
        r_decode_is_pilot <= w_is_pilot;
        r_decode_polarity <= w_pilot_scramble_value;
        if (reset) r_decode_valid <= 0;
        else r_decode_valid <= r_state == LP_SEND;
    end

    always @(posedge clk_Modulation) begin
        if (!reset && w_push && r_group_count == w_bpsc - 1'b1) r_carriers[r_write_carrier] <= r_assembled;
        // Look ahead one carrier for the synchronous BRAM read. Pilots do
        // not consume a data index; the final pilot still has a following bin.
        r_symbol_bits <= r_carriers[(r_state == LP_SEND && !w_is_pilot && r_slot_count != 51) ?
            r_read_next: r_read_carrier];
        if (reset) begin
            r_state <= LP_LOAD;
            r_group_bits <= 0;
            r_group_count <= 0;
            r_write_carrier <= 0;
            r_read_carrier <= 0;
            r_slot_count <= 0;
            r_final_symbol <= 0;
            r_pilot_addr <= 1;
            r_frame_last <= 0;
            r_launch_count <= 0;
            r_read_next <= 1;
        end else begin
            if (r_launch_count != 0) r_launch_count <= r_launch_count - 1'b1;
            if (w_push) begin
                r_group_bits <= r_assembled;
                if (r_group_count == w_bpsc - 1'b1) begin
                    r_group_bits <= 0;
                    r_group_count <= 0;
                    if (r_input_last_q) begin
                        r_write_carrier <= 0;
                        r_state <= LP_WAIT;
                        r_frame_last <= r_write_carrier;
                    end else r_write_carrier <= r_write_carrier + 1'b1;
                end else r_group_count <= r_group_count + 1'b1;
            end
            if (r_state == LP_WAIT && r_launch_count == 0 && data_start_allowed) begin
                r_state <= LP_SEND;
                r_slot_count <= 0;
                r_launch_count <= tx_Upsample == 2 ? 9'd319 : 9'd159;
            end
            if (r_state == LP_SEND) begin
                if (!w_is_pilot && r_slot_count != 51) begin
                    r_read_carrier <= r_read_next;
                    r_read_next <= r_read_next + 1'b1;
                end
                if (r_slot_count == 51) begin
                    r_state <= r_read_carrier == r_frame_last ? LP_DRAIN : LP_WAIT;
                    r_final_symbol <= r_read_carrier == r_frame_last;
                    r_read_carrier <= r_read_next;
                    r_read_next <= r_read_next + 1'b1;
                    r_pilot_addr <= r_pilot_addr == 126 ? 0 : r_pilot_addr + 1'b1;
                    r_slot_count <= 0;
                end else r_slot_count <= r_slot_count + 1'b1;
            end
            if (r_state == LP_DRAIN && tx_freq_to_timed_cycle_flag) begin
                r_state <= LP_LOAD;
                r_final_symbol <= 0;
                r_pilot_addr <= 1;
                r_read_carrier <= 0;
                r_read_next <= 1;
            end
        end
    end
    always @(*) begin
        tx_modulate_re_out = 0;
        tx_modulate_im_out = 0;
        if (r_decode_valid) begin
            if (r_decode_is_pilot)
                tx_modulate_re_out = (r_decode_polarity ^ (r_decode_slot == 46)) ? LP_BPSK_POS : LP_BPSK_NEG;
            else case (r_decode_modulation)
                    0 : tx_modulate_re_out = r_decode_bits[0] ? LP_BPSK_POS : LP_BPSK_NEG;
                1: begin
                    tx_modulate_re_out = qpsk_level(r_decode_bits[0]);
                    tx_modulate_im_out = qpsk_level(r_decode_bits[1]);
                end
                2: begin
                    tx_modulate_re_out = qam16_level(r_decode_bits[1:0]);
                    tx_modulate_im_out = qam16_level(r_decode_bits[3:2]);
                end
                3: begin
                    tx_modulate_re_out = qam64_level(r_decode_bits[2:0]);
                    tx_modulate_im_out = qam64_level(r_decode_bits[5:3]);
                end
            endcase
        end
    end
    pilot_scramble u_pilot_scramble (
        .clka                                         (clk_Modulation),
        .addra                                        (r_pilot_addr),
        .douta                                        (w_pilot_scramble_value));
    // synthesis translate_off
    always @(posedge clk_Modulation) if (!reset && w_push) begin
        if (r_write_carrier >= MAX_CARRIERS) $fatal(1, "TX constellation index overflow");
        if (r_input_last_q && (r_write_carrier % 48 != 47 || r_group_count != w_bpsc - 1'b1))
            $fatal(1, "TX partial mapper symbol");
    end
// synthesis translate_on
endmodule
