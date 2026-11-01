#!/usr/bin/env bash
set -eo pipefail

# Fixed RGB-D launcher for the KV260.  The Python application intentionally
# uses pynq_dpu.DpuOverlay and never initializes XRT itself.
YOLO_DIR="${YOLO_DIR:-/home/ubuntu/kv260_yolov4_deploy}"
YOLO_SCRIPT="${YOLO_SCRIPT:-remote_camera_yolov4.py}"
YOLO_PYTHON="/usr/local/share/pynq-venv/bin/python3"
STOP_REQUEST_FILE="${YOLO_STOP_REQUEST_FILE:-/run/user/1000/kv260-astra-rgbd-yolov4.stop}"
# Use udev's persistent by-id name instead of a volatile /dev/videoN number.
# Override ASTRA_COLOR_DEVICE only when another camera is intentional.
COLOR_DEVICE="${ASTRA_COLOR_DEVICE:-/dev/v4l/by-id/usb-Astra_Pro_HD_Camera_Astra_Pro_HD_Camera-video-index0}"
# Empty means OpenNI2 selects the currently enumerated Astra device. A URI
# can still be supplied explicitly when multiple OpenNI2 cameras are present.
DEPTH_URI="${ASTRA_DEVICE_URI:-}"

if [[ ! -d "${YOLO_DIR}" ]]; then
  echo "错误：YOLO 工程目录不存在：${YOLO_DIR}" >&2
  exit 1
fi
if [[ ! -x "${YOLO_PYTHON}" ]]; then
  echo "错误：PYNQ Python 不存在或不可执行：${YOLO_PYTHON}" >&2
  exit 1
fi
if [[ ! -s "${YOLO_DIR}/overlay/dpu.bit" ]]; then
  echo "错误：DPU bitstream 不存在或为空" >&2
  exit 1
fi
if [[ ! -s "${YOLO_DIR}/compiled/yolov4_leaky_416_tf.xmodel" ]]; then
  echo "错误：YOLOv4 XModel 不存在或为空" >&2
  exit 1
fi
if [[ ! -f "${YOLO_DIR}/${YOLO_SCRIPT}" ]]; then
  echo "错误：RGB-D Python 脚本不存在：${YOLO_DIR}/${YOLO_SCRIPT}" >&2
  exit 1
fi
if [[ ! -e "${COLOR_DEVICE}" ]]; then
  echo "错误：Astra RGB 设备不存在：${COLOR_DEVICE}" >&2
  exit 1
fi

# This order is intentional: the PYNQ profile must be loaded before the
# privileged Python process, and ROS setup must precede the Astra workspace.
source /etc/profile.d/pynq_venv.sh
source /opt/ros/humble/setup.bash
source /home/ubuntu/kv260_astra_ws/install/setup.bash
set -u

export ASTRA_COLOR_DEVICE="${COLOR_DEVICE}"
export ASTRA_DEVICE_URI="${DEPTH_URI}"
export ASTRA_DEPTH_START_RETRIES="${ASTRA_DEPTH_START_RETRIES:-5}"
export ASTRA_DEPTH_START_DELAY="${ASTRA_DEPTH_START_DELAY:-2.0}"
export ASTRA_DEPTH_READY_TIMEOUT="${ASTRA_DEPTH_READY_TIMEOUT:-15}"
export YOLO_STOP_REQUEST_FILE="${STOP_REQUEST_FILE}"
export OMP_NUM_THREADS=1
export OPENBLAS_NUM_THREADS=1
export MKL_NUM_THREADS=1
export NUMEXPR_NUM_THREADS=1
export PYTHONPATH="${YOLO_DIR}:${PYTHONPATH:-}"

# Select the local graphical session when the launcher is started from SSH or
# a terminal without DISPLAY.  The Python process is privileged, so authorize
# root to use the same X11 session before starting OpenCV's window.
if [[ -z "${DISPLAY:-}" ]]; then
  if [[ -S /tmp/.X11-unix/X0 ]]; then
    export DISPLAY=:0
  elif [[ -S /tmp/.X11-unix/X1 ]]; then
    export DISPLAY=:1
  else
    echo "错误：没有可用的 X11 显示会话" >&2
    exit 1
  fi
fi

if [[ -z "${XAUTHORITY:-}" ]]; then
  if [[ -f /run/user/1000/gdm/Xauthority ]]; then
    export XAUTHORITY=/run/user/1000/gdm/Xauthority
  elif [[ -f /home/ubuntu/.Xauthority ]]; then
    export XAUTHORITY=/home/ubuntu/.Xauthority
  else
    echo "错误：找不到 XAUTHORITY 文件" >&2
    exit 1
  fi
fi

if ! xhost +SI:localuser:root >/dev/null 2>&1; then
  echo "错误：无法授权 root 使用 ${DISPLAY} 的 X11 显示" >&2
  exit 1
fi

# These writes are already allowed by the existing KV260 sudoers policy.
echo -1 | sudo -n tee /sys/module/usbcore/parameters/autosuspend >/dev/null
for governor in /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_governor; do
  if [[ -f "${governor}" ]]; then
    echo performance | sudo -n tee "${governor}" >/dev/null
  fi
done

echo "启动 Astra RGB-D YOLOv4：${YOLO_DIR}/${YOLO_SCRIPT}"
echo "RGB=${ASTRA_COLOR_DEVICE} depth_uri=${ASTRA_DEVICE_URI:-<auto>}"
echo "显示：${DISPLAY}；XAUTHORITY=${XAUTHORITY}"
echo "结果主题：/yolov4/detections；深度单位：16UC1 毫米"

# A stale request can remain after a power loss or forced termination. Remove
# it immediately before launch; later requests are consumed by the main loop.
rm -f -- "${STOP_REQUEST_FILE}"

# sudoers must allow this exact command with SETENV/NOPASSWD:
# /usr/local/share/pynq-venv/bin/python3 /home/ubuntu/kv260_yolov4_deploy/remote_camera_yolov4.py
exec sudo -n -E "${YOLO_PYTHON}" "${YOLO_DIR}/${YOLO_SCRIPT}"