$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$iverilog = (Resolve-AnluTool 'iverilog')
$vvp = (Resolve-AnluTool 'vvp')
$hdl = Join-Path $projectRoot 'src\user_source\hdl_source'
$simOutput = Join-Path $projectRoot 'build\bmp_sim'
New-Item -ItemType Directory -Force -Path $simOutput | Out-Null
$sources = @(
    (Join-Path $hdl 'tf_bmp_file_player.v'),
    (Join-Path $projectRoot 'sim\tb_bmp_file_negative.v')
)
$compiled = Join-Path $simOutput 'bmp_file_negative.vvp'
$compileLog = Join-Path $simOutput 'bmp_file_negative_compile.log'
$runLog = Join-Path $simOutput 'bmp_file_negative.log'
& $iverilog -g2012 -Wall -s tb_bmp_file_negative -o $compiled @sources *> $compileLog
if ($LASTEXITCODE -ne 0) { Get-Content $compileLog; throw 'BMP simulation compilation failed' }
& $vvp $compiled *> $runLog
$runExit = $LASTEXITCODE
Get-Content $runLog
if ($runExit -ne 0 -or -not (Select-String -LiteralPath $runLog -Pattern '^PASS tb_bmp_file_negative' -Quiet)) {
    throw 'BMP simulation failed'
}
