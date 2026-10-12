# C11206 多尺寸 BMP / FPGA 最近邻缩放

从 C11205 transition_wipe verified169 文件逐项SHA核验后隔离复制，不复制旧TD数据库。成功回退仍为C11205，当前工程在开发验证中。

显示时序与帧缓存目标保持640×480/RGB888；新增 bmp_scale_engine 在加载阶段解析原尺寸24位BI_RGB像素，等比缩放并居中补黑边。支持正负高度、奇数宽行填充，宽1..1024/高绝对值1..768。输出按底向上行序送原WRITE_V_FLIP=1 writer，目标在SDRAM中仍按正常显示方向存放。首版为最近邻，不做双线性或裁剪。

单个512字节扇区同步缓存、一条最多1024像素的源行同步缓存；复用相同源行。完整扇区/源行才提交tag，反向访问由原FAT32 mapper重新定位。原音频、HDMI PHY、PLL、约束、字幕、亮度对比度、波形冻结和转场读侧保持。write FIFO 实际写域水位/full/reset-release提供反压，pixel_ready低时保持引擎待输出像素。

规格见 [build/scaler_spec.md](build/scaler_spec.md)，独立媒体/gold与真实loader模型见build/model/scaler_*，实际pack/backend/FIFO压力模型见build/model/run_write_backpressure.ps1。复制的旧模型/review为父版本材料，没有日志的模型未重跑。新增验证范围以build/model/verification_scope.md为准。

正式构建入口为 scripts/build_candidate.ps1。仅在最终原约束setup/hold/TNS均非负后生成候选位流。源码/脚本/数据库/报告/位流来源需绑定封存；本地模型和时序不能替代实板确认。

板卡/AL-LINK在用户远控的实验室电脑；本机不做JTAG/TF/Flash操作。已知动态波形双线和低清晰度留到优化阶段。
