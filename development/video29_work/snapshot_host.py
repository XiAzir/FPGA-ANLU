"""Read-only Windows memory/process snapshot for this serial build."""
import ctypes
import datetime
import json
import subprocess
from pathlib import Path

class MemoryStatus(ctypes.Structure):
    _fields_=[('length',ctypes.c_ulong),('load_percent',ctypes.c_ulong)]+[
        (name,ctypes.c_ulonglong) for name in ('total_physical','available_physical',
         'total_page_file','available_page_file','total_virtual','available_virtual','available_extended')]

state=MemoryStatus()
state.length=ctypes.sizeof(state)
assert ctypes.windll.kernel32.GlobalMemoryStatusEx(ctypes.byref(state))
cmd="Get-Process -Name td_commands_prompt,td,vsim,vsimk,iverilog,vvp -ErrorAction SilentlyContinue | Select-Object ProcessName,Id,WorkingSet64,PeakWorkingSet64,CPU | ConvertTo-Json -Compress"
process=subprocess.run(['pwsh','-NoProfile','-Command',cmd],capture_output=True,text=True)
text=process.stdout.strip()
data={
 'recorded_local':datetime.datetime.now().astimezone().isoformat(),
 'memory':{name:getattr(state,name) for name,_ in state._fields_},
 'task_tool_processes':json.loads(text) if text else [],
 'policy':'one TD stage at a time; no simultaneous whole-system simulation',
 'operation':'read-only snapshot; no process/cache cleanup or system setting change'
}
out=Path(__file__).resolve().parent/'host_resource_final.json'
out.write_text(json.dumps(data,indent=2),encoding='utf-8')
print(json.dumps(data,indent=2))
