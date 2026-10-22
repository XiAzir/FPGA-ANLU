from pathlib import Path
import shutil,json,hashlib
base=Path('development/player_video23_mode_switch');new=Path('development/player_video25_sdhc_init')
assert not new.exists()
(new/'src/td_project').mkdir(parents=True)
shutil.copytree(base/'src/user_source',new/'src/user_source')
shutil.copytree(base/'src/td_project/al_ip',new/'src/td_project/al_ip')
shutil.copytree(base/'scripts',new/'scripts')
shutil.copy2(base/'src/td_project/AC201_tf_hdmi.al',new/'src/td_project/AC201_tf_hdmi.al')
for p in list((new/'scripts').iterdir())+[new/'src/td_project/AC201_tf_hdmi.al']:
 t=p.read_text(encoding='utf-8-sig').replace('player_video23_mode_switch','player_video25_sdhc_init');p.write_text(t,encoding='utf-8')
shutil.copy2('development/video23_work/startup_review/skip_cmd16/sd_card_sec_read_write.v',new/'src/user_source/hdl_source/SD/sd_card_sec_read_write.v')
p=new/'src/user_source/hdl_source/player_compact_status_pages.v';t=p.read_text(encoding='utf-8-sig').replace("32'h00C11323","32'h00C11325");p.write_text(t,encoding='utf-8')
(new/'verification').mkdir()
for name in ['check_final_stages.ps1','dump_final_routed.tcl']:
 t=(base/'verification'/name).read_text(encoding='utf-8-sig').replace('player_video23_mode_switch','player_video25_sdhc_init');(new/'verification'/name).write_text(t,encoding='utf-8')
assert '.SPI_HIGH_SPEED_DIV(0)' in (new/'src/user_source/hdl_source/top_tf_hdmi_audio.v').read_text(encoding='utf-8-sig')
print('C25 skip-CMD16 SHA',hashlib.sha256((new/'src/user_source/hdl_source/SD/sd_card_sec_read_write.v').read_bytes()).hexdigest())
