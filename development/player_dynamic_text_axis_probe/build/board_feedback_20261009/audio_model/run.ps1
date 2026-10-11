$ErrorActionPreference = 'Stop'
$modelDir = $PSScriptRoot
$projectDir = (Resolve-Path (Join-Path $modelDir '../../..')).Path
$repoDir = (Resolve-Path (Join-Path $projectDir '../..')).Path
$iverilog = Join-Path $repoDir 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe'
$vvp = Join-Path $repoDir 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe'
$hdl = Join-Path $projectDir 'src/user_source/hdl_source'
$image = Join-Path $modelDir 'tb_audio_rate.vvp'

$sources = @(
    (Join-Path $hdl 'hdmi_audio_tone_pcm_scale.v'),
    (Join-Path $hdl 'wav_pcm_bridge.v'),
    (Join-Path $hdl 'audio_arc_calculate.v'),
    (Join-Path $hdl 'player_audio_probe.v'),
    (Join-Path $hdl 'player_status_monitor.v'),
    (Join-Path $modelDir 'tb_audio_rate.v')
)

"Compile: $iverilog -g2012 -s tb_audio_rate" | Set-Content (Join-Path $modelDir 'compile.log')
& $iverilog -g2012 -s tb_audio_rate -o $image @sources 2>&1 |
    Tee-Object -FilePath (Join-Path $modelDir 'compile.log') -Append
if ($LASTEXITCODE -ne 0) { throw "iverilog failed with exit code $LASTEXITCODE" }

$timer = [System.Diagnostics.Stopwatch]::StartNew()
& $vvp $image 2>&1 | Tee-Object -FilePath (Join-Path $modelDir 'run.log')
$exitCode = $LASTEXITCODE
$timer.Stop()
"Exit code: $exitCode`r`nWall time: $($timer.Elapsed)" |
    Add-Content (Join-Path $modelDir 'run.log')
if ($exitCode -ne 0) { throw "vvp failed with exit code $exitCode" }
