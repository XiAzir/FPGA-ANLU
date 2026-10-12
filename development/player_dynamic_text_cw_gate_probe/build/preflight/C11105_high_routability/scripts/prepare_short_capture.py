from pathlib import Path
import shutil
import xml.etree.ElementTree as ET
import json
import hashlib

root = Path(__file__).resolve().parents[1]
saved = root / 'build/preflight/C11103_ultra_timing'
saved.mkdir(parents=True, exist_ok=False)
shutil.copytree(root / 'src', saved / 'src', ignore=shutil.ignore_patterns('run', 'runs', 'work', '.cache', '*.dmp'))
shutil.copytree(root / 'scripts', saved / 'scripts')
for path in (root / 'build/manual').iterdir():
    if path.is_file() and (path.suffix in {'.db', '.ts', '.timing', '.area', '.cwc', '.json', '.log'}):
        shutil.copy2(path, saved / path.name)
shutil.copytree(root / 'build/manual/stage_evidence', saved / 'stage_evidence')
cfg = root / 'src/td_project/chip_debugger/user.cfg'
tree = ET.parse(cfg)
node = tree.getroot().find('instance')
assert node is not None
assert node.find('config').get('sample_depth') == '1024'
node.find('config').set('sample_depth', '256')
node.find('trigger').set('window_depth', '256')
node.find('trigger').set('position', '127')
node.find('logic_eram').set('depth', '256')
tree.write(cfg, encoding='utf-8', xml_declaration=True)
top = root / 'src/user_source/hdl_source/top_tf_hdmi_audio.v'
text = top.read_text(encoding='utf-8')
assert text.count("assign packet_n=24'hC11103;") == 1
top.write_text(text.replace('C11103', 'C11104'), encoding='utf-8')
physical = root / 'scripts/build_manual_phy.tcl'
script = physical.read_text(encoding='utf-8')
for param in ('effort', 'opt_timing', 'post_place_opt'):
    script = script.replace(f'set_param place {param} ultra', f'set_param place {param} high')
script = script.replace('set_param route effort timing', 'set_param route effort normal')
physical.write_text(script, encoding='utf-8')
meta_path = root / 'build/preparation.json'
meta = json.loads(meta_path.read_text(encoding='utf-8-sig'))
meta.update(build_id='C11104', status='SHORT_CAPTURE_256_PREPARED_NOT_BUILT',
            strategy='place high; route normal; original SDC and debugger SMD unchanged',
            capture_depth=256,
            active_config_sha256=hashlib.sha256(cfg.read_bytes()).hexdigest(),
            top_sha256=hashlib.sha256(top.read_bytes()).hexdigest())
meta_path.write_text(json.dumps(meta, indent=2), encoding='utf-8')
print('C11104: 32 data bits / 1 trigger bit / depth 256')
