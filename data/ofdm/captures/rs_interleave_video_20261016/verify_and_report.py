#!/usr/bin/env python3
"""Independently check completed capture rows and write the measured report."""
import hashlib
import json
from pathlib import Path

OUT = Path(__file__).resolve().parent
ROOT = OUT.parents[2]


def load(path):
    return json.loads(path.read_text())


def totals(rows):
    result = {}
    for row in rows:
        for key, value in row['counters'].items():
            result[key] = result.get(key, 0) + value
    return result


def verify(folder, image=False):
    rows = [json.loads(line) for line in (folder / 'results.jsonl').read_text().splitlines()]
    summary = load(folder / 'summary.json')
    config = load(folder / 'config.json')
    assert rows and all(row['success'] and row['differing_bits'] == 0 for row in rows)
    if image:
        assert len(rows) == summary['successes'] == summary['attempts'] == 400
        data = Path(config['source']).read_bytes()
        assert all(row['compared_bits'] == len(data) * 8 for row in rows)
        assert (folder / 'last_received.png').read_bytes() == data
    else:
        assert len(rows) == summary['successes'] == summary['attempted']
        assert summary['scheduled_frames'] == (len(rows) + summary['dropped_source_frames']
                                                + summary['unattempted_frames'])
        frames = sorted(Path(config['source']).glob('*.jpg'))
        for row in rows:
            data = frames[row['source_index'] % len(frames)].read_bytes()
            assert row['compared_bits'] == len(data) * 8 == row['bytes'] * 8
            if config.get('save_received_frames'):
                assert (folder / 'received' / f"frame_{row['source_index']:06d}.jpg").read_bytes() == data
        assert (folder / 'last_received.jpg').read_bytes() == frames[
            rows[-1]['source_index'] % len(frames)].read_bytes()
        assert totals(rows) == summary['counter_totals']
    assert len(rows) == sum(bool(row['counters']) for row in rows)
    assert all(totals(rows).get(key, 0) == 0 for key in
               ('tx_rejected', 'tx_failed', 'rx_overflow', 'rx_timeout', 'link_failures'))
    return summary, totals(rows)


def main():
    assert 'SUITE_COMPLETE' in (OUT / 'video_suite.log').read_text()
    image, image_counters = verify(OUT / 'images_400', image=True)
    runs = load(OUT / 'sweep_summary.json')
    assert len(runs) == 21
    manifest = load(OUT / 'source_manifest.json')
    profiles = {profile['name']: profile for profile in manifest['profiles']}
    for row in runs:
        result, _ = verify(OUT / row['name'])
        assert all(result[key] == row[key] for key in result)
    endurance, _ = verify(OUT / 'endurance_360p')
    extras = []
    for folder in sorted(OUT.glob('confirm_*')):
        if not (folder / 'summary.json').exists():
            continue
        result, _ = verify(folder)
        extras.append(dict(name=folder.name, **result))
    # Ensure the original board build artifacts have remained unchanged.
    hashes = load(ROOT / 'sim/captures/rs_interleave_live_20261016/artifacts.json')
    for name, expected in hashes.items():
        assert hashlib.sha256(Path(name).read_bytes()).hexdigest() == expected
    report = dict(status='PASS: completed transfers verified; overload explicitly recorded',
                  images_400=image, image_counter_totals=image_counters,
                  video_sweep=runs, endurance=endurance, confirmations=extras,
                  artifacts_sha256=hashes, limitations=manifest['limitations'],
                  interrupted_followups=[f.name for f in OUT.glob('confirm_*')
                                         if not (f/'summary.json').exists()])
    if (OUT/'vga7/result.json').exists():
        vga, _ = verify(OUT/'vga7/received_run')
        report['vga_640x480_7fps'] = vga
    (OUT / 'verified_result.json').write_text(json.dumps(report, indent=2) + '\n')
    lines = ['# RS-interleaved OFDM: 400 images and paced JPEG video', '',
             'Current-board Ethernet -> OFDM RF loopback -> Ethernet tests; 850 MHz,',
             '40 MSPS, RS and packet-local interleaving enabled. No firmware/bitstream',
             'change or QSPI programming was performed during these tests.', '',
             '## 400 consecutive original PNG transfers', '',
             f"400/400 passed; {image['successful_bytes']:,} bytes / {image['compared_bits']:,} bits compared, zero differences.",
             f"Wall time {image['wall_s']:.3f} s, application goodput {image['application_goodput_Bps']/1000:.1f} kB/s "
             f"({image['application_goodput_Bps']*8/1e6:.3f} Mbit/s).",
             f"Median / P95 / maximum full-frame time: "
             f"{image['success_timings']['elapsed_s']['median']*1000:.2f} / "
             f"{image['success_timings']['elapsed_s']['p95']*1000:.2f} / "
             f"{image['success_timings']['elapsed_s']['max']*1000:.2f} ms.",
             f"Reported per-transfer counter totals: `{json.dumps(image_counters)}`.", '',
             '## Moving JPEG sweep', '',
             'The source is synthetic motion with seeded texture over an upscaled',
             '192x128 test pattern, not a natural camera recording. Each profile contains',
             '32 JPEG frames replayed cyclically (4:2:0; Pillow quality as listed).',
             'Resolution identifies transmitted JPEG dimensions, not source camera detail.',
             'Each configuration ran for 12 seconds. No host retry; one outstanding frame.',
             'Source frames that expire while the link is busy are skipped, bounding latency.',
             'Each returned frame is byte/CRC checked and JPEG-decoded.', '',
             '| Dimensions / quality | Mean kB/frame | Target fps | Delivered fps | Successful / scheduled | Source frames skipped | Late frames | P95 source-to-decode ms | Retries |',
             '| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |']
    for row in runs:
        profile = profiles[row['profile']]
        lines.append(f"| {row['profile']} | {profile['frame_bytes']['mean']/1000:.1f} | "
                     f"{row['requested_fps']:g} | {row['delivered_fps']:.2f} | "
                     f"{row['successes']}/{row['scheduled_frames']} | {row['dropped_source_frames']} | "
                     f"{row['late_frames']} | {row['capture_to_decode_s']['p95']*1000:.1f} | "
                     f"{row['counter_totals']['link_retries']} |")
    lines += ['', 'Late frames are successfully recovered frames that miss the next source-frame',
              'deadline; they are counted separately from skipped source frames and failures.',
              'Source-to-decode latency includes scheduling delay and the full transfer/ACK',
              'completion plus JPEG decode. A small playback buffer could absorb some late',
              'frames, but buffered playback was not tested.', '', '## Sustained runs', '']
    for name, row in [('endurance_360p', endurance)] + [(r['name'], r) for r in extras]:
        lines.append(f"- `{name}`: target {row['requested_fps']:g} fps, {row['wall_s']:.2f} s; "
                     f"{row['successes']}/{row['scheduled_frames']} complete, "
                     f"{row['dropped_source_frames']} source skips, {row['late_frames']} late; "
                     f"delivered {row['delivered_fps']:.3f} fps; "
                     f"P95 {row['capture_to_decode_s']['p95']*1000:.1f} ms, "
                     f"{row['counter_totals']['link_retries']} link retries.")
    lines += ['', '## Interpretation and reproduction', '',
              'Goodput counts successful JPEG payload bytes once per complete RF loopback.',
              'It is not PHY bitrate or an independently measured peer-to-peer video capacity.',
              'Packets include FCS/ARQ; zero delivered differences do not establish raw BER.',
              'Saturation FPS depends on JPEG size, protocol overhead, RF retries, and host jitter.',
              'A practical configuration needs headroom below saturation and a frame budget',
              'that tolerates the configured 100 ms link retry timeout.', '',
              'Capture, resize, JPEG encode and GUI display are excluded from paced runs.',
              '`encoding_timings.json` separately measures host JPEG encoding only.',
              '`synthetic_360p_preview.gif` previews the source, not a recording of a receiver.',
              'The last actual verified received JPEG is retained in each run directory.',
              'No natural video source/camera was available; conclusions apply to these loads.', '',
              'Run a JPEG directory through the maintained tool (choose a new output directory):', '',
              '```sh',
              f'python3 {ROOT}/host/dma_jpeg_benchmark.py 192.168.137.10 {OUT}/sources/640x360_q70 /tmp/ofdm_video_new --fps 5 --seconds 120',
              '```', '',
              'Evidence: `images_400/`, `source_manifest.json`, `calibration_*.json`,',
              '`sweep_summary.json`, per-run `results.jsonl`/`summary.json`,',
              '`video_suite.log`, `endurance_360p/`, `verified_result.json`.',
              'Run `verify_and_report.py` after the suite to independently recheck these results.', '']
    if 'vga_640x480_7fps' in report:
        row = report['vga_640x480_7fps']
        lines += ['## Requested 640x480 / 7 fps configuration', '',
                  f"JPEG Q50, 120 seconds: {row['successes']}/{row['scheduled_frames']} successful; "
                  f"{row['dropped_source_frames']} source skips; {row['late_frames']} late frames; "
                  f"{row['differing_bits']} bit differences.",
                  'All returned JPEGs and independent per-file hashes are retained in `vga7/`.',
                  '`vga7/received_player.html` plays the first 49 actually returned JPEGs',
                  'offline at 7 fps. `vga7/received_640x480_7fps.gif` is a color-quantized preview.',
                  'The entire 120-second received sequence is in `vga7/received_run/received/`.',
                  'Earlier optional follow-ups were stopped when the user narrowed the target;',
                  'partial logs are retained but excluded from complete-run validation.', '']
    (OUT / 'README.md').write_text('\n'.join(lines))
    print('VERIFIED_AND_REPORTED', len(runs), 'sweep runs,', len(extras)+1, 'follow-up runs')


if __name__ == '__main__':
    main()