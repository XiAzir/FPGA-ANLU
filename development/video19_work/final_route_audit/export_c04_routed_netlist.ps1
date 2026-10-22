$ErrorActionPreference = 'Stop'
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '../../..')).Path
. (Join-Path $projectRoot 'scripts/anlu_tools.ps1')
$buildRoot = Join-Path $projectRoot 'development/player_video19/build'
$manual = Join-Path $buildRoot 'manual'
$evidence = Join-Path $manual 'stage_evidence'
$synId = '0c69ff10-3139-4672-acea-5a38d730eef0'
$physicalId = 'b5370f50-01db-423e-86d9-407bff967274'
$holdId = '387033ad-cf55-48fa-8c26-507e0577472e'
$bitId = 'bb977f9e-fce9-4d85-aca2-71693525de70'

$syn = Get-Content -LiteralPath (Join-Path $evidence "synthesis_$synId.json") -Raw | ConvertFrom-Json
$physical = Get-Content -LiteralPath (Join-Path $evidence "physical_$physicalId.json") -Raw | ConvertFrom-Json
$hold = Get-Content -LiteralPath (Join-Path $evidence "hold_$holdId.json") -Raw | ConvertFrom-Json
$bit = Get-Content -LiteralPath (Join-Path $evidence "bitstream_$bitId.json") -Raw | ConvertFrom-Json
if ($syn.status -ne 'success' -or $syn.runId -ne $synId) { throw 'C04 synthesis evidence mismatch.' }
if ($physical.status -ne 'success' -or $physical.runId -ne $physicalId -or $physical.synthesisRunId -ne $synId) { throw 'C04 physical evidence mismatch.' }
if ($hold.status -ne 'success' -or $hold.runId -ne $holdId -or $hold.synthesisRunId -ne $synId) { throw 'C04 hold evidence mismatch.' }
if ($bit.status -ne 'success' -or $bit.runId -ne $bitId -or $bit.synthesisRunId -ne $synId -or $bit.routeStage -ne 'hold') { throw 'C04 bitstream evidence mismatch.' }
if ($physical.scopeHash -ne $syn.scopeHash -or $hold.scopeHash -ne $syn.scopeHash -or $bit.scopeHash -ne $syn.scopeHash) { throw 'C04 source scope hashes differ across stages.' }
if ($physical.gateDbHash -ne $syn.gateDbHash -or $hold.gateDbHash -ne $syn.gateDbHash -or $bit.gateDbHash -ne $syn.gateDbHash) { throw 'C04 gate DB hashes differ across stages.' }

$routeDb = Join-Path $manual 'AC201_tf_hdmi_pr.db'
$routeTiming = Join-Path $manual 'AC201_tf_hdmi_pr.timing'
$routeDbHash = (Get-FileHash -LiteralPath $routeDb -Algorithm SHA256).Hash.ToLowerInvariant()
$timingHash = (Get-FileHash -LiteralPath $routeTiming -Algorithm SHA256).Hash.ToLowerInvariant()
if ($routeDbHash -ne $hold.artifacts.'AC201_tf_hdmi_pr.db') { throw 'Final PR DB differs from successful hold record.' }
if ($timingHash -ne $hold.artifacts.'AC201_tf_hdmi_pr.timing') { throw 'Final routed timing report differs from successful hold record.' }

$outNetlist = Join-Path $PSScriptRoot 'AC201_tf_hdmi_c04_pr_routed.v'
$outLog = Join-Path $PSScriptRoot 'dump_c04_routed_netlist.log'
if (Test-Path -LiteralPath $outNetlist) { throw "Refusing to overwrite existing audit netlist: $outNetlist" }
$dbBefore = $routeDbHash
$td = (Resolve-AnluTool -Name 'td_commands_prompt')
& $td ((Join-Path $PSScriptRoot 'dump_c04_routed_netlist.tcl').Replace('\','/')) *> $outLog
if ($LASTEXITCODE -ne 0) { throw "TD read-only export failed ($LASTEXITCODE); see $outLog" }
if (!(Test-Path -LiteralPath $outNetlist)) { throw "TD reported success without routed netlist: $outNetlist" }
$dbAfter = (Get-FileHash -LiteralPath $routeDb -Algorithm SHA256).Hash.ToLowerInvariant()
if ($dbAfter -ne $dbBefore) { throw 'Input PR DB hash changed during read-only export.' }
$sourceScopePath = Join-Path $manual 'build_source_scope.json'
$sourceReceiptPath = Join-Path $buildRoot 'video_system_20261021_200426/source_receipt.json'
$sourceScope = Get-Content -LiteralPath $sourceScopePath -Raw | ConvertFrom-Json
$sourceReceipt = Get-Content -LiteralPath $sourceReceiptPath -Raw | ConvertFrom-Json

$receipt = [ordered]@{
    generated = (Get-Date).ToString('o')
    synthesis_record = [ordered]@{ run_id=$synId; sha256=(Get-FileHash (Join-Path $evidence "synthesis_$synId.json") -Algorithm SHA256).Hash; scope_hash=$syn.scopeHash; gate_db_sha256=$syn.gateDbHash }
    physical_record = [ordered]@{ run_id=$physicalId; sha256=(Get-FileHash (Join-Path $evidence "physical_$physicalId.json") -Algorithm SHA256).Hash }
    hold_record = [ordered]@{ run_id=$holdId; sha256=(Get-FileHash (Join-Path $evidence "hold_$holdId.json") -Algorithm SHA256).Hash }
    bitstream_record = [ordered]@{ run_id=$bitId; sha256=(Get-FileHash (Join-Path $evidence "bitstream_$bitId.json") -Algorithm SHA256).Hash; bit_sha256=$bit.bitHash }
    source_scope = [ordered]@{ path=$sourceScopePath; sha256=(Get-FileHash -LiteralPath $sourceScopePath -Algorithm SHA256).Hash; file_count=$sourceScope.Count; scope_hash=$syn.scopeHash }
    simulation_source_receipt = [ordered]@{ path=$sourceReceiptPath; sha256=(Get-FileHash -LiteralPath $sourceReceiptPath -Algorithm SHA256).Hash; input_count=$sourceReceipt.inputs.Count; compatibility_count=$sourceReceipt.compatibility.Count }
    route_db = [ordered]@{ path=$routeDb; sha256=$dbAfter }
    timing_report = [ordered]@{ path=$routeTiming; sha256=$timingHash }
    exported_netlist = [ordered]@{ path=$outNetlist; sha256=(Get-FileHash -LiteralPath $outNetlist -Algorithm SHA256).Hash; length=(Get-Item -LiteralPath $outNetlist).Length }
    td_version = '6.2.178840 (from C04 stage logs)'
    export_log_sha256 = (Get-FileHash -LiteralPath $outLog -Algorithm SHA256).Hash
    export_command = (Get-Content -LiteralPath (Join-Path $PSScriptRoot 'dump_c04_routed_netlist.tcl') -Raw).Trim()
}
($receipt | ConvertTo-Json -Depth 6) | Set-Content -LiteralPath (Join-Path $PSScriptRoot 'route_export_receipt.json') -Encoding utf8
Write-Output "C04_ROUTED_EXPORT_COMPLETE $outNetlist"
