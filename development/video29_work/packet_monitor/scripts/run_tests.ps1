$ErrorActionPreference = 'Stop'
$taskRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$repoRoot = [IO.Path]::GetFullPath((Join-Path $taskRoot '..\..\..'))
. (Join-Path $repoRoot 'scripts/anlu_tools.ps1')
$iverilog = Resolve-AnluTool 'iverilog'
$vvp = Resolve-AnluTool 'vvp'
$source = Join-Path $taskRoot 'hdmi_packet_monitor.v'
$testbench = Join-Path $taskRoot 'tb_hdmi_packet_monitor.v'
$output = Join-Path $taskRoot 'results/tb_hdmi_packet_monitor.vvp'
$compileLog = Join-Path $taskRoot 'results/compile.log'
$simulationLog = Join-Path $taskRoot 'results/simulation.log'
& $iverilog -g2012 -Wall -s tb_hdmi_packet_monitor -o $output $source $testbench *> $compileLog
if ($LASTEXITCODE -ne 0) { throw "Icarus compile failed: $LASTEXITCODE (see $compileLog)" }
& $vvp $output *> $simulationLog
if ($LASTEXITCODE -ne 0) { throw "Icarus simulation failed: $LASTEXITCODE (see $simulationLog)" }
Get-Content -Raw $simulationLog
