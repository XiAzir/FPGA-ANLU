. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$python = Resolve-AnluPython
$pythonPrefix = @()
if ([IO.Path]::GetFileNameWithoutExtension($python) -ieq 'py') { $pythonPrefix = @('-3') }
$ErrorActionPreference='Stop'
$project = $AnluRepositoryRoot
$task=Join-Path $project 'development\player_spectrum_resource_fit'
$sim=Join-Path $task 'sim'
$model=Join-Path $task 'build\model'
$hdl=Join-Path $task 'src\user_source\hdl_source'
$td=Join-Path $task 'src\td_project'
$oracle=Join-Path $sim 'spectrum_oracle.py'
$tb=Join-Path $sim 'tb_player_spectrum_analyzer.v'
$rtl=Join-Path $hdl 'player_spectrum_analyzer.v'
$iverilog=(Resolve-AnluTool -Name 'iverilog')
$vvp=(Resolve-AnluTool -Name 'vvp')
$vec=Join-Path $sim 'vectors'
foreach($file in @($oracle,$tb,$rtl,$iverilog,$vvp,(Join-Path $hdl 'spectrum_hann.mem'),(Join-Path $hdl 'spectrum_twiddle.mem'))) { if(!(Test-Path -LiteralPath $file)){throw "Missing required file: $file"} }
New-Item -ItemType Directory -Force -Path $model | Out-Null
& $python @pythonPrefix $oracle --emit | Set-Content -LiteralPath (Join-Path $model 'oracle_run.json') -Encoding utf8
if($LASTEXITCODE -ne 0){throw 'oracle failed'}
$tag=Get-Date -Format 'yyyyMMdd_HHmmss'
$exe=Join-Path $model "spectrum_sim_$tag.vvp"
$compileLog=Join-Path $model "spectrum_compile_$tag.log"
$runLog=Join-Path $model "spectrum_run_$tag.log"
Set-Content -LiteralPath $compileLog -Value '' -Encoding ascii
Push-Location $hdl
try {
  $compileOutput=& $iverilog -g2012 -DPRIVATE_ROM_BEHAVIORAL_SIM -I $hdl -s tb_player_spectrum_analyzer -o $exe $tb $rtl (Join-Path $hdl "spectrum_coeff_rom.v") 2>&1
  $compileOutput | Tee-Object -FilePath $compileLog
  if($compileOutput -match '(?i)\b(warning|error):'){throw 'Icarus compile warning/error'}
  if($LASTEXITCODE -ne 0){throw "iverilog failed: $LASTEXITCODE"}
  $runOutput=& $vvp $exe "+VEC=$(Join-Path $vec 'all_samples.mem')" "+EXP=$(Join-Path $vec 'all_expected.mem')" 2>&1
  $runOutput | Tee-Object -FilePath $runLog
  if($runOutput -match '(?i)\b(ERROR|WARNING)\b'){throw 'simulator reported ERROR/WARNING'}
  if($LASTEXITCODE -ne 0){throw "vvp failed: $LASTEXITCODE"}
} finally { Pop-Location }
$rtlHash=(Get-FileHash -Algorithm SHA256 -LiteralPath $rtl).Hash.ToLower()
$tbHash=(Get-FileHash -Algorithm SHA256 -LiteralPath $tb).Hash.ToLower()
$oracleHash=(Get-FileHash -Algorithm SHA256 -LiteralPath $oracle).Hash.ToLower()
$hanningHash=(Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $hdl 'spectrum_hann.mem')).Hash.ToLower()
$twiddleHash=(Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $hdl 'spectrum_twiddle.mem')).Hash.ToLower()
@"
PASS: mathematical oracle assertions and Icarus testbench completed.
Fast mathematical capture explicitly sets FRAME_TIMEOUT_SAMPLES=0; this run does not verify the production 4096-sample watchdog.
Test scope: 13 production-sized 1024-sample vectors (accelerated capture), plus one full-rate 521-clock frame (48 kHz at 25 MHz); full 1024-point RTL analysis uses 55,320 cycles per frame.
Cases: low/mid/high exact-bin tones, half-amplitude relation, two tones, silence, positive DC, positive/negative fullscale DC, phase-pi/4 fullscale sine, alternating Nyquist extremes, centered impulse, fixed-seed wideband random.
Additional checks: continuous consecutive frames, source_change abort during partial capture and during analysis, reset during analysis.
Checks: independent direct DFT and integer FFT reference; all 1024 Hann and 512 twiddle ROM words against formulas; 24 ordered bands per frame against fixed-point reference (bit exact; max absolute error 0); frame_done alignment; silence zero; DC bin omitted with Hann leakage predicted; tone peak bands; two-tone response; amplitude scaling; direct DFT quantization error asserted <=16 for every vector.
Simulator: $iverilog; compile log $compileLog; run log $runLog.
SHA256 analyzer=$rtlHash
testbench=$tbHash
oracle=$oracleHash
hann_rom=$hanningHash
twiddle_rom=$twiddleHash
Hardware validation: not performed by this simulation.
"@ | Set-Content -LiteralPath (Join-Path $model "spectrum_evidence_$tag.txt") -Encoding utf8
Get-Content -LiteralPath $runLog
Get-Content -LiteralPath (Join-Path $model "spectrum_evidence_$tag.txt")









