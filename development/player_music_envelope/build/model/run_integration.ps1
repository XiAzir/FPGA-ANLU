$ErrorActionPreference='Stop'
$taskProject=(Resolve-Path (Join-Path $PSScriptRoot '../../../..')).Path
$taskHdl=Join-Path $taskProject 'development/player_music_envelope/src/user_source/hdl_source'
$taskIver=Join-Path $taskProject 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe'
$taskVvp=Join-Path $taskProject 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe'
Push-Location $PSScriptRoot
try {
 & $taskIver -g2012 -s tb_envelope_integration -o 'integration.vvp' 'tb_envelope_integration.v' "$taskHdl/player_pcm_waveform.v" "$taskHdl/player_rgb_adjust.v" "$taskHdl/player_adjust_osd.v" "$taskHdl/player_osd.v" "$taskHdl/player_dynamic_text.v" *> 'integration_compile.log'
 if($LASTEXITCODE -ne 0){Get-Content 'integration_compile.log';throw 'Integration compile failed'}
 & $taskVvp 'integration.vvp' *> 'integration.log'
 if($LASTEXITCODE -ne 0){Get-Content 'integration.log';throw 'Integration model failed'}
 if(!(Select-String -LiteralPath 'integration.log' -SimpleMatch 'INTEGRATION PASS' -Quiet)){throw 'Integration completion marker absent'}
 Get-Content 'integration.log'
 $taskNames=@('tb_envelope_integration.v','run_integration.ps1','music_pcm.hex','integration.log','integration_compile.log')
 $taskModelHashes=[ordered]@{};foreach($n in $taskNames){$taskModelHashes[$n]=(Get-FileHash -LiteralPath $n).Hash}
 $taskRtlHashes=[ordered]@{};foreach($n in @('player_pcm_waveform.v','player_rgb_adjust.v','player_adjust_osd.v','player_osd.v','player_dynamic_text.v')){$taskRtlHashes[$n]=(Get-FileHash -LiteralPath (Join-Path $taskHdl $n)).Hash}
 [ordered]@{status='PASS';modelHashes=$taskModelHashes;sourceHashes=$taskRtlHashes;scope='Three full 800x525 raster frames with real local music1024 samples repeating at nominal48kHz, parameters/default restoration and OSD overlay. No encrypted HDMI/SDRAM/physical card.'} | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath 'integration_receipt.json' -Encoding utf8
}finally{Pop-Location}
