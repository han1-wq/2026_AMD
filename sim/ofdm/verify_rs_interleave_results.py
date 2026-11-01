#!/usr/bin/env python3
"""Fail-closed verification of complete current interleaver simulation artifacts."""
import hashlib
import json
from pathlib import Path
import re

from run_rs_interleave_phy import CASES

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT/'sim/build_rs_interleave'


def read_json(path):
    if not path.exists():
        raise AssertionError(f'Missing completed result: {path}')
    return json.loads(path.read_text())


def verify_hashes(result):
    hashes = result['source_sha256']
    assert hashes, 'Missing source provenance'
    for name, expected in hashes.items():
        assert hashlib.sha256(Path(name).read_bytes()).hexdigest() == expected, f'Stale result: {name}'


def main():
    verified = OUT/'verified_summary.json'
    if verified.exists():
        verified.unlink()
    rtl = read_json(OUT/'results.json')
    assert rtl['passed'] and not rtl['smoke'] and rtl['cases'] == 6693
    assert rtl['mapping_payload_lengths'] == 1024 and rtl['burst_windows_checked'] == 551888
    verify_hashes(rtl)
    text = (OUT/'run.log').read_text()
    assert 'FATAL' not in text
    assert len(re.findall(r'^RS_PACKET_PASS ', text, re.M)) == rtl['cases']
    for mode in (0, 1):
        control = (OUT/f'control{mode}.log').read_text()
        assert 'RS_CONTROL_PASS' in control and 'FATAL' not in control
    legacy = read_json(ROOT/'sim/build_rs/results.json')
    assert legacy['pass'] and legacy['cases'] == 204
    assert 'RS_REGRESSION_PASS cases=204 ' in (ROOT/'sim/build_rs/run.log').read_text()
    compat = read_json(ROOT/'sim/build_rs_interleave_compat/results.json')
    assert compat['passed'] and compat['cases']==22
    verify_hashes(compat)
    phy = read_json(OUT/'phy_results.json')
    # The old-mode RF dropout is an observed degradation comparison. Keep its
    # raw failure visible; it stopped before FCS/DMA, so do not claim rejection.
    assert phy['source_unchanged']
    verify_hashes(phy)
    parallel = read_json(OUT/'parallel_rates.json') if (OUT/'parallel_rates.json').exists() else None
    if parallel:
        assert parallel['passed'] and {v['rate'] for v in parallel['rates']}=={6,9,12,18,24,36,48,54}
        verify_hashes(parallel)
    assert {r['case']['name'] for r in phy['results']} == {c['name'] for c in CASES}, 'Partial PHY matrix'
    packets, rates = 0, 0
    reference_degradation = []
    for result in phy['results']:
        verify_hashes(result)
        case = result['case']
        path = Path(result['log'])
        driver = path.read_text()
        expected_rates = str(case.get('RATES', 54)).split()
        if case['name']=='rf_dropout_legacy' and not result['passed']:
            log = path.parent/'rf_dropout_legacy_r54_gain_0.75.log'
            text = log.read_text()
            assert 'Fatal: PAYLOAD_MISMATCH index=113 got=e8' in text, log
            assert 'RF_CHAIN_PASS ' not in text, log
            reference_degradation.append(dict(case=case['name'],
                observation='payload mismatch at byte 113; simulation stopped before FCS/DMA'))
            rates += 1
            continue
        assert result['passed'], case
        assert f'RATE_REGRESSION_PASS cases={len(expected_rates)}' in driver, path
        for rate in expected_rates:
            log = path.parent/f'{case["name"]}_r{rate}_gain_0.75.log'
            text = log.read_text()
            assert 'Fatal:' not in text and 'Error:' not in text, log
            count = case.get('PACKETS', 1)
            assert f'RF_CHAIN_PASS packets={count} ' in text, log
            assert len(re.findall('RF_CHAIN_PACKET_PASS ', text)) == count, log
            packets += count
            rates += 1
    synth = ROOT/'sim/build_rs_interleave_synth'
    for line in (synth/'SYNTH_PASS.txt').read_text().splitlines():
        expected, name = line.split(None, 1)
        assert hashlib.sha256(Path(name).read_bytes()).hexdigest()==expected, f'Stale synthesis: {name}'
    timing = {}
    for module in ('rs_packet_encoder', 'rs_packet_decoder'):
        text = (synth/f'{module}_timing.rpt').read_text()
        assert 'All user specified timing constraints are met.' in text
        match = re.search(r'^\s*([\d.\-]+)\s+([\d.\-]+)\s+0\s+\d+\s+([\d.\-]+)\s+([\d.\-]+)\s+0\s+', text, re.M)
        assert match
        wns, tns, whs, ths = map(float, match.groups())
        assert wns >= 0 and whs >= 0 and tns == ths == 0
        timing[module] = dict(wns_ns=wns, whs_ns=whs)
    supporting = read_json(OUT/'supporting_results.json')
    assert set(supporting)=={'dma','host','interface'}
    for result in supporting.values():
        assert result['passed']
        assert hashlib.sha256(Path(result['log']).read_bytes()).hexdigest()==result['sha256']
    assert 'DMA_REGRESSION_PASS' in Path(supporting['dma']['log']).read_text()
    host_text = Path(supporting['host']['log']).read_text()
    assert 'Ran 50 tests' in host_text and '\nOK\n' in host_text
    interface_text = Path(supporting['interface']['log']).read_text()
    assert len(re.findall(r'^PHY_.*_PASS',interface_text,re.M))==6
    summary = dict(passed=True, rtl_cases=rtl['cases'], legacy_cases=legacy['cases'],
                   compatibility_cases=compat['cases'],
                   mapping_windows=rtl['burst_windows_checked'], phy_scenarios=len(CASES),
                   phy_rate_cases=rates, phy_packets=packets,
                   reference_degradation=reference_degradation,
                   raw_phy_matrix_passed=phy['passed'], supporting_regressions_passed=True,
                   max_decode_cycles=rtl['max_decode_cycles'], timing=timing,
                   limitations='OOC timing only; no full-board rebuild/programming, RF BER/PER or over-air qualification')
    verified.write_text(json.dumps(summary, indent=2)+'\n')
    print(json.dumps(summary, indent=2))


if __name__ == '__main__':
    main()