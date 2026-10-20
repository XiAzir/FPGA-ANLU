from pathlib import Path
from datetime import datetime,timezone,timedelta
import json,re,shutil
p=Path(__file__).resolve().parent
docs=Path('E:/QQ CACHE/Download/安路资料/开发记录')
r=json.loads((p/'build/delivery_verified.json').read_text(encoding='utf-8-sig'))
assert r['status']=='LOCAL_CANDIDATE_DELIVERED_BOARD_PENDING'
stamp=datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
topic=docs/'专题记录/音频可视化/频谱柱_C11304_20261013/C11310_FFT局部复位与恢复'
topic.mkdir(exist_ok=False)
shutil.copyfile(p/'build/delivery/README.md',topic/'README.md')
shutil.copyfile(p/'build/delivery_verified.json',topic/'delivery_verified.json')
summary=f"**C11310 FFT局部复位/停滞恢复候选已本地交付，实板待验证**：独立工程player_spectrum_fft_recover，仅analyzer/renderer-wrapper/top被动诊断/status四源修改；FFT内部异步复位两pixel拍释放、5位binary none/default容错、4096输入有效采样无帧时局部恢复，无反馈到音频或全局复位。312合成/48真实WAV/72集成段定点误差0、650独立像素/遥测/状态页/595模型通过；真实WAV和恢复模型默认4096/521clk，加速夹具timeout0明确仅数学用途。恢复模型注入非法态/停滞后不用全局复位即可输出下一帧。TD同源syn/phy/nativehold/bit，setup+{r['timing']['SWNSns']:.3f}/hold+{r['timing']['HWNSns']:.3f}ns/TNS0，17001LUT/10085reg/18508LE/44BRAM/12DSP/3GCLK；gate/routed时钟各45检查、1536系数INIT通过。原ROM参数SIG→INV逐字FAIL保留，补充按实际双lane逻辑穷举32态有效启用证明PASS。{r['files']}文件冻结/ZIP成员逐字验证，旧C11309 240冻结/bit/ZIP与C11206回退不变。PROGRAM_SRAM/5MHz、DFC11310、spectrum_fft_recover.bit；启动4秒自检后32秒16页循环，F2=state5+capture10+window9，F3=00恢复8+切源8，F4=接受样本24。实板停滞物理根因仍未确定，protected BRAM/外部HDMI电气未验证，未JTAG/TF/Flash。[包与操作](专题记录/音频可视化/频谱柱_C11304_20261013/C11310_FFT局部复位与恢复/README.md)。"
text=f"""
## 交付凭据与当前证据

- 记录时间：{stamp}（北京时间）；状态：本地候选交付，实板待验证。
- 候选：[完整包]({r['zip'].replace(chr(92),'/')})；[直接bit](E:/VSCODE-project/FPGA-ANLU/download/spectrum_fft_recover.bit)。
- bit {r['bitBytes']}字节，SHA256 {r['bitSha256']}；ZIP {r['zipSha256']}。
- 冻结 {r['files']} 文件，manifest {r['manifestSha256']}；清单逐项长度/SHA、ZIP全部成员逐字核验，C11309旧240冻结/bit/ZIP及C11206成功bit不变。
- {summary}
- 当前源绑定[模型结果](E:/VSCODE-project/FPGA-ANLU/development/player_spectrum_fft_recover/build/model/model_result.json)；[时钟审计](E:/VSCODE-project/FPGA-ANLU/development/player_spectrum_fft_recover/build/audit/routed_clock_route.md)；[ROM有效极性证明](E:/VSCODE-project/FPGA-ANLU/development/player_spectrum_fft_recover/build/audit/rom_polarity_evidence.md)。
- 原控制参数逐字审计发现SIG→INV差异，原FAIL不覆盖。另读取实际gate/routed逻辑、正确区分双lane LUT/FF与组合解码，穷举32状态有效Hann/twiddle使能后PASS，不以“应该是优化”猜测放行。
- 用户C11309视频分别1.947511/2.613400秒，WAV/tone均B7000000/C7840000，tone有声且无频谱；没有D页独立版本读数，版本按上下文。完成帧0，C84仅PCM曾见/空前台曾commit，无系数非零标记；系数全0也应推进固定FFT控制，支持先定位控制进度，未证实具体硅上根因。
- 视频输入与提帧原证据在 development/player_spectrum_clock_route/build/board_feedback_spectrum。未执行JTAG、TF写入或Flash，未进行厂商protected BRAM行为仿真或实物电气测量。布局改变仍需实板检验，音画代码继承不能作为新位流实板保证。
- 下一步：用户PROGRAM_SRAM/JTAG5MHz加载DFC11310，看默认音乐和内置音阶两种频谱及音画；如仍空，各音源录至少36秒，覆盖B/C/F2/F3/F4数码管，以新状态/事件/接受采样值继续定位。无需重装TF素材。
"""
with (topic/'README.md').open('a',encoding='utf-8') as f:f.write(text)
status=docs/'当前状态.md'
s=status.read_text(encoding='utf-8-sig')
s=re.sub(r'^更新：.*$',f'更新：{stamp}（北京时间；C11309音画正常、两音源空频谱；C11310局部恢复候选已交付，实板待验证）。',s,count=1,flags=re.M)
s=re.sub(r'^- \*\*C11310 .*$',f'- {summary}',s,count=1,flags=re.M)
s=re.sub(r'^0\\. C11309两短视频.*$', '0. 保留C11309音画正常回退/C11206完整基线；下载C11310（PROGRAM_SRAM/5MHz、DFC11310）核对两音源频谱及音画；若仍空，各音源提供B/C/F2/F3/F4覆盖视频，用状态/接受样本/局部恢复/切源次数继续定位。',s,count=1,flags=re.M)
status.write_text(s,encoding='utf-8')
with (docs/'工作日志/2026-10-14.md').open('a',encoding='utf-8') as f:
 f.write(f'\n### {stamp[11:16]}｜C11310 FFT局部恢复候选交付｜本地已完成，实板待验证\n\n- {summary}\n- bit SHA {r["bitSha256"]}，ZIP {r["zipSha256"]}；manifest {r["manifestSha256"]}。证据和交付凭据见专题。此前ROM极性解析未完成的阶段结论已被实际lane控制真值证明更新，原逐字审计FAIL保留。\n- 动作未包含远程板卡下载/TF改写/Flash固化；用户上板反馈仍为依赖，真实物理根因未确定。下一步两音源频谱验证；若空按新诊断继续。\n')
print(f'Delivery and pending-board status recorded: {topic}')

