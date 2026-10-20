from pathlib import Path
import sys

for _anlu_root in Path(__file__).resolve().parents:
    if (_anlu_root / 'scripts' / 'anlu_paths.py').is_file():
        sys.path.insert(0, str(_anlu_root / 'scripts'))
        break
from anlu_paths import DOCS_ROOT, REPOSITORY_ROOT, recorded_path

import hashlib, json, wave, struct, math

root = REPOSITORY_ROOT
project = root / 'development/player_pcm_waveform_freeze'
parent = root / 'development/player_pcm_waveform/checkpoints/pcm_waveform_20261012_candidate'
def sha(path): return hashlib.sha256(Path(path).read_bytes()).hexdigest().upper()
same, changed = [], []
for f in sorted((parent / 'src/user_source').rglob('*')):
    if f.is_file():
        rel = f.relative_to(parent / 'src')
        (same if sha(f) == sha(project / 'src' / rel) else changed).append(rel.as_posix())
assert set(changed) == {'user_source/hdl_source/top_tf_hdmi_audio.v', 'user_source/hdl_source/player_status_monitor.v', 'user_source/hdl_source/player_pcm_waveform.v'}
audit = {'parentVersion': 'C11202', 'parentFrozenFiles': 133, 'unchangedInheritedSources': same, 'changedSources': changed, 'newSources': [], 'parentManifestSha256': sha(parent / 'manifest.json')}
(project / 'build/model/parent_source_audit.json').write_text(json.dumps(audit, indent=2), encoding='utf-8')
wav = root / 'deliverables/real_music_20261008/card/TEST.WAV'
with wave.open(str(wav), 'rb') as w:
    assert w.getframerate() == 48000 and w.getsampwidth() == 2 and w.getnchannels() == 1
    w.setpos(144000)
    raw = w.readframes(1024)
samples = struct.unpack('<1024h', raw)
reference = {'source': str(wav), 'sourceSha256': sha(wav), 'windowStartSample': 144000, 'windowStartSeconds': 3, 'sampleCount': 1024, 'minPCM': min(samples), 'maxPCM': max(samples), 'rmsPCM': math.sqrt(sum(s*s for s in samples)/len(samples)), 'limitation': 'Local card payload, not new read of remote TF; real frozen capture starts at a preceding/next VS-aligned window, not exactly sample144000.'}
(project / 'build/model/lead_in_reference.json').write_text(json.dumps(reference, indent=2), encoding='utf-8')
(project / 'build/model/normalize_project.tcl').write_text('cd ' + project.as_posix() + '/src/td_project\nif {[catch {\n import_device eagle_s20.db -package EG4S20BG256\n open_project AC201_tf_hdmi.al -single_run\n close_project\n} message]} { puts "PROJECT_NORMALIZATION_ERROR: $message"; exit 1 }\nputs PROJECT_NORMALIZATION_COMPLETE\nexit\n', encoding='utf-8')
(project / 'README.md').write_text('''# C11203 冻结波形诊断候选

从 C11202 波形候选冻结 133 文件逐项 SHA 核验后隔离复制，未复制旧数据库；不是修复版，实板待验证，成功基线仍 C11201 image_adjust。

波形观察到同音源 144000 次 audio_valid 后请求冻结（48kHz 连续事件名义3秒）；在完整窗VS提交时冻结一整窗、标题 HOLD WAV X4 / HOLD TONE X4。冻结期间音频/图片/按键继续运行，观察器不写RAM、不换front、不因无样本清图。PLAY长KEY1换音源会解除冻结，再计数/采完整窗/冻结；不增加产品按键，未改音频/FIFO/卡/PHY/SDC。窗口/量化/图形仍同C11202，仅冻结及HOLD字形和BUILD_ID改变。

诊断目标：冻结后等待5秒，用肉眼和照片观察是否仍有两条分离完整曲线。静态消失只支持动态因素，不唯一证明显示器或FPGA原因；静态保留则继续查实际绘制/读取/输出，不凭一次对照定义根因。模型/构建状态待补。TF不改、只PROGRAM_SRAM，不写Flash。
''', encoding='utf-8')
print(json.dumps({'unchanged': len(same), 'changed': changed, 'localMusicAt3secRMS': reference['rmsPCM']}, indent=2))
