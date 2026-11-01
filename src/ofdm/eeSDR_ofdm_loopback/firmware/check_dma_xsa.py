#!/usr/bin/env python3
"""Reject hardware platforms that cannot complete the OFDM RX DMA path."""
import sys
import zipfile
import xml.etree.ElementTree as ET


def check(path):
    with zipfile.ZipFile(path) as archive:
        modules = []
        for name in archive.namelist():
            if name.endswith('.hwh'):
                modules.extend(module for module in ET.fromstring(archive.read(name)).iter('MODULE')
                               if module.get('INSTANCE') == 'axi_dma_0')
    if len(modules) != 1:
        raise ValueError('Expected exactly one axi_dma_0 in XSA')
    parameters = {item.get('NAME'): item.get('VALUE')
                  for item in modules[0].iter('PARAMETER')}
    for name, expected in [('C_INCLUDE_SG', '1'), ('C_INCLUDE_MM2S', '1'),
                           ('C_INCLUDE_S2MM', '1'), ('C_SG_INCLUDE_STSCNTRL_STRM', '0')]:
        actual = parameters.get(name)
        if actual != expected:
            raise ValueError(f'{name}={actual}, expected {expected}; rebuild with connect_dma_bd.tcl. '
                             'The OFDM adapter supplies no external DMA status/control stream.')
    print('DMA_XSA_PASS: SG TX/RX enabled; external status/control stream disabled')


if __name__ == '__main__':
    if len(sys.argv) != 2:
        sys.exit('Usage: check_dma_xsa.py /absolute/TOP.xsa')
    try:
        check(sys.argv[1])
    except (OSError, ValueError, zipfile.BadZipFile, ET.ParseError) as exc:
        sys.exit(str(exc))