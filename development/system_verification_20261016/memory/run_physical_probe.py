from pathlib import Path
from datetime import datetime
import sys,os,json,shutil,re,argparse
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'integration'))
from common import BASE,BIN,execute,sha
p=argparse.ArgumentParser();p.add_argument('--reference',action='store_true');a=p.parse_args()
if not os.environ.get('MGLS_LICENSE_FILE'):raise SystemExit('Initialize license environment')
out=BASE/'memory'/('physical_probe_'+datetime.now().strftime('%Y%m%d_%H%M%S'));out.mkdir()
model=Path('C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/sim_release/eg4/eg_phy_sdram_2m_32.v')
models=[model]
if a.reference:
 models=[Path('E:/QQ CACHE/Download/安路资料/赛题1_工作资料/05_补充参考工程/APUG011_SDRAM参考工程/source_code/model/IS42s32200.v'),BASE/'memory/sdram_issi_reference_wrapper.v']
tb=out/'tb_physical_sdram_probe.v';shutil.copy2(BASE/'memory/tb_physical_sdram_probe.v',tb)
(out/'modelsim.ini').write_text('[Library]\nwork = work\nothers = E:/ModelsimSE/modelsim.ini\n')
if execute([BIN/'vlib.exe','work'],out,'vlib.log')['exit_code']:raise SystemExit('vlib failed')
if execute([BIN/'vlog.exe','-modelsimini','modelsim.ini','-work','work']+models+[tb],out,'compile.log')['exit_code']:raise SystemExit('Compile failed '+str(out))
(out/'run.do').write_text('onerror {quit -code 2 -f}\nonbreak {quit -code 3 -f}\nrun -all\nquit -code 0 -f\n')
result=execute([BIN/'vsim.exe','-modelsimini','modelsim.ini','-c','-novopt','work.tb_physical_sdram_probe','-do','run.do','-l','run.log'],out,'console.log',90)
log=(out/'console.log').read_text(errors='replace');match=re.search(r'SDRAM_PHYSICAL_MODEL_PROBE_COMPLETE known=(\d+) matching=(\d+) z=(\d+) x=(\d+)',log)
counts=dict(zip(['known','matching','z','x'],map(int,match.groups()))) if match else None
status='NO_READBACK_MODEL_UNQUALIFIED' if counts and counts['known']==0 else 'READBACK_PRESENT_REQUIRES_CONTROLLER_QUALIFICATION'
(out/'summary.json').write_text(json.dumps(dict(status=status,reference_model=a.reference,simulation=result,counts=counts,inputs=[dict(path=str(p),sha256=sha(p)) for p in models+[tb]],scope='Direct SDRAM macro BL1/CAS2/CAS3 command probe; no conclusion about physical board or full protocol conformance'),indent=2))
print(out,flush=True);print(status,counts,flush=True);print(log[-800:])
