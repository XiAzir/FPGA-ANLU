# BMP header byte-timed extent pipeline backup

此备选从冻结的 stride header 候选 `tf_bmp_file_player.header_stride.production.v` 派生，基线 SHA256 `093c86171d75dd5f9df66da51bbc0830bc391b70b4c5ae627d3bf4d0d8111dc6`。独立生产候选 `tf_bmp_file_player.header_stride_pipe.production.v` SHA256 `28c78aef011d5d729256a0af618dc609ede1de11a1dcb7bd418564776ad58534`；补丁为 `patch_stride_pipeline.diff`。

唯一算法变化是把已经在 HEADER 字节流中可用的几何量逐段锁存：

- byte 22：宽度完整字节 18..21 已在前面采集，锁存 `stride_words_q[9:0]`。
- byte 26：高度完整字节 22..25 已采集，用锁存 stride 和 `abs_height[9:0]` 相乘，将22位 image byte count 零扩展后写入 `pixel_end_work[32:0]`。
- byte 27：pixel_offset 字节 10..13 已采集；用其和工作寄存器低22位相加，原地覆盖为完整33位 pixel_end。
- CHECK 仍在512字节扇区结束后进行，所有 mask/header_ok 仍读取同一33位 pixel_end。

共新增43个寄存器位：10位 `stride_words_q` 加33位复用工作/最终结果寄存器。每个预计算都在原 HEADER 周期内完成，没有增加外部周期。所有赋值位于 `card_valid` 对应的 byte-index case 中；reset 和启动新 header 时清零。短/长扇区不会进入 CHECK，byte22/26/27 的停顿由当前有效字节索引保持。

验证证据：

- 原 2,048 个 stride 输入测试 PASS；公式和截断没有变化。
- pipeline/reference 周期级全部公开输出对照：538 cases、529 header masks 全通过；包括 512 个 raw32 width/height/declared/file-size 随机交叉、短/长扇区、file_error mapper、watchdog、ack timeout、短 payload、sticky first failure、reset 和768像素 valid commit。见 `pipe_mask_run.log`。
- 独立暂停用例在 header byte 22、26、27 前分别插入三周期 card_valid 空隙；全部公开输出的周期级对照通过，valid_commit=768 pixels。最终全输出日志为 `pipe_mask_alloutputs_run.log` 和 `pipe_pause_alloutputs_run.log`。
- 完整 loader gold regression：6 张图、1,843,200像素均通过，包含背压运行；见 `full_loader_run.log`。
- 4 种坏输入保留行为均通过：zero dimension、unsupported width、short sector、truncated payload。见 `bad_inputs_run.log`。

补丁 SHA、候选和测试日志 SHA 在 `pipeline_manifest.json`。未运行 TD，未修改主源或 gold。此方案仍是待选备份；43个额外寄存器可能增加 slice 占用，需根据 B03 的 STA 和面积余量决定是否采用。
