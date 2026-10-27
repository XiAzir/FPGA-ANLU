# EG_LOGIC_ODDR direct input probe

日期：2026-10-27。此目录是B探针的独立副本。A/B目录保持冻结；本目录未生成bitstream，未执行下载。

## 修改内容

原lane在串行时钟负沿把 `S_shift_data[9:8]` 暂存到 `S_oddr_data`，随后连接 `ODDR.d1=S_oddr_data[0]`、`ODDR.d0=S_oddr_data[1]`。Verilog向量映射为 `S_oddr_data[1]=S_shift_data[9]`、`S_oddr_data[0]=S_shift_data[8]`，因此直接输入应为 `d0=S_shift_data[9]`、`d1=S_shift_data[8]`。候选仅移除这组寄存器和负沿块，pending/load/shift调度保持不变。

候选输出寄存仍由TD映射成每lane `DDRX1`。官方功能模型 `EG_LOGIC_ODDR` 在正沿采样 `d0/d1`，`d1`经内部两个边沿级输出；独立夹具直接比较参考版与候选版四路物理 `q`，没有用内部寄存器相等代替输出等价。

## ModelSim物理q对比

ModelSim SE-64 10.1c使用TD安装的原始 `sim_release/eg4/eg_logic_io.v` 与 `eg_phy_glbl.v`。主等价运行引用未经修改的模型。确定性随机数据由 `$random(seed)` 生成；4 lane分别使用独立seed，每个phase各lane输入162个10bit字。像素/串行时钟取74.285714/371.428571MHz，串行频率严格为像素频率5倍；串行初始相位为0ps、400ps、1000ps。

每个串行时钟跳变后等待模型中`clk_mux`的0.1ns功能延时稳定，再采样四路q向量；每组采1618次。每phase覆盖启动异步复位、播放期间在pixel正沿发起且保持3.2ns的reset、以及非时钟边沿发起且保持3.2ns的异步reset。3.2ns大于一个完整串行周期2.692ns。三组均PASS，合计比较19416个逐lane q采样位（4854个四lane向量，1618向量/组×4lane×3组）。首次错误连接的结果保留：phase 400ps、61ns首个q不一致，随后根据向量位序纠正d0/d1；纠正后模型等价通过。

## TD综合与布局布线

只在ModelSim等价通过后执行。TD 6.2.1 SP1 `read_adc`、综合、合法化、place、route均成功。没有设置false path、exclusive clock group、multicycle或随机seed。

| 指标 | B版原始直接前版本 | 直接ODDR输入版本 |
|---|---:|---:|
| STA覆盖率 | 84.09% | 83.45% |
| SWNS / STNS | +0.007 / 0ns | +0.892 / 0ns |
| HWNS / HTNS | +0.067 / 0ns | +0.067 / 0ns |
| 串行时钟内寄存器最小周期 / Fmax | 2.678ns / 373.413MHz | 1.800ns / 555.556MHz |

B版的原坏路径是 `S_oddr_data_reg` 负沿寄存器到输出PAD正沿，预算半周期1.346ns。直接输入版本报告最差路径为串行时钟正沿寄存器到正沿寄存器，预算完整周期2.692ns，最差路径为 `S_load_en_2d_reg` 到另lane `S_shift_data_reg[7]`；负沿到PAD的半周期路径消失。SWNS提升0.885ns。

直接输入版本综合资源为43 LUT、105 reg、1 PLL、1 GCLK、4个DDRX1输出；四对输出位置仍是K11/J11、L14/M14、K15/M15、H13/J13。route继续有 `PHY-5014 detail route doesn't find pib for u_pll/pll_inst.fbclk[0]`。`check_timing`仍指出串行PLL约束371.500MHz与PLL参数371.428571MHz有偏差、refclk无input delay、四路输出无output delay；STA覆盖83.45%。reset仍未在ADC约束中指定位置，TD将其自动分配到H16、LVCMOS33、PULLUP。

## 结论边界

直接接线版本在官方EG4功能模型的q输出上与参考版本逐位等价，且片内时序报告显示负沿到输出PAD的半周期路径变成串行时钟正沿完整周期路径。仿真验证的是安装的数字功能模型；TD route和面积报告验证的是芯片映射及约束下实现，不包含真实芯片PLL锁定、输出波形、板级SI、接收端兼容或完整播放器运行验证。

## 核心证据

- 候选HDL：`src/user_source/serializer.v`
- frozen B副本：`sim/serializer_reference.v`；ModelSim夹具：`sim/tb_direct_equivalence.sv`
- 原生官方模型：`sim/eg_logic_io.v`、`sim/eg_phy_glbl.v`
- 等价PASS日志：`sim/modelsim_equivalence_run03.log`
- 首次d0/d1反序差异：`sim/modelsim_equivalence_run01.log`
- TD完整日志与route数据库：`build/td_run_direct.log`、`build/native_clock_serializer_probe_b_pr.db`
- STA报告：`build/native_clock_serializer_probe_b_pr.timing`、`build/native_clock_serializer_probe_b_chk.timing`、`build/native_clock_serializer_probe_b_phy.area`
- 所有关键源、模型、日志和报告SHA-256：`probe_summary.json`

