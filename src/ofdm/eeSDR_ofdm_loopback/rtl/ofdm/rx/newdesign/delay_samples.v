module delay_samples #(
    parameter                                       DWIDTH = 32,
    parameter                                       DDELAY = 16
) (
    input   wire                                        sclk                                        ,
    input   wire                                        enable                                      ,
    input   wire                                        reset                                       ,
    input   wire            [DWIDTH - 1:0]              sample_in                                   ,
    input   wire                                        sample_in_valid                             ,
    output  wire            [DWIDTH - 1:0]              sampledelay_out                             ,
    output  reg                                         sampledelay_out_valid
);

    reg                 [clogb2(DDELAY - 1) - 1:0]  r_addr;
    reg                                             r_full;

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_addr <= 'd0;
        end
        else if (enable == 1'b1) begin
            if (sample_in_valid == 1'b1 && r_addr == DDELAY - 1) begin
                r_addr <= 'd0;
            end
            else if (sample_in_valid == 1'b1) begin
                r_addr <= r_addr + 1'b1;
            end
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_full <= 1'b0;
        end
        else if (enable == 1'b1 && r_addr == DDELAY - 1 && sample_in_valid == 1'b1) begin
            r_full <= 1'b1;
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            sampledelay_out_valid <= 1'b0;
        end
        else if (enable == 1'b1 && r_full == 1'b1 && sample_in_valid == 1'b1) begin
            sampledelay_out_valid <= 1'b1;
        end
        else begin
            sampledelay_out_valid <= 1'b0;
        end
    end

    ram_simple2port #(
        .RAM_WIDTH                                    (DWIDTH),
        .RAM_DEPTH                                    (DDELAY)
    ) u_ram_simple2port (
        .addra                                        (r_addr),
        .addrb                                        (r_addr),
        .dina                                         (sample_in),
        .clka                                         (sclk),
        .clkb                                         (sclk),
        .wea                                          (sample_in_valid),
        .enb                                          (1'b1),
        .rstb                                         (reset),
        .regceb                                       (1'b1),
        .doutb                                        (sampledelay_out)
    );

    //  The following function calculates the address width based on specified RAM depth
    function integer clogb2;
        input integer depth;
        for (clogb2 = 0; depth > 0; clogb2 = clogb2 + 1)
            depth = depth >> 1;
    endfunction

endmodule
