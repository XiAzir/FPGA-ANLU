$ErrorActionPreference = 'Stop'
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
$iverilog = Join-Path $projectRoot 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\iverilog.exe'
$vvp = Join-Path $projectRoot 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\vvp.exe'
$source = Join-Path $projectRoot 'development\player_fat32\src\user_source\hdl_source\player_debug_overlay.v'
$testbench = Join-Path $projectRoot 'development\player_fat32\sim\tb_player_debug_overlay.v'
$outDir = Join-Path $projectRoot 'development\player_fat32\build\fat_sim'
$image = Join-Path $outDir 'player_debug_overlay.vvp'
$log = Join-Path $outDir 'player_debug_overlay.log'

New-Item -ItemType Directory -Force -Path $outDir | Out-Null
& $iverilog -g2005 -Wall -s tb_player_debug_overlay -o $image $testbench $source 2>&1 |
    Tee-Object -FilePath $log
if ($LASTEXITCODE -ne 0) { throw "iverilog failed with exit code $LASTEXITCODE" }
& $vvp $image 2>&1 | Tee-Object -FilePath $log -Append
if ($LASTEXITCODE -ne 0) { throw "vvp failed with exit code $LASTEXITCODE" }
if (-not (Select-String -Path $log -SimpleMatch 'PASS: debug overlay glyph, sync passthrough, RGB passthrough, and frame reset checks passed' -Quiet)) {
    throw "Debug overlay self-check did not report PASS; see $log"
}
