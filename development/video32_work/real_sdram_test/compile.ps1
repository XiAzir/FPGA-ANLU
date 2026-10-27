$ErrorActionPreference = 'Stop'
$testDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = 'E:\VSCODE-project\FPGA-ANLU'
$sourceRoot = Join-Path $projectRoot 'development\player_video31_audio_ablation\src\user_source'
$modelsimBin = 'E:\ModelsimSE\win64'
$modelsimIni = Join-Path $testDir 'modelsim.ini'
$workLib = Join-Path $testDir 'work'

if (-not (Test-Path -LiteralPath $workLib)) {
    & (Join-Path $modelsimBin 'vlib.exe') $workLib
    if ($LASTEXITCODE -ne 0) { throw "vlib exit=$LASTEXITCODE" }
}
& (Join-Path $modelsimBin 'vmap.exe') -modelsimini $modelsimIni work $workLib
if ($LASTEXITCODE -ne 0) { throw "vmap exit=$LASTEXITCODE" }

Push-Location $sourceRoot
try {
    $inc = '+incdir+' + (Join-Path $sourceRoot 'hdl_source\include').Replace('\','/')
    & (Join-Path $modelsimBin 'vlog.exe') -sv -permissive -modelsimini $modelsimIni -work work $inc -f (Join-Path $testDir 'sources.f') -l (Join-Path $testDir 'compile_permissive.log')
    if ($LASTEXITCODE -ne 0) { throw "vlog exit=$LASTEXITCODE" }
} finally {
    Pop-Location
}
