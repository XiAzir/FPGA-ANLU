$ErrorActionPreference = 'Stop'
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..\..')).Path
$hdl = Join-Path $projectRoot 'development\player_image_adjust\src\user_source\hdl_source'
$modelDir = $PSScriptRoot
$iverilog = Join-Path $projectRoot 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\iverilog.exe'
$vvp = Join-Path $projectRoot 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\vvp.exe'

if (!(Test-Path -LiteralPath $iverilog)) { throw "iverilog not found: $iverilog" }
if (!(Test-Path -LiteralPath $vvp)) { throw "vvp not found: $vvp" }

$cases = @(
    @{ Name = 'tb_player_rgb_adjust'; Sources = @('player_rgb_adjust.v') },
    @{ Name = 'tb_player_adjust_control'; Sources = @('player_adjust_control.v', 'SD\sd_card_bmp.v') }
)

foreach ($case in $cases) {
    $image = Join-Path $modelDir ($case.Name + '.vvp')
    $log = Join-Path $modelDir ($case.Name + '.log')
    $compileLog = Join-Path $modelDir ($case.Name + '.compile.log')
    $sourcePaths = @($case.Sources | ForEach-Object { Join-Path $hdl $_ }) + @((Join-Path $modelDir ($case.Name + '.v')))
    & $iverilog -g2012 -Wall -s $case.Name -o $image @sourcePaths *> $compileLog
    if ($LASTEXITCODE -ne 0) { throw "iverilog failed for $($case.Name); see $compileLog" }
    & $vvp $image *> $log
    if ($LASTEXITCODE -ne 0) { throw "simulation failed for $($case.Name); see $log" }
    Get-Content -Raw $compileLog
    Get-Content -Raw $log
}
