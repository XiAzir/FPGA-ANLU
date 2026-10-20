# C11301 波形清晰度优化候选

隔离自C11206 bmp_scale verified。规格见build/waveform_spec.md。512列、四分之一像素幅值与边缘亮度过渡，保持1024样本窗口、图形范围和增益；按键与五项扩展保持。

独立gold、冻结及音乐/参数/字幕叠加模型通过；正式TD综合、布局布线和位流生成成功，原约束setup+0.615ns/hold+0.019ns/TNS0，29BRAM9K/14621LUT/8677reg/8DSP。已生成本地候选，实板验收待用户完成。成功回退为download/bmp_scale.bit，可使用现有多尺寸BMP及TEST.WAV。实验室板卡由用户下载，本机不操作JTAG/TF/Flash。

本轮实际运行模型：build/model/run_waveform_fine.ps1、run_keyfreeze_wave.ps1、run_integration.ps1。其他从父快照复制的模型仅保留历史测试源码，未运行的模型不计本轮通过；默认stale等待用缩短周期参数实例核控制，物理显示/音质/长期尚未验证。封存清单与交付包由build/seal_candidate.py核查绑定。
