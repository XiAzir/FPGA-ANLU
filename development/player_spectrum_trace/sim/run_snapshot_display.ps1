$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$projectRoot=(Resolve-Path (Join-Path $taskRoot '../..')).Path
$iverilog=Join-Path $projectRoot 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe'
$vvp=Join-Path $projectRoot 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe'
$model=Join-Path $taskRoot 'build/model/snapshot_display'
New-Item -ItemType Directory -Force $model | Out-Null
& $iverilog -g2012 -s tb_snapshot_display -o (Join-Path $model test.vvp) (Join-Path $PSScriptRoot tb_snapshot_display.v) (Join-Path $taskRoot 'src/user_source/hdl_source/player_status_monitor.v') *> (Join-Path $model compile.log)
if($LASTEXITCODE){throw 'display compile failed'}
& $vvp (Join-Path $model test.vvp) *> (Join-Path $model run.log)
if($LASTEXITCODE){Get-Content (Join-Path $model run.log);throw 'display regression failed'}
Get-Content (Join-Path $model run.log)
