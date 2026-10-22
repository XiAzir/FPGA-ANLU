$ErrorActionPreference = 'Stop'
$project = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
$iv = Join-Path $project 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\iverilog.exe'
$vvp = Join-Path $project 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\vvp.exe'
$out = Join-Path $PSScriptRoot 'tb_quiesce.vvp'
$log = Join-Path $PSScriptRoot 'quiesce_unit.log'
& $iv -g2005 -o $out -s tb_player_mode_quiesce `
  (Join-Path $PSScriptRoot 'player_mode_quiesce.v') `
  (Join-Path $PSScriptRoot 'tb_player_mode_quiesce.v') 2>&1 | Tee-Object -FilePath $log
if ($LASTEXITCODE -ne 0) { throw "iverilog failed: $LASTEXITCODE" }
& $vvp $out 2>&1 | Tee-Object -FilePath $log -Append
if ($LASTEXITCODE -ne 0) { throw "vvp failed: $LASTEXITCODE" }
if (-not (Select-String -Path $log -SimpleMatch 'PASS quiesce protocol' -Quiet)) {
  throw 'PASS marker missing from simulation log'
}
