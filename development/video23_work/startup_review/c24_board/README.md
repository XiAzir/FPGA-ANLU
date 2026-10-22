# C24 实板录像诊断核对

日期：2026-10-22。来源为父任务提供的完整循环录像；本记录中的读取值均经离线提帧后人工核对，不代表代理实板操作。

## 原始证据与采样

- 原视频：`E:/QQ CACHE/LiaoTianJiLu/Tencent Files/1791081637/nt_qq/nt_data/Video/2026-10/Ori/cf2687dc4bddbafd7c0c518b5be73be2.mp4`
- SHA256：`4B7BA7BEAD3D3B970EC4C41B23218DF1A5475021560DB9C5D7739125C1424B13`
- ffprobe：H.264，720×1280，30000/1001 fps，530帧，17.668378秒。
- 提帧方式：ffmpeg `fps=1:start_time=0.5`，共18张全板取样帧，保存为 `sec_01.jpg` 至 `sec_18.jpg`；`sec_01` 对应录像约0.5秒，此后每秒一帧。状态页轮转略慢于每秒一次，因此页6有重复样帧，后段覆盖完整16页循环。
- [状态页接触表](status_pages_contact.png)；页0图：[sec_12_display.png](sec_12_display.png)，页1：[sec_13_display.png](sec_13_display.png)，页2：[sec_14_display.png](sec_14_display.png)，页4：[sec_16_display.png](sec_16_display.png)，页5：[sec_17_display.png](sec_17_display.png)。原始视频只读，采样帧和裁剪图保存在本目录。

## 完整状态页读数

页码按 `player_compact_status_pages.v` 的 `page_index` 对应，以下为视频中人工读取的32位值。页0、页1、页2、页4、页5及文件头页采用单帧复核，其余按循环接触表读取。

| 页 | 读数 | 定义/核对 |
| --- | --- | --- |
| 0 | `00C11324` | C24 版本标识。 |
| 1 | `2B08000F` | `fs_ready=1`、`fs_error=0`、WAV与视频文件均找到；照片状态 `8=HALT`、视频状态 `0`、目录错误码 `00`；末 nibble `F` 表示 BMP/photo、WAV、BMP mapper、WAV mapper 错误标志全置位。 |
| 2 | `000A0000` | SD CRC 计数：已检查10块，错误0块。 |
| 3 | `00000000` | 音频/频谱快照为0，符合未出声状态。 |
| 4 | `40A0AC29` | `bmp_map_error_code=0A`、`wav_map_error_code=0A`，均为 `E_TIMEOUT`；WAV 状态 `C=ST_HALTED`、扫描阶段 `2=P_CHUNK_ID`；目录 BMP 数量4，JPEG core idle=1。 |
| 5 | `50400054` | `photo_failure_detail=0x040005`：原因 `04` 表示 mapper `file_error`，photo loader 在 state `5=PAYLOAD` 收到错误；低四位 `4` 解为 video reader error=0、wav_error=1、display_valid=0、video_mode=0。 |
| 6 | `68022000` | 板载内存诊断原值。 |
| 7 | `700A0000` | PCM 首 CRC 诊断原值。 |
| 8 | `80000000` | PCM CRC 快照原值。 |
| 9 | `90000000` | PCM block 快照原值。 |
| 10 | `A0000000` | underflow 计数快照为0。 |
| 11 | `B0CE6950` | WAV 首次等待时间最大值原值。 |
| 12 | `C8001390` | WAV FIFO low-water/当前水位原值。 |
| 13 | `D0000000` | PCM 样本数快照为0。 |
| 14 | `52494646` | WAV 逻辑文件首四字节 ASCII `RIFF`。见 [sec_10_display.png](sec_10_display.png)。 |
| 15 | `424D3684` | BMP 逻辑文件首四字节 `BM 36 84`；第二字节按视频帧人工读作 `4D`。见 [sec_11_display.png](sec_11_display.png)。 |

录像关键采样：页2取自 `sec_14.jpg`（约13.5秒），页4取自 `sec_16.jpg`（约15.5秒），页5取自 `sec_17.jpg`（约16.5秒）。SHA256：

| 采样 | SHA256 |
| --- | --- |
| `sec_14.jpg` | `5A11F116B4F192B5AF04B439B30A0D3C1C5EFCAB167CB89BFA687F7E7F9BAEB8` |
| `sec_16.jpg` | `408A2C6BDFFC8AA7AF39E6426316D428A2730B8698015730D2C294D820E13897` |
| `sec_17.jpg` | `EF57F813A02D33122A0C9AC6F18D4ED1115FBED79E74091D1C61FC0E3DF6A43F` |
| `status_pages_contact.png` | `7994FEA86CFA3FE5FAC787338B2D59E4FDF4496934519E09F42D3F49BEB52EE1` |

## 停点解释

页1和页2支持目录挂载已经成功，且至少10个读块完成 CRC 检查、0块 CRC 错误；`fs_error=0`。页14与页15进一步证明，WAV 和 BMP 的首个逻辑文件扇区数据都到达了各自消费者。页4给出的两路 mapper 错误码均为 `E_TIMEOUT`；页5给出的照片故障位置在 `PAYLOAD`，因此当前读数指向挂载之后的运行期后续文件扇区请求/响应路径。

这组签名没有触发 mapper 的起始簇 `E_CLUSTER=03`、地址算术溢出 `E_ADDR=04` 或 sector 越界 `E_RANGE=01` 检查，初始启动簇校验/地址溢出与停点不吻合。文件头已经读到，也说明请求已越过首扇区。`E_TIMEOUT` watchdog 同时覆盖 `C_SETUP`、`C_DISPATCH`、`C_FAT_WAIT` 与 `C_DATA_WAIT`；页4没有暴露 mapper core_state，因此尚不能从显示读数定位具体停态。有效范围内的错误后续 LBA仍可能引起物理读等待，地址问题不能由本页完全排除。

## C22 / C23 / C24 连接差异

| 项目 | C22 | C23 | C24 |
| --- | --- | --- | --- |
| mapper 源 | SHA256 `084B7DC884B1B33E3EBC2804283BC820B0E5A38EB248E7DC14A6303D70F67BFB` | 同左 | 同左 |
| catalog 源 | SHA256 `CEBA12AAB36AD403D789FDFE8CF6692B841F83888A6622752657F47066CF7AA5` | 同左 | 同左 |
| card SPI 高速分频 | `SPI_HIGH_SPEED_DIV=0` | `0` | `2` |
| catalog/card reset | `.rst(rst_all)` | `.rst(rst_all_reg)` | `.rst(rst_all_reg)` |
| mapper / runtime consumers reset | `.rst(rst_all)` | `.rst(rst_all)` | `.rst(rst_all)` |
| runtime card read | `fs_ready ? arb_card_read : fs_read` | ready后额外 `&& !mode_gate_new_sector` | 与 C23 相同 |
| physical idle / quiesce gate | 无 `sd_idle` 接口和 mode quiesce gate | 新增 | 保留 |

`rst_all = rst_all_reg | media_reset_active`。因此 C22 的媒体重启会同时复位 card、catalog、mapper 与读者；C23/C24 在媒体重启期间复位 mapper/读者并保留已初始化的 card 与已挂载的 catalog。C23/C24 的 gate 在 `fs_ready=1` 时阻断新物理扇区请求，mapper 接口和 watchdog仍活动。视频当前显示 `video_mode=0`，但该状态本身不记录 gate 是否曾经拉高或 media reset 是否发生。

`player_mode_quiesce` 在请求到达后置 `gate_new_sector`，等待 `mount_ready && physical_idle`，发 commit 后保持 gate，直到同步到 media restart 的 ack。`player_media_restart` 在 commit 后令 `media_reset` 持续32个 video clock，再翻转 ack。若 gate 被维持接近 mapper 的 `WAIT_LIMIT=50,000,000` 个 SD 时钟，处于 C_SETUP/C_DISPATCH/C_FAT_WAIT/C_DATA_WAIT 的等待会报告 `E_TIMEOUT`。本录像没有 mode_gate、busy、physical_idle 或 media_reset 波形，无法确认曾发生这种长等待；普通短握手时长也不足以单独解释超时。

相关源位置：C22 `top_tf_hdmi_audio.v` 的 catalog/card 实例；C23/C24 对应实例；[C24 mapper](../../player_video24_spi6p25_diag/src/user_source/hdl_source/fat32_dual_file_sector.v)、[quiesce](../../player_video24_spi6p25_diag/src/user_source/hdl_source/player_mode_quiesce.v)、[restart](../../player_video24_spi6p25_diag/src/user_source/hdl_source/player_media_restart.v)、[compact status pages](../../player_video24_spi6p25_diag/src/user_source/hdl_source/player_compact_status_pages.v)。

## 后续离线消融建议（未执行）

基于隔离仿真副本运行，固定同一已挂载目录、BMP/WAV 文件参数、SD 数据模型和请求序列，每次只改变一个控制条件：

1. **基线**：C24 mapper、quiesce gate 和正常 card 响应，启动后跑到两路完成若干扇区；记录首个请求与完成计数。
2. **gate 单因子**：只强制 `mode_gate_new_sector=0`，其余复位和 SD 模型保持基线。若无 `E_TIMEOUT`，可将 gate 路径列为候选因子。
3. **media-reset 单因子**：gate 保持低，只在 catalog/card 已挂载后脉冲 `media_reset_active`，检查 mapper 与两个请求源的 `read` 是否有低电平重新 arm、之后是否再次完成扇区。
4. **握手时序**：保持实际 quiesce/restart 连接，分别正常 ack 和延迟/丢弃 ack；记录 gate 高电平周期数以及 `E_TIMEOUT` 是否只在长 gate 条件出现。

第一轮波形最少记录 `core_state`、`active_client`、`queued/busy/armed/walk_initialized`、两个 file_read 与 logical sector、`sd_addr/sd_read`、`mode_gate_new_sector/mode_switch_busy/card_idle/media_reset_active`、`shared_card_read/shared_card_valid/shared_card_end`、card command状态、mapper错误码和 watchdog。该波形可区分请求未被触发或复位后未重新 arm、gate 阻断、FAT/data阶段无物理响应，以及有效请求地址访问不返回。当前仅是实验建议，尚未修改 RTL 或运行消融。

## 当前结论与限制

- 已确认：C24 的目录层启动成功；两路 mapper 最终各报 `E_TIMEOUT`；BMP 在 `PAYLOAD` 阶段遇到 mapper 错误；WAV 扫描在 `CHUNK_ID` 阶段被 mapper 错误中止；两种文件的首扇区头部数据都已到达消费者。
- 起始簇拒绝和 mapper 地址溢出路径不符合错误码；后续有效地址选择、SD 请求/响应、quiesce gate及复位后的重新 arm 仍需用波形区分。
- 没有直接证据表明 `mode_gate_new_sector` 曾长时间拉高，也没有足够信息把故障归因于 SPI 采样、CMD16、媒体复位或 gate 中任何单一因素。
- C25 的 CMD16 单变量启动对照仍可回答初始化边界；这组 C24 runtime 读数显示其失败发生在目录挂载和文件首扇区读取之后，应另行观察后续运行期读请求。


