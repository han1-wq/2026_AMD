"""Same-subnet TTL=1 isolates the direct path without changing system routes."""
import json
from pathlib import Path
import secrets
import socket
import struct
import sys
import time

root = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(root / 'host'))
from dma_image_benchmark import transfer, summarize

out = Path(sys.argv[1]).resolve()
count = int(sys.argv[2]) if len(sys.argv) > 2 else 20
out.mkdir(exist_ok=False)
data = (root / 'sim/captures/demo_20261009/demo_source.png').read_bytes()
for ttl in (64, 1, 64, 1):
    run = len(list(out.glob('*/summary.json')))
    dest = out / f'{run}_ttl{ttl}'
    dest.mkdir()
    rows = []
    with socket.socket() as sock:
        sock.settimeout(30)
        sock.setsockopt(socket.IPPROTO_IP, socket.IP_TTL, ttl)
        sock.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
        sock.connect(('192.168.137.10', 5001))
        start = time.monotonic()
        with (dest / 'results.jsonl').open('w') as log:
            for index in range(count):
                row, image = transfer(sock, data, secrets.randbits(32), index, 30)
                rows.append(row)
                log.write(json.dumps(row) + '\n')
                if not row['success']:
                    break
            wall = time.monotonic() - start
        info = sock.getsockopt(socket.IPPROTO_TCP, socket.TCP_INFO, 104)
        retrans = struct.unpack_from('=I', info, 100)[0]
    summary = summarize(rows, len(data), wall)
    summary.update(ip_ttl=ttl, tcp_nodelay=True, total_retrans=retrans)
    (dest / 'summary.json').write_text(json.dumps(summary, indent=2) + '\n')
    print(dest.name, 'success', summary['successes'], 'retrans', retrans,
          'first_ms', summary['success_timings']['first_data_s']['median'] * 1000,
          'elapsed_ms', summary['success_timings']['elapsed_s']['median'] * 1000, flush=True)
    if len(rows) != count or summary['failures']:
        raise RuntimeError('Path experiment failed')
print('PATH_AB_PASS', flush=True)