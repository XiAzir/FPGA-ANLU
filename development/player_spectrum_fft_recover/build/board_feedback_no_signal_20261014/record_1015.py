from pathlib import Path
from datetime import datetime,timezone,timedelta
import hashlib,json

ev=Path(__file__).resolve().parent
docs=Path('E:/QQ CACHE/Download/安路资料/开发记录')
now=datetime.now(timezone(timedelta(hours=8)))
fft=ev/'modelsim/fft_gate_1015/cone_console.log'
video=ev/'video_modelsim/full_gate_1015/console.log'
assert 'PASS fft_cone cases=3 bands=72 max_fixedpoint_error=0' in fft.read_text()
assert 'PASS video_full_cone lock=1 full_lines=1440' in video.read_text()
evidence={'time':now.isoformat(),'scope':'gate-level functional cones; no SDF; not board pass',
          'fft':'3 tones, 72 bands, exact fixed-point output, 3 frames/2 recaptures, original 14 BRAM and 1 DSP',
          'video':'actual gate video timing/source through HDMI lock logic, 1440 lines/921600 completed pixels, locked=1; no data FIFO or PHY',
          'files':{str(p.relative_to(ev)):hashlib.sha256(p.read_bytes()).hexdigest() for p in (fft,video,fft.parent/'cone_manifest.json',video.parent/'cone_manifest.json')},
          'board':'user: currently not connected','new_bitstream':False,'root_cause':'not yet determined'}
(ev/'verification_20261015.json').write_text(json.dumps(evidence,ensure_ascii=False,indent=2),encoding='utf-8')
entry=f'''### {now:%H:%M}｜C11310门级完整FFT及视频锁定接续｜局部验证通过，实板根因未定

- 动作：从C11310原综合网表逐实例提取并闭合依赖，FFT 1029实例/381 FF/14 BRAM/1 DSP；视频源到锁定控制241实例/131 FF。原始原语、RAM及乘法器未替换；本机ModelSim SE10.1c原厂库实跑，未修改生产源、旧位流、ZIP或冻结检查点。用户确认目前板卡未连接。
- 证据：工程 development/player_spectrum_fft_recover/build/board_feedback_no_signal_20261014/verification_20261015.json 绑定日志与manifest SHA。modelsim/fft_gate_1015/cone_console.log：低/中/高频三帧、72频段逐项定点误差0，连续自主重采样2次，accepted累计3072。video_modelsim/full_gate_1015/console.log：真实gate视频时序/valid/user到锁定控制，1440整行/921600完整像素、下一帧首像素时locked=1。
- 边界：上述为无SDF、外部25MHz及全局复位激励的功能锥；视频不含像素数据FIFO/PHY/接收器，FFT不含全机启动及板端状态。全routed完整顶层长测因运行速度未完成，中止日志保留；vopt启动未完成，不计通过。routed FFT抽取仍在完善；不能用门级通过宣称C11310已修好。
- 历史接续：已核对10月11日ChipWatcher源IP物理断言、gate插入资源/自动1ns约束时序失败记录，不再假定现成ChipWatcher方案可直接交付。现有F2/F3/F4并非原子快照，原厂模型未复现实板同时locked0/FFT帧0/F4零。
- 下一步：完成routed受控FFT及复位路径核对，继续寻找能复现现场失败的条件；若离线模型仍不复现，准备明确触发和信号范围的板内取证，先完成诊断实现与本地验证后再交用户采样。未JTAG/TF/Flash，无新交付位流。

'''
log=docs/f'工作日志/{now:%Y-%m-%d}.md'
with log.open('a',encoding='utf-8') as f:f.write('\n'+entry)
p=docs/'当前状态.md'
lines=p.read_text(encoding='utf-8-sig').splitlines()
for i,line in enumerate(lines):
    if line.startswith('更新：'):
        lines[i]=f'更新：{now:%Y-%m-%d %H:%M}（北京时间；C11310门级FFT72频段及实际门级视频源到锁定控制通过；实板根因仍未定，无新位流）。';break
text='\n'.join(lines)+'\n'
marker='## 当前阶段\n\n'
note='- **2026-10-15接续**：C11310原综合网表完整FFT依赖锥实跑3帧/72频段定点误差0（14 BRAM/1 DSP/自主重采样）；真实gate视频源时序到HDMI锁定控制3整帧/1440行/921600像素，locked=1。均为功能锥、无SDF，不替代routed全机或板测；实板locked0/FFT帧0矛盾未复现。用户确认当前板卡未连接；无新bit。证据与下一步见[今日日志](工作日志/2026-10-15.md)。\n\n'
if '**2026-10-15接续**' not in text:text=text.replace(marker,marker+note,1)
p.write_text(text,encoding='utf-8')
print('Recorded gate FFT/video functional scope; root cause open; no bitstream.')
