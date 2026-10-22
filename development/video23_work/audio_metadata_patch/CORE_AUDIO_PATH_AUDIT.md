# HDMI audio metadata experiment and source-path audit

时间：2026-10-22（北京时间）。结论：metadata差异假设已由完整块证据修正；原型保留为隔离诊断实验，不进入生产工程。

## 完整 channel-status 块复核

audio_post_pcm23 的串行夹具从真实B0起点抓取了192个audio sample packet，并另加只读 baseline-core tap 对照原始wrapper输出。baseline与候选输出逐bit一致：左声道channel-status前5字节`04 80 10 02 0B`，右声道`04 80 20 02 0B`；按IEC channel-status字节定义，Fs=48kHz、word length=24bit。将P校验纳入V/U/C后，192帧 parity错误0。启动片段中B标志前的191个子帧没有构成一个完整192帧状态块，原来观察到的C全零不代表稳态字段。

同一测试终结于`PATCHED_PIN_PASS`：音频样本1611/1611且PCM mismatch=0，SP1=1611，ACR N=6144/CTS=25000，BCH/TERC=0，RGB 307200像素mismatch=0，四路延迟检查840018项错误0。早期错误结果和clock bypass消融保存在 `../audio_analysis/metadata_patched_pin_sim/tone_run.log` 与该目录原始输入/输出CSV；后续正确的baseline比较结果保存在同一runner的最终日志。

原Audio InfoFrame PB0=`70`、PB1=`01`、PB2=`00`，包含HB在内PB0校验和为零。PB2的零编码沿HDMI audio stream字段提供未指定值；B后IEC状态块已明确48kHz/24bit。AIF与ACR/PCM的早期字段看起来不同，现有完整块/串行证据没有支持将其归因为音频杂音。

## 可见源代码路径核查

C25生产候选保持使用像素域输入：`top_tf_hdmi_audio.v` 将 `video_clk` 接到 HDMI wrapper 的 `I_pixel_clk` 和 `player_audio_probe.pixel_clk`，并将 `audio_valid/left/right` 及同域生成的 `acr_valid/cts/n`接入wrapper；参数为`AUDIO_SAMPLE_RATE="48K"`。本地 `video_pll.v` 生成25MHz pixel clock，音频probe/bridge也按PIXEL_HZ=25MHz、SAMPLE_HZ=48kHz工作。

可读的 WAV FIFO 路径在 `tf_wav_file_player.v` 的 `sd_card_clk` 域；`wav_pcm_bridge.v` 把 sample request/ack toggle 经两级同步跨到像素域，16-bit mailbox在ack协议下稳定，消费 FIFO 的`sample_take`也由sd域时序生成。音频 valid 由25MHz accumulator生成，脉冲间隔为520/521像素周期；ACR每48个有效音频样本排一次，N=6144。此路径没有暴露可见的无同步多bit FIFO读写或混用采样时钟线索。

HDMI transmitter wrapper有`AUDIO_SAMPLE_RATE`和音频/ACR端口的可读声明，但包内实现由`pragma protect`加密；FIFO、packet scheduler及其内部RAM时钟/使能的具体net在当前可读源中没有展开。相同wrapper文件在C25生产源与官方TF WAV例程SHA256一致（`867E0B0B...776596A63`）。

外部可观测证据：真实core和PHY串行恢复后，ordered PCM与输入向量相符，BCH/TERC错误0，ACR为N=6144、CTS=25000，完整RGB解码通过；baseline IEC channel status正确。这些观察没有显示PCM FIFO、ACR时钟或channel-status字段的数字链路故障。内核FIFO的内部实现保持未观测，因此现有材料只能支持外部接口和输出行为判断。

## 原型用途

`hdmi_audio_metadata_patch.v` 和 `tb_audio_metadata_patch.v` 保留强制InfoFrame显式设置及强制C字段目标的 raw-vector 实验，`run_raw_tb.ps1` / `raw_run.log` 为复跑材料。它证明TERC4位域和BCH的最小改写、8像素时钟等量延迟、透明比较及负控检测；测试向量采用合成channel status，结果代表试验路径。真实core完整B后块已验证正确，故C字段生产patch冗余，AIF的PB2=00使用stream值也满足当前完整块证据。此原型只作后续A/B和格式研究，不合入C19~25，也没有TD构建或板卡操作。
