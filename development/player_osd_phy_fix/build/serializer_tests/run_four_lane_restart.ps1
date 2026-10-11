param([string]$LaneSourcePath='E:\VSCODE-project\FPGA-ANLU\development\player_osd_phy_fix\src\user_source\hdl_source\lane_lvds_10_1.v')
$ErrorActionPreference='Stop'
$root='E:\VSCODE-project\FPGA-ANLU'
$iv=Join-Path $root 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\iverilog.exe'
$vvp=Join-Path $root 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\vvp.exe'
$dir=Join-Path $root 'development\player_osd\build\serializer_audit'
$tb=Join-Path $dir 'tb_four_lane_restart.v'
$out=Join-Path $dir 'four_lane_restart.vvp'
if((Get-Content -LiteralPath $LaneSourcePath -Raw) -notmatch 'S_pending_data') { throw "Expected pending-data candidate source: $LaneSourcePath" }
& $iv -g2012 -s tb_four_lane_restart -o $out $tb $LaneSourcePath
if($LASTEXITCODE -ne 0) { throw "iverilog exit $LASTEXITCODE" }
$result=& $vvp $out 2>&1
$result
if($LASTEXITCODE -ne 0 -or (($result -join "`n") -notmatch 'FOUR_LANE_RESTART epochs=2 pulses_first=\d+ pulses_after_restart=\d+ strobe_mismatches=0 loaded_word_mismatches=0 reset_clear_mismatches=0')) { throw 'Four-lane/restart gate failed.' }
