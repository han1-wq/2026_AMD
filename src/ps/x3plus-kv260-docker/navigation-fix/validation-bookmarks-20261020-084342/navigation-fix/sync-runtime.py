#!/usr/bin/env python3
"""Idempotently install reviewed source files into an idle robot container."""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import time

BASE = Path(__file__).resolve().parents[1]
PACKAGE_FILES = ['launch/yahboomcar_navigation.launch', 'launch/view_navigate.launch',
                 'launch/library/amcl.launch', 'launch/library/move_base.launch',
                 'scripts/navigation_guard.py', 'scripts/send_mark.py',
                 'scripts/navigation_quality.py', 'scripts/navigation_bookmarks.py',
                 'rviz/yahboomcar_navigate.rviz', 'CMakeLists.txt', 'package.xml']
FILES = {BASE/'context/src/yahboomcar_nav'/name:
         '/opt/x3plus_ws/src/yahboomcar_nav/'+name for name in PACKAGE_FILES}
FILES[BASE/'context/src/yahboomcar_bringup/scripts/Mcnamu_X3plus.py'] = \
    '/opt/x3plus_ws/src/yahboomcar_bringup/scripts/Mcnamu_X3plus.py'


def command(args, **kwargs):
    return subprocess.run(args, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                          check=True, timeout=30, **kwargs).stdout


def sync(container, check_only=False):
    expected = {dest: hashlib.sha256(path.read_bytes()).hexdigest() for path, dest in FILES.items()}
    source = ('import hashlib,json,os,sys; paths=json.load(sys.stdin); '
              'print(json.dumps({p:hashlib.sha256(open(p,"rb").read()).hexdigest() '
              'if os.path.isfile(p) else None for p in paths}))')
    current = json.loads(command(['docker', 'exec', '-i', container, 'python', '-c', source],
                                 input=json.dumps(list(expected)).encode()))
    changed = [dest for dest in expected if current.get(dest) != expected[dest]]
    if not changed:
        print('Navigation runtime source checksums verified (%d files).' % len(FILES))
        return
    if check_only:
        raise RuntimeError('Runtime differs from reviewed source; stop hardware/navigation and run '
                           'navigation-fix/sync-runtime.py: '+', '.join(changed))
    nodes = command(['docker', 'exec', container, 'bash', '-c',
                     'source /opt/ros/melodic/setup.bash; rosnode list']).decode().splitlines()
    active = set(nodes)-{'/rosout'}
    if active:
        raise RuntimeError('Refusing to replace runtime while ROS nodes are active: '+', '.join(sorted(active)))
    backup = BASE/'navigation-fix/runtime-backups'/time.strftime('%Y%m%d-%H%M%S')
    for path, dest in FILES.items():
        if dest not in changed:
            continue
        if current.get(dest) is not None:
            saved = backup/dest.lstrip('/')
            saved.parent.mkdir(parents=True, exist_ok=True)
            command(['docker', 'cp', container+':'+dest, str(saved)])
        command(['docker', 'cp', str(path), container+':'+dest])
        if path.suffix == '.py':
            command(['docker', 'exec', container, 'chmod', '755', dest])
    sync(container, check_only=True)
    print('Runtime installed without starting nodes. Backup: '+str(backup))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--container', default='x3plus-robot')
    parser.add_argument('--check', action='store_true')
    args = parser.parse_args()
    try:
        sync(args.container, args.check)
    except (RuntimeError, OSError, subprocess.SubprocessError) as exc:
        parser.exit(1, str(exc)+'\n')