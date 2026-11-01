module bpsk_deinterleaver(
    input   wire                                        clk                                         ,
    input   wire                                        rst                                         ,
    input   wire                                        bpsk_deinterleaver_data_in_valid            ,
    input   wire            [2:0]                       bpsk_deinterleaver_data_in                  ,
    output  reg                                         bpsk_deinterleaver_data_out_valid           ,
    output  wire            [2:0]                       bpsk_deinterleaver_data_out_chnl0           ,
    output  wire            [2:0]                       bpsk_deinterleaver_data_out_chnl1
);

    reg                 [2:0]                       r_bpsk_deinterleaver_data_in_dly;
    reg                                             r_deinterleaver_valid;
    reg                 [5:0]                       r_rom_pattern_store_addr;
    wire                [5:0]                       w_rom_data_out;
    reg                                             r_deinterleaver_valid_dly;
    wire                                            w_deinterleaver_end_flag;
    reg                                             r_read_ram_valid;
    reg                 [4:0]                       r_read_ram_addr;
    reg                 [2:0]                       r_data_store[0:47];
    reg                 [5:0]                       r_ram_data_out;

    assign bpsk_deinterleaver_data_out_chnl0 = bpsk_deinterleaver_data_out_valid ? r_ram_data_out[2:0]: 3'b0;
    assign bpsk_deinterleaver_data_out_chnl1 = bpsk_deinterleaver_data_out_valid ? r_ram_data_out[5:3]: 3'b0;

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            r_rom_pattern_store_addr <= 'd0;
        end
        else if (r_rom_pattern_store_addr == 'd47) begin
            r_rom_pattern_store_addr <= 'd0;
        end
        else if (bpsk_deinterleaver_data_in_valid == 1'b1) begin
            r_rom_pattern_store_addr <= r_rom_pattern_store_addr + 1'b1;
        end
    end

    always @(posedge clk) begin
        r_bpsk_deinterleaver_data_in_dly <= bpsk_deinterleaver_data_in;
        r_deinterleaver_valid_dly <= r_deinterleaver_valid;
        r_deinterleaver_valid <= bpsk_deinterleaver_data_in_valid;
    end

    assign w_deinterleaver_end_flag = !r_deinterleaver_valid && r_deinterleaver_valid_dly;

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            r_read_ram_valid <= 1'b0;
        end
        else if (r_read_ram_addr == 'd23) begin
            r_read_ram_valid <= 1'b0;
        end
        else if (w_deinterleaver_end_flag == 1'b1) begin
            r_read_ram_valid <= 1'b1;
        end
        else begin
            r_read_ram_valid <= r_read_ram_valid;
        end
    end

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            r_read_ram_addr <= 'd0;
        end
        else if (r_read_ram_addr == 'd23) begin
            r_read_ram_addr <= 'd0;
        end
        else if (r_read_ram_valid == 1'b1) begin
            r_read_ram_addr <= r_read_ram_addr + 1'b1;
        end
        else begin
            r_read_ram_addr <= 'd0;
        end
    end

    always @(posedge clk) begin
        bpsk_deinterleaver_data_out_valid <= r_read_ram_valid;
    end

    // 48 three-bit soft symbols; each read returns two consecutive symbols.
    // Preserve the asymmetric (3-bit write / 6-bit read) BRAM interface.
    integer data_store_i;
    always @(posedge clk) begin
        if (rst == 1'b1) begin
            r_ram_data_out <= 6'd0;
            for (data_store_i = 0; data_store_i < 48; data_store_i = data_store_i + 1)
                r_data_store[data_store_i] <= 3'd0;
        end
        else begin
            // Match the one-clock registered read latency of the original BRAM.
            r_ram_data_out <= {r_data_store[{r_read_ram_addr, 1'b1}],
            r_data_store[{r_read_ram_addr, 1'b0}]};
            if (r_deinterleaver_valid == 1'b1)
                r_data_store[w_rom_data_out] <= r_bpsk_deinterleaver_data_in_dly;
        end
    end

    //rom
    rom_pattern_store u_rom_pattern_store (
        .clka                                         (clk),  // input wire clka
        .addra                                        (r_rom_pattern_store_addr),  // input wire [5:0] addra
        .douta                                        (w_rom_data_out)  // output wire [5:0] douta
    );

endmodule
