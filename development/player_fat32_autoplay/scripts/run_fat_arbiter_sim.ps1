$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$taskBin='E:\VSCODE-project\FPGA-ANLU\bringup\tf_wav_hdmi\tools\iverilog\app\bin'
$taskOut=Join-Path $taskRoot 'build\fat_sim\fat_arbiter'
& (Join-Path $taskBin 'iverilog.exe') -g2005 -Wall -s tb_fat_arbiter -o ($taskOut+'.vvp') (Join-Path $taskRoot 'src\user_source\hdl_source\sd_sector_arbiter.v') (Join-Path $taskRoot 'sim\tb_fat_arbiter.v') *> ($taskOut+'_compile.log')
if($LASTEXITCODE -ne 0){Get-Content ($taskOut+'_compile.log');throw 'Arbiter compile failed'}
& (Join-Path $taskBin 'vvp.exe') ($taskOut+'.vvp') *> ($taskOut+'.log')
$taskExit=$LASTEXITCODE;Get-Content ($taskOut+'.log')
if($taskExit -ne 0 -or !(Select-String -LiteralPath ($taskOut+'.log') -Pattern '^PASS fat_arbiter' -Quiet)){throw 'Arbiter test failed'}
