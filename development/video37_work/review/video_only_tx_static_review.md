# Video-only TMDS TX 静态复核

日期：2026-10-27（北京时间）
范围：只读复核 `video_only_tmds_tx.sv`、`packet_assembler_compat.sv`、上游 `tmds_channel.sv` 和 `tb_video_only_tmds_tx.sv`，并对照现有 PHY lane wrapper/serializer 顺序。未改 RTL；未启动 TD、ModelSim 或重任务。结论限于静态代码审查及既有 TB/README 所记录结果。

## actionable 风险

### R1｜RGB 输入必须提供当前坐标的同拍像素（集成前置）

- 位置：`video_only_tmds_tx.sv:56-58,125`；上游 `tmds_channel.sv:22-25,148-156`；TB `tb_video_only_tmds_tx.sv:62-64,256-263`。
- `cx/cy/active` 是当前计数器组合输出；RGB 直接进入编码器组合路径，TMDS 输出在像素时钟沿寄存。因此要求上游在该沿之前提供当前 `cx/cy` 对应的 RGB。TB 以组合 `color_at(cx)` 满足此契约。若生产像素源由同一像素沿的同步 BRAM/scaler 输出，TX 会采到前一坐标的 RGB，首像素/行边界可能错一拍；无 `valid`/ready 或内置坐标补偿可自动对齐。
- 动作：接入前明确 RGB 数据源延迟；若源延迟一拍，就对坐标/同步/active 做一致的延迟对齐或在输入侧补偿；用生产 RGB 源的首行首像素边界做门级/布线后核对。当前短垂直窗口 TB 的范围未纳入生产像素源延迟与映射首行差异。
- 判定：集成风险，取决于上游像素源时序；静态代码未证明已有错位。

### R2｜PLL 锁定与复位释放时序由集成顶层负责

- 位置：`video_only_tmds_tx.sv:17-18,61-74`；上游 `tmds_channel.sv:15,20,92,148-156`；TB `tb_video_only_tmds_tx.sv:16-17,43,223-225`。
- 计数器只对 pixel_clk 上升沿采样同步 reset；TMDS 输出寄存器仅有声明初始化，未提供 reset 端口；差分 lane 位于模块外。TB 假定 pixel_clk 从仿真开始稳定，保持 reset 四个周期后释放，未覆盖 PLL 未锁、停钟、失锁重锁或 reset 与 pixel_clk 边沿关系。
- 动作：集成时以 PLL lock 保持视频时序和 PHY 复位，且在稳定 pixel_clk 域同步释放；板测检查锁定前输出及重新锁定后的首帧。模块本身未强制这一顺序。
- 判定：系统集成门槛，是否会造成现场失败取决于 C37 top 的复位/PLL 连线；C37 top 未纳入本次审查，风险归因待顶层复核。

### R3｜VIC0 不提供标准 1080p 时序识别信息

- 位置：`video_only_tmds_tx.sv:130-135,162-165`；SPD 文本与构造见 `:137-153,166-173`。
- AVI InfoFrame 使用 `VIDEO_ID_CODE(0)`；SPD 携带 `FPGAANLU / VIDEO ONLY TX` 文本。两者均未编码标准 VIC 对应模式能力。对自定义1920×1080、15Hz栅格，接收器仍需根据实际 H/V 频率识别。已有EDID摘录显示该屏声明 V58–62Hz、H30–83kHz；当前 C36 约15Hz/16.5kHz落在其声明范围之外。用户反馈 PC 按相同33MHz、2000×1100、15Hz发送时持续出现“输入不支持”但画面完整更新，与接收器按扫描频率拒绝模式相容。已有短帧 TB 对 AVI/SPD checksum 与包结构的检查通过；修改 SPD 名称无法表达接收模式能力。
- 动作：上板判读时把“可见有效图像”与接收器模式接受状态分开记录；若必须消除屏上“不支持”，需实测接收器接受的标准/声明范围内扫描时序，同时保持内容更新目标。当前源码不带接收器能力协商。
- 判定：明确兼容性风险；具体根因仍需与 PC 同参数现场反馈和接收器时序范围对照。

## 覆盖缺口（需要收敛标准/补验证）

### C1｜TB 的 VSYNC 期望函数复制了 DUT 的边界算法

- 位置：DUT `video_only_tmds_tx.sv:80-93`；TB `tb_video_only_tmds_tx.sv:138-147,322-324,353-362`。
- TB 的 `expected_vsync` 逐项复用了 DUT 在首个/最后一个垂直同步行、`x=H_ACTIVE+H_FRONT` 的分段规则；其后的控制符号及 TERC4 C0/C1 检查都对照这个函数。当前检查能发现编码/接线与该算法之间的偏差；建议再用独立时序表生成期望值，核对垂直边沿位置是否符合系统契约。
- 动作：将预期的 VSYNC 起止行与行内相位直接绑定到已选定的时序表/接口契约；保留当前“同步位在控制期、preamble、TERC4和guard中一致”的检查。
- 判定：验证独立性缺口；该项结果不构成 VSYNC 源码错误的依据。

### C2｜缺少真实生产像素源、PHY 与映射后首行的闭环

- 位置：TB 几何 `tb_video_only_tmds_tx.sv:3-14`；RGB 发生器 `:45-64`；PHY/PLL/板级 wrapper 不在本审查四个文件中。
- TB 用1920有效像素、2000总像素、16有效行/36总行，覆盖两个缩短帧的像素数、打包、ECC、同步码与岛边界。当前TB范围为缩短垂直窗口下的行为检查；全1080行、真实像素源延迟、PHY串行字节位序、布线后时序与接收器锁定仍待独立验证。README 记录的行为级 PASS 只支持RTL功能层结论。
- 动作：C37 集成后用现有 C35 PHY 复核每 lane 的串行首位；在生产 RGB 源下检查首个锁定有效行的 RGB 边界；保留综合/布线后时序与板测为独立证据阶段。
- 判定：验证范围边界，无源级阻塞结论。

## 已核对且未见阻塞

- **TMDS/PHY 位序**：编码器输出为10-bit TMDS code；当前 PHY wrapper 将 `I_tmds_channel[0]` 放到 lane 输入最高位，随后 lane 每次移出 `[9:8]`，可还原 bit0/bit1 先发顺序。固定 `clockword=10'b0000011111` 与现有 C35 PHY 使用值一致。复用现有 wrapper 时，保持反序适配和 lane 发送相位原样；本次未做串行 PHY 仿真或板级眼图判断。
- **1岛/行与blank80**：岛前preamble为 `H_ACTIVE+4..+11`，前guard `+12..+13`，32个payload `+14..+45`，尾guard `+46..+47`，总占48个blank时钟；Hblank80余32时钟，随后行末视频preamble/guard位于 `H_TOTAL-10..-1`，没有水平重叠。岛payload可跨水平同步脉冲，并在 channel 0 的 TERC4 C0/C1及guard/control期携带H/V状态，这是预期路径。
- **包结构**：局部compat assembler用32个符号发送header/subpacket及BCH；TB逐符号解码并校验AVI/SPD/NULL header、InfoFrame checksum、五组ECC及guards。未发现静态计数/包切片错位。
- **首锁/初始化**：计数器初值 `(H_TOTAL-32,V_TOTAL-1)` 使周期输出先经历22个控制符号、8个视频preamble和2个video guard后到 `(0,0)`；与其余行末的 preamble/guard 位置一致。硬件初始化和真实PLL释放顺序仍见R2。

## 依据路径

- 新TX：`development/video33_work/open_tx_work/video_only_tx/rtl/video_only_tmds_tx.sv`
- Packet ECC适配：`development/video33_work/open_tx_work/video_only_tx/rtl/packet_assembler_compat.sv`
- 上游TMDS编码：`development/video33_work/open_tx_work/video_only_tx/upstream/src/tmds_channel.sv`
- 行为TB：`development/video33_work/open_tx_work/video_only_tx/tb/tb_video_only_tmds_tx.sv`
- 当前PHY对照：`development/player_dynamic_text_video_probe/src/user_source/hdl_source/hdmi_phy_warpper.v`、`lane_lvds_10_1.v`
- EDID/现场模式背景：`development/video33_work/output_limits/README.md`、`E:/QQ CACHE/Download/安路资料/开发记录/当前状态.md`

## Addendum｜独立 VSYNC 契约核验（2026-10-27）

遵照模运算契约新建 `tb_vsync_contract.sv`，冻结 TX 与上游 SV 核。每个有效采样点先锁存沿前 `cx/cy/rgb`，在同一沿后检查寄存的 TMDS code；VSYNC 期望只由帧内位置和契约起点计算，不读 DUT 的 `vsync`、按行分支或 `mode` 来生成期望。

契约定义：`F=H_TOTAL*V_TOTAL`；`A=(V_ACTIVE-1)*H_TOTAL+H_ACTIVE+H_FRONT`；`VS_START=(A+V_FRONT*H_TOTAL) mod F`；`VS_END=(VS_START+V_SYNC*H_TOTAL) mod F`。HSYNC 期望低区间按每行 `H_ACTIVE+H_FRONT <= cx < H_ACTIVE+H_FRONT+H_SYNC`。控制符号、DI preamble中的channel-0控制码、TERC4 payload低两位和DI guard中的channel-0 TERC4码均解码并对照该期望；视频guard区按协议不携带H/V，跳过同步位比较。另检查每行HSYNC落/升沿、宽度/周期，VSYNC落/升沿实际解码位置/间隔，以及整帧后计数器恰回 `(0,0)`。首行RGB只核对 `(0,0)` 与 `(H_ACTIVE-1,0)` 两端。

### 结果

- **1920×1080，Htotal=2000，Vtotal=1100**（默认C36）：完整一帧2,200,000 pixel cycles；PASS。解码VSYNC下降沿帧内位置2,167,928，上升沿2,177,928，低宽10,000 cycles（5行）；HSYNC每帧落/升沿采样各1,100次，下降沿间周期2,000、低宽8；下一帧起点周期2,200,000。
- **C35 640×480，Htotal=1000，Vtotal=550**（HFP/HSA/HBP=16/96/248，VFP/VSA/VBP=10/2/58）：完整一帧550,000 pixel cycles；PASS。VSYNC下降沿489,656，上升沿491,656，低宽2,000 cycles（2行）；HSYNC每帧落/升沿采样各550次，下降沿间周期1,000、低宽96；下一帧起点周期550,000。
- 两组逐个检查全部可译同步位置，控制/TERC4/DI-guard编码与独立契约一致；RGB首行两端解码匹配沿前采样值。此结论只覆盖冻结SV核心的行为级Icarus仿真。

第一版1080p单帧日志 `1080p15_vsync.log` 保留了1082项失败。复核发现夹具在posedge之后用已更新的`active`分类，并用更新后的`rgb`作沿前期望；TMDS寄存字对应posedge前的坐标/数据。修正版在沿前保存坐标、几何active和rgb，再沿后核对；两组修正版均通过。该首轮失败反映夹具采样时序问题，不构成 RTL 失败证据。

### 可复现文件与绑定

- 新增契约TB：`development/video37_work/review/tb_vsync_contract.sv`，SHA-256 `BEC19754D88FDDA924ED1ECBCF5F1398E1D8DCEC760F46AEBF964D62264FE80C`。
- 冻结核心 `video_only_tmds_tx.sv`：SHA-256 `64F1142679C718D85979C32A61BAD80D6A2E43B1BA7AF35E6040B41AD98091C9`。
- 冻结compat ECC `packet_assembler_compat.sv`：SHA-256 `4ED9318DE09ACC5196268E46BD8E5D3CC589176B829534C908587E2E2DE298A7`。
- 冻结上游 `tmds_channel.sv`：SHA-256 `FFAD8647C0C0FC7F376A79D54227AFEBF6C68EEAFD101604F9D38FDAF7042751`。
- 结果输出：`1080p15_vsync.log`（首版夹具失败，保留作发现采样问题的记录）；修正版PASS输出见本节结果。参数编译记录为 `1080p15_compile.log`、`C35_compile.log`；原SV源码未改。
- 仿真器：工程固定依赖 Icarus Verilog，使用 `iverilog -g2012` 编译、`vvp` 执行；无TD/ModelSim任务。

