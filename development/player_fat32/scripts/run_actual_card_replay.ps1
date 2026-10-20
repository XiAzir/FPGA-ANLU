param(
    [int]$MaxExpansionSeconds = 180,
    [switch]$SkipFourFrameRun
)
$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$taskRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$taskHdl=Join-Path $taskRoot 'src\user_source\hdl_source'
$taskBin=(Split-Path -Parent (Resolve-AnluTool 'iverilog'))
$taskBuild=Join-Path $taskRoot 'build\actual_card_replay'
$taskFixture=$taskBuild
$taskTb=Join-Path $taskRoot 'sim\tb_actual_card_replay.v'
$taskSources=@('fat32_catalog.v','fat32_file_sector.v','tf_bmp_file_player.v','tf_wav_file_player.v','sd_sector_arbiter.v','SD\sd_card_bmp.v') | ForEach-Object {Join-Path $taskHdl $_}
$taskSources+=$taskTb

& python (Join-Path $PSScriptRoot 'make_actual_card_fixture.py') --output $taskFixture
if($LASTEXITCODE -ne 0){throw 'Actual-card fixture generation failed'}

function Invoke-ActualReplay([int]$FrameTarget,[string]$Name) {
    $taskOut=Join-Path $taskBuild $Name
    & (Resolve-AnluTool 'iverilog') -g2012 -Wall -s tb_actual_card_replay -I $taskFixture `
        "-Ptb_actual_card_replay.FRAME_TARGET=$FrameTarget" "-Ptb_actual_card_replay.CARD_GAP=1" `
        -o ($taskOut+'.vvp') @taskSources *> ($taskOut+'_compile.log')
    if($LASTEXITCODE -ne 0){Get-Content ($taskOut+'_compile.log');throw "Compile failed: $Name"}
    $taskTimer=[System.Diagnostics.Stopwatch]::StartNew()
    & (Resolve-AnluTool 'vvp') ($taskOut+'.vvp') "+FIXTURE=$($taskFixture.Replace('\','/'))" *> ($taskOut+'.log')
    $taskExit=$LASTEXITCODE; $taskTimer.Stop()
    Get-Content ($taskOut+'.log') | ForEach-Object { Write-Host $_ }
    if($taskExit -ne 0 -or !(Select-String -LiteralPath ($taskOut+'.log') -Pattern "^PASS actual_card_replay frames=$FrameTarget/4" -Quiet)){
        throw "Simulation failed: $Name (exit=$taskExit, elapsed=$($taskTimer.Elapsed))"
    }
    return $taskTimer.Elapsed
}

$taskTwoElapsed=Invoke-ActualReplay 2 'actual_card_replay_two_frame'
Write-Host "Two-frame replay elapsed: $taskTwoElapsed"
if(!$SkipFourFrameRun -and $taskTwoElapsed.TotalSeconds -le $MaxExpansionSeconds){
    [void](Invoke-ActualReplay 4 'actual_card_replay_four_frame')
} else {
    Write-Host "Four-frame replay skipped by cost policy (two-frame elapsed=$taskTwoElapsed, threshold=${MaxExpansionSeconds}s)."
}
