from pathlib import Path
import hashlib, json, shutil

root = Path(__file__).resolve().parents[3]
p = Path(__file__).resolve().parents[1]
parent = root / 'development/player_bmp_scale/checkpoints/bmp_scale_20261012_verified'
def sha(f): return hashlib.sha256(f.read_bytes()).hexdigest().upper()
assert sha(parent/'manifest.json') == '71F87A4B82F974092F63102E0D7522B6C5577BD367B6789C6AD0DDDA37A76FB7'
entries = json.loads((parent/'manifest.json').read_text(encoding='utf-8-sig'))
assert len(entries) == 268
for e in entries:
    assert sha(parent/e['path']) == e['sha256'], e['path']
assert not (p/'src').exists()
for name in ['src', 'scripts']:
    shutil.copytree(parent/name, p/name)
for f in (p/'scripts').iterdir():
    if f.is_file():
        f.write_text(f.read_text(encoding='utf-8-sig').replace('player_bmp_scale','player_waveform_fine'), encoding='utf-8')
f = p/'src/td_project/AC201_tf_hdmi.al'
f.write_text(f.read_text(encoding='utf-8-sig').replace('/player_bmp_scale/','/player_waveform_fine/'), encoding='utf-8')
for name in ['top_tf_hdmi_audio.v','player_status_monitor.v']:
    f=p/'src/user_source/hdl_source'/name
    f.write_text(f.read_text(encoding='utf-8-sig').replace('C11206','C11301'),encoding='utf-8')
# Keep inherited test source, never inherit old output logs as new test results.
model=p/'build/model'
model.mkdir(parents=True)
for f in (parent/'build/model').iterdir():
    if f.suffix in ['.v','.ps1','.py','.hex']:
        shutil.copy2(f,model/f.name)
for f in model.glob('*.ps1'):
    f.write_text(f.read_text(encoding='utf-8-sig').replace('player_bmp_scale','player_waveform_fine'),encoding='utf-8')
(p/'build/parent_receipt.json').write_text(json.dumps({'parent':str(parent),'manifestSha256':sha(parent/'manifest.json'),'checkedEntries':len(entries),'status':'PASS','noOldDatabasesCopied':True},indent=2),encoding='utf-8')
print('C11301_PARENT268_SHA_PASS_ISOLATED_SOURCE_READY')
