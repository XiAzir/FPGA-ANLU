$ErrorActionPreference='Stop'
$taskModel=$PSScriptRoot
$taskSource=(Resolve-Path (Join-Path $taskModel '../../src/user_source/hdl_source')).Path
$taskRoot=(Resolve-Path (Join-Path $taskModel '../../../..')).Path
$taskIcarus=Join-Path $taskRoot 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe'
$taskVvp=Join-Path $taskRoot 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe'
Push-Location $taskModel
try {
 & $taskIcarus -g2012 -s tb_write_backpressure -o write_backpressure.vvp tb_write_backpressure.v "$taskSource/rgb888_word_codec.v" "$taskSource/SD/frame_read_write.v" "$taskSource/SD/frame_fifo_write.v" "$taskSource/SD/frame_fifo_read.v" "$taskSource/IP/afifo_16_32_256.v" "$taskSource/IP/afifo_32_16_256.v" *> write_backpressure_compile.log
 if($LASTEXITCODE -ne 0){Get-Content write_backpressure_compile.log;throw 'backpressure compile failed'}
 & $taskVvp write_backpressure.vvp *> write_backpressure.log
 Get-Content write_backpressure.log
 if($LASTEXITCODE -ne 0 -or !(Select-String write_backpressure.log -Pattern '^WRITE_BACKPRESSURE PASS' -Quiet)){throw 'backpressure model failed'}
} finally {Pop-Location}
