from pathlib import Path
import re
p=Path('development/player_video23_mode_switch/src/td_project/AC201_tf_hdmi.al')
t=p.read_text(encoding='utf-8-sig')
match=re.search(r'            <File Path="../user_source/hdl_source/player_pcm_crc_probe.v">.*?</File>',t,re.S)
assert match
for i,name in enumerate(['player_mode_quiesce.v','player_media_restart.v']):
 pattern=r'            <File Path="../user_source/hdl_source/'+name+r'">.*?</File>'
 entry=match.group().replace('player_pcm_crc_probe.v',name)
 entry=re.sub(r'(<Attr Name="CompileOrder" Val=")[^"]+',lambda m:m[1]+str(91+i),entry)
 t,n=re.subn(pattern,lambda m:entry,t,flags=re.S);assert n==1
p.write_text(t,encoding='utf-8')
