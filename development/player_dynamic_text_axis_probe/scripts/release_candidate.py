from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).resolve().parents[3] / 'scripts'))
from anlu_paths import REPOSITORY_ROOT, DOCS_ROOT, recorded_path, require_file
import datetime, hashlib, json, shutil, zipfile

root = REPOSITORY_ROOT
project = root / 'development/player_dynamic_text_axis_probe'
docs = (DOCS_ROOT / '开发记录')
topic = docs / '专题记录/OSD状态显示/动态字幕资源版竖线_20261009'
now = datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')

def sha(p):
    return hashlib.sha256(require_file(p).read_bytes()).hexdigest().upper()

def write_json(path, data):
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

audit_path = project / 'build/independent_audit/final_build_review.json'
audit = json.loads(audit_path.read_text(encoding='utf-8-sig'))
assert audit['result'] == 'PASS_BUILD_AND_MODEL_SOURCE_GUARDS_BOARD_NOT_TESTED'
assert audit['status_model_source_bindings'] == 'PASS'
assert sha(project / 'build/manual/AC201_tf_hdmi_pr.db') == audit['final_db_sha256']
for item in json.loads((project / 'build/manual/build_source_scope.json').read_text(encoding='utf-8-sig')):
    assert sha(project / 'src' / item['path']) == item['sha256'].upper()
assert 'BITSTREAM_GENERATED' in (project / 'build/manual/bitstream_console.log').read_text()
bit = project / 'build/manual/AC201_player_dynamic_text_axis_probe.bit'
bit_sha = sha(bit)
assert bit.stat().st_size == 629624
assert bit_sha == '07DEAD7F0337A3BAD7DA8C093BF57093AAB1E0106B322311724F78A90A10577B'
fallback = root / 'download/osd_phy_fix.bit'
assert sha(fallback) == '9E893B0B6C86BF6FBEE19E74B5FB58933C1BEA6AA07F203786CCE96F3B60AE6F'
download = root / 'download/axis_probe.bit'
if download.exists():
    assert sha(download) == bit_sha, 'Do not overwrite another candidate'
else:
    shutil.copy2(bit, download)
assert sha(download) == bit_sha

info = {
    'created_beijing': now, 'status': 'LOCAL_VERIFICATION_PASS_BOARD_PENDING',
    'hardware_result': 'NOT_TESTED', 'root_cause': 'NOT_CONFIRMED',
    'bitstream': str(bit), 'download': str(download), 'bytes': bit.stat().st_size, 'sha256': bit_sha,
    'source_changed_vs_video_probe': audit['source_changed'], 'source_added': audit['source_added'],
    'source_unchanged': audit['source_unchanged'], 'timing': audit['timing'],
    'sta_coverage_percent': audit['sta_coverage_percent'], 'resources': audit['resources'],
    'routed_db_sha256': audit['final_db_sha256'],
    'final_implementation_differs': True,
    'final_route_normalized_sha256': audit['final_route_normalized_sha256'],
    'models': {
        'observer': 'PASS: three actual source-chain frames, directed malformed USER/row/frame/ready/reset/saturation tests; SDRAM pixel source substituted',
        'status_display': 'PASS: self-test, three 9-page rounds, startup/audio mailbox and full B/C 24-bit payload',
        'scope': 'Partial RTL models; encrypted HDMI and physical board not modeled',
        'observer_bindings': str(project / 'build/axis_probe_model/source_bindings.json'),
        'status_bindings': str(project / 'build/status_axis_model/source_bindings.json')
    },
    'audit': str(audit_path), 'integration_audit': str(project / 'build/independent_audit/integration_review.json'),
    'fallback': str(fallback), 'fallback_sha256': sha(fallback),
    'frozen_guards': audit['frozen_guards'], 'agent_card_or_flash_operations': 'NONE',
    'limitations': audit['limitations'],
    'expected_source_metrics': {'line_width': 640, 'frame_rows': 480, 'frame_cycles': 420000, 'valid_pixels_per_frame': 307200, 'intra_frame_blank': 160, 'TLAST': 0},
    'observer_flags': '{current_locked,locked_ever,valid_seen,user_seen}',
    'display_codes': ['1', '3', '6', '7', '8', '9', 'A', 'B', 'C']
}
info_path = project / 'build/manual/AC201_player_dynamic_text_axis_probe.info.json'
write_json(info_path, info)
prep_path = project / 'build/preparation.json'
prep = json.loads(prep_path.read_text(encoding='utf-8-sig'))
prep.update(updated_beijing=now, models='OBSERVER_AND_STATUS_INTEGRATION_PASS', td_build='SYNTHESIS_PHYSICAL_ORIGINAL_CONSTRAINT_HOLD_BITGEN_PASS', hardware_result='NOT_TESTED', root_cause='NOT_CONFIRMED', bitstream=str(download), sha256=bit_sha, final_timing=audit['timing'])
write_json(prep_path, prep)

guide = f'''AXIS 输入统计诊断候选（2026-10-09）

状态：本地模型/综合/原约束布局布线与 setup/hold 通过，尚未上板；不是已经证实的修复版。
新位流 axis_probe.bit，629624字节，SHA256 {bit_sha}
成功回退 osd_phy_fix.bit，SHA256 {sha(fallback)}

本次操作（无需改TF文件）：
1. 等 BitWriter 停止下载后，板卡断电约5秒；保持原TF卡、稳定供电接法、HDMI及显示器设置，上电后重新 PROGRAM_SRAM 下载 axis_probe.bit。确认 Downloading succeeded!，等待10秒。
2. 先记录默认画面/音乐是否正常，以及D3/D2/D1/D0状态。无信号也不要立即重载。
3. 仅长按KEY1约2秒，D3闪烁后松开；记录音阶是否正常，再拍数码管20秒，覆盖1、3、6、7、8、9、A、B、C一整轮。视频可给本地路径；拍不到视频也可抄这些页的8位十六进制字符。
4. 取证完成可回载 osd_phy_fix.bit；异常时这份成功基线仍是正常使用版。

显示含义：首位是页码；6..C第二位flags={{当前locked,曾locked,见过valid,见过user}}。正常持续locked为F，从未锁定但已见valid/user为3，曾锁后当前失锁为7。
1：原启动/文件标志、FS/WAV映射错误码。3：原音源/欠载/lock/SOF标志及每名义秒音频输入样本数。
6：最后一行宽[高12位] / 完整帧行数[低12位]，预期载荷2801E0（640/480）。
7：帧开始之间像素时钟周期数，预期0668A0（420000）。
8：完整帧VALID周期数，预期04B000（307200）。
9：坏行数[高12位] / 坏帧数[低12位]，预期000000。
A：帧内行间blank周期[高12位] / valid且ready低的累计周期[低12位]，前者预期0A0（160），后者用于观察背压并非预设正确值。
B：上一个完整帧TLAST次数。原转换器模型观察为0；此共享协议缺陷尚未证明导致当前无信号，不把0冒充核接受成功。
C：异常USER数[高12位] / 累计valid+user帧开始数[低12位]；异常预期0，帧数递增至FFF饱和。
统计按VALID周期，不按VALID&&READY过滤，不能当接收端已成功接受的像素数。

KEY0点按/KEY1短按仍保留切图/轮播。KEY0+KEY1长按是原REF诊断手势，本轮取证先不使用。数码管页6..C已换成输入统计，不能按旧音频包页含义读取。
时序：SWNS+0.280ns/HWNS+0.027ns、TNS均0，coverage99.97%。外部IO delay和加密IP边界仍有限；观察器会改变fanout/物理布局，若恢复不能唯一确定旧物理故障原因。
'''
guide_path = topic / 'AXIS输入统计诊断_20261009.md'
guide_path.write_text('# AXIS输入统计诊断候选\n\n' + guide, encoding='utf-8')

checkpoint = project / 'checkpoints/axis_probe_20261009_candidate'
assert not checkpoint.exists(), 'Do not overwrite a frozen checkpoint'
checkpoint.mkdir(parents=True)
for folder in ('src/user_source', 'scripts', 'sim', 'build/axis_probe_model', 'build/status_axis_model', 'build/independent_audit', 'build/prehold'):
    shutil.copytree(project / folder, checkpoint / folder)
shutil.copytree(project / 'src/td_project/al_ip', checkpoint / 'src/td_project/al_ip')
shutil.copy2(project / 'src/td_project/AC201_tf_hdmi.al', checkpoint / 'src/td_project/AC201_tf_hdmi.al')
(checkpoint / 'build/manual').mkdir(parents=True)
for p in (project / 'build/manual').iterdir():
    if p.is_file() and (p.suffix != '.db' or p.name == 'AC201_tf_hdmi_pr.db'):
        shutil.copy2(p, checkpoint / 'build/manual' / p.name)
shutil.copy2(prep_path, checkpoint / 'build/preparation.json')
manifest = [{'path': p.relative_to(checkpoint).as_posix(), 'bytes': p.stat().st_size, 'sha256': sha(p)} for p in sorted(checkpoint.rglob('*')) if p.is_file()]
write_json(checkpoint / 'manifest.json', manifest)
for item in manifest:
    p = checkpoint / item['path']
    assert p.stat().st_size == item['bytes'] and sha(p) == item['sha256']
write_json(project / 'build/checkpoint_verification.json', {'verified_beijing': now, 'checkpoint': str(checkpoint), 'files': len(manifest), 'manifest_sha256': sha(checkpoint / 'manifest.json'), 'result': 'PASS'})

package = root / 'deliverables/axis_probe_20261009.zip'
assert not package.exists(), 'Do not overwrite an old release'
hashes = f'{bit_sha}  axis_probe.bit\n{sha(fallback)}  osd_phy_fix.bit\n'
with zipfile.ZipFile(package, 'w', compression=zipfile.ZIP_DEFLATED) as z:
    z.write(download, 'axis_probe.bit')
    z.write(fallback, 'osd_phy_fix.bit')
    z.writestr('READ_ME.txt', guide)
    z.writestr('SHA256SUMS.txt', hashes)
with zipfile.ZipFile(package) as z:
    assert z.testzip() is None
    assert hashlib.sha256(z.read('axis_probe.bit')).hexdigest().upper() == bit_sha
    assert hashlib.sha256(z.read('osd_phy_fix.bit')).hexdigest().upper() == sha(fallback)
    assert z.read('READ_ME.txt').decode() == guide
package_audit = {'created_beijing': now, 'zip': str(package), 'bytes': package.stat().st_size, 'sha256': sha(package), 'members': ['axis_probe.bit', 'osd_phy_fix.bit', 'READ_ME.txt', 'SHA256SUMS.txt'], 'crc_and_bit_hashes': 'PASS', 'checkpoint': str(checkpoint), 'checkpoint_files': len(manifest), 'hardware_result': 'NOT_TESTED'}
write_json(root / 'deliverables/axis_probe_20261009.package_audit.json', package_audit)

report_path = topic / '视频源诊断无信号.md'
with report_path.open('a', encoding='utf-8') as f:
    f.write(f'''\n## {now}：输入观察候选本地验证完成，待实板

player_dynamic_text_axis_probe 使用被动输入观察替换包观察，原74源含卡/缓存/音频/按键/核/PLL/pin/SDC不变。实际视频链三帧及定向错误模型通过，独立真实状态页模型连续3轮通过，B/C完整24位载荷确认。81项综合source scope匹配；最终route导出归一hash {audit['final_route_normalized_sha256']}，与失败probe不同，2673个观察器标识出现，避免此前TLAST单项无实现差分的无效板测。

初始HWNS/HTNS -0.008/-0.016ns的DB与报告已保存prehold；原约束fix_hold后SWNS0.280/HWNS0.027ns、TNS0、coverage99.97%，17137LUT/7978reg/18435LE/19BRAM9K/0DSP/2GCLK。TD bitgen完成，位流629624字节/SHA256 {bit_sha}。{len(manifest)}文件checkpoint manifest逐项校验通过，交付ZIP CRC/内含新旧bit hash匹配；旧598冻结文件和4个download bit守卫通过。输入计数按VALID，不代表READY接受传输；现只完成本地构建，唯一根因/竖线均未关闭。

取证步骤与页面字段见[本轮诊断说明](AXIS输入统计诊断_20261009.md)。成功基线仍osd_phy_fix，TF/Flash未操作；下一步用户冷启动重新下载axis_probe，默认观感+长按KEY1后20秒数字页证据。若恢复，仅能说明实现相关，不能外推旧物理原因。
''')
state_path = docs / '当前状态.md'
state = state_path.read_text(encoding='utf-8-sig')
state = state.replace(state.splitlines()[2], f'更新：{now}（北京时间）。项目：2026安路赛道赛题1多媒体播放器；AC601+AC201/ES8388，EG4S20BG256。工程与资料分别位于同级的FPGA-ANLU、FPGA-ANLU-docs仓库。用户确认第三方板卡参赛获主办方认可；按需入口见项目AGENTS.md。', 1)
start = state.index('**', state.index('## 当前阶段'))
end = state.index('\n\n', start)
state = state[:start] + f'''**{now}输入统计诊断候选本地完成、待实板：download/axis_probe.bit，629624字节/SHA256 {bit_sha}；三帧输入模型及独立状态页24bit模型通过，81项source hash匹配，原约束最终SWNS0.280/HWNS0.027ns/TNS0、coverage99.97%，观察器在实际新route保留且与失败probe有实现差分。{len(manifest)}文件冻结checkpoint及ZIP校验通过。新候选尚未板测，不记为修复；成功基线仍osd_phy_fix。此前probe冷热无信号、TLAST候选最终网表无差分停止交付，竖线/无信号根因仍未确认。下一步冷启动下载并读取6..C输入几何/周期/ready/lock数码管页；取证步骤见[本轮诊断](专题记录/OSD状态显示/动态字幕资源版竖线_20261009/AXIS输入统计诊断_20261009.md)，背景见[无信号取证](专题记录/OSD状态显示/动态字幕资源版竖线_20261009/视频源诊断无信号.md)。**''' + state[end:]
state = state.replace('当前优先：完成被动视频输入统计candidate的集成模型/原约束STA和实板对照；TLAST源修改最终网表相同，停止交付；probe无信号，原BMP/REF诊断尚未完成。', '当前优先：用户冷启动重新下载axis_probe，记录默认画面/声音及长按KEY1内部tone后的20秒数码管；本地验证/封存已完成，候选板测待用户。TLAST单项网表相同未交付；旧probe无信号，原BMP/REF分层测试尚未完成。')
state_path.write_text(state, encoding='utf-8')
with (docs / '工作日志/2026-10-09.md').open('a', encoding='utf-8') as f:
    f.write(f'''\n### {now[11:]}｜视频输入统计诊断候选｜本地完成/实板待用户

- 动作：player_dynamic_text_axis_probe保留74源、top/status两改/一新增被动观察；独立luna审计及状态页真实RTL3轮PASS，三帧实际视频链模型PASS（SDRAM像素替代，未模拟加密HDMI）。81项scope全匹配，最终route保留观察逻辑且与旧probe有实际差分。详细审计在工程build/independent_audit。
- 验证：初始hold-0.008/-0.016ns报告/DB保留prehold；原约束fix_hold后SWNS0.280/HWNS0.027ns/TNS0、coverage99.97%。bitgen成功，download/axis_probe.bit=629624字节/SHA256 {bit_sha}；{len(manifest)}文件manifest复核和deliverables/axis_probe_20261009.zip CRC/内部hash通过。旧四检查点598项/四download bit保持。
- 未完成：板测、竖线/无信号唯一根因未确认；观察器按VALID非READY接受口径，物理布局/fanout改变，恢复不能唯一证明旧因。外部IO delay/加密IP/电气测量边界保留。未操作TF/Flash，成功基线osd_phy_fix。
- 下一步：冷启动重新PROGRAM_SRAM下载axis_probe，默认显示/音乐观察及长KEY1后的20秒数码管视频。说明见[本轮输入诊断](../专题记录/OSD状态显示/动态字幕资源版竖线_20261009/AXIS输入统计诊断_20261009.md)；失败可回载成功版。
''')
print(json.dumps({'download': str(download), 'sha256': bit_sha, 'checkpoint_files': len(manifest), 'zip': str(package), 'zip_sha256': sha(package), 'hardware_result': 'NOT_TESTED', 'recorded_beijing': now}, ensure_ascii=False))
