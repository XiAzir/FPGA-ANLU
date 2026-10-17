from pathlib import Path
import shutil, json, hashlib

root=Path('E:/VSCODE-project/FPGA-ANLU')
old=root/'development/player_music_envelope'
new=root/'development/player_music_envelope_phy'
if new.exists():
 assert not (new/'build').exists(), 'Never overwrite a built candidate'
 assert all(p.read_bytes()==(old/p.relative_to(new)).read_bytes() for p in (new/'src/user_source').rglob('*') if p.is_file()), 'Resume only untouched partial source copy'
for rel in ('src/user_source','src/td_project/al_ip','scripts'):
 shutil.copytree(old/rel,new/rel,dirs_exist_ok=True)
(new/'src/td_project/AC201_tf_hdmi.al').write_text((old/'src/td_project/AC201_tf_hdmi.al').read_text(encoding='utf-8-sig').replace('player_music_envelope/','player_music_envelope_phy/'),encoding='utf-8')
for p in (new/'scripts').iterdir():
 if p.is_file():
  text=p.read_text(encoding='utf-8-sig')
  text=text.replace('player_music_envelope','player_music_envelope_phy')
  p.write_text(text,encoding='utf-8')
for name in ('top_tf_hdmi_audio.v','player_status_monitor.v'):
 p=new/'src/user_source/hdl_source'/name
 p.write_text(p.read_text(encoding='utf-8-sig').replace('C11302','C11303'),encoding='utf-8')
p=new/'src/user_source/hdl_source/lane_lvds_10_1.v'
text=p.read_text(encoding='utf-8-sig')
text=text.replace('always @(posedge I_pixel_clk or posedge I_rst)', '''// Launch the word marker halfway between adjacent serial rising edges.
    // The PHY captures the corresponding complete TMDS word on this same
    // pixel falling edge; serial pending capture follows three cycles later.
    always @(negedge I_pixel_clk or posedge I_rst)''',1)
p.write_text(text,encoding='utf-8')
p=new/'src/user_source/hdl_source/hdmi_phy_warpper.v'
text=p.read_text(encoding='utf-8-sig')
insert='''    // Capture all TMDS lanes as one word on the middle of the pixel period.
    // Includes video, controls, audio/data islands and forwarded clock alike.
    // The lane marker also launches on this falling edge. With the existing
    // 25/125 MHz PLL, it is 4 ns from either adjacent serial rising edge.
    reg [9:0] tmds_word_0, tmds_word_1, tmds_word_2, tmds_word_clk;
    always @(negedge I_pixel_clk or posedge I_rst) begin
        if (I_rst) begin
            tmds_word_0 <= 10'd0;
            tmds_word_1 <= 10'd0;
            tmds_word_2 <= 10'd0;
            tmds_word_clk <= 10'd0;
        end else begin
            tmds_word_0 <= I_tmds_channel_0;
            tmds_word_1 <= I_tmds_channel_1;
            tmds_word_2 <= I_tmds_channel_2;
            tmds_word_clk <= I_tmds_channel_clk;
        end
    end

'''
text=text.replace('    wire[9:0] S_tmds_data_ch0;',insert+'    wire[9:0] S_tmds_data_ch0;',1)
for src,dst in [('I_tmds_channel_0[','tmds_word_0['),('I_tmds_channel_1[','tmds_word_1['),('I_tmds_channel_2[','tmds_word_2['),('I_tmds_channel_clk[','tmds_word_clk[')]:
 text=text.replace(src,dst)
p.write_text(text,encoding='utf-8')
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest().upper()
diff=[]
files=[]
for p in (new/'src/user_source').rglob('*'):
 if p.is_file():
  rel=p.relative_to(new/'src')
  q=old/'src'/rel
  row={'path':str(rel).replace('\\','/'),'parentSha256':sha(q),'sha256':sha(p),'changed':p.read_bytes()!=q.read_bytes()}
  files.append(row)
  if row['changed']: diff.append(row['path'])
assert len(diff)==4, diff
(new/'build').mkdir()
(new/'build/source_diff.json').write_text(json.dumps({'parent':'C11302 FAILED','version':'C11303','files':files,'changed':diff},indent=2)+'\n',encoding='utf-8')
print(json.dumps({'project':str(new),'changed':diff,'sourceCount':len(files)},indent=2))
