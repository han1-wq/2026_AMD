#!/usr/bin/env bash
set -euo pipefail
ROOT=/home/amd/lerobot-deploy
PORT=/dev/serial/by-id/usb-1a86_USB_Single_Serial_5B91026450-if00
devices=()
for arg in "$@"; do
    if [[ "$arg" == --hardware ]]; then
        test -c "$PORT"
        if fuser "$PORT" >/dev/null 2>&1; then echo 'Leader serial port is busy' >&2; exit 1; fi
        devices=(--device "$PORT:/dev/so101-leader:rwm" --group-add "$(stat -Lc %g "$PORT")")
    fi
done
exec docker run --rm --init --network host --name so101-network-leader \
    --user "$(id -u):$(id -g)" "${devices[@]}" \
    -e HOME=/workspace -e PYTHONUNBUFFERED=1 -e PYTHONDONTWRITEBYTECODE=1 \
    -v "$ROOT/workspace:/workspace" -v "$ROOT/network-teleop:/network:ro" \
    -v "$ROOT/lerobot/src/lerobot:/opt/lerobot/src/lerobot:ro" \
    lerobot-cpu:joyandai-0.4.3 python /network/teleop.py client \
    --host 192.168.43.182 --key /network/session.key \
    --serial /dev/so101-leader --calibration /workspace/calibration/teleoperators/so101_leader "$@"