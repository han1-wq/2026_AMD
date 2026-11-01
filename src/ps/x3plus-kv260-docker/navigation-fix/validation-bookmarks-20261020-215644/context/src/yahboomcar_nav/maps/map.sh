#!/usr/bin/env bash
set -euo pipefail

# Run inside the robot container. /maps is the persistent host volume.
MAP_DIR="${MAP_DIR:-/maps}"
MAP_NAME="${1:-map}"
mkdir -p "${MAP_DIR}"
exec rosrun map_server map_saver -f "${MAP_DIR}/${MAP_NAME}"