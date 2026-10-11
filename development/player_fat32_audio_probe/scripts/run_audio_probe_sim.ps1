$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$taskHdl=Join-Path $taskRoot 'src\user_source\hdl_source'
$taskBin='E:\VSCODE-project\FPGA-ANLU\bringup\tf_wav_hdmi\tools\iverilog\app\bin'
$taskOut=Join-Path $taskRoot 'build\audio_probe_sim'
New-Item -ItemType Directory -Force -Path $taskOut | Out-Null
$taskImage=Join-Path $taskOut 'audio_probe.vvp'
$taskLog=Join-Path $taskOut 'audio_probe.log'
& (Join-Path $taskBin 'iverilog.exe') -g2012 -Wall -s tb_player_audio_probe -o $taskImage `
    (Join-Path $taskRoot 'sim\tb_player_audio_probe.v') `
    (Join-Path $taskHdl 'player_audio_probe.v') `
    (Join-Path $taskHdl 'wav_pcm_bridge.v') `
    (Join-Path $taskHdl 'hdmi_audio_tone_pcm_scale.v') `
    (Join-Path $taskHdl 'audio_arc_calculate.v') *> (Join-Path $taskOut 'compile.log')
if($LASTEXITCODE -ne 0) { Get-Content (Join-Path $taskOut 'compile.log'); throw 'Audio probe compile failed' }
& (Join-Path $taskBin 'vvp.exe') $taskImage *> $taskLog
Get-Content -LiteralPath $taskLog
if($LASTEXITCODE -ne 0 -or !(Select-String -LiteralPath $taskLog -SimpleMatch 'PASS tb_player_audio_probe' -Quiet)) { throw 'Audio probe simulation failed' }
