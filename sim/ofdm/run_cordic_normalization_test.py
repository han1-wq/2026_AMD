#!/usr/bin/env python3
"""Compare the actual RTL functions against the pre-optimization algorithm.

Extract only the pure functions, so Icarus needs no vendor IP stubs. Temporary
files stay outside sim/build; this test can run concurrently with XSim.
"""
from pathlib import Path
import re
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
RTL = ROOT / 'rtl/ofdm/rx/newdesign'


def check(filename, width, fine):
    text = (RTL / filename).read_text()
    function = re.search(r'    function \[63:0\] f_cordic_vector;.*?    endfunction',
                         text, re.S).group(0)
    call = 'f_cordic_vector(i, q)' if fine else 'f_cordic_vector({q, i})'
    bench = r'''
module tb;
    localparam DATA_WIDTH = WIDTH;
    localparam LP_NORM_WIDTH = 1 << $clog2(DATA_WIDTH);
    FUNCTION
    function [63:0] reference;
        input signed [DATA_WIDTH-1:0] i, q;
        reg signed [DATA_WIDTH:0] vi, vq;
        integer n;
        begin
            vi = i; vq = q;
            for (n=0; n<DATA_WIDTH; n=n+1)
                if (vi > 536870911 || vi < -536870912 ||
                    vq > 536870911 || vq < -536870912) begin
                    vi = vi >>> 1; vq = vq >>> 1;
                end
            for (n=0; n<29; n=n+1)
                if ((vi != 0 || vq != 0) &&
                    vi <= 268435455 && vi >= -268435456 &&
                    vq <= 268435455 && vq >= -268435456) begin
                    vi = vi <<< 1; vq = vq <<< 1;
                end
            reference = {vq[31:0], vi[31:0]};
        end
    endfunction
    integer cases=0, seed=32'h714acdef, a, b, n, k;
    reg signed [DATA_WIDTH-1:0] ri, rq, boundary_value;
    task check;
        input signed [DATA_WIDTH-1:0] i, q;
        reg [63:0] actual, expected;
        begin
            actual = CALL;
            expected = reference(i, q);
            if (actual !== expected)
                $fatal(1, "NORMALIZE_FAIL width=%0d i=%h q=%h actual=%h expected=%h",
                       DATA_WIDTH, i, q, actual, expected);
            cases = cases + 1;
        end
    endtask
    initial begin
        for (a=-64; a<=64; a=a+1)
            for (b=-64; b<=64; b=b+1) check(a,b);
        for (k=0; k<DATA_WIDTH; k=k+1) begin
            boundary_value = {{(DATA_WIDTH-1){1'b0}},1'b1} << k;
            for (a=-3; a<=3; a=a+1) begin
                check(boundary_value+a, 0); check(0, boundary_value+a);
                check(-boundary_value+a, 0); check(0, -boundary_value+a);
                for (b=-3; b<=3; b=b+1) begin
                    check(boundary_value+a, -boundary_value+b);
                    check(boundary_value+a, boundary_value+b);
                    check(-boundary_value+a, -boundary_value+b);
                end
            end
        end
        for (n=0; n<100000; n=n+1) begin
            ri = {$random(seed), $random(seed)};
            rq = {$random(seed), $random(seed)};
            check(ri,rq);
            check(ri >>> (n % DATA_WIDTH), rq >>> ((n/7) % DATA_WIDTH));
        end
        $display("CORDIC_NORMALIZE_PASS width=%0d cases=%0d", DATA_WIDTH, cases);
        $finish;
    end
endmodule
'''.replace('DATA_WIDTH = WIDTH;', f'DATA_WIDTH = {width};').replace('FUNCTION', function).replace('CALL', call)
    with tempfile.TemporaryDirectory(prefix='ofdm_normalize_') as directory:
        source = Path(directory) / 'tb.v'
        output = Path(directory) / 'tb.vvp'
        source.write_text(bench)
        subprocess.run(['iverilog', '-g2012', '-s', 'tb', '-o', str(output),
                        str(source)], check=True)
        subprocess.run(['vvp', str(output)], check=True)


if __name__ == '__main__':
    check('rx_fine_cfo_correct_use_lt.v', 32, True)
    for width in (32, 51):
        check('rx_phase_tracker_correct_use_pilot.v', width, False)