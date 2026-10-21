from pathlib import Path
import json,hashlib,re
R=next(p for p in Path(__file__).resolve().parents if (p/'scripts/anlu_tools.ps1').is_file() and (p/'download').is_dir())
W=R/'development/opt16_work';C=R/'development/player_spectrum_opt16';V=W/'small/validated_scaler/c11315'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def read(p):return json.loads(p.read_text(encoding='utf-8-sig'))
files=[];checks=[]
def add(p):
 p=Path(p);assert p.is_file(),p
 if p not in files:files.append(p)
 return p
for name,marker in [('default_13case_run.log','BMP_EQUIV PASS valid=7 errors=6'),('valid_domain_run.log','BMP_C11315_VALIDATED PASS valid=7'),('diagnostic_538_run.log','BMP_FAILURE_DETAIL PASS cases=538'),('full_paired_run.log','SCALER_INTEGRATION PASS images=6 pairs=C11315/HEADER_VALIDATED pixels=1843200 cycle_outputs=matched')]:
 p=add(V/name);assert marker in p.read_text(errors='replace'),p;checks.append({'log':str(p),'marker':marker})
for name in ('bmp_scale_engine.v','tf_bmp_file_player.v'):
 td=add(V/'td/A2_validated/hdl_source'/name)
 assert sha(td)==sha(C/'src/user_source/hdl_source'/name),name
assert sha(add(W/'catalog/fat32_catalog_candidate_fixed_flags.v'))==sha(C/'src/user_source/hdl_source/fat32_catalog.v')
matrix=read(add(W/'catalog/build/matrix_summary.json'));assert len(matrix)==15 and all(x['returncode']==0 for x in matrix)
assert read(add(W/'bmp_extent_proof.json'))['geometry_pairs']==786432
for variant in ('baseline','clean_combined'):
 d=W/'catalog/td_area_high'/variant
 add(d/'reports/gate.area')
 if variant=='baseline':
  log=add(d.parent/'td_console.log');s=log.read_text(errors='replace').split('AREA_DONE baseline')[0]
  assert 'AREA_BEGIN baseline' in s and 'Report gate stage QoR done.' in s
 else:
  log=add(d/'td_console.log');s=log.read_text(errors='replace');assert 'SYNTHESIS_COMPLETE' in s
 assert 'CRITICAL-WARNING' not in s
for d in [V/'td/A1_base',V/'td/A2_validated',W/'catalog/td_area_high/baseline',W/'catalog/td_area_high/clean_combined']:
 for kind in ('rtl','gate'):
  p=add(d/f'reports/actualparams.{kind}.log');s=p.read_text()
  for k,v in [('min_ripple_len','18'),('mapper_lut_delay','1600'),('add_map_lut_struct','high'),('map_mode','area_prior')]:assert re.search(k+r'\s*\|\s*'+v+r'\s*\|',s),(p,k)
for name,marker in [('sd_read_crc.log','PASS tb_sd_read_crc blocks=5 injected_corruptions=2'),('fault_snapshot/run.log','PASS fault_snapshot checks=77')]:
 p=add(C/'build/model'/name);assert marker in p.read_text(errors='replace'),p
for folder in (W/'catalog',V,W/'mapper',W/'scaler',W/'selected'):
 for p in folder.iterdir():
  if p.is_file() and p.suffix in ('.py','.v','.md','.diff','.json','.log','.csv'):
   # Incomplete early experiments are preserved in their own directories;
   # the selected-unit folder and its recorded outputs form this receipt.
   add(p)
for p in (W/'catalog/variants').glob('*'):
 if p.is_file() and p.suffix in ('.v','.json'):add(p)
for p in (W/'small').iterdir():
 if p.is_file() and p.suffix in ('.md','.v','.log'):add(p)
for tag in ('baseline','candidate'):
 for p in (W/'small'/tag).rglob('*'):
  if p.is_file() and (p.suffix in ('.v','.tcl','.al','.sdc') or p.name in ('gate.area','console.log','actualparams.rtl.log','actualparams.gate.log')):add(p)
for name in ('extended_diff_result.json','geometry_reference.log','geometry_shared36.log','names_reference.log','names_shared36.log'):add(W/'catalog/build'/name)
for name in ('area_summary.json','area_summary.csv'):add(W/'catalog/td_area_high'/name)
for folder in ('A00_buildid_only','A01_shared_multiplier'):
 d=C/'build/attempts'/folder;receipt=read(add(d/'result.json'))
 for e in receipt['files']:
  p=add(d/e['path']);assert sha(p)==e['sha256'],p
for name in ('bmp_header_contract.vh','prove_bmp_extent.py','verify_unit_evidence.py'):add(W/name)
result={'status':'PASS','hardware_status':'BOARD_NOT_TESTED','checks':checks,'catalog_variant_count':len(matrix),'geometry_pairs':786432,'files':[{'path':str(p),'relative_to_repository':p.relative_to(R).as_posix(),'sha256':sha(p)} for p in files]}
(C/'build/unit_evidence.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');print('UNIT_EVIDENCE PASS files',len(files))
