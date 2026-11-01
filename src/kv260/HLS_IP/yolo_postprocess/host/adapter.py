"""Application adapter; the injected device executor owns MMIO/XRT and buffers.

execute(packed_input, tables, confidence, nms, enable_nms) must return
(status, packed_output, detection_count) AFTER device completion and invalidate.
Timeout recovery must drain/reset hardware before returning or raising; buffers
cannot be reused while a timed-out invocation might still write them.
"""
import numpy as np

from .config import INPUT_WORDS, GRIDS, make_tables, unpack_detections


def postprocess(output_buffers, output_tensors, yolo, width, height, execute,
                enable_nms=True):
    """Return boxes, scores, classes, hardware_used; whole-frame fallback on overflow.

Only standard YOLOv4 416/COCO anchors are supported. A model mismatch raises an
error before submission. Device exceptions propagate rather than hiding faults.
"""
    from .config import ANCHORS
    if type(width) is not int or type(height) is not int or width <= 0 or height <= 0:
        raise ValueError('invalid image geometry')
    if yolo.INPUT_W != 416 or yolo.INPUT_H != 416:
        raise ValueError('requires YOLOv4 416 input')
    if len(output_buffers) != 3 or len(output_tensors) != 3:
        raise ValueError('requires three output tensors')
    by_grid = {}
    for buffer, tensor in zip(output_buffers, output_tensors):
        shape = tuple(tensor.dims)
        if (len(shape) != 4 or shape[0] != 1 or shape[1] not in GRIDS
                or shape[2] != shape[1] or shape[3] != 255
                or buffer.shape != shape or buffer.dtype != np.int8
                or shape[1] in by_grid):
            raise ValueError('requires unique [1,H,H,255] INT8 outputs, H=52/26/13')
        by_grid[shape[1]] = (buffer, int(tensor.get_attr('fix_point')))
    for grid, anchors in zip(GRIDS, ANCHORS):
        if not np.array_equal(yolo.ANCHORS[grid], anchors):
            raise ValueError('unsupported model anchors')
    packed = bytearray(INPUT_WORDS*16)
    offset = 0
    for grid in GRIDS:
        raw = by_grid[grid][0].tobytes(order='C')
        packed[offset:offset+len(raw)] = raw
        offset += len(raw)
    tables = make_tables(tuple(by_grid[g][1] for g in GRIDS))
    status, output, count = execute(packed, tables, yolo.CONF_THRESHOLD,
                                    yolo.NMS_THRESHOLD, enable_nms)
    if status == 0:
        # NMS must precede clipping/mapping. Keep letterbox coordinates here.
        unpack_detections(output, count, status, width, height)  # ABI validation
        records = np.frombuffer(output, dtype='<u4', count=count*8).reshape(count,8)
        boxes = records[:,:4].copy().view('<i4').astype(np.float32)/256
        scores = records[:,4].astype(np.float32)/2**30
        classes = records[:,5].astype(np.int32)
        if not enable_nms:
            keep = yolo.classwise_nms(boxes,scores,classes,yolo.NMS_THRESHOLD)
            boxes,scores,classes = boxes[keep],scores[keep],classes[keep]
    elif status == 2:
        decoded = [yolo.decode_yolo_output(buffer, yolo.ANCHORS[g], yolo.CONF_THRESHOLD,
                    quant_scale=2.0**-fix) for g,(buffer,fix) in by_grid.items()]
        boxes,scores,classes = (np.concatenate([d[i] for d in decoded]) for i in range(3))
        keep = yolo.classwise_nms(boxes,scores,classes,yolo.NMS_THRESHOLD)
        boxes,scores,classes = boxes[keep],scores[keep],classes[keep]
    else:
        raise RuntimeError('postprocess rejected request: {}'.format(status))
    scale = min(416/width,416/height)
    px,py = (416-round(width*scale))//2,(416-round(height*scale))//2
    boxes = yolo.map_boxes_to_original(boxes,scale,px,py,width,height)
    return boxes,scores,classes,status==0