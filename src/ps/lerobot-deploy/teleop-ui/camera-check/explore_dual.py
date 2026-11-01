"""Bounded two-camera capture experiments. Never touches robot controls."""
import concurrent.futures
import json
from pathlib import Path
import subprocess
import time

ROOT = Path(__file__).resolve().parent
DEVICES = {
    'integrated': '/dev/v4l/by-id/usb-XHH-260202-H_Integrated_Camera-video-index0',
    'web': '/dev/v4l/by-id/usb-Generic_Web_Camera_20250708V1.000-video-index0',
}
CASES = [
    ('mjpeg-request15', ('mjpeg', '640x480', 15), ('mjpeg', '640x360', 15)),
    ('raw-low', ('yuyv422', '640x480', 30), ('yuyv422', '640x360', 30)),
    ('raw-mjpeg', ('yuyv422', '640x480', 30), ('mjpeg', '640x360', 30)),
    ('mjpeg-raw', ('mjpeg', '640x480', 60), ('yuyv422', '640x360', 30)),
    ('raw720-slow', ('yuyv422', '1280x720', 10), ('yuyv422', '1280x720', 15)),
]


def capture(case, name, config):
    fmt, size, fps = config
    prefix = ROOT / (case + '-' + name)
    start = time.monotonic()
    args = ['ffmpeg', '-hide_banner', '-nostdin', '-loglevel', 'info',
            '-f', 'v4l2', '-input_format', fmt, '-video_size', size,
            '-framerate', str(fps), '-i', DEVICES[name], '-t', '8',
            '-c:v', 'copy', '-progress', str(prefix) + '.progress',
            '-f', 'null', '-']
    with Path(str(prefix) + '.log').open('w') as log:
        process = subprocess.Popen(args, stdout=subprocess.DEVNULL, stderr=log)
        timed_out = False
        try:
            process.wait(timeout=20)
        except subprocess.TimeoutExpired:
            timed_out = True
            process.terminate()
            try:
                process.wait(timeout=3)
            except subprocess.TimeoutExpired:
                process.kill()
                process.wait()
    text = Path(str(prefix) + '.log').read_text()
    progress = Path(str(prefix) + '.progress')
    values = {}
    if progress.exists():
        for line in progress.read_text().splitlines():
            if '=' in line:
                key, value = line.split('=', 1)
                values[key] = value
    return {'camera': name, 'requested': config, 'start_monotonic': start,
            'end_monotonic': time.monotonic(), 'returncode': process.returncode,
            'timeout': timed_out, 'progress': values,
            'diagnostics': [line for line in text.splitlines()
                            if any(word in line for word in ('Stream #', 'changed', 'ioctl', 'error', 'Error', 'space'))]}


def main():
    results = []
    for case, integrated, web in CASES:
        # Refuse to compete with another camera user.
        for path in DEVICES.values():
            busy = subprocess.run(['fuser', path], capture_output=True, text=True)
            if busy.returncode == 0:
                raise RuntimeError('Camera occupied: ' + path)
        with concurrent.futures.ThreadPoolExecutor(max_workers=2) as pool:
            a = pool.submit(capture, case, 'integrated', integrated)
            b = pool.submit(capture, case, 'web', web)
            pair = [a.result(), b.result()]
        result = {'case': case, 'captures': pair}
        results.append(result)
        (ROOT / 'matrix-results.json').write_text(json.dumps(results, indent=2))
        print(json.dumps(result), flush=True)
    print('EXPLORATION_COMPLETE', flush=True)


if __name__ == '__main__':
    main()