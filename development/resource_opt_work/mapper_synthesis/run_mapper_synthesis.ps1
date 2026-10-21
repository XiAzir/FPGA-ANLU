$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$workRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$outputRoot = $PSScriptRoot
$source = Join-Path $workRoot '../player_spectrum_trace/src/user_source/hdl_source/fat32_file_sector.v'
$source = (Resolve-Path -LiteralPath $source).Path
$null = New-Item -ItemType Directory -Force -Path (Join-Path $outputRoot 'runs')
python (Join-Path $PSScriptRoot 'prepare_variants.py') $source (Join-Path $outputRoot 'runs') $workRoot
if ($LASTEXITCODE -ne 0) { throw "prepare_variants.py failed: $LASTEXITCODE" }

$td = Resolve-AnluTool 'td_commands_prompt'
$summary = [System.Collections.Generic.List[object]]::new()
foreach ($variant in @('reference', 'algorithm_only', 'address_only', 'index_only', 'combined')) {
    $folder = Join-Path $outputRoot "runs/$variant"
    $console = Join-Path $folder 'console.log'
    $script = (Join-Path $folder 'run_syn.tcl').Replace('\','/')
    Push-Location $folder
    try {
        & $td $script *> $console
        $exitCode = $LASTEXITCODE
    } finally {
        Pop-Location
    }
    $area = Join-Path $folder 'reports/gate.area'
    $complete = Test-Path -LiteralPath $area -PathType Leaf
    $marker = Select-String -LiteralPath $console -SimpleMatch 'SYNTHESIS_COMPLETE' -Quiet
    $summary.Add([pscustomobject]@{
        variant = $variant
        exit_code = $exitCode
        synthesis_marker = [bool]$marker
        area_report = [bool]$complete
        hdl_sha256 = (Get-FileHash -LiteralPath (Join-Path $folder 'fat32_file_sector.v')).Hash
    })
    if ($exitCode -ne 0 -or !$marker -or !$complete) {
        $summary | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $outputRoot 'runs/synthesis_status.json') -Encoding utf8
        throw "TD synthesis failed for $variant; inspect $console"
    }
}
$summary | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $outputRoot 'runs/synthesis_status.json') -Encoding utf8
python (Join-Path $PSScriptRoot 'summarize_synthesis.py')
if ($LASTEXITCODE -ne 0) { throw "summarize_synthesis.py failed: $LASTEXITCODE" }
Write-Output "PASS: five standalone TD syn runs completed sequentially under $outputRoot/runs"
