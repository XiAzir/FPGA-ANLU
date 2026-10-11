$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$taskTools='E:/VSCODE-project/FPGA-ANLU/bringup/tf_wav_hdmi/tools/iverilog/app/bin'
$taskOut=Join-Path $taskRoot 'build/status_hex_sim'
New-Item -ItemType Directory -Force -Path $taskOut | Out-Null
$taskExe=Join-Path $taskOut 'hex.vvp'
& (Join-Path $taskTools 'iverilog.exe') -g2012 -Wall -s tb_status_hex595 -o $taskExe (Join-Path $taskRoot 'sim/tb_status_hex595.v') (Join-Path $taskRoot 'src/user_source/hdl_source/status_hex595.v') *> (Join-Path $taskOut 'compile.log')
if($LASTEXITCODE -ne 0) { throw '595 model compilation failed' }
& (Join-Path $taskTools 'vvp.exe') $taskExe *> (Join-Path $taskOut 'run.log')
Get-Content -LiteralPath (Join-Path $taskOut 'run.log')
if($LASTEXITCODE -ne 0) { throw '595 model failed' }
