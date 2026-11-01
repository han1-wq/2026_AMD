import json
import tempfile
import unittest
from pathlib import Path
from unittest.mock import ANY, patch
import launcher_network as network


class NetworkTests(unittest.TestCase):
    def rows(self, ip='192.168.43.182'):
        return json.dumps([{'ifname': 'wlan0', 'addr_info': [{'scope': 'global', 'local': ip}]}])

    def test_auto_replaces_inherited_stale_ip_and_port(self):
        env = {'ROS_NETWORK_MODE': 'auto', 'ROS_MASTER_PORT': '11312',
               'ROS_HOSTNAME': '192.168.137.60', 'ROS_IP': '192.168.137.60'}
        with patch.object(network, 'command', side_effect=[self.rows(), '[{"prefsrc":"192.168.43.182"}]']):
            result = network.resolve(env)
        self.assertEqual(result['ROS_HOSTNAME'], '192.168.43.182')
        self.assertEqual(result['ROS_IP'], '192.168.43.182')
        self.assertEqual(result['ROS_MASTER_URI'], 'http://192.168.43.182:11312')

    def test_explicit_interface_without_default_route(self):
        with patch.object(network, 'command', return_value=self.rows()):
            result = network.resolve({'ROS_NETWORK_MODE': 'auto', 'ROS_NETWORK_INTERFACE': 'wlan0'})
        self.assertEqual(result['ROS_HOSTNAME'], '192.168.43.182')

    def test_no_route_is_rejected(self):
        with patch.object(network, 'command', side_effect=[self.rows(), '[]']):
            with self.assertRaises(ValueError):
                network.resolve({'ROS_NETWORK_MODE': 'auto'})

    def test_manual_stale_address_fails_before_docker(self):
        with patch.object(network, 'command', return_value=self.rows()) as call:
            with self.assertRaisesRegex(ValueError, '不在本机'):
                network.ensure('x3plus-master', {'ROS_HOSTNAME': '192.168.137.60'})
            self.assertEqual(call.call_count, 1)

    def test_network_change_with_active_robot_never_stops_containers(self):
        info = {'Config': {'Env': ['ROS_MASTER_URI=http://old:11311']}, 'State': {'Running': True}}
        with patch.object(network, 'validate_local'), patch.object(network, 'command', side_effect=[
                'x3plus-master\nx3plus-robot', json.dumps([info]), json.dumps([info]), 'PID COMMAND\n1 tail\n2 python']) as call:
            with self.assertRaisesRegex(ValueError, '先点击停止'):
                network.ensure('x3plus-master', {'ROS_MASTER_URI': 'http://new:11311'})
            self.assertFalse(any('stop' in args[0] for args, _ in call.call_args_list))

    def test_matching_network_does_not_mutate(self):
        env = {'ROS_MASTER_URI': 'http://host:11311', 'ROS_HOSTNAME': 'host'}
        info = {'Config': {'Env': ['%s=%s' % item for item in env.items()]}}
        with patch.object(network, 'validate_local'), patch.object(network, 'command', side_effect=[
                'x3plus-master', json.dumps([info])]) as call:
            network.ensure('x3plus-master', env)
            self.assertEqual(call.call_count, 2)

    def test_ros_ip_mismatch_triggers_migration(self):
        info = {'Config': {'Env': ['ROS_MASTER_URI=http://host:11311', 'ROS_HOSTNAME=host', 'ROS_IP=old']}}
        self.assertTrue(network.mismatch(info, {'ROS_MASTER_URI': 'http://host:11311',
                                                'ROS_HOSTNAME': 'host', 'ROS_IP': 'new'}))

    def test_create_config_drops_runtime_only_host_fields(self):
        info = {'Config': {'Env': ['ROS_MASTER_URI=http://old:11311']},
                'HostConfig': {'NetworkMode': 'host', 'IpcMode': 'host', 'Binds': [],
                               'RestartPolicy': {'Name': 'unless-stopped', 'MaximumRetryCount': 0}},
                'State': {'Running': False}}
        with patch.object(network, 'validate_local'), patch.object(network, 'command', side_effect=[
                'x3plus-master', json.dumps([info]), 'x3plus-master:network-test', 'x3plus-master-backup-test', '', '']) as call, patch.object(network, 'create_container') as create:
            network.ensure('x3plus-master', {'ROS_MASTER_URI': 'http://new:11311', 'ROS_HOSTNAME': 'new'})
            self.assertEqual(create.call_args.args[1]['HostConfig']['NetworkMode'], 'host')
            self.assertEqual(create.call_args.args[1]['HostConfig']['IpcMode'], 'host')

    def test_restart_policy_keeps_failure_retry_limit(self):
        self.assertEqual(network.restart_policy_argument(
            {'Name': 'on-failure', 'MaximumRetryCount': 4}), 'on-failure:4')
        self.assertEqual(network.restart_policy_argument(
            {'Name': 'unless-stopped', 'MaximumRetryCount': 0}), 'unless-stopped')

    def test_create_failure_restores_name_policy_and_running_state(self):
        info = {'Config': {'Env': ['ROS_MASTER_URI=http://old:11311']},
                'HostConfig': {'RestartPolicy': {'Name': 'on-failure', 'MaximumRetryCount': 3}},
                'State': {'Running': True}}
        commands = ['x3plus-master', json.dumps([info]), '', 'snapshot', '', '', '', '']
        with tempfile.TemporaryDirectory() as folder, \
                patch.object(network, 'validate_local'), \
                patch.object(network, 'command', side_effect=commands) as call, \
                patch.object(network, 'create_container', side_effect=RuntimeError('create failed')), \
                patch.object(network, 'BACKUP_ROOT', Path(folder)):
            with self.assertRaisesRegex(RuntimeError, 'create failed'):
                network.ensure('x3plus-master', {'ROS_MASTER_URI': 'http://new:11311'})
        actual = [args[0] for args, _ in call.call_args_list]
        self.assertEqual(actual[-3:], [
            ['docker', 'rename', ANY, 'x3plus-master'],
            ['docker', 'update', '--restart=on-failure:3', 'x3plus-master'],
            ['docker', 'start', 'x3plus-master']])

    def test_rename_failure_restores_previously_running_container(self):
        info = {'Config': {'Env': ['ROS_MASTER_URI=http://old:11311']},
                'HostConfig': {'RestartPolicy': {'Name': 'unless-stopped', 'MaximumRetryCount': 0}},
                'State': {'Running': True}}
        commands = ['x3plus-master', json.dumps([info]), '', 'snapshot', RuntimeError('rename failed'), '', '']
        with tempfile.TemporaryDirectory() as folder, \
                patch.object(network, 'validate_local'), \
                patch.object(network, 'command', side_effect=commands) as call, \
                patch.object(network, 'BACKUP_ROOT', Path(folder)):
            with self.assertRaisesRegex(RuntimeError, 'rename failed'):
                network.ensure('x3plus-master', {'ROS_MASTER_URI': 'http://new:11311'})
        actual = [args[0] for args, _ in call.call_args_list]
        self.assertEqual(actual[-2:], [
            ['docker', 'update', '--restart=unless-stopped', 'x3plus-master'],
            ['docker', 'start', 'x3plus-master']])

    def test_stopped_container_is_not_started_after_snapshot_failure(self):
        info = {'Config': {'Env': ['ROS_MASTER_URI=http://old:11311']},
                'HostConfig': {'RestartPolicy': {'Name': 'no', 'MaximumRetryCount': 0}},
                'State': {'Running': False}}
        with tempfile.TemporaryDirectory() as folder, \
                patch.object(network, 'validate_local'), \
                patch.object(network, 'command', side_effect=['x3plus-master', json.dumps([info]), RuntimeError('commit failed'), '']) as call, \
                patch.object(network, 'BACKUP_ROOT', Path(folder)):
            with self.assertRaisesRegex(RuntimeError, 'commit failed'):
                network.ensure('x3plus-master', {'ROS_MASTER_URI': 'http://new:11311'})
        self.assertFalse(any(args[0][:2] == ['docker', 'start'] for args, _ in call.call_args_list))

    def test_stop_failure_restores_previously_running_container(self):
        info = {'Config': {'Env': ['ROS_MASTER_URI=http://old:11311']},
                'HostConfig': {'RestartPolicy': {'Name': 'unless-stopped', 'MaximumRetryCount': 0}},
                'State': {'Running': True}}
        with tempfile.TemporaryDirectory() as folder, \
                patch.object(network, 'validate_local'), \
                patch.object(network, 'command', side_effect=[
                    'x3plus-master', json.dumps([info]), RuntimeError('stop timed out'), '', '']) as call, \
                patch.object(network, 'BACKUP_ROOT', Path(folder)):
            with self.assertRaisesRegex(RuntimeError, 'stop timed out'):
                network.ensure('x3plus-master', {'ROS_MASTER_URI': 'http://new:11311'})
        actual = [args[0] for args, _ in call.call_args_list]
        self.assertEqual(actual[-2:], [
            ['docker', 'update', '--restart=unless-stopped', 'x3plus-master'],
            ['docker', 'start', 'x3plus-master']])

    def test_backup_policy_update_failure_restores_every_mutation(self):
        info = {'Config': {'Env': ['ROS_MASTER_URI=http://old:11311']},
                'HostConfig': {'RestartPolicy': {'Name': 'unless-stopped', 'MaximumRetryCount': 0}},
                'State': {'Running': True}}
        commands = ['x3plus-master', json.dumps([info]), '', 'snapshot', '',
                    RuntimeError('policy update failed'), '', '', '']
        with tempfile.TemporaryDirectory() as folder, \
                patch.object(network, 'validate_local'), \
                patch.object(network, 'command', side_effect=commands) as call, \
                patch.object(network, 'BACKUP_ROOT', Path(folder)):
            with self.assertRaisesRegex(RuntimeError, 'policy update failed'):
                network.ensure('x3plus-master', {'ROS_MASTER_URI': 'http://new:11311'})
        actual = [args[0] for args, _ in call.call_args_list]
        self.assertEqual(actual[-3:], [
            ['docker', 'rename', ANY, 'x3plus-master'],
            ['docker', 'update', '--restart=unless-stopped', 'x3plus-master'],
            ['docker', 'start', 'x3plus-master']])


if __name__ == '__main__':
    unittest.main()