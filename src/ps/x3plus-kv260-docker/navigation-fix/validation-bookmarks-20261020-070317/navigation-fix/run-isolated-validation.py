#!/usr/bin/env python3
"""Snapshot sources and start bounded, network/device-isolated ROS tests."""
import argparse
import datetime
import hashlib
import json
from pathlib import Path
import shutil
import shlex
import subprocess


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--tests', nargs='+', choices=('regression', 'integration', 'bookmark_regression', 'quality'),
                        default=['regression', 'integration', 'bookmark_regression', 'quality'])
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    stamp = datetime.datetime.now().strftime('%Y%m%d-%H%M%S')
    out = root/'navigation-fix'/('validation-bookmarks-'+stamp)
    out.mkdir()
    for directory in ('context/src/yahboomcar_nav', 'pc-console', 'remote-rviz'):
        shutil.copytree(root/directory, out/directory, ignore=shutil.ignore_patterns('__pycache__', '*.pyc'))
    (out/'navigation-fix').mkdir()
    for path in (root/'navigation-fix').glob('*'):
        if path.is_file() and path.suffix in ('.py', '.sh'):
            shutil.copy2(path, out/'navigation-fix'/path.name)
    hashes = {str(p.relative_to(out)): hashlib.sha256(p.read_bytes()).hexdigest()
              for p in sorted(out.rglob('*')) if p.is_file()}
    (out/'sources-sha256.json').write_text(json.dumps(hashes, indent=2))
    image = subprocess.check_output(['docker', 'image', 'inspect', 'x3plus:nav-test-amd64',
                                     '--format', '{{.Id}}'], text=True).strip()
    jobs = []
    for test in args.tests:
        name = 'x3plus-bookmarks-'+test.replace('_', '-')+'-'+stamp
        script = ('source /opt/ros/melodic/setup.bash; python /project/navigation-fix/test_navigation_quality.py'
                  if test == 'quality' else 'bash /project/navigation-fix/run-regression.sh '+test+'.py')
        command = ('timeout --signal=TERM --kill-after=10s 240s bash -c '+
                   shlex.quote(script)+' > /project/navigation-fix/'+test+'.log 2>&1; '
                   'rc=$?; echo $rc > /project/navigation-fix/'+test+'.exit; exit $rc')
        cid = subprocess.check_output(['docker', 'run', '-d', '--network', 'none',
                                       '--entrypoint', '/bin/bash', '--name', name,
                                       '-v', str(out)+':/project', image, '-c', command], text=True).strip()
        jobs.append({'test': test, 'container': name, 'id': cid})
    (out/'jobs.json').write_text(json.dumps({'directory': str(out), 'image': image, 'jobs': jobs,
        'scope': 'Network none; no host ROS, hardware, host devices or privileged mode; synthetic sensor data'}, indent=2))
    print(out)
    print(json.dumps(jobs, indent=2))


if __name__ == '__main__':
    main()