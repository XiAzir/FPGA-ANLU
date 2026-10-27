from pathlib import Path
import hashlib,json

ROOT=Path(__file__).resolve().parents[2]
SOURCE=ROOT/'development/video33_work/idct/jpeg_idct_dc_fast.v'
DEST=ROOT/'development/player_video34_1080p15/src/user_source/hdl_source/jpeg/jpeg_idct.v'
old=DEST.read_bytes()
candidate=SOURCE.read_bytes().replace(b'module jpeg_idct_dc_fast',b'module jpeg_idct',1)
DEST.write_bytes(candidate)
receipt={'source':str(SOURCE),'source_sha256':hashlib.sha256(SOURCE.read_bytes()).hexdigest(),
         'destination':str(DEST),'previous_sha256':hashlib.sha256(old).hexdigest(),
         'integrated_sha256':hashlib.sha256(candidate).hexdigest(),
         'change':'Module symbol only renamed from jpeg_idct_dc_fast to jpeg_idct; exact algorithm bytes retained.'}
Path(__file__).with_name('idct_integration.json').write_text(json.dumps(receipt,indent=2),encoding='utf-8')
print(json.dumps(receipt))
