# 开源 JPEG RTL 核初筛

日期：2026-10-21

## 初筛结论

首选 `ultraembedded/core_jpeg`。该核明确面向 baseline sequential JPEG，支持 4:2:0、固定标准 Huffman 表和 JPEG 流内 DQT；公开声明的 4:2:0 峰值为 2.1 cycles/pixel，且有 Xilinx 7-series 实机测试背景。输入素材是 8-bit SOF0、4:2:0、标准 Huffman、640x480 的独立帧，格式匹配度高。15 fps 对应 4.608 Mpixel/s；用公开峰值折算约需 9.68 Mcore cycles/s（无停顿理想值），实际吞吐要由本地时钟、输入节流和输出背压测量确认。

它适合作为最小综合试验对象；EG4S20 上相对剩余 2828 Slice、19 BRAM9K、20 DSP 的适配情况待本地综合确认。公开资源图标注为 Xilinx 7-series post-implementation，抓取结果没有给出图中数字。README 声称设计可达至少 75 MHz，该时序数据对应 Xilinx 平台。

## 接口和集成要点

- 顶层 `jpeg_core` 输入为 32-bit AXI-Stream 风格 `valid/accept`，带 4-byte `strb` 与 `last`；帧内容通过 JPEG marker parser 输入。
- 默认 `SUPPORT_WRITABLE_DHT=0`，提供固定标准 Huffman 表；`=1` 可接收可写/优化 DHT，代价是逻辑增长和性能下降。标准 Huffman 素材宜先用默认值。
- DQT 从输入 JPEG 配置，核支持动态 DQT。
- SOF0 解析只识别 monochrome、4:4:4、4:2:0；4:2:2、progressive SOF2、DRI/restart markers 不支持。素材为 SOF0/4:2:0 且每帧独立，符合已声明范围；仍需抽样确认无 restart interval、APP/COM 及其他该核不处理的 marker。parser 在 marker 解析状态会跳过部分 APP/COM/DRI 类扩展段；熵数据中的 restart marker 仍属不支持项，EOI/位填充行为也建议用本地文件验证。
- 输出是 RGB888 像素、宽高和 x/y 坐标。内部按 block 接收并重排到行列像素坐标，适合直接接显示 FIFO；帧尾需在系统侧用 `valid && x==width-1 && y==height-1` 派生，并结合 `idle_o`/EOI 控制帧完成。
- 输出端有 `outport_accept_i` 背压；缓存 RAM 会承担块重排和 Y/Cb/Cr 对齐。仓库 issue 列表中仍有开放的 “backpressure at jpeg_output.v” 报告，需在输出随机停顿仿真中优先检查数据、坐标保持和丢像素。
- 源码有独立 dual-port RAM、transpose RAM、FIFO、IDCT 乘法路径。作者称乘法器/表/FIFO 会映射到 DSP48 和 Block RAM；EG4S20 上实际映射、是否落入 BRAM9K，以及乘法器资源需要直接综合确认。

## 第二候选

`ultraembedded/core_jpeg_decoder` 提供 AXI4-Lite 控制、AXI DMA 输入/输出和 RGB565 写回，README 声明在 Digilent Arty A7（Xilinx）测试。README 明确说其底层基于 `core_jpeg`，因此算法与主要资源风险相同；DMA/AXI 总线包装对当前像素输出集成增加外部依赖，暂不建议把它作为独立候选核综合。若目标流程本来就有 AXI DMA/内存，再单独评估包装层。

## 许可与出处

解码核心仓库标注 Apache-2.0；遵守随附许可证、保留版权/许可声明并标注修改文件。AXI DMA 包装仓库也提供 Apache License 2.0。

- 核源码与 README：<https://github.com/ultraembedded/core_jpeg>
- 核 README：<https://raw.githubusercontent.com/ultraembedded/core_jpeg/main/README.md>
- 顶层端口及连接：<https://raw.githubusercontent.com/ultraembedded/core_jpeg/main/src_v/jpeg_core.v>
- JPEG marker/SOF0/采样因子解析：<https://raw.githubusercontent.com/ultraembedded/core_jpeg/main/src_v/jpeg_input.v>
- RGB 输出、坐标和 accept 背压：<https://raw.githubusercontent.com/ultraembedded/core_jpeg/main/src_v/jpeg_output.v>
- RAM 实现示例：<https://raw.githubusercontent.com/ultraembedded/core_jpeg/main/src_v/jpeg_output_y_ram.v>
- Apache-2.0 文本：<https://raw.githubusercontent.com/ultraembedded/core_jpeg/main/LICENSE>
- DMA 包装说明：<https://raw.githubusercontent.com/ultraembedded/core_jpeg_decoder/main/README.md>
- 开放 issue 列表：<https://github.com/ultraembedded/core_jpeg/issues>

## 建议的最小本地实验

1. 在独立工程中只加入 `core_jpeg/src_v` 全部依赖 RTL，设 `SUPPORT_WRITABLE_DHT=0`，综合 EG4S20；统计 Slice、BRAM9K、DSP 和最高时钟，并检查 Y/Cb/Cr 缓存、IDCT 表和乘法器的资源映射。
2. 用一张实际 640x480 JPEG 做一次无背压仿真，核对 307200 个像素、坐标边界、RGB 输出和 EOI/idle 帧完成；记录核心周期，换算 15 fps 是否有裕量。
3. 对同一帧加入输出随机 `accept` 停顿，确认输出 valid 数据/坐标保持、帧尾和像素总数正确；这一步针对开放 issue 所指风险。
4. 若资源超额，再单独检查 `jpeg_idct` 精度/乘法映射与输出重排 RAM 的代价；首轮保持核心本体配置，随后再评估 DMA 包装层。

## 证据缺口

- GitHub README 的资源图只能确认平台为 Xilinx 7-series、post-implementation；图内 LUT/FF/BRAM/DSP 具体数字在本轮抓取中不可读。
- 未执行源克隆、仿真或 TD 综合；本记录属于公开源码初筛，EG4S20 适配结论待本地实验。
- SOF0 标记匹配不自动保证任意 JPEG 文件皆兼容；需用本地素材验证其 marker 顺序、DQT 精度/表数、restart interval 与输出背压行为。
