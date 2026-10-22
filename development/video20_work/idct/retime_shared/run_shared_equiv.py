from pathlib import Path
import hashlib,json,subprocess
root=Path(__file__).resolve().parent
repo=root.parents[3]
src=repo/'development/player_video19/src/user_source/hdl_source/jpeg'
shared=repo/'development/video20_work/shared_idct'
out=root/'equiv_shared_retime'
out.mkdir(exist_ok=True)
files=[]
for name in ('jpeg_idct_ram.v','jpeg_idct_ram_dp.v','jpeg_idct_transpose.v','jpeg_idct_transpose_ram.v','jpeg_idct_x.v','jpeg_idct_y.v','jpeg_idct_fifo.v'):
 p=src/name; files.append(p)
ref=out/'jpeg_idct_reference.v'
ref.write_text((src/'jpeg_idct.v').read_text(encoding='utf-8-sig').replace('module jpeg_idct\n','module jpeg_idct_reference\n',1),encoding='ascii');files.append(ref)
ret=out/'jpeg_idct_y_retimed.v';ret.write_bytes((root/'retime/jpeg_idct_y_retimed.v').read_bytes());files.append(ret)
transpose=out/'jpeg_idct_transpose_early.v'
txt=(shared/'jpeg_idct_transpose_early.v').read_text(encoding='utf-8-sig').replace('module jpeg_idct_transpose #','module jpeg_idct_transpose_early #',1)
transpose.write_text(txt,encoding='ascii');files.append(transpose)
top=out/'jpeg_idct_early_retimed.v'
txt=(shared/'jpeg_idct_early.v').read_text(encoding='utf-8-sig')
txt=txt.replace('jpeg_idct_transpose #(.EARLY_READ(1))','jpeg_idct_transpose_early #(.EARLY_READ(1))',1)
txt=txt.replace('jpeg_idct_y #(.OUT_SHIFT(11))','jpeg_idct_y_retimed #(.OUT_SHIFT(11))',1)
top.write_text(txt,encoding='ascii');files.append(top)
tb=out/'tb_shared.sv';tb.write_bytes((shared/'tb_shared.sv').read_bytes());files.append(tb)
frozen=out/'frozen';frozen.mkdir(exist_ok=True)
local=[]
for p in files:
 target=frozen/p.name;target.write_bytes(p.read_bytes());local.append(target)
bin=repo/'bringup/tf_wav_hdmi/tools/iverilog/app/bin'
exe=bin/'iverilog.exe';vvp=bin/'vvp.exe'
compile_cmd=[str(exe),'-g2012','-s','tb_shared','-o',str(out/'simv'),*[str(p) for p in local]]
p=subprocess.run(compile_cmd,cwd=out,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
(out/'compile.log').write_bytes(p.stdout)
if p.returncode: raise SystemExit(p.stdout.decode(errors='replace'))
p=subprocess.run([str(vvp),str(out/'simv')],cwd=out,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
(out/'run.log').write_bytes(p.stdout)
print(p.stdout.decode(errors='replace')[-3000:])
if p.returncode or b'SHARED_IDCT_PASS' not in p.stdout: raise SystemExit('shared transaction compare failed')
(out/'result.json').write_text(json.dumps({'status':'PASS','files':{p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in local}},indent=2)+'\n',encoding='utf-8')
