#!/usr/bin/env python3
"""Isolated real FFT/Viterbi + balanced interleaver + CRC/DMA regression."""
import argparse
import concurrent.futures
import hashlib
import json
import os
from pathlib import Path
import subprocess
import time

ROOT = Path(__file__).resolve().parents[1]
CASES = [
    dict(name='short8', PAYLOAD_LENGTH=1, RS_BURST_LENGTH=8),
    dict(name='depth2', PAYLOAD_LENGTH=236, RS_BURST_LENGTH=16, RS_BURST_START=250),
    dict(name='depth3', PAYLOAD_LENGTH=475, RS_BURST_LENGTH=24, RS_BURST_START=503),
    dict(name='depth4', PAYLOAD_LENGTH=714, RS_BURST_LENGTH=32, RS_BURST_START=750),
    dict(name='max_tail40', PAYLOAD_LENGTH=1024, RS_BURST_LENGTH=40, RS_BURST_START=1068, PACKETS=2),
    dict(name='max6_40', RATES=6, PAYLOAD_LENGTH=1024, RS_BURST_LENGTH=40, RS_BURST_START=513),
    dict(name='reject41', PAYLOAD_LENGTH=1024, RS_BURST_LENGTH=41),
    dict(name='legacy_reject40', RS_INTERLEAVE=0, PAYLOAD_LENGTH=1024, RS_BURST_LENGTH=40),
    dict(name='legacy8', RS_INTERLEAVE=0, PAYLOAD_LENGTH=1024, RS_INJECT_ERRORS=8),
    dict(name='no_rs', RS_ENABLE=0, PAYLOAD_LENGTH=1024),
    dict(name='impaired40', PAYLOAD_LENGTH=1024, RS_BURST_LENGTH=40, CFO_HZ=300, INTERFERENCE=2),
    dict(name='rf_dropout', PAYLOAD_LENGTH=1024, RF_BURST_START=1000, RF_BURST_SAMPLES=16),
    dict(name='rf_dropout_legacy', RS_INTERLEAVE=0, PAYLOAD_LENGTH=1024,
         RF_BURST_START=1000, RF_BURST_SAMPLES=16),
    dict(name='all_rates_clean', RATES='6 9 12 18 24 36 48 54', PAYLOAD_LENGTH=1024),
]


def run(case):
    started = time.monotonic()
    out = ROOT/'sim'/('build_rs_interleave_phy_'+case['name'])
    out.mkdir(parents=True, exist_ok=True)
    result_path = out/'result.json'
    if result_path.exists():
        result_path.unlink()
    env = dict(os.environ, PATH='/tools/Xilinx/Vivado/2022.1/bin:'+os.environ['PATH'])
    settings = dict(BUILD_DIR=out, TAG=case['name'], RATES=54, GAINS=0.75, PACKETS=1,
                    PAYLOAD_LENGTH=64, RS_ENABLE=1, RS_INTERLEAVE=1, RS_INJECT_ERRORS=0,
                    RS_BURST_LENGTH=0, RS_BURST_START=0, CFO_HZ=0, INTERFERENCE=0,
                    RF_BURST_START=0, RF_BURST_SAMPLES=0,
                    WALL_TIMEOUT_S=3600, TIMEOUT_NS=10000000)
    settings.update({k:v for k,v in case.items() if k!='name'})
    env.update({k:str(v) for k,v in settings.items()})
    with (out/'driver.log').open('w') as log:
        prepared = subprocess.run(['python3', str(ROOT/'sim/prepare_xsim.py'), '--ip-dir',
                                   str(ROOT/'build_hw/ip'), '--output-dir', str(out)],
                                  stdout=log, stderr=subprocess.STDOUT, timeout=120).returncode
        status = prepared or subprocess.run(['bash', str(ROOT/'sim/run_rate_regression.sh')],
                                           env=env, stdout=log, stderr=subprocess.STDOUT,
                                           timeout=28800).returncode
    result = dict(case=case, passed=status==0, elapsed_s=time.monotonic()-started,
                  log=str(out/'driver.log'))
    result_path.write_text(json.dumps(result, indent=2)+'\n')
    print(json.dumps(result), flush=True)
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('cases', nargs='*')
    parser.add_argument('--resume', action='store_true', help='Reuse only passing cases with identical source hashes')
    args = parser.parse_args()
    unknown = set(args.cases)-{c['name'] for c in CASES}
    if unknown:
        parser.error(f'Unknown cases: {unknown}')
    selected = [c for c in CASES if not args.cases or c['name'] in args.cases]
    source_files = sorted((ROOT/'rtl').rglob('*.v')) + [
        ROOT/'sim/tb_ofdm_rf_chain.v', ROOT/'sim/run_rate_regression.sh', Path(__file__)]
    hashes = {str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in source_files}
    def checked_run(case):
        path = ROOT/'sim'/('build_rs_interleave_phy_'+case['name'])/'result.json'
        if args.resume and path.exists():
            previous = json.loads(path.read_text())
            if previous.get('source_sha256')==hashes and previous.get('passed'):
                print(f'REUSE {case["name"]}', flush=True)
                return previous
        result = run(case)
        result['source_sha256'] = hashes
        path.write_text(json.dumps(result, indent=2)+'\n')
        return result
    with concurrent.futures.ThreadPoolExecutor(max_workers=2) as pool:
        results = list(pool.map(checked_run, selected))
    unchanged = all(hashlib.sha256(Path(p).read_bytes()).hexdigest()==h for p,h in hashes.items())
    summary = dict(passed=unchanged and all(r['passed'] for r in results),
                   source_unchanged=unchanged, results=results, source_sha256=hashes)
    out = ROOT/'sim/build_rs_interleave'
    out.mkdir(parents=True, exist_ok=True)
    (out/'phy_results.json').write_text(json.dumps(summary, indent=2)+'\n')
    raise SystemExit(0 if summary['passed'] else 1)


if __name__ == '__main__':
    main()