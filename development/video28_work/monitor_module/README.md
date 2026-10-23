# C28 被动 HDMI 运行观测模块

模块：`player_hdmi_runtime_probe.v`。此目录只包含模块、Icarus testbench、编译/仿真日志；生产候选源、复位/时钟/控制逻辑没有改动。

## 接口和页面

输入：`pixel_clk`（25 MHz）、`serial_clk`（125 MHz）、`cold_rst`、`media_rst`、`locked`、AXIS `ready/valid/user`、`hs/vs/de`、`serial_clock_out`（名称沿用；C28 实接 HDMI clock lane 的 ODDR 正边沿输入 `S_oddr_data[1]`，不接专用 PAD 端点）、`tmds_clock_word[9:0]`（父 top 提供真实 core 时钟字）。输出仅有 `page_e/page_f` 两个诊断页。

`page_e = {4'hE,locked,lock_seen,lock_lost,axis_ready,sof_count[7:0],last_frame_lines[9:0],axis_user,axis_valid,hs,vs,ready_wait_seen,de_seen}`。SOF由`user&&valid`的上升事件计数；`last_frame_lines`在下一次SOF锁存上一帧行数，SOF当拍置当前行数为1；行数通过`valid`上升沿累计。`lock_seen/lock_lost/ready_wait_seen/de_seen/sof_count`由冷复位清零；行数及valid/SOF边沿历史由媒体复位清零。媒体复位期间同步跟踪locked，避免复位造成的假lock_lost。

`page_f = {4'hF,tmds_clock_word[9:0],clock_edge_delta[9:0],8'd0}`。serial域在125 MHz采样反馈信号并计数变化，Gray计数器经pixel域两级同步；pixel域以7位内部`window_timer`每128拍计算一次模1024增量。F页末8位固定为0，避免数码管显示快速变化值。名义25 MHz反馈下窗口期5.12 µs、期望256个边沿，现场容差建议±2。页面整体由pixel域形成；F页十位TMDS值由父top同域接入。启动后的前两个窗口仅作内部warmup，约10.24 µs，无需读取epoch。

## 验证

Icarus `-g2012 -Wall` 编译通过，`vvp`输出：

```text
HDMI_PROBE_PASS sof=2 lines_checked=480 lines_after_reset=0 lock_seen=1 lock_lost=1 ready_wait=1 de_seen=1 delta=256 timer=111 tail=00 tmds=2d5
COLD_RESET_PASS sticky=0 sof=0 lines=0 delta=0 window=0
```

TB覆盖连续serial输出活动、停`serial_clock_out`和停`serial_clk`两种负控（delta归零）、两种恢复（delta回到254..258）、AXIS ready等待sticky、DE sticky、两帧SOF与480行前帧锁存、媒体复位清行统计且不误报锁丢失、真实锁丢失置sticky、冷复位清除计数及sticky。

编译日志：`compile.log`；运行日志：`run.log`；TB：`tb_player_hdmi_runtime_probe.v`。首两个窗口建议不用于现场判读。Gray计数跨域经过2FF，窗口值按模差计算；窗口边界附近有同步延迟，读数以稳定连续窗口为准。反馈变化若快于serial_clk采样能力会漏计，当前频率比为5:1。模块不作恢复或控制动作。

## C28 PHY 实连接矩阵

`tb_phy_probe_matrix.sv` 使用C28 lane/wrapper、真实vendor EG4 ODDR functional library和原`hdmi_serial_receiver`。矩阵覆盖8种pixel/serial相位×8种reset release偏移、每组3个启动epoch，另保留3组串行pin随机翻转负控。矩阵顶层`CLOCK_WORD`参数分别取`10'h3e0`和`10'h01f`；同一raw测试夹具值贯穿PHY时钟lane输入、receiver判相和probe的TMDS raw字段。每个epoch发送450个pixel word（约18 µs，超过3个128-pixel计数窗口）；每组检查F页时钟字段原样返回该夹具值、`clock_edge_delta`为254..258、低8位为00，并以原receiver逐字比对三个随机数据通道且检查clock character/锁定。

ModelSim结果：`0x3e0`与`0x01f`两组分别有192个正常相位/复位case和3个pin翻转负控通过；每组195个case的`Fdelta`均为256。正常case receiver收到443..444个symbol、`errors=0`；每个负控检出1次数据偏差。日志分别保存在`run_3e0.log`和`run_01f.log`，编译诊断在`compile.log`。此实验验证的是ODDR输入侧观测点与原serializer输出序列的仿真行为；板端引脚、电气信号完整性和显示器识别仍需实测。

运行：`run_phy_probe_matrix.ps1`。它从C28候选源目录直接编译PHY、probe与原receiver，再编译该matrix，使用本机ModelSim SE-64 10.1c与TD预编译EG4 ODDR库；不启动整机仿真或TD。summary记录了runner所用全部源文件SHA；probe候选SHA为`7773B067D60DA672C9A07E56554F04F032D73D70D0F748886CDA291A83959B28`。

## 最小板测读数

状态页按每页约1秒轮换；page 5仍是原SD诊断副本，HDMI probe在E/F页。E页稳定视频时应见bit27 `locked=1`、bit26 `lock_seen=1`、bit25 `lock_lost=0`、SOF计数持续增加；收到下一帧SOF后`last_frame_lines[15:6]=480`。bit24为当前AXIS ready，低6位为`user/valid/hs/vs/ready_wait_seen/de_seen`。F页`[27:18]`直接、原样显示core的10-bit `tmds_clk_data`，`[17:8]`经稳定窗口应为256（可容差254..258），末8位固定00。C28使用实际core时该raw值由core提供；矩阵中的`0x3e0/0x01f`仅为两种raw测试夹具，因此不要按某个固定F页整值判定板测。前两个窗口只作10.24 µs启动warmup。
