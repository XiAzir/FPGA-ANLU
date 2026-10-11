import hashlib
import json
from datetime import datetime, timezone, timedelta
from pathlib import Path

project = Path(__file__).resolve().parent.parent
root = project.parent.parent
records = Path('E:/QQ CACHE/Download/安路资料/开发记录')
now = datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
audit = json.loads((root / 'deliverables/dynamic_text_fit_20261009.package_audit.json').read_text(encoding='utf-8-sig'))
info = json.loads((project / 'build/manual/AC201_player_dynamic_text_fit.info.json').read_text(encoding='utf-8-sig'))
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest().upper()
assert sha(root / 'download/dynamic_text.bit') == 'D0559A203C0A775B2C70F7A1EA3E7F90BB7743F7ED463AF11409855D54CBF28F'
assert sha(root / 'deliverables/dynamic_text_20261009.zip') == '4B4FDE1FA931F75332667B50EAD84C6ECCAF84F6364C3D1B5B1C6BD8B3B27D4D'
assert sha(root / 'download/osd_phy_fix.bit') == info['fallback_sha256']
topic = records / '专题记录/OSD状态显示/动态字幕资源候选_20261009.md'
topic.write_text(f'''# 动态字幕资源优化候选

更新：{now}（北京时间）。状态：本地验证/构建/打包已完成，实板未验证，历史故障根因未确认。

## 目的与范围

失败动态字幕版出现IMG0/4、无BMP/WAV及内部音阶失真；用户同条件回载osd_phy_fix恢复。视频包观察器在PHY前有BCH/TERC错误、无正确ACR，源码和时钟路径审计不足以唯一归因。现场/视频及推论边界见[失败排查](动态字幕首版失败_20261009/排查进展.md)。

共享字模第一实验局部字模仅少1LUT、全设计LUT反增，布局MSlice4906超过4900 (PHY-9009)，未产bit，已放弃。本候选在独立 `development/player_dynamic_text_fit` 保留原动态字模，只修改 `fat32_file_sector.v` 的Brent计数器声明：anchor及cache_anchor保持32位；power及cache_power改14位；length及cache_length改13位。现有4096簇文件/遍历硬上限、算法、错误码、接口均不变。75个user sources中74个哈希与失败版一致，音频/TF协议/复位/PLL/引脚/SDC不改。

文件最多4096簇，最大合法目标index4095，最多4095次成功前进；Brent power在可达范围内最高4096。14/13位保留保守余量，簇编号仍32位。两mapper实例合计理论少148个寄存器位；实测gate reg8005→7857恰少148、gate LUT16743→16587；最终资源见下表。缩宽不等于已证修复EOC/音频故障，重新布局还会改变其他模块物理位置。

## 验证证据

- 优化前/后分别运行既有byte-gap模型，SPC1/8/64、碎片、cache/backseek、EOF/free/cycle/timeout通过。
- 新增双实例逐周期接口及Brent数值状态对照：6381198周期、12295个完整512字节扇区事务通过，含最大合法4096簇/sector4095/cache power4096、4097簇E_LIMIT、长EOC、晚期循环；没有force内部寄存器。这是受测范围的行为等价与数值边界验证，不是完整形式证明。
- 候选mapper与被测narrow副本逐字归一模块名后相同，原参照与失败mapper绑定相同；测试、源码和日志存于 `sim/mapper_width_experiment`。
- 动态像素1843200/计时12000cycle、旧OSD1843200/state838的原模型日志因对应源码逐字相同而复用，明确标记same_source，不冒充新板测。
- TD6.2.178840综合/布局布线通过。初始hold HWNS-0.011ns/HTNS-0.017ns，原DB/报告保留 `build/prehold`；原约束fix_hold后SWNS+0.581ns、HWNS+0.027ns、两TNS0，coverage99.98%。STA实际识别25MHz/125MHz关联时钟，无新增false path/exclusive；外部SPI输入及HDMI接收端delay仍未建预算。SDRAM位置调整警告保留，未据此定根因。

| 最终资源 | 失败动态版 | 本候选 |
|---|---:|---:|
| LUT |17254|17151|
| reg |8170|8016|
| LE |18630|18459|
| BRAM9K |19|19|
| slice (route摘要，fix_hold前) |9678 / 98.76%|9614 / 98.10%|

另有只读协议核查确认共有旧转换器在每行640个DE有效周期下没有TLAST（检查旧计数器值的off-by-one）；成功/失败版源码及连接相同，加密core内部如何消费last未知，不能解释当前差分。ready也未反馈，是独立协议核查点。本候选未改这项，详细TB/日志/报告在 `build/axis_readonly_audit` 并随新检查点保存，后续独立修复/验证，避免多项混改。

## 产物与保护

- 下载：`E:/VSCODE-project/FPGA-ANLU/download/dynamic_text_fit.bit`，629624字节，SHA256 `{audit['sha256']}`。
- 压缩包：`E:/VSCODE-project/FPGA-ANLU/deliverables/dynamic_text_fit_20261009.zip`，{audit['package_bytes']}字节，SHA256 `{audit['package_sha256']}`；内含新bit、osd_phy_fix成功回退、README及校验信息，ZIP CRC/成员逐字核验通过。
- 新冻结检查点148文件：`development/player_dynamic_text_fit/checkpoints/dynamic_text_fit_20261009_candidate`，manifest逐项bytes/SHA检查通过。
- 原成功174文件/失败136文件检查点逐项复核通过；原成功bit、失败bit及失败ZIP哈希保持一致。未操作板卡、TF或Flash。

## 下一步实板

保持TF卡、供电、HDMI、音量不变，BitWriter PROGRAM_SRAM下载英文路径新bit。检查四图/天之弱、KEY0点按、KEY1短按AUTO轮播、KEY1长约2秒内部音阶；RUN计时和底部滚动字幕应继续运行，观察约一分钟有无画面/音频中断。如异常，同条件回载osd_phy_fix；新候选只能待反馈后更新hardware_result，不能套用成功基线结果。
''', encoding='utf-8')

state_path = records / '当前状态.md'
state = state_path.read_text(encoding='utf-8-sig')
lines = state.splitlines()
for i, line in enumerate(lines):
    if line.startswith('更新：'):
        lines[i] = '更新：' + now + '（北京时间）。' + line.split('。', 1)[1]
    if line.startswith('**2026-10-09动态字幕首版实板回归失败'):
        lines[i] = line.replace('下一单项资源实验为4096簇上限内FAT mapper计数器缩宽，等价/边界模型进行中。', '单项FAT mapper位宽资源候选本地已完成，实板待测（见下）；首版根因仍未确认。')
state = '\n'.join(lines) + '\n'
anchor = '## 当前阶段\n\n'
new = f'''**动态字幕资源候选本地完成、实板未验证：download/dynamic_text_fit.bit=629624字节/SHA256 {audit['sha256']}。独立player_dynamic_text_fit仅缩宽FAT mapper Brent计数器，74旧源/原动态字模/音频/PLL/引脚/SDC不改；原/优化bytegap及6381198周期/12295扇区等价通过。原约束fix_hold后SWNS0.581/HWNS0.027ns/TNS0、coverage99.98%，17151LUT/8016reg/18459LE/19BRAM。148文件checkpoint和新ZIP核验完成；原成功/失败冻结产物保持。当前实板成功基线仍osd_phy_fix，动态首版根因未确认。待同卡图音/按键/计时/滚动及一分钟中断回归，详见[资源候选记录](专题记录/OSD状态显示/动态字幕资源候选_20261009.md)。**

'''
state = state.replace(anchor, anchor + new, 1)
state_path.write_text(state, encoding='utf-8')
with (records / '工作日志/2026-10-09.md').open('a', encoding='utf-8') as log:
    log.write(f'''
### {now[11:]}｜动态字幕单项资源候选封存交付｜已完成（本地阶段），实板未验证

- 独立player_dynamic_text_fit仅mapper计数器位宽变化，75源中的74个与失败版一致；共享字模实验无有效降面积且PHY-9009，无bit，未采用。
- 原/优化bytegap模型通过，双实例逐周期6381198周期/12295个完整扇区通过，包括最大4096簇/cache/seek/E_LIMIT/EOC/loop。保留原动态字模及旧OSD同源模型证据，明确为复用。
- TD综合/布局布线/原约束fix_hold通过：初始HWNS-0.011/HTNS-0.017ns保留prehold；最终SWNS0.581/HWNS0.027ns、TNS0、coverage99.98%。最终17151LUT/8016reg/18459LE/19BRAM；route slices98.10%，仍高占用，不定根因。
- 新bit SHA {audit['sha256']}，148文件checkpoint逐项校验；ZIP {audit['package_bytes']} bytes/SHA {audit['package_sha256']}，CRC/成员PASS；原174/136冻结检查点、旧bit/ZIP均保留并复核。未板测、未写TF/Flash。详见[资源候选](../专题记录/OSD状态显示/动态字幕资源候选_20261009.md)。
- 另只读实际DE→AXIS模型发现共有旧TLAST off-by-one（640valid但0last），成功/失败旧源相同且加密core消费未知；此候选未混改，后续单独处理，不当当前差分根因。
- 下一步：用户同TF/供电/HDMI/音量下载download/dynamic_text_fit.bit，观察图音/KEY0/KEY1/长KEY1内部tone、计时/滚动和一分钟中断；异常回载osd_phy_fix。根因仍未确认，不标实板完成。
''')
print('Candidate record, state and log saved; prior downloads and package hashes unchanged.')
