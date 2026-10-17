from pathlib import Path
import hashlib,json,re,shutil,zipfile
from datetime import datetime, timezone, timedelta

root=Path('E:/VSCODE-project/FPGA-ANLU')
p=Path(__file__).resolve().parent
old=root/'development/player_music_envelope'
manual=p/'build/manual'
model=old/'build/board_feedback_20261013/serializer_model/result.json'
stamp=datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
def sha(f): return hashlib.sha256(f.read_bytes()).hexdigest().upper()
result=json.loads(model.read_text(encoding='utf-8-sig'))
assert result['status']=='PASS', 'Final PHY model must PASS'
assert result['candidateCaseCount']==28 and result['wordChecks']>0
for key in ('wordErrors','serialBitErrors','sourceSequenceErrors'):
 assert result[key]==0
for key,name in [('candidateLaneSha256','lane_lvds_10_1.v'),('candidateWrapperSha256','hdmi_phy_warpper.v')]:
 assert result[key].upper()==sha(p/'src/user_source/hdl_source'/name), 'Model binding stale'
stages={}
for stage in ('synthesis','physical','hold','bitstream'):
 pointer=json.loads((manual/f'stage_evidence/latest_{stage}.json').read_text(encoding='utf-8-sig'))
 item=json.loads((manual/'stage_evidence'/pointer['record']).read_text(encoding='utf-8-sig'))
 assert item['status']=='success'
 stages[stage]=item
assert stages['physical']['synthesisRunId']==stages['synthesis']['runId']
assert stages['hold']['synthesisRunId']==stages['synthesis']['runId']
assert stages['bitstream']['synthesisRunId']==stages['synthesis']['runId']
timing=re.search(r'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns\.',(manual/'AC201_tf_hdmi_phy.ts').read_text())
assert timing
values=[float(x) for x in timing.groups()]
assert all(x>=0 for x in values), 'No negative STA allowed'
area=(manual/'AC201_tf_hdmi_phy.area').read_text()
resource={k:int(re.search(r'^#'+label+r'\s+(\d+)',area,re.M).group(1)) for k,label in [('LUT','lut'),('reg','reg'),('LE','le'),('BRAM9K','bram'),('DSP','dsp'),('GCLK','gclk')]}
assert resource['BRAM9K']<=32 and resource['DSP']<=8
coverage=float(re.search(r'STA coverage\s*:\s*([\d.]+)%',(manual/'AC201_tf_hdmi_pr.timing').read_text()).group(1))
bit=manual/'AC201_player_music_envelope_phy.bit'
assert sha(bit)==stages['bitstream']['bitHash'].upper()
rollback=root/'download/bmp_scale.bit'
assert sha(rollback)=='C60464C0D4396D316DB7622E4CB0B70B5DE12C25148AFE234AC7C795C818625D'
assert sha(root/'download/music_envelope.bit')=='594AA169246DD480F224E9A0F4060E52CCB5642817B76522ABA040E147BD73EF'
changes=[]; inherited=[]
for f in (p/'src/user_source').rglob('*'):
 if f.is_file():
  rel=f.relative_to(p/'src')
  item={'path':str(rel).replace('\\','/'),'sha256':sha(f),'parentSha256':sha(old/'src'/rel)}
  (inherited if item['sha256']==item['parentSha256'] else changes).append(item)
assert len(changes)==4
assert sha(p/'src/user_source/hdl_source/player_pcm_waveform.v')==sha(old/'src/user_source/hdl_source/player_pcm_waveform.v')
(p/'build/source_diff_final.json').write_text(json.dumps({'parent':'C11302 FAILED_BOARD','changed':changes,'inheritedCount':len(inherited),'inherited':inherited},indent=2)+'\n',encoding='utf-8')
for folder in ('download','deliverables'):
 shutil.copyfile(bit,root/folder/'music_envelope_phy.bit')
info={
 'version':'C11303','kind':'ENVELOPE_PHY_FALLING_EDGE_WORD_AND_ODDR_PAIR','createdBeijing':stamp,
 'boardStatus':'PENDING_BOARD_VALIDATION','rootCause':'UNCONFIRMED; candidate tests serializer capture/PAD hold hypothesis',
 'parentVersion':'C11302 failed board','successfulBaseline':'C11206 bmp_scale.bit',
 'bitBytes':bit.stat().st_size,'bitSha256':sha(bit),'project':str(p),'bit':str(bit),
 'rollbackSha256':sha(rollback),'failedParentBitSha256':sha(root/'download/music_envelope.bit'),
 'timing':dict(zip(['SWNSns','STNSns','HWNSns','HTNSns'],values)),
 'timingCoveragePercent':coverage,'resource':resource,'holdFixPerformed':True,
 'stageRunIds':{k:v['runId'] for k,v in stages.items()},
 'changes':changes,'unchangedUserSourceCount':len(inherited),
 'model':str(model),'modelSha256':sha(model),'modelResult':result,
 'modelTestbenchSha256':sha(model.parent/'tb_serializer_model.v'),'modelRunnerSha256':sha(model.parent/'run_model.ps1'),
 'scopeHash':stages['synthesis']['scopeHash'],'scriptHash':stages['synthesis']['scriptHash'],
 'limits':['ODDR model uses official edge semantics; injected delays are not measured board delays','HDMI output delay/eye diagram not characterised','CRC evidence only a 32768-sample window before encrypted HDMI core','No local JTAG/TF/Flash or board test','Long run/repeated startup not validated']
}
info_text=json.dumps(info,ensure_ascii=False,indent=2)+'\n'
(manual/'AC201_player_music_envelope_phy.info.json').write_text(info_text,encoding='utf-8')
(root/'download/music_envelope_phy.info.json').write_text(info_text,encoding='utf-8')
readme=f'''# C11303 HDMI PHY 补强候选（实板待验证）

C11302 用户反馈整屏绿/彩条、无声，回载 C11206 同条件音画恢复；这次保留原包络、TF/音频/图片逻辑，仅补强 HDMI 的完整字捕获与 ODDR 输出前的数据准备，外加 build ID 更新。真实实板根因仍未唯一确认。

将本包解压到连接板卡电脑的纯英文目录。BitWriter Add music_envelope_phy.bit → PROGRAM_SRAM /5MHz → Run，确认 Downloading succeeded。数码管 D 页必须 DFC11303。TF 现有素材保持即可。

1. 默认音乐：确认底图、白字/黑底与包络面板没有规则绿/彩条，声音清晰。
2. 长按 KEY1 约 2 秒：确认内部音阶清晰；再次长按回音乐。
3. 如音画正常，再双键短按并松开验证 HOLD/恢复；观察曲线清晰度即可。

本轮先反馈音画和两音源结果；异常立即同条件回载包里的 bmp_scale.bit（C11206）。无需换卡或写 Flash。

本地模型和最终原约束 STA 通过：setup {values[0]:+.3f}ns、hold {values[2]:+.3f}ns、TNS0。模型不是电气测量，也不能代替此次候选板测。原 C11302 位流与 ZIP 保留取证，不覆盖。

位流 SHA256：{sha(bit)}
成功回退 SHA256：{sha(rollback)}
'''
(p/'README.md').write_text(readme,encoding='utf-8')
delivery=p/'build/delivery'
delivery.mkdir(exist_ok=True)
shutil.copyfile(bit,delivery/'music_envelope_phy.bit')
shutil.copyfile(rollback,delivery/'bmp_scale.bit')
(delivery/'music_envelope_phy.info.json').write_text(info_text,encoding='utf-8')
(delivery/'README.md').write_text(readme,encoding='utf-8')
shutil.copyfile(model,delivery/'phy_model_result.json')
members=sorted(f for f in delivery.iterdir() if f.is_file() and f.name!='checksums.sha256')
(delivery/'checksums.sha256').write_text(''.join(f'{sha(f)}  {f.name}\n' for f in members),encoding='ascii')
out=root/'deliverables/music_envelope_phy_20261013.zip'
assert not out.exists(), 'Do not replace a published ZIP'
with zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED) as z:
 for f in sorted(delivery.iterdir()): z.write(f,f.name)
with zipfile.ZipFile(out) as z:
 assert z.testzip() is None
 for f in delivery.iterdir(): assert z.read(f.name)==f.read_bytes()
checkpoint=p/'checkpoints/music_envelope_phy_20261013_candidate'
assert not checkpoint.exists()
for name in ('src','scripts','build/manual','build/delivery','build/audit'):
 shutil.copytree(p/name,checkpoint/name)
shutil.copytree(model.parent,checkpoint/'build/serializer_model')
shutil.copyfile(p/'build/source_diff_final.json',checkpoint/'build/source_diff_final.json')
manifest=[{'path':str(f.relative_to(checkpoint)).replace('\\','/'),'bytes':f.stat().st_size,'sha256':sha(f)} for f in sorted(checkpoint.rglob('*')) if f.is_file()]
(checkpoint/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
for m in manifest:
 f=checkpoint/m['path']; assert f.stat().st_size==m['bytes'] and sha(f)==m['sha256']
receipt={'createdBeijing':stamp,'zip':str(out),'zipSha256':sha(out),'bitSha256':sha(bit),'zipMembers':len(list(delivery.iterdir())),'checkpoint':str(checkpoint),'checkpointFiles':len(manifest),'manifestSha256':sha(checkpoint/'manifest.json'),'status':'LOCAL_DELIVERY_VERIFIED_BOARD_PENDING'}
(p/'build/delivery_verified.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print(json.dumps(receipt,indent=2))
