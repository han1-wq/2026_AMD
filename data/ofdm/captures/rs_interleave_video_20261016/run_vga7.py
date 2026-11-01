#!/usr/bin/env python3
"""Validate the requested 640x480/7-fps JPEG load and retain received playback."""
import base64
import hashlib
from io import BytesIO
import json
from pathlib import Path
import sys

from PIL import Image, ImageChops, ImageDraw

OUT = Path(__file__).resolve().parent
sys.path.insert(0, str(OUT.parents[2] / 'host'))
from dma_jpeg_benchmark import run
from dma_image_benchmark import distribution


def main():
    root = OUT / 'vga7'
    root.mkdir(exist_ok=False)
    source = Image.open(OUT / 'sources/1280x720_q70/frame_000.jpg').convert('RGB')
    source = source.resize((640, 480), Image.LANCZOS)
    profiles = []
    for quality in (50, 60, 70):
        directory = root / f'source_q{quality}'
        directory.mkdir()
        sizes = []
        for index in range(49):
            frame = ImageChops.offset(source, index * 5, index * 2)
            draw = ImageDraw.Draw(frame)
            x = (index * 9) % 480
            draw.rectangle((x, 210, x+100, 310), fill=(240, 170, 30), outline='white', width=4)
            draw.rectangle((0, 0, 640, 30), fill='black')
            draw.text((10, 9), f'OFDM RX TEST | 640x480 | 7 FPS | JPEG Q{quality} | FRAME {index:03d}', fill='white')
            data = BytesIO()
            frame.save(data, format='JPEG', quality=quality, subsampling=2)
            (directory / f'frame_{index:03d}.jpg').write_bytes(data.getvalue())
            sizes.append(len(data.getvalue()))
        result = run('192.168.137.10', directory, root / f'probe_q{quality}', 7, 12)
        profiles.append(dict(quality=quality, frame_bytes=distribution(sizes), result=result))
        print('PROBE', quality, 'mean_bytes', round(sum(sizes)/len(sizes)),
              'received', result['successes'], 'skipped', result['dropped_source_frames'],
              'late', result['late_frames'], flush=True)
    # Prefer margin: Q50 is the requested initial low-rate JPEG configuration.
    quality = 50
    (root / 'profiles.json').write_text(json.dumps(profiles, indent=2)+'\n')
    result = run('192.168.137.10', root / f'source_q{quality}', root / 'received_run',
                 7, 120, save_frames=True)
    (root / 'result.json').write_text(json.dumps(result, indent=2)+'\n')
    rows = [json.loads(line) for line in (root/'received_run/results.jsonl').read_text().splitlines()]
    assert result['successes'] == len(rows) and result['failures'] == 0
    assert result['differing_bits'] == 0
    sources = sorted((root/f'source_q{quality}').glob('*.jpg'))
    hashes = {}
    images, playback = [], []
    for row in rows:
        filename = f"frame_{row['source_index']:06d}.jpg"
        path = root/'received_run/received'/filename
        data = path.read_bytes()
        assert data == sources[row['source_index'] % len(sources)].read_bytes()
        assert row['compared_bits'] == len(data)*8
        hashes[filename] = hashlib.sha256(data).hexdigest()
        if len(images) < 49:
            images.append(Image.open(BytesIO(data)).convert('RGB'))
        playback.append(dict(url='received_run/received/'+filename,
                             index=row['source_index'], finished=row['finish_s']))
    (root/'received_sha256.json').write_text(json.dumps(hashes, indent=2)+'\n')
    (root/'playback.json').write_text(json.dumps(playback)+'\n')
    images[0].save(root/'received_640x480_7fps.gif', save_all=True,
                   append_images=images[1:], duration=[140 if i%7!=6 else 160 for i in range(49)], loop=0)
    embedded = ['data:image/jpeg;base64,' + base64.b64encode(
        (root/p['url']).read_bytes()).decode('ascii') for p in playback[:49]]
    html = '''<!doctype html><html lang="zh-CN"><meta charset="utf-8">
<title>OFDM 实际接收视频 · 640×480 / 7 fps</title>
<style>body{background:#101820;color:#eee;font:17px system-ui;max-width:900px;margin:30px auto}img{width:640px;max-width:100%;border:1px solid #567}button,input{margin:10px;font:inherit}p{line-height:1.6}</style>
<h1>OFDM 实际接收视频</h1><p>640×480 · JPEG Q50 · 7 fps。以下为板子经 OFDM 回环后返回、逐字节校验通过的前 49 帧，7 秒循环回放。源为合成运动图像，不是摄像头录像。</p>
<img id="frame" alt="板子返回的 JPEG 视频帧"><div><button id="play">暂停</button><input id="seek" type="range" min="0" max="48" value="0"><span id="counter"></span></div>
<p id="stats"></p><p>浏览器按 7 fps 重放，回放时间并非原始网络到达时间；原始逐帧时间戳与两分钟完整接收 JPEG 已另行保存。GIF 预览会有调色板颜色损失，此页面直接显示原 JPEG。</p>
<script>const frames=FRAMES, stats=STATS;let i=0,playing=true;const image=document.getElementById('frame'),seek=document.getElementById('seek');function show(){image.src=frames[i];seek.value=i;document.getElementById('counter').textContent=(i+1)+' / '+frames.length;}document.getElementById('play').onclick=function(){playing=!playing;this.textContent=playing?'暂停':'播放'};seek.oninput=()=>{i=+seek.value;show()};document.getElementById('stats').textContent=`两分钟验证：${stats.successes}/${stats.scheduled_frames} 帧成功；跳帧 ${stats.dropped_source_frames}；迟到 ${stats.late_frames}；数据差异 ${stats.differing_bits} bit。`;show();setInterval(()=>{if(playing){i=(i+1)%frames.length;show()}},1000/7);</script></html>'''
    (root/'received_player.html').write_text(html.replace('FRAMES',json.dumps(embedded)).replace('STATS',json.dumps(result)))
    print('VGA7_COMPLETE', json.dumps(result), flush=True)


if __name__ == '__main__':
    main()