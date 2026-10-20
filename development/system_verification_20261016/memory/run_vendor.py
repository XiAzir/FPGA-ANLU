from pathlib import Path
from datetime import datetime
import sys,os,json
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'integration'))
from common import BASE,BIN,archived_sources,compile_sources,execute

if not os.environ.get('MGLS_LICENSE_FILE'):raise SystemExit('Initialize existing license environment')
out=Path(__file__).resolve().parent/('vendor_'+datetime.now().strftime('%Y%m%d_%H%M%S'))
out.mkdir()
sources,flags,receipt=archived_sources('C11206',out)
# Resolve only the real memory dependency tree for this unit qualification.
names={'eg_phy_pll_init_adapter.v','sys_pll.v','sdram.v','sdr_as_ram.enc.v','sdr_init_ref.enc.v','sdr_wrrd.enc.v'}
sources=[p for p in sources if p.name in names]
flags=['-permissive']+flags
compile_result=compile_sources(out,sources,flags,Path(__file__).with_name('tb_vendor_memory.v'))
(out/'run.do').write_text('onerror {quit -code 2 -f}\nonbreak {quit -code 3 -f}\nrun -all\nquit -code 0 -f\n')
call=execute([BIN/'vsim.exe','-modelsimini','modelsim.ini','-c','-lic_noqueue','-novopt','-suppress','3017,3722','-L','work','-L','eg4','-L','hdmi','work.tb_vendor_memory','eg4.glbl','-do','run.do','-l','run.log'],out,'console.log',240)
text=(out/'console.log').read_text(errors='replace')
status='MODEL_TRACE_AVAILABLE' if call['exit_code']==0 and 'MEM_TRACE_COMPLETE' in text and '** Fatal' not in text and '** Error' not in text else 'VENDOR_MEMORY_UNQUALIFIED'
summary=dict(status=status,compile=compile_result,simulation=call,markers=[l for l in text.splitlines() if any(x in l for x in ['BOUNDARY','MEM_','Error','Fatal'])])
(out/'summary.json').write_text(json.dumps(summary,indent=2))
print(status,flush=True)
for line in summary['markers']:print(line,flush=True)
print(out,flush=True)
