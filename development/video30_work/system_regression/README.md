# C30 系统离线回归准备

本目录为 `player_video30_probe_prune` 的独立系统回归夹具。候选目录通过 `--player` 指定；所有新建的源码快照、编译产物、波形和日志都写入本目录的 `build/`。生产候选和 C29 源码目录保持只读。

基础来自 `development/player_video27_command_boundary/build/video_system_20261022_171832/`，该快照已有完整 6 次媒体重置序列：4 次图片/视频切换和 2 次视频重播；事件位置覆盖数据区 byte 0、37 与 CRC 区 byte 511、512、513。其 SPI SDHC card model、FAT32 packed-sector 镜像、LBA 映射、PCM gold 和 nominal PLL replay model 已放在 `fixture/`。新 card model 副本只额外统计 CMD0，供独立卡侧会话重初始化检查。

`tb_restart_system.v` 保留真实 RTL 的 SD SPI、FAT/JPEG/WAV 消费路径，检查外置 SPI card model 协议、每个音频有效样本的 PCM、送入真实 JPEG 解码器的文件字节 CRC、每个视频 session 一张完整 640×480 解码 RGB 帧、像素坐标唯一/完整及 RGB 帧 CRC。它还逐 session 检查模式与 CMD0 重初始化。TB 不读取生产 CRC 计数、调试错误码、LED 统计、诊断页或纯观察探针；输入事件在保留的按键分类器输出处注入，与基线夹具一致。

## 命令

仅准备候选冻结源码与可运行夹具，不调用 ModelSim：

```powershell
pwsh -NoProfile -File development/video30_work/system_regression/run_system_regression.ps1 -Player development/player_video30_probe_prune
```

收到主代理运行通知后，启动完整仿真：

```powershell
pwsh -NoProfile -File development/video30_work/system_regression/run_system_regression.ps1 -Execute -Player development/player_video30_probe_prune
```

编译检查可单独执行：

```powershell
pwsh -NoProfile -File development/video30_work/system_regression/run_system_regression.ps1 -Execute -CompileOnly -Player development/player_video30_probe_prune
```

工具由项目 `scripts/anlu_tools.ps1` 的 `Resolve-AnluPython` 解析；ModelSim 默认使用 `E:/ModelsimSE/win64`，也可在执行时设置绝对路径环境变量 `ANLU_MODELSIM_BIN`。完整仿真与 TD 任务串行安排。

可按相同命令先后将 `-Player` 指向 C29 与 C30 两个候选，再用 `compare_system_traces.py` 比较两个输出目录的 RGB 帧 CRC、模式 session、音频样本总数、SPI 读取/命令数和 CMD0 序列。比较器忽略仿真时刻，只对照可观察媒体行为。

当前夹具未运行；运行需要 C30 候选目录已创建并由主代理明确通知。结果指标是离线消费者回归，PLL 为名义边沿回放，SDRAM 使用应用接口模型，无 SDF。按键事件注入分类器输出，实板按键弹跳与 HDMI 物理链路需按各自验证流程处理。
