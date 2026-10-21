$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$root = $PSScriptRoot
$runs = Join-Path $root 'td_runs'
$null = New-Item -ItemType Directory -Force -Path $runs
$td = Resolve-AnluTool -Name 'td_commands_prompt'
$python = Resolve-AnluPython
& $python (Join-Path $root 'td_prepare.py') | Set-Content -LiteralPath (Join-Path $runs 'prepare.log') -Encoding utf8
if ($LASTEXITCODE -ne 0) { throw "td_prepare.py failed: $LASTEXITCODE" }
$rows = [System.Collections.Generic.List[object]]::new()
foreach ($variant in @('wav_candidate_default','wav_candidate_area_high')) {
    $folder = Join-Path $runs $variant
    $console = Join-Path $folder 'console.log'
    Push-Location $folder
    try {
        & $td ((Join-Path $folder 'run_syn.tcl').Replace('\','/')) *> $console
        $exitCode = $LASTEXITCODE
    } finally { Pop-Location }
    $areaPath = Join-Path $folder 'reports/gate.area'
    if ($exitCode -ne 0 -or !(Select-String -LiteralPath $console -SimpleMatch 'SYNTHESIS_COMPLETE' -Quiet) -or !(Test-Path -LiteralPath $areaPath)) {
        throw "TD failed for $variant; inspect $console"
    }
    $actualRtl = Join-Path $folder 'reports/actualparams.rtl.log'
    $actualGate = Join-Path $folder 'reports/actualparams.gate.log'
    if (!(Test-Path -LiteralPath $actualRtl) -or !(Test-Path -LiteralPath $actualGate)) { throw "actualparams reports missing for $variant" }
    $actual = (Get-Content -LiteralPath $actualRtl -Raw) + "`n" + (Get-Content -LiteralPath $actualGate -Raw)
    if ($variant.EndsWith('area_high')) {
        foreach ($check in @('add_map_lut_struct[^\r\n]*high','map_mode[^\r\n]*area_prior','multi_thread_mapping[^\r\n]*partition','resource_sharing[^\r\n]*auto','shifter_style[^\r\n]*shifter_reg')) {
            if ($actual -notmatch $check) { throw "AreaOptimizeHigh parameter not verified ($check) for $variant; inspect actualparams reports" }
        }
    }
    $area = Get-Content -LiteralPath $areaPath -Raw
    $rows.Add([pscustomobject]@{
        variant=$variant
        source_sha256=(Get-FileHash -LiteralPath (Join-Path $folder 'tf_wav_file_player.v') -Algorithm SHA256).Hash.ToLowerInvariant()
        device_lut=[int]([regex]::Match($area,'(?m)^#lut\s+(\d+)').Groups[1].Value)
        device_reg=[int]([regex]::Match($area,'(?m)^#reg\s+(\d+)').Groups[1].Value)
        ripple=[int]([regex]::Match($area,'(?m)^\|top\s+\|tf_wav_file_player\s+\|\d+\s+\|(\d+)').Groups[1].Value)
        seq=[int]([regex]::Match($area,'(?m)^\|top\s+\|tf_wav_file_player\s+\|\d+\s+\|\d+\s+\|(\d+)').Groups[1].Value)
        generic_lut=[int]([regex]::Match($area,'(?m)^#Total_luts\s+(\d+)').Groups[1].Value)
        dsp=[int]([regex]::Match($area,'(?m)^#dsp\s+(\d+)').Groups[1].Value)
        area_report=$areaPath; actualparams_rtl=$actualRtl; actualparams_gate=$actualGate; console=$console
    })
}
$rows | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $runs 'summary.json') -Encoding utf8
$rows | Export-Csv -LiteralPath (Join-Path $runs 'summary.csv') -NoTypeInformation -Encoding utf8
$rows | Format-Table variant,device_lut,device_reg,ripple,seq,generic_lut,dsp,source_sha256 -AutoSize
