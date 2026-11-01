"""HWH-derived AXI-Lite driver, reusable CMA buffers, VART and CPU fallback.

No virtual address is passed to an HLS port. VART's Python runner copies host
tensors internally; this module deliberately does not claim VART zero-copy.
"""
import json
import threading
import time
import xml.etree.ElementTree as ET
from pathlib import Path

import numpy as np
from pynq import allocate
from pynq_dpu import DpuOverlay
from pynq_dpu.dpu import get_child_subgraph_dpu
import vart

from . import pre_config as pre
from . import post_config as post
from . import reference
from .controls import Controls


def memory_kib():
    wanted = {'MemAvailable', 'CmaFree', 'CmaTotal'}
    result = {}
    for line in Path('/proc/meminfo').read_text().splitlines():
        key, value = line.split(':', 1)
        if key in wanted:
            result[key] = int(value.split()[0])
    for line in Path('/proc/self/status').read_text().splitlines():
        key, value = line.split(':', 1)
        if key in {'VmRSS', 'VmHWM'}:
            result[key] = int(value.split()[0])
    return result


class HlsCore:
    def __init__(self, overlay, hwh, name, timeout):
        module = next(m for m in ET.parse(hwh).iter('MODULE') if m.get('INSTANCE') == name)
        self.offsets = {}
        for reg in module.findall('.//REGISTER'):
            props = {p.get('NAME'): p.get('VALUE') for p in reg.findall('PROPERTY')}
            self.offsets[reg.get('NAME')] = int(props['ADDRESS_OFFSET'], 0)
        self.ip = getattr(overlay, name)
        self.name, self.timeout = name, timeout
        self.busy = False
        self.lock = threading.Lock()

    def read(self, name):
        return self.ip.read(self.offsets[name])

    def write(self, name, value):
        name = {'input': 'input_r', 'output': 'output_r'}.get(name, name)
        value = int(value)
        if name in self.offsets:
            self.ip.write(self.offsets[name], value)
        else:
            self.ip.write(self.offsets[name + '_1'], value & 0xffffffff)
            self.ip.write(self.offsets[name + '_2'], value >> 32)

    def run(self, arguments):
        with self.lock:
            if self.busy or not self.read('CTRL') & 4:
                raise RuntimeError(self.name + ' is not idle; refusing buffer reuse')
            for key, value in arguments.items():
                self.write(key, value)
            self.busy = True
            self.write('CTRL', 1)  # auto_restart always disabled
            deadline = time.monotonic() + self.timeout
            while not self.read('CTRL') & 2:
                if time.monotonic() >= deadline:
                    raise TimeoutError(self.name + ' did not finish; keep DMA buffers pinned')
                time.sleep(0.0001)  # release GIL for capture, DDS and DPU worker
            self.busy = False
            return self.read('ap_return')


class Slot:
    def __init__(self, hardware, index):
        self.index = index
        self.tensor = hardware.alloc((1, 416, 416, 3), np.int8)
        self.packed = hardware.alloc((post.INPUT_WORDS * 16,), np.uint8)
        self.outputs = []
        offsets, offset = {}, 0
        for grid in post.GRIDS:
            offsets[grid] = offset
            offset += grid * grid * 255
        for t in hardware.output_tensors:
            n = int(np.prod(t.dims))
            start = offsets[t.dims[1]]
            # Views in one packed allocation: no per-frame concatenation/copy.
            self.outputs.append(self.packed[start:start+n].view(np.int8).reshape(t.dims))
        self.frame = None
        self.depth = None
        self.sequence = 0
        self.capture_time = self.stamp_ns = 0
        self.timings = {}
        self.enhanced = None
        self.pre_settings = {}


class Hardware:
    def __init__(self, root, workers=1, slots=2, confidence=.3, nms=.6, timeout=10.0, preview=False):
        self.allocations = []
        self.runners = []
        self.pre = self.post = None
        self.active_dpu = 0
        self.active_lock = threading.Lock()
        self.confidence, self.nms = confidence, nms
        self.root = Path(root)
        if memory_kib()['MemAvailable'] < 500 * 1024:
            raise MemoryError('At least 500 MiB MemAvailable required before model initialization')
        print('BEFORE_LOAD ' + json.dumps(memory_kib()), flush=True)
        self.overlay = DpuOverlay(str(self.root / 'overlay/dpu.bit'))
        self.overlay.load_model(str(self.root / 'compiled/yolov4_leaky_416_tf.xmodel'))
        subgraph = get_child_subgraph_dpu(self.overlay.graph)[0]
        target = subgraph.get_attr('dpu_name')
        if target != 'DPUCZDX8G_ISA1_B3136':
            raise ValueError('Unexpected model target: ' + target)
        self.runners.append(self.overlay.runner)
        self.input_tensor = self.runners[0].get_input_tensors()[0]
        self.output_tensors = self.runners[0].get_output_tensors()
        if (len(self.runners[0].get_input_tensors()) != 1 or
                tuple(self.input_tensor.dims) != (1, 416, 416, 3) or
                str(self.input_tensor.dtype) != 'xint8'):
            raise ValueError('Requires one [1,416,416,3] INT8 input')
        if (len(self.output_tensors) != 3 or
                {tuple(t.dims) for t in self.output_tensors} != {(1, g, g, 255) for g in post.GRIDS} or
                any(str(t.dtype) != 'xint8' for t in self.output_tensors)):
            raise ValueError('Requires INT8 NHWC outputs 52/26/13, 255 channels')
        self.fix = int(self.input_tensor.get_attr('fix_point'))
        self.output_fix = {t.dims[1]: int(t.get_attr('fix_point')) for t in self.output_tensors}
        hwh = self.root / 'overlay/dpu.hwh'
        self.pre = HlsCore(self.overlay, hwh, 'image_preprocess_1', timeout)
        self.post = HlsCore(self.overlay, hwh, 'yolo_postprocess_1', timeout)
        for _ in range(1, workers):
            if memory_kib()['MemAvailable'] < 400 * 1024:
                raise MemoryError('Insufficient memory for another DPU runner')
            self.runners.append(vart.Runner.create_runner(subgraph, 'run'))
        # One preprocessing owner and one postprocessing owner; only per-frame
        # tensors/outputs need multiple slots. Disabled preview gets 64 bytes.
        self.source = self.alloc((480, 640, 3), np.uint8)
        self.preview_enabled = preview
        self.preview = self.alloc((480, 640, 3) if preview else (64,), np.uint8)
        self.pre_settings = None
        self.config_id = 0
        self.pre_luts = self.alloc((512,), np.uint8)
        self.pre_luts[:] = np.frombuffer(pre.make_luts(fix_point=self.fix), np.uint8)
        self.pre_luts.flush()
        self.post_luts = self.alloc((post.TABLE_WORDS,), np.uint32)
        self.post_luts[:] = np.frombuffer(post.make_tables(tuple(self.output_fix[g] for g in post.GRIDS)), '<u4')
        self.post_luts.flush()
        self.detections = self.alloc((post.MAX_CANDIDATES * 32,), np.uint8)
        self.slots = [Slot(self, i) for i in range(slots)]
        self.pre_args = [pre.frame_arguments(
            source=self.descriptor(self.source), tensor=self.descriptor(s.tensor),
            preview=self.descriptor(self.preview), luts=self.descriptor(self.pre_luts),
            flags=pre.RESET_HISTORY) for s in self.slots]
        self.post_args = [post.arguments(
            input_buffer=self.pair(s.packed), tables_buffer=self.pair(self.post_luts),
            output_buffer=self.pair(self.detections), confidence=confidence, nms=nms) for s in self.slots]
        print('HARDWARE_READY ' + json.dumps(dict(
            model_target=target, input_fix=self.fix, output_fix=self.output_fix,
            workers=workers, slots=slots, application_cma_bytes=sum(b.nbytes for b in self.allocations),
            memory_kib=memory_kib())), flush=True)

    def alloc(self, shape, dtype):
        requested = int(np.prod(shape)) * np.dtype(dtype).itemsize
        if memory_kib()['CmaFree'] * 1024 < requested + 16 * 1024**2:
            raise MemoryError('CMA reserve would fall below 16 MiB')
        b = allocate(shape, dtype=dtype)
        b.fill(0)
        self.allocations.append(b)
        return b

    @staticmethod
    def descriptor(b):
        return pre.Buffer(int(b.device_address), int(b.nbytes))

    @staticmethod
    def pair(b):
        return int(b.device_address), int(b.nbytes)

    def preprocess(self, slot, settings=None):
        start = time.monotonic()
        settings = settings or Controls()
        changed = self.pre_settings != settings.hardware_key()
        if changed:
            # This method has exactly one pipeline owner. The previous run
            # returned ap_done before either LUT or registers can change.
            self.config_id = (self.config_id + 1) & 0xffffffff
            self.pre_luts[:] = np.frombuffer(pre.make_luts(settings.contrast, settings.brightness, self.fix), np.uint8)
            self.pre_luts.flush()
            self.pre_settings = settings.hardware_key()
        np.copyto(self.source, slot.frame)
        self.source.flush()
        args = self.pre_args[slot.index]
        args.update(output_mode=pre.TENSOR_AND_PREVIEW if self.preview_enabled else pre.TENSOR_ONLY,
                    flags=(pre.COLOR_LUT | pre.SATURATION |
                           (pre.ENHANCE_TENSOR if settings.enhance_tensor else 0) |
                           (pre.RESET_HISTORY if changed else 0)),
                    eq_mode=settings.eq_mode, saturation_q12=round(settings.saturation * 4096),
                    config_id=self.config_id)
        args['frame_id'] = slot.sequence & 0xffffffff
        launched = time.monotonic()
        status = self.pre.run(args)
        completed = time.monotonic()
        if (status or self.pre.read('abi_version') != pre.ABI_VERSION or
                self.pre.read('completed_frame_id') != args['frame_id'] or
                self.pre.read('completed_config_id') != args['config_id'] or
                self.pre.read('tensor_bytes') != pre.TENSOR_BYTES or
                self.pre.read('preview_bytes') != (640*480*3 if self.preview_enabled else 0)):
            raise RuntimeError('Preprocessing status/ABI/frame/size mismatch: ' + str(status))
        slot.tensor.invalidate()
        synchronized = time.monotonic()
        if self.preview_enabled:
            self.preview.invalidate()
            slot.enhanced = np.asarray(self.preview).copy()
        slot.pre_settings = dict(contrast=settings.contrast, brightness=settings.brightness,
                                saturation=settings.saturation, eq_mode=settings.eq_mode,
                                enhance_tensor=settings.enhance_tensor, config_id=self.config_id)
        finished = time.monotonic()
        slot.timings = {'pre_ms': (finished - start) * 1000,
                        'pre_submit_ms': (launched - start) * 1000,
                        'pre_kernel_wait_ms': (completed - launched) * 1000,
                        'pre_tensor_sync_ms': (synchronized - completed) * 1000,
                        'pre_preview_copy_ms': (finished - synchronized) * 1000}

    def infer(self, slot, worker=0):
        start = time.monotonic()
        with self.active_lock:
            self.active_dpu += 1
        # A failed wait leaves active_dpu set: cleanup must not free buffers.
        job = self.runners[worker].execute_async([slot.tensor], slot.outputs)
        status = self.runners[worker].wait(job)
        if status:
            raise RuntimeError('VART wait failed: ' + str(status))
        with self.active_lock:
            self.active_dpu -= 1
        slot.timings['dpu_ms'] = (time.monotonic() - start) * 1000

    def cpu_postprocess(self, slot):
        decoded = [reference.decode_yolo_output(
            b, reference.ANCHORS[t.dims[1]], self.confidence,
            quant_scale=2.0 ** -self.output_fix[t.dims[1]]) for b, t in zip(slot.outputs, self.output_tensors)]
        boxes, scores, classes = [np.concatenate([d[i] for d in decoded]) for i in range(3)]
        keep = reference.classwise_nms(boxes, scores, classes, self.nms)
        return boxes[keep], scores[keep], classes[keep]

    def postprocess(self, slot):
        start = time.monotonic()
        # VART writes host views; make those bytes visible to HLS masters.
        slot.packed.flush()
        status = self.post.run(self.post_args[slot.index])
        count = self.post.read('detection_count')
        candidates = self.post.read('candidate_count')
        if status == 2:
            boxes, scores, classes = self.cpu_postprocess(slot)
        elif status == 0 and 0 <= count <= post.MAX_CANDIDATES:
            self.detections.invalidate()
            records = np.asarray(self.detections).view('<u4').reshape(-1, 8)[:count]
            boxes = records[:, :4].copy().view('<i4').astype(np.float32) / 256
            scores = records[:, 4].astype(np.float32) / 2**30
            classes = records[:, 5].astype(np.int32)
            if np.any(classes >= 80):
                raise RuntimeError('Invalid HLS class ID')
        else:
            raise RuntimeError('Postprocessing status/count mismatch: ' + str((status, count)))
        boxes = reference.map_boxes_to_original(boxes, .65, 0, 52, 640, 480)
        slot.timings['post_ms'] = (time.monotonic() - start) * 1000
        return boxes, scores, classes, status == 2, candidates

    def safe_to_release(self):
        return not self.active_dpu and not any(c and c.busy for c in (self.pre, self.post))

    def close(self):
        if not self.safe_to_release():
            raise RuntimeError('Accelerator active: cannot release DMA buffers')
        # Drop all views before freeing parent allocations.
        for s in getattr(self, 'slots', []):
            s.outputs.clear()
        for b in reversed(self.allocations):
            b.freebuffer()
        self.allocations.clear()
        self.runners.clear()
        self.overlay.runner = None


def self_test(hw):
    """Exercise DMA, color order, quantization, NMS, overflow and DPU completion."""
    s = hw.slots[0]
    s.sequence = 42
    s.frame = np.empty((480, 640, 3), np.uint8)
    s.frame[:] = (20, 100, 220)
    hw.preprocess(s)
    lut = np.frombuffer(pre.make_luts(fix_point=hw.fix)[256:], np.int8)
    expected = np.empty((1, 416, 416, 3), np.int8)
    expected[:] = lut[128]
    expected[:, 52:364, :, :] = lut[[220, 100, 20]]
    np.testing.assert_array_equal(s.tensor, expected)
    # A spatially varying frame exercises bilinear sampling, not just padding.
    # HLS rounds its Q22 interpolation once; OpenCV can round intermediate
    # stages differently. Check the observed INT8 bound for this seeded frame.
    s.frame = np.random.default_rng(20261014).integers(0, 256, (480, 640, 3), dtype=np.uint8)
    hw.preprocess(s)
    rgb, _, _, _ = reference.letterbox_image(s.frame)
    cpu_tensor = reference.quantize_input(rgb, hw.fix)
    difference = np.abs(np.asarray(s.tensor)[0].astype(np.int16) - cpu_tensor.astype(np.int16))
    assert difference.max() <= 1, 'seeded resize exceeds one INT8 unit vs OpenCV'
    np.testing.assert_array_equal(s.tensor[0, :52], expected[0, :52])
    np.testing.assert_array_equal(s.tensor[0, 364:], expected[0, 364:])
    resize_check = dict(max_int8_difference=int(difference.max()),
                        differing_bytes=int(np.count_nonzero(difference)),
                        compared_bytes=int(difference.size))
    # Two overlapping same-class boxes on the finest grid must collapse to one.
    s.packed.fill(128)  # INT8 -128: all background
    head = next(b for b in s.outputs if b.shape[1] == 52).reshape(52, 52, 3, 85)
    for anchor in (0, 1):
        head[20, 20, anchor, :4] = 0
        head[20, 20, anchor, 4] = 20
        head[20, 20, anchor, 5] = 20
    # Equalize the second anchor's size to the first approximately.
    head[20, 20, 1, 2:4] = np.rint(np.log(np.array([10/16, 13/30])) * 2**hw.output_fix[52]).astype(np.int8)
    # Distinct scores avoid testing unspecified equal-score NMS ordering.
    head[20, 20, 1, 4:6] = 16
    boxes, scores, classes, fallback, candidates = hw.postprocess(s)
    assert candidates == 2 and len(boxes) == 1 and classes[0] == 0 and not fallback
    cpu = hw.cpu_postprocess(s)
    mapped = reference.map_boxes_to_original(cpu[0], .65, 0, 52, 640, 480)
    np.testing.assert_allclose(boxes, mapped, atol=.03)
    np.testing.assert_allclose(scores, cpu[1], atol=1e-4)
    # Exercise every scale/anchor LUT, signed coordinates/logits and class IDs.
    s.packed.fill(128)
    for scale_index, grid in enumerate(post.GRIDS):
        view = next(b for b in s.outputs if b.shape[1] == grid).reshape(grid, grid, 3, 85)
        for anchor in range(3):
            values = view[grid // 2, grid // 2, anchor]
            values[:4] = (-1, 2, -3, 1)
            values[4] = 20
            values[5 + scale_index * 3 + anchor] = 20 - scale_index * 3 - anchor
    boxes, scores, classes, fallback, candidates = hw.postprocess(s)
    cpu = hw.cpu_postprocess(s)
    mapped = reference.map_boxes_to_original(cpu[0], .65, 0, 52, 640, 480)
    assert candidates == 9 and len(boxes) == 9 and not fallback
    np.testing.assert_array_equal(classes, cpu[2])
    np.testing.assert_allclose(boxes, mapped, atol=.03)
    np.testing.assert_allclose(scores, cpu[1], atol=1e-4)
    # 257 separated/tied candidates: force whole-frame software fallback.
    s.packed.fill(128)
    flat = head.reshape(-1, 85)
    flat[:257, :4] = 0
    flat[:257, 4:6] = 20
    boxes, scores, classes, fallback, _ = hw.postprocess(s)
    assert fallback, 'overflow must not silently truncate detections'
    cpu = hw.cpu_postprocess(s)
    np.testing.assert_array_equal(boxes, reference.map_boxes_to_original(cpu[0], .65, 0, 52, 640, 480))
    np.testing.assert_array_equal(scores, cpu[1])
    np.testing.assert_array_equal(classes, cpu[2])
    hw.infer(s)
    result = hw.postprocess(s)
    print('SELF_TEST_OK ' + json.dumps(dict(
        checks=['pre_dma_rgb_padding_quantization', 'pre_seeded_resize_vs_opencv',
                'post_decode_nms_vs_cpu', 'post_all_scales_anchors_vs_cpu',
                'overflow_whole_frame_fallback', 'dpu_execution'],
        resize_check=resize_check, dpu_ms=s.timings['dpu_ms'],
        detections=len(result[0]), memory_kib=memory_kib())), flush=True)