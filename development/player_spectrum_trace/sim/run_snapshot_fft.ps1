. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$projectRoot=(Resolve-Path (Join-Path $taskRoot '../..')).Path
$iverilog=(Resolve-AnluTool -Name 'iverilog')
$vvp=(Resolve-AnluTool -Name 'vvp')
$hdl=Join-Path $taskRoot 'src/user_source/hdl_source'
$model=Join-Path $taskRoot 'build/model/snapshot_fft'
New-Item -ItemType Directory -Force $model | Out-Null
$exe=Join-Path $model test.vvp
& $iverilog -g2012 -DPRIVATE_ROM_BEHAVIORAL_SIM -I $hdl -s tb_fault_snapshot_fft -o $exe (Join-Path $PSScriptRoot tb_fault_snapshot_fft.v) (Join-Path $hdl player_fault_snapshot.v) (Join-Path $hdl player_spectrum_analyzer.v) (Join-Path $hdl player_pcm_waveform.v) (Join-Path $hdl spectrum_coeff_rom.v) *> (Join-Path $model compile.log)
if($LASTEXITCODE){throw 'snapshot FFT integration compile failed'}
Push-Location $hdl
try { & $vvp $exe "+VEC=$PSScriptRoot/vectors/all_samples.mem" "+EXP=$PSScriptRoot/vectors/all_expected.mem" *> (Join-Path $model run.log) }
finally { Pop-Location }
if($LASTEXITCODE){Get-Content (Join-Path $model run.log);throw 'snapshot FFT integration failed'}
Get-Content (Join-Path $model run.log)
