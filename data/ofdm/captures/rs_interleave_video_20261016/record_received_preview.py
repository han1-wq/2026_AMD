#!/usr/bin/env python3
"""Save an actual checked 5-fps receive sequence and an animated preview."""
import importlib
from pathlib import Path
import sys
import time

from PIL import Image

OUT = Path(__file__).resolve().parent
sys.path.insert(0, str(OUT.parents[2] / 'host'))


def main():
    start = time.monotonic()
    while not (OUT / 'confirmations.log').exists() or 'CONFIRMATIONS_COMPLETE' not in (
            OUT / 'confirmations.log').read_text():
        if time.monotonic() - start > 600:
            raise RuntimeError('Confirmation runs did not complete within budget')
        time.sleep(2)
    run = importlib.import_module('dma_jpeg_benchmark').run
    result = run('192.168.137.10', OUT / 'sources/640x360_q70',
                 OUT / 'confirm_received_preview', 5, 6.4, save_frames=True)
    if result['successes'] != 32 or result['failures']:
        raise RuntimeError(f'Preview incomplete: {result}')
    images = []
    for path in sorted((OUT / 'confirm_received_preview/received').glob('*.jpg')):
        with Image.open(path) as image:
            images.append(image.copy())
    images[0].save(OUT / 'received_360p_5fps.gif', save_all=True,
                   append_images=images[1:], duration=200, loop=0)
    print('RECEIVED_PREVIEW_COMPLETE', flush=True)


if __name__ == '__main__':
    main()