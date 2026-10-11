$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$taskManual=Join-Path $taskRoot 'build/manual'
$taskBit=Join-Path $taskManual 'AC201_player_fat32_packet_diag.bit'
$taskSelection=$null
$taskPhysicalMarker='PLACE_ROUTE_COMPLETE_WITH_REPORTS'
if(Test-Path -LiteralPath (Join-Path $taskManual 'selected_physical.info.json')) {
    $taskSelection=Get-Content -Raw -LiteralPath (Join-Path $taskManual 'selected_physical.info.json') | ConvertFrom-Json
    $taskPhysicalMarker=$taskSelection.physical_marker
    if((Get-FileHash -LiteralPath (Join-Path $taskManual 'AC201_tf_hdmi_pr.db')).Hash -ne $taskSelection.routed_db_sha256) {throw 'Selected route DB mismatch'}
}
foreach($taskLogMarker in @(@('synthesis_console.log','SYNTHESIS_COMPLETE_WITH_GATE_DATABASE'),@('physical_console.log',$taskPhysicalMarker),@('bitstream_console.log','BITSTREAM_GENERATED'))) {
    if(!(Select-String -LiteralPath (Join-Path $taskManual $taskLogMarker[0]) -SimpleMatch $taskLogMarker[1] -Quiet)) { throw "Missing build marker $($taskLogMarker[1])" }
}
foreach($taskTest in @('build/status_monitor_sim/run.log','build/status_hex_sim/run.log','sim/test_result.txt')) {
    if(!(Select-String -LiteralPath (Join-Path $taskRoot $taskTest) -SimpleMatch 'PASS' -Quiet)) { throw "Missing model PASS $taskTest" }
    if(Select-String -LiteralPath (Join-Path $taskRoot $taskTest) -Pattern '^FAIL|FATAL|failures=[1-9]' -Quiet) { throw "Model failure $taskTest" }
}
$taskTiming=Get-Content -Raw -LiteralPath (Join-Path $taskManual 'AC201_tf_hdmi_phy.ts')
$taskM=[regex]::Match($taskTiming,'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns\.')
if(!$taskM.Success) { throw 'Unrecognized timing' }
foreach($taskGroup in 1..4) { if([double]$taskM.Groups[$taskGroup].Value -lt 0) { throw 'Cannot save candidate with timing violations' } }
$taskReport=Get-Content -Raw -LiteralPath (Join-Path $taskManual 'AC201_tf_hdmi_pr.timing')
$taskCoverage=[regex]::Match($taskReport,'STA coverage\s*:\s*([\d.]+)%').Groups[1].Value
$taskResources=@{}
$taskArea=Get-Content -Raw -LiteralPath (Join-Path $taskManual 'AC201_tf_hdmi_phy.area')
foreach($taskResource in @('lut','reg','le','bram9k','dsp','gclk')) {
    $taskR=[regex]::Match($taskArea,"(?m)^\s*#$taskResource\s+(\d+)")
    if(!$taskR.Success) { throw "Missing resource $taskResource" }
    $taskResources[$taskResource]=[int]$taskR.Groups[1].Value
}
$taskBaseline=Join-Path (Split-Path $taskRoot) 'player_fat32_status_diag/src/user_source'
$taskSources=Join-Path $taskRoot 'src/user_source'
$taskChanged=@();$taskHashes=[ordered]@{}
foreach($taskF in (Get-ChildItem -LiteralPath $taskBaseline -File -Recurse)) {
    $taskRel=[IO.Path]::GetRelativePath($taskBaseline,$taskF.FullName)
    $taskPeer=Join-Path $taskSources $taskRel
    $taskHash=(Get-FileHash -LiteralPath $taskPeer).Hash
    if($taskHash -ne (Get-FileHash -LiteralPath $taskF.FullName).Hash) { $taskChanged+=$taskRel }
    $taskHashes[$taskRel]=$taskHash
}
if((($taskChanged|Sort-Object) -join '|') -ne 'hdl_source\player_status_monitor.v|hdl_source\top_tf_hdmi_audio.v') { throw 'Unexpected source change relative to status_diag' }
$taskAdded=@(Get-ChildItem -LiteralPath $taskSources -File -Recurse | Where-Object {
    !(Test-Path -LiteralPath (Join-Path $taskBaseline ([IO.Path]::GetRelativePath($taskSources,$_.FullName))))
} | ForEach-Object { [IO.Path]::GetRelativePath($taskSources,$_.FullName) })
if(($taskAdded -join '|') -ne 'hdl_source\hdmi_packet_monitor.v') { throw 'Unexpected added source' }
$taskHashes[$taskAdded[0]]=(Get-FileHash -LiteralPath (Join-Path $taskSources $taskAdded[0])).Hash
$taskScope=@(Get-Content -Raw -LiteralPath (Join-Path $taskManual 'build_source_scope.json') | ConvertFrom-Json)
foreach($taskEntry in $taskScope) { if((Get-FileHash -LiteralPath (Join-Path $taskSources $taskEntry.path)).Hash -ne $taskEntry.sha256) { throw 'Source changed after build' } }
$taskStamp=[TimeZoneInfo]::ConvertTimeBySystemTimeZoneId([DateTime]::UtcNow,'China Standard Time').ToString('yyyy-MM-dd HH:mm:ss')
$taskInfo=[ordered]@{
    created_beijing=$taskStamp;status='packet diagnostic build/model/timing complete; hardware pending; not a repair';
    device='EG4S20BG256';td='6.2.178840';bitstream=$taskBit;
    bytes=(Get-Item -LiteralPath $taskBit).Length;sha256=(Get-FileHash -LiteralPath $taskBit).Hash;
    baseline='status_diag observed: both sources noisy, input counts match reference';
    unchanged_baseline_source_count=$taskHashes.Count-3;changed_baseline_source=$taskChanged;added_sources=$taskAdded;
    original_sdc_and_pins_unchanged=$true;
    diagnostic_clock='existing pixel clock, input mailbox consumer on falling edge; registered packet counts read in same domain; no new clocks/exceptions';
    timing=[ordered]@{SWNS_ns=[double]$taskM.Groups[1].Value;STNS_ns=[double]$taskM.Groups[2].Value;HWNS_ns=[double]$taskM.Groups[3].Value;HTNS_ns=[double]$taskM.Groups[4].Value};
    selected_physical=$taskSelection;
    sta_coverage_percent=[double]$taskCoverage;resources=$taskResources;
    model_tests=@('independent reflected BCH vector and directed packet parser tests','exact nine-page status display observations (1,3,6-C)','external 595 chain, 25MHz, 0-F, blanking and refresh');
    packet_monitor_implementation='single 56-bit payload for CTS/N; online ACR repeated payload equality; online independent L/R +/-AMP comparison including terminal pairs; 47 directed assertions PASS';
    hardware_result='not tested';hardware_operations='none by assistant';card_or_flash_writes='none';
    limits=@('Instrumentation changes physical implementation; not a waveform capture of old failing bitstreams','Passive parallel-core output tap does not observe PHY pins or receiver acceptance','Packet counters saturate at 65535 per nominal second','Tone first window may include old WAV FIFO samples; read stable later windows','Nominal clock frequency unmeasured; board IO delay and encrypted IP warning boundaries retained','Audio noise root cause unresolved');
    source_hashes=$taskHashes
}
$taskCheckpoint=Join-Path $taskRoot 'checkpoints/packet_diag_20261008_candidate'
if(Test-Path -LiteralPath $taskCheckpoint) { throw 'Do not overwrite an existing checkpoint' }
$taskInfo|ConvertTo-Json -Depth 12|Set-Content -LiteralPath (Join-Path $taskManual 'AC201_player_fat32_packet_diag.info.json') -Encoding utf8
New-Item -ItemType Directory -Force -Path $taskCheckpoint,(Join-Path $taskCheckpoint 'build')|Out-Null
foreach($taskItem in @('src','scripts','sim','README.md')) { Copy-Item -LiteralPath (Join-Path $taskRoot $taskItem) -Destination $taskCheckpoint -Recurse }
Get-ChildItem -LiteralPath (Join-Path $taskRoot 'build') | ForEach-Object {
    Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $taskCheckpoint 'build') -Recurse
}
$taskManifest=@(Get-ChildItem -LiteralPath $taskCheckpoint -Recurse -File | ForEach-Object { [ordered]@{path=[IO.Path]::GetRelativePath($taskCheckpoint,$_.FullName);bytes=$_.Length;sha256=(Get-FileHash -LiteralPath $_.FullName).Hash} })
$taskManifest|ConvertTo-Json -Depth 6|Set-Content -LiteralPath (Join-Path $taskCheckpoint 'manifest.json') -Encoding utf8
foreach($taskEntry in $taskManifest) { if((Get-FileHash -LiteralPath (Join-Path $taskCheckpoint $taskEntry.path)).Hash -ne $taskEntry.sha256) { throw 'Checkpoint hash mismatch' } }
[ordered]@{sha256=$taskInfo.sha256;bytes=$taskInfo.bytes;timing=$taskInfo.timing;coverage=$taskInfo.sta_coverage_percent;resources=$taskResources;source_unchanged=$taskInfo.unchanged_baseline_source_count;checkpoint_files=$taskManifest.Count;checkpoint=$taskCheckpoint}|ConvertTo-Json -Depth 5
