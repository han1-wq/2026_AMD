import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
from make_link_config import merge


class LinkTests(unittest.TestCase):
    def test_preserves_duplicate_key_entries(self):
        original = ("platform=platform.xpfm\n[clock]\nid=3:DPUCZDX8G_1.aclk\n"
                    "id=5:DPUCZDX8G_1.ap_clk_2\n[connectivity]\n"
                    "nk=DPUCZDX8G:1:DPUCZDX8G_1\nnk=sfm_xrt_top:1:sfm_xrt_top_1\n"
                    "sp=DPUCZDX8G_1.M_AXI_HP2:HP1\n")
        result = merge(original)
        for line in original.splitlines():
            self.assertIn(line, result)
        self.assertEqual(result.count("[clock]"), 1)
        self.assertEqual(result.count("[connectivity]"), 1)
        self.assertIn("sp=image_preprocess_1.m_axi_gmem_preview:HP3", result)

    def test_missing_sections(self):
        result = merge("platform=example.xpfm\n")
        self.assertEqual(result.count("[clock]"), 1)
        self.assertEqual(result.count("[connectivity]"), 1)

    def test_rejects_duplicate_merge_and_duplicate_sections(self):
        with self.assertRaises(ValueError):
            merge(merge("platform=example.xpfm\n"))
        with self.assertRaises(ValueError):
            merge("[clock]\n[clock]\n")


if __name__ == "__main__":
    unittest.main()