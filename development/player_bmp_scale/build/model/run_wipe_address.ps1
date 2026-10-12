$ErrorActionPreference='Stop'
$taskProject=(Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$taskRoot=(Resolve-Path (Join-Path $taskProject '../..')).Path
$taskIver=Join-Path $taskRoot 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe'
$taskVvp=Join-Path $taskRoot 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe'
Push-Location $PSScriptRoot
try {
 & $taskIver -g2012 -s tb_wipe_address -o 'wipe_address.vvp' 'tb_wipe_address.v' "$taskProject/src/user_source/hdl_source/player_wipe_address.v" *> 'wipe_address_compile.log'
 if($LASTEXITCODE -ne 0){Get-Content 'wipe_address_compile.log';throw 'Address model compile failed'}
 & $taskVvp 'wipe_address.vvp' *> 'wipe_address.log'
 if($LASTEXITCODE -ne 0){Get-Content 'wipe_address.log';throw 'Address model failed'}
 Get-Content 'wipe_address.log'
 if(!(Select-String 'wipe_address.log' -Pattern '^WIPE_ADDRESS PASS ' -Quiet)){throw 'No PASS'}
} finally {Pop-Location}
