#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/launcher-env.sh"
exec /usr/bin/python3 "${SCRIPT_DIR}/launcher_modes.py" stop-keyboard