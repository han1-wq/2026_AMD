#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/launcher-env.sh"
COLOR_DEVICE="${ASTRA_COLOR_DEVICE:-/dev/v4l/by-id/usb-Astra_Pro_HD_Camera_Astra_Pro_HD_Camera-video-index0}"
if [[ ! -c "${COLOR_DEVICE}" ]]; then
  echo "错误：相机字符设备不可用，未加载 DPU：${COLOR_DEVICE}" >&2
  exit 1
fi

if pgrep -f '^/usr/local/share/pynq-venv/bin/python3 /home/ubuntu/kv260_B3136/vision_hls.py( |$)' >/dev/null; then
  echo 'B3136 HLS 视觉已经运行；请打开 AI 视觉界面。'
  exit 0
fi
mkdir -p /run/user/1000/kv260-b3136-ui
rm -f /run/user/1000/kv260-b3136-ui/stop
export DISPLAY="${DISPLAY:-:0}" XAUTHORITY="${XAUTHORITY:-/run/user/1000/gdm/Xauthority}"
export ASTRA_COLOR_DEVICE="$COLOR_DEVICE" KV260_B3136_ACTION=run
echo '启动 B3136 + HLS RGB-D 视觉；结果主题 /yolov4_b3136/detections'
exec sudo -n --preserve-env=DISPLAY,XAUTHORITY,ROS_DOMAIN_ID,RMW_IMPLEMENTATION,ASTRA_COLOR_DEVICE,ASTRA_DEVICE_URI,KV260_B3136_ACTION \
  /usr/local/share/pynq-venv/bin/python3 /home/ubuntu/kv260_yolov4_deploy/remote_camera_yolov4.py