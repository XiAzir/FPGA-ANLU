# C11322 模式切换排空握手原型

日期：2026-10-22（北京时间）  
范围：只读审查 C11322；新模块、TB 与复制的控制器源码均位于本目录。没有改 C22/C19～C22 生产源或位流，没有运行 TD、没有操作硬件。

## 实板证据及定位

父任务从新 C11322 录像读到视频故障状态 `24400010`：`video_mode=1`、`fs_error=1`、`fs_ready=0`、两个播放器 state=0、`fs_error_code=01 (E_SECTOR)`；播放器/mapper/解码错误全0。CRC页为 `checked=1,bad=1`，其他音频和文件头页为0。首个可见故障位于重新挂载早期 sector，消费者还未运行。该信息来自父任务对用户录像的读取，不是本代理实测。

确认的控制路径：`top_tf_hdmi_audio.v` 中 `video_mode_press` 直接触发 `media_reset_active`；组合 `rst_all` 同时复位 `sd_card_top`、`fat32_catalog`、文件播放器及共享帧缓存。`sd_card_top` 子模块在异步复位时抬高 CS、清 SPI 状态、清 `sd_init_done`，之后重新初始化并由 catalog 重扫 LBA0。于是模式键可能在 CMD17 命令、token 等待或 sector payload 中途截断物理读。CRC bad 与 E_SECTOR 的现场组合证明切换后的首批 SD 数据确有异常；具体是卡侧 CMD0/模式恢复、SPI边沿，还是板级时序因素，现有静态证据无法区分。

既有 `video22_work/mode_review/tb_mode_remount.v` 是六相位负控：它在这些阶段复位卡控制器/catalog，外卡模型随 CS 上升立即清除事务，并接受后续 CMD0/重挂载；六轮都重挂载成功、CRC bad=0。模型端口没有 FPGA reset，且没有可配置的卡恢复延迟/异常行为。它证明 RTL 会中断交易且该模型可恢复，不能覆盖用户实卡返回的 CRC bad。

## 排空模块接口

`player_mode_quiesce.v` 运行在 `sd_card_clk` 域；两级 request/ack 同步器带 `ASYNC_REG` 属性：

- `request_toggle_async`：媒体时钟域的模式切换请求 toggle，最多允许一个未完成请求。
- `mount_ready`：持久 catalog 已挂载。未 ready 时模块保留请求，但 `gate_new_sector=0`，避免阻断挂载。
- `physical_idle`：由 SD 控制器显式提供；测试副本的 `sd_card_sec_read_write.sd_idle` 为 `state==S_WAIT_READ_WRITE`，再与 `sd_init_done && !sd_sec_read` 合并。生产状态顺序保证此前 CMD16/S_READ ACK 已回到 CMD/SPI wait。`sd_card_top` 将该标志作为输出转出，避免集成层级探测内部状态。
- `gate_new_sector`：挂起切换后阻止新的 runtime sector 请求；保持到对端确认。
- `commit_toggle`：仅在 `mount_ready && physical_idle` 时翻转，跨回媒体时钟域后才提交 `video_mode` 并重置媒体客户端。
- `ack_toggle_async`：媒体域完成模式翻转和本地媒体复位后回送同值；收到确认后模块释放 gate。

接入 C23 时，应把 gate 放在 runtime client 到物理 `sd_sec_read` 的边界，并给 catalog 启动读取保留通路；冷启动 reset 单独供卡控制器和 catalog 使用。媒体播放器、mapper、解码器及帧读写流水在各自时钟域完成 reset/同步释放。推荐从 `sd_card_top` 增加显式 `physical_idle` 输出，内部条件为 `sd_init_done && sec_state==S_WAIT_READ_WRITE && cmd_state==S_WAIT && spi_state==IDLE && !sd_sec_read`；不要在集成逻辑中依赖层级引用。

## 仿真证据

- `quiesce_unit.log`：请求跨域同步、mount 未 ready 时请求暂存、physical_idle 前不 commit、commit 后等待对端 ack、ack 前保持 gate，均通过。
- `sd_quiesce_integration.log`：使用本目录复制的生产 `sd_card_top`/catalog/SD模块和现有 `sd_spi_card_model`、64 MiB稀疏FAT32镜像。六个实际 controller phase（CMD参数、token wait、payload 8/37/255/510）发切换请求后，各次原 sector 完整结束；每次 CRC checked 加一、bad=0，catalog ready 保持。卡模型独立计数确认 cold mount 的 CMD0=1，六轮 runtime 切换后仍=1，命令计数仅逐次增加一个 CMD17。
- 同一TB最后设置一次单bit payload注入，CRC监视器使 `crc_bad` 从0变1；该负控证明CRC检查链路能检出单bit错误。它不模拟或解释现场实卡为何在模式复位后返回坏CRC。
- 对照旧实现见 `development/video22_work/mode_review/mode_remount_run.log`：原 six-phase 中止模型以 `command_count=61` 完成六次重新初始化；新测试 cold mount 后 command count 从8增到14，新增六条均为 runtime CMD17，没有重初始化命令序列。
- `tb_player_mode_quiesce.v` 是协议行为单元测试；它没有模拟实际 SPI 器件。集成仿真仍使用现有外卡模型，不能作为实卡响应行为证明。

运行：在项目 PowerShell 下运行 `run_quiesce_unit.ps1`、`run_sd_quiesce_integration.ps1`。两脚本调用工程内 Icarus；当前 Windows 沙箱下需要系统临时目录可写时执行。

## 未验证与下一步

原型尚未接入 top，也未综合、布局布线或上板；跨时钟 reset 的实现和整机模式提交仍由 C23 集成验证。实卡 CRC 异常的精确卡侧机制仍未定案。下一步由 C23 将此握手接入真实 runtime SD 请求边界，检查 runtime 与 catalog 读请求仲裁，并在卡事务各相位进行完整工程仿真；板上重点确认切换期间 CRC bad 不增加、fs_ready持续为1且 BMP/video 均可恢复。
