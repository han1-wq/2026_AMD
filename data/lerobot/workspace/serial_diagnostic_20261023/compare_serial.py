"""Bounded, read-only SDK comparison; never constructs a LeRobot device."""
import argparse
import json
import platform
import signal
import time
from pathlib import Path

import scservo_sdk as sdk
import serial


def validate_packet(packet):
    p = list(packet)
    if (len(p) < 8 or p[:2] != [255, 255] or p[3] != len(p) - 4
            or p[-1] != (~sum(p[2:-1]) & 255)):
        raise PermissionError('Invalid packet')
    unicast = (len(p) == 8 and p[2] in range(1, 7)
               and p[4] == 2 and tuple(p[5:7]) in {(3, 2), (40, 1), (56, 2), (65, 1)})
    sync = p[2:-1] == [254, 10, 130, 56, 2, 1, 2, 3, 4, 5, 6]
    if not (unicast or sync):
        raise PermissionError('Only identity, torque, status and position reads are allowed')


class ReadPort(sdk.PortHandler):
    def __init__(self, name):
        super().__init__(name)
        self.packets = 0
        self.window_ms = 50

    def setupPort(self, baud):
        self.ser = serial.Serial(self.port_name, self.baudrate, timeout=0,
                                 write_timeout=1.0, exclusive=True)
        self.is_open = True
        self.ser.reset_input_buffer()
        self.tx_time_per_byte = 10000.0 / self.baudrate
        return True

    def writePort(self, packet):
        validate_packet(packet)
        self.packets += 1
        return super().writePort(packet)

    def setPacketTimeout(self, length):
        self.packet_start_time = self.getCurrentTime()
        self.packet_timeout = self.tx_time_per_byte * (length + 3) + self.window_ms


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--port', default='/dev/ttyACM0')
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    report = {'python': platform.python_version(), 'serial': serial.__version__,
              'write_timeout_s': 1.0, 'profiles': []}
    port = ReadPort(args.port)
    handler = sdk.PacketHandler(0)

    def deadline(signum, frame):
        raise TimeoutError('Diagnostic exceeded 65 seconds')

    signal.signal(signal.SIGALRM, deadline)
    signal.alarm(65)
    try:
        if not port.setBaudRate(1000000):
            raise RuntimeError('Cannot open serial port')
        for motor in range(1, 7):
            for address, length in [(3, 2), (40, 1), (65, 1)]:
                raw, comm, error = handler.readTxRx(port, motor, address, length)
                if comm or error or len(raw) != length:
                    raise RuntimeError('Preflight failed id={} addr={} comm={} error={}'.format(
                        motor, address, comm, error))
                value = sum(byte << (8 * i) for i, byte in enumerate(raw))
                if value != (777 if address == 3 else 0):
                    raise RuntimeError('Unexpected model, enabled torque or motor fault')
        sync = sdk.GroupSyncRead(port, handler, 56, 2)
        for motor in range(1, 7):
            sync.addParam(motor)
        for name, pause, timeout in [('unicast', 0.02, 50), ('sync_fast', 0, 50),
                                     ('sync_50hz', 0.02, 50), ('sync_50hz_200ms', 0.02, 200)]:
            port.window_ms = timeout
            stats = {'name': name, 'success': 0, 'failures': 0, 'errors': [], 'max_call_ms': 0}
            report['profiles'].append(stats)
            end = time.monotonic() + 10
            while time.monotonic() < end:
                start = time.monotonic()
                exception = None
                try:
                    if name == 'unicast':
                        for motor in range(1, 7):
                            raw, comm, error = handler.readTxRx(port, motor, 56, 2)
                            if comm or error or len(raw) != 2:
                                break
                        else:
                            comm, error = 0, 0
                    else:
                        comm, error = sync.txRxPacket(), 0
                except serial.SerialTimeoutException as exc:
                    comm, error = 'write_timeout', 0
                    exception = str(exc)
                    port.is_using = False
                    port.ser.reset_output_buffer()
                stats['max_call_ms'] = max(stats['max_call_ms'], (time.monotonic() - start) * 1000)
                if comm or error:
                    stats['failures'] += 1
                    if len(stats['errors']) < 10:
                        stats['errors'].append({'comm': comm, 'error': error, 'exception': exception})
                    port.ser.reset_input_buffer()
                else:
                    stats['success'] += 1
                if pause:
                    time.sleep(pause)
            print(json.dumps(stats), flush=True)
    except Exception as error:
        report['error'] = '{}: {}'.format(type(error).__name__, error)
        print(report['error'], flush=True)
    finally:
        signal.alarm(0)
        if port.is_open:
            port.closePort()
        report['read_only_packets'] = port.packets
        args.output.write_text(json.dumps(report, indent=2) + '\n')
    return 1 if 'error' in report else 0


if __name__ == '__main__':
    raise SystemExit(main())