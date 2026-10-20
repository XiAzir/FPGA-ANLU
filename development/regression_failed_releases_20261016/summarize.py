"""Assemble the completed reverse-regression evidence without running a build."""
from pathlib import Path
from datetime import datetime, timezone, timedelta
import json
import hashlib

ROOT=Path(__file__).resolve().parent
def read(relative): return json.loads((ROOT/relative).read_text(encoding='utf-8-sig'))
def sha(path): return hashlib.sha256(path.read_bytes()).hexdigest().upper()

rtl=read('rtl/summary.json')
video=read('video/summary.json')
gate=read('fft_netlist/attempt_2_guarded/summary.json')
routed=read('fft_netlist/attempt_4_boundary_outputs/summary.json')
coeff=read('rtl/coeff_scan/summary.json')
archive=read('archive_integrity.json')
negative=read('fft_netlist/negative_controls/summary.json')
assert 'completed' in routed and len(routed['results'])==5, 'Routed matrix not complete'
assert len(rtl['results'])==7 and len(video['runs'])==5
assert all(not r['mismatches'] and r['matches_frozen_bit'] for r in archive)
assert all(r['expected_failure_detected'] for r in negative)
assert all(r['simulation']['result']=='PASS' for r in video['runs'])
assert all(r['deliveredBit']['hashMatchesManifest'] for r in video['runs'])

by_rtl={r['id']:r for r in rtl['results']}
by_gate={r['version']:r for r in gate['results'] if r['stage']=='gate'}
by_route={r['version']:r for r in routed['results']}
by_video={r['release']:r for r in video['runs']}
rows=[]
def status(r,kind):
    if r is None:return '未测'
    if r['status'].startswith('PASS'):return '通过'
    if kind in ('gate','routed'):
        assert r.get('input_guard_passed'), 'Invalid input guard on non-pass test'
        if any('outputs=24 nonzero=0' in m for m in r.get('markers',[])):
            return '失败：24段全零'
    return '失败/待核：'+r['status']
rows.append('| C11302 | 绿条、无声 | 不适用 | 不适用 | 不适用 | 通过 |')
board={
 'C11304':'黑屏无信号', 'C11305':'默认无图无声、切音源后无信号',
 'C11306':'频谱不动、音画异常', 'C11307':'无BMP、WAV杂音，音阶/频谱正常',
 'C11308':'绿条、无声，频谱运动', 'C11309':'音画正常，频谱为空',
 'C11310':'黑屏无信号',
}
table_results=[]
for version in board:
    rt=status(by_rtl[version],'rtl')
    if version=='C11306':rt='失败：24段全零'
    ga=status(by_gate[version],'gate')
    ro=status(by_route.get(version),'routed') if version in by_route else '无封存网表'
    vi='通过' if version in by_video else '未测'
    rows.append(f'| {version} | {board[version]} | {rt} | {ga} | {ro} | {vi} |')
    table_results.append(dict(version=version,board_feedback=board[version],rtl=rt,gate=ga,routed=ro,video_control=vi))

evidence=[
 'archive_integrity.json','rtl/summary.json','rtl/coeff_scan/summary.json',
 'video/summary.json','fft_netlist/attempt_2_guarded/summary.json',
 'fft_netlist/attempt_4_boundary_outputs/summary.json',
 'fft_netlist/negative_controls/summary.json',
 'fft_netlist/extract_fft.py','fft_netlist/tb_fft_cone.v',
]
receipt=dict(completed_beijing=datetime.now(timezone(timedelta(hours=8))).isoformat(),
    simulator='ModelSim SE-64 10.1c', source='Archived RTL and official gate/routed netlists corresponding to delivered old bits; not direct .bit execution',
    matrix=table_results, archived_files_checked=sum(x['files'] for x in archive),
    archived_manifest_mismatches=sum(len(x['mismatches']) for x in archive),
    evidence=[dict(path=x,sha256=sha(ROOT/x)) for x in evidence],
    limits=['Controlled functional cones, not whole-system board startup', 'No complete SDF',
            'Video test excludes pixel FIFO/PHY/receiver', 'C11206 gate not included in verified manifest',
            'No production RTL/bit/ZIP changes; no new synthesis or hardware operation',
            'C11310 board no-signal and C11309 board empty-spectrum root causes remain unproven'])
(ROOT/'summary.json').write_text(json.dumps(receipt,indent=2,ensure_ascii=False),encoding='utf-8')

report='''# 历史实板失败版本反向仿真（2026-10-16）

本轮实际重跑 ModelSim SE-64 10.1c。结论：多份实板失败版本仍通过现有局部功能仿真；C11306 的实际 BRAM 读控制异常可以被原厂模型检出。不能用这些 PASS 作为整机修复或板测通过的证据。

ModelSim 执行的是旧位流对应的封存 RTL 和官方导出网表，不直接执行 `.bit`。C11304..C11310 的七个下载 bit 均与冻结 bit 的 SHA256 相同；七份清单共 1795 个冻结文件逐项校验零差异，未修改旧版源码/网表/位流/ZIP，未重新综合或操作硬件。

| 版本 | 原实板表现（用户反馈） | FFT RTL | FFT综合网表锥 | FFT路由后网表锥 | 视频时序→锁定控制锥 |
| --- | --- | --- | --- | --- | --- |
'''+ '\n'.join(rows)+'''

“通过”仅适用于相应列测试范围；“未测/无封存网表”不计通过。C11302 采用原包络功能，因此本轮 FFT 列不适用。C11303 无明确本轮实板失败反馈，未纳入。

## 测试范围与证据

- [RTL矩阵](rtl/README.md)：通过版本各13组/312频段定点误差0，含521clk采样、连续帧、切源与复位。C11304/05使用原数组ROM；C11306起使用原厂EG_PHY_BRAM和glbl，不定义行为ROM宏。旧ModelSim的声明顺序兼容调整只存在隔离副本，带逆变换与原文一致证明。
- [FFT网表矩阵](fft_netlist/attempt_4_boundary_outputs/summary.json)：共同TB以外部25MHz/复位/PCM输入，对低中高三帧72个频段逐项比较，并检查两次自主重采样。gate列有效证据在 `fft_netlist/attempt_2_guarded`；routed列最终有效证据在 `attempt_4_boundary_outputs`。保留原语参数和被观察逻辑；跨切口同一packed slice另一lane的输出转接dummy，防止回驱外部边界；逐条切口在cone_manifest.json。
- [视频矩阵](video/summary.json)：C11302/04/08/10封存gate在同一TB均locked=1，3完整帧/1440行/921600像素。C11206对照也通过；但其verified manifest没有gate网表条目，使用现存工程gate，来源限制单独标明，不能称网表与稳定bit有冻结哈希绑定。四个失败版gate有精确manifest绑定。
- [负对照](fft_netlist/negative_controls/summary.json)：故意改错一个黄金值，以及故意缺失黄金文件，均被最终断言检出；模拟器进程退出0不会被当作PASS。
- [冻结完整性](archive_integrity.json)与[汇总凭据](summary.json)记录输入、位流关联、执行日志和SHA。

## C11306：仿真能够检出的历史错误

[独立ROM扫描](rtl/coeff_scan/README.md)以原封存系数模块、原厂EG_PHY_BRAM/glbl逐地址比较：C11306 Hann1024字全部正确，twiddle512字全部为0且无未知值，首地址实际00000000、黄金7fff0000；C11307的1536字全部正确。两版INIT/INITP与黄金mem数据相同，差异在twiddle端口/片选/读控制配置。C11306的RTL、gate和修正夹具后的routed FFT均稳定产生24个全零频段。

这证明旧行为ROM模型绕过了真实BRAM端口控制，原来的数学测试不足以覆盖该错误。该历史读回异常不等于已经定位C11309停滞或C11310黑屏的根因，后续版本不能据此重复套用修复。

## 本轮发现并排除的测试夹具问题

1. 早期RTL试跑中，长路径/输入文件未加载后，旧TB仍可能打印PASS。本轮相关结果作废；最终隔离TB逐字检查样本与黄金中的X/未加载值，并使用校验过的简单相对路径输入。
2. 网表矩阵首轮同样有输入路径截断，未采信。`attempt_2_guarded` 的gate结果具有完整输入守卫，仍有效。
3. 通用routed提取器曾将局部同步复位FF输出误作全局reset边界；移除后另在 `attempt_3_reset_closure` 重跑，但仍有假异常。
4. 进一步发现所保留packed slice另一lane仍驱动外部reset边界，形成多驱动。最终显式断开跨切口输出，保留原语参数、输入和被观察输出逻辑，再跑 `attempt_4_boundary_outputs`。旧中间routed失败不得当作硬件故障复现；先前审计note是阶段记录，最终切口证据以各cone_manifest.json为准。

## 仍未覆盖

本轮没有完整真实上电/PLL锁定整机长测、完整SDF、实际TF与外部HDMI电气/接收器验证。视频控制锥不含像素FIFO、PHY和接收器；FFT锥由测试台提供有效PCM，绕过整机启动和真实音频生产链。因此C11309/C11310通过这些用例仍不能证明实板故障消失。

当前没有发布新修复bit。C11312仍为待实板取证诊断候选；后续应把真实故障条件变成修前失败、修后通过的用例，不能继续把局部PASS当整机验收。

## 复跑

从工程根目录运行，仿真过程沿用已有用户许可环境，不写许可正文：

```powershell
pwsh -NoProfile -File development/regression_failed_releases_20261016/rtl/run_retest.ps1
pwsh -NoProfile -File development/regression_failed_releases_20261016/rtl/coeff_scan/run_coeff_scan.ps1
$env:MGLS_LICENSE_FILE=[Environment]::GetEnvironmentVariable('MGLS_LICENSE_FILE','User')
python development/regression_failed_releases_20261016/fft_netlist/run_matrix.py
```

网表运行器默认创建带时间戳的新目录，拒绝覆盖已存在的汇总凭据。视频各版实际命令见video/summary.json；原始日志和中间失败尝试均保留。
'''
(ROOT/'README.md').write_text(report,encoding='utf-8')
print('Report completed:',ROOT/'README.md')
for row in rows: print(row)
