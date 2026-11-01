#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/launcher-env.sh"
NAME="${RVIZ_CONTAINER_NAME:-x3plus-rviz}"
if timeout 5 docker container ls -a --format '{{.Names}}' | grep -Fxq "${NAME}"; then
  timeout --kill-after=2s 18 docker stop -t 10 "${NAME}"
else
  # A daemon error must not be reported as a successful stop.
  timeout 5 docker info --format '{{.ServerVersion}}' >/dev/null
  echo "RViz 容器不存在，无需停止。"
fi