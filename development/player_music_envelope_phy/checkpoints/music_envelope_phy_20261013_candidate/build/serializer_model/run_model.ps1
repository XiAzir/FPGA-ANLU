param([ValidateSet('baseline','candidate')][string]$Mode='candidate',[switch]$BoundaryOnly)
$ErrorActionPreference='Stop'; $nl="`r`n"; $root='E:\VSCODE-project\FPGA-ANLU'; $dir=Join-Path $root 'development\player_music_envelope\build\board_feedback_20261013\serializer_model'
$lanePath=if($Mode -eq 'candidate'){Join-Path $root 'development\player_music_envelope_phy\src\user_source\hdl_source\lane_lvds_10_1.v'}else{Join-Path $root 'development\player_music_envelope\src\user_source\hdl_source\lane_lvds_10_1.v'}
$wrapPath=if($Mode -eq 'candidate'){Join-Path $root 'development\player_music_envelope_phy\src\user_source\hdl_source\hdmi_phy_warpper.v'}else{Join-Path $root 'development\player_music_envelope\src\user_source\hdl_source\hdmi_phy_warpper.v'}
$iv=Join-Path $root 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\iverilog.exe';$vvp=Join-Path $root 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\vvp.exe'
$lane=(Get-Content -LiteralPath $lanePath -Raw).Replace('parameter DEVICE = "EG"','parameter DEVICE = "EG",'+$nl+'    parameter integer TOGGLE_DELAY_PS = 0,'+$nl+'    parameter integer ODDR_D0_DELAY_PS = 0,'+$nl+'    parameter integer ODDR_D1_DELAY_PS = 0,'+$nl+'    parameter integer PAD_CLK_DELAY_PS = 0')
$lane=$lane.Replace('S_odd_even <= ~S_odd_even;','#(TOGGLE_DELAY_PS) S_odd_even <= ~S_odd_even;')
$insert=@"
    wire S_oddr_d1_pin, S_oddr_d0_pin, S_oddr_clk_pin;
    assign #(ODDR_D1_DELAY_PS) S_oddr_d1_pin = S_oddr_data[0];
    assign #(ODDR_D0_DELAY_PS) S_oddr_d0_pin = S_oddr_data[1];
    assign #(PAD_CLK_DELAY_PS) S_oddr_clk_pin = I_serial_clk;
"@
$lane=$lane.Replace("    generate$nl",($insert+$nl+"    generate$nl")).Replace('.clk   ( I_serial_clk   )','.clk   ( S_oddr_clk_pin )').Replace('.d1    ( S_oddr_data[0] )','.d1    ( S_oddr_d1_pin )').Replace('.d0    ( S_oddr_data[1] )','.d0    ( S_oddr_d0_pin )')
$wrap=(Get-Content -LiteralPath $wrapPath -Raw).Replace('parameter DEVICE = "EG"','parameter DEVICE = "EG",'+$nl+'    parameter integer TOGGLE_DELAY_PS = 0,'+$nl+'    parameter integer ODDR_D0_DELAY_PS = 0,'+$nl+'    parameter integer ODDR_D1_DELAY_PS = 0,'+$nl+'    parameter integer PAD_CLK_DELAY_PS = 0')
$wrap=$wrap.Replace('.DEVICE ( DEVICE )','.DEVICE ( DEVICE ),'+$nl+'        .TOGGLE_DELAY_PS ( TOGGLE_DELAY_PS ),'+$nl+'        .ODDR_D0_DELAY_PS ( ODDR_D0_DELAY_PS ),'+$nl+'        .ODDR_D1_DELAY_PS ( ODDR_D1_DELAY_PS ),'+$nl+'        .PAD_CLK_DELAY_PS ( PAD_CLK_DELAY_PS )')
Set-Content -LiteralPath (Join-Path $dir "lane_$Mode.v") -Value $lane -Encoding ascii;Set-Content -LiteralPath (Join-Path $dir "wrapper_$Mode.v") -Value $wrap -Encoding ascii
$tb=Join-Path $dir 'tb_serializer_model.v';$cand=if($Mode -eq 'candidate'){1}else{0};$rows=[System.Collections.Generic.List[string]]::new()
if($BoundaryOnly){$phaseValues=@(0);$toggleValues=@(0);$d0Values=@(50);$d1Values=@(1500);$clkValues=@(1000);$seedValues=@(1)}else{$phaseValues=@(-1000,0,1000);$toggleValues=@(0,1000,2000);$d0Values=@(0);$d1Values=@(0);$clkValues=@(0);$seedValues=@(1,37,97)}
foreach($phase in $phaseValues){foreach($toggle in $toggleValues){foreach($d0 in $d0Values){foreach($d1 in $d1Values){foreach($clk in $clkValues){foreach($seed in $seedValues){
 $exe=Join-Path $dir "model_${Mode}_${toggle}_${d0}_${d1}_${clk}.vvp";& $iv -g2012 -s tb_serializer_model -P "tb_serializer_model.TOGGLE_DELAY_PS=$toggle" -P "tb_serializer_model.CANDIDATE=$cand" -P "tb_serializer_model.ODDR_D0_DELAY_PS=$d0" -P "tb_serializer_model.ODDR_D1_DELAY_PS=$d1" -P "tb_serializer_model.PAD_CLK_DELAY_PS=$clk" -o $exe $tb (Join-Path $dir "lane_$Mode.v") (Join-Path $dir "wrapper_$Mode.v");if($LASTEXITCODE -ne 0){throw "compile failed $Mode $toggle $d0 $d1 $clk"}
 $out=& $vvp $exe "+phase=$phase" "+seed=$seed" 2>&1;$vvpExit=$LASTEXITCODE;$line=$out|Where-Object {$_ -like 'SUMMARY *'}|Select-Object -Last 1;if(!$line){$out;throw 'missing summary'};$rows.Add($line);$expectedBaselineFailure=($BoundaryOnly -and $Mode -eq 'baseline' -and $line -match 'align_bit=-1');if($expectedBaselineFailure){if($vvpExit -eq 0){throw 'baseline boundary counterexample was not detected'}}elseif($vvpExit -ne 0){$out;throw "vvp exited $vvpExit for $Mode phase=$phase toggle=$toggle d0=$d0 d1=$d1 clk=$clk seed=$seed"};$failed=($line -match 'align_bit=-1') -or ($line -match 'word_errors=([1-9][0-9]*)') -or ($line -match 'serial_bit_errors=([1-9][0-9]*)') -or ($line -match 'target_errors=([1-9][0-9]*)') -or ($line -match 'capture_errors=([1-9][0-9]*)') -or ($line -match 'source_sequence_errors=([1-9][0-9]*)');if($failed -and -not $expectedBaselineFailure){$out|Set-Content -LiteralPath (Join-Path $dir "failure_${Mode}_${toggle}_${d0}_${d1}_${clk}_${phase}_${seed}.log") -Encoding ascii;throw "failure summary: $line"}
}}}}}}
$summary=if($BoundaryOnly){"summary_${Mode}_boundary.txt"}else{"summary_${Mode}_final.txt"};$rows|Set-Content -LiteralPath (Join-Path $dir $summary) -Encoding ascii;Get-Content (Join-Path $dir $summary)



