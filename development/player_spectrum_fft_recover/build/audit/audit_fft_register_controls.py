#!/usr/bin/env python3
"""Bounded combinational control audit for C11310 FFT counters."""
import argparse, hashlib, itertools, json, re
from pathlib import Path

ROOT=Path(__file__).resolve().parents[2]
GATE=ROOT/'build/manual/AC201_tf_hdmi_gate.v'

def split_top(s):
    s=s.strip()
    if s.startswith('{') and s.endswith('}'): s=s[1:-1]
    out=[]; start=0; depth=0
    for i,ch in enumerate(s):
        if ch=='{': depth+=1
        elif ch=='}': depth-=1
        elif ch==',' and depth==0: out.append(s[start:i].strip()); start=i+1
    if s[start:].strip(): out.append(s[start:].strip())
    return out
def expand_atom(a):
    a=a.strip(); m=re.fullmatch(r"(\d+)'[bB]([01xXzZ]+)",a)
    if m:
        w,d=int(m.group(1)),m.group(2).lower().rjust(int(m.group(1)),'0')[-int(m.group(1)):]; return ["1'b"+x for x in d]
    m=re.fullmatch(r"(.*?)\s+\[(\d+):(\d+)\]",a)
    if m:
        b,h,l=m.group(1).strip().lstrip('\\'),int(m.group(2)),int(m.group(3)); step=-1 if h>=l else 1; return [f'{b}[{n}]' for n in range(h,l+step,step)]
    m=re.fullmatch(r"(.*?)\s+\[(\d+)\]",a)
    if m: return [f"{m.group(1).strip().lstrip(chr(92))}[{m.group(2)}]"]
    return [a.lstrip('\\').strip()]
def expand_bus(s): return [x for a in split_top(s) for x in expand_atom(a)]
def lanes(s):
    a=list(reversed(expand_bus(s)))
    if len(a)==1: a.append("1'b0")
    return a[:2]
def params(s): return {m.group(1):(m.group(2) or m.group(3)).strip() for m in re.finditer(r'\.([A-Za-z0-9_]+)\s*\(\s*(?:"([^"]*)"|([^)]*))\)',s)}
def ports(s): return {m.group(1):m.group(2).strip() for m in re.finditer(r'\.([A-Za-z0-9_]+)\s*\(([^)]*)\)',s)}
def literal(s):
    m=re.fullmatch(r"\s*(\d+)'([bBoOdDhH])([0-9a-fA-F_xXzZ]+)\s*",s or '')
    if not m or any(c in m.group(3).lower() for c in 'xz'): return None
    return int(m.group(3).replace('_',''),{'b':2,'o':8,'d':10,'h':16}[m.group(2).lower()])
CELL_RE=re.compile(r'(?ms)^\s*(?P<typ>(?:AL_MAP|EG_PHY)_[A-Z0-9_]+)\s*#\s*\((?P<params>.*?)\)\s*(?P<inst>\\[^\r\n]+?)\s*\((?P<ports>.*?)\)\s*;')
class NL:
 def __init__(self,p):
    self.text=p.read_text(encoding='utf-8',errors='replace'); self.cells=[]; self.drivers={}; self.q={}; self.dups=set()
    for m in CELL_RE.finditer(self.text):
      typ,pa,ins,po=m.group('typ'),params(m.group('params')),m.group('inst').strip(),ports(m.group('ports')); c={'typ':typ,'params':pa,'inst':ins,'ports':po,'inputs':{}}; self.cells.append(c)
      if 'q' in po:
        for bit,n in enumerate(expand_bus(po['q'])): self.q.setdefault(n,[]).append(c)
      for pin in ('a','b','c','d','e'):
        if pin in po:c['inputs'][pin]=lanes(po[pin])
      if typ.startswith('AL_MAP_LUT') and 'o' in po:
        c['lut']=literal(pa.get('INIT','')); c['pins']=[x for x in ('a','b','c','d','e') if x in po]; self.add(expand_atom(po['o'])[0],c)
      elif typ.startswith('EG_PHY_'):
        for op in ('f','fx'):
          if op not in po:continue
          for lane,n in enumerate(lanes(po[op])):
            lk=('INIT_LUTF' if typ.endswith('LSLICE') else 'INIT_LUT')+str(lane) if op=='f' else 'INIT_LUTG'+str(lane)
            cc=dict(c); cc['lane']=lane; cc['lut']=literal(pa.get(lk,'')); cc['lutg']=literal(pa.get('INIT_LUTG'+str(lane),'')) if typ.endswith('LSLICE') and op=='f' else None; cc['pins']=['a','b','c','d'] if typ.endswith('LSLICE') else [x for x in ('a','b','c','d') if x in po]; cc['unsupported']=typ.endswith('LSLICE') and pa.get('LSFMUX'+str(lane)) not in (None,'FUNC5')
            if not n.startswith("1'b"):self.add(n,cc)
 def add(self,n,c):
    if n in self.drivers:self.dups.add(n)
    self.drivers[n]=c
 def source(self,n):
    if n in self.dups:raise ValueError('duplicate LUT driver: '+n)
    c=self.drivers.get(n)
    if c is None:return None
    if c.get('unsupported') and c['typ'].endswith('LSLICE'):
       raise ValueError('arithmetic cell requires vendor primitive model: '+c['inst'])
    if c['lut'] is None:raise ValueError('missing LUT INIT: '+c['inst'])
    return c
 def exprs(self,c):
    if c['typ'].endswith('LSLICE'):return [c['inputs'].get(p,["1'b0","1'b0"])[c['lane']] for p in ('a','b','c','d','e')]
    return [c['inputs'].get(p,["1'b0","1'b0"])[c.get('lane',0) if c['typ'].startswith('EG_PHY_') else 0] for p in c['pins']]
 def leaves(self,n,seen=None):
    if seen is None:seen=set()
    if n in seen:raise ValueError('combinational loop '+n)
    if n.startswith("1'b"):return set()
    c=self.source(n)
    if c is None:return {n}
    out=set()
    for e in self.exprs(c):out|=self.leaves(expand_atom(e)[0],seen|{n})
    return out
 def ev(self,n,a,seen=None,memo=None):
    if seen is None: seen=set()
    if memo is None: memo={}
    if n in memo: return memo[n]
    if n in seen: raise ValueError('combinational loop '+n)
    if n in a: return a[n]
    m=re.fullmatch(r"1'b([01])",n)
    if m: return int(m.group(1))
    c=self.source(n)
    if c is None: raise ValueError('unassigned leaf: '+n)
    if c.get('unsupported') and c['typ'].endswith('LSLICE'):
        raise ValueError('vendor arithmetic/output mode stop: '+c['inst'])
    es=self.exprs(c)
    used=es[:4] if c['typ'].endswith('LSLICE') else es
    idx=sum(self.ev(expand_atom(e)[0],a,seen|{n},memo)<<i for i,e in enumerate(used))
    f=(c['lut']>>idx)&1
    if c['typ'].endswith('LSLICE'):
        g=((c['lutg'] if c['lutg'] is not None else c['lut'])>>idx)&1
        result=g if self.ev(expand_atom(es[4])[0],a,seen|{n},memo) else f
    else: result=f
    memo[n]=result
    return result




def locate(nl,kind,bit):
    token='u_pcm_waveform/u_spectrum/'+kind+'_reg'
    xs=[c for c in nl.cells if token in c['inst'].lstrip(chr(92)).rstrip() and c['inst'].lstrip(chr(92)).rstrip().endswith('['+str(bit)+']')]
    if len(xs)!=1: raise ValueError(token+'['+str(bit)+'] count='+str(len(xs)))
    return xs[0]
def d_stops(nl,root):
    seen=set(); out=[]
    def walk(net):
        if net in seen or net.startswith("1'b"): return
        seen.add(net); c=nl.drivers.get(net)
        if c is None: return
        lane=c.get('lane',0); mux=c['params'].get('LSFMUX'+str(lane),'')
        if c['typ'].endswith('LSLICE') and mux=='SUM':
            out.append({'cell':c['inst'].lstrip(chr(92)).rstrip(),'type':c['typ'],'MODE':c['params'].get('MODE',''),'LSFMUX':mux,'net':net}); return
        if c['typ'].endswith('LSLICE') and c.get('unsupported'):
            out.append({'cell':c['inst'].lstrip(chr(92)).rstrip(),'type':c['typ'],'mux':mux,'net':net,'reason':'unsupported output mode'}); return
        for e in nl.exprs(c): walk(expand_atom(e)[0])
    walk(root); return out
def main():
    ap=argparse.ArgumentParser(); ap.add_argument('--output',type=Path); args=ap.parse_args(); nl=NL(GATE)
    regs={k:locate(nl,k,0) for k in ('sample_count','accepted_samples')}
    pins={k:{q:expand_atom(c['ports'][q])[0] for q in ('ce','sr','d')} for k,c in regs.items()}
    leaves={k:sorted(nl.leaves(v['ce'])) for k,v in pins.items()}
    rows=[]; mismatches=[]
    for state,count,audio,reset,sc,to,accepted in itertools.product([0,1,16],[0,11,1023],[0,1],[0,1],[0,1],[0,1],[0,1,0xffffff]):
        a={}
        for b in range(5): a['u_pcm_waveform/u_spectrum/debug_progress['+str(19+b)+']']=(state>>b)&1
        for b in range(10): a['u_pcm_waveform/u_spectrum/debug_progress['+str(9+b)+']']=(count>>b)&1
        for b in range(24): a['u_pcm_waveform/u_spectrum/debug_accepted['+str(b)+']']=(accepted>>b)&1
        for b in range(5): a['u_pcm_waveform/u_spectrum/emit_index['+str(b)+']']=0
        a.update({'u_pcm_waveform/u_spectrum/reset_pipe[1]_syn_4':reset,'u_pcm_waveform/u_spectrum/timeout_pulse':to,'u_audio_probe/tone_mode':0,'u_pcm_waveform/tone_prev':sc,'u_audio_probe/wav_valid':audio,'u_audio_probe/tone_valid':0})
        memo={}; ce={k:nl.ev(v['ce'],a,memo=memo) for k,v in pins.items()}
        active=state==0 and audio==1 and reset==0 and sc==0 and to==0
        expected={'sample_count':1,'accepted_samples':int(accepted!=0xffffff)}
        if active and ce!=expected: mismatches.append({'state':state,'count':count,'accepted':accepted,'CE':ce,'expected':expected})
        rows.append({'state':state,'count':count,'audio_valid':audio,'reset':reset,'source_change':sc,'timeout':to,'accepted':accepted,'CE':ce,'active':active})
    stops={}
    for kind,width in [('sample_count',10),('accepted_samples',24)]:
        stops[kind]=[]
        for bit in range(width):
            root=expand_atom(locate(nl,kind,bit)['ports']['d'])[0]
            stops[kind].append({'bit':bit,'d_net':root,'stop_cells':d_stops(nl,root)})
    lib=Path('C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/sim_release/common/al_map_seq.v').read_text(encoding='utf-8',errors='replace')
    pats={'CEMUX_CE':r'"CE"\s*:\s*ce_in\s*=\s*ce\s*;','SRMUX_SR':r'"SR"\s*:\s*sr_s\s*=\s*sr\s*;','SRMODE_ASYNC':r'"ASYNC"\s*:\s*sr_a\s*=\s*gsr\s*\|\s*sr_s\s*;','REGSET_RESET':r'"RESET"\s*:\s*INIT\s*=\s*1\'b0\s*;'}
    contract={k:bool(re.search(v,lib)) for k,v in pats.items()}
    result={'schema':'fft-control-truth-v1','status':'PASS' if not mismatches and all(contract.values()) else 'FAIL','netlist':str(GATE),'sha256':hashlib.sha256(GATE.read_bytes()).hexdigest(),'case_count':len(rows),'expected_case_count':432,'active_non_saturated':sum(x['active'] and x['accepted']!=0xffffff for x in rows),'active_saturated':sum(x['active'] and x['accepted']==0xffffff for x in rows),'mismatches':mismatches,'pins':pins,'ce_leaves':leaves,'d_pin_stop_boundaries_by_bit':stops,'al_map_seq_semantics':contract,'interpretation':'Accepted-sample CE deassertion only at 24-bit saturation is intentional. No D value is inferred beyond EG_PHY_LSLICE MODE=RIPPLE LSFMUX=SUM boundaries.'}
    out=args.output or ROOT/'build/audit/fft_register_control_truth.json'; out.parent.mkdir(parents=True,exist_ok=True); out.write_text(json.dumps(result,indent=2,ensure_ascii=False)+chr(10),encoding='utf-8'); print(json.dumps({k:v for k,v in result.items() if k!='d_pin_stop_boundaries_by_bit'},indent=2,ensure_ascii=False)); print('Wrote',out); return 0 if result['status']=='PASS' else 1
if __name__=='__main__': raise SystemExit(main())
