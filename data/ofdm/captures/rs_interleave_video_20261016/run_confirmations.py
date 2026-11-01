#!/usr/bin/env python3
"""Sequential follow-up of useful low-frame-rate profiles; no firmware changes."""
import json
from pathlib import Path
import sys
import time

OUT = Path(__file__).resolve().parent
sys.path.insert(0, str(OUT.parents[2] / 'host'))
from dma_jpeg_benchmark import run


def main():
    # The board supports a single TCP client; wait for the main suite to release it.
    wait_start = time.monotonic()
    while 'SUITE_COMPLETE' not in (OUT / 'video_suite.log').read_text():
        if time.monotonic() - wait_start > 240:
            raise RuntimeError('Main suite did not complete within the follow-up wait budget')
        time.sleep(2)
    for profile, fps, seconds in [('640x360_q70', 5, 120),
                                  ('640x360_q50', 10, 60),
                                  ('1280x720_q70', 2, 60)]:
        name = f'confirm_{profile}_{fps}fps'
        result = run('192.168.137.10', OUT / 'sources' / profile, OUT / name, fps, seconds)
        print(name, json.dumps(result), flush=True)
        if result['failures']:
            raise RuntimeError(f'Transfer failure in {name}')
    print('CONFIRMATIONS_COMPLETE', flush=True)


if __name__ == '__main__':
    main()