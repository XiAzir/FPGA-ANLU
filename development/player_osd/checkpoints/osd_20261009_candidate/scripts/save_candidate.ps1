$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$taskManual=Join-Path $taskRoot 'build/manual'
$taskBit=Join-Path $taskManual 'AC201_player_osd.bit'
foreach($taskCheck in @(@('synthesis_console.log','SYNTHESIS_COMPLETE_WITH_GATE_DATABASE'),@('bitstream_console.log','BITSTREAM_GENERATED'))) {
    if(!(Select-String -LiteralPath (Join-Path $taskManual $taskCheck[0]) -SimpleMatch $taskCheck[1] -Quiet)) {throw 'Missing successful build marker'}
}
foreach($taskTest in @('build/osd_sim/run.log','build/state_sim/run.log')) {
    $taskText=Get-Content -LiteralPath (Join-Path $taskRoot $taskTest) -Raw
    if($taskText -notmatch 'PASS' -or $taskText -match 'FAIL|FATAL') {throw "Test not passed: $taskTest"}
}
$taskScope=Get-Content -Raw -LiteralPath (Join-Path $taskManual 'build_source_scope.json') | ConvertFrom-Json
foreach($taskEntry in $taskScope) {
    if((Get-FileHash -LiteralPath (Join-Path $taskRoot ('src/'+$taskEntry.path))).Hash -ne $taskEntry.sha256) {throw "Source mismatch: $($taskEntry.path)"}
}
$taskTiming=Get-Content -Raw -LiteralPath (Join-Path $taskManual 'AC201_tf_hdmi_phy.ts')
$taskM=[regex]::Match($taskTiming,'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns\.')
if(!$taskM.Success) {throw 'No final timing status'}
foreach($taskGroup in 1..4) {if([double]$taskM.Groups[$taskGroup].Value -lt 0) {throw 'Timing violation; do not save candidate'}}
$taskArea=Get-Content -Raw -LiteralPath (Join-Path $taskManual 'AC201_tf_hdmi_phy.area')
$taskResources=[ordered]@{}
foreach($taskName in @('lut','reg','le','bram9k','dsp','gclk')) {
    $taskR=[regex]::Match($taskArea,"(?m)^\s*#$taskName\s+(\d+)")
    if(!$taskR.Success) {throw "Missing resource $taskName"}
    $taskResources[$taskName]=[int]$taskR.Groups[1].Value
}
$taskSummary=Get-Content -Raw -LiteralPath (Join-Path $taskManual 'AC201_tf_hdmi_pr.timing')
$taskCoverage=[regex]::Match($taskSummary,'STA coverage\s*:\s*([\d.]+)%')
if(!$taskCoverage.Success) {throw 'Missing STA coverage'}
$taskBase=(Get-Content -Raw -LiteralPath (Join-Path $taskRoot 'build/baseline.json') | ConvertFrom-Json).baseline
$taskOld=Join-Path $taskBase 'src/user_source'
$taskNew=Join-Path $taskRoot 'src/user_source'
$taskChanged=@(); $taskAdded=@()
foreach($taskF in (Get-ChildItem -LiteralPath $taskNew -Recurse -Force -File)) {
    $taskRel=[IO.Path]::GetRelativePath($taskNew,$taskF.FullName)
    $taskPeer=Join-Path $taskOld $taskRel
    if(!(Test-Path -LiteralPath $taskPeer)) {$taskAdded+=$taskRel}
    elseif((Get-FileHash -LiteralPath $taskPeer).Hash -ne (Get-FileHash -LiteralPath $taskF.FullName).Hash) {$taskChanged+=$taskRel}
}
if(@(Compare-Object $taskChanged @('hdl_source\tf_bmp_file_player.v','hdl_source\top_tf_hdmi_audio.v')).Count) {throw 'Unexpected changes to playback baseline'}
if(@(Compare-Object $taskAdded @('hdl_source\player_osd.v','hdl_source\player_osd_state.v')).Count) {throw 'Unexpected added source'}
$taskInfo=[ordered]@{
    created_beijing=[TimeZoneInfo]::ConvertTimeBySystemTimeZoneId([DateTimeOffset]::UtcNow,'China Standard Time').ToString('yyyy-MM-dd HH:mm:ss')
    status='OSD model/build/original-constraint timing passed; hardware pending'
    baseline=$taskBase;baseline_bit_sha256='C2B3DEAFB78355C124CE8958015EED31CEBA38CD4B0B41D9179A7190E4200818'
    device='EG4S20BG256';td='6.2.178840';bitstream=$taskBit
    bytes=(Get-Item -LiteralPath $taskBit).Length;sha256=(Get-FileHash -LiteralPath $taskBit).Hash
    routed_db_sha256=(Get-FileHash -LiteralPath (Join-Path $taskManual 'AC201_tf_hdmi_pr.db')).Hash
    changed_sources=$taskChanged;added_sources=$taskAdded
    original_audio_ip_pll_sdc_pins_unchanged=$true
    timing=[ordered]@{SWNS_ns=[double]$taskM.Groups[1].Value;STNS_ns=[double]$taskM.Groups[2].Value;HWNS_ns=[double]$taskM.Groups[3].Value;HTNS_ns=[double]$taskM.Groups[4].Value}
    sta_coverage_percent=[double]$taskCoverage.Groups[1].Value;resources=$taskResources
    tests=@('six complete 640x480 frames / 1843200 active pixels / 46080 overlay pixels','838 dual-clock mailbox, reset and frame-selection assertions')
    behavior='IMG current/total and MANUAL/AUTO; 240x32 black panel at (16,16), 5x7 white glyphs scaled 2x; no RGB pipeline delay; metadata and memory buffer selected together, read request delayed one pixel cycle'
    hardware_result='not tested';hardware_operations='none by assistant';card_or_flash_writes='none'
    limits=@('RTL simulation is not proof of metastability absence or encrypted-IP / board correctness','Existing read_ack CDC and ping-pong buffer lifetime remain; writer reuse is not a full anti-tearing protocol','Original board IO-delay, physical clock-frequency and encrypted-IP warning boundaries remain','Historical audio-noise root cause unresolved; new implementation needs real-board audio and image regression','Status text is implemented; scrolling subtitles and other planned extensions are not')
}
$taskCheckpoint=Join-Path $taskRoot 'checkpoints/osd_20261009_candidate'
if(Test-Path -LiteralPath $taskCheckpoint) {throw 'Do not overwrite existing checkpoint'}
$taskInfo | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath (Join-Path $taskManual 'AC201_player_osd.info.json') -Encoding utf8
New-Item -ItemType Directory -Path $taskCheckpoint,(Join-Path $taskCheckpoint 'build') | Out-Null
foreach($taskItem in @('src','scripts','sim')) {Copy-Item -LiteralPath (Join-Path $taskRoot $taskItem) -Destination $taskCheckpoint -Recurse}
foreach($taskItem in @('manual','osd_sim','state_sim')) {Copy-Item -LiteralPath (Join-Path $taskRoot ('build/'+$taskItem)) -Destination (Join-Path $taskCheckpoint 'build') -Recurse}
Copy-Item -LiteralPath (Join-Path $taskRoot 'build/baseline.json') -Destination (Join-Path $taskCheckpoint 'build')
$taskManifest=@(Get-ChildItem -LiteralPath $taskCheckpoint -Recurse -Force -File | Sort-Object FullName | ForEach-Object {
    [ordered]@{path=[IO.Path]::GetRelativePath($taskCheckpoint,$_.FullName);bytes=$_.Length;sha256=(Get-FileHash -LiteralPath $_.FullName).Hash}
})
$taskManifest | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $taskCheckpoint 'manifest.json') -Encoding utf8
foreach($taskEntry in $taskManifest) {if((Get-FileHash -LiteralPath (Join-Path $taskCheckpoint $taskEntry.path)).Hash -ne $taskEntry.sha256) {throw 'Checkpoint verification failed'}}
[ordered]@{sha256=$taskInfo.sha256;bytes=$taskInfo.bytes;timing=$taskInfo.timing;coverage=$taskInfo.sta_coverage_percent;resources=$taskResources;checkpoint_files=$taskManifest.Count;checkpoint=$taskCheckpoint} | ConvertTo-Json -Depth 6
