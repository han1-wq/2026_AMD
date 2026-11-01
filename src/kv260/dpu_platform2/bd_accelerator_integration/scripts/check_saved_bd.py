#!/usr/bin/env python3
"""Check saved Vivado JSON: original DPU wiring, new wiring, maps and IP hashes."""
import argparse
import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
PROJECT = Path('/home/amd/Workspace/dpu_platform2/kv260_vitis_platform2/'
               'dpu_trd_system_hw_link/Hardware/dpu.build/link/vivado/vpl/prj')


def require(condition, message):
    if not condition:
        raise RuntimeError(message)


def net_for(design, category, endpoint):
    key = 'interface_ports' if category == 'interface_nets' else 'ports'
    matches = [set(net[key]) for net in design[category].values()
               if endpoint in net[key]]
    require(len(matches) == 1, 'Expected one net for ' + endpoint)
    return matches[0]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--bd', type=Path, default=PROJECT / 'prj.srcs/sources_1/bd/'
                        'kv260_hardware_platform/kv260_hardware_platform.bd')
    args = parser.parse_args()
    backup = Path((ROOT / 'backup_path.txt').read_text().strip())
    old = json.loads((backup / 'original_bd.json').read_text())['design']
    new = json.loads(args.bd.read_text())['design']
    for name, cell in old['components'].items():
        require(name in new['components'], 'Removed original cell ' + name)
        require(new['components'][name]['vlnv'] == cell['vlnv'], 'Changed IP ' + name)
    for category in ('interface_nets', 'nets'):
        key = 'interface_ports' if category == 'interface_nets' else 'ports'
        for name, net in old[category].items():
            endpoints = set(net[key])
            if name == 'irq_const_tieoff_dout':
                endpoints -= {'axi_intc_0_intr_1_interrupt_concat/In2',
                              'axi_intc_0_intr_1_interrupt_concat/In3'}
            require(endpoints <= net_for(new, category, sorted(endpoints)[0]),
                    'Changed original connection ' + name)
    for name, addressing in old['addressing'].items():
        for space, content in addressing['address_spaces'].items():
            for seg, value in content['segments'].items():
                actual = new['addressing'][name]['address_spaces'][space]['segments'][seg]
                require(actual == value, 'Changed original address ' + seg)
    for master, slave in (
        ('image_preprocess_1/m_axi_gmem_in', 'vision_read_sc/S00_AXI'),
        ('yolo_postprocess_1/m_axi_gmem_in', 'vision_read_sc/S01_AXI'),
        ('vision_read_sc/M00_AXI', 'zynq_ultra_ps_e_0/S_AXI_HP2_FPD'),
        ('image_preprocess_1/m_axi_gmem_out', 'vision_write_sc/S00_AXI'),
        ('image_preprocess_1/m_axi_gmem_preview', 'vision_write_sc/S01_AXI'),
        ('yolo_postprocess_1/m_axi_gmem_out', 'vision_write_sc/S02_AXI'),
        ('vision_write_sc/M00_AXI', 'zynq_ultra_ps_e_0/S_AXI_HP3_FPD'),
        ('ps8_0_axi_periph/M03_AXI', 'image_preprocess_1/s_axi_control'),
        ('ps8_0_axi_periph/M04_AXI', 'yolo_postprocess_1/s_axi_control'),
    ):
        require(net_for(new, 'interface_nets', master) == {master, slave},
                'Incorrect connection ' + master)
    for pin in ('image_preprocess_1/ap_clk', 'yolo_postprocess_1/ap_clk',
                'vision_read_sc/aclk', 'vision_write_sc/aclk',
                'zynq_ultra_ps_e_0/saxihp2_fpd_aclk',
                'zynq_ultra_ps_e_0/saxihp3_fpd_aclk',
                'ps8_0_axi_periph/M03_ACLK', 'ps8_0_axi_periph/M04_ACLK'):
        require('clk_wiz_1/clk_out1' in net_for(new, 'nets', pin), 'Wrong clock ' + pin)
    require('clk_wiz_1/clk_out1' in
            net_for(new, 'nets', 'proc_sys_reset_0/slowest_sync_clk'),
            'Reset controller is not synchronized to the vision clock')
    for core, offset, irq in (('image_preprocess_1', 0x86000000, 2),
                              ('yolo_postprocess_1', 0x86010000, 3)):
        require('proc_sys_reset_0/peripheral_aresetn' in
                net_for(new, 'nets', core + '/ap_rst_n'), 'Wrong core reset')
        require('axi_intc_0_intr_1_interrupt_concat/In' + str(irq) in
                net_for(new, 'nets', core + '/interrupt'), 'Wrong interrupt')
        segments = new['addressing']['/zynq_ultra_ps_e_0']['address_spaces']['Data']['segments']
        matches = [s for s in segments.values()
                   if s['address_block'] == '/' + core + '/s_axi_control/Reg']
        require(len(matches) == 1 and int(matches[0]['offset'], 16) == offset
                and matches[0]['range'] == '64K', 'Wrong control address for ' + core)
        for space in new['addressing']['/' + core]['address_spaces'].values():
            regions = list(space['segments'].values())
            mapped = [s for s in regions if s.get('is_excluded') != 'TRUE']
            require(len(mapped) == 2 and all('DDR_' in s['address_block'] for s in mapped),
                    'Incorrect DDR map for ' + core)
    for pin in ('vision_read_sc/aresetn', 'vision_write_sc/aresetn',
                'ps8_0_axi_periph/M03_ARESETN', 'ps8_0_axi_periph/M04_ARESETN'):
        require('proc_sys_reset_0/interconnect_aresetn' in net_for(new, 'nets', pin),
                'Wrong interconnect reset ' + pin)
    manifest = json.loads((ROOT / 'ip_repo_sha256.json').read_text())
    for core, files in manifest.items():
        for name, expected in files.items():
            require(hashlib.sha256((ROOT / 'ip_repo' / core / name).read_bytes()).hexdigest()
                    == expected, 'IP snapshot changed: ' + name)
    print('PASS: original cells/connections/addresses preserved; accelerator wiring, '
          'clocks, resets, interrupts, DDR maps and IP snapshots verified.')


if __name__ == '__main__':
    main()