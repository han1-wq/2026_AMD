#!/usr/bin/env bash
set -euo pipefail

YOLO_DIR="${YOLO_DIR:-/home/ubuntu/kv260_yolov4_deploy}"
YOLO_SCRIPT="${YOLO_SCRIPT:-camera_yolov4.py}"
YOLO_PYTHON="/usr/local/share/pynq-venv/bin/python3"
BITFILE="${YOLO_DIR}/overlay/dpu.bit"
XMODEL="${YOLO_DIR}/compiled/yolov4_leaky_416_tf.xmodel"
CAMERA_DEVICE="${YOLO_CAMERA_DEVICE:-/dev/video0}"
XAUTHORITY_FILE="/run/user/1000/gdm/Xauthority"

if [[ ! -d "${YOLO_DIR}" ]]; then
  echo "错误：YOLO 工程目录不存在：${YOLO_DIR}" >&2
  exit 1
fi
if [[ ! -f "${YOLO_DIR}/${YOLO_SCRIPT}" ]]; then
  echo "错误：YOLO 启动脚本不存在：${YOLO_DIR}/${YOLO_SCRIPT}" >&2
  exit 1
fi
if [[ ! -s "${BITFILE}" ]]; then
  echo "错误：DPU bitstream 不存在或为空：${BITFILE}" >&2
  exit 1
fi
if [[ ! -s "${XMODEL}" ]]; then
  echo "错误：YOLOv4 XModel 不存在或为空：${XMODEL}" >&2
  exit 1
fi
if [[ ! -x "${YOLO_PYTHON}" ]]; then
  echo "错误：PYNQ Python 不存在或不可执行：${YOLO_PYTHON}" >&2
  exit 1
fi
if [[ ! -e "${CAMERA_DEVICE}" ]]; then
  echo "错误：摄像头设备不存在：${CAMERA_DEVICE}" >&2
  exit 1
fi

# The camera and DPU are exclusive resources. Do not create a second YOLO process.
existing_pid="$(pgrep -f '[c]amera_yolov4.py' | head -n 1 || true)"
if [[ -n "${existing_pid}" ]]; then
  echo "YOLOv4 已在运行（PID ${existing_pid}），复用现有进程。"
  echo "窗口：KV260 YOLOv4 USB Camera"
  exit 0
fi

cd "${YOLO_DIR}"

# This is the known-good KV260 PYNQ/DPU runtime environment.
source /etc/profile.d/pynq_venv.sh
export OMP_NUM_THREADS=1
export OPENBLAS_NUM_THREADS=1
export MKL_NUM_THREADS=1
export NUMEXPR_NUM_THREADS=1

# Keep the USB camera responsive and use the performance CPU governor while YOLO runs.
echo -1 | sudo -n tee /sys/module/usbcore/parameters/autosuspend >/dev/null
for governor in /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_governor; do
  if [[ -f "${governor}" ]]; then
    echo performance | sudo -n tee "${governor}" >/dev/null
  fi
done

if [[ -S /tmp/.X11-unix/X1 ]]; then
  export DISPLAY=:1
elif [[ -S /tmp/.X11-unix/X0 ]]; then
  export DISPLAY=:0
else
  echo "ERROR: No X11 display found" >&2
  exit 1
fi

export XAUTHORITY="${XAUTHORITY_FILE}"
if [[ ! -f "${XAUTHORITY}" ]]; then
  echo "ERROR: XAUTHORITY does not exist: ${XAUTHORITY}" >&2
  echo "当前 XAUTHORITY: ${XAUTHORITY:-未设置}" >&2
  exit 1
fi

xhost +SI:localuser:root

export PYTHONPATH="${YOLO_DIR}:${PYTHONPATH:-}"
echo "启动独立 YOLOv4 摄像头检测：${YOLO_DIR}/${YOLO_SCRIPT}"
echo "PYNQ Python：${YOLO_PYTHON}"
echo "显示：${DISPLAY}；摄像头：${CAMERA_DEVICE}；ROS 不参与此进程。"

# sudoers grants only this exact YOLO command, so no password prompt is needed.
exec sudo -n -E "${YOLO_PYTHON}" "${YOLO_DIR}/${YOLO_SCRIPT}"
