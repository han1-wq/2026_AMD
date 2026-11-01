"""Build must finish first; JTAG is used only after the benchmark exits."""
import subprocess
import sys
from pathlib import Path

root = Path(__file__).resolve().parents[3]
out = Path(sys.argv[1]).resolve()
workspace = Path(sys.argv[2]).resolve()
out.mkdir(exist_ok=False)
with (out / 'deploy.log').open('w') as log:
    subprocess.run([sys.executable, str(root / 'sim/captures/progress_fix_validation/program_and_capture.py'),
                    str(workspace), str(out / 'boot')], stdout=log, stderr=subprocess.STDOUT, check=True)
with (out / 'benchmark.log').open('w') as log:
    subprocess.run([sys.executable, '-B', str(root / 'host/dma_image_benchmark.py'),
                    '192.168.137.10', str(root / 'sim/captures/demo_20261009/demo_source.png'),
                    str(out / 'benchmark'), '--count', '1'], stdout=log, stderr=subprocess.STDOUT, check=True)
nm = subprocess.check_output(['/tools/Xilinx/Vitis/2022.1/gnu/aarch32/lin/gcc-arm-none-eabi/bin/arm-none-eabi-nm',
                              str(workspace / 'ofdm_dma/Debug/ofdm_dma.elf')], text=True)
symbols = {fields[2]: int(fields[0], 16) for line in nm.splitlines()
           if len(fields := line.split()) == 3}
tcl = ['connect -url tcp:127.0.0.1:3121',
       'targets -set -filter {name =~ "ARM Cortex-A9 MPCore #0"}', 'stop']
for name, words in [('ofdm_net_trace_count', 1), ('ofdm_net_trace_overflow', 1), ('ofdm_net_trace', 4096 * 20)]:
    tcl.append(f'mrd -bin -file {{{out / (name + ".bin")}}} 0x{symbols[name]:x} {words}')
tcl += ['con', 'disconnect', 'exit']
script = out / 'dump.tcl'
script.write_text('\n'.join(tcl) + '\n')
with (out / 'dump.log').open('w') as log:
    subprocess.run(['/tools/Xilinx/Vitis/2022.1/bin/xsct', str(script)],
                   stdout=log, stderr=subprocess.STDOUT, check=True)
print('TRACE_CAPTURE_PASS', flush=True)