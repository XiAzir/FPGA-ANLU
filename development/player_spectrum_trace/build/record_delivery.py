from pathlib import Path
from datetime import datetime,timezone,timedelta
import json,hashlib
p=Path(__file__).resolve().parents[1]
repo=p.parents[1]
docs=Path('E:/QQ CACHE/Download/安路资料/开发记录')
now=datetime.now(timezone(timedelta(hours=8)))
r=json.loads((p/'build/delivery_receipt.json').read_text())
assert r['delivery_hashes_verified']
old_ev=repo/'development/player_spectrum_fft_recover/build/board_feedback_no_signal_20261014'
route_log=old_ev/'modelsim/fft_gate_1015/routed/console.log'
assert 'PASS fft_cone cases=3 bands=72 max_fixedpoint_error=0' in route_log.read_text()
v=json.loads((old_ev/'verification_20261015.json').read_text())
v['routed_fft']={'status':'PASS','cases':3,'bands':72,'fixed_point_errors':0,'original_primitives':485,'BRAM':14,'DSP':1,
                 'scope':'lane-aware closed physical cone, common global reset boundary; unobserved co-packed lanes may be undriven; no SDF/full startup/board proof',
                 'log':str(route_log),'sha256':hashlib.sha256(route_log.read_bytes()).hexdigest()}
(old_ev/'verification_20261015.json').write_text(json.dumps(v,ensure_ascii=False,indent=2),encoding='utf-8')
topic=docs/'专题记录/音频可视化/频谱柱_C11304_20261013/C11312_原子故障快照'
topic.mkdir(parents=True,exist_ok=True)
(topic/'README.md').write_text(f'''# C11312 原子故障快照

时间：{now:%Y-%m-%d %H:%M}（北京时间）。状态：本地诊断候选已交付，实板待取证；C11310根因未确认，未宣称修复。

- 工程：`E:/VSCODE-project/FPGA-ANLU/development/player_spectrum_trace`，来源失败C11310。四处原HDL改动及一个新被动模块；移除观察端口及声明顺序调整后，FFT analyzer/renderer逐token对比不变。PLL/SDC/引脚及媒体控制未改，但新实现会改变物理布局。
- 本轮C11310验证：原gate完整FFT 1029实例/14BRAM/1DSP及routed依赖锥485原语，各3帧72频带定点误差0、自主重采样2次；实际gate视频源至锁定控制1440整行/921600像素，locked1。范围与日志SHA见失败工程 `build/board_feedback_no_signal_20261014/verification_20261015.json`。都未复现现场，非完整SDF/实板证明。
- 诊断触发：原因1为第四SOF时锁定且FFT已运行的参考快照；原因2为第四SOF起仍未锁定；原因3为连续4096有效样本无FFT完成；原因4为允许写入后下一拍sample/accepted增量不符。原因2/3/4冻结相邻两拍的progress/accepted和控制标志；切换音源重装。参考1可被后续故障覆盖。
- 6页显示原因、音源/HDMI/音频/帧标志及前后control；7/8为前后progress；9/A为前后accepted；B/C为捕获时帧数及恢复/切源计数。7..C第二位8表示有效。D=DFC11312。F2/F3/F4仍实时，不能当作原子快照。
- 本地模型：77快照检查；真实FFT+观察器两帧48频带定点零误差；176显示页采样；C11312完整gate/routed原厂模型均完成故障注入、冻结，并将7字全部正确传到mailbox destination。测试台强制PLL ready、快启动和accepted观察故障；不等于已复现原板故障。
- 测试夹具修正留证：FFT集成最初误期望切源后帧数累计2，原设计切源清零，改期望1后通过；全gate测试最初选到参考库旧top，改为优先work并验证加载日志；直接读取被优化裁掉的header常量位会见Z，最终改验实际显示邮箱完整7字；原ROM控制脚本硬编码旧eq14网名被eq15重命名触发，改为绑定实际端口/分析器scope和完整32态真值后通过。旧失败日志保留，均不当作硬件缺陷。
- TD：同源synthesis/physical/hold/bitstream证据绑定通过。初始hold -0.012/TNS -0.016ns已封存 `build/prehold/initial`；官方fix_hold后setup +0.060/hold +0.024ns，TNS0/coverage99.98%。16934LUT/10061reg/18481LE/44BRAM9K/12DSP/3GCLK。1536系数逐字、四ROM读控制32态逻辑及45时钟映射检查通过；原参数字符串SIG/INV不一致FAIL保留，逻辑等价证明单独绑定。
- bit SHA256：`{r['bit_sha256']}`。封存{r['frozen_file_count']}文件，manifest SHA `{r['manifest_sha256']}`；ZIP SHA `{r['zip_sha256']}`，ZIP成员与展开交付逐项核验。
- [诊断ZIP](E:/VSCODE-project/FPGA-ANLU/deliverables/music_spectrum_trace_20261015.zip)，内含spectrum_trace.bit、C11206 bmp_scale.bit、操作说明、离线解码及哈希。旧C11206/C11309/C11310下载位流哈希核对不变。用户本轮确认板卡未连接；没有JTAG/TF/Flash操作。
- 下一步：用户在板卡所接电脑PROGRAM_SRAM/5MHz加载spectrum_trace.bit，确认DFC11312；默认模式先不按KEY1，录40秒可读数码管（6..C及D），提供路径和HDMI/声音/频谱结果。先取一段新原子数据，不要求重录旧实时页或重复既有回载。
''',encoding='utf-8')
log=docs/f'工作日志/{now:%Y-%m-%d}.md'
with log.open('a',encoding='utf-8') as f:
    f.write(f'''\n### {now:%H:%M}｜C11312原子快照诊断包｜本地完成，实板取证待执行

- C11310 gate/routed FFT各72频带零误差及实际gate视频源3整帧locked1；仍未复现现场，根因未确认。新增被动相邻两拍快照，C11312四原源+一模块；观察器无反馈。77单元检查、48真实FFT集成频带、176显示页采样及完整gate/routed故障注入后7字显示邮箱均通过。
- 同源TD四阶段与初始hold失败封存完成；最终setup+0.060/hold+0.024ns/TNS0/coverage99.98%，45时钟映射/1536系数/32态ROM控制等价通过。{r['frozen_file_count']}文件冻结及ZIP成员核验通过。交付ZIP `E:/VSCODE-project/FPGA-ANLU/deliverables/music_spectrum_trace_20261015.zip`；bit SHA `{r['bit_sha256']}`。原稳定和失败包未改，未提交推送或硬件操作。
- 限制：故障注入只验证诊断捕获/传输，不是原故障复现，非完整SDF或板测通过。用户确认板卡未连接；下一步真实加载C11312，默认音乐先录40秒数码管6..C/D的冻结现场及音画结果；之后据快照定向修复。详细证据、夹具更正和边界见[专题](../专题记录/音频可视化/频谱柱_C11304_20261013/C11312_原子故障快照/README.md)。
''')
status=docs/'当前状态.md'
lines=status.read_text(encoding='utf-8-sig').splitlines()
for i,line in enumerate(lines):
    if line.startswith('更新：'):
        lines[i]=f'更新：{now:%Y-%m-%d %H:%M}（北京时间；C11312原子快照诊断包已交付、实板待取证；C11310根因未定）。';break
text='\n'.join(lines)+'\n'
note='- **C11312 原子快照诊断候选本地交付，实板待取证**：从C11310新增只读观察，相邻两拍FFT采样/接受计数及复位/切源/超时在故障时冻结，6..C页改为该快照；DFC11312。77单元/48 FFT集成频带/176显示采样、完整gate/routed故障注入后7字邮箱传输通过；同源TD最终setup+0.060/hold+0.024ns/TNS0，45时钟/1536系数/ROM控制32态核验通过，233文件封存及ZIP成员校验。`download/spectrum_trace.bit` SHA 60AE6B971CE1F9ED09D76BEC14CF88DFC25CDFE7CBBEBE5DD9FC070115B812CE；[交付与边界](专题记录/音频可视化/频谱柱_C11304_20261013/C11312_原子故障快照/README.md)。这不是已确认修复版；用户当前板卡未连接，待默认音乐40秒数码管6..C/D新取证，未JTAG/TF/Flash。\n\n'
text=text.replace('## 当前阶段\n\n','## 当前阶段\n\n'+note,1)
status.write_text(text,encoding='utf-8')
print('Delivery and pending hardware evidence recorded; root cause remains open.')
