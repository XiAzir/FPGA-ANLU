param([switch]$VerifyFailedBaseline)
$ErrorActionPreference='Stop'
$task=Split-Path -Parent $PSScriptRoot
$repo=Split-Path -Parent (Split-Path -Parent $task)
$hdl=Join-Path $task 'src/user_source/hdl_source'
$out=Join-Path $task 'build/model/video_contract'
$iv=Join-Path $repo 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe'
$vvp=Join-Path $repo 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe'
New-Item -ItemType Directory -Force $out | Out-Null
$checks=@()
function Invoke-Contract($Name,$Sources,[bool]$ExpectPass) {
    $exe=Join-Path $out ($Name+'.vvp')
    $compileLog=Join-Path $out ($Name+'_compile.log')
    $runLog=Join-Path $out ($Name+'_run.log')
    $top=if($Name -eq 'pipeline'){'tb_video_pipeline_contract'}else{'tb_video_axis_contract'}
    $compile=& $iv -g2012 -I (Join-Path $hdl 'SD') -s $top -o $exe @Sources 2>&1
    $compile | Set-Content -LiteralPath $compileLog -Encoding utf8
    if($LASTEXITCODE -ne 0){throw "Compile failed: $compileLog"}
    $run=& $vvp $exe 2>&1
    $exit=$LASTEXITCODE
    $run | Set-Content -LiteralPath $runLog -Encoding utf8
    $content=$run -join [Environment]::NewLine
    if($ExpectPass) {
        if($exit -ne 0 -or $content -notmatch ('PASS '+$top.Substring(3))){throw "Contract failed: $runLog"}
    } else {
        if($exit -eq 0 -or $content -notmatch 'valids=614400 sofs=2 eols=0 errors=960'){
            throw "Failed baseline did not reproduce the specific missing-TLAST defect: $runLog"
        }
    }
    $run | Write-Host
    [ordered]@{name=$Name;expectedFailure=(!$ExpectPass);exitCode=$exit;log=$runLog;
        inputs=@($Sources | ForEach-Object {[ordered]@{path=$_;sha256=(Get-FileHash -LiteralPath $_).Hash}})}
}
$axisTb=Join-Path $PSScriptRoot 'tb_video_axis_contract.v'
$axis=Join-Path $hdl 'video_rgb_to_axis_640x480.v'
if($VerifyFailedBaseline) {
    $old=Join-Path $repo 'development/player_spectrum_fft_recover/src/user_source/hdl_source/video_rgb_to_axis_640x480.v'
    $checks+=Invoke-Contract 'baseline_missing_tlast' @($axisTb,$old) $false
}
$checks+=Invoke-Contract 'axis' @($axisTb,$axis) $true
$checks+=Invoke-Contract 'pipeline' @(
    (Join-Path $PSScriptRoot 'tb_video_pipeline_contract.v'),$axis,
    (Join-Path $hdl 'SD/video_timing_data.v'),(Join-Path $hdl 'SD/video_delay.v'),
    (Join-Path $hdl 'SD/color_bar.v')) $true
$evidence=[ordered]@{status='PASS';scope='RTL video source to AXIS boundary only; no protected HDMI core, vendor primitives, board, or electrical simulation';
    createdUtc=[DateTime]::UtcNow.ToString('o');checks=$checks;
    includeInputs=@([ordered]@{path=(Join-Path $hdl 'SD/video_define.v');sha256=(Get-FileHash -LiteralPath (Join-Path $hdl 'SD/video_define.v')).Hash});
    runnerSha256=(Get-FileHash -LiteralPath $PSCommandPath).Hash;iverilogSha256=(Get-FileHash -LiteralPath $iv).Hash}
$evidence | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $out 'evidence.json') -Encoding utf8
Write-Host 'PASS video_contract regression'
