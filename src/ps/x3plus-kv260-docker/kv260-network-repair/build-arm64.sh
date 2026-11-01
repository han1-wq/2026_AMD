#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IMAGE="${IMAGE:-x3plus:melodic-arm64}"

cd "${ROOT}"
[[ -f Dockerfile && -d context/src && -d context/ydlidar-sdk ]] || {
  echo "This directory is incomplete: Dockerfile/context are required." >&2
  exit 1
}

if [[ "$(uname -m)" != "aarch64" && "${ALLOW_CROSS_BUILD:-0}" != "1" ]]; then
  echo "This script is intended for native ARM64 KV260 builds." >&2
  echo "On an x86 host use Docker Buildx with --platform linux/arm64 instead." >&2
  exit 1
fi

echo "Building ${IMAGE} from ${ROOT}"
echo "Architecture: $(uname -m)"
docker build --pull --network host -t "${IMAGE}" .
echo "Built image: ${IMAGE}"