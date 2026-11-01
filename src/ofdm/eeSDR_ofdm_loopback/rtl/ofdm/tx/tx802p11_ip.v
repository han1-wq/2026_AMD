`timescale 1ns/1ps
// Single-clock integration boundary. Packet ingress accepts arbitrary gaps;
// the legacy encoder receives a contiguous replay. Packet metadata is sampled
// only with cmd_valid && cmd_ready. No overlap or asynchronous CDC is implied.
module tx802p11_ip #(
    parameter RS_ENABLE = 1'b1,
    parameter RS_INTERLEAVE = 1'b1
) (
    input   wire                            clk                                             ,
    input   wire                            reset                                           ,
    input   wire                            cmd_valid                                       ,
    output  wire                            cmd_ready                                       ,
    input   wire    [10:0]                  cmd_length                                      ,
    input   wire    [5:0]                   cmd_rate                                        ,
    input   wire    [1:0]                   cmd_upsample                                    ,
    input   wire                            s_valid                                         ,
    input   wire                            s_last                                          ,
    input   wire    [7:0]                   s_data                                          ,
    output  wire                            s_ready                                         ,
    output  wire                            m_valid                                         ,
    output  wire    [15:0]                  m_re                                            ,
    output  wire    [15:0]                  m_im                                            ,
    output  wire                            busy                                            ,
    output  reg                             done                                            ,
    output  reg     [1:0]                   error
);
    localparam                                  LP_IDLE = 0;
    localparam                                  LP_CAPTURE = 1;
    localparam                                  LP_PRIME = 2;
    localparam                                  LP_REPLAY = 3;
    localparam                                  LP_DRAIN = 4;
    reg                 [2:0]                   r_state;
    reg                 [10:0]                  r_length_q;
    reg                 [10:0]                  r_wr_count;
    reg                 [10:0]                  r_rd_count;
    reg                 [5:0]                   r_rate_q;
    reg                 [1:0]                   r_up_q;
    reg                 [1:0]                   r_code_q;
    reg                 [1:0]                   r_modulation_q;
    // Hold reset through IP reset recovery. Caller may keep reset high longer.
    reg                 [5:0]                   r_recovery;
    // The packet-buffered RS receiver needs time to finish correction and CRC.
    // Enforce the same fixed guard on both peers, including error-free frames.
    // 32768 clocks = 409.6 us at 80 MHz; done still marks the last RF sample.
    reg [15:0] r_rs_guard;
    wire                                        w_core_reset = reset;
    (* ram_style = "block" *) reg [7:0] r_packet_mem[0:1023];
    reg                 [7:0]                   r_byte_q;
    reg                                         r_replay_valid;
    reg                                         r_replay_start;
    reg                                         r_replay_end;
    wire                                        w_core_done;
    wire                                        w_supported_rate = cmd_rate == 6 || cmd_rate == 9 || cmd_rate == 12 ||
        cmd_rate == 18 || cmd_rate == 24 || cmd_rate == 36 ||
        cmd_rate == 48 || cmd_rate == 54;
    assign busy = r_state != LP_IDLE || w_core_reset || r_recovery != 0 || r_rs_guard != 0;
    assign cmd_ready = !busy;
    assign s_ready = r_state == LP_CAPTURE && !w_core_reset;
    always @(posedge clk) begin
        if (reset) r_recovery <= 63;
        else if (r_recovery != 0) r_recovery <= r_recovery - 1'b1;
        if (reset) r_rs_guard <= 0;
        else if (RS_ENABLE && r_state == LP_DRAIN && w_core_done) r_rs_guard <= 32768;
        else if (r_rs_guard != 0) r_rs_guard <= r_rs_guard - 1'b1;
        if (s_valid && s_ready) r_packet_mem[r_wr_count[9:0]] <= s_data;
        if (r_state == LP_REPLAY) r_byte_q <= r_packet_mem[r_rd_count[9:0]];
        if (w_core_reset) begin
            r_state <= LP_IDLE;
            r_wr_count <= 0;
            r_rd_count <= 0;
            r_replay_valid <= 0;
            r_replay_start <= 0;
            r_replay_end <= 0;
            done <= 0;
            error <= 0;
            r_length_q <= 0;
            r_rate_q <= 6;
            r_up_q <= 0;
            r_code_q <= 0;
            r_modulation_q <= 0;
        end else begin
            done <= 0;
            r_replay_valid <= r_state == LP_REPLAY;
            r_replay_start <= r_state == LP_REPLAY && r_rd_count == 0;
            r_replay_end <= r_state == LP_REPLAY && r_rd_count == r_length_q - 1'b1;
            case (r_state)
                LP_IDLE: if (cmd_valid && cmd_ready) begin
                    error <= 0;
                    if (!w_supported_rate || cmd_length == 0 || cmd_length > 1024) begin
                        error <= 1;
                        done <= 1;
                    end else begin
                        r_length_q <= cmd_length;
                        r_rate_q <= cmd_rate;
                        r_up_q <= cmd_upsample;
                        case (cmd_rate)
                            6, 9: r_modulation_q <= 0;
                            12, 18: r_modulation_q <= 1;
                            24, 36: r_modulation_q <= 2;
                            default: r_modulation_q <= 3;
                        endcase
                        case (cmd_rate)
                            6, 12, 24: r_code_q <= 0;
                            48: r_code_q <= 1;
                            default: r_code_q <= 2;
                        endcase
                        r_wr_count <= 0;
                        r_state <= LP_CAPTURE;
                    end
                end
                LP_CAPTURE: if (s_valid) begin
                    if (s_last != (r_wr_count == r_length_q - 1'b1)) begin
                        error <= 2;
                        done <= 1;
                        r_state <= LP_IDLE;
                    end else if (s_last) r_state <= LP_PRIME;
                    else r_wr_count <= r_wr_count + 1'b1;
                end
                LP_PRIME: begin
                    r_rd_count <= 0;
                    r_state <= LP_REPLAY;
                end
                LP_REPLAY: begin
                    if (r_rd_count == r_length_q - 1'b1) r_state <= LP_DRAIN;
                    else r_rd_count <= r_rd_count + 1'b1;
                end
                LP_DRAIN: if (w_core_done) begin
                    done <= 1;
                    r_state <= LP_IDLE;
                end
                default: r_state <= LP_IDLE;
            endcase
        end
    end
    // Fixed sample cadence has no output backpressure. Connect to a consumer
    // that accepts every m_valid beat; an external CDC requires its own FIFO.
    Tx802p11 #(.RS_ENABLE(RS_ENABLE), .RS_INTERLEAVE(RS_INTERLEAVE)) u_core (
        .clk_User                                     (clk),
        .clk_Modulation                               (clk),
        .reset                                        (w_core_reset),
        .tx_Upsample                                  (r_up_q),
        .tx_Rate                                      (r_rate_q),
        .tx_ConvCodeRate                              (r_code_q),
        .tx_Modulation                                (r_modulation_q),
        .packetlength                                 ({5'd0, r_length_q}),
        .user_tx_data_start                           (r_replay_start),
        .user_tx_data_end                             (r_replay_end),
        .user_tx_data_valid                           (r_replay_valid),
        .user_tx_data                                 (r_byte_q),
        .tx_802p11_out_valid                          (m_valid),
        .tx_802p11_re_out                             (m_re),
        .tx_802p11_im_out                             (m_im),
        .tx_done                                      (w_core_done)
    );
endmodule
