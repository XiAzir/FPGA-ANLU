"""Prepare isolated source-IP watcher candidate from cadence_probe.

No TF/Flash/JTAG operations. The watcher interface follows the installed
ChipWatcher_1.0/ChipWatcher/Other/cwc.atpl, validated by ip_smoke synthesis.
"""
from pathlib import Path
import hashlib
import json

root = Path(__file__).resolve().parent.parent
base = root.parent / 'player_dynamic_text_cadence_probe'
hdl = root / 'src/user_source/hdl_source'
original = (base / 'src/user_source/hdl_source/player_status_monitor.v').read_bytes()
text = original.decode('utf-8-sig')
assert text.count('endmodule') == 1
addition = '''
    // Passive JTAG observation of the reported bit-17 discrepancy.
    // [31]=tone, [30]=valid, [29:26]=page, [25:24]=self_test,
    // [23]=ack_toggle, [22]=ack_sync1, [21]=request_toggle,
    // [20]=hex17, [19]=received17, [18]=mailbox17, [17:0]=count.
    player_count_chipwatcher u_count_watch (
        .clk(pixel_clk),
        .probe0({tone_mode,audio_valid,page,self_test,ack_toggle,ack_sync1,
                 request_toggle,hex_value[17],received[17],mailbox[17],
                 audio_count[17:0]}),
        .probe1(request_toggle)
    );
'''
(hdl / 'player_status_monitor.v').write_text(text.replace('endmodule', addition+'endmodule'), encoding='utf-8')
(hdl / 'player_count_chipwatcher.sv').write_text('''// Interface generated from the installed official ChipWatcher IP template.
// TD insert_debugger resolves this black box before optimize_rtl.
// synthesis syn_black_box
module player_count_chipwatcher(input [31:0] probe0, input [0:0] probe1, input clk);
    localparam string IP_TYPE = "ChipWatcher";
    localparam CWC_BUS_NUM = 2;
    localparam INPUT_PIPE_NUM = 0;
    localparam OUTPUT_PIPE_NUM = 0;
    localparam RAM_DATA_DEPTH = 1024;
    localparam CAPTURE_CONTROL = 0;
    localparam integer CWC_BUS_WIDTH [CWC_BUS_NUM-1:0] = '{32,1};
    localparam integer CWC_DATA_ENABLE [CWC_BUS_NUM-1:0] = '{1,0};
    localparam integer CWC_TRIG_ENABLE [CWC_BUS_NUM-1:0] = '{0,1};
endmodule
''', encoding='utf-8')
cadence = hdl / 'player_cadence_probe.v'
cadence.write_text((base / 'src/user_source/hdl_source/player_cadence_probe.v').read_text(encoding='utf-8-sig').replace("24'hC10902", "24'hC11101"), encoding='utf-8')
project = root / 'src/td_project/AC201_tf_hdmi.al'
rel = '../user_source/hdl_source/player_count_chipwatcher.sv'
# TD's own project format contains the literal attribute name UsedInP&R;
# it is not strict XML. Preserve the native format instead of normalizing it.
project_text = project.read_text(encoding='utf-8-sig')
assert rel not in project_text
entry = f'''            <File Path="{rel}">
                <FileInfo>
                    <Attr Name="UsedInSyn" Val="true"/>
                    <Attr Name="UsedInP&R" Val="true"/>
                    <Attr Name="BelongTo" Val="design_1"/>
                    <Attr Name="CompileOrder" Val="99"/>
                </FileInfo>
            </File>
'''
project.write_text(project_text.replace('        </Verilog>', '        </Verilog>\n        <System_Verilog>\n'+entry+'        </System_Verilog>', 1), encoding='utf-8')
for filename in ['build_manual_syn.tcl','build_manual_phy.tcl','fix_hold.tcl','generate_bit.tcl','build_candidate.ps1']:
    script = (base / 'scripts' / filename).read_text(encoding='utf-8-sig').replace('player_dynamic_text_cadence_probe','player_dynamic_text_cw_probe')
    if filename == 'build_manual_syn.tcl':
        script = script.replace('    optimize_rtl', '    insert_debugger .\n    optimize_rtl')
    if filename == 'build_manual_phy.tcl':
        script = script.replace('    place', '    insert_debugger .\n    place')
    if filename == 'build_candidate.ps1':
        script = script.replace('if($taskExit -ne 0 -or !(',
            "if($taskExit -ne 0 -or (Select-String -LiteralPath $taskLog -Pattern '^[A-Z]+-\\d+ ERROR:|Assertion failed|Oops! coredump' -Quiet) -or !(")
    if filename == 'generate_bit.tcl':
        script = script.replace('    commit_param -step bitgen', f'    cd {root.as_posix()}/src/td_project\n    commit_param -step bitgen')
        script = script.replace('\n} message]', '\n    setup_debugger . -bit $output_dir/AC201_player_dynamic_text_cw_probe.bit\n    export_chipwatcher $output_dir/cw_probe.cwc -add_bid\n    export_chipwatcher $output_dir/cw_probe_sp.cwc -sp -add_bid\n} message]')
    (root / 'scripts' / filename).write_text(script, encoding='utf-8')
differences = []
for f in (root/'src/user_source').rglob('*'):
    if f.is_file():
        relative = f.relative_to(root/'src')
        other = base / 'src' / relative
        if not other.exists() or f.read_bytes() != other.read_bytes():
            differences.append(relative.as_posix())
assert set(differences) == {
    'user_source/hdl_source/player_status_monitor.v',
    'user_source/hdl_source/player_count_chipwatcher.sv',
    'user_source/hdl_source/player_cadence_probe.v'}
manifest = {'status':'OFFLINE_BUILD_IN_PROGRESS_NOT_RELEASED', 'base_bit_sha256':hashlib.sha256((base/'build/manual/AC201_player_dynamic_text_cadence_probe.bit').read_bytes()).hexdigest(),
 'build_id':'C11101', 'changed_user_source_files':differences,
 'capture':{'clock':'player_status_monitor.pixel_clk','data_bits':32,'trigger':'request_toggle','depth':1024},
 'limits':['new placement; cannot prove original physical fault','no physical TMDS measurement','not connected to board on this host']}
(root/'build/preflight/candidate_scope.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2), encoding='utf-8')
print(json.dumps(manifest, ensure_ascii=False, indent=2))
