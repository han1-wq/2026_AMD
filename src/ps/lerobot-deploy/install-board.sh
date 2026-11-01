#!/bin/bash
set -euo pipefail
ROOT=/home/ubuntu/lerobot-deploy
test "$(uname -m)" = aarch64
python3 -m venv "$ROOT/venv"
source "$ROOT/venv/bin/activate"
export PIP_DISABLE_PIP_VERSION_CHECK=1 PIP_NO_CACHE_DIR=1
python -m pip install --upgrade 'pip<26' 'setuptools>=71,<81' wheel
python -m pip install --only-binary=:all: torch==2.8.0 torchvision==0.23.0 --index-url https://download.pytorch.org/whl/cpu
python -m pip install --index-url https://pypi.tuna.tsinghua.edu.cn/simple -c "$ROOT/constraints.txt" -e "$ROOT/lerobot[feetech]"
python -m pip check
python -m pip freeze > "$ROOT/pip-freeze.txt"
echo BOARD_INSTALL_PASS