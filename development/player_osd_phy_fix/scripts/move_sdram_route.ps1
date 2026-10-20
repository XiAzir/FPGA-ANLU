$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$taskRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$taskOut=Join-Path $taskRoot 'build/attempt_sdram_x17y36'
if(Test-Path -LiteralPath $taskOut) {throw 'Do not overwrite a physical attempt'}
$taskScopePath=Join-Path $taskRoot 'build/manual/build_source_scope.json'
$taskScope=Get-Content -Raw -LiteralPath $taskScopePath | ConvertFrom-Json
foreach($taskEntry in $taskScope) {
    if((Get-FileHash -LiteralPath (Join-Path $taskRoot ('src/'+$taskEntry.path))).Hash -ne $taskEntry.sha256) {throw 'Source changed after synthesis'}
}
New-Item -ItemType Directory -Path $taskOut | Out-Null
Copy-Item -LiteralPath $taskScopePath -Destination $taskOut
$taskLog=Join-Path $taskOut 'physical_console.log'
$taskAlPath = Join-Path $taskRoot 'src/td_project/AC201_tf_hdmi.al'
$taskAlLocation = Get-AnluProjectLocation $taskAlPath
try {
    & (Resolve-AnluTool 'td_commands_prompt') ((Join-Path $PSScriptRoot 'move_sdram_route.tcl').Replace('\','/')) *> $taskLog
    $taskExit=$LASTEXITCODE
} finally {
    # TD rewrites only this location during open_project; retain all other source guards.
    Restore-AnluProjectLocation $taskAlPath $taskAlLocation
}
Get-Content -LiteralPath $taskLog -Tail 12
if($taskExit -ne 0 -or !(Select-String -LiteralPath $taskLog -SimpleMatch 'SDRAM_MOVE_ROUTE_HOLD_COMPLETE' -Quiet) -or !(Select-String -LiteralPath $taskLog -SimpleMatch 'Successfully moved 1 instances' -Quiet)) {throw "Physical move failed: $taskLog"}
Get-Content -LiteralPath (Join-Path $taskOut 'AC201_tf_hdmi_phy.ts')
