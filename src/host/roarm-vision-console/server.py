"""Loopback-only web console using the Python standard library."""
import argparse
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import json
import os
import secrets
from urllib.parse import urlsplit

from console import Console
from transport import ROOT


class Server(ThreadingHTTPServer):
    daemon_threads = True

    def __init__(self, address, console):
        super().__init__(address, Handler)
        self.console = console
        self.token = secrets.token_urlsafe(32)


class Handler(BaseHTTPRequestHandler):
    def log_message(self, *args):
        pass

    def reply(self, status, content, content_type='application/json; charset=utf-8'):
        if not isinstance(content,bytes):
            content = json.dumps(content,ensure_ascii=False,allow_nan=False).encode()
        self.send_response(status)
        self.send_header('Content-Type',content_type)
        self.send_header('Content-Length',str(len(content)))
        self.send_header('Cache-Control','no-store')
        self.send_header('X-Content-Type-Options','nosniff')
        self.send_header('Referrer-Policy','no-referrer')
        self.send_header('Content-Security-Policy',"default-src 'self'; script-src 'self'; style-src 'self'; img-src 'self'; connect-src 'self'; frame-ancestors 'none'; base-uri 'none'; form-action 'self'")
        self.end_headers()
        try:
            self.wfile.write(content)
        except (BrokenPipeError,ConnectionResetError):
            pass

    def trusted(self):
        port = self.server.server_port
        hosts = ('127.0.0.1:%d'%port,'localhost:%d'%port)
        if self.headers.get('Host') not in hosts:
            self.reply(403,{'error':'仅允许本机访问'})
            return False
        origin = self.headers.get('Origin')
        if origin and origin not in tuple('http://'+host for host in hosts):
            self.reply(403,{'error':'不允许跨站访问'})
            return False
        if self.headers.get('Sec-Fetch-Site') == 'cross-site':
            self.reply(403,{'error':'不允许跨站访问'})
            return False
        return True

    def do_GET(self):
        if not self.trusted():
            return
        path = urlsplit(self.path).path
        if path == '/api/session':
            self.reply(200,{'token':self.server.token})
        elif path == '/api/status':
            self.reply(200,self.server.console.status())
        elif path in ('/image.jpg','/depth.png'):
            image = self.server.console.vision.image(depth=path=='/depth.png')
            if image:
                self.reply(200,image,'image/png' if path=='/depth.png' else 'image/jpeg')
            else:
                self.reply(503,{'error':'等待实时图像'})
        elif path in ('/','/app.js','/style.css'):
            name, content_type = {'/':('index.html','text/html; charset=utf-8'),
                                  '/app.js':('app.js','text/javascript; charset=utf-8'),
                                  '/style.css':('style.css','text/css; charset=utf-8')}[path]
            self.reply(200,(ROOT/'web'/name).read_bytes(),content_type)
        else:
            self.reply(404,{'error':'未找到'})

    def do_POST(self):
        if not self.trusted():
            return
        if not secrets.compare_digest(self.headers.get('X-Console-Token',''),self.server.token):
            self.reply(403,{'error':'会话无效，请刷新页面'})
            return
        if self.headers.get_content_type() != 'application/json':
            self.reply(415,{'error':'需要 JSON 请求'})
            return
        try:
            size = int(self.headers.get('Content-Length','0'))
            if not 0 < size <= 16384:
                raise ValueError('请求长度无效')
            self.connection.settimeout(5)
            data = json.loads(self.rfile.read(size))
            if not isinstance(data,dict):
                raise ValueError('请求必须为 JSON 对象')
            path = urlsplit(self.path).path
            console = self.server.console
            if path == '/api/config':
                console.configure(data)
            elif path in ('/api/observe','/api/watch','/api/feedback','/api/servo'):
                console.submit(path.rsplit('/',1)[1],data)
            elif path == '/api/stop':
                console.stop()
            else:
                self.reply(404,{'error':'未找到'})
                return
            self.reply(200,{'ok':True})
        except (ValueError,RuntimeError) as exc:
            message = str(exc)
            key = self.server.console.model.key
            if key:
                message = message.replace(key,'[已隐藏]')
            self.reply(400,{'error':message[:300]})
        except Exception:
            self.reply(500,{'error':'请求失败；请检查连接或输入类型'})


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--port',type=int,default=8877)
    args = parser.parse_args()
    console = Console()
    console.model.key = os.environ.pop('ROARM_API_KEY','')
    server = Server(('127.0.0.1',args.port),console)
    console.start()
    print('RoArm console: http://127.0.0.1:%d'%server.server_port,flush=True)
    try:
        server.serve_forever(poll_interval=.2)
    except KeyboardInterrupt:
        pass
    finally:
        console.close()
        server.server_close()


if __name__ == '__main__':
    main()