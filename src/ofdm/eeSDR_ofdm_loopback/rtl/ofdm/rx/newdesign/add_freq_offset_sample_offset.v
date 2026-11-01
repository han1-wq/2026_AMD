module add_freq_offset_sample_offset(
// Clock
// Clock Enable
// Asynchronous reset active low
//fix32_15
    input   wire                                        sclk                                        ,
    input   wire                                        enable                                      ,
    input   wire                                        reset                                       ,
    input   wire            [31:0]                      channel_data_i                              ,
    input   wire            [31:0]                      channel_data_q                              ,
    input   wire                                        channel_data_valid                          ,
    output  wire            [31:0]                      data_chnl_out_i                             ,
    output  wire            [31:0]                      data_chnl_out_q                             ,
    output  wire                                        data_chnl_out_valid
);

    reg                 [15:0]                      r_imem[51:0];
    reg                 [15:0]                      r_qmem[51:0];
    reg                 [5:0]                       r_cnt;
    wire                [31:0]                      w_offset_data;
    wire                [63:0]                      w_mult_out;
    wire                                            w_mult_out_valid;

    initial begin
        $readmemh("./idata.mif", r_imem);
        $readmemh("./qdata.mif", r_qmem);
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_cnt <= 'd0;
        end
        else if (enable == 1'b1) begin
            if (channel_data_valid == 1'b1) begin
                r_cnt <= r_cnt + 1'b1;
            end
            else begin
                r_cnt <= 'd0;
            end
        end
    end

    assign w_offset_data = {r_qmem[r_cnt], r_imem[r_cnt]};
    //in fix16_15 *x fix16_8
    //out fix33_23 -->fix 32_22
    complex_multiplier u_complex_mult_user_pilot (
        .aclk                                         (sclk),  // input wire aclk
        .s_axis_a_tvalid                              (channel_data_valid),  // input wire s_axis_a_tvalid
        .s_axis_a_tdata                               (w_offset_data),  // input wire [31:0] s_axis_a_tdata
        .s_axis_b_tvalid                              (channel_data_valid),  // input wire s_axis_b_tvalid
        .s_axis_b_tdata                               ({channel_data_q[22:7], channel_data_i[22:7]}),  // input wire [31:0] s_axis_b_tdata
        .m_axis_dout_tvalid                           (w_mult_out_valid),  // output wire m_axis_dout_tvalid
        .m_axis_dout_tdata                            (w_mult_out)  // output wire [63:0] m_axis_dout_tdata
    );
    //out fix32_22 -->fix 32_15
    assign data_chnl_out_valid = w_mult_out_valid;
    assign data_chnl_out_i = {{7 {w_mult_out[31]}}, w_mult_out[31:7]};
    assign data_chnl_out_q = {{7 {w_mult_out[63]}}, w_mult_out[63:39]};

endmodule
