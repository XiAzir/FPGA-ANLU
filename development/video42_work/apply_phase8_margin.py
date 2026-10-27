"""Select 8 ns forwarding from the measured phase9 timing window."""
from pathlib import Path
import xml.etree.ElementTree as ET

ROOT=Path(__file__).resolve().parents[2]
SRC=ROOT/'development/player_video42_sdram100/src/user_source'
for suffix in ('v','vhd'):
    path=SRC/f'hdl_source/IP/sys_pll.{suffix}'
    text=path.read_text(encoding='utf-8-sig')
    old='.CLKC2_CPHASE(8)' if suffix=='v' else 'CLKC2_CPHASE => 8'
    new='.CLKC2_CPHASE(7)' if suffix=='v' else 'CLKC2_CPHASE => 7'
    assert text.count(old)==1
    path.write_text(text.replace(old,new).replace('324.0000 DEG','288.0000 DEG'),encoding='utf-8')
path=SRC/'hdl_source/IP/sys_pll.ipc'
tree=ET.parse(path)
for clock in tree.getroot().findall('./Page3/clocks/clock'):
    if clock.findtext('id')=='2':clock.find('phase_shift').text='288.0000000000000000deg'
tree.write(path,encoding='utf-8',xml_declaration=True)
path=SRC/'constraints_source/timing.sdc'
text=path.read_text(encoding='utf-8-sig')
text=text.replace('launch n@9ns','launch n@8ns').replace('source9/capture10','source8/capture10').replace('source19/capture20','source18/capture20')
path.write_text(text,encoding='utf-8')
print('C42 phase8 margin candidate: 100MHz, 8ns shift, DATA_DELAY0, setup2 with unrelaxed hold')
