#!/usr/bin/env python3
"""Check local skill structure and references; never execute documented commands."""
import argparse
import hashlib
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[2]
SECTIONS = (
    '适用场景', '输入与前置条件', '权威来源', '执行流程',
    '验收与输出', '常见故障', '禁止与停止条件', '调用示例',
    '复用方法', '已验证效果', '经验来源',
)
LINK = re.compile(r'\[[^\]\n]+\]\(([^)\n]+)\)')
NAME = re.compile(r'[a-z0-9]+(?:-[a-z0-9]+)*\Z')


def contained(path, root):
    """Resolve symlinks without accepting paths outside the chosen package."""
    try:
        path.resolve().relative_to(root.resolve())
        return True
    except (ValueError, OSError, RuntimeError):
        return False


def markdown_errors(path, root, required=False, origin=None, standalone=False,
                    external=None):
    errors = []
    text = path.read_text(encoding='utf-8')
    lines = text.splitlines()
    if sum(line.startswith('```') for line in lines) % 2:
        errors.append('unclosed code fence')
    name = None
    if required:
        if not lines or lines[0] != '---' or '---' not in lines[1:]:
            errors.append('missing frontmatter')
        else:
            end = lines.index('---', 1)
            fields = {}
            for line in lines[1:end]:
                key, separator, value = line.partition(':')
                if not separator or key in fields:
                    errors.append('invalid or duplicate frontmatter field')
                else:
                    fields[key] = value.strip()
            name = fields.get('name', '')
            if not NAME.fullmatch(name):
                errors.append('invalid skill name')
            if not fields.get('description'):
                errors.append('missing description')
        for section in SECTIONS:
            marker = '## ' + section
            if marker not in lines:
                errors.append('missing section: ' + section)
                continue
            start = lines.index(marker) + 1
            stop = next((i for i in range(start, len(lines))
                         if lines[i].startswith('## ')), len(lines))
            if not '\n'.join(lines[start:stop]).strip():
                errors.append('empty section: ' + section)
        for heading in ('权威来源', '已验证效果', '经验来源'):
            if '## ' + heading not in lines:
                continue
            start = lines.index('## ' + heading) + 1
            stop = next((i for i in range(start, len(lines))
                         if lines[i].startswith('## ')), len(lines))
            if not LINK.search('\n'.join(lines[start:stop])):
                errors.append(heading + ' section has no reference')
    for target in LINK.findall(text):
        if target.startswith(('https://', 'http://', 'mailto:', '#')):
            continue
        destination = Path(target.split('#', 1)[0])
        if not destination.is_absolute():
            errors.append('reference must be absolute: ' + target)
            continue
        if origin is not None:
            try:
                destination = root / destination.relative_to(origin)
            except ValueError:
                errors.append('reference outside declared origin: ' + target)
                continue
        # Check lexical scope before resolving: an external source link may be
        # absent in a skill-only copy, but a skill symlink must never escape.
        if standalone:
            try:
                relative = destination.relative_to(root)
            except ValueError:
                errors.append('reference escapes package: ' + target)
                continue
            if '..' in relative.parts:
                errors.append('reference escapes package: ' + target)
                continue
            if not relative.parts or relative.parts[0] != 'skill':
                if external is not None:
                    external.add(target)
                continue
        boundary = root / 'skill' if standalone else root
        if not contained(destination, boundary):
            errors.append('reference escapes package: ' + target)
        elif not destination.exists():
            errors.append('missing reference: ' + target)
    return name, errors


def check_catalog(root, relocate=False, standalone=False):
    root = Path(root).resolve()
    skill_root = root / 'skill'
    errors, documents, imported_paths = [], set(), set()
    module_count = 0
    external = set()
    try:
        catalog = json.loads((skill_root / 'catalog.json').read_text(encoding='utf-8'))
        if not isinstance(catalog, dict) or catalog.get('schema_version') != 1:
            raise ValueError('unsupported catalog schema')
        declared = catalog.get('package_root')
        if not isinstance(declared, str) or not Path(declared).is_absolute():
            raise ValueError('package_root must be an absolute provenance path')
        origin = Path(declared) if relocate or standalone else None
        if origin is None and declared != str(root):
            errors.append('catalog package_root differs from requested root')
        entries = catalog.get('modules')
        if not isinstance(entries, list) or not entries:
            raise ValueError('modules must be a nonempty list')
        module_count = len(entries)

        def registered_path(raw):
            if not isinstance(raw, str) or not raw:
                raise ValueError('catalog path must be a nonempty string')
            path = Path(raw)
            if origin is not None:
                try:
                    path = root / path.relative_to(origin)
                except ValueError:
                    raise ValueError('catalog path outside declared origin: ' + raw)
            if not path.is_absolute() or not contained(path, skill_root):
                raise ValueError('catalog path must stay inside skill directory: ' + raw)
            if not path.is_file():
                raise ValueError('catalog file missing: ' + raw)
            if path in documents:
                raise ValueError('duplicate catalog path: ' + raw)
            documents.add(path)
            return path

        router = registered_path(catalog.get('router'))
        name, issues = markdown_errors(router, root, required=True,
                                      origin=origin, standalone=standalone, external=external)
        errors.extend(str(router) + ': ' + issue for issue in issues)
        names, ids, module_paths = {name}, set(), set()
        for entry in entries:
            if not isinstance(entry, dict):
                raise ValueError('module entry must be an object')
            identifier = entry.get('id', '')
            if not isinstance(identifier, str) or not NAME.fullmatch(identifier):
                raise ValueError('invalid module id')
            if identifier in ids:
                errors.append('duplicate module id: ' + identifier)
            ids.add(identifier)
            if entry.get('default_scope') not in ('read-only', 'offline'):
                errors.append('unsafe or unknown default scope: ' + identifier)
            path = registered_path(entry.get('path'))
            module_paths.add(path)
            if path != skill_root / identifier / 'SKILL.md':
                errors.append('module path does not match id: ' + identifier)
            name, issues = markdown_errors(path, root, required=True,
                                          origin=origin, standalone=standalone, external=external)
            errors.extend(str(path) + ': ' + issue for issue in issues)
            if name in names:
                errors.append('duplicate skill name: ' + str(name))
            names.add(name)
            if name != entry.get('name'):
                errors.append('frontmatter/catalog name mismatch: ' + identifier)
        imported = catalog.get('imported', [])
        support = catalog.get('supporting_documents', [])
        if not isinstance(imported, list) or not isinstance(support, list):
            raise ValueError('imported and supporting_documents must be lists')
        for entry in imported:
            if not isinstance(entry, dict):
                raise ValueError('imported entry must be an object')
            path = registered_path(entry.get('path'))
            if not contained(path, skill_root / 'imported'):
                errors.append('imported document outside imported directory')
            imported_paths.add(path)
            if hashlib.sha256(path.read_bytes()).hexdigest() != entry.get('sha256'):
                errors.append('imported hash mismatch: ' + str(path))
        for raw in support:
            path = registered_path(raw)
            _, issues = markdown_errors(path, root, origin=origin,
                                       standalone=standalone, external=external)
            errors.extend(str(path) + ': ' + issue for issue in issues)
        expected = module_paths | imported_paths | {router}
        actual = set(skill_root.rglob('SKILL.md'))
        for path in sorted(actual - expected):
            errors.append('unregistered SKILL.md: ' + str(path))
        for path in sorted(set(skill_root.rglob('*.md')) - documents):
            errors.append('unregistered markdown: ' + str(path))
    except (OSError, ValueError, TypeError, RuntimeError) as exc:
        errors.append(str(exc))
    return {
        'ok': not errors,
        'package_root': str(root),
        'modules': module_count,
        'documents_checked': len(documents),
        'imported_documents': len(imported_paths),
        'hardware_actions': False,
        'documented_commands_executed': False,
        'validation_scope': 'skill-only' if standalone else 'full-package-references',
        'external_references_not_checked': sorted(external),
        'errors': errors,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--root', type=Path, default=ROOT,
                        help='Absolute parent directory of skill')
    parser.add_argument('--relocate', action='store_true',
                        help='Map catalog provenance root to --root without editing sources')
    parser.add_argument('--standalone', action='store_true',
                        help='Check skill-only copy; list external evidence links as unchecked')
    args = parser.parse_args()
    result = check_catalog(args.root, relocate=args.relocate, standalone=args.standalone)
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return 0 if result['ok'] else 1


if __name__ == '__main__':
    raise SystemExit(main())