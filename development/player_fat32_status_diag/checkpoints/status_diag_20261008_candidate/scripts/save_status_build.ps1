$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$taskManual=Join-Path $taskRoot 'build\manual'
$taskBit=Join-Path $taskManual 'AC201_player_fat32_status_diag.bit'
foreach($taskLogMarker in @(@('synthesis_console.log','SYNTHESIS_COMPLETE_WITH_GATE_DATABASE'),@('physical_console.log','PLACE_ROUTE_COMPLETE_WITH_REPORTS'),@('bitstream_console.log','BITSTREAM_GENERATED'))) {
    if(!(Select-String -LiteralPath (Join-Path $taskManual $taskLogMarker[0]) -SimpleMatch $taskLogMarker[1] -Quiet)) { throw "Missing build marker $($taskLogMarker[1])" }
}
foreach($taskTest in @('build\status_monitor_sim\run.log','build\status_hex_sim\run.log')) {
    if(!(Select-String -LiteralPath (Join-Path $taskRoot $taskTest) -SimpleMatch 'PASS' -Quiet)) { throw "Missing model PASS $taskTest" }
}
$taskTiming=Get-Content -Raw -LiteralPath (Join-Path $taskManual 'AC201_tf_hdmi_phy.ts')
$taskM=[regex]::Match($taskTiming,'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns\.')
if(!$taskM.Success) { throw 'Unrecognized timing' }
foreach($taskGroup in 1..4) { if([double]$taskM.Groups[$taskGroup].Value -lt 0) { throw 'Cannot save candidate with timing violations' } }
$taskReport=Get-Content -LiteralPath (Join-Path $taskManual 'AC201_tf_hdmi_pr.timing') -Raw
$taskCoverage=[regex]::Match($taskReport,'STA coverage\s*:\s*([\d.]+)%').Groups[1].Value
$taskResources=@{}
$taskArea=Get-Content -LiteralPath (Join-Path $taskManual 'AC201_tf_hdmi_phy.area') -Raw
foreach($taskResource in @('lut','reg','le','bram9k','dsp','gclk')) {
    $taskR=[regex]::Match($taskArea,"(?m)^\s*#$taskResource\s+(\d+)")
    if(!$taskR.Success) { throw "Missing resource $taskResource" }
    $taskResources[$taskResource]=[int]$taskR.Groups[1].Value
}
$taskBaseline=Join-Path (Split-Path $taskRoot) 'player_fat32_autoplay_keepaudio\src\user_source'
$taskSources=Join-Path $taskRoot 'src\user_source'
$taskChanged=@()
$taskHashes=[ordered]@{}
foreach($taskF in (Get-ChildItem -LiteralPath $taskBaseline -File -Recurse)) {
    $taskRel=[IO.Path]::GetRelativePath($taskBaseline,$taskF.FullName)
    $taskPeer=Join-Path $taskSources $taskRel
    $taskHash=(Get-FileHash -LiteralPath $taskPeer).Hash
    if($taskHash -ne (Get-FileHash -LiteralPath $taskF.FullName).Hash) { $taskChanged+=$taskRel }
    $taskHashes[$taskRel]=$taskHash
}
if((($taskChanged | Sort-Object) -join '|') -ne 'constraints_source\pin.adc|hdl_source\top_tf_hdmi_audio.v') { throw 'Unexpected changed playback source' }
foreach($taskF in @('hdl_source\player_status_monitor.v','hdl_source\status_hex595.v')) { $taskHashes[$taskF]=(Get-FileHash -LiteralPath (Join-Path $taskSources $taskF)).Hash }
$taskStamp=[TimeZoneInfo]::ConvertTimeBySystemTimeZoneId([DateTime]::UtcNow,'China Standard Time').ToString('yyyy-MM-dd HH:mm:ss')
$taskInfo=[ordered]@{
    created_beijing=$taskStamp; status='diagnostic build/model/timing complete; hardware pending; not a repair';
    device='EG4S20BG256'; td='6.2.178840'; bitstream=$taskBit;
    bytes=(Get-Item -LiteralPath $taskBit).Length; sha256=(Get-FileHash -LiteralPath $taskBit).Hash;
    baseline='failed keepaudio'; unchanged_original_playback_source_count=67;
    changed_original_source=$taskChanged; added_sources=@('player_status_monitor.v','status_hex595.v');
    original_sdc_unchanged=$true;
    diagnostic_clock='existing pixel clock, snapshot consumer on falling edge; independent display reset; no added playback clock or exceptions';
    timing=[ordered]@{SWNS_ns=[double]$taskM.Groups[1].Value;STNS_ns=[double]$taskM.Groups[2].Value;HWNS_ns=[double]$taskM.Groups[3].Value;HTNS_ns=[double]$taskM.Groups[4].Value};
    sta_coverage_percent=[double]$taskCoverage;resources=$taskResources;
    model_tests=@('exact 5-page observations and sample/change/frame counts across separate clocks; black/nonblack and independent reset','external 595 chain: shift/latch bit count, blanking/onehot, 0-F, refresh and SCLK limits');
    hardware_result='not tested'; hardware_operations='none by assistant'; card_or_flash_writes='none';
    limits=@('Instrumentation changes physical implementation; not a waveform capture of old failing bitstream','Counts prove signals presented to HDMI input, not receiver acceptance or packet validity','Nominal time windows assume unmeasured 25MHz pixel clock','Existing encrypted SDRAM warnings and board IO delays remain','Root cause unproven; original candidate is a confirmed regression');
    source_hashes=$taskHashes
}
$taskInfoPath=Join-Path $taskManual 'AC201_player_fat32_status_diag.info.json'
$taskInfo|ConvertTo-Json -Depth 12|Set-Content -LiteralPath $taskInfoPath -Encoding utf8
$taskCheckpoint=Join-Path $taskRoot 'checkpoints\status_diag_20261008_candidate'
if(Test-Path -LiteralPath $taskCheckpoint) { throw 'Do not overwrite an existing checkpoint' }
New-Item -ItemType Directory -Force -Path $taskCheckpoint,(Join-Path $taskCheckpoint 'build')|Out-Null
foreach($taskItem in @('src','scripts','sim','README.md')) { Copy-Item -LiteralPath (Join-Path $taskRoot $taskItem) -Destination $taskCheckpoint -Recurse }
foreach($taskItem in @('manual','status_monitor_sim','status_hex_sim','attempt_initial','attempt_status_bufg','attempt_status_negedge','attempt_pixel_prehold','source_scope.json')) {
    $taskPath=Join-Path $taskRoot "build\$taskItem"
    if(Test-Path -LiteralPath $taskPath) { Copy-Item -LiteralPath $taskPath -Destination (Join-Path $taskCheckpoint 'build') -Recurse }
}
$taskManifest=@(Get-ChildItem -LiteralPath $taskCheckpoint -Recurse -File|ForEach-Object { [ordered]@{path=[IO.Path]::GetRelativePath($taskCheckpoint,$_.FullName);bytes=$_.Length;sha256=(Get-FileHash -LiteralPath $_.FullName).Hash} })
$taskManifest|ConvertTo-Json -Depth 6|Set-Content -LiteralPath (Join-Path $taskCheckpoint 'manifest.json') -Encoding utf8
foreach($taskEntry in $taskManifest) {
    if((Get-FileHash -LiteralPath (Join-Path $taskCheckpoint $taskEntry.path)).Hash -ne $taskEntry.sha256) { throw 'Checkpoint hash mismatch' }
}
$taskInfo|ConvertTo-Json -Depth 4
"Checkpoint verified: $($taskManifest.Count) files: $taskCheckpoint"

