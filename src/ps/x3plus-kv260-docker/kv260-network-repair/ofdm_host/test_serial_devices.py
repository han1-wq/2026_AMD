"""Device identity and re-enumeration checks without USB hardware."""

import tempfile
import unittest
from pathlib import Path
from types import SimpleNamespace
from unittest.mock import patch

from serial_devices import (AmbiguousDevice, DeviceNotFound, SerialDevice,
                            interface_number, select_device)
from serial_connection import SerialConnection


def device(path='/dev/ttyUSB3', serial='NEW123', location='1-1.3:1.1', interface=1):
    return SerialDevice(path, 0x0403, 0x6010, serial, location, interface, 'Updated product')


class DeviceTests(unittest.TestCase):
    def test_select_interface_one_with_changed_name_and_serial(self):
        target = device('/dev/ttyUSB9')
        others = [device('/dev/ttyUSB8', interface=0),
                  SerialDevice('/dev/ttyUSB0', 0x10c4, 0xea60, '', '', 1, 'CP2102')]
        self.assertEqual(select_device(others + [target]), target)

    def test_unknown_interface_is_not_selected(self):
        with self.assertRaises(DeviceNotFound):
            select_device([device(interface=None), device(interface=0)])

    def test_ambiguity_requires_selection(self):
        first, second = device(), device('/dev/ttyUSB5', 'SECOND', '1-2:1.1')
        with self.assertRaises(AmbiguousDevice):
            select_device([first, second])
        self.assertEqual(select_device([first, second], 'SECOND'), second)
        with self.assertRaises(DeviceNotFound):
            select_device([first, second], 'MISSING')

    def test_duplicate_serial_uses_location(self):
        first, second = device(), device('/dev/ttyUSB5', location='1-2:1.1')
        with self.assertRaises(AmbiguousDevice):
            select_device([first, second], 'NEW123')
        self.assertEqual(select_device([first, second], 'NEW123', '1-2:1.1'), second)

    def test_descriptor_preferred_over_description_or_location(self):
        with tempfile.TemporaryDirectory() as tmp:
            Path(tmp, 'bInterfaceNumber').write_text('01\n')
            port = SimpleNamespace(device='/dev/nonexistent-ofdm-test',
                                   usb_interface_path=tmp, location='1-2:1.0', interface='same name')
            self.assertEqual(interface_number(port), 1)

    def test_location_fallback_and_unknown(self):
        port = SimpleNamespace(device='/dev/nonexistent-ofdm-test', location='1-2:1.1')
        self.assertEqual(interface_number(port), 1)
        port.location = '1-2'
        self.assertIsNone(interface_number(port))

    @patch('serial_connection.serial.Serial')
    @patch('serial_connection.resolve_device')
    def test_reopen_resolves_changed_device_number(self, resolve, serial):
        resolve.return_value = device()
        conn = SerialConnection()
        conn.open(settle=0)
        self.assertEqual(conn.port.port, '/dev/ttyUSB3')
        resolve.return_value = device('/dev/ttyUSB7')
        with self.assertRaisesRegex(Exception, 'changed'):
            conn.validate()
        conn.open(settle=0)
        self.assertEqual(conn.port.port, '/dev/ttyUSB7')
        conn.close()

    @patch('serial_connection.serial.Serial')
    @patch('serial_connection.resolve_device')
    def test_open_race_closes_port(self, resolve, serial):
        resolve.side_effect = [device(), device('/dev/ttyUSB7')]
        conn = SerialConnection()
        with self.assertRaisesRegex(Exception, 'changed'):
            conn.open()
        self.assertIsNone(conn.port)
        serial.return_value.close.assert_called_once()


if __name__ == '__main__':
    unittest.main()