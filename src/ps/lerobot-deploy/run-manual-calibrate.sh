#!/usr/bin/env bash
set -euo pipefail

ROOT=/home/amd/lerobot-deploy
PORT=/dev/serial/by-id/usb-1a86_USB_Single_Serial_5B91028053-if00
CONTAINER=lerobot-manual-R12252801

if [[ ! -t 0 || ! -t 1 ]]; then
    echo 'Run this launcher in an interactive terminal.' >&2
    exit 1
fi
if [[ ! -c "$PORT" ]]; then
    echo "Robot serial device is missing: $PORT" >&2
    exit 1
fi
if fuser "$PORT" >/dev/null 2>&1; then
    echo "Serial device is already in use: $PORT" >&2
    exit 1
fi

RUN_DIR="$ROOT/workspace/calibration_runs/manual_R12252801_$(date -u +%Y%m%dT%H%M%SZ)"
mkdir -p "$RUN_DIR"
printf 'Robot: R12252801\nSerial: %s -> /dev/ttyACM0\nLog: %s/terminal.log\n' "$PORT" "$RUN_DIR"
printf 'Calibration: %s/workspace/calibration/robots/so101_follower/R12252801.json\n\n' "$ROOT"
printf 'Support the arm before calibration disables torque. Follow the prompts and press ENTER yourself.\n\n'

command=(docker run --rm --init -it --name "$CONTAINER"
    --user "$(id -u):$(id -g)" --group-add "$(stat -Lc %g "$PORT")"
    --device "$PORT:/dev/ttyACM0:rwm"
    -e HOME=/workspace -e HF_HOME=/workspace/cache/huggingface
    -e HF_LEROBOT_CALIBRATION=/workspace/calibration
    -e PYTHONUNBUFFERED=1 -e PYTHONDONTWRITEBYTECODE=1
    -e OMP_NUM_THREADS=2 -e MKL_NUM_THREADS=2
    -v "$ROOT/workspace:/workspace"
    -v "$ROOT/lerobot/src/lerobot:/opt/lerobot/src/lerobot"
    lerobot-cpu:joyandai-0.4.3
    lerobot-calibrate --robot.type=so101_follower
    --robot.port=/dev/ttyACM0 --robot.id=R12252801)
printf -v quoted_command '%q ' "${command[@]}"
printf '%s\n' "$quoted_command" > "$RUN_DIR/command.txt"
set +e
script --quiet --return --flush --command "$quoted_command" "$RUN_DIR/terminal.log"
status=$?
set -e
printf '%s\n' "$status" > "$RUN_DIR/exit_code.txt"
printf '\nCalibration command exit code: %s\nLog: %s/terminal.log\n' "$status" "$RUN_DIR"
exit "$status"