param(
    [Parameter(Mandatory)][string]$Fixture,
    [ValidateSet('baseline_C03','candidate_C03','A08')][string]$Variant = 'candidate_C03',
    [int]$Mode = 0,
    [int]$Gap = 0,
    [int]$Seed = 324508639,
    [int]$AbortBytes = 0,
    [int]$HoldLastCycles = 0,
    [int]$Width = 640,
    [int]$Height = 480
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '../../../../scripts/anlu_tools.ps1')

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '../../../..')).Path
$fixturePath = (Resolve-Path -LiteralPath $Fixture).Path
$pipelineRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$sourceDir = switch ($Variant) {
    'baseline_C03' { Join-Path $pipelineRoot 'candidate_src/C03' }
    'candidate_C03' { Join-Path $pipelineRoot 'candidate_src/C03' }
    'A08' { Join-Path $pipelineRoot 'candidate_src/A08' }
}
$runTag = '{0}_{1}_{2}_{3}_{4}_{5}' -f $Variant, [IO.Path]::GetFileNameWithoutExtension($fixturePath), $Mode, $Gap, $AbortBytes, (Get-Date -Format 'yyyyMMdd_HHmmss_fff')
$runDir = Join-Path $PSScriptRoot "runs/$runTag"
New-Item -ItemType Directory -Path $runDir -Force | Out-Null
$iverilog = Resolve-AnluTool -Name 'iverilog'
$vvp = Resolve-AnluTool -Name 'vvp'
$image = Join-Path $runDir 'jpeg_core.vvp'
$pixels = Join-Path $runDir 'pixels_xy_rgb.bin'
$result = Join-Path $runDir 'result.log'
$console = Join-Path $runDir 'console.log'
$compileLog = Join-Path $runDir 'compile.log'
$testbench = Join-Path $pipelineRoot 'tb_jpeg_core.sv'
$sources = @(Get-ChildItem -LiteralPath $sourceDir -Filter '*.v' | Sort-Object Name | ForEach-Object FullName)
if ($Variant -eq 'baseline_C03') {
    $sources = @($sources | Where-Object { [IO.Path]::GetFileName($_) -ne 'jpeg_output.v' })
    $sources += Join-Path $PSScriptRoot 'jpeg_output_C03_before_pipeline.v'
}
$sourceSnapshot = Join-Path $runDir 'source_snapshot'
New-Item -ItemType Directory -Path $sourceSnapshot -Force | Out-Null
$snapshotSources = @()
foreach ($source in $sources) {
    $destination = Join-Path $sourceSnapshot ([IO.Path]::GetFileName($source))
    Copy-Item -LiteralPath $source -Destination $destination
    $snapshotSources += $destination
}
$snapshotTb = Join-Path $sourceSnapshot 'tb_jpeg_core.sv'
Copy-Item -LiteralPath $testbench -Destination $snapshotTb
$sourceRecords = @($snapshotSources | ForEach-Object {
    [pscustomobject]@{ name = [IO.Path]::GetFileName($_); sha256 = (Get-FileHash -LiteralPath $_ -Algorithm SHA256).Hash }
})
$manifest = [ordered]@{
    variant = $Variant
    fixture = [ordered]@{ path = $fixturePath; sha256 = (Get-FileHash -LiteralPath $fixturePath -Algorithm SHA256).Hash }
    parameters = [ordered]@{ mode = $Mode; gap = $Gap; seed = $Seed; abort_bytes = $AbortBytes; hold_last_cycles = $HoldLastCycles; width = $Width; height = $Height }
    run_started = (Get-Date).ToString('o')
    source_sha256 = $sourceRecords
    testbench = [ordered]@{ name = 'tb_jpeg_core.sv'; sha256 = (Get-FileHash -LiteralPath $snapshotTb -Algorithm SHA256).Hash }
    iverilog = [ordered]@{ path = $iverilog; version = ((& $iverilog -V 2>&1 | Select-Object -First 1) -join '') }
    vvp_path = $vvp
    compile_exit_code = $null
    simulation_exit_code = $null
    compiled_image_sha256 = $null
    compile_log_sha256 = $null
    output_sha256 = $null
}
($manifest | ConvertTo-Json -Depth 8) | Set-Content -LiteralPath (Join-Path $runDir 'manifest.json') -Encoding utf8

& $iverilog -g2012 -s tb_jpeg_core -o $image $snapshotTb $snapshotSources *> $compileLog
$manifest.compile_exit_code = $LASTEXITCODE
$manifest.compile_log_sha256 = (Get-FileHash -LiteralPath $compileLog -Algorithm SHA256).Hash
if ($LASTEXITCODE -ne 0) {
    ($manifest | ConvertTo-Json -Depth 8) | Set-Content -LiteralPath (Join-Path $runDir 'manifest.json') -Encoding utf8
    throw "iverilog failed ($LASTEXITCODE); see $compileLog"
}
$manifest.compiled_image_sha256 = (Get-FileHash -LiteralPath $image -Algorithm SHA256).Hash
Push-Location $runDir
try {
    & $vvp $image "+JPEG=$($fixturePath.Replace('\','/'))" '+OUT=pixels_xy_rgb.bin' '+LOG=result.log' `
        "+MODE=$Mode" "+GAP=$Gap" "+SEED=$Seed" "+FRAMES=1" `
        "+ABORT_BYTES=$AbortBytes" "+HOLD_LAST_CYCLES=$HoldLastCycles" `
        "+WIDTH=$Width" "+HEIGHT=$Height" *> $console
}
finally { Pop-Location }
$manifest.simulation_exit_code = $LASTEXITCODE
if ($LASTEXITCODE -eq 0) { $manifest.output_sha256 = (Get-FileHash -LiteralPath $pixels -Algorithm SHA256).Hash }
($manifest | ConvertTo-Json -Depth 8) | Set-Content -LiteralPath (Join-Path $runDir 'manifest.json') -Encoding utf8
if ($LASTEXITCODE -ne 0) { throw "vvp failed ($LASTEXITCODE); see $console" }
Get-Content -LiteralPath $console
Get-FileHash -LiteralPath $pixels -Algorithm SHA256 | Select-Object Path,Hash
