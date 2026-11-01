#!/usr/bin/env bash
set -euo pipefail
ROOT=/home/ubuntu/lerobot-deploy
PORT=/dev/serial/by-id/usb-1a86_USB_Single_Serial_5B91028053-if00
for arg in "$@"; do
    if [[ "$arg" == --hardware ]]; then
        test -c "$PORT"
        if fuser "$PORT" >/dev/null 2>&1; then echo 'Follower serial port is busy' >&2; exit 1; fi
    fi
done
export PYTHONDONTWRITEBYTECODE=1
exec "$ROOT/run.sh" python "$ROOT/network-teleop/teleop.py" server \
    --host 192.168.43.182 --peer 192.168.43.123 --key "$ROOT/network-teleop/session.key" \
    --serial "$PORT" --calibration "$ROOT/workspace/calibration/robots/so101_follower" "$@"