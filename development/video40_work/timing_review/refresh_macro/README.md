# SDRAM refresh macro audit

日期：2026-10-27（Asia/Shanghai）。只读检查 C32/C40 源、已存在的 C32/C40 gate Verilog 与 C32 final timing report；工程RTL、global_def、TD项目和构建输入保持原状；本轮未运行TD。

## 源与哈希绑定

- C32 文件：`development/player_video32_read_return/src/user_source/hdl_source/include/global_def.v` 与 `.../sdr_init_ref.enc.v`。
- C40 文件：`development/player_video40_spi25/src/user_source/hdl_source/include/global_def.v` 与 `.../sdr_init_ref.enc.v`。
- C32 final binding 与 C40 source audit/build_source_scope 现有 JSON 记录的源文件SHA256一致：`global_def.v = DA6A16AC7E3B8D3415F45B9F18847D8E6170C7F9EB6E192C417F730977072583`；`sdr_init_ref.enc.v = 6DA5945F4AF793610D0D64C65C7E5D2D1C86ED4C11BC5FDEACD27EB03178B9F6`。
- 保存的 C32/C40 `sdr_init_ref.enc.v` 公开前缀使用逐字节提取，遇首个 `` `pragma protect begin_protected `` 行立即停止；prefix文件不含marker与后续内容。两版公开前缀各3298字节，SHA256均为 `DD819265959E21AA700C29B7344DC9531466A9CC51D58EECFE655ABB30A926E1`；原始副本保存在同目录 `sdr_init_ref_public_prefix_C32.v` 与 `sdr_init_ref_public_prefix_C40.v`。这些文件只覆盖保护开始前完整公开的逻辑；受保护控制器实现未纳入此模型。
- `global_def_raw.v` 是 C40 原始公开头文件字节副本，SHA256与现有source binding相符；`global_def_fixA...` 和 `fixB...` 是仅供分析的括号方案副本，未写回C32/C40。

## 宏展开与公开逻辑

原始定义：

```verilog
`define SDR_CLK_PERIOD 1000000000/50000000
`define SELF_REFRESH_INTERVAL 64000000/`SDR_CLK_PERIOD/2**(`ROW_WIDTH)
```

Verilog预处理将第二行文本替换成 `64000000/1000000000/50000000/2**11`。整数除法左结合，`64000000/1000000000`先得0，故 `SELF_REFRESH_INTERVAL`实际为0。独立Icarus宏微夹具及根提供的运行结果为：`SDR_CLK_PERIOD=20`、`SELF_REFRESH_INTERVAL_EXPANDED=0`、显式括号目标`64000000/(SDR_CLK_PERIOD)/2**ROW_WIDTH=1562`。该括号目标用于对照修正方案；生产源码宏的实际展开仍为0。

两个不改原文件的可行括号表达式均能保留period宏数值20并令该公式得到1562：

- A：`` `define SDR_CLK_PERIOD (1000000000/50000000) ``；
- B：`` `define SELF_REFRESH_INTERVAL 64000000/(`SDR_CLK_PERIOD)/2**(`ROW_WIDTH) ``。

在公开 `sdr_init_ref` 前缀中，14位 `init_cnt` 复位/未完成时清零；完成后若 `init_cnt==SELF_REFRESH_INTERVAL` 则归零，否则递增。周期请求条件是 `init_cnt==(SELF_REFRESH_INTERVAL-10) && !Sdr_ref_ack`。原始宏为0时，计数比较`init_cnt==0`会让已复位计数停在0；请求比较目标为0-10，转换至与无符号14位计数器比较后无可达匹配值，因此该初始化条件下公开逻辑给出周期`ref_req`脉冲为0。括号修复后目标周期为1562，计数正常递增/回绕，请求比较值为1552；在隔离初始化完成信号后可得到周期性单拍请求（首个请求约在第1553个计数上升沿、后续间隔1563周期）。根先前宏微夹具输出由其Icarus运行提供。本轮使用公开前缀fixture对raw/fixA/fixB三种宏版本实际运行Icarus：raw在5000周期内0脉冲；fixA和fixB各在cycle 1553、3116、4679出现3个单拍脉冲；三例TB均PASS。运行日志为`prefix_raw.log`、`prefix_fixA.log`、`prefix_fixB.log`。

已保留测试工件：

- `../tb_sdram_macros.v`：输出原宏和括号目标。
- `tb_prefix_refresh_req.v`：force公开模块前缀的 `init_done`，观察5000周期`Sdr_ref_req`，仅用于公开前缀小模型。
- `raw/`、`fixA/`、`fixB/`：各含原始公开逻辑前缀、配套宏副本与可供本地Icarus编译的include布局。`*_prefix_fixture.v`末尾只追加 `endmodule` 以闭合抽取前缀。

## 现有gate implementation核查

C32和C40均有匹配源哈希的 `build/manual/build_source_scope.json`，且已存在的 `AC201_tf_hdmi_gate.v` 有如下证据。Gate文件SHA256：C32 `902707A297D7DFBF9C31CE603A01B916F9497A38316E01075C01E7A68828BDF9`；C40 `200C8DE5910970B96EA29A9913075BA96D07BCBEE1B398B541103332E4F301D6`。

- C32（gate Verilog行107914–107915）：缓冲网 `u_frame_buffer/u_sdram/u2_ram/u2_wrrd/Sdr_ref_req`的输入硬连`1'b0`，再转发到`Sdr_ref_req_syn_4`。
- C40（gate Verilog行108042–108043）：相同信号同样硬连`1'b0`，再转发到`Sdr_ref_req_syn_4`。
- 请求消费者仍存在：C32 `Sdr_ref_req_syn_4`用于`u2_wrrd`逻辑（行112171、112208）；C40对应行112299、112336。保留网名本身说明该观察点仍可追踪；其`1'b0` buffer显示当前gate阶段的上游周期请求已常量化。
- `sdram.v`同版本实例参数`self_refresh_open(1'b1)`，而`App_ref_req`常量接地`1'b0`。公开源中 `Sdr_ref_req=ref_req|App_ref_req`，因此该周期源被优化为0后，送入刷新调度的请求被清零。
- 两份gate V都没有 `u1_init_ref/init_cnt` 或 `u1_init_ref/ref_req`的保留节点；`sdr_init_cnt`（init pipeline）仍保留。结合Sdr_ref_req常量网，这是refresh interval计数/周期请求逻辑被综合消除的证据。

证据层级：C32有gate网表与 `src/td_project/final_timing.rpt`；根随后报告C40最终route已完成，并从真实PR DB导出 `verification/final_routed.v`。本审查用两版gate网表确认常量化；没有独立分析C40 routed implementation。两个gate网表都证明综合阶段的请求网为0。现有两个候选gate网表的周期刷新请求输入均为0。实物温升、刷新失效、画面异常或数据损坏仍需单独测试确认，静态网表尚未建立现场因果。

## 后续修复隔离

先建立单独SDRAM refresh修复候选，将括号修正与TF25/C40整机变化隔离。修复后确认source hash、宏测试、公开prefix/器件模型刷新请求周期、gate网表不再常量化，并检查实际器件所需刷新间隔（源公式1562是软件公式结果，还需以具体 SDRAM 型号/数据手册核对单位和命令次数）。再单独做最终路由/实板观察。当前新增内容仅为报告和测试夹具，C32/C40生产源保持原状。

## 检查流程说明

本次早期文件预览曾越过首个保护marker并显示少量原始保护区字节文本；未做解密、解码或分析。发现后立即停止读取保护区，后续前缀提取逐字节于marker处终止。保护区内容未复制进本目录，也未用于任何结论。
