import unittest
from unittest.mock import Mock
import threading
import tempfile
from pathlib import Path
from unittest.mock import patch
import base64
import io
import json

from PIL import Image
from model import validate_decision
from motion import step_target, check_feedback
from transport import ArmCommandError
from servo import check_plan, run_servo, scene_change


def decision():
    return dict(action='calibrate',confidence=.95,tip=[20,20],target=[50,50],
        goal_tip=[22,20],reason='局部自由空间标定',target_label='bottle',
        completion_evidence='',contact_ready=False,clearance_verified=True,
        mapping_verified=False,step={'joint':1,'delta_rad':.01})


def frame():
    buf=io.BytesIO();Image.new('RGB',(80,60),'white').save(buf,format='JPEG')
    return dict(jpeg=base64.b64encode(buf.getvalue()).decode(),stamp=100.,width=80,height=60)


class BoundsTests(unittest.TestCase):
    def test_encoder_no_movement_inside_target_tolerance_is_failure(self):
        with self.assertRaisesRegex(RuntimeError,'未确认同向位移'):
            check_feedback([0.]*10,[0.]*10,4,.003,.003)

    def test_encoder_direction_target_and_other_joints(self):
        before=[0.]*10
        for measured,other in [(-.003,0),(.003,0),(.009,.01)]:
            after=before.copy();after[7]=measured;after[4]=other
            with self.subTest(measured=measured,other=other),self.assertRaises(RuntimeError):
                check_feedback(before,after,4,.009,.009)
        after=before.copy();after[7]=.009203885
        self.assertAlmostEqual(check_feedback(before,after,4,.009,.009),.009203885)

    def test_valid_increment(self):
        self.assertEqual(step_target([0.]*10,[0.]*10,1,.01,[0.]*10,0.),.01)

    def test_invalid_commands(self):
        for joint,delta,travel in [(6,.01,0),(True,.01,0),(1,.1,0),(1,float('nan'),0),
                                  (1,.01,.18),(1,True,0),(1,.001,0)]:
            with self.subTest(joint=joint,delta=delta,travel=travel),self.assertRaises(ValueError):
                step_target([0.]*10,[0.]*10,joint,delta,[0.]*10,travel)

    def test_encoder_changed(self):
        q=[0.]*10;q[5]=.02
        with self.assertRaises(ValueError):step_target(q,[0.]*10,1,.01,[0.]*10,0)

    def test_local_range(self):
        q=[0.]*10;q[4]=.079
        with self.assertRaises(ValueError):step_target(q,q,1,.01,[0.]*10,0)

    def test_plan_gates(self):
        d=decision();check_plan(d,[]);validate_decision(d,80,60)
        d['clearance_verified']=False
        with self.assertRaises(ValueError):check_plan(d,[])
        d['clearance_verified']=True;d['action']='approach'
        with self.assertRaises(ValueError):check_plan(d,[])
        d['mapping_verified']=True
        with self.assertRaises(ValueError):check_plan(d,[])
        history=[{'decision':decision(),'execution':{'feedback':[0.]*10}}]
        check_plan(d,history)
        d['action']='push'
        with self.assertRaises(ValueError):check_plan(d,history)


class LoopTests(unittest.TestCase):
    def console(self):
        c=Mock();c.lock=threading.RLock();c.task='push bottle'
        c._read_feedback.return_value={'feedback':[0.]*10}
        c.vision.snapshot.return_value=frame();c.vision.fresh_after.return_value=frame()
        c.arm.call.return_value={'before':[0.]*10,'feedback':[0.]*4+[.01]+[0.]*5}
        return c

    def test_motion_then_reobserve_with_before_image_and_feedback(self):
        c=self.console();done=decision();done.update(action='done',step=None)
        c.model.observe.side_effect=[{'decision':decision()},{'decision':done}]
        with tempfile.TemporaryDirectory() as temp,patch('servo.ROOT',Path(temp)):
            (Path(temp)/'inspection').mkdir()
            run_servo(c,threading.Event())
        c.arm.call.assert_called_once()
        self.assertEqual(c.arm.call.call_args.args,('step',))
        self.assertEqual(c.model.observe.call_count,2)
        args,kwargs=c.model.observe.call_args
        self.assertIn('execution',args[2]['history'][0])
        self.assertIsNotNone(kwargs['previous_frame'])
        self.assertEqual(c.phase,'review_required')

    def test_cancel_inflight_model_never_dispatches(self):
        c=self.console();cancel=threading.Event()
        def observe(*args,**kwargs):
            cancel.set();return {'decision':decision()}
        c.model.observe.side_effect=observe
        with tempfile.TemporaryDirectory() as temp,patch('servo.ROOT',Path(temp)):
            (Path(temp)/'inspection').mkdir();run_servo(c,cancel)
        c.arm.call.assert_not_called()

    def test_rejected_plan_is_returned_to_model_and_never_moves(self):
        c=self.console();d=decision();d['confidence']=.7
        c.model.observe.return_value={'decision':d}
        with tempfile.TemporaryDirectory() as temp,patch('servo.ROOT',Path(temp)):
            (Path(temp)/'inspection').mkdir()
            with self.assertRaisesRegex(RuntimeError,'连续三次'):
                run_servo(c,threading.Event())
        c.arm.call.assert_not_called()
        self.assertEqual(c.model.observe.call_count,3)
        self.assertIn('rejection',c.model.observe.call_args.args[2]['history'][0])

    def test_scene_changed_never_dispatches(self):
        c=self.console();c.model.observe.return_value={'decision':decision()}
        with tempfile.TemporaryDirectory() as temp,patch('servo.ROOT',Path(temp)),patch('servo.scene_change',return_value=10.):
            (Path(temp)/'inspection').mkdir();run_servo(c,threading.Event())
            row=json.loads(next((Path(temp)/'inspection').glob('servo-*/00-plan.json')).read_text())
            self.assertEqual(row['dispatch'],'not_sent')
            self.assertIn('scene_changed',row['rejection'])
        c.arm.call.assert_not_called()

    def test_old_worker_false_success_is_rejected_and_saved(self):
        c=self.console();d=decision();d['step']['delta_rad']=.003
        c.model.observe.return_value={'decision':d}
        c.arm.call.return_value={'before':[0.]*10,'feedback':[0.]*10}
        with tempfile.TemporaryDirectory() as temp,patch('servo.ROOT',Path(temp)):
            (Path(temp)/'inspection').mkdir()
            with self.assertRaisesRegex(RuntimeError,'未确认同向位移'):
                run_servo(c,threading.Event())
            row=json.loads(next((Path(temp)/'inspection').glob('servo-*/00-failed.json')).read_text())
            self.assertEqual(row['dispatch'],'sent')
            self.assertFalse(row['motion_verified'])
            self.assertEqual(row['execution']['feedback'],[0.]*10)
        c.arm.call.assert_called_once()
        c.vision.fresh_after.assert_not_called()

    def test_remote_error_preserves_dispatch_and_feedback(self):
        c=self.console();c.model.observe.return_value={'decision':decision()}
        evidence={'dispatch':'sent','before':[0.]*10,'feedback':[0.]*10,'measured_rad':0.}
        c.arm.call.side_effect=ArmCommandError('未到位',evidence)
        with tempfile.TemporaryDirectory() as temp,patch('servo.ROOT',Path(temp)):
            (Path(temp)/'inspection').mkdir()
            with self.assertRaisesRegex(RuntimeError,'未到位'):
                run_servo(c,threading.Event())
            row=json.loads(next((Path(temp)/'inspection').glob('servo-*/00-failed.json')).read_text())
            self.assertEqual(row['dispatch'],'sent')
            self.assertEqual(row['execution_evidence'],evidence)
            self.assertFalse(row['motion_verified'])
        c.arm.call.assert_called_once()

    def test_scene_comparison(self):
        self.assertEqual(scene_change(frame(),frame()),0.)