$ErrorActionPreference='Stop'
$taskRepo=(Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
. (Join-Path $taskRepo 'scripts/anlu_tools.ps1')
$taskIverilog=Resolve-AnluTool -Name iverilog
$taskVvp=Resolve-AnluTool -Name vvp
$task30=Join-Path $taskRepo 'development/player_video30_probe_prune/src/user_source/hdl_source'
$task31=Join-Path $taskRepo 'development/player_video31_audio_ablation/src/user_source/hdl_source'
& $taskIverilog -g2012 -s tb_audio_observer_ablation -o "$PSScriptRoot/audio.vvp" "$PSScriptRoot/tb_audio_observer_ablation.v" "$task30/player_audio_output.v" "$task31/player_audio_probe.v" "$task31/wav_pcm_bridge.v" "$task31/hdmi_audio_tone_pcm_scale.v" "$task31/audio_arc_calculate.v" *> "$PSScriptRoot/audio_compile.log"
if($LASTEXITCODE -ne 0){throw 'Audio ablation compile failed'}
& $taskVvp "$PSScriptRoot/audio.vvp" *> "$PSScriptRoot/audio_run.log"
Get-Content "$PSScriptRoot/audio_run.log"
if($LASTEXITCODE -ne 0){throw 'Audio ablation test failed'}
