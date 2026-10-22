# HDMI metadata prototype feasibility and corrected conclusion

时间：2026-10-22（北京时间）。阶段：独立raw-TMDS原型已完成；完整串行块对照已完成；内部加密core FIFO仅能作外部行为审计。

## 插入点与实验接口

加密wrapper输出三路并行10-bit TMDS data word与clock word。隔离fixture可在wrapper与PHY间插入原型：三路数据及clock共用8级pixel-clock延迟，packet parser标记并修改TERC4 raw packet位，在线重算BCH。复位clock填充值匹配真实core word `01F`。

## Raw-vector 实验结果

Icarus构造7,412字TMDS流，包括video-like/control字、AIF、有效ACR(N=6144/CTS=25000)、228个SP=1音频sample packet（B在第191包，此后同data-island连续发送），按预期等延迟逐字比较。AIF checksum PASS；PCM、视频/control/ACR不变；原 `hdmi_packet_monitor.v` 正控BCH/TERC=0/0，故意翻转单个TERC BCH parity位的负控检测到1。该向量使用合成channel-status位，验证按索引修改和P/BCH处理的机制。

## 结论修正

完整192帧串行测试从真实B0起点采集baseline core和patched输出。L/R状态字节分别为`04 80 10 02 0B` / `04 80 20 02 0B`，Fs48kHz、word length24bit均已正确；把C包含在P计算后，192帧parity错误0，patched状态与baseline逐位相等。原始C全零观察来自B起点之前的不完整启动片段。

Baseline AIF为HB `84 01 0A`、PB0/PB1/PB2=`70/01/00`，checksum有效，PB2取stream字段值。已有B后完整块与serial数据没有支持metadata为杂音根因，也未显示内部PCM/ACR时钟错配。真实core wrapper实现受`pragma protect`保护；当前可读代码提供输入端口/参数和外部采样/ACR发生逻辑，内核 FIFO/packet scheduler clock-enable没有展开。

原型保留在此目录供协议和后续A/B研究；生产候选不需要C字段或AIF metadata修改。没有TD实现、布局布线或板上运行。具体源路径审计、证据限制和后续线索见 `CORE_AUDIO_PATH_AUDIT.md`。
