# SO101 speed-400 preparation: offline tests passed; hardware execution blocked

## Completed
- Requested exploration, midpoint and recovery speed cap: 400 (raw register value; no physical unit conversion asserted). Torque settings remain try=400/max=600, wrist roll and gripper cap=300; no torque increase from the speed-150 wrapper.
- Zero or implausibly small measured spans abort before midpoint motion. Invalid per-joint results cannot enter provisional results; complete calibration is validated before hardware calibration writes.
- Register writes now require matching readback. Acknowledged-but-ignored writes, overloads and status/temperature/voltage faults latch an abort. Position-target commands remain blocked.
- Cleanup verifies writes and captures two stop-readback samples. A failed torque-off readback prevents switching that motor into position mode. Nonzero velocity or fault status prevents a successful result.
- Preserved phase/overall watchdogs and bounded best-effort cleanup. These are software guards, not a hardware emergency stop.
- Corrected the test file for host Python 3.8 syntax. All 37 mock-bus tests passed in lerobot-cpu:joyandai-0.4.3; test command and output are saved in this directory.
- Test container had no serial device mounts, no privileged flag, no network and a read-only artifacts mount. No hardware-connected run was made for this version.
- Original backup hash and prior-run launcher/test hashes matched saved evidence; inspected upstream LeRobot source hashes are unchanged.

## Not resolved / not claimed
- The reason actual motors still reported enabled torque after stop commands remains undiagnosed. Mock tests only verify detection and abort behavior; they do not prove physical stopping works.
- The cause of zero measured ranges is not established. The new checks reject these results rather than attempting to force motion. The 200-count plausibility floor is a conservative software heuristic, not a manufacturer specification.
- User confirmed physical power-off and inspection after the failed speed-150 run. No independent post-power-off telemetry was collected. Keep power off during offline work.
- No fresh before.json, candidate.json, success.json or final calibration was created. offline_before_fixture.json is historical test data and must not be treated as a fresh hardware backup.
- Previous register changes were not restored. See the previous run's register_changes.json and RESULT.md.

## Execution lock and next prerequisite
- HARDWARE_EXECUTION_BLOCKED=True: calibrate_slow.py --execute and --stop-only exit before constructing or connecting a device. Default invocation validates imports only.
- The copied preflight.py is a hardware-reading utility and was NOT executed in this offline preparation.
- Do not remove the lock merely because tests pass. A separately authorized, supervised diagnosis must establish reliable register writes and verified torque-off, with a new snapshot, before considering any motion. No automatic retry launcher was installed in this directory.
