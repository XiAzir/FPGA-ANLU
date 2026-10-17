from pathlib import Path
import hashlib, json, shutil
root=Path(__file__).resolve().parents[3]
p=Path(__file__).resolve().parents[1]
parent=root/'development/player_waveform_fine/checkpoints/waveform_fine_20261013_candidate'
def sha(f):return hashlib.sha256(f.read_bytes()).hexdigest().upper()
assert sha(parent/'manifest.json')=='F6F5DA1F9228DF3231EB46CC0113E81894D3E99B412C528F3684BBED8F0EA0EE'
entries=json.loads((parent/'manifest.json').read_text(encoding='utf-8-sig'));assert len(entries)==175
for e in entries:assert sha(parent/e['path'])==e['sha256'],e['path']
assert not (p/'src').exists()
for sub in ['src','scripts']:shutil.copytree(parent/sub,p/sub)
for f in (p/'scripts').iterdir():
    if f.is_file():f.write_text(f.read_text(encoding='utf-8-sig').replace('player_waveform_fine','player_music_envelope'),encoding='utf-8')
f=p/'src/td_project/AC201_tf_hdmi.al';f.write_text(f.read_text(encoding='utf-8-sig').replace('/player_waveform_fine/','/player_music_envelope/'),encoding='utf-8')
for n in ['player_status_monitor.v','top_tf_hdmi_audio.v']:
    f=p/'src/user_source/hdl_source'/n;f.write_text(f.read_text(encoding='utf-8-sig').replace('C11301','C11302'),encoding='utf-8')
(p/'build/model').mkdir(parents=True)
shutil.copy2(parent/'build/model/music_pcm.hex',p/'build/model/music_pcm.hex')
(p/'build/parent_receipt.json').write_text(json.dumps({'status':'PASS','parent':str(parent),'entries':175,'manifestSha256':sha(parent/'manifest.json'),'C11301IsVisualPartialFeedbackNotFullBaseline':True,'successfulBaseline':'C11206'},indent=2),encoding='utf-8')
print('C11302_PARENT175_SHA_PASS_ISOLATED_SOURCE_READY')
