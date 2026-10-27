import hashlib
import json
from pathlib import Path
import re

WORK=Path(__file__).resolve().parent
report=WORK/'raw_io_report.rpt'
text=report.read_text()
paths=text.split('Slack               :')[1:]
sck=next(p for p in paths if re.search(r'Begin Point\s*:\s*sd_dclk_syn_',p) and re.search(r'End Point\s*:\s*sd_dclk\s',p))
miso=next(p for p in paths if re.search(r'Begin Point\s*:\s*sd_miso\s',p) and 'Check Type          : setup' in p)
number=lambda pattern,section:float(re.search(pattern,section)[1])
sck_arrival=number(r'Arrival\s+([-\d.]+)',sck)
miso_required=number(r'Required\s+([-\d.]+)',miso)
miso_internal=number(r'Data Path Delay\s*:\s*([-\d.]+)',miso)-20.0
result={'scope':'Routed path estimate using artificial 20ns max IO delays; actual card tOD/PCB and min timing unmeasured.',
 'sck_pad_falling_arrival_ns':sck_arrival,'miso_required_ns':miso_required,
 'miso_pad_net_register_path_ns':miso_internal,
 'remaining_card_tOD_plus_PCB_roundtrip_ns':round(miso_required-sck_arrival-miso_internal,3),
 'report_sha256':hashlib.sha256(report.read_bytes()).hexdigest()}
(WORK/'raw_io_budget.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
print(json.dumps(result,indent=2))
