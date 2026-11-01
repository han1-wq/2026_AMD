"""SO101 control panel. Python standard library; no serial access from the UI."""
import argparse
import hashlib
import hmac
import json
import math
import os
from pathlib import Path
import secrets
import signal
import subprocess
import threading
import time
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen

HERE = Path(__file__).resolve().parent
CONTAINER = 'so101-network-leader'


def run(argv, timeout=8):
    return subprocess.run(argv, capture_output=True, text=True, timeout=timeout)


def secret(path):
    if not path.exists():
        fd = os.open(str(path), os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600)
        with os.fdopen(fd, 'w') as stream:
            stream.write(secrets.token_hex(32))
    return path.read_text().strip()


def signature(key, method, path, stamp, nonce, body):
    message = '\n'.join((method, path, stamp, nonce, hashlib.sha256(body).hexdigest()))
    return hmac.new(key.encode(), message.encode(), hashlib.sha256).hexdigest()


class Auth:
    def __init__(self, key, token):
        self.key, self.token = key, token
        self.used = {}
        self.lock = threading.Lock()

    def verify(self, headers, method, path, body):
        bearer = headers.get('Authorization', '')
        if hmac.compare_digest(bearer, 'Bearer ' + self.token):
            return True
        stamp, nonce = headers.get('X-Time', ''), headers.get('X-Nonce', '')
        try:
            timestamp = float(stamp)
            if not math.isfinite(timestamp) or abs(time.time() - timestamp) > 30 or len(nonce) != 32:
                return False
        except ValueError:
            return False
        expected = signature(self.key, method, path, stamp, nonce, body)
        if not hmac.compare_digest(expected, headers.get('X-Signature', '')):
            return False
        with self.lock:
            now = time.time()
            self.used = {k: v for k, v in self.used.items() if now - v < 60}
            if nonce in self.used:
                return False
            self.used[nonce] = now
        return True


def tail(path):
    try:
        with path.open('rb') as stream:
            stream.seek(0, 2)
            stream.seek(max(0, stream.tell() - 24000))
            text = stream.read().decode('utf-8', errors='replace')
        return '\n'.join(text.splitlines()[-35:]), max(0, time.time() - path.stat().st_mtime)
    except FileNotFoundError:
        return '', None


class Controller:
    def __init__(self, role, root):
        self.role, self.root = role, Path(root)
        self.network = self.root / 'network-teleop'
        self.log = self.network / ('live-server.log' if role == 'board' else 'live-client.log')
        self.child = None

    def processes(self):
        if self.child is not None:
            self.child.poll()  # reap completed children
        if self.role == 'local':
            result = run(['docker', 'inspect', CONTAINER])
            if result.returncode:
                if 'No such' in result.stderr:
                    return []
                raise RuntimeError('Docker 状态查询失败：' + result.stderr[:300])
            info = json.loads(result.stdout)[0]
            if not info['State']['Running']:
                return []
            args = info['Config'].get('Cmd', []) or []
            if '/network/teleop.py' not in args or 'client' not in args:
                raise RuntimeError('同名容器不属于此遥操作程序，拒绝操作')
            return [{'pid': info['State']['Pid'], 'identity': info['Id'],
                     'mode': 'hardware' if '--hardware' in args else 'dry-run'}]
        found = []
        script = str(self.network / 'teleop.py')
        for item in Path('/proc').iterdir():
            if not item.name.isdigit():
                continue
            try:
                args = (item / 'cmdline').read_bytes().decode().split('\0')
                if script in args and args[args.index(script) + 1] == 'server':
                    identity = (item / 'stat').read_text().rsplit(')', 1)[1].split()[19]
                    found.append({'pid': int(item.name), 'identity': identity,
                                  'mode': 'hardware' if '--hardware' in args else 'dry-run'})
            except (OSError, UnicodeError, IndexError):
                continue
        return found

    def status(self):
        processes = self.processes()
        text, age = tail(self.log)
        sample = None
        for line in reversed(text.splitlines()):
            try:
                data = json.loads(line)
                if isinstance(data, dict) and 'applied' in data:
                    sample = data
                    break
            except ValueError:
                continue
        serial = ('5B91028053' if self.role == 'board' else '5B91026450')
        return {'reachable': True, 'running': bool(processes), 'processes': processes,
                'mode': processes[0]['mode'] if processes else None,
                'serial_present': Path('/dev/serial/by-id/usb-1a86_USB_Single_Serial_' + serial + '-if00').exists(),
                'log': text, 'log_age': age, 'sample': sample,
                'phase': ('发送端运行中' if self.role == 'local' else
                          ('反馈更新中' if sample and age is not None and age <= 12 else
                           '反馈未更新，请检查日志' if sample else '等待连接')) if processes else '已停止'}

    def start(self, mode):
        if mode not in ('hardware', 'dry-run'):
            raise ValueError('不支持的运行模式')
        existing = self.processes()
        if existing:
            if len(existing) != 1 or existing[0]['mode'] != mode:
                raise RuntimeError('已有不同模式的进程，请先停止')
            return False
        script = self.network / ('run-follower.sh' if self.role == 'board' else 'run-leader.sh')
        args = ['bash', str(script)] + (['--hardware'] if mode == 'hardware' else [])
        if self.log.exists():
            self.log.replace(self.log.with_name(self.log.name + '.previous'))
        with self.log.open('w') as stream:
            self.child = subprocess.Popen(args, stdin=subprocess.DEVNULL, stdout=stream,
                                          stderr=subprocess.STDOUT, start_new_session=True)
        for _ in range(75):
            if self.child.poll() is not None:
                raise RuntimeError('启动失败：' + tail(self.log)[0][-1500:])
            if self.role == 'board':
                if 'LISTENING' in tail(self.log)[0]:
                    return True
            elif self.processes():
                return True
            time.sleep(0.2)
        self.stop()
        raise RuntimeError('启动等待超时，已停止本次进程')

    def stop(self):
        processes = self.processes()
        if not processes:
            return
        if self.role == 'local':
            # Use immutable container ID so a replacement is never stopped accidentally.
            for item in processes:
                result = run(['docker', 'stop', '--time', '10', item['identity']], timeout=15)
                if result.returncode:
                    raise RuntimeError(result.stderr[:500])
        else:
            for item in processes:
                if item in self.processes():
                    os.kill(item['pid'], signal.SIGTERM)
            for _ in range(60):
                if not self.processes():
                    return
                time.sleep(0.2)
            raise RuntimeError('从臂进程仍在退出中；未发送 SIGKILL，请检查日志')


class App:
    def __init__(self, role, root, key, token, remote):
        self.role = role
        self.control = Controller(role, root)
        self.auth = Auth(key, token)
        self.remote = remote.rstrip('/')
        self.lock = threading.Lock()

    def board(self, method, path, data=None):
        body = json.dumps(data).encode() if data is not None else b''
        stamp, nonce = str(time.time()), secrets.token_hex(16)
        headers = {'Content-Type': 'application/json', 'X-Time': stamp, 'X-Nonce': nonce,
                   'X-Signature': signature(self.auth.key, method, path, stamp, nonce, body)}
        req = Request(self.remote + path, data=body if method == 'POST' else None,
                      headers=headers, method=method)
        try:
            with urlopen(req, timeout=25 if method == 'POST' else 4) as response:
                return json.load(response)
        except HTTPError as exc:
            raise RuntimeError('KV260：' + exc.read(3000).decode(errors='replace')) from exc
        except (URLError, TimeoutError, OSError) as exc:
            raise RuntimeError('KV260 服务不可达：' + str(exc)) from exc

    def status(self):
        try:
            own = self.control.status()
        except Exception as exc:
            own = {'reachable': False, 'running': False, 'error': str(exc)}
        result = {'role': self.role, 'busy': self.lock.locked(), 'self': own, 'time': time.time()}
        if self.role == 'local':
            try:
                result['board'] = self.board('GET', '/api/status')['self']
            except Exception as exc:
                result['board'] = {'reachable': False, 'running': False, 'error': str(exc)}
        return result

    def action(self, data):
        if not isinstance(data, dict) or set(data) - {'action', 'mode'}:
            raise ValueError('无效请求')
        action = data.get('action')
        if action not in ('start', 'stop'):
            raise ValueError('未知操作')
        if not self.lock.acquire(blocking=False):
            raise RuntimeError('另一项操作正在执行，请稍后')
        try:
            if action == 'stop':
                errors = []
                try:
                    self.control.stop()
                except Exception as exc:
                    errors.append(str(exc))
                if self.role == 'local':
                    try:
                        self.board('POST', '/api/action', {'action': 'stop'})
                    except Exception as exc:
                        errors.append(str(exc))
                if errors:
                    raise RuntimeError('；'.join(errors))
                return {'message': '已停止。实机从臂按既有策略尝试保持当前位置，扭矩保持开启。'}
            mode = data.get('mode')
            if mode not in ('hardware', 'dry-run'):
                raise ValueError('请选择实机或模拟模式')
            board_created = False
            if self.role == 'local':
                existing = self.control.processes()
                if existing and existing[0]['mode'] != mode:
                    raise RuntimeError('本机已有不同模式的遥操作，请先停止')
                result = self.board('POST', '/api/action', {'action': 'start', 'mode': mode})
                board_created = result['created']
            try:
                created = self.control.start(mode)
            except Exception:
                if board_created:
                    self.board('POST', '/api/action', {'action': 'stop'})
                raise
            return {'created': created, 'message': '启动请求已完成，请观察运行状态与从臂反馈。'}
        finally:
            self.lock.release()


class Handler(BaseHTTPRequestHandler):
    def log_message(self, *_):
        pass  # Never log credentials or URLs containing tokens.

    def reply(self, status, data, kind='application/json; charset=utf-8'):
        body = json.dumps(data, ensure_ascii=False).encode() if kind.startswith('application/json') else data
        self.send_response(status)
        self.send_header('Content-Type', kind)
        self.send_header('Content-Length', str(len(body)))
        self.send_header('Cache-Control', 'no-store')
        self.send_header('X-Content-Type-Options', 'nosniff')
        self.send_header('Referrer-Policy', 'no-referrer')
        self.send_header('Content-Security-Policy', "default-src 'self'; script-src 'self'; style-src 'self'; frame-ancestors 'none'; connect-src 'self'")
        self.end_headers()
        self.wfile.write(body)

    def handle_request(self):
        app = self.server.app
        host = self.headers.get('Host', '')
        if host not in self.server.allowed_hosts:
            self.reply(403, {'error': 'Invalid host'})
            return
        origin = self.headers.get('Origin')
        if origin and origin != 'http://' + host:
            self.reply(403, {'error': 'Cross-origin request rejected'})
            return
        if self.command == 'GET' and self.path in ('/', '/app.js', '/style.css'):
            file, kind = {'/': ('index.html', 'text/html; charset=utf-8'),
                          '/app.js': ('app.js', 'text/javascript; charset=utf-8'),
                          '/style.css': ('style.css', 'text/css; charset=utf-8')}[self.path]
            self.reply(200, (HERE / file).read_bytes(), kind)
            return
        try:
            length = int(self.headers.get('Content-Length', '0'))
            if not 0 <= length <= 4096:
                raise ValueError('Request too large')
            self.connection.settimeout(5)
            body = self.rfile.read(length)
            if len(body) != length:
                raise ValueError('Incomplete request')
            if not app.auth.verify(self.headers, self.command, self.path, body):
                self.reply(401, {'error': '访问令牌无效，请使用打开控制台的启动器或输入令牌'})
                return
            if self.command == 'GET' and self.path == '/api/status':
                self.reply(200, app.status())
            elif self.command == 'POST' and self.path == '/api/action':
                self.reply(200, app.action(json.loads(body)))
            else:
                self.reply(404, {'error': 'Not found'})
        except ValueError as exc:
            self.reply(400, {'error': str(exc)})
        except Exception as exc:
            self.reply(409, {'error': str(exc)})

    do_GET = handle_request
    do_POST = handle_request


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--role', choices=['local', 'board'], required=True)
    parser.add_argument('--bind', required=True)
    parser.add_argument('--port', type=int, required=True)
    parser.add_argument('--root', type=Path, default=HERE.parent)
    parser.add_argument('--remote', default='http://192.168.43.182:8089')
    parser.add_argument('--public-host', help='Additional exact HTTP Host allowed for LAN access')
    args = parser.parse_args()
    key = (HERE / 'api.key').read_text().strip()
    token = secret(HERE / 'ui.token')
    server = ThreadingHTTPServer((args.bind, args.port), Handler)
    server.daemon_threads = True
    server.app = App(args.role, args.root, key, token, args.remote)
    server.allowed_hosts = {args.bind + ':' + str(args.port), 'localhost:' + str(args.port),
                            '127.0.0.1:' + str(args.port)}
    if args.public_host:
        server.allowed_hosts.add(args.public_host)
    print('CONTROL_PANEL_READY', args.role, args.bind, args.port, flush=True)
    server.serve_forever()


if __name__ == '__main__':
    main()