from pathlib import Path
import shutil,json,re
from datetime import datetime,timezone,timedelta

root=Path(__file__).resolve().parents[1]
old=root/'development/player_spectrum_private_init'
new=root/'development/player_spectrum_observed'
assert not new.exists()
for name in ('src','scripts','sim'):
    shutil.copytree(old/name,new/name,ignore=shutil.ignore_patterns('__pycache__','*.db','*.vvp','AC201_tf_hdmi_Runs'))
for folder in ('scripts','sim'):
    for f in (new/folder).iterdir():
        if f.suffix in ('.ps1','.tcl','.py'):
            f.write_text(f.read_text(encoding='utf-8-sig').replace('player_spectrum_private_init','player_spectrum_observed'),encoding='utf-8')
al=new/'src/td_project/AC201_tf_hdmi.al'
al.write_text(al.read_text(encoding='utf-8-sig').replace('player_spectrum_private_init','player_spectrum_observed'),encoding='utf-8')
for name in ('top_tf_hdmi_audio.v','player_status_monitor.v'):
    f=new/'src/user_source/hdl_source'/name
    f.write_text(f.read_text(encoding='utf-8-sig').replace('C11306','C11307'),encoding='utf-8')
(new/'build/audit').mkdir(parents=True)
for name in ('audit_private_rom_init.py','export_routed_rom.tcl'):
    shutil.copyfile(old/'build/audit'/name,new/'build/audit'/name)
stamp=datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
feedback={'createdBeijing':stamp,'version':'C11306','status':'FAILED_BOARD_VALIDATION','reportedBy':'user',
 'beforeKEY1':'No picture/no sound','afterKEY1':'Picture with flickering bright pixels, internal tone with noise, spectrum does not react; image/manual/auto/brightness/contrast work',
 'rollback':'User reports older bitfiles normal',
 'videoBefore':r'E:\QQ CACHE\LiaoTianJiLu\Tencent Files\1791081637\nt_qq\nt_data\Video\2026-10\Ori\6883c6541db017379e652daba0542130.mp4',
 'videoAfter':r'E:\QQ CACHE\LiaoTianJiLu\Tencent Files\1791081637\nt_qq\nt_data\Video\2026-10\Ori\9b59c3867f05d441152c8190928a63b8.mp4',
 'observed':['DFC11306','1D880000','3300BB80 before','3B00BB80 after','6700F485','7700F485','8700F485','97000000','A7008000'],
 'decode':'WAV PCM prefix at source/FIFO/HDMI input matches F485, flags7; nominal48000 samples/second in both modes, format_bad0, no mapper error. Read timeout from C11305 not present.',
 'limits':'Input CRC covers first32768 WAV samples only, not HDMI serial packets, later sound or internal tone correctness. ROM INIT audit did not check actual board read values; spectrum stage still unknown.',
 'next':'C11307 narrow ODDR preparation edge change plus passive spectrum telemetry; ROM read audit in progress; preserve old artifacts.'}
(old/'build/board_failure_20261013/feedback.json').write_text(json.dumps(feedback,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for f in (root/'download/spectrum_private_init.info.json',old/'build/manual/AC201_player_spectrum_private_init.info.json'):
    v=json.loads(f.read_text(encoding='utf-8-sig'));v['boardStatus']='FAILED_BOARD_VALIDATION';v['boardFeedback']=feedback
    f.write_text(json.dumps(v,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
docs=Path('E:/QQ CACHE/Download/安路资料/开发记录')
status=docs/'当前状态.md';s=status.read_text(encoding='utf-8-sig')
s=re.sub(r'^更新：.*$',f'更新：{stamp}（北京时间；C11306实板失败，C11307窄范围ODDR/频谱诊断进行中；成功基线C11206）。',s,count=1,flags=re.M)
s=s.replace('**C11306局部系数初始化候选已本地交付，实板待验证**','**C11306实板失败，禁止作为成功版**')
s=s.replace('唯一实物根因未确认、实板未验证，未操作JTAG/TF/Flash。','用户反馈默认无音画，tone有图/闪点/带杂音、频谱不动；视频DFC11306、默认/tone 48000 PCM，源/FIFO/HDMI输入前缀F485/flag7且无读取/格式错误。C11305超时本版未见；输出端与实际FFT阶段待隔离。唯一实物根因未确认，未操作JTAG/TF/Flash。',1)
s=re.sub(r'^0\. 优先同条件加载C11306.*$', '0. C11306停止推荐；C11307仅调整ODDR两位准备沿，保持基线pixel marker/wrapper，并补被动FFT/系数/显示诊断；先完成独立串行矩阵、ROM审计和模型/原约束TD后交付。',s,count=1,flags=re.M)
status.write_text(s,encoding='utf-8')
topic=docs/'专题记录/音频可视化/频谱柱_C11304_20261013/C11306_局部系数初始化/README.md'
topic.write_text(f'## {stamp} 实板失败修正\n\n用户反馈默认无音画；长KEY1后有图/闪点、内置音阶伴杂音、频谱不动，翻页/轮播/亮度对比度正常，旧文件回载正常。视频DFC11306、1D880000，默认3300BB80/tone3B00BB80，源/FIFO/HDMI前缀均F485/flag7，格式错误0，读取超时未见。支持把当前问题定位到PCM输入之后及未观测的频谱阶段，但未证明唯一根因。live FAILED，原bit/ZIP/232冻结不改。后续C11307只改ODDR准备沿并补被动频谱诊断，正在本地审计/实现，尚未交付。\n\n'+topic.read_text(encoding='utf-8-sig'),encoding='utf-8')
with (docs/'工作日志/2026-10-13.md').open('a',encoding='utf-8') as f:
    f.write(f'\n### {stamp[11:16]}｜C11306实板失败与定点隔离｜进行中\n\n- 用户反馈默认无音画，tone有图/闪点/杂音、频谱空；原控制功能正常，旧文件回载正常。两视频DFC11306、48000样本/名义秒、三端前缀F485/flag7、badformat0、无读取错误；前缀仅证明32768 WAV输入样本，不证明TMDS/tone/后续内容。\n- C11306 live FAILED，旧位流/ZIP/232快照不改。新C11307 spectrum_observed只拟改ODDR准备沿、保留baseline pixel marker/wrapper，补FFT/ROM/显示被动诊断。两luna独立审计ROM读路径及最小ODDR变体。\n- 未完成：源码/模型/TD/交付/板测，唯一根因未确认。未操作JTAG/TF/Flash。下一步完成证据再交付。\n')
print(new)
