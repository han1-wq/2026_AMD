#!/usr/bin/env python3
"""Read-only SO101 diagnosis. Never enables torque or writes registers."""
import argparse
import datetime
import json
import signal
import time
from pathlib import Path

import scservo_sdk as sdk
import serial

NAMES = ['shoulder_pan', 'shoulder_lift', 'elbow_flex',
         'wrist_flex', 'wrist_roll', 'gripper']
REGISTERS = {
    'Firmware': (0, 2), 'Model_Number': (3, 2), 'ID': (5, 1),
    'Response_Status_Level': (8, 1), 'Max_Temperature_Limit': (13, 1),
    'Max_Voltage_Limit': (14, 1), 'Min_Voltage_Limit': (15, 1),
    'Max_Torque_Limit': (16, 2), 'Unloading_Condition': (19, 1),
    'Homing_Offset': (31, 2), 'Operating_Mode': (33, 1),
    'Torque_Enable': (40, 1), 'Goal_Velocity': (46, 2),
    'Torque_Limit': (48, 2), 'Lock': (55, 1),
    'Present_Position': (56, 2), 'Present_Velocity': (58, 2),
    'Present_Voltage': (62, 1), 'Present_Temperature': (63, 1),
    'Status': (65, 1), 'Moving': (66, 1), 'Present_Current': (69, 2),
}
ALLOWED_READS = frozenset(REGISTERS.values())
CRITICAL = ['Torque_Enable', 'Goal_Velocity', 'Present_Velocity',
            'Status', 'Moving', 'Present_Position']


def validate_read_packet(packet):
    data = list(packet)
    if (len(data) != 8 or any(type(x) is not int or not 0 <= x <= 255 for x in data)
            or data[:2] != [255, 255] or data[2] not in range(1, 7)
            or data[3] != 4 or data[4] != 2
            or tuple(data[5:7]) not in ALLOWED_READS
            or data[7] != (~sum(data[2:7]) & 255)):
        raise PermissionError('Read-only transport rejected a non-allowlisted packet')
    return data


class ReadOnlyPort(sdk.PortHandler):
    def __init__(self, port_name):
        super().__init__(port_name)
        self.tx_packets = []

    def setupPort(self, cflag_baud):
        if self.is_open:
            raise RuntimeError('Refusing to reopen a diagnostic port')
        self.ser = serial.Serial(port=self.port_name, baudrate=self.baudrate,
                                 bytesize=serial.EIGHTBITS, timeout=0,
                                 write_timeout=0.25, exclusive=True)
        self.is_open = True
        self.ser.reset_input_buffer()
        self.tx_time_per_byte = 10000.0 / self.baudrate
        return True

    def writePort(self, packet):
        packet = validate_read_packet(packet)
        self.tx_packets.append(packet)
        return super().writePort(packet)


def signed_magnitude(value, bit):
    return -(value & ((1 << bit) - 1)) if value & (1 << bit) else value


def read_value(handler, port, motor_id, register):
    address, length = REGISTERS[register]
    raw, comm, error = handler.readTxRx(port, motor_id, address, length)
    if comm != sdk.COMM_SUCCESS or error or len(raw) != length:
        raise RuntimeError('{} id={}: comm={} error={} data={}'.format(
            register, motor_id, comm, error, raw))
    value = sum(byte << (8 * index) for index, byte in enumerate(raw))
    if register in ['Goal_Velocity', 'Present_Velocity']:
        value = signed_magnitude(value, 15)
    elif register == 'Homing_Offset':
        value = signed_magnitude(value, 11)
    return value


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--port', required=True)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--read-only', action='store_true', required=True)
    args = parser.parse_args()
    # Reserve the audit file before opening any hardware; never overwrite evidence.
    with args.output.open('x') as output:
        report = {'utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
                  'port': args.port, 'read_only': True, 'motion_authorized': False,
                  'status': 'STARTED', 'snapshot': {}, 'samples': [], 'issues': []}
        output.write(json.dumps(report) + '\n'); output.flush()
        port = ReadOnlyPort(args.port)
        handler = sdk.PacketHandler(0)
        previous_handler = signal.getsignal(signal.SIGALRM)

        def timeout(signum, frame):
            raise TimeoutError('Read-only diagnostic exceeded 20 seconds')

        signal.signal(signal.SIGALRM, timeout)
        signal.setitimer(signal.ITIMER_REAL, 20)
        try:
            if not port.setBaudRate(1000000):
                raise RuntimeError('Cannot open diagnostic port')
            for motor_id, name in enumerate(NAMES, 1):
                values = {}
                report['snapshot'][name] = values
                for register in REGISTERS:
                    values[register] = read_value(handler, port, motor_id, register)
                    if register == 'Model_Number' and values[register] != 777:
                        raise RuntimeError('Unexpected model on id={}'.format(motor_id))
                    if register == 'ID' and values[register] != motor_id:
                        raise RuntimeError('Motor ID register mismatch')
            for index in range(3):
                if index:
                    time.sleep(0.2)
                sample = {}
                report['samples'].append(sample)
                for motor_id, name in enumerate(NAMES, 1):
                    values = {}
                    sample[name] = values
                    for register in CRITICAL:
                        values[register] = read_value(handler, port, motor_id, register)
                        if register != 'Present_Position' and values[register] != 0:
                            report['issues'].append('sample {} {}/{}={}'.format(
                                index, name, register, values[register]))
            for name, values in report['snapshot'].items():
                if values['Present_Temperature'] >= min(50, values['Max_Temperature_Limit'] - 10):
                    report['issues'].append(name + ': temperature outside existing guard')
                if not values['Min_Voltage_Limit'] < values['Present_Voltage'] < values['Max_Voltage_Limit']:
                    report['issues'].append(name + ': voltage outside configured limits')
                if len({sample[name]['Present_Position'] for sample in report['samples']}) != 1:
                    report['issues'].append(name + ': position changed between samples')
            report['status'] = 'READBACK_HAS_ISSUES' if report['issues'] else 'READBACK_QUIESCENT_NOT_STOP_PROOF'
        except BaseException as error:
            report['status'] = 'FAILED'
            report['error'] = {'type': type(error).__name__, 'message': str(error)}
        finally:
            signal.setitimer(signal.ITIMER_REAL, 0)
            try:
                if port.is_open:
                    port.closePort()
            except Exception as error:
                report['status'] = 'FAILED'
                report['close_error'] = str(error)
            signal.signal(signal.SIGALRM, previous_handler)
            report['tx_packets'] = port.tx_packets
            report['all_transmitted_packets_read_only'] = all(
                validate_read_packet(packet) == packet for packet in port.tx_packets)
            output.seek(0); output.truncate()
            output.write(json.dumps(report, indent=2) + '\n'); output.flush()
        print(json.dumps({k: v for k, v in report.items() if k != 'tx_packets'}, indent=2), flush=True)
        return 0 if report['status'] == 'READBACK_QUIESCENT_NOT_STOP_PROOF' else 2


if __name__ == '__main__':
    raise SystemExit(main())