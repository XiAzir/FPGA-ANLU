$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot '../../scripts/anlu_tools.ps1')
$taskCompiler=Resolve-AnluTool -Name 'iverilog'
$taskRuntime=Resolve-AnluTool -Name 'vvp'
$taskHdl=Join-Path $PSScriptRoot '../player_video26_runtime_diag/src/user_source/hdl_source'
& python (Join-Path $PSScriptRoot 'prepare_observer_tests.py')
if($LASTEXITCODE -ne 0) {throw 'Observer extraction failed'}
$taskCases=@(
    @{name='r1';sources=@("$taskHdl/SD/sd_card_cmd.v","$PSScriptRoot/sd_card_cmd_r1_probe_tb.v");marker='PASS: R1 observer'},
    @{name='mode_counter';sources=@("$PSScriptRoot/mode_counter_probe.v","$PSScriptRoot/tb_mode_counter.v");marker='PASS_MODE_COUNTER'},
    @{name='card_debug';sources=@("$taskHdl/SD/sd_card_cmd.v","$taskHdl/SD/sd_card_sec_read_write.v","$taskHdl/SD/sd_card_top.v","$taskHdl/SD/spi_master.v","$PSScriptRoot/tb_card_debug.v");marker='PASS_CARD_DEBUG'}
)
$taskResults=@()
foreach($taskCase in $taskCases) {
    $taskBinary=Join-Path $PSScriptRoot ($taskCase.name+'.vvp')
    $taskCompileLog=Join-Path $PSScriptRoot ($taskCase.name+'_compile.log')
    $taskRunLog=Join-Path $PSScriptRoot ($taskCase.name+'_run.log')
    & $taskCompiler -g2012 -o $taskBinary @($taskCase.sources) *> $taskCompileLog
    if($LASTEXITCODE -ne 0) {Get-Content $taskCompileLog;throw "Compile failed: $($taskCase.name)"}
    & $taskRuntime $taskBinary *> $taskRunLog
    if($LASTEXITCODE -ne 0 -or !(Select-String -LiteralPath $taskRunLog -SimpleMatch $taskCase.marker -Quiet)) {
        Get-Content $taskRunLog;throw "Simulation failed: $($taskCase.name)"
    }
    Get-Content $taskRunLog -TotalCount 2
    $taskResults+=@{name=$taskCase.name;status='PASS';log_sha256=(Get-FileHash $taskRunLog).Hash}
}
$taskReport=@{status='PASS';tests=$taskResults;inputs=(Get-Content -Raw (Join-Path $PSScriptRoot 'observer_test_inputs.json') | ConvertFrom-Json)}
$taskReport | ConvertTo-Json -Depth 10 | Set-Content (Join-Path $PSScriptRoot '../player_video26_runtime_diag/verification/runtime_diag_tests.json') -Encoding utf8
