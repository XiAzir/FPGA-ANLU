from pathlib import Path
import shutil,xml.etree.ElementTree as ET,re,hashlib,json
root=Path('development/player_video23_mode_switch')
assert not (root/'verification/final_binding.json').exists()
base=Path('development/player_video22_audio_diag')
(root/'src/td_project').mkdir(parents=True,exist_ok=True)
shutil.copytree(base/'src/user_source',root/'src/user_source',dirs_exist_ok=True)
shutil.copytree(base/'src/td_project/al_ip',root/'src/td_project/al_ip',dirs_exist_ok=True)
shutil.copy2(base/'src/td_project/AC201_tf_hdmi.al',root/'src/td_project/AC201_tf_hdmi.al')
shutil.copytree(base/'scripts',root/'scripts',dirs_exist_ok=True)
for p in list((root/'scripts').glob('*'))+[root/'src/td_project/AC201_tf_hdmi.al']:
 t=p.read_text(encoding='utf-8-sig').replace('player_video22_audio_diag','player_video23_mode_switch')
 p.write_text(t,encoding='utf-8')
hdl=root/'src/user_source/hdl_source'
shutil.copy2('development/video23_work/mode_analysis/player_mode_quiesce.v',hdl/'player_mode_quiesce.v')
p=hdl/'player_mode_quiesce.v';t=p.read_text(encoding='utf-8-sig').replace('reg [1:0] req_sync;', '(* async_reg = "true" *) reg [1:0] req_sync;').replace('reg [1:0] ack_sync;', '(* async_reg = "true" *) reg [1:0] ack_sync;');p.write_text(t,encoding='utf-8')
p=hdl/'SD/sd_card_sec_read_write.v';t=p.read_text(encoding='utf-8-sig');t=t.replace('output reg       sd_init_done,','output reg       sd_init_done,\n    output wire      sd_idle,');t=t.replace('reg[31:0]                      sec_addr;','reg[31:0]                      sec_addr;\nassign sd_idle = (state == S_WAIT_READ_WRITE);');p.write_text(t,encoding='utf-8')
p=hdl/'SD/sd_card_top.v';t=p.read_text(encoding='utf-8-sig');t=t.replace('output           sd_init_done,','output           sd_idle,\n\toutput           sd_init_done,');t=t.replace('.sd_init_done                   (sd_init_done           ),','.sd_init_done                   (sd_init_done           ),\n    .sd_idle                        (sd_idle                ),');p.write_text(t,encoding='utf-8')
p=hdl/'player_compact_status_pages.v';t=p.read_text(encoding='utf-8-sig').replace("32'h00C11322","32'h00C11323");p.write_text(t,encoding='utf-8')
p=hdl/'top_tf_hdmi_audio.v';t=p.read_text(encoding='utf-8-sig');a=t.index('reg video_mode;');b=t.index('always @(posedge sd_card_clk or posedge rst_all_reg)',a)
old=t[a:b]
new='''wire video_mode;
wire media_reset_active;
reg [1:0] video_mode_sd_sync;
reg video_restart_toggle;
wire video_next_press, video_auto_press;
wire video_key_next_ack, video_key_auto_ack;
wire photo_key_next_ack, photo_key_auto_ack;
wire video_mode_sd=video_mode_sd_sync[1];
wire mode_request_toggle,mode_ack_toggle,mode_commit_toggle;
wire mode_gate_new_sector,mode_switch_busy,card_idle;
player_media_restart u_media_restart (
    .clk(video_clk),.rst(rst_all_reg),.mode_press(video_mode_press),
    .restart_toggle_async(video_restart_toggle),.commit_toggle_async(mode_commit_toggle),
    .request_toggle(mode_request_toggle),.ack_toggle(mode_ack_toggle),
    .video_mode(video_mode),.media_reset(media_reset_active)
);
player_mode_quiesce u_mode_quiesce (
    .clk(sd_card_clk),.rst(rst_all_reg),
    .request_toggle_async(mode_request_toggle),.ack_toggle_async(mode_ack_toggle),
    .physical_idle(card_idle),.mount_ready(fs_ready),
    .gate_new_sector(mode_gate_new_sector),.commit_toggle(mode_commit_toggle),
    .busy(mode_switch_busy)
);
'''
t=t[:a]+new+t[b:]
t=t.replace('.clk(sd_card_clk),.rst(rst_all),.sd_init_done(card_init_done)', '.clk(sd_card_clk),.rst(rst_all_reg),.sd_init_done(card_init_done)')
t=t.replace('assign shared_card_read=fs_ready ? arb_card_read : fs_read;', 'assign shared_card_read=fs_ready ? (arb_card_read && !mode_gate_new_sector) : fs_read;')
t=t.replace('.clk(sd_card_clk), .rst(rst_all),\n    .SD_nCS', '.clk(sd_card_clk), .rst(rst_all_reg),\n    .SD_nCS')
t=t.replace('.sd_init_done(card_init_done),\n    .sd_sec_read', '.sd_init_done(card_init_done),.sd_idle(card_idle),\n    .sd_sec_read')
p.write_text(t,encoding='utf-8')
# Keep project formatting and let TD derive compile ordering on analysis.
p=root/'src/td_project/AC201_tf_hdmi.al';t=p.read_text(encoding='utf-8-sig');anchor=t.index('\n        </Verilog>')
entry=''
for name in ['player_mode_quiesce.v','player_media_restart.v']:
 entry+='\n            <File Path="../user_source/hdl_source/'+name+'"><FileInfo><Attr Name="AutoExcluded" Val="false"/><Attr Name="UsedInSyn" Val="true"/><Attr Name="UsedInP&amp;R" Val="true"/><Attr Name="BelongTo" Val="design_1"/></FileInfo></File>'
t=t[:anchor]+entry+t[anchor:];p.write_text(t,encoding='utf-8')
(root/'verification').mkdir(exist_ok=True)
manifest=[]
for p in sorted((base/'src/user_source').rglob('*')):
 if p.is_file(): manifest.append({'path':str(p.relative_to(base/'src')),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()})
(root/'verification/parent_c22_inputs.json').write_text(json.dumps(manifest,indent=2))
print(root)


