$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$taskRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$taskTools=(Split-Path -Parent (Resolve-AnluTool 'iverilog'))
$taskOut=Join-Path $taskRoot 'build/state_sim'
New-Item -ItemType Directory -Force -Path $taskOut | Out-Null
$taskExe=Join-Path $taskOut 'state.vvp'
& (Resolve-AnluTool 'iverilog') -g2012 -Wall -s tb_player_osd_state -o $taskExe `
    (Join-Path $taskRoot 'sim/tb_player_osd_state.v') `
    (Join-Path $taskRoot 'src/user_source/hdl_source/player_osd_state.v') *> (Join-Path $taskOut 'compile.log')
if($LASTEXITCODE -ne 0) { Get-Content (Join-Path $taskOut 'compile.log'); throw 'state model compilation failed' }
& (Resolve-AnluTool 'vvp') $taskExe *> (Join-Path $taskOut 'run.log')
Get-Content -LiteralPath (Join-Path $taskOut 'run.log')
if($LASTEXITCODE -ne 0 -or !(Select-String -LiteralPath (Join-Path $taskOut 'run.log') -SimpleMatch 'PASS coherent dual-clock' -Quiet)) { throw 'state model failed' }
