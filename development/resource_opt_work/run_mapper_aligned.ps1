$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '../../scripts/anlu_tools.ps1')
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$build = Join-Path $PSScriptRoot 'build/mapper_aligned'
$source = Join-Path $projectRoot 'development/player_spectrum_trace/src/user_source/hdl_source/fat32_file_sector.v'
python (Join-Path $PSScriptRoot 'prepare_mapper_aligned.py') $source $build
if ($LASTEXITCODE -ne 0) { throw "prepare_mapper_aligned.py failed: $LASTEXITCODE" }
$iverilog = Resolve-AnluTool 'iverilog'
$vvp = Resolve-AnluTool 'vvp'
$reference = Join-Path $build 'fat32_file_sector_reference.v'
$aligned = Join-Path $build 'fat32_file_sector_aligned.v'
foreach ($top in @('tb_mapper_aligned_edges', 'tb_mapper_aligned_long')) {
    $image = Join-Path $build "$top.vvp"
    $compileLog = Join-Path $build "${top}_compile.log"
    $runLog = Join-Path $build "${top}_run.log"
    & $iverilog -g2001 -Wall -s $top -o $image $reference $aligned (Join-Path $build "$top.v") 2>&1 | Tee-Object -FilePath $compileLog
    if ($LASTEXITCODE -ne 0) { throw "iverilog failed for $top : $LASTEXITCODE" }
    & $vvp $image 2>&1 | Tee-Object -FilePath $runLog
    if ($LASTEXITCODE -ne 0) { throw "vvp failed for $top : $LASTEXITCODE" }
}
Write-Output "PASS: aligned-OR proposal differential fixtures completed in $build"
