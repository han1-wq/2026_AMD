module accum_avg #(
    parameter                                       DWIDTH = 32,
    parameter                                       DDELAY = 16
) (
    input   wire                                        sclk                                        ,
    input   wire                                        enable                                      ,
    input   wire                                        reset                                       ,
    input   wire            [DWIDTH - 1:0]              sample_in                                   ,
    input   wire                                        sample_in_valid                             ,
    output  reg             [DWIDTH - 1:0]              sample_avg_out                              ,
    output  reg                                         sample_avg_out_valid
);
    localparam                                      LP_WINSINZE_BIT = clogb2(DDELAY - 1);
    localparam                                      LP_SUM_WIDTH = LP_WINSINZE_BIT + DWIDTH;

    reg                 [clogb2(DDELAY - 1) - 1:0]  r_addr;
    reg                                             r_full;

    reg         signed  [LP_SUM_WIDTH - 1:0]        r_sum_win;
    wire        signed  [LP_SUM_WIDTH - 1:0]        w_ext_old_data;
    wire        signed  [LP_SUM_WIDTH - 1:0]        w_ext_new_data;
    wire        signed  [DWIDTH - 1:0]              w_new_data;
    wire        signed  [DWIDTH - 1:0]              w_old_data;

    assign w_new_data = sample_in;
    assign w_ext_old_data = {{LP_WINSINZE_BIT {w_old_data[DWIDTH - 1]}}, w_old_data};
    assign w_ext_new_data = {{LP_WINSINZE_BIT {w_new_data[DWIDTH - 1]}}, w_new_data};

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
            sample_avg_out_valid <= 1'b0;
        end
        else if (enable == 1'b1 && r_full == 1'b1 && sample_in_valid == 1'b1) begin
            sample_avg_out_valid <= 1'b1;
        end
        else begin
            sample_avg_out_valid <= 1'b0;
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_sum_win <= 'd0;
        end
        else if (enable == 1'b1) begin
            if (sample_in_valid == 1'b1 && r_full == 1'b1) begin
                r_sum_win <= r_sum_win + w_ext_new_data - w_ext_old_data;
            end
            else if (sample_in_valid == 1'b1 && r_full == 1'b0) begin
                r_sum_win <= r_sum_win + w_ext_new_data;
            end
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            sample_avg_out <= 'd0;
        end
        else if (enable == 1'b1 && sample_in_valid == 1'b1) begin
            sample_avg_out <= r_sum_win[LP_SUM_WIDTH - 1:LP_WINSINZE_BIT];
            //avg
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
        .doutb                                        (w_old_data)
    );

    //  The following function calculates the address width based on specified RAM depth
    function integer clogb2;
        input integer depth;
        for (clogb2 = 0; depth > 0; clogb2 = clogb2 + 1)
            depth = depth >> 1;
    endfunction

endmodule
