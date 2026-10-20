$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
$iverilog = (Resolve-AnluTool 'iverilog')
$vvp = (Resolve-AnluTool 'vvp')
$source = Join-Path $projectRoot 'development\player_fat32\src\user_source\hdl_source\tf_wav_file_player.v'
$testbench = Join-Path $projectRoot 'development\player_fat32\sim\tb_wav_file_player.v'
$outDir = Join-Path $projectRoot 'development\player_fat32\build\fat_sim'
$image = Join-Path $outDir 'wav_file_player.vvp'
$log = Join-Path $outDir 'wav_file_player.log'

New-Item -ItemType Directory -Force -Path $outDir | Out-Null
& $iverilog -g2005 -Wall -s tb_wav_file_player -o $image $testbench $source 2>&1 |
    Tee-Object -FilePath $log
if ($LASTEXITCODE -ne 0) { throw "iverilog failed with exit code $LASTEXITCODE" }
& $vvp $image 2>&1 | Tee-Object -FilePath $log -Append
if ($LASTEXITCODE -ne 0) { throw "vvp failed with exit code $LASTEXITCODE" }
if (-not (Select-String -Path $log -SimpleMatch 'PASS: all WAV file player self-checks passed' -Quiet)) {
    throw "WAV file player self-check did not report PASS; see $log"
}
