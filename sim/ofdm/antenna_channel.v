`timescale 1ns / 1ps
// Simulation-only equivalent TX/RX antenna response at 40 MS/s.
// Eight cascaded [a, 1-2a, a] sections: unity DC gain, linear phase,
// monotonically decreasing magnitude from DC to Nyquist for 0 <= a <= 1/4.
module antenna_channel;
    real coefficient = 0.0;
    real edge_db = 0.0;
    real zi1 [0:7], zi2 [0:7], zq1 [0:7], zq2 [0:7];

    task clear;
        integer k;
        begin
            for (k=0; k<8; k=k+1) begin
                zi1[k]=0.0; zi2[k]=0.0; zq1[k]=0.0; zq2[k]=0.0;
            end
        end
    endtask

    task configure;
        input real attenuation_db;
        real sine_edge;
        begin
            // Outermost occupied 802.11a/g carrier: 26 * 20 MHz / 64.
            if (attenuation_db < 0.0 || attenuation_db > 30.0)
                $fatal(1, "ANTENNA_EDGE_DB must be 0..30 at +/-8.125 MHz");
            edge_db = attenuation_db;
            sine_edge = $sin(3.141592653589793 * 8.125 / 40.0);
            coefficient = (1.0 - 10.0 ** (-edge_db / 160.0)) /
                          (4.0 * sine_edge * sine_edge);
            clear;
        end
    endtask

    task step;
        input real in_i, in_q;
        output real out_i, out_q;
        real stage_i, stage_q, next_i, next_q;
        integer k;
        begin
            stage_i=in_i; stage_q=in_q;
            // Zero attenuation is an exact bypass, preserving old stimuli.
            if (edge_db != 0.0) begin
                for (k=0; k<8; k=k+1) begin
                    next_i=coefficient*(stage_i+zi2[k])+(1.0-2.0*coefficient)*zi1[k];
                    next_q=coefficient*(stage_q+zq2[k])+(1.0-2.0*coefficient)*zq1[k];
                    zi2[k]=zi1[k]; zi1[k]=stage_i;
                    zq2[k]=zq1[k]; zq1[k]=stage_q;
                    stage_i=next_i; stage_q=next_q;
                end
            end
            out_i=stage_i; out_q=stage_q;
        end
    endtask
endmodule
