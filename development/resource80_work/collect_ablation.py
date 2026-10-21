"""Collect actual standalone and full-top ablations; retain source reports and hashes."""
from pathlib import Path
import hashlib,json
from datetime import datetime
R=next(p for p in Path(__file__).resolve().parents if (p/'scripts/anlu_tools.ps1').is_file() and (p/'download').is_dir())
C=R/'development/player_spectrum_resource_80'
W=R/'development/resource80_work'
def read(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def record(p):return {'path':str(p.relative_to(R)),'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'data':read(p)}
standalone=[
 W/'mapper_synthesis/summary.json', W/'mapper/simulation.json',
 W/'catalog/td_area_high/summary.json', W/'catalog/build/selected_latch_diff_result.json',
 W/'catalog/review_bmp/proof_result.json',W/'catalog/stride_experiment/result_manifest.json',
 W/'bmp/synthesis_loader/area_summary.json',W/'mapper_specialize/build/summary.json',
 W/'wav/td_runs/summary.json',W/'mapper_specialize/integration_manifest.json']
optional=W/'mapper_specialize/td/runs/summary.json'
if optional.exists():standalone.append(optional)
result={'created':datetime.now().astimezone().isoformat(),
 'baseline':{'build_id':'C11313','slices':8243,'slice_capacity':9800,'setup_wns_ns':.101,'hold_wns_ns':.011},
 'goal':{'strictly_below_percent':80,'maximum_slices':7839},
 'full_top':[record(p) for p in sorted((C/'build/attempts').glob('*/summary.json'))],
 'standalone':[record(p) for p in standalone],
 'notes':[
 'Standalone comparisons share their own documented strategy; full-top routing determines slice count.',
 'B02 has negative setup and was rejected despite its 7837 slices.',
 'B04 selects mapper specialization. Optional 43-FF BMP header pipeline stays unselected; B03/B04 timing already passes.',
 'WAV v1 rejected for AreaHigh LUT regression; rowstep scaler rejected for +71 LUT/+11 FF despite saving one DSP.',
 'WAV v2 AreaHigh baseline 1347 LUT/641 FF -> 1291 LUT/468 FF; logs and source hashes in wav/td_runs/summary.json.',
 'Initial B01/B03 system replays omitted WAV candidate; source override list was corrected to ten entries and every changed source is now asserted. Final system replay is separately bound.',
 ]}
(C/'build/ablation_summary.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'attempts':len(result['full_top']),'standalone':len(result['standalone'])}))
