from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo
import hashlib
import json

root=Path(__file__).resolve().parent.parent
docs=Path('E:/QQ CACHE/Download/安路资料/开发记录')
now=datetime.now(ZoneInfo('Asia/Shanghai'))
topic=docs/'专题记录/OSD状态显示/节奏诊断实板失败_20261011/ChipWatcher准备_20261011.md'
scope=json.loads((root/'build/manual/build_source_scope.json').read_text(encoding='utf-8-sig'))
for item in scope:
    actual=hashlib.sha256((root/'src'/item['path']).read_bytes()).hexdigest()
    assert actual.lower()==item['sha256'].lower(), item['path']
syn=(root/'build/manual/synthesis_console.log').read_text(encoding='utf-8',errors='replace')
phy=(root/'build/manual/physical_console.log').read_text(encoding='utf-8',errors='replace')
assert 'SYNTHESIS_COMPLETE_WITH_GATE_DATABASE' in syn and ' ERROR:' not in syn
assert 'ppm.cpp, line 610' in phy
assert not list((root/'build/manual').glob('*.bit'))
result=f'''
## {now:%H:%M} 最终阶段状态：综合通过，物理流程退出，未交付

- 顶层 source-IP 版本完整综合已通过，最终日志无 TD ERROR；16580 LUT、8044寄存器、23 BRAM9K。{len(scope)} 个综合输入文件的 SHA256 重新复核一致。此前失败的综合输出不作通过证据。
- 完整工程 physical 在 `arch/ppm.cpp:610` 断言退出，与独立小模型同位置；保留 `build/manual/physical_console.log`。未完成布局布线、setup/hold 或 bitgen。没有新的板测位流，不能交给用户下载。
- gate 导出中仍有调试 hub 的逻辑层实例，配置导出为空；追加的配置/compile_watcher 离线检查也未得到有效 CWC。尚不能区分当前 source-IP 命令行集成方式问题与工具问题，不直接认定 EG4 不支持，也不能用本轮现象解释原 HDMI 故障。
- 顶层放置使先前 KIT-8466 消失，是本次实测；手册未找到必须顶层例化的明确限制。数据/触发/clock 连接、4处用户源码差异经独立只读核查；status_hex595原连接未改。
- 构建状态在工程 `build/status.json`；所有本轮编译进程已结束，未保留后台构建。原 osd_phy_fix/cadence_probe 下载文件哈希复核不变。
- 下一步：先用 TD 原生 GUI 生成/核对配套 ChipWatcher 配置，或确认调试 hub 的完整物理映射流程，再依据新证据重试。本机只负责离线开发；待构建与调试配置验证完成，实际下载和采样须在用户远控的板卡/AL-LINK 所接电脑进行。目前不要求用户移动板卡、改卡或再录旧诊断页。
'''
with topic.open('a',encoding='utf-8') as f:f.write(result)
log=docs/'工作日志/2026-10-11.md'
with log.open('a',encoding='utf-8') as f:
    f.write(f'''
### {now:%H:%M}｜无外部仪器的 ChipWatcher 路线｜综合完成，物理与配置未完成

- 用户确认只有开发板/AL-LINK，板卡不接本机、当前通过远控操作。代理全程仅离线开发，未进行 JTAG/TF/Flash 操作。
- 准备独立 player_dynamic_text_cw_probe（C11101），32 bit/1024深度，只读观察count/mailbox/received/显示bit17；4处源差异与实际生成 wrapper 经核对。最终综合无ERROR、23BRAM9K；{len(scope)}输入哈希复核一致。
- physical 与小模型均在 TD arch/ppm.cpp:610 断言退出；无最终STA/新bit，有效CWC尚未导出。不能认定工具/原HDMI唯一根因。原成功基线和失败候选位流哈希不变，当前所有构建进程已结束。
- 已保留配置/插入预试、失败日志、源码和stage状态；下一步核实TD原生配置及debughub物理映射后再编译，成功后在板卡所接电脑下载采样。详见[本轮记录](../专题记录/OSD状态显示/节奏诊断实板失败_20261011/ChipWatcher准备_20261011.md)。
''')
state=docs/'当前状态.md'
text=state.read_text(encoding='utf-8-sig')
lines=text.splitlines()
for i,line in enumerate(lines):
    if line.startswith('更新：'):
        remainder=line[line.index('项目：'):]
        lines[i]=f'更新：{now:%Y-%m-%d %H:%M:%S}（北京时间；XiAzir；ChipWatcher隔离综合通过，物理断言退出、无新bit）。'+remainder
    if line.startswith('当前优先：'):
        lines[i]='当前优先：用户只有开发板/AL-LINK，板卡位于远控的另一台电脑。本机已准备独立 ChipWatcher 观察工程，综合通过，但完整工程和小模型均在 TD arch/ppm.cpp:610 断言退出，有效CWC尚未导出；无新bit、无后台构建。先核实TD原生配置/debughub物理映射，再依据新证据编译；完成后由用户在板卡所接电脑采样。cadence旧视频无需重录；SRAM校验工具报告成功；原HDMI无信号与bit17偏差根因未确认，成功基线仍osd_phy_fix。见[ChipWatcher准备](专题记录/OSD状态显示/节奏诊断实板失败_20261011/ChipWatcher准备_20261011.md)。'
text='\n'.join(lines)+'\n'
note='**2026-10-11 片内采样准备：用户只有开发板和AL-LINK，且板子不接本机。隔离cw_probe（C11101）综合通过，32bit/1024深度；physical在TD内部ppm.cpp:610断言退出，无新位流或已验证CWC。仅离线开发，未连接/操作硬件；不把综合通过当上板支持。详见[准备记录](专题记录/OSD状态显示/节奏诊断实板失败_20261011/ChipWatcher准备_20261011.md)。**\n\n'
text=text.replace('## 当前阶段\n\n','## 当前阶段\n\n'+note,1)
state.write_text(text,encoding='utf-8')
print(f'Recorded {now:%Y-%m-%d %H:%M:%S}; source hashes verified: {len(scope)}; no release bit.')
