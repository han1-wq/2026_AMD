#!/usr/bin/env python3
"""Read-only ROS 1 master status for the PC console."""

import argparse
import json
import socket
import sys
import xmlrpc.client


def topic_nodes(entries, topic):
    for name, nodes in entries:
        if name == topic:
            return sorted(nodes)
    return []


def registered_nodes(entries, needle):
    return sorted({node for _, nodes in entries for node in nodes
                   if needle in node.rsplit("/", 1)[-1]})


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--master", required=True, help="ROS master URL")
    args = parser.parse_args()
    socket.setdefaulttimeout(3.0)
    result = {"ok": False, "master": args.master}
    try:
        master = xmlrpc.client.ServerProxy(args.master, allow_none=True)
        code, message, state = master.getSystemState("/x3plus_pc_console")
        if code != 1:
            raise RuntimeError(message)
        publishers, subscribers, services = state
        result.update(
            {
                "ok": True,
                "map_publishers": topic_nodes(publishers, "/map"),
                "scan_publishers": topic_nodes(publishers, "/scan"),
                "cmd_vel_publishers": topic_nodes(publishers, "/cmd_vel"),
                "move_base_nodes": sorted({
                    node
                    for topic in publishers + subscribers + services
                    for node in topic[1]
                    if node.rsplit("/", 1)[-1] == "move_base"
                }),
                "move_base_publishers": topic_nodes(publishers, "/move_base/status"),
                "amcl_nodes": registered_nodes(publishers + subscribers + services, "amcl"),
                "map_server_nodes": registered_nodes(publishers + subscribers + services, "map_server"),
                "amcl_publishers": topic_nodes(publishers, "/amcl_pose"),
                "odom_publishers": topic_nodes(publishers, "/odom"),
                "tf_publishers": topic_nodes(publishers, "/tf"),
                "tf_static_publishers": topic_nodes(publishers, "/tf_static"),
            }
        )
    except Exception as exc:  # XML-RPC/socket errors are user-facing status.
        result["error"] = str(exc)
    print(json.dumps(result, ensure_ascii=True))
    return 0 if result["ok"] else 1


if __name__ == "__main__":
    sys.exit(main())