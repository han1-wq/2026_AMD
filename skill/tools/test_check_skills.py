"""No-hardware tests for the skill checker; all mutations use temporary trees."""
import hashlib
import json
from pathlib import Path
import tempfile
import unittest
import shutil
import subprocess
import sys

from check_skills import SECTIONS, check_catalog


class SkillChecks(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix='skill-check-test-')
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        self.skill = self.root / 'skill'
        self.skill.mkdir()
        self.source = self.root / 'source.txt'
        self.source.write_text('fixture only\n')
        self.router = self.skill / 'SKILL.md'
        self.router.write_text(self.document('fixture-router'))
        self.module = self.skill / 'fixture' / 'SKILL.md'
        self.module.parent.mkdir()
        self.module.write_text(self.document('fixture-module'))
        self.imported = self.skill / 'imported' / 'SKILL.md'
        self.imported.parent.mkdir()
        self.imported.write_text('historical fixture\n')
        self.catalog = {
            'schema_version': 1, 'package_root': str(self.root),
            'router': str(self.router),
            'modules': [{'id': 'fixture', 'name': 'fixture-module',
                         'path': str(self.module), 'default_scope': 'offline'}],
            'imported': [{'path': str(self.imported), 'sha256':
                          hashlib.sha256(self.imported.read_bytes()).hexdigest()}],
            'supporting_documents': [],
        }
        self.save()

    def document(self, name):
        lines = ['---', 'name: ' + name, 'description: Fixture for validation.', '---']
        for section in SECTIONS:
            lines += ['## ' + section, 'Fixture description.']
            if section in ('权威来源', '已验证效果', '经验来源'):
                lines.append('[fixture](' + str(self.source) + ')')
        return '\n'.join(lines) + '\n'

    def save(self):
        (self.skill / 'catalog.json').write_text(json.dumps(self.catalog))

    def rejects(self, message):
        result = check_catalog(self.root)
        self.assertFalse(result['ok'])
        self.assertIn(message, '\n'.join(result['errors']))

    def test_valid_catalog(self):
        result = check_catalog(self.root)
        self.assertTrue(result['ok'], result['errors'])
        self.assertEqual(result['modules'], 1)
        self.assertFalse(result['documented_commands_executed'])

    def test_missing_section(self):
        self.module.write_text(self.module.read_text().replace('## 验收与输出', '## different'))
        self.rejects('missing section: 验收与输出')

    def test_empty_section(self):
        self.module.write_text(self.module.read_text().replace('## 常见故障\nFixture description.', '## 常见故障'))
        self.rejects('empty section: 常见故障')

    def test_missing_reference(self):
        self.source.unlink()
        self.rejects('missing reference')

    def test_relative_reference(self):
        self.module.write_text(self.module.read_text().replace(str(self.source), 'source.txt'))
        self.rejects('reference must be absolute')

    def test_symlink_escape(self):
        with tempfile.TemporaryDirectory(prefix='outside-skill-test-') as directory:
            outside = Path(directory) / 'source.txt'
            outside.write_text('outside')
            self.source.unlink()
            self.source.symlink_to(outside)
            self.rejects('reference escapes package')

    def test_imported_hash_changed(self):
        self.imported.write_text('unexpected modification')
        self.rejects('imported hash mismatch')

    def test_duplicate_module(self):
        self.catalog['modules'].append(dict(self.catalog['modules'][0]))
        self.save()
        self.rejects('duplicate module id')

    def test_duplicate_skill_name(self):
        self.module.write_text(self.document('fixture-router'))
        self.rejects('duplicate skill name')

    def test_missing_frontmatter(self):
        self.module.write_text(self.module.read_text().replace('---\n', '', 1))
        self.rejects('missing frontmatter')

    def test_unclosed_code_fence(self):
        self.module.write_text(self.module.read_text() + '\n```bash\n')
        self.rejects('unclosed code fence')

    def test_unsafe_default_scope(self):
        self.catalog['modules'][0]['default_scope'] = 'hardware'
        self.save()
        self.rejects('unsafe or unknown default scope')

    def test_wrong_catalog_root(self):
        self.catalog['package_root'] = str(self.root / 'other')
        self.save()
        self.rejects('package_root differs')

    def test_unregistered_skill(self):
        other = self.skill / 'extra' / 'SKILL.md'
        other.parent.mkdir()
        other.write_text(self.document('extra'))
        self.rejects('unregistered SKILL.md')

    def test_malformed_json(self):
        (self.skill / 'catalog.json').write_text('{invalid')
        self.assertFalse(check_catalog(self.root)['ok'])

    def test_documented_command_is_not_executed(self):
        marker = self.root / 'must-not-exist'
        self.module.write_text(self.module.read_text() + '\n```bash\ntouch ' + str(marker) + '\n```\n')
        self.assertTrue(check_catalog(self.root)['ok'])
        self.assertFalse(marker.exists())

    def test_missing_verified_effect(self):
        self.module.write_text(self.module.read_text().replace('## 已验证效果', '## omitted'))
        self.rejects('missing section: 已验证效果')

    def test_experience_requires_evidence_link(self):
        text = self.module.read_text()
        begin = text.index('## 经验来源')
        self.module.write_text(text[:begin] + '## 经验来源\nUnsubstantiated claim.\n')
        self.rejects('经验来源 section has no reference')

    def test_relocated_package(self):
        with tempfile.TemporaryDirectory() as directory:
            target = Path(directory) / 'relocated'
            shutil.copytree(self.root, target)
            self.assertTrue(check_catalog(target, relocate=True)['ok'])
            (target / 'source.txt').unlink()
            self.assertFalse(check_catalog(target, relocate=True)['ok'])

    def test_standalone_lists_missing_external_evidence(self):
        with tempfile.TemporaryDirectory() as directory:
            target = Path(directory)
            shutil.copytree(self.skill, target / 'skill')
            result = check_catalog(target, standalone=True)
            self.assertTrue(result['ok'], result['errors'])
            self.assertEqual(result['external_references_not_checked'], [str(self.source)])
            self.assertEqual(result['validation_scope'], 'skill-only')

    def test_standalone_rejects_internal_missing_link(self):
        self.module.write_text(self.module.read_text() + '\n[missing](' + str(self.skill / 'missing.md') + ')\n')
        self.assertFalse(check_catalog(self.root, standalone=True)['ok'])

    def test_standalone_rejects_symlink_escape(self):
        link = self.skill / 'escape.txt'
        link.symlink_to(self.source)
        self.module.write_text(self.module.read_text() + '\n[escape](' + str(link) + ')\n')
        self.assertFalse(check_catalog(self.root, standalone=True)['ok'])

    def test_cli_exit_codes(self):
        command = [sys.executable, '-B', str(Path(__file__).with_name('check_skills.py')),
                   '--root', str(self.root)]
        good = subprocess.run(command, capture_output=True, text=True, timeout=20)
        self.assertEqual(good.returncode, 0, good.stderr)
        self.assertTrue(json.loads(good.stdout)['ok'])
        self.source.unlink()
        bad = subprocess.run(command, capture_output=True, text=True, timeout=20)
        self.assertEqual(bad.returncode, 1, bad.stderr)
        self.assertFalse(json.loads(bad.stdout)['ok'])


if __name__ == '__main__':
    unittest.main()