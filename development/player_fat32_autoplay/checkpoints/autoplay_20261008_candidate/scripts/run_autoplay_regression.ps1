$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$taskHdl=Join-Path $taskRoot 'src\user_source\hdl_source'
$taskBin='E:\VSCODE-project\FPGA-ANLU\bringup\tf_wav_hdmi\tools\iverilog\app\bin'
$taskSources=@('fat32_catalog.v','fat32_file_sector.v','tf_bmp_file_player.v','tf_wav_file_player.v','sd_sector_arbiter.v','SD\sd_card_bmp.v') | ForEach-Object {Join-Path $taskHdl $_}
$taskSources+=Join-Path $taskRoot 'sim\tb_fat_file_integration.v'
foreach($taskCase in @(@{Name='integration_small';Card=0;Audio=64},@{Name='integration_spi12m5';Card=32;Audio=1042})) {
    $taskFixture=Join-Path $taskRoot ('build\fat_sim\'+$taskCase.Name+'_fixture')
    & python (Join-Path $PSScriptRoot 'make_integration_fixture.py') --width 16 --height 64 --output $taskFixture
    if($LASTEXITCODE -ne 0){throw 'Fixture generation failed'}
    $taskOut=Join-Path $taskRoot ('build\fat_sim\'+$taskCase.Name)
    & (Join-Path $taskBin 'iverilog.exe') -g2012 -Wall -s tb_fat_file_integration -I $taskFixture '-Ptb_fat_file_integration.WIDTH=16' '-Ptb_fat_file_integration.HEIGHT=64' "-Ptb_fat_file_integration.CARD_BYTE_CYCLES=$($taskCase.Card)" "-Ptb_fat_file_integration.AUDIO_SAMPLE_CYCLES=$($taskCase.Audio)" -o ($taskOut+'.vvp') @taskSources *> ($taskOut+'_compile.log')
    if($LASTEXITCODE -ne 0){Get-Content ($taskOut+'_compile.log');throw 'Integration compile failed'}
    & (Join-Path $taskBin 'vvp.exe') ($taskOut+'.vvp') "+FIXTURE=$($taskFixture.Replace('\','/'))" *> ($taskOut+'.log')
    $taskExit=$LASTEXITCODE
    Get-Content -LiteralPath ($taskOut+'.log')
    if($taskExit -ne 0 -or !(Select-String -LiteralPath ($taskOut+'.log') -Pattern '^PASS fat_file_integration' -Quiet)){throw 'Autoplay/WAV integration failed'}
}
