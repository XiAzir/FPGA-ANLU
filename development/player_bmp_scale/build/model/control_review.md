# C11204 按键冻结控制器模型审查

## 实现结论

`player_adjust_control` 新增 `waveform_toggle` 输出；复位及非事件周期为 0。已有双键消抖重叠锁存和“两键均稳定释放”分支产生短组合键单周期脉冲，仅在 `!chord_long_done && mode == MODE_PLAY` 时产生。原消抖器、双键/单键长按计数、单键短动作及低脉冲/高恢复队列未改动。

## 可复现仿真

- `pwsh -NoProfile -ExecutionPolicy Bypass -File build/model/run_control_model.ps1`：PASS；38 个 `check` 断言覆盖旧控制器行为、25 MHz默认计数和新输出互斥回归。
- `pwsh -NoProfile -ExecutionPolicy Bypass -File build/model/run_short_chord_model.ps1`：PASS；11 个 `check` 断言覆盖按键弹跳、先后按下/释放、等待双键释放、连续组合键重装、长组合键和编辑模式抑制；监视器另检查脉冲不连续超过一个周期。
- 日志：`tb_player_adjust_control.compile.log`、`tb_player_adjust_control.log`、`tb_waveform_chord_control.compile.log`、`tb_waveform_chord_control.log`。

## 结论边界

证据限于 Icarus Verilog RTL模型仿真。未执行 TD 综合/时序检查、下载或实板输入与波形冻结验证；此结果不能作为实板行为证据。
