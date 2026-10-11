param([ValidateRange(2,5)][int]$Seed=2)
$ErrorActionPreference='Stop'
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
[ordered]@{seed=$Seed;gate_db_sha256=(Get-FileHash -LiteralPath (Join-Path $taskManual 'AC201_tf_hdmi_gate.db')).Hash;official_flow='C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/scripts/MultiSeed.tcl';started_beijing=(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')} |
    ConvertTo-Json | Set-Content -LiteralPath (Join-Path $taskOutput 'seed.info.json') -Encoding utf8
$env:FPGA_DIAG_PLACE_SEED=[string]$Seed
try {
    $taskLog=Join-Path $taskOutput 'physical_console.log'
    & 'C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/bin/td_commands_prompt.exe' ((Join-Path $PSScriptRoot 'build_seeded.tcl').Replace('\','/')) *> $taskLog
    $taskExit=$LASTEXITCODE
    Get-Content -LiteralPath $taskLog -Tail 12
    if($taskExit -ne 0 -or !(Select-String -LiteralPath $taskLog -SimpleMatch 'SEEDED_PLACE_ROUTE_HOLD_COMPLETE' -Quiet)) {throw "Seed $Seed failed; see $taskLog"}
    Get-Content -LiteralPath (Join-Path $taskOutput 'AC201_tf_hdmi_phy.ts')
} finally {
    Remove-Item Env:FPGA_DIAG_PLACE_SEED -ErrorAction SilentlyContinue
}
