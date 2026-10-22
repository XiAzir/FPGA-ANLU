$ErrorActionPreference = 'Stop'
$run = Split-Path -Parent $MyInvocation.MyCommand.Path
$vopt = 'E:/ModelsimSE/win64/vopt.exe'
$vsim = 'E:/ModelsimSE/win64/vsim.exe'
Set-Location -LiteralPath $run

foreach ($tool in @($vopt, $vsim)) {
    if (-not (Test-Path -LiteralPath $tool -PathType Leaf)) {
        throw "Missing ModelSim executable: $tool"
    }
}

$voptArgs = @(
    '-modelsimini', 'modelsim.ini',
    '-L', 'work', '-L', 'eg4', '-L', 'hdmi',
    '-G/tb_video_system/MAPPED_SECTORS=29686',
    '-G/tb_video_system/IMAGE_BYTES=536870912',
    '-G/tb_video_system/CHECK_FRAMES=2',
    'work.tb_video_system', 'work.glbl',
    '-o', 'tb_video_system_physical_final'
)
$voptOut = Join-Path $run 'vopt_physical_final.log'
$voptErr = Join-Path $run 'vopt_physical_final_stderr.log'
$voptProcess = Start-Process -FilePath $vopt -ArgumentList $voptArgs -WorkingDirectory $run `
    -RedirectStandardOutput $voptOut -RedirectStandardError $voptErr -PassThru -Wait -WindowStyle Hidden
if ($voptProcess.ExitCode -ne 0) {
    throw "vopt failed with exit code $($voptProcess.ExitCode); see vopt_physical_final.log and vopt_physical_final_stderr.log"
}

$simArgs = @(
    '-modelsimini', 'modelsim.ini', '-c', '-lic_noqueue',
    '-suppress', '3017,3722',
    '-L', 'work', '-L', 'eg4', '-L', 'hdmi',
    'work.tb_video_system_physical_final', 'work.glbl',
    '-do', 'run.do', '-l', 'physical_final_run.log',
    '+AUDIO_PHASE=800'
)
$stdout = Join-Path $run 'physical_final_console.log'
$stderr = Join-Path $run 'physical_final_stderr.log'
$process = Start-Process -FilePath $vsim -ArgumentList $simArgs -WorkingDirectory $run `
    -RedirectStandardOutput $stdout -RedirectStandardError $stderr -PassThru -WindowStyle Hidden
if (-not $process.WaitForExit(7200000)) {
    $process.Kill($true)
    $process.WaitForExit()
    throw 'vsim exceeded the 7200 second limit; result is interrupted'
}
if ($process.ExitCode -ne 0) {
    throw "vsim failed with exit code $($process.ExitCode); see physical_final_run.log and console logs"
}

$log = Get-Content -LiteralPath (Join-Path $run 'physical_final_run.log') -Raw
if ($log -notmatch 'VIDEO_SYSTEM_PASS decoded_pixels=\d+ commits=\d+ distinct_frames=\d+ PCM=\d+ underflow=0 late=0') {
    throw 'Expected complete VIDEO_SYSTEM_PASS record was not found; inspect physical_final_run.log'
}
Write-Output 'Physical SDRAM simulation reached VIDEO_SYSTEM_PASS.'
