$ErrorActionPreference = 'Stop'

$root = $PSScriptRoot
$rtl = Join-Path $root 'rtl'
$runName = "native_{0}" -f (Get-Date -Format 'yyyyMMdd_HHmmss')
$runDir = Join-Path (Join-Path $root 'runs') $runName
$iverilog = (Get-Command iverilog.exe -ErrorAction SilentlyContinue).Source
$vvp = (Get-Command vvp.exe -ErrorAction SilentlyContinue).Source
if (-not $iverilog) {
    $bin = Join-Path $env:USERPROFILE '.cursor\extensions\iccoderagenticverilogplatform.iccoder-2.0.9\tools\iverilog\win\bin'
    $iverilog = Join-Path $bin 'iverilog.exe'
    $vvp = Join-Path $bin 'vvp.exe'
}
if (-not (Test-Path -LiteralPath $iverilog) -or -not (Test-Path -LiteralPath $vvp)) {
    throw 'Native Icarus Verilog executables were not found.'
}

New-Item -ItemType Directory -Path $runDir -Force | Out-Null
$sources = @(
    (Join-Path $rtl 'player_video_schedule.v'),
    (Join-Path $rtl 'player_osd_state.v'),
    (Join-Path $root 'schedule_osd_tb.v')
)
$sourceHashes = @{}
foreach ($source in $sources) {
    $sourceHashes[[IO.Path]::GetFileName($source)] = (Get-FileHash -Algorithm SHA256 -LiteralPath $source).Hash.ToLowerInvariant()
}

$simulator = (& $iverilog -V 2>&1 | Select-Object -First 1).ToString()
$outputPath = Join-Path $runDir 'schedule_osd_tb.vvp'
$compileOutput = & $iverilog -g2005 -s schedule_osd_tb -o $outputPath @sources 2>&1
if ($LASTEXITCODE -ne 0) {
    $compileOutput | Set-Content -LiteralPath (Join-Path $runDir 'compile.log') -Encoding utf8
    throw "Icarus compilation failed with exit code $LASTEXITCODE"
}

$simulationOutput = & $vvp $outputPath 2>&1
$simulationExit = $LASTEXITCODE
$simulationText = ($simulationOutput | ForEach-Object { $_.ToString() }) -join "`r`n"
$simulationText | Set-Content -LiteralPath (Join-Path $runDir 'simulation.log') -Encoding utf8
$passed = $simulationExit -eq 0 -and $simulationText.Contains('SCHEDULE_OSD_PASS')
$result = [ordered]@{
    status = if ($passed) { 'PASS' } else { 'FAIL' }
    command = 'pwsh -NoProfile -File development/video19_work/schedule_unit/run_native.ps1'
    simulator = $simulator
    generation = '2005'
    sources = $sourceHashes
    formal_audio_frames = 602
    samples_per_audio_frame = 3200
    reset_restart = 'one reset between two 301-frame phases'
    expected = '602 formal frames, one late injection, one paused first frame, 604 display reads'
    exit_code = $simulationExit
    output = $simulationText.Trim()
}
$result | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $runDir 'result.json') -Encoding utf8
Write-Output $simulationText
Write-Output "RESULT=$($result.status) RUN_DIR=$runDir"
if (-not $passed) { exit 1 }
