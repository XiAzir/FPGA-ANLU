# C11319 / C04 实际 SDRAM 控制器回归

最终结果见 `final_result.json`，状态为 `PASS_AFTER_STARTUP_TRANSIENT`。

有效运行采用 `runs/video_system_C04_20261021_200556` 冻结的 C04 RTL、实际控制器 gate、APUG011 的 IS42s32200 引脚模型与名义 PLL 重放。显式 vopt 的有效参数为 MAPPED_SECTORS=35998、IMAGE_BYTES=536870912、CHECK_FRAMES=2，优化设计名 `work.tb_video_system_opt_35998`。最终完整日志为 `vopt_try_20261021/run_opt_35998_console.log` 与 `run_opt_35998.log`，优化日志为 `vopt_35998.log`。

有效回放于 221 ms 输出 `VIDEO_SYSTEM_PASS`：921600 解码像素、3 次完整帧提交、2 个不同显示帧、6408 个原声 PCM 样本精确匹配，音频欠载和迟帧均为 0。启动约 709～709.2 ns 保留两条 SDRAM 命令错误及三条 hold 诊断；1 us 后运行期模型错误为 0。启动诊断原文和时间逐条写入最终凭据。

本回放使用原 Q95 标准前缀作为较高负载对照。主交付 Q90 的短窗口、全片 reader 与独立 HDMI pin 核验分别保存在其他验证目录。完整 20 秒整机解码、SDF、板卡时钟与实体 SDRAM/TF 持续播放待后续实测。

旧 novopt 的中止 summary、自动优化停滞及默认 300 扇区参数的失败尝试全部原样保留。最终显式 vopt 运行的启动器退出码未采集，完成依据为日志中的 PASS 与 221 ms 正常 testbench `$finish`。最终文件哈希、模型、控制器网表、源 receipt、卡映射、原声参考和参数均在 `final_result.json` 绑定。

重新核对最终证据：

```powershell
python development/video19_work/physical_resume/summarize_final.py
```

源编译入口参考 `run_c04_physical.py`，ModelSim 10.1c 的加速复跑须先对正确参数显式 vopt，再加载 `tb_video_system_opt_35998`。旧运行目录中的 summary 继续描述原 novopt 尝试，最终状态读取本目录的 `final_result.json`。
