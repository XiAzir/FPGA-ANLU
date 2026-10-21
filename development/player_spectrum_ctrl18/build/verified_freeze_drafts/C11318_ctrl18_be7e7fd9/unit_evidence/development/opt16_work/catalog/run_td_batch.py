from pathlib import Path
import subprocess,sys
root=Path(__file__).resolve().parent
exe=Path(r'C:\Anlogic\TD_6.2.1_SP1_6.2.178.840\bin\td_commands_prompt.exe')
tcl=root/'td_area_high'/'run_batch.tcl'
log=root/'td_area_high'/'td_console.log'
with log.open('wb') as output:
    proc=subprocess.Popen([str(exe),tcl.as_posix()],cwd=tcl.parent,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
    assert proc.stdout is not None
    for line in proc.stdout:
        output.write(line); output.flush()
        sys.stdout.buffer.write(line); sys.stdout.buffer.flush()
    raise SystemExit(proc.wait())
