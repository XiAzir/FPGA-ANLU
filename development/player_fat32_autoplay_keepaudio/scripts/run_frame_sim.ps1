$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$iverilog = (Resolve-AnluTool 'iverilog')
$vvp = (Resolve-AnluTool 'vvp')
$hdl = Join-Path $projectRoot 'src\user_source\hdl_source'
$simOutput = Join-Path $projectRoot 'build\sim'
New-Item -ItemType Directory -Force -Path $simOutput | Out-Null
$sourceFiles = @(
    (Join-Path $hdl 'frame_buffer_rgb888.v'),
    (Join-Path $hdl 'rgb888_word_codec.v'),
    (Join-Path $hdl 'SD\frame_read_write.v'),
    (Join-Path $hdl 'SD\frame_fifo_write.v'),
    (Join-Path $hdl 'SD\frame_fifo_read.v'),
    (Join-Path $hdl 'IP\afifo_32_16_256.v'),
    (Join-Path $hdl 'IP\afifo_16_32_256.v'),
    (Join-Path $projectRoot 'sim\tb_compact_frame_buffer.v')
)
foreach ($case in @(
    @{ Name='small_flip'; Width=16; Height=64; Flip=1; DataLag=-1; CaptureDelay=0; DataDelay=1 },
    @{ Name='small_no_flip'; Width=16; Height=64; Flip=0; DataLag=-1; CaptureDelay=0; DataDelay=1 },
    @{ Name='small_ideal'; Width=16; Height=64; Flip=1; DataLag=0; CaptureDelay=0; DataDelay=0 },
    @{ Name='small_late_data'; Width=16; Height=64; Flip=1; DataLag=1; CaptureDelay=1; DataDelay=0 },
    @{ Name='480p_flip'; Width=640; Height=480; Flip=1; DataLag=-1; CaptureDelay=0; DataDelay=1 }
)) {
    $compiled = Join-Path $simOutput ($case.Name + '.vvp')
    $compileLog = Join-Path $simOutput ($case.Name + '_compile.log')
    $runLog = Join-Path $simOutput ($case.Name + '.log')
    & $iverilog -g2012 -Wall -s tb_compact_frame_buffer `
        "-Ptb_compact_frame_buffer.WIDTH=$($case.Width)" `
        "-Ptb_compact_frame_buffer.HEIGHT=$($case.Height)" `
        "-Ptb_compact_frame_buffer.FLIP=$($case.Flip)" `
        "-Ptb_compact_frame_buffer.DATA_LAG=$($case.DataLag)" `
        "-Ptb_compact_frame_buffer.CAPTURE_DELAY=$($case.CaptureDelay)" `
        "-Ptb_compact_frame_buffer.DATA_DELAY=$($case.DataDelay)" `
        -o $compiled @sourceFiles *> $compileLog
    if ($LASTEXITCODE -ne 0) { Get-Content $compileLog; throw "Compilation failed: $($case.Name)" }
    & $vvp $compiled *> $runLog
    $runExit = $LASTEXITCODE
    Get-Content $runLog
    if ($runExit -ne 0) { throw "Simulation failed: $($case.Name)" }
    if (-not (Select-String -LiteralPath $runLog -Pattern '^PASS tb_compact_frame_buffer' -Quiet)) {
        throw "Missing PASS marker: $($case.Name)"
    }
}

