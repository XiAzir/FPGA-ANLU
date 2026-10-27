"""Prepare the explicit one-cycle-later SDRAM input-capture experiment."""
from pathlib import Path
import json
import xml.etree.ElementTree as ET

ROOT=Path(__file__).resolve().parents[2]
SRC=ROOT/'development/player_video42_sdram100/src/user_source'
for suffix in ('v','vhd'):
    path=SRC/f'hdl_source/IP/sys_pll.{suffix}'
    text=path.read_text(encoding='utf-8-sig')
    old='.CLKC2_CPHASE(3)' if suffix=='v' else 'CLKC2_CPHASE => 3'
    new='.CLKC2_CPHASE(8)' if suffix=='v' else 'CLKC2_CPHASE => 8'
    assert text.count(old)==1
    path.write_text(text.replace(old,new).replace('144.0000 DEG','324.0000 DEG'),encoding='utf-8')
path=SRC/'hdl_source/IP/sys_pll.ipc'
tree=ET.parse(path)
for clock in tree.getroot().findall('./Page3/clocks/clock'):
    if clock.findtext('id')=='2':
        clock.find('phase_shift').text='324.0000000000000000deg'
tree.write(path,encoding='utf-8',xml_declaration=True)
path=SRC/'hdl_source/top_tf_hdmi_audio.v'
text=path.read_text(encoding='utf-8-sig')
old='    .WRITE_V_FLIP      (1)\n) u_frame_buffer ('
new='    .WRITE_V_FLIP      (1),\n    .SDR_READ_DATA_DELAY(0)\n) u_frame_buffer ('
assert text.count(old)==1
path.write_text(text.replace(old,new),encoding='utf-8')
path=SRC/'constraints_source/timing.sdc'
text=path.read_text(encoding='utf-8-sig')
text+='''
# C42 read interface: SDRAM launch n@9ns is captured at mem edge20ns.
# Data changes each 10ns; retain the setup-derived hold check (source9/capture10,
# equivalent to next word source19/capture20). No hold relaxation is applied.
# This source clock drives only the SDRAM forwarding clock. Its return paths
# must be verified against the actual device model and DATA_DELAY=0 capture.
set_multicycle_path 2 -setup -from [get_clocks ext_mem_clk_sft] -to [get_clocks ext_mem_clk]
'''
path.write_text(text,encoding='utf-8')
print(json.dumps({'status':'EXPERIMENT_PREPARED_PENDING_DATA_AND_STA',
    'forwarded_phase_ns':9,'read_data_delay':0,'read_setup_cycles':2,
    'hold_exception':None,'hardware_capture':'rising edge',
    'OE_padding_or_retiming':False},indent=2))
