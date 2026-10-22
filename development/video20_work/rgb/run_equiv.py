from pathlib import Path
import subprocess,json,hashlib
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[2]
source=ROOT/'development/player_video19/src/user_source/hdl_source/player_rgb_adjust.v'
reference=HERE/'player_rgb_adjust_reference.v'
reference.write_text(source.read_text().replace('module player_rgb_adjust (','module player_rgb_adjust_reference ('),encoding='utf-8')
run=HERE/'equiv'
run.mkdir(exist_ok=False)
BIN=Path('E:/ModelsimSE/win64')
(run/'modelsim.ini').write_text('[Library]\nwork = work\nothers = E:/ModelsimSE/modelsim.ini\n')
(run/'run.do').write_text('onerror {quit -code 2 -f}\nonbreak {quit -code 3 -f}\nrun -all\nquit -code 0 -f\n')
commands=[[str(BIN/'vlib.exe'),'work'],[str(BIN/'vlog.exe'),'-sv',str(reference),str(HERE/'player_rgb_adjust.v'),str(HERE/'tb_rgb.sv')],[str(BIN/'vsim.exe'),'-c','-lic_noqueue','-novopt','work.tb_rgb','-do','run.do']]
for i,cmd in enumerate(commands):
 p=subprocess.run(cmd,cwd=run,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
 (run/f'{i}.log').write_bytes(p.stdout)
 assert p.returncode==0,p.stdout.decode(errors='replace')[-4000:]
assert b'RGB_EXHAUSTIVE_PASS' in p.stdout
result={'status':'PASS','selector_pairs':128,'rgb_triples':32768,'channel_comparisons':98304,'files':{str(f):hashlib.sha256(f.read_bytes()).hexdigest() for f in (source,reference,HERE/'player_rgb_adjust.v',HERE/'tb_rgb.sv')}}
(run/'result.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(result))
