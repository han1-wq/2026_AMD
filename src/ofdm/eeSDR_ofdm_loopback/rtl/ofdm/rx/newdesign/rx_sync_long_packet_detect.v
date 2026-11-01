module rx_sync_long_packet_detect(
    input   wire                                        sclk                                        ,
    input   wire                                        reset                                       ,
    input   wire                                        enable                                      ,
    input   wire            [15:0]                      peak_threshold                              ,
    input   wire            [15:0]                      sample_in_i                                 ,
    input   wire            [15:0]                      sample_in_q                                 ,
    input   wire                                        sample_in_valid                             ,
    output  reg             [15:0]                      align_lt1_file_i                            ,
    output  reg             [15:0]                      align_lt1_file_q                            ,
    output  reg                                         align_lt1_valid                             ,
    output  reg                                         detect_long_status                          ,
    output  reg                                         detect_long_status_valid                    ,
    output  reg                                         second_peak_delay_8s
);

    wire                [31:0]                      w_cross_corr;
    wire                                            w_cross_corr_valid;
    reg                 [2:0]                       r_peak_cnt;
    reg                 [11:0]                      r_peak_gap_cnt;
    reg                                             r_lt_detect_ok;
    reg                                             r_align_lt1_flag;

    wire                [31:0]                      w_sampledelay_out;
    wire                                            w_sampledelay_out_valid;
    reg                 [31:0]                      r_smp_dly1;
    reg                 [31:0]                      r_smp_dly2;
    reg                 [31:0]                      r_smp_dly3;
    reg                 [31:0]                      r_smp_dly4;
    reg                 [31:0]                      r_smp_dly5;
    reg                 [31:0]                      r_smp_dly6;
    reg                 [31:0]                      r_smp_dly7;
    reg                 [31:0]                      r_smp_dly8;
    reg                 [31:0]                      r_smp_dly9;
    reg                 [31:0]                      r_smp_dly10;
    reg                 [31:0]                      r_smp_dly11;
    reg                 [31:0]                      r_smp_dly12;
    reg                 [31:0]                      r_smp_dly13;
    reg                 [31:0]                      r_smp_dly14;
    reg                 [31:0]                      r_smp_dly15;
    reg                 [31:0]                      r_smp_dly16;
    reg                 [31:0]                      r_smp_dly17;
    reg                 [31:0]                      r_smp_dly18;
    reg                 [17:0]                      r_smp_v_buf;

    reg                 [10:0]                      r_time_out_cnt;

    reg                 [3:0]                       r_lt_ok_delay_cnt;

    //----------------------------------------------------------------
    //Dalay 96 sample valid
    //latency 1
    //always enable
    //----------------------------------------------------------------

    delay_samples #(
        .DWIDTH                                       (32),
        .DDELAY                                       (96)
    ) u_delay_samples (
        .sclk                                         (sclk),
        .enable                                       (1'b1),
        .reset                                        (reset),
        .sample_in                                    ({sample_in_q, sample_in_i}),
        .sample_in_valid                              (sample_in_valid),
        .sampledelay_out                              (w_sampledelay_out),
        .sampledelay_out_valid                        (w_sampledelay_out_valid)
    );

    //latency 5  new : alter latency 18
    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_smp_v_buf <= 'd0;
            {r_smp_dly18, r_smp_dly17, r_smp_dly16, r_smp_dly15, r_smp_dly14, r_smp_dly13, r_smp_dly12, r_smp_dly11, r_smp_dly10, r_smp_dly9, r_smp_dly8, r_smp_dly7, r_smp_dly6, r_smp_dly5, r_smp_dly4, r_smp_dly3, r_smp_dly2, r_smp_dly1} <= 'd0;
        end
        begin
            r_smp_v_buf <= {r_smp_v_buf[16:0], w_sampledelay_out_valid};
            {r_smp_dly18, r_smp_dly17, r_smp_dly16, r_smp_dly15, r_smp_dly14, r_smp_dly13, r_smp_dly12, r_smp_dly11, r_smp_dly10, r_smp_dly9, r_smp_dly8, r_smp_dly7, r_smp_dly6, r_smp_dly5, r_smp_dly4, r_smp_dly3, r_smp_dly2, r_smp_dly1} <=
                {r_smp_dly17, r_smp_dly16, r_smp_dly15, r_smp_dly14, r_smp_dly13, r_smp_dly12, r_smp_dly11, r_smp_dly10, r_smp_dly9, r_smp_dly8, r_smp_dly7, r_smp_dly6, r_smp_dly5, r_smp_dly4, r_smp_dly3, r_smp_dly2, r_smp_dly1, w_sampledelay_out};
        end
    end

    //-----------------------------------------------------------------------------------
    //long train cross corretion
    //latency = 6 sclk   19
    //-----------------------------------------------------------------------------------

    lt_64_cross_corr u_lt_64_cross_corr
    (
        .sclk                                         (sclk),
        .reset                                        (reset),
        .enable                                       (enable),
        .sample_in_i                                  (sample_in_i),
        .sample_in_q                                  (sample_in_q),
        .sample_in_valid                              (sample_in_valid),
        .cross_corr                                   (w_cross_corr),
        .cross_corr_valid                             (w_cross_corr_valid)
    );

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_peak_cnt <= 'd0;
        end
        else if (enable == 1'b1 && w_cross_corr_valid == 1'b1) begin
            if (w_cross_corr[15:0] >= peak_threshold) begin
                r_peak_cnt <= r_peak_cnt + 1'b1;
            end
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_peak_gap_cnt <= 'd0;
        end
        else if (r_peak_cnt >= 1'b1 && enable == 1'b1 && w_cross_corr_valid == 1'b1) begin
            r_peak_gap_cnt <= r_peak_gap_cnt + 1'b1;
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_lt_detect_ok <= 1'b0;
        end
        else if (enable == 1'b1 && (r_peak_cnt == 'd1 || r_peak_cnt == 'd2) && w_cross_corr_valid == 1'b1) begin
            if (w_cross_corr[15:0] >= peak_threshold) begin
                if (r_peak_gap_cnt >= 'd62 && r_peak_gap_cnt <= 64) begin
                    r_lt_detect_ok <= 1'b1;
                end
            end
        end
    end

    always @(*) begin
        r_align_lt1_flag = r_lt_detect_ok;
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            align_lt1_valid <= 1'b0;
            align_lt1_file_i <= 'd0;
            align_lt1_file_q <= 'd0;
        end
        else if (r_align_lt1_flag == 1'b1) begin
            align_lt1_valid <= r_smp_v_buf[17];
            align_lt1_file_i <= r_smp_dly18[15:0];
            align_lt1_file_q <= r_smp_dly18[31:16];
        end
        else begin
            align_lt1_valid <= 1'b0;
            align_lt1_file_i <= 'd0;
            align_lt1_file_q <= 'd0;
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_time_out_cnt <= 'd0;
        end
        else if (enable == 1'b1) begin
            if (r_lt_detect_ok == 1'b0 && w_cross_corr_valid == 1'b1) begin
                r_time_out_cnt <= r_time_out_cnt + 1'b1;
            end
            else if (r_lt_detect_ok == 1'b1) begin
                r_time_out_cnt <= 'd0;
            end
        end
        else begin
            r_time_out_cnt <= 'd0;
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            detect_long_status <= 'd0;
            detect_long_status_valid <= 1'b0;
        end
        else if (enable == 1'b1) begin
            if (r_time_out_cnt[10] == 1'b1) begin
                detect_long_status <= 'd1;
                //error
                detect_long_status_valid <= 1'b1;
            end
            else if (r_lt_detect_ok == 1'b1) begin
                detect_long_status <= 'd0;
                //ok
                detect_long_status_valid <= 1'b1;
            end
        end
        else begin
            detect_long_status <= 'd0;
            detect_long_status_valid <= 1'b0;
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_lt_ok_delay_cnt <= 'd0;
        end
        else if (r_lt_detect_ok == 1'b1 && r_smp_v_buf[17] == 1'b1 && r_lt_ok_delay_cnt[3] == 1'b0) begin
            r_lt_ok_delay_cnt <= r_lt_ok_delay_cnt + 1'b1;
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            second_peak_delay_8s <= 1'b0;
        end
        else if (r_lt_ok_delay_cnt == 'd7 && r_smp_v_buf[17] == 1'b1) begin
            second_peak_delay_8s <= 1'b1;
        end
        else begin
            second_peak_delay_8s <= 1'b0;
        end
    end

endmodule
