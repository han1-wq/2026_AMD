// Legacy OFDM DATA frontend: BPSK/QPSK/16-QAM/64-QAM, all code rates.
// Packet buffering decouples the sample clock from serial bit processing.
// Store compact decisions/confidences, not raw I/Q/CSI. Retain 64-QAM
// distance-to-boundary confidence through buffering and deinterleaving.
// Parameters may still arrive after the entire packet. Memories are synchronous
// and are not reset; validity/counts fence stale contents after a packet reset.
// Up to 1024 payload bytes, including RS expansion to a 1108-byte PSDU.
module ofdm_data_frontend #(parameter CSI_WIDTH = 16, DATA_WIDTH = 32)(
    input   wire                                        clk                                         ,
    input   wire                                        rst                                         ,
    input   wire                                        params_valid                                ,
    input   wire                                        params_ok                                   ,
    input   wire            [5:0]                       rate                                        ,
    input   wire            [1:0]                       modulation                                  ,
    input   wire            [1:0]                       code_rate                                   ,
    input   wire            [11:0]                      n_symbols                                   ,
    input   wire            [CSI_WIDTH-1:0]             csi_i                                       ,
    input   wire            [CSI_WIDTH-1:0]             csi_q                                       ,
    input   wire            [DATA_WIDTH-1:0]            data_i                                      ,
    input   wire            [DATA_WIDTH-1:0]            data_q                                      ,
    input   wire                                        data_valid                                  ,
    output  reg             [2:0]                       demod_bit                                   ,
    output  reg                                         demod_valid                                 ,
    output  wire            [2:0]                       decoded_a                                   ,
    output  wire            [2:0]                       decoded_b                                   ,
    output  wire            [1:0]                       erased                                      ,
    output  wire                                        decoded_valid                               ,
    input   wire                                        decoded_ready
);
    // 6 Mbps: ceil((16+8*1108+6)/24)=371 symbols, 48 carriers each.
    localparam  integer                             LP_MAX_CARRIERS = 17808;
    localparam  integer                             LP_MAX_CODED_BITS = 33216;
    (* ram_style = "block" *) reg [23:0] r_samples[0:LP_MAX_CARRIERS - 1];
    (* ram_style = "block" *) reg [2:0] r_soft_bits[0:LP_MAX_CODED_BITS - 1];
    reg                 [14:0]                      r_sample_count;
    reg                 [14:0]                      r_sample_read;
    // Keep this control-path register in fabric, not a DSP output register.
    // It fans out into input acceptance and packet-completion comparisons.
    (* use_dsp = "no" *) reg [14:0] r_carrier_target;
    reg                 [14:0]                      r_sample_next;
    reg                                             r_last_sample;
    reg                 [14:0]                      r_committed_count;
    reg                 [15:0]                      r_write_bit_count;
    reg                 [15:0]                      r_symbol_base;
    reg                 [8:0]                       r_trellis_bit;
    reg                 [8:0]                       r_punctured_index;
    reg                 [11:0]                      r_symbol_count;
    reg                 [2:0]                       r_bit_in_carrier;
    reg                 [2:0]                       r_puncture_phase;
    reg                 [1:0]                       r_state;
    reg                 [1:0]                       r_mod_reg;
    reg                 [1:0]                       r_code_reg;
    reg                                             r_params_done;
    reg                 [8:0]                       r_n_cbps;
    reg                 [8:0]                       r_n_dbps;
    reg                 [2:0]                       r_n_bpsc;
    reg                 [11:0]                      r_symbols_reg;
    // Match the original unsized +1 comparisons (no wrap at 4095/511).
    // Zero targets must never terminate on a wrapped counter.
    reg                 [8:0]                       r_last_trellis;
    reg                 [11:0]                      r_last_symbol;
    wire                                            w_accept_sample = !rst && data_valid && r_sample_count < LP_MAX_CARRIERS &&
        (!r_params_done || r_sample_count < r_carrier_target);
    // Input II=1. Split constant multiplies into 16-bit limbs so each DSP
    // product has a register before the wide sum. All comparisons retain the
    // original 25906/53090 constants, strictness, unsigned magnitude and widths.
    reg                 [4:0]                       r_decision_valid;
    reg         signed  [CSI_WIDTH-1:0]             r_hi0;
    reg         signed  [CSI_WIDTH-1:0]             r_hq0;
    reg                 [DATA_WIDTH-1:0]            r_yi0;
    reg                 [DATA_WIDTH-1:0]            r_yq0;
    reg                 [2*CSI_WIDTH-1:0]           r_hi_sq1;
    reg                 [2*CSI_WIDTH-1:0]           r_hq_sq1;
    reg                 [DATA_WIDTH-1:0]            r_abs_i1;
    reg                 [DATA_WIDTH-1:0]            r_abs_q1;
    reg                 [2*CSI_WIDTH:0]             r_power2;
    reg                 [1:0]                       r_signs1;
    reg                 [1:0]                       r_signs2;
    reg                 [1:0]                       r_signs3;
    (* use_dsp = "yes" *) reg [30:0] r_i16_lo2;
    reg                 [DATA_WIDTH-16+15-1:0]      r_i16_hi2;
    reg                 [30:0]                      r_q16_lo2;
    reg                 [DATA_WIDTH-16+15-1:0]      r_q16_hi2;
    (* use_dsp = "yes" *) reg [31:0] r_i64_lo2;
    reg                 [DATA_WIDTH-16+16-1:0]      r_i64_hi2;
    reg                 [31:0]                      r_q64_lo2;
    reg                 [DATA_WIDTH-1:0]            r_q64_hi2;
    reg                 [DATA_WIDTH+14:0]           r_i16_3;
    reg                 [DATA_WIDTH+14:0]           r_q16_3;
    reg                 [2*CSI_WIDTH+15:0]         r_threshold6_3;
    reg                 [DATA_WIDTH+15:0]           r_i64_3;
    reg                 [DATA_WIDTH+15:0]           r_q64_3;
    reg                 [2*CSI_WIDTH+13:0]         r_threshold2_3;
    reg                 [2*CSI_WIDTH+14:0]         r_threshold4_3;
    // A constellation step is power*4096 in the |Y|*53090 domain.
    // Quantize distance from the nearest bit boundary at 1/2, 1, 3/2
    // steps. No division; normalize confidence to the carrier's CSI.
    localparam integer LP_METRIC_WIDTH = (DATA_WIDTH+16 > 2*CSI_WIDTH+16) ?
        DATA_WIDTH+16 : 2*CSI_WIDTH+16;
    function [2:0] f_soft64;
        input positive;
        input [LP_METRIC_WIDTH-1:0] distance;
        input [LP_METRIC_WIDTH-1:0] step;
        reg [LP_METRIC_WIDTH+1:0] distance4, step3;
        reg [1:0] confidence;
        begin
            distance4 = {distance, 2'b00};
            step3 = {2'b00, step} + {1'b0, step, 1'b0};
            if (step == 0) confidence = 0;
            else if (distance4 >= step3) confidence = 3;
            else if (distance4 >= {1'b0, step, 1'b0}) confidence = 2;
            else if (distance4 >= {2'b00, step}) confidence = 1;
            else confidence = 0;
            f_soft64 = positive ? 3'd4 + {1'b0, confidence} :
                                  3'd3 - {1'b0, confidence};
        end
    endfunction
    function [2:0] f_middle64;
        input [LP_METRIC_WIDTH-1:0] magnitude, boundary, step;
        begin
            f_middle64 = f_soft64(magnitude < boundary,
                magnitude < boundary ? boundary-magnitude : magnitude-boundary, step);
        end
    endfunction
    function [2:0] f_inner64;
        input [LP_METRIC_WIDTH-1:0] magnitude, low_boundary, high_boundary, step;
        reg [LP_METRIC_WIDTH-1:0] distance;
        begin
            if (magnitude < low_boundary) distance = low_boundary-magnitude;
            else if (magnitude >= high_boundary) distance = magnitude-high_boundary;
            else distance = magnitude-low_boundary < high_boundary-magnitude ?
                            magnitude-low_boundary : high_boundary-magnitude;
            f_inner64 = f_soft64(magnitude >= low_boundary && magnitude < high_boundary,
                                distance, step);
        end
    endfunction
    reg                 [23:0]                      r_decisions4;
    always @(posedge clk) begin
        if (rst) r_decision_valid <= 0;
        else r_decision_valid <= {r_decision_valid[3:0], w_accept_sample};
        r_hi0 <= csi_i;
        r_hq0 <= csi_q;
        r_yi0 <= data_i;
        r_yq0 <= data_q;
        r_hi_sq1 <= r_hi0 * r_hi0;
        r_hq_sq1 <= r_hq0 * r_hq0;
        r_abs_i1 <= r_yi0[DATA_WIDTH-1] ? - r_yi0: r_yi0;
        r_abs_q1 <= r_yq0[DATA_WIDTH-1] ? - r_yq0: r_yq0;
        r_signs1 <= {~r_yq0[DATA_WIDTH-1], ~r_yi0[DATA_WIDTH-1]};
        r_power2 <= r_hi_sq1 + r_hq_sq1;
        r_i16_lo2 <= r_abs_i1[15:0] * 15'd25906;
        r_i16_hi2 <= r_abs_i1[DATA_WIDTH-1:16] * 15'd25906;
        r_q16_lo2 <= r_abs_q1[15:0] * 15'd25906;
        r_q16_hi2 <= r_abs_q1[DATA_WIDTH-1:16] * 15'd25906;
        r_i64_lo2 <= r_abs_i1[15:0] * 16'd53090;
        r_i64_hi2 <= r_abs_i1[DATA_WIDTH-1:16] * 16'd53090;
        r_q64_lo2 <= r_abs_q1[15:0] * 16'd53090;
        r_q64_hi2 <= r_abs_q1[DATA_WIDTH-1:16] * 16'd53090;
        r_signs2 <= r_signs1;
        r_i16_3 <= {r_i16_hi2, 16'd0} + {16'd0, r_i16_lo2};
        r_q16_3 <= {r_q16_hi2, 16'd0} + {16'd0, r_q16_lo2};
        r_i64_3 <= {r_i64_hi2, 16'd0} + {16'd0, r_i64_lo2};
        r_q64_3 <= {r_q64_hi2, 16'd0} + {16'd0, r_q64_lo2};
        r_threshold2_3 <= {r_power2, 13'd0};
        r_threshold4_3 <= {r_power2, 14'd0};
        r_threshold6_3 <= {1'b0, r_power2, 14'd0} + {2'd0, r_power2, 13'd0};
        r_signs3 <= r_signs2;
        r_decisions4 <= {
        f_inner64(r_q64_3, r_threshold2_3, r_threshold6_3, r_threshold2_3),
        f_middle64(r_q64_3, r_threshold4_3, r_threshold2_3),
        {3{r_q16_3 < r_threshold2_3}},
        f_soft64(r_signs3[1], r_q64_3, r_threshold2_3),
        f_inner64(r_i64_3, r_threshold2_3, r_threshold6_3, r_threshold2_3),
        f_middle64(r_i64_3, r_threshold4_3, r_threshold2_3),
        {3{r_i16_3 < r_threshold2_3}},
        f_soft64(r_signs3[0], r_i64_3, r_threshold2_3)};
    end
    always @(posedge clk) begin
        if (!rst && r_decision_valid[4]) r_samples[r_committed_count] <= r_decisions4;
    end

    reg                 [23:0]                      r_sample_word;
    wire                                            w_last_carrier_bit = r_bit_in_carrier + 1'b1 == r_n_bpsc;
    wire                [14:0]                      w_prefetch_sample = r_state == 1 && w_last_carrier_bit && !r_last_sample ?
        r_sample_next: r_sample_read;
    // Look ahead on the final bit, including BPSK (one new carrier per clock).
    always @(posedge clk) r_sample_word <= r_samples[w_prefetch_sample];
    reg                 [17:0]                      r_carrier_bits;
    always @(*) begin
        case (r_mod_reg)
            0: r_carrier_bits = {15'd0, {3{r_sample_word[2]}}};
            1: r_carrier_bits = {12'd0, {3{r_sample_word[14]}}, {3{r_sample_word[2]}}};
            2: r_carrier_bits = {6'd0, r_sample_word[17:15], {3{r_sample_word[14]}},
                                r_sample_word[5:3], {3{r_sample_word[2]}}};
            3: r_carrier_bits = {r_sample_word[23:21], r_sample_word[20:18],
                                r_sample_word[14:12], r_sample_word[11:9],
                                r_sample_word[8:6], r_sample_word[2:0]};
        endcase
    end
    wire [2:0] w_soft_bit = r_carrier_bits[3*r_bit_in_carrier +: 3];

    // Constant, synchronous dual-read ROM; division/modulo exist ONLY in the
    // elaboration-time initializer. Concatenated addresses avoid a barrel mux.
    (* rom_style = "block" *) reg [8:0] r_interleave_map[0:2047];
    integer map_mode, map_k, map_i, map_cbps, map_step, map_bpsc;
    initial begin
        for (map_mode = 0; map_mode < 4; map_mode = map_mode + 1) begin
            case (map_mode)
                0: map_bpsc = 1;
                1: map_bpsc = 2;
                2: map_bpsc = 4;
                3: map_bpsc = 6;
            endcase
            map_cbps = 48 * map_bpsc;
            map_step = map_bpsc / 2;
            if (map_step == 0) map_step = 1;
            for (map_k = 0; map_k < 512; map_k = map_k + 1) begin
                map_i = (map_cbps / 16) * (map_k % 16) + map_k / 16;
                r_interleave_map[map_mode * 512 + map_k] = map_k < map_cbps ?
                    map_step * (map_i / map_step) +
                    (map_i + map_cbps - (16 * map_i) / map_cbps) % map_step: 0;
            end
        end
    end
    wire                                            w_erase_a = r_code_reg == 2 && r_puncture_phase == 2;
    wire                                            w_erase_b = (r_code_reg == 1 || r_code_reg == 2) && r_puncture_phase == 1;
    wire                [1:0]                       w_used_bits = {1'b0, !w_erase_a} + {1'b0, !w_erase_b};
    wire                [8:0]                       w_index_b = r_punctured_index + {8'd0, !w_erase_a};
    reg                 [8:0]                       r_mapped_a;
    reg                 [8:0]                       r_mapped_b;
    reg                 [15:0]                      r_mapped_base;
    reg                 [15:0]                      r_addr_a;
    reg                 [15:0]                      r_addr_b;
    reg                 [1:0]                       r_mapped_erased;
    reg                 [1:0]                       r_addr_erased;
    reg                                             r_mapped_valid;
    reg                                             r_addr_valid;
    reg                 [2:0]                       r_bit_a;
    reg                 [2:0]                       r_bit_b;
    reg                                             r_out_valid;
    reg                 [1:0]                       r_out_erased;
    // Globally stalled pipeline. When its output is full every RAM register,
    // address, valid and erasure bit freezes together. II=1 when ready is high.
    wire                                            w_advance = !rst && (!r_out_valid || decoded_ready);
    wire                                            w_fetch_pair = w_advance && r_state == 2;
    always @(posedge clk) begin
        if (w_advance) begin
            r_mapped_a <= r_interleave_map[{r_mod_reg, r_punctured_index}];
            r_mapped_b <= r_interleave_map[{r_mod_reg, w_index_b}];
            r_mapped_base <= r_symbol_base;
            r_addr_a <= r_mapped_base + r_mapped_a;
            r_addr_b <= r_mapped_base + r_mapped_b;
        end
    end
    // Register the decision before writing RAM: avoid a BRAM-to-BRAM path
    // through the modulation/bit selector. The final write drains while the
    // first pair traverses the map/address stages, before either RAM read.
    // Port A writes then reads; port B reads only (no third RAM port).
    wire                                            w_store_bit = !rst && demod_valid;
    wire                [15:0]                      w_port_a_addr = w_store_bit ? r_write_bit_count: r_addr_a;
    always @(posedge clk) begin
        if (w_store_bit) r_soft_bits[w_port_a_addr] <= demod_bit;
        else if (w_advance && r_addr_valid) r_bit_a <= r_soft_bits[w_port_a_addr];
    end
    always @(posedge clk) begin
        if (w_advance && r_addr_valid) r_bit_b <= r_soft_bits[r_addr_b];
    end
    assign decoded_a = r_out_erased[0] ? 3'd3: r_bit_a;
    assign decoded_b = r_out_erased[1] ? 3'd3: r_bit_b;
    assign erased = r_out_erased;
    assign decoded_valid = r_out_valid;

    always @(posedge clk) begin
        if (rst) begin
            r_sample_count <= 0;
            r_sample_read <= 0;
            r_carrier_target <= 0;
            r_sample_next <= 1;
            r_last_sample <= 0;
            r_committed_count <= 0;
            r_write_bit_count <= 0;
            r_symbol_base <= 0;
            r_trellis_bit <= 0;
            r_punctured_index <= 0;
            r_symbol_count <= 0;
            r_bit_in_carrier <= 0;
            r_puncture_phase <= 0;
            r_state <= 0;
            r_mod_reg <= 0;
            r_code_reg <= 0;
            r_params_done <= 0;
            r_n_cbps <= 48;
            r_n_dbps <= 24;
            r_n_bpsc <= 1;
            r_symbols_reg <= 0;
            r_last_trellis <= 23;
            r_last_symbol <= 0;
            demod_bit <= 0;
            demod_valid <= 0;
            r_out_valid <= 0;
            r_out_erased <= 0;
            r_mapped_valid <= 0;
            r_addr_valid <= 0;
            r_mapped_erased <= 0;
            r_addr_erased <= 0;
        end else begin
            demod_valid <= 0;
            if (w_advance) begin
                r_mapped_valid <= r_state == 2;
                r_addr_valid <= r_mapped_valid;
                r_out_valid <= r_addr_valid;
                r_mapped_erased <= {w_erase_b, w_erase_a};
                r_addr_erased <= r_mapped_erased;
                r_out_erased <= r_addr_erased;
            end
            if (params_valid && params_ok) begin
                r_params_done <= 1;
                r_mod_reg <= modulation;
                r_code_reg <= code_rate;
                r_carrier_target <= (n_symbols << 5) + (n_symbols << 4);
                r_symbols_reg <= n_symbols;
                r_n_dbps <= {3'd0, rate} << 2;
                r_last_trellis <= ({3'd0, rate} << 2) - 1'b1;
                r_last_symbol <= n_symbols - 1'b1;
                case (modulation)
                    0: begin
                        r_n_bpsc <= 1;
                        r_n_cbps <= 48;
                    end
                    1: begin
                        r_n_bpsc <= 2;
                        r_n_cbps <= 96;
                    end
                    2: begin
                        r_n_bpsc <= 4;
                        r_n_cbps <= 192;
                    end
                    3: begin
                        r_n_bpsc <= 6;
                        r_n_cbps <= 288;
                    end
                endcase
            end
            if (w_accept_sample) r_sample_count <= r_sample_count + 1'b1;
            if (r_decision_valid[4]) r_committed_count <= r_committed_count + 1'b1;
            if (w_store_bit) r_write_bit_count <= r_write_bit_count + 1'b1;
            if (r_state == 0 && r_params_done && r_committed_count >= r_carrier_target) begin
                r_state <= 1;
                r_last_sample <= r_carrier_target == 1;
            end
            if (r_state == 1) begin
                demod_bit <= w_soft_bit;
                demod_valid <= 1;
                if (r_bit_in_carrier + 1 == r_n_bpsc) begin
                    r_bit_in_carrier <= 0;
                    r_sample_read <= r_sample_read + 1'b1;
                    r_sample_next <= r_sample_next + 1'b1;
                    r_last_sample <= r_sample_next + 1'b1 == r_carrier_target;
                    if (r_last_sample) r_state <= 2;
                end else r_bit_in_carrier <= r_bit_in_carrier + 1'b1;
            end
            // Advance on RAM issue, not on acceptance of the previous output.
            // A full output register freezes both memory ports and metadata.
            if (w_fetch_pair) begin
                r_punctured_index <= r_punctured_index + w_used_bits;
                r_trellis_bit <= r_trellis_bit + 1'b1;
                if (r_code_reg == 1) r_puncture_phase <= r_puncture_phase == 1 ? 0: 1;
                else if (r_code_reg == 2) r_puncture_phase <= r_puncture_phase == 2 ? 0: r_puncture_phase + 1'b1;
                if (r_n_dbps != 0 && r_trellis_bit == r_last_trellis) begin
                    r_trellis_bit <= 0;
                    r_punctured_index <= 0;
                    r_puncture_phase <= 0;
                    r_symbol_base <= r_symbol_base + r_n_cbps;
                    r_symbol_count <= r_symbol_count + 1'b1;
                    if (r_symbols_reg != 0 && r_symbol_count == r_last_symbol) r_state <= 3;
                end
            end
        end
    end
endmodule
