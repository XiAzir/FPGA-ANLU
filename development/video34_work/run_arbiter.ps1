$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot '../../scripts/anlu_tools.ps1')
$taskIv=Resolve-AnluTool -Name iverilog
$taskVvp=Resolve-AnluTool -Name vvp
$taskOutput=Join-Path $PSScriptRoot 'arbiter'
New-Item -ItemType Directory -Force -Path $taskOutput | Out-Null
& $taskIv -g2012 -s tb_yuv_arbiter -o (Join-Path $taskOutput 'arbiter.vvp') `
    (Join-Path $PSScriptRoot 'tb_yuv_arbiter.v') `
    (Join-Path $PSScriptRoot '../player_video34_1080p15/src/user_source/hdl_source/yuv_sdram_burst_arbiter.v')
if($LASTEXITCODE -ne 0){throw 'Arbiter compile failed'}
& $taskVvp (Join-Path $taskOutput 'arbiter.vvp') *> (Join-Path $taskOutput 'simulation.log')
$taskExit=$LASTEXITCODE
Get-Content -LiteralPath (Join-Path $taskOutput 'simulation.log')
if($taskExit -ne 0){throw 'Arbiter simulation failed'}
