import re,json,pathlib
p=pathlib.Path(r'E:\VSCODE-project\FPGA-ANLU\development\player_spectrum_fft_recover\build\manual\AC201_tf_hdmi_gate.v')
s=p.read_text(errors='replace')
mods=['AL_MAP_SEQ','AL_MAP_LUT1','AL_MAP_LUT2','AL_MAP_LUT3','AL_MAP_LUT4','AL_MAP_LUT5','AL_MAP_LUT6','AL_MAP_ADDER','EG_PHY_LSLICE','EG_PHY_MSLICE']
pat=re.compile(r'\b(?:'+ '|'.join(mods)+r')\s*#\s*\(')
def paren_end(txt,pos):
 d=0; inq=False; esc=False
 for i in range(pos,len(txt)):
  c=txt[i]
  if inq:
   if esc: esc=False
   elif c=='\\': esc=True
   elif c=='"': inq=False
  else:
   if c=='"': inq=True
   elif c=='(': d+=1
   elif c==')':
    d-=1
    if d==0:return i+1
 raise ValueError('unclosed')
def split_top(x):
 out=[]; d=0; inq=False; start=0
 for i,c in enumerate(x):
  if c=='"':inq=not inq
  elif not inq:
   if c in '({[':d+=1
   elif c in ')}]':d-=1
   elif c==',' and d==0:out.append(x[start:i].strip());start=i+1
 out.append(x[start:].strip());return [z for z in out if z]
def ports(txt):
 r={}
 for m in re.finditer(r'\.([A-Za-z_][A-Za-z0-9_]*)\s*\(',txt):
  a=m.end(); e=paren_end(txt,a-1);r[m.group(1)]=txt[a:e-1].strip()
 return r
def atoms(x):
 x=x.strip()
 if x.startswith('{') and x.endswith('}'):
  return sum((atoms(z) for z in split_top(x[1:-1])),[])
 if re.fullmatch(r"1'b[01]",x):return []
 return [x.replace('\\','').strip()]
inst=[]
for m in pat.finditer(s):
 mod=m.group(0).split()[0]
 pe=paren_end(s,m.end()-1); q=pe
 while q<len(s) and s[q].isspace():q+=1
 if q>=len(s):continue
 if s[q]=='\\':
  q+=1; z=q
  while q<len(s) and not s[q].isspace():q+=1
  name=s[z:q]
 else:
  z=q
  while q<len(s) and (s[q].isalnum() or s[q] in '_$'):q+=1
  name=s[z:q]
 while q<len(s) and s[q].isspace():q+=1
 if q>=len(s) or s[q]!='(':continue
 ee=paren_end(s,q); pp=ports(s[q+1:ee-1]); par=ports(s[m.end():pe-1])
 outs={'AL_MAP_SEQ':['q'],'AL_MAP_LUT1':['o'],'AL_MAP_LUT2':['o'],'AL_MAP_LUT3':['o'],'AL_MAP_LUT4':['o'],'AL_MAP_LUT5':['o'],'AL_MAP_LUT6':['o'],'AL_MAP_ADDER':['sum','cout'],'EG_PHY_LSLICE':['f','fx','q','fco','dpram_di','dpram_we','dpram_waddr','dpram_wclk','dpram_mode'],'EG_PHY_MSLICE':['f','fx','q','fco','dpram_di','dpram_we','dpram_waddr','dpram_wclk','dpram_mode']}[mod]
 oo=[]
 for k in outs:
  if k in pp:oo+=atoms(pp[k])
 ins=[]
 for k,v in pp.items():
  if k not in outs:ins+=atoms(v)
 inst.append({'mod':mod,'name':name,'p':pp,'par':par,'out':oo,'in':sorted(set(ins))})
drivers={}
for i,x in enumerate(inst):
 for o in x['out']: drivers[o]=i
# top paths, normalized from Verilog escaped ids
prefix='u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/'
targets=['hdmi_video_locked',prefix+'u_video_axi_stream_receiver/O_video_source_pause',prefix+'u_video_axi_stream_receiver/I_video_source_sof',prefix+'u_video_axi_stream_receiver/I_video_source_sol','u_adjust_osd/de_prev']
bound={'axis_s_user','axis_s_valid','u_status_monitor/sys_clk',prefix+'u_hdmi_edid_wrapper/u_iic_master_wrapper/u_iic_receiver_controller/I_rst'}
seen=set(); visiting=set(); missing=set(); stack=[]; order=[]
def visit(n):
 if n in bound:return
 if n in seen:return
 if n in visiting:return
 di=drivers.get(n)
 if di is None:
  missing.add(n);return
 visiting.add(n);stack.append(n)
 cell=inst[di]
 for a in cell['in']:visit(a)
 stack.pop();visiting.remove(n);seen.add(n);order.append(di)
for n in targets:visit(n)
print(json.dumps({'primitives':len(inst),'drivers':len(drivers),'cells':len(set(order)),'nets':len(seen),'missing_count':len(missing),'missing_sample':sorted(missing)[:80],'module_counts':{m:sum(inst[i]['mod']==m for i in set(order)) for m in mods},'boundary':sorted(bound)},indent=2))