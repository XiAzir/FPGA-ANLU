from pathlib import Path
import hashlib,json
R=Path(__file__).resolve().parents[2];C=R/'development/player_spectrum_arch17';W=Path(__file__).parent
p=W/'shared_mapper/candidate.v';h=hashlib.sha256(p.read_bytes()).hexdigest()
assert h==hashlib.sha256((W/'mapper_tests/candidate_as_tested.v').read_bytes()).hexdigest()=='084b7dc884b1b33e3ebc2804283bc820b0e5a38eb248e7dc14a6303d70f67bfb'
s=json.loads((C/'build/selected_changes.json').read_text(encoding='utf-8-sig'))
s['user_source/hdl_source/fat32_dual_file_sector.v'].update(source=str(p),sha256=h)
(C/'src/user_source/hdl_source/fat32_dual_file_sector.v').write_bytes(p.read_bytes())
(C/'build/selected_changes.json').write_text(json.dumps(s,indent=2));print('Shared revision 084B7D installed')
