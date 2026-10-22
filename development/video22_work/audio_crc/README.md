# C11322 HDMI 输入 PCM CRC 观察器

此目录提供独立探针、短仿真和 WAV CRC 黄金表。生产工程仍未改动；父任务可将模块复制进 C11322 后接到 HDMI wrapper 的 `audio_valid/audio_left_data/audio_right_data`。

## 模块行为

`player_pcm_crc_probe.v` 对每笔 `audio_valid` 输入采样快照，随后每个 `clk` 处理一个 CRC bit，48 个 pixel clocks 完成左右声道 6 字节记录。CRC 为 CRC-16/CCITT-FALSE：poly `0x1021`、init `0xFFFF`、不反射；每通道字节顺序低字节先、每个字节 MSB 先。接口约定相邻音频 tick 至少间隔 48 拍；HDMI 48kHz 输入的实际 tick 间隔约520/521拍。

每块4096个 `audio_valid` 样本。`first_crc` 在首块完成时捕获并保持到 reset；`last_crc` 每块完成更新；`block_index` 初始0，首块完成仍为0，其后依次1、2……；`sample_count` 统计每个 `audio_valid`。异步高有效 reset 清零所有输出，当前 CRC 初始化为 `0xFFFF`。探针只观察输入，不驱动或反馈数据通路。

## 短仿真

黄金由 `gen_crc_golden.py` 使用独立 Python bitwise CRC 生成。来源为 `deliverables/video20_c11320_20261021/TEST.WAV`，SHA256 `30eaf10a6ff1800163cecb3225cce685873b38c9a8e42635f1e5c92b0e95b5de`，data offset78、960000个样本。输入映射为 `{pcm16,8'h00}` 的左右声道相同值，CRC按用户规定的L低/中/高字节，再R低/中/高字节处理。

Icarus 编译和仿真均 exit code 0。运行命令（从本目录执行）：

```powershell
python gen_crc_golden.py
iverilog.exe -g2012 -s tb_player_pcm_crc_probe -o tb_player_pcm_crc_probe.vvp tb_player_pcm_crc_probe.v player_pcm_crc_probe.v
vvp.exe tb_player_pcm_crc_probe.vvp
```

`simulation_pass.log` 记录三块值 `9DC4 / D821 / 1B4B`、样本计数12288、首块 CRC 冻结、块号0/1/2、复位清零和520/521拍交替节拍通过。单比特负控只翻 L 路 packed PCM 的最低有效位（`audio_left[8]`），CRC 从 `9DC4` 变为 `9D84`。初次 `simulation.log` 保留了 golden 脚本将正负两路同时翻位时的失败输出；脚本已修正，当前通过输出独立保存在 `simulation_pass.log`。

## Canonical 黄金表

`canonical_crc_first80.json/.csv` 给前80个完整/部分CRC块；`canonical_crc_two_pass.json/.csv` 给20秒素材完整一遍并从头回环一次的全表：1,920,000个输出样本、469块，每个输入样本索引用 `sample_index % 960000` 取源WAV，最后一块含3072样本。JSON还记录来源SHA、data offset、CRC参数、块首尾、回环边界和每块CRC。前三块 CRC 与短仿真 golden 相同。

搜索资料目录没有发现旧版 `TEST.WAV`，所以本轮没有可用于区分旧卡素材的 firstCRC 对照项。实板采集可先查看 `first_crc`：与 canonical `9DC4` 相同表示首块 PCM 指纹匹配；随后读取 `last_crc` 与 `block_index`，和全表按块对照可定位偏离起点。CRC 相等提供高置信度指纹匹配，作为观测结果使用。

## 文件摘要

- RTL SHA256：`2fae63d0a85912ff1cab144ba39155d74084f02831089bf3eab0e52fd16fbc0f`
- testbench SHA256：`67ee9a616519eb10e6552b95a22a63fc2920f2fc4d43e8827a82e36e2312b326`
- golden generator SHA256：`e1e7d888fefe7c9ae5f16aa196f99926e53afa7f4518a6d92cbc7c43046d8180`
- two-pass JSON SHA256：`6c36d118e81d28d3cef0e0bf7da720f8e725e971d645694ca649af43ee37adb9`
- two-pass CSV SHA256：`305e655370b5a807470fbc72b42a8928ab505e81c29599b63d139ce0421856af`
