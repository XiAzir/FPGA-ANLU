$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$taskRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$taskHdl = Join-Path $taskRoot 'src\user_source\hdl_source'
$taskBin = (Split-Path -Parent (Resolve-AnluTool 'iverilog'))
$taskOutRoot = Join-Path $taskRoot 'build\fat_frame_sim'
New-Item -ItemType Directory -Force -Path $taskOutRoot | Out-Null

$taskSources = @(
    (Join-Path $taskHdl 'fat32_catalog.v'),
    (Join-Path $taskHdl 'fat32_file_sector.v'),
    (Join-Path $taskHdl 'tf_bmp_file_player.v'),
    (Join-Path $taskHdl 'frame_buffer_rgb888.v'),
    (Join-Path $taskHdl 'rgb888_word_codec.v'),
    (Join-Path $taskHdl 'SD\sd_card_bmp.v'),
    (Join-Path $taskHdl 'SD\frame_read_write.v'),
    (Join-Path $taskHdl 'SD\frame_fifo_write.v'),
    (Join-Path $taskHdl 'SD\frame_fifo_read.v'),
    (Join-Path $taskHdl 'IP\afifo_32_16_256.v'),
    (Join-Path $taskHdl 'IP\afifo_16_32_256.v'),
    (Join-Path $taskRoot 'sim\tb_fat_frame_integration.v')
)

foreach ($taskCase in @(
    @{ Name='frame_small'; Width=16; Height=64; Frames=2 },
    @{ Name='frame_480p'; Width=640; Height=480; Frames=1 }
)) {
    $taskFixture = Join-Path $taskOutRoot ($taskCase.Name + '_fixture')
    & python (Join-Path $PSScriptRoot 'make_integration_fixture.py') `
        --width $taskCase.Width --height $taskCase.Height --output $taskFixture
    if ($LASTEXITCODE -ne 0) { throw "Fixture generation failed: $($taskCase.Name)" }

    $taskCompiled = Join-Path $taskOutRoot ($taskCase.Name + '.vvp')
    $taskCompileLog = Join-Path $taskOutRoot ($taskCase.Name + '_compile.log')
    $taskRunLog = Join-Path $taskOutRoot ($taskCase.Name + '.log')
    & (Resolve-AnluTool 'iverilog') -g2012 -Wall -s tb_fat_frame_integration `
        -I $taskFixture "-Ptb_fat_frame_integration.WIDTH=$($taskCase.Width)" `
        "-Ptb_fat_frame_integration.HEIGHT=$($taskCase.Height)" `
        "-Ptb_fat_frame_integration.FRAME_COUNT=$($taskCase.Frames)" `
        -o $taskCompiled @taskSources *> $taskCompileLog
    if ($LASTEXITCODE -ne 0) { Get-Content $taskCompileLog; throw "Compile failed: $($taskCase.Name)" }

    & (Resolve-AnluTool 'vvp') $taskCompiled "+FIXTURE=$($taskFixture.Replace('\','/'))" *> $taskRunLog
    $taskExit = $LASTEXITCODE
    Get-Content $taskRunLog
    if ($taskExit -ne 0 -or -not (Select-String -LiteralPath $taskRunLog -Pattern '^PASS tb_fat_frame_integration' -Quiet)) {
        throw "Frame integration simulation failed: $($taskCase.Name)"
    }
}
