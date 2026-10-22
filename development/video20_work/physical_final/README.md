# C11320 Physical SDRAM Final Attempt

## 最终结果：2026-10-22 11:05 已完成

`checkpointed_20261022/start_exit.json` 记录vsim正常退出0；`start_console.log` 在221ms输出VIDEO_SYSTEM_PASS：1008128解码像素、3 commits、2不同显示内容帧、6408原声样本，欠载0、迟帧0。原108峰值帧48.25877ms，在50ms预算内余量1.74123ms；第三帧48.40089ms。五条709ns启动诊断原样保留，运行期模型错误0，最终状态PASS_AFTER_STARTUP_TRANSIENT。

本次复用先前成功的no-acc优化设计，单独启动vsim；未再次运行vopt，因此最终结果中vopt_exit_code为null、reused_optimization为true。755项输入/编译设计文件哈希核对通过，见`checkpointed_20261022/run_input_binding.json`。六个仿真检查点均已保存；本次从头连续完成，未使用restore。

机器可读结果为`final_result.json`；汇总命令：

```powershell
python development/video20_work/physical_final/summarize_final.py --exit-json development/video20_work/physical_final/checkpointed_20261022/start_exit.json --log development/video20_work/physical_final/checkpointed_20261022/start_console.log --runner development/video20_work/physical_final/run_checkpointed.ps1 --reused-optimization
```

验证使用冻结C11320 RTL、未改动的SHA绑定SDRAM控制器gate、APUG011 IS42s32200引脚模型与名义PLL重放。SDF、实体板卡和完整20秒持续播放待后续验证。

## 历史准备和中断阶段（保留原记录）

本目录保存冻结 run `E:/VSCODE-project/FPGA-ANLU/development/player_video20/build/video_system_20261021_215714` 的独立输入副本、隔离 work 库和最终尝试记录。`source_receipt.json` 保留 `inputs` / `compatibility` schema；本地 304 项绑定检查通过，父侧最新 967 项源绑定检查也通过。

当前状态为 `RUNNING`。执行环境于 2026-10-21 22:44 恢复 ModelSim 进程启动；22:45 开始本轮 no-acc vopt，随后于 22:45:34 启动真实 SDRAM 仿真。最新日志到 120 ms，pixels=506624、commits=1、display=0、PCM=1608、sectors=139，SDRAM memory `ready=1`。完整仿真结果和 exit JSON 尚未生成，当前不据此判定 PASS。

早先环境阻塞尝试单独保存在 `final_result_envblocked_20261021_224339.json`，其中的 WinError 623 状态只描述当时的创建进程失败。更早的冻结 run 停在 100 ms 且无 `VIDEO_SYSTEM_PASS`，也仅作为中断进度证据。

本轮日志在 709.0 ns 出现两条器件启动命令/时序诊断；709.2 ns 出现 Ras_n、Cas_n、We_n 三条 specify hold 检查，共五条。它们归类为 1 us 内的 SDRAM 启动诊断；运行期是否有模型错误，待最终日志汇总。

冻结链使用 unchanged、SHA-bound SDRAM controller gate 与 APUG011 `IS42s32200` 模型，不含 SDF；卡镜像参数为 `MAPPED_SECTORS=29686`、`IMAGE_BYTES=536870912`、`CHECK_FRAMES=2`，启动参数 `+AUDIO_PHASE=800`。使用 nominal PLL replay。仿真库从旧 run 复制到本目录的 `work`，`modelsim.ini` 的本地 `work` 映射指向该副本，优化输出也写入此隔离库。

日志、exit JSON 与完整度量会在仿真结束后由 [summarize_final.py](summarize_final.py) 汇总为 [final_result.json](final_result.json)。source receipt SHA-256 为 `F4E8D9EA649DC09F8611E6A8EFDA437A56E781EB2A88EC2C694B9E4ACF720B66`。
