$ErrorActionPreference = 'Stop'
$project = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
$rtl = Join-Path $project 'development\player_video23_mode_switch\src\user_source\hdl_source'
$iv = Join-Path $project 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\iverilog.exe'
$vvp = Join-Path $project 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\vvp.exe'
$out = Join-Path $PSScriptRoot 'tb_c23_mode_restart.vvp'
$log = Join-Path $PSScriptRoot 'c23_mode_restart.log'
Set-Content -Path $log -Value ''
& $iv -g2005 -o $out -s tb_c23_mode_restart `
  (Join-Path $rtl 'player_media_restart.v') `
  (Join-Path $rtl 'player_mode_quiesce.v') `
  (Join-Path $PSScriptRoot 'tb_c23_mode_restart.v') 2>&1 | Tee-Object -FilePath $log
if ($LASTEXITCODE -ne 0) { throw "iverilog failed: $LASTEXITCODE" }
$cases = @(
  @{ V=20; S=10; P=0 },
  @{ V=20; S=10; P=7 },
  @{ V=20; S=10; P=19 },
  @{ V=19; S=10; P=3 },
  @{ V=21; S=10; P=9 }
)
foreach ($case in $cases) {
  & $vvp $out "+VHALF=$($case.V)" "+SHALF=$($case.S)" "+PHASE=$($case.P)" 2>&1 | Tee-Object -FilePath $log -Append
  if ($LASTEXITCODE -ne 0) { throw "vvp failed for $case" }
}
$passes = (Select-String -Path $log -Pattern '^PASS C23 restart control:' | Measure-Object).Count
if ($passes -ne $cases.Count) { throw "Expected $($cases.Count) PASS runs, got $passes" }
