from pathlib import Path
import re,shutil,hashlib,json,subprocess
root=Path('development/video19_work/dht_case').resolve()
base=Path('development/video19_work/area_rebalance/A08_base').resolve()
source=root/'src_v';source.mkdir(exist_ok=True)
for p in (base/'src_v').glob('*.v'):shutil.copy2(p,source/p.name)
names=['y_dc','y_ac','cx_dc','cx_ac']
receipts=[]
for name in names:
 p=source/('jpeg_dht_std_'+name+'.v');t=p.read_text()
 # All standard Huffman prefixes are disjoint. Express them as parallel cases.
 pat=r'(?:else\s+)?if \(lookup_input_i\[15:(\d+)\] == (\d+)\x27h([0-9a-f]+)\)\s*begin\s*'+name+r'_value_r = 8\x27h([0-9a-f]+);\s*'+name+r'_width_r = 5\x27d(\d+);\s*end'
 matches=list(re.finditer(pat,t));assert matches,(name,t[:1200])
 cases=[]
 for m in matches:
  low,width,code,value,n=m.groups();low=int(low);width=int(width)
  prefix=f'{int(code,16):0{width}b}'+'?'*low
  assert len(prefix)==16
  cases.append(f"        16'b{prefix}: begin {name}_value_r=8'h{value};{name}_width_r=5'd{n};end")
 replace='    casez (lookup_input_i)\n'+'\n'.join(cases)+'\n        default: ;\n    endcase'
 new=t[:matches[0].start()]+replace+t[matches[-1].end():]
 assert 'if (lookup_input_i' not in new
 p.write_text(new)
 old=base/'src_v'/p.name;original=root/(p.stem+'_reference.v')
 original.write_text(old.read_text().replace('module '+p.stem, 'module '+p.stem+'_reference'))
 receipts.append({'module':p.stem,'prefixes':len(matches),'reference_sha':hashlib.sha256(old.read_bytes()).hexdigest(),'candidate_sha':hashlib.sha256(p.read_bytes()).hexdigest()})
# Formal-domain exhaustive comparison for every 16-bit lookup.
tb='module tb;reg [15:0] code;integer i;'
for n in names:
 tb+=f'wire [4:0] {n}w,{n}r;wire [7:0] {n}v,{n}s;\n'
 tb+=f'jpeg_dht_std_{n} a_{n}(code,{n}w,{n}v);jpeg_dht_std_{n}_reference r_{n}(code,{n}r,{n}s);\n'
tb+='initial begin for(i=0;i<65536;i=i+1)begin code=i;#1;\n'
for n in names:tb+=f'if({{{n}w,{n}v}}!=={{{n}r,{n}s}})$fatal(1,"DHT mismatch {n} code=%h",code);\n'
tb+='end $display("DHT_CASE_PASS 4 tables 65536 inputs each");$finish;end endmodule\n'
(root/'tb.v').write_text(tb)
bin=Path('bringup/tf_wav_hdmi/tools/iverilog/app/bin').resolve()
cmd=[str(bin/'iverilog.exe'),'-g2012','-s','tb','-o',str(root/'tb.vvp'),str(root/'tb.v')]+[str(source/f'jpeg_dht_std_{n}.v') for n in names]+[str(root/f'jpeg_dht_std_{n}_reference.v') for n in names]
r=subprocess.run(cmd,capture_output=True);(root/'compile.log').write_bytes(r.stdout+r.stderr);assert r.returncode==0
r=subprocess.run([str(bin/'vvp.exe'),str(root/'tb.vvp')],capture_output=True);(root/'run.log').write_bytes(r.stdout+r.stderr);assert r.returncode==0;print(r.stdout.decode())
(root/'manifest.json').write_text(json.dumps(receipts,indent=2))
# Derive isolated area-only project.
shutil.copytree(base/'td_project',root/'td_project',ignore=shutil.ignore_patterns('*.db','*.vdb','*.rpt'),dirs_exist_ok=True)
(root/'reports').mkdir(exist_ok=True)
shutil.copy2(base/'jpeg_core.sdc',root/'jpeg_core.sdc')
t=(base/'run_syn.tcl').read_text().replace(base.as_posix(),root.as_posix())
(root/'run_syn.tcl').write_text(t)
