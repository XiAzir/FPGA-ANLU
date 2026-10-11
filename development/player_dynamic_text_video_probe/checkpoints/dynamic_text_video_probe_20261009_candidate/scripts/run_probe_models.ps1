# Reproduction entry point; original model runs and hashes are in model_results.json.
$ErrorActionPreference='Stop'
$taskProject=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$taskWorkspace=(Resolve-Path (Join-Path $taskProject '..\..')).Path
$taskTools=Join-Path $taskWorkspace 'bringup\tf_wav_hdmi\tools\iverilog\app\bin'
$taskHdl=Join-Path $taskProject 'src\user_source\hdl_source'
$taskOutput=Join-Path $taskProject 'build\probe_model_reproduction'
New-Item -ItemType Directory -Path $taskOutput -Force | Out-Null
$taskCases=@(
    @{name='source_probe';top='tb_player_video_source_probe';tb='tb_player_video_source_probe.v';sources=@('player_video_source_probe.v','tf_bmp_file_player.v')},
    @{name='pixels_probe';top='tb_player_dynamic_text_pixels_probe';tb='tb_player_dynamic_text_pixels_probe.v';sources=@('player_osd.v','player_dynamic_text.v')},
    @{name='timer_probe';top='tb_player_dynamic_text_timer_probe';tb='tb_player_dynamic_text_timer_probe.v';sources=@('player_dynamic_text.v')}
)
foreach ($taskCase in $taskCases) {
    $taskModel=Join-Path $taskOutput ($taskCase.name+'.vvp')
    $taskCompile=Join-Path $taskOutput ($taskCase.name+'_compile.log')
    $taskRun=Join-Path $taskOutput ($taskCase.name+'_run.log')
    $taskSources=@($taskCase.sources | ForEach-Object {Join-Path $taskHdl $_})
    & (Join-Path $taskTools 'iverilog.exe') -g2012 -s $taskCase.top -o $taskModel @taskSources (Join-Path $taskProject ('sim\tests\'+$taskCase.tb)) *> $taskCompile
    if ($LASTEXITCODE -ne 0) {throw ('Probe compile failed: '+$taskCompile)}
    & (Join-Path $taskTools 'vvp.exe') $taskModel *> $taskRun
    if ($LASTEXITCODE -ne 0) {throw ('Probe simulation failed: '+$taskRun)}
    $taskText=Get-Content -LiteralPath $taskRun -Raw
    if ($taskText -notmatch 'PASS' -or $taskText -match 'FAIL|FATAL') {throw ('Missing passing model: '+$taskRun)}
    Get-Content -LiteralPath $taskRun -Tail 2
}
