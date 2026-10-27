# C42 phase8 最终审计

范围：只读审查 `development/player_video42_sdram100` 的 phase8 最终 routed 报告、exception/check report、final routed Verilog / QoR、bitstream stage 记录和基于 final routed netlist 的 gate/model 记录。未运行 TD、仿真或板测；本审查只写入本目录的 phase8 audit 文件。

## 结论

在报告约束和模型假设下，phase8 候选具备离线产物条件：路由后 setup/hold 均无违例，32 条 DQ MCP setup/hold 均有效，基于 final routed netlist 的 SDRAM 初始化和数据 scoreboard 通过，bitstream stage 成功。当前证据不支持板上功能 PASS：实际 EM638325 速度档、PCB DQ/CLK skew 与板上验证仍待确认。离线交付应继续标为 board pending，并保留 `check_timing` 的中等等级外部 I/O 约束提示。

## PLL 与 DQ 返回路径

`sys_pll.v` / `.ipc` 为 `CLKC2_DIV=10, CLKC2_CPHASE=7, CLKC2_FPHASE=0`，标称 100 MHz、288°；routed timing clock summary 读数为 `ext_mem_clk_sft` rise 8ns、fall 3ns、period 10ns。

`AC201_tf_hdmi_exception.timing` 中 setup MCP 显示 32 paths / 32 endpoints，Dominated=32、Shadowed=0、Ignored=0。Max setup 为 `sdram.dq[0] -> sdram_syn_1.bpad`，source rise@8ns、capture rise@20ns、budget 12ns、slack +1.572ns。Min hold 为 `sdram.dq[23] -> sdram_syn_18.bpad`，source rise@8ns、capture rise@10ns、budget -2ns、slack +2.392ns；按 10ns 周期平移，对应下一 word source rise@18ns 对 capture rise@20ns。该配对保留相邻 word 的 hold 检查。

`AC201_tf_hdmi_chk.timing` 列出 DQ[0:31] 共 32 个 abnormal `set_input_delay` 目标，每个 DQ 使用 hard-IP reference pin `u_frame_buffer/u_sdram/sdram.clk` 和 `ext_mem_clk_sft`，max=5ns、min=1ns。它们实际进入 MCP 的硬 IP DQ arrival 路径：setup 使用 max 5ns，hold 使用 min 1ns。TD MCP report 的统计为32 paths；check report 的 MCP/SMD max table显示64 checks，shadowed/ignored均为0。异常标记属于检查结果的一部分，具体约束来源未从项目 timing.sdc 追溯。

EM638325 Rev3.2 表16给出 tAC(max)=5ns（-5）、5.4ns（-6/-7），tOH(min)=2ns（-5）、2.5ns（-6/-7）。check_timing 列出的 5ns max / 1ns min input delay 实际进入 MCP path 计算。按器件模型本次实际 tAC=5.4ns 对 STA max 5ns 作0.4ns保守折减，DQ setup约 +1.172ns；min delay=1ns 比各档 tOH(min) 更早，STA hold 检查更保守。实际颗粒速度档尚未通过料号确认，PCB skew 尚未建模。

## SDRAM 输出与全局时序

常规 path group `ext_mem_clk -> ext_mem_clk_sft` 覆盖48 endpoints。最差 SDRAM DQ output setup为 `sdr_t_reg -> SDRAM DQ`，slack +2.011ns；输出组最差 hold 为 `sdram_syn_8.osclk -> SDRAM CAS_N`，slack +1.780ns。其 hard-IP 输出 max/min 延迟为-5ns/-1ns；此组检查包括DQ和命令输出，最差 hold 端点是CAS_N。

最终 routed timing status：setup SWNS +0.285ns、STNS 0；hold HWNS +0.037ns、HTNS 0；0 setup/hold violation。`final_route.qor` 对应 Setup WNS/TNS=+285/0ps、Hold WNS/TNS=+37/0ps、违例端点0；STA coverage 99.99%。该全局 hold 裕量较小但为正，保持边界为本候选最敏感的内部路径余量。

`check_timing` 另报告4个顶层输入无 input delay（key1/key2/rst_n/sd_miso）、14个顶层输出无 output delay（HDMI、SPI、LED、seg7），以及32个内部 DQ abnormal input delay。它们不构成此次 SDRAM MCP 的未覆盖证据，但系统级外部接口时序仍需按板级约束确认，不能以此报告声称 HDMI/SPI 板级时序闭合。

## Gate / 模型证据

`memory_bench/run_C42_20261027_221527/result.json` 记录 init/data/overall PASS、model timing error=0。run log：初始化 PREALL=1、MRS=1、两次 AREF 后 init pass；production raw capture (`DATA_DELAY=0`) 的读回 scoreboard 写460、读460、返回460匹配；115个写burst及115个读burst，运行期间AREF请求/ACK/命令各3次，SDRAM pin checker共见 MRS=1、AREF=5、ACT=230、READ=115、WRITE=115、PRE=1。夹具没有执行 corruption negative control。

此行为模型来自 APUG011 官方 IS42s32200 模型，并以 EM638325 -7 档时序值配置。本次实例参数由 `eg_phy_sdram_model.v` 显式设置为 `T_AC=5.4ns`、`T_OH=2.5ns`，并传入 `.tAC(T_AC)` / `.tOH(T_OH)`；实际颗粒完整料号/速度档尚待确认。simulation gate copy 仅模块重命名后验证，来源 SHA 与 `verification/final_routed.v` 对应；运行未使用 SDF，属于无SDF功能级时序验证，routed cell/net delay仍以STA为准。该模型为 STA 边界提供额外功能佐证，后续还需实际颗粒和板级验证。

补充控制运行：`run_C42_20261027_222536` 注入首个读样本单 bit 翻转，记录原值/翻转值并触发 767/768 生产 capture scoreboard mismatch；result 标记 `negative_control_detected=true`、`single_sample_corruption_verified=true`，因此该次预期以数据检查失败结束。`run_C42_20261027_222654` 选择 previous-data capture 对照，raw current=768、raw previous=0、production capture=768，日志触发 `strict raw-previous scoreboard mismatch`；result 为该替代模式 data FAIL。两组运行均绑定同一 final routed gate SHA，覆盖结论限定为控制识别/拍对齐。

## 预测对照与交付判断

| 指标 | phase9 routed | phase8 先验估计 | phase8 最终 routed | 差异 |
|---|---:|---:|---:|---:|
| DQ MCP read setup | +0.572ns | +1.572ns | +1.572ns | 命中 |
| DQ MCP read hold | +3.392ns | +2.392ns | +2.392ns | 命中 |
| SDRAM DQ output setup | +3.011ns | 约+2.011ns | +2.011ns | 命中；早前+2.999为一阶粗估 |
| SDRAM output-group hold | +0.780ns | 相位平移约+1ns | +1.780ns | 命中一阶趋势 |

在已有产物范围内，没有发现阻止 phase8 **离线**交付的 setup、hold、MCP覆盖或 gate scoreboard 失败。bitstream stage status=success，routeStage=hold；最终 bit SHA256 已在 JSON 中记录。交付说明须将候选标为离线验证、板测待验。实际 EM638325 速度档和 PCB skew 未定，顶层 HDMI/SPI 延迟也未约束；这些缺口阻止“板上功能通过/板级 STA 闭合”的表述，要求后续实板使用、速度档确认和 board timing characterization。

## 证据 SHA256

- `verification/final_routed.v`: `437D44141607624E94AD9D04BEA60F8ECA6EEC0D2D034D92573C8EEC0230097C`
- `verification/final_route.qor`: `4B849B36259F98CCFCA00800A9A50332C56973F05D5B159776583E3E2CD0456F`
- `build/manual/AC201_tf_hdmi_pr.timing`: `E646D7D9FE680D3BE545AA2D1BB6C0A02036A89D2B426ADD0F6C078FB9EBE2FD`
- `build/manual/AC201_tf_hdmi_exception.timing`: `36F9C6D88B83F9B3706504FBD70F51468ABD5FED5361731BFEC1982362D903A4`
- `build/manual/AC201_tf_hdmi_chk.timing`: `B22C05716BFDEFDB43BF1A81AED68B9B680E33EE100D7FB246388768BECF791C`
- `verification/source_audit.json`: `64617D1B88FCA81D371EC83CB6830AE4E5D98DEE129F2EF7154211BDE20D4C99`
- `build/manual/AC201_player_video42_sdram100.bit`: `BF8E700B9A046576B0CEEC99A37085137E31BA0EF6FEE44E3401905A76BA6059`
- strict gate source `run_C42_20261027_221527/source_binding.json` bound `verification/final_routed.v` SHA256 `437D44141607624E94AD9D04BEA60F8ECA6EEC0D2D034D92573C8EEC0230097C`.
