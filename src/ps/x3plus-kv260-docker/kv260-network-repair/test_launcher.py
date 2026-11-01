"""Regression tests; fake sysfs, fake commands, no robot hardware access."""
import dataclasses
import fcntl
import json
import logging
import os
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch

import launcher_core as core
import launcher_tasks as tasks


class DeviceTests(unittest.TestCase):
    def setUp(self):
        self.robot = core.SerialDevice('/dev/ttyUSB3', '1a86', '7523', '', '00', '1-1.4')
        self.lidar = core.SerialDevice('/dev/ttyUSB1', '10c4', 'ea60', '0001', '00', '1-1.1')

    def test_unique_vid_pid(self):
        self.assertEqual(core.select_device([self.robot, self.lidar], '1A86', '7523', interface='00'), self.robot)

    def test_renumbering_does_not_change_identity(self):
        moved = dataclasses.replace(self.robot, path='/dev/ttyUSB9')
        self.assertEqual(core.select_device([moved], '1a86', '7523', interface='00').path, '/dev/ttyUSB9')

    def test_missing_is_rejected(self):
        with self.assertRaises(ValueError):
            core.select_device([], '1a86', '7523', interface='00')

    def test_duplicate_is_rejected(self):
        other = dataclasses.replace(self.robot, path='/dev/ttyUSB4', location='1-1.5')
        with self.assertRaisesRegex(ValueError, '拒绝猜测'):
            core.select_device([self.robot, other], '1a86', '7523', interface='00')

    def test_location_disambiguates(self):
        other = dataclasses.replace(self.robot, path='/dev/ttyUSB4', location='1-1.5')
        self.assertEqual(core.select_device([self.robot, other], '1a86', '7523',
                         interface='00', location='1-1.4'), self.robot)

    def test_serial_disambiguates(self):
        other = dataclasses.replace(self.lidar, serial='0002')
        self.assertEqual(core.select_device([self.lidar, other], '10c4', 'ea60',
                         interface='00', serial='0001'), self.lidar)

    def test_unknown_interface_rejected(self):
        with self.assertRaises(ValueError):
            core.select_device([dataclasses.replace(self.robot, interface='')],
                               '1a86', '7523', interface='00')

    def test_interface_cannot_be_disabled(self):
        with self.assertRaises(ValueError):
            core.select_device([self.robot], '1a86', '7523')

    def test_ftdi_wrong_interface_not_selected(self):
        d = core.SerialDevice('/dev/ttyUSB0','0403','6010','ABC','00','1-1.3')
        with self.assertRaises(ValueError):
            core.select_device([d], '0403', '6010', interface='01')

    def test_invalid_vid_rejected(self):
        with self.assertRaises(ValueError):
            core.select_device([self.robot], 'xyz', '7523', interface='00')

    def test_volatile_alias_rejected(self):
        with self.assertRaises(ValueError):
            core.validate_alias('/dev/ttyUSB3', self.robot)

    def test_alias_to_wrong_character_device_rejected(self):
        with self.assertRaisesRegex(ValueError, '错误设备'):
            core.validate_alias('/dev/null', self.robot)

    def test_missing_alias_rejected(self):
        with self.assertRaisesRegex(ValueError, '不可用'):
            core.validate_alias('/dev/kv260-test-does-not-exist', self.robot)

    def test_same_device_roles_rejected(self):
        env = {'LIDAR_USB_VID':'1a86', 'LIDAR_USB_PID':'7523'}
        with patch.object(core, 'validate_alias'):
            status = core.serial_status(env, [self.robot])
        self.assertFalse(status['ROBOT']['ok'])
        self.assertFalse(status['LIDAR']['ok'])

    def test_sysfs_never_inherits_hub_serial(self):
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            hub = root/'usb1'
            device = hub/'1-1.4'
            interface = device/'1-1.4:1.0'
            tty = interface/'ttyUSB3'
            tty.mkdir(parents=True)
            (hub/'serial').write_text('HUB-SERIAL')
            (hub/'idVendor').write_text('1d6b')
            (hub/'idProduct').write_text('0002')
            (device/'idVendor').write_text('1a86')
            (device/'idProduct').write_text('7523')
            (interface/'bInterfaceNumber').write_text('00')
            class_dir = root/'class'
            class_dir.mkdir()
            (class_dir/'ttyUSB3').symlink_to(tty)
            found = core.discover_serial(class_dir)
            self.assertEqual(len(found), 1)
            self.assertEqual(found[0].serial, '')
            self.assertEqual(found[0].interface, '00')
            self.assertEqual(found[0].location, '1-1.4')

    def test_container_stale_device_rejected(self):
        with patch.object(core, 'command', return_value='bc:1\nbc:3\n'):
            with self.assertRaisesRegex(ValueError, '过期'):
                core.check_container_devices({'ROBOT_SERIAL':'/dev/null','LIDAR_SERIAL':'/dev/zero'})

    def test_container_matching_devices(self):
        paths = ['/dev/null', '/dev/zero']
        output = '\n'.join('%x:%x' % (os.major(Path(p).stat().st_rdev),
            os.minor(Path(p).stat().st_rdev)) for p in paths) + '\n'
        with patch.object(core, 'command', return_value=output):
            self.assertIn('一致', core.check_container_devices(dict(zip(
                ['ROBOT_SERIAL','LIDAR_SERIAL'], paths))))


class ConfigTests(unittest.TestCase):
    def test_literal_values_no_execution(self):
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder)/'env'
            path.write_text("export KEY='$(touch /tmp/never-execute)'\nexport EMPTY=\n")
            self.assertEqual(core.read_config(path), {'KEY':'$(touch /tmp/never-execute)', 'EMPTY':''})

    def test_invalid_assignment_rejected(self):
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder)/'env'
            path.write_text('export X=one; touch /tmp/no\n')
            with self.assertRaises(ValueError):
                core.read_config(path)

    def test_environment_override(self):
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder)/'env'
            path.write_text('export ROBOT_USB_SERIAL=old\n')
            with patch.dict(os.environ, {'ROBOT_USB_SERIAL':'new'}):
                self.assertEqual(core.read_env(path)['ROBOT_USB_SERIAL'], 'new')


class TaskTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.folder = Path(self.temp.name)
        self.mock = patch.object(tasks, 'STATE', self.folder)
        self.mock.start()

    def tearDown(self):
        self.mock.stop()
        self.temp.cleanup()

    def test_map_injection_rejected(self):
        for name in ('../map', 'map;touch x', 'bad name', '-f', 'a'*65, ''):
            with self.subTest(name=name), self.assertRaises(ValueError):
                tasks.action_commands('navigation', name)

    def test_map_kept_separate_argument(self):
        self.assertEqual(tasks.action_commands('navigation', 'map_1')[0][-1], 'map_1')

    def test_all_action_scripts_exist(self):
        for action in tasks.ACTIONS:
            for cmd in tasks.action_commands(action, 'map1'):
                self.assertTrue(Path(cmd[0]).is_file(), cmd)

    def test_rviz_modes_share_lock(self):
        with (self.folder/'rviz.lock').open('w') as stream:
            fcntl.flock(stream, fcntl.LOCK_EX)
            self.assertTrue(tasks.is_active('rviz-map'))
            self.assertTrue(tasks.is_active('rviz-nav'))

    def test_long_start_and_stop_use_control_gate(self):
        with (self.folder/'control.lock').open('w') as stream:
            fcntl.flock(stream, fcntl.LOCK_EX)
            with patch.object(tasks.subprocess, 'Popen') as popen:
                for action in ('rviz-map', 'vision', 'keyboard', 'stop-all', 'stop-vision'):
                    self.assertEqual(tasks.run(action), 75)
                popen.assert_not_called()

    def test_running_service_releases_start_gate(self):
        cmd = ['/bin/sh', '-c', 'echo ready; sleep 0.1']
        with patch.object(tasks, 'service_started', return_value=True):
            from unittest.mock import Mock
            release = Mock()
            self.assertEqual(tasks.supervise(cmd, 'rviz-map', dict(os.environ),
                             logging.getLogger('test'), release), 0)
            release.assert_called_once_with()

    def test_unready_service_does_not_release_start_gate(self):
        cmd = ['/bin/sh', '-c', 'echo failed; exit 1']
        with patch.object(tasks, 'service_started', return_value=False):
            from unittest.mock import Mock
            release = Mock()
            self.assertEqual(tasks.supervise(cmd, 'vision', dict(os.environ),
                             logging.getLogger('test'), release), 1)
            release.assert_not_called()

    def test_control_lock_prevents_start(self):
        with (self.folder/'control.lock').open('w') as stream:
            fcntl.flock(stream, fcntl.LOCK_EX)
            with patch.object(tasks.subprocess, 'Popen') as popen:
                self.assertEqual(tasks.run('base'), 75)
                popen.assert_not_called()

    def test_base_timeout_covers_network_snapshot_and_other_actions_stay_bounded(self):
        self.assertEqual(tasks.finite_timeout('base'), 420)
        self.assertEqual(tasks.finite_timeout('save'), 180)

    def test_missing_serial_never_runs_command(self):
        with patch.object(tasks, 'read_env', return_value=dict(os.environ)), patch.object(tasks, 'require_serial', side_effect=ValueError('missing')):
            with patch.object(tasks.subprocess, 'Popen') as popen:
                self.assertEqual(tasks.run('hardware'), 1)
                popen.assert_not_called()
        self.assertEqual(json.loads((self.folder/'hardware.json').read_text())['returncode'], 1)

    def test_absent_camera_never_starts_dpu(self):
        with patch.object(tasks, 'read_env', return_value={'ASTRA_COLOR_DEVICE':str(self.folder/'missing')}):
            with patch.object(tasks.subprocess, 'Popen') as popen:
                self.assertEqual(tasks.run('vision'), 1)
                popen.assert_not_called()

    def test_failure_record_and_log(self):
        cmd = ['/bin/sh', '-c', 'echo simulated-failure; exit 7']
        with patch.object(tasks, 'action_commands', return_value=[cmd]):
            self.assertEqual(tasks.run('save', 'map1'), 7)
        self.assertIn('simulated-failure', (self.folder/'save.log').read_text())
        self.assertEqual(json.loads((self.folder/'save.json').read_text())['returncode'], 7)

    def test_log_memory_and_disk_bound(self):
        cmd = ['/usr/bin/python3', '-c', 'import sys; sys.stdout.write("x" * 1200000)']
        with patch.object(tasks, 'action_commands', return_value=[cmd]):
            self.assertEqual(tasks.run('save', 'map1'), 0)
        files = list(self.folder.glob('save.log*'))
        self.assertLessEqual(len(files), 2)
        self.assertLessEqual(sum(p.stat().st_size for p in files), 524288)

    def test_save_rejects_existing_and_dangling_files(self):
        env = dict(os.environ, MAP_DIR=str(self.folder))
        target = self.folder/'existing.yaml'
        for dangling in (False, True):
            if dangling:
                target.symlink_to(self.folder/'missing')
            else:
                target.write_text('keep me')
            result = subprocess.run(['bash', str(core.BASE/'save-map.sh'), 'existing'],
                                    env=env, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                                    text=True, timeout=5)
            self.assertEqual(result.returncode, 1)
            self.assertIn('避免覆盖', result.stderr)
            if not dangling:
                self.assertEqual(target.read_text(), 'keep me')
            target.unlink()

    def test_direct_save_respects_map_lock(self):
        with (self.folder/'.kv260-save.lock').open('w') as stream:
            fcntl.flock(stream, fcntl.LOCK_EX)
            result = subprocess.run(['bash', str(core.BASE/'save-map.sh'), 'newmap'],
                env=dict(os.environ, MAP_DIR=str(self.folder)), stdout=subprocess.PIPE,
                stderr=subprocess.PIPE, timeout=5)
            self.assertEqual(result.returncode, 75)


if __name__ == '__main__':
    unittest.main()