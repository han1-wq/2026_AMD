#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/launcher-env.sh"

STOP_REQUEST_FILE="${YOLO_STOP_REQUEST_FILE:-/run/user/1000/kv260-astra-rgbd-yolov4.stop}"
PROCESS_PATTERN='/home/ubuntu/kv260_yolov4_deploy/[r]emote_camera_yolov4.py'
YOLO_PYTHON="/usr/local/share/pynq-venv/bin/python3"
YOLO_SCRIPT="/home/ubuntu/kv260_yolov4_deploy/remote_camera_yolov4.py"

if ! pgrep -f "${PROCESS_PATTERN}" >/dev/null; then
  rm -f -- "${STOP_REQUEST_FILE}"
  echo "Astra RGB-D + DPU YOLOv4 当前没有运行。"
  exit 0
fi

echo "正在请求 Astra RGB-D + DPU YOLOv4 安全退出..."
touch "${STOP_REQUEST_FILE}"

# Normal cleanup can spend up to five seconds joining the DPU worker and then
# stop the Astra process/ROS executor. Allow ample time before the legacy
# SIGINT fallback so a second signal cannot interrupt an active finally block.
for _ in $(seq 1 120); do
  if ! pgrep -f "${PROCESS_PATTERN}" >/dev/null; then
    rm -f -- "${STOP_REQUEST_FILE}"
    echo "已停止，并已释放 Astra 相机、DPU、ROS2 节点和显示窗口。"
    exit 0
  fi
  sleep 0.1
done

echo "退出请求暂未响应，正在通过受限 sudo 命令发送 Ctrl+C 信号..."
export KV260_YOLO_STOP_ONLY=1
if ! sudo -n -E "${YOLO_PYTHON}" "${YOLO_SCRIPT}"; then
  echo "错误：程序未能安全退出。请在检测窗口按 q，或在启动终端按 Ctrl+C。" >&2
  exit 1
fi

for _ in $(seq 1 30); do
  if ! pgrep -f "${PROCESS_PATTERN}" >/dev/null; then
    rm -f -- "${STOP_REQUEST_FILE}"
    echo "已停止，并已释放 Astra 相机、DPU、ROS2 节点和显示窗口。"
    exit 0
  fi
  sleep 0.1
done

echo "错误：程序仍未完全退出。请检查启动终端中的清理日志。" >&2
exit 1