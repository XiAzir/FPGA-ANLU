$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$hdl = Join-Path $root 'src\user_source\hdl_source'
$sim = Join-Path $root 'build\sim'
$iverilog = (Resolve-AnluTool 'iverilog')
$vvp = (Resolve-AnluTool 'vvp')
$sources = @('frame_buffer_rgb888.v','rgb888_word_codec.v','SD\frame_read_write.v',
    'SD\frame_fifo_write.v','SD\frame_fifo_read.v','IP\afifo_32_16_256.v',
    'IP\afifo_16_32_256.v') | ForEach-Object { Join-Path $hdl $_ }
$sources += Join-Path $root 'sim\tb_compact_frame_buffer.v'
foreach ($captureDelay in @(0,1)) {
    $name = "lead_data_capture_$captureDelay"
    $compiled = Join-Path $sim ($name + '.vvp')
    $compileLog = Join-Path $sim ($name + '_compile.log')
    $runLog = Join-Path $sim ($name + '.log')
    & $iverilog -g2012 -Wall -s tb_compact_frame_buffer `
        '-Ptb_compact_frame_buffer.DATA_LAG=-1' `
        "-Ptb_compact_frame_buffer.CAPTURE_DELAY=$captureDelay" `
        '-Ptb_compact_frame_buffer.DATA_DELAY=0' `
        -o $compiled @sources *> $compileLog
    if ($LASTEXITCODE -ne 0) { Get-Content $compileLog; throw 'Reproduction compilation failed' }
    & $vvp $compiled *> $runLog
    $runExit = $LASTEXITCODE
    Get-Content $runLog
    if ($runExit -eq 0 -or -not (Select-String -LiteralPath $runLog -Pattern 'capture mismatch' -Quiet)) {
        throw 'Expected read-capture mismatch not reproduced'
    }
}
'EXPECTED_FAILURES_REPRODUCED: data-leading-valid model rejects both previous capture0 and capture1 versions; model is not a measured board waveform.'

