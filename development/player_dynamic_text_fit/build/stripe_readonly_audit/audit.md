# 动态字幕底图竖线只读审计

日期：2026-10-09（北京时间）
范围：只读比对 `player_dynamic_text_fit` 与成功实板基线 `player_osd_phy_fix`，未修改 HDL、约束、bit/checkpoint 或资料文档，未运行板卡。

## 身份与输入

- 候选 `build/manual/AC201_player_dynamic_text_fit.bit`：629624 bytes，SHA256 `028D9D9A742A2CD980ECBEA48FFBE824D89DA34CF6B2B3E66EA0AA42B6D6456D`。
- 成功基线 `build/manual/AC201_player_osd_phy_fix.bit`：SHA256 `9E893B0B6C86BF6FBEE19E74B5FB58933C1BEA6AA07F203786CCE96F3B60AE6F`。
- 候选构建记录 `../manual/AC201_player_dynamic_text_fit.info.json` 说明相对首版 dynamic_text 只收窄 `fat32_file_sector.v` 内 Brent 计数器；该候选与成功基线按 HDL 文件哈希的差异为：`fat32_file_sector.v`、新增 `player_dynamic_text.v`、顶层 `top_tf_hdmi_audio.v`。

## 已证实

1. BMP/帧缓存数据通路没有候选源差异。以下成功与候选文件 SHA256 完全相同：
   - `tf_bmp_file_player.v`：`67BCB723E75BA508C632709BA2416E25BBA449F45F86592527277CCBC30F1B89`
   - `frame_buffer_rgb888.v`：`5F6531512BAC6EF1C65EBC35DFF90C3EC8A2DB3C59DCF4F16FFFEB3DA82455CC`
   - `rgb888_word_codec.v`：`1EBE462B52A0F4A08E22BFF98E8B8C10C67FBA7857006CF2E5A2CB5004DE9C93`
   - `SD/frame_read_write.v`：`036D2C3DBD06438BD5D3DC87EA13A1DD3EC92E42FD57B91ABB5F5C6810F47C6F`
   - `SD/frame_fifo_read.v`：`5952075B213EC638F5C9BB238D4D4162685F9E9B5E752674F0E68A92DBEC83AC`
   - `SD/bmp_read.v`：`CA3F998FC71B06C9409D2F21F47136BB2DCFE9BF56DCB033DA63B431FCBE68F1`
   - `video_rgb_to_axis_640x480.v`：`1C8FC26C789F87227036BEA034F1AB6FC5633F2AB2684BE422C54687A290FB96`

2. 顶层候选只在成功基线 OSD 后串接一个 RGB 组合覆盖器：候选 `top_tf_hdmi_audio.v:341-350`。帧缓存、SDRAM 控制器、帧 FIFO、RGB888 pack/unpack 及 converter 接线未改（候选 top `:289-310`, `:392-402`）。`player_osd.v` 和 `player_dynamic_text.v` 对覆盖区外像素保持输入 RGB；动态覆盖器输出在 `player_dynamic_text.v:314` 附近以 `de` 决定是否替换 RGB。因此静态 RTL 未显示它会在非字幕区域周期性插入竖线。

3. RGB888 读侧采用 32-bit 字 FIFO + 64-bit reservoir，按 24-bit 连续抽取像素。普通同步 FIFO 的读响应延后一拍，由 `pop_pending` 接入；相关逻辑在 `rgb888_word_codec.v:81-123`。候选与基线此实现相同。现有 mapper 缩位宽模型已跑到 6,381,198 cycles / 12,295 sectors，覆盖最大4096簇与边界/回退/缓存续读，没有报告接口周期差异；该模型支持“窄化映射器未表现出可复现截断”的结论，但不是完整 TF→SDRAM→HDMI 仿真。

4. 公共 converter 的 TLAST off-by-one 已在 `../axis_readonly_audit/source_audit.md` 与行为模型确认（640-DE 下无 TLAST），但该文件哈希与成功基线相同；不是这次候选差分根因。

5. 候选 SDC `src/user_source/constraints_source/timing.sdc:1-11` 定义了时钟/派生时钟及 FIFO Gray 同步 max-delay 约束，但未设置板级 SPI I/O 延迟。候选 `AC201_tf_hdmi_chk.timing:683-709` 明确列出 4 个无 input delay（包括 `sd_miso`）及 14 个无 output delay（包括 HDMI_CLK/D0/D1/D2）。因此片内 STA 不能证明 HDMI 外部输出裕量或 SPI MISO 采样裕量。此报告不据此声称 SDRAM DQ 缺少约束或存在问题：SDRAM 由 EG_PHY hard-IP 封装，当前缺延迟条目只列出 `sd_miso` 与 HDMI 等端口；其采样相位应依据 hard-IP 配置与板级时序单独核实。上述 I/O 报告差异同样存在于成功基线，不能单独证明回归根因。

## 未证实 / 假设

- 当前未找到可在 RTL 模型复现的候选数据位错误、周期性像素列计数错误或新增读拍/CDC 缺陷。
- 候选不同逻辑会改变布局布线；窄化 FAT mapper 也可能移动共享资源。若实际竖线只出现在未被 OSD/字幕遮盖的底图区域，推测优先级是：候选布局影响底图读流或 RGB/HDMI 输出路径，其次再看 BMP 文件字节解码。这个推测不能由当前截图/源码确定，也不特指 SDRAM 板级时序约束。
- SDRAM 加密 PHY 内部 DQ 捕获相位、HDMI加密核内部 AXIS ready/TLAST 消费、连接器/线材/显示器对 TMDS 裕量的影响均不能从可读 RTL 完整确认。

## 最小验证建议

1. 同卡同线各下载成功基线与候选，锁定同一张静态 BMP、字幕位置固定；保存同一显示器照片/短视频。不要据此立即改源码。
2. 若可另起诊断构建：保持候选 HDMI PLL、PHY、SDRAM 和时钟不动，只在 overlay 前把帧缓存 RGB 替换为内部常量色/小格子图案。常量图案仍出竖线，问题在 framebuffer 之后的 HDMI/PHY/板级链；常量图案干净而原底图有线，回到 SDRAM/FIFO/BMP 读流侧。
3. 再做观测点：计数 `rgb888_unpack32.underflow`，对固定窗口内 `video_read_data` 与写入参考帧做逐像素 CRC，并把 CRC/underflow 锁存显示。只看整帧底图 checksum 不足以排除按列重复/丢拍。
4. 物理验证应补查 HDMI 输出 delay/IO sampling；SDRAM 的读拍另依据 EG_PHY 配置及板级资料核对，不由当前 MISO/HDMI 缺失延迟条目推导。先取得波形/CRC证据，再决定是否修改约束或架构。

以上是静态审查。未编译、未执行新增模型或硬件测试；没有给出已确认根因。


