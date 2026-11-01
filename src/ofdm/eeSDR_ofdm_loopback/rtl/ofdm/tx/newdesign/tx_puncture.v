// One sequential mother-code store isolates the unstallable encoder.
// RS maximum PSDU=1108 bytes: 16+8*1108+6=8886 data bits before
// OFDM padding, at most ceil(8886/216)*216=9072 mother-code pairs.
// Synchronous single-address reads infer BRAM.
// in_end is a pulse AFTER the final input pair; out_last travels with data.
module tx_puncture (
    input   wire                            clk_Modulation                                  ,
    input   wire                            reset                                           ,
    input   wire    [1:0]                   tx_ConvCodeRate                                 ,
    input   wire                            tx_conv_valid                                   ,
    input   wire                            in_end                                          ,
    input   wire    [1:0]                   tx_conv_bit                                     ,
    input   wire                            out_ready                                       ,
    output  wire                            tx_puncture_valid                               ,
    output  wire                            tx_puncture_bit                                 ,
    output  wire                            out_last                                        ,
    output  reg                             tx_puncture_bit_cnt_valid                       ,
    output  reg     [15:0]                  tx_puncture_bit_cnt
);
    localparam MAX_PAIRS = 9072;
    (* ram_style = "block" *) reg [1:0] r_code_mem[0:MAX_PAIRS-1];
    reg                 [13:0]                  r_wr_count;
    reg                 [13:0]                  r_rd_index;
    reg                 [13:0]                  r_frame_last_index;
    reg                 [1:0]                   r_pair_data;
    reg                 [1:0]                   r_pair_phase;
    reg                 [1:0]                   r_rate;
    localparam                                  LP_IDLE = 0;
    localparam                                  LP_FETCH = 1;
    localparam                                  LP_A = 2;
    localparam                                  LP_B = 3;
    reg                 [1:0]                   r_state;
    wire                                        w_keep_a = !(r_rate == 2 && r_pair_phase == 2);
    wire                                        w_keep_b = r_rate == 0 || r_pair_phase == 0 || (r_rate == 2 && r_pair_phase == 2);
    assign tx_puncture_valid = (r_state == LP_A && w_keep_a) || (r_state == LP_B && w_keep_b);
    assign tx_puncture_bit = r_state == LP_A ? r_pair_data[1] : r_pair_data[0];
    assign out_last = tx_puncture_valid && r_rd_index == r_frame_last_index &&
        (r_state == LP_B || (r_state == LP_A && !w_keep_b));
    wire                                        w_fire = tx_puncture_valid && out_ready;
    always @(posedge clk_Modulation) begin
        if (!reset && tx_conv_valid && r_wr_count<MAX_PAIRS) r_code_mem[r_wr_count] <= tx_conv_bit;
        if (r_state == LP_FETCH) r_pair_data <= r_code_mem[r_rd_index];
    end
    always @(posedge clk_Modulation) begin
        if (reset) begin
            r_wr_count <= 0;
            r_rd_index <= 0;
            r_frame_last_index <= 0;
            r_pair_phase <= 0;
            r_rate <= 0;
            r_state <= LP_IDLE;
            tx_puncture_bit_cnt <= 0;
            tx_puncture_bit_cnt_valid <= 0;
        end else begin
            tx_puncture_bit_cnt_valid <= 0;
            if (tx_conv_valid) begin
                r_wr_count <= r_wr_count + 1'b1;
                r_rate <= tx_ConvCodeRate;
            end
            if (in_end) begin
                r_state <= LP_FETCH;
                r_rd_index <= 0;
                r_frame_last_index <= r_wr_count - 1'b1;
                r_pair_phase <= 0;
                tx_puncture_bit_cnt <= 0;
            end
            if (r_state == LP_FETCH) r_state <= LP_A;
            if (r_state == LP_A && (!w_keep_a || out_ready)) r_state <= LP_B;
            if (w_fire) tx_puncture_bit_cnt <= tx_puncture_bit_cnt + 1'b1;
            if (r_state == LP_B && (!w_keep_b || out_ready)) begin
                if (r_rd_index == r_frame_last_index) begin
                    r_state <= LP_IDLE;
                    r_wr_count <= 0;
                    tx_puncture_bit_cnt_valid <= 1;
                end else begin
                    r_rd_index <= r_rd_index + 1'b1;
                    r_state <= LP_FETCH;
                    if (r_rate == 0 || (r_rate == 1 && r_pair_phase == 1) ||
                            (r_rate == 2 && r_pair_phase == 2)) r_pair_phase <= 0;
                    else r_pair_phase <= r_pair_phase + 1'b1;
                end
            end
        end
    end
    // synthesis translate_off
    always @(posedge clk_Modulation) if (!reset) begin
        if (tx_conv_valid && (r_wr_count >= MAX_PAIRS || r_state != LP_IDLE))
            $fatal(1, "TX mother-code overflow/overlap");
        if (in_end && (r_wr_count == 0 || r_state != LP_IDLE))
            $fatal(1, "TX unexpected mother-code end");
    end
// synthesis translate_on
endmodule
