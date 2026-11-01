#!/usr/bin/env python3
"""Complete a partial PHY matrix, reusing verified logs and parallelizing rates.

Run only after the original matrix driver exits/stops. A still-running clean
rate snapshot can finish independently; --wait-rate6 reserves one worker for it.
Raw reference failures remain failures in phy_results.json.
"""
import argparse
import concurrent.futures
import hashlib
import json
from pathlib import Path
import shutil
import time

from run_rs_interleave_phy import ROOT, CASES, run


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--wait-rate6', action='store_true')
    args = parser.parse_args()
    out = ROOT/'sim/build_rs_interleave'
    baseline = json.loads((ROOT/'sim/build_rs_interleave_phy_short8/result.json').read_text())
    hashes = baseline['source_sha256']
    for name, digest in hashes.items():
        assert hashlib.sha256(Path(name).read_bytes()).hexdigest()==digest, f'Stale source {name}'
    helper_hash = hashlib.sha256(Path(__file__).read_bytes()).hexdigest()
    results = []
    for case in CASES:
        if case['name']=='all_rates_clean':
            continue
        path = ROOT/'sim'/('build_rs_interleave_phy_'+case['name'])/'result.json'
        result = json.loads(path.read_text())
        assert result['case']==case and result['source_sha256']==hashes
        assert result['passed'] or case['name']=='rf_dropout_legacy', case
        results.append(result)
    aggregate_dir = ROOT/'sim/build_rs_interleave_phy_all_rates_clean'
    def rate_job(rate):
        target = aggregate_dir/f'all_rates_clean_r{rate}_gain_0.75.log'
        if rate==6 and args.wait_rate6:
            deadline = time.monotonic()+3600
            while time.monotonic()<deadline:
                text = target.read_text() if target.exists() else ''
                if 'Fatal:' in text or 'Error:' in text:
                    raise AssertionError(text[-2000:])
                if 'RF_CHAIN_PASS packets=1 ' in text and 'Exiting xsim at ' in text:
                    print('REUSED completed clean rate 6', flush=True)
                    return dict(rate=6, passed=True, reused_log=str(target))
                time.sleep(10)
            raise TimeoutError('Clean rate 6 did not finish')
        if target.exists():
            text = target.read_text()
            if 'RF_CHAIN_PASS packets=1 ' in text and 'Exiting xsim at ' in text and 'Fatal:' not in text and 'Error:' not in text:
                print(f'REUSED completed clean rate {rate}', flush=True)
                return dict(rate=rate, passed=True, reused_log=str(target))
        case = dict(name=f'parallel_clean{rate}', RATES=rate, PAYLOAD_LENGTH=1024)
        result = run(case)
        assert result['passed'], result
        source = Path(result['log']).parent/f'parallel_clean{rate}_r{rate}_gain_0.75.log'
        shutil.copy2(source, target)
        return dict(rate=rate, passed=True, source_log=str(source), copied_log=str(target))
    started = time.monotonic()
    with concurrent.futures.ThreadPoolExecutor(max_workers=2) as pool:
        rates = list(pool.map(rate_job, (6,9,12,18,24,36,48,54)))
    assert all(hashlib.sha256(Path(p).read_bytes()).hexdigest()==h for p,h in hashes.items())
    assert hashlib.sha256(Path(__file__).read_bytes()).hexdigest()==helper_hash
    with (aggregate_dir/'driver.log').open('a') as stream:
        stream.write('\nCompleted using isolated per-rate libraries; see parallel_rates.json.\n')
        stream.write('RATE_REGRESSION_PASS cases=8\n')
    provenance = dict(passed=True, rates=rates, elapsed_s=time.monotonic()-started,
                      source_sha256={**hashes,str(Path(__file__)):helper_hash})
    (out/'parallel_rates.json').write_text(json.dumps(provenance,indent=2)+'\n')
    clean = dict(case=next(c for c in CASES if c['name']=='all_rates_clean'), passed=True,
                 log=str(aggregate_dir/'driver.log'), source_sha256=hashes,
                 parallel_provenance=str(out/'parallel_rates.json'))
    (aggregate_dir/'result.json').write_text(json.dumps(clean,indent=2)+'\n')
    results.append(clean)
    summary = dict(passed=all(r['passed'] for r in results), source_unchanged=True,
                   results=results, source_sha256=hashes)
    (out/'phy_results.json').write_text(json.dumps(summary,indent=2)+'\n')
    print('PHY_COMPLETED raw_pass=%s; inspect reference_degradation in independent verifier' % summary['passed'])


if __name__=='__main__':
    main()