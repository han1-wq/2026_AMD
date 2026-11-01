#!/usr/bin/env python3
"""Verify copied content, internal links and sensitive-file exclusions, without hardware."""
import argparse
import ast
import csv
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
from datetime import datetime, timezone

ROOT = Path(__file__).resolve().parents[1]
EXCLUDED_MANIFEST_FILES = {'report/SHA256SUMS', 'report/package_files.json',
                         'report/verification.json', 'report/verification.log',
                         'report/verification.pid'}
SECRET_NAMES = {'api.key', 'session.key', 'ui.token', 'id_rsa', 'id_ed25519',
                'id_ecdsa', 'id_dsa', 'authorized_keys', 'known_hosts', '.netrc',
                '.npmrc', '.pypirc', 'credentials', 'credentials.json',
                'token.json', 'tokens.json', 'secrets.json', 'secrets.yaml'}
SECRET_PATTERNS = [
    re.compile(rb'-----BEGIN (?:RSA |EC |OPENSSH |DSA )?PRIVATE KEY-----'),
    re.compile(rb'\b(?:sk-(?:proj-|svcacct-)?[A-Za-z0-9_-]{25,}|gh[pousr]_[A-Za-z0-9]{30,}|hf_[A-Za-z0-9]{30,}|AKIA[A-Z0-9]{16})\b'),
    re.compile(rb'(?i)(?:authorization["\s:]+bearer\s+)[A-Za-z0-9._-]{24,}'),
]


def hash_scan(path, scan=False):
    h = hashlib.sha256()
    found = False
    previous = b''
    with path.open('rb') as f:
        for chunk in iter(lambda: f.read(1024*1024), b''):
            h.update(chunk)
            if scan and any(p.search(previous+chunk) for p in SECRET_PATTERNS):
                found = True
            previous = chunk[-512:]
    return h.hexdigest(), found


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--compare-originals', action='store_true', help='also read original files to detect source changes')
    parser.add_argument('--seal', action='store_true', help='create/update whole-package SHA256SUMS; no source files are changed')
    args = parser.parse_args()
    rows = list(csv.DictReader((ROOT/'report/source_manifest.csv').open()))
    copied = {r['destination']: r for r in rows}
    problems, links, files = [], [], []
    fingerprints = {}
    for directory, dirs, names in os.walk(ROOT, followlinks=False):
        for name in sorted(dirs+names):
            path = Path(directory)/name
            rel = str(path.relative_to(ROOT))
            if path.is_symlink():
                try:
                    target = path.resolve(strict=True)
                    if ROOT not in target.parents and target != ROOT:
                        problems.append({'file': rel, 'problem': 'link_outside_delivery'})
                    links.append({'path': rel, 'target': os.readlink(path)})
                except (OSError, RuntimeError):
                    problems.append({'file': rel, 'problem': 'broken_or_cyclic_link'})
                continue
            if not path.is_file() or rel in EXCLUDED_MANIFEST_FILES:
                continue
            low = name.lower()
            public_ros_key = (rel == 'src/ps/x3plus-kv260-docker/context/ros.key' and
                hash_scan(path)[0] == '4a91c49af0d6f0016108b93698782b596c27ccd836937e18e0e36c3347dc602f')
            if (low in SECRET_NAMES or low.endswith(('.key','.token','.pem','.p12','.pfx')) or
                low.endswith('.env') or (low.startswith('.env') and not low.endswith(('.example','.sample','.template')))):
                if not public_ros_key:
                    problems.append({'file': rel, 'problem': 'sensitive_filename'})
            value, secret = hash_scan(path, scan=True)
            fingerprints[rel] = value
            if secret:
                problems.append({'file': rel, 'problem': 'possible_credential_content'})
            if rel in copied and value != copied[rel]['sha256']:
                problems.append({'file': rel, 'problem': 'copied_content_hash_mismatch'})
            files.append({'path': rel, 'bytes': path.stat().st_size, 'sha256': value})
    for rel in copied:
        if rel not in fingerprints:
            problems.append({'file': rel, 'problem': 'manifest_file_missing'})
    if args.compare_originals:
        for row in rows:
            path = Path(row['source'])
            if not path.is_file() or hash_scan(path)[0] != row['sha256']:
                problems.append({'file': row['source'], 'problem': 'original_changed_since_copy'})
    # Only parse newly authored Python; legacy trees contain multiple Python versions.
    for name in ('build/package_sources.py', 'build/index_delivery.py',
                 'build/verify_delivery.py', 'sim/run_software_checks.py'):
        path = ROOT/name
        if path.exists():
            try:
                ast.parse(path.read_text(), filename=str(path))
            except SyntaxError as exc:
                problems.append({'file': name, 'problem': str(exc)})
    for name in ('build/build_hls.sh', 'build/build_ofdm_firmware.sh'):
        result = subprocess.run(['bash', '-n', str(ROOT/name)], capture_output=True, text=True)
        if result.returncode:
            problems.append({'file': name, 'problem': 'bash_syntax', 'detail': result.stderr})
    required = ['README.md','src/README.md','sim/README.md','build/README.md',
                'board/README.md','data/README.md','skill/README.md','report/README.md']
    for name in required:
        if not (ROOT/name).is_file() or not (ROOT/name).stat().st_size:
            problems.append({'file': name, 'problem': 'required_document_missing'})
    if args.seal and not problems:
        with (ROOT/'report/SHA256SUMS').open('w') as f:
            for item in sorted(files, key=lambda x:x['path']):
                f.write(item['sha256']+'  '+item['path']+'\n')
        (ROOT/'report/package_files.json').write_text(json.dumps({'files': files, 'links': links},ensure_ascii=False,indent=2)+'\n')
    result = {'checked_at_utc': datetime.now(timezone.utc).isoformat(),
              'files': len(files), 'bytes': sum(x['bytes'] for x in files),
              'source_files': len(rows), 'links': len(links), 'compared_originals': args.compare_originals,
              'hardware_actions': False, 'ok': not problems, 'problems': problems,
              'credential_scan_scope': 'filename rules and recognizable credential patterns; not a guarantee of publishability',
              'seal_exclusions': sorted(EXCLUDED_MANIFEST_FILES)}
    (ROOT/'report/verification.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
    print(json.dumps(result,ensure_ascii=False,indent=2),flush=True)
    return 0 if not problems else 1


if __name__ == '__main__':
    raise SystemExit(main())