$ErrorActionPreference = 'Stop'
Set-Location (Resolve-Path (Join-Path $PSScriptRoot '../../..'))
. ./scripts/anlu_tools.ps1
$iverilog = Resolve-AnluTool -Name iverilog
$vvp = Resolve-AnluTool -Name vvp
$test = 'development/video32_work/pressure_test/tb_frame_fifo_return_drain_rw.v'
$out = 'development/video32_work/pressure_test/tb_frame_fifo_return_drain_rw.vvp'
$rtl = 'development/player_video31_audio_ablation/src/user_source/hdl_source'
$candidate = 'development/video32_work/pressure_test/frame_fifo_read_c32_candidate.v'
& $iverilog -g2012 -s tb_frame_fifo_return_drain -o $out $test `
    "$rtl/SD/frame_fifo_read.v" $candidate `
    "$rtl/SD/frame_fifo_write.v" "$rtl/jpeg420_word_address.v"
if ($LASTEXITCODE -ne 0) { throw "Icarus compile failed: $LASTEXITCODE" }
& $vvp $out
if ($LASTEXITCODE -ne 0) { throw "VVP simulation failed: $LASTEXITCODE" }
$thresholdTest = 'development/video32_work/pressure_test/tb_frame_fifo_read_pressure.v'
$thresholdOut = 'development/video32_work/pressure_test/tb_frame_fifo_read_pressure.vvp'
& $iverilog -g2012 -s tb_frame_fifo_read_pressure -o $thresholdOut $thresholdTest "$rtl/SD/frame_fifo_read.v"
if ($LASTEXITCODE -ne 0) { throw "Threshold Icarus compile failed: $LASTEXITCODE" }
& $vvp $thresholdOut
if ($LASTEXITCODE -ne 0) { throw "Threshold VVP simulation failed: $LASTEXITCODE" }
