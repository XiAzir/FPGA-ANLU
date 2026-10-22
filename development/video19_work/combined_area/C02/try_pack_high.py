from pathlib import Path
import shutil,subprocess
live=Path('development/player_video19').resolve();root=Path('development/video19_work/combined_area/C02').resolve();shutil.copytree(live/'build/manual',root/'whole_gate',dirs_exist_ok=True)
script=(live/'scripts/build_manual_phy.tcl').read_text()
script=script.replace('set output_dir $task_root/build/manual','set output_dir '+(root/'whole_gate').as_posix())
script=script.replace('    commit_param -step place','    set_param gate pack_effort high\n    commit_param -step place')
script=script.replace('set task_root [file normalize [file join [file dirname [info script]] ..]]','set task_root '+live.as_posix())
(root/'pack_high.tcl').write_text(script)
with (root/'pack_high.log').open('w') as log:
 p=subprocess.run(['C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/bin/td_commands_prompt.exe',(root/'pack_high.tcl').as_posix()],cwd=live/'src/td_project',stdout=log,stderr=subprocess.STDOUT)
print('PACK_HIGH_EXIT',p.returncode);print((root/'pack_high.log').read_text()[-2200:])
