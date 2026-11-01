#!/usr/bin/env python3
"""Bounded zero-only writes and independent readback; never enable motion."""
import argparse
import datetime
import json
import signal
import time

import read_only_diagnostic as diag


def validate_stop_packet(packet):
    data = list(packet)
    try:
        return diag.validate_read_packet(data)
    except PermissionError:
        pass
    if (any(type(x) is not int or not 0 <= x <= 255 for x in data)
            or len(data) not in (8, 9) or data[:2] != [255, 255]
            or data[2] not in range(1, 7) or data[3] != len(data) - 4
            or data[4] != 3 or data[5:-1] not in ([40, 0], [46, 0, 0])
            or data[-1] != (~sum(data[2:-1]) & 255)):
        raise PermissionError('Transport accepts only allowlisted reads or zero stop writes')
    return data


class StopOnlyPort(diag.ReadOnlyPort):
    def writePort(self, packet):
        data = validate_stop_packet(packet)
        self.tx_packets.append(data)
        return diag.sdk.PortHandler.writePort(self, data)


def snapshot(handler, port):
    return {name: {reg: diag.read_value(handler, port, motor_id, reg)
                   for reg in ['Model_Number', 'ID', 'Operating_Mode'] + diag.CRITICAL}
            for motor_id, name in enumerate(diag.NAMES, 1)}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--port', required=True)
    parser.add_argument('--output', type=diag.Path, required=True)
    args = parser.parse_args()
    report = {'utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
              'status': 'STARTED', 'writes': [], 'samples': [], 'issues': []}
    port = StopOnlyPort(args.port)
    handler = diag.sdk.PacketHandler(0)

    def timeout(signum, frame):
        raise TimeoutError('Stop verification exceeded 20 seconds')

    with args.output.open('x') as output:
        output.write(json.dumps(report)); output.flush()
        signal.signal(signal.SIGALRM, timeout)
        signal.setitimer(signal.ITIMER_REAL, 20)
        try:
            if not port.setBaudRate(1000000):
                raise RuntimeError('Cannot open serial port')
            report['before'] = snapshot(handler, port)
            for motor_id, name in enumerate(diag.NAMES, 1):
                if report['before'][name]['Model_Number'] != 777 or report['before'][name]['ID'] != motor_id:
                    raise RuntimeError('Unexpected motor identity: ' + name)
            for reg in ['Torque_Enable', 'Goal_Velocity']:
                address, length = diag.REGISTERS[reg]
                for motor_id, name in enumerate(diag.NAMES, 1):
                    record = {'motor': name, 'id': motor_id, 'register': reg,
                              'address': address, 'bytes': [0] * length}
                    report['writes'].append(record)
                    comm, error = handler.writeTxRx(port, motor_id, address, length, [0] * length)
                    record.update(comm=comm, error=error)
                    try:
                        record['readback'] = diag.read_value(handler, port, motor_id, reg)
                    except Exception as exc:
                        record['read_error'] = str(exc)
                    if comm != diag.sdk.COMM_SUCCESS or error or record.get('readback') != 0:
                        report['issues'].append(record.copy())
            for index in range(3):
                time.sleep(0.2)
                sample = snapshot(handler, port)
                report['samples'].append(sample)
                for name, values in sample.items():
                    for reg in diag.CRITICAL:
                        if reg != 'Present_Position' and values[reg] != 0:
                            report['issues'].append('{} sample {} {}={}'.format(name, index, reg, values[reg]))
            for name in diag.NAMES:
                if len({sample[name]['Present_Position'] for sample in report['samples']}) != 1:
                    report['issues'].append(name + ': position changed')
            report['status'] = 'FAILED' if report['issues'] else 'ZERO_WRITES_AND_STATIC_READBACK_VERIFIED'
        except BaseException as exc:
            report['status'] = 'FAILED'
            report['error'] = {'type': type(exc).__name__, 'message': str(exc)}
        finally:
            signal.setitimer(signal.ITIMER_REAL, 0)
            try:
                if port.is_open:
                    port.closePort()
            except Exception as exc:
                report['status'] = 'FAILED'
                report['close_error'] = str(exc)
            report['tx_packets'] = port.tx_packets
            report['limitation'] = 'Zero writes to already disabled motors do not establish stopping under load.'
            output.seek(0); output.truncate()
            output.write(json.dumps(report, indent=2) + '\n'); output.flush()
        print(json.dumps({k: v for k, v in report.items() if k != 'tx_packets'}, indent=2), flush=True)
    return 0 if report['status'] == 'ZERO_WRITES_AND_STATIC_READBACK_VERIFIED' else 2


if __name__ == '__main__':
    raise SystemExit(main())