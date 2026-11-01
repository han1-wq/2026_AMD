#!/usr/bin/env python3
"""Copy explicitly selected local projects without changing their source trees."""
import argparse
import csv
import hashlib
import json
import os
from pathlib import Path
import platform
import re
import shutil
import subprocess
from datetime import datetime, timezone

ROOT = Path(__file__).resolve().parents[1]
PROJECTS = [
    ('ofdm', '/home/amd/eeSDR_ofdm_loopback', 'src/ofdm/eeSDR_ofdm_loopback'),
    ('hls', '/home/amd/Workspace/HLS_IP', 'src/kv260/HLS_IP'),
    ('dpu_platform', '/home/amd/Workspace/dpu_platform2', 'src/kv260/dpu_platform2'),
    ('b3136', '/home/amd/kv260_B3136', 'src/ps/kv260_B3136'),
    ('x3plus', '/home/amd/x3plus-kv260-docker', 'src/ps/x3plus-kv260-docker'),
    ('lerobot', '/home/amd/lerobot-deploy', 'src/ps/lerobot-deploy'),
    ('roarm', '/home/amd/roarm_ws', 'src/ps/roarm_ws'),
    ('roarm_console', '/home/amd/roarm-vision-console', 'src/host/roarm-vision-console'),
    ('launcher', '/home/amd/kv260-launcher-ai', 'src/host/kv260-launcher-ai'),
    ('ofa_legacy', '/home/amd/kv260_ofa_yolo_deploy', 'src/ps/kv260_ofa_yolo_deploy'),
    ('ros_legacy', '/home/amd/kv260_yolo_ros', 'src/ps/kv260_yolo_ros'),
]
SPLITS = {
    'ofdm': {
        'build_hw': 'build/projects/ofdm/build_hw',
        'build_sw': 'build/projects/ofdm/build_sw',
        'sim': 'sim/ofdm',
        'sim/captures': 'data/ofdm/captures',
    },
    'hls': {
        'image_preprocess/build': 'build/hls/image_preprocess',
        'yolo_postprocess/build': 'build/hls/yolo_postprocess',
        'timing_extreme_20261014': 'build/hls/timing_extreme_20261014',
        'timing_margin_20261013': 'build/hls/timing_margin_20261013',
    },
    'dpu_platform': {
        'kv260_vitis_platform/dpu_trd_system_hw_link': 'build/projects/kv260/dpu_trd_system_hw_link',
        'bd_accelerator_integration/check_project': 'build/projects/kv260/bd_check_project',
    },
    'b3136': {
        'overlay': 'board/artifacts/kv260_B3136/overlay',
        'compiled': 'data/models/kv260_B3136/compiled',
        'logs': 'board/results/imported/kv260_B3136',
    },
    'lerobot': {
        'workspace': 'data/lerobot/workspace',
        'artifacts': 'build/environment/lerobot',
        'logs': 'board/results/imported/lerobot',
    },
    'roarm_console': {
        'inspection': 'board/results/imported/roarm_console',
        'skills': 'skill/imported/roarm_console',
    },
    'ofa_legacy': {
        'overlay': 'board/artifacts/ofa_legacy/overlay',
        'compiled': 'data/models/ofa_legacy/compiled',
        'minicpm_results': 'board/results/imported/ofa_legacy/minicpm',
        'smollm2_results': 'board/results/imported/ofa_legacy/smollm2',
    },
    'ros_legacy': {},
}
for _name in ('kv260_ofa_yolo_deploy', 'kv260_yolov4_deploy'):
    SPLITS['ros_legacy'][f'{_name}/overlay'] = f'board/artifacts/ros_legacy/{_name}/overlay'
    SPLITS['ros_legacy'][f'{_name}/compiled'] = f'data/models/ros_legacy/{_name}/compiled'

SKIP_DIRS = {'.git', '.venv', 'venv', '__pycache__', '.pytest_cache', '.mypy_cache',
             'node_modules', '.cache', '.Xil', '.ipcache', 'ip_cache', '.metadata',
             '.analytics', '.dide', '.ssh', '.aws', '.azure', '.config',
             'RemoteSystemsTempFiles', '.ipynb_checkpoints', 'backups'}
SKIP_SUFFIXES = {'.pyc', '.pyo', '.o', '.obj', '.dcp', '.rpx', '.wdb', '.wlf',
                 '.vvp', '.str', '.jou', '.sdb', '.reloc', '.wcfg', '.swp'}
SECRET_NAMES = {'api.key', 'session.key', 'ui.token', 'id_rsa', 'id_ed25519',
                'id_ecdsa', 'id_dsa', 'authorized_keys', 'known_hosts', '.netrc',
                '.npmrc', '.pypirc', 'credentials', 'credentials.json',
                'token.json', 'tokens.json', 'secrets.json', 'secrets.yaml'}
SECRET_PATTERNS = [
    re.compile(rb'-----BEGIN (?:RSA |EC |OPENSSH |DSA )?PRIVATE KEY-----'),
    re.compile(rb'\b(?:sk-(?:proj-|svcacct-)?[A-Za-z0-9_-]{25,}|gh[pousr]_[A-Za-z0-9]{30,}|hf_[A-Za-z0-9]{30,}|AKIA[A-Z0-9]{16})\b'),
    re.compile(rb'(?i)(?:authorization["\s:]+bearer\s+)[A-Za-z0-9._-]{24,}'),
]


def secret_name(name):
    n = name.lower()
    return (n in SECRET_NAMES or n.endswith(('.key', '.token', '.pem', '.p12', '.pfx'))
            or (n.endswith('.env') and not n.endswith('.example'))
            or (n.startswith('.env') and not n.endswith(('.example', '.sample', '.template'))))


def skip_reason(project, rel, is_dir):
    n = rel.name
    # Pinned ROS apt repository PUBLIC key is a Docker build dependency, not a secret.
    if project == 'x3plus' and str(rel) == 'context/ros.key' and not is_dir:
        source = Path('/home/amd/x3plus-kv260-docker/context/ros.key')
        if hashlib.sha256(source.read_bytes()).hexdigest() == '4a91c49af0d6f0016108b93698782b596c27ccd836937e18e0e36c3347dc602f':
            return None
        return 'public_repository_key_checksum_mismatch'
    if secret_name(n):
        return 'sensitive_filename'
    if is_dir and (n in SKIP_DIRS or n.endswith(('.cache', '.hw', '.ip_user_files'))):
        return 'cache_or_generated_directory'
    if project == 'lerobot' and str(rel).startswith('workspace/cache'):
        return 'dependency_download_cache'
    if project == 'ros_legacy' and len(rel.parts) > 1 and rel.parts[0] == 'ros2_ws_src' and rel.parts[1] in {'build', 'install', 'log'}:
        return 'architecture_specific_ros_output'
    if not is_dir:
        if rel.suffix.lower() in SKIP_SUFFIXES:
            return 'intermediate_output'
        if n.lower().endswith(('.zip', '.tar', '.tar.gz', '.tgz', '.tar.bz2', '.tar.xz', '.7z')):
            return 'opaque_archive_excluded_for_secret_review'
    return None


def mapped(project, rel, base):
    matches = [(Path(k), Path(v)) for k, v in SPLITS.get(project, {}).items()
               if rel == Path(k) or Path(k) in rel.parents]
    if matches:
        source, dest = max(matches, key=lambda x: len(x[0].parts))
        return ROOT / dest / rel.relative_to(source)
    return ROOT / base / rel


def digest(path):
    h = hashlib.sha256()
    with path.open('rb') as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b''):
            h.update(chunk)
    return h.hexdigest()


def create_link(path, target):
    path.parent.mkdir(parents=True, exist_ok=True)
    text = os.path.relpath(target, path.parent)
    if path.is_symlink() and os.readlink(path) == text:
        return
    if path.exists() or path.is_symlink():
        raise RuntimeError(f'Refusing to overwrite existing link location: {path}')
    path.symlink_to(text, target_is_directory=target.is_dir())


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--copy', action='store_true', help='copy into this delivery directory')
    args = parser.parse_args()
    if not args.copy:
        parser.error('Explicit --copy is required; this never builds or programs hardware')
    marker = ROOT / 'report/source_manifest.csv'
    if marker.exists():
        parser.error('A completed source manifest already exists; refusing to recopy')
    excluded, rows, sources, links = [], [], [], []
    planned_links = []
    for project, source_text, base in PROJECTS:
        source = Path(source_text)
        if not source.is_dir():
            sources.append({'project': project, 'source': source_text, 'status': 'missing'})
            continue
        rev = subprocess.run(['git', '-C', str(source), 'rev-parse', 'HEAD'],
                             capture_output=True, text=True, timeout=10)
        info = {'project': project, 'source': source_text, 'destination': base,
                'git_commit': rev.stdout.strip() if rev.returncode == 0 else None,
                'status': 'copied', 'files': 0, 'bytes': 0}
        if project == 'lerobot':
            commit_file = source / 'SOURCE_COMMIT'
            if commit_file.is_file():
                info['recorded_lerobot_commit'] = commit_file.read_text().strip()
        for relative, target in sorted(SPLITS.get(project, {}).items(), key=lambda x: len(Path(x[0]).parts)):
            rel = Path(relative)
            if not (source / rel).is_dir():
                continue
            # Resolve only ancestor split, not the directory's own split.
            parent_location = mapped(project, rel.parent, base)
            location = parent_location / rel.name
            canonical = ROOT / target
            canonical.mkdir(parents=True, exist_ok=True)
            planned_links.append((location, canonical, 'classification_directory'))
        for directory, dirs, files in os.walk(source, followlinks=False):
            directory = Path(directory)
            kept = []
            for name in sorted(dirs):
                path = directory / name
                rel = path.relative_to(source)
                reason = skip_reason(project, rel, True)
                if reason:
                    excluded.append({'project': project, 'path': str(rel), 'reason': reason})
                elif path.is_symlink():
                    links.append((project, path, mapped(project, rel, base)))
                else:
                    kept.append(name)
            dirs[:] = kept
            for name in sorted(files):
                path = directory / name
                rel = path.relative_to(source)
                reason = skip_reason(project, rel, False)
                if reason:
                    excluded.append({'project': project, 'path': str(rel), 'reason': reason})
                    continue
                if path.is_symlink():
                    links.append((project, path, mapped(project, rel, base)))
                    continue
                if not path.is_file():
                    excluded.append({'project': project, 'path': str(rel), 'reason': 'not_regular_file'})
                    continue
                before = path.stat()
                h = hashlib.sha256()
                secret = False
                previous = b''
                with path.open('rb') as f:
                    for chunk in iter(lambda: f.read(1024 * 1024), b''):
                        h.update(chunk)
                        if any(pattern.search(previous + chunk) for pattern in SECRET_PATTERNS):
                            secret = True
                        previous = chunk[-512:]
                if secret:
                    excluded.append({'project': project, 'path': str(rel), 'reason': 'possible_credential_content'})
                    continue
                dest = mapped(project, rel, base)
                dest.parent.mkdir(parents=True, exist_ok=True)
                if dest.exists():
                    if dest.is_symlink() or digest(dest) != h.hexdigest():
                        raise RuntimeError(f'Destination collision: {dest}')
                else:
                    shutil.copy2(path, dest)
                after = path.stat()
                if (before.st_size, before.st_mtime_ns) != (after.st_size, after.st_mtime_ns):
                    raise RuntimeError(f'Source changed during copy: {path}')
                rows.append({'project': project, 'source': str(path),
                             'destination': str(dest.relative_to(ROOT)),
                             'bytes': before.st_size, 'sha256': h.hexdigest()})
                info['files'] += 1
                info['bytes'] += before.st_size
        sources.append(info)
        print(json.dumps(info, ensure_ascii=False), flush=True)
    for project, source_link, dest in links:
        try:
            resolved = source_link.resolve(strict=True)
        except (FileNotFoundError, RuntimeError):
            excluded.append({'project': project, 'path': str(source_link), 'reason': 'broken_source_symlink'})
            continue
        translated = None
        for target_project, target_source, target_base in PROJECTS:
            try:
                rel = resolved.relative_to(target_source)
            except ValueError:
                continue
            translated = mapped(target_project, rel, target_base)
            break
        if translated is None or not translated.exists():
            excluded.append({'project': project, 'path': str(source_link), 'reason': 'external_or_excluded_symlink_target'})
            continue
        planned_links.append((dest, translated, 'translated_source_symlink'))
    link_rows = []
    for location, target, reason in planned_links:
        create_link(location, target)
        link_rows.append({'path': str(location.relative_to(ROOT)),
                          'target': os.readlink(location), 'reason': reason})
    with marker.open('x', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=['project', 'source', 'destination', 'bytes', 'sha256'])
        writer.writeheader()
        writer.writerows(rows)
    environment = {'packaged_at_utc': datetime.now(timezone.utc).isoformat(),
                   'platform': platform.platform(), 'machine': platform.machine(),
                   'python': platform.python_version(), 'projects': sources,
                   'files': len(rows), 'bytes': sum(r['bytes'] for r in rows),
                   'source_modified': False, 'hardware_actions': False}
    for name, value in [('source_inventory.json', environment), ('excluded_files.json', excluded),
                        ('source_links.json', link_rows)]:
        (ROOT / 'report' / name).write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n')
    print('PACKAGING_COPY_COMPLETE', len(rows), environment['bytes'], flush=True)


if __name__ == '__main__':
    main()