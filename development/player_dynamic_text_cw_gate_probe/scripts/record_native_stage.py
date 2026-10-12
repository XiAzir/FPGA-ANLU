from pathlib import Path
import sys

for _anlu_root in Path(__file__).resolve().parents:
    if (_anlu_root / 'scripts' / 'anlu_paths.py').is_file():
        sys.path.insert(0, str(_anlu_root / 'scripts'))
        break
from anlu_paths import DOCS_ROOT, REPOSITORY_ROOT, recorded_path

from datetime import datetime
import json

docs = DOCS_ROOT / '开发记录'
now = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
topic = docs / '专题记录/OSD状态显示/节奏诊断实板失败_20261011/ChipWatcher准备_20261011.md'
text = f'''

## {now}｜原生配置已取得，切换纯 gate 插入路线（进行中）

- 经用户处理本机 TD 授权，使用 computer-use skill 的 Windows API 仅操作本机离线 TD。板卡/AL-LINK 在另一台电脑；没有下载、扫描 JTAG、改 TF 或 Flash。
- 原生 GUI 在隔离 cw_probe 工程执行 Read Design/Optimize Gate 并打开 ChipWatcher。源码例化实例仍未出现在界面。原生添加 cw_count_data[31:0] 后保存得到 `src/td_project/chip_debugger/user.cfg`，不是可交付 CWC；配置含 EG4S20BG256、auto_created_cwc1、32 数据/触发位、1024 深度，clock=u_status_monitor/sys_clk，与 video_clk 同源。
- 原生 GUI physical 实际执行 insert_debugger ../../chip_debugger → config_chipwatcher user.cfg → compile_watcher → debug_hub/watcher OOC → pack -eco/legalize_phy_inst。但含原源码 IP 的工程仍在 ppm.cpp:610 断言。GUI run.log 到 GP Iteration 后没有记录断言，弹窗确认文件和行号；断言进程已终止，GUI 已关闭。不能因日志没有 ERROR 就认为物理通过。
- 新最小对照 `cw_probe/build/gate_smoke` 不含 source-IP stub，采用 GUI cfg 结构和 `insert_debugger chip_debugger -cwc chip_debugger/user.cfg`。TD 接受配置，32 位全部 Checked，4 BRAM，place/route 完成，无同类断言。最终 SWNS=-0.366ns、STNS=-1.019ns、HWNS=+0.011ns、HTNS=0，因此未生成 bit；它只证明该插入路线可完成布局布线，不是时序或上板通过。
- 新独立 `development/player_dynamic_text_cw_gate_probe`（C11102）已准备并综合，去掉源码 IP，保留被动 bus，使用工程已有 `fehdl keep="true"` 保留网名。综合网表实际保留 cw_count_data，未见 AL_LOGIC_DEBUGHUB/u_count_watch；无调试器时19 BRAM。源码功能路径、PLL、引脚、SDC不变。
- 首次综合时 TD 重写了 .al 工程格式；源/config 哈希保护拒绝继续 physical，定位仅 .al 有变化，HDL/约束/config未变。旧日志/scope保存在新工程 build/preflight，正在重新综合归一化后的工程再进入 physical。尚无新位流、实板根因未确认。
- 安路官方 FAQ 明确 ChipWatcher 可在 Read Design/Gate 阶段编辑，支持 IP/mark_debug/直接添加信号；本次采用直接添加后的 gate 路线，具体工具行为以本机日志为准。参考：https://tech.anlogic.com/Cn/Index/listView/catid/12/m/Cn/cate/32/tp/1/p/2.html 。未联系或向厂商发送文件。
'''
topic.write_text(topic.read_text(encoding='utf-8-sig') + text, encoding='utf-8')
status = docs / '当前状态.md'
s = status.read_text(encoding='utf-8-sig')
old_start = '**2026-10-11 片内采样准备：'
i = s.index(old_start)
j = s.index('\n\n', i)
s = s[:i] + '**2026-10-11 片内采样准备：用户只有开发板和AL-LINK，板卡不接本机。已通过本机原生GUI生成真实采样配置；含source-IP的完整工程仍触发ppm.cpp:610。纯gate插入小模型完成布局布线（setup未通过，无bit），新隔离cw_gate_probe（C11102）正在综合/物理验证。未连接硬件、未交付新位流；根因仍未确认。详见[准备记录](专题记录/OSD状态显示/节奏诊断实板失败_20261011/ChipWatcher准备_20261011.md)。**' + s[j:]
s = s.replace('更新：2026-10-11 14:30:59（北京时间；XiAzir；ChipWatcher隔离综合通过，物理断言退出、无新bit）。', f'更新：{now}（北京时间；XiAzir；已取得原生采样配置，纯gate路线验证中、无新bit）。')
i = s.index('当前优先：')
j = s.index('\n\n', i)
s = s[:i] + '当前优先：完成独立 cw_gate_probe 的纯 gate 插入、原约束 setup/hold、配套 CWC 和位流验证。GUI 配置及最小模型已取得，原 source-IP 工程仍断言；正在依新证据切换插入路线。完成后才交由用户在板卡所接电脑下载与采样。cadence旧视频无需重录，成功回退仍osd_phy_fix。' + s[j:]
status.write_text(s, encoding='utf-8')
log = docs / '工作日志/2026-10-11.md'
log.write_text(log.read_text(encoding='utf-8-sig') + f'''

### {now[11:16]}｜ChipWatcher 原生 GUI 与 gate 插入对照｜进行中

- 取得本机 GUI 的真实 user.cfg；含 source-IP 完整工程仍 ppm.cpp:610，失败子进程结束。
- 纯 RTL gate 小模型完成插入和布局布线，32×1024、4BRAM；setup -0.366ns 未通过，无bit。新 C11102 完整隔离候选已去掉 source-IP，保留被动总线；源哈希门槛发现 TD 自动归一化 .al，正在以归一化项目重新综合。
- 板卡在用户远控的另一台电脑，本机仅离线操作，未改TF/Flash；未形成新交付，原HDMI故障根因未确认。下一步完整候选物理/时序及配套CWC。详见[准备记录](../专题记录/OSD状态显示/节奏诊断实板失败_20261011/ChipWatcher准备_20261011.md)。
''', encoding='utf-8')
print('Recorded native GUI and pure gate comparison; full candidate still in progress')
