import re,json,pathlib,collections
p=pathlib.Path(r'E:\VSCODE-project\FPGA-ANLU\development\player_spectrum_fft_recover\build\manual\AC201_tf_hdmi_gate.v');s=p.read_text(errors='replace')
mods=['AL_MAP_SEQ','AL_MAP_LUT1','AL_MAP_LUT2','AL_MAP_LUT3','AL_MAP_LUT4','AL_MAP_LUT5','AL_MAP_LUT6','AL_MAP_ADDER','EG_PHY_LSLICE','EG_PHY_MSLICE']
pat=re.compile(r'\b(?:'+ '|'.join(mods)+r')\s*#\s*\(')
def pend(t,pos):
 d=0;q=False;esc=False
 for i in range(pos,len(t)):
  c=t[i]
  if q:
   if esc:esc=False
   elif c=='\\':esc=True
   elif c=='"':q=False
  elif c=='"':q=True
  elif c=='(':d+=1
  elif c==')':
   d-=1
   if d==0:return i+1
 raise Exception('paren')
def split(x):
 r=[];d=0;q=False;st=0
 for i,c in enumerate(x):
  if c=='"':q=not q
  elif not q:
   if c in '({[':d+=1
   elif c in ')}]':d-=1
   elif c==',' and d==0:r.append(x[st:i].strip());st=i+1
 r.append(x[st:].strip());return [z for z in r if z]
def ports(x):
 r={}
 for m in re.finditer(r'\.([A-Za-z_]\w*)\s*\(',x):
  e=pend(x,m.end()-1);r[m.group(1)]=x[m.end():e-1].strip()
 return r
def bits(x):
 x=x.strip()
 if x.startswith('{') and x.endswith('}'):return sum((bits(z) for z in split(x[1:-1])),[])
 if re.fullmatch(r"[0-9]+\s*'\s*[bBoOdDhH][0-9a-fA-F_xXzZ]+",x):return []
 if re.fullmatch(r"1'\s*[bB][01]",x):return []
 x=x.replace('\\','').strip()
 m=re.fullmatch(r'(.+?)\s*\[(\d+):(\d+)\]',x)
 if m:
  name,hi,lo=m.group(1).strip(),int(m.group(2)),int(m.group(3))
  step=-1 if hi>=lo else 1
  return [name+f' [{j}]' for j in range(hi,lo+step,step)]
 return [re.sub(r'\s+\[', ' [', x)]
outnames={'AL_MAP_SEQ':['q'],'AL_MAP_LUT1':['o'],'AL_MAP_LUT2':['o'],'AL_MAP_LUT3':['o'],'AL_MAP_LUT4':['o'],'AL_MAP_LUT5':['o'],'AL_MAP_LUT6':['o'],'AL_MAP_ADDER':['sum','cout'],'EG_PHY_LSLICE':['f','fx','q','fco','dpram_di','dpram_we','dpram_waddr','dpram_wclk','dpram_mode'],'EG_PHY_MSLICE':['f','fx','q','fco','dpram_di','dpram_we','dpram_waddr','dpram_wclk','dpram_mode']}
ins=[]
for m in pat.finditer(s):
 mod=m.group(0).split()[0];pe=pend(s,m.end()-1);q=pe
 while q<len(s) and s[q].isspace():q+=1
 if q>=len(s):continue
 if s[q]=='\\':q+=1;z=q
 else:z=q
 while q<len(s) and not s[q].isspace() and s[q]!='(':q+=1
 name=s[z:q].replace('\\','')
 while q<len(s) and s[q].isspace():q+=1
 if q>=len(s) or s[q]!='(':continue
 ee=pend(s,q);pp=ports(s[q+1:ee-1]);pa=ports(s[m.end():pe-1]);outs=[]
 for o in outnames[mod]:
  if o in pp:outs+=bits(pp[o])
 ii=[]
 for k,v in pp.items():
  if k not in outnames[mod]:ii+=bits(v)
 ins.append({'mod':mod,'name':name,'pp':pp,'pa':pa,'out':outs,'in':list(dict.fromkeys(ii))})
dr={}
for i,c in enumerate(ins):
 for o in c['out']:dr[o]=i
prefix='u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/'
targets=['hdmi_video_locked',prefix+'u_video_axi_stream_receiver/O_video_source_pause',prefix+'u_video_axi_stream_receiver/I_video_source_sof',prefix+'u_video_axi_stream_receiver/I_video_source_sol','u_adjust_osd/de_prev']
bounds={'axis_s_user','axis_s_valid','u_status_monitor/sys_clk',prefix+'u_hdmi_edid_wrapper/u_iic_master_wrapper/u_iic_receiver_controller/I_rst','clk_dup_1','rst_n_dup_1','video_pll_lock','sys_pll_lock'}
seen=set();loop=set();missing=set();order=[]
def visit(n,path):
 if n in bounds or n.startswith('open_n') or n.startswith("2'b"):return
 if n in seen:return
 if n in path:loop.add(n);return
 j=dr.get(n)
 if j is None:missing.add(n);return
 c=ins[j]
 for z in c['in']:visit(z,path|{n})
 seen.add(n);order.append(j)
for n in targets:visit(n,set())
idx=set(order)
print(json.dumps({'cells':len(idx),'nets':len(seen),'cycles':sorted(loop)[:30],'missing':sorted(missing)[:80],'mods':dict(collections.Counter(ins[i]['mod'] for i in idx)),'count_targets':sorted(n for n in seen if 'S_col_cnt ' in n or 'S_line_cnt ' in n)[:80]},indent=2))
