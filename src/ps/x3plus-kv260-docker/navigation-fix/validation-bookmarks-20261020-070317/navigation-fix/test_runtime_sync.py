import hashlib
import importlib.util
import json
from pathlib import Path
import unittest
from unittest.mock import patch

spec = importlib.util.spec_from_file_location('runtime_sync', Path(__file__).with_name('sync-runtime.py'))
runtime = importlib.util.module_from_spec(spec)
spec.loader.exec_module(runtime)


class RuntimeSyncTests(unittest.TestCase):
    def test_matching_runtime_never_copies_or_queries_ros(self):
        checksums = {dest: hashlib.sha256(path.read_bytes()).hexdigest()
                     for path, dest in runtime.FILES.items()}
        with patch.object(runtime, 'command', return_value=json.dumps(checksums).encode()) as command:
            runtime.sync('isolated')
        self.assertEqual(command.call_count, 1)

    def test_active_nodes_block_installation(self):
        with patch.object(runtime, 'command', side_effect=[b'{}', b'/rosout\n/driver_node\n']) as command:
            with self.assertRaisesRegex(RuntimeError, 'ROS nodes are active'):
                runtime.sync('isolated')
        self.assertEqual(command.call_count, 2)
        self.assertFalse(any('cp' in call.args[0] for call in command.call_args_list))

    def test_read_only_check_fails_without_installation(self):
        with patch.object(runtime, 'command', return_value=b'{}') as command:
            with self.assertRaisesRegex(RuntimeError, 'Runtime differs'):
                runtime.sync('isolated', check_only=True)
        self.assertEqual(command.call_count, 1)


if __name__ == '__main__':
    unittest.main()