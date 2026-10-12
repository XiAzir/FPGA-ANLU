# C11109 同步 BRAM 音频 FIFO 候选

当前为隔离候选，实板未验证，不能作为成功基线。成功回退仍是 `E:/VSCODE-project/FPGA-ANLU/download/osd_phy_fix.bit`。

父工程 C11108 实板无信号；固定音乐窗口的组样本写入 CRC=F485、FIFO 消费及 HDMI 核输入 CRC=D2D6，三段完成。用户同条件回载基线后图片、WAV、内部音阶均恢复。此证据把音频调查优先级指向 FIFO 读写/头预取/消费边界，尚未证明探针无误、唯一根因或无信号机制。

本候选仅改 `tf_wav_file_player.v` 的样本存储实现：独立同步 RAM 读写口、读寄存器不复位、同地址读写时选择已寄存的新样本旁路。指针、计数、预取控制、样本有效握手不改。top 与状态模块仅将标识改为 C11109。其他用户源、SDC、PLL、PHY、HDMI 配置保持父工程内容。

TD 综合网表已确认：四个 EG_PHY_BRAM，DP8K、每块 2048×4，共 2048×16 样本；整工程 BRAM9K 19→23。综合总 LUT 11824，寄存器 7818；最终资源与时序以交付 info 和物理报告为准。

构建入口 `scripts/build_candidate.ps1 -Stage synthesis|physical|hold|bitstream`。每阶段绑定源文件/脚本/数据库/报告哈希，原约束 setup 或 hold 有负裕量则拒绝生成位流。模型与报告在 `build/model`、`build/manual`；交付脚本在 `build/package_delivery.py`。

诊断与 C11108 相同：每段独立跳过 65536 次真实样本事件，再对 32768 个样本冻结 CRC16。原天之弱 TEST.WAV 应为 6700F485/7700F485/8700F485、97000000、A7008000、B702002D、C700002C；版本页 DFC11109。先保持默认 WAV 至少 10 秒，再录全部页面；采集完成后长按 KEY1 切内部音阶，冻结 CRC 不变。

CRC16 可碰撞，覆盖只到 HDMI 核输入。RTL 模型未覆盖加密 HDMI 核与实际物理输出；器件 BRAM 同地址碰撞由显式旁路规避。布局变化可能影响实板表现。TF 文件不用改，不写 Flash，板卡在远控实验室电脑，由用户下载。

详细反馈与阶段记录：`E:/QQ CACHE/Download/安路资料/开发记录/专题记录/OSD状态显示/PCM校验FIFO分歧与无信号_20261011/README.md`。


2026-10-12 09:57:30状态更新：用户报告图像/KEY0/KEY1轮播/WAV/tone正常，两视频确认三CRC=F485/flags7/DFC11109。live info为PASS_REPORTED_FUNCTIONS_AND_PCM_WINDOW，新verified checkpoint=pcm_bram_20261012_verified。当前可用作成功开发基线，原candidate/ZIP保留PENDING历史。根因唯一物理机制未确认，长期/整曲/碎片未验证。
