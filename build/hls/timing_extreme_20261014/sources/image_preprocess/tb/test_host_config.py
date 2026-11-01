import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "host"))
from config import Buffer, frame_arguments, make_luts


class ConfigTests(unittest.TestCase):
    def buffers(self):
        return dict(source=Buffer(0x10000000, 640*480*3),
                    tensor=Buffer(0x11000000, 416*416*3),
                    preview=Buffer(0x12000000, 640*480*3),
                    luts=Buffer(0x13000000, 512))

    def test_default_geometry_and_luts(self):
        args = frame_arguments(**self.buffers())
        self.assertEqual((args["resized_w"], args["resized_h"], args["pad_x"], args["pad_y"]), (416, 312, 0, 52))
        luts = make_luts()
        self.assertEqual(luts[:256], bytes(range(256)))
        self.assertEqual([luts[256+i] for i in (2, 6, 10, 128, 255)], [0, 2, 2, 32, 64])
        self.assertEqual(make_luts(fix_point=8)[-1], 127)

    def test_overlapping_allocations(self):
        buffers = self.buffers()
        buffers["tensor"] = Buffer(0x10000040, 416*416*3)
        with self.assertRaises(ValueError):
            frame_arguments(**buffers)

    def test_capacity_alignment_dimensions(self):
        for key, value in (("source", Buffer(0x10000000, 512)),
                           ("luts", Buffer(0x13000001, 512)),
                           ("luts", Buffer(0x13000000, 256))):
            buffers = self.buffers()
            buffers[key] = value
            with self.assertRaises(ValueError):
                frame_arguments(**buffers)
        for params in ({"width": 320}, {"height": 1081}, {"src_stride": 1921},
                       {"saturation": float("nan")}, {"flags": 16}, {"frame_id": -1}):
            with self.assertRaises(ValueError):
                frame_arguments(**self.buffers(), **params)

    def test_lut_parameter_limits(self):
        self.assertEqual(set(make_luts(contrast=0, brightness=-255)[:256]), {0})
        for params in ({"contrast": float("nan")}, {"contrast": 5},
                       {"brightness": 256}, {"fix_point": 99}):
            with self.assertRaises(ValueError):
                make_luts(**params)


if __name__ == "__main__":
    unittest.main()