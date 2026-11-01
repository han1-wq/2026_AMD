# SO101 speed-150 attempt: FAILED; shutdown NOT verified

- Motion started 2026-10-23 10:22:13 UTC; calibration container exited with code 1 at 10:22:29 UTC.
- Speed 150; try torque 400, cap 600; wrist roll and gripper cap 300. Existing protection settings preserved; no upstream source changes.
- Offline mock-bus tests: 20 passed. This did not validate hardware behavior.
- Elbow flex and wrist flex both produced zero-width ranges; gripper also produced a zero-width provisional range. These results are invalid.
- The guard latched an overload reported by gripper ID 6 while reading status; no automatic calibration retry was made. Operator also requested TERM after detecting invalid elbow/wrist results.
- Primary cleanup and one stop-only fallback both failed shutdown verification. Latest saved readback shows torque enabled on IDs 1,3,4,5,6 and wrist flex velocity -50. Target velocities are zero. Containers exiting does NOT prove physical stop.
- User was told to cut power and subsequently confirmed physical power-off and mechanical inspection. This is user confirmation, not independent telemetry. Keep power off for offline repair.
- No final calibration, candidate.json, or success.json exists. Provisional results must not be used.
- No servo register rollback was attempted. See register_changes.json, before.json, primary_after.json and after.json. Original backup remains at /home/amd/lerobot-deploy/workspace/calibration_runs/so101_20261023T095558Z/before.json.
- Both run containers exited; kv260-vision-console was left running.
