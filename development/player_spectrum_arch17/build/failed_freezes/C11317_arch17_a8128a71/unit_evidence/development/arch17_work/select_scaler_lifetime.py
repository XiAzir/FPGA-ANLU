from pathlib import Path
import hashlib,json
R=Path(__file__).resolve().parents[2];C=R/'development/player_spectrum_arch17';W=Path(__file__).parent
p=W/'scaler_lifetime/bmp_scale_engine_candidate.v'
assert hashlib.sha256(p.read_bytes()).hexdigest()=='cde50900d2307674272134b2043c1cd26b53f1372fad913eef1b227a7f9706e2'
s=json.loads((C/'build/selected_changes.json').read_text(encoding='utf-8-sig'))
s['user_source/hdl_source/bmp_scale_engine.v']={'source':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'reason':'HEADER_VALIDATED=1 uses parent-held header width/height/stride; generic0 retains original latches'}
(C/'src/user_source/hdl_source/bmp_scale_engine.v').write_bytes(p.read_bytes())
(C/'build/selected_changes.json').write_text(json.dumps(s,indent=2));print('A04 adds production header storage reuse')
