$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
. (Join-Path $taskRoot 'scripts/build_evidence.ps1')
$taskOutput=Join-Path $taskRoot 'build/manual'
$taskCtx=Get-CurrentEvidenceContext (Join-Path $taskRoot 'src') (Join-Path $taskRoot 'scripts')
$taskStages=[ordered]@{}
foreach($taskName in @('synthesis','physical','hold','bitstream')) {
 $taskRecord=Read-StageEvidence $taskOutput $taskName
 Assert-Context $taskRecord $taskCtx
 $taskStages[$taskName]=$taskRecord
}
foreach($taskName in @('physical','hold','bitstream')) {
 if($taskStages[$taskName].synthesisRunId -ne $taskStages.synthesis.runId -or $taskStages[$taskName].gateDbHash -ne $taskStages.synthesis.gateDbHash) {throw 'Stage does not belong to the current synthesis'}
}
if((Get-FileSha256 (Join-Path $taskOutput 'AC201_tf_hdmi_gate.db')) -ne $taskStages.synthesis.gateDbHash) {throw 'Gate DB changed'}
Assert-RouteArtifacts $taskStages.hold $taskOutput
if($taskStages.bitstream.routeStage -ne 'hold') {throw 'Bit was not generated from the final hold stage'}
$taskBit=Join-Path $taskOutput 'AC201_player_video26_runtime_diag.bit'
if((Get-FileSha256 $taskBit) -ne $taskStages.bitstream.bitHash) {throw 'Bit hash mismatch'}
$taskInputs=@(Get-ChildItem -LiteralPath (Join-Path $taskRoot 'src/user_source') -File -Force -Recurse)
$taskInputs+=Get-Item -LiteralPath (Join-Path $taskRoot 'src/td_project/AC201_tf_hdmi.al')
$taskInputs+=Get-ChildItem -LiteralPath (Join-Path $taskRoot 'src/td_project/al_ip') -File -Force -Recurse
$taskScope=@($taskInputs | Sort-Object FullName | ForEach-Object {[ordered]@{path=[IO.Path]::GetRelativePath($taskRoot,$_.FullName);sha256=(Get-FileSha256 $_.FullName)}})
[ordered]@{status='PASS';createdUtc=[DateTime]::UtcNow.ToString('o');inputs=$taskScope;scopeHash=$taskCtx.scopeHash;scriptHash=$taskCtx.scriptHash;stages=$taskStages;bit_sha256=(Get-FileSha256 $taskBit)} | ConvertTo-Json -Depth 25 | Set-Content (Join-Path $PSScriptRoot 'final_stage_binding.json') -Encoding utf8
