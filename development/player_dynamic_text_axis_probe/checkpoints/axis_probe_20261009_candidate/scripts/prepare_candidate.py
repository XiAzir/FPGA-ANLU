from pathlib import Path
import shutil, re, json, hashlib, datetime

root=Path(r'E:\VSCODE-project\FPGA-ANLU')
old=root/'development/player_dynamic_text_video_probe'
new=root/'development/player_dynamic_text_axis_probe'
assert not (new/'build/manual').exists(), 'Do not overwrite a candidate that has entered TD build'
assert not (new/'build/preparation.json').exists(), 'Do not overwrite a completed preparation'
shutil.copytree(old/'src/user_source',new/'src/user_source',dirs_exist_ok=True)
shutil.copytree(old/'src/td_project/al_ip',new/'src/td_project/al_ip',dirs_exist_ok=True)
al=(old/'src/td_project/AC201_tf_hdmi.al').read_bytes().decode('utf-8')
al=al.replace(str(old).replace('\\','/'),str(new).replace('\\','/')).replace(str(old),str(new))
end_tag='        </Verilog>'
assert al.count(end_tag)==1
orders=[int(v) for v in re.findall(r'<Attr Name="CompileOrder" Val="(\d+)"',al)]
module='''            <File Path="../user_source/hdl_source/player_axis_input_probe.v">\r
                <FileInfo>\r
                    <Attr Name="UsedInSyn" Val="true"/>\r
                    <Attr Name="UsedInP&R" Val="true"/>\r
                    <Attr Name="BelongTo" Val="design_1"/>\r
                    <Attr Name="CompileOrder" Val="%d"/>\r
                </FileInfo>\r
            </File>\r
''' % (max(orders)+1)
al=al.replace(end_tag,module+end_tag)
(new/'src/td_project/AC201_tf_hdmi.al').write_bytes(al.encode('utf-8'))
top_path=new/'src/user_source/hdl_source/top_tf_hdmi_audio.v'
top=top_path.read_bytes().decode('utf-8')
assert top.count('wire [19:0] packet_cts, packet_n;')==1
top=top.replace('wire [19:0] packet_cts, packet_n;','wire [23:0] packet_cts, packet_n;')
start=top.index('// Passive branch from the transmitter\'s parallel outputs; never feeds PHY.')
end=top.index('\nplayer_status_monitor',start)
replacement='''// Passive video-input observer. Status pages 6..C are AXIS diagnostics in this build.\r
// Observed wires are not fed back into the core or the video source.\r
player_axis_input_probe u_axis_input_probe (\r
    .clk(video_clk), .rst(rst_all),\r
    .valid(axis_s_valid), .user(axis_s_user), .last(axis_s_last),\r
    .ready(axis_s_ready), .locked(hdmi_video_locked),\r
    .flags(packet_flags), .dims(packet_samples),\r
    .frame_period(packet_count), .frame_pixels(packet_bad_bch),\r
    .bad_counts(packet_bad_terc), .gap_ready(packet_tone_bad),\r
    .frame_last_count(packet_cts), .user_frames(packet_n)\r
);\r
'''
top=top[:start]+replacement+top[end:]
top_path.write_bytes(top.encode('utf-8'))
status_path=new/'src/user_source/hdl_source/player_status_monitor.v'
status=status_path.read_bytes().decode('utf-8')
assert status.count('input [19:0] packet_cts, packet_n,')==1
status=status.replace('// Packet-focused observer. Input pixel/change counts remain evidenced in status_diag.', '// AXIS input diagnostics on pages 6..C. Legacy packet port names carry observer payloads.')
status=status.replace('input [19:0] packet_cts, packet_n,','input [23:0] packet_cts, packet_n,')
status=status.replace("{4'hB,packet_flags,4'd0,packet_cts}","{4'hB,packet_flags,packet_cts}")
status=status.replace("{4'hC,packet_flags,4'd0,packet_n}","{4'hC,packet_flags,packet_n}")
status=status.replace('// Packet outputs are registered in the SAME pixel-clock domain as the','// Diagnostic payloads are registered in the SAME pixel-clock domain as the')
status_path.write_bytes(status.encode('utf-8'))
for name in ('build_candidate.ps1','build_manual_syn.tcl','build_manual_phy.tcl','fix_hold.tcl','generate_bit.tcl'):
    text=(old/'scripts'/name).read_bytes().decode('utf-8')
    text=text.replace(str(old).replace('\\','/'),str(new).replace('\\','/')).replace(str(old),str(new))
    text=text.replace('AC201_player_dynamic_text_video_probe.bit','AC201_player_dynamic_text_axis_probe.bit')
    (new/'scripts'/name).write_bytes(text.encode('utf-8'))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest().upper()
old_files={p.relative_to(old/'src/user_source').as_posix():sha(p) for p in (old/'src/user_source').rglob('*') if p.is_file()}
new_files={p.relative_to(new/'src/user_source').as_posix():sha(p) for p in (new/'src/user_source').rglob('*') if p.is_file()}
changed=[p for p,h in old_files.items() if new_files[p]!=h]
added=sorted(new_files.keys()-old_files.keys())
assert changed==['hdl_source/top_tf_hdmi_audio.v','hdl_source/player_status_monitor.v'] or set(changed)=={'hdl_source/top_tf_hdmi_audio.v','hdl_source/player_status_monitor.v'},changed
assert added==['hdl_source/player_axis_input_probe.v'],added
assert sha(old/'src/user_source/hdl_source/video_rgb_to_axis_640x480.v')==sha(new/'src/user_source/hdl_source/video_rgb_to_axis_640x480.v')
now=datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
info={'created_beijing':now,'source_project':str(old),'candidate_project':str(new),'changed':changed,'added':added,'unchanged_old_user_source':74,'models':'PENDING','td_build':'NOT_STARTED','hardware_result':'NOT_TESTED','root_cause':'NOT_CONFIRMED','change':'Replace passive HDMI-output packet observer with passive HDMI-input video observer; core/source/data/control/PLL/constraints retained, including original TLAST comparator; 24bit diagnostic B/C pages','limitations':['Layout/fanout changes; candidate recovery does not identify old unique root cause.','No card/Flash operations.']}
(new/'build').mkdir(exist_ok=True)
(new/'build/preparation.json').write_text(json.dumps(info,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps(info,ensure_ascii=False))
