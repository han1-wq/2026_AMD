module rx_coarse_cfo_use_st(
// Clock
    input   wire                                        sclk                                        ,
    input   wire                                        reset                                       ,
    input   wire                                        enable                                      ,
    input   wire            [15:0]                      sample_in_i                                 ,
    input   wire            [15:0]                      sample_in_q                                 ,
    input   wire                                        sample_in_valid                             ,
    input   wire            [31:0]                      accu_avg_in_i                               ,
    input   wire            [31:0]                      accu_avg_in_q                               ,
    input   wire                                        accu_avg_valid                              ,
    output  reg             [15:0]                      correct_coarse_i                            ,
    output  reg             [15:0]                      correct_coarse_q                            ,
    output  reg                                         correct_coarse_valid
);

    wire                [31:0]                      w_sampledelay_out;
    wire                                            w_sampledelay_out_valid;
    wire        signed  [31:0]                      w_angle_out;
    wire                                            w_angle_out_valid;
    wire        signed  [31:0]                      w_angle_out_div16x2pi;
    wire                                            w_angle_out_div16x2pi_valid;
    reg         signed  [31:0]                      r_freq_ctrl;
    reg                 [31:0]                      r_phase_addr;
    reg                                             r_phase_addr_valid;
    wire        signed  [15:0]                      w_dds_data_i;
    wire        signed  [15:0]                      w_dds_data_q;
    wire                                            w_dds_data_valid;
    wire                [63:0]                      w_mult_out;
    wire                                            w_mult_out_valid;

    //----------------------------------------------------------------
    //Dalay 256 sample
    //latency 1
    //----------------------------------------------------------------

    delay_samples #(
        .DWIDTH                                       (32),
        .DDELAY                                       (256)
    ) u_delay_samples (
        .sclk                                         (sclk),
        .enable                                       (enable),
        .reset                                        (reset),
        .sample_in                                    ({sample_in_q, sample_in_i}),
        .sample_in_valid                              (sample_in_valid),
        .sampledelay_out                              (w_sampledelay_out),
        .sampledelay_out_valid                        (w_sampledelay_out_valid)
    );

    //----------------------------------------------------------------
    //get angle and angle/(16*2*pi) fix32_28
    //latency 90
    //----------------------------------------------------------------

    fix_atan2 u_fix_atan2 (
        .sclk                                         (sclk),
        .reset                                        (reset),
        .enable                                       (enable),
        .y_in                                         (accu_avg_in_q),
        .x_in                                         (accu_avg_in_i),
        .xy_in_valid                                  (accu_avg_valid),
        .angle_out                                    (w_angle_out),
        .angle_out_valid                              (w_angle_out_valid),
        .angle_out_div16x2pi                          (w_angle_out_div16x2pi),  //fix32_28
        .angle_out_div16x2pi_valid                    (w_angle_out_div16x2pi_valid)
    );
    //----------------------------------------------------------------
    //get freq ctrl word 32bit
    //freq_ctrl =(angle_out_div16x2pi/2^28)*2^32
    //this angle_out_div16x2pi value of actual frequency offset
    //e^jn*alhpa
    //latency 1
    //----------------------------------------------------------------

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_freq_ctrl <= 'd0;
        end
        else if (enable == 1'b1) begin
            if (w_angle_out_div16x2pi_valid == 1'b1) begin
                r_freq_ctrl <= {w_angle_out_div16x2pi[27:0], 4'b0000};
            end
        end
    end
    //----------------------------------------------------------------
    //gen dds
    //e^-jn*alhpa
    //latency 1
    //----------------------------------------------------------------

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_phase_addr <= 'd0;
        end else if (enable == 1'b1 && w_sampledelay_out_valid == 1'b1) begin
            r_phase_addr <= r_phase_addr - r_freq_ctrl;
            //e^-jn*alpha
        end
    end

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            r_phase_addr_valid <= 1'b0;
        end
        else if (enable == 1'b1) begin
            r_phase_addr_valid <= w_sampledelay_out_valid;
        end
    end

    dds_cfo u_dds_cfo (
        .aclk                                         (sclk),
        .aresetn                                      (~reset),  // input wire aclk
        .s_axis_phase_tvalid                          (r_phase_addr_valid),  // input wire s_axis_phase_tvalid
        .s_axis_phase_tdata                           ({4'd0, r_phase_addr[31:20]}),  // input wire [15:0] s_axis_phase_tdata
        .m_axis_data_tvalid                           (w_dds_data_valid),  // output wire m_axis_data_tvalid
        .m_axis_data_tdata                            ({w_dds_data_q, w_dds_data_i})  // output wire [31:0] m_axis_data_tdata
    );

    //----------------------------------------------------------------
    //offset signal * e^-jn*alpha
    //latency
    //----------------------------------------------------------------

    complex_multiplier u_mult_delay (
        .aclk                                         (sclk),  // input wire aclk
        .s_axis_a_tvalid                              (w_dds_data_valid),  // input wire s_axis_a_tvalid
        .s_axis_a_tdata                               ({w_dds_data_q, w_dds_data_i}),  // input wire [31:0] s_axis_a_tdata
        .s_axis_b_tvalid                              (w_dds_data_valid),  // input wire s_axis_b_tvalid
        .s_axis_b_tdata                               (w_sampledelay_out),  // input wire [31:0] s_axis_b_tdata
        .m_axis_dout_tvalid                           (w_mult_out_valid),  // output wire m_axis_dout_tvalid
        .m_axis_dout_tdata                            (w_mult_out)  // output wire [63:0] m_axis_dout_tdata
    );

    // Match the Q1.15 DDS and the CMPY's one-bit output scaling.
    // Preserve unity gain and saturate instead of wrapping discarded high bits.
    function [15:0] f_rotate_to_sample;
        input signed [31:0] product;
        reg signed [31:0] sample;
        begin
            sample = product >>> 14;
            if (sample > 32'sd32767) f_rotate_to_sample = 16'h7fff;
            else if (sample < -32'sd32768) f_rotate_to_sample = 16'h8000;
            else f_rotate_to_sample = sample[15:0];
        end
    endfunction

    //output reg

    always @(posedge sclk) begin
        if (reset == 1'b1) begin
            correct_coarse_valid <= 1'b0;
            correct_coarse_i <= 'd0;
            correct_coarse_q <= 'd0;
        end
        else if (enable == 1'b1) begin
            correct_coarse_valid <= w_mult_out_valid;
            correct_coarse_i <= f_rotate_to_sample(w_mult_out[31:0]);
            correct_coarse_q <= f_rotate_to_sample(w_mult_out[63:32]);
        end
    end

endmodule
