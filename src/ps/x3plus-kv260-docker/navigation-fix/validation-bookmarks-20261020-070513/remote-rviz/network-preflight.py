#!/usr/bin/env python3
"""Test both ROS Master access and its callback path, without robot commands."""
import json
import socket
import sys
import threading
import uuid
import xmlrpc.client
from xmlrpc.server import SimpleXMLRPCServer


def check(master_uri, pc_ip):
    socket.setdefaulttimeout(4)
    master = xmlrpc.client.ServerProxy(master_uri)
    code, message, _ = master.getSystemState('/pc_console_preflight')
    if code != 1:
        raise RuntimeError(message)
    event = threading.Event()
    token = uuid.uuid4().hex
    caller = '/pc_console_network_' + token
    topic = caller + '/callback_test'
    with SimpleXMLRPCServer((pc_ip, 0), logRequests=False, allow_none=True) as server:
        def callback(caller_id, topic_name, publishers):
            if topic_name == topic:
                event.set()
            return [1, '', 0]
        server.register_function(callback, 'publisherUpdate')
        worker = threading.Thread(target=server.serve_forever, daemon=True)
        worker.start()
        uri = 'http://%s:%d/' % (pc_ip, server.server_address[1])
        try:
            for method, name in ((master.registerSubscriber, caller), (master.registerPublisher, caller + '_publisher')):
                code, message, _ = method(name, topic, 'std_msgs/String', uri)
                if code != 1:
                    raise RuntimeError(message)
            if not event.wait(5):
                raise RuntimeError('Master 可访问，但 KV260 无法回连主机 %s。检查 VMware 桥接、Wi-Fi 隔离和防火墙；NAT 通常不能直接运行 ROS 1。' % pc_ip)
        finally:
            for method, name in ((master.unregisterPublisher, caller + '_publisher'), (master.unregisterSubscriber, caller)):
                try:
                    method(name, topic, uri)
                except Exception:
                    pass
            server.shutdown()
            worker.join(2)
    return {'ok': True, 'master': master_uri, 'pc_ip': pc_ip, 'callback': True}


if __name__ == '__main__':
    try:
        print(json.dumps(check(sys.argv[1], sys.argv[2]), ensure_ascii=False))
    except Exception as exc:
        print('ROS 双向网络检查失败：' + str(exc), file=sys.stderr)
        sys.exit(1)