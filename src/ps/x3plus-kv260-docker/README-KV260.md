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