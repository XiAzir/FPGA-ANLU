$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '../../scripts/anlu_tools.ps1')
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$build = Join-Path $PSScriptRoot 'build/mapper_proposal'
$null = New-Item -ItemType Directory -Force -Path $build
$source = Join-Path $projectRoot 'development/player_spectrum_trace/src/user_source/hdl_source/fat32_file_sector.v'
$reference = Join-Path $build 'fat32_file_sector_reference.v'
python (Join-Path $PSScriptRoot 'prepare_mapper_variants.py') $source $build

$iverilog = Resolve-AnluTool 'iverilog'
$vvp = Resolve-AnluTool 'vvp'
foreach ($variant in @('algorithm', 'address', 'index', 'combined')) {
    $proposal = Join-Path $build "fat32_file_sector_$variant.v"
    $edgeTest = Join-Path $build "tb_mapper_edges_$variant.v"
    $edgeText = (Get-Content -LiteralPath (Join-Path $PSScriptRoot 'tb_mapper_edges.v') -Raw).
        Replace('module tb_mapper_edges;', "module tb_mapper_edges_$variant;").
        Replace('fat32_file_sector_proposal #(', "fat32_file_sector_$variant #(")
    Set-Content -LiteralPath $edgeTest -Value $edgeText -Encoding utf8
    $cases = @(@{ name="tb_mapper_edges_$variant"; test=$edgeTest })
    if ($variant -eq 'combined') {
        $longTest = Join-Path $build 'tb_mapper_long_equiv_combined.v'
        $longText = (Get-Content -LiteralPath (Join-Path $PSScriptRoot 'tb_mapper_long_equiv.v') -Raw).
            Replace('module tb_mapper_long_equiv;', 'module tb_mapper_long_equiv_combined;').
            Replace('fat32_file_sector_proposal #(', 'fat32_file_sector_combined #(')
        Set-Content -LiteralPath $longTest -Value $longText -Encoding utf8
        $cases += @{ name='tb_mapper_long_equiv_combined'; test=$longTest }
    }
    foreach ($case in $cases) {
        $image = Join-Path $build ($case.name + '.vvp')
        $compileLog = Join-Path $build ($case.name + '_compile.log')
        $runLog = Join-Path $build ($case.name + '_run.log')
        & $iverilog -g2001 -Wall -s $case.name -o $image $reference $proposal $case.test 2>&1 | Tee-Object -FilePath $compileLog
        if ($LASTEXITCODE -ne 0) { throw "iverilog failed for $($case.name): $LASTEXITCODE" }
        & $vvp $image 2>&1 | Tee-Object -FilePath $runLog
        if ($LASTEXITCODE -ne 0) { throw "vvp failed for $($case.name): $LASTEXITCODE" }
    }
}
Write-Output "PASS: all independent and combined mapper variants passed; sources and logs are in $build"
