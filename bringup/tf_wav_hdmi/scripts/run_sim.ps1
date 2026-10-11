$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$iv = Join-Path $root 'tools/iverilog/app/bin/iverilog.exe'
$vvp = Join-Path $root 'tools/iverilog/app/bin/vvp.exe'
$hdl = Join-Path $root 'src/user_source/hdl_source'
$sim = Join-Path $root 'sim'
& $iv -g2012 -s tb_tf_wav_player -o "$sim/player.vvp" "$hdl/tf_wav_player.v" "$sim/tb_tf_wav_player.v"
if ($LASTEXITCODE) { throw 'Player compilation failed' }
foreach ($mode in '', '+BAD_HEADER', '+SLOW_SD') {
    if ($mode) { & $vvp "$sim/player.vvp" $mode } else { & $vvp "$sim/player.vvp" }
    if ($LASTEXITCODE) { throw "Player test failed: $mode" }
}
& $iv -g2012 -s tb_wav_pipeline -o "$sim/pipeline.vvp" "$hdl/tf_wav_player.v" "$hdl/sd_sector_arbiter.v" "$hdl/wav_pcm_bridge.v" "$hdl/audio_arc_calculate.v" "$sim/tb_wav_pipeline.v"
if ($LASTEXITCODE) { throw 'Pipeline compilation failed' }
& $vvp "$sim/pipeline.vvp"
if ($LASTEXITCODE) { throw 'Pipeline test failed' }
