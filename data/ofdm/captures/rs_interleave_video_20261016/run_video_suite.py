#!/usr/bin/env python3
"""Reproducible moving synthetic JPEG load; run against the current board."""
from io import BytesIO
import argparse
import json
from pathlib import Path
import random
import secrets
import sys
import time

from PIL import Image, ImageChops, ImageDraw

ROOT = Path(__file__).resolve().parents[3]
OUT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT / 'host'))
from dma_image import connect_board
from dma_image_benchmark import distribution, transfer
from dma_jpeg_benchmark import run


def save_json(path, value):
    path.write_text(json.dumps(value, indent=2) + '\n')


def generate():
    randomizer = random.Random(20261016)
    source = Image.open(ROOT / 'sim/captures/demo_20261009/demo_source.png').convert('RGB')
    source = source.resize((1280, 720), Image.LANCZOS)
    noise = bytes(randomizer.getrandbits(8) for _ in range(1280 * 720))
    texture = Image.frombytes('L', (1280, 720), noise).convert('RGB')
    source = Image.blend(source, texture, 0.12)
    profiles = [(320, 180, 70), (640, 360, 50), (640, 360, 70),
                (640, 360, 85), (960, 540, 70), (1280, 720, 50), (1280, 720, 70)]
    result = []
    for width, height, quality in profiles:
        name = f'{width}x{height}_q{quality}'
        folder = OUT / 'sources' / name
        folder.mkdir(parents=True, exist_ok=False)
        sizes = []
        for index in range(32):
            image = ImageChops.offset(source, index * 11, index * 3)
            draw = ImageDraw.Draw(image)
            x = (index * 31) % 1000
            draw.rectangle((x, 260, x + 200, 440), fill=(240, 170, 30), outline='white', width=7)
            draw.ellipse((1050-x, 90, 1190-x, 230), fill=(30, 150, 230), outline='white', width=5)
            image = image.resize((width, height), Image.LANCZOS)
            draw = ImageDraw.Draw(image)
            draw.rectangle((0, 0, min(width, 245), 16), fill='black')
            draw.text((3, 2), f'OFDM {name} FRAME {index:03d}', fill='white')
            buffer = BytesIO()
            image.save(buffer, format='JPEG', quality=quality, subsampling=2, optimize=False)
            data = buffer.getvalue()
            (folder / f'frame_{index:03d}.jpg').write_bytes(data)
            sizes.append(len(data))
        result.append(dict(name=name, width=width, height=height, quality=quality,
                           directory=str(folder), frame_bytes=distribution(sizes)))
    save_json(OUT / 'source_manifest.json', dict(
        source='synthetic motion over rescaled 192x128 test pattern plus seeded texture',
        jpeg='Pillow JPEG, 4:2:0, quality as named, 32 preencoded frames repeated cyclically',
        limitations='Not a natural camera clip; no camera/encoder timing or GUI display',
        profiles=result))
    return result


def calibrate(profile):
    rows = []
    sock = connect_board(('192.168.137.10', 5001), 10)
    start = time.monotonic()
    try:
        for index, path in enumerate(sorted(Path(profile['directory']).glob('*.jpg'))[:12]):
            data = path.read_bytes()
            row, _ = transfer(sock, data, secrets.randbits(32), index + 1, 10)
            row['bytes'] = len(data)
            rows.append(row)
            if not row['success']:
                raise RuntimeError(f'Calibration failure: {row}')
    finally:
        sock.close()
    wall = time.monotonic() - start
    result = dict(profile=profile['name'], frames=len(rows), wall_s=wall,
                  sustainable_fps_estimate=len(rows)/wall,
                  goodput_Bps=sum(r['bytes'] for r in rows)/wall,
                  timings=distribution(r['elapsed_s'] for r in rows), rows=rows)
    save_json(OUT / f"calibration_{profile['name']}.json", result)
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--reuse-sources', action='store_true',
                        help='Reuse generated sources; run output directories must still be new')
    args = parser.parse_args()
    profiles = (json.loads((OUT / 'source_manifest.json').read_text())['profiles']
                if args.reuse_sources else generate())
    runs = []
    for profile in profiles:
        calibration = calibrate(profile)
        rate = calibration['sustainable_fps_estimate']
        print('CALIBRATION', profile['name'], round(rate, 2), 'fps', flush=True)
        # Low load, near capacity, and deliberate overload. Bound the sweep to 30 fps.
        rates = sorted(set(max(0.5, min(30, round(rate * factor * 2)/2))
                           for factor in (0.45, 0.8, 1.25)))
        for fps in rates:
            name = f"{profile['name']}_{fps:g}fps"
            result = run('192.168.137.10', profile['directory'], OUT / name, fps, 12)
            result.update(profile=profile['name'], name=name)
            runs.append(result)
            save_json(OUT / 'sweep_summary.json', runs)
            print('RUN', name, 'received', result['successes'], '/', result['scheduled_frames'],
                  'dropped', result['dropped_source_frames'], 'late', result['late_frames'],
                  'actual_fps', round(result['delivered_fps'], 2), flush=True)
            if result['failures']:
                raise RuntimeError(f'Transfer failure; stopping suite: {name}')
    # Endurance at a useful 360p configuration, with conservative headroom.
    profile = next(p for p in profiles if p['name'] == '640x360_q70')
    stable = [r for r in runs if r['profile'] == profile['name']
              and r['dropped_source_frames'] == 0 and r['failures'] == 0
              and r['late_frames'] <= max(1, r['scheduled_frames'] * .01)]
    fps = max((r['requested_fps'] for r in stable), default=2)
    result = run('192.168.137.10', profile['directory'], OUT / 'endurance_360p', fps, 120)
    save_json(OUT / 'endurance_summary.json', result)
    print('ENDURANCE', json.dumps(result), flush=True)
    print('SUITE_COMPLETE', flush=True)


if __name__ == '__main__':
    main()