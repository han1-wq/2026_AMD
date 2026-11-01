"""Bounded UTF-8 status messages for the DMA UART's 1000-byte payload."""
import json

MAX_UART_BYTES = 1000


def encode(data):
    result = json.dumps(data, ensure_ascii=False, separators=(',', ':')).encode('utf-8')
    if len(result) > MAX_UART_BYTES:
        raise ValueError('状态信息超过串口单包 1000 字节')
    return result


def task_and_log(action, record, active, log_bytes, file_bytes):
    state = {key: record[key] for key in ('status', 'pid', 'started', 'finished', 'returncode')
             if key in record}
    state['message'] = str(record.get('message', '暂无任务记录'))[:120]
    data = {'type': 'task_log', 'action': action, 'active': active, 'state': state,
            'log_file_bytes': file_bytes, 'log_truncated': False, 'log': ''}
    # Tail on byte boundaries; decoding with replacement also handles a split UTF-8 codepoint.
    for size in range(min(700, len(log_bytes)), -1, -1):
        data['log'] = log_bytes[-size:].decode('utf-8', errors='replace') if size else ''
        data['log_truncated'] = file_bytes > size
        try:
            return encode(data)
        except ValueError:
            continue
    raise ValueError('任务状态信息超过串口单包 1000 字节')


def usb_and_runtime(snapshot):
    if not snapshot or 'error' in snapshot or 'serial' not in snapshot:
        raise ValueError('暂无有效监控快照，请刷新状态后重试')
    serial = {role: {'ok': item.get('ok'), 'message': str(item.get('message', ''))[:80]}
              for role, item in snapshot['serial'].items()}
    devices = [{key: device.get(key, '') for key in ('path', 'vid', 'pid', 'interface')}
               for device in snapshot.get('devices', [])]
    data = {'type': 'usb_runtime', 'sampled_at': snapshot.get('sampled_at'),
            'serial': serial, 'devices': devices, 'camera': snapshot.get('camera'),
            'containers': snapshot.get('containers', {}),
            'ros_nodes': len(snapshot.get('nodes', [])),
            'ros_error': str(snapshot.get('ros_error', ''))[:80],
            'cpu_percent': snapshot.get('cpu'), 'memory_mib': snapshot.get('memory'),
            'load': snapshot.get('load'), 'details_truncated': False,
            'device_count': len(devices)}
    while True:
        try:
            return encode(data)
        except ValueError:
            data['details_truncated'] = True
            if data['devices']:
                data['devices'].pop()
            elif data['containers']:
                data['containers'] = {}
            elif any(item['message'] for item in serial.values()):
                for item in serial.values():
                    item['message'] = ''
            else:
                raise ValueError('USB 状态摘要仍超过串口单包 1000 字节')