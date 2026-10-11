$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$hdl = Join-Path $root 'src\user_source\hdl_source'
$sim = Join-Path $root 'build\sim'
$iverilog = 'E:\VSCODE-project\FPGA-ANLU\bringup\tf_wav_hdmi\tools\iverilog\app\bin\iverilog.exe'
$vvp = 'E:\VSCODE-project\FPGA-ANLU\bringup\tf_wav_hdmi\tools\iverilog\app\bin\vvp.exe'
$sources = @('frame_buffer_rgb888.v','rgb888_word_codec.v','SD\frame_read_write.v',
    'SD\frame_fifo_write.v','SD\frame_fifo_read.v','IP\afifo_32_16_256.v',
    'IP\afifo_16_32_256.v') | ForEach-Object { Join-Path $hdl $_ }
$sources += Join-Path $root 'sim\tb_compact_frame_buffer.v'
$compiled = Join-Path $sim 'read_capture_repro.vvp'
$compileLog = Join-Path $sim 'read_capture_repro_compile.log'
$runLog = Join-Path $sim 'read_capture_repro.log'
& $iverilog -g2012 -Wall -s tb_compact_frame_buffer `
    '-Ptb_compact_frame_buffer.DATA_LAG=1' '-Ptb_compact_frame_buffer.CAPTURE_DELAY=0' `
    -o $compiled @sources *> $compileLog
if ($LASTEXITCODE -ne 0) { Get-Content $compileLog; throw 'Reproduction compilation failed' }
& $vvp $compiled *> $runLog
$runExit = $LASTEXITCODE
Get-Content $runLog
if ($runExit -eq 0 -or -not (Select-String -LiteralPath $runLog -Pattern 'pixel mismatch' -Quiet)) {
    throw 'Expected read-capture mismatch not reproduced'
}
'EXPECTED_FAILURE_REPRODUCED: early valid with one-cycle-late data; this is a hypothesis model, not a measured board waveform.'
