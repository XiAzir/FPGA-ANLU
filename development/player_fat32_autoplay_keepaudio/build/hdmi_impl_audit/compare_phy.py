"""Read-only comparison of PLL/PAD configuration in routed TD netlists.

This is a configuration audit, not functional or physical equivalence.
"""
import json
import re
from pathlib import Path

ROOT = Path('E:/VSCODE-project/FPGA-ANLU/development')
FILES = {
    'verified_probe': ROOT / 'player_fat32_autoplay/build/audio_impl_audit/audio_probe_routed.v',
    'failed_keepaudio': ROOT / 'player_fat32_autoplay_keepaudio/build/hdmi_impl_audit/keepaudio_routed.v',
}
CELL = re.compile(r'^  (EG_PHY_\w+)\s+(?:#\((.*?)\)\s*)?(\\\S+|\w+)\s+\((.*?)\);', re.M | re.S)
PARAM = re.compile(r'^\s*\.(\w+)\((.*?)\),?\s*$', re.M)

def cells(path):
    source = path.read_text(encoding='utf-8')
    result = []
    for match in CELL.finditer(source):
        kind, parameters, name, ports = match.groups()
        params = dict(PARAM.findall(parameters or ''))
        connections = dict(PARAM.findall(ports))
        result.append({'kind': kind, 'name': name.lstrip('\\'), 'parameters': params,
                       'ports': connections, 'line': source.count('\n', 0, match.start()) + 1})
    return result

report = {'scope': 'PLL and HDMI output PAD parameters/connections; no whole-design equivalence'}
selected = {}
for label, path in FILES.items():
    parsed = cells(path)
    chosen = [c for c in parsed if c['kind'] == 'EG_PHY_PLL' or
              (c['kind'] == 'EG_PHY_PAD' and c['name'].startswith('HDMI_'))]
    selected[label] = {c['name']: c for c in chosen}
    report[label] = {'file': str(path), 'parsed_cells': len(parsed), 'selected': chosen}

changes = []
for name in sorted(set(selected['verified_probe']) | set(selected['failed_keepaudio'])):
    old = selected['verified_probe'].get(name)
    new = selected['failed_keepaudio'].get(name)
    if old is None or new is None:
        changes.append({'instance': name, 'missing': 'old' if old is None else 'new'})
        continue
    for key in sorted(set(old['parameters']) | set(new['parameters'])):
        if old['parameters'].get(key) != new['parameters'].get(key):
            changes.append({'instance': name, 'parameter': key,
                            'old': old['parameters'].get(key), 'new': new['parameters'].get(key)})
report['parameter_changes'] = changes
output = Path(__file__).with_name('phy_comparison.json')
output.write_text(json.dumps(report, indent=2), encoding='utf-8')
print(json.dumps({'selected_counts': {k:len(v) for k,v in selected.items()},
                  'parameter_changes': changes, 'report': str(output)}, indent=2))
