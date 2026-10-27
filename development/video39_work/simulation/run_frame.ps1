$ErrorActionPreference='Stop'
$repo=(Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '../../..')).Path
$hdl=Join-Path $repo 'development/player_video39_native1080p30/src/user_source/hdl_source/open_tx'
$bin=Join-Path $repo 'bringup/tf_wav_hdmi/tools/iverilog/app/bin'
$image=Join-Path $PSScriptRoot 'native30_frame.vvp'
$sources=@('video_only_tmds_tx.v','tmds_channel.v','packet_assembler_compat.v','auxiliary_video_information_info_frame.v') |
    ForEach-Object {Join-Path $hdl $_}
& "$bin/iverilog.exe" -g2012 -s tb_native30_frame -o $image @sources (Join-Path $PSScriptRoot 'tb_native30_frame.sv') *> (Join-Path $PSScriptRoot 'frame_compile.log')
if($LASTEXITCODE -ne 0){throw 'C39 full frame compilation failed'}
$timer=[Diagnostics.Stopwatch]::StartNew()
& "$bin/vvp.exe" $image *> (Join-Path $PSScriptRoot 'frame_run.log')
$exitCode=$LASTEXITCODE
$timer.Stop()
$text=[IO.File]::ReadAllText((Join-Path $PSScriptRoot 'frame_run.log'))
$complete=$text.Contains('NATIVE30_FULL_FRAME_PASS')
$result=[ordered]@{exit_code=$exitCode;completed=$complete;duration_seconds=$timer.Elapsed.TotalSeconds;
    source_sha256=@($sources|ForEach-Object{@{path=$_;sha256=(Get-FileHash -LiteralPath $_ -Algorithm SHA256).Hash}});
    bench_sha256=(Get-FileHash -LiteralPath (Join-Path $PSScriptRoot 'tb_native30_frame.sv') -Algorithm SHA256).Hash;
    stdout=$text}
$result|ConvertTo-Json -Depth 5|Set-Content -LiteralPath (Join-Path $PSScriptRoot 'frame_result.json') -Encoding utf8
$result|ConvertTo-Json -Depth 5
if($exitCode -ne 0 -or -not $complete){throw 'C39 full frame verification failed'}
