param([Parameter(Mandatory)][string]$CandidateProjectRoot)
$ErrorActionPreference = 'Stop'
$ModelDir = (Resolve-Path $PSScriptRoot).Path
$ProjectRoot = (Resolve-Path $CandidateProjectRoot).Path
. (Join-Path $PSScriptRoot 'anlu_tools.ps1')
$Iverilog = (Resolve-AnluTool 'iverilog')
$Vvp = (Resolve-AnluTool 'vvp')
$Hdl = Join-Path $ProjectRoot 'development\player_bmp_scale\src\user_source\hdl_source'
$LogDir = Join-Path $ModelDir 'logs'
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
$Log = Join-Path $LogDir 'engine_smoke.log'
$VvpFile = Join-Path $ModelDir 'engine_smoke.vvp'
$CompileOutput = & $Iverilog -g2012 -s tb_engine_smoke -o $VvpFile `
    (Join-Path $Hdl 'bmp_scale_engine.v') (Join-Path $ModelDir 'tb_engine_smoke.v') 2>&1
$CompileCode = $LASTEXITCODE
$RunOutput = @()
$RunCode = -1
if ($CompileCode -eq 0) {
    $RunOutput = & $Vvp $VvpFile 2>&1
    $RunCode = $LASTEXITCODE
}
$Evidence = @(
    "Icarus: $Iverilog",
    "Compile exit: $CompileCode",
    $CompileOutput,
    "Run exit: $RunCode",
    $RunOutput
)
$Evidence | Out-File -LiteralPath $Log -Encoding utf8
Get-Content -LiteralPath $Log
if ($CompileCode -ne 0) { exit $CompileCode }
if ($RunCode -ne 0) { exit $RunCode }
