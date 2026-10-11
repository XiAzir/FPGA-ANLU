# 最终构建复核

PASS（本地构建范围）；尚未板测，根因未确认。

综合源快照逐项 81/81 匹配；相对失败 video_probe，74 旧源不变，仅 top/status 两处改动与新增观察器，al_ip 保持相同。原 PLL、引脚、SDC、卡/图像/音频/按键生产模块不改。观察器三帧模型的源码、运行器、testbench 及实际视频链路源 hash 均与本候选匹配。

原约束最终 STA：SWNS 0.280 ns、STNS 0、HWNS 0.027 ns、HTNS 0，coverage 99.97%，Slow/Fast max/min 检查通过；初始 hold -0.008/-0.016 ns 的报告/DB/manifest 保存在 build/prehold，fix_hold 后上述结果通过。资源：{'lut': 17137, 'reg': 7978, 'le': 18435, 'bram9k': 19, 'dsp': 0, 'gclk': 2}。

最终数据库只读 write_verilog 导出，含 210879 行（仅跳过生成时间），与失败 probe 的 210257 行及归一 hash 有实际差异；新观察器前缀出现 2673 次。此次不重复 TLAST 单项修正的“最终网表无差分”情况。两份归一 hash 见 JSON，完整导出/TD日志同目录。该检查证明有实现差分与观察逻辑保留，不是整机功能等价或板级波形证明。

原四份冻结检查点合计598文件及四份 download 位流 hash 保持；成功基线仍 osd_phy_fix。STA 外部 I/O delay/加密IP边界与3个dummy node保留；原工具告警未升级为实物根因。输入统计按 VALID 周期计数，不以 READY 限定，不冒充被核接受的像素数。

下一步：状态页独立模型通过后生成候选位流；冷启动 SRAM 下载、保留原卡/接线，记录画面/声音/数字诊断。同条件恢复仅说明该实现改善，不证明旧故障唯一物理原因。
