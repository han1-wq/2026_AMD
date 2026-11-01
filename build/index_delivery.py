#!/usr/bin/env python3
"""Create classified internal links and inventories; never execute imported code."""
import csv
import json
import os
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]


def link(path, target):
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.is_symlink():
        if path.resolve() == target.resolve():
            return
        raise RuntimeError('Conflicting link: ' + str(path))
    if path.exists():
        raise RuntimeError('Refusing to replace existing file: ' + str(path))
    path.symlink_to(os.path.relpath(target, path.parent), target_is_directory=target.is_dir())


def main():
    rows = list(csv.DictReader((ROOT/'report/source_manifest.csv').open()))
    inventory = json.loads((ROOT/'report/source_inventory.json').read_text())
    projects = {p['project']: p for p in inventory['projects']}
    indexes = {'build/scripts': [], 'build/reports': [], 'board/scripts': [],
               'board/artifacts/index': [], 'sim/scripts': [], 'sim/results/imported': [],
               'data/reference': [], 'report/design': []}
    path_refs = []
    # OFDM simulation scripts expect their parent to contain RTL/firmware/host.
    # Preserve that assumption without modifying copied scripts or writing outside the package.
    for name in ('rtl', 'firmware', 'host', 'board', 'ip_repo', 'ip_config'):
        target = ROOT/'src/ofdm/eeSDR_ofdm_loopback'/name
        if target.exists():
            link(ROOT/'sim'/name, target)
    link(ROOT/'sim/sim', ROOT/'sim/ofdm')
    explicit = {
        'sim/projects/ofdm': 'src/ofdm/eeSDR_ofdm_loopback',
        'sim/projects/image_preprocess': 'src/kv260/HLS_IP/image_preprocess',
        'sim/projects/yolo_postprocess': 'src/kv260/HLS_IP/yolo_postprocess',
        'sim/projects/navigation': 'src/ps/x3plus-kv260-docker/navigation-fix',
        'sim/projects/so101': 'src/ps/lerobot-deploy/network-teleop',
        'sim/projects/roarm_console': 'src/host/roarm-vision-console/tests',
        'board/projects/ofdm': 'src/ofdm/eeSDR_ofdm_loopback',
        'board/projects/kv260_B3136': 'src/ps/kv260_B3136',
        'board/projects/x3plus': 'src/ps/x3plus-kv260-docker',
        'board/projects/lerobot': 'src/ps/lerobot-deploy',
    }
    for loc, target in explicit.items():
        if (ROOT/target).exists():
            link(ROOT/loc, ROOT/target)
    for row in rows:
        project = row['project']
        rel = Path(row['source']).relative_to(projects[project]['source'])
        path = ROOT/row['destination']
        n, suffix = path.name.lower(), path.suffix.lower()
        categories = []
        text_parts = '/'.join(rel.parts).lower()
        if suffix in {'.md', '.rst', '.pdf'} and ('report' in n or '报告' in n or '流程' in n or
                n in {'readme.md', 'readme-kv260.md', 'ai-vision.md', 'status.md',
                      'ai_vision_project_overview_cn.md', 'validation.md', 'protocol.md', 'dma_bringup.md'}):
            categories.append('report/design')
        if suffix in {'.rpt', '.rptx'} or (suffix == '.xml' and ('csynth' in n or 'cosim' in n)):
            categories.append('build/reports')
        if suffix in {'.tcl', '.sh', '.py', '.cfg'} or n in {'makefile', 'dockerfile'}:
            if (n.startswith(('build', 'synth', 'integrate', 'export')) or
                    n in {'makefile', 'dockerfile'} or (suffix == '.tcl' and 'program' not in n)):
                categories.append('build/scripts')
            if n.startswith(('test_', 'tb_', 'check_', 'verify_', 'validate_', 'run_dma_regression', 'run_regression')):
                categories.append('sim/scripts')
            if n.startswith(('run-', 'run_', 'start-', 'start_', 'stop-', 'stop_', 'program', 'install-')) and not ('regression' in n or 'test' in n):
                categories.append('board/scripts')
        if suffix in {'.v', '.sv', '.cpp', '.c'} and n.startswith(('test_', 'tb_')):
            categories.append('sim/scripts')
        if suffix == '.service':
            categories.append('board/scripts')
        if suffix in {'.bit', '.bin', '.xsa', '.hwh', '.xclbin', '.elf', '.dtbo'}:
            categories.append('board/artifacts/index')
        if suffix in {'.mem', '.hex', '.coe', '.pgm', '.npy', '.npz', '.safetensors'} or 'fixture' in text_parts or '/maps/' in '/'+text_parts:
            categories.append('data/reference')
        if (suffix in {'.log', '.json', '.csv', '.txt'} and
                (project == 'ofdm' and str(rel).startswith('sim/') or
                 project == 'hls' and any(t in text_parts for t in ('/sim/', '/csim/', 'validation', 'comparison')))):
            categories.append('sim/results/imported')
        for category in categories:
            location = ROOT/category/project/rel
            link(location, path)
            indexes[category].append({'entry': str(location.relative_to(ROOT)),
                                      'target': row['destination'], 'source': row['source']})
        if suffix in {'.py', '.sh', '.tcl', '.xpr', '.cfg', '.service', '.mk', '.xml', '.launch'} or n in {'makefile', 'dockerfile'}:
            if int(row['bytes']) < 4 * 1024 * 1024:
                text = path.read_text(errors='replace')
                for number, line in enumerate(text.splitlines(), 1):
                    matches = sorted(set(re.findall(r'/(?:home|opt|tools|root)/[^\s\"\'<>;,)]+', line)))
                    for match in matches:
                        path_refs.append({'file': row['destination'], 'line': number, 'path': match[:500]})
    for category, entries in indexes.items():
        directory = ROOT/category
        directory.mkdir(parents=True, exist_ok=True)
        with (directory/'INDEX.csv').open('w', newline='') as f:
            writer = csv.DictWriter(f, fieldnames=['entry', 'target', 'source'])
            writer.writeheader()
            writer.writerows(entries)
    with (ROOT/'report/absolute_path_references.csv').open('w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=['file', 'line', 'path'])
        writer.writeheader()
        writer.writerows(path_refs)
    counts = {k: len(v) for k,v in indexes.items()}
    (ROOT/'report/category_counts.json').write_text(json.dumps(counts, indent=2)+'\n')
    print('INDEX_COMPLETE', json.dumps(counts), 'absolute_path_references',len(path_refs))


if __name__ == '__main__':
    main()