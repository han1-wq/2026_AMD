"""Bounded, authenticated SO101 LAN teleoperation. Simulation is the default."""
import argparse
import hashlib
import hmac
import json
import math
from pathlib import Path
import secrets
import signal
import socket
import time

JOINTS = ('shoulder_pan', 'shoulder_lift', 'elbow_flex', 'wrist_flex', 'wrist_roll', 'gripper')
LIMIT = 4096


def positions(value):
    if not isinstance(value, dict) or set(value) != set(JOINTS):
        raise ValueError('Expected exactly six joint names')
    for name, number in value.items():
        low = 0 if name == 'gripper' else -100
        if type(number) not in (float, int) or not math.isfinite(number) or not low <= number <= 100:
            raise ValueError('Invalid normalized position: ' + name)
    return value


def canonical(value):
    return json.dumps(value, sort_keys=True, separators=(',', ':'), allow_nan=False).encode()


class Wire:
    def __init__(self, sock, key):
        self.sock, self.key = sock, key
        self.buffer = b''

    def send(self, data):
        mac = hmac.new(self.key, canonical(data), hashlib.sha256).hexdigest()
        packet = canonical({'data': data, 'mac': mac}) + b'\n'
        if len(packet) > LIMIT:
            raise ValueError('Frame too large')
        self.sock.sendall(packet)

    def receive(self, deadline):
        while b'\n' not in self.buffer:
            remaining = deadline - time.monotonic()
            if remaining <= 0:
                raise TimeoutError('Command deadline expired')
            self.sock.settimeout(remaining)
            try:
                chunk = self.sock.recv(LIMIT + 1 - len(self.buffer))
            except socket.timeout as exc:
                raise TimeoutError('Command deadline expired') from exc
            if not chunk:
                raise EOFError('Peer disconnected')
            self.buffer += chunk
            if len(self.buffer) > LIMIT:
                raise ValueError('Frame too large')
        line, self.buffer = self.buffer.split(b'\n', 1)
        if time.monotonic() >= deadline:
            raise TimeoutError('Expired frame')
        packet = json.loads(line)
        if not isinstance(packet, dict) or set(packet) != {'data', 'mac'}:
            raise ValueError('Invalid envelope')
        expected = hmac.new(self.key, canonical(packet['data']), hashlib.sha256).hexdigest()
        if not isinstance(packet['mac'], str) or not hmac.compare_digest(expected, packet['mac']):
            raise ValueError('Authentication failed')
        return packet['data']


class Arm:
    def __init__(self, args):
        self.bus = None
        self.live = False
        self.current = dict.fromkeys(JOINTS, 0.0)
        self.args = args

    def open(self):
        if not self.args.hardware:
            return
        if self.args.role == 'server':
            from lerobot.robots.so101_follower import SO101Follower, SO101FollowerConfig
            obj = SO101Follower(SO101FollowerConfig(
                port=self.args.serial, id='R12252801', calibration_dir=Path(self.args.calibration),
                disable_torque_on_disconnect=False))
        else:
            from lerobot.teleoperators.so101_leader import SO101Leader, SO101LeaderConfig
            obj = SO101Leader(SO101LeaderConfig(
                port=self.args.serial, id='R07252801', calibration_dir=Path(self.args.calibration)))
        if set(obj.calibration) != set(JOINTS):
            raise ValueError('Missing calibration')
        self.bus = obj.bus
        self.bus.connect()
        for name in JOINTS:
            cal = obj.calibration[name]
            if cal.id != self.bus.motors[name].id or cal.range_min >= cal.range_max:
                raise ValueError('Invalid calibration: ' + name)
            for register, expected in (
                ('Min_Position_Limit', cal.range_min), ('Max_Position_Limit', cal.range_max),
                ('Homing_Offset', cal.homing_offset),
            ):
                if self.bus.read(register, name, normalize=False, num_retry=10) != expected:
                    raise ValueError('Calibration mismatch: ' + name + ' ' + register)
            if self.bus.read('Operating_Mode', name, normalize=False, num_retry=10) != 0:
                raise ValueError('Motor is not in position mode: ' + name)
        self.read()
        if self.args.role == 'client':
            # Leader must already be freely movable; do not silently release torque.
            for name in JOINTS:
                if self.bus.read('Torque_Enable', name, normalize=False, num_retry=10) != 0:
                    raise ValueError('Leader torque is enabled; prepare leader separately')

    def read(self):
        if self.bus:
            self.current = positions(self.bus.sync_read('Present_Position', num_retry=10))
        return self.current.copy()

    def activate(self):
        if self.bus:
            # Seed goals from raw current positions before enabling any torque.
            raw = self.bus.sync_read('Present_Position', normalize=False, num_retry=10)
            self.live = True
            for name, value in raw.items():
                self.bus.write('Goal_Position', name, value, normalize=False, num_retry=10)
            self.bus.enable_torque(num_retry=10)
        else:
            self.live = True

    def write(self, target):
        if self.bus:
            self.bus.sync_write('Goal_Position', target, num_retry=10)
        else:
            self.current = target.copy()

    def hold(self):
        if self.bus and self.live:
            raw = self.bus.sync_read('Present_Position', normalize=False, num_retry=10)
            # Individual acknowledged writes for the terminal hold command.
            for name, value in raw.items():
                self.bus.write('Goal_Position', name, value, normalize=False, num_retry=10)
        if self.bus and self.live:
            print('HOLD: position goal acknowledged; torque preserved; restart both processes to resume', flush=True)
        else:
            print('HOLD: simulated/inactive; no motor command sent; restart both processes to resume', flush=True)

    def close(self):
        if self.bus and self.bus.is_connected:
            self.bus.disconnect(disable_torque=False)


def validate_reply(reply, seq, nonce):
    if not isinstance(reply, dict) or set(reply) != {'seq', 'nonce', 'positions'}:
        raise ValueError('Invalid command')
    if type(reply['seq']) is not int or reply['seq'] != seq or reply['nonce'] != nonce:
        raise ValueError('Stale/replayed command')
    return positions(reply['positions'])


def limited(target, present):
    # Same per-command clamp as the original local max_relative_target=5.0.
    return {name: present[name] + max(-5.0, min(5.0, target[name] - present[name]))
            for name in JOINTS}


def serve_connection(sock, args, key, arm):
    wire = Wire(sock, key)
    seq = 0
    start = time.monotonic()
    while not args.duration or time.monotonic() - start < args.duration:
        cycle = time.monotonic()
        nonce = secrets.token_hex(16)
        deadline = cycle + args.ttl
        wire.send({'seq': seq, 'nonce': nonce, 'mode': 'hardware' if args.hardware else 'dry-run'})
        target = validate_reply(wire.receive(deadline), seq, nonce)
        present = arm.read()
        if time.monotonic() >= deadline:
            raise TimeoutError('Expired while reading follower')
        if seq == 0:
            arm.activate()
            if time.monotonic() >= deadline:
                raise TimeoutError('Expired during activation')
        now = time.monotonic()
        goal = limited(target, present)
        arm.write(goal)
        seq += 1
        if seq == 1 or seq % 100 == 0:
            print(json.dumps({'applied': seq, 'round_trip_ms': round((now-cycle)*1000, 2),
                              'present': present, 'goal': goal}), flush=True)
        time.sleep(max(0, 1 / args.hz - (time.monotonic() - cycle)))
    print('SESSION_COMPLETE', seq, flush=True)


def server(args, key, arm):
    with socket.socket() as listener:
        listener.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        listener.bind((args.host, args.port))
        listener.listen(1)
        listener.settimeout(1)
        print('LISTENING', args.host, args.port, 'hardware' if args.hardware else 'dry-run', flush=True)
        waiting = time.monotonic()
        while True:
            if time.monotonic() - waiting > args.accept_timeout:
                raise TimeoutError('No authorized client connected')
            try:
                sock, addr = listener.accept()
            except socket.timeout:
                continue
            with sock:
                if addr[0] != args.peer:
                    print('REJECTED_SOURCE', addr[0], flush=True)
                    continue
                sock.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
                sock.settimeout(args.ttl)
                serve_connection(sock, args, key, arm)
                return


def client(args, key, arm):
    with socket.create_connection((args.host, args.port), timeout=5) as sock:
        sock.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
        wire = Wire(sock, key)
        seq = 0
        start = time.monotonic()
        while not args.duration or time.monotonic() - start < args.duration:
            request = wire.receive(time.monotonic() + 2)
            mode = 'hardware' if args.hardware else 'dry-run'
            if (not isinstance(request, dict) or set(request) != {'seq', 'nonce', 'mode'}
                    or request['seq'] != seq or request['mode'] != mode
                    or not isinstance(request['nonce'], str) or len(request['nonce']) != 32):
                raise ValueError('Unexpected server challenge or hardware mode mismatch')
            target = arm.read()
            if not args.hardware:
                target['wrist_roll'] = 2 * math.sin(time.monotonic() - start)
            wire.send({'seq': seq, 'nonce': request['nonce'], 'positions': target})
            seq += 1
        print('CLIENT_COMPLETE', seq, flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('role', choices=['server', 'client'])
    parser.add_argument('--host', required=True)
    parser.add_argument('--peer', default='192.168.43.123')
    parser.add_argument('--port', type=int, default=5101)
    parser.add_argument('--key', type=Path, required=True)
    parser.add_argument('--hardware', action='store_true')
    parser.add_argument('--probe', action='store_true', help='Read hardware configuration/position then exit; no writes')
    parser.add_argument('--serial')
    parser.add_argument('--calibration')
    parser.add_argument('--ttl', type=float, default=1.0)
    parser.add_argument('--hz', type=float, default=20)
    parser.add_argument('--duration', type=float, default=0)
    parser.add_argument('--accept-timeout', type=float, default=60)
    args = parser.parse_args()
    if not (0.05 <= args.ttl <= 1 and 1 <= args.hz <= 30
            and math.isfinite(args.duration) and args.duration >= 0
            and 1 <= args.accept_timeout <= 300):
        parser.error('Invalid rate/timing limits')
    if args.hardware and (not args.serial or not args.calibration):
        parser.error('--hardware requires --serial and --calibration')
    if args.probe and not args.hardware:
        parser.error('--probe requires --hardware')
    key = args.key.read_bytes()
    if len(key) < 32:
        parser.error('Shared key must contain at least 32 bytes')
    signal.signal(signal.SIGTERM, lambda *_: (_ for _ in ()).throw(KeyboardInterrupt()))
    arm = Arm(args)
    failed = False
    try:
        arm.open()
        if args.probe:
            print('READ_ONLY_PROBE_PASS', json.dumps(arm.read()), flush=True)
        else:
            (server if args.role == 'server' else client)(args, key, arm)
    except (Exception, KeyboardInterrupt) as exc:
        failed = True
        print('STOP', type(exc).__name__, str(exc), flush=True)
    finally:
        try:
            if args.role == 'server' and not args.probe:
                arm.hold()
        except Exception as exc:
            failed = True
            print('HOLD_FAILED: physical stop required:', repr(exc), flush=True)
        finally:
            arm.close()
    raise SystemExit(1 if failed else 0)


if __name__ == '__main__':
    main()