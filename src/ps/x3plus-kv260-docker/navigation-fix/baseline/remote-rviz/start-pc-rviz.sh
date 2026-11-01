#!/usr/bin/env bash
set -euo pipefail
BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KV260_IP="${KV260_IP:-}"
ROS_MASTER_PORT="${ROS_MASTER_PORT:-11311}"
NAME=x3plus-pc-slam-rviz
MODE="${1:-slam}"
exec 9>"${XDG_RUNTIME_DIR:-/tmp}/${NAME}-$(id -u).lock"
flock -n 9 || { echo 'Another viewer startup is in progress.' >&2; exit 1; }
case "${MODE}" in
  stop)
    names="$(docker container ls -a --format '{{.Names}}')"
    if grep -qx "${NAME}" <<< "${names}"; then
      docker stop -t 5 "${NAME}" >/dev/null
      docker rm "${NAME}" >/dev/null
    fi
    echo 'PC RViz stopped.'
    exit 0
    ;;
  slam)
    ROS_LAUNCH="roslaunch /pc-rviz/slam-view.launch"
    ;;
  navigation|nav)
    MODE=navigation
    ROS_LAUNCH="roslaunch yahboomcar_nav view_navigate.launch"
    ;;
  *)
    echo "Usage: $0 [slam|navigation|stop] [--replace|--reconnect]" >&2
    exit 2
    ;;
esac
[[ -n "${KV260_IP}" ]] || { echo '请在上位机填写 KV260 IP，或设置 KV260_IP 环境变量。' >&2; exit 1; }
PC_ROS_IP="${PC_ROS_IP:-$(ip -4 route get "${KV260_IP}" | awk '{for(i=1;i<=NF;i++) if($i=="src") {print $(i+1); exit}}')}"
[[ -n "${PC_ROS_IP}" ]] || { echo 'Cannot determine PC ROS address.' >&2; exit 1; }
python3 - "${KV260_IP}" "${PC_ROS_IP}" "${ROS_MASTER_PORT}" <<'PY'
import ipaddress, sys
for value in sys.argv[1:3]:
    ipaddress.IPv4Address(value)
if not sys.argv[3].isascii() or not sys.argv[3].isdigit() or not 1 <= int(sys.argv[3]) <= 65535:
    raise SystemExit('Invalid ROS Master port')
PY
MASTER_URI="http://${KV260_IP}:${ROS_MASTER_PORT}"
python3 "${BASE}/network-preflight.py" "${MASTER_URI}" "${PC_ROS_IP}"
DISPLAY_VALUE="${DISPLAY:-:0}"
AUTH="${XAUTHORITY:-/run/user/$(id -u)/gdm/Xauthority}"
[[ -r "${AUTH}" ]] || { echo "X11 authority unavailable: ${AUTH}" >&2; exit 1; }
python3 - "${MASTER_URI}" <<'PY'
import socket, sys, xmlrpc.client
socket.setdefaulttimeout(4)
master = xmlrpc.client.ServerProxy(sys.argv[1])
code, message, state = master.getSystemState('/pc_rviz_preflight')
if code != 1:
    raise SystemExit(message)
print('KV260 Master reachable.')
PY
docker image inspect x3plus:melodic-amd64 >/dev/null
if docker inspect "${NAME}" >/dev/null 2>&1; then
  if [[ "$(docker inspect -f '{{.State.Running}}' "${NAME}")" == true ]]; then
    running_mode="$(docker inspect -f '{{index .Config.Labels "x3plus.viewer.mode"}}' "${NAME}")"
    running_mode="${running_mode:-slam}"
    running_env="$(docker inspect -f '{{range .Config.Env}}{{println .}}{{end}}' "${NAME}")"
    if [[ "${2:-}" != --reconnect && "${running_mode}" == "${MODE}" ]] &&
       grep -Fqx "ROS_MASTER_URI=${MASTER_URI}" <<< "${running_env}" &&
       grep -Fqx "ROS_HOSTNAME=${PC_ROS_IP}" <<< "${running_env}"; then
      echo "${NAME} is already running in ${MODE} mode."
      exit 0
    fi
    if [[ "${2:-}" != --replace && "${2:-}" != --reconnect ]]; then
      echo "${NAME} is already running with different mode/network settings; stop it before switching or pass --replace." >&2
      exit 3
    fi
    docker stop -t 5 "${NAME}" >/dev/null
  fi
  docker rm "${NAME}" >/dev/null
fi
graphics=()
for device in /dev/dri/card0 /dev/dri/renderD128; do
  [[ ! -e "${device}" ]] || graphics+=(--device "${device}:${device}")
done
docker run -d --name "${NAME}" --label "x3plus.viewer.mode=${MODE}" --privileged --net=host --ipc=host \
  --env "DISPLAY=${DISPLAY_VALUE}" --env XAUTHORITY=/root/.Xauthority \
  --env "ROS_MASTER_URI=${MASTER_URI}" \
  --env "ROS_HOSTNAME=${PC_ROS_IP}" \
  --env QT_X11_NO_MITSHM=1 --env QT_ACCESSIBILITY=0 --env NO_AT_BRIDGE=1 \
  --env QT_QPA_PLATFORMTHEME=none --env XDG_RUNTIME_DIR=/tmp/runtime-root \
  --env "LIBGL_ALWAYS_SOFTWARE=${RVIZ_SOFTWARE_RENDERING:-0}" \
  --volume /tmp/.X11-unix:/tmp/.X11-unix:rw \
  --volume "${AUTH}:/root/.Xauthority:ro" \
  --volume "${BASE}:/pc-rviz:ro" \
  --tmpfs /tmp/runtime-root:rw,mode=700 \
  --log-opt max-size=10m --log-opt max-file=2 \
  "${graphics[@]}" x3plus:melodic-amd64 \
  bash -c "source /opt/ros/melodic/setup.bash; source /opt/x3plus_ws/devel/setup.bash; exec ${ROS_LAUNCH}"
sleep 3
if [[ "$(docker inspect -f '{{.State.Running}}' "${NAME}")" != true ]]; then
  docker logs --tail 60 "${NAME}" >&2
  exit 1
fi
echo "PC RViz started (${MODE}): ${PC_ROS_IP} -> ${KV260_IP}."
echo "Stop viewer: docker stop ${NAME}"