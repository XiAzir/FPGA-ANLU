from pathlib import Path
import subprocess
r=Path('development/video19_work/dht_case').resolve()
with (r/'td.log').open('w') as log:
 p=subprocess.run(['C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/bin/td_commands_prompt.exe',(r/'run_syn.tcl').as_posix()],cwd=r,stdout=log,stderr=subprocess.STDOUT)
print(p.returncode)
print((r/'td.log').read_text()[-1400:])
