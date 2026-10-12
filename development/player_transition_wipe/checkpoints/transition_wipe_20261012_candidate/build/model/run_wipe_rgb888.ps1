$ErrorActionPreference='Stop'
$taskProject=(Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$taskRoot=(Resolve-Path (Join-Path $taskProject '../..')).Path
$taskIver=Join-Path $taskRoot 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe'
$taskVvp=Join-Path $taskRoot 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe'
Push-Location $PSScriptRoot
try {
 & $taskIver -g2012 -s tb_wipe_rgb888 -o 'wipe_rgb888.vvp' 'tb_wipe_rgb888.v' "$taskProject/src/user_source/hdl_source/player_wipe_address.v" "$taskProject/src/user_source/hdl_source/rgb888_word_codec.v" *> 'wipe_rgb888_compile.log'
 if($LASTEXITCODE -ne 0){Get-Content 'wipe_rgb888_compile.log';throw 'RGB model compile failed'}
 & $taskVvp 'wipe_rgb888.vvp' *> 'wipe_rgb888.log'
 if($LASTEXITCODE -ne 0){Get-Content 'wipe_rgb888.log';throw 'RGB model failed'}
 Get-Content 'wipe_rgb888.log'
 if(!(Select-String 'wipe_rgb888.log' -Pattern '^WIPE_RGB888 PASS ' -Quiet)){throw 'No PASS'}
} finally {Pop-Location}
