#!/bin/bash
set -euo pipefail
ROOT=/home/amd/lerobot-deploy
mkdir -p "$ROOT/workspace/cache" "$ROOT/workspace/data" "$ROOT/workspace/outputs"
args=(--rm --init --user "$(id -u):$(id -g)" --shm-size=1g
      -e HOME=/workspace -e HF_HOME=/workspace/cache/huggingface
      -e OMP_NUM_THREADS=2 -e MKL_NUM_THREADS=2
      -v "$ROOT/workspace:/workspace" -v "$ROOT:/deployment:ro")
if [[ -t 0 && -t 1 ]]; then args+=(-it); fi
if [[ $# -eq 0 ]]; then set -- /bin/bash; fi
exec docker run "${args[@]}" lerobot-cpu:joyandai-0.4.3 "$@"