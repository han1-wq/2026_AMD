#!/usr/bin/env bash
set -euo pipefail

echo "== Host =="
uname -a
printf 'Architecture: '; uname -m
command -v docker >/dev/null || { echo "docker is not installed" >&2; exit 1; }
docker info >/dev/null || { echo "Docker is unavailable or the current user lacks permission" >&2; exit 1; }
docker --version

echo
echo "== Serial devices =="
if [[ -d /dev/serial/by-id ]]; then
  find -L /dev/serial/by-id -maxdepth 1 -type c -printf '%p -> %k KB\n' 2>/dev/null || true
else
  echo "/dev/serial/by-id does not exist"
fi
for device in /dev/ttyUSB* /dev/ttyACM* /dev/myserial /dev/ydlidar; do
  [[ -e "${device}" ]] && ls -l "${device}"
done

echo
echo "Choose the actual robot and lidar paths from the list above. Do not assume
/dev/ttyUSB0 or /dev/ttyUSB1 after reconnecting USB devices."