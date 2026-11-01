#!/usr/bin/env python3
"""Export a skill-only copy with local absolute documentation links; never edit source."""
import argparse
import json
from pathlib import Path
import shutil

from check_skills import check_catalog, contained


def export(source_skill, destination_root):
    source_skill, destination_root = Path(source_skill), Path(destination_root)
    if not source_skill.is_absolute() or not destination_root.is_absolute():
        raise ValueError('source and destination must be absolute paths')
    if destination_root.exists() or destination_root.is_symlink():
        raise ValueError('destination root must not exist; existing results are never overwritten')
    source_skill, destination_root = source_skill.resolve(), destination_root.resolve()
    if source_skill.name != 'skill' or not source_skill.is_dir():
        raise ValueError('source must be the existing skill directory')
    if destination_root.exists() or destination_root.is_symlink():
        raise ValueError('destination root must not exist; existing results are never overwritten')
    if contained(destination_root, source_skill.parent):
        raise ValueError('destination must be outside the source package')
    for path in source_skill.rglob('*'):
        if path.is_symlink() or not (path.is_file() or path.is_dir()):
            raise ValueError('skill export does not support symlinks or special files: ' + str(path))
    before = check_catalog(source_skill.parent, standalone=True)
    if not before['ok']:
        raise ValueError('source skill check failed: ' + '; '.join(before['errors']))
    catalog = json.loads((source_skill / 'catalog.json').read_text(encoding='utf-8'))
    origin = catalog['package_root']
    destination_root.mkdir()  # exclusive; caller creates any missing parent first
    target = destination_root / 'skill'
    shutil.copytree(source_skill, target, ignore=shutil.ignore_patterns('__pycache__', '*.pyc'))
    rewritten = []
    for path in target.rglob('*.md'):
        if contained(path, target / 'imported'):
            continue
        text = path.read_text(encoding='utf-8')
        updated = text.replace(origin + '/', str(destination_root) + '/')
        if updated != text:
            path.write_text(updated, encoding='utf-8')
            rewritten.append(str(path))
    def relocate(value):
        if isinstance(value, dict):
            return {key: relocate(item) for key, item in value.items()}
        if isinstance(value, list):
            return [relocate(item) for item in value]
        if isinstance(value, str):
            if value == origin:
                return str(destination_root)
            if value.startswith(origin + '/'):
                return str(destination_root) + value[len(origin):]
        return value
    (target / 'catalog.json').write_text(json.dumps(relocate(catalog), ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    after = check_catalog(destination_root, standalone=True)
    return {'ok': after['ok'], 'destination': str(destination_root),
            'source_modified': False, 'imported_bytes_modified': False,
            'rewritten_documents': rewritten, 'validation': after,
            'note': 'Only skill copied. External source/report references remain unavailable. Evidence JSON/logs retain historical paths; they are not rerun results.'}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source-skill', type=Path, required=True)
    parser.add_argument('--destination-root', type=Path, required=True)
    args = parser.parse_args()
    try:
        result = export(args.source_skill, args.destination_root)
    except (OSError, ValueError, TypeError, RuntimeError) as exc:
        result = {'ok': False, 'error': str(exc),
                  'note': 'If a new destination was partially created, inspect it; do not overwrite or treat it as validated.'}
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return 0 if result['ok'] else 1


if __name__ == '__main__':
    raise SystemExit(main())