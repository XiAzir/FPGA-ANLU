param(
    [Parameter(Mandatory)][string]$RunId,
    [Parameter(Mandatory)][string]$PhysicalRunId,
    [Parameter(Mandatory)][string]$HoldRunId
)
$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '../../..')).Path
. (Join-Path $repoRoot 'scripts/anlu_tools.ps1')
$projectRoot = Join-Path $repoRoot 'development/player_video20'
$manual = Join-Path $projectRoot 'build/manual'
$evidence = Join-Path $manual 'stage_evidence'

function Read-StageRecord([string]$Stage, [string]$Id) {
    $latestPath = Join-Path $evidence "latest_$Stage.json"
    if (!(Test-Path -LiteralPath $latestPath)) { throw "Missing latest $Stage pointer: $latestPath" }
    $pointer = Get-Content -LiteralPath $latestPath -Raw | ConvertFrom-Json
    if ($pointer.stage -ne $Stage -or $pointer.status -ne 'success' -or $pointer.runId -ne $Id) {
        throw "Latest successful $Stage pointer does not match requested C11320 runId $Id"
    }
    $recordPath = Join-Path $evidence $pointer.record
    $record = Get-Content -LiteralPath $recordPath -Raw | ConvertFrom-Json
    if ($record.stage -ne $Stage -or $record.status -ne 'success' -or $record.runId -ne $Id) {
        throw "$Stage record does not match requested runId $Id"
    }
    return [pscustomobject]@{ Pointer=$pointer; PointerPath=$latestPath; Record=$record; RecordPath=$recordPath }
}

$syn = Read-StageRecord 'synthesis' $RunId
$physical = Read-StageRecord 'physical' $PhysicalRunId
$hold = Read-StageRecord 'hold' $HoldRunId
if ($physical.Record.synthesisRunId -ne $RunId -or $hold.Record.synthesisRunId -ne $RunId) {
    throw 'Physical or hold record is not linked to the selected synthesis runId.'
}
if ($physical.Record.scopeHash -ne $syn.Record.scopeHash -or $hold.Record.scopeHash -ne $syn.Record.scopeHash) {
    throw 'Synthesis, physical, and hold source scope hashes differ.'
}
if ($physical.Record.gateDbHash -ne $syn.Record.gateDbHash -or $hold.Record.gateDbHash -ne $syn.Record.gateDbHash) {
    throw 'Synthesis, physical, and hold gate database hashes differ.'
}

$gateDb = Join-Path $manual 'AC201_tf_hdmi_gate.db'
$routeDb = Join-Path $manual 'AC201_tf_hdmi_pr.db'
$timing = Join-Path $manual 'AC201_tf_hdmi_pr.timing'
$gateHash = (Get-FileHash -LiteralPath $gateDb -Algorithm SHA256).Hash.ToLowerInvariant()
$routeHash = (Get-FileHash -LiteralPath $routeDb -Algorithm SHA256).Hash.ToLowerInvariant()
$timingHash = (Get-FileHash -LiteralPath $timing -Algorithm SHA256).Hash.ToLowerInvariant()
if ($gateHash -ne $syn.Record.gateDbHash) { throw 'Current gate database hash differs from selected successful synthesis record.' }
if ($routeHash -ne $hold.Record.artifacts.'AC201_tf_hdmi_pr.db') { throw 'Current final PR database differs from selected successful hold record.' }
if ($timingHash -ne $hold.Record.artifacts.'AC201_tf_hdmi_pr.timing') { throw 'Current routed timing report differs from selected successful hold record.' }

$netlist = Join-Path $PSScriptRoot 'AC201_tf_hdmi_c11320_pr_routed.v'
$log = Join-Path $PSScriptRoot 'dump_c11320_routed_netlist.log'
$receiptPath = Join-Path $PSScriptRoot 'route_export_receipt.json'
foreach ($artifact in @($netlist,$log,$receiptPath)) {
    if (Test-Path -LiteralPath $artifact) { throw "Refusing to overwrite prior audit artifact; preserve it and use a fresh audit directory: $artifact" }
}
$dbBefore = $routeHash
$td = Resolve-AnluTool -Name 'td_commands_prompt'
& $td ((Join-Path $PSScriptRoot 'dump_c11320_routed_netlist.tcl').Replace('\','/')) *> $log
if ($LASTEXITCODE -ne 0) { throw "TD read-only routed export failed ($LASTEXITCODE); see $log" }
if (!(Test-Path -LiteralPath $netlist)) { throw "TD completed without producing the routed netlist: $netlist" }
$dbAfter = (Get-FileHash -LiteralPath $routeDb -Algorithm SHA256).Hash.ToLowerInvariant()
if ($dbAfter -ne $dbBefore) { throw 'Input final PR DB hash changed during read-only export.' }
if ((Get-Item -LiteralPath $netlist).LastWriteTimeUtc -lt [DateTime]::Parse($hold.Record.completedUtc).ToUniversalTime()) {
    throw 'Exported routed netlist predates selected successful hold completion.'
}

$scopePath = Join-Path $manual 'build_source_scope.json'
$scope = Get-Content -LiteralPath $scopePath -Raw | ConvertFrom-Json
$receipt = [ordered]@{
    schema = 'c11320-routed-netlist-export-v1'
    generated = (Get-Date).ToString('o')
    selected_run_ids = [ordered]@{ synthesis=$RunId; physical=$PhysicalRunId; hold=$HoldRunId }
    synthesis_record = [ordered]@{ path=(Resolve-Path $syn.RecordPath).Path; run_id=$RunId; sha256=(Get-FileHash $syn.RecordPath -Algorithm SHA256).Hash; scope_hash=$syn.Record.scopeHash; gate_db_sha256=$gateHash }
    physical_record = [ordered]@{ path=(Resolve-Path $physical.RecordPath).Path; run_id=$PhysicalRunId; sha256=(Get-FileHash $physical.RecordPath -Algorithm SHA256).Hash }
    hold_record = [ordered]@{ path=(Resolve-Path $hold.RecordPath).Path; run_id=$HoldRunId; sha256=(Get-FileHash $hold.RecordPath -Algorithm SHA256).Hash }
    source_scope = [ordered]@{ path=(Resolve-Path $scopePath).Path; sha256=(Get-FileHash $scopePath -Algorithm SHA256).Hash; file_count=$scope.Count; scope_hash=$syn.Record.scopeHash }
    route_db = [ordered]@{ path=(Resolve-Path $routeDb).Path; sha256=$routeHash }
    timing_report = [ordered]@{ path=(Resolve-Path $timing).Path; sha256=$timingHash }
    exported_netlist = [ordered]@{ path=(Resolve-Path $netlist).Path; sha256=(Get-FileHash $netlist -Algorithm SHA256).Hash; length=(Get-Item $netlist).Length }
    td_version = '6.2.178840 (configured TD command tool)'
    export_log_sha256 = (Get-FileHash $log -Algorithm SHA256).Hash
    export_command = (Get-Content -LiteralPath (Join-Path $PSScriptRoot 'dump_c11320_routed_netlist.tcl') -Raw).Trim()
}
$receipt | ConvertTo-Json -Depth 7 | Set-Content -LiteralPath $receiptPath -Encoding utf8
Write-Output "C11320_ROUTED_EXPORT_COMPLETE $netlist"
