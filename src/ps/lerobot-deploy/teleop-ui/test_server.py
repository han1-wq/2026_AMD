import json
from pathlib import Path
import tempfile
import threading
import time
import unittest
from unittest.mock import Mock, patch
from urllib.error import HTTPError
from urllib.request import Request, urlopen
from http.server import ThreadingHTTPServer

from server import App, Auth, Controller, Handler, signature, tail


class ControlTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.app = App('local', self.temp.name, 'key', 'token', 'http://127.0.0.1:9')
        self.app.control = Mock()
        self.app.board = Mock()
        self.app.control.processes.return_value = []

    def test_start_order(self):
        calls = []
        self.app.board.side_effect = lambda *args: calls.append('board') or {'created': True}
        self.app.control.start.side_effect = lambda mode: calls.append('leader') or True
        self.assertTrue(self.app.action({'action': 'start', 'mode': 'hardware'})['created'])
        self.assertEqual(calls, ['board', 'leader'])

    def test_start_failure_rolls_back_only_created_board(self):
        for created in (True, False):
            self.app.board.reset_mock()
            self.app.board.return_value = {'created': created}
            self.app.control.start.side_effect = RuntimeError('leader unavailable')
            with self.assertRaises(RuntimeError):
                self.app.action({'action': 'start', 'mode': 'dry-run'})
            self.assertEqual(self.app.board.call_count, 2 if created else 1)

    def test_stop_board_even_if_local_stop_fails(self):
        self.app.control.stop.side_effect = RuntimeError('docker failure')
        with self.assertRaisesRegex(RuntimeError, 'docker failure'):
            self.app.action({'action': 'stop'})
        self.app.board.assert_called_once_with('POST', '/api/action', {'action': 'stop'})

    def test_mode_conflict_does_not_touch_board(self):
        self.app.control.processes.return_value = [{'mode': 'hardware'}]
        with self.assertRaises(RuntimeError):
            self.app.action({'action': 'start', 'mode': 'dry-run'})
        self.app.board.assert_not_called()

    def test_duplicate_operation(self):
        self.app.lock.acquire()
        with self.assertRaises(RuntimeError):
            self.app.action({'action': 'stop'})
        self.app.lock.release()

    def test_invalid_action(self):
        for data in ({'action': 'shell'}, {'action': 'start', 'mode': 'other'}, []):
            with self.assertRaises(ValueError):
                self.app.action(data)

    def test_existing_process_is_adopted(self):
        ctrl = Controller('board', self.temp.name)
        ctrl.processes = Mock(return_value=[{'mode': 'hardware'}])
        with patch('server.subprocess.Popen') as popen:
            self.assertFalse(ctrl.start('hardware'))
            popen.assert_not_called()

    def test_real_process_lifecycle_without_hardware(self):
        root = Path(self.temp.name)
        network = root / 'network-teleop'
        network.mkdir()
        script = network / 'teleop.py'
        script.write_text("import time\nprint('LISTENING test-only', flush=True)\ntime.sleep(60)\n")
        (network / 'run-follower.sh').write_text('exec python3 ' + str(script) + ' server\n')
        ctrl = Controller('board', root)
        try:
            self.assertTrue(ctrl.start('dry-run'))
            self.assertTrue(ctrl.status()['running'])
            self.assertFalse(ctrl.start('dry-run'))
            ctrl.stop()
            self.assertFalse(ctrl.status()['running'])
        finally:
            if ctrl.child and ctrl.child.poll() is None:
                ctrl.child.terminate()
                ctrl.child.wait(timeout=3)

    def test_hmac_tamper_expiry_and_replay(self):
        auth = Auth('key', 'token')
        body = b'{"action":"stop"}'
        stamp, nonce = str(time.time()), 'f' * 32
        headers = {'X-Time': stamp, 'X-Nonce': nonce,
                   'X-Signature': signature('key', 'POST', '/api/action', stamp, nonce, body)}
        self.assertFalse(auth.verify(headers, 'POST', '/api/action', b'bad'))
        self.assertTrue(auth.verify(headers, 'POST', '/api/action', body))
        self.assertFalse(auth.verify(headers, 'POST', '/api/action', body))
        stamp = str(time.time() - 100)
        headers.update({'X-Time': stamp, 'X-Signature': signature('key', 'POST', '/api/action', stamp, nonce, body)})
        self.assertFalse(auth.verify(headers, 'POST', '/api/action', body))

    def test_tail_bounded(self):
        path = Path(self.temp.name) / 'log'
        path.write_text(('hello\n' * 10000) + 'last\n')
        text, age = tail(path)
        self.assertEqual(len(text.splitlines()), 35)
        self.assertTrue(text.endswith('last'))
        self.assertGreaterEqual(age, 0)

    def test_http_requires_auth_and_rejects_origin(self):
        http = ThreadingHTTPServer(('127.0.0.1', 0), Handler)
        http.app = self.app
        host = '127.0.0.1:' + str(http.server_port)
        http.allowed_hosts = {host}
        self.app.control.status.return_value = {'running': False}
        self.app.board.return_value = {'self': {'running': False}}
        thread = threading.Thread(target=http.serve_forever, daemon=True)
        thread.start()
        try:
            with self.assertRaises(HTTPError) as exc:
                urlopen('http://' + host + '/api/status')
            self.assertEqual(exc.exception.code, 401)
            req = Request('http://' + host + '/api/status', headers={'Authorization': 'Bearer token'})
            with urlopen(req) as response:
                self.assertEqual(json.load(response)['role'], 'local')
            req.add_header('Origin', 'http://evil.invalid')
            with self.assertRaises(HTTPError) as exc:
                urlopen(req)
            self.assertEqual(exc.exception.code, 403)
        finally:
            http.shutdown()
            http.server_close()
            thread.join()


if __name__ == '__main__':
    unittest.main()