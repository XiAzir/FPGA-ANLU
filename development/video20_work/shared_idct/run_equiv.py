from pathlib import Path
import subprocess,json,hashlib,argparse
import shutil
from datetime import datetime
parser=argparse.ArgumentParser()
parser.add_argument('--candidate',default='jpeg_idct.v')
parser.add_argument('--transpose',type=Path)
parser.add_argument('--arithmetic',type=Path)
args=parser.parse_args()
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[2]
SRC=ROOT/'development/player_video19/src/user_source/hdl_source/jpeg'
run=HERE/('equiv_'+datetime.now().strftime('%H%M%S'))
run.mkdir(exist_ok=False)
ref=run/'jpeg_idct_reference.v'
ref.write_text((SRC/'jpeg_idct.v').read_text().replace('module jpeg_idct\n','module jpeg_idct_reference\n').replace('jpeg_idct_y\n','jpeg_idct_y_reference\n'))
ref_y=run/'jpeg_idct_y_reference.v'
ref_y.write_text((SRC/'jpeg_idct_y.v').read_text().replace('module jpeg_idct_y\n','module jpeg_idct_y_reference\n'))
sources=[SRC/n for n in ('jpeg_idct_ram.v','jpeg_idct_ram_dp.v','jpeg_idct_transpose.v','jpeg_idct_transpose_ram.v','jpeg_idct_x.v','jpeg_idct_y.v','jpeg_idct_fifo.v')]+[ref,ref_y,HERE/args.candidate,HERE/'tb_shared.sv']
if args.transpose:
 sources=[args.transpose.resolve() if f.name=='jpeg_idct_transpose.v' else f for f in sources]
if args.arithmetic:
 sources=[args.arithmetic.resolve() if f.name=='jpeg_idct_y.v' else f for f in sources]
frozen=run/'frozen'
frozen.mkdir()
copied=[]
for source in sources:
 target=frozen/('jpeg_idct_transpose.v' if args.transpose and source==args.transpose.resolve() else source.name)
 shutil.copy2(source,target)
 copied.append(target)
sources=copied
bin=ROOT/'bringup/tf_wav_hdmi/tools/iverilog/app/bin'
cmd=[str(bin/'iverilog.exe'),'-g2012','-s','tb_shared','-o',str(run/'simv'),*[str(p) for p in sources]]
for name,command in [('compile',cmd),('run',[str(bin/'vvp.exe'),str(run/'simv')])]:
 p=subprocess.run(command,cwd=run,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
 (run/f'{name}.log').write_bytes(p.stdout)
 print(p.stdout.decode(errors='replace')[-2200:])
 assert p.returncode==0
assert b'SHARED_IDCT_PASS' in p.stdout
(run/'result.json').write_text(json.dumps({'status':'PASS','files':{str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in sources}},indent=2)+'\n')
