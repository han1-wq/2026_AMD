"""Collect measured results without treating missing reports as passing checks."""
import hashlib
import json
from pathlib import Path
import re
import xml.etree.ElementTree as ET

WORK = Path(__file__).resolve().parent
KERNELS = ("image_preprocess", "yolo_postprocess")
FIXTURES = {
    "image_preprocess": ("opencv_source.bgr", "opencv_tensor.int8"),
    "yolo_postprocess": ("fixture_input.bin", "fixture_output.bin", "fixture_tables.bin"),
}


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def tree_hashes(root):
    return {str(p.relative_to(root)): digest(p)
            for p in sorted(root.rglob('*')) if p.is_file()}


def compare_fixtures():
    report = {}
    for kernel, names in FIXTURES.items():
        report[kernel] = {}
        for name in names:
            paths = [base / 'candidate' / kernel / 'solution_200mhz/csim/build' / name
                     for base in (WORK.parent / 'timing_margin_20261013', WORK)]
            hashes = [digest(p) if p.is_file() else None for p in paths]
            report[kernel][name] = {
                'paths': [str(p) for p in paths], 'sha256': hashes,
                'identical': all(p.is_file() and p.stat().st_size > 0 for p in paths)
                             and hashes[0] == hashes[1]}
    return report


def xml_value(element, tag):
    node = element.find(tag)
    if node is None:
        return None
    if len(node):
        return {child.tag: xml_value(node, child.tag) for child in node}
    return (node.text or '').strip() or None


def normalize(text):
    text = re.sub(r'/\*.*?\*/|//[^\n]*', '', text, flags=re.S)
    text = re.sub(r'^\s*#(?!pragma\b).*$', '', text, flags=re.M)
    text = re.sub(r'^\s*#pragma HLSDIRECTIVE TOP name=[a-z_]+\s*$', '', text, flags=re.M)
    text = re.sub(r'VITIS_LOOP_\d+_\d+:', '', text)
    text = re.sub(r'__attribute__\s*\(\(sdx_kernel\("[a-z_]+",\s*0\)\)\)', '', text)
    return re.sub(r'\s+', '', text)


def resources(path):
    text = path.read_text()
    values = {}
    for label, key in (("CLB LUTs*", "lut"), ("CLB LUTs", "lut"),
                       ("CLB Registers", "ff"), ("Block RAM Tile", "bram_tiles"),
                       ("DSPs", "dsp")):
        match = re.search(r'\|\s*' + re.escape(label) + r'\s*\|\s*([\d.]+)', text)
        if match:
            values[key] = float(match[1])
    return values


def routed(directory):
    path = directory / "slack.tsv"
    if not path.exists():
        return {"available": False}
    rows = [line.split('\t') for line in path.read_text().splitlines()[1:]]
    result = {"available": True, "slack_ns": {}}
    for scope, kind, slack in rows:
        result["slack_ns"].setdefault(scope, {})[kind] = float(slack)
    for scope in ("global", *KERNELS):
        if set(result["slack_ns"].get(scope, {})) != {"max", "min"}:
            raise ValueError("Incomplete routed timing: " + str(path))
    result["setup_hold_nonnegative"] = all(
        value >= 0 for values in result["slack_ns"].values() for value in values.values())
    result["resources"] = resources(directory / "utilization.rpt")
    result["per_kernel_resources"] = {
        kernel: resources(directory / (kernel + "_utilization.rpt")) for kernel in KERNELS}
    result["checkpoint_exists"] = (directory / "platform_candidate.dcp").exists()
    route = directory / 'route_status.rpt'
    result['routing_complete'] = False
    if route.exists():
        text = route.read_text()
        counts = {}
        for label in ('routable nets', 'fully routed nets', 'nets with routing errors'):
            match = re.search(r'# of ' + label + r'\.+\s*:\s*(\d+)', text)
            counts[label] = int(match[1]) if match else None
        result['route_counts'] = counts
        result['routing_complete'] = (
            counts['routable nets'] is not None and counts['routable nets'] > 0
            and counts['routable nets'] == counts['fully routed nets']
            and counts['nets with routing errors'] == 0)
    drc = directory / 'drc.rpt'
    result['drc_no_errors'] = False
    if drc.exists():
        text = drc.read_text()
        result['drc_no_errors'] = 'REPORT SUMMARY' in text and not re.search(
            r'\|\s*(?:Error|Critical Warning)\s*\|', text)
    bus_skew = directory / 'bus_skew.rpt'
    result['bus_skew_passed'] = False
    if bus_skew.exists():
        slacks = re.findall(r'^\s*(?:Slow|Fast)\s+[\d.]+\s+[\d.]+\s+(-?[\d.]+)\s*$',
                            bus_skew.read_text(), flags=re.M)
        result['bus_skew_slacks_ns'] = [float(value) for value in slacks]
        result['bus_skew_passed'] = bool(slacks) and all(float(value) >= 0 for value in slacks)
    methodology = directory / 'methodology.rpt'
    result['methodology_critical_warnings'] = None
    if methodology.exists():
        result['methodology_critical_warnings'] = re.findall(
            r'^\|\s*([\w-]+)\s*\|\s*Critical Warning\s*\|', methodology.read_text(), flags=re.M)
    return result


def main():
    report = {"kernels": {}, "source_audit": {}}
    report['acceptance_scope'] = (
        'Integrated base platform under existing timing constraints; methodology '
        'clock warnings are reported separately. Does not certify a DPU-linked '
        'platform, bitstream, XSA or board execution.')
    for kernel in KERNELS:
        directory = WORK / "candidate" / kernel
        source = WORK / "sources" / kernel / "src" / (kernel + ".cpp")
        preprocessed = directory / "solution_200mhz/.autopilot/db" / (kernel + ".pp.0.cpp")
        matches = normalize(preprocessed.read_text()).endswith(normalize(source.read_text()))
        header = source.with_suffix('.h')
        header_text = re.sub(r'^\s*#pragma once\s*$', '', header.read_text(), flags=re.M)
        header_matches = normalize(header_text) in normalize(preprocessed.read_text())
        report["source_audit"][kernel] = {
            "source_sha256": digest(source), "preprocessed_sha256": digest(preprocessed),
            "header_sha256": digest(header), "normalized_header_match": header_matches,
            "normalized_source_and_pragmas_match": matches,
            "method": "Suffix comparison after removing comments, include/line directives, whitespace, generated loop labels, sdx_kernel attributes and generated DIRECTIVE TOP; source HLS pragmas retained."}
        state = json.loads((directory / "status.json").read_text())
        report['source_audit'][kernel]['build_time_hashes_available'] = 'sources' in state
        report['source_audit'][kernel]['build_time_hashes_match'] = (
            state['sources'] == tree_hashes(WORK / 'sources' / kernel) if 'sources' in state else None)
        timing = (directory / "mapped/timing.rpt").read_text()
        match = re.search(r'WNS\(ns\).*?\n\s*-+[^\n]*\n\s*([-\d.]+)', timing)
        if not match:
            raise ValueError("Missing mapped WNS: " + kernel)
        result = {"validation": state, "mapped_resources": resources(directory / "mapped/utilization.rpt"),
                  "mapped_setup_wns_ns": float(match[1]), "hls_functions": {}}
        for path in sorted((directory / "solution_200mhz/syn/report").glob('*csynth.xml')):
            tree = ET.parse(path).getroot()
            result["hls_functions"][path.stem] = {
                tag: tree.findtext('.//' + tag) for tag in
                ("Best-caseLatency", "Worst-caseLatency", "Interval-min", "Interval-max", "DSP", "FF", "LUT")}
            result["hls_functions"][path.stem]["loops"] = {
                loop.tag: {tag: xml_value(loop, tag) for tag in ("PipelineII", "PipelineDepth", "TripCount")}
                for summary in tree.findall('.//SummaryOfLoopLatency') for loop in summary}
        cosim = directory / "solution_200mhz/sim/report" / (kernel + "_cosim.rpt")
        result["cosim_report"] = cosim.read_text() if cosim.exists() else None
        report["kernels"][kernel] = result
    report["previous_routed"] = routed(WORK.parent / "timing_margin_20261013/candidate_routed")
    report["candidate_routed"] = routed(WORK / "candidate_routed")
    report["platform_status"] = json.loads((WORK / "platform_status.json").read_text())
    fixtures = compare_fixtures()
    (WORK / 'fixture_comparison.json').write_text(json.dumps(fixtures, indent=2) + '\n')
    report["fixtures_identical"] = all(
        fixtures[kernel][name]['identical'] for kernel, names in FIXTURES.items() for name in names)
    abi = WORK / "candidate_export_sha256.json"
    report["abi_verified"] = abi.exists() and all(
        json.loads(abi.read_text()).get(k, {}).get("abi_matches", False) for k in KERNELS)
    manifest = json.loads(abi.read_text()) if abi.exists() else {}
    report['export_hashes_verified'] = all(
        bool(manifest.get(k, {}).get('files'))
        and manifest[k]['files'] == tree_hashes(WORK / 'candidate' / k / 'solution_200mhz/impl/ip')
        == tree_hashes(WORK / 'platform_candidate/ip_repo/vision' / k) for k in KERNELS)
    report["acceptance_passed"] = (
        all(v["normalized_source_and_pragmas_match"] for v in report["source_audit"].values())
        and all(v['normalized_header_match'] and v['build_time_hashes_match'] is not False
                for v in report['source_audit'].values())
        and all(v["validation"]["status"] == "passed" for v in report["kernels"].values())
        and report["abi_verified"]
        and report['export_hashes_verified']
        and report["fixtures_identical"]
        and all(re.search(r'\|\s*Verilog\s*\|\s*Pass\s*\|', v['cosim_report'] or '')
                for v in report['kernels'].values())
        and report["platform_status"]["stage"] == "passed"
        and report["candidate_routed"].get("setup_hold_nonnegative", False)
        and report['candidate_routed'].get('routing_complete', False)
        and report['candidate_routed'].get('drc_no_errors', False)
        and report['candidate_routed'].get('bus_skew_passed', False)
        and report["candidate_routed"].get("checkpoint_exists", False))
    (WORK / "comparison.json").write_text(json.dumps(report, indent=2) + '\n')
    (WORK / "source_snapshot_audit.json").write_text(json.dumps(report["source_audit"], indent=2) + '\n')
    print(json.dumps({key: report[key] for key in
                     ("source_audit", "previous_routed", "candidate_routed", "platform_status", "acceptance_passed")}, indent=2))


if __name__ == "__main__":
    main()