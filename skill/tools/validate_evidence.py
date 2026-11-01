#!/usr/bin/env python3
"""Offline evidence gates; standard library only, no PYNQ import or device access."""
import argparse
from decimal import Decimal
import hashlib
import json
import math
from pathlib import Path
import re
import xml.etree.ElementTree as ET


def number(value, name, nonnegative=False):
    if type(value) not in (int, float) or not math.isfinite(value):
        raise ValueError(name + ' must be a finite number, not bool/string')
    if nonnegative and value < 0:
        raise ValueError(name + ' must be nonnegative')
    return value


def load(path):
    def reject_constant(value):
        raise ValueError('nonfinite JSON constant: ' + value)
    def unique(pairs):
        result = {}
        for key, value in pairs:
            if key in result:
                raise ValueError('duplicate JSON key: ' + key)
            result[key] = value
        return result
    return json.loads(Path(path).read_text(encoding='utf-8'),
                      parse_constant=reject_constant, object_pairs_hook=unique)


def tensor(document):
    shape, data = document['shape'], document['data']
    if not isinstance(shape, list) or not shape or any(type(n) is not int or n <= 0 for n in shape):
        raise ValueError('shape must be a nonempty list of positive integers')
    count = math.prod(shape)
    if not isinstance(data, list) or len(data) != count:
        raise ValueError('flat data count differs from shape')
    dtype = document['dtype']
    match = re.fullmatch(r'(u?int)(8|16|32|64)', dtype)
    if not match and dtype not in ('float32', 'float64'):
        raise ValueError('unsupported dtype')
    for value in data:
        number(value, 'tensor value')
        if match:
            bits = int(match.group(2))
            low = 0 if match.group(1) == 'uint' else -(2 ** (bits - 1))
            high = 2 ** bits - 1 if low == 0 else 2 ** (bits - 1) - 1
            if type(value) is not int or not low <= value <= high:
                raise ValueError('integer tensor value outside dtype range')
    return shape, dtype, data


def golden(reference, candidate, atol=0.0, rtol=0.0):
    number(atol, 'atol', True)
    number(rtol, 'rtol', True)
    shape, dtype, expected = tensor(reference)
    other_shape, other_dtype, actual = tensor(candidate)
    if (shape, dtype) != (other_shape, other_dtype):
        raise ValueError('shape or dtype mismatch')
    absolute, relative = Decimal(str(atol)), Decimal(str(rtol))
    bad, maximum = [], Decimal(0)
    failures = 0
    for index, (want, got) in enumerate(zip(expected, actual)):
        want, got = Decimal(str(want)), Decimal(str(got))
        error = abs(got - want)
        maximum = max(maximum, error)
        if error > absolute + relative * abs(want):
            failures += 1
            if len(bad) < 20:
                bad.append(index)
    return {'ok': failures == 0, 'scope': 'numeric-values-only',
            'elements': len(actual), 'mismatches': failures,
            'first_mismatch_indices': bad, 'max_abs_error': str(maximum),
            'atol': atol, 'rtol': rtol,
            'limitations': 'No tensor layout, model accuracy or golden independence verification.'}


def checked_file(record):
    path = Path(record['path'])
    if not path.is_absolute() or not path.is_file() or path.stat().st_size == 0:
        raise ValueError('evidence file must be a nonempty regular file at an absolute path')
    expected = record['sha256']
    if not isinstance(expected, str) or not re.fullmatch('[0-9a-f]{64}', expected):
        raise ValueError('expected sha256 must come from a trusted manifest')
    digest = hashlib.sha256()
    with path.open('rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            digest.update(block)
    if digest.hexdigest() != expected:
        raise ValueError('evidence sha256 mismatch: ' + str(path))
    return path


def qor(document):
    source = checked_file(document['source_report'])
    if document['stage'] != 'implemented':
        raise ValueError('requires implemented report; HLS/synthesis is not routed timing')
    problems = []
    for metric in ('wns_ns', 'whs_ns'):
        if number(document[metric], metric) < 0:
            problems.append(metric + ' is negative')
    for metric in ('unconstrained_paths', 'drc_errors'):
        value = document[metric]
        if type(value) is not int or value < 0:
            raise ValueError(metric + ' must be a nonnegative integer')
        if value != 0:
            problems.append(metric + ' is not zero')
    resources = document['resources']
    if not isinstance(resources, dict) or not resources:
        raise ValueError('resources must be a nonempty mapping')
    for name, entry in resources.items():
        used = number(entry['used'], name + '.used', True)
        limit = number(entry['limit'], name + '.limit', True)
        if limit <= 0:
            raise ValueError('resource limit must be positive')
        if used > limit:
            problems.append(name + ' exceeds limit')
    return {'ok': not problems, 'scope': 'user-transcribed-qor-gates',
            'source_report': str(source), 'problems': problems,
            'limitations': 'Does not parse source report or verify transcription, CDC, constraint coverage or bitstream provenance.'}


def pynq_preflight(document):
    bit, hwh = checked_file(document['bit']), checked_file(document['hwh'])
    if bit.suffix != '.bit' or hwh != bit.with_suffix('.hwh'):
        raise ValueError('classic PYNQ preflight requires colocated same-stem .bit/.hwh')
    raw = hwh.read_text(encoding='utf-8')
    if '\x00' in raw or '<!DOCTYPE' in raw.upper() or '<!ENTITY' in raw.upper():
        raise ValueError('HWH DTD/entity declarations are not supported')
    root = ET.fromstring(raw)
    names = {m.get('INSTANCE') for m in root.iter('MODULE') if m.get('INSTANCE')}
    expected = document['expected_instances']
    if (not isinstance(expected, list) or not expected or
            any(not isinstance(name, str) or not name for name in expected) or
            len(set(expected)) != len(expected)):
        raise ValueError('expected_instances must contain unique nonempty strings')
    missing = sorted(set(expected) - names)
    return {'ok': not missing, 'scope': 'classic-pynq-artifact-preflight-only',
            'missing_instances': missing, 'instances_checked': expected,
            'limitations': 'No device compatibility, IP ABI, bit/HWH semantic pairing, allocation, DMA or board execution verification.'}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest='mode', required=True)
    compare = sub.add_parser('golden')
    compare.add_argument('reference', type=Path)
    compare.add_argument('candidate', type=Path)
    compare.add_argument('--atol', type=float, default=0.0)
    compare.add_argument('--rtol', type=float, default=0.0)
    for mode in ('qor', 'pynq'):
        sub.add_parser(mode).add_argument('contract', type=Path)
    args = parser.parse_args()
    try:
        if args.mode == 'golden':
            result = golden(load(args.reference), load(args.candidate), args.atol, args.rtol)
        else:
            result = {'qor': qor, 'pynq': pynq_preflight}[args.mode](load(args.contract))
    except (OSError, ValueError, TypeError, KeyError, OverflowError, ET.ParseError) as exc:
        result = {'ok': False, 'scope': args.mode, 'error': str(exc)}
    result.update(hardware_actions=False, network_actions=False)
    print(json.dumps(result, ensure_ascii=False, indent=2, allow_nan=False))
    return 0 if result['ok'] else 1


if __name__ == '__main__':
    raise SystemExit(main())