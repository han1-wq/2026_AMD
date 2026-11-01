`timescale 1ns/1ps
// Ordered PREAMBLE -> SIGNAL -> DATA elastic sample queue.
// The mapper issues a symbol every 160/320 clocks. Start after one DATA
// symbol is buffered; preamble/SIGNAL provide additional latency reserve.
module tx_out_arrange (
    input   wire                            clk_Modulation                                  ,
    input   wire                            reset                                           ,
    input   wire    [1:0]                   tx_Upsample                                     ,
    input   wire                            user_tx_data_start                              ,
    input   wire                            tx_add_cyclic_prefix_valid                      ,
    input   wire                            tx_add_cyclic_prefix_end                        ,
    input   wire    [15:0]                  tx_add_cyclic_prefix_re                         ,
    input   wire    [15:0]                  tx_add_cyclic_prefix_im                         ,
    input   wire                            tx_gen_sig_add_cyclic_prefix_valid              ,
    input   wire    [15:0]                  tx_gen_sig_add_cyclic_prefix_re                 ,
    input   wire    [15:0]                  tx_gen_sig_add_cyclic_prefix_im                 ,
    output  reg                             preamble_ready                                  ,
    output  wire                            data_start_allowed                              ,
    output  wire                            tx_802p11_out_valid                             ,
    output  wire    [15:0]                  tx_802p11_re_out                                ,
    output  wire    [15:0]                  tx_802p11_im_out                                ,
    output  reg                             frame_done
);
    // 1108 encoded PSDU bytes + SERVICE + TAIL at 6 Mbps: 371 DATA
    // symbols, 80 samples/symbol, and at most two samples per input.
    localparam  integer                         LP_MAX_DATA_SAMPLES = 371 * 80 * 2;
    localparam  integer                         LP_MAX_SAMPLES = 2048;
    (* ram_style = "block" *) reg [31:0] r_wave_mem[0:LP_MAX_SAMPLES - 1];
    reg                 [15:0]                  r_write_count;
    reg                 [9:0]                   r_pre_count;
    reg                 [9:0]                   r_preamble_rom_addr;
    reg                 [7:0]                   r_sig_count;
    reg                 [15:0]                  r_data_count;
    reg                 [15:0]                  r_read_count;
    reg                 [15:0]                  r_frame_last;
    reg                                         r_read_rom;
    reg                                         r_read_rom_d;
    reg                                         r_rom_valid;
    reg                                         r_up2;
    reg                                         r_pre_phase;
    reg                                         r_sig_phase;
    reg                                         r_data_phase;
    reg                                         r_pre_done;
    reg                                         r_sig_done;
    reg                                         r_data_done;
    reg                                         r_sending;
    reg                                         r_cycle_cnt;
    wire                [15:0]                  w_preamble_re;
    wire                [15:0]                  w_preamble_im;
    reg                 [31:0]                  r_output_sample;
    reg                 [31:0]                  r_write_word_q;
    reg                 [15:0]                  r_write_addr_q;
    reg                                         r_write_valid_q;
    assign data_start_allowed = r_sig_done;
    // Preserve useful diagnostic names used by the transaction extractor.
    wire                [2:0]                   w_fifo_in_state = r_sending ? 4 : (!r_pre_done ? 1 : (!r_sig_done ? 2 : 3));
    wire                [17:0]                  w_cnt = r_write_count;
    wire                                        w_fifo_in_valid = (r_rom_valid && (r_up2 || r_pre_phase)) ||
        (tx_gen_sig_add_cyclic_prefix_valid && (r_up2 || r_sig_phase)) ||
        (tx_add_cyclic_prefix_valid && (r_up2 || r_data_phase));
    assign tx_802p11_out_valid = r_sending && r_cycle_cnt;
    assign tx_802p11_re_out = r_output_sample[15:0];
    assign tx_802p11_im_out = r_output_sample[31:16];
    wire                                        w_pre_write = r_rom_valid && (r_up2 || r_pre_phase);
    wire                                        w_sig_write = tx_gen_sig_add_cyclic_prefix_valid && (r_up2 || r_sig_phase);
    wire                                        w_data_write = tx_add_cyclic_prefix_valid && (r_up2 || r_data_phase);
    wire                [31:0]                  w_pre_word = {w_preamble_im, w_preamble_re};
    wire                [31:0]                  w_sig_word = {tx_gen_sig_add_cyclic_prefix_im, tx_gen_sig_add_cyclic_prefix_re};
    wire                [31:0]                  w_data_word = {tx_add_cyclic_prefix_im, tx_add_cyclic_prefix_re};
    wire                [31:0]                  w_capture_word = w_pre_write ? w_pre_word : w_sig_write ? w_sig_word : w_data_word;
    // Capture the write transaction before the wide waveform BRAM bank.
    // Frame replay begins only after DATA capture has completed.
    always @(posedge clk_Modulation) begin
        if (reset || user_tx_data_start) r_write_valid_q <= 0;
        else begin
            r_write_valid_q <= w_fifo_in_valid;
            if (w_fifo_in_valid) begin
                r_write_addr_q <= r_write_count;
                r_write_word_q <= r_up2 ? w_capture_word:
                    {w_capture_word[30:16], 1'b0, w_capture_word[14:0], 1'b0};
            end
        end
        if (!reset && !user_tx_data_start && r_write_valid_q)
            r_wave_mem[r_write_addr_q[10:0]] <= r_write_word_q;
        if (r_sending && !r_cycle_cnt) r_output_sample <= r_wave_mem[r_read_count[10:0]];
    end
    always @(posedge clk_Modulation) begin
        if (reset || user_tx_data_start) r_write_count <= 0;
        else if (w_fifo_in_valid) r_write_count <= r_write_count + 1'b1;
    end
    // synthesis translate_off
    always @(posedge clk_Modulation) if (!reset) begin
        if ((w_pre_write && w_sig_write) || (w_pre_write && w_data_write) || (w_sig_write && w_data_write))
            $fatal(1, "TX waveform capture collision");
        if (w_fifo_in_valid && (r_write_count - r_read_count >= LP_MAX_SAMPLES - 1))
            $fatal(1, "TX sample queue overflow");
        if (r_sending && !r_cycle_cnt && r_read_count >= r_write_count - 1)
            if (!(r_data_done && r_read_count == r_frame_last))
            $fatal(1, "TX sample queue underflow");
        if (w_data_write && !r_sig_done) $fatal(1, "TX DATA before SIGNAL");
    end
    // synthesis translate_on
    always @(posedge clk_Modulation) begin
        if (reset) begin
            r_pre_count <= 0;
            r_sig_count <= 0;
            r_data_count <= 0;
            r_read_count <= 0;
            r_frame_last <= 0;
            r_preamble_rom_addr <= 0;
            r_read_rom <= 0;
            r_read_rom_d <= 0;
            r_rom_valid <= 0;
            r_pre_phase <= 0;
            r_sig_phase <= 0;
            r_data_phase <= 0;
            r_pre_done <= 0;
            r_sig_done <= 0;
            r_data_done <= 0;
            r_sending <= 0;
            r_cycle_cnt <= 0;
            preamble_ready <= 0;
            r_up2 <= 0;
            frame_done <= 0;
        end else begin
            frame_done <= 0;
            preamble_ready <= 0;
            r_read_rom_d <= r_read_rom;
            r_rom_valid <= r_read_rom_d;
            if (user_tx_data_start) begin
                r_pre_count <= 0;
                r_sig_count <= 0;
                r_data_count <= 0;
                r_read_count <= 0;
                r_pre_done <= 0;
                r_sig_done <= 0;
                r_data_done <= 0;
                r_sending <= 0;
                r_pre_phase <= 0;
                r_sig_phase <= 0;
                r_data_phase <= 0;
                r_read_rom <= 1;
                r_preamble_rom_addr <= 0;
                r_up2 <= tx_Upsample == 2;
            end else if (r_read_rom) begin
                if (r_preamble_rom_addr == 639) r_read_rom <= 0;
                else r_preamble_rom_addr <= r_preamble_rom_addr + 1'b1;
            end
            if (r_rom_valid) begin
                r_pre_phase <= ~r_pre_phase;
                if (r_up2 || r_pre_phase) begin
                    r_pre_count <= r_pre_count + 1'b1;
                end
                if (!r_read_rom_d) begin
                    r_pre_done <= 1;
                    preamble_ready <= 1;
                end
            end
            if (tx_gen_sig_add_cyclic_prefix_valid) begin
                r_sig_phase <= ~r_sig_phase;
                if (r_up2 || r_sig_phase) begin
                    r_sig_count <= r_sig_count + 1'b1;
                    if (r_sig_count == (r_up2 ? 159 : 79)) r_sig_done <= 1;
                end
            end else r_sig_phase <= 0;
            if (tx_add_cyclic_prefix_valid) begin
                r_data_phase <= ~r_data_phase;
                if ((r_up2 || r_data_phase) && r_data_count < LP_MAX_DATA_SAMPLES) begin
                    r_data_count <= r_data_count + 1'b1;
                end
            end else r_data_phase <= 0;
            if (tx_add_cyclic_prefix_end) begin
                r_data_done <= 1;
                r_frame_last <= r_write_count - 1'b1;
            end
            if (r_pre_done && r_sig_done && r_data_count >= (r_up2 ? 160 : 80) && !r_sending && !r_data_done) begin
                r_sending <= 1;
                r_read_count <= 0;
                r_cycle_cnt <= 0;
            end else if (r_sending) begin
                r_cycle_cnt <= ~r_cycle_cnt;
                if (r_cycle_cnt) begin
                    if (r_data_done && r_read_count == r_frame_last) begin
                        r_sending <= 0;
                        r_pre_done <= 0;
                        r_sig_done <= 0;
                        frame_done <= 1;
                    end
                    else r_read_count <= r_read_count + 1'b1;
                end
            end else r_cycle_cnt <= 0;
        end
    end
    blk_mem_preamble_re u_blk_p_re (
        .clka                                         (clk_Modulation),
        .addra                                        (r_preamble_rom_addr),
        .douta                                        (w_preamble_re));
    blk_mem_preamble_im u_blk_p_im (
        .clka                                         (clk_Modulation),
        .addra                                        (r_preamble_rom_addr),
        .douta                                        (w_preamble_im));
endmodule
