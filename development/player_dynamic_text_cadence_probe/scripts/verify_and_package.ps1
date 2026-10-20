$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$taskRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$taskRepo=(Resolve-Path (Join-Path $taskRoot '../..')).Path
$taskManual=Join-Path $taskRoot 'build/manual'
$taskAudit=Join-Path $taskRoot 'build/audit'
$taskScope=@(Get-Content -Raw -LiteralPath "$taskManual/build_source_scope.json" | ConvertFrom-Json)
foreach($entry in $taskScope) {
    $actual=Get-FileHash -LiteralPath (Join-Path "$taskRoot/src" $entry.path)
    if($actual.Hash -ne $entry.sha256){throw "Build source mismatch: $($entry.path)"}
}
$taskFallback=Join-Path $taskRepo 'download/osd_phy_fix.bit'
$taskFallbackHash='9E893B0B6C86BF6FBEE19E74B5FB58933C1BEA6AA07F203786CCE96F3B60AE6F'
if((Get-FileHash -LiteralPath $taskFallback).Hash -ne $taskFallbackHash){throw 'Fallback hash mismatch'}
$taskOldCheckpoints=@(
    'player_osd_phy_fix/checkpoints/osd_phy_fix_20261009_candidate',
    'player_dynamic_text_axis_probe/checkpoints/axis_probe_20261009_candidate'
)
$taskFrozen=@()
foreach($relative in $taskOldCheckpoints){
    $checkpoint=Join-Path "$taskRepo/development" $relative
    $entries=@(Get-Content -Raw -LiteralPath "$checkpoint/manifest.json" | ConvertFrom-Json)
    foreach($entry in $entries){
        Assert-AnluInputFile (Join-Path $checkpoint $entry.path)
        $file=Get-Item -LiteralPath (Join-Path $checkpoint $entry.path)
        if($file.Length -ne $entry.bytes -or (Get-FileHash -LiteralPath $file.FullName).Hash -ne $entry.sha256){throw "Frozen mismatch: $($file.FullName)"}
    }
    $taskFrozen += [ordered]@{checkpoint=$checkpoint;files=$entries.Count;result='PASS'}
}
$taskBase=Join-Path $taskRepo 'development/player_dynamic_text_axis_probe/src/user_source'
Assert-AnluInputFile "$taskManual/AC201_tf_hdmi_pr.db"
$taskSource=Join-Path $taskRoot 'src/user_source'
$taskDiff=[ordered]@{unchanged=0;changed=@();added=@();removed=@()}
foreach($file in Get-ChildItem -LiteralPath $taskSource -Recurse -Force -File){
    $rel=[IO.Path]::GetRelativePath($taskSource,$file.FullName).Replace('\','/')
    $old=Join-Path $taskBase $rel
    if(!(Test-Path -LiteralPath $old)){$taskDiff.added+=$rel}
    elseif((Get-FileHash -LiteralPath $old).Hash -ne (Get-FileHash -LiteralPath $file.FullName).Hash){$taskDiff.changed+=$rel}
    else{$taskDiff.unchanged++}
}
foreach($file in Get-ChildItem -LiteralPath $taskBase -Recurse -Force -File){
    $rel=[IO.Path]::GetRelativePath($taskBase,$file.FullName).Replace('\','/')
    if(!(Test-Path -LiteralPath (Join-Path $taskSource $rel))){$taskDiff.removed+=$rel}
}
if($taskDiff.unchanged -ne 74 -or $taskDiff.changed.Count -ne 2 -or $taskDiff.added.Count -ne 1 -or $taskDiff.removed.Count -ne 1){throw 'Unexpected source scope'}
$taskTiming=Get-Content -Raw -LiteralPath "$taskManual/AC201_tf_hdmi_phy.ts"
$taskMatch=[regex]::Match($taskTiming,'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns\.')
if(!$taskMatch.Success){throw 'Timing format'}
foreach($idx in 1..4){if([double]$taskMatch.Groups[$idx].Value -lt 0){throw 'Timing violation'}}
if(!(Select-String -LiteralPath "$taskManual/bitstream_console.log" -SimpleMatch 'BITSTREAM_GENERATED' -Quiet)){throw 'No bitgen completion'}
$taskBit=Get-Item -LiteralPath "$taskManual/AC201_player_dynamic_text_cadence_probe.bit"
$taskBitHash=(Get-FileHash -LiteralPath $taskBit.FullName).Hash
$taskNetlist=Get-Content -Raw -LiteralPath "$taskAudit/final_pr_routed.v"
foreach($token in @('u_cadence_probe/window_audio_samples','u_cadence_probe/window_half_cycles','u_cadence_probe/prev_window_reg','u_status_monitor/window_toggle_out')){
    if(!$taskNetlist.Contains($token)){throw "Missing routed observer: $token"}
}
foreach($item in @(@('cadence_model','PASS checks=200'),@('status_integration_model','PASS checks=80'))){
    if(!(Select-String -LiteralPath "$taskRoot/build/$($item[0])/run.log" -SimpleMatch $item[1] -Quiet)){throw "Model failed: $($item[0])"}
}
$taskTime=[TimeZoneInfo]::ConvertTimeBySystemTimeZoneId([DateTimeOffset]::UtcNow,'China Standard Time').ToString('yyyy-MM-dd HH:mm:ss zzz')
$taskInfo=[ordered]@{
    created_beijing=$taskTime;status='DIAGNOSTIC_CANDIDATE_LOCAL_CHECKS_PASS_BOARD_PENDING';hardware_result='NOT_TESTED';root_cause='NOT_CONFIRMED'
    bitstream=$taskBit.FullName;download="$taskRepo/download/cadence_probe.bit";bytes=$taskBit.Length;sha256=$taskBitHash
    parent='player_dynamic_text_axis_probe';source_diff=$taskDiff;build_source_scope_matched=$taskScope.Count
    timing=[ordered]@{SWNS_ns=0.472;STNS_ns=0;HWNS_ns=0.067;HTNS_ns=0;coverage_percent=99.97}
    prehold=[ordered]@{SWNS_ns=0.472;HWNS_ns=-0.012;HTNS_ns=-0.016}
    resources=[ordered]@{lut=16997;reg=7879;le=18329;bram9k=19;dsp=0;gclk=2}
    routed_db_sha256=(Get-FileHash -LiteralPath "$taskManual/AC201_tf_hdmi_pr.db").Hash
    routed_observer_present=$true
    models=[ordered]@{observer='PASS 200 checks, real 25M-edge window and 59 real frames';integration='PASS 80 checks, 17 scaled 50000-edge mailbox windows and two real frames, all 9 page payloads';scope='Partial RTL, no encrypted HDMI or physical board model'}
    page_format='page[31:28], flags[27:24], payload[23:0]';observer_flags='{tone_mode,core_locked,audio_seen,window_seen}';build_id='C10902'
    fallback=$taskFallback;fallback_sha256=$taskFallbackHash;frozen_guards=$taskFrozen;agent_card_or_flash_operations='NONE'
    limitations=@('Passive logic changes placement and fanout; recovery does not uniquely identify old cause.','Clock word is measured before serializer; correct word does not prove TMDS pin waveform.','Observer uses the same pixel clock; no absolute frequency measurement.','Gap and clock error counters accumulate and saturate. Startup WAV gap can be historical.','External SPI IO delays uncharacterized; three dummy-node groups and shared-IP warnings remain.','Scalar request_toggle use-before-declaration warning reviewed in RTL integration and routed connection; no width redeclaration.')
}
$taskInfo | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath "$taskManual/AC201_player_dynamic_text_cadence_probe.info.json" -Encoding utf8
$taskInfo | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath "$taskAudit/final_build_review.json" -Encoding utf8
$taskDownload=Join-Path $taskRepo 'download/cadence_probe.bit'
if(Test-Path -LiteralPath $taskDownload){throw 'Download candidate already exists; do not silently replace'}
Copy-Item -LiteralPath $taskBit.FullName -Destination $taskDownload
Copy-Item -LiteralPath "$taskManual/AC201_player_dynamic_text_cadence_probe.info.json" -Destination "$taskRepo/download/cadence_probe.info.json"
if((Get-FileHash -LiteralPath $taskDownload).Hash -ne $taskBitHash){throw 'Download copy hash'}

$taskCheckpoint=Join-Path $taskRoot 'checkpoints/cadence_probe_20261010_candidate'
if(Test-Path -LiteralPath $taskCheckpoint){throw 'Checkpoint already exists'}
New-Item -ItemType Directory -Path $taskCheckpoint -Force | Out-Null
$taskFiles=@($taskScope | ForEach-Object {Get-Item -LiteralPath (Join-Path "$taskRoot/src" $_.path)})
foreach($dir in @('scripts','sim','build/manual','build/prehold','build/audit','build/cadence_model','build/status_integration_model')){
    $taskFiles+=Get-ChildItem -LiteralPath (Join-Path $taskRoot $dir) -Recurse -Force -File
}
foreach($file in $taskFiles | Sort-Object FullName -Unique){
    $dest=Join-Path $taskCheckpoint ([IO.Path]::GetRelativePath($taskRoot,$file.FullName))
    New-Item -ItemType Directory -Force -Path (Split-Path $dest) | Out-Null
    Copy-Item -LiteralPath $file.FullName -Destination $dest
}
$taskManifest=@(Get-ChildItem -LiteralPath $taskCheckpoint -Recurse -Force -File | Sort-Object FullName | ForEach-Object {
    [ordered]@{path=[IO.Path]::GetRelativePath($taskCheckpoint,$_.FullName).Replace('\','/');bytes=$_.Length;sha256=(Get-FileHash -LiteralPath $_.FullName).Hash}
})
$taskManifest | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath "$taskCheckpoint/manifest.json" -Encoding utf8
foreach($entry in $taskManifest){if((Get-FileHash -LiteralPath (Join-Path $taskCheckpoint $entry.path)).Hash -ne $entry.sha256){throw 'Checkpoint verify failed'}}

$taskPackage=Join-Path $taskRepo 'deliverables/cadence_probe_20261010'
if(Test-Path -LiteralPath $taskPackage){throw 'Package already exists'}
New-Item -ItemType Directory -Path $taskPackage | Out-Null
Copy-Item -LiteralPath $taskDownload -Destination "$taskPackage/cadence_probe.bit"
Copy-Item -LiteralPath $taskFallback -Destination "$taskPackage/osd_phy_fix.bit"
Copy-Item -LiteralPath "$taskManual/AC201_player_dynamic_text_cadence_probe.info.json" -Destination "$taskPackage/cadence_probe.info.json"
Copy-Item -LiteralPath (Join-Path $AnluDocsRoot '开发记录/专题记录/OSD状态显示/动态字幕资源版竖线_20261009/节奏诊断候选_20261010.md') -Destination "$taskPackage/README.md"
$taskPackageManifest=@(Get-ChildItem -LiteralPath $taskPackage -File | Sort-Object Name | ForEach-Object {
    [ordered]@{path=$_.Name;bytes=$_.Length;sha256=(Get-FileHash -LiteralPath $_.FullName).Hash}
})
$taskPackageManifest | ConvertTo-Json | Set-Content -LiteralPath "$taskPackage/manifest.json" -Encoding utf8
$taskZip="$taskPackage.zip"
if(Test-Path -LiteralPath $taskZip){throw 'ZIP already exists'}
[IO.Compression.ZipFile]::CreateFromDirectory($taskPackage,$taskZip)
$archive=[IO.Compression.ZipFile]::OpenRead($taskZip)
try{
    foreach($entry in $taskPackageManifest){
        $zipEntry=$archive.GetEntry($entry.path)
        if(!$zipEntry -or $zipEntry.Length -ne $entry.bytes){throw 'ZIP entry mismatch'}
        $stream=$zipEntry.Open()
        try{$hash=[Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($stream))}finally{$stream.Dispose()}
        if($hash -ne $entry.sha256){throw 'ZIP content hash mismatch'}
    }
}finally{$archive.Dispose()}
$taskResult=[ordered]@{recorded_beijing=$taskTime;result='PASS';bit_sha256=$taskBitHash;checkpoint=$taskCheckpoint;checkpoint_files=$taskManifest.Count;zip=$taskZip;zip_bytes=(Get-Item -LiteralPath $taskZip).Length;zip_sha256=(Get-FileHash -LiteralPath $taskZip).Hash;hardware_result='NOT_TESTED'}
$taskResult | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath "$taskRoot/build/delivery_verification.json" -Encoding utf8
$taskResult | ConvertTo-Json -Depth 4
