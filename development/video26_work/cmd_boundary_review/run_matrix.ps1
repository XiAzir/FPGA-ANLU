$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$taskCompiler=Resolve-AnluTool -Name 'iverilog'
$taskRuntime=Resolve-AnluTool -Name 'vvp'
$taskBase=Join-Path $PSScriptRoot '../../player_video26_runtime_diag/src/user_source/hdl_source/SD/sd_card_cmd.v'
$taskTb=Join-Path $PSScriptRoot 'tb_command_boundary.v'
$taskRows=@()
foreach($taskVersion in @('baseline','candidate')) {
  $taskSource=if($taskVersion -eq 'baseline'){$taskBase}else{Join-Path $PSScriptRoot 'sd_card_cmd.v'}
  & $taskCompiler -g2012 -o "$PSScriptRoot/$taskVersion.vvp" $taskSource $taskTb *> "$PSScriptRoot/$($taskVersion)_compile.log"
  if($LASTEXITCODE -ne 0){throw 'Compile failed'}
  foreach($taskCmd in @(0,8,17,55)) {
    foreach($taskSlot in @(0,1,2,3,4,5,99)) {
      foreach($taskNoise in @(0,1,4,128,193,255)) {
        $taskLog=Join-Path $PSScriptRoot "$($taskVersion)_cmd$($taskCmd)_slot$($taskSlot)_noise$taskNoise.log"
        & $taskRuntime "$PSScriptRoot/$taskVersion.vvp" "+CMD=$taskCmd" "+SLOT=$taskSlot" "+NOISE=$taskNoise" *> $taskLog
        $taskPass=($LASTEXITCODE -eq 0 -and (Select-String -LiteralPath $taskLog -SimpleMatch 'BOUNDARY_PASS' -Quiet))
        $taskExpected=($taskVersion -eq 'candidate' -or $taskSlot -eq 99 -or $taskNoise -ge 128)
        if($taskPass -ne $taskExpected){Get-Content $taskLog;throw 'Unexpected boundary matrix outcome'}
        $taskRows+=@{version=$taskVersion;cmd=$taskCmd;slot=$taskSlot;noise=$taskNoise;pass=$taskPass;expected_pass=$taskExpected;log_sha256=(Get-FileHash $taskLog).Hash}
      }
    }
    $taskLog=Join-Path $PSScriptRoot "$($taskVersion)_cmd$($taskCmd)_r1error.log"
    & $taskRuntime "$PSScriptRoot/$taskVersion.vvp" "+CMD=$taskCmd" '+SLOT=99' '+REPLY=4' *> $taskLog
    if($LASTEXITCODE -ne 0 -or !(Select-String -LiteralPath $taskLog -SimpleMatch 'BOUNDARY_PASS' -Quiet)){Get-Content $taskLog;throw 'Real R1 error was not preserved'}
  }
}
@{status='PASS';cases=$taskRows.Count;rows=$taskRows;baseline_expected_failures=@($taskRows|Where-Object {-not $_.pass}).Count;candidate_passes=@($taskRows|Where-Object {$_.version -eq 'candidate' -and $_.pass}).Count;r1_error_tests=8;tb_sha256=(Get-FileHash $taskTb).Hash;baseline_sha256=(Get-FileHash $taskBase).Hash;candidate_sha256=(Get-FileHash "$PSScriptRoot/sd_card_cmd.v").Hash} | ConvertTo-Json -Depth 8 | Set-Content "$PSScriptRoot/matrix_summary.json" -Encoding utf8
Write-Output "PASS command boundary matrix $($taskRows.Count) cases, baseline failures detected, candidate all pass; 8 real-R1-error controls pass"
