"""Fail closed if a candidate changes the existing software/hardware ABI."""
import hashlib
import json
from pathlib import Path
import xml.etree.ElementTree as ET

WORK = Path(__file__).resolve().parent
NS = {"s": "http://www.spiritconsortium.org/XMLSchema/SPIRIT/1685-2009"}

def canonical(element):
    return {"tag": element.tag, "attributes": sorted(element.attrib.items()),
            "text": (element.text or "").strip(),
            "children": [canonical(child) for child in element]}

def signature(path):
    root = ET.parse(path).getroot()
    return {name: canonical(root.find(name, NS)) for name in (
        "s:busInterfaces", "s:memoryMaps", "s:model/s:ports", "s:model/s:modelParameters")}

def main():
    report = {}
    for kernel in ("image_preprocess", "yolo_postprocess"):
        original = WORK.parent / kernel / "build" / kernel / "solution_200mhz/impl/ip"
        candidate = WORK / "candidate" / kernel / "solution_200mhz/impl/ip"
        before, after = signature(original / "component.xml"), signature(candidate / "component.xml")
        differences = [key for key in before if before[key] != after[key]]
        if differences:
            raise SystemExit(kernel + " ABI mismatch: " + str(differences))
        files = {str(p.relative_to(candidate)): hashlib.sha256(p.read_bytes()).hexdigest()
                 for p in sorted(candidate.rglob("*")) if p.is_file()}
        report[kernel] = {"abi_matches": True, "file_count": len(files), "files": files}
        print(kernel, "PASS register maps, interfaces and port signatures; files", len(files))
    (WORK / "candidate_export_sha256.json").write_text(json.dumps(report, indent=2))

if __name__ == "__main__":
    main()