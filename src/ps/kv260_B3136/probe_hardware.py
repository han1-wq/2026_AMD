#!/usr/bin/env python3
"""One-shot deployment probe. Run before camera tests; changes the FPGA image."""
import json
from pathlib import Path
import numpy as np
from pynq import allocate
from pynq_dpu import DpuOverlay

root = Path(__file__).resolve().parent
print('Loading new overlay', flush=True)
overlay = DpuOverlay(str(root / 'overlay/dpu.bit'))
print('IPs', json.dumps({k: v.get('phys_addr') for k, v in overlay.ip_dict.items()}), flush=True)
print('Loading B3136 model', flush=True)
overlay.load_model(str(root / 'compiled/yolov4_leaky_416_tf.xmodel'))
runner = overlay.runner
for name, tensors in [('input', runner.get_input_tensors()), ('output', runner.get_output_tensors())]:
    for t in tensors:
        print(name, t.name, t.dims, str(t.dtype), t.get_attr('fix_point'), flush=True)
buffer = allocate((64,), dtype=np.uint8)
print('CMA allocation', hex(buffer.device_address), buffer.nbytes, flush=True)
buffer.freebuffer()
for name in ('image_preprocess_1', 'yolo_postprocess_1'):
    ip = getattr(overlay, name)
    print(name, 'CTRL', hex(ip.read(0)), flush=True)
print('PROBE_OK', flush=True)