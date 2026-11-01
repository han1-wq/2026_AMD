#!/usr/bin/env python3
"""Compare HLS C simulation output with the application's OpenCV/NumPy path."""
import argparse
from pathlib import Path
import sys

import cv2
import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "host"))
from config import make_luts


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("directory", type=Path)
    args = parser.parse_args()
    for fix_point in (-16, -1, 0, 4, 6, 7, 8, 12, 16):
        expected_lut = np.clip(
            np.round(np.arange(256, dtype=np.float32) / 256.0 * float(2**fix_point)),
            -128, 127,
        ).astype(np.int8).tobytes()
        if make_luts(fix_point=fix_point)[256:] != expected_lut:
            raise SystemExit("FAIL: quantization LUT mismatch at fix_point=" + str(fix_point))
    print("PASS: 256-entry quantization LUTs match NumPy at 9 fix_point settings")
    image = np.fromfile(args.directory / "opencv_source.bgr", dtype=np.uint8).reshape(480, 640, 3)
    actual = np.fromfile(args.directory / "opencv_tensor.int8", dtype=np.int8).reshape(416, 416, 3)
    canvas = np.full((416, 416, 3), 128, dtype=np.uint8)
    canvas[52:364] = cv2.resize(image, (416, 312), interpolation=cv2.INTER_LINEAR)
    rgb = cv2.cvtColor(canvas, cv2.COLOR_BGR2RGB)
    lut = np.clip(np.round(np.arange(256, dtype=np.float32) / 256.0 * 64.0), -128, 127).astype(np.int8)
    expected = lut[rgb]
    error = np.abs(actual.astype(np.int16) - expected.astype(np.int16))
    print("OpenCV:", cv2.__version__, "NumPy:", np.__version__)
    print("Compared bytes:", error.size)
    print("Differing bytes:", np.count_nonzero(error))
    print("Maximum INT8 error:", error.max())
    print("Mean absolute INT8 error:", error.mean())
    if error.max() > 1:
        raise SystemExit("FAIL: error exceeds 1 quantized LSB")
    if np.any(actual[:52] != 32) or np.any(actual[364:] != 32):
        raise SystemExit("FAIL: padding mismatch")
    print("PASS: numeric bound and padding; this does not certify model accuracy")


if __name__ == "__main__":
    main()