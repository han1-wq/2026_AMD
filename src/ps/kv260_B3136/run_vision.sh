#!/usr/bin/env bash
set -eo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if [[ "${1:-}" == --help ]]; then
    exec /usr/local/share/pynq-venv/bin/python3 "$ROOT/vision_hls.py" --help
fi
if [[ $EUID -ne 0 ]]; then
    # Keep only the environment needed for ROS and the existing desktop session.
    export DISPLAY="${DISPLAY:-:0}"
    export XAUTHORITY="${XAUTHORITY:-/run/user/1000/gdm/Xauthority}"
    exec sudo --preserve-env=DISPLAY,XAUTHORITY,ROS_DOMAIN_ID,RMW_IMPLEMENTATION,ASTRA_COLOR_DEVICE,ASTRA_DEVICE_URI \
        /bin/bash "$ROOT/run_vision.sh" "$@"
fi
exec 9>/run/lock/kv260-b3136.lock
flock -n 9 || { echo 'B3136 pipeline is already running' >&2; exit 1; }
if pgrep -f '^(/[^ ]*/)?python[0-9.]* .*(/remote_camera_yolov4.py|/camera_yolov4.py|/infer_yolov4.py)( |$)' >/dev/null; then
    echo 'Stop the existing DPU vision application before changing the FPGA overlay.' >&2
    exit 1
fi
cd "$ROOT"
sha256sum --quiet -c artifacts.sha256
source /usr/local/share/pynq-venv/bin/activate
source /opt/ros/humble/setup.bash
source /home/ubuntu/kv260_astra_ws/install/setup.bash
export BOARD=KV260 XILINX_XRT=/usr
export OMP_NUM_THREADS=1 OPENBLAS_NUM_THREADS=1 MKL_NUM_THREADS=1 NUMEXPR_NUM_THREADS=1
export MALLOC_ARENA_MAX=2 PYTHONUNBUFFERED=1
export PYTHONPATH="$ROOT:${PYTHONPATH:-}"
ulimit -c 0
exec /usr/local/share/pynq-venv/bin/python3 "$ROOT/vision_hls.py" "$@"