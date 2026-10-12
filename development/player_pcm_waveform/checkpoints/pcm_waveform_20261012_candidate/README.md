# T23 真实PCM波形候选 C11202

基于已通过的C11201 image_adjust工程133文件verified快照建立隔离工程，尚未上板。

被动观察与HDMI核相同的audio_valid/audio_left_data，不回压或修改音频。128个bin×8真实样本=1024事件窗，48kHz名义下21.333ms；每bin保留极值并横向复制4像素。双bank完整窗VS上升切换，capture等待帧边界期间丢弃观察事件，不是音频播放丢样。

底部panel x16..623/y320..423、graph x64..575/center384，青色波形/灰中心线，标题PCM WAV/TONE X4；固定幅度可视增益，floor(PCM16/256)裁剪±28。静音窗平线；音源切换清旧窗，超过100ms无有效音频请求下一VS清旧图。保留原RUN/滚动字幕及亮度/对比度/按键。无需新增TF文件。

状态：unit 303检查、两帧真实音乐集成模型、独立代码审查及 TD 综合/布局布线/位流通过；实板待验证。原约束 SWNS +0.660ns / HWNS +0.003ns / TNS0 / coverage99.97%；13097 LUT / 8221 reg / 14688 LE / 24 BRAM9K / 0 DSP / 2 GCLK，未执行fix_hold。成功基线仍download/image_adjust.bit，未本机JTAG/写TF/Flash。


位流 SHA256：D753D6893AA6C1EB98323C189FC7889A7FBCB96D3C12ECA5966AF515AE397D49
数码管 D 页应为 DFC11202。模型与边界见 build/model/integration_review.md；交付及操作见 build/delivery/README.md。
