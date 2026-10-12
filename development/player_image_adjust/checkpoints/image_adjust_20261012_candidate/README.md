# T22 亮度与对比度候选 C11201

基于 C11109 实板通过版本建立隔离工程；尚未上板。

- 640×480；B=-64..+64，步长16；C=0.50/0.75/1.00/1.25/1.50；默认 B+00 C1.00逐像素恒等。
- 每通道 clip(floor((pixel-128)*C)+128+B,0,255)，仅底图；原OSD、RUN与滚动字幕保持原色。
- KEY0长按约1.5秒循环PLAY/BRI/CON；编辑时KEY0短按减、KEY1短按加，端点停住；双键长按恢复PLAY/default。
- PLAY短KEY0切图，短KEY1开关轮播，长KEY1切音源（长按不再顺带改变AUTO）；短动作在释放后生效。编辑模式音乐/轮播继续，长KEY1不切音源。
- 参数VS上升沿统一提交；参数栏位于左上第二行，显示模式/B偏移/C倍数。
- 保留原音频FIFO、FAT、SDRAM、HDMI核/PHY与原约束；仅修改控制、底图运算、参数文字、构建ID与工程登记。

本地模型/正式综合/布局布线/原约束时序/位流通过，尚未上板。最终 SWNS +0.576ns / HWNS +0.011ns，STNS/HTNS=0，coverage99.96%；12944 LUT/8151 reg/14388 LE/23 BRAM9K/0 DSP/2 GCLK。未执行fix_hold。模型与边界见build/model/README.md。

版本 C11201，数码管D页DFC11201。播放模式极快连点忙时合并到1位pending；正常点按逐次生效。

位流SHA256: 5482E8E2D2AE912E47D9EA21F93892559F39AF77C907D025EBDA46AE9994C2FAPROGRAM_SRAM；不写TF/Flash。回退 download/pcm_bram_candidate.bit。
