$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$projectRoot=(Resolve-Path (Join-Path $taskRoot '../..')).Path
$iverilog=Join-Path $projectRoot 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe'
$vvp=Join-Path $projectRoot 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe'
$model=Join-Path $taskRoot 'build/model/fault_snapshot'
New-Item -ItemType Directory -Force $model | Out-Null
$exe=Join-Path $model test.vvp
& $iverilog -g2012 -s tb_fault_snapshot -o $exe (Join-Path $PSScriptRoot tb_fault_snapshot.v) (Join-Path $taskRoot 'src/user_source/hdl_source/player_fault_snapshot.v') *> (Join-Path $model compile.log)
if($LASTEXITCODE){throw 'snapshot compile failed'}
& $vvp $exe *> (Join-Path $model run.log)
if($LASTEXITCODE){Get-Content (Join-Path $model run.log);throw 'snapshot test failed'}
Get-Content (Join-Path $model run.log)
