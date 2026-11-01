#!/usr/bin/env python3
"""Run an explicit no-hardware allowlist; write logs inside a fresh run directory."""
import argparse
from datetime import datetime, timezone
import json
import os
from pathlib import Path
import shutil
import signal
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--python', default=sys.executable, help='Python for standard-library protocol/control tests')
    parser.add_argument('--numpy-python', help='Optional separate Python with NumPy for navigation/HLS tests')
    parser.add_argument('--output', type=Path, help='New results directory, inside this delivery package')
    parser.add_argument('--timeout', type=int, default=180)
    args = parser.parse_args()
    if args.timeout < 1:
        parser.error('--timeout must be positive')
    output = args.output or ROOT / 'sim/results' / datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ')
    output = output.resolve()
    if ROOT not in output.parents:
        parser.error('Output must be inside the delivery directory')
    output.mkdir(parents=True, exist_ok=False)
    py = shutil.which(args.python)
    if not py:
        parser.error('Python executable not found')
    numpy_py = shutil.which(args.numpy_python or args.python)
    if not numpy_py:
        parser.error('NumPy Python executable not found')
    env = dict(os.environ, PYTHONDONTWRITEBYTECODE='1')
    env.pop('DISPLAY', None)
    env.pop('PYTHONPATH', None)
    ofdm = ROOT / 'src/ofdm/eeSDR_ofdm_loopback'
    hls = ROOT / 'src/kv260/HLS_IP'
    ps = ROOT / 'src/ps'
    tasks = [
        ('environment', [py, '-B', '-c', 'import sys,platform; print(sys.version); print(platform.platform())'], ROOT),
        ('numpy_environment', [numpy_py, '-B', '-c', 'import sys,numpy; print(sys.version); print("numpy",numpy.__version__)'], ROOT),
        ('ofdm_host', [py, '-B', '-m', 'unittest', 'discover', '-s', str(ofdm/'host'), '-p', 'test_*.py', '-v'], ofdm),
        ('vision_controls', [py, '-B', '-m', 'unittest', 'discover', '-s', str(ps/'kv260_B3136'), '-p', 'test_controls.py', '-v'], ps/'kv260_B3136'),
        ('navigation', [numpy_py, '-B', '-m', 'unittest', 'discover', '-s', str(ps/'x3plus-kv260-docker/navigation-fix'), '-p', 'test_*.py', '-v'], ps/'x3plus-kv260-docker'),
        ('so101_protocol', [py, '-B', '-m', 'unittest', 'discover', '-s', str(ps/'lerobot-deploy/network-teleop'), '-p', 'test_teleop.py', '-v'], ps/'lerobot-deploy/network-teleop'),
        ('hls_host_config', [numpy_py, '-B', str(hls/'image_preprocess/tb/test_host_config.py')], hls/'image_preprocess'),
        ('hls_link_config', [numpy_py, '-B', str(hls/'image_preprocess/tb/test_link_config.py')], hls/'image_preprocess'),
        ('b3136_artifacts', ['sha256sum', '-c', str(ps/'kv260_B3136/artifacts.sha256')], ps/'kv260_B3136'),
        ('ofdm_xsa', [py, '-B', str(ofdm/'firmware/check_dma_xsa.py'), str(ofdm/'build_hw/TOP.xsa')], ofdm),
    ]
    # These are the five CPU/RTL-only commands in the original DMA regression.
    binary = output / 'dma'
    binary.mkdir()
    tasks += [
        ('dma_packets_compile', ['iverilog', '-g2012', '-Wall', '-s', 'tb_dma_packets', '-o', str(binary/'packets.vvp'), str(ofdm/'rtl/board/ofdm_dma_tx.v'), str(ofdm/'rtl/board/ofdm_dma_rx.v'), str(ofdm/'sim/tb_dma_packets.v')], ofdm),
        ('dma_packets', ['vvp', str(binary/'packets.vvp')], ofdm),
        ('dma_control_compile', ['iverilog', '-g2012', '-Wall', '-s', 'tb_dma_control', '-o', str(binary/'control.vvp'), str(ofdm/'rtl/board/ofdm_dma_control.v'), str(ofdm/'sim/tb_dma_control.v')], ofdm),
        ('dma_control', ['vvp', str(binary/'control.vvp')], ofdm),
        ('dma_link_compile', ['cc', '-std=c11', '-Wall', '-Wextra', '-Werror', '-I'+str(ofdm/'firmware/dma_app'), str(ofdm/'firmware/dma_app/link.c'), str(ofdm/'sim/test_dma_link.c'), '-o', str(binary/'link_test')], ofdm),
        ('dma_link', [str(binary/'link_test')], ofdm),
        ('dma_services_compile', ['cc', '-std=c11', '-Wall', '-Wextra', '-Werror', '-ffunction-sections', '-fdata-sections', '-I'+str(ofdm/'firmware/dma_app'), '-I'+str(ofdm/'sim'), str(ofdm/'firmware/dma_app/link.c'), str(ofdm/'sim/test_dma_services.c'), '-Wl,--gc-sections', '-o', str(binary/'services_test')], ofdm),
        ('dma_services', [str(binary/'services_test')], ofdm),
        ('dma_phy_compile', ['cc', '-std=c11', '-Wall', '-Wextra', '-Werror', '-DOFDM_PHY_TEST', '-I'+str(ofdm/'sim'), str(ofdm/'firmware/dma_app/board_phy.c'), str(ofdm/'sim/test_board_phy.c'), '-o', str(binary/'phy_test')], ofdm),
        ('dma_phy', [str(binary/'phy_test')], ofdm),
    ]
    tokens = {'dma_packets': 'DMA_PACKETS_PASS', 'dma_control': 'DMA_CONTROL_PASS',
              'dma_link': 'DMA_LINK_PASS', 'dma_services': 'DMA_SINGLE_BOARD_SERVICES_PASS',
              'dma_phy': 'BOARD_PHY_PASS', 'ofdm_xsa': 'DMA_XSA_PASS'}
    results = []
    for name, command, cwd in tasks:
        start = time.monotonic()
        log_path = output / (name + '.log')
        code, error = None, None
        with log_path.open('w') as log:
            try:
                proc = subprocess.Popen(command, cwd=cwd, env=env, stdout=log,
                                        stderr=subprocess.STDOUT, start_new_session=True)
                try:
                    code = proc.wait(timeout=args.timeout)
                except subprocess.TimeoutExpired:
                    os.killpg(proc.pid, signal.SIGTERM)
                    try:
                        proc.wait(timeout=5)
                    except subprocess.TimeoutExpired:
                        os.killpg(proc.pid, signal.SIGKILL)
                        proc.wait()
                    error = 'timeout'
            except OSError as exc:
                error = str(exc)
                log.write(error + '\n')
        text = log_path.read_text(errors='replace')
        token_ok = name not in tokens or tokens[name] in text
        item = {'name': name, 'command': command, 'cwd': str(cwd), 'returncode': code,
                'error': error, 'seconds': round(time.monotonic()-start, 3),
                'pass_marker_found': token_ok, 'ok': code == 0 and token_ok and error is None,
                'log': str(log_path.relative_to(ROOT))}
        results.append(item)
        print(name, 'PASS' if item['ok'] else 'FAIL', flush=True)
        (output/'summary.json').write_text(json.dumps({'hardware_actions': False,
                'python': py, 'results': results, 'complete': False}, ensure_ascii=False, indent=2)+'\n')
    passed = all(r['ok'] for r in results)
    (output/'summary.json').write_text(json.dumps({'hardware_actions': False, 'python': py, 'numpy_python': numpy_py,
            'complete': True, 'ok': passed, 'results': results}, ensure_ascii=False, indent=2)+'\n')
    print('SOFTWARE_CHECKS_PASS' if passed else 'SOFTWARE_CHECKS_INCOMPLETE', output, flush=True)
    return 0 if passed else 1


if __name__ == '__main__':
    raise SystemExit(main())