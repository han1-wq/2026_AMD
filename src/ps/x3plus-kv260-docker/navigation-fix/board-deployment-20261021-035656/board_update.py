#!/usr/bin/env python3
"""Session-specific, idle-only backup/install/rollback. Never starts robot nodes."""
import ast
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tarfile
import xml.etree.ElementTree as ET

SESSION = Path(__file__).resolve().parent
BASE = SESSION.parents[1]
STAGE = SESSION / 'staging'
BACKUP = SESSION / 'backup'
CONTAINER = 'x3plus-robot'


def run(args, data=None, timeout=60):
    result = subprocess.run(args, input=data, stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE, timeout=timeout)
    if result.returncode:
        raise RuntimeError('%r: %s' % (args, result.stderr.decode(errors='replace')))
    return result.stdout


def write(path, value):
    path.write_text(json.dumps(value, indent=2, ensure_ascii=False) + '\n')


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def idle():
    nodes = run(['docker', 'exec', CONTAINER, 'bash', '-c',
                 'source /opt/ros/melodic/setup.bash; timeout 8 rosnode list']).decode().splitlines()
    assert set(nodes) <= {'/rosout'}, 'Active ROS nodes; refusing update: %r' % nodes
    return nodes


def runtime_hashes(paths):
    script = ('import hashlib,json,os,sys; paths=json.load(sys.stdin); '
              'print(json.dumps({p:hashlib.sha256(open(p,"rb").read()).hexdigest() '
              'if os.path.isfile(p) else None for p in paths}))')
    return json.loads(run(['docker', 'exec', '-i', CONTAINER, 'python', '-c', script],
                          json.dumps(list(paths)).encode()))


def expected():
    return json.loads((SESSION / 'install-manifest.json').read_text())


def runtime_expected():
    return json.loads((SESSION / 'runtime-manifest.json').read_text())


def check_stage():
    for name, value in expected().items():
        assert not Path(name).is_absolute() and '..' not in Path(name).parts
        path = STAGE / name
        assert digest(path) == value, name
        if path.suffix == '.py':
            ast.parse(path.read_text())
        elif path.suffix == '.sh':
            run(['bash', '-n', str(path)])
        elif path.suffix in ('.xml', '.launch'):
            ET.parse(str(path))


def backup():
    check_stage()
    idle()
    BACKUP.mkdir(mode=0o700)
    host = {}
    names = set(expected())
    names.update(p.name for p in BASE.iterdir() if p.is_file() and
                 (p.suffix in ('.sh', '.py', '.env') or p.name == 'KV260.env'))
    for name in sorted(names):
        source = BASE / name
        host[name] = digest(source) if source.is_file() else None
        if source.is_file():
            dest = BACKUP / 'host' / name
            dest.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(str(source), str(dest))
    runtime = runtime_hashes(runtime_expected())
    for name, value in runtime.items():
        if value is None:
            continue
        saved = BACKUP / 'runtime' / name.lstrip('/')
        saved.parent.mkdir(parents=True, exist_ok=True)
        run(['docker', 'cp', CONTAINER + ':' + name, str(saved)])
        assert digest(saved) == value, name
    for container in (CONTAINER, 'x3plus-master'):
        (BACKUP / (container + '.inspect.json')).write_bytes(run(['docker', 'inspect', container]))
    (BACKUP / 'robot.diff.txt').write_bytes(run(['docker', 'diff', CONTAINER]))
    map_dir = Path('/home/ubuntu/x3plus-maps')
    maps = {p.name: digest(p) for p in map_dir.iterdir() if p.is_file()}
    with tarfile.open(str(BACKUP / 'maps.tar.gz'), 'w:gz') as tar:
        tar.add(str(map_dir), arcname='x3plus-maps')
    # File-level backup is the rollback authority. An image commit is only an
    # optional convenience and must not block a safe update on slow flash.
    write(BACKUP / 'baseline.json', dict(host=host, runtime=runtime, maps=maps,
                                       snapshot_tag=None, snapshot_image=None))
    idle()
    with tarfile.open(str(SESSION / 'predeployment-backup.tar.gz'), 'w:gz') as tar:
        tar.add(str(BACKUP), arcname='backup')
    write(SESSION / 'backup-result.json', dict(backup=str(BACKUP),
          archive_sha256=digest(SESSION / 'predeployment-backup.tar.gz'),
          host_files=len(host), runtime_files=len(runtime), maps=len(maps)))
    print('BOARD_BACKUP_PASS', flush=True)


def restore():
    idle()
    baseline = json.loads((BACKUP / 'baseline.json').read_text())
    for name in expected():
        dest = BASE / name
        if baseline['host'][name] is None:
            if dest.exists():
                dest.unlink()
        else:
            shutil.copy2(str(BACKUP / 'host' / name), str(dest))
    for name, value in baseline['runtime'].items():
        if value is None:
            run(['docker', 'exec', CONTAINER, 'rm', '-f', name])
        else:
            run(['docker', 'cp', str(BACKUP / 'runtime' / name.lstrip('/')), CONTAINER + ':' + name])
    assert runtime_hashes(baseline['runtime']) == baseline['runtime']
    for name in expected():
        path = BASE / name
        assert (digest(path) if path.is_file() else None) == baseline['host'][name]
    write(SESSION / 'rollback-result.json', dict(restored=True, nodes=idle()))
    print('BOARD_ROLLBACK_PASS', flush=True)


def install():
    check_stage()
    idle()
    baseline = json.loads((BACKUP / 'baseline.json').read_text())
    for name, value in baseline['host'].items():
        path = BASE / name
        assert (digest(path) if path.is_file() else None) == value, 'Host changed: ' + name
    assert runtime_hashes(baseline['runtime']) == baseline['runtime'], 'Runtime changed'
    try:
        for name in expected():
            source, dest = STAGE / name, BASE / name
            dest.parent.mkdir(parents=True, exist_ok=True)
            temp = dest.with_name(dest.name + '.reviewed-install')
            shutil.copy2(str(source), str(temp))
            temp.chmod(0o755 if source.suffix in ('.py', '.sh') else 0o644)
            os.replace(str(temp), str(dest))
        run(['/usr/bin/python3', str(BASE / 'navigation-fix/sync-runtime.py')], timeout=180)
        verify()
    except Exception as exc:
        (SESSION / 'install-failure.txt').write_text(repr(exc) + '\n')
        restore()
        raise
    print('BOARD_INSTALL_PASS', flush=True)


def verify():
    for name, value in expected().items():
        assert digest(BASE / name) == value, name
    runtime = runtime_expected()
    assert runtime_hashes(runtime) == runtime, 'Runtime hash mismatch'
    run(['/usr/bin/python3', str(BASE / 'navigation-fix/sync-runtime.py'), '--check'])
    script = ('import ast,json,sys; paths=json.load(sys.stdin); '
              '[ast.parse(open(p).read()) for p in paths if p.endswith(".py")]; '
              'print("PYTHON2_RUNTIME_PARSE_PASS")')
    run(['docker', 'exec', '-i', CONTAINER, 'python', '-c', script], json.dumps(list(runtime)).encode())
    nodes_output = run(['docker', 'exec', CONTAINER, 'bash', '-c',
        'set -e; source /opt/ros/melodic/setup.bash; source /opt/x3plus_ws/devel/setup.bash; '
        'python -c "import actionlib,tf,numpy; from std_srvs.srv import Trigger; '
        'from move_base_msgs.msg import MoveBaseAction"; '
        'ROBOT_TYPE=X3plus roslaunch --nodes yahboomcar_nav yahboomcar_navigation.launch '
        'use_rviz:=false map:=/maps/cde']).decode()
    assert '/navigation_guard' in nodes_output and '/move_base' in nodes_output, nodes_output
    baseline = json.loads((BACKUP / 'baseline.json').read_text())
    for name, value in baseline['maps'].items():
        assert digest(Path('/home/ubuntu/x3plus-maps') / name) == value, 'Map changed: ' + name
    write(SESSION / 'install-result.json', dict(installed=expected(), runtime=runtime,
          backup=str(BACKUP), nodes=idle(), launch_nodes=nodes_output.splitlines(),
          python2_parse=True, maps_unchanged=True, hardware_started=False,
          physical_navigation_verified=False))
    print('BOARD_INSTALL_VERIFY_PASS', flush=True)


if __name__ == '__main__':
    {'backup': backup, 'install': install, 'verify': verify, 'rollback': restore}[sys.argv[1]]()