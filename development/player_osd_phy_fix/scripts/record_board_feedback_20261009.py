"""Archive user board feedback; update live records without changing frozen artifacts."""
from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).resolve().parents[3] / 'scripts'))
from anlu_paths import REPOSITORY_ROOT, DOCS_ROOT, recorded_path, require_file
from datetime import datetime, timezone, timedelta
import hashlib
import json
import re
import shutil
import argparse

parser = argparse.ArgumentParser(description='One-time archival workflow for the original 2026-10-09 board feedback; inspect existing record guards before replay.')
parser.add_argument('--evidence-dir', type=Path, required=True,
                    help='Directory containing the two original codex-clipboard JPG files named below.')
args = parser.parse_args()
evidence_dir = args.evidence_dir.expanduser().resolve()
if not evidence_dir.is_dir():
    parser.error(f'Original evidence directory is missing: {evidence_dir}')

ROOT = REPOSITORY_ROOT
DOC = (DOCS_ROOT / '开发记录')
PROJECT = ROOT / 'development/player_osd_phy_fix'
STAMP = datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
BIT_SHA = '9E893B0B6C86BF6FBEE19E74B5FB58933C1BEA6AA07F203786CCE96F3B60AE6F'
ARCHIVE = DOC / '专题记录/OSD状态显示/修复版通过_20261009'

def digest(path):
    return hashlib.sha256(require_file(path).read_bytes()).hexdigest().upper()

def write_json(path, data):
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

def replace_once(text, old, new):
    if text.count(old) != 1:
        raise RuntimeError(f'Expected one record fragment: {old[:80]}')
    return text.replace(old, new, 1)

bit = ROOT / 'download/osd_phy_fix.bit'
assert bit.stat().st_size == 629624 and digest(bit) == BIT_SHA
assert digest(PROJECT / 'build/manual/AC201_player_osd_phy_fix.bit') == BIT_SHA
ARCHIVE.mkdir(parents=True, exist_ok=True)
photos = []
for index, name in enumerate([
    'codex-clipboard-84b527b1-76ef-4ac6-8f4b-15d747149d3d.jpg',
    'codex-clipboard-8323c941-865f-4016-ab84-777e09f2942b.jpg',
], 1):
    source = require_file(evidence_dir / name)
    target = ARCHIVE / f'image_{index}.jpg'
    if target.exists():
        assert digest(target) == digest(source), 'Existing evidence differs'
    else:
        shutil.copy2(source, target)
    assert digest(target) == digest(source)
    photos.append({'source': str(source), 'archive': str(target),
                   'bytes': target.stat().st_size, 'sha256': digest(target)})

feedback = {
    'recorded_beijing': STAMP,
    'source': '用户现场反馈与两张照片；代理未操作板卡或直接测量音频/物理时序',
    'candidate': str(bit), 'candidate_sha256': BIT_SHA, 'bytes': 629624,
    'user_report': '这次看起来一切正常了，点按切换正常，显示正常，自动轮切正常，音乐播放正常',
    'long_key1_followup': '已测试，正常（回应长按KEY1约2秒切内部音阶是否清晰正常）',
    'reported_checks': {
        'image_display': 'PASS（用户反馈）',
        'key0_manual_switch': 'PASS（用户反馈）',
        'key1_auto_switch': 'PASS（用户反馈）',
        'default_real_music': 'PASS（用户反馈）',
        'long_key1_internal_tone': 'PASS（用户补充反馈）',
    },
    'photo_observation': '两照片中红苹果、绿叶、棕色果梗、浅色背景与黑底白字状态栏正确；分别可读IMG 1/4 MANUAL和IMG 1/4 AUTO，未见首版明显噪点/花屏。照片不是逐像素测量。',
    'photos': photos,
    'duration_seconds': None, 'observed_music_loop_count': None,
    'power_cycle_reload_test': '未验证',
    'status': '实板功能回归通过（所反馈范围）；作为当前开发基线，保留packet_diag回退',
    'cause_evidence': '输入混字机制在假设传播延迟模型中已复现并由pending采样避免；实板恢复支持修复有效。重综合及物理实现同时改变，不能唯一证明首版或更早故障的物理根因。',
    'not_verified': ['本版明确音乐循环次数及长时稳定性', '重新上电后重新下载的重复启动', '换文件/碎片卡实物测试', '实际内部包/PHY逐位波形与延迟'],
    'assistant_board_operations': 'none', 'card_or_flash_writes': 'none',
    'frozen_checkpoint_and_zip': '原174文件checkpoint与原ZIP保持构建时元数据，不覆盖；最新结果在live文件与开发记录',
}
feedback_path = PROJECT / 'build/board_feedback_20261009.json'
write_json(feedback_path, feedback)
write_json(ARCHIVE / 'feedback.json', feedback)

info_path = PROJECT / 'build/manual/AC201_player_osd_phy_fix.info.json'
info = json.loads(info_path.read_text(encoding='utf-8-sig'))
info['status'] = 'Verified board baseline for reported image, OSD, manual/auto keys, default music and internal tone; extended regression pending'
info['hardware_result'] = 'PASS for user-reported functional regression; extended duration/loop/restart/file-change checks pending'
info['baseline']['hardware_pending'] = False
info['hardware_feedback'] = feedback
write_json(info_path, info)

state_path = DOC / '当前状态.md'
state = state_path.read_text(encoding='utf-8-sig')
state = re.sub(r'更新：[^（\n]+（北京时间）', f'更新：{STAMP}（北京时间）', state, count=1)
phase_start = state.index('**2026-10-09串行采样修复候选')
phase_end = state.index('\n\n', phase_start)
new_phase = ('**2026-10-09 OSD串行采样修复版实板功能回归通过（用户反馈），当前开发基线为download/osd_phy_fix.bit。'
             '用户确认显示、KEY0点按切图、KEY1自动轮播、天之弱音乐均正常，并补测长按KEY1后的内部音阶正常。'
             '两照片显示红苹果/绿叶及黑底白字IMG 1/4 MANUAL、AUTO正确，未见首版明显花屏。'
             '位流629624字节/SHA256 9E893B0B6C86BF6FBEE19E74B5FB58933C1BEA6AA07F203786CCE96F3B60AE6F；'
             '174文件冻结检查点逐项哈希复核通过，旧osd、packet_diag及交付ZIP未改。'
             '本版音乐循环次数、运行时长、重复上电下载、换文件/碎片卡未验证；Flash未固化。'
             '修复有效与物理根因唯一确认仍有区别：混字模型已复现，实板内部延迟未测，物理布局也改变。'
             '现场反馈/照片在[修复版通过证据](专题记录/OSD状态显示/修复版通过_20261009/feedback.json)，'
             '完整路线见[串行器修查](专题记录/OSD状态显示/串行器采样修查_20261009.md)。**')
state = state[:phase_start] + new_phase + state[phase_end:]
state = state.replace('当前成功基线仍packet_diag。现场证据', '首版失败时成功回退为packet_diag；当前基线已更新为osd_phy_fix。现场证据')
state = state.replace('独立player_osd_phy_fix修复候选本地验证通过，实板待验证，换文件/碎片与长时验证后续集中安排。',
                      '独立player_osd_phy_fix修复版本地及实板所反馈功能回归通过，换文件/碎片与长时验证后续集中安排。')
table_marker = '| --- | --- |\n| player_fat32_packet_diag'
state = replace_once(state, table_marker,
    '| --- | --- |\n| player_osd_phy_fix/build/manual/AC201_player_osd_phy_fix.bit | 当前开发基线，SHA256 9E893B0B6C86BF6FBEE19E74B5FB58933C1BEA6AA07F203786CCE96F3B60AE6F；显示、OSD、KEY0手动、KEY1轮播、真实音乐及长按内部音阶用户反馈正常。174文件candidate保持冻结；时长、循环次数、重复启动及换文件回归待补。 |\n| player_fat32_packet_diag')
next_start = state.index('## 下一步\n')
next_end = state.index('## 新增PCM参考审计', next_start)
state = state[:next_start] + (
    '## 下一步\n\n'
    '1. 保持osd_phy_fix为开发基线，packet_diag保留回退；长按KEY1内部音阶已补测正常，无需重复本轮基础测试。\n'
    '2. 下一阶段集中安排本版长时播放/明确循环次数、重新上电后重新下载回归和换文件/碎片卡实物验证；当前未执行，不把packet_diag旧循环结果套用到本版。\n'
    '3. 后续功能按planning/20261007/执行规划.md继续选择并隔离开发；每份位流回归图片、OSD、音乐/内部音源和按键。Flash固化、ES8388、720p及完整曲目等仍未完成；不为推进开发强行宣称历史根因唯一确定。\n\n'
    ) + state[next_end:]
entry_start = state.index('## 后续开发入口（2026-10-09）')
state = state[:entry_start] + (
    '## 后续开发入口（2026-10-09）\n\n'
    '当前从development/player_osd_phy_fix及其174文件冻结检查点接续；download/osd_phy_fix.bit为用户实板功能回归通过版本，原packet_diag为成功回退。'
    '首版osd失败工程/位流/包与照片继续保留。最新用户结果在live .info.json、build/board_feedback_20261009.json及专题证据，冻结检查点与ZIP中的pending仅是构建时历史快照。\n\n'
    '下个扩展使用独立工程/新文件名，保留本版源码/物理实现/位流；完成相关模型与原约束setup/hold再做实板回归。'
    '本版通过不等于所有历史花屏/杂音根因已取证；实际包/PHY测量、长期回归和Flash固化待后续。\n'
    )
state_path.write_text(state, encoding='utf-8')

topic_path = DOC / '专题记录/OSD状态显示/串行器采样修查_20261009.md'
topic = topic_path.read_text(encoding='utf-8-sig')
topic = replace_once(topic, '新候选实板待验证。不是已确认的实板根因报告。',
    '修复版实板显示/OSD/手动切图/轮播/真实音乐/内部音阶均获用户正常反馈。长期等扩展回归待补；不是已确认的实板根因报告。')
topic = replace_once(topic, '- 新候选实板未测试，不标记图片/音频修复成功；原故障具体物理原因仍未证实。无需重录成功基线或改TF，用户下载新候选后进行下述回归。',
    '- 构建时新候选尚未上板；后续用户功能回归通过，见下节。原174文件检查点与ZIP的hardware pending保留为历史快照，live元数据已附新反馈；原故障具体物理原因仍未唯一证实。')
topic = replace_once(topic, '## 下一步\n\n用户保持现有TF和接线，PROGRAM_SRAM下载`osd_phy_fix.bit`，验证四图、黑底白字、默认音乐两次循环、KEY0编号/KEY1轮播、长按后内部音阶。实板异常就保留现象并回载packet_diag，必要时扩大真实PHY/包观测；实板通过后仍区分“修复候选通过”与“历史失败的物理机制完全取证”。',
    f'## 实板功能回归通过（{STAMP}，北京时间）\n\n'
    '用户反馈“这次看起来一切正常了，点按切换正常，显示正常，自动轮切正常，音乐播放正常”；随后回应长按KEY1切内部音阶“已测试，正常”。'
    '两张照片显示红苹果、绿叶、棕果梗与浅色背景正常，黑底白字分别可读`IMG 1/4 MANUAL`、`IMG 1/4 AUTO`，未见首版明显花屏。'
    '默认音乐与内部音阶的听感结论来自用户，代理未直接测量声波或HDMI链路。\n\n'
    '照片原文件与SHA256、用户原话、测试范围及未验证项已归档到[修复版通过证据](修复版通过_20261009/feedback.json)；工程`build/board_feedback_20261009.json`和live `.info.json`同步。'
    '磁盘交付核查：新位流两副本一致、629624字节/SHA256 9E893B0B6C86BF6FBEE19E74B5FB58933C1BEA6AA07F203786CCE96F3B60AE6F；174文件manifest大小/hash全部匹配；旧osd、packet_diag与原ZIP指定hash均不变。'
    '无改RTL、重新构建、板卡操作或TF/Flash写入；冻结检查点和ZIP未覆盖。\n\n'
    '本版作为当前开发基线。实板通过支持本次修复有效；传播延迟混采是模型已复现机制，实际板上延迟和内部字序未直接抓取，重综合/布局布线同时改变，不能唯一指认历史物理根因。'
    '运行总时长与明确循环次数未反馈，本版重新上电下载、换文件/碎片卡实物回归待补；不能继承packet_diag的两次循环结果。\n\n'
    '## 下一步\n\n'
    '保留此成功版本与packet_diag回退，后续扩展从本版冻结源码隔离开展；集中完成本版长时/循环/重复启动及文件变化验证。'
    '若再出现图音异常，保存新版本与条件再同条件回退，必要时分层抓取真实包/PHY。Flash固化尚未实施。')
topic_path.write_text(topic, encoding='utf-8')

original_topic = DOC / '专题记录/OSD状态显示/实现与验证_20261009.md'
original = original_topic.read_text(encoding='utf-8-sig')
original = replace_once(original, '失败产物已保留，修查在独立player_osd_phy_fix工程进行。',
    '失败产物已保留，独立player_osd_phy_fix修复版已获图像/OSD/按键/音乐及内部音阶正常反馈，详见[串行器修查](串行器采样修查_20261009.md)。')
original = replace_once(original, '用户保持原TF/稳定接线/音量，用BitWriter临时下载英文路径osd.bit；观察图像/音乐、IMG编号与实际切图、MANUAL/AUTO状态、两次音乐循环及两音源。若异常，保留失败版本与现象，同条件回载packet_diag.bit对照并优先排查。新候选上板未验证，不标记OSD实物通过；Flash固化、完整曲目/换文件碎片/长时仍待后续。',
    '上述首版候选已上板失败，勿作为成功版继续下载。当前使用`download/osd_phy_fix.bit`：图像、OSD、切图/轮播、默认音乐及长按内部音阶均获用户正常反馈。首版失败与修复证据分别保留；Flash固化、完整曲目/换文件碎片/长时仍待后续。')
original_topic.write_text(original, encoding='utf-8')

log = DOC / '工作日志/2026-10-09.md'
with log.open('a', encoding='utf-8') as stream:
    stream.write(
        f'\n### {STAMP}｜OSD修复版实板功能回归｜已完成（用户反馈范围）\n\n'
        '- 用户确认图片显示、KEY0点按切图、KEY1自动轮播、真实音乐均正常；随后长按KEY1切内部音阶补测“已测试，正常”。'
        '两照片显示红苹果/绿叶、黑底白字IMG 1/4 MANUAL与AUTO，未见首版明显花屏。音频正常为用户听感反馈，未由代理直接测量。\n'
        '- 动作/证据：保存两原照片与SHA至专题OSD状态显示/修复版通过_20261009及feedback.json；同步工程build/board_feedback_20261009.json和live位流.info.json，更新当前状态与OSD专题。'
        '本次只维护记录，未改RTL/约束、重建或操作板/TF/Flash。\n'
        '- 产物核验：osd_phy_fix两bit副本629624字节、SHA256 9E893B0B6C86BF6FBEE19E74B5FB58933C1BEA6AA07F203786CCE96F3B60AE6F；冻结manifest174/174大小和SHA一致。'
        '旧packet_diag/osd及osd_phy_fix_20261009.zip哈希均保持，冻结检查点与ZIP保留构建时pending，不覆盖。当前开发基线更新为osd_phy_fix，packet_diag保留回退。\n'
        '- 边界：修复版现象恢复支持修复有效，但假设延迟模型的混采机制未获得板上内部时序直接取证，整体物理实现也改变，不认定历史根因唯一确认。'
        '本版明确循环次数、持续时长、重复上电下载、换文件/碎片卡实物验证尚未完成，不沿用旧packet_diag循环反馈。\n'
        '- 下一步：保留成功版，后续从其冻结源码隔离开发并集中完成扩展回归；未实施Flash固化。完整路线见[串行器修查](../专题记录/OSD状态显示/串行器采样修查_20261009.md)。\n'
    )
print(json.dumps({'recorded_beijing': STAMP, 'feedback': str(feedback_path),
                  'photos': photos, 'functional_regression': 'PASS user reported',
                  'unchanged_frozen_artifacts': True}, ensure_ascii=False))
