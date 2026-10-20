$ErrorActionPreference='Stop'
$taskProject=(Resolve-Path (Join-Path $PSScriptRoot '../../../..')).Path
$taskHdl=Join-Path $taskProject 'development/player_waveform_fine/src/user_source/hdl_source'
$taskIver=Join-Path $taskProject 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe'
$taskVvp=Join-Path $taskProject 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe'
Push-Location $PSScriptRoot
try {
 & $taskIver -g2012 -s tb_waveform_integration -o 'integration.vvp' 'tb_waveform_integration.v' "$taskHdl/player_pcm_waveform.v" "$taskHdl/player_rgb_adjust.v" "$taskHdl/player_adjust_osd.v" "$taskHdl/player_osd.v" "$taskHdl/player_dynamic_text.v" *> 'integration_compile.log'
 if($LASTEXITCODE -ne 0){Get-Content 'integration_compile.log';throw 'Integration compile failed'}
 & $taskVvp 'integration.vvp' *> 'integration.log'
 if($LASTEXITCODE -ne 0){Get-Content 'integration.log';throw 'Integration model failed'}
 Get-Content 'integration.log'
} finally {Pop-Location}
