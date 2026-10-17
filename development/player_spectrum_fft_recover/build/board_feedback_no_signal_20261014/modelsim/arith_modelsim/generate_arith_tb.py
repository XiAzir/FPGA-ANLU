from pathlib import Path
import re
NET=Path(r'E:/VSCODE-project/FPGA-ANLU/development/player_spectrum_fft_recover/build/audit/routed_implementation.v')
OUT=Path(__file__).parent
TEXT=NET.read_text(errors='replace')
def bal(s,op):
 d=0;q=False;esc=False
 for i in range(op,len(s)):
  c=s[i]
  if q:
   if esc:esc=False
   elif c=='\\':esc=True
   elif c=='\"':q=False
  elif c=='\"':q=True
  elif c=='(':d+=1
  elif c==')':
   d-=1
   if d==0:return i+1
 raise ValueError('unbalanced')
def get(name):
 needle='\\u_pcm_waveform/u_spectrum/'+name;at=TEXT.find(needle);st=TEXT.rfind('EG_PHY_LSLICE',0,at);hp=TEXT.find('#(',st,at);pe=bal(TEXT,hp+1);ip=TEXT.find('(',at+len(needle));ie=bal(TEXT,ip);return TEXT[hp+2:pe-1],TEXT[ip+1:ie-1],TEXT.count('\n',0,st)+1
FIELD=re.compile(r'\.(\w+)\s*\(')
def pd(s):
 o={};p=0
 while 1:
  m=FIELD.search(s,p)
  if not m:break
  e=bal(s,m.end()-1);o[m.group(1)]=s[m.end():e-1].strip();p=e
 return o
def tr(x,k):
 if k=='cnt':
  x=re.sub(r'\\u_pcm_waveform/u_spectrum/debug_progress\s*\[(\d+)\]',lambda m:f'x10[{int(m.group(1))-9}]',x)
  x=re.sub(r'\\u_pcm_waveform/u_spectrum/sample_count_b6\s*\[(\d+)\]',lambda m:f'y10[{m.group(1)}]',x)
  x=x.replace('\\u_pcm_waveform/u_spectrum/add4_syn_54','c10_1').replace('\\u_pcm_waveform/u_spectrum/add4_syn_58','c10_2')
  x=x.replace('\\u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/S_packet_body [21]','pktbit')
 else:
  x=re.sub(r'\\u_pcm_waveform/u_spectrum/debug_accepted\s*\[(\d+)\]',lambda m:f'x24[{m.group(1)}]',x)
  x=re.sub(r'\\u_pcm_waveform/u_spectrum/accepted_samples_b3\s*\[(\d+)\]',lambda m:f'y24[{m.group(1)}]',x)
  for i,n in enumerate((124,128,132,136,140,144)):x=x.replace(f'\\u_pcm_waveform/u_spectrum/add1_syn_{n}',f'c24_{i+1}')
 return re.sub(r'open_n(\d+)',lambda m:'open_'+m.group(1),x)
inst=[];opens=set()
for name,k in [(f'add4_syn_{i}','cnt') for i in (62,63,64)]+[(f'add1_syn_{i}','acc') for i in range(146,153)]:
 par,ports,line=get(name); d=pd(ports);inst.append(f'// routed {name}, source {81 if k=="acc" else 338}, line {line}\nEG_PHY_LSLICE #({par}) u_{name} ('+',\n'.join(f'.{a}({tr(b,k)})' for a,b in d.items())+');\n');opens.update(re.findall(r'open_(\d+)',str(d)))
head='`timescale 1ns/1ps\nmodule tb;\nreg [9:0] x10; wire [9:0] y10; reg [23:0] x24; wire [23:0] y24; reg sys_clk=0,pktbit=0;\nwire c10_1,c10_2,c24_1,c24_2,c24_3,c24_4,c24_5,c24_6; integer i; reg [9:0] e10; reg [23:0] e24;\n' + ''.join(f'wire open_{n};\n' for n in sorted(opens))
body='''\ninitial begin\nfor(i=0;i<1024;i=i+1)begin x10=i[9:0];#2;e10=(i+1)&10'h3ff;if(y10[9:1]!==e10[9:1])begin $display("FAIL count x=%h got=%h expected=%h",x10,y10,e10);$fatal(1);end if((i&7)==7&&c10_1!==1'b1)begin $display("FAIL count carry1 x=%h",x10);$fatal(1);end if((i&63)==63&&c10_2!==1'b1)begin $display("FAIL count carry2 x=%h",x10);$fatal(1);end end\n$display("PASS C11310 sample_count routed cells visible bits[9:1], 1024 vectors; bit0 open at LSLICE boundary");\nx24=24'h000000;#2;check24();x24=24'h000001;#2;check24();x24=24'h000007;#2;check24();x24=24'h00000f;#2;check24();x24=24'h0000ff;#2;check24();x24=24'h000fff;#2;check24();x24=24'h00ffff;#2;check24();x24=24'hffffff;#2;check24();\n$display("PASS C11310 accepted_samples routed cells visible bits[23:1], eight vectors; bit0 open at LSLICE boundary");$finish;end\ntask check24;begin e24=x24+24'd1;if(y24[23:1]!==e24[23:1])begin $display("FAIL accepted x=%h got=%h expected=%h",x24,y24,e24);$fatal(1);end end endtask\nendmodule\n'''
(OUT/'tb_arith_routed_cells.v').write_text(head+'\n'.join(inst)+body,encoding='utf-8');print('created',OUT/'tb_arith_routed_cells.v','cells',len(inst),'open',len(opens))
