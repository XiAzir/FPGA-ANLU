from pathlib import Path
import json,hashlib,argparse
R=Path(__file__).resolve().parents[2];W=Path(__file__).parent
C=R/'development/player_spectrum_ctrl18';P=R/'development/player_spectrum_arch17'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def read(p):return json.loads(p.read_text(encoding='utf-8-sig'))
files=set();checks=[]
def add(p):
 p=Path(p);assert p.is_file(),p;files.add(p);return p
parent=read(add(P/'build/unit_evidence.json'));assert parent['status']=='PASS'
for e in parent['files']:assert sha(add(e['path']))==e['sha256'],e['path']
assert sha(W/'key_events/player_adjust_control.v')==sha(C/'src/user_source/hdl_source/player_adjust_control.v')
assert sha(W/'key_events/tf_bmp_file_player_event_candidate.v')==sha(C/'src/user_source/hdl_source/tf_bmp_file_player.v')
assert sha(W/'status_domain/status_hex595.v')==sha(P/'src/user_source/hdl_source/status_hex595.v')==sha(C/'src/user_source/hdl_source/status_hex595.v')
def bind_receipt(value):
 if isinstance(value,dict):
  if 'path' in value and 'sha256' in value:
   p=Path(value['path']);p=p if p.is_absolute() else R/p
   assert sha(p)==value['sha256'].lower(),p
   if p.suffix.lower() not in ('.exe','.vvp','.db'):add(p)
  for v in value.values():bind_receipt(v)
 elif isinstance(value,list):
  for v in value:bind_receipt(v)
bind_receipt(read(W/'key_events/source_receipt.json'))
bind_receipt(read(W/'integration_audit/loader_event_receipt.json'))
import re
for digest,rel in re.findall(r'^([A-Fa-f0-9]{64})\s+(.+)$',(W/'status_domain/source_sha256.txt').read_text(),re.M):
 assert sha(add(R/rel.strip()))==digest.lower(),rel
spec=read(W/'test_expectations.json')
for item in spec['required_logs']:
 p=add(W/item['path']);content=p.read_text(encoding='utf-8-sig',errors='replace')
 for marker in item['markers']:assert marker in content,(p,marker)
 checks.append({'path':str(p),'sha256':sha(p),'markers':item['markers']})
for folder in ('key_events','status_domain','integration_audit'):
 for p in (W/folder).rglob('*'):
  if p.is_file() and p.suffix.lower() in ('.v','.vh','.py','.ps1','.json','.md','.log','.diff','.patch','.csv','.sdc','.tcl','.al','.txt'):
   add(p)
for p in W.iterdir():
 if p.is_file() and p.suffix in ('.py','.ps1','.json','.vh','.md'):add(p)
for p in (C/'build/audit/attempts').rglob('*'):
 if p.is_file():add(p)
for p in (C/'build/attempts').glob('*/result.json'):
 r=read(add(p))
 for e in r['files']:
  q=add(p.parent/e['path']);assert sha(q)==e['sha256'],q
result={'status':'PASS','hardware_status':'BOARD_NOT_TESTED','inherited_parent_unit_files':len(parent['files']),'checks':checks,'files':[{'path':str(p),'relative_to_repository':p.relative_to(R).as_posix(),'sha256':sha(p)} for p in sorted(files)]}
(C/'build/unit_evidence.json').write_text(json.dumps(result,indent=2)+'\n');print('UNIT_EVIDENCE PASS',len(files))
