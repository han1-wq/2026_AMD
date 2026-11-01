#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/launcher-env.sh"

NAME="${ROBOT_NAME:-x3plus-robot}"
HOST_MAP_DIR="${MAP_DIR:-/home/ubuntu/x3plus-maps}"
CONTAINER_MAP_DIR="${MAP_CONTAINER_DIR:-/maps}"
MAP_SAVE_TIMEOUT="${MAP_SAVE_TIMEOUT:-90}"

usage() {
  echo "用法：$0 <地图名称>" >&2
  echo "示例：$0 office_map" >&2
}

if [[ $# -ne 1 ]]; then
  usage
  exit 2
fi

MAP_NAME="$1"
if [[ ! "${MAP_NAME}" =~ ^[A-Za-z0-9][A-Za-z0-9_-]{0,63}$ ]]; then
  echo "错误：地图名称只能以英文或数字开头，并且只能包含英文、数字、下划线和短横线（最长 64 个字符）。" >&2
  exit 2
fi

YAML_PATH="${HOST_MAP_DIR}/${MAP_NAME}.yaml"
PGM_PATH="${HOST_MAP_DIR}/${MAP_NAME}.pgm"
if [[ ! -d "${HOST_MAP_DIR}" ]]; then
  echo "错误：宿主机地图目录不存在：${HOST_MAP_DIR}" >&2
  exit 1
fi
# Serialize direct shell callers too, including separate launcher instances.
exec 9>"${HOST_MAP_DIR}/.kv260-save.lock"
flock -n 9 || { echo "已有地图保存任务正在运行。" >&2; exit 75; }
if [[ -e "${YAML_PATH}" || -L "${YAML_PATH}" || -e "${PGM_PATH}" || -L "${PGM_PATH}" ]]; then
  echo "错误：地图已存在，为避免覆盖而停止：${MAP_NAME}" >&2
  echo "已有文件：${YAML_PATH} 或 ${PGM_PATH}" >&2
  exit 1
fi

if ! docker inspect "${NAME}" >/dev/null 2>&1 || \
   ! docker inspect "${NAME}" --format '{{.State.Running}}' | grep -qx true; then
  echo "错误：机器人容器 ${NAME} 未运行，请先启动基础环境。" >&2
  exit 1
fi

mount_source="$(docker inspect "${NAME}" --format '{{range .Mounts}}{{if eq .Destination "/maps"}}{{.Source}}{{end}}{{end}}')"
if [[ -z "${mount_source}" ]]; then
  echo "错误：机器人容器没有将地图目录挂载到 /maps，拒绝保存以避免地图丢失。" >&2
  exit 1
fi
if [[ "$(readlink -f "${mount_source}")" != "$(readlink -f "${HOST_MAP_DIR}")" ]]; then
  echo "错误：容器 /maps 的宿主机挂载路径与 MAP_DIR 不一致。" >&2
  echo "容器挂载：${mount_source}" >&2
  echo "配置目录：${HOST_MAP_DIR}" >&2
  exit 1
fi

docker exec "${NAME}" test -d "${CONTAINER_MAP_DIR}" || {
  echo "错误：容器地图目录不存在：${CONTAINER_MAP_DIR}" >&2
  exit 1
}
docker exec "${NAME}" test -w "${CONTAINER_MAP_DIR}" || {
  echo "错误：容器地图目录不可写：${CONTAINER_MAP_DIR}" >&2
  exit 1
}

if ! docker exec "${NAME}" bash -c \
  'source /opt/ros/melodic/setup.bash; source /opt/x3plus_ws/devel/setup.bash; rostopic info /map 2>/dev/null | sed -n "/Publishers:/,/Subscribers:/p" | grep -q "^ \\*"'; then
  echo "错误：当前没有 /map 发布者，请先完成 gmapping 建图并等待地图发布。" >&2
  exit 1
fi

MAP_OWNER="$(stat -c '%u:%g' "${HOST_MAP_DIR}")"
TARGET="${CONTAINER_MAP_DIR}/${MAP_NAME}"
TARGET_QUOTED="$(printf '%q' "${TARGET}")"
MAP_SAVER_COMMAND="export HOME=/tmp; mkdir -p /tmp/.ros; source /opt/ros/melodic/setup.bash; source /opt/x3plus_ws/devel/setup.bash; exec rosrun map_server map_saver -f ${TARGET_QUOTED}"

echo "开始保存地图：${MAP_NAME}"
echo "宿主机目录：${HOST_MAP_DIR}"
echo "容器目标：${TARGET}"
if ! timeout --kill-after=5s "${MAP_SAVE_TIMEOUT}" \
  docker exec --user "${MAP_OWNER}" "${NAME}" bash -c "${MAP_SAVER_COMMAND}"; then
  rm -f "${YAML_PATH}" "${PGM_PATH}"
  echo "错误：map_saver 执行失败或超时，未保留不完整地图。" >&2
  exit 1
fi

if [[ ! -s "${YAML_PATH}" || ! -s "${PGM_PATH}" ]]; then
  rm -f "${YAML_PATH}" "${PGM_PATH}"
  echo "错误：map_saver 返回成功，但没有生成完整的 .yaml/.pgm 文件。" >&2
  exit 1
fi

echo "地图保存成功。"
echo "YAML：${YAML_PATH}"
echo "PGM ：${PGM_PATH}"
