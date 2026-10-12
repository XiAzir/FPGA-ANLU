# PCM 波形 RTL 模型

在项目根目录运行 `pwsh -File development/player_pcm_waveform/build/model/run_waveform_model.ps1`，脚本调用工作区内 Icarus Verilog 编译并运行本模型，输出写入 `development/player_pcm_waveform/build/model/player_pcm_waveform_model.log`。

测试从 `audio_valid/audio_pcm` 端口输入 128×8 个有效 PCM 事件，独立整数模型以负数 floor 除法计算量化 code 并逐 bin 比较 BRAM min/max。1024 个事件约对应 48 kHz 下 21.333 ms；PCM16 右移 8 位再加中心码 28，量化步长为 256 PCM counts。相对于每 1024 PCM counts 对应一个纵向像素的基准，这是 ×4 可视增益；PCM16 的数值范围仍为 -32768..32767。超出画布上下 28 像素时截顶，只影响图形。

模型随后通过真实 VS 上升沿切 bank，驱动 DE 光栅检查 RGB 叠加、图形 x/y 边界和同步读地址。音源模式在非 VS 沿变化时保留当帧图像；下一 VS 到来时，如新音源窗已 ready 就切到该完整窗口，如仍未 ready 就清图。音源变化与 VS 同沿时优先清除旧图，并忽略同沿采样事件。模型也覆盖事件间隙、窗口完成后的丢弃、半窗 source flush、VS 帧锁标题、默认 stale 周期常量及缩放 stale 实例。缩放实例测试 valid 恰逢超时门限，以及第五个无效周期与 VS 同沿时丢弃 ready bank、清除旧 front。

本模型不覆盖安路 TD 综合、BRAM 映射/时序、板上 HDMI 显示或真实音频链路。双 bank 的实体存储资源与时钟域接口由集成工程另行确认。
