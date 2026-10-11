$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$taskBase=Join-Path (Split-Path $taskRoot -Parent) 'player_fat32_audio_probe\checkpoints\audio_probe_20261008_verified'
$taskManual=Join-Path $taskRoot 'build\manual'
$taskBit=Join-Path $taskManual 'AC201_player_fat32_autoplay_keepaudio.bit'
if(!(Test-Path -LiteralPath $taskBit)){throw 'Bitstream missing'}
$taskTiming=Get-Content -LiteralPath (Join-Path $taskManual 'AC201_tf_hdmi_phy.ts') -Raw
$taskTimingValues=[ordered]@{}
foreach($taskMetric in @('SWNS','STNS','HWNS','HTNS')) {
    $taskMatch=[regex]::Match($taskTiming,($taskMetric+':\s*(-?[0-9.]+)ns'))
    if(!$taskMatch.Success){throw "Missing timing metric: $taskMetric"}
    $taskTimingValues[$taskMetric+'_ns']=[double]::Parse($taskMatch.Groups[1].Value,[Globalization.CultureInfo]::InvariantCulture)
}
if($taskTimingValues.SWNS_ns -lt 0 -or $taskTimingValues.HWNS_ns -lt 0 -or $taskTimingValues.STNS_ns -ne 0 -or $taskTimingValues.HTNS_ns -ne 0){throw 'Timing violations remain'}
if(!(Select-String -LiteralPath (Join-Path $taskRoot 'build\audio_key_sim\audio_key.log') -SimpleMatch 'PASS autoplay_audio_key' -Quiet)){throw 'Missing short/long audio key PASS'}
foreach($taskStage in @(@('synthesis','SYNTHESIS_COMPLETE_WITH_GATE_DATABASE'),@('physical','PLACE_ROUTE_COMPLETE_WITH_REPORTS'),@('bitstream','BITSTREAM_GENERATED'))) {
    if(!(Select-String -LiteralPath (Join-Path $taskManual ($taskStage[0]+'_console.log')) -SimpleMatch $taskStage[1] -Quiet)){throw "Missing build marker: $($taskStage[0])"}
}
$taskManifest=Get-Content -LiteralPath (Join-Path $taskBase 'manifest.json') -Raw | ConvertFrom-Json
$taskDifferences=@()
foreach($taskSource in @($taskManifest.files | Where-Object{$_.path -like 'src/user_source/*'})) {
    if((Get-FileHash -LiteralPath (Join-Path $taskRoot $taskSource.path) -Algorithm SHA256).Hash -ne $taskSource.sha256){$taskDifferences+=$taskSource.path}
}
if($taskDifferences.Count -ne 1 -or $taskDifferences[0] -ne 'src/user_source/hdl_source/top_tf_hdmi_audio.v'){throw 'Unexpected source changes'}
$taskSources=[ordered]@{}
Get-ChildItem -LiteralPath (Join-Path $taskRoot 'src') -File -Recurse | Where-Object{$_.Extension -in @('.v','.al','.adc','.sdc','.tcl','.ipc')} | Sort-Object FullName | ForEach-Object {
    $taskSources[[IO.Path]::GetRelativePath($taskRoot,$_.FullName).Replace('\','/')]=(Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash
}
$taskSummary=Get-Content -LiteralPath (Join-Path $taskManual 'AC201_tf_hdmi_pr.timing') -Raw
$taskCoverage=[regex]::Match($taskSummary,'STA coverage\s*:\s*([0-9.]+)%')
if(!$taskCoverage.Success){throw 'Missing STA coverage'}
$taskArea=Get-Content -LiteralPath (Join-Path $taskManual 'AC201_tf_hdmi_phy.area') -Raw
$taskResources=[ordered]@{}
foreach($taskMetric in @('lut','reg','le','bram','dsp')) {
    $taskMatch=[regex]::Match($taskArea,('(?m)^#'+$taskMetric+'\s+(\d+)'))
    if(!$taskMatch.Success){throw "Missing resource: $taskMetric"}
    $taskResources[$taskMetric]=[int]$taskMatch.Groups[1].Value
}
if(!(Select-String -LiteralPath (Join-Path $taskManual 'AC201_tf_hdmi_gate.area') -SimpleMatch '|    u_tone' -Quiet)){throw 'Expected dynamic tone circuitry was pruned'}
$taskInfo=[ordered]@{
    created_beijing=(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
    device='EG4S20BG256'
    td='6.2.178840'
    bitstream=$taskBit
    bytes=(Get-Item -LiteralPath $taskBit).Length
    sha256=(Get-FileHash -LiteralPath $taskBit -Algorithm SHA256).Hash
    status='build/timing/model checks complete; hardware pending'
    baseline_checkpoint=$taskBase
    baseline_bit_sha256='4FC48C6678758FC1B74BD0BB9D9DA4FDD6132198BB1AEE8C294C6340EA81CF8C'
    functional_source_differences=$taskDifferences
    keys=[ordered]@{KEY0='manual next image';KEY1='short: toggle automatic slideshow; long>=1.5s: diagnostic tone toggle and one autoplay toggle'}
    audio='default WAV; dynamic internal-tone mux retained, selected by diagnostic long KEY1'
    leds='D3 FIFO nonzero seen; D2 sample consumed; D1 PCM varied; D0 expected ACR occurred; sticky events'
    original_constraints_unchanged=$true
    timing=$taskTimingValues
    sta_coverage_percent=[double]::Parse($taskCoverage.Groups[1].Value,[Globalization.CultureInfo]::InvariantCulture)
    resources=$taskResources
    timing_status_text=$taskTiming.Trim()
    post_route_fix_hold=(Test-Path -LiteralPath (Join-Path $taskManual 'hold_console.log'))
    model_checks=@('short KEY1 pulses preserve WAV source; long threshold not early; long hold triggers once; release rearms; return to WAV')
    model_limits='Scaled-time existing key and audio probe modules; no real card/HDMI/SDRAM; prior autoplay core image/key hardware feedback cannot prove WAV correctness'
    physical_implementation='Dynamic tone and mux retained in gate area; physical placement/routing can still differ from verified probe'
    hardware_operations='none by assistant'
    card_writes='none'
    known_limits=@('Prior failed revisions root cause unresolved','Actual-card long run/change files/fragmentation not hardware verified','Original encrypted SDRAM undriven clk and uncharacterized external IO delays remain','SDRAM macro placement relocation critical warnings also occur in the verified baseline','Segment display not connected')
    sources=$taskSources
}
$taskInfo | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath ([IO.Path]::ChangeExtension($taskBit,'.info.json')) -Encoding utf8
[pscustomobject]@{bit=$taskBit;bytes=$taskInfo.bytes;sha256=$taskInfo.sha256;timing=$taskTimingValues;hardware='pending'} | ConvertTo-Json -Depth 5
