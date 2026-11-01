#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/launcher-env.sh"
COLOR_DEVICE="${ASTRA_COLOR_DEVICE:-/dev/v4l/by-id/usb-Astra_Pro_HD_Camera_Astra_Pro_HD_Camera-video-index0}"
if [[ ! -c "${COLOR_DEVICE}" ]]; then
  echo "错误：相机字符设备不可用，未加载 DPU：${COLOR_DEVICE}" >&2
  exit 1
fi

# Desktop-launcher adapter. Keep the actual camera/DPU setup in one canonical
# script so command-line and GUI launches always use the same configuration.
MAIN_LAUNCHER="/home/ubuntu/start_astra_rgbd_yolov4.sh"

if [[ ! -x "${MAIN_LAUNCHER}" ]]; then
  echo "错误：Astra RGB-D YOLOv4 启动脚本不存在或不可执行：${MAIN_LAUNCHER}" >&2
  exit 1
fi

existing_pid="$(pgrep -f '/home/ubuntu/kv260_yolov4_deploy/[r]emote_camera_yolov4.py' | head -n 1 || true)"
if [[ -n "${existing_pid}" ]]; then
  echo "Astra RGB-D + DPU YOLOv4 已在运行（PID ${existing_pid}），不会重复启动。"
  echo "窗口：KV260 YOLOv4 Astra RGB-D"
  echo "检测结果：/yolov4/detections"
  exit 0
fi

legacy_pid="$(pgrep -f '/home/ubuntu/kv260_yolov4_deploy/[c]amera_yolov4.py' | head -n 1 || true)"
if [[ -n "${legacy_pid}" ]]; then
  echo "错误：旧版 YOLOv4 摄像头程序正在运行（PID ${legacy_pid}）。" >&2
  echo "请先退出旧版 YOLO 窗口，再启动 Astra RGB-D 版本。" >&2
  exit 1
fi

echo "启动 Astra 深度相机 + DPU YOLOv4..."
exec "${MAIN_LAUNCHER}"