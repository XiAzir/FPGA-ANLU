$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$probe = (Resolve-Path (Join-Path $here '..\..')).Path
$project = (Resolve-Path (Join-Path $here '..\..\..\..')).Path
$src = Join-Path $probe 'src\user_source\hdl_source'
$iverilog = Join-Path $project 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\iverilog.exe'
$vvp = Join-Path $project 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\vvp.exe'
if (!(Test-Path -LiteralPath $iverilog)) { throw "Icarus compiler missing: $iverilog" }
if (!(Test-Path -LiteralPath $vvp)) { throw "Icarus runtime missing: $vvp" }
$out = Join-Path $here 'axis_protocol_fix.vvp'
$log = Join-Path $here 'compile.log'
'Icarus Verilog 12.0 (devel), compile full actual video chain + original and isolated fixed converter' | Set-Content -LiteralPath $log -Encoding utf8
& $iverilog -g2012 -DVIDEO_640_480 -I (Join-Path $src 'SD') -s tb_axis_protocol_fix_audit -o $out (Join-Path $src 'SD\color_bar.v') (Join-Path $src 'SD\video_timing_data.v') (Join-Path $src 'SD\video_delay.v') (Join-Path $src 'video_rgb_to_axis_640x480.v') (Join-Path $here 'prototype\video_rgb_to_axis_640x480_fixed.v') (Join-Path $here 'tb_axis_protocol_fix_audit.v') 2>&1 | Tee-Object -FilePath $log -Append
if ($LASTEXITCODE -ne 0) { throw "iverilog failed: $LASTEXITCODE" }
& $vvp $out 2>&1 | Tee-Object -FilePath (Join-Path $here 'run.log')
if ($LASTEXITCODE -ne 0) { throw "vvp failed: $LASTEXITCODE" }
