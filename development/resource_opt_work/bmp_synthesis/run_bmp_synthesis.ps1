$ErrorActionPreference = 'Stop'
$Root = (Resolve-Path $PSScriptRoot).Path
. (Join-Path $Root '../../../scripts/anlu_tools.ps1')
$Runs = Join-Path $Root 'runs'
$ManifestPath = Join-Path $Runs 'input_manifest.json'
$Manifest = Get-Content -LiteralPath $ManifestPath -Raw | ConvertFrom-Json
$Td = Resolve-AnluTool -Name 'td_commands_prompt'
$Status = [System.Collections.Generic.List[object]]::new()

foreach ($Variant in @('reference','width32','width19','loader_reference','loader_diag_direct')) {
    $Folder = Join-Path $Runs $Variant
    $Console = Join-Path $Folder 'console.log'
    $Area = Join-Path $Folder 'reports/gate.area'
    if ((Test-Path -LiteralPath $Console) -or (Test-Path -LiteralPath $Area)) {
        $Marker = (Test-Path -LiteralPath $Console) -and
            (Select-String -LiteralPath $Console -SimpleMatch 'SYNTHESIS_COMPLETE' -Quiet)
        if (!$Marker -or !(Test-Path -LiteralPath $Area -PathType Leaf)) {
            throw "Incomplete existing evidence for $Variant; inspect it before restarting."
        }
        $Status.Add([pscustomobject]@{
            variant=$Variant; exit_code=0; synthesis_marker=$true
            gate_area=$Area; gate_area_sha256=(Get-FileHash -LiteralPath $Area -Algorithm SHA256).Hash.ToLowerInvariant()
            console_sha256=(Get-FileHash -LiteralPath $Console -Algorithm SHA256).Hash.ToLowerInvariant()
            source_sha256=$Manifest.variants.$Variant.hdl_files; status='success'
        })
        $Status | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $Runs 'synthesis_status.json') -Encoding utf8
        continue
    }
    $Script = (Join-Path $Folder 'run_syn.tcl').Replace('\','/')
    Push-Location $Folder
    try {
        & $Td $Script *> $Console
        $ExitCode = $LASTEXITCODE
    } finally {
        Pop-Location
    }
    $Marker = Select-String -LiteralPath $Console -SimpleMatch 'SYNTHESIS_COMPLETE' -Quiet
    if ($ExitCode -ne 0 -or !$Marker -or !(Test-Path -LiteralPath $Area -PathType Leaf)) {
        $Status.Add([pscustomobject]@{
            variant=$Variant; exit_code=$ExitCode; synthesis_marker=[bool]$Marker
            gate_area=(Test-Path -LiteralPath $Area); status='failed'
            source_sha256=$Manifest.variants.$Variant.hdl_files
        })
        $Status | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $Runs 'synthesis_status.json') -Encoding utf8
        throw "TD synthesis failed for $Variant; inspect $Console"
    }
    $Status.Add([pscustomobject]@{
        variant=$Variant; exit_code=$ExitCode; synthesis_marker=[bool]$Marker
        gate_area=$Area; gate_area_sha256=(Get-FileHash -LiteralPath $Area -Algorithm SHA256).Hash.ToLowerInvariant()
        console_sha256=(Get-FileHash -LiteralPath $Console -Algorithm SHA256).Hash.ToLowerInvariant()
        source_sha256=$Manifest.variants.$Variant.hdl_files; status='success'
    })
    $Status | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $Runs 'synthesis_status.json') -Encoding utf8
}

python (Join-Path $Root 'summarize_area.py') $Runs
if ($LASTEXITCODE -ne 0) { throw 'Could not summarize standalone gate.area reports.' }
Write-Output "BMP_STANDALONE_SYNTHESIS PASS variants=5 root=$Runs"
