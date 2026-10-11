from pathlib import Path
import datetime, hashlib, json, re

root = Path(r'E:\VSCODE-project\FPGA-ANLU')
project = root / 'development/player_dynamic_text_axis_probe'
old = root / 'development/player_dynamic_text_video_probe'
out = project / 'build/independent_audit'

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest().upper()

scope = json.loads((project / 'build/manual/build_source_scope.json').read_text(encoding='utf-8-sig'))
for item in scope:
    path = project / 'src' / item['path']
    assert path.is_file() and sha(path) == item['sha256'].upper(), str(path)

def files(folder):
    return {p.relative_to(folder).as_posix(): sha(p) for p in folder.rglob('*') if p.is_file()}

prior = files(old / 'src/user_source')
current = files(project / 'src/user_source')
changed = sorted(p for p in prior.keys() & current.keys() if prior[p] != current[p])
added = sorted(current.keys() - prior.keys())
deleted = sorted(prior.keys() - current.keys())
assert changed == ['hdl_source/player_status_monitor.v', 'hdl_source/top_tf_hdmi_audio.v']
assert added == ['hdl_source/player_axis_input_probe.v'] and not deleted
assert files(old / 'src/td_project/al_ip') == files(project / 'src/td_project/al_ip')

timing_text = (project / 'build/manual/AC201_tf_hdmi_phy.ts').read_text()
m = re.search(r'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns\.', timing_text)
assert m
timing = dict(zip(('SWNS_ns', 'STNS_ns', 'HWNS_ns', 'HTNS_ns'), map(float, m.groups())))
assert all(v >= 0 for v in timing.values()), timing
report = (project / 'build/manual/AC201_tf_hdmi_pr.timing').read_text()
coverage = float(re.search(r'STA coverage\s*:\s*([\d.]+)%', report).group(1))
assert 'Confidence          : Routed' in report
assert str(project / 'src/user_source/constraints_source/timing.sdc').replace('\\', '/') in report

area = (project / 'build/manual/AC201_tf_hdmi_phy.area').read_text()
resources = {key: int(re.search(r'^\s*#' + key + r'\s+(\d+)', area, re.M).group(1)) for key in ('lut', 'reg', 'le', 'bram9k', 'dsp', 'gclk')}

new_route = out / 'AC201_tf_hdmi_axis_probe_pr_routed.v'
old_route = old / 'build/startup_readonly_audit/AC201_tf_hdmi_pr_routed.v'
def normalize(path):
    lines = path.read_text().splitlines()
    assert re.match(r'^// (Mon|Tue|Wed|Thu|Fri|Sat|Sun) ', lines[1])
    return '\n'.join(lines[:1] + lines[2:])
new_norm, old_norm = normalize(new_route), normalize(old_route)
assert new_norm != old_norm, 'No observable final implementation difference'
assert r'\u_axis_input_probe/' in new_norm
assert r'\u_axis_input_probe/' not in old_norm
observer_identifiers = len(re.findall(r'\\u_axis_input_probe/', new_norm))

model_binding = json.loads((project / 'build/axis_probe_model/source_bindings.json').read_text(encoding='utf-8-sig'))['files']
for key in ('observer_rtl', 'testbench', 'runner'):
    assert sha(Path(model_binding[key]['path'])) == model_binding[key]['sha256'].upper(), key
for item in model_binding['actual_chain']:
    path = Path(item['path'])
    assert sha(path) == item['sha256'].upper()
    equivalent = project / 'src/user_source/hdl_source' / path.relative_to(old / 'src/user_source/hdl_source')
    assert sha(equivalent) == sha(path)
assert 'PASS: source bindings and report written.' in (project / 'build/axis_probe_model/run.log').read_text(encoding='utf-8-sig')
status_binding = json.loads((project / 'build/status_axis_model/source_bindings.json').read_text(encoding='utf-8-sig'))
for item in status_binding['sources']:
    assert sha(Path(item['path'])) == item['sha256'].upper(), item['path']
integration = json.loads((out / 'integration_review.json').read_text(encoding='utf-8-sig'))
assert integration['overall'] == 'PASS_WITH_INTERPRETATION_BOUNDARY'
assert integration['icarus_model']['status'] == 'PASS'
assert 'PASS: 2 self-test patterns;' in (project / 'build/status_axis_model/run.log').read_text(encoding='utf-8-sig')

guards = {}
for proj, cp, count in (
    ('player_osd_phy_fix', 'osd_phy_fix_20261009_candidate', 174),
    ('player_dynamic_text', 'dynamic_text_20261009_candidate', 136),
    ('player_dynamic_text_fit', 'dynamic_text_fit_20261009_candidate', 148),
    ('player_dynamic_text_video_probe', 'dynamic_text_video_probe_20261009_candidate', 140),
):
    folder = root / 'development' / proj / 'checkpoints' / cp
    manifest = json.loads((folder / 'manifest.json').read_text(encoding='utf-8-sig'))
    assert len(manifest) == count
    for item in manifest:
        path = folder / item['path']
        assert path.stat().st_size == item['bytes'] and sha(path) == item['sha256'].upper(), str(path)
    guards[proj] = {'files': count, 'result': 'PASS', 'manifest_sha256': sha(folder / 'manifest.json')}
for bit, expected in (
    ('osd_phy_fix.bit', '9E893B0B6C86BF6FBEE19E74B5FB58933C1BEA6AA07F203786CCE96F3B60AE6F'),
    ('dynamic_text_video_probe.bit', '1EFEB04BD50035789E4EBD1430B3CB8736B0F48D93DAF24FD4013AB8130F30DF'),
    ('dynamic_text_fit.bit', '028D9D9A742A2CD980ECBEA48FFBE824D89DA34CF6B2B3E66EA0AA42B6D6456D'),
    ('dynamic_text.bit', 'D0559A203C0A775B2C70F7A1EA3E7F90BB7743F7ED463AF11409855D54CBF28F'),
):
    assert sha(root / 'download' / bit) == expected

result = {
    'recorded_beijing': datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=8))).isoformat(),
    'result': 'PASS_BUILD_AND_MODEL_SOURCE_GUARDS_BOARD_NOT_TESTED',
    'source_scope_matched': len(scope), 'source_changed': changed, 'source_added': added,
    'source_unchanged': len(prior) - len(changed), 'al_ip_unchanged': True,
    'timing': timing, 'sta_coverage_percent': coverage, 'resources': resources,
    'prehold': {'SWNS_ns': 0.280, 'STNS_ns': 0.0, 'HWNS_ns': -0.008, 'HTNS_ns': -0.016},
    'final_db_sha256': sha(project / 'build/manual/AC201_tf_hdmi_pr.db'),
    'final_route_lines': len(new_norm.splitlines()), 'old_route_lines': len(old_norm.splitlines()),
    'final_route_normalized_sha256': hashlib.sha256(new_norm.encode()).hexdigest().upper(),
    'old_route_normalized_sha256': hashlib.sha256(old_norm.encode()).hexdigest().upper(),
    'final_implementation_differs': True, 'observer_identifier_occurrences': observer_identifiers,
    'observer_model_source_bindings': 'PASS', 'status_model_source_bindings': 'PASS', 'integration_review': 'PASS_WITH_INTERPRETATION_BOUNDARY', 'frozen_guards': guards,
    'old_download_bits': 'PASS', 'hardware_result': 'NOT_TESTED', 'root_cause': 'NOT_CONFIRMED',
    'limitations': ['STA coverage 99.97%; external SPI I/O delays not characterized.',
                    'Three dummy nodes reported; shared encrypted IP and historical warnings retained.',
                    'Passive RTL changes fanout and placement; recovery would not prove the old unique cause.',
                    'Input metrics count VALID cycles regardless of READY; these are not accepted-transfer counts.',
                    'No board electrical measurements or card/Flash operations.']
}
(out / 'final_build_review.json').write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
(out / 'final_build_review.md').write_text(f'''# 最终构建复核

PASS（本地构建范围）；尚未板测，根因未确认。

综合源快照逐项 {len(scope)}/{len(scope)} 匹配；相对失败 video_probe，74 旧源不变，仅 top/status 两处改动与新增观察器，al_ip 保持相同。原 PLL、引脚、SDC、卡/图像/音频/按键生产模块不改。观察器三帧模型的源码、运行器、testbench 及实际视频链路源 hash 均与本候选匹配。

原约束最终 STA：SWNS {timing['SWNS_ns']:.3f} ns、STNS 0、HWNS {timing['HWNS_ns']:.3f} ns、HTNS 0，coverage {coverage:.2f}%，Slow/Fast max/min 检查通过；初始 hold -0.008/-0.016 ns 的报告/DB/manifest 保存在 build/prehold，fix_hold 后上述结果通过。资源：{resources}。

最终数据库只读 write_verilog 导出，含 {len(new_norm.splitlines())} 行（仅跳过生成时间），与失败 probe 的 {len(old_norm.splitlines())} 行及归一 hash 有实际差异；新观察器前缀出现 {observer_identifiers} 次。此次不重复 TLAST 单项修正的“最终网表无差分”情况。两份归一 hash 见 JSON，完整导出/TD日志同目录。该检查证明有实现差分与观察逻辑保留，不是整机功能等价或板级波形证明。

原四份冻结检查点合计598文件及四份 download 位流 hash 保持；成功基线仍 osd_phy_fix。STA 外部 I/O delay/加密IP边界与3个dummy node保留；原工具告警未升级为实物根因。输入统计按 VALID 周期计数，不以 READY 限定，不冒充被核接受的像素数。

下一步：状态页独立模型通过后生成候选位流；冷启动 SRAM 下载、保留原卡/接线，记录画面/声音/数字诊断。同条件恢复仅说明该实现改善，不证明旧故障唯一物理原因。
''', encoding='utf-8')
print(json.dumps({k: result[k] for k in ('result', 'source_scope_matched', 'timing', 'resources', 'final_route_lines', 'observer_identifier_occurrences')}, ensure_ascii=False))
