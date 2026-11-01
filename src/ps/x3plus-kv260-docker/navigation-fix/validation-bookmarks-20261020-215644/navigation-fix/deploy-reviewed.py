#!/usr/bin/env python3
"""Install a checksum-verified bundle on KV260 without starting any ROS nodes."""
import ast
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import tarfile
import tempfile
import time
import xml.etree.ElementTree as ET

BASE = Path('/home/ubuntu/x3plus-kv260-docker')


def run(args, **kwargs):
    r = subprocess.run(args, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                       timeout=40, check=True, **kwargs)
    return r.stdout


def main():
    archive = Path(__import__('sys').argv[1])
    with tempfile.TemporaryDirectory(prefix='nav-reviewed-') as directory:
        staging = Path(directory)
        with tarfile.open(str(archive)) as tar:
            assert all(not p.name.startswith('/') and '..' not in Path(p.name).parts and p.isfile()
                       for p in tar.getmembers()), 'Invalid archive members'
            tar.extractall(str(staging))
        manifest = json.loads((staging/'deployment-manifest.json').read_text())
        for name, expected in manifest.items():
            assert hashlib.sha256((staging/name).read_bytes()).hexdigest() == expected, name
            path = staging/name
            if path.suffix == '.sh':
                run(['bash', '-n', str(path)])
            elif path.suffix == '.py':
                ast.parse(path.read_text())
            elif path.suffix in ('.launch', '.xml'):
                ET.parse(str(path))
        nodes = run(['docker', 'exec', 'x3plus-robot', 'bash', '-c',
                     'source /opt/ros/melodic/setup.bash; rosnode list']).decode().splitlines()
        assert set(nodes) <= {'/rosout'}, 'ROS nodes became active; aborting deployment'
        old = json.loads((staging/'baseline-host-manifest.json').read_text())
        for name, expected in old.items():
            assert hashlib.sha256((BASE/name).read_bytes()).hexdigest() == expected, 'Concurrent host change: '+name
        runtime = json.loads((staging/'baseline-runtime-manifest.json').read_text())
        for dest, expected in runtime.items():
            actual = run(['docker', 'exec', 'x3plus-robot', 'sha256sum', dest]).decode().split()[0]
            assert actual == expected, 'Concurrent runtime change: '+dest
        backup = BASE/'navigation-fix/deployment-backups'/time.strftime('%Y%m%d-%H%M%S')
        backup.mkdir(parents=True)
        originals = {}
        for name in manifest:
            dest = BASE/name
            originals[name] = dest.exists()
            if dest.exists():
                saved = backup/'host'/name
                saved.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(str(dest), str(saved))
        runtime_saved = {}
        for dest in runtime:
            saved = backup/'runtime'/dest.lstrip('/')
            saved.parent.mkdir(parents=True, exist_ok=True)
            run(['docker', 'cp', 'x3plus-robot:'+dest, str(saved)])
            runtime_saved[dest] = saved
        try:
            for name in manifest:
                source, dest = staging/name, BASE/name
                dest.parent.mkdir(parents=True, exist_ok=True)
                temporary = dest.with_name(dest.name+'.nav-install')
                shutil.copy2(str(source), str(temporary))
                temporary.chmod(0o755 if source.suffix in ('.sh', '.py') else 0o644)
                os.replace(str(temporary), str(dest))
            run(['/usr/bin/python3', str(BASE/'navigation-fix/sync-runtime.py')])
            run(['docker', 'exec', 'x3plus-robot', 'bash', '-c',
                 'source /opt/ros/melodic/setup.bash; source /opt/x3plus_ws/devel/setup.bash; '
                 'python -c "import actionlib,tf,numpy; from std_srvs.srv import Trigger; '
                 'from move_base_msgs.msg import MoveBaseAction"; '
                 'ROBOT_TYPE=X3plus roslaunch --nodes yahboomcar_nav yahboomcar_navigation.launch '
                 'use_rviz:=false map:=/maps/x3plus_map'])
            nodes_after = run(['docker', 'exec', 'x3plus-robot', 'bash', '-c',
                              'source /opt/ros/melodic/setup.bash; rosnode list']).decode().splitlines()
            assert set(nodes_after) <= {'/rosout'}, 'Unexpected ROS nodes after installation'
        except Exception:
            for name, existed in originals.items():
                dest = BASE/name
                if existed:
                    shutil.copy2(str(backup/'host'/name), str(dest))
                elif dest.exists():
                    dest.unlink()
            for dest, saved in runtime_saved.items():
                run(['docker', 'cp', str(saved), 'x3plus-robot:'+dest])
            run(['docker', 'exec', 'x3plus-robot', 'rm', '-f',
                 '/opt/x3plus_ws/src/yahboomcar_nav/scripts/navigation_guard.py'])
            raise
        report = {'installed': manifest, 'backup': str(backup), 'nodes_after': nodes_after,
                  'hardware_started': False, 'navigation_started': False}
        (BASE/'navigation-fix/deployed.json').write_text(json.dumps(report, indent=2)+'\n')
        print(json.dumps(report, indent=2))
        print('NAVIGATION_FIX_DEPLOYMENT_PASS')


if __name__ == '__main__':
    main()