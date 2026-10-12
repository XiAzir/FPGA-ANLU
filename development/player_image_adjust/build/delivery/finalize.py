from pathlib import Path
import json,re,hashlib,shutil,zipfile,datetime
r=Path('E:/VSCODE-project/FPGA-ANLU');p=r/'development/player_image_adjust';out=p/'build/manual';d=p/'build/delivery';docs=Path('E:/QQ CACHE/Download/安路资料/开发记录');now=datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
def sha(f):return hashlib.sha256(Path(f).read_bytes()).hexdigest().upper()
def savejson(f,obj):Path(f).write_text(json.dumps(obj,ensure_ascii=False,indent=2),encoding='utf-8')
bit=out/'AC201_player_image_adjust.bit';bh=sha(bit);assert bit.stat().st_size==629624
rb=r/'download/pcm_bram_candidate.bit';rh=sha(rb);assert rh=='A5F2C25BA1F65B05051419093BC78EC2DD05E510502D914450DD77673CB7E0C0'
timing=[float(v) for v in re.search(r'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns\.',(out/'AC201_tf_hdmi_phy.ts').read_text()).groups()];assert min(timing)>=0
coverage=float(re.search(r'STA coverage\s*:\s*([\d.]+)%',(out/'AC201_tf_hdmi_pr.timing').read_text()).group(1));area=(out/'AC201_tf_hdmi_phy.area').read_text();resource={key:int(re.search(r'^\s*#'+field+r'\s+(\d+)',area,re.M).group(1)) for key,field in [('LUT','lut'),('reg','reg'),('LE','le'),('BRAM9K','bram9k'),('DSP','dsp'),('GCLK','gclk')]}
logs=['tb_player_rgb_adjust.log','tb_player_adjust_control.log','overlay.log'];
for f in logs: assert 'PASS ' in (p/'build/model'/f).read_text(encoding='utf-8-sig') and 'FAIL' not in (p/'build/model'/f).read_text(encoding='utf-8-sig')
stages={}
for s in ['synthesis','physical','bitstream']:
 pointer=json.loads((out/'stage_evidence'/('latest_'+s+'.json')).read_text(encoding='utf-8-sig'));e=json.loads((out/'stage_evidence'/pointer['record']).read_text(encoding='utf-8-sig'));assert e['status']=='success';stages[s]=e
assert stages['bitstream']['bitHash'].upper()==bh
# Capture the four actual synthesized 2048x4 PCM BRAM instances.
gate=(out/'AC201_tf_hdmi_gate.v').read_text(encoding='utf-8-sig');blocks=[]
for match in re.finditer(r'EG_PHY_BRAM #\(',gate):
 end=gate.find(');',match.start())+2;block=gate[match.start():end]
 if '\\u_wav_player/ramread1_syn_' in block:blocks.append(block)
assert len(blocks)==4,len(blocks)
(p/'build/model/bram_mapping_excerpt.txt').write_text('Gate SHA256 '+sha(out/'AC201_tf_hdmi_gate.v')+'\n\n'+'\n\n'.join(blocks),encoding='utf-8')
checkpoint=p/'checkpoints/image_adjust_20261012_candidate';assert not checkpoint.exists()
info={'version':'C11201','kind':'T22_BRIGHTNESS_CONTRAST_CANDIDATE','boardStatus':'PENDING_BOARD_VALIDATION','createdBeijing':now,'sourceProject':str(p),'parentVersion':'C11109','canonicalBit':str(bit),'deliveryBitName':'image_adjust.bit','bitBytes':bit.stat().st_size,'bitSha256':bh,'rollbackBitName':rb.name,'rollbackSha256':rh,'scopeHash':stages['bitstream']['scopeHash'],'scriptHash':stages['bitstream']['scriptHash'],'stageRunIds':{s:e['runId'] for s,e in stages.items()},'timing':dict(zip(['SWNSns','STNSns','HWNSns','HTNSns'],timing)),'timingCoveragePercent':coverage,'resource':resource,'holdFixPerformed':False,'models':{f:sha(p/'build/model'/f) for f in logs},'inheritedSourceAudit':sha(p/'build/model/parent_source_audit.json'),'sampleFifoBram':'4 EG_PHY_BRAM DP8K, 2048x4 = 2048x16; inherited C11109 unchanged','format':'640x480 existing BMP/48kHz mono PCM16 TEST.WAV, existing TF files','brightnessOffsets':list(range(-64,65,16)),'contrastGains':[0.5,0.75,1.0,1.25,1.5],'pixelFormula':'clip(floor((p-128)*C)+128+B,0,255), default identity, active base pixels only','parameterCommit':'VS rise, frame constant; OSD mode frame-latched','controlLimit':'PLAY short actions on release; long KEY1 no AUTO side-effect; busy taps coalesce in one-entry pending; combo video probe disabled','checkpoint':str(checkpoint),'hardwareActions':'No local JTAG, TF writes or Flash programming','evidenceLimit':'Models/STA and source equivalence do not prove board PHY/long-term operation. Original unconstrained IO/CDC/IP warning boundaries preserved.'}
savejson(out/'AC201_player_image_adjust.info.json',info)
readme=(p/'README.md').read_text(encoding='utf-8');readme=readme.replace('本地模型/构建状态待补。','''本地模型/正式综合/布局布线/原约束时序/位流通过，尚未上板。最终 SWNS +0.576ns / HWNS +0.011ns，STNS/HTNS=0，coverage99.96%；12944 LUT/8151 reg/14388 LE/23 BRAM9K/0 DSP/2 GCLK。未执行fix_hold。模型与边界见build/model/README.md。

版本 C11201，数码管D页DFC11201。播放模式极快连点忙时合并到1位pending；正常点按逐次生效。

位流SHA256: '''+bh)
(p/'README.md').write_text(readme,encoding='utf-8')
# Live download copies, preserving old successful artifacts.
for src,dst in [(bit,r/'download/image_adjust.bit'),(out/'AC201_player_image_adjust.info.json',r/'download/image_adjust.info.json')]:
 assert not dst.exists();shutil.copy2(src,dst);assert sha(src)==sha(dst)
# Freeze all sources/scripts, local model evidence and final reports; large compiler DBs remain in live build/manual.
checkpoint.mkdir(parents=True)
files=[p/'README.md']
files += [f for f in (p/'src/user_source').rglob('*') if f.is_file()]
files += [p/'src/td_project/AC201_tf_hdmi.al']+[f for f in (p/'src/td_project/al_ip').rglob('*') if f.is_file()]
files += [f for f in (p/'scripts').rglob('*') if f.is_file()]
files += [f for f in (p/'build/model').rglob('*') if f.is_file() and f.suffix!='.vvp']
files += [f for f in out.rglob('*') if f.is_file() and f.suffix in ['.log','.ts','.timing','.area','.json','.bit']]
manifest=[]
for f in sorted(set(files)):
 rel=f.relative_to(p);dest=checkpoint/rel;dest.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(f,dest);assert sha(f)==sha(dest);manifest.append({'path':rel.as_posix(),'bytes':dest.stat().st_size,'sha256':sha(dest)})
savejson(checkpoint/'manifest.json',manifest)
for e in manifest:assert sha(checkpoint/e['path'])==e['sha256']
shutil.copy2(bit,d/'image_adjust.bit');shutil.copy2(rb,d/rb.name);shutil.copy2(out/'AC201_player_image_adjust.info.json',d/'image_adjust.info.json')
deliveryreadme='''# C11201 亮度 / 对比度实板验收

本地模型、TD综合/布局布线/原约束setup-hold通过；新候选尚未上板。
只用 PROGRAM_SRAM，不用写TF/Flash。现有四BMP/天之弱TEST.WAV保持；路径用英文。

1. BitWriter Add image_adjust.bit，PROGRAM_SRAM / 5MHz，Run并确认Downloading succeeded。
2. 默认应显示PLAY B+00 C1.00；图片、天之弱音乐、KEY0短切图、KEY1短轮播、RUN计时/滚动字幕正常。短操作松开后生效；点按间稍作间隔，极快多连点会合并。
3. KEY0长按约2秒看到BRI后松开：短KEY1增亮、短KEY0减亮。B=-64..+64步长16，端点不回绕；观察底图变化、文字清晰、音乐保持。
4. 再长KEY0看到CON后松开：短KEY1增对比度、短KEY0减。C=0.50/0.75/1.00/1.25/1.50；观察暗亮区域、端点无反色、OSD数字同步。
5. 同时按住两键约2秒后松开两键，应回PLAY B+00 C1.00、原图恢复，已有AUTO/音源不会因该恢复操作被重置。
6. PLAY模式长KEY1约2秒切内部音阶，再长按切回音乐；这版长KEY1不再顺带切AUTO。编辑模式长KEY1不切音源。

新候选失败时同条件回载pcm_bram_candidate.bit，这是C11109用户反馈全功能及30分钟短稳正常的直接回退。
成功只需逐项反馈，不必重录10页；异常保存照片/短视频及D页版本，必要时核对6/7/8 CRC。
'''
(d/'README.md').write_text(deliveryreadme,encoding='utf-8');checksum=''.join(sha(f)+'  '+f.name+'\n' for f in sorted(d.iterdir()) if f.is_file() and f.name!='finalize.py');(d/'checksums.sha256').write_text(checksum,encoding='ascii')
zipout=r/'deliverables/image_adjust_20261012.zip';assert not zipout.exists()
with zipfile.ZipFile(zipout,'w',zipfile.ZIP_DEFLATED) as z:
 for f in sorted(d.iterdir()):
  if f.is_file() and f.name!='finalize.py':z.write(f,f.name)
with zipfile.ZipFile(zipout) as z:
 assert z.testzip() is None
 for name in z.namelist():assert hashlib.sha256(z.read(name)).hexdigest().upper()==sha(d/name)
receipt={'createdBeijing':now,'bitSha256':bh,'checkpointFiles':len(manifest),'manifestSha256':sha(checkpoint/'manifest.json'),'zip':str(zipout),'zipBytes':zipout.stat().st_size,'zipSha256':sha(zipout),'boardStatus':'PENDING_BOARD_VALIDATION'};savejson(p/'build/delivery_verified.json',receipt)
topic=docs/'专题记录/图像实时调节/亮度对比度首版_20261012';topic.mkdir(parents=True,exist_ok=True);savejson(topic/'delivery_receipt.json',receipt);savejson(topic/'build_info.json',info)
(topic/'README.md').write_text('''# T22 亮度/对比度首版 C11201

''' +now+'''（北京时间），完成本地实现/模型/构建/封存/交付；上板待验证。

用户针对C11109的30分钟WAV/AUTO、手动切图及RUN/滚动回复“没问题”，记用户现场短稳反馈通过；未升级为长稳/冷启动回归。

工程：E:/VSCODE-project/FPGA-ANLU/development/player_image_adjust。继承成功141文件verified快照并全哈希复核，原音频FIFO/FAT/SDRAM/HDMI/PHY/SDC不改；新增控制/RGB定点饱和/参数栏三模块，top连接及状态BUILD_ID变化。产品双键手势替代旧组合视频probe，不再触发隐藏测试图。PLAY短动作释放生效、长KEY1只切音源，编辑模式音乐/轮播继续。

B±64/步16，C0.50..1.50/五档。clip(floor((p-128)*C)+128+B)，默认恒等；参数VS提交/模式文字帧锁，底图调节、文字独立保持原色。

模型11524RGBvectors；缩放控制+生产25MHz参数断言+真实legacy debounce集成；三帧1152000周期和24576参数栏比较。根代理复核/重跑，修正生产整数溢出、多process pending驱动、同步初值、组合优先及legacy脉冲高间隔；独立gpt-6-luna只读集成复核无新增必改。范围见工程build/model/README.md，未模拟加密核/实际PHY。

TD正式三阶段输入/脚本/数据库/报告哈希绑定。SWNS+0.576/HWNS+0.011ns，TNS0、coverage99.96%；12944LUT/8151reg/14388LE/23BRAM9K/0DSP/2GCLK；无需fix_hold，未放宽原约束。真实PCM FIFO仍四块2048×4 BRAM；保留原IP/IO/CDC警告边界，不把STA代替实板。

候选download/image_adjust.bit，SHA256 '''+bh+'''; ZIP deliverables/image_adjust_20261012.zip逐项解包哈希通过；冻结检查点 '''+str(checkpoint)+'''，共'''+str(len(manifest))+'''文件，详见delivery_receipt.json。成功基线仍C11109 SHA '''+rh+'''；ZIP含此直接回退。未本机JTAG/写TF/Flash，旧位流/ZIP/检查点保持。

下一步用户用PROGRAM_SRAM上板验证默认显示/音乐/按键/字幕、亮度和对比度五档效果/饱和/数值同步、双键恢复以及两音源。仅全部通过后记T22实板验收，随后T23真实PCM波形；无需改卡/重录旧页。
''',encoding='utf-8')
state=docs/'当前状态.md';t=state.read_text(encoding='utf-8');start=t.index('## 当前阶段');t=t[:start]+t[start:].replace('## 当前阶段','## 当前阶段\n\n**'+now+' T22亮度/对比度候选C11201本地模型/正式综合/布局布线/原约束时序/位流/封存/ZIP校验完成；尚未上板。SWNS+0.576/HWNS+0.011ns/TNS0/coverage99.96%，download/image_adjust.bit SHA '+bh+'。KEY0长切PLAY/BRI/CON，编辑短KEY0-/KEY1+，双键长复默认；PLAY长KEY1只切音源。父音频/SDRAM/PHY/约束不改。deliverables/image_adjust_20261012.zip含C11109直接回退，成功基线仍C11109，TF无需改。见[首版开发与交付](专题记录/图像实时调节/亮度对比度首版_20261012/README.md)。**',1)
t=t.replace('RGB/控制/整帧模型与TD综合已通过，布局布线进行中；最终原约束setup/hold和位流尚待完成，未上板，不作为成功版本。','RGB/控制/整帧模型、正式综合/布局布线/原约束setup-hold与位流/封存/交付通过；实板待验证，不作为成功版本。')
state.write_text(t,encoding='utf-8');log=docs/'工作日志/2026-10-12.md';t=log.read_text(encoding='utf-8');t+='\n### '+now+'｜T22 C11201候选交付｜本地完成，实板待验证\n\n- 完成三模块与top/工程接入，模型/独立集成复核通过；生产25MHz溢出等本地复核问题在正式构建前修正。模型范围/源码继承见专题和工程build/model。\n- 正式三阶段wrapper绑定通过；最终SWNS+0.576/HWNS+0.011ns/TNS0/coverage99.96%、12944LUT/8151reg/14388LE/23BRAM9K/0DSP/2GCLK；四PCM BRAM映射保持，无fix_hold/改约束。bit629624字节SHA '+bh+'。\n- 冻结'+str(len(manifest))+'文件checkpoint，manifest '+receipt['manifestSha256']+'；ZIP '+str(zipout)+' / '+str(receipt['zipBytes'])+'字节 / SHA '+receipt['zipSha256']+'；逐条哈希/ZIP核验通过。旧成功产物不覆盖。\n- [T22首版说明与操作](../专题记录/图像实时调节/亮度对比度首版_20261012/README.md)。尚未上板，不证明实板音画/长期稳定；成功开发基线仍C11109。未JTAG/TF/Flash操作。\n- 下一步用户PROGRAM_SRAM下载image_adjust.bit，检验默认音画/按键/动态字幕、B/C档位效果和文字同步、双键恢复及长KEY1音源。通过后推进T23真实PCM波形，TF不用改。\n';log.write_text(t,encoding='utf-8')
print(json.dumps(receipt,ensure_ascii=True,indent=2))

