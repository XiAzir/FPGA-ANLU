# AXIS 行协议 TLAST 隔离修正审计

日期：2026-10-09（北京时间）

## 范围

在 `prototype/video_rgb_to_axis_640x480_fixed.v` 建立隔离副本，除实例化所需的模块名改为 `video_rgb_to_axis_640x480_fixed` 外，只将行末计数比较从旧值 639 改为 638。将原副本中模块名和比较值反向归一后，与原文件逐行比较（忽略空行/文件尾差异）结果为 0 行差异。未修改生产源码、`.al`、SDC、bit 或检查点；未生成或启动 TD 候选。

测试用的 color_bar、video_timing_data、video_delay 是 probe 的真实 RTL；原 converter 与修正 converter 并行接收同一链路。full-chain testbench 在时序器解除复位后额外保持 converter reset 40 拍，避开真实 `video_timing_data` 未复位 d1 输出寄存器在 `video_delay` 复位释放时造成的一拍启动 X，再开始协议计数。该 reset 仅属于 testbench。

## 测试与结果

Icarus Verilog 12.0 (devel)，用 `run.ps1` 编译实际 video source、原 converter、隔离修正副本和 testbench；日志在 `compile.log` 与 `run.log`。

- 实际时序/延迟链完整两帧：960 行、614400 valid 像素。逐输入拍比较两实例的 valid 和 data 延迟，均保持 1 拍；blank 期间检查 last/user 为 0。
- 每行用实际连续 DE 起止计数：原 converter 发出 TLAST=0；隔离修正副本每行在第 640 个、仍为 valid 的末像素发出 TLAST=1，总计 960 次。没有按修正计数器镜像生成 oracle。
- SOF 按原有任意 VS 边沿 arm 规则逐拍核对；真实两帧共 2 次，均在各帧首行首像素。
- 直接输入边界：639 像素短行无 TLAST；紧接的完整 640 像素行正确重新计数并发 1 次 TLAST；300 像素行中异步复位立即清除输出，复位后完整新行只再发 1 次 TLAST；VS 上升、下降边沿均重新 arm SOF。

最终日志：`FULL SUMMARY lines=960 pixels=614400 orig_last=0 fixed_last=960 sof=2 failures=0`，以及完整 PASS 行。

## 证据边界

结果证明 RTL 协议模型中 638 比较值会把 TLAST 对齐到 640 个连续 valid 的行末，且本测试覆盖的 valid/data/user 延迟与行首/复位语义保持不变。未模拟 ready/backpressure、加密 HDMI core 内部、综合布局布线、板上路由或实物；尤其不能据此声称该修正解决本次 no-signal。

## SHA-256

- probe 原 converter：`1C8FC26C789F87227036BEA034F1AB6FC5633F2AB2684BE422C54687A290FB96`
- 本目录 prototype converter：`3E1F1857CF2E3AF5FFFDECCB050EBD7D77009B029F92FAEA1E85FC1A5AB80E2F`
- `SD/color_bar.v`：`AFE1F56714EC58D2477BA1717E5A36C5A0DA5FE5C07D70D11AA5ACE710C4B152`
- `SD/video_timing_data.v`：`C6F75501E98DD5995F687AAFB40455BEFFE45B426137B5089A73AC3A036F7282`
- `SD/video_delay.v`：`F47C4B63F8BAA6D8874C87DCA5B72DFDADD19F4A107403DA98752BCE98936433`
- `tb_axis_protocol_fix_audit.v`：`567358B1863AF3B2F440D557CDFC27B0BA6300B7DDAD38BAADF8AA05D781B8EA`
- `run.ps1`：`2E4CB3CF64CC21277C0CF630D79AB164C9017D375D2B7311E6FCBF8198A13DC0`

复跑：`pwsh -NoProfile -ExecutionPolicy Bypass -File run.ps1`。
