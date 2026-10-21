. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$python = Resolve-AnluPython
$pythonPrefix = @()
if ([IO.Path]::GetFileNameWithoutExtension($python) -ieq 'py') { $pythonPrefix = @('-3') }
$ErrorActionPreference='Stop'
$project = $AnluRepositoryRoot
$task=Join-Path $project 'development\player_spectrum_resource_fit'
$sim=Join-Path $task 'sim';$model=Join-Path $task 'build\model'
$hdl=Join-Path $task 'src\user_source\hdl_source'
$tb=Join-Path $sim 'tb_spectrum_overlay_integration.v'
$rtl=Join-Path $hdl 'player_pcm_waveform.v';$analyzer=Join-Path $hdl 'player_spectrum_analyzer.v'
$iverilog=(Resolve-AnluTool -Name 'iverilog')
$vvp=(Resolve-AnluTool -Name 'vvp')
$vec=Join-Path $sim 'vectors';$obs=Join-Path $model 'spectrum_overlay_integration_observed.log'
$exe=Join-Path $model 'spectrum_overlay_integration.vvp'
$clog=Join-Path $model 'spectrum_overlay_integration_compile.log'
$rlog=Join-Path $model 'spectrum_overlay_integration_run.log'
foreach($f in @($tb,$rtl,$analyzer,$iverilog,$vvp)){if(!(Test-Path -LiteralPath $f)){throw "Missing $f"}}
& $python @pythonPrefix (Join-Path $sim 'spectrum_oracle.py') --emit | Set-Content -LiteralPath (Join-Path $model 'oracle_run.json') -Encoding utf8
if($LASTEXITCODE -ne 0){throw 'spectrum oracle failed'}
Set-Content -LiteralPath $clog -Value '' -Encoding ascii
Push-Location $hdl
try {
  $compileOutput=& $iverilog -g2012 -DPRIVATE_ROM_BEHAVIORAL_SIM -I $hdl -s tb_spectrum_overlay_integration -o $exe $tb $rtl $analyzer (Join-Path $hdl "spectrum_coeff_rom.v") 2>&1
  $compileOutput | Tee-Object -FilePath $clog
  if($compileOutput -match '(?i)\b(warning|error):'){throw 'Icarus compile warning/error'}
  if($LASTEXITCODE -ne 0){throw "iverilog failed: $LASTEXITCODE"}
  $runOutput=& $vvp $exe "+PCM=$(Join-Path $vec 'all_samples.mem')" "+OBS=$obs" 2>&1
  $runOutput | Tee-Object -FilePath $rlog
  if($runOutput -match '(?i)\b(ERROR|WARNING)\b'){throw 'simulator reported ERROR/WARNING'}
  if($LASTEXITCODE -ne 0){throw "vvp failed: $LASTEXITCODE"}
} finally {Pop-Location}
$verify=Join-Path $sim 'verify_spectrum_overlay_integration.py'
$verifyOutput=& $python @pythonPrefix $verify $obs 2>&1
$verifyOutput | Tee-Object -FilePath (Join-Path $model 'spectrum_overlay_integration_verify.log')
if($LASTEXITCODE -ne 0){throw 'integrated gold verification failed'}
$hashes=[ordered]@{
  renderer=(Get-FileHash -Algorithm SHA256 -LiteralPath $rtl).Hash.ToLower()
  analyzer=(Get-FileHash -Algorithm SHA256 -LiteralPath $analyzer).Hash.ToLower()
  integration_tb=(Get-FileHash -Algorithm SHA256 -LiteralPath $tb).Hash.ToLower()
  state_gold=(Get-FileHash -Algorithm SHA256 -LiteralPath $verify).Hash.ToLower()
  fixedpoint_gold=(Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $sim 'spectrum_oracle.py')).Hash.ToLower()
  analyzer_vectors=(Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $vec 'all_samples.mem')).Hash.ToLower()
}
$hashes | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $model 'spectrum_overlay_integration_hashes.json') -Encoding utf8
@"
PASS: real PCM analyzer-to-renderer control and RGB path; 3 production 1024-point analysis frames; full 100ms stale timeout.
Accelerated integration PCM explicitly disables FFT_TIMEOUT_SAMPLES; production 4096-sample watchdog is verified separately by tb_fft_recover and the physical-rate WAV test.
Renderer SHA256=$($hashes.renderer)
Analyzer SHA256=$($hashes.analyzer)
Integration TB SHA256=$($hashes.integration_tb)
Independent state gold SHA256=$($hashes.state_gold)
Fixedpoint gold SHA256=$($hashes.fixedpoint_gold)
"@ | Set-Content -LiteralPath (Join-Path $model 'spectrum_overlay_integration_evidence.txt') -Encoding utf8
Get-Content -LiteralPath $rlog


