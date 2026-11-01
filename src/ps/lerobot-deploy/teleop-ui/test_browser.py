"""Read-only Firefox smoke test; does not click any motion controls."""
import json
from pathlib import Path
import socket
import subprocess
import tempfile
import time


def main():
    root = Path(__file__).resolve().parent
    with tempfile.TemporaryDirectory(prefix='so101-browser-') as profile:
        Path(profile, 'user.js').write_text('user_pref("marionette.port", 2829);\n')
        with (root / 'test-browser.log').open('w') as log:
            firefox = subprocess.Popen(['firefox', '--headless', '--no-remote', '--profile', profile,
                                        '--marionette', 'about:blank'], stdout=log, stderr=log)
            sock = None
            try:
                for _ in range(60):
                    try:
                        sock = socket.create_connection(('127.0.0.1', 2829), timeout=1)
                        break
                    except OSError:
                        time.sleep(0.25)
                if sock is None:
                    raise RuntimeError('Firefox Marionette did not start')
                sock.settimeout(20)
                reader = sock.makefile('rb')

                def receive():
                    prefix = b''
                    while not prefix.endswith(b':'):
                        part = reader.read(1)
                        if not part:
                            raise RuntimeError('Browser connection closed')
                        prefix += part
                    return json.loads(reader.read(int(prefix[:-1])))

                receive()
                counter = 0

                def command(name, params=None):
                    nonlocal counter
                    counter += 1
                    payload = json.dumps([0, counter, name, params or {}]).encode()
                    sock.sendall(str(len(payload)).encode() + b':' + payload)
                    response = receive()
                    if response[2]:
                        raise RuntimeError(str(response[2]))
                    return response[3]

                command('WebDriver:NewSession', {'capabilities': {}})
                for address, token_file in [('127.0.0.1:8088', 'ui.token'),
                                            ('192.168.43.182:8089', 'board-ui.token')]:
                    token = (root / token_file).read_text().strip()
                    command('WebDriver:Navigate', {'url': 'http://' + address + '/#token=' + token})
                    for _ in range(30):
                        result = command('WebDriver:ExecuteScript', {
                            'script': 'return {connection:document.getElementById("connection").textContent, rows:document.querySelectorAll("#joints tr").length, applied:document.getElementById("applied").textContent, hash:location.hash, stopDisabled:document.getElementById("stop").disabled};',
                            'args': []})['value']
                        if result['connection'] == '控制服务已连接':
                            break
                        time.sleep(0.5)
                    assert result['connection'] == '控制服务已连接', result
                    assert result['rows'] == 6 and result['hash'] == '', result
                    assert not result['stopDisabled'], result
                    print('BROWSER_PASS', address, result)
                command('WebDriver:DeleteSession')
            finally:
                if sock:
                    sock.close()
                firefox.terminate()
                try:
                    firefox.wait(timeout=8)
                except subprocess.TimeoutExpired:
                    firefox.kill()
                    firefox.wait()


if __name__ == '__main__':
    main()