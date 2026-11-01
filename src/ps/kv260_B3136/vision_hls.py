#!/usr/bin/env python3
"""Bounded threaded RGB-D pipeline for B3136 plus two HLS kernels."""
import argparse
from collections import deque
import json
import os
from pathlib import Path
import queue
import signal
import threading
import time
import traceback
from runtime.controls import ControlReader, atomic_write


def arguments():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--headless', action='store_true', help='No OpenCV window')
    p.add_argument('--seconds', type=float, default=0, help='Stop after this many seconds; 0 means unlimited')
    p.add_argument('--workers', type=int, choices=(1, 2), default=1, help='Independent VART runners')
    p.add_argument('--slots', type=int, choices=(2, 3, 4), default=2, help='Fixed in-flight frame buffers')
    p.add_argument('--self-test', action='store_true', help='Exercise both HLS kernels and DPU without camera')
    p.add_argument('--confidence', type=float, default=.3)
    p.add_argument('--nms', type=float, default=.6)
    p.add_argument('--max-depth-skew-ms', type=float, default=100)
    p.add_argument('--hls-timeout', type=float, default=10)
    p.add_argument('--camera-device', default=os.environ.get('ASTRA_COLOR_DEVICE',
                   '/dev/v4l/by-id/usb-Astra_Pro_HD_Camera_Astra_Pro_HD_Camera-video-index0'))
    p.add_argument('--external-depth', action='store_true', help='Subscribe to an already running depth publisher')
    p.add_argument('--summary', type=Path, help='Write bounded final JSON performance summary')
    p.add_argument('--snapshot', type=Path, help='Save the final annotated RGB image')
    p.add_argument('--control-dir', type=Path, help='Desktop control/status directory (enables HLS preview)')
    a = p.parse_args()
    if not (0 < a.confidence <= 1 and 0 <= a.nms <= 1 and 0 < a.hls_timeout <= 60
            and 0 <= a.seconds and 0 < a.max_depth_skew_ms <= 250):
        p.error('Invalid threshold, duration, skew or timeout')
    return a


def latest_put(q, value):
    try:
        q.put_nowait(value)
    except queue.Full:
        try:
            q.get_nowait()
        except queue.Empty:
            pass
        q.put_nowait(value)


class Pipeline:
    def __init__(self, hw, camera, args, stop):
        self.hw, self.camera, self.args, self.stop = hw, camera, args, stop
        self.latest = queue.Queue(1)
        self.free = queue.Queue(args.slots)
        self.prepared = queue.Queue(args.slots)
        self.inferred = queue.Queue(args.slots)
        self.results = queue.Queue(1)
        self.errors = queue.Queue(1)
        self.threads = []
        self.captured = self.processed = self.fallbacks = self.depth_pairs = 0
        self.published = 0
        self.timings = deque(maxlen=256)
        self.latencies = deque(maxlen=256)
        self.last_progress = time.monotonic()
        self.last_sequence = -1
        self.peak_rss = self.min_cma = self.min_available = None
        self.controls = ControlReader(args.control_dir)
        for s in hw.slots:
            self.free.put(s)

    def get(self, q):
        while not self.stop.is_set():
            try:
                return q.get(timeout=.1)
            except queue.Empty:
                pass
        return None

    def put(self, q, value):
        while not self.stop.is_set():
            try:
                q.put(value, timeout=.1)
                return
            except queue.Full:
                pass

    def worker(self, fn, *args):
        try:
            fn(*args)
        except Exception:
            latest_put(self.errors, traceback.format_exc())
            self.stop.set()

    def start(self):
        functions = [('rgb-capture', self.capture, ()), ('hls-pre', self.preprocess, ())]
        functions += [('dpu-' + str(i), self.infer, (i,)) for i in range(self.args.workers)]
        functions += [('hls-post', self.postprocess, ())]
        for name, fn, args in functions:
            t = threading.Thread(target=self.worker, args=(fn, *args), name=name, daemon=True)
            self.threads.append(t)
            t.start()

    def capture(self):
        failed = 0
        while not self.stop.is_set():
            ok, frame = self.camera.cap.read()
            if not ok:
                failed += 1
                if failed >= 30:
                    raise RuntimeError('RGB capture failed 30 times')
                time.sleep(.02)
                continue
            failed = 0
            if frame.shape != (480, 640, 3) or frame.dtype != np.uint8:
                raise RuntimeError('RGB frame shape/dtype changed')
            now, stamp = time.monotonic(), time.time_ns()
            self.captured += 1
            depth = self.camera.node.snapshot(stamp, self.args.max_depth_skew_ms)
            latest_put(self.latest, (frame, depth, self.captured, now, stamp))

    def preprocess(self):
        while not self.stop.is_set():
            slot = self.get(self.free)
            if slot is None:
                return
            record = self.get(self.latest)
            if record is None:
                return
            slot.frame, slot.depth, slot.sequence, slot.capture_time, slot.stamp_ns = record
            self.hw.preprocess(slot, self.controls.read())
            self.put(self.prepared, slot)

    def infer(self, worker):
        while not self.stop.is_set():
            slot = self.get(self.prepared)
            if slot is None:
                return
            self.hw.infer(slot, worker)
            self.put(self.inferred, slot)

    def postprocess(self):
        while not self.stop.is_set():
            slot = self.get(self.inferred)
            if slot is None:
                return
            boxes, scores, classes, fallback, candidates = self.hw.postprocess(slot)
            records = []
            for box, score, cls in zip(boxes, scores, classes):
                if box[2] <= box[0] or box[3] <= box[1]:
                    continue
                depth, valid = sample_depth(slot.depth, box)
                records.append(dict(bbox=[float(x) for x in box], score=float(score),
                                    class_id=int(cls), class_name=CLASS_NAMES[int(cls)],
                                    depth_m=depth, valid_depth_pixels=valid))
            latency = (time.monotonic() - slot.capture_time)*1000
            self.processed += 1
            self.fallbacks += int(fallback)
            self.depth_pairs += int(slot.depth is not None)
            self.timings.append(slot.timings.copy())
            self.latencies.append(latency)
            self.last_progress = time.monotonic()
            # Multiple runners may finish out of order; never show older frames.
            if slot.sequence > self.last_sequence:
                self.last_sequence = slot.sequence
                message = dict(sequence=slot.sequence, rgb_stamp_ns=slot.stamp_ns,
                               depth_stamp_ns=None if slot.depth is None else
                               slot.depth[0].header.stamp.sec*10**9 + slot.depth[0].header.stamp.nanosec,
                               depth_skew_ms=None if slot.depth is None else slot.depth[1],
                               depth_registration='uncalibrated_normalized_roi',
                               rgb_timestamp='host_after_v4l2_read',
                               depth_unit='m', hls_post_used=not fallback, candidates=candidates,
                               latency_ms=latency, timings=slot.timings.copy(), detections=records,
                               preprocessing=slot.pre_settings.copy())
                latest_put(self.results, (slot.frame, slot.enhanced, message))
            slot.frame = slot.depth = None
            slot.enhanced = None
            self.put(self.free, slot)

    def metrics(self, elapsed):
        mem = memory_kib()
        self.peak_rss = max(self.peak_rss or 0, mem['VmHWM'])
        self.min_cma = min(self.min_cma or mem['CmaFree'], mem['CmaFree'])
        self.min_available = min(self.min_available or mem['MemAvailable'], mem['MemAvailable'])
        timings = list(self.timings)
        latency = list(self.latencies)
        return dict(elapsed_s=elapsed, frames=self.processed,
                    fps=self.processed/max(elapsed, 1e-6), rgb_frames=self.captured,
                    depth_frames=self.camera.node.count, invalid_depth=self.camera.node.invalid,
                    paired_frames=self.depth_pairs, published_frames=self.published,
                    overflow_fallback_frames=self.fallbacks,
                    recent_mean_ms={k: float(np.mean([t[k] for t in timings]))
                                    for k in ('pre_ms', 'dpu_ms', 'post_ms')} if timings else {},
                    recent_latency_p50_ms=float(np.median(latency)) if latency else None,
                    recent_latency_p95_ms=float(np.percentile(latency, 95)) if latency else None,
                    memory_kib=mem, peak_rss_kib=self.peak_rss,
                    min_cma_free_kib=self.min_cma, min_mem_available_kib=self.min_available,
                    workers=self.args.workers, slots=self.args.slots)


def annotate(frame, message, fps):
    frame = frame.copy()
    for item in message['detections']:
        x1, y1, x2, y2 = map(int, item['bbox'])
        color = (40, 220, 40)
        cv2.rectangle(frame, (x1, y1), (x2, y2), color, 2)
        depth = item['depth_m']
        label = '{} {:.2f} {}'.format(item['class_name'], item['score'],
                                     '~{:.2f}m'.format(depth) if depth is not None else 'depth--')
        cv2.putText(frame, label, (x1, max(18, y1-5)), cv2.FONT_HERSHEY_SIMPLEX, .5, color, 1)
    cv2.putText(frame, 'B3136 + HLS pre/post  {:.1f} FPS'.format(fps), (8, 22),
                cv2.FONT_HERSHEY_SIMPLEX, .55, (0, 255, 255), 1)
    cv2.putText(frame, 'Depth: approximate, unregistered', (8, 468),
                cv2.FONT_HERSHEY_SIMPLEX, .43, (0, 255, 255), 1)
    return frame


def main(a):
    global cv2, np, sample_depth, CLASS_NAMES, memory_kib
    import cv2
    import numpy as np
    from runtime.hardware import Hardware, memory_kib, self_test
    from runtime.camera import Camera, sample_depth
    from runtime.reference import CLASS_NAMES
    from std_msgs.msg import String
    cv2.setNumThreads(1)
    cv2.ocl.setUseOpenCL(False)
    stop = threading.Event()
    hw = cam = pipeline = None
    last_frame = last_message = None
    summary = None
    started = None
    controls = ControlReader(a.control_dir)
    if a.control_dir:
        a.control_dir.mkdir(parents=True, exist_ok=True)
        controls.status(state='starting', pid=os.getpid(), updated=time.time())
    success = False
    stop_reason = 'completed'
    def request_stop(signum, _frame):
        nonlocal stop_reason
        stop_reason = signal.Signals(signum).name
        stop.set()
    for sig in (signal.SIGINT, signal.SIGTERM):
        signal.signal(sig, request_stop)
    try:
        hw = Hardware(Path(__file__).resolve().parent, a.workers, a.slots,
                      a.confidence, a.nms, a.hls_timeout, preview=bool(a.control_dir))
        if a.self_test:
            self_test(hw)
            if a.control_dir:
                from test_enhancement_board import run_checks
                run_checks(hw)
            success = True
            return
        if not a.headless and not os.environ.get('DISPLAY'):
            raise RuntimeError('No DISPLAY; use --headless over SSH')
        cam = Camera(a.camera_device, a.external_depth)
        cam.start()
        if stop.is_set():
            return
        pipeline = Pipeline(hw, cam, a, stop)
        started = time.monotonic()
        pipeline.start()
        last_report, last_count = started, 0
        display_fps = 0
        last_ui_report, last_ui_count = started, 0
        while not stop.is_set():
            now = time.monotonic()
            if controls.stop_requested():
                stop_reason = 'desktop_stop'
                break
            if a.seconds and now - started >= a.seconds:
                break
            if now - pipeline.last_progress > 20:
                raise RuntimeError('No inference result for 20 seconds')
            if cam.process and cam.process.poll() is not None:
                raise RuntimeError('ROS2 depth child exited during inference')
            if cam.node.latest and now - cam.node.latest[2] > 3:
                raise RuntimeError('ROS2 depth stream stalled')
            try:
                original, enhanced, message = pipeline.results.get(timeout=.05)
                selection = controls.read().display_mode
                frame = enhanced if selection == 'enhanced' and enhanced is not None else original
                last_frame, last_message = frame, message
                pub = String()
                pub.data = json.dumps(message, separators=(',', ':'), allow_nan=False)
                cam.node.publisher.publish(pub)
                pipeline.published += 1
                if a.control_dir:
                    if now - last_ui_report >= 1:
                        display_fps = (pipeline.processed-last_ui_count)/(now-last_ui_report)
                        last_ui_report, last_ui_count = now, pipeline.processed
                    shown = annotate(frame, message, display_fps)
                    atomic_write(a.control_dir / 'frame.ppm', b'P6\n640 480\n255\n' + shown[:, :, ::-1].tobytes())
                    controls.status(state='running', pid=os.getpid(), updated=time.time(),
                                    fps=display_fps, processed=pipeline.processed,
                                    depth_pairs=pipeline.depth_pairs, message=message,
                                    display_mode=selection)
                if not a.headless:
                    cv2.imshow('KV260 B3136 HLS RGB-D YOLOv4', annotate(frame, message, display_fps))
            except queue.Empty:
                pass
            if not a.headless and cv2.waitKey(1) & 0xff in (27, ord('q')):
                stop_reason = 'keyboard'
                break
            if now - last_report >= 5:
                summary = pipeline.metrics(now-started)
                display_fps = (pipeline.processed-last_count)/(now-last_report)
                summary['interval_fps'] = display_fps
                print('STATS ' + json.dumps(summary), flush=True)
                if summary['memory_kib']['MemAvailable'] < 128*1024:
                    raise MemoryError('Available memory below 128 MiB; stopping pipeline')
                last_report, last_count = now, pipeline.processed
        if not pipeline.errors.empty():
            raise RuntimeError(pipeline.errors.get_nowait())
        if not pipeline.processed or not pipeline.depth_pairs:
            raise RuntimeError('Test produced no inference frames or no valid depth pairs')
        success = True
    finally:
        stop.set()
        controls.status(state='draining', pid=os.getpid(), updated=time.time())
        if pipeline:
            for t in pipeline.threads:
                t.join(timeout=12)
            summary = pipeline.metrics(time.monotonic()-started)
            summary['success'] = success
            summary['stop_reason'] = stop_reason
            summary['last_detections'] = last_message['detections'] if last_message else []
            print('SUMMARY ' + json.dumps(summary), flush=True)
            if a.summary:
                a.summary.parent.mkdir(parents=True, exist_ok=True)
                a.summary.write_text(json.dumps(summary, indent=2) + '\n')
            if a.snapshot and last_frame is not None:
                a.snapshot.parent.mkdir(parents=True, exist_ok=True)
                if not cv2.imwrite(str(a.snapshot), annotate(last_frame, last_message, summary['fps'])):
                    print('Snapshot write failed: ' + str(a.snapshot), flush=True)
        # A timeout must never unmap a live DMA allocation. Keep the process
        # and lock alive until outstanding work is idle; do not SIGKILL it.
        warned = False
        while hw and (not hw.safe_to_release() or
                      (pipeline and any(t.is_alive() for t in pipeline.threads))):
            if not warned:
                print('DRAINING: retaining buffers/FPGA lock until all accelerator work finishes. '
                      'Do not SIGKILL. Inspect hardware if this persists.', flush=True)
                if cam:
                    cam.stop_child()
                warned = True
            for core in (hw.pre, hw.post):
                if core and core.busy and core.read('CTRL') & 4:
                    core.busy = False
            time.sleep(.2)
        if cam:
            cam.close()
        if hw:
            hw.close()
        if not a.headless:
            cv2.destroyAllWindows()
        print('CLEANUP_OK ' + json.dumps(memory_kib()), flush=True)
        controls.status(state='stopped' if success else 'error', pid=os.getpid(),
                        updated=time.time(), cleanup_ok=True, reason=stop_reason)


if __name__ == '__main__':
    main(arguments())