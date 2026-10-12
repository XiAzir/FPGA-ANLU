from pathlib import Path
import sys

for _anlu_root in Path(__file__).resolve().parents:
    if (_anlu_root / 'scripts' / 'anlu_paths.py').is_file():
        sys.path.insert(0, str(_anlu_root / 'scripts'))
        break
from anlu_paths import DOCS_ROOT, REPOSITORY_ROOT, recorded_path

import datetime, hashlib, json, re, shutil, zipfile

root = REPOSITORY_ROOT
project = root / 'development/player_pcm_waveform_freeze'
out = project / 'build/manual'
model = project / 'build/model'
parent = root / 'development/player_pcm_waveform/checkpoints/pcm_waveform_20261012_candidate'
docs = DOCS_ROOT / '开发记录'
topic = docs / '专题记录/音频可视化/真实PCM波形首版_20261012'
now = datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')

def sha(path): return hashlib.sha256(Path(path).read_bytes()).hexdigest().upper()
def load(path): return json.loads(Path(path).read_text(encoding='utf-8-sig'))
def save(path, value): Path(path).write_text(json.dumps(value, ensure_ascii=False, indent=2), encoding='utf-8')

checkpoint = project / 'checkpoints/waveform_freeze_20261012_candidate'
zipout = root / 'deliverables/waveform_freeze_20261012.zip'
assert not checkpoint.exists() and not zipout.exists() and not (root / 'download/waveform_freeze.bit').exists()
bit = out / 'AC201_player_pcm_waveform_freeze.bit'
assert bit.stat().st_size == 629624
bh = sha(bit)
rollback = root / 'download/image_adjust.bit'
dynamic = root / 'download/pcm_waveform.bit'
rh, dh = sha(rollback), sha(dynamic)
assert rh == '5482E8E2D2AE912E47D9EA21F93892559F39AF77C907D025EBDA46AE9994C2FA'
assert dh == 'D753D6893AA6C1EB98323C189FC7889A7FBCB96D3C12ECA5966AF515AE397D49'
assert sha(parent / 'manifest.json') == 'C5B58E2F7FE26E8E88638F62E0FCD888ECE7BBB73C667DECFFE567BE07519E72'
for e in load(parent / 'manifest.json'): assert sha(parent / e['path']) == e['sha256']
assert sha(root / 'deliverables/pcm_waveform_20261012.zip') == 'EA0C3899B22DA7DABF829F564C9B02BDF936849267223F0C5553907AA496DA73'
audit = load(model / 'parent_source_audit.json')
for relative in audit['unchangedInheritedSources']:
    assert sha(project / 'src' / relative) == sha(parent / 'src' / relative)
stages = {}
for s in ['synthesis', 'physical', 'bitstream']:
    pointer = load(out / 'stage_evidence' / ('latest_' + s + '.json'))
    e = load(out / 'stage_evidence' / pointer['record'])
    assert e['status'] == pointer['status'] == 'success' and e['runId'] == pointer['runId']
    stages[s] = e
hold = out / 'stage_evidence/latest_hold.json'
if hold.exists():
    pointer = load(hold)
    stages['hold'] = load(out / 'stage_evidence' / pointer['record'])
    assert stages['hold']['status'] == 'success'
syn, bs = stages['synthesis'], stages['bitstream']
route = stages[bs['routeStage']]
assert bs['bitHash'].upper() == bh and sha(out / 'AC201_tf_hdmi_gate.db') == syn['gateDbHash'].upper()
for s, e in stages.items():
    assert e['scopeHash'] == syn['scopeHash'] and e['scriptHash'] == syn['scriptHash']
    if s != 'synthesis': assert e['synthesisRunId'] == syn['runId'] and e['gateDbHash'] == syn['gateDbHash']
for name, expected in route['artifacts'].items(): assert sha(out / name) == expected.upper()
for e in bs['scripts']: assert sha(project / 'scripts' / e['path']) == e['sha256'].upper()
for e in load(out / 'build_source_scope.json'): assert sha(project / 'src' / e['path']) == e['sha256'].upper()
timing = [float(v) for v in re.search(r'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns\.', (out / 'AC201_tf_hdmi_phy.ts').read_text()).groups()]
assert min(timing) >= 0
coverage = float(re.search(r'STA coverage\s*:\s*([\d.]+)%', (out / 'AC201_tf_hdmi_pr.timing').read_text()).group(1))
area = (out / 'AC201_tf_hdmi_phy.area').read_text()
resources = {k: int(re.search(r'^\s*#' + f + r'\s+(\d+)', area, re.M).group(1)) for k, f in [('LUT','lut'),('reg','reg'),('LE','le'),('BRAM9K','bram9k'),('DSP','dsp'),('GCLK','gclk')]}
logs = ['player_pcm_waveform_model.log', 'integration.log', 'freeze_model_root.log', 'frozen_music_integration.log']
for name in logs:
    text = (model / name).read_text(encoding='utf-8-sig')
    assert 'PASS' in text and 'FAIL' not in text and 'FATAL' not in text
assert (model / 'freeze_review.md').exists()
gate = (out / 'AC201_tf_hdmi_gate.v').read_text(encoding='utf-8-sig')
wave_blocks, pcm_blocks = [], []
for match in re.finditer(r'EG_PHY_BRAM #\(', gate):
    block = gate[match.start():gate.find(');', match.start()) + 2]
    if '\\u_pcm_waveform/ramread0_syn_' in block: wave_blocks.append(block)
    if '\\u_wav_player/ramread1_syn_' in block: pcm_blocks.append(block)
assert len(wave_blocks) == 1 and len(pcm_blocks) == 4 and 'PDPW8K' in wave_blocks[0]
(model / 'bram_mapping_excerpt.txt').write_text('Gate SHA256 ' + sha(out / 'AC201_tf_hdmi_gate.v') + '\nWave 1 PDPW8K: logical256x14, constant bits removed256x12. Audio FIFO remains4 DP8K.\n\n' + '\n\n'.join(wave_blocks + pcm_blocks), encoding='utf-8')
info = {'version': 'C11203', 'kind': 'FREEZE_FRONT_DIAGNOSTIC', 'boardStatus': 'PENDING_DIAGNOSTIC_BOARD_VALIDATION', 'createdBeijing': now,
    'sourceProject': str(project), 'parentVersion': 'C11202', 'successfulBaseline': 'C11201 image_adjust.bit', 'canonicalBit': str(bit),
    'deliveryBitName': 'waveform_freeze.bit', 'bitBytes': bit.stat().st_size, 'bitSha256': bh, 'rollbackBitName': rollback.name, 'rollbackSha256': rh,
    'dynamicComparisonBit': dynamic.name, 'dynamicComparisonSha256': dh, 'scopeHash': bs['scopeHash'], 'scriptHash': bs['scriptHash'],
    'stageRunIds': {s: e['runId'] for s, e in stages.items()}, 'timing': dict(zip(['SWNSns','STNSns','HWNSns','HTNSns'], timing)),
    'timingCoveragePercent': coverage, 'resource': resources, 'holdFixPerformed': bs['routeStage'] == 'hold',
    'models': {n: sha(model / n) for n in logs}, 'inheritedSourceAudit': sha(model / 'parent_source_audit.json'), 'freezeReview': sha(model / 'freeze_review.md'),
    'freezeAfterEvents': 144000, 'nominalSecondsAt48kHz': 3, 'freezeCommit': 'Complete capture bank at VS after registered request; coincident threshold/VS may wait another complete window',
    'freezeBehavior': 'Both RAM banks and front display held; audio continues; stale ignored after freeze; source change/reset rearm',
    'title': 'PCM WAV/TONE X4 while live; HOLD WAV/TONE X4 after front freeze', 'observerInput': 'Unchanged passive audio_valid/audio_left_data used by HDMI core',
    'waveBram': '1 physical PDPW8K (256x12 after constant-bit reduction)', 'audioFifoBram': '4 physical DP8K, inherited unchanged',
    'format': 'Existing 640x480 BMP and48kHz mono PCM16 TEST.WAV; no TF change', 'checkpoint': str(checkpoint),
    'hardwareActions': 'No local JTAG, TF writes or Flash programming', 'evidenceLimit': 'Diagnostic, not a fix. Dense default-threshold counting and local raster models are not board48kHz/actual BRAM/HDMI PHY measurement. Static clean result does not uniquely prove monitor cause; implementation placement also changes.'}
save(out / 'AC201_player_pcm_waveform_freeze.info.json', info)
readme = (project / 'README.md').read_text(encoding='utf-8').replace('模型/构建状态待补。', '继承unit303、真实音乐两帧集成和专用冻结模型/独立只读审查通过；正式TD三阶段和原约束最终时序通过，尚未上板。')
readme += '\n\n最终时序/资源：' + json.dumps(info['timing'], ensure_ascii=False) + '，coverage' + str(coverage) + '%，' + json.dumps(resources) + '。bit SHA256 ' + bh + '，数码管D页DFC11203。范围见build/model/freeze_review.md和交付README。\n'
(project / 'README.md').write_text(readme, encoding='utf-8')
delivery = project / 'build/delivery'
delivery.mkdir(parents=True)
delivery_readme = '''# C11203 冻结波形对照

独立诊断候选，非修复版；本地模型/正式TD构建及原约束时序通过，尚未上板。成功回退仍C11201。
TF素材不改。英文路径解压，BitWriter Add waveform_freeze.bit，PROGRAM_SRAM / 5MHz，确认 Downloading succeeded。

1. 默认音乐继续播放，波形先动态显示。同一音源输入144000个有效样本后（连续48kHz名义约3秒），完整窗在帧边界冻结，标题显示 HOLD WAV X4。下载完成时可能已经HOLD，不需重新下载。
2. 看到 HOLD 后等5秒，用肉眼观察波形是否完全不动，以及是否仍有两条分离的青色完整曲线。灰色中心线不计第二条波形；粗竖线/同一组min-max填满的区间与分离双线要区分。音乐应继续。
3. PLAY模式长按KEY1约2秒后松开：音阶应继续清晰播放，先 PCM TONE X4 动态采集，再约3秒显示 HOLD TONE X4 并固定方波；等5秒后同样观察。再长按切回音乐会重新采集/冻结，不是播放暂停。
4. 简单确认KEY0切图/KEY1轮播及声音正常。此版仅冻结波形观察支路；原操作映射保持。

反馈：HOLD WAV下单线或双线？HOLD TONE下单线或双线？冻结后是否还动？音乐/音阶是否继续且清晰？双线保留时拍一张带HOLD标题的照片即可。
静态干净只支持动态因素，不能唯一证明显示器响应；静态仍异常则继续查实际读取/绘制/输出。该版重新布局，与旧动态位流还有物理实现差异，不据一次对照认定根因。

pcm_waveform.bit为C11202原动态比较版（已报告肉眼重影），不是成功回退。异常音画或按键同条件回载image_adjust.bit，这是C11201已反馈全功能音画正常的直接回退。不写Flash。
'''
(delivery / 'README.md').write_text(delivery_readme, encoding='utf-8')
for source, target in [(bit, root / 'download/waveform_freeze.bit'), (out / 'AC201_player_pcm_waveform_freeze.info.json', root / 'download/waveform_freeze.info.json'), (bit, delivery / 'waveform_freeze.bit'), (out / 'AC201_player_pcm_waveform_freeze.info.json', delivery / 'waveform_freeze.info.json'), (rollback, delivery / rollback.name), (dynamic, delivery / dynamic.name)]:
    assert not target.exists()
    shutil.copy2(source, target)
    assert sha(source) == sha(target)
delivery_names = ['README.md', 'waveform_freeze.bit', 'waveform_freeze.info.json', 'image_adjust.bit', 'pcm_waveform.bit']
(delivery / 'checksums.sha256').write_text(''.join(sha(delivery / n) + '  ' + n + '\n' for n in sorted(delivery_names)), encoding='ascii')
delivery_names.append('checksums.sha256')
checkpoint.mkdir(parents=True)
files = [project / 'README.md', project / 'build/init_project.py', project / 'build/prepare_evidence.py', Path(__file__), delivery / 'README.md']
files += [f for f in (project / 'src/user_source').rglob('*') if f.is_file()]
files += [project / 'src/td_project/AC201_tf_hdmi.al'] + [f for f in (project / 'src/td_project/al_ip').rglob('*') if f.is_file()]
files += [f for f in (project / 'scripts').rglob('*') if f.is_file()]
files += [f for f in model.rglob('*') if f.is_file() and f.suffix != '.vvp']
files += [f for f in out.rglob('*') if f.is_file() and f.suffix in ['.log','.ts','.timing','.area','.json','.bit']]
prehold = project / 'build/prehold'
if prehold.exists(): files += [f for f in prehold.rglob('*') if f.is_file() and f.suffix != '.db']
manifest = []
for source in sorted(set(files)):
    rel = source.relative_to(project)
    target = checkpoint / rel
    target.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(source, target)
    assert sha(source) == sha(target)
    manifest.append({'path': rel.as_posix(), 'bytes': target.stat().st_size, 'sha256': sha(target)})
save(checkpoint / 'manifest.json', manifest)
for e in manifest: assert sha(checkpoint / e['path']) == e['sha256']
with zipfile.ZipFile(zipout, 'w', zipfile.ZIP_DEFLATED) as z:
    for name in sorted(delivery_names): z.write(delivery / name, name)
with zipfile.ZipFile(zipout) as z:
    assert z.testzip() is None and set(z.namelist()) == set(delivery_names)
    for name in z.namelist(): assert hashlib.sha256(z.read(name)).hexdigest().upper() == sha(delivery / name)
receipt = {'createdBeijing': now, 'bitSha256': bh, 'checkpointFiles': len(manifest), 'manifestSha256': sha(checkpoint / 'manifest.json'), 'zip': str(zipout), 'zipBytes': zipout.stat().st_size, 'zipSha256': sha(zipout), 'boardStatus': info['boardStatus'], 'parentCandidateAndZipUnchanged': True}
save(project / 'build/delivery_verified.json', receipt)
save(topic / 'freeze_diagnostic_build_info.json', info)
save(topic / 'freeze_diagnostic_receipt.json', receipt)
(topic / 'README.md').write_text((topic / 'README.md').read_text(encoding='utf-8') + '\n\n## ' + now + '｜C11203冻结front诊断交付，实板待验证\n\n独立player_pcm_waveform_freeze，继承C11202冻结133文件逐项SHA核验；80源不变，仅wave冻结/HOLD字形及top/状态BUILD_ID改变。144000同音源有效事件后VS完整窗冻结，冻结两bank不可写且stale不清图，音乐照播、换源/复位重装；同沿threshold/VS使用旧request可延后一个完整窗。WAV头已避开，本地3秒窗口非零（RMS490），实际freeze窗起点随VS变化。\n\nunit303/两帧真实音乐集成及专用冻结模型根代理重跑/独立luna只读审查通过，生产144000计数采用密集事件不计真实48k时序实测。专用范围/像素连通/字形及边沿条件见新工程build/model/freeze_review.md。TD三阶段源/脚本/DB/报告/bit绑定通过，原约束' + json.dumps(info['timing']) + '，coverage' + str(coverage) + '%，资源' + json.dumps(resources) + '，holdFix=' + str(info['holdFixPerformed']) + '；一wave PDPW8K和四PCM DP8K。\n\n候选download/waveform_freeze.bit SHA ' + bh + '；ZIP ' + str(zipout) + ' SHA ' + receipt['zipSha256'] + '，含原动态C11202和成功回退C11201；' + str(len(manifest)) + '文件checkpoint，manifest ' + receipt['manifestSha256'] + '，逐条/ZIP哈希通过。旧候选/ZIP未改。未上板/未本机JTAG/TF/Flash，不称修复或新成功基线。\n\n下一步用户PROGRAM_SRAM /5MHz下载、观察HOLD WAV和HOLD TONE各稳定5秒后的单/双线、是否仍移动及两音源清晰连续。灰线不算第二轨迹。静态干净不唯一证明显示器，物理实现变化也需计入证据；失败音画同条件回载image_adjust。\n', encoding='utf-8')
state = docs / '当前状态.md'
text = state.read_text(encoding='utf-8')
text = re.sub(r'^更新：.*$', '更新：' + now + '（北京时间；XiAzir；C11203冻结波形诊断已交付、实板待验证；成功基线C11201）。', text, count=1, flags=re.M)
text = text.replace('## 当前阶段', '## 当前阶段\n\n**' + now + ' C11203冻结波形诊断本地模型/独立审查/正式TD三阶段/原约束时序/封存/ZIP核验完成，实板待验证，不是修复版。144000事件后VS冻结并HOLD标记，换源重装，音频继续；download/waveform_freeze.bit SHA ' + bh + '。' + json.dumps(info['timing']) + ' coverage' + str(coverage) + '%；ZIP waveform_freeze_20261012含C11202动态和C11201成功回退。用户下一步看HOLD WAV/TONE稳定5秒后的单/双线及音质；根因未确认。TF不改、未本机JTAG/TF/Flash，旧候选/ZIP冻结保持。见[诊断与操作](专题记录/音频可视化/真实PCM波形首版_20261012/README.md)。**', 1)
text = text.replace('优先冻结front对照诊断（尚未开发）', 'C11203冻结front对照已交付、待板测', 1)
state.write_text(text, encoding='utf-8')
log = docs / '工作日志/2026-10-12.md'
log.write_text(log.read_text(encoding='utf-8') + '\n### ' + now + '｜C11203冻结波形诊断交付｜本地完成、实板待验证\n\n- 144000有效事件后完整窗VS冻结/HOLD；换源/复位重装，无音频/按键/卡/PHY源改动。unit303、真实音乐两帧集成和专用freeze模型根代理重跑、luna只读审查通过；计数生产实例用密集事件，非实际48kHz实测，详见freeze_review.md。\n- TD三阶段绑定、原约束' + json.dumps(info['timing']) + '，coverage' + str(coverage) + '%，资源' + json.dumps(resources) + '，holdFix=' + str(info['holdFixPerformed']) + '；一wave/four PCM BRAM，bit629624字节SHA ' + bh + '。\n- ' + str(len(manifest)) + '文件checkpoint manifest ' + receipt['manifestSha256'] + '；ZIP ' + str(zipout) + ' / ' + str(receipt['zipBytes']) + 'bytes / SHA ' + receipt['zipSha256'] + '，逐条与ZIP哈希通过，原C11202候选及ZIP重验不改。\n- 未上板/未证明修复，成功基线C11201；未JTAG/TF/Flash。下一步用户观察HOLD WAV/TONE等待5秒后的单双线/是否不动/两音源是否清晰，失败回载image_adjust。静态结果不能唯一证明板或显示器原因，存在重新布局差异。[专题证据](../专题记录/音频可视化/真实PCM波形首版_20261012/README.md)。\n', encoding='utf-8')
print(json.dumps(receipt, ensure_ascii=True, indent=2))
