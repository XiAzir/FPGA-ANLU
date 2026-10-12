from pathlib import Path
import datetime, hashlib, json, re, shutil, zipfile

root = Path('E:/VSCODE-project/FPGA-ANLU')
project = root / 'development/player_pcm_waveform'
out = project / 'build/manual'
delivery = project / 'build/delivery'
docs = Path('E:/QQ CACHE/Download/安路资料/开发记录')
now = datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')

def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest().upper()

def load(path):
    return json.loads(Path(path).read_text(encoding='utf-8-sig'))

def save(path, value):
    Path(path).write_text(json.dumps(value, ensure_ascii=False, indent=2), encoding='utf-8')

bit = out / 'AC201_player_pcm_waveform.bit'
rollback = root / 'download/image_adjust.bit'
checkpoint = project / 'checkpoints/pcm_waveform_20261012_candidate'
zipout = root / 'deliverables/pcm_waveform_20261012.zip'
assert not checkpoint.exists() and not zipout.exists()
assert not (root / 'download/pcm_waveform.bit').exists()
assert bit.stat().st_size == 629624
bh = sha(bit)
rh = sha(rollback)
assert rh == '5482E8E2D2AE912E47D9EA21F93892559F39AF77C907D025EBDA46AE9994C2FA'
parent = root / 'development/player_image_adjust/checkpoints/image_adjust_20261012_verified'
parent_manifest = load(parent / 'manifest.json')
assert len(parent_manifest) == 133
assert sha(parent / 'manifest.json') == '52E1D0B64D95D71BDF6C2568E74A0B25CB9BC6C245E21F208C650421DC595DA4'
for e in parent_manifest:
    assert sha(parent / e['path']) == e['sha256']
assert sha(root / 'deliverables/image_adjust_20261012.zip') == 'B140FA40D43EB12B3264AF4624C0F1594149480B13C45EB86F6C4120055D237B'
audit = load(project / 'build/model/parent_source_audit.json')
for relative in audit['unchangedInheritedSources']:
    assert sha(project / 'src' / relative) == sha(parent / 'src' / relative)
stages = {}
for stage in ['synthesis', 'physical', 'bitstream']:
    pointer = load(out / 'stage_evidence' / ('latest_' + stage + '.json'))
    e = load(out / 'stage_evidence' / pointer['record'])
    assert e['status'] == pointer['status'] == 'success' and e['runId'] == pointer['runId']
    stages[stage] = e
syn, physical, bs = (stages[s] for s in ['synthesis', 'physical', 'bitstream'])
assert bs['bitHash'].upper() == bh and sha(out / 'AC201_tf_hdmi_gate.db') == syn['gateDbHash'].upper()
for e in [physical, bs]:
    assert e['synthesisRunId'] == syn['runId'] and e['gateDbHash'] == syn['gateDbHash']
    assert e['scopeHash'] == syn['scopeHash'] and e['scriptHash'] == syn['scriptHash']
for name, expected in physical['artifacts'].items():
    assert sha(out / name) == expected.upper()
for entry in bs['scripts']:
    assert sha(project / 'scripts' / entry['path']) == entry['sha256'].upper()
for entry in load(out / 'build_source_scope.json'):
    assert sha(project / 'src' / entry['path']) == entry['sha256'].upper()
timing = [float(v) for v in re.search(r'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns\.', (out / 'AC201_tf_hdmi_phy.ts').read_text()).groups()]
assert min(timing) >= 0
coverage = float(re.search(r'STA coverage\s*:\s*([\d.]+)%', (out / 'AC201_tf_hdmi_pr.timing').read_text()).group(1))
area = (out / 'AC201_tf_hdmi_phy.area').read_text()
resources = {key: int(re.search(r'^\s*#' + field + r'\s+(\d+)', area, re.M).group(1)) for key, field in [('LUT', 'lut'), ('reg', 'reg'), ('LE', 'le'), ('BRAM9K', 'bram9k'), ('DSP', 'dsp'), ('GCLK', 'gclk')]}
model_logs = ['player_pcm_waveform_model.log', 'integration.log']
for name in model_logs:
    text = (project / 'build/model' / name).read_text(encoding='utf-8-sig')
    assert 'PASS ' in text and 'FAIL' not in text
gate = (out / 'AC201_tf_hdmi_gate.v').read_text(encoding='utf-8-sig')
wave_blocks, pcm_blocks = [], []
for match in re.finditer(r'EG_PHY_BRAM #\(', gate):
    end = gate.find(');', match.start()) + 2
    block = gate[match.start():end]
    if '\\u_pcm_waveform/ramread0_syn_' in block:
        wave_blocks.append(block)
    if '\\u_wav_player/ramread1_syn_' in block:
        pcm_blocks.append(block)
assert len(wave_blocks) == 1 and len(pcm_blocks) == 4
assert 'PDPW8K' in wave_blocks[0]
mapping = project / 'build/model/bram_mapping_excerpt.txt'
mapping.write_text('Gate SHA256 ' + sha(out / 'AC201_tf_hdmi_gate.v') + '\nLogical wave 256x14 reduces to 256x12: both quantized codes are 0..56; their bit 6 is constant zero. One PDPW8K physical BRAM9K. No reset/init array; front_valid masks the unread bank. PCM playback FIFO still four DP8K instances.\n\n' + '\n\n'.join(wave_blocks + pcm_blocks), encoding='utf-8')
review = project / 'build/model/integration_review.md'
review.write_text('''# T23 集成审查与模型边界

独立 gpt-6-luna 只读审查未发现必改 RTL：采样仅 audio_valid 事件，同 HDMI 核的 audio_left_data；无反压。tone/VS/stale 优先级与双 bank 交换保持整窗、整帧可见。同步预测地址与像素位置对齐。继承 80 个源码 SHA 不变，top 只新增叠加连接及 BUILD_ID，状态模块只改 BUILD_ID。

根代理独立重跑 unit：303 检查，1024 样本窗；包括极值、bin 最后一个样本、间隙、边界像素、半窗换源、非 VS 保留 front、换源与 VS 同沿、超时与 VS 同沿、超时边界有效事件、复位写门控。

整帧集成模型：真实本地音乐 1024 样本按 520/521 周期输入，独立整数参考 128 个 bin；两帧 768000 周期、58368 波形像素、968 标题白像素比较通过；区域外亮度/对比度、原 OSD、RUN、滚动和 blanking 保留。选择非重叠 1024 点块中能量最高者，起点 2177024（45.354667 秒），95/128 bin 有宽度。源码、选择方式和素材 SHA 见 music_reference.json；这是本地素材，不是远控电脑 TF 的新读取。

审查完成时 TD 证据尚未提供给子代理；随后根代理确认实体 wave 为 1 个 PDPW8K，音频 FIFO 仍 4 块 DP8K，正式三阶段通过且原约束 SWNS +0.660 / HWNS +0.003ns / TNS0 / coverage99.97%。BRAM 推断前 BE 未驱动警告与忽略 init 警告保留；最终物理宏无 BE 端口，未初始化内容由 front_valid 遮罩。未执行 fix_hold、未改原约束。独立审查与局部模型均不包含加密 HDMI 核/板级 PHY、完整 FAT 播放或长期稳定验证。尚未上板。
''', encoding='utf-8')
info = {
    'version': 'C11202', 'kind': 'T23_REAL_PCM_WAVEFORM_CANDIDATE', 'boardStatus': 'PENDING_BOARD_VALIDATION',
    'createdBeijing': now, 'sourceProject': str(project), 'parentVersion': 'C11201', 'parentVerifiedFiles': 133,
    'canonicalBit': str(bit), 'deliveryBitName': 'pcm_waveform.bit', 'bitBytes': bit.stat().st_size, 'bitSha256': bh,
    'rollbackBitName': rollback.name, 'rollbackSha256': rh, 'scopeHash': bs['scopeHash'], 'scriptHash': bs['scriptHash'],
    'stageRunIds': {s: e['runId'] for s, e in stages.items()},
    'timing': dict(zip(['SWNSns', 'STNSns', 'HWNSns', 'HTNSns'], timing)), 'timingCoveragePercent': coverage,
    'resource': resources, 'holdFixPerformed': False, 'models': {name: sha(project / 'build/model' / name) for name in model_logs},
    'inheritedSourceAudit': sha(project / 'build/model/parent_source_audit.json'), 'integrationReview': sha(review),
    'waveformBram': '1 EG_PHY_BRAM PDPW8K: logical 256x14 -> constant-bit reduced 256x12; two 128-bin banks',
    'sampleFifoBram': '4 EG_PHY_BRAM DP8K 2048x4; inherited unchanged',
    'format': 'Existing 640x480 BMP and 48kHz mono PCM16 TEST.WAV; no TF change',
    'observerInput': 'Same audio_valid/audio_left_data as HDMI core, PCM16 = signed [23:8], no backpressure',
    'window': {'bins': 128, 'samplesPerBin': 8, 'samples': 1024, 'nominalMsAt48kHz': 21.3333333333, 'displayBinWidthPixels': 4},
    'verticalFormula': 'code=clip(floor(PCM16/256)+28,0,56), visual X4 relative to 1024 PCM counts/pixel; no audio gain change',
    'panel': {'x': [16, 623], 'y': [320, 423], 'graphX': [64, 575], 'graphY': [356, 412], 'centerY': 384},
    'commit': 'Complete windows at VS rise; clear stale/source-change front at VS; no DE/RGB pipeline delay',
    'observerLimit': 'Waiting-ready observations discarded; no effect on playback samples. Min/max visualization, not a trigger-stabilized scope or spectrum.',
    'noSamplesTimeoutMs': 100, 'checkpoint': str(checkpoint), 'hardwareActions': 'No local JTAG, TF writes or Flash programming',
    'evidenceLimit': 'Local model/review/TD STA do not prove board audio/video/PHY or long-term operation; original IO/CDC/IP warning boundaries preserved.'
}
save(out / 'AC201_player_pcm_waveform.info.json', info)
readme = (project / 'README.md').read_text(encoding='utf-8')
readme = readme.replace('状态：模块/模型开发中；本地构建/时序/实板待验证。', '状态：unit 303检查、两帧真实音乐集成模型、独立代码审查及 TD 综合/布局布线/位流通过；实板待验证。原约束 SWNS +0.660ns / HWNS +0.003ns / TNS0 / coverage99.97%；13097 LUT / 8221 reg / 14688 LE / 24 BRAM9K / 0 DSP / 2 GCLK，未执行fix_hold。')
readme += '\n\n位流 SHA256：' + bh + '\n数码管 D 页应为 DFC11202。模型与边界见 build/model/integration_review.md；交付及操作见 build/delivery/README.md。\n'
(project / 'README.md').write_text(readme, encoding='utf-8')
for source, target in [(bit, root / 'download/pcm_waveform.bit'), (out / 'AC201_player_pcm_waveform.info.json', root / 'download/pcm_waveform.info.json')]:
    assert not target.exists()
    shutil.copy2(source, target)
    assert sha(source) == sha(target)
delivery_readme = '''# C11202 真实 PCM 波形实板验收

本地模型、代码审查及 TD 综合/布局布线/原约束 setup-hold/位流通过，尚未上板。
已有 TF 四张图片和天之弱 TEST.WAV 保持，不需改卡。仅 PROGRAM_SRAM，不写 Flash。

1. ZIP 解压到英文路径，BitWriter Add pcm_waveform.bit，PROGRAM_SRAM / 5MHz，Run 后确认 Downloading succeeded。
2. 默认音乐与图片正常，底部新黑色区域应有 PCM WAV X4 标题和青色波形，灰色中心线。音乐开头或弱段波形接近平线；有声音的段落应随实际音乐变化。
3. 保持 PLAY 模式，长按 KEY1 约 2 秒后松开，应切到清晰内部音阶，标题变 PCM TONE X4，波形随音阶变化。再长按切回 WAV。画布峰顶饱和是 X4 图形增益的预期行为，不放大播放音量。波形未加触发锁定，不要求静止图形。
4. 短按 KEY0 切图、短按 KEY1 轮播，原 RUN 计时、滚动字幕、状态栏和音乐保持正常。波形所在区域覆盖底图是设计效果。
5. 原亮度/对比度继续回归：长 KEY0 切 BRI/CON，短 KEY0 减、KEY1 加；底图变化而波形/文字保持原色，双键长按恢复 PLAY B+00 C1.00。

数码管 D 页版本 DFC11202。音源切换仅 PLAY 模式长 KEY1 有效，编辑模式下长 KEY1 不切音源。
失败时保持同一 TF/供电/HDMI/音量，回载同包 image_adjust.bit（C11201 用户已反馈全部功能和音画正常），记录是否恢复。成功逐项文字反馈即可，不需重复录全部数码管；异常再保存照片/短视频。
'''
(delivery / 'README.md').write_text(delivery_readme, encoding='utf-8')
for source, target in [(bit, delivery / 'pcm_waveform.bit'), (rollback, delivery / rollback.name), (out / 'AC201_player_pcm_waveform.info.json', delivery / 'pcm_waveform.info.json')]:
    shutil.copy2(source, target)
    assert sha(source) == sha(target)
shutil.copy2(project / 'build/model/music_reference.json', delivery / 'music_reference.json')
delivery_names = ['README.md', 'pcm_waveform.bit', 'image_adjust.bit', 'pcm_waveform.info.json', 'music_reference.json']
(delivery / 'checksums.sha256').write_text(''.join(sha(delivery / n) + '  ' + n + '\n' for n in sorted(delivery_names)), encoding='ascii')
delivery_names.append('checksums.sha256')
checkpoint.mkdir(parents=True)
files = [project / 'README.md']
files += [f for f in (project / 'src/user_source').rglob('*') if f.is_file()]
files += [project / 'src/td_project/AC201_tf_hdmi.al'] + [f for f in (project / 'src/td_project/al_ip').rglob('*') if f.is_file()]
files += [f for f in (project / 'scripts').rglob('*') if f.is_file()]
files += [f for f in (project / 'build/model').rglob('*') if f.is_file() and f.suffix != '.vvp']
files += [f for f in out.rglob('*') if f.is_file() and f.suffix in ['.log', '.ts', '.timing', '.area', '.json', '.bit']]
files += [delivery / 'README.md', Path(__file__)]
manifest = []
for source in sorted(set(files)):
    relative = source.relative_to(project)
    target = checkpoint / relative
    target.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(source, target)
    assert sha(source) == sha(target)
    manifest.append({'path': relative.as_posix(), 'bytes': target.stat().st_size, 'sha256': sha(target)})
save(checkpoint / 'manifest.json', manifest)
for entry in manifest:
    assert sha(checkpoint / entry['path']) == entry['sha256']
with zipfile.ZipFile(zipout, 'w', zipfile.ZIP_DEFLATED) as z:
    for name in sorted(delivery_names):
        z.write(delivery / name, name)
with zipfile.ZipFile(zipout) as z:
    assert z.testzip() is None and set(z.namelist()) == set(delivery_names)
    for name in z.namelist():
        assert hashlib.sha256(z.read(name)).hexdigest().upper() == sha(delivery / name)
receipt = {'createdBeijing': now, 'bitSha256': bh, 'checkpointFiles': len(manifest), 'manifestSha256': sha(checkpoint / 'manifest.json'), 'zip': str(zipout), 'zipBytes': zipout.stat().st_size, 'zipSha256': sha(zipout), 'boardStatus': 'PENDING_BOARD_VALIDATION', 'parentFrozenArtifactsReverified': True}
save(project / 'build/delivery_verified.json', receipt)
topic = docs / '专题记录/音频可视化/真实PCM波形首版_20261012'
topic.mkdir(parents=True, exist_ok=True)
save(topic / 'delivery_receipt.json', receipt)
save(topic / 'build_info.json', info)
(topic / 'README.md').write_text('''# T23 真实 PCM 波形首版 C11202

''' + now + '''（北京时间），本地实现/模型/代码审查/正式构建/封存/交付完成，实板待验证。

用户“好。开始”授权开发。继承 C11201 verified 133 文件并逐项 SHA 校验，新增 player_pcm_waveform，top 插入零延迟叠加链、状态 BUILD_ID 改 C11202；80 个继承源码不变，音频 FIFO/FAT/SDRAM/PHY/PLL/原 SDC/控制无修改。成功基线仍 download/image_adjust.bit。未本机 JTAG/TF/Flash 操作。

只观察送往 HDMI 的 audio_valid/audio_left_data，PCM16 取 signed [23:8]，128 bin×8 样本极值窗口，名义 48kHz 下 21.333ms；双 bank 完整窗 VS 提交，音源变化或 100ms 无样本请求下个 VS 清旧图。等待 VS 时只丢观察事件，播放无反压。图形 X4、超出 ±28 像素截顶；底部黑面板青色波形，PCM WAV/TONE 标题。保留原状态、调节/RUN/滚动/音画，TF 不改。

单元模型根代理重跑 303 检查/1024事件，含边界与换源/超时/VS 同沿。独立 gpt-6-luna 集成只读复核无必改。两帧 768000周期、58368波形像素与真实音乐独立参考一致，原区域外叠加/调节/blanking保持；模型范围及素材哈希/选窗方法见工程 build/model/integration_review.md 和 music_reference.json。本地模型不包含加密核/完整实际卡读取/板级 PHY。

TD6.2.178840 正式 synthesis/physical/bitstream wrapper 绑定源/脚本/DB/报告/bit 哈希，通过后复核当前绑定。SWNS +0.660ns / HWNS +0.003ns、STNS/HTNS0、coverage99.97%；13097LUT/8221reg/14688LE/24BRAM9K/0DSP/2GCLK。未执行 fix_hold/改约束。波形实体一块 PDPW8K，256×14 常量位优化为256×12；播放 FIFO 仍四块 DP8K。映射摘录留档，保留原警告/未约束边界，不用 STA 代替板测。

位流 download/pcm_waveform.bit（629624字节），SHA ''' + bh + '''。ZIP deliverables/pcm_waveform_20261012.zip 内含候选、成功回退 image_adjust.bit、校验/操作说明；逐项 ZIP 哈希通过。冻结 ''' + str(len(manifest)) + ''' 文件 checkpoint，manifest ''' + receipt['manifestSha256'] + '''，ZIP SHA ''' + receipt['zipSha256'] + '''；详见 delivery_receipt.json。C11201 verified manifest 与原 ZIP 重新复核保持不变。

下一步用户远控实验室电脑，用 PROGRAM_SRAM / 5MHz 下载，检查音乐 WAV 波形、PLAY 长 KEY1 的清晰音阶/TONE 波形、切图/自动/原字幕/B/C/恢复以及音画。全部通过前保持 PENDING，不称 T23 实板完成；异常同条件回载包内 image_adjust.bit。无需重复全部数码管视频。长期/冷启动/碎片文件实板验证仍待后续，未承接父版本短稳结果。
''', encoding='utf-8')
state = docs / '当前状态.md'
text = state.read_text(encoding='utf-8')
text = re.sub(r'^更新：.*$', '更新：' + now + '（北京时间；XiAzir；T23 C11202 本地候选交付、实板待验证；成功基线 C11201）。', text, count=1, flags=re.M)
marker = '## 当前阶段'
text = text.replace(marker, marker + '\n\n**' + now + ' T23真实PCM波形C11202本地303检查/真实音乐两帧集成/独立审查/正式三阶段/原约束时序/位流/封存/ZIP核验完成；实板待验证。SWNS+0.660/HWNS+0.003ns/TNS0/coverage99.97%，24BRAM9K（新增波形1块），未fix_hold/改约束。download/pcm_waveform.bit SHA ' + bh + '；deliverables/pcm_waveform_20261012.zip含C11201直接回退。成功基线仍image_adjust；用户下一步板测WAV/TONE波形与原音画/按键/字幕/B/C。TF不改、未本机JTAG/TF/Flash。见[首版开发与交付](专题记录/音频可视化/真实PCM波形首版_20261012/README.md)。**', 1)
text = text.replace('下一步T23真实PCM波形尚未实现。', '该条为T22完成时记录；T23最新候选状态见上方。')
state.write_text(text, encoding='utf-8')
log = docs / '工作日志/2026-10-12.md'
text = log.read_text(encoding='utf-8')
text += '\n### ' + now + '｜T23 C11202真实PCM波形交付｜本地完成，实板待验证\n\n- 新被动观察波形/双bank/VS切换/音源及stale清理实现；unit303检查与真实音乐两帧768000周期/58368波形像素通过。独立luna审查无必改；审查未覆盖当时尚未完成的TD，随后根代理另核实体BRAM。模型边界、选窗及SHA见专题/工程build/model。\n- 正式三阶段输入/脚本/数据库/报告/bit绑定与当前复核PASS；原约束SWNS+0.660/HWNS+0.003ns/TNS0/coverage99.97%，13097LUT/8221reg/14688LE/24BRAM9K/0DSP/2GCLK；一波形PDPW8K、四PCM DP8K，未fix_hold/改约束。\n- bit SHA ' + bh + '；冻结' + str(len(manifest)) + '文件manifest ' + receipt['manifestSha256'] + '；ZIP ' + str(zipout) + ' / ' + str(receipt['zipBytes']) + '字节 / SHA ' + receipt['zipSha256'] + '，逐条哈希与ZIP核验通过。C11201 verified/原ZIP重验保持。\n- [T23说明和板测步骤](../专题记录/音频可视化/真实PCM波形首版_20261012/README.md)。未上板，成功基线仍C11201，长稳/冷启动/换文件未验证；未JTAG/TF/Flash。下一步用户远控PROGRAM_SRAM下载，检验WAV/TONE可视化及原全部功能，异常同条件回退image_adjust。\n'
log.write_text(text, encoding='utf-8')
print(json.dumps(receipt, ensure_ascii=True, indent=2))
