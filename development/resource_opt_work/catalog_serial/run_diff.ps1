$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$iverilog = Resolve-AnluTool -Name 'iverilog'
$vvp = Resolve-AnluTool -Name 'vvp'
python (Join-Path $PSScriptRoot 'run_diff.py') $iverilog $vvp
if ($LASTEXITCODE -ne 0) { throw "catalog serial differential run failed: $LASTEXITCODE" }
