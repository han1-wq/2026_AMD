"""Sequential 400-image trials; finish with the requested 1000-ms firmware."""
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import traceback

out = Path(__file__).resolve().parent
root = out.parents[2]
template = (root / 'sim/captures/rs_ack_1s_20261016/program_and_capture.py').read_text()
source = root / 'sim/captures/demo_20261009/demo_source.png'


def program(label, workspace):
    directory = out / label
    directory.mkdir(exist_ok=False)
    helper = template.replace('root = out.parents[2]', 'root = out.parents[3]')
    helper = helper.replace('build_sw_rs_ack1s/', workspace + '/')
    helper = helper.replace('Program the ACK-1s firmware', 'Program the selected comparison firmware')
    (directory / 'program_and_capture.py').write_text(helper)
    print('PROGRAM', label, flush=True)
    with (directory / 'program_capture.log').open('w') as log:
        subprocess.run([sys.executable, '-u', str(directory / 'program_and_capture.py')],
                       stdout=log, stderr=subprocess.STDOUT, check=True, timeout=110)
    assert 'PROGRAM_AND_BOOT_PASS' in (directory / 'program_capture.log').read_text()
    return directory


def benchmark(directory):
    cmd = [sys.executable, '-u', str(root / 'host/dma_image_benchmark.py'),
           '192.168.137.10', str(source), str(directory / 'benchmark_400'), '--count', '400']
    (directory / 'command.json').write_text(json.dumps(cmd, indent=2) + '\n')
    print('BENCHMARK', directory.name, flush=True)
    with (directory / 'benchmark.log').open('w') as log:
        subprocess.run(cmd, stdout=log, stderr=subprocess.STDOUT, check=True)
    summary = json.loads((directory / 'benchmark_400/summary.json').read_text())
    print('COMPLETE', directory.name, summary['attempts'], summary['successes'], flush=True)
    assert summary['attempts'] == 400


def main():
    baseline_error = None
    try:
        benchmark(program('ack_100ms', 'build_sw_rs'))
    except Exception:
        baseline_error = traceback.format_exc()
        (out / 'baseline_error.log').write_text(baseline_error)
        print(baseline_error, flush=True)
    # Restore 1 s even if the control test failed.
    benchmark(program('ack_1000ms', 'build_sw_rs_ack1s'))
    if baseline_error:
        raise RuntimeError('Control failed; see baseline_error.log')
    results = {}
    for label in ('ack_100ms', 'ack_1000ms'):
        directory = out / label / 'benchmark_400'
        rows = [json.loads(line) for line in (directory / 'results.jsonl').read_text().splitlines()]
        summary = json.loads((directory / 'summary.json').read_text())
        totals = {}
        for row in rows:
            for key, value in row.get('counters', {}).items():
                totals[key] = totals.get(key, 0) + value
        summary['counter_totals'] = totals
        summary['rows_with_counters'] = sum(bool(row.get('counters')) for row in rows)
        summary['error_messages'] = [row.get('error') for row in rows if not row['success']]
        summary['last_image_matches'] = (directory / 'last_received.png').read_bytes() == source.read_bytes()
        results[label] = summary
    results['source_sha256'] = hashlib.sha256(source.read_bytes()).hexdigest()
    (out / 'comparison.json').write_text(json.dumps(results, indent=2) + '\n')
    print('COMPARISON_COMPLETE', flush=True)


if __name__ == '__main__':
    main()