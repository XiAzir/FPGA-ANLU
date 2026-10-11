param([Parameter(Mandatory)][ValidatePattern('^x\d+y\d+$')][string]$Grid)
$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$taskOutput=Join-Path $taskRoot "build/attempt_streaming_move_$Grid"
$taskManual=Join-Path $taskRoot 'build/manual'
$taskSelection=Join-Path $taskManual 'selected_physical.info.json'
if(Test-Path -LiteralPath $taskSelection) {throw 'Do not overwrite a selected physical result'}
foreach($taskPair in @(@('move_console.log','Successfully moved 1 instances'),@('physical_console.log','MOVED_ROUTE_HOLD_COMPLETE'))) {
    if(!(Select-String -LiteralPath (Join-Path $taskOutput $taskPair[0]) -SimpleMatch $taskPair[1] -Quiet)) {throw 'Missing verified move/route result'}
}
$taskTiming=Get-Content -Raw -LiteralPath (Join-Path $taskOutput 'AC201_tf_hdmi_phy.ts')
$taskMatch=[regex]::Match($taskTiming,'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns\.')
if(!$taskMatch.Success) {throw 'Missing final timing'}
foreach($taskGroup in 1..4) {if([double]$taskMatch.Groups[$taskGroup].Value -lt 0) {throw 'Timing violation; do not select'}}
$taskSources=Join-Path $taskRoot 'src/user_source'
$taskScope=@(Get-Content -Raw -LiteralPath (Join-Path $taskOutput 'build_source_scope.json') | ConvertFrom-Json)
foreach($taskEntry in $taskScope) {if((Get-FileHash -LiteralPath (Join-Path $taskSources $taskEntry.path)).Hash -ne $taskEntry.sha256) {throw 'Source changed since build'}}
foreach($taskFile in @('AC201_tf_hdmi_pr.db','AC201_tf_hdmi_phy.ts','AC201_tf_hdmi_pr.timing','AC201_tf_hdmi_chk.timing','AC201_tf_hdmi_exception.timing','AC201_tf_hdmi_phy.area','physical_console.log')) {
    Copy-Item -LiteralPath (Join-Path $taskOutput $taskFile) -Destination (Join-Path $taskManual $taskFile)
}
if(Test-Path -LiteralPath (Join-Path $taskManual 'hold_console.log')) {
    Move-Item -LiteralPath (Join-Path $taskManual 'hold_console.log') -Destination (Join-Path $taskManual 'historical_hold_console_before_streaming.log')
}
[ordered]@{
    selected_beijing=[TimeZoneInfo]::ConvertTimeBySystemTimeZoneId([DateTime]::UtcNow,'China Standard Time').ToString('yyyy-MM-dd HH:mm:ss');
    input='original streaming synthesis and placed DB';selected_from=$taskOutput;
    placement_change='one existing packed MSLICE (SDRAM sdr_t plus addr16) moved from grid (2,24) to (17,36)';
    move_log=Join-Path $taskOutput 'move_console.log';physical_marker='MOVED_ROUTE_HOLD_COMPLETE';
    routed_db_sha256=(Get-FileHash -LiteralPath (Join-Path $taskManual 'AC201_tf_hdmi_pr.db')).Hash;
    sdc_adc_pll_phy_hdl_unchanged=$true;hold_fix='included in selected physical_console.log';
    timing=@{SWNS_ns=[double]$taskMatch.Groups[1].Value;STNS_ns=[double]$taskMatch.Groups[2].Value;HWNS_ns=[double]$taskMatch.Groups[3].Value;HTNS_ns=[double]$taskMatch.Groups[4].Value}
} | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $taskSelection -Encoding utf8
Get-Content -LiteralPath $taskSelection
