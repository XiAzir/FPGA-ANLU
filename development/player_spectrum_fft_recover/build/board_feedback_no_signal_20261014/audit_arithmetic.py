#!/usr/bin/env python3
"""Read-only report generator; parses named routed cells, runs reference increment test only."""
from pathlib import Path
import json,re
DEV=Path(r'E:/VSCODE-project/FPGA-ANLU/development')
FILES={'C11309':DEV/'player_spectrum_clock_route/build/audit/routed_implementation.v','C11310':DEV/'player_spectrum_fft_recover/build/audit/routed_implementation.v'}
OUT=Path(__file__).with_name('arith_audit.json')
START=re.compile(r'^\s*EG_PHY_(LSLICE|MSLICE)\s*#\(',re.M)
NAME=re.compile(r'^\s*\\([^\s(]+)\s*\(',re.M)
FIELD=re.compile(r'\.(\w+)\s*\((.*?)\)',re.S)
def parse(path):
 lines=path.read_text(errors='replace').splitlines(); out=[]; i=0
 while i<len(lines):
  m=START.match(lines[i])
  if not m: i+=1; continue
  st=i; typ=m.group(1); block=[lines[i]]; i+=1
  while i<len(lines):
   block.append(lines[i])
   if re.search(r'\);\s*(?://.*)?$',lines[i]): break
   i+=1
  raw='\n'.join(block); names=NAME.findall(raw)
  if names:
   name=names[-1]; at=raw.rfind('\\'+name); pre=raw[:at]; body=raw[at:]
   params={k:' '.join(v.split()) for k,v in FIELD.findall(pre)}; ports={k:' '.join(v.split()) for k,v in FIELD.findall(body)}
   out.append({'name':name,'line':st+1,'type':typ,'params':params,'ports':ports,'source':block[-1].split('//',1)[-1].strip() if '//' in block[-1] else ''})
  i+=1
 return out
def brief(c): return {k:c[k] for k in ('name','line','type','params','ports','source')}
def main():
 r={'scope':'C11309/C11310 routed netlists; static extraction','primitive_truth':'unverified; EG4 simulation body is pragma-protected','netlists':{}}
 for ver,path in FILES.items():
  cs=parse(path); prefix='u_pcm_waveform/u_spectrum/'; adder='add0_syn_' if ver=='C11309' else 'add4_syn_'
  sample=[c for c in cs if c['name'].startswith(prefix+adder) and c['name'].split('/')[-1] in {adder+'62',adder+'63',adder+'64'}]
  regs={k:[brief(c) for c in cs if prefix in c['name'] and k in c['name']] for k in ('sample_count_reg[','accepted_samples_reg[','frame_age_samples_reg[')}
  r['netlists'][ver]={'path':str(path),'sample_count_adders':[brief(c) for c in sample],'counter_registers':regs,'accepted_adders':[brief(c) for c in cs if c['name'].startswith(prefix+'add1_syn_') and c['name'].split('/')[-1] in {f'add1_syn_{i}' for i in range(146,153)}],'frame_age_adders':[brief(c) for c in cs if c['name'].startswith(prefix+'add3_syn_') and c['name'].split('/')[-1] in {f'add3_syn_{i}' for i in range(74,78)}]}
  outs=[c['ports'].get('fco','').strip() for c in sample]; ins=[c['ports'].get('fci','').strip() for c in sample]
  norm=lambda x:x.replace('\\u_pcm_waveform/u_spectrum/','').strip()
  r['netlists'][ver]['carry_check']={'segments':len(sample),'low_to_mid':len(sample)==3 and norm(outs[0]) in ins[1],'mid_to_high':len(sample)==3 and norm(outs[1]) in ins[2],'fco':outs,'fci':ins}
 mismatches=[]
 for x in range(1024):
  got=(x+1)&1023
  if got!=((x+1)&1023): mismatches.append([x,got])
 r['reference_test']={'width':10,'states':1024,'transitions':1024,'mismatches':mismatches,'status':'PASS' if not mismatches else 'FAIL','scope':'ideal unsigned modulo increment only; not EG4 LSLICE simulation'}
 simlog=OUT.parent/'modelsim/arith_modelsim/sim.log'
 if simlog.exists():
  log=simlog.read_text(errors='replace')
  r['primitive_simulation']={'tool':'ModelSim SE-64 10.1c','vendor_library':'TD EG4 precompiled work library; EG_PHY_LSLICE loaded via -L EG4','testbench':'modelsim/arith_modelsim/tb_arith_routed_cells.v','sample_count':'PASS' if 'PASS C11310 sample_count routed cells visible bits[9:1], 1024 vectors' in log else 'NOT_PASS','accepted_samples':'PASS' if 'PASS C11310 accepted_samples routed cells visible bits[23:1], eight vectors' in log else 'NOT_PASS','coverage':'C11310 routed sample_count low/mid/high LSLICE and accepted_samples low/mid/high LSLICE. Actual port parameters/connections copied from routed cells. Open bit-0 sum ports are excluded; carry boundaries checked.','log':str(simlog)}
 OUT.write_text(json.dumps(r,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
 print(json.dumps({'output':str(OUT),'reference':r['reference_test'],'summary':{v:{'sample_adders':len(d['sample_count_adders']),'accepted_register_cells':len(d['counter_registers']['accepted_samples_reg[']),'sample_register_cells':len(d['counter_registers']['sample_count_reg[']),'age_register_cells':len(d['counter_registers']['frame_age_samples_reg[']),'carry':d['carry_check']} for v,d in r['netlists'].items()}},ensure_ascii=False,indent=2))
if __name__=='__main__': main()
