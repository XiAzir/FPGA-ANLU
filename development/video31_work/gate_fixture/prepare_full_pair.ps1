$ErrorActionPreference = 'Stop'
$fixture = (Resolve-Path $PSScriptRoot).Path
$root = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
$src29 = Join-Path $root 'development\player_video29_media_flow\verification\final_routed.v'
$src30 = Join-Path $root 'development\player_video30_probe_prune\verification\final_routed.v'
$out29 = Join-Path $fixture 'full_c29.v'
$out30 = Join-Path $fixture 'full_c30.v'
$ascii = [System.Text.Encoding]::ASCII

function New-RenamedNetlist([string]$sourcePath, [string]$targetPath, [string]$newName) {
    $sourceText = [System.IO.File]::ReadAllText($sourcePath, $ascii)
    $matches = [regex]::Matches($sourceText, '(?m)^module top\b')
    if ($matches.Count -ne 1) { throw "Expected one top module declaration in $sourcePath; found $($matches.Count)" }
    $renamedText = [regex]::Replace($sourceText, '(?m)^module top\b', "module $newName", 1)
    if ($renamedText -eq $sourceText) { throw "Module rename did not change $sourcePath" }
    $normalized = [regex]::Replace($renamedText, "(?m)^module $newName\b", 'module top', 1)
    if ($normalized -cne $sourceText) { throw "Generated copy differs beyond module name: $targetPath" }
    [System.IO.File]::WriteAllText($targetPath, $renamedText, $ascii)
    $sourceHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $sourcePath).Hash.ToLowerInvariant()
    $copyHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $targetPath).Hash.ToLowerInvariant()
    $normalizedHash = [System.Security.Cryptography.SHA256]::Create().ComputeHash($ascii.GetBytes($normalized))
    $normalizedHashText = ([System.BitConverter]::ToString($normalizedHash)).Replace('-', '').ToLowerInvariant()
    if ($sourceHash -ne $normalizedHashText) { throw "Normalized hash mismatch for $sourcePath" }
    return [ordered]@{
        source = $sourcePath
        source_bytes = (Get-Item -LiteralPath $sourcePath).Length
        source_sha256 = $sourceHash
        generated = $targetPath
        generated_bytes = (Get-Item -LiteralPath $targetPath).Length
        generated_sha256 = $copyHash
        normalized_sha256 = $normalizedHashText
        top_module_rename_count = 1
        only_module_name_changed = $true
    }
}

$binding = [ordered]@{
    format = 'routed-audio-pair-input-binding-v1'
    created_local = (Get-Date).ToString('yyyy-MM-ddTHH:mm:ssK')
    c29 = New-RenamedNetlist $src29 $out29 'top29'
    c30 = New-RenamedNetlist $src30 $out30 'top30'
    testbench = [ordered]@{
        path = (Join-Path $fixture 'tb_full_pair.v')
        bytes = (Get-Item -LiteralPath (Join-Path $fixture 'tb_full_pair.v')).Length
        sha256 = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $fixture 'tb_full_pair.v')).Hash.ToLowerInvariant()
    }
}
$receipt = Join-Path $fixture 'input_binding_receipt.json'
$binding | ConvertTo-Json -Depth 6 | Set-Content -Encoding UTF8 -LiteralPath $receipt
Write-Output "Input copies created and bound: $receipt"
Write-Output "C29 source SHA256: $($binding.c29.source_sha256)"
Write-Output "C30 source SHA256: $($binding.c30.source_sha256)"
