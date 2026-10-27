# C42 100 MHz SDRAM gate 夹具

状态：夹具源码已准备，尚未编译或仿真。bench从C41完整gate层级启用合法App读写事务，pattern覆盖控制器接口写数据、读请求、真实 SDRAM pin 模型和生产 DATA_DELAY1 捕获输出；含命令、时序检查及单bit负控。

## 输入与边界

- 基线工程：`development/player_video41_refresh`；用户反馈 C41 已上板正常。
- C41 引用夹具：`development/video41_work/gate_refresh/`。
- 本夹具只消费根任务生成的 C42 完整 gate；gate 仿真副本只允许顶层模块重命名。reset、mem/shift clocks、加速启动节点和应用输入均由 bench simulation-only force 驱动，必须写入每次运行的 `source_binding.json`。
- `MemPeriodNs`/`ShiftDelayNs` 默认需由启动参数设为 10/4（100 MHz）或 20/8（50 MHz）；生产输入与输出仍经过综合网表 SDRAM controller 和物理 DQ 引脚。

## 模型可行性与来源

官方模型副本已放在本目录 `IS42s32200.v`，SHA256 `6AAD09C411B00E319EA6E7FF5A85453EB990532541AE368084406F78A276690B`。来源记录见 `development/system_verification_20261016/memory/controller_model_20261016_183434/source_receipt.json`：官方 APUG011 SDRAM 参考工程 `source_code/model/IS42s32200.v`。`eg_phy_sdram_model.v` 绑定器件实例并暴露时序参数。历史单控制器 gate harness 用同一模型读回 256 字、报告 mismatch=0；该证据不代表本 C42 完整 gate 已验证。

模型命令解码覆盖 ACT、READ、WRITE、PRE、AREF、MRS、BURST TERMINATE / NOP；含 DQM 字节屏蔽、突发访问和 CAS 数据输出。wrapper默认 tAC=5.4ns，按 EM638325 -7 表20设 tRAS=42ns、tRC/tRFC=63ns、tRCD/tRP=21ns、tRRD=14ns。模型 tDPL 阈值在runner编译时设为2个mem clocks，以覆盖tWR；MRS、AREF、ACT、PRE命令顺序，以及 tRFC/tRRD/tMRD由 pin checker 监视。tRC/tRCD/tRP/tRAS/tWR详细器件时序由原厂模型检查，runner会将原厂时序错误文本判为失败。

模型默认每 bank 建立 524289 个 32-bit `reg`，约 64 MiB/实例。保持官方容量最稳妥，根任务逐轮限制同时运行的模拟器进程。若要缩小容量，需先证明 gate 测试地址到 BA/row/column 的映射未越界。仿真启动加速只跳过生产 200ms power counter，不可跳过实际 MRS/AREF/ACT 或读返回过程。

## 要求的检查与数据事务

监视器直接在 `EG_PHY_SDRAM_2M_32` 引脚的 `posedge clk` 解码，至少留存命令 CSV、周期和时间戳，并对 unknown command/address/DQ 立即 `$fatal`。

| 项目 | 检查 |
| --- | --- |
| 初始化 | power-up 后确认 PRECHARGE ALL、MRS 和至少 2 次 AREF 在 init_done 前完成。AREF 可位于 MRS 前或后；记录 MRS 地址中的 BL、CAS latency、burst type。 |
| 命令 | AREF、ACT、READ、WRITE、PRE 的周期/BA/地址；每 bank row open 状态、非法 row 转换、未开行访问和重复开启均失败。 |
| 时序 | 以实际 pin clock 计算 tRC、tRCD、tRP、tRAS、tWR、tRFC；逐项使用所选 SiP 数据手册的 min 值配置，拒绝用历史 IS42 参数代替已确认器件参数。 |
| 数据 | App写入端驱动非恒定、可寻址 pattern；官方功能模型在真实 SDRAM DQ 上完成存取。按 App 写地址建立期望字典，对 controller raw 返回数据和生产 `DATA_DELAY1` 捕获数据逐字比较，任何 X/Z 都失败。读回成功要求数据经过真实命令/DQ/控制器返回链。 |
| 覆盖 | 多地址连续突发；超过256字的长度覆盖列边界、跨行/跨bank；production MRS现场确认BL4、BL8或full-page 256；等待写后读验证。 |

当前生产端 `App_wr_dm` 是常量 `4'b0000`，综合网表会折叠掩码输入；此轮 production gate 仅验证全字写入。官方器件模型代码包含 DQM 字节屏蔽行为，但本 runner未将它算入 full-gate 验证覆盖。

## 负控

`-InjectReadBitError`在simulation-only测试钩子中翻转首个生产捕获字的一位；runner要求此负控以预期scoreboard mismatch退出。该项只验证scoreboard告警灵敏度，不覆盖DQ物理线路故障模型。

`-CaptureMode`诊断可选 `0` raw current、`1` raw previous、`2` production capture（按当前 gate 的真实 DATA_DELAY 参数观察）。每个模式都统计 raw-current、raw-previous 和 production capture 匹配数；只对选中的模式作严格逐字 PASS。默认 mode 2。将 phase 4 ns 与 phase 9 ns 分别运行，比较数据证据；此诊断不强制或修正常规返回路径。

## 运行接口

仅根任务执行。C42普通gate入口：

```powershell
pwsh -File development/video42_work/memory_bench/run_memory_gate.ps1 `
  -Case C42 `
  -GateFile development/player_video42_sdram100/build/manual/AC201_tf_hdmi_gate.v `
  -ExpectedSha256 262d53fb0dd5bfd30e048d53387545b9667aa14a85d33be1898bbf89d1613619 `
  -MemPeriodNs 10 -ShiftDelayNs 4 -Traffic 1 -BurstWords 256 -RunSimulation
```

C41完整gate基线可用相同夹具，周期为20/8ns：

```powershell
pwsh -File development/video42_work/memory_bench/run_memory_gate.ps1 `
  -Case C41 `
  -GateFile development/player_video41_refresh/verification/final_routed.v `
  -ExpectedSha256 a8ccaa65b235e18caa20b037ba24630b0773bd33b7f2c9c22f280255a8418fe3 `
  -MemPeriodNs 20 -ShiftDelayNs 8 -Traffic 1 -BurstWords 256 -RoutedNetlist -RunSimulation
```

单bit负控在任一正常命令增加 `-InjectReadBitError`。phase诊断命令分别增加 `-CaptureMode 0`、`-CaptureMode 1` 或 `-CaptureMode 2`，并将 `-ShiftDelayNs 4` 改为 `-ShiftDelayNs 9`重复运行。runner校验SHA，只重命名gate仿真副本顶层，隔离运行目录并保存绑定manifest、模型hash、日志和pin命令计数。路由gate更新后需同步更新输入SHA。省略 `-RunSimulation` 仅准备副本；本次未启动综合或仿真工具。

C41 若需诊断 init_done 提前而继续读写 scoreboard，可在常规命令后增加 `-DiagnoseMissingInitAref`。该模式将输出 `INIT_AREF_MISSING`，继续收集数据结果，并在 `result.json` 分列 `init_status=FAIL`、`data_status=PASS/FAIL`、`overall_pass=false`；正常严格模式仍在缺少初始 AREF 时停止。运行目录另保存前1us原始初始化pin trace、首8次WRITE/READ实际DQ beat及模型行列状态到 `init_pin_trace.csv` 和 `sdram_pin_trace.csv`，以及首16组APP事务与`app_wr_addr_1d..4d`/`app_wr_din_6d`到`app_pipeline_trace.csv`。

## 当前缺项

- C42初版gate SHA256为`262d53fb0dd5bfd30e048d53387545b9667aa14a85d33be1898bbf89d1613619`。C42启动等待使用 public `u_legacy_frame_backend/Sdr_init_done`；C41普通gate使用控制器内部 init_done，C41 routed gate使用 public init_done alias。C42当前DATA_DELAY0生产capture映射至controller raw output，C41 DATA_DELAY1映射至`read_capture_data`。新gate生成后必须静态核对实际信号路径与源SHA。
- 器件参数来自 EM638325 Rev.3.2 表16（项目摘录`video42_work/em638325_timing_page20.txt`）；速度等级采用最慢-7值，需在仿真manifest中保留这些值。
- actual MRS burst length由pin checker输出/报告；traffic命令需指定256-word burst。DQM部分写不在production gate覆盖内。自写checker目前只审初始化、命令有效性、tRFC/tRRD/tMRD；其余时序由原厂模型承担，未提供自写 tWR checker 单元负控。
- 夹具源码尚未编译或执行；根任务应串行运行C41 50MHz基线和C42 100MHz候选，根据日志反馈修复编译/层级问题。
