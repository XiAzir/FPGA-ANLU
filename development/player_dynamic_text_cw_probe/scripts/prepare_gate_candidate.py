"""Create the isolated, native gate-insertion diagnostic candidate (offline)."""
from pathlib import Path
import shutil
import re
import json
import hashlib

project = Path('E:/VSCODE-project/FPGA-ANLU')
source = project / 'development/player_dynamic_text_cw_probe'
target = project / 'development/player_dynamic_text_cw_gate_probe'
assert not target.exists(), 'Refuse to replace an existing candidate'
(target / 'src/td_project').mkdir(parents=True)
shutil.copytree(source / 'src/user_source', target / 'src/user_source',
                ignore=shutil.ignore_patterns('player_count_chipwatcher.sv'))
shutil.copytree(source / 'src/td_project/al_ip', target / 'src/td_project/al_ip')
al = (source / 'src/td_project/AC201_tf_hdmi.al').read_text(encoding='utf-8-sig')
al, n = re.subn(r'\s*<File Path="\.\./user_source/hdl_source/player_count_chipwatcher\.sv">.*?</File>', '', al, flags=re.S)
assert n == 1
(target / 'src/td_project/AC201_tf_hdmi.al').write_text(al, encoding='utf-8')

top_path = target / 'src/user_source/hdl_source/top_tf_hdmi_audio.v'
top = top_path.read_text(encoding='utf-8-sig')
old = '''// ChipWatcher source IP kept at top level for TD discovery.
player_count_chipwatcher u_count_watch (
    .clk(video_clk),.probe0(cw_count_data),.probe1(cw_count_trigger)
);'''
assert top.count(old) == 1
top = top.replace(old, '// ChipWatcher is inserted into the gate netlist using chip_debugger/user.cfg.')
assert top.count('wire [31:0] cw_count_data;') == 1
top = top.replace('wire [31:0] cw_count_data;', 'wire [31:0] cw_count_data /* fehdl keep="true" */;')
top_path.write_text(top, encoding='utf-8')
cadence_path = target / 'src/user_source/hdl_source/player_cadence_probe.v'
cadence = cadence_path.read_text(encoding='utf-8-sig')
assert cadence.count("24'hC11101") == 1
cadence_path.write_text(cadence.replace("24'hC11101", "24'hC11102"), encoding='utf-8')

cfg_dir = target / 'src/td_project/chip_debugger'
cfg_dir.mkdir()
shutil.copy2(source / 'src/td_project/chip_debugger/user.cfg', cfg_dir / 'user.cfg')
(target / 'scripts').mkdir()
for name in ['build_manual_syn.tcl', 'build_manual_phy.tcl', 'fix_hold.tcl', 'generate_bit.tcl', 'build_candidate.ps1']:
    text = (source / 'scripts' / name).read_text(encoding='utf-8-sig')
    text = text.replace('player_dynamic_text_cw_probe', 'player_dynamic_text_cw_gate_probe')
    if name == 'build_manual_syn.tcl':
        text = text.replace('    insert_debugger .\n', '')
        text = text.replace('    export_db $output_dir/AC201_tf_hdmi_gate.db',
                            '    write_verilog $output_dir/AC201_tf_hdmi_gate.v\n    export_db $output_dir/AC201_tf_hdmi_gate.db')
    elif name == 'build_manual_phy.tcl':
        text = text.replace('    insert_debugger .',
                            '    insert_debugger chip_debugger -cwc chip_debugger/user.cfg\n'
                            '    export_chipwatcher $output_dir/cw_gate_before_place.cwc\n'
                            '    write_verilog $output_dir/AC201_tf_hdmi_debug_gate.v\n'
                            '    export_db $output_dir/AC201_tf_hdmi_debug_gate.db')
    elif name == 'generate_bit.tcl':
        text = text.replace('    setup_debugger . -bit', '    setup_debugger chip_debugger -bit')
        text = text.replace('cw_probe.cwc', 'cw_gate_probe.cwc').replace('cw_probe_sp.cwc', 'cw_gate_probe_sp.cwc')
    elif name == 'build_candidate.ps1':
        text = text.replace("$taskFiles+=Get-ChildItem -LiteralPath (Join-Path $taskSourceRoot 'td_project/al_ip') -Recurse -File",
                            "$taskFiles+=Get-ChildItem -LiteralPath (Join-Path $taskSourceRoot 'td_project/al_ip') -Recurse -File\n"
                            "$taskFiles+=Get-Item -LiteralPath (Join-Path $taskSourceRoot 'td_project/chip_debugger/user.cfg')")
        text = text.replace("'^[A-Z]+-\\d+ ERROR:|Assertion failed|Oops! coredump'", "'^[A-Z]+-\\d+ ERROR:|^ERROR:|Assertion failed|Oops! coredump'")
    (target / 'scripts' / name).write_text(text, encoding='utf-8')

diffs = []
for p in (target / 'src/user_source').rglob('*'):
    if p.is_file():
        before = source / p.relative_to(target)
        if p.read_bytes() != before.read_bytes():
            diffs.append(p.relative_to(target).as_posix())
assert sorted(diffs) == sorted(['src/user_source/hdl_source/top_tf_hdmi_audio.v',
                               'src/user_source/hdl_source/player_cadence_probe.v'])
(target / 'build').mkdir()
(target / 'build/preparation.json').write_text(json.dumps({
    'build_id': 'C11102', 'source': str(source), 'method': 'GUI-derived gate insertion; no source IP',
    'changed_from_source_ip': diffs, 'removed_source': 'player_count_chipwatcher.sv',
    'gui_config_sha256': hashlib.sha256((cfg_dir / 'user.cfg').read_bytes()).hexdigest(),
    'board_connected_to_agent_host': False, 'status': 'PREPARED_NOT_BUILT'
}, indent=2), encoding='utf-8')
print(target)
