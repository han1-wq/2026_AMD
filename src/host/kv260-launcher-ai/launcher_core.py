"""Read-only discovery and low-cost telemetry. Python standard library only.

Importing this module never opens a serial port, starts Docker, or publishes ROS.
"""
import json
import os
import re
import shlex
import stat
import subprocess
import xmlrpc.client
from dataclasses import asdict, dataclass
from pathlib import Path
from launcher_network import resolve

BASE = Path(__file__).resolve().parent
MAP_PATTERN = re.compile(r"[A-Za-z0-9][A-Za-z0-9_-]{0,63}\Z")


def read_config(path=BASE / "KV260.env"):
    """Parse literal export assignments, never eval arbitrary shell code."""
    values = {}
    if path.exists():
        for number, line in enumerate(path.read_text().splitlines(), 1):
            parts = shlex.split(line, comments=True)
            if not parts:
                continue
            if len(parts) != 2 or parts[0] != "export" or "=" not in parts[1]:
                raise ValueError("%s:%s: 仅支持 export KEY=字面值" % (path, number))
            name, value = parts[1].split("=", 1)
            if not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", name):
                raise ValueError("无效配置键: " + name)
            values[name] = value
    return values


def read_env(path=BASE / "KV260.env"):
    values = read_config(path)
    values.update(os.environ)
    try:
        return resolve(values)
    except (ValueError, OSError, RuntimeError, subprocess.SubprocessError) as exc:
        # Monitoring and stop actions must remain available while offline.
        values['ROS_NETWORK_ERROR'] = str(exc)
        return values


def text(path):
    try:
        return path.read_text().strip()
    except (OSError, UnicodeError):
        return ""


@dataclass(frozen=True)
class SerialDevice:
    path: str
    vid: str
    pid: str
    serial: str
    interface: str
    location: str
    product: str = ""


def discover_serial(sys_tty=Path('/sys/class/tty'), dev=Path('/dev')):
    devices = []
    for node in sorted(sys_tty.glob('tty*')):
        if not node.name.startswith(('ttyUSB', 'ttyACM')):
            continue
        interface = ''
        resolved = node.resolve()
        for parent in (resolved, *resolved.parents):
            if not interface:
                interface = text(parent / 'bInterfaceNumber').lower()
            vid, pid = text(parent / 'idVendor'), text(parent / 'idProduct')
            if vid and pid:
                # Stop at the nearest USB device: never inherit hub serials.
                devices.append(SerialDevice(str(dev / node.name), vid.lower(),
                    pid.lower(), text(parent / 'serial'), interface,
                    parent.name, text(parent / 'product')))
                break
    return devices


def select_device(devices, vid, pid, serial='', interface='', location=''):
    if not re.fullmatch(r'[0-9a-fA-F]{4}', vid) or not re.fullmatch(r'[0-9a-fA-F]{4}', pid):
        raise ValueError('VID/PID 必须为四位十六进制')
    if not re.fullmatch(r'[0-9a-fA-F]{2}', interface):
        raise ValueError('必须指定两位十六进制 USB 接口号；未知接口不接受')
    matches = [d for d in devices if d.vid == vid.lower() and d.pid == pid.lower()
               and (not serial or d.serial == serial)
               and (not interface or d.interface == interface.lower())
               and (not location or d.location == location)]
    if not matches:
        raise ValueError('未找到符合身份条件的设备')
    if len(matches) != 1:
        raise ValueError('发现 %d 个匹配设备；拒绝猜测，请配置序列号或 USB 位置' % len(matches))
    return matches[0]


def validate_alias(alias, device):
    path = Path(alias)
    if not alias.startswith('/dev/') or re.fullmatch(r'/dev/tty(?:USB|ACM)\d+', alias):
        raise ValueError('必须使用稳定 /dev 别名，而不是 tty 编号')
    try:
        if not stat.S_ISCHR(path.stat().st_mode):
            raise ValueError('别名不是字符设备: ' + alias)
        if path.resolve() != Path(device.path).resolve():
            raise ValueError('别名指向错误设备: %s → %s，期望 %s' %
                             (alias, path.resolve(), device.path))
    except OSError as exc:
        raise ValueError('设备别名不可用: %s (%s)' % (alias, exc)) from exc


def serial_status(env, devices=None):
    devices = discover_serial() if devices is None else devices
    result = {}
    for role, vid, pid, alias in [('ROBOT', '1a86', '7523', '/dev/myserial'),
                                  ('LIDAR', '10c4', 'ea60', '/dev/ydlidar')]:
        path = env.get(role + '_SERIAL', alias)
        try:
            device = select_device(devices, env.get(role + '_USB_VID', vid),
                env.get(role + '_USB_PID', pid), env.get(role + '_USB_SERIAL', ''),
                env.get(role + '_USB_INTERFACE', '00'), env.get(role + '_USB_LOCATION', ''))
            validate_alias(path, device)
            result[role] = {'ok': True, 'message': path + ' → ' + device.path,
                            'device': asdict(device)}
        except ValueError as exc:
            result[role] = {'ok': False, 'message': str(exc)}
    if all(item['ok'] for item in result.values()) and (
            result['ROBOT']['device']['path'] == result['LIDAR']['device']['path']):
        for item in result.values():
            item.update(ok=False, message='底盘和雷达不能使用同一个串口')
    return result


def require_serial(env):
    status = serial_status(env)
    failures = ['%s: %s' % (role, item['message']) for role, item in status.items()
                if not item['ok']]
    if failures:
        raise ValueError('; '.join(failures))
    return status


def command(args, timeout=3):
    proc = subprocess.run(args, capture_output=True, text=True, timeout=timeout,
                          check=False)
    if proc.returncode:
        raise RuntimeError((proc.stderr or proc.stdout or '命令失败')[-1000:].strip())
    return proc.stdout


def check_container_devices(env, name=None):
    name = name or env.get('ROBOT_NAME', 'x3plus-robot')
    output = command(['docker', 'exec', name, 'stat', '-Lc', '%t:%T',
                      '/dev/robot', '/dev/lidar']).splitlines()
    expected = []
    for key, default in [('ROBOT_SERIAL', '/dev/myserial'), ('LIDAR_SERIAL', '/dev/ydlidar')]:
        dev = Path(env.get(key, default)).stat().st_rdev
        expected.append('%x:%x' % (os.major(dev), os.minor(dev)))
    if output != expected:
        raise ValueError('容器设备映射已过期！请先停用机器人，再停止/重启容器；不会自动重启驱动。')
    return '设备号一致（不代表驱动/通信健康）'


class TimeoutTransport(xmlrpc.client.Transport):
    def make_connection(self, host):
        conn = super().make_connection(host)
        conn.timeout = 1.5
        return conn


def ros_nodes(uri):
    with xmlrpc.client.ServerProxy(uri, transport=TimeoutTransport()) as proxy:
        code, message, groups = proxy.getSystemState('/kv260_launcher_monitor')
        if code != 1:
            raise RuntimeError(message)
        return sorted({node for group in groups for _, nodes in group for node in nodes})


class Monitor:
    def __init__(self, env):
        self.env = env
        self.previous_cpu = None

    def snapshot(self):
        self.env = read_env()
        devices = discover_serial()
        result = {'network': self.env.get('ROS_NETWORK_ERROR') or self.env.get('ROS_MASTER_URI', ''), 'serial': serial_status(self.env, devices),
                  'devices': [asdict(d) for d in devices]}
        mem = {}
        for line in Path('/proc/meminfo').read_text().splitlines():
            key, value = line.split(':', 1)
            mem[key] = int(value.strip().split()[0])
        result['memory'] = {'total': mem['MemTotal'] / 1024,
                            'available': mem['MemAvailable'] / 1024}
        ticks = list(map(int, Path('/proc/stat').read_text().splitlines()[0].split()[1:9]))
        total, idle = sum(ticks), ticks[3] + ticks[4]
        result['cpu'] = None
        if self.previous_cpu:
            dt, di = total - self.previous_cpu[0], idle - self.previous_cpu[1]
            if dt > 0:
                result['cpu'] = max(0, min(100, 100 * (dt - di) / dt))
        self.previous_cpu = total, idle
        result['load'] = os.getloadavg()[0]
        result['pressure'] = text(Path('/proc/pressure/memory')).splitlines()[:1]
        try:
            rows = command(['docker', 'ps', '-a', '--format', '{{.Names}}\t{{.State}}'])
            result['containers'] = dict(row.split('\t', 1) for row in rows.splitlines())
            robot = self.env.get('ROBOT_NAME', 'x3plus-robot')
            if result['containers'].get(robot) == 'running' and all(
                    item['ok'] for item in result['serial'].values()):
                try:
                    result['mapping'] = check_container_devices(self.env, robot)
                except (ValueError, OSError, RuntimeError, subprocess.TimeoutExpired) as exc:
                    result['mapping_error'] = str(exc)
        except (OSError, RuntimeError, subprocess.TimeoutExpired) as exc:
            result['docker_error'] = str(exc)
        try:
            result['nodes'] = ros_nodes(self.env.get('ROS_MASTER_URI', 'http://127.0.0.1:11311'))
        except (OSError, RuntimeError, ValueError, xmlrpc.client.Error) as exc:
            result['ros_error'] = str(exc)
        camera = self.env.get('ASTRA_COLOR_DEVICE',
            '/dev/v4l/by-id/usb-Astra_Pro_HD_Camera_Astra_Pro_HD_Camera-video-index0')
        result['camera'] = Path(camera).exists()
        result['camera_path'] = camera
        return result


if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser(description='只读 USB/容器身份校验；绝不打开串口')
    parser.add_argument('--check', action='store_true')
    parser.add_argument('--container')
    parser.add_argument('--shell-env', action='store_true')
    args = parser.parse_args()
    config = read_env()
    if args.shell_env:
        for key, value in config.items():
            if key not in os.environ or os.environ[key] != value:
                print('export %s=%s' % (key, shlex.quote(value)))
        raise SystemExit(0)
    if args.check:
        status = serial_status(config)
        print(json.dumps(status, ensure_ascii=False, indent=2))
        raise SystemExit(0 if all(d['ok'] for d in status.values()) else 1)
    if args.container:
        try:
            print(check_container_devices(config, args.container))
        except (ValueError, OSError, RuntimeError, subprocess.TimeoutExpired) as error:
            parser.exit(1, str(error) + '\n')
    else:
        print(json.dumps([asdict(d) for d in discover_serial()], ensure_ascii=False, indent=2))