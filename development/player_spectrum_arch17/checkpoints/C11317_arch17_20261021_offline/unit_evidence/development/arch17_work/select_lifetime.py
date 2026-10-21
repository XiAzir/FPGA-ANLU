from pathlib import Path
import json,hashlib
R=Path(__file__).resolve().parents[2];C=R/'development/player_spectrum_arch17';W=Path(__file__).parent
p=W/'mapper_lifetime/fat32_file_sector.v'
selected={'user_source/hdl_source/fat32_file_sector.v':{'source':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'reason':'94-bit working/cache lifetime merge per mapper; no interface-cycle changes'}}
(C/'src/user_source/hdl_source/fat32_file_sector.v').write_bytes(p.read_bytes())
(C/'build/selected_changes.json').write_text(json.dumps(selected,indent=2));print('installed lifetime-only A01')
