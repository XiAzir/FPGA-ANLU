$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$project = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$repo = (Resolve-Path (Join-Path $project '..\..')).Path
$build = Join-Path $project 'build\axis_probe_model'
$null = New-Item -ItemType Directory -Force -Path $build
$iverilog = (Resolve-AnluTool 'iverilog')
$vvp = (Resolve-AnluTool 'vvp')
$hdl = Join-Path $project 'src\user_source\hdl_source\player_axis_input_probe.v'
$tb = Join-Path $project 'sim\axis_probe\tb_axis_probe.v'
$legacy = Join-Path $repo 'development\player_dynamic_text_video_probe\src\user_source\hdl_source'
$sources = @(
    $tb,
    $hdl,
    (Join-Path $legacy 'SD\color_bar.v'),
    (Join-Path $legacy 'SD\video_timing_data.v'),
    (Join-Path $legacy 'SD\video_delay.v'),
    (Join-Path $legacy 'video_rgb_to_axis_640x480.v')
)
$includeArgs = @('-I', (Join-Path $legacy 'SD'))
$compileArgs = @('-g2012') + $includeArgs + @('-o', (Join-Path $build 'axis_probe.vvp')) + $sources
$runArgs = @((Join-Path $build 'axis_probe.vvp'))
$argsRecord = [ordered]@{
    iverilog = $iverilog
    iverilog_args = $compileArgs
    vvp = $vvp
    vvp_args = $runArgs
    working_directory = $repo
}
$argsPath = Join-Path $build 'command_args.json'
$argsRecord | ConvertTo-Json -Depth 5 | Set-Content -Encoding utf8 $argsPath
$log = Join-Path $build 'run.log'
Set-Content -Encoding utf8 $log "Icarus axis observer model`r`n"
Push-Location $repo
try {
    & $iverilog @compileArgs 2>&1 | Tee-Object -FilePath $log -Append
    $compileExit = $LASTEXITCODE
    if ($compileExit -ne 0) { throw "iverilog exited $compileExit" }
    & $vvp @runArgs 2>&1 | Tee-Object -FilePath $log -Append
    $runExit = $LASTEXITCODE
    if ($runExit -ne 0) { throw "vvp exited $runExit" }
} catch {
    Add-Content -Encoding utf8 $log "FAILED: $_"
    throw
} finally {
    Pop-Location
}

$files = [ordered]@{
    observer_rtl = $hdl
    testbench = $tb
    actual_chain = @(
        (Join-Path $legacy 'SD\color_bar.v'),
        (Join-Path $legacy 'SD\video_timing_data.v'),
        (Join-Path $legacy 'SD\video_delay.v'),
        (Join-Path $legacy 'video_rgb_to_axis_640x480.v')
    )
    runner = $PSCommandPath
}
$bindings = [ordered]@{ generated_utc = [DateTime]::UtcNow.ToString('o'); files = @{} }
foreach ($key in @('observer_rtl', 'testbench', 'runner')) {
    $path = $files[$key]
    $bindings.files[$key] = [ordered]@{ path = $path; sha256 = (Get-FileHash -Algorithm SHA256 -LiteralPath $path).Hash }
}
$bindings.files.actual_chain = @(
    foreach ($path in $files.actual_chain) {
        [ordered]@{ path = $path; sha256 = (Get-FileHash -Algorithm SHA256 -LiteralPath $path).Hash }
    }
)
$bindings | ConvertTo-Json -Depth 8 | Set-Content -Encoding utf8 (Join-Path $build 'source_bindings.json')
@'
# AXI 视频输入观察器模型报告

结果：PASS。由指定 Icarus Verilog 12 工具链编译并运行 `sim/axis_probe/tb_axis_probe.v`。

覆盖范围：实际工程 `color_bar`、`video_timing_data`、`video_delay` 与旧版 `video_rgb_to_axis_640x480` 串接，SDRAM 像素读取由递增 RGB 驱动替代；运行多帧连续链并核对 640×480、420000 周期、307200 有效像素、TLAST 观测为 0、160 周期行间 blank、零错误计数及状态位。小参数用例覆盖短行、帧像素/行/周期异常、非法 USER、USER 行中分隔、首帧不误判、SOF ready 低、TLAST 计数、复位重启和 12 位饱和。

边界：该模型验证 RTL 的输入观测和计数语义；像素源已替代 SDRAM，不包含 HDMI 加密核或板级时钟/供电，不能据此断言实板黑屏根因或恢复。旧转换器本身已知没有发出 TLAST，本 observer 只报告观察值，不据此增加坏帧判断。复位后保留转换器约 40 拍启动边界。

接口：`flags={locked,locked_ever,valid_seen,user_seen}`；`dims={last_line_width[11:0],last_complete_frame_rows[11:0]}`；`frame_period`、`frame_pixels`、`bad_counts={bad_line,bad_frame}`、`gap_ready={intra_frame_blank,valid_not_ready}`、`frame_last_count`、`user_frames={bad_user,valid_user_frames}`。所有观察输入均为被动输入。

可复现命令：`pwsh -NoProfile -File scripts/run_axis_probe_model.ps1`。完整参数见 `build/axis_probe_model/command_args.json`，源 SHA-256 绑定见 `build/axis_probe_model/source_bindings.json`，终端输出见 `build/axis_probe_model/run.log`。
'@ | Set-Content -Encoding utf8 (Join-Path $build 'report.md')
Add-Content -Encoding utf8 $log "PASS: source bindings and report written."
