#!/usr/bin/env python3
"""Generate a candidate Vitis link config preserving all DPU/sfm settings.

This requires a separately exported .xo, enabled HP2/HP3 in the updated platform,
and confirmation of bundle names in kernel.xml. The default export is Vivado IP.
"""
import argparse
import re
from pathlib import Path

ADDITIONS = {
    "clock": ["id=2:image_preprocess_1.ap_clk"],
    "connectivity": ["nk=image_preprocess:1:image_preprocess_1",
                     "sp=image_preprocess_1.m_axi_gmem_in:HP2",
                     "sp=image_preprocess_1.m_axi_gmem_out:HP3",
                     "sp=image_preprocess_1.m_axi_gmem_preview:HP3"],
}


def merge(text):
    if "image_preprocess_1" in text:
        raise ValueError("input config already references image_preprocess_1")
    sections = re.split(r"(?m)^(\[[^\]\r\n]+\][ \t]*\r?$)", text)
    seen = set()
    for i in range(1, len(sections), 2):
        name = sections[i].strip()[1:-1]
        if name in ADDITIONS:
            if name in seen:
                raise ValueError("duplicate section: " + name)
            seen.add(name)
            sections[i+1] = sections[i+1].rstrip() + "\n" + "\n".join(ADDITIONS[name]) + "\n\n"
    for name in ADDITIONS:
        if name not in seen:
            sections.extend(["\n["+name+"]\n", "\n".join(ADDITIONS[name])+"\n"])
    return "".join(sections)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("input", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    if args.input.resolve() == args.output.resolve():
        raise SystemExit("write to a new file; the original config is preserved")
    result = merge(args.input.read_text())
    with args.output.open("x") as output:
        output.write(result)


if __name__ == "__main__":
    main()