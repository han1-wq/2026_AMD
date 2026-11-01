"""Host-side ABI helpers. No PYNQ import is needed to validate a frame request.

The generated HLS register map is authoritative; do not hardcode AXI-Lite offsets.
All four buffers must remain owned by this invocation until completion.
"""
from dataclasses import dataclass
import math

ABI_VERSION = 0x00010000
TARGET = 416
MAX_WIDTH = 1920
MAX_HEIGHT = 1080
TENSOR_BYTES = TARGET * TARGET * 3
TENSOR_ONLY, PREVIEW_ONLY, TENSOR_AND_PREVIEW = range(3)
EQ_OFF, EQ_CURRENT, EQ_PREVIOUS = range(3)
COLOR_LUT, SATURATION, ENHANCE_TENSOR, RESET_HISTORY = 1, 2, 4, 8


@dataclass(frozen=True)
class Buffer:
    device_address: int
    capacity: int


def make_luts(contrast=1.0, brightness=0, fix_point=6):
    """Return exactly 512 bytes: unsigned color LUT then signed INT8 bit patterns."""
    if not math.isfinite(contrast) or not 0 <= contrast <= 4:
        raise ValueError("contrast must be finite and in [0, 4]")
    if not isinstance(brightness, int) or not -255 <= brightness <= 255:
        raise ValueError("brightness must be an integer in [-255, 255]")
    if not isinstance(fix_point, int) or not -16 <= fix_point <= 16:
        raise ValueError("validated host fix_point range is [-16, 16]")
    color = bytes(max(0, min(255, round(contrast*(v-128)+128+brightness))) for v in range(256))
    quant = bytes(max(-128, min(127, round(math.ldexp(v, fix_point-8)))) & 255 for v in range(256))
    return color + quant


def frame_arguments(*, source, tensor, preview, luts, width=640, height=480,
                    src_stride=None, preview_stride=None, output_mode=TENSOR_ONLY,
                    flags=0, eq_mode=EQ_OFF, saturation=1.0, frame_id=0, config_id=0):
    """Validate physical buffers and return scalar/pointer values by HLS port name.

    Keep valid, nonoverlapping allocations even for a disabled output. Increment
    config_id whenever the color LUT changes. Assert RESET_HISTORY after reset.
    The caller is responsible for cache maintenance, register writes and timeout.
    """
    if not (isinstance(width, int) and isinstance(height, int)
            and TARGET <= width <= MAX_WIDTH and TARGET <= height <= MAX_HEIGHT):
        raise ValueError("unsupported dimensions")
    if output_mode not in (TENSOR_ONLY, PREVIEW_ONLY, TENSOR_AND_PREVIEW):
        raise ValueError("invalid output mode")
    if eq_mode not in (EQ_OFF, EQ_CURRENT, EQ_PREVIOUS) or flags < 0 or flags & ~15:
        raise ValueError("invalid equalization mode or flags")
    if not math.isfinite(saturation) or not 0 <= saturation <= 2:
        raise ValueError("saturation must be finite and in [0, 2]")
    stride = (width*3+15) & ~15
    src_stride = stride if src_stride is None else src_stride
    preview_stride = stride if preview_stride is None else preview_stride
    for value in (src_stride, preview_stride):
        if not isinstance(value, int) or value % 16 or not width*3 <= value <= MAX_WIDTH*3:
            raise ValueError("stride must be aligned to 16 and fit the hardware limit")
    buffers = (source, tensor, preview, luts)
    for buf in buffers:
        if (not isinstance(buf.device_address, int) or not isinstance(buf.capacity, int)
                or buf.device_address <= 0 or buf.device_address % 64
                or buf.capacity <= 0 or buf.capacity >= 2**32
                or buf.device_address + buf.capacity > 2**40):
            raise ValueError("invalid aligned device address or capacity")
    for i, a in enumerate(buffers):
        for b in buffers[i+1:]:
            if max(a.device_address, b.device_address) < min(a.device_address+a.capacity, b.device_address+b.capacity):
                raise ValueError("input/output/LUT allocations must not overlap")
    if (source.capacity < src_stride*height or luts.capacity < 512
            or (output_mode != PREVIEW_ONLY and tensor.capacity < TENSOR_BYTES)
            or (output_mode != TENSOR_ONLY and preview.capacity < preview_stride*height)):
        raise ValueError("insufficient capacity")
    for value in (frame_id, config_id):
        if not isinstance(value, int) or not 0 <= value < 2**32:
            raise ValueError("frame/config id must fit uint32")
    scale = min(TARGET/width, TARGET/height)
    rw, rh = round(width*scale), round(height*scale)
    return dict(src=source.device_address, tensor=tensor.device_address,
                preview=preview.device_address, luts=luts.device_address,
                width=width, height=height, src_stride=src_stride,
                src_capacity=source.capacity, tensor_capacity=tensor.capacity,
                preview_stride=preview_stride, preview_capacity=preview.capacity,
                resized_w=rw, resized_h=rh, pad_x=(TARGET-rw)//2, pad_y=(TARGET-rh)//2,
                output_mode=output_mode, flags=flags, eq_mode=eq_mode,
                saturation_q12=round(saturation*4096), frame_id=frame_id, config_id=config_id)