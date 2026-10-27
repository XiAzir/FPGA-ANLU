$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$iverilog = 'E:/VSCODE-project/FPGA-ANLU/bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe'
$vvp = 'E:/VSCODE-project/FPGA-ANLU/bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe'
$tb = Join-Path $here 'tb_write_fifo_ready.v'
$positiveImage = Join-Path $here 'write_fifo_ready_positive.vvp'
$negativeImage = Join-Path $here 'write_fifo_ready_negative.vvp'
$positiveLog = Join-Path $here 'write_fifo_ready_positive.log'
$negativeLog = Join-Path $here 'write_fifo_ready_negative.log'
if (-not (Test-Path -LiteralPath $iverilog) -or -not (Test-Path -LiteralPath $vvp)) {
    throw 'Configured Icarus binaries were not found.'
}
& $iverilog -g2012 -s tb_write_fifo_ready -o $positiveImage $tb *> $positiveLog
if ($LASTEXITCODE -ne 0) { Get-Content -LiteralPath $positiveLog; throw "Positive compile failed: $LASTEXITCODE" }
& $vvp $positiveImage *> $positiveLog
if ($LASTEXITCODE -ne 0) { Get-Content -LiteralPath $positiveLog; throw "Positive reset unit failed: $LASTEXITCODE" }
Get-Content -LiteralPath $positiveLog
& $iverilog -g2012 -DNEGATIVE_CONTROL -s tb_write_fifo_ready -o $negativeImage $tb *> $negativeLog
if ($LASTEXITCODE -ne 0) { Get-Content -LiteralPath $negativeLog; throw "Negative compile failed: $LASTEXITCODE" }
& $vvp $negativeImage *> $negativeLog
if ($LASTEXITCODE -eq 0) { Get-Content -LiteralPath $negativeLog; throw 'Negative control escaped detection.' }
Get-Content -LiteralPath $negativeLog
Write-Host 'PASS: gated and gate-deleted candidates match; missing release synchronization is detected.'
