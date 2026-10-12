# C11205 集成审查

审查时点：2026-10-12 12:30:19 +08:00。范围为只读静态审查；未构建、未运行仿真、未操作硬件。结论绑定下列源码 SHA-256，后续 `player_osd_state.v` / `tf_bmp_file_player.v` 变更后需重审相关状态路径。

## 结论

在该快照中，未发现地址路由、实例接线或 loader/OSD 所有权路径的集成级阻断问题。实现采用连续整帧地址重映射：每次 wipe 只改变 `App_rd_addr`，不增加请求、不清读 FIFO、不增加 pixel/data pipeline。该结论是源码静态结论，不代表行为模型、综合时序或实板随机访问已经验证。

## 核查依据

- `top_tf_hdmi_audio.v:210-224,287-297,321-343`：BMP loader、OSD ownership、frame buffer 实例的 wipe/finish/ACK 接口已完整连接；`read_req_ack` 同时送 OSD 与 timing/request 路径，`display_finish_toggle` 回到 loader。首图由 `player_osd_state.v:95-103` 直接设为显示帧且关闭 wipe。
- `frame_buffer_rgb888.v:73-120`：原 `frame_read_write` 的请求、数据、捕获延迟参数及 read FIFO 接口仍原样连接；`u_wipe_address` 位于 backend 地址输出与 SDRAM 之间。`App_rd_en` 仍直连原 `app_read_en`，只有 `App_rd_addr` 使用 `wipe_read_addr`，read data/valid/capture 路径没有经过新逻辑。
- `player_wipe_address.v:16-46`：默认 640x480 compact RGB888 每行 `(640/4)*3 = 480` 个 32-bit word；整帧 230,400 word，即 900 个 256-word burst。8 行 cut 为 3,840 word，正好 15 个 burst；每帧推进 8 行，480/8 = 60 个显示帧完成 wipe。地址区间 `[old_base, old_base+cut_words)` 映射到新帧同 offset，其余读地址仍来自旧帧。切换仅作用于地址，理论请求量仍是每帧 900 burst。
- metadata 的 active/rows/old/new 各有两级 mem-clock 同步（`player_wipe_address.v:21-35`），并在 `frame_ack` 上升沿锁存（`36-42`）。像素域只在 frame edge 改这些字段，下一次 frame request/ACK 期间字段保持到下个显示帧；按当前帧时序，字段有远多于两级同步器的稳定时间。这里是静态 CDC 结构审查，未做器件级 CDC/MTBF 或约束审查。
- `SD/frame_fifo_read.v:233-262`：读控制器在 `S_READ_BURST` 完成当前 burst 后才进入 burst-end 状态；下一次请求才会回到 `S_ACK`。地址映射状态因此不会在一个已发出的旧 burst 中途切换。ACK 在 `S_ACK` 拉高；backend 同时锁存基址并清读 FIFO（`134-144,184-215`），地址路由在 ACK 的上升沿采样 metadata。这里的 `read_req_ack` 是请求受理/基址锁存 ACK，不是整帧 230,400 word 读取完成 ACK。
- final wipe frame edge 将 OSD 当前 buffer/image 与显示目标一起切换（`player_osd_state.v:104-115`）；该次请求 ACK 时 router inactive，backend 已按新 buffer 选基址，之后整帧读新 buffer。`release_pending` 等待同步后的 read-request ACK 才 toggle（`87-93`），loader 经过自身同步器后才从 `WAIT_DISPLAY` 回到 `IDLE`（`tf_bmp_file_player.v:35,72-73,167-171`）。虽然该 ACK 不代表整帧读取完成，但 final frame 的所有后续读取已指向新 buffer，旧 buffer 不再被显示读取；loader 之后还需选图、读 header 并握手才会开始复用旧 buffer。按此源码路径，释放旧 buffer 的时点是安全的。
- `tf_bmp_file_player.v:138-169`：写请求握手后才进入 payload；文件结束只有在 sector 长度正确且 `pixel_seen==PIXEL_BYTES` 时才进 COMMIT；COMMIT 等 `write_done` 或同步完成脉冲后才发布 buffer/index/valid，并进入 `WAIT_DISPLAY`。顶层 mem 域将一周期 `frame_write_finish` 转成 toggle（`top_tf_hdmi_audio.v:191-197`），loader 用三段同步链检测 toggle（`tf_bmp_file_player.v:35,39-40,72-73,81`）；写完成提前到达时 `write_done` 保持到 COMMIT。HALT 路径清 `card_read/write_req/write_en`（`172-178`）。静态看未见正常时序下的完成事件丢失；异常 EOF/文件错误同时撞上 COMMIT 的边缘竞争未由本审查动态覆盖。
- 与 `pcm_bram_20261012_verified` checkpoint 对比，目标工程共同存在的 `tf_wav_file_player.v`、`wav_pcm_bridge.v`、`hdmi_audio_tone_pcm_scale.v`、`hdmi_phy_warpper.v`、`sd_sector_arbiter.v` 均逐字节同 SHA；顶层因 wipe 集成有变更，静态核对音频/SD 仲裁/HDMI 数据通路的既有连线仍在。此为文件对比和连线审查，不是运行验证。
- `SD/sdram.v:32-38,56-74` 将公开的每 word `App_rd_addr` 端口送入 `sdr_as_ram`；该实现是加密源码（`include/sdr_as_ram.enc.v`），无法在本审查中核实物理控制器是否完整支持该接口地址映射及任意逐 word 地址读取。行为模型与实板随机访问行为必须分开判定。

## 尚未验证 / 下一步

- 主代理在审查后反馈：full-address 地址模型检查 922,360 项通过；RGB888 模型 4 个整帧、合计 1,228,800 像素通过。该结果由主代理提供，本审查未独立运行模型。
- 加密 `sdr_as_ram` 内部地址解释和真实 SDRAM 读写行为未验证；需要在模型证据通过后由工具/实板验证。
- 本报告对应下列源码时点；ownership 代理若更新控制器文件，应以新哈希复核 metadata 发布、final release 和 COMMIT/ACK 相邻边界。

## 源码指纹

| 文件 | SHA-256 |
|---|---|
| `player_wipe_address.v` | `8712E3490C0EC01FDF1A719BB74EEE2BC2D7269AE51119E338F0EB0FBD143F4F` |
| `frame_buffer_rgb888.v` | `953C6C0E89A427B53D7B4620362E047968D8690CD5D5CAF76802AEDC90D94632` |
| `top_tf_hdmi_audio.v` | `CE1235E8B8CDF1268AE20621D5CDAF55A9D77C2FE16C1F53D762DCCABDD9E7E7` |
| `player_osd_state.v` | `E9476042E52B27881A0268E9E684A50A60B2EB87A9F5BAA4E8E445B75BBE8307` |
| `tf_bmp_file_player.v` | `7394339639ED5E391F88CBA921DFD44C50521A48E37C871EDE6DE3851181E15D` |

