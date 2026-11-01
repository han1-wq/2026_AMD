import base64
import io
import json
import math
import threading
import time
import zlib

import numpy as np
from PIL import Image

from transport import vision_process


class Vision:
    def __init__(self):
        self.lock = threading.Lock()
        self.frame = None
        self.error = '等待连接'
        self.process = None
        self.running = True
        self.count = 0

    def run(self):
        while self.running:
            try:
                self.process = vision_process()
                for line in self.process.stdout:
                    if not self.running:
                        break
                    if not line.startswith('{'):
                        continue
                    frame = json.loads(line)
                    validate_frame(frame)
                    depth_array(frame)
                    frame['received_at'] = time.monotonic()
                    with self.lock:
                        self.frame, self.error = frame, ''
                        self.count += 1
                self.error = '视觉 SSH 流已断开，正在重连'
            except Exception as exc:
                self.error = '视觉流异常：' + str(exc)[:200]
            finally:
                if self.process:
                    self.process.terminate()
            if self.running:
                time.sleep(2)

    def snapshot(self, max_age=2.5, after=None):
        with self.lock:
            frame = self.frame
            if frame is None:
                raise RuntimeError('尚未收到图像')
            age = time.monotonic()-frame['received_at']+frame['source_age_s']
            if age > max_age or age < -.2:
                raise RuntimeError('视觉帧已过期，停止决策')
            if after is not None and frame['stamp'] <= after:
                raise RuntimeError('等待动作完成后的新画面')
            return dict(frame)

    def fresh_after(self, frame_stamp, timeout=6):
        deadline = time.monotonic()+timeout
        while time.monotonic()<deadline:
            try:
                return self.snapshot(after=frame_stamp)
            except RuntimeError:
                time.sleep(.08)
        raise RuntimeError('动作后未收到新画面')

    def status(self):
        with self.lock:
            if self.frame is None:
                return {'connected':False,'error':self.error,'frames':self.count}
            frame = self.frame
            age = time.monotonic()-frame['received_at']+frame['source_age_s']
            return dict(connected=-.2<=age<2.5,error=self.error,age_s=round(age,3),frames=self.count,
                        stamp=frame['stamp'],width=frame['width'],height=frame['height'],
                        depth_sync_ms=round(abs(frame['stamp']-frame['depth_stamp'])*1000,2),
                        detections=frame['detections'])

    def image(self, depth=False):
        with self.lock:
            frame = self.frame
        if frame is None:
            return b''
        if not depth:
            return base64.b64decode(frame['jpeg'])
        array = depth_array(frame)
        normalized = np.clip(array.astype(float)/2000,0,1)
        rgb = np.stack((255*(1-normalized),255*(1-abs(normalized-.5)*2),255*normalized),axis=-1).astype('uint8')
        rgb[array==0] = 0
        output = io.BytesIO()
        Image.fromarray(rgb).save(output,format='PNG')
        return output.getvalue()

    def close(self):
        self.running = False
        if self.process:
            self.process.terminate()


def depth_array(frame):
    depth = frame['depth']
    if depth.get('encoding') != '16UC1':
        raise ValueError('深度图编码无效')
    width,height,step = depth['width'],depth['height'],depth['step']
    if not (0<width<=2048 and 0<height<=2048 and width*2<=step<=8192 and step%2==0):
        raise ValueError('深度图尺寸无效')
    decoder = zlib.decompressobj()
    raw = decoder.decompress(base64.b64decode(depth['zlib']),step*height+1)
    if len(raw)!=step*height or not decoder.eof:
        raise ValueError('深度图数据长度错误')
    return np.frombuffer(raw,dtype='>u2' if depth['bigendian'] else '<u2').reshape(height,step//2)[:,:width]


def validate_frame(frame):
    for key in ('stamp','depth_stamp','source_age_s'):
        value = frame.get(key)
        if isinstance(value,bool) or not isinstance(value,(int,float)) or not math.isfinite(value):
            raise ValueError('视觉时间戳无效')
    if not -.2 <= frame['source_age_s'] <= 2:
        raise ValueError('源图像已过期')
    detected = frame['detections']['stamp']
    detected_stamp = detected['sec'] + detected['nanosec']/1e9
    if abs(frame['stamp']-frame['depth_stamp']) > .2 or abs(frame['stamp']-detected_stamp) > .02:
        raise ValueError('图像、深度与检测不同步')
    for key in ('width','height'):
        if type(frame[key]) is not int or not 0 < frame[key] <= 4096:
            raise ValueError('图像尺寸无效')