from pathlib import Path
import re

p=Path(__file__).resolve().parent
for f in (p/'scripts').iterdir():
    if f.suffix in ('.ps1','.tcl'):
        s=f.read_text(encoding='utf-8-sig').replace('player_music_envelope_phy','player_spectrum')
        if f.suffix=='.tcl':
            s=re.sub(r'^set task_root .*',r'set task_root [file normalize [file join [file dirname [info script]] ..]]',s,flags=re.M)
        f.write_text(s,encoding='utf-8')
al=p/'src/td_project/AC201_tf_hdmi.al'
s=al.read_text(encoding='utf-8-sig').replace('player_music_envelope_phy','player_spectrum')
path='../user_source/hdl_source/player_spectrum_analyzer.v'
if path not in s:
    entry='''            <File Path="../user_source/hdl_source/player_spectrum_analyzer.v">
                <FileInfo>
                    <Attr Name="UsedInSyn" Val="true"/>
                    <Attr Name="UsedInP&R" Val="true"/>
                    <Attr Name="BelongTo" Val="design_1"/>
                    <Attr Name="CompileOrder" Val="100"/>
                </FileInfo>
            </File>
'''
    s=s.replace('        </Verilog>',entry+'        </Verilog>')
al.write_text(s,encoding='utf-8')
for name in ('top_tf_hdmi_audio.v','player_status_monitor.v'):
    f=p/'src/user_source/hdl_source'/name
    s=f.read_text(encoding='utf-8-sig').replace('C11303','C11304')
    f.write_text(s,encoding='utf-8')
print('C11304 isolated project and build scripts prepared')
