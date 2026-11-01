module recv_data_finished_control(
//来自残余频偏校正模块
//来自长训练模块 1 为 error
    input   wire                                        clk                                         ,
    input   wire                                        rst                                         ,
    input   wire                                        data_field_param_gain_stb                   ,
    input   wire                                        data_field_param_gain_ok                    ,
    input   wire            [11:0]                      data_field_ofdm_nums                        ,
    input   wire                                        data_chnl_out_valid                         ,
    input   wire                                        detect_long_status                          ,
    output  reg                                         reset_for_recv_data_finished
);

    // Count accepted DATA carriers, not falling valid edges.  SIGNAL/Viterbi may
    // finish after every carrier of a short frame has already arrived.  A latched
    // count also tolerates gaps within symbols and parameters arriving late.
    reg                 [17:0]                      r_carrier_count;
    reg                 [17:0]                      r_carrier_target;
    reg                                             r_params_known;
    reg                                             r_completed;
    reg                 [3:0]                       r_reset_count;
    always @(posedge clk) begin
        if (rst) begin
            r_carrier_count <= 0;
            r_carrier_target <= 0;
            r_params_known <= 0;
            r_completed <= 0;
            r_reset_count <= 0;
            reset_for_recv_data_finished <= 0;
        end else begin
            if (data_chnl_out_valid && !r_completed && r_carrier_count != 18'h3ffff)
                r_carrier_count <= r_carrier_count + 1'b1;
            if (data_field_param_gain_stb && data_field_param_gain_ok) begin
                r_carrier_target <= {6'd0, data_field_ofdm_nums} * 18'd48;
                r_params_known <= 1;
            end
            if (!r_completed && (detect_long_status ||
                    (data_field_param_gain_stb && !data_field_param_gain_ok) ||
                    (r_params_known && r_carrier_count >= r_carrier_target))) begin
                reset_for_recv_data_finished <= 1;
                r_reset_count <= 0;
                r_completed <= 1;
            end else if (reset_for_recv_data_finished) begin
                if (r_reset_count == 9) begin
                    reset_for_recv_data_finished <= 0;
                    r_reset_count <= 0;
                end else r_reset_count <= r_reset_count + 1'b1;
            end
        end
    end
endmodule
