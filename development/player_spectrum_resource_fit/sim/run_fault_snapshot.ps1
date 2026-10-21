. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$projectRoot=(Resolve-Path (Join-Path $taskRoot '../..')).Path
$iverilog=(Resolve-AnluTool -Name 'iverilog')
$vvp=(Resolve-AnluTool -Name 'vvp')
$model=Join-Path $taskRoot 'build/model/fault_snapshot'
New-Item -ItemType Directory -Force $model | Out-Null
$exe=Join-Path $model test.vvp
& $iverilog -g2012 -s tb_fault_snapshot -o $exe (Join-Path $PSScriptRoot tb_fault_snapshot.v) (Join-Path $taskRoot 'src/user_source/hdl_source/player_fault_snapshot.v') *> (Join-Path $model compile.log)
if($LASTEXITCODE){throw 'snapshot compile failed'}
& $vvp $exe *> (Join-Path $model run.log)
if($LASTEXITCODE){Get-Content (Join-Path $model run.log);throw 'snapshot test failed'}
Get-Content (Join-Path $model run.log)
