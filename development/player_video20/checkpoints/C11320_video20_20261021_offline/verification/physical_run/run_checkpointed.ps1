param([string]$Restore = '')
$ErrorActionPreference = 'Stop'
$taskBase = $PSScriptRoot
$taskRun = Join-Path $taskBase 'checkpointed_20261022'
Set-Location -LiteralPath $taskRun
$taskArgs = @('-modelsimini','modelsim.ini','-c','-lic_noqueue',
    '-suppress','3017,3722','-L','work','-L','eg4','-L','hdmi')
if ($Restore) {
    $taskArgs += @('-restore',$Restore,'-do','resume.do')
} else {
    $taskArgs += @('work.tb_video_system_physical_final','work.glbl',
        '+AUDIO_PHASE=800','-do','checkpointed.do')
}
$taskTag = if ($Restore) {'restore_'+[IO.Path]::GetFileNameWithoutExtension($Restore)} else {'start'}
$taskArgs += @('-l',($taskTag+'.log'))
$taskProcess = Start-Process -FilePath 'E:/ModelsimSE/win64/vsim.exe' -ArgumentList $taskArgs `
    -WorkingDirectory $taskRun -WindowStyle Hidden -PassThru `
    -RedirectStandardOutput ($taskTag+'_console.log') -RedirectStandardError ($taskTag+'_stderr.log')
$taskProcess.WaitForExit()
$taskExit = [ordered]@{exit_code=$taskProcess.ExitCode;vsim_exit_code=$taskProcess.ExitCode;
    timed_out=$false;restore=$Restore;log=(Join-Path $taskRun ($taskTag+'.log'));
    optimized_design='work.tb_video_system_physical_final';finished=(Get-Date).ToString('o')}
$taskExit | ConvertTo-Json | Set-Content -LiteralPath ($taskTag+'_exit.json') -Encoding utf8
Get-Content -LiteralPath ($taskTag+'.log') -Tail 12
if ($taskProcess.ExitCode -ne 0) {throw "ModelSim exit $($taskProcess.ExitCode); inspect $taskRun"}
