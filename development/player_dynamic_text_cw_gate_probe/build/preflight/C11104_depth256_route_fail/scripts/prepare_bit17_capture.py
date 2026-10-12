from pathlib import Path
import shutil
import xml.etree.ElementTree as ET
import json
import hashlib

root = Path(__file__).resolve().parents[1]
saved = root / 'build/preflight/C11104_depth256_route_fail'
saved.mkdir(parents=True, exist_ok=False)
shutil.copytree(root / 'src', saved / 'src', ignore=shutil.ignore_patterns('run', 'runs', 'work', '.cache', '*.dmp'))
shutil.copytree(root / 'scripts', saved / 'scripts')
for path in (root / 'build/manual').iterdir():
    if path.is_file() and path.suffix in {'.db', '.ts', '.timing', '.area', '.cwc', '.json', '.log'}:
        shutil.copy2(path, saved / path.name)
shutil.copytree(root / 'build/manual/stage_evidence', saved / 'stage_evidence')
top = root / 'src/user_source/hdl_source/top_tf_hdmi_audio.v'
text = top.read_text(encoding='utf-8')
assert text.count('wire [31:0] cw_count_data') == 1
top.write_text(text.replace('wire [31:0] cw_count_data', 'wire [9:0] cw_count_data')
               .replace('C11104', 'C11105'), encoding='utf-8')
monitor = root / 'src/user_source/hdl_source/player_status_monitor.v'
text = monitor.read_text(encoding='utf-8')
old = '''assign cw_count_data={tone_mode,audio_valid,page,self_test,ack_toggle,
                          ack_sync1,request_toggle,hex_value[17],received[17],
                          mailbox[17],audio_count[17:0]};'''
assert text.count(old) == 1
monitor.write_text(text.replace('output wire [31:0] cw_count_data', 'output wire [9:0] cw_count_data')
                   .replace(old, '''assign cw_count_data={tone_mode,page,request_toggle,
                          hex_value[17],received[17],mailbox[17],audio_count[17]};'''),
                   encoding='utf-8')
cfg = root / 'src/td_project/chip_debugger/user.cfg'
tree = ET.parse(cfg)
main_bus = tree.getroot().find('./watcher_nodes/bus')
main_bus.set('name', 'cw_count_data[9:0]')
for child in list(main_bus):
    main_bus.remove(child)
for bit in range(9, -1, -1):
    ET.SubElement(main_bus, 'net', name=f'cw_count_data[{bit}]', const='false',
                  data='enable', trig='enable' if bit == 4 else 'disable')
instance = tree.getroot().find('instance')
instance.find('config').set('sample_depth', '64')
signal_bus = instance.find('./signal_vec/watcher_nodes/bus')
signal_bus.set('name', 'cw_count_data[9:0]')
for child in list(signal_bus):
    signal_bus.remove(child)
for bit in range(9, -1, -1):
    ET.SubElement(signal_bus, 'net', name=f'cw_count_data[{bit}]', cond='low', capture_cond='low')
instance.find('trigger').set('window_depth', '64')
instance.find('trigger').set('position', '15')
instance.find('logic_eram').set('width', '10')
instance.find('logic_eram').set('depth', '64')
tree.write(cfg, encoding='utf-8', xml_declaration=True)
physical = root / 'scripts/build_manual_phy.tcl'
script = physical.read_text(encoding='utf-8')
assert 'set_param route effort normal' in script
physical.write_text(script.replace('set_param route effort normal', 'set_param route effort routability'), encoding='utf-8')
meta_path = root / 'build/preparation.json'
meta = json.loads(meta_path.read_text(encoding='utf-8-sig'))
meta.update(build_id='C11105', status='BIT17_FOCUSED_PREPARED_NOT_BUILT',
            last_result='C11104: 4806 MSlice; route conflict PHY-8023/RUN-8102, no final STA',
            strategy='place high; route routability; original SDC/debugger SMD unchanged',
            capture_width=10, capture_depth=64,
            mapping='9=tone,8:5=page,4=request_toggle,3=hex[17],2=received[17],1=mailbox[17],0=audio_count[17]',
            trigger='cw_count_data[4] request_toggle only',
            retained='original counter/mailbox/received/display logic; only passive capture bus narrowed',
            active_config_sha256=hashlib.sha256(cfg.read_bytes()).hexdigest(),
            top_sha256=hashlib.sha256(top.read_bytes()).hexdigest())
meta_path.write_text(json.dumps(meta, indent=2), encoding='utf-8')
print('C11105: focused bit17, 10 data / 1 trigger / 64 depth; counters unchanged')
