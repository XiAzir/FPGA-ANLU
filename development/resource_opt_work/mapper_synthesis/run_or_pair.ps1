$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '../../..')).Path
$source = Join-Path $projectRoot 'development/player_spectrum_trace/src/user_source/hdl_source/fat32_file_sector.v'
$output = Join-Path $PSScriptRoot 'or_ablation'
python (Join-Path $PSScriptRoot 'prepare_or_pair.py') $source $output
if ($LASTEXITCODE -ne 0) { throw "prepare_or_pair.py failed: $LASTEXITCODE" }
$td = Resolve-AnluTool 'td_commands_prompt'
$iverilog = Resolve-AnluTool 'iverilog'
$vvp = Resolve-AnluTool 'vvp'
$summary = [System.Collections.Generic.List[object]]::new()
foreach ($variant in @('combined', 'combined_or')) {
    $folder = Join-Path $output $variant
    $console = Join-Path $folder 'console.log'
    Push-Location $folder
    try {
        & $td ((Join-Path $folder 'run_syn.tcl').Replace('\','/')) *> $console
        $exitCode = $LASTEXITCODE
    } finally { Pop-Location }
    $area = Join-Path $folder 'reports/gate.area'
    $complete = Test-Path -LiteralPath $area -PathType Leaf
    $marker = Select-String -LiteralPath $console -SimpleMatch 'SYNTHESIS_COMPLETE' -Quiet
    $summary.Add([pscustomobject]@{
        variant=$variant; exit_code=$exitCode; synthesis_marker=[bool]$marker; area_report=[bool]$complete;
        hdl_sha256=(Get-FileHash -LiteralPath (Join-Path $folder 'fat32_file_sector.v')).Hash
    })
    if ($exitCode -ne 0 -or !$marker -or !$complete) { throw "TD synthesis failed for $variant; inspect $console" }
    $tb = Join-Path $PSScriptRoot '..\tb_mapper_edges.v'
    $sourceText = (Get-Content -LiteralPath $tb -Raw).Replace('module tb_mapper_edges;', 'module tb_mapper_or_edges;').Replace('fat32_file_sector_proposal #(', "fat32_file_sector_$variant #(")
    $variantRef = Join-Path $output 'reference.v'
    if (!(Test-Path -LiteralPath $variantRef)) {
        $baseText = (Get-Content -LiteralPath $source -Raw).Replace('module fat32_file_sector #(', 'module fat32_file_sector_reference #(')
        Set-Content -LiteralPath $variantRef -Value $baseText -Encoding utf8
    }
    $tbPath = Join-Path $output "tb_mapper_or_edges_$variant.v"
    Set-Content -LiteralPath $tbPath -Value $sourceText -Encoding utf8
    $simSource = Join-Path $output "fat32_file_sector_$variant.v"
    $candidateText = (Get-Content -LiteralPath (Join-Path $folder 'fat32_file_sector.v') -Raw).Replace('module fat32_file_sector #(', "module fat32_file_sector_$variant #(")
    Set-Content -LiteralPath $simSource -Value $candidateText -Encoding utf8
    $image = Join-Path $output "tb_mapper_or_edges_$variant.vvp"
    & $iverilog -g2001 -Wall -s tb_mapper_or_edges -o $image $variantRef $simSource $tbPath *> (Join-Path $output "tb_mapper_or_edges_$variant`_compile.log")
    if ($LASTEXITCODE -ne 0) { throw "Icarus compile failed for $variant" }
    & $vvp $image *> (Join-Path $output "tb_mapper_or_edges_$variant`_run.log")
    if ($LASTEXITCODE -ne 0) { throw "Icarus run failed for $variant" }
}
$summary | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $output 'synthesis_status.json') -Encoding utf8
python (Join-Path $PSScriptRoot 'summarize_or_pair.py')
if ($LASTEXITCODE -ne 0) { throw "summarize_or_pair.py failed: $LASTEXITCODE" }
Write-Output "PASS: combined and combined_or TD synthesis completed sequentially; Icarus edge logs are in $output"
