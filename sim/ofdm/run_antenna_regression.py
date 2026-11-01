#!/usr/bin/env python3
"""Characterize antenna rolloff; failed decodes are recorded, not hidden.

Exit 0 means the characterization completed, not that every case decoded.
Inspect the CSV PASS/FAIL column. Tool errors/incomplete runs exit nonzero.
Run serially with other scripts that compile into sim/build.
"""
import csv
import os
import signal
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]
BUILD = ROOT / 'sim/build'
TAG = os.environ.get('TAG', 'antenna')
GAINS = os.environ.get('GAINS', '1 0.02').split()
EDGES = os.environ.get('EDGES', '0 3 6 12 24').split()
PACKETS = os.environ.get('PACKETS', '1')
WALL_TIMEOUT = int(os.environ.get('WALL_TIMEOUT_S', '120'))


def run(command, log, env=None, timeout=900):
    with log.open('w') as stream:
        process = subprocess.Popen(command, cwd=BUILD, env=env, stdout=stream,
                                   stderr=subprocess.STDOUT, start_new_session=True)
        try:
            return process.wait(timeout=timeout)
        except subprocess.TimeoutExpired:
            # Kill the entire Xilinx launcher/kernel process group, not just
            # the parent shell. A wall timeout is not a receiver failure.
            os.killpg(process.pid, signal.SIGKILL)
            process.wait()
            stream.write(f'\nANTENNA_WALL_TIMEOUT seconds={timeout}\n')
            return 124


def main():
    if not TAG.replace('_', '').isalnum():
        raise ValueError('TAG must contain only letters, digits or underscores')
    if int(PACKETS) < 1 or WALL_TIMEOUT < 1:
        raise ValueError('PACKETS and WALL_TIMEOUT_S must be positive')
    subprocess.run(['python3', str(ROOT / 'sim/prepare_xsim.py')], check=True)
    subprocess.run(['iverilog', '-g2012', '-s', 'tb_antenna_channel', '-o',
                    str(BUILD / f'{TAG}_model.vvp'),
                    str(ROOT / 'sim/antenna_channel.v'),
                    str(ROOT / 'sim/tb_antenna_channel.v')], check=True)
    subprocess.run(['vvp', str(BUILD / f'{TAG}_model.vvp')], check=True)
    result_path = BUILD / f'{TAG}_results.csv'
    errors = 0
    with result_path.open('w', newline='') as stream:
        writer = csv.writer(stream)
        writer.writerow(['smooth', 'gain', 'edge_db', 'packets', 'result', 'detail', 'log'])
        for smooth in (0, 1):
            snapshot = f'{TAG}_s{smooth}'
            # Compile current sources, check the existing units and a flat
            # normal-gain RF case, then reuse the snapshot for the sweep.
            env = dict(os.environ, TAG=snapshot, GAINS='1', PACKETS=PACKETS,
                       CHANNEL_SMOOTH=str(smooth), ANTENNA_EDGE_DB='0',
                       RX_SHIFT='4', ADC_MODE='0', ADC_WRAP='0',
                       ECHO_GAIN='0', CFO_HZ='0', INTERFERENCE='0')
            print(f'BUILD smooth={smooth}', flush=True)
            build_log = BUILD / f'{snapshot}_driver.log'
            code = run(['bash', str(ROOT / 'sim/run_amplitude_regression.sh')], build_log, env)
            if code:
                raise RuntimeError(f'Baseline/build failed ({code}): {build_log}')
            for gain in GAINS:
                for edge in EDGES:
                    log = BUILD / f'{snapshot}_g{gain}_edge{edge}.log'
                    command = ['xsim', snapshot, '-runall']
                    for arg in (f'GAIN={gain}', f'ANTENNA_EDGE_DB={edge}',
                                f'TIMEOUT_NS={250000 * int(PACKETS)}',
                                'ADC_MODE=0', 'ADC_WRAP=0', 'ECHO_GAIN=0',
                                'CFO_HZ=0', 'INTERFERENCE=0'):
                        command.extend(['-testplusarg', arg])
                    code = run(command, log, timeout=WALL_TIMEOUT)
                    text = log.read_text()
                    passed = 'RF_CHAIN_PASS packets=' in text and 'Fatal:' not in text and code == 0
                    failures = [line for line in text.splitlines() if 'Fatal:' in line]
                    if code == 124:
                        result, detail = 'ERROR', f'WALL_TIMEOUT seconds={WALL_TIMEOUT}'
                    elif passed:
                        result = 'PASS'
                        detail = next(line for line in text.splitlines() if 'RF_CHAIN_PACKET_PASS' in line)
                    elif failures and any(name in failures[0] for name in
                                          ('PAYLOAD_MISMATCH', 'FCS_FAIL', 'RF_CHAIN_TIMEOUT')):
                        result, detail = 'FAIL', failures[0]
                    else:
                        result, detail = 'ERROR', f'Simulator exit={code}; inspect raw log'
                    errors += result == 'ERROR'
                    writer.writerow([smooth, gain, edge, PACKETS, result, detail, str(log)])
                    stream.flush()
                    print(f'ANTENNA_CASE smooth={smooth} gain={gain} edge_db={edge} {result}', flush=True)
    if errors:
        raise RuntimeError(f'Characterization has {errors} incomplete/error cases: {result_path}')
    print(f'ANTENNA_CHARACTERIZATION_DONE {result_path}', flush=True)


if __name__ == '__main__':
    main()
