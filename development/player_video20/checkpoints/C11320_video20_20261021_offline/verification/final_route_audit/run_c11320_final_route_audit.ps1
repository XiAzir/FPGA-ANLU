param(
    [Parameter(Mandatory)][string]$RunId,
    [Parameter(Mandatory)][string]$PhysicalRunId,
    [Parameter(Mandatory)][string]$HoldRunId
)
$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '../../..')).Path
$strictJson = Join-Path $PSScriptRoot 'strict_routed_rom_control.json'
$summaryPath = Join-Path $PSScriptRoot 'final_route_audit_summary.json'
foreach ($artifact in @($strictJson,$summaryPath)) {
    if ($artifact -eq $summaryPath -and (Test-Path -LiteralPath $artifact)) { throw "Refusing to overwrite prior audit summary: $artifact" }
}

$netlist = Join-Path $PSScriptRoot 'AC201_tf_hdmi_c11320_pr_routed.v'
$receiptPath = Join-Path $PSScriptRoot 'route_export_receipt.json'
if (Test-Path -LiteralPath $receiptPath) {
    $receipt = Get-Content -LiteralPath $receiptPath -Raw | ConvertFrom-Json
    $actualReceiptIds = $receipt.selected_run_ids
    if ($receipt.schema -ne 'c11320-routed-netlist-export-v1' -or
        $actualReceiptIds.synthesis -ne $RunId -or $actualReceiptIds.physical -ne $PhysicalRunId -or $actualReceiptIds.hold -ne $HoldRunId -or
        (Get-FileHash -LiteralPath $netlist -Algorithm SHA256).Hash -ne $receipt.exported_netlist.sha256) {
        throw 'Existing routed export receipt does not match this invocation; preserve it and use a new audit folder.'
    }
} else {
    & (Join-Path $PSScriptRoot 'export_c11320_routed_netlist.ps1') -RunId $RunId -PhysicalRunId $PhysicalRunId -HoldRunId $HoldRunId
    if ($LASTEXITCODE -ne 0) { throw "Routed netlist export failed: $LASTEXITCODE" }
}

$strictExit = 0
if (Test-Path -LiteralPath $strictJson) {
    $strict = Get-Content -LiteralPath $strictJson -Raw | ConvertFrom-Json
    if ($strict.selected_run_ids.synthesis -ne $RunId -or $strict.selected_run_ids.physical -ne $PhysicalRunId -or $strict.selected_run_ids.hold -ne $HoldRunId -or
        $strict.netlist_sha256 -ne (Get-FileHash -LiteralPath $netlist -Algorithm SHA256).Hash.ToLowerInvariant()) {
        throw 'Existing strict audit belongs to a different routed netlist; preserve it and use a new audit folder.'
    }
} else {
    & python (Join-Path $PSScriptRoot 'audit_c11320_strict_rom_controls.py') `
        --run-id $RunId --physical-run-id $PhysicalRunId --hold-run-id $HoldRunId `
        --kind routed --netlist $netlist --output $strictJson
    $strictExit = $LASTEXITCODE
    $strict = Get-Content -LiteralPath $strictJson -Raw | ConvertFrom-Json
}
if ($strict.schema -ne 'c11320-strict-rom-control-parameters-v1' -or @($strict.banks.PSObject.Properties).Count -ne 4) {
    throw 'Strict ROM parameter audit did not produce a four-bank C11320 report.'
}

$proofExit = 0
try {
    & (Join-Path $PSScriptRoot 'prove_c11320_routed_rom_polarity.ps1') -RunId $RunId -PhysicalRunId $PhysicalRunId -HoldRunId $HoldRunId
    if ($LASTEXITCODE -ne 0) { $proofExit = $LASTEXITCODE }
} catch {
    $proofExit = 1
    Write-Warning "ROM polarity proof failed and its artifacts are preserved: $($_.Exception.Message)"
}

$clockExit = 0
try {
    & python (Join-Path $PSScriptRoot 'audit_c11320_clock_route.py') `
        --run-id $RunId --physical-run-id $PhysicalRunId --hold-run-id $HoldRunId
    $clockExit = $LASTEXITCODE
} catch {
    $clockExit = 1
    Write-Warning "Clock/STA audit failed and its artifacts are preserved: $($_.Exception.Message)"
}

$proofStatus = if (Test-Path (Join-Path $PSScriptRoot 'routed_rom_control_proof.json')) {
    (Get-Content -LiteralPath (Join-Path $PSScriptRoot 'routed_rom_control_proof.json') -Raw | ConvertFrom-Json).status
} else { 'missing' }
$clockStatus = if (Test-Path (Join-Path $PSScriptRoot 'routed_clock_audit.json')) {
    (Get-Content -LiteralPath (Join-Path $PSScriptRoot 'routed_clock_audit.json') -Raw | ConvertFrom-Json).status
} else { 'missing' }
$result = [ordered]@{
    schema='c11320-final-route-audit-summary-v1'
    generated=(Get-Date).ToString('o')
    design='player_video20 / C11320'
    selected_run_ids=[ordered]@{synthesis=$RunId;physical=$PhysicalRunId;hold=$HoldRunId}
    strict_rom_status=$strict.status
    rom_truth_status=$proofStatus
    clock_route_status=$clockStatus
    process_exit_codes=[ordered]@{strict=$strictExit;rom_truth=$proofExit;clock_route=$clockExit}
    strict_result_sha256=(Get-FileHash $strictJson -Algorithm SHA256).Hash
    route_export_receipt_sha256=(Get-FileHash (Join-Path $PSScriptRoot 'route_export_receipt.json') -Algorithm SHA256).Hash
}
$result | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $summaryPath -Encoding utf8
Write-Output ($result | ConvertTo-Json -Depth 6)
if ($proofExit -ne 0 -or $clockExit -ne 0) { exit 1 }
