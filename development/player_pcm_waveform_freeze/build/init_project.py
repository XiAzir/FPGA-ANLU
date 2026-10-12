from pathlib import Path
import sys

for _anlu_root in Path(__file__).resolve().parents:
    if (_anlu_root / 'scripts' / 'anlu_paths.py').is_file():
        sys.path.insert(0, str(_anlu_root / 'scripts'))
        break
from anlu_paths import DOCS_ROOT, REPOSITORY_ROOT, recorded_path

import datetime, hashlib, json, shutil

root = REPOSITORY_ROOT
project = root / 'development/player_pcm_waveform_freeze'
parent = root / 'development/player_pcm_waveform/checkpoints/pcm_waveform_20261012_candidate'
assert not (project / 'src').exists()
def sha(path): return hashlib.sha256(Path(path).read_bytes()).hexdigest().upper()
assert sha(parent / 'manifest.json') == 'C5B58E2F7FE26E8E88638F62E0FCD888ECE7BBB73C667DECFFE567BE07519E72'
manifest = json.loads((parent / 'manifest.json').read_text(encoding='utf-8-sig'))
for e in manifest: assert sha(parent / e['path']) == e['sha256']
for directory in ['src', 'scripts']:
    shutil.copytree(parent / directory, project / directory)
for f in (project / 'scripts').rglob('*'):
    if f.is_file(): f.write_text(f.read_text(encoding='utf-8-sig').replace('player_pcm_waveform', 'player_pcm_waveform_freeze'), encoding='utf-8')
al = project / 'src/td_project/AC201_tf_hdmi.al'
al.write_text(al.read_text(encoding='utf-8-sig').replace('/development/player_pcm_waveform/', '/development/player_pcm_waveform_freeze/'), encoding='utf-8')
for name in ['top_tf_hdmi_audio.v', 'player_status_monitor.v']:
    f = project / 'src/user_source/hdl_source' / name
    text = f.read_text(encoding='utf-8-sig')
    assert 'C11202' in text
    f.write_text(text.replace('C11202', 'C11203'), encoding='utf-8')
model = project / 'build/model'
model.mkdir(parents=True)
for name in ['tb_player_pcm_waveform.v', 'run_waveform_model.ps1', 'tb_waveform_integration.v', 'run_integration.ps1', 'music_pcm.hex', 'music_bins.hex', 'music_reference.json']:
    source = parent / 'build/model' / name
    shutil.copy2(source, model / name)
for name in ['run_waveform_model.ps1', 'run_integration.ps1']:
    f = model / name
    f.write_text(f.read_text(encoding='utf-8-sig').replace('/player_pcm_waveform/', '/player_pcm_waveform_freeze/'), encoding='utf-8')
now = datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
docs = DOCS_ROOT / '开发记录'
state = docs / '当前状态.md'
text = state.read_text(encoding='utf-8').replace('## 当前阶段', '## 当前阶段\n\n**' + now + ' 用户“好”授权冻结波形诊断。独立player_pcm_waveform_freeze/C11203从C11202冻结133文件逐项SHA核验后复制源/脚本，未复制数据库。拟同音源约3秒有效样本后VS冻结完整front，音频照播，换音源重新采集；避开WAV开头静音。开发/模型/构建进行中，尚无位流，不作为修复版；成功基线仍C11201。未JTAG/TF/Flash。**', 1)
state.write_text(text, encoding='utf-8')
log = docs / '工作日志/2026-10-12.md'
log.write_text(log.read_text(encoding='utf-8') + '\n### ' + now + '｜C11203冻结波形诊断启动｜进行中\n\n- 用户“好”授权此前提出的冻结front对照。从C11202候选133文件逐项SHA核验后复制到独立player_pcm_waveform_freeze，源/脚本/英文工程路径与BUILD_ID改C11203，无复制旧数据库。\n- 拟同音源144000个audio_valid事件（名义3秒）后，在完整窗VS提交时冻结；音频与按键照旧，切音源重新计数/捕获/冻结。避开WAV头静音窗口，标题HOLD提示。该行为尚在开发，不证明重影已修复。\n- 下一步冻结功能/保持静态/音源切换模型、原波形与真实音乐集成回归、TD原约束时序及候选交付。尚未JTAG/TF/Flash，成功基线C11201。\n', encoding='utf-8')
print('PARENT_133_HASHED_PROJECT_READY')
