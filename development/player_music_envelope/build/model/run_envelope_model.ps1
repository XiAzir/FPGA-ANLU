param(
    [int]$AvgLog2 = 8,
    [int]$FrameCycles = 420000,
    [int]$ClkFreqHz = 25000000,
    [int]$ValidRateHz = 48000,
    [switch]$CompileOnly
)
$ErrorActionPreference = 'Stop'
$modelDir = $PSScriptRoot
$projectDir = (Resolve-Path (Join-Path $modelDir '../../../..')).Path
$rtl = Join-Path $projectDir 'development/player_music_envelope/src/user_source/hdl_source/player_pcm_waveform.v'
$spec = Join-Path $projectDir 'development/player_music_envelope/build/envelope_spec.md'
$tb = Join-Path $modelDir 'tb_music_envelope.v'
$iverilog = Join-Path $projectDir 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe'
$vvp = Join-Path $projectDir 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe'
foreach ($path in @($rtl,$spec,$tb,$iverilog,$vvp)) {
    if (-not (Test-Path -LiteralPath $path)) { throw "Missing required file: $path" }
}
$tag = Get-Date -Format 'yyyyMMdd_HHmmss'
$outPrefix = "envelope_$tag"
$referencePath = Join-Path $modelDir "${outPrefix}_reference_history.txt"
$expectedPath = Join-Path $modelDir "${outPrefix}_expected_512.txt"
$reportPath = Join-Path $modelDir "${outPrefix}_model_report.txt"
$sim = Join-Path $modelDir "envelope_sim_$tag.vvp"
$compileLog = Join-Path $modelDir "envelope_compile_$tag.log"
$runLog = Join-Path $modelDir "envelope_run_$tag.log"
$compileArgs = @('-g2012','-s','tb_music_envelope',"-Ptb_music_envelope.AVG_LOG2=$AvgLog2", "-Ptb_music_envelope.FRAME_CYCLES=$FrameCycles", "-Ptb_music_envelope.CLK_FREQ_HZ=$ClkFreqHz", "-Ptb_music_envelope.VALID_RATE_HZ=$ValidRateHz", '-o',$sim,$rtl,$tb)
& $iverilog @compileArgs 2>&1 | Tee-Object -FilePath $compileLog
$compileExit = $LASTEXITCODE
if (-not (Test-Path -LiteralPath $compileLog)) { Set-Content -LiteralPath $compileLog -Value '' -Encoding utf8 }
$runExit = $null
if ($compileExit -ne 0) {
    $status = 'COMPILE_FAIL'
} elseif ($CompileOnly) {
    $status = 'COMPILE_ONLY'
} else {
    Push-Location $modelDir
    try { & $vvp $sim "+OUT_PREFIX=$outPrefix" 2>&1 | Tee-Object -FilePath $runLog; $runExit = $LASTEXITCODE }
    finally { Pop-Location }
    if ($runExit -ne 0) { $status = 'FAIL' } else { $status = 'PASS' }
}
$files = [ordered]@{}
foreach ($entry in @(@('spec',$spec),@('rtl',$rtl),@('testbench',$tb),@('runner',$PSCommandPath),@('compile_log',$compileLog))) {
    $files[$entry[0]] = [ordered]@{ path=$entry[1]; sha256=(Get-FileHash -Algorithm SHA256 -LiteralPath $entry[1]).Hash }
}
if (Test-Path -LiteralPath $runLog) { $files['run_log']=[ordered]@{path=$runLog;sha256=(Get-FileHash -Algorithm SHA256 -LiteralPath $runLog).Hash} }
foreach ($path in @($reportPath,$referencePath,$expectedPath)) {
    if (Test-Path -LiteralPath $path) { $files[[IO.Path]::GetFileName($path)]=[ordered]@{path=$path;sha256=(Get-FileHash -Algorithm SHA256 -LiteralPath $path).Hash} }
}
$manifest = [ordered]@{
    task='C11302 independent integer envelope reference and RTL pixel comparison'
    status=$status
    compile_exit=$compileExit
    run_exit=$runExit
    avg_log2=$AvgLog2
    avg_samples_per_event=(1 -shl $AvgLog2)
    frame_cycles=$FrameCycles
    clk_freq_hz=$ClkFreqHz
    valid_rate_hz=$ValidRateHz
    nominal_frame_cycles=420000
    nominal_128_frame_coverage=($FrameCycles -eq 420000)
    simulator=[ordered]@{iverilog=$iverilog;vvp=$vvp}
    files=$files
    note='RTL simulation evidence only; no synthesis, HDMI link, or board test.'
}
$manifestPath=Join-Path $modelDir "envelope_binding_$tag.json"
$manifest | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $manifestPath -Encoding utf8
Write-Output "status=$status"
Write-Output "binding=$manifestPath"
if ($status -in @('FAIL','COMPILE_FAIL')) { exit 1 }
