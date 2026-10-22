from pathlib import Path
import hashlib,json,subprocess
root=Path(__file__).resolve().parent
repo=root.parents[3]
source=repo/'development/player_video19/src/user_source/hdl_source/jpeg'
shared=repo/'development/video20_work/shared_idct'
bin=repo/'bringup/tf_wav_hdmi/tools/iverilog/app/bin'
variants={'retime':'jpeg_idct_y_retimed','dsp_only':'jpeg_idct_y_dsp','retime_dsp':'jpeg_idct_y_retimed_dsp'}
for variant,module in variants.items():
 out=root/f'equiv_shared_{variant}';frozen=out/'frozen';frozen.mkdir(parents=True,exist_ok=True)
 files=[]
 for name in ('jpeg_idct_ram.v','jpeg_idct_ram_dp.v','jpeg_idct_transpose.v','jpeg_idct_transpose_ram.v','jpeg_idct_x.v','jpeg_idct_y.v','jpeg_idct_fifo.v'):
  files.append(source/name)
 ref=out/'jpeg_idct_reference.v';ref.write_text((source/'jpeg_idct.v').read_text(encoding='utf-8-sig').replace('module jpeg_idct\n','module jpeg_idct_reference\n',1),encoding='ascii');files.append(ref)
 v=root/variant/f'{module}.v';files.append(v)
 trans=out/'jpeg_idct_transpose_early.v';trans.write_text((shared/'jpeg_idct_transpose_early.v').read_text(encoding='utf-8-sig').replace('module jpeg_idct_transpose #','module jpeg_idct_transpose_early #',1),encoding='ascii');files.append(trans)
 top=out/'jpeg_idct_early_candidate.v';text=(shared/'jpeg_idct_early.v').read_text(encoding='utf-8-sig')
 text=text.replace('jpeg_idct_transpose #(.EARLY_READ(1))','jpeg_idct_transpose_early #(.EARLY_READ(1))',1)
 text=text.replace('jpeg_idct_y #(.OUT_SHIFT(11))',f'{module} #(.OUT_SHIFT(11))',1)
 top.write_text(text,encoding='ascii');files.append(top)
 tb=out/'tb_shared.sv';tb.write_bytes((shared/'tb_shared.sv').read_bytes());files.append(tb)
 local=[]
 for p in files:
  q=frozen/p.name;q.write_bytes(p.read_bytes());local.append(q)
 cmd=[str(bin/'iverilog.exe'),'-g2012','-s','tb_shared','-o',str(out/'simv'),*[str(p) for p in local]]
 comp=subprocess.run(cmd,cwd=out,stdout=subprocess.PIPE,stderr=subprocess.STDOUT);(out/'compile.log').write_bytes(comp.stdout)
 if comp.returncode:raise SystemExit(f'{variant} compile: '+comp.stdout.decode(errors='replace'))
 run=subprocess.run([str(bin/'vvp.exe'),str(out/'simv')],cwd=out,stdout=subprocess.PIPE,stderr=subprocess.STDOUT);(out/'run.log').write_bytes(run.stdout);print(variant+': '+run.stdout.decode(errors='replace')[-1300:])
 if run.returncode or b'SHARED_IDCT_PASS' not in run.stdout:raise SystemExit(f'{variant} transaction check failed')
 (out/'result.json').write_text(json.dumps({'variant':variant,'status':'PASS','files':{p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in local}},indent=2)+'\n',encoding='utf-8')
