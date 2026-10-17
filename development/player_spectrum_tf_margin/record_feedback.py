from pathlib import Path
import json,re,hashlib
from datetime import datetime,timezone,timedelta

root=Path(__file__).resolve().parents[2]
old=root/'development/player_spectrum_observed'
stamp=datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
feedback={'createdBeijing':stamp,'version':'C11307','status':'FAILED_FULL_BOARD_VALIDATION_PARTIAL_PROGRESS',
 'reportedBy':'user','beforeKEY1':'WAV audible with noise; spectrum works; no BMP; IMG0/0; all four LEDs lit',
 'afterKEY1':'Internal scale clean and spectrum works; no BMP; D3 blinking other LEDs lit',
 'videoBefore':r'E:\QQ CACHE\LiaoTianJiLu\Tencent Files\1791081637\nt_qq\nt_data\Video\2026-10\Ori\cd666b5cefccf78a874d16cbae9fb2ab.mp4',
 'videoAfter':r'E:\QQ CACHE\LiaoTianJiLu\Tencent Files\1791081637\nt_qq\nt_data\Video\2026-10\Ori\b3824e0e3d42e88e235c67a6a26fe9eb.mp4',
 'observed':['DFC11307','1D980000','3300BB80 before','3B00BB80 after','6700F485','7700F485','8700F485','97000000','A7008000','B7000681->B70006B6 before','C7FE0000/C7FE0006 before','B7000512->B7000536 after','C7FE035F/C7FE036D after'],
 'decode':'Filesystem ready; BMP loader error; WAV primed; no filesystem or mapper errors. FFT frames advance; coefficients/frame/front-height flags latched. IMG0/0 is no-committed-frame OSD default, not proof catalog empty.',
 'crcScope':'Current probe SKIP_SAMPLES65536 + PREFIX32768, CRC F485 matches canonical60s WAV; old8s same window6ACD. PageA8000 is CRC sample count, not data offset; B/C repurposed for FFT.',
 'limits':'User clean tone confirms a narrower improvement, not complete HDMI/electrical validation or proof of TF fault. CRC window does not prove entire music or physical SD file hash.',
 'next':'C11308 TF SPI clock divisor2 (nominal6.25MHz vs12.5), passive sectorCRC counters, sticky exact BMP failure reason/mask; hardware cause unconfirmed.'}
(old/'build/board_feedback_20261014/feedback.json').write_text(json.dumps(feedback,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for f in (root/'download/spectrum_observed.info.json',old/'build/manual/AC201_player_spectrum_observed.info.json'):
    v=json.loads(f.read_text(encoding='utf-8-sig'));v['boardStatus']=feedback['status'];v['boardFeedback']=feedback
    f.write_text(json.dumps(v,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
docs=Path('E:/QQ CACHE/Download/安路资料/开发记录')
status=docs/'当前状态.md';s=status.read_text(encoding='utf-8-sig')
s=re.sub(r'^更新：.*$',f'更新：{stamp}（北京时间；C11307频谱/内置音阶用户反馈正常，BMP失败/真实音乐杂音；C11308 TF读余量/精确失败观测进行中，成功基线C11206）。',s,count=1,flags=re.M)
s=s.replace('**C11307 ROM读控制/ODDR准备沿/被动频谱诊断候选已本地交付，实板待验证**','**C11307完整板测失败，但频谱和内置音阶获正常反馈**')
s=s.replace('实板白点/杂音/默认WAV/频谱与唯一因果未确认','2026-10-14用户反馈两音源频谱正常、内置音阶干净；BMP无图/IMG0/0、WAV杂音。视频DFC11307/1D980000定位BMP loader error，无mapper/fs/WAV错误；FFT帧数增长、FE状态。音乐校验仅跳过65536后32768样本窗口三端F485匹配60秒素材，非整曲。唯一因果未确认')
s=re.sub(r'^0\. 优先同条件加载C11307.*$', '0. C11307完整板测未通过；C11308隔离降低TF SPI速度并增加扇区CRC和BMP精确失败诊断，先验证/TD后交付。频谱/音阶已有正常反馈，不再重复要求旧版回载；C11206成功基线不变。',s,count=1,flags=re.M)
status.write_text(s,encoding='utf-8')
topic=docs/'专题记录/音频可视化/频谱柱_C11304_20261013/C11307_ROM读控制与ODDR诊断/README.md'
topic.write_text(f'## {stamp} 实板反馈修正\n\n用户反馈默认WAV有杂音/无图但频谱正常，长KEY1后内置音阶和频谱正常/仍无图。视频DFC11307、1D980000（挂载ready、BMP loader error、WAV primed，无fs/mapper/WAV error），FFT帧数持续增长、C=FE。完整板测失败；音阶/频谱部分通过用户反馈。CRC F485三端匹配当前60秒素材跳过65536后32768样本窗口；A8000是捕获样本数，不是data offset。历史首32768措辞不适用于当前探针。IMG0/0是未提交首帧OSD默认，不能证明目录无BMP。现存live元数据更新，原bit/ZIP/281冻结保持。下一版降低TF读取频率并补扇区CRC/BMP首错详情，具体物理根因未确认。\n\n'+topic.read_text(encoding='utf-8-sig'),encoding='utf-8')
print('C11307 live failure and evidence recorded; immutable delivery preserved')
