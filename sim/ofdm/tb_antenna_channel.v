`timescale 1ns / 1ps
module tb_antenna_channel;
    antenna_channel dut();
    real oi, oq, frequency, omega, energy, measured, expected, previous;
    real attenuation, impulse_sum;
    integer setting, bin, n, checks=0;
    initial begin
        for (setting=0; setting<5; setting=setting+1) begin
            attenuation=setting*6.0;
            dut.configure(attenuation);
            impulse_sum=0.0;
            for (n=0; n<40; n=n+1) begin
                dut.step(n==0 ? 1.0 : 0.0, 0.0, oi, oq);
                impulse_sum=impulse_sum+oi;
                if (oq!=0.0 || (n>16 && oi!=0.0)) $fatal(1,"ANTENNA_IMPULSE_TAIL");
            end
            if ($abs(impulse_sum-1.0)>1.0e-9) $fatal(1,"ANTENNA_DC_GAIN");
            previous=1.0;
            for (bin=0; bin<=26; bin=bin+1) begin
                frequency=bin*20.0/64.0;
                omega=6.283185307179586*frequency/40.0;
                dut.clear;
                energy=0.0;
                for (n=0; n<272; n=n+1) begin
                    dut.step($cos(omega*n),$sin(omega*n),oi,oq);
                    if (n>=16) energy=energy+oi*oi+oq*oq;
                end
                measured=$sqrt(energy/256.0);
                expected=(1.0-4.0*dut.coefficient*$sin(omega/2.0)*$sin(omega/2.0))**8;
                if ($abs(measured-expected)>1.0e-9 || measured>previous+1.0e-9)
                    $fatal(1,"ANTENNA_TONE edge=%f bin=%0d measured=%f expected=%f",attenuation,bin,measured,expected);
                previous=measured;
                checks=checks+1;
            end
            if ($abs(measured-10.0**(-attenuation/20.0))>1.0e-9) $fatal(1,"ANTENNA_EDGE");
            dut.clear;
            dut.step(0.0,0.0,oi,oq);
            if (oi!=0.0 || oq!=0.0) $fatal(1,"ANTENNA_RESET");
        end
        dut.configure(0.0);
        dut.step(-123.5,78.25,oi,oq);
        if (oi!=-123.5 || oq!=78.25) $fatal(1,"ANTENNA_BYPASS");
        $display("ANTENNA_CHANNEL_PASS tones=%0d",checks);
        $finish;
    end
endmodule
