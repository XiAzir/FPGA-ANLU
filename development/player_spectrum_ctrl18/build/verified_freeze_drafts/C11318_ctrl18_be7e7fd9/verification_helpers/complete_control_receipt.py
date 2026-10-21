from pathlib import Path
import json,hashlib,re
C=Path(__file__).resolve().parents[2]/'development/player_spectrum_ctrl18';T=C/'build/attempts/A00_same_id_control'
p=T/'result.json';r=json.loads(p.read_text())
r.update(status='SYNTHESIS_PHYSICAL_COMPLETE',slices=int(re.search(r'#slices\s*\|\s*(\d+)',(T/'route.qor').read_text())[1]),timing=(T/'physical/AC201_tf_hdmi_phy.ts').read_text().strip(),physical_run_id=json.loads((T/'physical/stage_evidence/latest_physical.json').read_text(encoding='utf-8-sig'))['runId'])
r['files']=[{'path':f.relative_to(T).as_posix(),'sha256':hashlib.sha256(f.read_bytes()).hexdigest()} for f in sorted(T.rglob('*')) if f.is_file() and f!=p and f.suffix!='.db']
r['database_files']=[{'path':f.relative_to(T).as_posix(),'sha256':hashlib.sha256(f.read_bytes()).hexdigest()} for f in sorted(T.rglob('*.db')) if f.is_file()]
p.write_text(json.dumps(r,indent=2)+'\n');print(r['status'],r['slices'],r['timing'])
