. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$python = Resolve-AnluPython
$pythonPrefix = @()
if ([IO.Path]::GetFileNameWithoutExtension($python) -ieq 'py') { $pythonPrefix = @('-3') }
$ErrorActionPreference='Stop'
$project = $AnluRepositoryRoot;$task=Join-Path $project 'development\player_spectrum_tf_margin';$sim=Join-Path $task 'sim';$model=Join-Path $task 'build\model';$hdl=Join-Path $task 'src\user_source\hdl_source'
$prepare=Join-Path $sim 'prepare_real_music_vectors.py';$tb=Join-Path $sim 'tb_spectrum_real_music.v';$rtl=Join-Path $hdl 'player_spectrum_analyzer.v'
$iverilog=(Resolve-AnluTool -Name 'iverilog');$vvp=(Resolve-AnluTool -Name 'vvp');$vec=Join-Path $sim 'vectors'
$exe=Join-Path $model 'spectrum_real_music.vvp';$clog=Join-Path $model 'spectrum_real_music_compile.log';$rlog=Join-Path $model 'spectrum_real_music_run.log'
& $python @pythonPrefix $prepare | Set-Content -LiteralPath (Join-Path $model 'real_music_vectors_run.json') -Encoding utf8
if($LASTEXITCODE -ne 0){throw 'real music vector preparation failed'}
Set-Content -LiteralPath $clog -Value '' -Encoding ascii
Push-Location $hdl
try {
  $compileOutput=& $iverilog -g2012 -DPRIVATE_ROM_BEHAVIORAL_SIM -I $hdl -s tb_spectrum_real_music -o $exe $tb $rtl (Join-Path $hdl "spectrum_coeff_rom.v") 2>&1
  $compileOutput | Tee-Object -FilePath $clog
  if($compileOutput -match '(?i)\b(warning|error):'){throw 'Icarus compile warning/error'}
  if($LASTEXITCODE -ne 0){throw "iverilog failed: $LASTEXITCODE"}
  $runOutput=& $vvp $exe "+SAMPLES=$(Join-Path $vec 'real_music_samples.mem')" "+EXPECTED=$(Join-Path $vec 'real_music_expected.mem')" 2>&1
  $runOutput | Tee-Object -FilePath $rlog
  if($runOutput -match '(?i)\b(ERROR|WARNING)\b'){throw 'simulator reported ERROR/WARNING'}
  if($LASTEXITCODE -ne 0){throw "vvp failed: $LASTEXITCODE"}
} finally {Pop-Location}
$rtlHash=(Get-FileHash -Algorithm SHA256 -LiteralPath $rtl).Hash.ToLower();$tbHash=(Get-FileHash -Algorithm SHA256 -LiteralPath $tb).Hash.ToLower()
$goldHash=(Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $sim 'spectrum_oracle.py')).Hash.ToLower();$prepHash=(Get-FileHash -Algorithm SHA256 -LiteralPath $prepare).Hash.ToLower()
$waveHash=(Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $project 'deliverables/real_music_20261008/card/TEST.WAV')).Hash.ToLower()
@"
PASS: two 1024-sample windows selected from the original 48 kHz mono PCM16 TEST.WAV and compared against the fixed-point oracle.
Input WAV SHA256=$waveHash
Analyzer RTL SHA256=$rtlHash
TB SHA256=$tbHash
Fixed-point gold SHA256=$goldHash
Vector preparer SHA256=$prepHash
"@ | Set-Content -LiteralPath (Join-Path $model 'spectrum_real_music_evidence.txt') -Encoding utf8
Get-Content -LiteralPath $rlog;Get-Content -LiteralPath (Join-Path $model 'spectrum_real_music_evidence.txt')
