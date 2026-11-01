#!/usr/bin/env bash
set -euo pipefail

ROOT=/home/amd/lerobot-deploy
FOLLOWER_PORT=/dev/serial/by-id/usb-1a86_USB_Single_Serial_5B91028053-if00
LEADER_PORT=/dev/serial/by-id/usb-1a86_USB_Single_Serial_5B91026450-if00
CONTAINER=lerobot-teleoperate-R12252801-R07252801

if [[ ! -t 0 || ! -t 1 ]]; then
    echo 'Run this launcher in an interactive terminal.' >&2
    exit 1
fi
for port in "$FOLLOWER_PORT" "$LEADER_PORT"; do
    if [[ ! -c "$port" ]]; then
        echo "Serial device is missing: $port" >&2
        exit 1
    fi
    if fuser "$port" >/dev/null 2>&1; then
        echo "Serial device is already in use: $port" >&2
        exit 1
    fi
done
for calibration in \
    "$ROOT/workspace/calibration/robots/so101_follower/R12252801.json" \
    "$ROOT/workspace/calibration/teleoperators/so101_leader/R07252801.json"; do
    if [[ ! -s "$calibration" ]]; then
        echo "Calibration file is missing or empty: $calibration" >&2
        exit 1
    fi
done

RUN_DIR="$ROOT/workspace/teleoperation_runs/R12252801_R07252801_$(date -u +%Y%m%dT%H%M%SZ)"
mkdir -p "$RUN_DIR"
printf 'Follower: R12252801 (%s)\nLeader: R07252801 (%s)\n' "$FOLLOWER_PORT" "$LEADER_PORT"
printf 'Log: %s/terminal.log\nStop teleoperation with Ctrl+C.\n\n' "$RUN_DIR"
cp "$ROOT/workspace/calibration/robots/so101_follower/R12252801.json" "$RUN_DIR/follower_calibration.json"
cp "$ROOT/workspace/calibration/teleoperators/so101_leader/R07252801.json" "$RUN_DIR/leader_calibration.json"

command=(docker run --rm --init -it --name "$CONTAINER"
    --user "$(id -u):$(id -g)"
    --group-add "$(stat -Lc %g "$FOLLOWER_PORT")"
    --group-add "$(stat -Lc %g "$LEADER_PORT")"
    --device "$FOLLOWER_PORT:/dev/ttyACM0:rwm"
    --device "$LEADER_PORT:/dev/ttyACM1:rwm"
    -e HOME=/workspace -e HF_HOME=/workspace/cache/huggingface
    -e HF_LEROBOT_CALIBRATION=/workspace/calibration
    -e PYTHONUNBUFFERED=1 -e PYTHONDONTWRITEBYTECODE=1
    -e OMP_NUM_THREADS=2 -e MKL_NUM_THREADS=2
    -v "$ROOT/workspace:/workspace"
    -v "$ROOT/lerobot/src/lerobot:/opt/lerobot/src/lerobot"
    lerobot-cpu:joyandai-0.4.3
    lerobot-teleoperate
    --robot.type=so101_follower --robot.port=/dev/ttyACM0 --robot.id=R12252801
    --robot.max_relative_target=5.0
    --teleop.type=so101_leader --teleop.port=/dev/ttyACM1 --teleop.id=R07252801)
printf -v quoted_command '%q ' "${command[@]}"
printf '%s\n' "$quoted_command" > "$RUN_DIR/command.txt"
set +e
script --quiet --return --flush --command "$quoted_command" "$RUN_DIR/terminal.log"
status=$?
set -e
printf '%s\n' "$status" > "$RUN_DIR/exit_code.txt"
printf '\nTeleoperation command exit code: %s\nLog: %s/terminal.log\n' "$status" "$RUN_DIR"
exit "$status"