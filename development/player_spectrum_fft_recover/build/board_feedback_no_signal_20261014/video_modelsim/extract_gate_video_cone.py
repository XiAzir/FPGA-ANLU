import re, pathlib, json, collections
src=pathlib.Path(r'E:\VSCODE-project\FPGA-ANLU\development\player_spectrum_fft_recover\build\manual\AC201_tf_hdmi_gate.v')
out=pathlib.Path(r'E:\VSCODE-project\FPGA-ANLU\development\player_spectrum_fft_recover\build\board_feedback_no_signal_20261014\video_modelsim')
s=src.read_text(errors='replace')
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
 raise ValueError('unbalanced parentheses')
def split_top(x):
 r=[];d=0;q=False;st=0
 for i,c in enumerate(x):
  if c=='"':q=not q
  elif not q:
   if c in '({[':d+=1
   elif c in ')}]':d-=1
   elif c==',' and d==0:r.append(x[st:i].strip());st=i+1
 r.append(x[st:].strip());return [z for z in r if z]
def portmap(x):
 r={}
 for m in re.finditer(r'\.([A-Za-z_]\w*)\s*\(',x):
  e=pend(x,m.end()-1);r[m.group(1)]=x[m.end():e-1].strip()
 return r
def bitnames(x):
 x=x.strip()
 if x.startswith('{') and x.endswith('}'):return sum((bitnames(z) for z in split_top(x[1:-1])),[])
 if re.fullmatch(r"[0-9]+\s*'\s*[bBoOdDhH][0-9a-fA-F_xXzZ]+",x):return []
 if re.fullmatch(r"1'\s*[bB][01]",x):return []
 x=x.replace('\\','').strip()
 m=re.fullmatch(r'(.+?)\s*\[(\d+):(\d+)\]',x)
 if m:
  name,hi,lo=m.group(1).strip(),int(m.group(2)),int(m.group(3)); step=-1 if hi>=lo else 1
  return [f'{name} [{j}]' for j in range(hi,lo+step,step)]
 return [re.sub(r'\s+\[',' [',x)]
outports={'AL_MAP_SEQ':['q'],'AL_MAP_LUT1':['o'],'AL_MAP_LUT2':['o'],'AL_MAP_LUT3':['o'],'AL_MAP_LUT4':['o'],'AL_MAP_LUT5':['o'],'AL_MAP_LUT6':['o'],'AL_MAP_ADDER':['sum','cout'],'EG_PHY_LSLICE':['f','fx','q','fco','dpram_di','dpram_we','dpram_waddr','dpram_wclk','dpram_mode'],'EG_PHY_MSLICE':['f','fx','q','fco','dpram_di','dpram_we','dpram_waddr','dpram_wclk','dpram_mode']}
cells=[]
for m in pat.finditer(s):
 mod=m.group(0).split()[0]; pe=pend(s,m.end()-1); q=pe
 while q<len(s) and s[q].isspace():q+=1
 if q<len(s) and s[q]=='\\': q+=1; z=q
 else:z=q
 while q<len(s) and not s[q].isspace() and s[q]!='(':q+=1
 name=s[z:q].replace('\\','')
 while q<len(s) and s[q].isspace():q+=1
 if q>=len(s) or s[q]!='(':continue
 ee=pend(s,q); pp=portmap(s[q+1:ee-1]); outs=[]
 for o in outports[mod]:
  if o in pp:outs+=bitnames(pp[o])
 ins=[]
 for k,v in pp.items():
  if k not in outports[mod]:ins+=bitnames(v)
 cells.append({'mod':mod,'name':name,'start':m.start(),'end':ee,'raw':s[m.start():ee],'params':s[m.end()-1:pe],'portsraw':s[q+1:ee-1],'p':pp,'out':list(dict.fromkeys(outs)),'in':list(dict.fromkeys(ins))})
drivers={}
duplicates=[]
for i,c in enumerate(cells):
 for n in c['out']:
  if n.startswith('open_n'):continue
  if n in drivers:duplicates.append(n)
  drivers[n]=i
prefix='u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/'
core_reset=prefix+'u_hdmi_edid_wrapper/u_iic_master_wrapper/u_iic_receiver_controller/I_rst'
clock='u_status_monitor/sys_clk'
bounds={'axis_s_user','axis_s_valid','u_adjust_osd/de_prev',clock,core_reset}
targets=['hdmi_video_locked',prefix+'u_video_axi_stream_receiver/O_video_source_pause',prefix+'u_video_axi_stream_receiver/I_video_source_sof',prefix+'u_video_axi_stream_receiver/I_video_source_sol']
seen=set();included=set();missing=set();loops=set()
def visit(n,path):
 if n in bounds or n.startswith('open_n') or n.startswith("2'b"):return
 if n in path:loops.add(n);return
 if n in seen:return
 j=drivers.get(n)
 if j is None:missing.add(n);return
 c=cells[j];included.add(j);seen.add(n)
 if c['mod']=='AL_MAP_SEQ':
  qbits=bitnames(c['p'].get('q',''))
  if qbits!=[n]:missing.add(n);return
  # Q is a state boundary; preserve this real register and recursively close its D/CE logic.
  for pin in ('d','ce'):
   v=c['p'].get(pin)
   if v:
    for x in bitnames(v):visit(x,set())
  return
 for x in c['in']:visit(x,path|{n})
for n in targets:visit(n,set())
known_outputs=[]
for i in included:known_outputs+=cells[i]['out']
# Include requested top outputs from cells already in cone.
extra={'hdmi_video_locked','u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/O_video_source_pause','u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/I_video_source_sof','u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/I_video_source_sol'}
# Remove genuinely external boundary drivers from missing accounting; report remaining unresolved precisely.
summary={'total_primitive_instances':len(cells),'unique_driven_nets':len(drivers),'cells_in_cone':len(included),'state_nets_in_cone':sum(cells[i]['mod']=='AL_MAP_SEQ' for i in included),'nets_in_cone':len(seen),'duplicates':sorted(set(duplicates))[:30],'unresolved':sorted(missing),'cycles':sorted(loops)[:30],'boundary':sorted(bounds),'module_counts':dict(collections.Counter(cells[i]['mod'] for i in included))}
(out/'gate_video_cone_stats.json').write_text(json.dumps(summary,indent=2))
print(json.dumps(summary,indent=2))
# Emit a standalone module composed exclusively of original gate-level primitives.
if missing or loops:
 raise SystemExit('Refusing emission: cone is not closed')
modout=['module video_ctrl_cone(input clk, input core_reset, input de_prev, input axis_user, output locked, output pause, output sof, output sol);']
modout += ['wire \\u_status_monitor/sys_clk ; assign \\u_status_monitor/sys_clk = clk;']
modout += ['wire \\u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_edid_wrapper/u_iic_master_wrapper/u_iic_receiver_controller/I_rst ; assign \\u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_edid_wrapper/u_iic_master_wrapper/u_iic_receiver_controller/I_rst = core_reset;']
modout += ['wire \\u_adjust_osd/de_prev ; assign \\u_adjust_osd/de_prev = de_prev;']
modout += ['wire axis_s_user; assign axis_s_user = axis_user;']
for i in sorted(included):
 modout.append(cells[i]['raw'])
modout += ['assign locked = hdmi_video_locked;', 'assign pause = \\u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/O_video_source_pause ;', 'assign sof = \\u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/I_video_source_sof ;', 'assign sol = \\u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/I_video_source_sol ;', 'endmodule']
(out/'gate_video_cone.v').write_text('\n'.join(modout)+'\n')
print('WROTE',out/'gate_video_cone.v','bytes', (out/'gate_video_cone.v').stat().st_size)
