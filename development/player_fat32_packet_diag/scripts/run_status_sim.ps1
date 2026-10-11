$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$taskTools='E:\VSCODE-project\FPGA-ANLU\bringup\tf_wav_hdmi\tools\iverilog\app\bin'
$taskOut=Join-Path $taskRoot 'build\status_monitor_sim'
New-Item -ItemType Directory -Force -Path $taskOut | Out-Null
$taskExe=Join-Path $taskOut 'status.vvp'
& (Join-Path $taskTools 'iverilog.exe') -g2012 -Wall -s tb_player_status_monitor -o $taskExe `
    (Join-Path $taskRoot 'sim\tb_player_status_monitor.v') `
    (Join-Path $taskRoot 'src\user_source\hdl_source\player_status_monitor.v') *> (Join-Path $taskOut 'compile.log')
if($LASTEXITCODE -ne 0) { Get-Content (Join-Path $taskOut 'compile.log'); throw 'status model compilation failed' }
& (Join-Path $taskTools 'vvp.exe') $taskExe *> (Join-Path $taskOut 'run.log')
Get-Content -LiteralPath (Join-Path $taskOut 'run.log')
if($LASTEXITCODE -ne 0) { throw 'status model failed' }

