$ErrorActionPreference = 'Stop'
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
$receiptPath = Join-Path $PSScriptRoot 'source_receipt.json'
$receipt = Get-Content -LiteralPath $receiptPath -Raw | ConvertFrom-Json
$entries = @()
foreach ($group in @($receipt.baseline, $receipt.candidate, $receipt.verification)) {
    foreach ($property in $group.PSObject.Properties) {
        if ($property.Value.path) { $entries += $property.Value }
    }
}

$lines = @()
$failed = 0
foreach ($entry in $entries) {
    $fullPath = Join-Path $projectRoot $entry.path
    $actualHash = (Get-FileHash -LiteralPath $fullPath -Algorithm SHA256).Hash
    $matches = $actualHash -ceq $entry.sha256
    $status = if ($matches) { 'PASS' } else { 'FAIL' }
    $lines += "$status $actualHash $fullPath"
    if (!$matches) { $failed++ }
}
if ($failed -eq 0) { $lines += 'RECEIPT_HASH_CHECK=PASS' }
else { $lines += "RECEIPT_HASH_CHECK=FAIL count=$failed" }
$lines | Set-Content -Path (Join-Path $PSScriptRoot 'source_receipt_check.log') -Encoding utf8NoBOM
$lines
if ($failed -ne 0) { exit 1 }
