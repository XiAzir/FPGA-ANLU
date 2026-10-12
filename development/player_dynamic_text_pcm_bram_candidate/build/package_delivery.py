from pathlib import Path
from datetime import datetime, timezone, timedelta
import hashlib, json, re, shutil, zipfile

root = Path(__file__).resolve().parents[1]
project = root.parents[1]
manual, model = root/'build/manual', root/'build/model'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest().upper()
read_json = lambda p: json.loads(p.read_text(encoding='utf-8-sig'))
def dump(p, value):
    p.write_text(json.dumps(value, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')

stages = {}
for stage in ('synthesis', 'physical', 'hold', 'bitstream'):
    pointer_path = manual/'stage_evidence'/f'latest_{stage}.json'
    if stage == 'hold' and not pointer_path.exists():
        continue
    pointer = read_json(pointer_path)
    e = read_json(pointer_path.parent/pointer['record'])
    assert e['status'] == 'success' and e['runId'] == pointer['runId']
    stages[stage] = e
assert len({e['scopeHash'] for e in stages.values()}) == 1
assert len({e['scriptHash'] for e in stages.values()}) == 1
syn = stages['synthesis']
assert sha(manual/'AC201_tf_hdmi_gate.db').lower() == syn['gateDbHash']
for name, e in stages.items():
    if name != 'synthesis':
        assert e['synthesisRunId'] == syn['runId'] and e['gateDbHash'] == syn['gateDbHash']
for item in syn['scripts']:
    assert sha(root/'scripts'/item['path']).lower() == item['sha256']
scope = read_json(manual/'build_source_scope.json')
current_files = [p for p in (root/'src/user_source').rglob('*') if p.is_file()]
current_files += [root/'src/td_project/AC201_tf_hdmi.al']
current_files += [p for p in (root/'src/td_project/al_ip').rglob('*') if p.is_file()]
assert {p.relative_to(root/'src').as_posix() for p in current_files} == {i['path'].replace('\\','/') for i in scope}
for item in scope:
    assert sha(root/'src'/item['path']) == item['sha256'].upper()
route_name = stages['bitstream']['routeStage']
assert route_name in ('physical', 'hold')
for name, digest in stages[route_name]['artifacts'].items():
    assert sha(manual/name).lower() == digest
timing_text = (manual/'AC201_tf_hdmi_phy.ts').read_text(encoding='utf-8-sig')
values = [float(x) for x in re.search(r'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns\.', timing_text).groups()]
assert min(values) >= 0
area_text = (manual/'AC201_tf_hdmi_phy.area').read_text(encoding='utf-8-sig')
resource = {key: int(re.search(r'^\s*#'+token+r'\s+(\d+)', area_text, re.M).group(1))
            for key, token in [('LUT','lut'),('reg','reg'),('LE','le'),('BRAM9K','bram9k'),('DSP','dsp'),('GCLK','gclk')]}
coverage = float(re.search(r'STA coverage\s*:\s*([\d.]+)%', (manual/'AC201_tf_hdmi_pr.timing').read_text(encoding='utf-8-sig')).group(1))
assert resource['BRAM9K'] == 23
gate_text = (manual/'AC201_tf_hdmi_gate.v').read_text(encoding='utf-8-sig')
assert len(re.findall(r'EG_PHY_BRAM #[\s\S]*?\\u_wav_player/ramread1_syn_\d+\s+\(', gate_text)) == 4
bit = manual/'AC201_player_dynamic_text_pcm_bram_candidate.bit'
rollback = project/'download/osd_phy_fix.bit'
assert sha(bit).lower() == stages['bitstream']['bitHash'] and bit.stat().st_size == 629624
assert sha(rollback) == '9E893B0B6C86BF6FBEE19E74B5FB58933C1BEA6AA07F203786CCE96F3B60AE6F'
required_logs = {'pipeline_model.log': 'PASS tb_pcm_prefix_pipeline',
                 'status_pages.log': 'PASS all status pages and wrap',
                 'wav_model.log': 'PASS: all WAV file player self-checks passed',
                 'fifo_equivalence.log': 'PASS tb_fifo_bram_equivalence'}
for name, marker in required_logs.items():
    assert marker in (model/name).read_text(encoding='utf-8-sig'), name
for name in ('pipeline_compile.log', 'wav_compile.log', 'fifo_equivalence_compile.log'):
    assert not (model/name).read_text(encoding='utf-8-sig').strip(), name
parent = project/'development/player_dynamic_text_pcm_crc_probe/src/user_source'
changed, new = [], []
source = root/'src/user_source'
assert {p.relative_to(source) for p in source.rglob('*') if p.is_file()} == {p.relative_to(parent) for p in parent.rglob('*') if p.is_file()}
for p in sorted(source.rglob('*')):
    if p.is_file() and sha(p) != sha(parent/p.relative_to(source)):
        changed.append(p.relative_to(source).as_posix())
assert set(changed) == {'hdl_source/top_tf_hdmi_audio.v', 'hdl_source/player_status_monitor.v', 'hdl_source/tf_wav_file_player.v'}
ref = read_json(model/'host_music_reference.json')
assert ref['prefix_crc16_hex'] == 'F485' and ref['expected_complete_pages']['D'] == 'DFC11109'
checkpoint = root/'checkpoints/pcm_bram_candidate_20261011_candidate'
bundle, verified = root/'build/delivery', root/'build/delivery_verified'
zip_path = project/'deliverables/pcm_bram_candidate_20261011.zip'
assert not any(p.exists() for p in (bundle, verified, checkpoint, zip_path))
info = {'version':'C11109', 'kind':'SYNCHRONOUS_BRAM_PCM_FIFO_CANDIDATE', 'boardStatus':'PENDING',
    'rootCause':'UNCONFIRMED', 'createdBeijing':datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S'),
    'sourceProject':str(root), 'parentVersion':'C11108', 'canonicalBit':str(bit),
    'deliveryBitName':'pcm_bram_candidate.bit', 'bitBytes':bit.stat().st_size, 'bitSha256':sha(bit),
    'rollbackSha256':sha(rollback), 'scopeHash':syn['scopeHash'], 'scriptHash':syn['scriptHash'],
    'stageRunIds':{k:v['runId'] for k,v in stages.items()}, 'timing':dict(zip(('SWNSns','STNSns','HWNSns','HTNSns'),values)),
    'timingCoveragePercent':coverage, 'resource':resource, 'changedUserSourceFiles':changed, 'newUserSourceFiles':new,
    'implementation':'Four EG_PHY_BRAM DP8K 2048x4 for 2048x16 sample FIFO; registered explicit same-address bypass; no RAM-output reset.',
    'models':{'pipeline':'PASS scaled real player/bridge with asynchronous clocks, cross-sector header, loop, passive branch fault injection, abort/freeze',
              'productionCrc':'PASS direct default generic CRC unit against original music F485',
              'wav':'PASS valid formats, parser errors/timeouts, concurrent pop/push',
              'equivalence':'PASS old/new valid-cycle outputs and software queue; scoped FIFO stimulus, not device primitive simulation',
              'status':'PASS 10 pages/DFC11109/wrap',
              'logs':{name:sha(model/name) for name in required_logs}},
    'reference':ref, 'captureFlags':'{early_tone_abort,source_done_sync,fifo_done_sync,hdmi_done}; normal=7',
    'pages':{'6':'push CRC16','7':'FIFO pop CRC16','8':'HDMI input CRC16','9':'PCM low8/stereo format errors','A':'capture count','B':'first hashed high-byte file offset low24','C':'data offset low24','D':'DFC11109'},
    'checkpoint':str(checkpoint), 'physicalLayoutChanged':True, 'originalConstraintsRetained':True,
    'externalSpiIoCharacterized':False, 'chipwatcherInserted':False,
    'boundary':'CRC16 may collide; fixed music window only through HDMI core input. RTL models exclude encrypted HDMI and physical link. BRAM inference does not prove hardware root cause; reference card hash not freshly read.',
    'hardwareActions':'None by agent; user operates remote laboratory board, no TF or Flash writes'}
dump(manual/(bit.stem+'.info.json'),info)
bundle.mkdir()
shutil.copy2(bit,bundle/'pcm_bram_candidate.bit')
shutil.copy2(rollback,bundle/'osd_phy_fix.bit')
dump(bundle/'info.json',info)
shutil.copy2(model/'host_music_reference.json',bundle/'music_reference.json')
readme = f'''C11109 同步 BRAM 音频 FIFO 候选（未上板，不是已验证修复版）

本候选将样本 FIFO 改成同步 BRAM + 同地址旁路，保留 C11108 三段校验。未证明旧版本根因或本版本实物正确。
TF 文件不用修改。把此包发到板卡所接远控电脑，解压到英文路径。
1. BitWriter 空闲后板卡断电5秒，上电；PROGRAM_SRAM/5MHz 下载 pcm_bram_candidate.bit，确认 Downloading succeeded。
2. 默认 WAV 模式等10秒，录数码管和四灯至少25秒，反馈画面、音乐、KEY0切图、短KEY1轮播。
3. 录完再长按 KEY1 约2秒松开，反馈内部音阶是否清晰。完成后的CRC冻结，不必重复录相同CRC页。
4. 若失败，同条件回载同包 osd_phy_fix.bit。只写 SRAM，不写 Flash。

版本页 DFC11109。原包 TEST.WAV 预期6/7/8=6700F485/7700F485/8700F485，9=97000000，A=A7008000，B=B702002D，C=C700002C。
各段跳过65536个真实样本事件后，采集32768个样本冻结CRC；第二位7表示三段完成且未提前切tone。
其它音乐不能套用F485。提前切tone会abort，需重新冷启动下载。TF参考哈希未重新读取，见music_reference.json。
页6写入、7FIFO消费、8HDMI核输入高16；页9核输入低8/左右格式错误；A捕获数；B第一样本高字节位置；C数据偏移。

WAV四灯为FIFO非零/take/PCM变化/正确ACR曾发生的锁存事件；tone D3闪。亮灯不能证明音频持续正确。
本机WAV/流水线/CRC/状态页/新旧FIFO等价模型通过；原约束最终SWNS {values[0]:+.3f}ns、HWNS {values[2]:+.3f}ns、TNS0。实际推断4块音频FIFO BRAM，全工程23块。
CRC16有碰撞，模型不含加密HDMI核与板级链路，未验证WAV实际包内PCM或物理引脚。即使听感正常也需据诊断页判断，不把布局改变当作根因证明。
'''
(bundle/'README.txt').write_text(readme,encoding='utf-8-sig')
sums = {p.name:sha(p) for p in bundle.iterdir() if p.is_file()}
dump(bundle/'SHA256.json',sums)
with zipfile.ZipFile(zip_path,'x',zipfile.ZIP_DEFLATED) as z:
    for p in sorted(bundle.iterdir()): z.write(p,p.name)
verified.mkdir()
with zipfile.ZipFile(zip_path) as z: z.extractall(verified)
for name,digest in sums.items(): assert sha(verified/name)==digest
assert sha(verified/'SHA256.json')==sha(bundle/'SHA256.json')
shutil.copy2(bit,project/'download/pcm_bram_candidate.bit')
dump(project/'download/pcm_bram_candidate.info.json',info)
assert sha(project/'download/pcm_bram_candidate.bit')==sha(bit)
receipt={'zip':str(zip_path),'bytes':zip_path.stat().st_size,'sha256':sha(zip_path),'entriesVerified':len(sums)+1,'aliasVerified':True,'boardStatus':'PENDING'}
dump(root/'build/delivery_verified.json',receipt)
checkpoint.mkdir(parents=True)
files=[]
for folder in (source,root/'src/td_project/al_ip',root/'scripts',model,manual/'stage_evidence'):
    files.extend(p for p in folder.rglob('*') if p.is_file() and p.suffix!='.vvp')
files.extend((root/'src/td_project/AC201_tf_hdmi.al',root/'README.md',root/'build/package_delivery.py',root/'build/delivery_verified.json'))
files.extend(p for p in manual.iterdir() if p.is_file() and p.suffix in ('.json','.log','.ts','.timing','.area','.bit'))
manifest=[]
for p in sorted(set(files)):
    dest=checkpoint/p.relative_to(root)
    dest.parent.mkdir(parents=True,exist_ok=True)
    shutil.copy2(p,dest)
    assert sha(dest)==sha(p)
    manifest.append({'path':p.relative_to(root).as_posix(),'sha256':sha(dest),'bytes':dest.stat().st_size})
dump(checkpoint/'manifest.json',manifest)
cp_receipt={'checkpoint':str(checkpoint),'filesVerified':len(manifest),'manifestSha256':sha(checkpoint/'manifest.json'),'boardStatus':'PENDING','immutableHistory':True}
dump(root/'build/checkpoint_verified.json',cp_receipt)
print(json.dumps({'bit':info['bitSha256'],'delivery':receipt,'checkpoint':cp_receipt},ensure_ascii=False,indent=2))

