# OSD HDMI 串行器独立审计

日期：2026-10-09。范围限于 `player_osd` 的未加密 `lane_lvds_10_1.v`、`hdmi_phy_warpper.v`、`IP/video_pll.v` 与 OSD RGB 覆盖路径。没有修改任何工程源文件，没有调用 TD 构建、没有上板或网络操作。

## 可由源码确认的拍关系

- `video_pll.v` 注明输入50 MHz，输出 pixel 25 MHz、serial 125 MHz，两个输出相位均为0°；IP参数为参考分频2、C0分频40、C1分频8。该文件给出期望频率与相位，不能当作板上实测。
- pixel上升沿翻转 `S_odd_even`。serial域以 `S_odd_even_1d/2d` 同步，再用 `S_load_en <= S_odd_even_1d ^ S_odd_even_2d` 检测变化，`S_load_en_1d/2d` 继续流水；由于非阻塞赋值，shift逻辑在同沿读取旧的 `S_load_en_2d`。
- 从 serial 同步器首次采到新 toggle 起，shift 装载在后续第5个serial上升沿发生；首次采样相对pixel边沿可能晚0至8 ns。因此源代码模型中装载约在pixel变化后32至40 ns。serial是pixel的5倍，每像素40 ns；在某些相位组合下该装载边沿恰好落在下一pixel上升沿。
- `S_oddr_data` 在后续serial上升沿从移位寄存器取两位，ODDR stub在串行时钟上升/下降沿依次输出两位。移位寄存器每次左移两位。四个lane连接同一pixel/serial时钟与复位，wrapper仅逐位反转并实例化lane。

## 独立仿真

产物：`tb_lane_lvds_10_1.v`、隔离的早采样候选、`run_sweep.ps1` 与summary。工具为工程内 Icarus Verilog 12.0 (devel)。测试只综合/仿真未加密lane，并自建 `EG_LOGIC_ODDR` 双沿行为stub，不代表安路硅片原语的已验证仿真模型。

TB输入每个pixel沿生成不同的10位字，建模像素数据在pixel沿后0–7000 ps更新；扫描serial初相位0–7900 ps、100 ps步进（80相位），skew取0、100、250、500、1000、2000、4000、7000 ps（共640组合/版本）。测试按实际ODDR输出的每10个串行位重组完整字，并逐字与装载字序列比对，同时检查每次装载是否采到预期pixel字。该模型不注入亚稳态或时钟抖动。

- 基线640组：每组99次steady-state装载；输出完整字序列错字0，装载字与预期pixel字不符0。
- 基线相位窗口：装载边沿相对pixel沿为32.0–39.9 ns；相位相等的4000 ps case恰在下一pixel沿（报告的模40 ns偏移为0）。相邻扫描点3900 ps为39.9 ns，4100 ps为32.1 ns，说明同步器首次采样跨过相位边界时，装载拍会整整提前一个serial周期（8 ns）。零-skew边沿同拍是RTL仿真竞态/实物setup-hold风险点，仿真没有建模物理亚稳态。
- 早期隔离候选在独立副本中加入10位 `S_pending_data`，在 `S_load_en_1d` 对应的早一拍捕获输入，原 `S_load_en_2d` 时刻仍装入shift。初始640组输出与输入字均通过。随后 `run_sweep.ps1` 增加 `-LaneSourcePath`；直接把正式独立修复工程 `player_osd_phy_fix` 的lane作为输入重跑640组，边界错误0、输出逐字错误0。输入采样窗口模型为24.1–32.0 ns，移位输出装载拍保持原点。该candidate工程正在单独构建/时序审查；此处Icarus结果不代替综合/STA/实板。

运行：在项目根目录执行 `./development/player_osd/build/serializer_audit/run_sweep.ps1 -Mode baseline`，或 `./development/player_osd/build/serializer_audit/run_sweep.ps1 -Mode candidate -LaneSourcePath 'E:\VSCODE-project\FPGA-ANLU\development\player_osd_phy_fix\src\user_source\hdl_source\lane_lvds_10_1.v'`。candidate源须已有 `S_pending_data`，runner不自动补写；候选门禁要求640组且目标字/串行字错误均为0。脚本每次重编译TB与被指定lane，再运行phase/skew矩阵。

## OSD及结论边界

`player_osd.v` 在 active-video 且内部坐标落于框内时，输出白色glyph或固定 `24'h000000`；框外保留 `rgb_in`，blanking期也保留 `rgb_in`。顶层把overlay放在 `video_delay`之后，并把同一 `vs/de`送入overlay；再送至RGB-to-AXIS模块。图像编号/文件元数据不进入该固定黑底分支，源码层没有让SDRAM/FAT32元数据把常数黑色变绿的路径。实际坐标是否与面板像素严格对齐仍需波形/显示观察；绿色可以来自框未命中时保留的输入RGB，也可能来自串行传输采样错误，当前证据不能区分。

源码和模型证明了串行load存在窄相位边界，直接相位对齐时仿真load正落在下一pixel边沿；这为有目的地测试串行采样裕量提供依据。它不能证明用户实板绿底、斑点或竖纹由此引起，也不能证明PLL相位/时钟抖动/路由延迟的实测值。新旧位流还存在整体布局布线差异，实板根因未定。

最小修复候选：在每lane加10位暂存字，把输入采样相对原load提前一个serial周期，再在原 `S_load_en_2d` load时刻取暂存字进入移位链；它保留TMDS word输出拍边界，且模型仿真通过。应用前仍须在工程副本评估资源、综合/布局后setup/hold及原约束，然后单独位流做实板A/B。不可只把shift条件改成 `S_load_en_1d`：那会提前移位装载拍，serial输出字分组相对ODDR改变，不能保留原字边界。

## 延迟注入复核与正式候选验证（2026-10-09）

为覆盖基线640相位/静态skew矩阵没有建模的输入传播延迟，在独立TB中给pixel toggle寄存器输出加可控 `#(TOGGLE_DELAY_PS)`，并把每个10-bit输入位在pixel沿后分别延迟 `50 + ((bit_index * skew_mode) % 951)` ps。三组skew_mode为97、211、337，覆盖每位正skew 50–1000ps；像素字按 `000 / 3e0 / 01f` 循环，相邻字HD距离5、10、5，激活全部bit。serial首个上升沿设在pixel首沿后100、200、…、600ps。toggle输出延迟取200、300、…、800ps，故每版矩阵126组。复位期间两个时钟先运行至400000ps再释放，避免原控制同步器未复位时把启动首个脉冲误作稳定态失败；期望字以预热后的pixel事件固定序列核对，并另以实际串行输出逐位重组10-bit字、独立与shift加载序列校验。TB找对齐时要求连续5个10-bit字严格匹配，找到唯一整体起点后继续检查余下完整序列，不对每个字分别搜索偏移。

复现脚本 `run_delay_injection.ps1` 接受 `-Mode baseline|candidate`、`-LaneSourcePath <完整源路径>`、`-OutputPrefix <名>`。baseline默认读失败OSD首版的原lane；candidate默认读独立修复目录的正式lane。候选模式不会自动补写pending寄存器，路径源缺少 `S_pending_data` 时立即失败；两模式只在 `serializer_audit` 内复制lane并注入toggle延迟，候选逻辑本身直接取传入源文件。候选门禁要求126组且目标字误差、输出串行字误差均为0。Icarus为仓内 `bringup/tf_wav_hdmi/tools/iverilog/app/bin` 的12.0-devel。行为stub按serial上升沿/下降沿分别驱动ODDR输入位；这是仿真假设，不是已验证的安路原语模型。输入正skew及toggle延迟也只是扫描假设，不是实测板级延迟。

结果文件为 `formal_lane_delay_final_baseline_summary.txt`、`phy_fix_lane_delay_final_candidate_summary.txt`。原lane 126组共12474次shift加载，96组出现目标字不符，合计8085个错误字（64.8%）；串行输出与它实际捕获的shift字序列相符，输出重组误差0。候选正式lane 126组共12474次加载，目标错字0、串行序列错字0。对候选检查时的正式lane SHA-256为 `4E2297D22452B437EE60968DAAD5D6473E1541AB1614C507EFF7F298F112BC0E`；后续若文件hash改变，应重跑矩阵，不能沿用此结论。

代表性可复现case：`phase=100ps, TOGGLE_DELAY_PS=800ps, skew_mode=97`。像素沿420000ps对应目标字`3e0`，每位输入在50–997ps内更新；原lane在460100ps（下一pixel沿后100ps）因toggle CDC / load流水时序读取实时输入`3e1`，目标`3e0`，随后字`01e`误替代`01f`。连续错误导致此case 66/99次load错字。pending候选在452100ps早一串行沿采得完整`3e0`，于原shift装载时刻460100ps把缓存字送入移位链；该case 0/99错字。逐拍文本见 `repro_baseline.log` 与 `repro_candidate.log`，相应VCD为 `delay_repro_baseline.vcd` 与 `delay_repro_candidate.vcd`。此case可证明注入模型下的失效条件和候选效果，不能证明真实芯片具有该延迟或本次实板花屏由此导致。

另用TB直接编译正式候选lane源（无源转换、无延迟注入）做四lane双复位测试：四路固定不同10-bit字共享pixel/serial/reset，检查每个serial沿四lane的 `S_load_en_2d` 一致、shift加载值等于该拍前的pending字，并在两次复位后检查pending/shift异步清零。结果 `epochs=2, pulses_first=20, pulses_after_restart=19, strobe_mismatches=0, loaded_word_mismatches=0, reset_clear_mismatches=0`。这验证四lane共同控制拍及两次复位后的恢复；字输出边界不变还由候选未改 `S_load_en_2d`、移位节拍、`S_oddr_data` 和ODDR接线的源差异审计支持。仿真stub不等价于器件原语/真实串行链路。

该延迟注入结果强化了“数据字可能在串行装载边沿附近被混采”的可测试机制，但实板根因仍需用户同条件A/B（必要时真实PHY/显示采样证据）。OSD固定黑底常数不会因元数据本身变绿；坐标未命中时仍传递输入RGB，故绿底和无声仍不能仅由本测试定因。未改PLL、SDC、引脚或失败OSD源；未做整机重建、上板或网络访问。
