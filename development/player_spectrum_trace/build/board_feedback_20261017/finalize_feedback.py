"""Record actual feedback and completed bounded verification, not a release."""
from pathlib import Path
from datetime import datetime,timezone,timedelta
import json,hashlib,shutil,re

p=Path(__file__).resolve().parent
root=p.parents[3]
doc=Path('E:/QQ CACHE/Download/安路资料/开发记录/专题记录/音频可视化/频谱柱_C11304_20261013/C11312_实板反馈_20261017')
now=datetime.now(timezone(timedelta(hours=8)))
logs={
 'display_pins':p/'display_cone/console.log',
 'display_sdf':p/'display_sdf/console.log',
 'upstream_version':p/'upstream_version/console.log',
}
texts={k:v.read_text(errors='replace') for k,v in logs.items()}
assert 'PASS routed_display_pins cases=44 digit_checks=352 detected_injected_errors=1' in texts['display_pins']
assert 'PASS sdf_display_fixed digit_checks=8' in texts['display_sdf']
assert 'display_mailbox_words=8 includes_DFC11312=1' in texts['upstream_version']
assert all('# FAIL' not in x for x in texts.values())
bit=root/'download/spectrum_trace.bit'
sha=lambda f:hashlib.sha256(f.read_bytes()).hexdigest()
assert sha(bit)=='60ae6b971ce1f9ed09d76bec14cf88dfc25cdfe7cbbebe5dd9fc070115b812ce'
result={
 'recorded':now.isoformat(), 'status':'FAILED_BOARD_VIDEO_AUDIO_AND_TELEMETRY',
 'board_feedback_source':'User reports and preserved videos; no hardware operated by agent.',
 'reported':['image green/color bands','spectrum empty','playing audio has noise','baseline reload normal'],
 'observed_fixed_version_word':'5FC11312', 'expected_fixed_version_word':'DFC11312',
 'raw_snapshot_decodable':False,'root_cause_confirmed':False,
 'hardware_location':'Laboratory with classmate; user at home, no local board/JTAG access.',
 'agent_operations':'Video decoding, source/PLL parameter comparison, bounded ModelSim tests, file hashes only. No production RTL/bit/ZIP modification or new build.',
 'simulation':{
  'display_pins':{'cases':44,'digit_checks':352,'negative_control_errors_detected':1,'primitives':101,'pads':3,'sdf':False},
  'display_sdf':{'fixed_word':'DFC11312','digit_checks':8,'sdf_annotation_succeeded':True,'negative_limits_zeroed':38,
                 'scope':'Extracted cone with original retained delays, ideal clock/reset/input boundaries; external 595 electrical behavior excluded.'},
  'upstream_version':{'full_routed_top':True,'mailbox_words':8,'version_word':'DFC11312',
                      'scope':'Controlled forced page selector copies, PLL-ready/fast startup/tone and observation fault injection; not natural board startup.'},
 },
 'logs':{k:{'path':str(v),'sha256':sha(v)} for k,v in logs.items()},
 'next':'First compare the exact laboratory programming file hash and BitWriter operation/result log. If identical, obtain an independent live hardware observation (595 serial waveform or suitable JTAG capture); do not decode corrupted page words or issue a speculative repair bit.'
}
(p/'verification_result.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
(doc/'verification_result.json').write_bytes((p/'verification_result.json').read_bytes())
for src,name in [(p/'before_key1/digits_017.5.png','version_word_17p5.png'),
                 (p/'display/frame_002.00.png','display_2s.png'),
                 (p/'check_lab_bit.ps1','check_lab_bit.ps1')]:
    shutil.copyfile(src,doc/name)
readme='''# C11312 2026-10-17 实板反馈

本版实板异常，根因未定。用户在家远程开发，板卡在实验室同学处；本机未操作硬件。

## 现场证据

- `before_key1.mp4`、`after_key1.mp4`、`display.mp4` 是用户原视频的逐字节副本，SHA/时长/原路径见 `video_manifest.json`。
- 用户反馈：画面有绿色条带、频谱无柱、音频播放有噪音；回载基线正常。本轮不再重复要求基线对照。
- 父代理抽帧确认显示屏彩色条纹/方格、黑白UI及空频谱。杂音仅为用户反馈，未直接听取或量化。
- KEY1前17.5秒及后续重复轮次的固定版本页显示 `5FC11312`，源码应为 `DFC11312`，见 `version_word_17p5.png`。其他固定页头也改变：B→3、C→4、A→2、9→1、8→0，部分有效标志8→9，并有多处280000字段。不能只补回bit31后解码。
- `raw_transcription.json` 保存原始八位字、秒数和严格解码器的拒绝结果。它们不能当作可信FFT内部状态。KEY1后部分裁切/字形不确定，不强行拼成七页有效快照。

## 本机核查结果与边界

1. 595驱动、跨时钟邮箱与C11309/C11310对应RTL字节一致；未见新的译码/端序改动。C11312 routed两PLL的全部显式参数与C11309 routed、C11206 gate相同；这不证明板上实际时钟/抖动正常。
2. 从C11312最终routed网表提取邮箱destination至三根595引脚的闭合依赖锥：101个原厂原语（含3 PAD），未重新综合或替换算术。逐位闭合无未解析观察输入；共包但未观察的另一lane可悬空，外部边界的共包输出断至dummy。理想50MHz、全局reset副本和32位数据是测试输入，不含上游实际启动/时钟生成。
3. ModelSim SE-64 10.1c，原厂EG4模型与独立glbl，-novopt。43组正常向量（版本、全8、自检、七快照字、32位walking-one）及1组串行翻位负对照，总352位校验；正常零错误，负对照恰检出1错。未缩短生产扫描/移位分频，不force下游寄存器。
4. 同一最终物理DB只读导出SDF，保留101个cell、489项内部/输出连线和150项输入边界连线的原始延时。SDF成功反标，固定DFC11312八位正确；38项负时序限被ModelSim置零，因此只算有边界的延时测试，不是完整STA/SDF或电气验证。SDF日志沿用TB通用的“no SDF”旧banner；实际启用与成功反标以vsim -sdfmax命令及加载记录为准，后者确实使用SDF。
5. 完整C11312 routed顶层另补D页：七个快照字及DFC11312均正确到destination_hex。沿用受控PLL ready、快速启动、切tone/观察总线故障注入，以及全部page重复Q的force；未复现自然启动现场。

日志、提取/复跑脚本及机器结果在工程 `development/player_spectrum_trace/build/board_feedback_20261017/`。`verification_result.json`记录结果和日志SHA。

## 下一步：实验室先核文件和下载日志

暂不换bit或重复录相同页。请同学在实验室电脑检查**BitWriter实际下载的那份文件**，不要拿另一份包里的文件代替：

```powershell
.\\check_lab_bit.ps1 -BitPath '实际下载的 spectrum_trace.bit 完整路径'
```

脚本只读文件，输出路径、大小、SHA及是否匹配C11312；不连接设备、不烧录，也不验证芯片内配置。预期634280字节，SHA256 `60AE6B971CE1F9ED09D76BEC14CF88DFC25CDFE7CBBEBE5DD9FC070115B812CE`。

同时保留该次BitWriter完整窗口/下载日志（所选文件、器件、PROGRAM_SRAM、JTAG频率、成功或错误信息）。若文件/下载一致，下一步需要独立于当前损坏显示链的现场观察，例如现有C11312的DIO/SCLK/RCLK逻辑分析仪采集，或经验证可用的JTAG内部采集。当前未确认实验室具备相应仪器/远程访问，不把这些操作写成已执行。

本轮未改生产RTL、旧bit/ZIP或冻结检查点，未发布新bit。诊断数据损坏可能来自上游数据、实现/配置、时序或外部传输，不能据本轮仿真宣称已排除或确定其中某项。
'''
(doc/'README.md').write_text(readme,encoding='utf-8')
info_path=root/'download/spectrum_trace.info.json'
info=json.loads(info_path.read_text(encoding='utf-8'))
info['status']=result['status'];info['board_feedback_20261017']=result
info['limits']='User board feedback on 2026-10-17 is abnormal, including corrupted fixed display words. No hardware operated by agent. Bounded local tests pass but do not reproduce the board fault. No confirmed repair or complete timing/electrical verification.'
info_path.write_text(json.dumps(info,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
log=Path('E:/QQ CACHE/Download/安路资料/开发记录/工作日志/2026-10-17.md')
with log.open('a',encoding='utf-8') as f:
    f.write(f'''\n### {now:%H:%M}｜C11312显示链补验及远程现场安排｜本机阶段完成，实板根因未定\n\n- 原厂101原语（含3 PAD）最终routed显示锥，43正常向量+1串行翻位负对照共352位校验PASS，负对照检出恰1错；独立SDF固定版本八位PASS（38负时序限置零，非完整时序验证）；完整routed顶层补D页至邮箱，8字PASS。两PLL显式参数与C11309 routed/C11206 gate相同，不代表物理时钟已测。详细边界、脚本及日志SHA见工程board_feedback_20261017/verification_result.json和资料同名专题README。\n- 用户确认板卡不在本机，在实验室同学处，自己在家远程开发。已准备只读check_lab_bit.ps1并用本机交付bit验证匹配；下一步同学对实际下载文件校验SHA并保留BitWriter完整日志，先排文件/下载差异，不重复录旧页或猜测性换版。若一致，需要独立595波形/可用JTAG现场观测，仪器/远程访问尚未确认。\n- 更新live download/spectrum_trace.info.json为FAILED_BOARD_VIDEO_AUDIO_AND_TELEMETRY；原bit/ZIP/冻结未改，生产RTL未改，无构建/硬件操作。根因仍未定，快照仍拒绝解码。本轮新增证据留本地，未自动继续推Git。\n''')
print(json.dumps({'status':result['status'],'bit_unchanged':sha(bit),'doc':str(doc)},ensure_ascii=True))
