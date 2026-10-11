param(
    [ValidateSet('baseline','candidate')] [string]$Mode = 'baseline',
    [string]$LaneSourcePath = '',
    [string]$OutputPrefix = 'delay_injection'
)
$ErrorActionPreference='Stop'
$root='E:\VSCODE-project\FPGA-ANLU'
$dir=Join-Path $root 'development\player_osd\build\serializer_audit'
$iv=Join-Path $root 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\iverilog.exe'
$vvp=Join-Path $root 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\vvp.exe'
$tb=Join-Path $dir 'tb_lane_delay_injection.v'
if(-not $LaneSourcePath) {
    if($Mode -eq 'candidate') { $LaneSourcePath=Join-Path $root 'development\player_osd_phy_fix\src\user_source\hdl_source\lane_lvds_10_1.v' }
    else { $LaneSourcePath=Join-Path $root 'development\player_osd\src\user_source\hdl_source\lane_lvds_10_1.v' }
}
$src=Get-Content -LiteralPath $LaneSourcePath -Raw
$nl="`r`n"
if($Mode -eq 'candidate' -and $src -notmatch 'S_pending_data') { throw "Candidate source has no pending-data register: $LaneSourcePath" }
if($src -notmatch 'TOGGLE_DELAY_PS') {
    $src=$src.Replace('parameter DEVICE = "EG"', ('parameter DEVICE = "EG",'+$nl+'    parameter integer TOGGLE_DELAY_PS = 0'))
    $src=$src.Replace('S_odd_even <= ~S_odd_even;', '#(TOGGLE_DELAY_PS) S_odd_even <= ~S_odd_even;')
}
$variant=Join-Path $dir "lane_delay_injected_$Mode.v"
Set-Content -LiteralPath $variant -Value $src -Encoding ascii
$rows=[System.Collections.Generic.List[string]]::new()
$toggleValues=@(200,300,400,500,600,700,800)
$phaseValues=@(100,200,300,400,500,600)
$modes=@(97,211,337)
foreach($toggle in $toggleValues) {
    $vvpOut=Join-Path $dir "${OutputPrefix}_${Mode}_${toggle}.vvp"
    if($Mode -eq 'candidate') { & $iv -g2012 -DCANDIDATE -s tb_delay_injection -P "tb_delay_injection.INJECT_TOGGLE_DELAY_PS=$toggle" -o $vvpOut $tb $variant }
    else { & $iv -g2012 -s tb_delay_injection -P "tb_delay_injection.INJECT_TOGGLE_DELAY_PS=$toggle" -o $vvpOut $tb $variant }
    if($LASTEXITCODE -ne 0) { throw "iverilog failed ($LASTEXITCODE) for toggle=$toggle" }
    foreach($phase in $phaseValues) { foreach($modeValue in $modes) {
        $out=& $vvp $vvpOut "+phase=$phase" "+mode=$modeValue" 2>&1
        $summary=$out | Where-Object { $_ -like 'SUMMARY *' } | Select-Object -Last 1
        if(-not $summary) { throw "Missing summary: mode=$Mode toggle=$toggle phase=$phase bit_skew_mode=$modeValue`n$out" }
        $rows.Add($summary)
    }}
}
$summaryPath=Join-Path $dir "${OutputPrefix}_${Mode}_summary.txt"
$rows | Set-Content -LiteralPath $summaryPath -Encoding ascii
$parsed=foreach($line in $rows) { if($line -match 'phase_ps=(\d+) toggle_delay_ps=(\d+) skew_mode=(\d+) loads=(\d+) target_word_errors=(\d+) output_words=(\d+) output_sequence_errors=(\d+) sample_offset_ps=(\d+)\.\.(\d+)') { [pscustomobject]@{phase=[int]$Matches[1];toggle=[int]$Matches[2];mode=[int]$Matches[3];loads=[int]$Matches[4];target=[int]$Matches[5];words=[int]$Matches[6];serial=[int]$Matches[7];offset_min=[int]$Matches[8];offset_max=[int]$Matches[9]} } }
$report=[pscustomobject]@{Mode=$Mode;Source=$LaneSourcePath;Cases=$parsed.Count;CasesWithTargetErrors=@($parsed|Where-Object target -gt 0).Count;TotalTargetWordErrors=($parsed.target|Measure-Object -Sum).Sum;CasesWithSerialSequenceErrors=@($parsed|Where-Object serial -gt 0).Count;Summary=$summaryPath}
$report | Format-List
if($Mode -eq 'candidate' -and ($report.Cases -ne 126 -or $report.TotalTargetWordErrors -ne 0 -or $report.CasesWithSerialSequenceErrors -ne 0)) { throw 'Candidate acceptance gate failed: require 126 cases and zero target/serial errors.' }
