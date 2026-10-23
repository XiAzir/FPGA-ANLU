# C27 图片 PAYLOAD 停点只读审查

日期：2026-10-23。对象：`development/player_video27_command_boundary` 当前冻结源。未改生产源、bit、脚本；仅在 `development/video27_work/photo_stall_review` 放置单元 testbench 与结果。

## 结论

静态审查未发现 BMP loader → scaler → writer 请求/ready/FIFO 路径中可确认会使 PAYLOAD 必停的确定性错误。当前现场状态 `photo_state=PAYLOAD(5), display_valid=0, write_ready=1, writer=CHECK_FIFO` 表示图像尚未提交，writer 可用；`CHECK_FIFO` 在剩余帧未完成且 FIFO 可读水位 `rdusedw<=BURST_SIZE(256)` 时等待属于设计条件。最需排除的停点仍是 scaler 扇区读等待与 `scale_pixel_valid && write_ready` 接收计数不再增加，现有外部状态页没有 scaler 子状态或进度计数。

## 代码链

- `tf_bmp_file_player.v:98,109,227,229-238`：PAYLOAD 下将 scaler 请求/地址接入卡映射；GAP 后启动 scaler；仅在 `scale_pixel_valid && write_ready` 时让 loader 发一个 `write_en`。
- `bmp_scale_engine.v:278-284`：pixel_valid 保持到 ready 同拍接受才前进坐标，握手语义一致。
- `frame_buffer_rgb888.v:72,80-87`：帧像素 ready 受 FIFO backend ready、write_req 和 reset 控制；RGB888 packer 每4像素生成3个32-bit字。
- `frame_read_write.v:98-109`：FIFO 使用水位 `<=480` 预留30字延迟余量，ready 在 reset release 两拍后开放。
- `SD/frame_fifo_write.v:87,149,259`：照片写帧期间检查条件为 `write_len_latch <= rdusedw + write_cnt || rdusedw > BURST_SIZE`（照片 `BURST_SIZE=256`）。因此单次看到 CHECK_FIFO 本身不能推出卡死。

握手存在一拍写入延迟：loader/scaler 在同一个 ready 边沿接受像素，loader 随后注册 `write_en`，frame FIFO 在后续边沿采样；30字余量覆盖该在途数据。当前静态路径未见握手丢项。

## 当前 RTL 小实验

通过 Icarus 对当前 C27 `tf_bmp_file_player.v` 与 `bmp_scale_engine.v` 直连回放合成的 16×16、24-bit BI_RGB BMP，按 BMP 逻辑扇区返回 512 字节数据，`write_ready=1`。逐点检查 640×480 输出：应有307,200次像素写入；中央 x=80..559 区域为 RGB `123456`，左右黑边为0。结果：

`PHOTO16_PASS writes=307200 scale_state=0 dw=480 dh=480 offx=80 offy=0 requests=3`

3次请求分别为1个header扇区和2个payload扇区。该实验实际验证 C27 当前窄化 divider、BMP载荷取数、full-frame pixel handshake 与横向黑边；它不验证物理SPI、整机SD/SDRAM并发，也没有注入 `write_ready` 停顿。全支持范围 divider 另以 Python 位宽模型穷举 786,432 个宽高组合，均与整数 `floor(num/den)` 一致。

文件：`tb_photo_16x16.v`，SHA256 `A12EE26882D1D53CF64DABC417D1B41226BA09A2310819C8689B63AE43D8DAC0`；编译输出 `tb_photo_16x16.vvp`，SHA256 `B58D02895DB537A3C5398E72F1DD5144C9AD7B8436E53552D8612CF1CBD447E4`。

## 正控覆盖和素材差异

C27 `build/video_system_20261022_171832/tb_video_system.v` 是独立mode/restart roundtrip正控（六次切换/重启，PASS）。冷启后先 `check_session(0)`，其条件等待 `fs_ready && display_valid && PCM>=256`；video模式为0时 top 的 display_valid 来自 photo loader，因此它实际等到一张 BMP 完成提交。这个正控虚拟卡镜像含四个 16×16 测试BMP，每张822字节；它不逐点比较BMP RGB内容。

本机C27冷启整机回归 `build/video_system_20261022_171144` 强制video起播；其虚拟卡含四张交付备用640×480 BMP，但该bench只验证视频/JPEG/PCM链路。mode/restart正控使用四张16×16 BMP，每张822字节，且首个photo session等到loader提交。历史交付备用图 `SCALE1.BMP` 的只读头为320×240、24-bit、pixel offset 54、文件长度230454（`0x00038436`）；这与现场读到的BMP前四字节`42 4D 36 84`相符到文件大小低16位，支持“TF沿用SCALE1”的线索。前四字节不足以唯一确认实际尺寸或文件内容，因此现场TF图片尺寸和实际payload长度仍待读取完整头/目录元数据确认。作为负载量级对比，16×16正控只读768字节像素数据、2个payload扇区；交付备用640×480素材需读921,600字节像素数据、1801个payload扇区。两者最终都向writer输出307,200帧像素。

## 最小进度观测spec

拍一次器件实测时，提供以下被动观测，锁定数秒前后两组读数即可：

1. `photo_state`、`u_scale.state`、`scale_error/done/failure_code`、`scale_card_read/card_addr`；`bmp_card_valid/end` 与 `bmp_map_error`。payload字节计数器在 `photo_state==PAYLOAD && bmp_card_valid` 时递增；目标字节数应以现场完整BMP头/文件大小为准。若现场图片确认为交付备用640×480素材，像素payload应为921,600字节。
2. `u_scale.out_y/out_x`（或等价行/像素计数）及像素握手计数器 `scale_pixel_valid && bmp_write_ready`，19位饱和计数目标307,200；一眼区分卡读停顿、ready背压、坐标停滞。
3. `photo_write_en`、RGB888 packer phase/word_en、FIFO used/full/ready、writer FSM 与 `rdusedw`、`App_wr_en`、write-finish toggle。若握手像素增加而 packed word/水位不增，停点落在packer/FIFO边界；水位不增且writer CHECK_FIFO时，先看实际 `rdusedw` 与 `into_burst`。
4. HDMI 另由系统侧临时被动页观察 `O_video_locked`、AXIS ready/valid+SOF、DE 与serializer内部活动。它用于区分显示输出链与本次BMP载荷链，避免单凭显示器无信号把问题归因到缩放器。

此spec无需触碰生产工程；未来若添加临时观测页，应输出寄存器/计数值，不在装卡固化源中引入控制依赖。
