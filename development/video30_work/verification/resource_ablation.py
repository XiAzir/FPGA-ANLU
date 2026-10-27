"""Compare actual certified synthesis resources across observer-removal groups."""
from pathlib import Path
import hashlib
import json
import re

ROOT=Path(__file__).resolve().parents[3]
WORK=ROOT/'development/video30_work'
paths={
 'D0_C29':ROOT/'development/player_video29_media_flow',
 'D1_external_observers_removed':WORK/'ablation/D1_observers_off',
 'D2_C30':ROOT/'development/player_video30_probe_prune'
}
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def read(p):return json.loads(p.read_text(encoding='utf-8-sig'))

def parameters(p):
    text=p.read_text(encoding='utf-8')
    result={}
    for line in text.splitlines():
        fields=[part.strip() for part in line.split('|')]
        if len(fields)==4 and re.fullmatch('[a-z0-9_]+',fields[0]):result[fields[0]]=fields[1]
    return result

cases={}
for label,project in paths.items():
    build=project/'build/manual'
    latest=read(build/'stage_evidence/latest_synthesis.json')
    stage=read(build/'stage_evidence'/latest['record'])
    assert latest['status']==stage['status']=='success'
    assert sha(build/'AC201_tf_hdmi_gate.db')==stage['gateDbHash']
    text=(build/'AC201_tf_hdmi_gate.area').read_text(encoding='utf-8')
    area={key:int(re.search(r'^#'+key+r'\s+(\d+)',text,re.M).group(1))
          for key in ('lut','reg','bram','dsp','pll','gclk')}
    cases[label]={'project':project.relative_to(ROOT).as_posix(),
      'synthesis_run_id':stage['runId'],'gate_db_sha256':stage['gateDbHash'],
      'area':area,'gate_area_sha256':sha(build/'AC201_tf_hdmi_gate.area'),
      'actual_gate_parameters':parameters(build/'strategy_actual.gate.log'),
      'actual_rtl_parameters':parameters(build/'strategy_actual.rtl.log')}
for key in ('actual_gate_parameters','actual_rtl_parameters'):
    assert cases['D0_C29'][key]==cases['D1_external_observers_removed'][key]==cases['D2_C30'][key],key
base=cases['D0_C29']['area'];d1=cases['D1_external_observers_removed']['area'];d2=cases['D2_C30']['area']
result={'status':'PASS','metric_scope':'Same actual strategy and synthesis stage; physical Slice uses final routed netlist separately',
 'cases':cases,
 'changes':{'D1_minus_D0':{k:d1[k]-base[k] for k in base},
            'D2_minus_D1':{k:d2[k]-d1[k] for k in base},
            'D2_minus_D0':{k:d2[k]-base[k] for k in base}},
 'source_groups':read(WORK/'preparation.json')['groups']}
(WORK/'verification/resource_ablation.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
print(json.dumps({'status':result['status'],'changes':result['changes']},indent=2))
