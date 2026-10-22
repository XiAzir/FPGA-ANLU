# C11321 模式切换复位与 FAT32 catalog 静态审查

日期：2026-10-22（北京时间）  
对象：`development/player_video21_diag`；只读检查 RTL。没有运行 TD、没有改 `src/scripts`、没有操作硬件。

## 结论

确定的结构问题是“媒体模式复位”同时复位 SD 卡物理控制器和 FAT32 catalog。`video_mode_press` 在 `video_clk` 域翻转 `video_mode` 的同一拍启动 `media_reset_active`，`rst_all = rst_all_reg | media_reset_active` 随之异步送到 SD 子系统。复位会在任意 SPI 命令/数据字节处中止控制器交易、拉高片选、清 `sd_init_done`，随后重跑卡初始化；catalog 和所有媒体客户端也同时清状态并等待重新挂载。

这是可以从静态连线确认的生命周期耦合与异步复位释放风险。它能解释切模式时 SD 交易为何被截断，也会扩大故障面；现有证据还不足以证明它单独造成实板“返回图片仅 UI、IMG0/0”。C11321 与 C11320 的功能控制及复位 RTL 完全相同，C11321 增加的观测 tap 只进入状态显示。C19/C20 的黑屏与 C21 可播放的变化须保留为证据，布局/时序/观测差异仍可能影响实板结果。

## 信号链证据

- `top_tf_hdmi_audio.v:192-198`：`video_mode_press` 使模式翻转并将媒体复位计数装载为 31；计数器位于 25 MHz `video_clk` 域，复位大约持续 32 个 video 时钟，即约 1.28 µs。
- `top_tf_hdmi_audio.v:202-209`：SD 域仅同步模式和视频重启 toggle；`rst_all` 直接组合媒体复位。`rst_all` 的释放仍发生在 video 域边沿，未针对 SD、存储器和视频域分别同步。
- `top_tf_hdmi_audio.v:245-246`：`fat32_catalog.rst` 接 `rst_all`。reset 分支清空挂载参数、BMP/WAV/video 目录结果、`byte_index`、目录匹配字段、`root_end_marker` 和状态机；之后从 `S_WAIT_INIT` 等待 `card_init_done`，从 LBA0 开始重新扫描。
- `top_tf_hdmi_audio.v:539-541` 与 `SD/sd_card_top.v`：同一 `rst_all` 接完整 `sd_card_top.rst`，覆盖扇区控制器、SPI 命令控制器及 SPI master。`sd_card_sec_read_write` reset 清 `sd_init_done` 并返回 `S_IDLE`；`sd_card_cmd` reset 设 `CS_reg=1`、返回 `S_IDLE`；SPI master reset到 IDLE 并将输出时钟恢复为 CPOL。
- `SD/sd_card_cmd.v` 的 `S_INIT` 后续会发送 11 个 `FF` 字节并重新开始 SD 初始化命令序列。因此每次模式切换都同时重启卡接口与图片/视频播放器。

## FAT32 byte/目录项审查

- 每次 `issue_sector` 都将 `byte_index` 清零；每个 `sd_valid` 消费一个字节并递增；`sd_end` 要求无同拍 `sd_valid` 且字节数恰为 512。异常长度进入 `E_SECTOR`。
- 根目录每项 32 字节：byte 0 重建空项/删除项状态，byte 8..10 逐字节匹配扩展名，byte 11 捕获属性跳过位，byte 20/21 与 26/27 捕获高低 cluster，byte 28..31 捕获长度。末字节处理与这些提前捕获字段错开一个时钟，非阻塞赋值读取的是已捕获字段，长度最高字节直接用当前 `sd_data`。
- `root_end_marker` 在挂载根簇开始和链式进入新簇时清零；读到首个空目录项后，在本扇区结束时进入 DONE。未见跨 sector 的 `byte_index` 漏清或目录项字段仅在冷复位初始化的问题。
- 因此当前静态证据优先指向复位/卡接口事务生命周期；没有足够依据将根目录解析器标成已确认缺陷。

## 有界复现输入与观测

在 25 MHz `video_clk`、约 50 MHz `sd_card_clk` 下，等待 catalog/卡初始化完成并让 SD 控制器进入任一 CMD 或 READ 中间拍（例如 `sd_card_cmd.state==S_READ && byte_cnt==8'd37`），触发一次真实双键 `video_mode_press`。原设计立即拉高 `rst_all` 约 1.28 µs；同一复位使 `sd_card_cmd.state` 回 IDLE、`CS_reg` 拉高、SPI 状态清零、`card_init_done` 归零、catalog 回 `S_WAIT_INIT`。松开后观察 `sd_init_done` 初始化时长、`fs_read/fs_addr`、`shared_card_valid/end`、`fs_ready/error/error_code`、`fs_bmp_count`。分别在图→视频和视频→图路径触发，保留每次触发的卡事务相位。

此输入在 RTL 仿真中确认模式复位会打断并重启物理卡接口。下方六个截断点测试显示，该中止和重初始化没有破坏当前卡模型中的文件系统重挂载结果；实板 IMG0/0 仍需依据 fs_ready、fs_error、bmp_count 与 display_valid 分层定位。


## 真实控制器/外卡模型中断复现

新增 `tb_mode_remount.v` 与 `run_mode_remount.ps1`，直接实例化 C21 的 `sd_card_top`、`fat32_catalog`，并复用 `system_verification_20261016/card` 的外卡模型、packed 64 MiB FAT32 镜像与 LBA map。外卡模型接口只有 CS/SCK/MOSI/MISO 和计数输出，没有 FPGA reset 输入；`media_reset` 仅连 controller/catalog，卡模型状态继续运行。测试在挂载 ready 后对已有 LBA 4130 发运行时读，按 controller 内部状态在 6 个截断相位拉起 32 个 25 MHz video 周期（1.28 µs）reset：CMD17 序列 state4/byte2、token wait state6、READ state7 的 byte 8/37/255/510。

`run_mode_remount.ps1` 在既有 Icarus 工具目录下编译和运行，成功退出。`mode_remount_run.log` 六次均报告 PASS remount，最终 PASS 六个运行时复位相位保留完整 catalog metadata；模型 `protocol_error=0`、CRC `bad=0`。`sd_init_done` 在每次媒体复位后归零并重新初始化；catalog 从头扫描后每次恢复 `fs_ready`。`command_count=61/read_count=26`。`crc_checked` 因 FPGA 侧 CRC 监视器随媒体复位清零，不跨 reset 累计，最终 checked=3/bad=0；`card_model.read_count` 跨 reset 保留。

冷启夹具目录基线为 BMP count=1/cluster21/size822，WAV found=1/cluster4/size8236，video found=0，FAT/data LBA 2080/4128，cluster_count126944。六轮重挂载后这些字段逐项匹配。夹具不含 `VIDEO.MJP`，因此 video 预期为 found=0。测试文件 SHA256：TB `5a27061894a34532bc5ad27f17420bca39531a819de55ffa96199c2d18aa356e`，runner `9d3e979a40bcde9432ad46c71adc7518340aec8a3b4ac185d71ae0371cd8c01d`，run log `bbe9d1cd6367a6954d2d466ce9ff78d2a3042791684916a07e7604c5c6e7f147`。复用模型、镜像和 LBA map SHA256 分别为 `c7a758a7fba278eb8e1be5803bb0a1819a877b3436981f17cba4deb965cbe342`、`425e4ab907fc88dff0fb499d6c19b60d8872e3a32ce8ccc9fac345ea80f2ae5d`、`42a172e8474adf869f6d1cd04eacf2fbb1dc049730abe8bca55afaba9c18c11a`。

仿真表明该受限模型场景没有复现目录信息丢失，因此复位耦合目前属于已确认的结构风险，尚无 IMG0/0 根因证据。测试不覆盖实卡对重初始化的兼容差异、供电/时钟模拟问题、完整 top 与 SDRAM/loader/HDMI、用户原始媒体或所有卡型号。未运行 TD、未改生产源、未操作硬件；当前源版和模型组合未复现目标故障，没有进行应用层候选消融。后续若板端读回 `fs_ready=1, bmp_count>0`，优先查 loader/显示提交；若 `fs_error` 或 `bmp_count=0`，再对照卡初始化和 root 目录流。

## 最小结构修复方向

若后续证据确认模式复位引起实卡重挂载异常，最小结构方向是将实体 SD 控制器复位与媒体复位分开：控制器仅受冷启动 reset 控制，catalog/client 按媒体 reset 清理。再增加停发新请求与当前扇区完成边界，确保媒体状态清理和运行事务对齐；若保留已挂载 catalog，则切换时可仅复位播放器状态。该方向尚未实施或通过消融验证。

