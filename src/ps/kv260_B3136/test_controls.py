"""Desktop inputs cannot silently bypass the accelerator's scalar limits."""
import json
import tempfile
import unittest
from pathlib import Path
from runtime.controls import Controls, ControlReader, write_json


class ControlTests(unittest.TestCase):
    def test_hardware_limits(self):
        self.assertEqual(Controls.parse(dict(brightness=-255, contrast=4, saturation=2, eq_mode=2)).brightness, -255)
        for values in (dict(contrast=float('nan')), dict(saturation=2.01), dict(brightness=2.5),
                       dict(eq_mode=True), dict(eq_mode=3), dict(enhance_tensor=1), dict(foo=2)):
            with self.subTest(values=values), self.assertRaises(ValueError):
                Controls.parse(values)

    def test_atomic_updates_and_rejected_update_retains_last_good(self):
        with tempfile.TemporaryDirectory() as directory:
            reader = ControlReader(directory)
            path = Path(directory)/'controls.json'
            write_json(path, dict(brightness=30, eq_mode=2))
            self.assertEqual(reader.read().brightness, 30)
            path.write_text('{broken')
            self.assertEqual(reader.read().brightness, 30)
            write_json(path, dict(saturation=0))
            self.assertEqual(reader.read().saturation, 0)
            self.assertFalse(path.with_name('controls.json.tmp').exists())


if __name__ == '__main__':
    unittest.main()