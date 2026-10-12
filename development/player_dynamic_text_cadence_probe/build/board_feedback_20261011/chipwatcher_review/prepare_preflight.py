"""Prepare an isolated, offline ChipWatcher insertion check; no JTAG access."""
from pathlib import Path
import hashlib
import json
import shutil
import xml.etree.ElementTree as ET

project = Path('E:/VSCODE-project/FPGA-ANLU')
review = Path(__file__).resolve().parent
trial = review / 'preflight'
trial.mkdir(exist_ok=True)
original = project / 'development/player_dynamic_text_cadence_probe/build/manual/AC201_tf_hdmi_gate.db'
shutil.copyfile(original, trial / 'input_gate.db')
manifest = {'purpose': 'offline insertion preflight only; not a board candidate',
            'input_gate_sha256': hashlib.sha256(original.read_bytes()).hexdigest(),
            'original_bit_sha256': hashlib.sha256((project / 'download/cadence_probe.bit').read_bytes()).hexdigest()}
(trial / 'inputs.json').write_text(json.dumps(manifest, indent=2), encoding='utf-8')
root = ET.Element('chipwatcher', project_name='cadence_cw_preflight',
                  bit_file='', bid_file='', chip_name='EG4S20BG256')
inst = ET.SubElement(root, 'instance', name='auto_chipwatcher_0', id='0', enabled='yes')
ET.SubElement(inst, 'clock', clk_name='video_clk', polarity='posedge')
ET.SubElement(inst, 'config', bram_name='auto_chipwatcher_0_logicbram', sample_depth='128')
vec = ET.SubElement(inst, 'signal_vec')
data = ET.SubElement(vec, 'data_nets')
ET.SubElement(data, 'net', name='audio_valid')
nodes = ET.SubElement(vec, 'watcher_nodes')
ET.SubElement(nodes, 'net', name='audio_valid', op='equal', type='reg', trigger='enable')
trig = ET.SubElement(inst, 'trigger', name='auto_chipwatcher_0_trigger', position='pre')
ET.SubElement(trig, 'condition', level='1', enabled='yes', type='basic_and')
ET.indent(root)
ET.ElementTree(root).write(trial / 'preflight.cwc', encoding='utf-8', xml_declaration=True)
(trial / 'insert.tcl').write_text(f'''# Offline only: no hardware connection or programming commands.
cd {trial.as_posix()}
if {{[catch {{
    import_device eagle_s20.db -package EG4S20BG256
    import_db {trial.as_posix()}/input_gate.db
    write_verilog {trial.as_posix()}/input_gate.v
    insert_debugger {trial.as_posix()} -cwc {trial.as_posix()}/preflight.cwc
    report_area -file {trial.as_posix()}/inserted.area
    export_db {trial.as_posix()}/inserted_gate.db
}} message]}} {{
    puts "CW_PREFLIGHT_ERROR: $message"
    exit 1
}}
puts "CW_PREFLIGHT_INSERT_COMPLETE"
exit
''', encoding='utf-8')
print(json.dumps(manifest, indent=2))
