import ast
import base64
import json
import threading
import time
import unittest
import zlib
from unittest.mock import Mock

import requests

from console import Console
from model import ModelClient, validate_decision
from server import Server
from transport import ROOT
from vision import Vision, depth_array, validate_frame


def frame():
    return dict(width=2,height=2,stamp=10.,depth_stamp=10.,source_age_s=.1,
                received_at=time.monotonic(),jpeg='',detections={'stamp':{'sec':10,'nanosec':0}},
                depth=dict(width=2,height=2,step=4,bigendian=False,encoding='16UC1',
                           zlib=base64.b64encode(zlib.compress(b'\x01\x00'*4)).decode()))


def decision():
    return dict(action='observe',confidence=.9,tip=[1,1],target=[1,1],goal_tip=None,
                reason='只观察',target_label='bottle',completion_evidence='',contact_ready=False)


class ValidationTests(unittest.TestCase):
    def test_valid_decision(self):
        validate_decision(decision(),2,2)

    def test_missing_coordinate_rejected(self):
        d=decision();del d['tip']
        with self.assertRaises(ValueError):validate_decision(d,2,2)

    def test_bool_confidence_rejected(self):
        d=decision();d['confidence']=True
        with self.assertRaises(ValueError):validate_decision(d,2,2)

    def test_invalid_coordinate(self):
        for point in ([2,0],[True,1],[float('nan'),1]):
            d=decision();d['tip']=point
            with self.assertRaises(ValueError):validate_decision(d,2,2)

    def test_depth_roundtrip(self):
        self.assertEqual(depth_array(frame()).tolist(),[[1,1],[1,1]])

    def test_depth_bigendian_padding(self):
        f=frame();f['depth'].update(bigendian=True,step=6,
            zlib=base64.b64encode(zlib.compress(b'\x00\x02\x00\x03\x00\x00'*2)).decode())
        self.assertEqual(depth_array(f).tolist(),[[2,3],[2,3]])

    def test_truncated_depth(self):
        f=frame();f['depth']['zlib']=base64.b64encode(zlib.compress(b'\x01')).decode()
        with self.assertRaises(ValueError):depth_array(f)

    def test_oversized_depth(self):
        f=frame();f['depth']['zlib']=base64.b64encode(zlib.compress(b'\x01'*100000)).decode()
        with self.assertRaises(ValueError):depth_array(f)

    def test_frame_sync_validation(self):
        f=frame();validate_frame(f);f['depth_stamp']=11
        with self.assertRaises(ValueError):validate_frame(f)

    def test_frame_nan_validation(self):
        f=frame();f['source_age_s']=float('nan')
        with self.assertRaises(ValueError):validate_frame(f)

    def test_expired_snapshot(self):
        v=Vision();v.frame=frame();v.frame['received_at']-=4
        with self.assertRaises(RuntimeError):v.snapshot()

    def test_snapshot_after(self):
        v=Vision();v.frame=frame()
        with self.assertRaises(RuntimeError):v.snapshot(after=10.)

    def test_key_not_public(self):
        m=ModelClient();m.configure({'api_key':'test-secret'})
        self.assertNotIn('test-secret',json.dumps(m.public()))

    def test_url_credentials_rejected(self):
        m=ModelClient()
        for url in ('http://example.com','https://user@example.com','https://example.com?key=x','https://example.com#x'):
            with self.assertRaises(ValueError):m.configure({'base_url':url})

    def test_remote_only_uses_single_joint_motion(self):
        tree=ast.parse((ROOT/'remote_arm.py').read_text())
        calls=[n.func.attr for n in ast.walk(tree) if isinstance(n,ast.Call) and isinstance(n.func,ast.Attribute)]
        self.assertNotIn('joints_radian_ctrl',calls)
        self.assertIn('joint_radian_ctrl',calls)
        self.assertIn('feedback_get',calls)


class CoordinatorTests(unittest.TestCase):
    def setUp(self):
        self.console=Console()
        self.console.model=Mock(key='test-secret')
        self.console.vision=Mock()
        self.console.vision.snapshot.return_value=frame()
        self.console.arm=Mock()
        self.console.arm.call.return_value={'feedback':[0.]*10,'source':'serial_encoder'}

    def test_observe_never_moves(self):
        self.console.model.observe.return_value={'decision':decision(),'observed_stamp':10.}
        self.console.submit('observe',{})
        self.console.worker.join(2)
        self.assertFalse(self.console.worker.is_alive())
        self.assertEqual(self.console.phase,'blocked')
        self.assertTrue(self.console.result['observation_only'])
        self.console.arm.call.assert_called_once_with('feedback')

    def test_stop_discards_inflight_result(self):
        started,release=threading.Event(),threading.Event()
        def observe(*args):
            started.set();release.wait(2)
            return {'decision':decision(),'observed_stamp':10.}
        self.console.model.observe.side_effect=observe
        self.console.submit('observe',{})
        self.assertTrue(started.wait(1))
        self.console.stop();release.set();self.console.worker.join(2)
        self.assertIsNone(self.console.result)
        self.assertEqual(self.console.phase,'stopped')

    def test_expired_frame_blocks_model(self):
        self.console.vision.snapshot.side_effect=RuntimeError('过期')
        with self.assertRaises(RuntimeError):self.console.submit('observe',{})
        self.console.model.observe.assert_not_called()


class HttpTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.console=Console()
        cls.server=Server(('127.0.0.1',0),cls.console)
        cls.url='http://127.0.0.1:%d'%cls.server.server_port
        cls.thread=threading.Thread(target=cls.server.serve_forever,daemon=True)
        cls.thread.start()

    @classmethod
    def tearDownClass(cls):
        cls.server.shutdown();cls.server.server_close();cls.console.close()

    def test_home(self):
        r=requests.get(self.url,timeout=2)
        self.assertEqual(r.status_code,200)
        self.assertIn('视觉任务控制台',r.content.decode())
        self.assertIn('frame-ancestors',r.headers['Content-Security-Policy'])

    def test_post_without_token_denied(self):
        r=requests.post(self.url+'/api/stop',json={},timeout=2)
        self.assertEqual(r.status_code,403)

    def test_cross_origin_denied(self):
        r=requests.get(self.url+'/api/status',headers={'Origin':'https://evil.example'},timeout=2)
        self.assertEqual(r.status_code,403)

    def test_untrusted_host_denied(self):
        r=requests.get(self.url,headers={'Host':'evil.example'},timeout=2)
        self.assertEqual(r.status_code,403)

    def test_config_does_not_leak_key(self):
        token=requests.get(self.url+'/api/session',timeout=2).json()['token']
        r=requests.post(self.url+'/api/config',json={'api_key':'test-secret'},headers={'X-Console-Token':token},timeout=2)
        self.assertEqual(r.status_code,200)
        status=requests.get(self.url+'/api/status',timeout=2)
        self.assertNotIn('test-secret',status.text)
        self.assertTrue(status.json()['model']['key_configured'])

    def test_motion_route_not_available(self):
        r=requests.post(self.url+'/api/step',json={},headers={'X-Console-Token':self.server.token},timeout=2)
        self.assertEqual(r.status_code,404)

    def test_stop(self):
        r=requests.post(self.url+'/api/stop',json={},headers={'X-Console-Token':self.server.token},timeout=2)
        self.assertEqual(r.status_code,200)
        self.assertEqual(self.console.phase,'stopped')


if __name__ == '__main__':
    unittest.main()