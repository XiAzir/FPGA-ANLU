# HDMI 串行器隔离模型结果

范围限定于独立 Icarus Verilog 模型；未改生产源码或检查点，也未运行 TD、生成位流或上板。基线读取 `development/player_music_envelope`；候选直接读取 `development/player_music_envelope_phy`。实际源哈希和机器可读汇总见 [result.json](result.json)。

模型逐字复用两版 `lane_lvds_10_1.v` 与 `hdmi_phy_warpper.v`，只在本目录生成副本，添加marker延迟参数以及 primitive 外的 D0、D1 数据pin和PAD时钟路径延迟。候选本体在 pixel 下降沿寄存四路完整TMDS字、同沿更新lane marker，并在 serial 下降沿同时更新 `S_oddr_data` 两位。向量含TMDS控制符号、TERC4符号及逐像素伪随机高翻转字；每个位有独立、确定性的0至2ns输入偏斜。

ODDR stub按本机安装的官方 `eg_logic_io.v` 功能模型实现：serial上升沿同时采样D0与D1，D1经 `comp_reg` 在下降沿更新，输出选择时钟路径延迟100ps。stub省略 `glbl.gsrn` 全局配置复位，只使用设计异步复位；每组两个复位周期。所有串行输出在PAD时钟每个上、下降沿后101ps采样。

常规矩阵共基线27组、候选27组：串行相位偏移-1/0/+1ns，marker延迟0/1/2ns，三组复位种子。候选另测PAD边界1组：D0延迟50ps、D1延迟1500ps、PAD clock延迟1000ps。每次只使用一个四路共同bit偏移和load字起点（连续5字共同匹配），随后固定起点检查所有完整剩余字；另检查候选每次载入字必须等于 `rev(pat(n-1,lane))`，且相邻load的源序号连续递增。n在pixel上升沿递增，wrapper在随后的下降沿采样并同沿发marker；对应shift load发生在下个pixel上升沿之后、再下个下降沿之前，因此此时n比wrapper持有的源字序号大1。该断言独立于wrapper寄存器，并检查四个lane各自的预期pattern。runner同时要求Icarus编译成功、candidate仿真退出码为0；唯一允许非零退出的是基线边界反例，并要求其summary确实无四路共同对齐。

候选28组全部通过：共检查5077个完整字位置，字错误、串行位错误、源序列跳字、捕获错误均为0；各组四通道load计数一致。基线常规矩阵27组通过；边界注入组未找到四路连续5字共同起点。该反例说明所选数字延迟假设下，旧版同沿ODDR数据更新存在混采窗口，而候选提供了更宽的离散模型裕量。

模型不能证明板上延迟或实板根因。延迟参数不是测量值，且模型不含亚稳态、抖动、真实PAD/PCB电气、接收器采样、布局布线STA或硅后primitive差异。早期使用错误D1-on-negedge stub产生的summary和日志已移至 `early_stub_invalid`，不参与正式凭据。

