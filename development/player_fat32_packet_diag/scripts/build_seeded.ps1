param([ValidateRange(2,5)][int]$Seed=2)
$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$taskRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$taskSources=Join-Path $taskRoot 'src/user_source'
$taskManual=Join-Path $taskRoot 'build/manual'
$taskScope=@(Get-Content -Raw -LiteralPath (Join-Path $taskManual 'build_source_scope.json') | ConvertFrom-Json)
foreach($taskEntry in $taskScope) {
    if((Get-FileHash -LiteralPath (Join-Path $taskSources $taskEntry.path)).Hash -ne $taskEntry.sha256) {throw 'Source changed after synthesis'}
}
$taskOutput=Join-Path $taskRoot "build/attempt_streaming_seed_$Seed"
if(Test-Path -LiteralPath $taskOutput) {throw 'Do not overwrite a seed result'}
New-Item -ItemType Directory -Path $taskOutput | Out-Null
Copy-Item -LiteralPath (Join-Path $taskManual 'build_source_scope.json') -Destination $taskOutput
[ordered]@{seed=$Seed;gate_db_sha256=(Get-FileHash -LiteralPath (Join-Path $taskManual 'AC201_tf_hdmi_gate.db')).Hash;official_flow=(Join-Path (Split-Path -Parent (Split-Path -Parent (Resolve-AnluTool 'td_commands_prompt'))) 'scripts/MultiSeed.tcl');started_beijing=(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')} |
    ConvertTo-Json | Set-Content -LiteralPath (Join-Path $taskOutput 'seed.info.json') -Encoding utf8
$env:FPGA_DIAG_PLACE_SEED=[string]$Seed
try {
    $taskLog=Join-Path $taskOutput 'physical_console.log'
    $taskAlPath = Join-Path $taskRoot 'src/td_project/AC201_tf_hdmi.al'
    $taskAlLocation = Get-AnluProjectLocation $taskAlPath
    try {
        & (Resolve-AnluTool 'td_commands_prompt') ((Join-Path $PSScriptRoot 'build_seeded.tcl').Replace('\','/')) *> $taskLog
        $taskExit=$LASTEXITCODE
    } finally {
        # TD rewrites only this location during open_project; retain all other source guards.
        Restore-AnluProjectLocation $taskAlPath $taskAlLocation
    }
    Get-Content -LiteralPath $taskLog -Tail 12
    if($taskExit -ne 0 -or !(Select-String -LiteralPath $taskLog -SimpleMatch 'SEEDED_PLACE_ROUTE_HOLD_COMPLETE' -Quiet)) {throw "Seed $Seed failed; see $taskLog"}
    Get-Content -LiteralPath (Join-Path $taskOutput 'AC201_tf_hdmi_phy.ts')
} finally {
    Remove-Item Env:FPGA_DIAG_PLACE_SEED -ErrorAction SilentlyContinue
}
