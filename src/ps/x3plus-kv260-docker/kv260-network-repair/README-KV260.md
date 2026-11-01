# X3plus KV260 ARM64 Docker deployment

This directory is a self-contained deployment bundle for the real KV260. It
contains the already-staged ROS source, YDLidar SDK, Rosmaster Python library,
launch/configuration files and scripts needed to build an ARM64 ROS Melodic
image. It does not depend on the original VM path or repository.

The VM was used for amd64 validation only. Do not copy the amd64 image to the
KV260 and do not copy `build/`, `devel/`, object files or shared libraries from
the VM. Build this Dockerfile natively on the KV260 so all C++ code is compiled
for aarch64.

## 1. Transfer from the VM

Run on the VM:

```bash
cd /home/amd
./x3plus-kv260-docker/verify-bundle.sh
tar --exclude='context/.git' -czf x3plus-kv260-docker.tar.gz x3plus-kv260-docker
scp x3plus-kv260-docker.tar.gz amd@KV260_IP:/home/amd/
```

Run on the KV260:

```bash
cd /home/amd
tar -xzf x3plus-kv260-docker.tar.gz
cd /home/amd/x3plus-kv260-docker
chmod +x *.sh context/*.sh
./verify-bundle.sh
```

The staged context is intentional: `build-context.sh` from the original VM
repository is not needed on KV260 because it refers to the VM's parent source
tree. The context already contains the VM-tested launch fixes.

## 2. Check the KV260 hardware

Connect the car and lidar to the KV260, then run:

```bash
./check-kv260-hardware.sh
```

Identify the stable paths under `/dev/serial/by-id/`. Confirm which device is
the car controller and which is the lidar. If permissions prevent access, add
the KV260 user to the appropriate serial group or use the deployment command
with the required privileges.

Create the persistent map directory:

```bash
sudo mkdir -p /opt/x3plus-maps
sudo chmod 0777 /opt/x3plus-maps
```

Copy the environment template and edit the two device paths:

```bash
cp KV260.env.example KV260.env
nano KV260.env
source KV260.env
```

`ROBOT_SERIAL` and `LIDAR_SERIAL` must be the actual host paths. The helper
script resolves those paths, maps them to fixed container paths `/dev/robot`
and `/dev/lidar`, and passes the fixed paths to the ROS launch configuration.
The generated code also retains the tested
`PYTHONPATH=/opt/rosmaster` and uses `bytearray` for PySerial writes.


## Stable USB serial paths

### OFDM Task And Log Transport

The dashboard includes an `OFDM` communication tab. It is disconnected by
default and never starts a robot task from returned data. Requires Python 3.8+,
Tkinter, pyserial and the existing transport modules in `/home/ubuntu/ofdm-host`
(override the directory with `OFDM_HOST_DIR`). Connect only after confirming
exclusive ownership of the FT2232 UART. Discovery accepts only `0403:6010`,
interface 1, using serial number/USB location rather than numeric tty paths.
Multiple devices require explicit selection. Connection does not prove firmware
readiness. Wait until firmware initialization has completed before sending.

Send the selected task state, the last 3000 bytes of its log, or custom text.
The optional auto-sync checkbox sends changed selected-task state and new log
tails every two seconds while connected. It does not replay old logs; rotation,
selection changes and disconnect reset the cursor. At most 2048 new log bytes
are sampled per interval; excess logs are intentionally not buffered. A full
eight-message queue rejects new submissions, including auto-sync log samples,
and records the rejection. Manual sends remain explicit user actions.

Messages are UTF-8 JSON with version, kind, task action, timestamp and content,
limited to 24000 encoded bytes. The 64-byte payload contains a 14-byte
little-endian header `<2sBBIHHH`: magic `KV`, version 1, kind (task=1, log=2,
text=3), 32-bit message ID, zero-based fragment index, total fragment count and
valid byte length. The remaining 50 bytes hold data with zero padding. UTF-8
characters may span fragments; reassemble valid bytes before decoding. No
firmware modification is required for loopback, but remote storage/execution
would require a separate receiver/application and acknowledgement protocol.

Only one fragment is outstanding. The adapter uses the existing framing,
sequence/CRC receiver, two-second deadline, USB identity validation and
reconnection. Every fragment must return result 0, flags `0x03`, length 64 and
identical content. Inter-fragment delay is at least 50 ms. On the first failure
the message stops without automatic retry; only all-fragment success is labeled
`loopback verification passed`. This does not prove remote storage or execution
and does not bypass robot safety gates. Disconnect cancels active and queued
messages. Closing the dashboard closes UART but leaves robot tasks/services
running. Exportable validation records retain the most recent 100000 characters.
The event queue is bounded to 256 entries and drops the oldest on overflow.

Run adapter tests without physical hardware:

```bash
OFDM_HOST_DIR=/home/ubuntu/ofdm-host python3 -B -m unittest test_launcher_ofdm -v
```

The robot and lidar must be configured with stable udev paths, not `/dev/ttyUSB0` or `/dev/ttyUSB1`. The current KV260 aliases are:

```text
/dev/myserial -> robot controller
/dev/ydlidar -> lidar
```

`run-robot.sh` passes these alias paths directly to Docker. The script waits for udev, verifies USB identity, checks that both aliases are character devices and distinct, and rejects numeric tty paths. A running container can retain stale device numbers after USB reconnect: the launcher checks the container nodes against the host and refuses reuse on mismatch. Ensure the robot is stopped before explicitly stopping/restarting that container. No automatic driver recovery is attempted.

The one-time migration from an older container that stored `/dev/ttyUSB*` mappings is performed with:

```bash
FORCE_RECREATE=1 ./run-robot.sh
```

Before removing the old container, the script saves a Docker image snapshot plus inspect/diff/log files and recreates from that snapshot, preserving validated writable-layer fixes. Future normal starts should use `./run-robot.sh`; it will reuse the stable-path container. Automatic ROS-address migration only proceeds while robot ROS processes are idle. It records the old container, snapshot, restart policy and running state; a failed stop, snapshot, rename, policy update or create attempts to restore the old name, policy and prior running state. This protects the local containers, but cannot move already-running ROS nodes or desktop clients to a new address; stop services and reconnect clients before switching networks.

## 3. Build the ARM64 image on KV260

The build downloads Ubuntu/ROS packages, so KV260 needs network access:

```bash
./build-arm64.sh
```

This creates:

```text
x3plus:melodic-arm64
```

The build compiles YDLidar SDK and the catkin workspace inside the ARM64 image.
If the ROS key/package mirror has a transient network failure, retry after the
network recovers; do not substitute the amd64 image.

## 4. Start ROS and the robot

Use separate SSH/Terminal sessions on KV260.

Terminal A:

```bash
source KV260.env
./run-master.sh
```

Terminal B:

```bash
source KV260.env
./run-robot.sh
```

`run-robot.sh` starts a persistent, headless container with `--privileged`,
host networking, both serial devices and `/opt/x3plus-maps:/maps`. It does not
start hardware or movement nodes yet.

Terminal C, start hardware and lidar only. Run one of the following in this terminal; do not run `./run-robot.sh` again:

Then use **one** of the following hardware launch files, not both at once:

```bash
docker exec -it x3plus-robot bash -lc '
  source /opt/ros/melodic/setup.bash; source /opt/x3plus_ws/devel/setup.bash
  roslaunch yahboomcar_nav laser_bringup.launch
'
```

For an Astra Pro depth camera, use instead:

```bash
docker exec -it x3plus-robot bash -lc '
  source /opt/ros/melodic/setup.bash; source /opt/x3plus_ws/devel/setup.bash
  roslaunch yahboomcar_nav laser_astrapro_bringup.launch
'
```

The hardware launches default to no SLAM and no local RViz. The old command
`laser_bringup.launch use_slam:=true` remains supported, but do not use it
when starting `yahboomcar_map.launch` separately.

Terminal D, start gmapping:

```bash
docker exec -it x3plus-robot bash -lc '
  source /opt/ros/melodic/setup.bash; source /opt/x3plus_ws/devel/setup.bash
  roslaunch yahboomcar_nav yahboomcar_map.launch use_rviz:=false map_type:=gmapping
'
```

This is the supported headless SLAM sequence. The separate hardware launch
uses no SLAM; this command starts exactly one gmapping node with:

```text
use_rviz:=false map_type:=gmapping
```

The equivalent helper command is `./start-slam.sh` after the hardware launch
is already running. It starts only `yahboomcar_map.launch`; it does not start a
second driver or lidar.

The KV260 is the hardware/SLAM computer. Do not start the VM's RViz container
or another hardware launch against the same serial ports.

## 5. Keyboard control

Open Terminal E on KV260 and run:

```bash
source KV260.env
./start-keyboard.sh
```

This uses `docker exec -it`, not a detached process, because
`yahboom_keyboard.py` reads raw keys from a real TTY. Keep this Terminal
focused. The controls are:

```text
        u   i   o
        j   k   l
        m   ,   .
```

`i` forward, `,` backward, `j/l` turn left/right, `u/o/m/.` diagonal motion,
and `SPACE` or `k` immediate stop. `Ctrl-C` exits the keyboard node and its
shutdown handler publishes zero velocity.

Before putting the wheels on the floor, confirm the driver and sensor topics:

```bash
docker exec -it x3plus-robot bash -lc '
  source /opt/ros/melodic/setup.bash
  source /opt/x3plus_ws/devel/setup.bash
  rosnode list
  rostopic info /cmd_vel
  rostopic hz /scan
  rostopic hz /odom
  rosrun tf tf_echo base_footprint laser
'
```

`/driver_node` must subscribe to `/cmd_vel`; `/ydlidar_lidar_publisher` must
publish `/scan`; and the TF chain must be valid. The keyboard launch is the
same command validated in the VM:

```bash
roslaunch yahboomcar_ctrl yahboom_keyboard.launch
```

The existing joystick node is included by the hardware bringup and also
publishes `/cmd_vel`. Do not operate the joystick and keyboard simultaneously.

## 6. Save a map and navigate

With SLAM running, save a map into the persistent host directory. The direct
container command is:

```bash
docker exec -it x3plus-robot bash -lc '
  source /opt/ros/melodic/setup.bash; source /opt/x3plus_ws/devel/setup.bash
  rosrun map_server map_saver -f /maps/my_map
'
```

The original script workflow is also supported inside the container:

```bash
docker exec -it x3plus-robot bash -lc '
  source /opt/ros/melodic/setup.bash; source /opt/x3plus_ws/devel/setup.bash
  bash /root/yahboomcar_ws/src/yahboomcar_nav/maps/map.sh
'
```

Stop SLAM before starting navigation, then start hardware again if it was
stopped, and launch navigation with the saved base name:

```bash
docker exec -it x3plus-robot bash -lc '
  source /opt/ros/melodic/setup.bash; source /opt/x3plus_ws/devel/setup.bash
  roslaunch yahboomcar_nav yahboomcar_navigation.launch use_rviz:=false map:=my_map
'
```

`map:=my_map`, `map:=/maps/my_map`, `map:=/maps/my_map.yaml`, and the old
`~/yahboomcar_ws/src/yahboomcar_nav/maps/my_map` form are normalized to the
mounted `/maps` directory. The map YAML uses a relative image filename, so it
also works when loaded from `/maps`.

## 7. RViz from another computer (optional)

KV260 does not need a local graphical display. Run RViz on an amd64 ROS Melodic
computer using the tested X11 setup, but use the KV260 LAN address rather than
`127.0.0.1`:

```bash
ROS_MASTER_URI=http://KV260_IP:11311
ROS_HOSTNAME=RVIZ_COMPUTER_IP
```

The ROS nodes must be reachable in both directions. Launch only:

```bash
roslaunch yahboomcar_nav view_map.launch
```

For navigation visualization, launch only:

```bash
roslaunch yahboomcar_nav view_navigate.launch
```

The supplied RViz configurations contain `2D Pose Estimate`, `2D Nav Goal`
and `Publish Point`. `send_mark.py` clears queued multipoint goals whenever a
new initial pose is published. `2D Nav Goal` sends a single goal; `Publish
Point` queues a sequence and continues cycling through it. This requires
`move_base` to be running and a valid `map -> odom -> base_footprint` TF chain.

The navigation planner is DWA. Its X3plus settings are in
`yahboomcar_nav/param/common/dwa_local_planner_params_X3plus.yaml` and are
loaded by `move_base.launch`; the image installs
`ros-melodic-dwa-local-planner` explicitly.

Do not launch `laser_bringup.launch` in the RViz computer: it would try to
start another lidar and another car driver. For the current VMware graphics
workaround, retain `--privileged`, `--net=host`, `--ipc=host`, `DISPLAY`,
`QT_X11_NO_MITSHM=1` and the `/tmp/.X11-unix` mount.

## 8. Stop safely

Stop all deployment containers after pressing SPACE/k:

```bash
./stop-all.sh
```

Check logs if a node exits:

```bash
docker logs x3plus-master
docker logs x3plus-robot
```

## Desktop dashboard update (2026-10-08)

The installed entry point is `/home/ubuntu/x3plus-kv260-docker/kv260-launcher.sh`.
The dashboard provides controls, a map selector, USB/ROS/container diagnostics,
bounded task logs and help. Opening it only reads state; closing it leaves
launched services running. Keyboard control still opens a real terminal.
Other actions run under detached supervisors without extra terminals.

The current `KV260.env` pins the chassis to VID/PID `1a86:7523`, interface `00`,
physical USB location `1-1.4` (this adapter has no serial number). The lidar uses
`10c4:ea60`, interface `00`, serial `0001`. Numeric tty names may change.
If the chassis cable is moved, inspect USB discovery and deliberately update
`ROBOT_USB_LOCATION`. VID/PID identify a model, not an individual; serials may
also be duplicated. Ambiguous matches, unknown interfaces and wrong aliases
are rejected. These checks do not prove communication or driver health.

Configuration accepts literal `export KEY=value` assignments and comments;
quote values containing spaces. Shell substitutions/variable expansion are
not evaluated. Existing process environment overrides the configuration file.
Shell helpers and Python now use the same parser through `launcher-env.sh`.

Read-only checks (do not start drivers or load a DPU):

```bash
cd /home/ubuntu/x3plus-kv260-docker
python3 launcher_core.py --check
python3 launcher_core.py --container x3plus-robot
python3 kv260_launcher.py --diagnose
python3 -m unittest -v test_launcher test_launcher_modes
```

Status is sampled every eight seconds in one worker with a one-item result
queue. Docker/XML-RPC probes have timeouts. ROS node names come from master
registration and are not a live health test. The UI reads only the latest
24 KB of the selected task log. Each action retains two logs of at most about
256 KiB each under `/home/ubuntu/.local/state/kv260-launcher/`.
This limit covers launcher logs only; ROS/Docker/vision retain their existing
logging policies. The dashboard does not import ROS, OpenCV or DPU libraries.

One GUI instance and one task per action are allowed. Both RViz modes share a
lock. Startup and stop commands share a control lock. Long-lived RViz, vision
and keyboard tasks release the control lock after their service is detected,
but retain their own action lock. Finite tasks have a 180-second supervisor
timeout, except Base Environment, which allows 420 seconds so a 300-second
network-migration snapshot and recovery can complete. A concurrent operation can be rejected with exit code 75; it is not
queued or automatically retried. A long startup whose service never appears
can retain the control lock until its process exits. Software stop is not a
physical emergency stop. A timeout/error does not prove background ROS/Docker
processes stopped: inspect actual service state before retrying.

`stop-all.sh` attempts robot/master, RViz and Astra vision shutdown and reports
partial failures. Robot/master containers, their writable layers and maps
remain. The temporary RViz container still uses Docker `--rm`. Direct shell
operations bypass the supervisor's global gate; do not mix simultaneous direct
commands and GUI controls. Map saving has its own filesystem lock and rejects
existing YAML/PGM files, including dangling symlinks. Saving and map navigation
retain the existing ROS scripts and map directory.

Navigation runs `launcher_modes.py prepare-navigation` before starting OR
reusing an existing navigation instance. It stops the keyboard roslaunch and
script, verifies both processes and known ROS nodes (`/yahboom_keyboard`,
`/keyboard_ctrl`) are absent, then sends zero velocity when keyboard control was
active. It stops SLAM if detected and verifies keyboard/SLAM absence again.
Docker/ROS query errors, residual processes/nodes, stop failures or failure to
send zero velocity reject the navigation request. Stale registrations are
treated conservatively; inspect/clean them explicitly rather than guessing.
Hardware/lidar, RViz and independent vision are not stopped by this guard.
The GUI also offers Stop Keyboard. Keyboard startup rejects an existing
keyboard instance or active navigation (launch/process/node detection); stop
navigation explicitly before switching to manual control. The existing
supervisor control lock serializes GUI transitions. Direct concurrent shell
calls or external ROS publishers still bypass it: this is not a `/cmd_vel`
arbiter, a continuous safety monitor or a physical emergency stop.

If camera enumeration is absent, the dashboard disables vision startup; both
the task supervisor and shell adapter check again before calling the canonical
`/home/ubuntu/start_astra_rgbd_yolov4.sh`. The camera/DPU application itself is
unchanged. Startup refuses to restart an existing unhealthy hardware roslaunch.

Original launcher/config/helper scripts are backed up at
`/home/ubuntu/kv260-launcher-backups/20261008-080743/` (`launcher.tar.gz`,
`SHA256SUMS`, `containers.json`). The deployment also writes a precise rollback
script beside its before-deployment archive. Close the GUI and let active tasks
finish before rollback; restoring files does not stop existing robot services.

## OFDM DMA and YOLO image transfer (2026-10-09)

The OFDM tab now embeds the DMA host console from
`/home/amd/ofdm/eeSDR_ofdm_loopback/host`. Its deployed, self-contained copy
is `/home/ubuntu/x3plus-kv260-docker/ofdm_host`. The legacy mailbox modules
remain for rollback but are no longer loaded by the dashboard.

The tab provides UART hex/text/random loopback, boot-log monitoring, image
loopback with TX/RX previews, log export, and sequential image benchmarks.
UART auto-discovery selects FT2232 `0403:6010` interface 1, rather than a
fixed tty number. Stop UART monitoring before sending UART data.

Three quick actions are also available in the task-log bar and OFDM tab:
`发送当前任务与日志` sends the selected task's saved status and latest log tail;
`发送 USB 与运行状态` sends the most recent read-only monitor sample (up to
eight seconds old); `拍照发送并显示回传` captures a new annotated YOLO frame,
transmits it and displays the saved, verified RX image. UART messages are
UTF-8 JSON limited to 1000 bytes per loopback; the task log is truncated
and marked as such when necessary. Large USB snapshots retain the USB role
health flags and device count while trimming details with a
`details_truncated` flag. UART requires an idle FT2232
port, and the camera pipeline must be running for image capture.

Start **AI 视觉** and wait for its live B3136 RGB-D preview, then click
**拍照发送并显示回传** in the task-log bar or OFDM image tab. Leave the
compatibility ROS topic field empty. The helper waits for a new frame after
the click in `/run/user/1000/kv260-b3136-ui`, preserving the currently selected
original/enhanced display, YOLO boxes and depth labels in a lossless PNG.
It checks frame/status consistency and rejects stopped or stale output.
It does not open the camera or load another DPU model. This is an annotated
RGB image, not a raw 16-bit depth map or continuous video.
PNG plus capture metadata are saved under
`/home/ubuntu/.local/state/kv260-launcher/ofdm-images/`.
Metadata records the matching detection message, actual preprocessing
configuration and display mode. Only the PNG is transmitted; JSON stays local.
Stopping capture cancels only the snapshot helper and leaves inference running.
To stop inference, use **AI 视觉 → 安全停止**.

Current maintained FPGA firmware has static IP `192.168.137.10/24`,
TCP port `5001`. Older release documents mention `192.168.1.10`; use the
address of the actually loaded firmware. The KV260 NetworkManager profile
`ofdm-direct` assigns `192.168.137.60/24` to `eth0`, autoconnects and sets
`ipv4.never-default=yes`. Wi-Fi remains the default route for SSH/ROS.
Direct communication needs no DHCP, NAT or Internet sharing. The profile
is persistent; a reboot acceptance test has not been performed.

The board IP can be changed in the UI or defaulted using
`export OFDM_BOARD_IP=192.168.137.10` in `KV260.env`.
An explicitly entered ROS image topic (or `export OFDM_YOLO_TOPIC=/yolov4/image`)
selects legacy ROS capture with UDP-only Fast DDS transport. Remove this
override or clear the field to use B3136. `/yolov4_b3136/detections` contains
JSON detections and cannot be used as an image topic.
Only one image TCP client is supported by the FPGA; do not run a separate
CLI benchmark while transferring from the GUI. Successful transfer
requires actual returned bytes, matching board CRC and drained ACK window.
The benchmark writes `results.jsonl`, `results.csv`, `summary.json` and
`last_received.png`; inspect success counts, not just process exit status.

The first live camera-image test returned all 546596 bytes in 0.775 seconds,
with CRC32 `f592514a` and matching SHA256
`b205e870672a313ef88b6fd23313fd5436a70b9ff585940573d2d37e58f4606b`.
This timing is one observation, not a guaranteed rate or raw RF BER.

The subsequent 200-transfer run passed 200/200, with zero failures and zero
differences across 874553600 compared bits. Mean transfer time was 1.993 s,
p95 2.429 s, and application goodput 273690 bytes/s (about 2.19 Mbit/s).
Total returned data was 109319200 bytes over 399.427 s. These measurements
include protocol/software overhead and do not measure raw RF BER.
The integrated capture-and-send action then passed with a fresh 544159-byte
image, and the GUI benchmark passed 3/3. TX/RX preview, capture cancellation,
closing during capture, and launcher smoke checks passed. The board passed
84 launcher tests and all 46 DMA host tests (the four display-dependent
tests were rerun successfully with the actual desktop display).

Raw 200-run results are on KV260 at
`/home/ubuntu/x3plus-kv260-docker/ofdm-yolo-200/`. Local evidence, including
original/returned PNGs, summary, per-transfer records and GUI logs, is at
`/home/amd/x3plus-kv260-docker/kv260-network-repair/ofdm-validation-20261009/`.

To roll back the dashboard entry point, close the dashboard and restore
`kv260_launcher.py` from
`/home/ubuntu/x3plus-kv260-docker/backups/ofdm-before-dma-20261009/`.
The old OFDM modules and `/home/ubuntu/ofdm-host` were retained unchanged.
To remove only the direct FPGA network profile, run
`nmcli connection delete ofdm-direct` in the KV260 desktop terminal.

## Lessons carried over from VM validation

1. Build separately for the target architecture; amd64 validation does not
   produce an ARM64 deployment image.
2. Keep one hardware/SLAM stack only; RViz is visualization only.
3. Keep one unambiguous package-level `launch/view_map.launch`; the duplicate
   nested `view/view_map.launch` was removed from this staged context.
4. Keep `/opt/rosmaster` on `PYTHONPATH` and use the tested serial environment
   variables.
5. Use real TTY access for keyboard control.
6. Verify `/scan`, `/odom`, TF and `/cmd_vel` before moving the robot.
7. Use stable serial-by-id paths instead of assuming ttyUSB numbering.