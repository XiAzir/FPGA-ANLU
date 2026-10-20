. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$ErrorActionPreference='Stop'
$task=Split-Path -Parent $PSScriptRoot
$project=Split-Path -Parent (Split-Path -Parent $task)
$hdl=Join-Path $task 'src/user_source/hdl_source'
$model=Join-Path $task 'build/model'
New-Item -ItemType Directory -Force $model | Out-Null
$iv=(Resolve-AnluTool -Name 'iverilog')
$vvp=(Resolve-AnluTool -Name 'vvp')
$exe=Join-Path $model 'spectrum_diag.vvp'
Push-Location $hdl
try {
    # A clean Icarus compile may produce no stdout; retain the empty capture file.
    [IO.File]::WriteAllText((Join-Path $model 'spectrum_diag_compile.log'),'')
    & $iv -g2012 -DPRIVATE_ROM_BEHAVIORAL_SIM -I $hdl -s tb_spectrum_diag -o $exe (Join-Path $PSScriptRoot 'tb_spectrum_diag.v') (Join-Path $hdl 'player_pcm_waveform.v') (Join-Path $hdl 'player_spectrum_analyzer.v') (Join-Path $hdl 'spectrum_coeff_rom.v') 2>&1 | Tee-Object (Join-Path $model 'spectrum_diag_compile.log')
    if($LASTEXITCODE -ne 0){throw 'Spectrum telemetry compile failed'}
    & $vvp $exe 2>&1 | Tee-Object (Join-Path $model 'spectrum_diag_run.log')
    if($LASTEXITCODE -ne 0){throw 'Spectrum telemetry simulation failed'}
    Add-Content -LiteralPath (Join-Path $model 'spectrum_diag_run.log') -Value 'NOTE: accelerated telemetry TB set FFT_TIMEOUT_SAMPLES=0; production timeout is covered by tb_fft_recover.'
} finally {Pop-Location}
