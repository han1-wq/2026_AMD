#!/usr/bin/env python3
"""Print actual HLS estimates and RTL simulation latency, without claiming route timing."""
from pathlib import Path
import xml.etree.ElementTree as ET


def main():
    root = Path(__file__).resolve().parents[1]
    solution = root / "build/image_preprocess/solution_200mhz"
    report = ET.parse(solution / "syn/report/image_preprocess_csynth.xml").getroot()
    resources = report.find(".//AreaEstimates/Resources")
    print("HLS resource estimates:")
    for value in resources:
        print("  {}: {}".format(value.tag, value.text))
    period = report.findtext(".//EstimatedClockPeriod")
    print("Estimated clock period (ns):", period)
    print("These estimates exclude PS interconnect and do not establish routed timing.")
    cosim = solution / "sim/report/image_preprocess_cosim.rpt"
    if cosim.exists():
        print("\nC/RTL report:")
        print(cosim.read_text())
    print("Mapped Vivado RTL resources, if generated:", root / "build/rtl_synthesis/utilization.rpt")


if __name__ == "__main__":
    main()