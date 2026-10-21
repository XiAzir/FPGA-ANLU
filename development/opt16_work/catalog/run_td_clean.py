from pathlib import Path
import subprocess,sys
root=Path(__file__).resolve().parent
folder=root/'td_area_high'/'clean_combined'; tcl=folder/'run_syn.tcl'
exe=Path(r'C:\Anlogic\TD_6.2.1_SP1_6.2.178.840\bin\td_commands_prompt.exe')
log=folder/'td_console.log'
with log.open('wb') as output:
    proc=subprocess.Popen([str(exe),tcl.as_posix()],cwd=tcl.parent,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
    assert proc.stdout is not None
    for line in proc.stdout:
        output.write(line); output.flush()
        text=line.decode('utf-8','replace').strip()
        if any(token in text for token in ('AREA_BEGIN','AREA_OUTPUT','SYNTHESIS_COMPLETE','BUILD_ERROR','CRITICAL-WARNING')):
            print(text,flush=True)
    code=proc.wait()
print(f'TD_EXIT={code}',flush=True)
raise SystemExit(code)
