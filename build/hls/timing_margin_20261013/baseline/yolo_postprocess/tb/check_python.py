"""Compare C-simulation output with actual application functions, without DPU import."""
import ast
import importlib.util
import pathlib
import struct
import sys
import unittest
from types import SimpleNamespace

import numpy as np

ROOT = pathlib.Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('post_config', ROOT / 'host/config.py')
config = importlib.util.module_from_spec(spec)
spec.loader.exec_module(config)


def application():
    path = pathlib.Path('/home/amd/x3plus-kv260-docker/vision-optimization/infer_yolov4.py')
    tree = ast.parse(path.read_text())
    names = {'sigmoid', 'decode_yolo_output', 'nms_single_class', 'classwise_nms', 'map_boxes_to_original'}
    functions = [node for node in tree.body if isinstance(node, ast.FunctionDef) and node.name in names]
    namespace = {'np': np, 'INPUT_W': 416, 'INPUT_H': 416}
    exec(compile(ast.Module(body=functions, type_ignores=[]), str(path), 'exec'), namespace)
    return namespace


class Checks(unittest.TestCase):
    def test_adapter_and_fallback(self):
        sys.path.insert(0, str(ROOT.parent))
        from yolo_postprocess.host.adapter import postprocess
        fixture = pathlib.Path(sys.argv[1]) if len(sys.argv)>1 else ROOT/'build'
        raw = np.frombuffer((fixture/'fixture_input.bin').read_bytes(),dtype=np.int8)
        output = (fixture/'fixture_output.bin').read_bytes()
        app = SimpleNamespace(**application())
        app.ANCHORS = {g:np.array(a,dtype=np.float32) for g,a in zip(config.GRIDS,config.ANCHORS)}
        app.CONF_THRESHOLD,app.NMS_THRESHOLD = .3,.6
        buffers,tensors=[],[]
        offset=0
        for grid,fix in zip(config.GRIDS,(4,5,6)):
            shape=(1,grid,grid,255)
            size=grid*grid*255
            buffers.append(raw[offset:offset+size].reshape(shape))
            tensors.append(SimpleNamespace(dims=shape,get_attr=lambda name,f=fix:f))
            offset+=size
        def execute(packed,tables,confidence,nms,enabled):
            self.assertEqual(packed[:len(raw)],raw.tobytes())
            self.assertEqual(len(packed),config.INPUT_WORDS*16)
            return 0,output,len(output)//32
        hw=postprocess(buffers,tensors,app,640,480,execute)
        sw=postprocess(buffers,tensors,app,640,480,lambda *args:(2,b'',0))
        hybrid=postprocess(buffers,tensors,app,640,480,execute,enable_nms=False)
        self.assertTrue(hw[3]);self.assertFalse(sw[3]);self.assertTrue(hybrid[3])
        self.assertEqual(len(hw[0]),len(sw[0]))
        for box,score,cls in zip(*hw[:3]):
            eligible=np.where(sw[2]==cls)[0]
            i=min(eligible,key=lambda i:np.max(abs(sw[0][i]-box)))
            self.assertLess(float(np.max(abs(sw[0][i]-box))),.011)
            self.assertLess(abs(sw[1][i]-score),.00004)
        with self.assertRaises(RuntimeError):
            postprocess(buffers,tensors,app,640,480,lambda *args:(1,b'',0))

    def test_actual_application(self):
        fixture = pathlib.Path(sys.argv[1]) if len(sys.argv)>1 else ROOT / 'build'
        raw = np.frombuffer((fixture / 'fixture_input.bin').read_bytes(), dtype=np.int8)
        records = np.frombuffer((fixture / 'fixture_output.bin').read_bytes(), dtype='<u4').reshape(-1, 8)
        app = application()
        offset = 0
        boxes, scores, classes = [], [], []
        for grid, fix, anchors in zip(config.GRIDS, (4, 5, 6), config.ANCHORS):
            size = grid*grid*255
            tensor = raw[offset:offset+size].reshape(1, grid, grid, 255)
            b, s, c = app['decode_yolo_output'](tensor, np.array(anchors, dtype=np.float32), 0.3, 2.0**-fix)
            boxes.extend(b); scores.extend(s); classes.extend(c)
            offset += size
        boxes, scores, classes = np.array(boxes), np.array(scores), np.array(classes)
        keep = app['classwise_nms'](boxes, scores, classes, 0.6)
        self.assertEqual(len(keep), len(records))
        remaining = list(keep)
        max_coord = max_score = 0
        for record in records:
            b = record[:4].view('<i4') / 256.0
            eligible = [i for i in remaining if classes[i] == record[5]]
            self.assertTrue(eligible)
            match = min(eligible, key=lambda i: np.max(np.abs(boxes[i]-b)))
            error = float(np.max(np.abs(boxes[match]-b)))
            score_error = abs(scores[match]-record[4]/2**30)
            self.assertLess(error, 0.007)
            self.assertLess(score_error, 0.00004)
            max_coord, max_score = max(max_coord, error), max(max_score, score_error)
            remaining.remove(match)
        self.assertFalse(remaining)
        self.assertEqual(config.make_tables((4,5,6)), (fixture/'fixture_tables.bin').read_bytes())
        print('Actual Python comparison: {} detections, max coordinate error {:.8f}px, score error {:.8g}'.format(len(records), max_coord, max_score))

    def test_tables_all_int8_values(self):
        for fix in (-16, -1, 0, 4, 6, 8, 16):
            tables = np.frombuffer(config.make_tables((fix,)*3), dtype='<u4').reshape(3,7,256)
            values = np.arange(256).astype(np.uint8).view(np.int8).astype(np.float64)*2.0**-fix
            sig = 1/(1+np.exp(-np.clip(values,-30,30)))
            self.assertLessEqual(float(np.max(abs(tables[:,0]/32768-sig))), 1/65536+1e-12)
            self.assertLess(int(tables[:,1:].max()), 2**30)
            scores = np.outer(tables[0,0]/32768, tables[0,0]/32768)
            exact = np.outer(sig,sig)
            self.assertLess(float(np.max(abs(scores-exact))), 0.000031)
            uncertain = np.count_nonzero((scores >= .3) != (exact >= .3))
            print('fix={} threshold .3 differing decisions={}/65536'.format(fix, uncertain))

    def test_host_contract(self):
        valid = dict(input_buffer=(0x100000, config.INPUT_WORDS*16),
                     tables_buffer=(0x300000, config.TABLE_WORDS*4),
                     output_buffer=(0x400000, 8192))
        self.assertEqual(config.arguments(**valid)['nms_q16'], 39322)
        for key, value in (('confidence', 0), ('nms', 1.1), ('confidence', float('nan')),
                           ('output_buffer', (0x400001,8192)), ('tables_buffer',(0x100000,21504)),
                           ('input_buffer',(0x100000,config.INPUT_BYTES))):
            with self.assertRaises(ValueError): config.arguments(**dict(valid, **{key:value}))
        with self.assertRaises(RuntimeError): config.unpack_detections(b'',0,2)
        record = struct.pack('<4i4I',0,52*256,416*256,364*256,1<<29,2,0,0)
        result = config.unpack_detections(record,1,0)[0]
        self.assertEqual(result[:3], ([0,0,639,479], .5, 2))


if __name__ == '__main__':
    unittest.main(argv=[sys.argv[0]])