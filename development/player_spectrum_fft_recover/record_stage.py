from pathlib import Path
from datetime import datetime,timezone,timedelta
import json,re,shutil
p=Path(__file__).resolve().parent
old=p.parent/'player_spectrum_clock_route'
docs=Path('E:/QQ CACHE/Download/安路资料/开发记录')
stamp=datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
f=old/'build/board_feedback_spectrum/feedback.json'
v=json.loads(f.read_text(encoding='utf-8-sig'))
v['latestObservations']={'videoBefore':r'E:/QQ CACHE/LiaoTianJiLu/Tencent Files/1791081637/nt_qq/nt_data/Video/2026-10/Ori/b62a8133556ac56034e06fa622813f67.mp4','videoAfter':r'E:/QQ CACHE/LiaoTianJiLu/Tencent Files/1791081637/nt_qq/nt_data/Video/2026-10/Ori/357012dd211ec9952d2dce0bbb2ce16c.mp4','durationsSeconds':[1.947511,2.613400],'both':['B7000000','C7840000'],'toneSpectrum':'User confirms also empty with audible scale'}
v['decode']='Capture CRC flags7; FFT completed0; payload840000=PCM seen and empty front commit only. No FFT/band/nonzero coefficient/front-height flags. Not enough to identify current FSM state; zero coefficients alone would not block fixed frame progression.'
v['next']='C11310 FFT-local synchronized-release asynchronous reset, retained binary/default recovery,4096 incoming-sample watchdog and state/accepted/recovery/source-event diagnosis; math/model/TD required before delivery.'
f.write_text(json.dumps(v,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
root=p.parents[1]
for target in (root/'download/spectrum_clock_route.info.json',old/'build/manual/AC201_player_spectrum_clock_route.info.json'):
    x=json.loads(target.read_text(encoding='utf-8-sig'));x['boardFeedback']=v
    target.write_text(json.dumps(x,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
with (docs/'工作日志/2026-10-14.md').open('a',encoding='utf-8') as log:
    log.write(f'\n### {stamp[11:16]}｜C11309两音源FFT未完成与C11310局部恢复｜进行中\n\n- 用户两短视频实际1.9475/2.6134秒，均读B7000000→C7840000；tone有声音而频谱也空。B后六位FFT0；C载荷840000仅PCM见过/空bank前台commit，非FFT完成证明。无法独立D页确认版本，仍按上下文。没有把C84当作当前持续48k输入或系数故障的唯一证明。\n- 控制审计：计算阶段不等待BRAM数据，系数0也会完成帧；两版17位one_hot同步复位源rst_all||source_change逻辑一致。优先FSM/样本推进/复位重复定位，具体物理根因未定。\n- 已读本地TD SWUG106 4.2.7(p38-39)/4.2.8(p40-41)，none保留用户编码及容错逻辑。C11310独立player_spectrum_fft_recover：仅FFT内部复位异步置位/两pixel同步释放、5位binary none、显式default freshcapture、4096有效输入脉冲无frame完成时局部恢复；F2状态/样本/窗计数、F3恢复/切源事件、F4接受样本。系统音画/PHY/PLL/TF代码继承C11309。\n- 当前TD综合认证PASS并确认5位state（无原17位重编码），布线进行中；状态页含F2/F3/F4模型PASS，FFT数学/渲染回归与默认生产4096恢复模型独立验证进行中。快速数学仿真禁WD只为加速，不能充当生产WD证明。未位流/交付/实板，不动原240冻结/bit/ZIP、未JTAG/TF/Flash。\n- 下一步完整数学/默认WD和物理时序/ROM/clock审计后交付，保留稳定C11309回退；若新频谱仍空，F2/F3/F4将给出具体控制阶段。\n')
status=docs/'当前状态.md';s=status.read_text(encoding='utf-8-sig')
s=re.sub(r'^更新：.*$',f'更新：{stamp}（北京时间；C11309音画正常、两音源B0/C84空频谱；C11310仅FFT局部复位/恢复与进度诊断进行中，旧稳定音画保留）。',s,count=1,flags=re.M)
s=re.sub(r'^0\. 保留音画正常.*$', '0. C11309两短视频均B7000000/C7840000，tone也空；输入见过但FFT完成0，不能用零系数单独解释。C11310独立加强FFT局部复位/保留binary/default与4096样本超时恢复，新增F2/F3/F4状态/事件/接受数；完成数学/生产WD/全TD与封存后交付，原音画路径/240冻结/bit/ZIP保留。',s,count=1,flags=re.M)
status.write_text(s,encoding='utf-8')
print('B0/C84 evidence and local FFT recovery stage recorded')

