# PLL 原厂模型初始化校准

## 结论

结果状态为 `MODEL_CALIBRATION_FAILED`：使用未修改的 EG4 原厂 `EG_PHY_PLL` 模型、两个生产 wrapper 参数和复位输入固定为 0 时，sys/video 的 `extlock` 到 1 ms 仍均为 0。它的分频时钟正常运行，1 ms 采样内部 `fakelockcnt=xxxx`；`lock_cnt`、`int_lock` 已推进，参考时钟监测为 1。这个结果说明该模型条件不能用来验收固定复位 0 的上电行为，不能当作板卡 PLL 实际失败，也不支持把生产 PLL reset 改成高电平作为黑屏修复。

仅为定位模型状态，测试台加了 120 ns 高脉冲后，两路均锁定：sys 约 946 ns、video 约 1.202 µs。另一个隔离实验将原厂模型复制到本目录，只给 `fakelockcnt` 声明增加 `=4'b0`，原 reset=0 场景两路都约 945 ns 锁定。这一适配状态标记为 `MODEL_INIT_ADAPTER_FUNCTIONAL_PASS`，只说明该单行初始化假设能令仿真模型工作，不能等同原厂模型通过或生产 RTL/硬件修复。

复位脉冲与本地初始化适配都不是稳定生产 top 的输入行为。统一入口应继续把原厂 reset=0 场景列为模型缺口，不应 force extlock 或跳过启动等待来报告整机通过。

## 复跑

在 Windows PowerShell 7 执行：

```powershell
& 'E:\VSCODE-project\FPGA-ANLU\development\system_verification_20261016\pll\run.ps1'
```

脚本从当前用户环境继承 `MGLS_LICENSE_FILE`，使用 ModelSim SE-64 10.1c。它先编译本地 wrapper 与测试台，分别运行原厂库下的 `no_reset`、`reset_pulse`，最后在独立 `adapter_work` 库编译模型副本并运行 `adapter_no_reset`。日志必须显示 `work.sys_pll`、`work.video_pll`、原厂 `EG4.EG_PHY_PLL`，以及适配试验使用的 `adapter_work.EG_PHY_PLL`。

## 证据

- `no_reset.log`：1、100、1000 µs 采样；extlock 始终 0；`fakelockcnt=xxxx`；原厂模型库已加载；输出周期为 pclk 40 ns、serclk 8 ns。
- `reset_pulse.log`：测试台单独脉冲对照；1 µs 时 sys 已锁、video 未锁，100 µs 时两者均锁。
- `adapter_no_reset.log`：固定 reset=0；本地适配模型两者均在约 945 ns 锁定；周期 40 ns 和 8 ns。
- `summary.json`：机器可读的总状态、分组结果、锁定时间、模型/包装器 SHA256 和适配器结论。
- `tb_pll_reset_calibration.v`、`run.ps1`：可复跑测试台和命令入口。
- `eg_phy_pll_init_adapter.v` 与 `adapter_diff.txt`：本目录中的临时实验副本与单行差异。安装目录中的原厂模型没有修改。

稳定 C11206 封存 checkpoint 为 `player_bmp_scale/checkpoints/bmp_scale_20261012_verified`。sys_pll 与 video_pll wrapper 分别与 C11310 当前源码逐字节 SHA256 相同：`4A410FC8776C9C116695B7DD8A84012317F9D88AA654B8287A89BDC1F88D0B4E`、`57E45A062814673E97773CF6C58FF1629FA45895E30DE9D2C2B6BDD30BD9BB13`。参数因此也完全一致：sys PLL 使用 50 MHz 参考、输出分频 20/20/20 且相位参数 19/19/7；video PLL 使用参考分频 2，输出分频 40/8、相位 39/7。

验证只覆盖两个 PLL wrapper 在理想 50 MHz 输入下的仿真模型启动/输出周期，不包含真实 FPGA PLL、整机时钟域或板上 HDMI 电气行为。
