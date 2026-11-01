"""Synthetic fixtures only: these tests never allocate buffers or open devices."""
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

from validate_evidence import golden, load, pynq_preflight, qor


class EvidenceTests(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory(prefix='skill-evidence-')
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)
        self.ref = {'shape': [2], 'dtype': 'int8', 'data': [1, -2]}
        self.qor = {'stage': 'implemented', 'wns_ns': 0.1, 'whs_ns': 0,
                    'unconstrained_paths': 0, 'drc_errors': 0,
                    'resources': {'LUT': {'used': 2, 'limit': 10}},
                    'source_report': self.file('synthetic.rpt', b'Synthetic fixture, not a tool report.\n')}
        self.overlay = {'bit': self.file('fixture.bit', b'NOT A BITSTREAM; TEST FIXTURE ONLY'),
                        'hwh': self.file('fixture.hwh', b'<ROOT><MODULE INSTANCE="core"/></ROOT>'),
                        'expected_instances': ['core']}

    def file(self, name, content):
        path = self.root / name
        path.write_bytes(content)
        return {'path': str(path), 'sha256': hashlib.sha256(content).hexdigest()}

    def test_equal(self):
        self.assertTrue(golden(self.ref, self.ref)['ok'])

    def test_numeric_mismatch(self):
        other = dict(self.ref, data=[1, -1])
        result = golden(self.ref, other)
        self.assertFalse(result['ok'])
        self.assertEqual(result['first_mismatch_indices'], [1])

    def test_relative_tolerance(self):
        ref = dict(self.ref, dtype='float64', data=[100, 0])
        self.assertTrue(golden(ref, dict(ref, data=[101, 0.01]), atol=.01, rtol=.01)['ok'])

    def test_reject_bad_tensor_and_tolerances(self):
        for key, value in [('shape', []), ('shape', [True]), ('shape', [3]),
                           ('dtype', 'unknown'), ('data', [True, -2]),
                           ('data', [128, -2]), ('data', [1.5, -2]),
                           ('data', [float('nan'), -2])]:
            with self.subTest(key=key, value=value), self.assertRaises(ValueError):
                golden(dict(self.ref, **{key: value}), self.ref)
        for atol in [-1, float('inf'), True]:
            with self.subTest(atol=atol), self.assertRaises(ValueError):
                golden(self.ref, self.ref, atol=atol)

    def test_dtype_and_shape_mismatch(self):
        for patch in [{'shape': [1, 2]}, {'dtype': 'int16'}]:
            with self.subTest(patch=patch), self.assertRaises(ValueError):
                golden(self.ref, dict(self.ref, **patch))

    def test_uint64_comparison_does_not_round_away_difference(self):
        ref = {'shape': [1], 'dtype': 'uint64', 'data': [2**64-1]}
        self.assertFalse(golden(ref, dict(ref, data=[2**64-2]))['ok'])

    def test_qor_pass(self):
        self.assertTrue(qor(self.qor)['ok'])

    def test_qor_reject_bad_metrics(self):
        for key, value in [('wns_ns', -.01), ('whs_ns', -.01),
                           ('unconstrained_paths', 1), ('drc_errors', 1)]:
            with self.subTest(key=key):
                self.assertFalse(qor(dict(self.qor, **{key: value}))['ok'])

    def test_qor_resource_excess(self):
        self.qor['resources']['LUT']['used'] = 11
        self.assertFalse(qor(self.qor)['ok'])

    def test_qor_invalid_stage(self):
        with self.assertRaises(ValueError):
            qor(dict(self.qor, stage='synthesis'))

    def test_qor_missing_or_invalid_metric(self):
        for key, value in [('wns_ns', float('inf')), ('drc_errors', True),
                           ('unconstrained_paths', -1), ('resources', {})]:
            with self.subTest(key=key), self.assertRaises(ValueError):
                qor(dict(self.qor, **{key: value}))
        del self.qor['whs_ns']
        with self.assertRaises(KeyError):
            qor(self.qor)

    def test_qor_reject_changed_source(self):
        Path(self.qor['source_report']['path']).write_text('changed')
        with self.assertRaises(ValueError):
            qor(self.qor)

    def test_pynq_pass_is_offline_only(self):
        result = pynq_preflight(self.overlay)
        self.assertTrue(result['ok'])
        self.assertEqual(result['scope'], 'classic-pynq-artifact-preflight-only')

    def test_pynq_missing_ip(self):
        self.overlay['expected_instances'] = ['other']
        self.assertFalse(pynq_preflight(self.overlay)['ok'])

    def test_pynq_mismatched_stem(self):
        self.overlay['hwh'] = self.file('other.hwh', b'<ROOT/>')
        with self.assertRaises(ValueError):
            pynq_preflight(self.overlay)

    def test_pynq_corruption_or_missing_file(self):
        path = Path(self.overlay['bit']['path'])
        path.write_bytes(b'changed')
        with self.assertRaises(ValueError):
            pynq_preflight(self.overlay)
        path.unlink()
        with self.assertRaises(ValueError):
            pynq_preflight(self.overlay)

    def test_pynq_reject_duplicate_ip_and_dtd(self):
        with self.assertRaises(ValueError):
            pynq_preflight(dict(self.overlay, expected_instances=['core', 'core']))
        self.overlay['hwh'] = self.file('fixture.hwh', b'<!DOCTYPE ROOT><ROOT/>')
        with self.assertRaises(ValueError):
            pynq_preflight(self.overlay)

    def test_pynq_reject_non_utf8_xml(self):
        self.overlay['hwh'] = self.file('fixture.hwh', '<ROOT/>'.encode('utf-16'))
        with self.assertRaises(ValueError):
            pynq_preflight(self.overlay)

    def test_json_nonfinite_and_duplicate_keys(self):
        path = self.root / 'bad.json'
        for text in ['{"a":NaN}', '{"a":1,"a":2}']:
            path.write_text(text)
            with self.assertRaises(ValueError):
                load(path)

    def test_cli_success_failure_and_malformed(self):
        tool = str(Path(__file__).with_name('validate_evidence.py'))
        ref, candidate = self.root / 'ref.json', self.root / 'candidate.json'
        ref.write_text(json.dumps(self.ref))
        for text, code in [(json.dumps(self.ref), 0),
                           (json.dumps(dict(self.ref, data=[2, -2])), 1), ('{bad', 1)]:
            candidate.write_text(text)
            proc = subprocess.run([sys.executable, '-B', tool, 'golden', str(ref), str(candidate)],
                                  capture_output=True, text=True, timeout=20)
            self.assertEqual(proc.returncode, code, proc.stderr)
            result = json.loads(proc.stdout)
            self.assertFalse(result['hardware_actions'])
            self.assertFalse(result['network_actions'])


if __name__ == '__main__':
    unittest.main()