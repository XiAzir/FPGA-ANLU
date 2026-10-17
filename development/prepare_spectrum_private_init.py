from pathlib import Path
import json, shutil, re
from datetime import datetime, timezone, timedelta

root=Path(__file__).resolve().parents[1]
old=root/'development/player_spectrum_baseline_phy'
new=root/'development/player_spectrum_private_init'
assert not new.exists(),'Do not replace candidate'
for name in ('src','scripts','sim'):
    shutil.copytree(old/name,new/name,ignore=shutil.ignore_patterns('__pycache__','*.db','*.vvp','AC201_tf_hdmi_Runs'))
for folder in ('scripts','sim'):
    for f in (new/folder).iterdir():
        if f.suffix in ('.ps1','.tcl','.py'):
            s=f.read_text(encoding='utf-8-sig').replace('player_spectrum_baseline_phy','player_spectrum_private_init')
            s=s.replace('gate eram_init on','gate eram_init off')
            # SYN-6562 about inherited FIFO initial values is expected with init off;
            # the new private ROM must instead be audited at primitive INIT level.
            s=s.replace('HDL-5105|SYN-6562','HDL-5105')
            f.write_text(s,encoding='utf-8')
al=new/'src/td_project/AC201_tf_hdmi.al'
s=al.read_text(encoding='utf-8-sig').replace('player_spectrum_baseline_phy','player_spectrum_private_init')
s=s.replace('Name="eram_init" Val="on"','Name="eram_init" Val="off"')
s=s.replace('<eram_init>on</eram_init>','<eram_init>off</eram_init>')
al.write_text(s,encoding='utf-8')
for name in ('top_tf_hdmi_audio.v','player_status_monitor.v'):
    f=new/'src/user_source/hdl_source'/name
    f.write_text(f.read_text(encoding='utf-8-sig').replace('C11305','C11306'),encoding='utf-8')
(new/'build/audit').mkdir(parents=True)
stamp=datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
failure={'createdBeijing':stamp,'version':'C11305','status':'FAILED_BOARD_VALIDATION',
 'reportedBy':'user','default':'UI/spectrum panel visible; no BMP/music; all LEDs off',
 'afterKEY1':'Monitor dark/no backlight/no signal; D3 blink, D2/D1/D0 on',
 'videoBefore':r'E:\QQ CACHE\LiaoTianJiLu\Tencent Files\1791081637\nt_qq\nt_data\Video\2026-10\Ori\4a35f0908e2f3e595ea59d8c21473468.mp4',
 'videoAfter':r'E:\QQ CACHE\LiaoTianJiLu\Tencent Files\1791081637\nt_qq\nt_data\Video\2026-10\Ori\561495ab9fdb4cc07ccd45366b2b91d6.mp4',
 'observedBefore':['DFC11305','1D97000A','33000000','6800FFFF','7800FFFF','98000000','A8000000','C800002C'],
 'observedAfter':['DFC11305','1D97000A','3B00BB80','prefix early_tone_abort=1'],
 'decode':'fs_ready=1/fs_error=0/display_valid=0/BMP error=1/WAV primed=0/WAV error=1/both file mappers error=1/WAV mapper 0A timeout. Default valid PCM=0; tone valid PCM=48000 nominal second and internal video locked/frame seen.',
 'limits':'No proof of unique electrical or synthesis root cause. Prefix flag8/count0 after tone is intentional early abort, not evidence of absent tone PCM.',
 'next':'C11306 local explicit coefficient ROM plus global eram_init off, preserve baseline PHY; implementation/verification underway'}
(old/'build/board_failure_20261013/feedback.json').write_text(json.dumps(failure,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for f in (root/'download/spectrum_baseline_phy.info.json',old/'build/manual/AC201_player_spectrum_baseline_phy.info.json'):
    v=json.loads(f.read_text(encoding='utf-8-sig'));v['boardStatus']='FAILED_BOARD_VALIDATION';v['boardFeedback']=failure
    f.write_text(json.dumps(v,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
docs=Path('E:/QQ CACHE/Download/安路资料/开发记录')
status=docs/'当前状态.md';s=status.read_text(encoding='utf-8-sig')
s=re.sub(r'^更新：.*$',f'更新：{stamp}（北京时间；C11305实板失败，C11306局部系数初始化修复进行中；成功基线C11206）。',s,count=1,flags=re.M)
s=s.replace('**C11305基线PHY恢复候选已本地交付，实板待验证**','**C11305实板失败，C11306局部系数初始化修复进行中**')
s=s.replace('唯一根因未确认、实板未验证、未操作JTAG/TF/Flash。','用户反馈默认UI有但BMP/WAV均无，长KEY1后无信号；视频DFC11305，1D97000A文件读取超时，默认PCM0、tonePCM48000/名义秒。模型/STA历史范围保留。唯一根因未确认，未操作JTAG/TF/Flash。',1)
s=s.replace('0. C11304实板失败且本次同条件回载C11206恢复；优先同条件加载新C11305 spectrum_baseline_phy.bit、确认DFC11305和默认音画，再长KEY1对比两音源。候选实板未验证。','0. C11305实板失败：默认媒体读取超时、切tone无信号；本地制作C11306将global eram_init恢复off并用局部显式系数ROM保持真实FFT，完成模型/初始化/TD验证后再交付；旧候选停止推荐。')
status.write_text(s,encoding='utf-8')
topic=docs/'专题记录/音频可视化/频谱柱_C11304_20261013/C11305_基线PHY恢复/README.md'
topic.write_text(f'''## {stamp} 实板失败修正

用户反馈默认UI清楚但IMG0/0、无BMP/音乐、LED全灭；长KEY1后无背光/无信号，D3闪其他灯常亮。两视频已抽帧：DFC11305，1D97000A对应mount ready/无FS错误、BMP/WAV与两mapper错误/WAV mapper超时0A；默认33000000有效PCM0，tone后3B00BB80有效PCM48000/名义秒且内部lock/frame有效。prefix flag8/count0是切tone前capture未完成的early abort，不能当tone输入缺失。唯一根因未确认，源码相同不证明新物理实现正常；C11305 live标FAILED，旧bit/ZIP/221冻结保持。

下一步C11306恢复global eram_init off，显式局部ROM初始化频谱系数并逐字验证；实现/编译/实板尚未完成。工程证据build/board_failure_20261013。原本地通过范围见历史下文。

'''+topic.read_text(encoding='utf-8-sig'),encoding='utf-8')
with (docs/'工作日志/2026-10-13.md').open('a',encoding='utf-8') as f:
    f.write(f'''\n### {stamp[11:16]}｜C11305实板失败与C11306局部初始化修复｜进行中

- 用户反馈默认仅UI，无BMP/天ノ弱音乐/LED全灭；长KEY1后无背光无信号，D3闪其他灯常亮。视频DFC11305、1D97000A文件映射timeout0A、默认PCM0；tone模式3B00BB80表示48000/名义秒和内部lock/frame。prefix flag8是early_tone_abort，不表示tone valid0。
- C11305 live FAILED，原bit/ZIP/221冻结不改。新player_spectrum_private_init C11306恢复global eram_init off，局部显式ROM仍在独立probe实现，保留C11206 PHY/其余播放链路。
- 尚未完成ROM证据/回归/编译/交付/板测，唯一根因未确认；未操作JTAG/TF/Flash。下一步证明off下系数有效，完成正式构建后交付候选。
''')
print(new)
