from pathlib import Path
import json,hashlib,re
R=next(p for p in Path(__file__).resolve().parents if (p/'scripts/anlu_tools.ps1').is_file() and (p/'download').is_dir())
W=Path(__file__).parent;C=R/'development/player_spectrum_arch17';P=R/'development/player_spectrum_opt16'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def read(p):return json.loads(p.read_text(encoding='utf-8-sig'))
files=[];checks=[]
def add(p):
 p=Path(p);assert p.is_file(),p
 if p not in files:files.append(p)
 return p
def log(p,marker):
 p=add(p);assert marker in p.read_text(errors='replace'),p
 checks.append({'log':str(p),'sha256':sha(p),'marker':marker})
selected=read(C/'build/selected_changes.json')
parent_unit=read(add(P/'build/unit_evidence.json'));assert parent_unit['status']=='PASS'
for e in parent_unit['files']:assert sha(add(e['path']))==e['sha256'],e['path']
if selected.get('user_source/hdl_source/fat32_file_sector.v',{}).get('action')!='remove' and 'user_source/hdl_source/fat32_file_sector.v' in selected:
 assert sha(add(W/'mapper_lifetime/fat32_file_sector.v'))==sha(C/'src/user_source/hdl_source/fat32_file_sector.v')
 matrix=read(add(W/'mapper_lifetime/summary.json'));assert len(matrix)==11 and all(x['status']=='PASS' for x in matrix)
 for x in matrix:log(x['log'],'PASS')
 original=(P/'src/user_source/hdl_source/fat32_file_sector.v').read_text(encoding='utf-8-sig')
 assert add(W/'mapper_lifetime/reference.v').read_text()==original.replace('module fat32_file_sector #','module fat32_file_sector_reference #')
if 'user_source/hdl_source/fat32_dual_file_sector.v' in selected:
 assert sha(add(W/'shared_mapper/candidate.v'))==sha(add(W/'mapper_tests/candidate_as_tested.v'))==sha(C/'src/user_source/hdl_source/fat32_dual_file_sector.v')
 receipt=read(add(W/'shared_mapper/source_receipt.json'))
 assert receipt['candidate']['sha256'].lower()==sha(W/'shared_mapper/candidate.v')
 assert receipt['area_high']['shared']['candidate_sha256'].lower()==sha(W/'shared_mapper/candidate.v')
 for label in ('shared','reference'):
  e=receipt['area_high'][label];assert sha(add(R/e['path']))==e['sha256'].lower()
 log(W/'mapper_tests/fat32_dual_file_sector.run.log','PASS: reference contract suite complete')
 log(W/'mapper_tests/fat32_dual_file_sector.run.log','PASS BMP watchdog edge concurrent with WAV dispatch preserves WAV transaction')
 log(W/'mapper_tests/fat32_dual_file_sector_ref.run.log','PASS: reference contract suite complete')
if 'user_source/hdl_source/rgb888_word_codec.v' in selected:
 D=W/'codec_hold';receipt=read(add(D/'source_receipt.json'))
 assert receipt['candidate_sha256']==sha(add(D/'rgb888_word_codec.v'))==sha(C/'src/user_source/hdl_source/rgb888_word_codec.v')
 for e in receipt['inputs']:assert sha(add(e['path']))==e['sha256']
 log(D/'run.log','CODEC_EQUIV PASS cycles=1000020 pops=486128 pixels=748838 clears=8 levels=1ff')
if 'user_source/hdl_source/bmp_scale_engine.v' in selected:
 D=W/'scaler_lifetime';receipt=read(add(D/'source_receipt.json'))
 assert receipt['source_binding']['candidate_engine_sha256']==sha(add(D/'bmp_scale_engine_candidate.v'))==sha(C/'src/user_source/hdl_source/bmp_scale_engine.v')
 for name,mark in [('default_13case_run.log','BMP_EQUIV PASS'),('valid_domain_run.log','BMP_C11315_VALIDATED PASS'),('diagnostic_538_run.log','BMP_FAILURE_DETAIL PASS')]:log(D/name,mark)
 for name,expected in receipt['reproduction']['log_sha256'].items():assert sha(add(D/name))==expected
 F=D/'full_six';six=read(add(F/'source_receipt.json'))
 assert six['simulation']['result']=='PASS' and six['simulation']['exit_code']==0
 assert six['expected_total_pixels']==1843200 and six['simulation']['public_output_compare_width_bits']==160
 assert six['candidate_engine_source']['sha256']==sha(C/'src/user_source/hdl_source/bmp_scale_engine.v')
 log(F/'full_six_run.log',six['simulation']['final_pass_line'])
 assert sha(F/'full_six_run.log')==six['simulation']['run_log_sha256']
 for e in six.values():
  if isinstance(e,dict) and set(('path','sha256'))<=set(e):assert sha(add(e['path']))==e['sha256'],e['path']
 for e in six['images']:assert sha(add(e['path']))==e['sha256'],e['path']
for folder in ('mapper_lifetime','codec','codec_hold','catalog_storage','scaler_lifetime','shared_mapper','mapper_tests','shared_review','final_preflight'):
 for p in (W/folder).rglob('*'):
  if not p.is_file():continue
  if any(part in ('__pycache__','work','modelsim_work') for part in p.parts):continue
  if p.suffix in ('.py','.ps1','.v','.vh','.json','.log','.md','.csv','.diff','.al','.tcl','.sdc') or p.name=='gate.area':add(p)
for p in (C/'build/attempts').glob('*/result.json'):
 receipt=read(add(p))
 for e in receipt['files']:
  q=add(p.parent/e['path']);assert sha(q)==e['sha256'],q
for p in W.iterdir():
 if p.is_file() and p.suffix in ('.py','.vh','.md'):add(p)
for p in (C/'build/audit/attempts').rglob('*'):
 if p.is_file() and p.suffix in ('.json','.ps1','.md'):add(p)
result={'status':'PASS','hardware_status':'BOARD_NOT_TESTED','checks':checks,'inherited_parent_unit_files':len(parent_unit['files']),'files':[{'path':str(p),'relative_to_repository':p.relative_to(R).as_posix(),'sha256':sha(p)} for p in files]}
(C/'build/unit_evidence.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');print('UNIT_EVIDENCE PASS files',len(files))
