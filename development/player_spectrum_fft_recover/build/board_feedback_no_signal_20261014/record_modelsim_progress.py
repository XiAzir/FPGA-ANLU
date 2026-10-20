from pathlib import Path
from datetime import datetime,timezone,timedelta
root=Path('E:/QQ CACHE/Download/安路资料/开发记录')
now=datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
p=root/'当前状态.md'
s=p.read_text(encoding='utf-8-sig')
lines=s.splitlines()
for i,line in enumerate(lines):
 if line.startswith('更新：'):
  lines[i]=f'更新：{now}（北京时间；C11310实板无信号失败，原厂ModelSim网表验证进行中；尚无新位流交付）。'
  break
s='\n'.join(lines)+'\n'
s=s.replace('**C11310 FFT局部复位/停滞恢复候选已本地交付，实板待验证**','**C11310 FFT局部复位/停滞恢复候选：历史构建证据，现已实板失败**')
old='0. 保留C11309音画正常回退/C11206完整基线；C11310已本地交付（PROGRAM_SRAM/5MHz、DFC11310），下一步核对两音源频谱及音画；若仍空，各音源提供覆盖B/C/F2/F3/F4的数码管视频，用状态、接受样本、局部恢复及切源次数继续定位。'
new='0. 保留C11309音画正常回退/C11206完整基线；C11310已确认实板无信号，停止当作待验证/成功候选。利用本机ModelSim SE原厂EG4库复现HDMI锁定与FFT停滞，再做针对性修复；已有用户回载和数码管视频，不重复索要相同对照。'
s=s.replace(old,new)
entry='- **ModelSim 原厂模型路径已打通**：本机 E:/ModelsimSE/win64 10.1c；用户已有 MGLS_LICENSE_FILE 配置载入当前进程后可运行，未修改许可证。原厂common/eg4库+C11310 routed网表编译通过。受控短测强制PLL ready/跳过20ms等待/选择tone，无TF或接收器模型，sample_count与accepted同步1..4、source-change=1；此测试仅106.3us，不含完整FFT/视频帧。原SDF反标在PLL/PAD/硬SDRAM宏失败；单独保留9761逻辑cell、排除75宏的范围限定副本可反标，负时序限制被旧模型置零，不能称完整STA/整机通过。独立原厂加法原语1024计数向量和边界测试通过；真实原厂HDMI/FFT集成仿真进行中。\n\n'
marker='## 当前阶段\n\n'
if '**ModelSim 原厂模型路径已打通**' not in s:s=s.replace(marker,marker+entry,1)
p.write_text(s,encoding='utf-8')
log=root/'工作日志/2026-10-14.md'
with log.open('a',encoding='utf-8') as f:
 f.write(f'\n### {now[11:]}｜C11310原厂网表仿真接通｜进行中\n\n')
 f.write('- 动作：定位本机ModelSim SE-64 10.1c；编译原厂common/eg4和实际routed网表；只读导出optimized_rtl及原始SDF，未改旧DB/bit/ZIP。受控smoke短测已运行，原厂加法原语测试由审计代理独立完成。\n')
 f.write('- 证据：工程development/player_spectrum_fft_recover/build/board_feedback_no_signal_20261014/modelsim；smoke_control_console.log显示接受计数1..4和切源次数1，现场F4=0未复现；高位events悬空仅为裁剪网表观测限制。原SDF无法匹配PLL/PAD/硬SDRAM时序项，logic-only副本范围及遗漏详sdf_scope.json，负时序限制置零告警保留，不能计完整时序通过。\n')
 f.write('- 更正/防回归：历史2026-10-09已经发现TLAST错误，并证明当时修前修后最终网表一致；本次C11310网表同样无可见TLAST路径。不能据此解释黑屏。隔离C11311只有源码协议修正和构建前视频回归，旧614400像素0TLAST失败、新960TLAST通过，真实时序上游三帧921600像素通过；未TD构建或发布C11311。\n')
 f.write('- 未完成/下一步：真实原厂HDMI集成锁定和FFT系数ROM集成仿真继续；唯一板端原因尚未证明。未JTAG/TF/Flash，不要求用户重复回载。\n')
print(now)
