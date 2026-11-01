// Two 288-bit symbol windows. Input and output progress only on transfers.
module tx_interleaver (
    input   wire                            clk_Modulation                                  ,
    input   wire                            reset                                           ,
    input   wire    [1:0]                   tx_Modulation                                   ,
    input   wire                            tx_interleaver_in_valid                         ,
    input   wire                            tx_interleaver_in_bit                           ,
    input   wire                            tx_puncture_bit_cnt_valid                       ,
    input   wire    [15:0]                  tx_puncture_bit_cnt                             ,
    output  reg                             intlvr_patt_valid                               ,
    output  reg     [15:0]                  intlvr_patt                                     ,
    output  wire                            interleaved_bit_valid                           ,
    output  wire                            interleaved_bit                                 ,
    input   wire                            in_last                                         ,
    output  wire                            in_ready                                        ,
    input   wire                            out_ready                                       ,
    output  wire                            out_last
);
    (* ram_style = "distributed" *) reg  r_bits_mem[0:1023];
    reg                 [1:0]                   r_full;
    reg                 [1:0]                   r_last_bank;
    reg                                         r_wr_bank;
    reg                                         r_rd_bank;
    reg                 [8:0]                   r_write_k;
    reg                 [8:0]                   r_read_k;
    reg                 [8:0]                   r_n_cbps;
    reg                 [8:0]                   r_i;
    reg                 [8:0]                   r_j;
    reg                 [1:0]                   r_hi_rem;
    reg                 [1:0]                   r_lo_rem;
    reg                 [1:0]                   r_new_rem;
    reg                                         r_write_pending;
    reg                                         r_pending_bit;
    reg                                         r_pending_end;
    reg                                         r_pending_last;
    reg                 [9:0]                   r_pending_addr;
    reg                                         r_perm_valid;
    reg                                         r_perm_bit;
    reg                                         r_perm_end;
    reg                                         r_perm_last;
    reg                                         r_perm_bank;
    reg                                         r_perm_odd;
    reg                 [8:0]                   r_perm_i;
    reg                 [1:0]                   r_perm_hi;
    reg                 [1:0]                   r_perm_rem;
    function [1:0] mod3(input [4:0] value);
        begin
            case (value)
                0, 3, 6, 9, 12, 15: mod3 = 0;
                1, 4, 7, 10, 13, 16: mod3 = 1;
                default: mod3 = 2;
            endcase
        end
    endfunction
    always @(*) begin
        case (tx_Modulation)
            0: r_n_cbps = 48;
            1: r_n_cbps = 96;
            2: r_n_cbps = 192;
            default: r_n_cbps = 288;
        endcase
        case (tx_Modulation)
            0: r_i = (r_write_k[3:0] << 1) + r_write_k[3:0] + r_write_k[8:4];
            1: r_i = (r_write_k[3:0] << 2) + (r_write_k[3:0] << 1) + r_write_k[8:4];
            2: r_i = (r_write_k[3:0] << 3) + (r_write_k[3:0] << 2) + r_write_k[8:4];
            default: r_i = (r_write_k[3:0] << 4) + (r_write_k[3:0] << 1) + r_write_k[8:4];
        endcase
        r_hi_rem = mod3(r_write_k[8:4]);
        r_lo_rem = mod3({1'b0, r_write_k[3:0]});
        if (r_hi_rem >= r_lo_rem) r_new_rem = r_hi_rem - r_lo_rem;
        else r_new_rem = r_hi_rem + 2'd3 - r_lo_rem;
        case (tx_Modulation)
            0, 1: r_j = r_perm_i;
            2: r_j = {r_perm_i[8:1], (r_perm_i[0] ^ r_perm_odd)};
            default: r_j = r_perm_i - r_perm_hi + r_perm_rem;
        endcase
    end
    assign in_ready = !r_full[r_wr_bank];
    assign interleaved_bit_valid = r_full[r_rd_bank];
    assign interleaved_bit = r_bits_mem[{r_rd_bank, r_read_k}];
    assign out_last = r_full[r_rd_bank] && r_last_bank[r_rd_bank] && r_read_k == r_n_cbps - 1'b1;
    wire                                        w_push = tx_interleaver_in_valid && in_ready;
    wire                                        w_pop = interleaved_bit_valid && out_ready;
    always @(posedge clk_Modulation) begin
        // Register permutation before the distributed-RAM address decoder.
        // Publish a full bank only when its final bit has actually committed.
        if (!reset && r_write_pending) r_bits_mem[r_pending_addr] <= r_pending_bit;
        if (reset) begin
            r_full <= 0;
            r_last_bank <= 0;
            r_wr_bank <= 0;
            r_rd_bank <= 0;
            r_write_k <= 0;
            r_read_k <= 0;
            intlvr_patt_valid <= 0;
            intlvr_patt <= 0;
            r_write_pending <= 0;
            r_pending_bit <= 0;
            r_pending_end <= 0;
            r_pending_last <= 0;
            r_pending_addr <= 0;
            r_perm_valid <= 0;
            r_perm_bit <= 0;
            r_perm_end <= 0;
            r_perm_last <= 0;
            r_perm_bank <= 0;
            r_perm_odd <= 0;
            r_perm_i <= 0;
            r_perm_hi <= 0;
            r_perm_rem <= 0;
        end else begin
            r_perm_valid <= w_push;
            r_write_pending <= r_perm_valid;
            if (r_perm_valid) begin
                r_pending_addr <= {r_perm_bank, r_j};
                r_pending_bit <= r_perm_bit;
                r_pending_end <= r_perm_end;
                r_pending_last <= r_perm_last;
                intlvr_patt <= {r_perm_bank, r_j};
            end
            if (r_write_pending && r_pending_end) begin
                r_full[r_pending_addr[9]] <= 1;
                r_last_bank[r_pending_addr[9]] <= r_pending_last;
            end
            intlvr_patt_valid <= r_perm_valid;
            if (w_push) begin
                r_perm_i <= r_i;
                r_perm_hi <= r_hi_rem;
                r_perm_rem <= r_new_rem;
                r_perm_bank <= r_wr_bank;
                r_perm_odd <= r_write_k[0];
                r_perm_bit <= tx_interleaver_in_bit;
                r_perm_end <= r_write_k == r_n_cbps - 1'b1;
                r_perm_last <= in_last;
                if (r_write_k == r_n_cbps - 1'b1) begin
                    r_wr_bank <= ~r_wr_bank;
                    r_write_k <= 0;
                end else r_write_k <= r_write_k + 1'b1;
            end
            if (w_pop) begin
                if (r_read_k == r_n_cbps - 1'b1) begin
                    r_full[r_rd_bank] <= 0;
                    r_rd_bank <= ~r_rd_bank;
                    r_read_k <= 0;
                end else r_read_k <= r_read_k + 1'b1;
            end
        end
    end
endmodule
