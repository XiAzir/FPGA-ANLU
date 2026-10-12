from pathlib import Path
import sys

for _anlu_root in Path(__file__).resolve().parents:
    if (_anlu_root / 'scripts' / 'anlu_paths.py').is_file():
        sys.path.insert(0, str(_anlu_root / 'scripts'))
        break
from anlu_paths import DOCS_ROOT, REPOSITORY_ROOT, recorded_path

import hashlib, json, re, shutil, zipfile
from datetime import datetime
from zoneinfo import ZoneInfo

root=REPOSITORY_ROOT;p=root/'development/player_bmp_scale'
out=p/'build/manual'; model=p/'build/model'; media=model/'test_media'
parent=root/'development/player_transition_wipe/checkpoints/transition_wipe_20261012_verified'
docs=DOCS_ROOT / '开发记录'
topic=docs/'专题记录/图片缩放/多尺寸最近邻首版_20261012'
now=datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y-%m-%d %H:%M:%S')
def sha(f): return hashlib.sha256(Path(f).read_bytes()).hexdigest().upper()
def load(f): return json.loads(Path(f).read_text(encoding='utf-8-sig'))
def save(f,v): Path(f).write_text(json.dumps(v,ensure_ascii=False,indent=2),encoding='utf-8')
cp=p/'checkpoints/bmp_scale_20261012_candidate'; zp=root/'deliverables/bmp_scale_20261012.zip'
assert not cp.exists() and not zp.exists() and not (root/'download/bmp_scale.bit').exists()
assert sha(parent/'manifest.json')=='A6B0AE1DBCAF1A92D360FA7F6E4AA935C1777A06D705940ED1364999A239A4A9'
assert len(load(parent/'manifest.json'))==169
for entry in load(parent/'manifest.json'): assert sha(parent/entry['path'])==entry['sha256']
oldcp=root/'development/player_transition_wipe/checkpoints/transition_wipe_20261012_candidate'
assert sha(oldcp/'manifest.json')=='55BDA6F491CCF5B7B15E70BD0E12B6F6F225EB4964B67ACAA7801ECE0824A82F'
for entry in load(oldcp/'manifest.json'): assert sha(oldcp/entry['path'])==entry['sha256']
assert sha(root/'deliverables/transition_wipe_20261012.zip')=='B9F6B9F7142B058424AD7BB84BCCC45E73B1DA8EA034AFC4AF90B2DD55581C76'
bit=out/'AC201_player_bmp_scale.bit'; assert bit.stat().st_size==629624
bh=sha(bit); rollback=root/'download/transition_wipe.bit'
assert sha(rollback)=='748E0AF0F9BF0656410C09735E371F655BEDD330C259E43858B614B1D95AE8F9'
audit=load(model/'parent_source_audit.json')
assert len(audit['unchangedInheritedSources'])==79 and len(audit['changedSources'])==5 and len(audit['newSources'])==1
for rel in audit['unchangedInheritedSources']: assert sha(p/'src'/rel)==sha(parent/'src'/rel)
review=(p/'build/audit/scaler_final_audit.md').read_text(encoding='utf-8-sig')
for rel in audit['changedSources']+audit['newSources']: assert sha(p/'src'/rel) in review.upper()
assert 'FINAL' in review.upper()
stages={}
for name in ['synthesis','physical','bitstream']:
    ptr=load(out/'stage_evidence'/('latest_'+name+'.json'))
    ev=load(out/'stage_evidence'/ptr['record'])
    assert ptr['status']==ev['status']=='success' and ptr['runId']==ev['runId']; stages[name]=ev
if (out/'stage_evidence/latest_hold.json').exists():
    ptr=load(out/'stage_evidence/latest_hold.json');ev=load(out/'stage_evidence'/ptr['record'])
    assert ptr['status']==ev['status']=='success' and ptr['runId']==ev['runId'];stages['hold']=ev
syn=stages['synthesis'];bs=stages['bitstream'];route=stages[bs['routeStage']]
assert bs['bitHash'].upper()==bh and sha(out/'AC201_tf_hdmi_gate.db')==syn['gateDbHash'].upper()
for name,ev in stages.items():
    assert ev['scopeHash']==syn['scopeHash'] and ev['scriptHash']==syn['scriptHash']
    if name!='synthesis': assert ev['synthesisRunId']==syn['runId'] and ev['gateDbHash']==syn['gateDbHash']
for name,h in route['artifacts'].items(): assert sha(out/name)==h.upper()
for ev in bs['scripts']: assert sha(p/'scripts'/ev['path'])==ev['sha256'].upper()
for ev in load(out/'build_source_scope.json'): assert sha(p/'src'/ev['path'])==ev['sha256'].upper()
timing=[float(v) for v in re.search(r'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns\.',(out/'AC201_tf_hdmi_phy.ts').read_text()).groups()]
assert min(timing)>=0
coverage=float(re.search(r'STA coverage\s*:\s*([\d.]+)%',(out/'AC201_tf_hdmi_pr.timing').read_text()).group(1))
area=(out/'AC201_tf_hdmi_phy.area').read_text()
resources={k:int(re.search(r'^\s*#'+field+r'\s+(\d+)',area,re.M).group(1)) for k,field in [('LUT','lut'),('reg','reg'),('LE','le'),('BRAM9K','bram9k'),('DSP','dsp'),('GCLK','gclk')]}
logs=['scaler_full_loader.log','write_backpressure.log']
for name in logs:
    txt=(model/name).read_text(encoding='utf-8-sig')
    assert 'PASS' in txt
    if name=='write_backpressure.log': assert 'FATAL' not in txt and 'FAIL' not in txt
# The independent full model receipt binds exact source hashes and completion counts.
gold=load(model/'scaler_validation_receipt.json')
assert gold['status']=='PASS'
assert sha(model/gold['successfulRunLog'])==gold['successfulRunLogSha256'].upper()
raw=(model/gold['successfulRunLog']).read_text(encoding='utf-8-sig')
assert 'SCALER_INTEGRATION PASS images=6 pixels=1843200' in raw and 'FAIL' not in raw and 'FATAL' not in raw
for rel,h in gold['sourceSha256'].items(): assert sha(p/'src/user_source/hdl_source'/rel)==h.upper()
assert gold['completeFrames']>=6 and gold['checkedPixels']>=1843200
assert gold['errorFixtureCases']==4
assert sha(model/gold['successfulErrorRunLog'])==gold['successfulErrorRunLogSha256'].upper()
error_raw=(model/gold['successfulErrorRunLog']).read_text(encoding='utf-8-sig')
assert 'SCALER_ERRORS PASS cases=4 retained=4' in error_raw and 'FAIL' not in error_raw and 'FATAL' not in error_raw
for rel,h in gold['testSha256'].items(): assert sha(model/rel)==h.upper()
for a in gold['assetGold']:
    stem=Path(a['bmp']).stem
    assert sha(media/a['bmp'])==a['bmpSha256'].upper()
    assert sha(media/(stem+'_source_bytes.mem'))==a['sourceBytesMemSha256'].upper()
    assert sha(media/(stem+'_expected_bottomup_rgb24.mem'))==a['expectedBottomupRgb24MemSha256'].upper()
gate=(out/'AC201_tf_hdmi_gate.v').read_text(encoding='utf-8-sig')
blocks=[]
for m in re.finditer(r'EG_PHY_BRAM #\(',gate): blocks.append(gate[m.start():gate.find(');',m.start())+2])
wave=[b for b in blocks if '\\u_pcm_waveform/ramread0_syn_' in b]
pcm=[b for b in blocks if '\\u_wav_player/ramread1_syn_' in b]
scale=[b for b in blocks if 'u_scale/' in b]
assert len(wave)==1 and len(pcm)==4 and len(scale)>=4
(model/'bram_mapping_excerpt.txt').write_text('Gate SHA256 '+sha(out/'AC201_tf_hdmi_gate.v')+'\nWave1 PCM4 scaler'+str(len(scale))+'\n\n'+'\n\n'.join(wave+pcm+scale),encoding='utf-8')
info={'version':'C11206','kind':'BMP24_NEAREST_NEIGHBOUR_ASPECT_FIT','boardStatus':'PENDING_BOARD_VALIDATION','createdBeijing':now,
 'sourceProject':str(p),'parentVersion':'C11205','successfulBaseline':'C11205 transition_wipe.bit with known waveform display issues',
 'canonicalBit':str(bit),'deliveryBitName':'bmp_scale.bit','bitBytes':bit.stat().st_size,'bitSha256':bh,
 'rollbackBitName':rollback.name,'rollbackSha256':sha(rollback),'scopeHash':bs['scopeHash'],'scriptHash':bs['scriptHash'],
 'stageRunIds':{s:e['runId'] for s,e in stages.items()},'timing':dict(zip(['SWNSns','STNSns','HWNSns','HTNSns'],timing)),
 'timingCoveragePercent':coverage,'resource':resources,'holdFixPerformed':bs['routeStage']=='hold',
 'goldReceipt':gold,'models':{n:sha(model/n) for n in logs},'inheritedSourceAudit':sha(model/'parent_source_audit.json'),
 'supported':{'bmp':'24-bit BI_RGB','widthMax':1024,'heightMax':768,'signedHeight':True,'rowPadding':True,'aspectFitBlackBorders':True,'display':[640,480]},
 'backpressure':{'thresholdWords':480,'usableCapacityWords':511,'observedPeakWords':481,'pressureModelPixels':4096,'pressureModelStalls':5908},
 'knownIssues':['Dynamic waveform double trace disappears under HOLD; unique cause unconfirmed','Low waveform display resolution; optimization deferred'],
 'hardwareActions':'No local JTAG, TF write or Flash programming; copying supplied BMP media is a future user action',
 'checkpoint':str(cp),'evidenceLimit':'Complete BMP loader/gold and actual pack/backend/FIFO pressure models, static audit and original-constraint TD timing. Encrypted SDRAM, real TF/card fragmented reverse access, physical BRAM/HDMI and board unverified.'}
save(out/'AC201_player_bmp_scale.info.json',info)
delivery=p/'build/delivery';delivery.mkdir(parents=True)
(delivery/'TF_ROOT').mkdir();(delivery/'PREVIEW_ONLY').mkdir()
mm=load(media/'media_manifest.json');mapping=[]
for idx,stem in enumerate(['bmp_320x240_bottomup','bmp_800x600_bottomup','bmp_191x321_topdown','bmp_512x128_bottomup'],1):
    asset=next(a for a in mm['assets'] if a['bmp']==stem+'.bmp')
    src=media/asset['bmp'];assert sha(src)==asset['sha256'].upper()
    target=f'SCALE{idx}.BMP';shutil.copy2(src,delivery/'TF_ROOT'/target)
    shutil.copy2(media/asset['preview_png'],delivery/'PREVIEW_ONLY'/f'SCALE{idx}.png')
    mapping.append(dict(asset,tfName=target))
save(delivery/'media_manifest.json',{'files':mapping,'TF_ROOT':'原始BMP，直接由FPGA缩放','PREVIEW_ONLY':'仅供比较的640×480显示金值，勿复制到TF卡'})
readme='''# C11206 多尺寸BMP缩放候选：实板待验证

FPGA读取原尺寸BMP，等比缩放并居中显示到640×480。显示器仍用原480p模式。包内原图没有在PC预缩放；PREVIEW_ONLY只供对照。

## 准备卡

1. 板卡断电，把TF卡接到实验室电脑读卡器。把现有四张BMP备份到电脑文件夹，再从TF卡根目录移走；不要把备份放在卡内子文件夹来代替电脑备份。
2. 把TF_ROOT里的四个SCALE*.BMP文件直接复制到TF卡根目录（打开盘符就能看到），不要复制TF_ROOT文件夹本身。根目录只保留这四张BMP，原TEST.WAV保持。无需格式化/写裸扇区。
3. 安全弹出卡，插回板卡，再上电。

## 下载与观察

英文路径解压，BitWriter Add bmp_scale.bit，PROGRAM_SRAM /5MHz，Run，确认Downloading succeeded；数码管D页DFC11206。先测试一轮手动切图，再打开AUTO。目录扫描顺序未必等于文件名顺序。

- SCALE1：320×240放大至全屏，彩块/边框/文字方向正确。
- SCALE2：800×600缩小至全屏，颜色、对角线和文字正常。
- SCALE3：191×321 top-down竖图，每行有3字节padding；内容285×480，左黑边177px/右178px，方向正确。
- SCALE4：512×128宽图，内容640×160，上下各160px黑边。

与PREVIEW_ONLY逐张对照。字幕/波形/状态栏属于叠加区域，会覆盖底图和部分黑边；首版最近邻边缘可呈阶梯。加载耗时可能不同，top-down反向FAT访问可能更慢，首版不承诺固定切图等待时长。

确认四图没有倒置、错色、条带或丢行；KEY0手动和KEY1 AUTO保留上下擦除。默认音乐和长按KEY1内部音阶均应清晰；再确认字幕、亮度/对比度、恢复默认、双键短按波形冻结/恢复。动态波形双线与低清晰度仍为已知项。

若异常，先恢复电脑备份的原四张BMP（移走SCALE*.BMP，保留WAV），在相同供电/HDMI/音量下回载同包transition_wipe.bit。旧版不支持这次多尺寸素材，因此须先恢复原素材才是有效回退对照。反馈文件名、画面/音频/按键现象；无需补录以前的诊断数码管页。

不写Flash。所有实物操作由用户在连接板卡的实验室电脑完成。
'''
(delivery/'README.md').write_text(readme,encoding='utf-8')
for src,dst in [(bit,root/'download/bmp_scale.bit'),(out/'AC201_player_bmp_scale.info.json',root/'download/bmp_scale.info.json'),(bit,delivery/'bmp_scale.bit'),(out/'AC201_player_bmp_scale.info.json',delivery/'bmp_scale.info.json'),(rollback,delivery/rollback.name)]:
    assert not dst.exists();shutil.copy2(src,dst);assert sha(src)==sha(dst)
names=sorted(f.relative_to(delivery).as_posix() for f in delivery.rglob('*') if f.is_file())
(delivery/'checksums.sha256').write_text(''.join(sha(delivery/n)+'  '+n+'\n' for n in names),encoding='ascii');names.append('checksums.sha256')
cp.mkdir(parents=True)
files=[p/'README.md']+[f for f in (p/'build').glob('*.py')]
files += [f for f in (p/'src/user_source').rglob('*') if f.is_file()]+[p/'src/td_project/AC201_tf_hdmi.al']
files += [f for f in (p/'src/td_project/al_ip').rglob('*') if f.is_file()]+[f for f in (p/'scripts').rglob('*') if f.is_file()]
files += [f for f in (p/'build/audit').rglob('*') if f.is_file()]+[p/'build/scaler_spec.md']
files += [f for f in model.rglob('*') if f.is_file() and f.suffix!='.vvp']
files += [f for f in delivery.rglob('*') if f.is_file()]
files += [f for f in out.rglob('*') if f.is_file() and f.suffix in ['.log','.ts','.timing','.area','.json','.bit']]
if (p/'build/prehold').exists(): files += [f for f in (p/'build/prehold').rglob('*') if f.is_file() and f.suffix!='.db']
files += [f for f in (p/'build/initial_ram_mapping').rglob('*') if f.is_file() and f.suffix in ['.log','.area','.ts','.timing','.json']]
manifest=[]
for src in sorted(set(files)):
    rel=src.relative_to(p);dst=cp/rel;dst.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(src,dst)
    assert sha(src)==sha(dst);manifest.append({'path':rel.as_posix(),'bytes':dst.stat().st_size,'sha256':sha(dst)})
save(cp/'manifest.json',manifest)
for e in manifest: assert sha(cp/e['path'])==e['sha256']
with zipfile.ZipFile(zp,'w',zipfile.ZIP_DEFLATED) as z:
    for n in sorted(names):z.write(delivery/n,n)
with zipfile.ZipFile(zp) as z:
    assert z.testzip() is None and set(z.namelist())==set(names)
    for n in names: assert hashlib.sha256(z.read(n)).hexdigest().upper()==sha(delivery/n)
receipt={'createdBeijing':now,'bitSha256':bh,'checkpointFiles':len(manifest),'manifestSha256':sha(cp/'manifest.json'),'zip':str(zp),'zipBytes':zp.stat().st_size,'zipSha256':sha(zp),'boardStatus':info['boardStatus'],'parentVerifiedAndCandidateAndZipUnchanged':True}
save(p/'build/delivery_verified.json',receipt);save(topic/'build_info.json',info);save(topic/'delivery_receipt.json',receipt)
shutil.copy2(delivery/'README.md',topic/'操作卡.md')
message=f'{now} C11206多尺寸BMP/FPGA最近邻候选本地完成、实板待验证。完整loader六帧逐像素gold {gold["checkedPixels"]}像素和错误/ready回归通过；实际pack/backend/FIFO压力4096像素/max_used481通过，静态审查无阻塞。TD原约束时序{info["timing"]} coverage{coverage}% holdFix={info["holdFixPerformed"]}，资源{resources}，BRAM映射保留PCM4/波形1且缩放{len(scale)}。源/脚本/DB/报告/bit来源与ZIP逐项SHA通过；bmp_scale.bit SHA{bh}；ZIP{zp} {receipt["zipBytes"]}bytes SHA{receipt["zipSha256"]}；checkpoint{len(manifest)}文件/manifest{receipt["manifestSha256"]}。79源不变/5改/1新，支持24位BI_RGB宽<=1024/高<=768正负高度/padding/等比黑边640×480。未代理JTAG/TF/Flash，真实卡/加密SDRAM/实际音画待板测；成功基线仍C11205，波形已知显示问题保留。功能开发约80%、全流程60%–65%为主观估算，未将待板测缩放计为已验收。'
with (topic/'README.md').open('a',encoding='utf-8') as f: f.write('\n## 本地候选交付\n\n'+message+'\n\n下一步按[操作卡](操作卡.md)备份旧BMP/复制四张原尺寸BMP并下载新候选；失败须恢复旧图片再回载C11205。\n')
state=docs/'当前状态.md';s=state.read_text(encoding='utf-8');s=re.sub(r'^更新：.*$',f'更新：{now}（北京时间；XiAzir；C11206候选交付/板测待验证，成功基线C11205）。',s,count=1,flags=re.M);s=s.replace('## 当前阶段','## 当前阶段\n\n**'+message+' [缩放专题](专题记录/图片缩放/多尺寸最近邻首版_20261012/README.md)。**',1);state.write_text(s,encoding='utf-8')
with (docs/'工作日志/2026-10-12.md').open('a',encoding='utf-8') as f: f.write('\n### '+now+'｜C11206缩放｜本地交付、板测待验证\n\n- '+message+'\n- 下一步用户在板卡相连的实验室电脑按操作卡处理媒体与下载。\n')
print(json.dumps(receipt,ensure_ascii=True,indent=2))
