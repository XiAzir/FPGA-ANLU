"""Close a sequential FFT cone using unchanged original gate primitives.

Inputs are clock/reset, PCM/valid and selected audio source. Outputs include
the actual emitted bands and diagnostics. No arithmetic or RAM is replaced.
"""
from pathlib import Path
import re, collections, json, hashlib, argparse

parser=argparse.ArgumentParser()
parser.add_argument('--source',type=Path,required=True)
parser.add_argument('--out',type=Path,required=True)
parser.add_argument('--routed',action='store_true')
args=parser.parse_args()
args.video=False
out=args.out.resolve()
out.mkdir(parents=True,exist_ok=True)
src=args.source.resolve()
s=src.read_text()
decls=re.findall(r'^  wire[^\n]+',s,re.M)
widths={}
for line in decls:
    m=re.match(r'  wire\s+(?:\[(\d+):(\d+)\]\s+)?(\\\S+|\w+)',line)
    if m:
        widths[m[3].lstrip('\\')]=list(range(int(m[1]),int(m[2])-1,-1)) if m[1] else None

def pend(t,pos):
    depth=0;quote=False
    for i in range(pos,len(t)):
        c=t[i]
        if c=='"':quote=not quote
        if not quote:
            if c=='(':depth+=1
            if c==')':
                depth-=1
                if depth==0:return i+1
    raise ValueError('unclosed')

def split(x):
    result=[];depth=0;start=0
    for i,c in enumerate(x):
        if c in '({[':depth+=1
        if c in ')}]':depth-=1
        if c==',' and depth==0:result.append(x[start:i]);start=i+1
    return result+[x[start:]]

def bits(x,keep=False):
    x=x.strip()
    if not x:return []
    if x.startswith('{') and x.endswith('}'):
        return sum((bits(y,keep) for y in split(x[1:-1])),[])
    if re.fullmatch(r"\d+\s*'\s*[bBoOdDhH][0-9a-fA-F_xXzZ]+",x):return [None]*int(x.split("'")[0]) if keep else []
    m=re.fullmatch(r'(\\\S+|[A-Za-z_]\w*)\s*(?:\[(\d+)(?::(\d+))?\])?',x)
    if not m:raise ValueError('unparsed expression '+x)
    name=m[1].lstrip('\\')
    if name.startswith('open_n'):return [None] if keep else []
    if m[2]:
        hi=int(m[2]);lo=int(m[3] or m[2]);step=-1 if hi>=lo else 1
        return [f'{name} [{i}]' for i in range(hi,lo+step,step)]
    return [f'{name} [{i}]' for i in widths[name]] if widths.get(name) else [name]

def ports(x):
    result={}
    for m in re.finditer(r'\.([A-Za-z_]\w*)\s*\(',x):
        end=pend(x,m.end()-1);result[m[1]]=x[m.end():end-1].strip()
    return result

outputs={'AL_MAP_SEQ':['q']}
outputs.update({f'AL_MAP_LUT{i}':['o'] for i in range(1,7)})
for typ in ('EG_PHY_LSLICE','EG_PHY_MSLICE','EG_PHY_BRAM','EG_PHY_MULT18'):
    model=Path('C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/sim_release/eg4')/(typ.lower()+'.v')
    body=model.read_text()
    body=re.sub(r'`pragma protect begin_protected.*?`pragma protect end_protected','',body,flags=re.S)
    outputs[typ]=re.findall(r'^\s*output\s+(?:reg\s+|wire\s+)?(?:\[[^\]]+\]\s*)?(\w+)',body,re.M)

cells=[]
for m in re.finditer(r'^  ('+'|'.join(outputs)+r')\s*#\s*\(',s,re.M):
    pe=pend(s,m.end()-1)
    nm=re.match(r'\s*(\\\S+|\w+)\s*\(',s[pe:])
    if not nm:raise ValueError('no instance')
    start=pe+nm.end()-1;end=pend(s,start);p=ports(s[start+1:end-1])
    oo=sum((bits(v) for k,v in p.items() if k in outputs[m[1]]),[])
    ii=sum((bits(v) for k,v in p.items() if k not in outputs[m[1]]),[])
    cells.append(dict(name=nm[1].lstrip('\\'),typ=m[1],out=oo,ins=ii,p=p,params=ports(s[m.end():pe-1]),raw=s[m.start():end]+';'))
for m in re.finditer(r'^  assign\s+(.+?)\s*=\s*(.+?);',s,re.M):
    cells.append(dict(name='assign',typ='assign',out=bits(m[1]),ins=bits(m[2]),raw=m[0]))
for m in re.finditer(r'^  buf\s+(\\\S+|\w+)\s*\((.+?)\);',s,re.M):
    connections=split(m[2])
    cells.append(dict(name=m[1].lstrip('\\'),typ='buf',out=bits(connections[0]),ins=sum((bits(x) for x in connections[1:]),[]),raw=m[0]))

drivers={}
for i,c in enumerate(cells):
    for b in c['out']:
        if b in drivers:raise ValueError('duplicate driver '+b)
        drivers[b]=i
clock='u_status_monitor/sys_clk'
reset='u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_edid_wrapper/u_iic_master_wrapper/u_iic_receiver_controller/I_rst'
bounds={clock: 'clk',reset:'rst','u_audio_probe/audio_valid':'audio_valid','u_audio_probe/tone_mode':'tone_mode'}
if 'u_status_monitor/startup_flags' in widths:
    bounds['u_status_monitor/startup_flags [1]']='rst'
if args.routed:
    for name in widths:
        if name.startswith('u_status_monitor/startup_flags[1]_dup_') or name.startswith(reset+'_dup_'):
            bounds[name]='rst'
for i in range(24):bounds[f'audio_left_data [{i}]']=f'audio_pcm[{i}]'
targets=['\\u_pcm_waveform/band_valid ','\\u_pcm_waveform/frame_done ',
         '\\u_pcm_waveform/u_spectrum/band_index ','\\u_pcm_waveform/u_spectrum/band_value ']
if args.video:
    bounds={clock:'clk',reset:'rst','u_status_monitor/startup_flags [1]':'rst'}
    targets=['hdmi_video_locked','axis_s_user','\\u_adjust_osd/de_prev ',
             '\\u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/O_video_source_pause ']
todo=sum((bits(t) for t in targets),[]);visited=set();selected=set();missing=set()
def dependencies(c,b):
    if not args.routed or c['typ'] not in ('EG_PHY_LSLICE','EG_PHY_MSLICE'):
        return c['ins']
    p=c['p'];param=c['params']
    if param.get('MODE','"LOGIC"') not in ('"LOGIC"','"RIPPLE"'):
        return c['ins']
    port=None;lane=None
    for op in outputs[c['typ']]:
        names=bits(p.get(op,''),True)
        if b in names:port=op;lane=len(names)-1-names.index(b);break
    if port is None:return c['ins']
    def at(pin,k):
        names=bits(p.get(pin,''),True)
        return [names[-1-k]] if len(names)>k and names[-1-k] is not None else []
    def combin(k,fx=False):
        # An overapproximation of one lane's LUT/5-input mux. FUNC6 and
        # ripple carries may depend on both lanes, so retain both there.
        lanes=[0,1] if fx or param.get('MODE')=='"RIPPLE"' else [k]
        result=[]
        for j in lanes:
            cp='mi' if param.get(f'CMIMUX{j}')=='"MI"' else 'c'
            for pin in ('a','b',cp,'d','e'):result+=at(pin,j)
        if param.get('MODE')=='"RIPPLE"':result+=bits(p.get('fci',''))
        return result
    if port=='q':
        ff=bits(p.get('clk',''))
        default_ce='"1"' if c['typ']=='EG_PHY_LSLICE' else '"CE"'
        if param.get('CEMUX',default_ce) in ('"CE"','"INV"'):ff+=bits(p.get('ce',''))
        if param.get('SRMUX','"SR"') in ('"SR"','"INV"'):ff+=bits(p.get('sr',''))
        mode=param.get(f'REG{lane}_SD','"MI"')
        return ff+(at('mi',lane) if mode=='"MI"' else combin(lane,mode=='"FX"'))
    if port=='f':return combin(lane)
    if port=='fx':return combin(lane,True)
    if port=='fco':return combin(0,True)
    return c['ins']
while todo:
    b=todo.pop()
    if b in visited or b in bounds:continue
    visited.add(b)
    if b not in drivers:missing.add(b);continue
    i=drivers[b]
    selected.add(i);todo.extend(dependencies(cells[i],b))
summary=dict(source=str(src),source_sha256=hashlib.sha256(src.read_bytes()).hexdigest(),
             primitive_counts=dict(collections.Counter(cells[i]['typ'] for i in selected)),
             included=len(selected),total=len(cells),unresolved=sorted(missing),boundaries=bounds,
             instances=[cells[i]['name'] for i in sorted(selected)])
if args.routed:summary['dependency_scope']='Slice lane-aware overapproximation; untouched full primitives retained. Unobserved co-packed lane inputs may be undriven; all observed lane data/control dependencies are closed.'
(out/'cone_manifest.json').write_text(json.dumps(summary,indent=2))
print(json.dumps({k:v for k,v in summary.items() if k not in ('instances','boundaries')},indent=2))
if missing:raise SystemExit('Unresolved nets: do not simulate incomplete cone')
body=['`timescale 1ns/1ps','module fft_cone(input clk,rst,audio_valid,tone_mode,input [23:0] audio_pcm,output band_valid,frame_done,output [4:0] band_index,output [15:0] band_value);']+decls
if args.video:
    body=['`timescale 1ns/1ps','module video_full_cone(input clk,rst,output locked,user,valid,pause);']+decls
for original,replacement in bounds.items():
    original='\\'+original if '/' in original else original
    body.append(f'assign {original} = {replacement};')
for i in sorted(selected):body.append(cells[i]['raw'])
names=['locked','user','valid','pause'] if args.video else ['band_valid','frame_done','band_index','band_value']
for name,target in zip(names,targets):
    body.append(f'assign {name} = {target};')
body+=['endmodule']
(out/('video_full_cone.v' if args.video else 'fft_cone.v')).write_text('\n'.join(body)+'\n')
