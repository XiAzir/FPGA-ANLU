# FIFO 等价模型范围与重跑

根代理独立重跑通过：256 深度 push780/pop771、empty bypass10、one-item bypass1、full pop+push1、读写指针各wrap3；2048 深度 push2572/pop2563、10/1/1、读写指针各wrap1。push 比 pop 多9来自非空复位时丢弃的9项，与模型预期一致。

完整旧/新播放器实例仅强制输入 `play_push_req` 与 `prefetch_value`，保留真实 accepted `play_push` 满/同时pop门控、头数据/valid、计数、RAM、读写指针。每次有效pop与软件队列比较，并逐周期比对两版available/push、有效data和内部count/pointer。旧副本相对C11108正式源仅模块改名和尾空行。模型不包含真实文件解析激励，解析/扇区/循环与bridge分别由wav_model与pipeline_model覆盖。

这是RTL数组模型，不是DP8K器件原语仿真。显式寄存旁路掩蔽空/单元素同址读写返回值；四块BRAM映射来自实际TD综合网表，不由本模型推断。CRC观察器只覆盖固定窗口，未证明板级链路或无信号机制。

在本工程根目录使用PowerShell 7：

```powershell
$taskRoot='E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_pcm_bram_candidate'
$taskIV='E:/VSCODE-project/FPGA-ANLU/bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe'
$taskVP='E:/VSCODE-project/FPGA-ANLU/bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe'
foreach($taskDepth in 256,2048) {
    & $taskIV -g2012 -s tb_fifo_bram_equivalence "-Ptb_fifo_bram_equivalence.TEST_DEPTH=$taskDepth" -o "$taskRoot/build/model/fifo_equivalence_$taskDepth.vvp" "$taskRoot/build/model/tb_fifo_bram_equivalence.v" "$taskRoot/build/model/tf_wav_file_player_old.v" "$taskRoot/src/user_source/hdl_source/tf_wav_file_player.v"
    if($LASTEXITCODE -ne 0) { throw 'compile failed' }
    & $taskVP "$taskRoot/build/model/fifo_equivalence_$taskDepth.vvp"
    if($LASTEXITCODE -ne 0) { throw 'model failed' }
}
```

固定checkpoint不重写。需要复跑时在活动build目录进行并单独存结果。
