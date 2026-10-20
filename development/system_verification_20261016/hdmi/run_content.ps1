param([switch]$CompileOnly)
$ErrorActionPreference='Stop'
$toolBin='E:\ModelsimSE\win64'
$sourceRoot='E:\VSCODE-project\FPGA-ANLU\development\player_spectrum_fft_recover\src\user_source\hdl_source'
$encrypted="$sourceRoot\hdmi1.4b_transmitter_core\hdmi_1_4b_transmitter_core_wrapper.enc.v"
$legacySim='E:\VSCODE-project\FPGA-ANLU\development\player_spectrum_fft_recover\build\board_feedback_no_signal_20261014\modelsim'
$env:MGLS_LICENSE_FILE=[Environment]::GetEnvironmentVariable('MGLS_LICENSE_FILE','User')
Set-Location -LiteralPath $PSScriptRoot
if(-not(Test-Path -LiteralPath '.\modelsim.ini')){Copy-Item -LiteralPath "$legacySim\modelsim.ini" -Destination '.\modelsim.ini'}
if(-not(Test-Path -LiteralPath '.\work')){& "$toolBin\vlib.exe" work}
$compileLog=Join-Path $PSScriptRoot 'content_compile.log'
& "$toolBin\vlog.exe" -work work -L EG4 `
  'C:\Anlogic\TD_6.2.1_SP1_6.2.178.840\sim_release\eg4\eg_phy_glbl.v' `
  "$sourceRoot\lane_lvds_10_1.v" "$sourceRoot\hdmi_phy_warpper.v" `
  "$sourceRoot\audio_arc_calculate.v" "$sourceRoot\hdmi_packet_monitor.v" `
  "$sourceRoot\video_rgb_to_axis_640x480.v" `
  '.\hdmi_serial_receiver.v' '.\hdmi_serial_packet_monitor.v' `
  '.\tmds_rgb_decode.v' '.\tb_hdmi_core_content.v' $encrypted *> $compileLog
if($LASTEXITCODE -ne 0){Get-Content -LiteralPath $compileLog -Tail 80; throw "HDMI core compile failed: $LASTEXITCODE"}
if($CompileOnly){Write-Output "HDMI core and scoreboard compiled. Log: $compileLog";exit 0}
$doFile=Join-Path $PSScriptRoot 'content_run.do'
@('onerror {quit -code 2 -f}','onbreak {quit -code 3 -f}','run -all','quit -code 0 -f') | Set-Content -LiteralPath $doFile
$cases=@(
  @{Name='positive'; Args=@()},
  @{Name='negative_rgb'; Args=@('+negative_rgb')},
  @{Name='negative_audio'; Args=@('+negative_audio')}
)
foreach($case in $cases){
  $log=Join-Path $PSScriptRoot "content_$($case.Name).log"
  Remove-Item -LiteralPath $log -ErrorAction SilentlyContinue
  $simArgs=@('-c','-novopt','-L','EG4','work.tb_hdmi_core_content','work.glbl')+$case.Args+@('-l',$log,'-do',$doFile)
  & "$toolBin\vsim.exe" @simArgs
  if($LASTEXITCODE -ne 0){Get-Content -LiteralPath $log -Tail 100; throw "HDMI core test $($case.Name) failed: $LASTEXITCODE"}
  if(-not(Select-String -LiteralPath $log -Pattern 'PASS: actual encrypted HDMI core' -Quiet)){Get-Content -LiteralPath $log -Tail 100; throw "PASS marker missing for $($case.Name)"}
}
Write-Output 'Content tests completed. See content_positive.log, content_negative_rgb.log, content_negative_audio.log.'
