"""Export tests use isolated fixture trees, never the real delivery package."""
import hashlib
import json
from pathlib import Path
import tempfile
import unittest

from check_skills import SECTIONS, check_catalog
from export_skills import export


class ExportTests(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory(prefix='skill-export-test-')
        self.addCleanup(temporary.cleanup)
        self.base = Path(temporary.name)
        self.root = self.base / 'original'
        self.skill = self.root / 'skill'
        module = self.skill / 'fixture' / 'SKILL.md'
        module.parent.mkdir(parents=True)
        router = self.skill / 'SKILL.md'
        imported = self.skill / 'imported' / 'SKILL.md'
        imported.parent.mkdir()
        imported.write_text('Unchanged historical origin ' + str(self.root))
        self.original_import = imported.read_bytes()
        for path, name in [(router, 'fixture-router'), (module, 'fixture-module')]:
            lines = ['---', 'name: ' + name, 'description: Fixture.', '---']
            for section in SECTIONS:
                lines += ['## ' + section, '[source](' + str(self.root / 'missing-source.txt') + ')']
            path.write_text('\n'.join(lines) + '\n')
        catalog = {'schema_version': 1, 'package_root': str(self.root), 'router': str(router),
                   'modules': [{'id': 'fixture', 'name': 'fixture-module', 'path': str(module), 'default_scope': 'offline'}],
                   'imported': [{'path': str(imported), 'sha256': hashlib.sha256(self.original_import).hexdigest()}],
                   'supporting_documents': []}
        (self.skill / 'catalog.json').write_text(json.dumps(catalog))
        self.destination = self.base / 'exported'

    def test_export_preserves_source_and_imports(self):
        before = {str(p): p.read_bytes() for p in self.skill.rglob('*') if p.is_file()}
        result = export(self.skill, self.destination)
        self.assertTrue(result['ok'], result)
        self.assertTrue(check_catalog(self.destination, standalone=True)['ok'])
        after = {str(p): p.read_bytes() for p in self.skill.rglob('*') if p.is_file()}
        self.assertEqual(before, after)
        self.assertEqual((self.destination / 'skill/imported/SKILL.md').read_bytes(), self.original_import)
        text = (self.destination / 'skill/SKILL.md').read_text()
        self.assertIn(str(self.destination / 'missing-source.txt'), text)
        self.assertNotIn(str(self.root), text)

    def test_existing_destination_rejected(self):
        self.destination.mkdir()
        marker = self.destination / 'keep.txt'
        marker.write_text('keep')
        with self.assertRaises(ValueError):
            export(self.skill, self.destination)
        self.assertEqual(marker.read_text(), 'keep')

    def test_destination_inside_source_rejected(self):
        with self.assertRaises(ValueError):
            export(self.skill, self.root / 'new')

    def test_symlink_rejected(self):
        (self.skill / 'link').symlink_to(self.skill / 'catalog.json')
        with self.assertRaises(ValueError):
            export(self.skill, self.destination)
        self.assertFalse(self.destination.exists())

    def test_relative_path_rejected(self):
        with self.assertRaises(ValueError):
            export(self.skill, Path('relative'))

    def test_dangling_destination_symlink_rejected(self):
        other = self.base / 'must-not-create'
        self.destination.symlink_to(other)
        with self.assertRaises(ValueError):
            export(self.skill, self.destination)
        self.assertFalse(other.exists())


if __name__ == '__main__':
    unittest.main()