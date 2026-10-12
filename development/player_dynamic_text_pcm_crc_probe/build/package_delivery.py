from pathlib import Path
from datetime import datetime, timezone, timedelta
import json, hashlib, shutil, zipfile, re

root = Path(__file__).resolve().parents[1]
project = root.parents[1]
manual = root/'build/manual'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest().upper()
dump = lambda p,v: p.write_text(json.dumps(v,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
stamp = datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
stages = {}
for stage in ('synthesis','physical','hold','bitstream'):
    pointer = json.loads((manual/'stage_evidence'/f'latest_{stage}.json').read_text(encoding='utf-8-sig'))
    e = json.loads((manual/'stage_evidence'/pointer['record']).read_text(encoding='utf-8-sig'))
    assert e['status']=='success' and e['runId']==pointer['runId']
    stages[stage]=e
assert len({e['scopeHash'] for e in stages.values()})==1
assert len({e['scriptHash'] for e in stages.values()})==1
bit = manual/'AC201_player_dynamic_text_pcm_crc_probe.bit'
rollback = project/'download/osd_phy_fix.bit'
assert sha(bit).lower()==stages['bitstream']['bitHash'] and bit.stat().st_size==629624
assert sha(rollback)=='9E893B0B6C86BF6FBEE19E74B5FB58933C1BEA6AA07F203786CCE96F3B60AE6F'
timing = (manual/'AC201_tf_hdmi_phy.ts').read_text()
values = [float(x) for x in re.search(r'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns\.',timing).groups()]
assert min(values)>=0
model = root/'build/model'
assert 'PASS tb_pcm_prefix_pipeline' in (model/'pipeline_model.log').read_text()
assert 'PASS all status pages and wrap' in (model/'status_pages.log').read_text()
assert not (model/'pipeline_compile.log').read_text().strip()
parent = project/'development/player_dynamic_text_audio_packet_probe/src/user_source'
changed,new = [],[]
for p in sorted((root/'src/user_source').rglob('*')):
    if p.is_file():
        rel=p.relative_to(root/'src/user_source')
        if not (parent/rel).exists(): new.append(str(rel).replace('\\','/'))
        elif sha(p)!=sha(parent/rel): changed.append(str(rel).replace('\\','/'))
assert set(changed)=={'hdl_source/top_tf_hdmi_audio.v','hdl_source/player_status_monitor.v','hdl_source/tf_wav_file_player.v'}
assert new==['hdl_source/player_pcm_prefix_probe.v']
ref=json.loads((model/'host_music_reference.json').read_text())
checkpoint=root/'checkpoints/pcm_crc_probe_20261011_candidate'
info={'version':'C11108','kind':'PCM_WINDOW_CRC_DIAGNOSTIC_CANDIDATE','boardStatus':'PENDING',
      'rootCause':'UNCONFIRMED','createdBeijing':stamp,'sourceProject':str(root),'parentVersion':'C11107',
      'canonicalBit':str(bit),'deliveryBitName':'pcm_crc_probe.bit','bitBytes':bit.stat().st_size,'bitSha256':sha(bit),
      'rollbackSha256':sha(rollback),'scopeHash':stages['synthesis']['scopeHash'],
      'scriptHash':stages['synthesis']['scriptHash'],'stageRunIds':{k:v['runId'] for k,v in stages.items()},
      'timing':dict(zip(('SWNSns','STNSns','HWNSns','HTNSns'),values)),
      'timingCoveragePercent':99.97,'resource':{'LUT':16825,'reg':7995,'LE':18215,'BRAM9K':19,'DSP':0,'GCLK':2},
      'changedUserSourceFiles':changed,'newUserSourceFiles':new,'projectMetadataChanged':True,
      'models':{'pipeline':'PASS scaled actual player/bridge, asynchronous clocks, crossed sectors, loop, passive branch faults, abort/freeze',
          'productionCrc':'PASS default SKIP65536/PREFIX32768 direct generic CRC unit, independent Python F485',
          'status':'PASS self-tests,10 pages,DFC11108,wrap',
          'logs':{n:sha(model/n) for n in ('pipeline_model.log','status_pages.log','reference_generation.log')}},
      'reference':ref,'captureFlags':'{early_tone_abort, source_done_sync, fifo_done_sync, hdmi_done}; normal complete=7',
      'pages':{'6':'write/push CRC16','7':'FIFO pop CRC16','8':'HDMI input CRC16',
          '9':'captured PCM low8/stereo format errors','A':'captured HDMI sample count',
          'B':'first hashed high-byte file offset, low24','C':'data_offset, low24','D':'DFC11108'},
      'checkpoint':str(checkpoint),'physicalLayoutChanged':True,'originalConstraintsRetained':True,
      'externalSpiIoCharacterized':False,'chipwatcherInserted':False,
      'boundary':'CRC16 may collide; covers only same-ordinal music window through HDMI core input, not actual WAV packet PCM/PHY pins. Models exclude encrypted transmitter and physical link. Reference card hash not freshly read.',
      'hardwareActions':'None by agent; remote lab board, no JTAG/TF/Flash actions'}
info_path=manual/(bit.stem+'.info.json')
dump(info_path,info)
shutil.copy2(bit,project/'download/pcm_crc_probe.bit')
dump(project/'download/pcm_crc_probe.info.json',info)

bundle=root/'build/delivery'
bundle.mkdir(exist_ok=False)
shutil.copy2(bit,bundle/'pcm_crc_probe.bit')
shutil.copy2(rollback,bundle/'osd_phy_fix.bit')
dump(bundle/'info.json',info)
shutil.copy2(model/'host_music_reference.json',bundle/'music_reference.json')
readme='''C11108 PCM音乐内容诊断候选（未上板，不是已验证修复版）

TF文件不用修改。此包传到板卡所接远控电脑，解压到英文路径。
1. BitWriter空闲后板卡断电5秒，重新上电；PROGRAM_SRAM/5MHz下载pcm_crc_probe.bit，等待Downloading succeeded。
2. 默认音乐等待10秒，保持默认模式录数码管及四灯至少25秒，反馈画面和音乐听感。先不要长按KEY1：此版会采集启动后的固定音乐数据窗口。
3. 录完再长按板上KEY1约2秒，松开；确认内部音阶清晰与否，观察D3闪烁即可。不需要再录同一组冻结CRC页面。
4. 需要回退时同条件下载osd_phy_fix.bit；不写Flash。

页D=DFC11108。页6/7/8第二位正常应为7，表示三段都采集完成且没有提前切tone。
此版页6..C不再显示音频包统计！三段各跳过65536个实际样本事件，再对后32768个样本冻结CRC。
按原包天之弱TEST.WAV预计：6=6700F485、7=7700F485、8=8700F485；9=97000000；A=A7008000；B=B702002D；C=C700002C。
页6是SD字节组样本实际push，7是FIFO实际pop，8是HDMI核输入高16；9是核输入低8/左右格式错误；A是捕获32768样本数；B是第一被哈希样本高字节绝对位置，C是payload偏移。
全部完成后切tone不会改变冻结CRC。若提前长按，abort位会置1、第三段不完成，应重新冷启动/下载再测。
其他音乐文件不能套F485；本机参考文件SHA和完整范围见music_reference.json，并非本次远控TF文件新读取哈希。

LED：WAV D3曾非零FIFO、D2曾take、D1PCM曾变化、D0曾正确ACR；tone D3闪、D2有效、D1非零、D0正确ACR；锁存灯不表示持续正确。
本地集成模型/真参数CRC单元/页面模型及原约束最终时序通过；最终setup+0.633ns、hold+0.035ns、TNS0，coverage99.97%。
CRC16有碰撞；同校验值不是全链路验收。这一轮只核对固定窗口到HDMI核输入，未解码WAV实际包内PCM或测物理引脚。布局改变，根因未确认。
'''
(bundle/'README.txt').write_text(readme,encoding='utf-8-sig')
sums={p.name:sha(p) for p in bundle.iterdir() if p.is_file()}
dump(bundle/'SHA256.json',sums)
zip_path=project/'deliverables/pcm_crc_probe_20261011.zip'
assert not zip_path.exists()
with zipfile.ZipFile(zip_path,'w',zipfile.ZIP_DEFLATED) as z:
    for p in sorted(bundle.iterdir()): z.write(p,p.name)
verified=root/'build/delivery_verified'
verified.mkdir(exist_ok=False)
with zipfile.ZipFile(zip_path) as z: z.extractall(verified)
for name,digest in sums.items(): assert sha(verified/name)==digest
assert sha(verified/'SHA256.json')==sha(bundle/'SHA256.json')
assert sha(project/'download/pcm_crc_probe.bit')==sha(bit)
receipt={'zip':str(zip_path),'bytes':zip_path.stat().st_size,'sha256':sha(zip_path),'entriesVerified':len(sums)+1,'aliasVerified':True,'boardStatus':'PENDING'}
dump(root/'build/delivery_verified.json',receipt)

checkpoint.mkdir(parents=True,exist_ok=False)
files=[]
for folder in (root/'src/user_source',root/'src/td_project/al_ip',root/'scripts',model,manual/'stage_evidence'):
    files.extend(p for p in folder.rglob('*') if p.is_file() and p.suffix!='.vvp')
files.extend((root/'src/td_project/AC201_tf_hdmi.al',root/'README.md',root/'build/package_delivery.py',root/'build/delivery_verified.json'))
files.extend(p for p in manual.iterdir() if p.is_file() and p.suffix in ('.json','.log','.ts','.timing','.area','.bit'))
manifest=[]
for p in sorted(set(files)):
    rel=p.relative_to(root)
    dest=checkpoint/rel
    dest.parent.mkdir(parents=True,exist_ok=True)
    shutil.copy2(p,dest)
    assert sha(dest)==sha(p)
    manifest.append({'path':str(rel).replace('\\','/'),'sha256':sha(dest),'bytes':dest.stat().st_size})
dump(checkpoint/'manifest.json',manifest)
cp_receipt={'checkpoint':str(checkpoint),'filesVerified':len(manifest),'manifestSha256':sha(checkpoint/'manifest.json'),'boardStatus':'PENDING','immutableHistory':True}
dump(root/'build/checkpoint_verified.json',cp_receipt)
print(json.dumps({'bit':info['bitSha256'],'delivery':receipt,'checkpoint':cp_receipt},ensure_ascii=False,indent=2))
