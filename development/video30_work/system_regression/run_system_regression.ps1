[CmdletBinding()]
param(
    [switch]$Execute,
    [switch]$CompileOnly,
    [string]$Player,
    [string]$Card,
    [string]$Media
)
$ErrorActionPreference = 'Stop'
$repo = (Resolve-Path (Join-Path $PSScriptRoot '../../..')).Path
. (Join-Path $repo 'scripts/anlu_tools.ps1')
$python = Resolve-AnluPython
$pythonArgs = [System.Collections.Generic.List[string]]::new()
$pythonArgs.Add((Join-Path $PSScriptRoot 'run_system_regression.py'))
if ($Player) { $pythonArgs.Add('--player'); $pythonArgs.Add($Player) }
if ($Card) { $pythonArgs.Add('--card'); $pythonArgs.Add($Card) }
if ($Media) { $pythonArgs.Add('--media'); $pythonArgs.Add($Media) }
if (-not $Execute) { $pythonArgs.Add('--prepare-only') }
if ($CompileOnly) { $pythonArgs.Add('--compile-only') }
if ($Execute) {
    $modelSimBin = $env:ANLU_MODELSIM_BIN
    if (-not $modelSimBin) { $modelSimBin = 'E:/ModelsimSE/win64' }
    foreach ($tool in @('vlib.exe','vlog.exe','vsim.exe')) {
        if (-not (Test-Path -LiteralPath (Join-Path $modelSimBin $tool) -PathType Leaf)) {
            throw "ModelSim executable not found: $modelSimBin/$tool"
        }
    }
    $env:ANLU_MODELSIM_BIN = $modelSimBin
}
& $python @pythonArgs
exit $LASTEXITCODE
