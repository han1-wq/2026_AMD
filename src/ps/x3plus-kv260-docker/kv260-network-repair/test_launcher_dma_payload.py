"""Shortcut payloads must fit the FPGA UART frame without losing provenance."""
import json
import unittest

from launcher_dma_payload import MAX_UART_BYTES, task_and_log, usb_and_runtime


class PayloadTests(unittest.TestCase):
    def test_task_contains_state_and_recent_log(self):
        log = ('旧日志' * 400 + '最新记录\n').encode('utf-8')
        data = json.loads(task_and_log('vision', {'status': 'running', 'pid': 123}, True,
                                       log[-700:], len(log)))
        self.assertEqual(data['action'], 'vision')
        self.assertEqual(data['state']['pid'], 123)
        self.assertTrue(data['active'])
        self.assertTrue(data['log_truncated'])
        self.assertTrue(data['log'].endswith('最新记录\n'))
        self.assertLessEqual(len(task_and_log('vision', {}, False, log[-700:], len(log))),
                             MAX_UART_BYTES)

    def test_missing_log_and_unicode_state(self):
        data = json.loads(task_and_log('base', {'message': '尚未运行'}, False, b'', 0))
        self.assertEqual(data['state']['message'], '尚未运行')
        self.assertFalse(data['log_truncated'])

    def test_usb_runtime_contains_device_and_health(self):
        snapshot = {'serial': {'ROBOT': {'ok': True, 'message': '已连接'}},
                    'devices': [{'path': '/dev/ttyUSB1', 'vid': '0403', 'pid': '6010',
                                 'interface': '01', 'serial': 'SECRET'}],
                    'containers': {'robot': 'running'}, 'nodes': ['/camera'],
                    'camera': True, 'cpu': 12, 'memory': {'available': 100},
                    'sampled_at': '12:00:00'}
        data = json.loads(usb_and_runtime(snapshot))
        self.assertEqual(data['devices'][0]['path'], '/dev/ttyUSB1')
        self.assertNotIn('serial', data['devices'][0])
        self.assertEqual(data['ros_nodes'], 1)
        self.assertTrue(data['camera'])

    def test_stale_or_oversized_runtime_compacted(self):
        with self.assertRaisesRegex(ValueError, '快照'):
            usb_and_runtime({})
        data = json.loads(usb_and_runtime({'serial': {'ROBOT': {'ok': False, 'message': '离线'}},
                                           'containers': {'x': 'z' * 1100}}))
        self.assertTrue(data['details_truncated'])
        self.assertFalse(data['serial']['ROBOT']['ok'])
        self.assertEqual(data['containers'], {})


if __name__ == '__main__':
    unittest.main()