from pathlib import Path
import json,hashlib
R=Path(__file__).resolve().parents[2];C=R/'development/player_spectrum_arch17';W=Path(__file__).parent
p=W/'codec_hold/rgb888_word_codec.v'
assert hashlib.sha256(p.read_bytes()).hexdigest()=='414a74a76a828b45f9baa2f0c56f5f80d5c6311b21001e309246d2f60a333552'
s=json.loads((C/'build/selected_changes.json').read_text())
s['user_source/hdl_source/rgb888_word_codec.v']={'source':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'reason':'Reuse held normal-FIFO word for high reservoir suffix; exact same read/pixel timing; 32 fewer local FF'}
(C/'src/user_source/hdl_source/rgb888_word_codec.v').write_bytes(p.read_bytes())
(C/'build/selected_changes.json').write_text(json.dumps(s,indent=2));print('A02 lifetime + held FIFO reservoir installed')
