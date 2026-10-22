# Video23 冷启动挂载与 CMD16 隔离审查

日期：2026-10-22（依据本专题文件日期整理；不代表所有实验的精确执行时间）  
状态：阶段性调查完成；实板根因与候选验证未完成。

## 现场反馈

- 用户反馈：C11323 上电显示 `00C11323 / 24000080 / 00000000`，`fs_error=1`、`ready=0`、错误码 `08=E_TIMEOUT`，未完成 SD 扇区读取。
- 后续用户反馈：同一 TF 卡和接线重载 C22 后，图片与声音恢复；仍有杂音和偶发切换黑屏。
- 父任务报告：C24 的 `SPI_HIGH_SPEED_DIV=2` 候选已独立编译，数字卡模型可解出首帧；尚无 C24 实板结果。此项为父任务转述。

## 静态核查

- C22 与 C23 的 `fat32_catalog.v`、`spi_master.v`、`sd_card_cmd.v` 源哈希相同。SD 扇区控制器差异仅增加 `sd_idle` 状态输出及顶层转接。
- C23 的 catalog 与 SD 卡控制器使用冷启动复位 `rst_all_reg`。在 `fs_ready=0` 时，`fs_read` 直通 SD 卡；挂载后才由 gate 抑制新的 mapper 读取。静态逻辑未显示 quiesce gate 阻断冷启动挂载。
- 发现初始化边界：CMD41 成功时驱动即置 `sd_init_done=1`，然后发送 CMD16。CMD16 失败会回到 CMD55；此时卡已初始化，CMD55 返回 R1 `00`，而驱动仍要求 `01`，使初始化重试循环。现场卡是否曾拒绝 CMD16 尚无证据。
- 此工程以 ACMD41 的 HCS=1 初始化 SDHC/SDXC，并用 CMD17 以扇区 LBA 读取。SD Association 简化规范说明 SDHC/SDXC 的 memory 操作固定 512 字节，CMD16 不影响这些操作，因此当前读卡路径无需 CMD16。来源：[SDA 简化规范下载页](https://www.sdcard.org/downloads/pls/)；[官方 v7.10 PDF](https://www.sdcard.org/cms/wp-content/themes/sdcard-org/dl.php?f=Part1_Physical_Layer_Simplified_Specification_Ver7.10.pdf)。

## 仿真证据

仿真使用本专题的数字 SD 卡模型与工程内存映射文件；属于数字模型结果，未覆盖实体卡模拟特性或板级信号完整性。

| 情形 | 结果 | 证据 |
| --- | --- | --- |
| C23 正常冷启动 | 挂载成功，完成 3 次读取；CMD16/55/41 均成功一次 | [运行脚本](run_c23_cold_mount.ps1)、[日志](cold_mount_run.log) |
| C23 注入 CMD16 R1=04 | catalog 等待 LBA0 后以 `E_TIMEOUT` 结束；`card_init_done` 已置高，CMD55 计数 68，CMD17 读取 0 | [运行脚本](run_c23_cold_mount.ps1)、[日志](cold_mount_run.log) |
| C22 透明 `sd_idle` 端口 shim | 正常冷启动挂载成功；注入 CMD16 拒绝时复现相同超时循环 | [运行脚本](run_c22_cold_mount.ps1)、[日志](c22_cold_mount_run.log) |
| 隔离的跳过 CMD16 候选 | 卡模型预置一次 CMD16 拒绝，但候选不发送 CMD16；挂载成功，完成 3 次读取，CMD16 计数 0 | [运行脚本](run_skip_cmd16_candidate.ps1)、[日志](skip_cmd16_run.log) |

CMD16 拒绝属于模型注入故障行为，只证明该错误路径存在，不构成现场根因证明。

## 隔离候选

候选文件：[skip_cmd16/sd_card_sec_read_write.v](skip_cmd16/sd_card_sec_read_write.v)。相对 C23 原文件的唯一功能改动为移除 `S_CMD16`，CMD41 成功后直接进入 `S_WAIT_READ_WRITE`；保持原有 `sd_init_done` 时序及高速分频设置。精确比较命令：

```powershell
git diff --no-index -- development/player_video23_mode_switch/src/user_source/hdl_source/SD/sd_card_sec_read_write.v development/video23_work/startup_review/skip_cmd16/sd_card_sec_read_write.v
```

该候选仍是隔离实验版本；尚未移入 C23/C24 原工程，尚未综合、布局布线或上板。C23/C24 源码与已交付位流未在本专题工作中修改。

## SPI 采样风险与下一步

- C23 的 SDC 注明板级 SPI I/O delay 尚未表征；`sd_miso` 没有 input delay，`sd_dclk/sd_mosi/sd_ncs` 没有 output delay。
- 同一 `spi_master.v` 的 mode3 数字延迟模型显示：12.5 MHz 时 MISO 延迟 35 ns 通过、55 ns 失败；6.25 MHz 时 75 ns 通过、85 ns 失败。证据：[SPI 速率可行性日志](../../spi_rate_feasibility_20261021/build/run.log)。这只是模型中的数字时序边界，未证明板级余量；布局变化导致的 MISO 采样问题仍待验证。
- 延后一拍采样仅为后续隔离实验方向，尚未实施。先取得 C24 实板结果，再决定是否单独验证采样相位。
- 建议下一步：保留已交付版本；如继续验证 CMD16 候选，基于独立 C25 副本只应用本专题这一项改动，完成编译/时序检查后再做实板冷启动挂载观察；同时记录屏显、`fs_error`、`ready`、首扇区读取、音频和切换黑屏情况。

## 未完成与影响

- 未证明现场 TF 卡曾拒绝 CMD16；跳过 CMD16 的仿真候选尚无实板验证。
- C24 降速后的实板结果缺失，SPI 板级 I/O delay 未约束；因此启动失败与音频杂音、切换黑屏的关联仍待确认。
- 当前材料支持将 CMD16 失败重试作为可复现故障边界，并支持后续单变量候选评估；尚不足以将其定为现场根因或判断最终修复效果。

## 版本与复现实验 SHA256

以下哈希由本次核对时对工作区文件计算（SHA-256），用于固定基线与复现实验材料身份：

| 文件 | SHA256 |
| --- | --- |
| C22 `fat32_catalog.v` | `CEBA12AAB36AD403D789FDFE8CF6692B841F83888A6622752657F47066CF7AA5` |
| C23 `fat32_catalog.v` | `CEBA12AAB36AD403D789FDFE8CF6692B841F83888A6622752657F47066CF7AA5` |
| C22 `spi_master.v` | `37F7A21144FA5CCA3CC5C3B5F68A5AD40B3108336B600E45A1367734AC61403C` |
| C23 `spi_master.v` | `37F7A21144FA5CCA3CC5C3B5F68A5AD40B3108336B600E45A1367734AC61403C` |
| C22 `sd_card_cmd.v` | `617AC307A4DAEE159A09DE5AA87E52BA3D978B78FF8EC60B8701FA5DC4554BD0` |
| C23 `sd_card_cmd.v` | `617AC307A4DAEE159A09DE5AA87E52BA3D978B78FF8EC60B8701FA5DC4554BD0` |
| C22 `sd_card_sec_read_write.v` | `2B2BF70BBBEF57945EAF202073D0F6FAD7FA86A41453FA33CEC0CDFAC7E2833D` |
| C23 `sd_card_sec_read_write.v` | `A5230084CBC6C87A070CB53F99B5DBEE5D8DAA90B7049A881CEF041ED34EE1C6` |
| 隔离 skip-CMD16 候选 `sd_card_sec_read_write.v` | `C564981202AC07C103D8EFDCF9C024D2A2B71873A6742EEDDC4866BCAC375857` |
| 注入模型 `sd_spi_card_model_fault.v` | `C77647871C784E0FCF574F039E9B96896C834866B75B52CDD40E2D9D4C5A0BDA` |
| 冷启动测试台 `tb_c23_cold_mount.v` | `CCA39B7FBECC2E323B1326B44D7F1CA3319CC65E0F53262500B7F33313984354` |
| C23 运行脚本 `run_c23_cold_mount.ps1` | `A5BC046021D7D440166A40E97F769D065E50994C62825B68106E3DA8F5947F0D` |
| C22 运行脚本 `run_c22_cold_mount.ps1` | `E54AA0767FCBF7EDD4859F256D5B5B577389AA6967F87579E66BE93A06C403FD` |

C22/C23 的 `fat32_catalog.v`、`spi_master.v`、`sd_card_cmd.v` 哈希一致。两版 `sd_card_sec_read_write.v` 内容差异为 C23 增加 `sd_idle` 输出及其 `state == S_WAIT_READ_WRITE` 指示赋值；C22 冷启动复测采用隔离副本并加透明端口 shim。拒绝注入差分和跳过 CMD16 候选结果见上方仿真证据与隔离候选章节。
