# Save a reproducible incomplete engineering checkpoint; never a candidate bitstream.
$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$taskSources=Join-Path $taskRoot 'src/user_source'
$taskBaseline=Join-Path (Split-Path $taskRoot) 'player_fat32_status_diag/src/user_source'
$taskChanged=@();$taskSame=0
foreach($taskFile in (Get-ChildItem -LiteralPath $taskBaseline -Recurse -File)) {
    $taskRel=[IO.Path]::GetRelativePath($taskBaseline,$taskFile.FullName)
    if((Get-FileHash -LiteralPath (Join-Path $taskSources $taskRel)).Hash -eq (Get-FileHash -LiteralPath $taskFile.FullName).Hash) {$taskSame++} else {$taskChanged+=$taskRel}
}
if((($taskChanged|Sort-Object)-join '|') -ne 'hdl_source\player_status_monitor.v|hdl_source\top_tf_hdmi_audio.v') {throw 'Unexpected changed source'}
if(Test-Path -LiteralPath (Join-Path $taskRoot 'build/manual/AC201_player_fat32_packet_diag.bit')) {throw 'Unexpected packet bitstream in incomplete checkpoint'}
$taskScope=@(Get-Content -LiteralPath (Join-Path $taskRoot 'build/manual/build_source_scope.json') -Raw|ConvertFrom-Json)
foreach($taskEntry in $taskScope) {if((Get-FileHash -LiteralPath (Join-Path $taskSources $taskEntry.path)).Hash -ne $taskEntry.sha256) {throw 'Source changed after synthesis'}}
$taskInfo=[ordered]@{
    saved_beijing=(Get-Date -Format 'yyyy-MM-dd HH:mm:ss');status='INCOMPLETE: models and routing complete; setup violations remain; NO BITSTREAM';
    models=@('reflected BCH external vector + 31 directed packet assertions PASS','nine status pages 1/3/6-C PASS','25MHz external 595 model PASS: 0.926MHz, 120.806Hz');
    baseline='status_diag observed inputs; both sources noisy';unchanged_source_files=$taskSame;changed_sources=$taskChanged;added_source='hdl_source/hdmi_packet_monitor.v';
    sdc_adc_pll_phy_playback_and_595_unchanged=$true;
    default_route_after_fix_hold=[ordered]@{SWNS_ns=-0.263;STNS_ns=-0.708;HWNS_ns=0.031;HTNS_ns=0};
    route_routability_after_fix_hold=[ordered]@{SWNS_ns=-0.329;STNS_ns=-0.922;HWNS_ns=0.031;HTNS_ns=0};
    hfn_placed_after_route=[ordered]@{SWNS_ns=-0.263;STNS_ns=-0.708;HWNS_ns=0.031;HTNS_ns=0;actual_duplicate_count=0};
    timing_bottleneck='encrypted SDRAM registered tristate sdr_t, 34 PAD TS loads, ext_mem_clk to ext_mem_clk_sft, DQ12..15';
    tool_limit='post-route reroute crashed; gate HFN lacked physical cells; literal and get_nets collection both resulted in zero copies';
    hardware_test='not performed';audio_noise_root_cause='unresolved';card_or_flash_writes='none';
    next_step='resolve original-constraint SDRAM output setup before packet hardware observation';
    source_scope=$taskScope
}
$taskInfo|ConvertTo-Json -Depth 9|Set-Content -LiteralPath (Join-Path $taskRoot 'build/incomplete.info.json') -Encoding utf8
$taskCheckpoint=Join-Path $taskRoot 'checkpoints/packet_diag_20261008_incomplete'
if(Test-Path -LiteralPath $taskCheckpoint) {throw 'Do not overwrite checkpoint'}
New-Item -ItemType Directory -Path $taskCheckpoint|Out-Null
foreach($taskItem in @('src','scripts','sim','build','README.md')) {Copy-Item -LiteralPath (Join-Path $taskRoot $taskItem) -Destination $taskCheckpoint -Recurse}
$taskManifest=@(Get-ChildItem -LiteralPath $taskCheckpoint -Recurse -File|ForEach-Object {[ordered]@{path=[IO.Path]::GetRelativePath($taskCheckpoint,$_.FullName);bytes=$_.Length;sha256=(Get-FileHash -LiteralPath $_.FullName).Hash}})
$taskManifest|ConvertTo-Json -Depth 6|Set-Content -LiteralPath (Join-Path $taskCheckpoint 'manifest.json') -Encoding utf8
foreach($taskEntry in $taskManifest) {if((Get-FileHash -LiteralPath (Join-Path $taskCheckpoint $taskEntry.path)).Hash -ne $taskEntry.sha256) {throw 'Checkpoint hash mismatch'}}
[ordered]@{status=$taskInfo.status;unchanged_source_files=$taskSame;changed_sources=$taskChanged;files=$taskManifest.Count;checkpoint=$taskCheckpoint}|ConvertTo-Json -Depth 4
