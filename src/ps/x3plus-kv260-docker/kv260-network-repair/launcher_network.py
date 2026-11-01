"""Network selection and lossless, idle-container network migration."""
import http.client
import json
import os
from pathlib import Path
import socket
import subprocess
import time
from urllib.parse import urlsplit, quote

BACKUP_ROOT = Path(__file__).resolve().parent / 'network-backups'


def command(args, timeout=10):
    result = subprocess.run(args, capture_output=True, text=True, timeout=timeout)
    if result.returncode:
        raise RuntimeError((result.stderr or result.stdout).strip())
    return result.stdout.strip()


def resolve(env):
    env = dict(env)
    env.pop('ROS_NETWORK_ERROR', None)
    if env.get('ROS_NETWORK_MODE', 'manual') != 'auto':
        return env
    rows = json.loads(command(['ip', '-j', '-4', 'addr', 'show', 'up']))
    addresses = [(row['ifname'], a['local']) for row in rows
                 for a in row.get('addr_info', []) if a.get('scope') == 'global'
                 and not row['ifname'].startswith(('docker', 'veth', 'br-'))]
    interface = env.get('ROS_NETWORK_INTERFACE', '')
    if interface:
        candidates = [addr for name, addr in addresses if name == interface]
    else:
        routes = json.loads(command(['ip', '-j', '-4', 'route', 'get', '1.1.1.1']))
        candidates = [routes[0].get('prefsrc', '')] if routes else []
        candidates = [addr for addr in candidates if addr in {ip for _, ip in addresses}]
    if len(candidates) != 1:
        raise ValueError('无法唯一确定 ROS 本机地址；检查网络或设置 ROS_NETWORK_INTERFACE。')
    port = env.get('ROS_MASTER_PORT', '11311')
    if not port.isascii() or not port.isdigit() or not 1 <= int(port) <= 65535:
        raise ValueError('ROS_MASTER_PORT 必须为 1–65535')
    env.update(ROS_HOSTNAME=candidates[0], ROS_IP=candidates[0],
               ROS_MASTER_URI='http://%s:%s' % (candidates[0], port))
    return env


def validate_local(env):
    if env.get('ROS_NETWORK_ERROR'):
        raise ValueError(env['ROS_NETWORK_ERROR'])
    rows = json.loads(command(['ip', '-j', '-4', 'addr', 'show', 'up']))
    addresses = {a['local'] for row in rows for a in row.get('addr_info', [])}
    host = env.get('ROS_HOSTNAME') or env.get('ROS_IP', '127.0.0.1')
    if host not in addresses:
        raise ValueError('ROS 地址 %s 不在本机网卡上；当前地址 %s。启用 ROS_NETWORK_MODE=auto 或修改配置。' %
                         (host, ', '.join(sorted(addresses))))
    uri = urlsplit(env.get('ROS_MASTER_URI', 'http://127.0.0.1:11311'))
    if uri.scheme != 'http' or uri.hostname not in addresses or not uri.port:
        raise ValueError('本机 Master 地址无效或已过期：' + uri.geturl())


def mismatch(info, env):
    old = dict(item.split('=', 1) for item in info['Config'].get('Env', []) if '=' in item)
    return any(old.get(key, '') != env.get(key, '')
               for key in ('ROS_MASTER_URI', 'ROS_HOSTNAME', 'ROS_IP'))


class DockerConnection(http.client.HTTPConnection):
    def connect(self):
        self.sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        self.sock.settimeout(self.timeout)
        self.sock.connect('/var/run/docker.sock')


def create_container(name, config):
    connection = DockerConnection('localhost', timeout=30)
    try:
        connection.request('POST', '/containers/create?name=' + quote(name),
                           json.dumps(config), {'Content-Type': 'application/json'})
        response = connection.getresponse()
        body = response.read().decode()
        if response.status != 201:
            raise RuntimeError('Docker 创建失败: ' + body)
    finally:
        connection.close()


def restart_policy_argument(policy):
    """Return the exact Docker CLI spelling for an inspected restart policy."""
    name = policy.get('Name') or 'no'
    retries = policy.get('MaximumRetryCount', 0)
    if name == 'on-failure' and retries:
        return '%s:%s' % (name, retries)
    return name


def restore_previous(name, backup, was_running, policy, renamed):
    """Best-effort recovery after any mutation in a network migration.

    The original name is normally free after a successful rename. If restoring
    that name fails, start the backup under its retained name rather than leave
    a previously-running ROS service stopped.
    """
    errors = []
    current = backup if renamed else name
    if renamed:
        try:
            command(['docker', 'rename', backup, name])
            current = name
        except Exception as exc:
            errors.append('恢复容器名称失败: %s' % exc)
    try:
        command(['docker', 'update', '--restart=' + restart_policy_argument(policy), current])
    except Exception as exc:
        errors.append('恢复重启策略失败: %s' % exc)
    if was_running:
        try:
            command(['docker', 'start', current], timeout=30)
        except Exception as exc:
            errors.append('恢复运行状态失败: %s' % exc)
    return errors


def ensure(name, env):
    validate_local(env)
    names = command(['docker', 'ps', '-a', '--format', '{{.Names}}']).splitlines()
    if name not in names:
        return
    info = json.loads(command(['docker', 'inspect', name]))[0]
    if not mismatch(info, env):
        return
    robot = env.get('ROBOT_NAME', 'x3plus-robot')
    if robot in names:
        robot_info = json.loads(command(['docker', 'inspect', robot]))[0]
        if robot_info['State']['Running']:
            processes = command(['docker', 'top', robot, '-eo', 'pid,comm']).splitlines()[1:]
            if any(line.split()[-1] != 'tail' for line in processes):
                raise ValueError('网络已变化，但机器人容器仍有运行进程。请先点击停止全部服务，再启动基础环境。')
    stamp = time.strftime('%Y%m%d-%H%M%S') + '-%d-%d' % (os.getpid(), time.time_ns())
    backup = name + '-network-backup-' + stamp
    image = name + ':network-' + stamp
    folder = BACKUP_ROOT / stamp
    folder.mkdir(parents=True)
    (folder / (name + '.json')).write_text(json.dumps(info, indent=2))
    was_running = bool(info.get('State', {}).get('Running'))
    policy = info.get('HostConfig', {}).get('RestartPolicy', {})
    print('网络变化：保留容器和快照，更新 %s → %s' % (name, env['ROS_MASTER_URI']), flush=True)
    try:
        if was_running:
            command(['docker', 'stop', '-t', '10', name], timeout=20)
        # Commit can be slow on the KV260's eMMC, especially after a large ROS log.
        command(['docker', 'commit', name, image], timeout=300)
    except Exception:
        # A stop can time out after Docker has already stopped the service, so
        # restore the recorded state for both stop and snapshot failures.
        restore_previous(name, name, was_running, policy, renamed=False)
        raise
    config = dict(info['Config'])
    config['Image'] = image
    values = dict(item.split('=', 1) for item in config.get('Env', []) if '=' in item)
    for key in ('ROS_MASTER_URI', 'ROS_HOSTNAME', 'ROS_IP'):
        values.pop(key, None)
        if env.get(key):
            values[key] = env[key]
    config['Env'] = ['%s=%s' % item for item in values.items()]
    # Docker's create API does not accept runtime-only inspect fields.
    config['HostConfig'] = dict(info['HostConfig'])
    renamed = False
    try:
        command(['docker', 'rename', name, backup])
        renamed = True
        command(['docker', 'update', '--restart=no', backup])
        create_container(name, config)
    except Exception as exc:
        errors = restore_previous(name, backup, was_running, policy, renamed)
        if errors:
            raise RuntimeError('%s；回滚不完整：%s' % (exc, '；'.join(errors))) from exc
        raise
    print('已保存旧容器 %s；挂载和可写层已保留。' % backup, flush=True)


if __name__ == '__main__':
    import sys
    from launcher_core import read_env
    try:
        ensure(sys.argv[1], read_env())
    except Exception as exc:
        print('网络检查失败：' + str(exc), file=sys.stderr)
        sys.exit(1)