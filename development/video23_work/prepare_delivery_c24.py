from pathlib import Path
import json,hashlib,re,shutil,zipfile,datetime
ROOT=Path(__file__).resolve().parents[2]
p=ROOT/'development/player_video24_spi6p25_diag';base=ROOT/'development/player_video23_mode_switch'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
read=lambda p:json.loads(p.read_text(encoding='utf-8-sig'))
save=lambda p,o:p.write_text(json.dumps(o,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
binding=read(p/'verification/final_stage_binding.json');assert binding['status']=='PASS'
old={q.relative_to(base/'src/user_source').as_posix():sha(q) for q in (base/'src/user_source').rglob('*') if q.is_file()}
new={q.relative_to(p/'src/user_source').as_posix():sha(q) for q in (p/'src/user_source').rglob('*') if q.is_file()}
changed=[k for k in old if old[k]!=new[k]];assert sorted(changed)==['hdl_source/player_compact_status_pages.v','hdl_source/top_tf_hdmi_audio.v']
oldtop=(base/'src/user_source/hdl_source/top_tf_hdmi_audio.v').read_text(encoding='utf-8-sig');newtop=(p/'src/user_source/hdl_source/top_tf_hdmi_audio.v').read_text(encoding='utf-8-sig')
assert newtop.replace('sd_card_top #(.SPI_HIGH_SPEED_DIV(2))','sd_card_top #(.SPI_HIGH_SPEED_DIV(0))')==oldtop
sdlog=ROOT/'development/video23_work/mode_analysis/sd_quiesce_c24_spi6p25.log';assert 'PASS SPI6.25 periods160ns checks=35980' in sdlog.read_text(encoding='utf-8-sig')
system=p/'build/video_system_20261022_140549';result=read(system/'summary.json');assert result['status']=='FAILED'
log=(system/'console.log').read_text(encoding='utf-8-sig');assert 'video decode missed a 15fps content deadline' in log
receipt=read(system/'source_receipt.json');compat={x['path']:x['copy_sha256'].lower() for x in receipt['compatibility']}
for row in receipt['inputs']:
 assert sha(Path(row['source']))==row['sha256'].lower()
 assert sha(Path(row['copy']))==compat.get(row['copy'],row['sha256'].lower())
t=(p/'build/manual/AC201_tf_hdmi_phy.ts').read_text();m=re.search(r'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns\.',t);assert m and all(float(x)>=0 for x in m.groups())
net=(p/'verification/final_routed.v').read_text(encoding='utf-8-sig');counts={x:len(re.findall(r'^\s*'+x+r'\s*#',net,re.M)) for x in ['EG_PHY_MSLICE','EG_PHY_LSLICE']};slices=sum(counts.values());assert 0<slices<=9800
area=(p/'build/manual/AC201_tf_hdmi_phy.area').read_text();resources={k:int(re.search(r'^#'+k+r'\s+(\d+)',area,re.M)[1]) for k in ['lut','reg','bram','dsp','pll','gclk']}
bit=p/'build/manual/AC201_player_video24_spi6p25_diag.bit';assert sha(bit)==binding['bit_sha256']
package=ROOT/'deliverables/video24_spi6p25_diag_c11324_20261022';package.mkdir(exist_ok=True)
validation={'status':'DIAGNOSTIC_BOARD_PENDING','build_id':'00C11324','clock':'SD data SPI6.25MHz; initialization100kHz; system/pixel clocks unchanged','purpose':'Compare C23 cold mount timeout against slower SPI transfer','bit_sha256':sha(bit),'changed_from_c23':changed,'other_user_source_identical':len(old)-len(changed),'timing_ns':dict(zip(['setup_wns','setup_tns','hold_wns','hold_tns'],map(float,m.groups()))),'slice_used':slices,'slice_percent':slices/98,'routed_slices':counts,'physical':resources,'sd_phase_crc_test':{'status':'PASS','period_ns':160,'period_checks':35980,'phases':6,'cmd0_count_after_all':1,'crc_bad_before_negative':0,'crc_bad_after_one_bit_negative':1,'log_sha256':sha(sdlog)},'video_15fps_regression':{'status':'FAILED','reason':'decode missed 15fps content deadline at244ms','summary':str(system/'summary.json'),'log_sha256':sha(system/'console.log'),'prior_observations':'Two JPEG frames committed; original PCM matched until failure, no PCM mismatch reported'},'board_result':'Pending','audio_noise':'Unchanged audio/HDMI sources; original noise remains under investigation','full_stage_binding_sha256':sha(p/'verification/final_stage_binding.json')}
save(p/'verification/final_binding.json',validation);save(package/'validation.json',validation)
for target in [ROOT/'download/video24_spi6p25_diag.bit',package/'video24_spi6p25_diag.bit']:shutil.copy2(bit,target)
for n in ['canonical_crc_period_1875.csv','crc_period_metadata.json']:shutil.copy2(ROOT/'deliverables/video22_audio_diag_c11322_20261022'/n,package/n)
manual='''C11324 SPI 6.25MHz 独立对照版

位流：video24_spi6p25_diag.bit，版本页00C11324。
基于C11323，仅改变工作态SPI分频0→2（12.5→6.25MHz）与版本号；SD初始化仍100kHz。
保留C23扇区边界交接、目录/卡会话保持和C22音频观测。音频/JPEG/PLL/引脚/约束沿用。

测试目的：比较同TF/接线下，C23的冷启挂载E_TIMEOUT08能否随SPI速率变化。
TF媒体文件沿用，无需重导视频。
1. 加载后记录00C11324、以2开头状态页、紧接的SD CRC页。
2. 观察图片、声音、频谱能否启动；再做一次图片/视频/图片往返并记录读数。
3. 若仍仅UI，请保存完整一轮数码管读数；可回C11322对照。

离线结果：6相读卡排空/CRC单bit负控通过；35980个字节内SCLK周期均160ns。
15fps完整视频回归在244ms报解码截止时间失败，原失败保留。本版用于挂载/速率消融；视频迟帧属于本版已知结果。
C11325保持12.5MHz并删除SDHC流程中冗余CMD16，另行验证。
杂音仍在独立排查，C24音频算法保持；完整时序/资源/SHA见validation.json。
'''
(package/'操作说明.txt').write_text(manual,encoding='utf-8')
info={'build_id':'00C11324','bit_sha256':sha(bit),'purpose':validation['purpose'],'status':'DIAGNOSTIC_BOARD_PENDING','video_15fps_regression':'FAILED_DEADLINE','validation':str(package/'validation.json')}
save(package/'video24_spi6p25_diag.info.json',info);save(ROOT/'download/video24_spi6p25_diag.info.json',info)
files=[{'name':q.name,'bytes':q.stat().st_size,'sha256':sha(q)} for q in sorted(package.iterdir()) if q.is_file() and q.name!='receipt.json'];save(package/'receipt.json',{'build_id':'00C11324','files':files})
zpath=package.with_suffix('.zip')
with zipfile.ZipFile(zpath,'w',zipfile.ZIP_DEFLATED) as z:
 for q in sorted(package.iterdir()):
  if q.is_file():z.write(q,q.name)
with zipfile.ZipFile(zpath) as z:
 assert z.testzip() is None
 for row in files:assert hashlib.sha256(z.read(row['name'])).hexdigest()==row['sha256']
assert len({sha(bit),sha(ROOT/'download/video24_spi6p25_diag.bit'),sha(package/'video24_spi6p25_diag.bit')})==1
record={'status':'PASS_DIAGNOSTIC_DELIVERY','bit_sha256':sha(bit),'zip_sha256':sha(zpath),'zip_bytes':zpath.stat().st_size,'payloads':len(files)+1,'slice':slices,'slice_percent':slices/98,'timing_ns':validation['timing_ns'],'video_15fps_regression':'FAILED_DEADLINE'};save(p/'verification/delivery_receipt.json',record)
print(json.dumps(record,ensure_ascii=False,indent=2))
