# SO101 automatic calibration: FAILED, do not reuse as calibrated

- Run: 2026-10-23, motion started 09:58:35 UTC; container exited 09:59:40 UTC, exit code 1.
- Device: SO101 follower, stable serial path `/dev/serial/by-id/usb-1a86_USB_Single_Serial_5B91028053-if00`.
- Read-only preflight passed for six configured STS3215 motors, IDs 1 through 6.
- The original registers were backed up to `/home/amd/lerobot-deploy/workspace/calibration_runs/so101_20261023T095558Z/before.json`.
- Existing installed calibration logic ran with explore_velocity=600, try_torque=600, max_torque=1000; wrist-roll and gripper use their separate 300 limits.
- A temporary wrapper added 20-second sweep/midpoint deadlines, an elapsed-time check before each motion phase, and best-effort shutdown. Installed LeRobot source was not modified.
- All six individual joint routines produced provisional results, but the recovery phase failed reading Present_Position from shoulder_lift (ID 2): `[RxPacketError] Overload error!`. These provisional results are NOT a completed calibration.
- Cleanup writes for shoulder_lift Goal_Velocity and Torque_Enable reported overload errors. Subsequent saved readback in `/home/amd/lerobot-deploy/workspace/calibration_runs/so101_20261023T095558Z/stopped.json` shows Torque_Enable=0, Goal_Velocity=0 and Operating_Mode=0 for all six motors. This is a recorded shutdown state, not continuous physical monitoring.
- No final calibration JSON, candidate.json, or success.json was generated.
- Calibration attempted changes to homing offsets, position limits and protection registers. No automatic register rollback was performed. Do not assume the prior servo configuration is intact.
- User was instructed to cut motor power. Do not retry calibration, run teleoperation or ACT, or restore registers automatically. Inspect the shoulder joint and recovery logic before an explicitly authorized next hardware operation.
- The calibration container stopped; existing `kv260-vision-console` remained running.
- Full log: `/home/amd/lerobot-deploy/workspace/calibration_runs/so101_20261023T095558Z/calibration.log`.
- Cleanup report: `/home/amd/lerobot-deploy/workspace/calibration_runs/so101_20261023T095558Z/cleanup.json`.