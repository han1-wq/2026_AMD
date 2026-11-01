"""Host-side configuration and bounded, noninteractive console operations."""

import ipaddress
import json
import math
import os
import subprocess
import sys
import tempfile
import time
from pathlib import Path

PROJECT = Path(__file__).resolve().parent
LAUNCHER = PROJECT.parent / "remote-rviz" / "start-pc-rviz.sh"
CONFIG = Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config")) / "x3plus-pc-console" / "config.json"
CONTAINER = "x3plus-pc-slam-rviz"
DEFAULTS = {"pc_ip": "", "kv260_ip": "", "port": "11311"}


def run(command, timeout=10, **kwargs):
    result = subprocess.run(command, capture_output=True, text=True, timeout=timeout, **kwargs)
    if result.returncode:
        raise RuntimeError((result.stderr or result.stdout).strip() or "命令执行失败：" + command[0])
    return result.stdout.strip()


def validate(data):
    if not isinstance(data, dict):
        raise ValueError("配置必须是 JSON 对象。")
    for key, label in (("pc_ip", "主机"), ("kv260_ip", "KV260")):
        try:
            if not isinstance(data[key], str):
                raise ValueError()
            address = ipaddress.IPv4Address(data[key])
            if address.is_unspecified or address.is_multicast or address.is_loopback or int(address) == 0xffffffff:
                raise ValueError()
        except (ValueError, KeyError, TypeError):
            raise ValueError(label + " IP 不是有效的单播 IPv4 地址。")
    port = data.get("port", "")
    if not isinstance(port, str) or not port.isascii() or not port.isdigit() or not 1 <= int(port) <= 65535:
        raise ValueError("ROS Master 端口必须为 1–65535。")
    return {"pc_ip": data["pc_ip"], "kv260_ip": data["kv260_ip"], "port": str(int(port))}


def master_url(data):
    return "http://%s:%s" % (data["kv260_ip"], data["port"])


def detect_pc_ip(kv_ip):
    try:
        ipaddress.IPv4Address(kv_ip)
        routes = json.loads(run(["ip", "-j", "-4", "route", "get", kv_ip], timeout=2))
        return routes[0].get("prefsrc", "")
    except (ValueError, IndexError, OSError, RuntimeError, subprocess.SubprocessError):
        return ""


def route_state(kv_ip):
    routes = json.loads(run(['ip', '-j', '-4', 'route', 'get', kv_ip], timeout=2))
    if not routes:
        return {}
    return {key: routes[0].get(key, '') for key in ('dev', 'gateway', 'prefsrc')}


def local_addresses():
    interfaces = json.loads(run(["ip", "-j", "-4", "addr", "show", "up"], timeout=2))
    return [(item["ifname"], addr["local"]) for item in interfaces
            for addr in item.get("addr_info", []) if addr.get("scope") == "global"]


def load_config():
    data = DEFAULTS.copy()
    warning = ""
    try:
        saved = json.loads(CONFIG.read_text(encoding="utf-8"))
        data.update(validate(saved))
    except FileNotFoundError:
        pass
    except (OSError, ValueError, TypeError, KeyError) as exc:
        warning = "无法读取配置，已使用默认值：" + str(exc)
    try:
        addresses = [address for _, address in local_addresses()]
        if not data["pc_ip"] or data["pc_ip"] not in addresses:
            detected = detect_pc_ip(data["kv260_ip"])
            if detected:
                if data["pc_ip"]:
                    warning += " 本机地址已变化，输入已更新为 %s；点击保存配置持久保存。" % detected
                data["pc_ip"] = detected
    except (OSError, RuntimeError, ValueError, subprocess.SubprocessError) as exc:
        warning += " 网卡检测失败：" + str(exc)
    return data, warning


def save_config(data):
    data = validate(data)
    atomic_json(CONFIG, data)


def atomic_json(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    descriptor, name = tempfile.mkstemp(prefix=path.name + '.', suffix='.tmp', dir=str(path.parent))
    temporary = Path(name)
    try:
        with os.fdopen(descriptor, 'w', encoding='utf-8') as stream:
            json.dump(data, stream, ensure_ascii=False, indent=2)
            stream.write('\n')
            stream.flush()
            os.fsync(stream.fileno())
        temporary.replace(path)
    finally:
        if temporary.exists():
            temporary.unlink()


def profiles():
    path = CONFIG.with_name('profiles.json')
    try:
        entries = json.loads(path.read_text(encoding='utf-8'))
    except FileNotFoundError:
        return {}
    if not isinstance(entries, dict):
        raise ValueError('网络方案文件格式错误，未覆盖原文件。')
    return {profile_name(name): validate(data) for name, data in entries.items()}


def profile_name(name):
    if not isinstance(name, str) or not name.strip() or len(name.strip()) > 40:
        raise ValueError('方案名称请输入 1–40 个字符。')
    return name.strip()


def save_profile(name, data):
    entries = profiles()
    entries[profile_name(name)] = validate(data)
    atomic_json(CONFIG.with_name('profiles.json'), entries)


def network_state(data, viewer):
    """Cheap checks only: no scanning, publishing or automatic reconfiguration."""
    try:
        data = validate(data)
        addresses = local_addresses()
        routing = route_state(data['kv260_ip'])
        route = detect_pc_ip(data['kv260_ip'])
        issues = []
        if data['pc_ip'] not in {address for _, address in addresses}:
            issues.append('主机 IP 已不在启用的网卡上')
        if not route:
            issues.append('没有到 KV260 的有效 IPv4 路由')
        elif route != data['pc_ip']:
            issues.append('路由源地址为 %s，与输入主机 IP 不同；请检查多网卡选择' % route)
        if viewer.get('error'):
            issues.append('无法确认 RViz 配置：' + viewer['error'])
        elif viewer.get('running') and (viewer['master'] != master_url(data) or viewer['pc_ip'] != data['pc_ip']):
            issues.append('RViz 仍使用其他网络配置，请重新连接')
        return {'ok': not issues, 'addresses': addresses, 'route': route,
                'routing': routing, 'issues': issues, 'master': master_url(data)}
    except (ValueError, OSError, RuntimeError, subprocess.SubprocessError) as exc:
        return {'ok': False, 'issues': [str(exc)], 'addresses': [], 'route': ''}


def probe_ok(result):
    received = result.get('received', {})
    laser = received.get('scan', {}).get('frame', 'laser')
    return (all(received.get(key, {}).get('count', 0) > 0 for key in ('map', 'scan'))
            and received.get('scan', {}).get('fresh', False)
            and all(result.get('tf', {}).get(key, {}).get('ok', False)
                    for key in ('map -> base_footprint', 'map -> ' + laser)))


def navigation_ok(result):
    received = result.get('received', {})
    pose = received.get('localization', {})
    state = received.get('navigation', {})
    return (probe_ok(result) and pose.get('count', 0) > 0 and pose.get('fresh', False)
            and state.get('fresh', False) and state.get('status', {}).get('ready') is True)


def navigation_message(result):
    item = result.get('received', {}).get('navigation', {})
    if not item.get('fresh'):
        return '未收到新鲜门控状态，请检查板端导航与连接'
    state = item.get('status', {})
    task = state.get('task_state')
    if state.get('goal_retained'):
        return '已停车并保留目标；稳定恢复后自动重新规划继续（已恢复 %s/%s 次）' % (
            state.get('resume_count', 0), state.get('max_auto_resumes', 2))
    if task == 'failed' and not state.get('initial_pose_required', False):
        return '本次导航已终止，不会自动续跑：' + state.get('task_reason', '请检查定位与规划状态')
    if task in ('navigating', 'replanning') and navigation_ok(result):
        return '正在%s原目标，包含最终朝向（已恢复 %s 次）' % (
            '重新规划前往' if task == 'replanning' else '前往', state.get('resume_count', 0))
    if navigation_ok(result):
        return '定位已确认，可直接发送新目标，无需重复设置初始位姿'
    labels = {'high_pose_uncertainty': '定位协方差超限', 'stale_scan': '激光数据过期',
              'stale_amcl_pose': 'AMCL 位姿过期', 'stale_tf': 'TF 过期',
              'scan_map_mismatch': '激光与地图不匹配', 'scan_ray_obstructed': '激光射线与地图冲突',
              'localization_jump': '定位跳变', 'waiting_map_scan_pose': '等待地图、激光或定位数据',
              'initial_pose_disagreement': '定位与人工初始位姿不一致',
              'amcl_restarted': 'AMCL 已重启', 'map_changed': '地图已更换'}
    reason = state.get('reason', 'unknown')
    fault = state.get('current_fault', '')
    required = state.get('initial_pose_required', reason.endswith('_initial_pose_required') or reason == 'initial_pose_required')
    if required:
        cause = state.get('latched_reason') or reason
        cause = cause.replace('_initial_pose_required', '')
        text = '需设置一次 2D Pose Estimate 或恢复起点定位'
        if cause != 'initial_pose_required':
            text += '；锁定原因：' + labels.get(cause, cause)
        if 'current_fault' in state:
            text += '；当前：' + (labels.get(fault, fault) if fault else '数据检查已恢复，等待人工确认')
        return text
    if reason in ('recovering_localization', 'verifying_scan_match'):
        return '停车验证定位，等待持续稳定后发送新目标；旧目标不会续跑'
    return '导航未放行：' + labels.get(fault or reason, fault or reason)


def diagnose(data):
    """Return each stage, including failures, so partial success is not hidden."""
    report = {'ok': False, 'steps': []}
    def step(name, function):
        try:
            result = function()
            if isinstance(result, dict) and result.get('ok') is False:
                raise RuntimeError(json.dumps(result, ensure_ascii=False))
            report['steps'].append({'name': name, 'ok': True, 'result': result})
            return result
        except Exception as exc:
            report['steps'].append({'name': name, 'ok': False, 'error': str(exc)})
            return None
    if step('输入配置', lambda: validate(data)) is None:
        return report
    viewer = step('查看器状态', viewer_state)
    step('本机网卡、路由与容器配置', lambda: network_state(data, viewer or {'error': 'Docker 检查失败'}))
    step('Master 与双向回连', lambda: json.loads(network_check(data)))
    if viewer and viewer.get('running'):
        sample = step('实际地图、雷达和 TF', lambda: probe(data))
        if sample is not None:
            report['steps'][-1]['ok'] = probe_ok(sample)
            report['probe'] = sample
            if viewer.get('mode') == 'navigation':
                report['steps'].append({'name': '板端定位确认与导航放行', 'ok': navigation_ok(sample),
                    'result': sample.get('received', {}).get('navigation', {}).get('status', {})})
    else:
        report['steps'].append({'name': '实际地图、雷达和 TF', 'ok': False,
                                'error': 'RViz 未运行，数据链路尚未验证。'})
    report['ok'] = all(item['ok'] for item in report['steps'])
    return report


def reconnect(data):
    data = validate(data)
    current = viewer_state()
    if not current.get('running'):
        raise ValueError('没有运行中的查看器，请选择启动 SLAM 或导航 RViz。')
    # The caller chooses the address; never silently override a manual NIC choice.
    output = launch(current['mode'], data, reconnect=True)
    report = diagnose(data)
    report.update(output=output, config=data)
    if report['ok']:
        save_config(data)
    return report


def viewer_state():
    # A Docker daemon failure must not be reported as an absent viewer.
    names = run(["docker", "container", "ls", "-a", "--format", "{{.Names}}"], timeout=5).splitlines()
    if CONTAINER not in names:
        return {"running": False}
    info = json.loads(run(["docker", "inspect", CONTAINER], timeout=5))[0]
    env = dict(value.split("=", 1) for value in info["Config"].get("Env", []) if "=" in value)
    return {
        "running": info["State"]["Running"],
        "mode": (info["Config"].get("Labels") or {}).get("x3plus.viewer.mode") or "slam",
        "master": env.get("ROS_MASTER_URI", ""),
        "pc_ip": env.get("ROS_HOSTNAME") or env.get("ROS_IP", ""),
        "exit_code": info["State"].get("ExitCode"),
    }


def launch(mode, data, reconnect=False):
    data = validate(data)
    if data["pc_ip"] not in [address for _, address in local_addresses()]:
        raise ValueError("主机 IP 不在当前启用的网卡上，请自动检测或选择正确地址。")
    env = dict(os.environ, KV260_IP=data["kv260_ip"], PC_ROS_IP=data["pc_ip"], ROS_MASTER_PORT=data["port"])
    return run(["bash", str(LAUNCHER), mode, "--reconnect" if reconnect else "--replace"], timeout=60, env=env)


def stop():
    return run(["bash", str(LAUNCHER), "stop"], timeout=20)


def network_check(data):
    data = validate(data)
    return run([sys.executable, str(LAUNCHER.parent / 'network-preflight.py'),
                master_url(data), data['pc_ip']], timeout=25)


def viewer_logs():
    result = subprocess.run(["docker", "logs", "--tail", "100", CONTAINER],
                            capture_output=True, text=True, timeout=10)
    output = (result.stdout + result.stderr).strip()
    if result.returncode:
        raise RuntimeError(output)
    return output


def status(data):
    try:
        result = subprocess.run([sys.executable, str(PROJECT / "ros-status.py"), "--master", master_url(data)],
                                capture_output=True, text=True, timeout=8)
        ros = json.loads(result.stdout or "{}")
    except (OSError, ValueError, subprocess.SubprocessError) as exc:
        ros = {'ok': False, 'error': str(exc)}
    try:
        viewer = viewer_state()
    except (OSError, RuntimeError, ValueError, subprocess.SubprocessError) as exc:
        viewer = {"error": str(exc)}
    return ros, viewer, network_state(data, viewer)


def probe(data):
    validate(data)
    viewer = viewer_state()
    if not viewer.get("running"):
        raise ValueError("请先启动 RViz，再检查实际数据与 TF。")
    if viewer["master"] != master_url(data) or viewer["pc_ip"] != data["pc_ip"]:
        raise ValueError("运行中的 RViz 网络与输入配置不同，请先点击启动应用新配置。")
    source = (PROJECT / "probe-ros.py").read_text(encoding="utf-8")
    output = run(["docker", "exec", "-i", CONTAINER, "bash", "-c",
                  "source /opt/ros/melodic/setup.bash; timeout 20s python -"], timeout=25, input=source)
    return json.loads(output.splitlines()[-1])


def bookmarks():
    try:
        result = json.loads(CONFIG.with_name('start-poses.json').read_text(encoding='utf-8'))
    except FileNotFoundError:
        return {}
    if not isinstance(result, dict):
        raise ValueError('起点书签文件格式错误，未覆盖原文件。')
    for key, entry in result.items():
        validate_bookmark(entry)
        if key != entry['name']:
            raise ValueError('起点书签名称不一致。')
    return result


def validate_bookmark(entry):
    if not isinstance(entry, dict) or entry.get('version') != 1 or entry.get('frame') != 'map':
        raise ValueError('不支持的起点书签格式。')
    profile_name(entry.get('name'))
    pose = entry.get('pose')
    if (not isinstance(pose, list) or len(pose) != 3 or
            any(isinstance(v, bool) or not isinstance(v, (int, float)) or not math.isfinite(v) for v in pose)
            or abs(pose[2]) > math.pi):
        raise ValueError('起点坐标或朝向无效。')
    identity = entry.get('map', {})
    digest = identity.get('sha256', '') if isinstance(identity, dict) else ''
    if len(digest) != 64 or any(c not in '0123456789abcdef' for c in digest):
        raise ValueError('地图指纹无效。')
    return entry


def bookmark_ros(data, request):
    data = validate(data)
    viewer = viewer_state()
    if (not viewer.get('running') or viewer.get('mode') != 'navigation' or
            viewer.get('master') != master_url(data) or viewer.get('pc_ip') != data['pc_ip']):
        raise ValueError('请先按当前网络配置启动导航 RViz；SLAM 模式不能使用起点书签。')
    source = (PROJECT / 'bookmark-ros.py').read_text(encoding='utf-8')
    # argv to python -c is not interpreted by the shell. All user data is stdin.
    output = run(['docker', 'exec', '-i', CONTAINER, 'bash', '-c',
                  'source /opt/ros/melodic/setup.bash; exec timeout 16s python -c "$1"',
                  'bookmark-client', source], timeout=20, input=json.dumps(request)+'\n')
    result = json.loads(output.splitlines()[-1])
    if not result.get('ok'):
        raise ValueError(result.get('error', '起点操作失败。'))
    return result['result']


def save_bookmark(name, data, physical_pose_verified=False, overwrite=False):
    if physical_pose_verified is not True:
        raise ValueError('请先核实实车位置、朝向和激光与地图重合；ready 本身不能证明定位唯一。')
    name = profile_name(name)
    entries = bookmarks()
    if name in entries and not overwrite:
        raise ValueError('同名起点已存在，请明确确认覆盖。')
    snapshot = bookmark_ros(data, {'action': 'snapshot'})
    if not snapshot.get('ready') or not snapshot.get('stationary') or 'pose' not in snapshot:
        raise ValueError('定位尚未通过门控或小车未静止（需新鲜 /odom），不能保存。')
    entry = validate_bookmark({'version': 1, 'name': name, 'map': snapshot['map'],
        'frame': 'map', 'pose': snapshot['pose'], 'saved_at': time.time(),
        'covariance': {'x': .25, 'y': .25, 'yaw': math.radians(15)**2},
        'placement_note': '实车须放回此位置并保持同一车头方向；恢复不导航。'})
    entries[name] = entry
    atomic_json(CONFIG.with_name('start-poses.json'), entries)
    return entry


def use_bookmark(name, data, restore=False, physical_placement_confirmed=False):
    if restore and physical_placement_confirmed is not True:
        raise ValueError('必须确认已把静止实车放回起点且车头朝向一致。')
    entry = bookmarks()[profile_name(name)]
    result = bookmark_ros(data, {'action': 'restore' if restore else 'preview', 'entry': entry,
                               'physical_placement_confirmed': physical_placement_confirmed})
    return ('已恢复 AMCL 初始位姿；旧目标已撤销，等待重新定位检查。不会自动导航。' if restore
            else '已在 RViz 显示蓝色起点箭头（不是导航目标）：') + '\n' + json.dumps(result, ensure_ascii=False)