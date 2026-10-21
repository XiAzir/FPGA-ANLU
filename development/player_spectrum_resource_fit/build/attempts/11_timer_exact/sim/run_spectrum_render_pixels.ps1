. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$python = Resolve-AnluPython
$pythonPrefix = @()
if ([IO.Path]::GetFileNameWithoutExtension($python) -ieq 'py') { $pythonPrefix = @('-3') }
$ErrorActionPreference='Stop'
$project = $AnluRepositoryRoot
$task=Join-Path $project 'development\player_spectrum_resource_fit'
$sim=Join-Path $task 'sim';$model=Join-Path $task 'build\model';$hdl=Join-Path $task 'src\user_source\hdl_source'
$gold=Join-Path $sim 'spectrum_render_gold.py';$tb=Join-Path $sim 'tb_spectrum_overlay_pixels.v';$rtl=Join-Path $hdl 'player_pcm_waveform.v';$analyzer=Join-Path $hdl 'player_spectrum_analyzer.v'
$iverilog=(Resolve-AnluTool -Name 'iverilog');$vvp=(Resolve-AnluTool -Name 'vvp');$vec=Join-Path $sim 'vectors'
foreach($f in @($gold,$tb,$rtl,$analyzer,$iverilog,$vvp)){if(!(Test-Path -LiteralPath $f)){throw "Missing $f"}}
$goldOutput=& $python @pythonPrefix $gold 2>&1
$goldOutput | Set-Content -LiteralPath (Join-Path $model 'render_gold_run.json') -Encoding utf8
if($LASTEXITCODE -ne 0){throw 'render gold failed'}
$goldInfo=Get-Content -LiteralPath (Join-Path $vec 'render_gold.json') -Raw | ConvertFrom-Json
$pixelCount=[int]$goldInfo.pixel_samples
$tag=Get-Date -Format 'yyyyMMdd_HHmmss';$exe=Join-Path $model "render_pixels_$tag.vvp";$clog=Join-Path $model "render_pixels_compile_$tag.log";$rlog=Join-Path $model "render_pixels_run_$tag.log"
Set-Content -LiteralPath $clog -Value '' -Encoding ascii
Push-Location $hdl
try {
 $compileOutput=& $iverilog -g2012 -DPRIVATE_ROM_BEHAVIORAL_SIM -I $hdl -s tb_spectrum_overlay_pixels -o $exe $tb $rtl $analyzer (Join-Path $hdl "spectrum_coeff_rom.v") 2>&1
 $compileOutput | Tee-Object -FilePath $clog
 if($compileOutput -match '(?i)\b(warning|error):'){throw 'Icarus compile warning/error'}
 if($LASTEXITCODE -ne 0){throw "iverilog failed: $LASTEXITCODE"}
 $runOutput=& $vvp $exe "+PIX=$(Join-Path $vec 'render_pixels.mem')" "+COUNT=$pixelCount" 2>&1
 $runOutput | Tee-Object -FilePath $rlog
 if($runOutput -match '(?i)\b(ERROR|WARNING)\b'){throw 'simulator reported ERROR/WARNING'}
 if($LASTEXITCODE -ne 0){throw "vvp failed: $LASTEXITCODE"}
} finally {Pop-Location}
$hashes=[ordered]@{renderer=(Get-FileHash -Algorithm SHA256 -LiteralPath $rtl).Hash.ToLower();analyzer=(Get-FileHash -Algorithm SHA256 -LiteralPath $analyzer).Hash.ToLower();pixel_tb=(Get-FileHash -Algorithm SHA256 -LiteralPath $tb).Hash.ToLower();gold=(Get-FileHash -Algorithm SHA256 -LiteralPath $gold).Hash.ToLower();pixel_vectors=(Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $vec 'render_pixels.mem')).Hash.ToLower()}
$hashes | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $model "render_pixel_hashes_$tag.json") -Encoding utf8
@"
Pixel gold PASS. $pixelCount independently generated RGB samples cover panel bounds, columns/gaps, baseline/top, peak marker, gridlines, title glyphs for SPECTRUM WAV/TONE and HOLD WAV/TONE, LOW/HIGH legend, DE-low and outside passthrough.
This is an accelerated renderer-only gold test with FFT_TIMEOUT_SAMPLES=0; it does not verify the production sample watchdog.
The gold implements the published pitch16 title and pitch8 legend coordinate/color contract independently.
Compile: $clog
Run: $rlog
"@ | Set-Content -LiteralPath (Join-Path $model "render_pixel_evidence_$tag.txt") -Encoding utf8
Get-Content -LiteralPath $rlog;Get-Content -LiteralPath (Join-Path $model "render_pixel_evidence_$tag.txt");Get-Content -LiteralPath (Join-Path $model "render_pixel_hashes_$tag.json")
