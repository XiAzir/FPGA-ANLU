from pathlib import Path
from datetime import datetime, timezone, timedelta
import hashlib
import json
import shutil

repo = Path('E:/VSCODE-project/FPGA-ANLU')
docs = Path('E:/QQ CACHE/Download/安路资料/开发记录')
work = Path(__file__).parent
topic = docs / '专题记录/OSD状态显示/节奏诊断实板失败_20261011'
stamp = datetime.now(timezone(timedelta(hours=8)))
raw = work / 'user_verify_sram.log'
log = raw.read_text(encoding='utf-8')
verify = log[log.index('RUN-1002 : start command "download -bit ..\\..\\anlu\\bit\\cadence_probe.bit -mode x_rdbk'):]
assert 'PRG-2014 : Chip validation success: EG4S20BG256' in verify
assert 'ReadBack: completed, 0 bits have been masked.' in verify
assert 'finish command "download' in verify
assert verify.rstrip().endswith('GUI-1001 : Downloading succeeded!')
result = {
    'recorded_beijing': stamp.isoformat(),
    'evidence_source': 'USER_PASTED_BITWRITER_LOG',
    'result': 'VERIFY_SRAM_TOOL_REPORTED_SUCCESS_NO_MISMATCH_REPORTED',
    'mode': 'x_rdbk',
    'chip': 'EG4S20BG256',
    'jtag_tck_mhz': 3,
    'user_bit_reference': '../../anlu/bit/cadence_probe.bit',
    'user_bit_sha256': None,
    'local_candidate_sha256': hashlib.sha256((repo / 'download/cadence_probe.bit').read_bytes()).hexdigest().upper(),
    'warning': 'PRG-5006 Cannot find mask file',
    'reported_masked_bits': 0,
    'raw_log': str(raw),
    'raw_log_sha256': hashlib.sha256(raw.read_bytes()).hexdigest(),
    'limits': [
        'User-side bit copy is not present on this host; no independent hash of it.',
        'Tool success for the selected Verify SRAM operation is not functional board success.',
        'Official manual excludes user ERAM; exact coverage without mask is undocumented.',
        'No independent configuration dump comparison or physical HDMI measurement.'
    ],
    'next': 'Check anomalous status bit17 against actual mapped primitives before additional board instrumentation.',
    'board_function_status': 'FAIL_NO_SIGNAL_ROOT_CAUSE_UNCONFIRMED'
}
(work / 'verify_result.json').write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
for name in ['user_verify_sram.log', 'verify_result.json', 'mask_warning_audit.md']:
    shutil.copyfile(work / name, topic / name)
for path in [repo / 'download/cadence_probe.info.json', repo / 'development/player_dynamic_text_cadence_probe/build/manual/AC201_player_dynamic_text_cadence_probe.info.json']:
    info = json.loads(path.read_text(encoding='utf-8-sig'))
    info['configuration_verify'] = result
    path.write_text(json.dumps(info, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

record = '''

## SRAM 校验结果（2026-10-11 用户日志）

用户完整日志已保存为 [user_verify_sram.log](user_verify_sram.log)，结构化结果见 [verify_result.json](verify_result.json)，mask 手册核查见 [mask_warning_audit.md](mask_warning_audit.md)。两次前序 PROGRAM_SRAM 为 JTAG 5 MHz，最后一次确实执行 `download -mode x_rdbk`，识别 EG4S20BG256，TCK 3 MHz；向量生成、执行及整个 x_rdbk 流程均成功结束，GUI 显示 succeeded，未报比较失败。因此本轮记作**工具层面 VERIFY_SRAM 成功，无已报告的配置失配**。

`BIT2VEC::ReadBack completed` 位于离线向量生成阶段，不能单独当作实板读回证据；其后的 `program` 是当前 x_rdbk 流程中的执行器，不能仅因名称将其解释成又写了一次位流。`Cannot find mask file` 是本轮非终止 warning，工具报告 0 bits masked，不能解读成 0 bits compared。手册定义 gen_mask 为 ERAM 校验相关罩文件，Verify SRAM 不含用户 ERAM；未给缺失 mask 时精确覆盖表，故不声称全部存储或运行态已逐位验证。

本次校验使用用户机器上的 `E:/anlu/bit/cadence_probe.bit`（日志为相对路径），该副本在本机不存在，无法独立核对其 SHA；本机交付文件 SHA 仍为 8C56A7D24F2D719835369720D7403DE3F55150E07C454CBA3182EE47D230E17C。当前证据降低“相对于所选文件下载错误”的优先级，不证明 RTL、运行时状态、用户 ERAM、板端时钟或 TMDS 电气输出正常。校验后显示状态用户尚未另行反馈，不凭日志推断恢复；该候选维持实板 FAIL。

下一步已在电脑上检查旧页3固定多 bit17 的实际映射逻辑，避免立即追加新板级观察器。原冻结 checkpoint、ZIP 和 bit 均未改；代理没有操作 JTAG、TF 或 Flash。现有9页视频无需重复提交。
'''
with (topic / '实板读数与下一步.md').open('a', encoding='utf-8') as handle:
    handle.write(record)

current = docs / '当前状态.md'
state = current.read_text(encoding='utf-8-sig')
state = state.replace('2026-10-11 13:55:46（北京时间；本机继续 XiAzir，cadence_probe 实板失败已取证）', stamp.strftime('%Y-%m-%d %H:%M:%S') + '（北京时间；本机继续 XiAzir，cadence_probe 实板失败，SRAM 校验工具报告成功）')
old = '当前优先对相同位流尝试BitWriter Verify SRAM配置回读校验并看完整日志；工具文档列有此功能，器件支持/运行影响未确认，不能预判配置错误。'
new = '用户随后提供完整x_rdbk日志：EG4S20BG256/3MHz，向量生成、执行及整体流程成功结束，未报比较失败，记录为工具层面VERIFY_SRAM成功；缺mask但0位屏蔽，精确覆盖未知，不含用户ERAM。所选用户侧bit副本SHA未独立取得。当前先验证旧页3 bit17实际映射逻辑，再取证串行输出；不再把下载损坏当作首要假设。'
assert old in state
state = state.replace(old, new, 1)
old = '先尝试用当前候选相同文件做 Verify SRAM，取完整日志区分配置匹配/比对失败/禁止或不支持；'
new = 'Verify SRAM用户日志已取得：x_rdbk工具报告成功、未报失配，mask缺失的覆盖边界已记录。先做旧页3 bit17的映射网表局部验证，再决定板级输出测量；'
assert old in state
state = state.replace(old, new, 1)
current.write_text(state, encoding='utf-8')

entry = f'''

### {stamp:%H:%M}｜cadence_probe SRAM 校验日志｜解读完成，局部映射验证进行中

- 用户证据：完整日志末次确为 x_rdbk/EG4S20BG256/3MHz，生成与执行成功，整个流程 GUI succeeded；未报告比较失败。PRG-5006 缺mask后继续，报告0位屏蔽，非“0位比较”；手册不含用户ERAM，缺mask的精确覆盖未给。
- 动作/产物：原日志、结构化结果、mask手册审计保存到[节奏诊断失败专题](../专题记录/OSD状态显示/节奏诊断实板失败_20261011/实板读数与下一步.md)，更新live info，候选仍FAIL。用户侧E:/anlu/bit副本不在本机，未独立哈希；本机bit SHA仍8C56A7D24F2D719835369720D7403DE3F55150E07C454CBA3182EE47D230E17C。
- 判断/限制：工具层面VERIFY_SRAM成功，可降低相对所选文件的配置传输失配优先级；不能证明运行逻辑/用户ERAM/TMDS输出正确或根因已找到。未运行硬件命令、重建或修改TF/Flash，冻结产物不动。
- 下一步：针对旧页3多bit17提取最终mapped primitive作有界局部模型验证，尚无结果；不再索要同一数码管视频，不要求反复下载。成功基线仍osd_phy_fix。
'''
with (docs / '工作日志/2026-10-11.md').open('a', encoding='utf-8') as handle:
    handle.write(entry)
print(json.dumps({'result': result['result'], 'local_sha256': result['local_candidate_sha256'], 'recorded': str(topic)}, ensure_ascii=False))
