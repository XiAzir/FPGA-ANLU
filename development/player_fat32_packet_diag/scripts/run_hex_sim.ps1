$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$taskRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$taskTools=(Split-Path -Parent (Resolve-AnluTool 'iverilog'))
$taskOut=Join-Path $taskRoot 'build/status_hex_sim'
New-Item -ItemType Directory -Force -Path $taskOut | Out-Null
$taskExe=Join-Path $taskOut 'hex.vvp'
& (Resolve-AnluTool 'iverilog') -g2012 -Wall -s tb_status_hex595 -o $taskExe (Join-Path $taskRoot 'sim/tb_status_hex595.v') (Join-Path $taskRoot 'src/user_source/hdl_source/status_hex595.v') *> (Join-Path $taskOut 'compile.log')
if($LASTEXITCODE -ne 0) { throw '595 model compilation failed' }
& (Resolve-AnluTool 'vvp') $taskExe *> (Join-Path $taskOut 'run.log')
Get-Content -LiteralPath (Join-Path $taskOut 'run.log')
if($LASTEXITCODE -ne 0) { throw '595 model failed' }
