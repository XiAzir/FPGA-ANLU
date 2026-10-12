"""Bounded, zero-delay LUT table audit of the actual routed page-3 selector.

This is not full-netlist simulation. It checks the five-LUT prefix ending
frame_value_b[17]_syn_9, before self-test gating and display registers.
"""
from pathlib import Path
from itertools import product
import hashlib
import json
import re

base = Path(__file__).resolve().parents[2]
netlist = base / 'audit/final_pr_routed.v'
text = netlist.read_text(encoding='utf-8-sig')

def params(instance):
    end = text.index('    \\' + instance + '  (')
    start = text.rfind('  EG_PHY_', 0, end)
    block = text[start:end]
    return {name: int(value, 2) for name, value in re.findall(r'\.(INIT_LUT\w*)\(16\'b([01]{16})\)', block)}

instances = {
    'file_received': 'u_status_monitor/received_reg[21]_syn_4',
    'low_page': 'u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_wr_din_4d_reg[17]_syn_4',
    'page_gate': 'u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo[6]__3_syn_4',
    'high_page': 'u_status_hex/frame_value_b[17]_syn_13',
    'final_prefix': 'u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_wr_din_4d_reg[22]_syn_4',
}
p = {key: params(value) for key, value in instances.items()}
assert p['low_page']['INIT_LUTF0'] == p['low_page']['INIT_LUTG0']
assert p['page_gate']['INIT_LUTF1'] == p['page_gate']['INIT_LUTG1']
assert p['final_prefix']['INIT_LUTF1'] == p['final_prefix']['INIT_LUTG1']

def lut(init, a, b, c, d):
    return (init >> (a + 2*b + 4*c + 8*d)) & 1

checks = 0
for received, filebit, gap, badgap, halfcycles, frameperiod in product(range(2), repeat=6):
    # Internal page=1 selects displayed page 3. The remaining payload inputs
    # are independently varied, including combinations unreachable on board.
    page0, page1, page2 = 1, 0, 0
    syn4 = lut(p['file_received']['INIT_LUT0'], filebit, page0, received, page1)
    sel17 = lut(p['low_page']['INIT_LUTF0'], badgap, gap, syn4, page1)
    gate = lut(p['page_gate']['INIT_LUTF1'], 0, 0, page2, page1)
    syn7 = lut(p['high_page']['INIT_LUT1'], gate, frameperiod, halfcycles, page0)
    syn9 = lut(p['final_prefix']['INIT_LUTF1'], 0, sel17, page2, syn7)
    assert syn9 == 1-received, (received, filebit, gap, badgap, halfcycles, frameperiod, syn9)
    checks += 1

report = {
    'result': 'PASS', 'checks': checks,
    'scope': 'Five actual routed LUT INIT tables, page=1 (display page 3), all 64 boundary combinations',
    'relation': 'frame_value_b[17]_syn_9 == NOT received[17]',
    'netlist_sha256': hashlib.sha256(netlist.read_bytes()).hexdigest(),
    'instances': instances, 'init_tables': p,
    'limits': 'Boundary connectivity transcribed from named primitive ports; no reset, FF, self-test gating, serial display, timing/SDF or hardware simulation.'
}
out = Path(__file__).with_suffix('.json')
out.write_text(json.dumps(report, indent=2) + '\n', encoding='utf-8')
print(f'PAGE17_PREFIX_PASS checks={checks} relation=syn9_not_received17')
