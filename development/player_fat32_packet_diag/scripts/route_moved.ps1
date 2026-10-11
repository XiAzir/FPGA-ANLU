param([Parameter(Mandatory)][ValidatePattern('^x\d+y\d+$')][string]$Grid)
$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$taskSources=Join-Path $taskRoot 'src/user_source'
$taskScopePath=Join-Path $taskRoot 'build/manual/build_source_scope.json'
$taskScope=@(Get-Content -Raw -LiteralPath $taskScopePath|ConvertFrom-Json)
foreach($taskEntry in $taskScope) {if((Get-FileHash -LiteralPath (Join-Path $taskSources $taskEntry.path)).Hash -ne $taskEntry.sha256) {throw 'Source changed after synthesis'}}
$taskOutput=Join-Path $taskRoot "build/attempt_streaming_move_$Grid"
$taskMove=Get-Content -Raw -LiteralPath (Join-Path $taskOutput 'move_console.log')
if(!$taskMove.Contains('Successfully moved 1 instances') -or !$taskMove.Contains('LOCAL_MOVE_COMMAND_COMPLETE_VERIFY_ATTRIBUTES')) {throw 'No verified successful move'}
$taskLog=Join-Path $taskOutput 'physical_console.log'
if(Test-Path -LiteralPath $taskLog) {throw 'Do not overwrite a routed move attempt'}
Copy-Item -LiteralPath $taskScopePath -Destination $taskOutput
$env:FPGA_DIAG_MOVE_GRID=$Grid
try {
    & 'C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/bin/td_commands_prompt.exe' ((Join-Path $PSScriptRoot 'route_moved.tcl').Replace('\','/')) *> $taskLog
    $taskExit=$LASTEXITCODE
    Get-Content -LiteralPath $taskLog -Tail 12
    if($taskExit -ne 0 -or !(Select-String -LiteralPath $taskLog -SimpleMatch 'MOVED_ROUTE_HOLD_COMPLETE' -Quiet)) {throw "Moved route failed; see $taskLog"}
    Get-Content -LiteralPath (Join-Path $taskOutput 'AC201_tf_hdmi_phy.ts')
} finally {Remove-Item Env:FPGA_DIAG_MOVE_GRID -ErrorAction SilentlyContinue}
