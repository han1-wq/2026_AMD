# SO-101 live diagnostic result

Speed-400 automatic calibration has NOT run. The existing execution gate remains enabled. No calibration file was created.

## Verified on hardware

- USB identity: `usb-1a86_USB_Single_Serial_5B91028053-if00`, resolved to `/dev/ttyACM0`.
- Read-only snapshot: `readback_20261023T105129458093Z/readback.json`; process exit 0.
- Six motors returned model 777 and expected IDs 1–6. Temperature 30–33 C; voltage 12.1–12.2 V.
- Three samples showed torque enable, goal velocity, present velocity, moving and status all zero, with unchanged positions.
- Independent zero-only writes: `stop_20261023T105449485119Z/stop.json`; process exit 0.
- All 12 writes (address 40, one zero byte; address 46, two zero bytes, for each ID) returned communication 0 and error 0; immediate readbacks were zero. Three subsequent samples remained stationary and fault-free.
- No torque-enable, nonzero velocity, position-target, mode-change or calibration-register writes were sent by these diagnostic scripts.

## Remaining blocker

The previous shutdown records report torque still enabled on five motors and residual velocity after stop writes. Inspection of serialization, addressing, SDK transactions and cleanup has not established the cause. The current successful writes were issued to already disabled, stationary motors after a restart. They do not demonstrate torque removal during motion or under the earlier overload condition. No dynamic stop test was attempted; the motion execution gate was not removed.

Before automatic limit exploration resumes, establish reliable torque-disable behavior under an appropriately supported, controlled hardware test, including the prior fault condition, or identify and correct the previous failure from packet-level evidence. Repeating calibration at speed 400 is not a diagnostic substitute for that missing evidence.

## Validation

The new read-only transport passed 7 tests; the zero-only transport passed 4 tests. Existing 37-test results were inspected without rerunning that suite. Diagnostic files were syntax checked and hardware artifacts were independently parsed and checked. The original backup SHA-256 remains `071cb4cc1c5f626ebc0ea52511206fb3d8ff1eecab54c9b58658fc7e25ebe176`.

The local tutorial is `/home/amd/lerobot-deploy/lerobot/examples/calibrate/auto_calibrate_example.py`. Its single-command interface delegates to device connection, calibration and disconnection; it does not resolve the observed shutdown failure. `COM3` is a Windows example port.