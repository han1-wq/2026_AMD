"""Validated YOLOv4 416/COCO postprocessing ABI; no board dependencies.

Caller owns cache synchronization, completion/timeout and whole-frame software
fallback. Never treat a NumPy virtual pointer as a physical device address.
"""
import math
import struct
from functools import lru_cache

GRIDS = (52, 26, 13)
ANCHORS = (((10, 13), (16, 30), (33, 23)),
           ((30, 61), (62, 45), (59, 119)),
           ((116, 90), (156, 198), (373, 326)))
INPUT_BYTES = 10647 * 85
INPUT_WORDS = (INPUT_BYTES + 15) // 16
MAX_CANDIDATES = 256
TABLE_WORDS = 5376


@lru_cache(maxsize=16)
def make_tables(fix_points):
    """Three output fix_points, ordered 52/26/13. Return little-endian u32 LUTs."""
    if len(fix_points) != 3 or any(type(f) is not int or not -16 <= f <= 16 for f in fix_points):
        raise ValueError("three integer output fix_points in [-16,16] required")
    words = []
    for fix, anchors in zip(fix_points, ANCHORS):
        values = [math.ldexp(v if v < 128 else v-256, -fix) for v in range(256)]
        words.extend(round(32768 / (1 + math.exp(-max(-30, min(30, v))))) for v in values)
        for anchor in anchors:
            for dimension in anchor:
                words.extend(round(math.exp(max(-10, min(10, v))) * dimension * 128) for v in values)
    return struct.pack('<{}I'.format(len(words)), *words)


def arguments(*, input_buffer, tables_buffer, output_buffer,
              confidence=0.30, nms=0.60, enable_nms=True):
    """Buffers are (physical address, allocated byte capacity), disjoint/aligned."""
    buffers = (input_buffer, tables_buffer, output_buffer)
    for address, capacity in buffers:
        if (type(address) is not int or type(capacity) is not int or address <= 0
                or address % 64 or capacity <= 0 or capacity >= 2**32
                or address+capacity > 2**40):
            raise ValueError("invalid device buffer")
    for i, (a, size) in enumerate(buffers):
        for b, other in buffers[i+1:]:
            if max(a, b) < min(a+size, b+other):
                raise ValueError("device buffers overlap")
    for buf, minimum in zip(buffers, (INPUT_WORDS*16, TABLE_WORDS*4, MAX_CANDIDATES*32)):
        if buf[1] < minimum:
            raise ValueError("insufficient capacity")
    if not math.isfinite(confidence) or not 0 < confidence <= 1:
        raise ValueError("invalid confidence")
    if not math.isfinite(nms) or not 0 <= nms <= 1 or type(enable_nms) is not bool:
        raise ValueError("invalid NMS configuration")
    return dict(input=input_buffer[0], tables=tables_buffer[0], output=output_buffer[0],
                input_words=input_buffer[1]//16, table_words=tables_buffer[1]//4,
                output_capacity=output_buffer[1]//32,
                confidence_q30=max(1, round(confidence*2**30)),
                nms_q16=round(nms*65536), enable_nms=int(enable_nms))


def unpack_detections(data, count, status, width=640, height=480):
    """Restore coordinates AFTER NMS, matching the software operation order."""
    if status != 0:
        raise RuntimeError("postprocess status {}; run software on the entire frame".format(status))
    if type(count) is not int or not 0 <= count <= MAX_CANDIDATES or len(data) < count*32:
        raise ValueError("invalid detection buffer")
    if type(width) is not int or type(height) is not int or width <= 0 or height <= 0:
        raise ValueError("invalid image geometry")
    scale = min(416/width, 416/height)
    px, py = (416-round(width*scale))//2, (416-round(height*scale))//2
    result = []
    for i in range(count):
        x1, y1, x2, y2, score, cls, anchor, _ = struct.unpack_from('<4i4I', data, i*32)
        box = [max(0, min(limit-1, (v/256-pad)/scale))
               for v, pad, limit in zip((x1, y1, x2, y2), (px, py, px, py),
                                        (width, height, width, height))]
        result.append((box, score/2**30, cls, anchor))
    return result