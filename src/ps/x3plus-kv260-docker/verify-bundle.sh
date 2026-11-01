#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
required=(Dockerfile .dockerignore context/ros.key context/entrypoint.sh context/roscore.sh
  context/src/yahboomcar_ctrl/launch/yahboom_keyboard.launch
  context/src/yahboomcar_nav/launch/laser_bringup.launch
  context/src/yahboomcar_nav/launch/laser_astrapro_bringup.launch
  context/src/yahboomcar_nav/launch/yahboomcar_map.launch
  context/src/yahboomcar_nav/launch/yahboomcar_navigation.launch
  context/src/yahboomcar_nav/launch/map_saver.launch
  context/src/yahboomcar_nav/launch/view_map.launch
  context/src/yahboomcar_nav/launch/view_navigate.launch
  context/src/ydlidar_ros_driver/launch/TG.launch
  context/src/astra_camera/package.xml
  context/src/astra_camera/include/openni2_redist/arm64/libOpenNI2.so
  context/rosmaster/Rosmaster_Lib/Rosmaster_Lib.py)

for file in "${required[@]}"; do
  [[ -f "${ROOT}/${file}" ]] || { echo "Missing: ${file}" >&2; exit 1; }
done

expected_ros_key_sha256="4a91c49af0d6f0016108b93698782b596c27ccd836937e18e0e36c3347dc602f"
actual_ros_key_sha256="$(sha256sum "${ROOT}/context/ros.key" | awk '{print $1}')"
[[ "${actual_ros_key_sha256}" == "${expected_ros_key_sha256}" ]] || {
  echo "ROS repository key checksum mismatch." >&2
  exit 1
}

if find "${ROOT}/context" -type f \( -name '*.o' -o -name '*.a' -o -name '*.pyc' -o -name CMakeCache.txt -o -name Makefile \) -print -quit | grep -q .; then
  echo "Generated build artifacts remain in context; rebuild the bundle before transfer." >&2
  exit 1
fi

# The only native files allowed in the source bundle are the vendor-provided
# ARM64 OpenNI2 runtime libraries used by Astra. No VM amd64 object/library may
# cross the deployment boundary.
while IFS= read -r -d '' native_file; do
  case "${native_file}" in
    "${ROOT}/context/src/astra_camera/include/openni2_redist/arm64/"*.so) ;;
    *) echo "Unexpected native binary in context: ${native_file}" >&2; exit 1 ;;
  esac
done < <(find "${ROOT}/context" -type f -name '*.so*' -print0)

for lib in \
  "${ROOT}/context/src/astra_camera/include/openni2_redist/arm64/libOpenNI2.so" \
  "${ROOT}/context/src/astra_camera/include/openni2_redist/arm64/OpenNI2/Drivers/libOniFile.so" \
  "${ROOT}/context/src/astra_camera/include/openni2_redist/arm64/OpenNI2/Drivers/liborbbec.so"; do
  file "${lib}" | grep -q 'ELF 64-bit.*ARM aarch64' || {
    echo "Astra runtime is not ARM64: ${lib}" >&2
    exit 1
  }
done

python3 - "${ROOT}" <<'PY'
from pathlib import Path
import sys
import xml.etree.ElementTree as ET
root = Path(sys.argv[1])
for path in (root / 'context' / 'src').rglob('*.launch'):
    ET.parse(path)
PY

for script in build-arm64.sh check-kv260-hardware.sh run-master.sh run-robot.sh \
              start-slam.sh start-keyboard.sh stop-all.sh; do
  bash -n "${ROOT}/${script}"
done

grep -q 'name="use_slam" default="false"' "${ROOT}/context/src/yahboomcar_nav/launch/laser_bringup.launch"
grep -q 'name="use_joy" default="false"' "${ROOT}/context/src/yahboomcar_bringup/launch/bringup.launch"
grep -q 'dwa_local_planner/DWAPlannerROS' "${ROOT}/context/src/yahboomcar_nav/launch/library/move_base.launch"
grep -q '^image: map.pgm$' "${ROOT}/context/src/yahboomcar_nav/maps/map.yaml"
grep -q 'launch/library/map_saver_impl.launch' "${ROOT}/context/src/yahboomcar_nav/launch/map_saver.launch"

echo "Bundle verification passed: ${ROOT}"
du -sh "${ROOT}" "${ROOT}/context"