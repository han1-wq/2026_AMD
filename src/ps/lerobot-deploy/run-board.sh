#!/bin/bash
set -euo pipefail
ROOT=/home/ubuntu/lerobot-deploy
export PATH="$ROOT/venv/bin:$PATH"
export HF_HOME="$ROOT/cache/huggingface"
export OMP_NUM_THREADS=2 OPENBLAS_NUM_THREADS=2 MKL_NUM_THREADS=2
mkdir -p "$HF_HOME"
cd "$ROOT"
if [[ $# -eq 0 ]]; then
    exec /bin/bash --noprofile --norc
fi
exec "$@"