from pathlib import Path
from datetime import datetime, timezone, timedelta
import json, hashlib, shutil

project=Path('E:/VSCODE-project/FPGA-ANLU')
root=project/'development/player_dynamic_text_pcm_bram_candidate'
work=Path(__file__).resolve().parent
docs=Path('E:/QQ CACHE/Download/安路资料/开发记录')
archive=docs/'专题记录/OSD状态显示/同步BRAM实板通过与原因证据_20261012'
archive.mkdir(parents=True,exist_ok=True)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest().upper()
def dump(p,v): p.write_text(json.dumps(v,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
stamp='2026-10-12 '+datetime.now(timezone(timedelta(hours=8))).strftime('%H:%M:%S')
pages={'1':'1DA80000','3':'3300BB80','6':'6700F485','7':'7700F485','8':'8700F485',
       '9':'97000000','A':'A7008000','B':'B702002D','C':'C700002C','D':'DFC11109'}
frames={'1':1,'3':4,'6':8,'7':12,'8':16,'9':20,'A':24,'B':28,'C':32,'D':36}
origins={'before':'aae394d1427c6a5535dc3a6d1bbd6e78.mp4','after':'f97e07aada50f57f12de45be14a79246.mp4'}
videos=[]
for mode,name in origins.items():
    source=Path('E:/QQ CACHE/LiaoTianJiLu/Tencent Files/1791081637/nt_qq/nt_data/Video/2026-10/Ori')/name
    dest=archive/mode
    dest.mkdir(exist_ok=True)
    shutil.copy2(source,dest/'board_video.mp4')
    assert sha(source)==sha(dest/'board_video.mp4')
    videos.append({'mode':mode,'origin':str(source),'archive':str(dest/'board_video.mp4'),
        'bytes':source.stat().st_size,'sha256':sha(source),
        'durationSeconds':19.833289 if mode=='before' else 19.866700})
    for page,n in frames.items():
        shutil.copy2(work/mode/'frames'/f'{n:03}.png',dest/f'page_{page}.png')
    shutil.copy2(work/mode/'key_pages.png',dest/'key_pages.png')

bit=project/'download/pcm_bram_candidate.bit'
assert sha(bit)=='A5F2C25BA1F65B05051419093BC78EC2DD05E510502D914450DD77673CB7E0C0'
feedback={'recordedBeijing':stamp,'clientDate':'2026-10-12','version':'C11109',
    'boardStatus':'PASS_REPORTED_FUNCTIONS_AND_PCM_WINDOW',
    'reportedByUser':{'image':'normal','key0Manual':'normal','key1Auto':'normal','defaultMusic':'normal','internalTone':'normal'},
    'pages':{'before':pages,'after':{**pages,'3':'3B00BB80'}},
    'decode':'Assistant manual full-frame/contact-sheet seven-segment reading at fps2; all 10 pages present in both videos.',
    'selectedFramesAtFps2':frames,'videos':videos,'localBitSha256':sha(bit),
    'remoteBitHashIndependentlyRead':False,
    'referenceMusicSha256':'D5244FD3935052A743379D9331EE78109C8A913241ED60DE472CB9E34A17FECF',
    'comparison':{'C11108':{'push':'F485','pop':'D2D6','hdmiInput':'D2D6'},'C11109':{'push':'F485','pop':'F485','hdmiInput':'F485'}},
    'interpretation':'Observed FIFO/output CRC divergence disappeared after synchronous BRAM sample-storage rewrite, concurrent with user-reported audio/image recovery. Strong evidence for FIFO-related implementation/sampling/sequence boundary; not proof of unique physical failure mechanism or common cause for all historic failures.',
    'limits':['CRC16 can collide; only 32768-sample window after skip65536, not whole music/long-run validation.',
              'After-KEY1 CRC values are frozen prior WAV capture, not independent tone CRC.',
              'Changed implementation also changes synthesis/place/route; no pin-level capture and no first erroneous sample ordinal from old hardware.',
              'Display and listening outcomes come from user; board-only videos do not independently show every image or key action.',
              'No fresh remote TF hash or hardware action by assistant.']}
dump(work/'feedback.json',feedback)
dump(archive/'feedback.json',feedback)
for item in (project/'download/pcm_bram_candidate.info.json',root/'build/manual/AC201_player_dynamic_text_pcm_bram_candidate.info.json'):
    info=json.loads(item.read_text(encoding='utf-8-sig'))
    assert info['version']=='C11109' and info['bitSha256']==sha(bit)
    info['boardStatus']=feedback['boardStatus']
    info['boardFeedbackBeijing']=stamp
    info['boardFeedback']=str(archive/'feedback.json')
    info['rootCause']='FIFO_BOUNDARY_SUPPORTED_PHYSICAL_MECHANISM_UNCONFIRMED'
    dump(item,info)

summary=f'''# C11109同步BRAM实板通过与原因证据

记录：{stamp}（北京时间，日期按客户端2026-10-12）。用户报告画面、KEY0切图、KEY1轮播、天之弱音乐、内部音阶全部正常。数码管两视频全10页已人工核验，版本均DFC11109。

| 观测点 | C11108失败 | C11109通过 | 意义 |
| --- | --- | --- | --- |
| WAV字节组成样本，实际FIFO push | F485 | F485 | 所选窗口在写入端均与本机素材匹配 |
| FIFO实际pop | D2D6 | F485 | 改为同步BRAM后消费窗口校验恢复 |
| HDMI核输入高16位 | D2D6 | F485 | 下游跟随消费端；新窗口三段一致 |

两视频页1=1DA80000；页3默认3300BB80、tone3B00BB80；页6/7/8=6700F485/7700F485/8700F485；页9=97000000；A=A7008000；B=B702002D；C=C700002C；D=DFC11109。flags7表示三段完成且无早切tone；32768样本、源高字节位置131117、data_offset44正确。KEY1后的CRC是此前WAV冻结结果，不是tone内容CRC。听感和图像/按键结果来自用户反馈，不伪称代理实测。

## 实际改动与证据强度

C11108→C11109仅WAV样本FIFO改独立同步RAM读写过程、无reset读输出、注册同址旁路；top/status仅版本号变化，其余user_source逐文件哈希相同。同址旁路在旧逻辑已有，新版明确了同步BRAM与旁路输出时序，不能声称旧版完全没有旁路。TD实际综合网表确认四个EG_PHY_BRAM DP8K/2048×4，全工程BRAM19→23，LUT16825→12128；原约束最终SWNS+0.660/HWNS+0.014ns/TNS0/coverage99.95%。原WAV/异步bridge流水线/CRC/页面模型、新旧有效输出与软件队列(256/2048)均通过，旧模型未复现硬件错误。

本轮最强结论：旧实板固定样本窗口的异常首次出现在FIFO消费观测端；规范同步BRAM实现后，三段CRC及用户听感同时恢复。由此强烈支持FIFO存取/头预取/采样/序列及其综合实现为本轮音频问题的主要故障区域，并已取得当前功能修复效果。

尚不能指定某个坏寄存器、某拍必然错字、RAM位翻转、同址冲突或某条布局线为唯一物理原因；旧版没有pop端绝对ordinal，CRC不等可能是错值或先前丢/重样导致窗口错位。三路CRC16相等也不是逐样本物理波形证明。成功osd_phy_fix同样存在旧大型读取选择网络，所以不能说该结构必然失败。RTL、综合优化和整体布线共同变化，图像恢复不能由音频CRC单独证明；历次无信号尚未独立抓取PHY波形，不能全部归到FIFO。

## 历史故障分别判断

- RGB888早期红变绿/竖向点带：工程证据支持SDRAM返回数据与读FIFO valid错拍，保存数据一拍后配原valid解决；颜色相位计算、失败方向对照、逐字模型与用户上板闭环支持。最底层DQ/时钟相位未实测。见[排查路线](../../RGB888紧凑帧缓存/排查路线与结论.md)。
- OSD首版整图花屏/静音：HDMI串行器捕获靠近下一像素更新边沿的混字机制在延迟模型复现；提前一个串行周期锁存完整10bit后模型无错、上板恢复。模型机制有证据，真实板级唯一根因尚未直接波形证明。见[串行器记录](../串行器采样修查_20261009.md)。
- FAT32早期固定乱码/静音和动态字幕底图竖线、无信号：各版本成功/失败对照保留，部分仍没有唯一根因证据。本次不能追溯认定全部同因。

## 封存、边界与下一步

新通过位流local SHA256 {sha(bit)}，629624字节。原139文件candidate checkpoint及20261011 ZIP保持构建时PENDING历史，不覆盖。live info按本次证据标PASS_REPORTED_FUNCTIONS_AND_PCM_WINDOW，成功回退osd_phy_fix继续保留。原始两视频、全帧page图片、手工页值与哈希见本目录feedback.json；工程副本见build/board_feedback_20261012。

本次未写TF/Flash，未连本机JTAG，未新综合/生成位流。未完成整曲逐样本、长期/多次冷启动/碎片/换文件回归；根因说明中的物理边界保留。下一步以C11109作已通过的开发基线，集中做持续循环与切图并发回归；进一步追因可用带ordinal标记的旧版FIFO逐样本比较，但尚未实施。
'''
(archive/'README.md').write_text(summary,encoding='utf-8')

# New verified snapshot; retain the original candidate and package byte-for-byte.
old=root/'checkpoints/pcm_bram_candidate_20261011_candidate'
manifest=json.loads((old/'manifest.json').read_text(encoding='utf-8-sig'))
new=root/'checkpoints/pcm_bram_20261012_verified'
new.mkdir(exist_ok=False)
for entry in manifest:
    source=old/entry['path']
    assert sha(source)==entry['sha256']
    dest=new/entry['path']
    dest.parent.mkdir(parents=True,exist_ok=True)
    shutil.copy2(source,dest)
    assert sha(dest)==entry['sha256']
live_info=root/'build/manual/AC201_player_dynamic_text_pcm_bram_candidate.info.json'
shutil.copy2(live_info,new/live_info.relative_to(root))
shutil.copy2(work/'feedback.json',new/'board_feedback.json')
(new/'BOARD_VERIFIED.md').write_text(summary,encoding='utf-8')
new_manifest=[{'path':p.relative_to(new).as_posix(),'bytes':p.stat().st_size,'sha256':sha(p)} for p in sorted(new.rglob('*')) if p.is_file()]
dump(new/'manifest.json',new_manifest)
receipt={'checkpoint':str(new),'filesVerified':len(new_manifest),'manifestSha256':sha(new/'manifest.json'),
         'boardStatus':feedback['boardStatus'],'scope':'Reported functions and fixed PCM window, not long-run/whole-file/PHY validation'}
dump(work/'verified_checkpoint.json',receipt)

note=f'''\n\n### {stamp}（北京时间）｜C11109实板功能与PCM窗口通过｜完成反馈核验/封存/原因说明

- 用户反馈画面/KEY0切图/KEY1轮播/真实音乐/内部tone全部正常；两视频全10页人工解码，版本DFC11109、默认/tone页3为3300BB80/3B00BB80。三段CRC均F485、flags7、32768样本/首字节位置/数据偏移正确，格式错0；tone后CRC是先前WAV冻结结果。
- 对照C11108 sourceF485/pop及HDMI输入D2D6，C11109三处均F485；同步BRAM改写后数据观测和用户听感一起恢复，强支持FIFO相关实现/采样/序列边界。尚未定位唯一物理机制或证明历次无信号同因；错值与ordinal错位仍不能逐点区分。
- 无RTL改动/新构建/TF或Flash操作。live info更新PASS_REPORTED_FUNCTIONS_AND_PCM_WINDOW；新{len(new_manifest)}文件verified checkpoint={new}，manifest SHA {receipt['manifestSha256']}；旧139文件candidate/ZIP冻结。新成功开发基线C11109 SHA {sha(bit)}，osd_phy_fix保留回退。
- 证据/完整原因分级：[同步BRAM实板通过与原因证据](../专题记录/OSD状态显示/同步BRAM实板通过与原因证据_20261012/README.md)。原视频/关键全帧/哈希已归档，用户现场结果与代理视频读取分开注明。
- 未完成：长期/多次冷启动/整曲/换文件碎片测试、板级PHY/首个错误样本定位；下一步基于已通过C11109做集中持续循环+切图回归，再继续开发。无需重录当前页面。
'''
log=docs/'工作日志/2026-10-12.md'
if not log.exists():log.write_text('# 2026-10-12 工作日志\n',encoding='utf-8')
with log.open('a',encoding='utf-8') as out:out.write(note)
state=docs/'当前状态.md'
s=state.read_text(encoding='utf-8-sig')
lines=s.splitlines()
lines[2]=f'更新：{stamp}（北京时间；XiAzir；C11109实板所反馈功能/PCM窗口通过，新成功基线）。'
s='\n'.join(lines)+'\n'
start=s.index('**C11108实板无信号')
end=s.index('\n\n',start)
current=f'''**2026-10-12 C11109同步BRAM版实板通过（用户反馈）：图片、KEY0、KEY1自动、天之弱音乐与内部音阶均正常。两视频全部10页人工核验，DFC11109、三段CRC均F485/flags7/32768样本、位置与格式检查正确；KEY1后CRC为此前WAV冻结值。C11108原sourceF485而pop/核输入D2D6，改同步BRAM后观测/听感同恢复，强支持FIFO相关实现/采样/序列边界；唯一物理根因及历次无信号同因仍未证实。C11109 live info标PASS_REPORTED_FUNCTIONS_AND_PCM_WINDOW，新{len(new_manifest)}文件verified checkpoint留档，旧139文件candidate/ZIP不改。新成功开发基线download/pcm_bram_candidate.bit SHA {sha(bit)}；osd_phy_fix继续回退。未新构建/写TF或Flash；长期/冷启动/整曲/碎片回归未完成，下一步集中持续循环+切图回归，无需再录同页。见[本轮通过与原因证据](专题记录/OSD状态显示/同步BRAM实板通过与原因证据_20261012/README.md)。**'''
s=s[:start]+current+s[end:]
state.write_text(s,encoding='utf-8')
with (docs/'专题记录/OSD状态显示/PCM校验FIFO分歧与无信号_20261011/README.md').open('a',encoding='utf-8') as out:
    out.write(f'\n\n2026-10-12后续：C11109用户所反馈全部功能通过，三段CRC都F485，版本DFC11109。原C11108失败结论不改；原因证据与范围见[新通过记录](../同步BRAM实板通过与原因证据_20261012/README.md)。\n')
with (root/'README.md').open('a',encoding='utf-8') as out:
    out.write(f'\n\n{stamp}状态更新：用户报告图像/KEY0/KEY1轮播/WAV/tone正常，两视频确认三CRC=F485/flags7/DFC11109。live info为PASS_REPORTED_FUNCTIONS_AND_PCM_WINDOW，新verified checkpoint={new.name}。当前可用作成功开发基线，原candidate/ZIP保留PENDING历史。根因唯一物理机制未确认，长期/整曲/碎片未验证。\n')
print(json.dumps({'feedback':str(archive/'feedback.json'),'verified':receipt},ensure_ascii=False,indent=2))
