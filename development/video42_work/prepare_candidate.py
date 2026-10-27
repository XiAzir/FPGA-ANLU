"""C42: isolate the memory clock change from the confirmed C41 player."""
import hashlib
import json
from pathlib import Path
import re
import shutil
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[2]
BASE = ROOT / 'development/player_video41_refresh'
CAND = ROOT / 'development/player_video42_sdram100'
assert not CAND.exists(), 'Preserve the existing candidate and its evidence'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
shutil.copytree(BASE / 'src/user_source', CAND / 'src/user_source')
shutil.copytree(BASE / 'src/td_project/al_ip', CAND / 'src/td_project/al_ip')
project = (BASE / 'src/td_project/AC201_tf_hdmi.al').read_text(encoding='utf-8-sig')
project = re.sub(r'(<Project\b[^>]*\bPath=")[^"]*(")',
                 lambda m: m[1] + (CAND / 'src/td_project').as_posix() + m[2], project, count=1)
(CAND / 'src/td_project/AC201_tf_hdmi.al').write_text(project, encoding='utf-8')
shutil.copytree(BASE / 'scripts', CAND / 'scripts')
for path in (CAND / 'scripts').iterdir():
    if path.is_file():
        text = path.read_text(encoding='utf-8-sig').replace(
            'AC201_player_video41_refresh.bit', 'AC201_player_video42_sdram100.bit')
        path.write_text(text, encoding='utf-8')
(CAND / 'verification').mkdir()
check = (BASE / 'verification/check_final_stages.ps1').read_text(encoding='utf-8-sig')
check = check.replace('AC201_player_video41_refresh.bit', 'AC201_player_video42_sdram100.bit').replace('C41_FINAL', 'C42_FINAL')
(CAND / 'verification/check_final_stages.ps1').write_text(check, encoding='utf-8')

src = CAND / 'src/user_source/hdl_source'
top_path = src / 'top_tf_hdmi_audio.v'
text = top_path.read_text(encoding='utf-8-sig')
assert text.count("32'h00C11341") == 1
top_path.write_text(text.replace("32'h00C11341", "32'h00C11342"), encoding='utf-8')
defs = src / 'include/global_def.v'
text = defs.read_text(encoding='utf-8-sig')
assert text.count('1000000000/50000000') == 1
defs.write_text(text.replace('1000000000/50000000', '(1000000000/100000000)'), encoding='utf-8')

# The 1 GHz VCO and 50 MHz feedback/SD output stay as generated.
# C1: 100 MHz, 0 degrees; C2: 100 MHz, 144 degrees (4 ns).
for extension in ('v', 'vhd'):
    path = src / f'IP/sys_pll.{extension}'
    text = path.read_text(encoding='utf-8-sig')
    for field, old, new in [('CLKC1_DIV',20,10), ('CLKC1_CPHASE',19,9),
                            ('CLKC2_DIV',20,10), ('CLKC2_CPHASE',7,3)]:
        pattern = rf'(\.{field}\(){old}(\))' if extension == 'v' else rf'({field}\s*=>\s*){old}(,)'
        text, count = re.subn(pattern, lambda m: m[1] + str(new) + m[2], text)
        assert count == 1, (path, field, count)
    text = re.sub(r'(C[12]\s*\|\s*)50\.000000MHZ', r'\g<1>100.000000MHZ', text)
    path.write_text(text, encoding='utf-8')
ipc_path = src / 'IP/sys_pll.ipc'
ipc = ET.parse(ipc_path)
for clock in ipc.getroot().findall('./Page3/clocks/clock'):
    if clock.findtext('id') in ('1','2'):
        clock.find('clock_division_factor').text = '10'
        clock.find('clock_frequency').text = '100.0000000000000000MHz'
ipc.write(ipc_path, encoding='utf-8', xml_declaration=True)

changes = []
same = 0
for path in sorted((BASE / 'src/user_source').rglob('*')):
    if not path.is_file():
        continue
    rel = path.relative_to(BASE / 'src/user_source')
    target = CAND / 'src/user_source' / rel
    if sha(path) == sha(target):
        same += 1
    else:
        changes.append({'path': rel.as_posix(), 'before': sha(path), 'after': sha(target)})
record = {
    'status':'INITIAL_CLOCK_CANDIDATE_CREATED',
    'baseline_bit_sha256':sha(ROOT / 'download/video41_refresh.bit'),
    'baseline_board_feedback':'download/video41_refresh.board_feedback.json',
    'clocks_hz':{'sd_logic':50000000,'spi_data':25000000,'memory':100000000,
                 'memory_shift':100000000,'pixel':25000000,'serializer':125000000},
    'memory_phase_shift_ns':4,
    'refresh_request_cycles':1562,
    'refresh_interval_ns':15620,
    'changes':changes,'unchanged_user_sources':same,
    'scope':'480p media, C41 refresh/ACK correction; isolate memory clock upgrade',
    'pending':['PLL functional model','100 MHz protocol/data tests','timing closure','board validation']
}
(CAND / 'verification/preparation.json').write_text(json.dumps(record,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps(record,ensure_ascii=False,indent=2))
