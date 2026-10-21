. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$ErrorActionPreference='Stop'
$project = $AnluRepositoryRoot
$task=Join-Path $project 'development\player_spectrum_resource_80'
$sim=Join-Path $task 'sim';$model=Join-Path $task 'build\model'
$hdl=Join-Path $task 'src\user_source\hdl_source'
$tb=Join-Path $sim 'tb_fft_recover.v'
$rtl=Join-Path $hdl 'player_spectrum_analyzer.v'
$overlay=Join-Path $hdl 'player_pcm_waveform.v'
$top=Join-Path $hdl 'top_tf_hdmi_audio.v'
$rom=Join-Path $hdl 'spectrum_coeff_rom.v'
$vec=Join-Path $sim 'vectors\all_samples.mem'
$iv=(Resolve-AnluTool -Name 'iverilog')
$vvp=(Resolve-AnluTool -Name 'vvp')
foreach($f in @($tb,$rtl,$overlay,$top,$rom,$vec,$iv,$vvp)){if(!(Test-Path -LiteralPath $f)){throw "Missing required file: $f"}}
New-Item -ItemType Directory -Force -Path $model | Out-Null
$rtlBefore=(Get-FileHash -Algorithm SHA256 -LiteralPath $rtl).Hash.ToLower()
$overlayHash=(Get-FileHash -Algorithm SHA256 -LiteralPath $overlay).Hash.ToLower()
$rtlText=Get-Content -LiteralPath $rtl -Raw
$overlayText=Get-Content -LiteralPath $overlay -Raw
$topText=Get-Content -LiteralPath $top -Raw
$portHeader=($rtlText -split '\);',2)[0]
if($portHeader -notmatch '(?m)input\s+wire\s+audio_valid' -or $portHeader -notmatch '(?m)input\s+wire\s+signed\s+\[15:0\]\s+audio_pcm'){
  throw 'Analyzer audio inputs changed or are missing'
}
if($portHeader -match '(?m)output\s+[^,\r\n]*\baudio_(valid|pcm|left|right)'){
  throw 'Analyzer unexpectedly exposes an audio-source output; recovery noninterference audit failed'
}
if($topText -notmatch '(?s)player_audio_probe\s+u_audio_probe\s*\(.*?\.audio_left\(audio_left_data\)'){
  throw 'Top-level audio source output path not found'
}
if($topText -notmatch '(?s)player_pcm_waveform\s+#\(.*?\)\s+u_pcm_waveform\s*\(.*?\.audio_valid\(audio_valid\).*?\.audio_pcm\(audio_left_data\)'){
  throw 'Top-level spectrum tap input wiring not found'
}
if($overlayText -match '(?s)output\s+wire\s+[^;]*\b(audio_valid|audio_pcm|audio_left|audio_right)'){
  throw 'Spectrum wrapper unexpectedly drives audio-source outputs'
}
$interfaceAudit=[ordered]@{
  status='PASS'
  analyzer_inputs=@('audio_valid','audio_pcm')
  analyzer_audio_outputs=@()
  recovery_is_local='timeout_pulse only resets analyzer control; recovery debug outputs do not feed the audio probe'
  top_audio_source_path='player_audio_probe drives audio_left_data/audio_valid; player_pcm_waveform only receives them'
  analyzer_sha256=$rtlBefore
  overlay_sha256=$overlayHash
  top_sha256=(Get-FileHash -Algorithm SHA256 -LiteralPath $top).Hash.ToLower()
}
$interfaceAudit | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $model 'fft_recover_interface_audit.json') -Encoding utf8
$tbHash=(Get-FileHash -Algorithm SHA256 -LiteralPath $tb).Hash.ToLower()
$vecHash=(Get-FileHash -Algorithm SHA256 -LiteralPath $vec).Hash.ToLower()
$ivHash=(Get-FileHash -Algorithm SHA256 -LiteralPath $iv).Hash.ToLower()
$tag=Get-Date -Format 'yyyyMMdd_HHmmss'
$exe=Join-Path $model "fft_recover_$tag.vvp"
$compileLog=Join-Path $model "fft_recover_compile_$tag.log"
$runLog=Join-Path $model "fft_recover_run_$tag.log"
Set-Content -LiteralPath $compileLog -Value '' -Encoding ascii
Push-Location $hdl
try {
  $compileOutput=& $iv -g2012 -DPRIVATE_ROM_BEHAVIORAL_SIM -I $hdl -s tb_fft_recover -o $exe $tb $rtl $rom 2>&1
  $compileOutput | Tee-Object -FilePath $compileLog
  if($compileOutput -match '(?i)\b(warning|error):'){throw 'Icarus compile reported warning/error'}
  if($LASTEXITCODE -ne 0){throw "iverilog failed: $LASTEXITCODE"}
  $runOutput=& $vvp $exe "+SAMPLES=$vec" 2>&1
  $runOutput | Tee-Object -FilePath $runLog
  if($LASTEXITCODE -ne 0){throw "vvp failed: $LASTEXITCODE"}
  $runText=$runOutput -join "`n"
  foreach($marker in @('PASS reset_release','PASS source_change','PASS binary_illegal_state_recovery','PASS normal_real_rate_frame','PASS watchdog_timeout','PASS autonomous_post_timeout_frame','PASS telemetry_saturation','PASS fft_recover')){
    if($runText -notmatch [regex]::Escape($marker)){throw "Missing PASS marker: $marker"}
  }
} finally {Pop-Location}
$rtlAfter=(Get-FileHash -Algorithm SHA256 -LiteralPath $rtl).Hash.ToLower()
if($rtlAfter -ne $rtlBefore){throw 'Production analyzer RTL changed during test; evidence rejected'}
$events=Join-Path $model "fft_recover_evidence_$tag.txt"
@"
PASS: analyzer recovery and recovery telemetry test completed.
Production FRAME_TIMEOUT_SAMPLES default: 4096 (parameter not overridden in tb_fft_recover).
Clock/sample cadence: 25 MHz clock; audio_valid one-cycle pulses every 521 clocks (~48 kHz).
Checks: asynchronous reset assertion; non-edge-aligned reset release and 3-pixel-clock settling; source_change abort/reset; direct testbench-only injection of binary illegal states 17..31; valid nonzero normal frame with recovery_count=0; testbench-only ST_CAPTURE stall while valid source samples continue until timeout; local recovery_count increment; subsequent real-rate frame completes with no source_change/global reset; recovery/source counter saturation and accepted-sample saturation.
No board, TD, or hardware test executed.
Analyzer RTL SHA256=$rtlBefore
Renderer/wrapper RTL SHA256=$overlayHash
Testbench SHA256=$tbHash
Input vector SHA256=$vecHash
Icarus SHA256=$ivHash
Compile log=$compileLog
Run log=$runLog
Testbench-only fault injection: state/counters are directly deposited only in this simulation; production RTL is unchanged.
Audio source separation: analyzer has no audio output port; recovery counter/reset are local, and top-level audio probe wiring is independent of spectrum diagnostic outputs.
Interface audit: $model\fft_recover_interface_audit.json
"@ | Set-Content -LiteralPath $events -Encoding utf8
Get-Content -LiteralPath $runLog
Get-Content -LiteralPath $events
