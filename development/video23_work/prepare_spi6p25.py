from pathlib import Path
import shutil
base=Path('development/player_video23_mode_switch');new=Path('development/player_video24_spi6p25_diag')
assert not new.exists()
(new/'src/td_project').mkdir(parents=True)
shutil.copytree(base/'src/user_source',new/'src/user_source')
shutil.copytree(base/'src/td_project/al_ip',new/'src/td_project/al_ip')
shutil.copytree(base/'scripts',new/'scripts')
shutil.copy2(base/'src/td_project/AC201_tf_hdmi.al',new/'src/td_project/AC201_tf_hdmi.al')
for p in list((new/'scripts').iterdir())+[new/'src/td_project/AC201_tf_hdmi.al']:
 t=p.read_text(encoding='utf-8-sig').replace('player_video23_mode_switch','player_video24_spi6p25_diag')
 p.write_text(t,encoding='utf-8')
p=new/'src/user_source/hdl_source/top_tf_hdmi_audio.v';t=p.read_text(encoding='utf-8-sig');assert t.count('sd_card_top #(.SPI_HIGH_SPEED_DIV(0))')==1;t=t.replace('sd_card_top #(.SPI_HIGH_SPEED_DIV(0))','sd_card_top #(.SPI_HIGH_SPEED_DIV(2))');p.write_text(t,encoding='utf-8')
p=new/'src/user_source/hdl_source/player_compact_status_pages.v';t=p.read_text(encoding='utf-8-sig').replace("32'h00C11323","32'h00C11324");p.write_text(t,encoding='utf-8')
(new/'verification').mkdir()
for name in ['check_final_stages.ps1','dump_final_routed.tcl']:
 t=(base/'verification'/name).read_text(encoding='utf-8-sig').replace('player_video23_mode_switch','player_video24_spi6p25_diag');(new/'verification'/name).write_text(t,encoding='utf-8')
print(new)
