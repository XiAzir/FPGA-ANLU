from pathlib import Path
import json,hashlib,re,sys
R=Path(__file__).resolve().parents[2];W=Path(__file__).parent
C=R/'development/player_spectrum_ctrl18';P=C/'build/attempts/A00_same_id_control'
kind=sys.argv[1];assert kind in ('keys','status','combined')
H=C/'src/user_source/hdl_source';sel={}
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def use(name,source,reason):
 d=H/name;d.write_bytes(source.read_bytes());sel['user_source/hdl_source/'+name]={'source':str(source),'sha256':sha(d),'reason':reason}
for name in ('top_tf_hdmi_audio.v','player_adjust_control.v','tf_bmp_file_player.v','status_hex595.v','player_status_mailbox.v'):
 (H/name).write_bytes((P/'src/user_source/hdl_source'/name).read_bytes())
project=C/'src/td_project/AC201_tf_hdmi.al';project.write_bytes((P/'src/td_project/AC201_tf_hdmi.al').read_bytes())
top=(H/'top_tf_hdmi_audio.v').read_text(encoding='utf-8-sig')
if kind in ('keys','combined'):
 use('player_adjust_control.v',W/'key_events/player_adjust_control.v','Event request/ack transport; one per-button cooldown preserves legacy coalescing')
 use('tf_bmp_file_player.v',W/'key_events/tf_bmp_file_player_event_candidate.v','Receive synchronized key events directly instead of debouncing synthesized key levels')
 assert top.count('wire        bmp_key_next, bmp_key_auto;')==1
 top=top.replace('wire        bmp_key_next, bmp_key_auto;','wire bmp_key_next_req,bmp_key_auto_req,bmp_key_next_ack,bmp_key_auto_ack;')
 old='.clk(sd_card_clk),.rst(rst_all),.key_next(bmp_key_next),.key_auto(bmp_key_auto),'
 assert old in top
 top=top.replace(old,'.clk(sd_card_clk),.rst(rst_all),\n    .key_next_req_toggle(bmp_key_next_req),.key_auto_req_toggle(bmp_key_auto_req),\n    .key_next_ack_toggle(bmp_key_next_ack),.key_auto_ack_toggle(bmp_key_auto_ack),')
 old='.next_n(bmp_key_next),.auto_n(bmp_key_auto),.tone_press(debug_tone_press),';assert old in top
 top=top.replace(old,'.next_req_toggle(bmp_key_next_req),.next_ack_async(bmp_key_next_ack),\n .auto_req_toggle(bmp_key_auto_req),.auto_ack_async(bmp_key_auto_ack),.tone_press(debug_tone_press),')
if kind in ('status','combined'):
 old='''wire [31:0] status_hex_system;
player_status_mailbox u_status_mailbox (
    .source_clk(video_clk),.destination_clk(sd_card_clk),.rst(rst_all),
    .source_hex(status_hex),.destination_hex(status_hex_system)
);
status_hex595 #(.CLK_HZ(50000000)) u_status_hex (
    .clk(sd_card_clk),.rst(rst_all),.hex_value(status_hex_system),'''
 assert old in top
 top=top.replace(old,'''status_hex595 #(.CLK_HZ(25000000)) u_status_hex (
    .clk(video_clk),.rst(rst_all),.hex_value(status_hex),''')
 oldpath=H/'player_status_mailbox.v';digest=sha(oldpath);oldpath.unlink()
 sel['user_source/hdl_source/player_status_mailbox.v']={'action':'remove','parent_sha256':digest,'reason':'595 consumes its complete frame directly in the status source video-clock domain'}
 text=project.read_text(encoding='utf-8-sig')
 pat=r'            <File Path="../user_source/hdl_source/player_status_mailbox.v">.*?</File>\r?\n'
 match=re.search(pat,text,re.S);assert match
 removed=int(re.search(r'Name="CompileOrder" Val="(\d+)"',match[0])[1])
 text=text[:match.start()]+text[match.end():]
 text=re.sub(r'(Name="CompileOrder" Val=")(\d+)(")',lambda m:m[1]+str(int(m[2])-(int(m[2])>removed))+m[3],text)
 pp=W/'selected_project.al';pp.write_text(text,encoding='utf-8');project.write_bytes(pp.read_bytes())
 sel['td_project/AC201_tf_hdmi.al']={'source':str(pp),'sha256':sha(project),'reason':'Retire mailbox source and normalize compile order before guarded synthesis'}
out=W/('top_'+kind+'.v');out.write_text(top,encoding='utf-8');(H/'top_tf_hdmi_audio.v').write_bytes(out.read_bytes())
sel['user_source/hdl_source/top_tf_hdmi_audio.v']={'source':str(out),'sha256':sha(out),'reason':'C11318 '+kind+' control interface integration'}
(C/'build/selected_changes.json').write_text(json.dumps(sel,indent=2)+'\n');print('SELECTED',kind,len(sel))
