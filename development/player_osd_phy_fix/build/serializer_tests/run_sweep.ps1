param([ValidateSet('baseline','candidate')] [string]$Mode = 'baseline',[string]$LaneSourcePath='')
$ErrorActionPreference = 'Stop'
$root = 'E:\VSCODE-project\FPGA-ANLU'
$iverilog = Join-Path $root 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\iverilog.exe'
$vvp = Join-Path $root 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\vvp.exe'
$tb = Join-Path $root 'development\player_osd\build\serializer_audit\tb_lane_lvds_10_1.v'
if(-not $LaneSourcePath) {
    if($Mode -eq 'candidate') { $LaneSourcePath=Join-Path $root 'development\player_osd_phy_fix\src\user_source\hdl_source\lane_lvds_10_1.v' }
    else { $LaneSourcePath=Join-Path $root 'development\player_osd\src\user_source\hdl_source\lane_lvds_10_1.v' }
}
$rtl=$LaneSourcePath
$sourceText=Get-Content -LiteralPath $rtl -Raw
if($Mode -eq 'candidate' -and $sourceText -notmatch 'S_pending_data') { throw "Candidate source has no pending-data register: $rtl" }
$out = Join-Path $root 'development\player_osd\build\serializer_audit\tb_lane.vvp'
if ($Mode -eq 'candidate') { & $iverilog -g2012 -DCANDIDATE -s tb_lane -o $out $tb $rtl }
else { & $iverilog -g2012 -s tb_lane -o $out $tb $rtl }
if ($LASTEXITCODE -ne 0) { throw "iverilog exit $LASTEXITCODE" }
$rows = [System.Collections.Generic.List[string]]::new()
$skews = @(0, 100, 250, 500, 1000, 2000, 4000, 7000)
for ($phase = 0; $phase -lt 8000; $phase += 100) {
    foreach ($skew in $skews) {
        $result = & $vvp $out "+phase=$phase" "+skew=$skew" 2>&1
        $summary = $result | Where-Object { $_ -like 'SUMMARY *' } | Select-Object -Last 1
        if (-not $summary) { throw "Missing summary phase=$phase skew=${skew}: $result" }
        $rows.Add($summary)
    }
}
$rows | Set-Content -LiteralPath (Join-Path (Split-Path $tb) "sweep_summary_$Mode.txt") -Encoding ascii
$parsed = foreach ($line in $rows) {
    if ($line -match 'phase_ps=(\d+) skew_ps=(\d+) loads=(\d+) output_words=(\d+) seq_errors=(\d+) boundary_mismatches=(\d+) min_load_offset_ps=(\d+) max_load_offset_ps=(\d+)') {
        [pscustomobject]@{ phase=[int]$Matches[1]; skew=[int]$Matches[2]; loads=[int]$Matches[3]; words=[int]$Matches[4]; seq=[int]$Matches[5]; boundary=[int]$Matches[6]; min=[int]$Matches[7]; max=[int]$Matches[8] }
    }
}
$parsed | Group-Object skew | ForEach-Object {
    $bad = @($_.Group | Where-Object boundary -gt 0).Count
    $seqBad = @($_.Group | Where-Object seq -gt 0).Count
    [pscustomobject]@{ skew_ps=$_.Name; phase_cases=$_.Count; boundary_bad_phases=$bad; output_sequence_bad_phases=$seqBad }
} | Format-Table -AutoSize
$summary = [pscustomobject]@{Mode=$Mode;Source=$rtl;Cases=$parsed.Count;TargetBoundaryErrors=($parsed.boundary|Measure-Object -Sum).Sum;OutputSequenceErrors=($parsed.seq|Measure-Object -Sum).Sum}
$summary | Format-List
if($Mode -eq 'candidate' -and ($summary.Cases -ne 640 -or $summary.TargetBoundaryErrors -ne 0 -or $summary.OutputSequenceErrors -ne 0)) { throw 'Candidate acceptance gate failed: require 640 cases and zero target/serial errors.' }

