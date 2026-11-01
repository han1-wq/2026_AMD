"""Host tests: no robot commands, Docker mutations or real configuration writes."""
import importlib.util
import json
import os
from pathlib import Path
import tempfile
import time
import unittest
from unittest.mock import patch

import console_backend as backend


class BackendTests(unittest.TestCase):
    def setUp(self):
        self.data = {"pc_ip": "192.168.137.149", "kv260_ip": "192.168.137.60", "port": "11312"}

    def test_navigation_messages_handle_ready_recovery_legacy_and_offline(self):
        result = self.good_probe()
        result['received']['localization'] = {'count': 1, 'fresh': True}
        result['received']['navigation'] = {'fresh': True, 'status': {'ready': True}}
        self.assertIn('无需重复', backend.navigation_message(result))
        result['received']['navigation']['status'] = {'ready': False, 'reason': 'recovering_localization'}
        self.assertIn('旧目标不会续跑', backend.navigation_message(result))
        result['received']['navigation']['status'] = {
            'ready': False, 'reason': 'high_pose_uncertainty_initial_pose_required'}
        self.assertIn('定位协方差超限', backend.navigation_message(result))
        result['received']['navigation']['fresh'] = False
        self.assertIn('未收到新鲜门控状态', backend.navigation_message(result))

    def test_reject_invalid_configuration(self):
        for key, value in (("pc_ip", "0.0.0.0"), ("pc_ip", "999.1.1.1"),
                           ("kv260_ip", "224.0.0.1"), ("pc_ip", 123), ("port", "65536"),
                           ("port", "0"), ("port", "abc")):
            with self.subTest(key=key, value=value), self.assertRaises(ValueError):
                backend.validate(dict(self.data, **{key: value}))
        for value in ([], None, "hello", 5):
            with self.assertRaises(ValueError):
                backend.validate(value)

    def test_config_roundtrip_and_corrupt_fallback(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "settings" / "config.json"
            with patch.object(backend, "CONFIG", path), patch.object(backend, "local_addresses", return_value=[('eth0', self.data['pc_ip'])]), patch.object(backend, "detect_pc_ip", return_value=self.data["pc_ip"]):
                backend.save_config(self.data)
                loaded, warning = backend.load_config()
                self.assertEqual(loaded, self.data)
                self.assertFalse(warning)
                self.assertEqual(list(path.parent.iterdir()), [path])
                path.write_text('[]')
                loaded, warning = backend.load_config()
                self.assertEqual(loaded["port"], "11311")
                self.assertTrue(warning)

    def test_custom_port_and_ips_reach_launcher(self):
        with patch.object(backend, "local_addresses", return_value=[("eth0", self.data["pc_ip"])]), patch.object(backend, "run", return_value="started") as command:
            backend.launch("navigation", self.data)
            args, kwargs = command.call_args
            self.assertEqual(args[0][-2:], ["navigation", "--replace"])
            self.assertEqual(kwargs["env"]["ROS_MASTER_PORT"], "11312")
            self.assertEqual(kwargs["env"]["PC_ROS_IP"], self.data["pc_ip"])
            self.assertEqual(kwargs["env"]["KV260_IP"], self.data["kv260_ip"])

    def test_changed_host_address_is_recovered_without_overwriting_file(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / 'config.json'
            path.write_text(json.dumps(self.data))
            with patch.object(backend, 'CONFIG', path), patch.object(backend, 'local_addresses', return_value=[('eth0', '192.168.43.123')]), patch.object(backend, 'detect_pc_ip', return_value='192.168.43.123'):
                data, warning = backend.load_config()
            self.assertEqual(data['pc_ip'], '192.168.43.123')
            self.assertIn('地址已变化', warning)
            self.assertEqual(json.loads(path.read_text()), self.data)

    def test_nonlocal_ip_does_not_start_docker(self):
        with patch.object(backend, "local_addresses", return_value=[]), patch.object(backend, "run") as command:
            with self.assertRaises(ValueError):
                backend.launch("slam", self.data)
            command.assert_not_called()

    def test_docker_failure_not_reported_as_stopped(self):
        with patch.object(backend, "run", side_effect=RuntimeError("permission denied")):
            with self.assertRaisesRegex(RuntimeError, "permission denied"):
                backend.viewer_state()

    def test_legacy_viewer_is_slam(self):
        info = [{"Config": {"Labels": {}, "Env": ["ROS_MASTER_URI=http://robot:11311", "ROS_HOSTNAME=host"]},
                 "State": {"Running": True}}]
        with patch.object(backend, "run", side_effect=[backend.CONTAINER, json.dumps(info)]):
            self.assertEqual(backend.viewer_state()["mode"], "slam")

    def test_probe_rejects_stale_network(self):
        viewer = {"running": True, "master": "http://old:11311", "pc_ip": self.data["pc_ip"]}
        with patch.object(backend, "viewer_state", return_value=viewer), patch.object(backend, "run") as command:
            with self.assertRaises(ValueError):
                backend.probe(self.data)
            command.assert_not_called()

    def test_profiles_roundtrip_and_corruption_preserved(self):
        with tempfile.TemporaryDirectory() as directory, patch.object(backend, 'CONFIG', Path(directory) / 'config.json'):
            backend.save_profile(' 实验室 ', self.data)
            backend.save_profile('热点', dict(self.data, kv260_ip='192.168.43.182'))
            self.assertEqual(backend.profiles()['实验室'], self.data)
            self.assertEqual(len(backend.profiles()), 2)
            path = backend.CONFIG.with_name('profiles.json')
            path.write_text('[]')
            with self.assertRaises(ValueError):
                backend.save_profile('新网络', self.data)
            self.assertEqual(path.read_text(), '[]')

    def test_atomic_write_failure_preserves_saved_config(self):
        with tempfile.TemporaryDirectory() as directory, patch.object(backend, 'CONFIG', Path(directory) / 'config.json'):
            backend.save_config(self.data)
            with patch.object(Path, 'replace', side_effect=OSError('disk error')):
                with self.assertRaises(OSError):
                    backend.save_config(dict(self.data, port='11311'))
            self.assertEqual(json.loads(backend.CONFIG.read_text()), self.data)
            self.assertEqual(list(Path(directory).iterdir()), [backend.CONFIG])

    def test_network_change_reports_nic_route_and_viewer_mismatch(self):
        viewer = {'running': True, 'master': 'http://old:11311', 'pc_ip': '192.168.1.2'}
        with patch.object(backend, 'local_addresses', return_value=[('eth0', '192.168.43.123')]), patch.object(backend, 'detect_pc_ip', return_value='192.168.43.123'), patch.object(backend, 'route_state', return_value={}):
            state = backend.network_state(self.data, viewer)
        self.assertFalse(state['ok'])
        self.assertEqual(len(state['issues']), 3)

    def test_no_route_or_docker_failure_is_not_healthy(self):
        with patch.object(backend, 'local_addresses', return_value=[('eth0', self.data['pc_ip'])]), patch.object(backend, 'detect_pc_ip', return_value=''), patch.object(backend, 'route_state', return_value={}):
            state = backend.network_state(self.data, {'error': 'daemon unavailable'})
        self.assertFalse(state['ok'])
        self.assertEqual(len(state['issues']), 2)

    def good_probe(self):
        return {'received': {'map': {'count': 1}, 'scan': {'count': 60, 'frame': 'laser', 'fresh': True}},
                'tf': {'map -> base_footprint': {'ok': True}, 'map -> laser': {'ok': True}}}

    def test_probe_requires_messages_and_both_fresh_transforms(self):
        result = self.good_probe()
        self.assertTrue(backend.probe_ok(result))
        result['tf']['map -> laser']['ok'] = False
        self.assertFalse(backend.probe_ok(result))
        result = self.good_probe()
        result['received']['scan']['count'] = 0
        self.assertFalse(backend.probe_ok(result))
        self.assertFalse(backend.probe_ok({}))

    def test_data_connectivity_does_not_confirm_navigation(self):
        result = self.good_probe()
        self.assertTrue(backend.probe_ok(result))
        self.assertFalse(backend.navigation_ok(result))
        result['received']['localization'] = {'count': 1, 'fresh': True}
        result['received']['navigation'] = {'fresh': True, 'status': {'ready': True}}
        self.assertTrue(backend.navigation_ok(result))
        result['received']['navigation']['fresh'] = False
        self.assertFalse(backend.navigation_ok(result))

    def test_scan_count_without_fresh_scan_is_not_connectivity(self):
        result = self.good_probe()
        result['received']['scan']['fresh'] = False
        self.assertFalse(backend.probe_ok(result))

    def test_navigation_diagnosis_requires_board_confirmation(self):
        with patch.object(backend, 'viewer_state', return_value={'running': True, 'mode': 'navigation'}), patch.object(backend, 'network_state', return_value={'ok': True}), patch.object(backend, 'network_check', return_value='{"ok":true}'), patch.object(backend, 'probe', return_value=self.good_probe()):
            report = backend.diagnose(self.data)
        self.assertFalse(report['ok'])
        self.assertFalse(report['steps'][-1]['ok'])

    def test_diagnosis_does_not_hide_callback_failure(self):
        with patch.object(backend, 'viewer_state', return_value={'running': True}), patch.object(backend, 'network_state', return_value={'ok': True}), patch.object(backend, 'network_check', side_effect=RuntimeError('callback blocked')), patch.object(backend, 'probe', return_value=self.good_probe()):
            report = backend.diagnose(self.data)
        self.assertFalse(report['ok'])
        self.assertTrue(any(step.get('error') == 'callback blocked' for step in report['steps']))
        self.assertEqual(report['probe'], self.good_probe())

    def test_diagnosis_requires_running_viewer_for_complete_success(self):
        with patch.object(backend, 'viewer_state', return_value={'running': False}), patch.object(backend, 'network_state', return_value={'ok': True}), patch.object(backend, 'network_check', return_value='{"ok":true}'), patch.object(backend, 'probe') as probe:
            self.assertFalse(backend.diagnose(self.data)['ok'])
            probe.assert_not_called()

    def test_reconnect_keeps_mode_and_saves_only_after_validation(self):
        for success in (False, True):
            with self.subTest(success=success), patch.object(backend, 'viewer_state', return_value={'running': True, 'mode': 'navigation'}), patch.object(backend, 'launch', return_value='started') as launch, patch.object(backend, 'diagnose', return_value={'ok': success}), patch.object(backend, 'save_config') as save:
                report = backend.reconnect(self.data)
                launch.assert_called_once_with('navigation', self.data, reconnect=True)
                self.assertEqual(report['ok'], success)
                self.assertEqual(save.call_count, int(success))

    def test_reconnect_without_viewer_does_not_launch(self):
        with patch.object(backend, 'viewer_state', return_value={'running': False}), patch.object(backend, 'launch') as launch:
            with self.assertRaises(ValueError):
                backend.reconnect(self.data)
            launch.assert_not_called()


@unittest.skipUnless(os.environ.get("DISPLAY"), "requires a graphical desktop")
class GuiTests(unittest.TestCase):
    def make_app(self):
        spec = importlib.util.spec_from_file_location('console_gui', Path(__file__).with_name('pc-console.py'))
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        with patch.object(backend, 'load_config', return_value=({'pc_ip': '192.168.43.123', 'kv260_ip': '192.168.43.182', 'port': '11311'}, '')), patch.object(backend, 'profiles', return_value={}):
            app = module.Console()
        for timer in app.tk.call('after', 'info'):
            app.after_cancel(timer)
        self.addCleanup(app.destroy)
        return app

    def test_input_change_immediately_invalidates_probe(self):
        app = self.make_app()
        app.show_probe(BackendTests().good_probe())
        app.variables['kv260_ip'].set('192.168.50.2')
        self.assertIsNone(app.last_probe)
        self.assertIn('配置已变化', app.status_labels['probe'].cget('text'))

    def test_probe_explains_latch_separately_from_current_health(self):
        app = self.make_app()
        result = BackendTests().good_probe()
        result['received']['navigation'] = {'fresh': True, 'status': {
            'ready': False, 'reason': 'high_pose_uncertainty_initial_pose_required',
            'initial_pose_required': True, 'current_fault': ''}}
        app.show_probe(result)
        text = app.status_labels['probe'].cget('text')
        self.assertIn('定位协方差超限', text)
        self.assertIn('数据检查已恢复', text)

    def test_bookmark_controls_visible_in_short_window(self):
        app = self.make_app()
        app.geometry('1000x700')
        app.update_idletasks()
        for label in ('保存当前位置', '显示起点', '恢复起点定位'):
            button = next(item for item in app.controls if item.winfo_class() == 'TButton'
                          and item.cget('text') == label)
            self.assertTrue(button.winfo_ismapped())
            self.assertLess(button.winfo_rooty()+button.winfo_height(), app.winfo_rooty()+app.winfo_height())

    def test_expired_probe_is_not_left_green(self):
        app = self.make_app()
        app.show_probe(BackendTests().good_probe())
        app.last_probe = (time.monotonic() - 36, app.data())
        app.continuous_probe.set(False)
        with patch.object(app, 'refresh_status'):
            app.auto_refresh()
        self.assertIsNone(app.last_probe)
        self.assertIn('过期', app.status_labels['probe'].cget('text'))

    def test_network_change_invalidates_even_with_reachable_master(self):
        app = self.make_app()
        viewer = {'running': True, 'mode': 'slam', 'master': backend.master_url(app.data()), 'pc_ip': app.data()['pc_ip']}
        state = {'ok': True, 'addresses': [('eth0', app.data()['pc_ip'])], 'route': app.data()['pc_ip'], 'issues': []}
        app.show_status({'ok': True}, viewer, state)
        app.show_probe(BackendTests().good_probe())
        app.show_status({'ok': True}, viewer, dict(state, route='192.168.50.2'))
        self.assertIsNone(app.last_probe)

    def test_gateway_change_with_same_source_invalidates_probe(self):
        app = self.make_app()
        viewer = {'running': True, 'mode': 'slam', 'master': backend.master_url(app.data()), 'pc_ip': app.data()['pc_ip']}
        state = {'ok': True, 'addresses': [('eth0', app.data()['pc_ip'])], 'route': app.data()['pc_ip'], 'issues': [],
                 'routing': {'dev': 'eth0', 'prefsrc': app.data()['pc_ip'], 'gateway': '192.168.43.1'}}
        app.show_status({'ok': True}, viewer, state)
        app.show_probe(BackendTests().good_probe())
        app.show_status({'ok': True}, viewer, dict(state, routing=dict(state['routing'], gateway='192.168.43.254')))
        self.assertIsNone(app.last_probe)

    def test_profile_load_preserves_manual_interface_choice(self):
        app = self.make_app()
        app.profile_box.set('双网卡')
        data = dict(app.data(), pc_ip='192.168.50.2')
        with patch.object(backend, 'profiles', return_value={'双网卡': data}), patch.object(app, 'refresh_status'), patch.object(app, 'auto_ip') as auto:
            app.load_profile()
            auto.assert_not_called()
        self.assertEqual(app.data(), data)

    def test_old_background_result_cannot_validate_new_input(self):
        app = self.make_app()
        app.operation_config = app.data()
        app.variables['kv260_ip'].set('192.168.50.2')
        app.events.put(('probe', 'test', BackendTests().good_probe(), None))
        with patch.object(app, 'refresh_status'):
            app.consume_events()
        self.assertIsNone(app.last_probe)
        self.assertIn('检查期间配置已变化', app.status_labels['probe'].cget('text'))

    def test_empty_queue_does_not_add_refresh_timers(self):
        spec = importlib.util.spec_from_file_location("console_gui", Path(__file__).with_name("pc-console.py"))
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        with patch.object(backend, "load_config", return_value=(dict(backend.DEFAULTS, pc_ip="192.168.137.149"), "")):
            app = module.Console()
        try:
            for timer in app.tk.call("after", "info"):
                app.after_cancel(timer)
            app.consume_events()
            timers = app.tk.call("after", "info")
            self.assertEqual(len(timers), 1)
            app.after_cancel(timers[0])
            app.show_status({"ok": True, "tf_publishers": ["/slam_gmapping"]},
                            {"running": True, "mode": "slam", "master": "http://192.168.137.60:11311", "pc_ip": "192.168.137.149"})
            self.assertIn("SLAM", app.status_labels["viewer"].cget("text"))
            self.assertEqual(app.status_labels["nav"].cget("text"), "无发布者")
        finally:
            app.destroy()


if __name__ == "__main__":
    unittest.main()