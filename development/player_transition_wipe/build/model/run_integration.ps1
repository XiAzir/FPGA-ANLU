$ErrorActionPreference='Stop'
$taskProject=(Resolve-Path (Join-Path $PSScriptRoot '../../../..')).Path
$taskHdl=Join-Path $taskProject 'development/player_transition_wipe/src/user_source/hdl_source'
. (Join-Path $PSScriptRoot '../../../../scripts/anlu_tools.ps1')
$taskIver=(Resolve-AnluTool 'iverilog')
$taskVvp=(Resolve-AnluTool 'vvp')
Push-Location $PSScriptRoot
try {
 & $taskIver -g2012 -s tb_waveform_integration -o 'integration.vvp' 'tb_waveform_integration.v' "$taskHdl/player_pcm_waveform.v" "$taskHdl/player_rgb_adjust.v" "$taskHdl/player_adjust_osd.v" "$taskHdl/player_osd.v" "$taskHdl/player_dynamic_text.v" *> 'integration_compile.log'
 if($LASTEXITCODE -ne 0){Get-Content 'integration_compile.log';throw 'Integration compile failed'}
 & $taskVvp 'integration.vvp' *> 'integration.log'
 if($LASTEXITCODE -ne 0){Get-Content 'integration.log';throw 'Integration model failed'}
 Get-Content 'integration.log'
} finally {Pop-Location}
