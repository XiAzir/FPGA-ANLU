from pathlib import Path
import shutil
import xml.etree.ElementTree as ET
import json
import hashlib

root = Path(__file__).resolve().parents[1]
saved = root / 'build/preflight/all32trigger_mslice_fail'
saved.mkdir(parents=True, exist_ok=False)
cfg = root / 'src/td_project/chip_debugger/user.cfg'
shutil.copy2(cfg, saved / 'user.cfg')
for name in ['physical_console.log', 'cw_gate_before_place.cwc', 'AC201_tf_hdmi_debug_gate.db',
             'AC201_tf_hdmi_debug_gate.v', 'build_source_scope.json']:
    p = root / 'build/manual' / name
    if p.exists():
        shutil.copy2(p, saved / name)
tree = ET.parse(cfg)
nets = tree.getroot().findall('./watcher_nodes/bus/net')
assert len(nets) == 32
for n in nets:
    n.set('trig', 'enable' if n.get('name') == 'cw_count_data[21]' else 'disable')
assert sum(n.get('trig') == 'enable' for n in nets) == 1
tree.write(cfg, encoding='utf-8', xml_declaration=True)
prep = root / 'build/preparation.json'
meta = json.loads(prep.read_text(encoding='utf-8'))
meta['active_config_sha256'] = hashlib.sha256(cfg.read_bytes()).hexdigest()
meta['trigger'] = 'cw_count_data[21] = request_toggle only; all 32 data bits retained'
meta['status'] = 'TRIGGER_REDUCED_AFTER_MSLICE_5079_EXCEEDS_4900; NOT_REBUILT'
prep.write_text(json.dumps(meta, indent=2), encoding='utf-8')
print(meta['trigger'])
