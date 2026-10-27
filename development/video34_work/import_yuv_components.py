from pathlib import Path
import shutil,json,hashlib
ROOT=Path(__file__).resolve().parents[2]
HERE=Path(__file__).parent
DEST=ROOT/'development/player_video34_1080p15/src/user_source/hdl_source'
sources=[HERE/'yuv_scan/yuv420_scan_cache.v',HERE/'yuv420/yuv420_to_rgb888.v']
receipt=[]
for source in sources:
    target=DEST/source.name
    shutil.copy2(source,target)
    h=hashlib.sha256(source.read_bytes()).hexdigest()
    assert hashlib.sha256(target.read_bytes()).hexdigest()==h
    receipt.append({'source':str(source),'target':str(target),'sha256':h})
(HERE/'yuv_component_binding.json').write_text(json.dumps(receipt,indent=2),encoding='utf-8')
print(json.dumps({'copied':len(receipt)}))
