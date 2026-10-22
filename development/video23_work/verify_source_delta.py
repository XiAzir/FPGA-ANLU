from pathlib import Path
import hashlib,json,re
base=Path('development/player_video22_audio_diag/src/user_source')
new=Path('development/player_video23_mode_switch/src/user_source')
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
a={p.relative_to(base).as_posix():sha(p) for p in base.rglob('*') if p.is_file()}
b={p.relative_to(new).as_posix():sha(p) for p in new.rglob('*') if p.is_file()}
changed=[k for k in a if a[k]!=b.get(k)]
added=[k for k in b if k not in a]
expected=['hdl_source/SD/sd_card_sec_read_write.v','hdl_source/SD/sd_card_top.v','hdl_source/player_compact_status_pages.v','hdl_source/top_tf_hdmi_audio.v']
assert sorted(changed)==sorted(expected),(changed,added)
assert sorted(added)==['hdl_source/player_media_restart.v','hdl_source/player_mode_quiesce.v']
old_top=(base/'hdl_source/top_tf_hdmi_audio.v').read_text(encoding='utf-8-sig')
new_top=(new/'hdl_source/top_tf_hdmi_audio.v').read_text(encoding='utf-8-sig')
# Check audio module, PLL, timing and PHY files byte-for-byte through file hashes.
for name in ['player_audio_probe.v','wav_pcm_bridge.v','audio_arc_calculate.v','tf_wav_file_player.v','frame_buffer_rgb888.v','IP/video_pll.v','IP/sys_pll.v','hdmi_phy_warpper.v','lane_lvds_10_1.v','hdmi1.4b_transmitter_core/hdmi_1_4b_transmitter_core_wrapper.enc.v']:
 assert a['hdl_source/'+name]==b['hdl_source/'+name],name
for k in a:
 if '/jpeg/' in k: assert a[k]==b[k]
# Production SD changes are a passive idle output, no SPI state algorithm changes.
for name in ['sd_card_sec_read_write.v','sd_card_top.v']:
 old=(base/'hdl_source/SD'/name).read_text(encoding='utf-8-sig')
 text=(new/'hdl_source/SD'/name).read_text(encoding='utf-8-sig')
 if name=='sd_card_sec_read_write.v':
  text=text.replace('    output wire      sd_idle,\n','').replace('assign sd_idle = (state == S_WAIT_READ_WRITE);\n','')
 else:
  text=text.replace('\toutput           sd_idle,\n','').replace('    .sd_idle                        (sd_idle                ),\n','')
 assert text==old,name
result={'status':'PASS','unchanged_file_count':len(a)-len(changed),'changed':changed,'added':added,'removed':list(set(a)-set(b)),'parent':a,'candidate':b,'passive_sd_idle_exact_normalized':True,'unchanged_audio_pll_phy_constraints_jpeg':True}
Path('development/player_video23_mode_switch/verification/source_delta.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
print({k:result[k] for k in ['status','unchanged_file_count','changed','added']})
