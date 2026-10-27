import hashlib
import json
from pathlib import Path
import subprocess

ROOT=Path(__file__).resolve().parents[2]
WORK=Path(__file__).resolve().parent
BIN=ROOT/'bringup/tf_wav_hdmi/tools/iverilog/app/bin'
prefixes={'fixed':WORK/'sdr_init_ref_public_prefix_final.v',
          'negative_raw_ack':ROOT/'development/video40_work/timing_review/refresh_macro/sdr_init_ref_public_prefix_C40.v'}
records=[]
for tag,prefix_path in prefixes.items():
    case=WORK/'ack_model'/tag
    case.mkdir(parents=True,exist_ok=True)
    prefix=prefix_path.read_text(encoding='utf-8-sig')
    assert 'begin_protected' not in prefix
    prefix=prefix.replace('../user_source/hdl_source/include/global_def.v','global_def.v')+'\nendmodule\n'
    (case/'prefix.v').write_text(prefix,encoding='utf-8')
    (case/'global_def.v').write_bytes((ROOT/'development/player_video41_refresh/src/user_source/hdl_source/include/global_def.v').read_bytes())
    comp=subprocess.run([str(BIN/'iverilog.exe'),'-g2012','-s','tb_ack_normalization','-I',str(case),
      '-o',str(case/'test.vvp'),str(WORK/'tb_ack_normalization.v'),str(case/'prefix.v')],capture_output=True,text=True)
    (case/'compile.log').write_text(comp.stdout+comp.stderr,encoding='utf-8')
    assert comp.returncode==0
    run=subprocess.run([str(BIN/'vvp.exe'),str(case/'test.vvp')],capture_output=True,text=True)
    (case/'run.log').write_text(run.stdout+run.stderr,encoding='utf-8')
    if tag=='fixed': assert run.returncode==0 and 'ACK_EDGE_PASS' in run.stdout
    else: assert run.returncode!=0 and 'width=2 generated 2 triggers' in run.stdout
    records.append({'case':tag,'exit_code':run.returncode,'stdout':run.stdout,
       'prefix_sha256':hashlib.sha256(prefix_path.read_bytes()).hexdigest()})
result={'status':'PASS','cases':records,'scope':'Candidate ACK shift pipeline with raw ACK widths and original-prefix negative control; protected command encoding checked separately by mapped gate.'}
(WORK/'ack_model/summary.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
print(json.dumps(result,indent=2))
