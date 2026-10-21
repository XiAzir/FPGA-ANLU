from pathlib import Path
import json,hashlib
C=Path(__file__).resolve().parents[2]/'development/player_spectrum_ctrl18'
for p in (C/'build/attempts').glob('*/result.json'):
 r=json.loads(p.read_text());new=[];db=list(r.get('database_files',[]))
 for e in r['files']:
  q=p.parent/e['path'];assert hashlib.sha256(q.read_bytes()).hexdigest()==e['sha256']
  if q.suffix=='.db':db.append(e)
  else:new.append(e)
 r['files']=new;r['database_files']=db
 p.write_text(json.dumps(r,indent=2)+'\n')
 print(p.parent.name,len(new),len(db))
