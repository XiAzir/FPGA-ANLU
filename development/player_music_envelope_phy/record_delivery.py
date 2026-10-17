from pathlib import Path
import json
from datetime import datetime,timezone,timedelta

root=Path('E:/VSCODE-project/FPGA-ANLU')
docs=Path('E:/QQ CACHE/Download/安路资料')
p=Path(__file__).resolve().parent
receipt=json.loads((p/'build/delivery_verified.json').read_text(encoding='utf-8-sig'))
info=json.loads((root/'download/music_envelope_phy.info.json').read_text(encoding='utf-8-sig'))
stamp=datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
topic=docs/'开发记录/专题记录/音频可视化/波形清晰度优化_20261013/C11302包络试验'
folder=topic/'C11303_PHY补强'
folder.mkdir(parents=True,exist_ok=True)
report=f'''# C11303 HDMI PHY 补强候选

时间：{stamp}（北京时间）。本地模型、TD、位流与封存完成，实板仍待验证；成功基线仍 C11206。C11302 的整屏规则绿/彩条与无声已记录为失败，用户同条件回载 C11206 音画恢复。

## 实际改动

隔离工程 `{p}`；仅两处 PHY 功能源及两个 build ID 源不同，其余 81 个 user_source 文件和三个 al_ip 源继承 C11302。包络 RTL 原 SHA 保持，PCM读取/FIFO/bridge、图片缩放、按键、PLL、引脚、SDC不改。

- hdmi_phy_wrapper 在像素下降沿一次寄存四路完整10bit TMDS字，包括三数据lane和clock；所有视频/control/audio data-island走同一捕获级。
- lane marker/toggle 改到像素下降沿，与已有25/125MHz零相位PLL的串行上升沿相隔约4ns；原pending/shift控制序列保持。
- S_oddr_data 两位在串行下降沿准备。官方 EG_LOGIC_ODDR 模型在上升沿同时采D0/D1，D1在随后下降沿发出；因此两位都提前半周期稳定。D0/D1位序和四lane一致性保持。此前历史测试stub使用不同ODDR边沿语义，不能用它证明当前PAD接口；本轮模型重新采用官方语义。

## 证据与验证

用户视频WAV/tone均48000 PCM/名义秒、无欠载，source/FIFO/HDMI-input 32768样本prefix CRC同F485，format错误0；该证据不覆盖核内部/物理发送。异常覆盖FPGA直接生成文字区域，故优先查图音共用发送链。[失败证据](../实板失败_20261013/README.md)。

本轮按官方ODDR语义复用最终生产源做相位/逐位延迟/复位/连续字序模型，四路只允许一次共同整体对齐；28组候选/5077字位置的字、位、目标捕获与独立源序列均0错，并注入D0/D1/PAD clock边界传播延迟作旧失败/新通过反例。具体范围、统计、SHA与限制见[模型凭据]({Path(info['model']).as_posix()})；独立实现审查见[审查报告]({(p/'build/audit/C11303_phy_audit_20261013.md').as_posix()})。延迟都是模拟值，并非板上测量；模型复现机制不能唯一确认实板根因。

最终原约束 STA setup {info['timing']['SWNSns']:+.3f}ns、hold {info['timing']['HWNSns']:+.3f}ns、TNS0，coverage {info['timingCoveragePercent']}%；资源 {info['resource']}。初次路由 hold -0.025ns/HTNS -0.104ns 的DB/报告已保留build/prehold，官方fix_hold后通过。只有输入寄存的早期综合保留build/attempt_input_retime_only，无bit交付。四TMDS端口的外部output delay/板端眼图未表征，内部STA不证明真实链路电气裕量。

## 交付与复核

[交付 ZIP]({Path(receipt['zip']).as_posix()})；位流 [music_envelope_phy.bit]({(root/'download/music_envelope_phy.bit').as_posix()})；操作说明见工程[README]({(p/'README.md').as_posix()})。

- C11303 bit SHA256 `{receipt['bitSha256']}`。
- ZIP SHA256 `{receipt['zipSha256']}`，{receipt['zipMembers']}成员CRC与逐项字节核对通过。
- frozen checkpoint {receipt['checkpointFiles']}项 SHA/大小逐项核验通过，manifest SHA256 `{receipt['manifestSha256']}`。
- C11302原255文件checkpoint逐项核查0差异，原ZIP SHA53457C1D...不变；C11206回退bit SHA C60464C0...不变。

解压到板卡电脑英文路径；BitWriter Add music_envelope_phy.bit，PROGRAM_SRAM /5MHz，Run，D页必须DFC11303。保持现卡/供电/HDMI/音量；先确认默认音乐、图/白字/黑底没有绿/彩条，长KEY1约2秒切内部音阶并回音乐。音画正常后再看HOLD/恢复。异常同条件回载包内bmp_scale.bit。

本轮没有代理JTAG、TF写或Flash操作。候选音画、实卡/接收端、包络观感、长期/重复启动均未验证；不标成功修复或继承旧板测。下一步等待同条件候选实板反馈，再决定是否收敛或继续抓真实发送数据。
'''
(folder/'README.md').write_text(report,encoding='utf-8')
(folder/'delivery_verified.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
state=docs/'开发记录/当前状态.md'
txt=state.read_text(encoding='utf-8-sig')
txt=txt.replace('当前在独立验证串行采样补强方案，尚无新修复位流或实板通过；成功基线 C11206。',f'C11303 PHY补强候选已本地完成：四路完整字在pixel下降沿寄存、toggle同沿、ODDR两位在serial下降沿准备，最终setup+0.119/hold+0.024/TNS0，模型与封存核验通过；实板待验证，根因未唯一确认。[候选与操作](专题记录/音频可视化/波形清晰度优化_20261013/C11302包络试验/C11303_PHY补强/README.md)。成功基线C11206不变。')
lines=txt.splitlines()
lines[2]=f'更新：{stamp}（北京时间；C11302实板失败，C11303 PHY补强候选本地交付/实板pending，成功基线C11206）。'
txt='\n'.join(lines)+'\n'
txt=txt.replace('2. 当前开发：C11302花屏/无声已由用户反馈与视频确认，C11206同条件回载正常。先完成HDMI发送链分层排查与隔离候选的模型/原约束STA；候选交付后做同条件音画/长KEY1两音源对照，C11206继续回退。','2. 当前开发：C11302花屏/无声失败，C11206同条件回载正常；C11303 PHY补强候选已交付，等待同条件默认音乐/长KEY1两音源与图/白字/黑底对照。异常继续回C11206。候选不能标成功修复，实际发送链根因/板端裕量未测。')
state.write_text(txt,encoding='utf-8')
with (topic/'README.md').open('a',encoding='utf-8') as f:
 f.write(f'\n### {stamp}｜失败后 PHY 补强候选交付，实板待验证\n\nC11302用户确认花屏/无声，同条件C11206回退恢复；原位流/255文件checkpoint/ZIP保持，live状态改FAILED。[实板失败取证](实板失败_20261013/README.md)。独立C11303补强四路TMDS捕获与ODDR提前半周期准备，模型/最终原约束STA/封存通过，尚无候选板测或唯一物理根因。[候选与操作](C11303_PHY补强/README.md)。\n')
with (docs/'开发记录/工作日志/2026-10-13.md').open('a',encoding='utf-8') as f:
 f.write(f'\n### {stamp[11:]}｜C11303 HDMI PHY补强候选｜本地交付完成，实板未完成\n\n- 动作/产物：从C11302隔离player_music_envelope_phy；改wrapper整字pixel下降捕获、lane toggle下降及ODDR整对serial下降准备，两个BUILD_ID改C11303；包络与其他81user_source/三个al_ip文件不改。交付{receipt["zip"]}，bit SHA{receipt["bitSha256"]}；详细[交付证据](../专题记录/音频可视化/波形清晰度优化_20261013/C11302包络试验/C11303_PHY补强/README.md)。\n- 验证/结论：按官方ODDR两输入同posedge捕获语义运行最终源四lane固定统一对齐/相位/传播延迟/两次reset模型通过，PAD延迟反例旧失败/新通过，模拟delay不代表实测。初次hold-0.025/-0.104保留prehold，经fix_hold最终+.119/+.024/TNS0 coverage99.98%，资源{info["resource"]}。{receipt["checkpointFiles"]}项manifest、ZIP{receipt["zipMembers"]}项与位流/成功回退核验通过；C11302原255项及原ZIP逐项不变。\n- 未完成/影响：实板音画/两音源/HOLD/包络观感及长期未验证；输出delay/眼图未表征，唯一实板根因未确认。没有代理JTAG/TF/Flash。C11206仍成功基线。\n- 下一步：用户PROGRAM_SRAM下载候选D页DFC11303，同卡供电HDMI音量确认图/白字黑底、默认音乐及長KEY1两音源；异常回载包内C11206，继续分层真实发送链取证。\n')
print(json.dumps({'recordedBeijing':stamp,'document':str(folder/'README.md'),'boardStatus':'PENDING_BOARD_VALIDATION'},ensure_ascii=False))
