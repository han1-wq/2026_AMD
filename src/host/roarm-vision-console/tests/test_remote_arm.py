import io
import json
import tempfile
import types
import unittest
from pathlib import Path
from unittest.mock import Mock, patch

import remote_arm
from transport import ROOT


class RemoteWorkerTests(unittest.TestCase):
    def run_worker(self, moved):
        arm=Mock()
        state=[0.]*10
        arm.feedback_get.side_effect=lambda: state.copy()
        def step(**args):
            if moved:
                state[args['joint']+3]=args['radian']
        arm.joint_radian_ctrl.side_effect=step
        driver=Mock();driver.roarm=arm
        driver_module=types.ModuleType('roarm_driver.roarm_driver')
        driver_module.RoarmDriver=Mock(return_value=driver)
        package=types.ModuleType('roarm_driver');package.__path__=[]
        ros=Mock()
        requests=[dict(id=1,op='step',joint=4,delta_rad=.009,expected=[0.]*10,issued_at=100),
                  dict(id=2,op='step',joint=4,delta_rad=.009,expected=[0.]*10,issued_at=100),
                  dict(id=3,op='feedback')]
        output=io.StringIO()
        with tempfile.TemporaryDirectory() as temp:
            lock=Path(temp)/'lock'
            real_open=open
            with patch.dict('sys.modules',{'rclpy':ros,'roarm_driver':package,
                                          'roarm_driver.roarm_driver':driver_module}), \
                 patch('remote_arm.subprocess.run',return_value=types.SimpleNamespace(returncode=1)), \
                 patch('builtins.open',side_effect=lambda *a,**kw:real_open(lock,'w')), \
                 patch('sys.stdin',io.StringIO(''.join(json.dumps(r)+'\n' for r in requests))), \
                 patch('sys.stdout',output),patch('remote_arm.time.time',return_value=100), \
                 patch('remote_arm.time.sleep'):
                remote_arm.main()
        driver.destroy_subscription.assert_called_once_with(driver.joint_states_sub)
        arm.disconnect.assert_called_once()
        return [json.loads(line) for line in output.getvalue().splitlines()],arm

    def test_zero_motion_records_sent_failure_and_locks_next_step(self):
        rows,arm=self.run_worker(False)
        self.assertTrue(rows[0]['ready'])
        failed=rows[1]
        self.assertEqual(failed['dispatch'],'sent')
        self.assertFalse(failed['motion_verified'])
        self.assertEqual(failed['measured_rad'],0.)
        self.assertEqual(failed['feedback'],[0.]*10)
        self.assertEqual(failed['target_rad'],.009)
        self.assertIn('未确认同向位移',failed['error'])
        self.assertEqual(rows[2]['dispatch'],'not_sent')
        self.assertIn('只允许读取反馈',rows[2]['error'])
        self.assertNotIn('error',rows[3])
        self.assertEqual(rows[3]['travel_rad'],.009)
        arm.joint_radian_ctrl.assert_called_once_with(joint=4,radian=.009,speed=30,acc=5)

    def test_encoder_confirmed_motion_and_stale_expected_pose_rejection(self):
        rows,arm=self.run_worker(True)
        self.assertTrue(rows[1]['motion_verified'])
        self.assertEqual(rows[1]['measured_rad'],.009)
        self.assertEqual(rows[1]['feedback'][7],.009)
        self.assertEqual(rows[2]['dispatch'],'not_sent')
        self.assertIn('姿态改变',rows[2]['error'])
        arm.joint_radian_ctrl.assert_called_once()

    def test_remote_bundle_has_no_local_motion_import(self):
        source=(ROOT/'motion.py').read_text()+'\n'+(ROOT/'remote_arm.py').read_text().replace(
            'from motion import step_target, check_feedback, SPEED, ACC','')
        self.assertNotIn('from motion import',source)
        namespace={'__name__':'bundled_worker'}
        exec(compile(source,'remote_bundle','exec'),namespace)
        self.assertTrue(callable(namespace['check_feedback']))