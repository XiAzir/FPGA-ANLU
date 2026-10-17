"""Unchanged synthesized controller + vendor pads + official pin memory model.

Requires exact content with one fixed data-to-valid edge offset; never searches
for a passing alignment. Raw trace is kept even on failures.
"""
from pathlib import Path
from datetime import datetime
import sys,os,json,shutil,re,argparse
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'integration'))
from common import BASE,BIN,EG4,execute,sha
p=argparse.ArgumentParser();p.add_argument('--data-offset',type=int,default=-1);p.add_argument('--matrix',action='store_true');p.add_argument('--corrupt-data',action='store_true');a=p.parse_args()
if not os.environ.get('MGLS_LICENSE_FILE'):raise SystemExit('Initialize license environment')
out=BASE/'memory'/('controller_model_'+datetime.now().strftime('%Y%m%d_%H%M%S'));out.mkdir()
gate_info=json.loads((BASE/'memory/controller_gate_latest.json').read_text())
gate_source=Path(gate_info['directory'])/'build/controller_gate.v'
if sha(gate_source)!=gate_info['gate_sha256']:raise ValueError('Controller gate hash mismatch')
reference=Path('E:/QQ CACHE/Download/安路资料/赛题1_工作资料/05_补充参考工程/APUG011_SDRAM参考工程/source_code/model/IS42s32200.v')
sources=[gate_source,reference,BASE/'memory/sdram_issi_reference_wrapper.v',
 Path('C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/sim_release/eg4/eg_phy_glbl.v'),BASE/'memory'/('tb_controller_gate_matrix.v' if a.matrix else 'tb_controller_gate.v')]
copied=[]
for source in sources:
 target=out/source.name;shutil.copy2(source,target);copied.append(target)
(out/'source_receipt.json').write_text(json.dumps(dict(inputs=[dict(source=str(s),copy=str(t),sha256=sha(s)) for s,t in zip(sources,copied)],
 controller_build=gate_info,consumer_data_offset_cycles=a.data_offset,scope='Isolated synthesized production controller, official APUG011 pin-level memory model, native vendor PADs; no SDF, nominal 50MHz/144-degree clocks'),indent=2))
(out/'modelsim.ini').write_text('[Library]\nwork = work\neg4 = '+EG4.as_posix()+'\nothers = E:/ModelsimSE/modelsim.ini\n')
print(out,flush=True)
if execute([BIN/'vlib.exe','work'],out,'vlib.log')['exit_code']:raise SystemExit('vlib failed')
if execute([BIN/'vlog.exe','-modelsimini','modelsim.ini','-work','work']+copied,out,'compile.log')['exit_code']:raise SystemExit('Compile failed '+str(out))
(out/'run.do').write_text('onerror {quit -code 2 -f}\nonbreak {quit -code 3 -f}\nrun -all\nquit -code 0 -f\n')
result=execute([BIN/'vsim.exe','-modelsimini','modelsim.ini','-c','-novopt','-suppress','3017,3722','-L','work','-L','eg4','work.tb_controller_gate','work.glbl']+(['+corrupt_data'] if a.corrupt_data else [])+['-do','run.do','-l','run.log'],out,'console.log',240)
log=(out/'console.log').read_text(errors='replace');trace=out/'controller_memory.csv'
rows=[line.split(',') for line in trace.read_text().splitlines()] if trace.exists() else []
by_cycle={int(r[0]):r for r in rows};errors=[];checked=0
expected=[int(line.split(',')[1],16) for line in (out/'expected.csv').read_text().splitlines()] if a.matrix and (out/'expected.csv').exists() else [(0x93a50000^(i*0x0103070b))&0xffffffff for i in range(256)]
for row in rows:
 if row[3]!='1':continue
 source=by_cycle.get(int(row[0])+a.data_offset)
 got=source[4] if source else 'missing'
 want=expected[checked] if checked<len(expected) else -1
 if got.lower()!=f'{want:08x}':errors.append(dict(index=checked,cycle=int(row[0]),got=got,expected=f'{want:08x}'))
 checked+=1
badlog=bool(re.search(r'(?:\*\* (?:Error|Fatal)|FATAL|ERROR:)',log))
base_ok=result['exit_code']==0 and 'CONTROLLER_TRACE_COMPLETE' in log and not badlog and checked==len(expected) and len(expected)==(1024 if a.matrix else 256)
ok=base_ok and (len(errors)==1 and errors[0]['index']==20 if a.corrupt_data else not errors)
summary=dict(status=('NEGATIVE_DATA_DETECTED' if a.corrupt_data else 'PASS_SCOPE_PIN_MODEL') if ok else 'NOT_QUALIFIED',matrix=a.matrix,corrupt_data=a.corrupt_data,simulation=result,checked_words=checked,mismatch_count=len(errors),first_mismatches=errors[:12],data_offset_cycles=a.data_offset,
 limitations=['Not full-top implementation or routed timing simulation','APUG011 reference chip model is not a guarantee of SiP silicon electrical timing','Nominal bank-aligned bursts, four banks, byte masks and post-refresh retention' if a.matrix else 'Only nominal contiguous 256-word access in this test'])
(out/'summary.json').write_text(json.dumps(summary,indent=2));print(json.dumps(summary,indent=2),flush=True);print(log[-2300:],flush=True)
if ok:
 key='matrix_negative' if a.corrupt_data else ('matrix_positive' if a.matrix else 'basic')
 (BASE/'memory'/('controller_'+key+'_latest.json')).write_text(json.dumps(dict(directory=str(out),summary_sha256=sha(out/'summary.json')),indent=2))
raise SystemExit(0 if ok else 2)
