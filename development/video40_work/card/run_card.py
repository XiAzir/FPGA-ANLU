import hashlib
import json
import argparse
from pathlib import Path
import re
import shutil
import subprocess
import time

ROOT=Path(__file__).resolve().parents[3]
WORK=Path(__file__).resolve().parent
CAND=ROOT/'development/player_video40_spi25/src/user_source/hdl_source/SD'
FIXTURE=ROOT/'development/system_verification_20261016/card'
TOOLS=ROOT/'bringup/tf_wav_hdmi/tools/iverilog/app/bin'
for name in ['packed_mem.mem','lba_map.mem','expected_sectors.mem','sd_spi_card_model.v']:
    if not (WORK/name).exists(): shutil.copy2(FIXTURE/name,WORK/name)
src=[WORK/'sd_spi_card_model.v',WORK/'tb_card25.v']+[CAND/n for n in ['sd_card_top.v','sd_card_sec_read_write.v','sd_card_cmd.v','spi_master.v']]
parser=argparse.ArgumentParser()
parser.add_argument('--observer-only',action='store_true')
args=parser.parse_args()
cases=[(0,14,0),(1,14,0),(1,14,1)] if args.observer_only else [(f,d,0) for d in [0,14,18] for f in [0,1]]+[(1,14,1)]
results=[]
for fast,delay,inject in cases:
    tag=f'fast{fast}_delay{delay}_inject{inject}'
    vvp=WORK/(tag+'.vvp')
    args=[str(TOOLS/'iverilog.exe'),'-g2012','-s','tb_card25',f'-Ptb_card25.FAST={fast}',f'-Ptb_card25.MISO_DELAY_NS={delay}',f'-Ptb_card25.INJECT_DATA_BIT={inject}','-o',str(vvp),*map(str,src)]
    comp=subprocess.run(args,cwd=WORK,capture_output=True,text=True)
    (WORK/(tag+'_compile.log')).write_text(comp.stdout+comp.stderr,encoding='utf-8')
    if comp.returncode: raise RuntimeError(comp.stdout+comp.stderr)
    start=time.monotonic()
    run=subprocess.run([str(TOOLS/'vvp.exe'),str(vvp)],cwd=WORK,capture_output=True,text=True,timeout=90)
    log=run.stdout+run.stderr
    (WORK/(tag+'_run.log')).write_text(log,encoding='utf-8')
    token='CARD25_NEGATIVE_PASS' if inject else 'CARD25_PASS'
    passed=run.returncode==0 and token in log and not re.search(r'FATAL|ERROR',log)
    item={'tag':tag,'status':'PASS' if passed else 'FAIL','exit_code':run.returncode,'elapsed_wall_s':round(time.monotonic()-start,3),'stdout':log}
    results.append(item)
    print(json.dumps(item,ensure_ascii=False),flush=True)
    (WORK/'summary.json').write_text(json.dumps({'state':'IN_PROGRESS','scope':'32-sector external pin card model; data golden and independently recovered CRC; no physical card/SDF.','cases':results},ensure_ascii=False,indent=2),encoding='utf-8')
    if not passed: raise RuntimeError('Failed '+tag)
binding={str(p.relative_to(ROOT)).replace('\\','/'):hashlib.sha256(p.read_bytes()).hexdigest() for p in src}
summary={'state':'PASS','scope':'32-sector external pin card model at 50MHz; CRC and byte goldens; delays 0/14/18ns are modeling points, not asserted board/card specifications.','cases':results,'source_sha256':binding}
(WORK/'summary.json').write_text(json.dumps(summary,ensure_ascii=False,indent=2),encoding='utf-8')
