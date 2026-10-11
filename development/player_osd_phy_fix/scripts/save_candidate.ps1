$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$taskManual=Join-Path $taskRoot 'build/manual'
$taskBit=Join-Path $taskManual 'AC201_player_osd_phy_fix.bit'
$taskCheckpoint=Join-Path $taskRoot 'checkpoints/osd_phy_fix_20261009_candidate'
if(Test-Path -LiteralPath $taskCheckpoint) {throw 'Do not overwrite a frozen candidate'}
foreach($taskCheck in @(@('synthesis_console.log','SYNTHESIS_COMPLETE_WITH_GATE_DATABASE'),@('physical_console.log','PLACE_ROUTE_COMPLETE_WITH_REPORTS'),@('bitstream_console.log','BITSTREAM_GENERATED'))) {
    if(!(Select-String -LiteralPath (Join-Path $taskManual $taskCheck[0]) -SimpleMatch $taskCheck[1] -Quiet)) {throw "Missing build marker: $($taskCheck[0])"}
}
foreach($taskTest in @('build/osd_sim/run.log','build/state_sim/run.log')) {
    $taskText=Get-Content -Raw -LiteralPath (Join-Path $taskRoot $taskTest)
    if($taskText -notmatch 'PASS' -or $taskText -match 'FAIL|FATAL') {throw "Test not passed: $taskTest"}
}
$taskModels=Get-Content -Raw -LiteralPath (Join-Path $taskRoot 'build/model_results.json') | ConvertFrom-Json
if($taskModels.status -ne 'PASS' -or $taskModels.hardware_proof -ne $false) {throw 'Missing independent serializer test evidence'}
$taskScope=Get-Content -Raw -LiteralPath (Join-Path $taskManual 'build_source_scope.json') | ConvertFrom-Json
foreach($taskEntry in $taskScope) {
    if((Get-FileHash -LiteralPath (Join-Path $taskRoot ('src/'+$taskEntry.path))).Hash -ne $taskEntry.sha256) {throw "Synthesis source changed: $($taskEntry.path)"}
}
$taskBaseline=Get-Content -Raw -LiteralPath (Join-Path $taskRoot 'build/baseline.json') | ConvertFrom-Json
$taskOld=Join-Path $taskBaseline.baseline 'src/user_source'
$taskNew=Join-Path $taskRoot 'src/user_source'
$taskOldFiles=@(Get-ChildItem -LiteralPath $taskOld -Recurse -Force -File)
$taskNewFiles=@(Get-ChildItem -LiteralPath $taskNew -Recurse -Force -File)
if($taskOldFiles.Count -ne 74 -or $taskNewFiles.Count -ne 74) {throw 'Unexpected source count'}
$taskChanged=@()
foreach($taskF in $taskNewFiles) {
    $taskRel=[IO.Path]::GetRelativePath($taskNew,$taskF.FullName)
    $taskPeer=Join-Path $taskOld $taskRel
    if(!(Test-Path -LiteralPath $taskPeer)) {throw "Unexpected added file: $taskRel"}
    if((Get-FileHash -LiteralPath $taskPeer).Hash -ne (Get-FileHash -LiteralPath $taskF.FullName).Hash) {$taskChanged+=$taskRel}
}
if($taskChanged.Count -ne 1 -or $taskChanged[0] -ne 'hdl_source\lane_lvds_10_1.v') {throw 'Expected only the serializer source to change'}
$taskTiming=Get-Content -Raw -LiteralPath (Join-Path $taskManual 'AC201_tf_hdmi_phy.ts')
$taskM=[regex]::Match($taskTiming,'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns\.')
if(!$taskM.Success) {throw 'Missing final timing status'}
foreach($taskGroup in 1..4) {if([double]$taskM.Groups[$taskGroup].Value -lt 0) {throw 'Timing violation; do not save candidate'}}
$taskArea=Get-Content -Raw -LiteralPath (Join-Path $taskManual 'AC201_tf_hdmi_phy.area')
$taskResources=[ordered]@{}
foreach($taskName in @('lut','reg','le','bram9k','dsp','gclk')) {
    $taskR=[regex]::Match($taskArea,"(?m)^\s*#$taskName\s+(\d+)")
    if(!$taskR.Success) {throw "Missing resource $taskName"}
    $taskResources[$taskName]=[int]$taskR.Groups[1].Value
}
$taskCoverage=[regex]::Match((Get-Content -Raw -LiteralPath (Join-Path $taskManual 'AC201_tf_hdmi_pr.timing')),'STA coverage\s*:\s*([\d.]+)%')
if(!$taskCoverage.Success) {throw 'Missing STA coverage'}
$taskInfo=[ordered]@{
    created_beijing=[TimeZoneInfo]::ConvertTimeBySystemTimeZoneId([DateTimeOffset]::UtcNow,'China Standard Time').ToString('yyyy-MM-dd HH:mm:ss')
    status='Targeted serializer sampling candidate; models and original-constraint implementation passed; hardware pending'
    device='EG4S20BG256';td='6.2.178840'
    baseline=$taskBaseline;changed_sources=$taskChanged;unchanged_source_count=73
    change='Capture 10-bit pending word on S_load_en_1d; shift loads pending on original S_load_en_2d; shift/ODDR schedule unchanged'
    osd_files_audio_pll_sdc_pins_unchanged=$true
    bitstream=$taskBit;bytes=(Get-Item -LiteralPath $taskBit).Length;sha256=(Get-FileHash -LiteralPath $taskBit).Hash
    routed_db_sha256=(Get-FileHash -LiteralPath (Join-Path $taskManual 'AC201_tf_hdmi_pr.db')).Hash
    timing=[ordered]@{SWNS_ns=[double]$taskM.Groups[1].Value;STNS_ns=[double]$taskM.Groups[2].Value;HWNS_ns=[double]$taskM.Groups[3].Value;HTNS_ns=[double]$taskM.Groups[4].Value}
    sta_coverage_percent=[double]$taskCoverage.Groups[1].Value;resources=$taskResources;models=$taskModels
    hardware_result='not tested';assistant_board_operations='none';card_or_flash_writes='none'
    limits=@('Delay injection reproduces a possible serializer mixed-word mechanism; actual failing board timing is not measured','Whole implementation changes with resynthesis; a passing board A/B alone does not uniquely establish the historical root cause','Behavioral ODDR model is not a silicon or electrical model','Existing frame-buffer lifetime and ACK CDC, IO-delay, physical-frequency and encrypted-IP warning boundaries remain')
}
$taskSelected=Get-Content -Raw -LiteralPath (Join-Path $taskManual 'selected_physical.info.json') | ConvertFrom-Json
if($taskSelected.routed_db_sha256 -ne $taskInfo.routed_db_sha256) {throw 'Selected physical DB does not match candidate'}
if(!(Select-String -LiteralPath $taskSelected.physical_log -SimpleMatch 'TIMING_HIGH_ROUTABILITY_ROUTE_HOLD_COMPLETE' -Quiet)) {throw 'No successful selected physical flow'}
$taskInfo['physical_implementation']=$taskSelected
$taskInfo | ConvertTo-Json -Depth 14 | Set-Content -LiteralPath (Join-Path $taskManual 'AC201_player_osd_phy_fix.info.json') -Encoding utf8
New-Item -ItemType Directory -Path $taskCheckpoint,(Join-Path $taskCheckpoint 'build') | Out-Null
foreach($taskItem in @('src','scripts','sim')) {Copy-Item -LiteralPath (Join-Path $taskRoot $taskItem) -Destination $taskCheckpoint -Recurse -Force}
foreach($taskItem in @('manual','osd_sim','state_sim','serializer_tests')) {Copy-Item -LiteralPath (Join-Path $taskRoot ('build/'+$taskItem)) -Destination (Join-Path $taskCheckpoint 'build') -Recurse -Force}
foreach($taskItem in @('attempt_timing_high','attempt_timing_high_routability')) {Copy-Item -LiteralPath (Join-Path $taskRoot ('build/'+$taskItem)) -Destination (Join-Path $taskCheckpoint 'build') -Recurse -Force}
foreach($taskItem in @('baseline.json','source_delta.json','model_results.json')) {Copy-Item -LiteralPath (Join-Path $taskRoot ('build/'+$taskItem)) -Destination (Join-Path $taskCheckpoint 'build')}
$taskManifest=@(Get-ChildItem -LiteralPath $taskCheckpoint -Recurse -Force -File | Sort-Object FullName | ForEach-Object {
    [ordered]@{path=[IO.Path]::GetRelativePath($taskCheckpoint,$_.FullName);bytes=$_.Length;sha256=(Get-FileHash -LiteralPath $_.FullName).Hash}
})
$taskManifest | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $taskCheckpoint 'manifest.json') -Encoding utf8
foreach($taskEntry in $taskManifest) {if((Get-FileHash -LiteralPath (Join-Path $taskCheckpoint $taskEntry.path)).Hash -ne $taskEntry.sha256) {throw 'Checkpoint verification failed'}}
[ordered]@{sha256=$taskInfo.sha256;bytes=$taskInfo.bytes;timing=$taskInfo.timing;resources=$taskResources;coverage=$taskInfo.sta_coverage_percent;checkpoint=$taskCheckpoint;checkpoint_files=$taskManifest.Count} | ConvertTo-Json -Depth 6
