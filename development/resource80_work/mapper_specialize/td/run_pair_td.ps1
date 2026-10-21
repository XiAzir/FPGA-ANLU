$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '../../../../scripts/anlu_tools.ps1')
$td = Resolve-AnluTool -Name 'td_commands_prompt'
$python = Resolve-AnluPython
$runs = Join-Path $PSScriptRoot 'runs'
$null = New-Item -ItemType Directory -Force -Path $runs
& $python (Join-Path $PSScriptRoot 'prepare_pair_td.py') | Set-Content -LiteralPath (Join-Path $runs 'prepare.log') -Encoding utf8
if ($LASTEXITCODE -ne 0) { throw "prepare_pair_td.py failed: $LASTEXITCODE" }
$rows = [System.Collections.Generic.List[object]]::new()
foreach ($variant in @('generic_000','top_specialized')) {
    $folder = Join-Path $runs $variant
    $console = Join-Path $folder 'console.log'
    Push-Location $folder
    try {
        & $td ((Join-Path $folder 'run_syn.tcl').Replace('\','/')) *> $console
        $exitCode = $LASTEXITCODE
    } finally { Pop-Location }
    $areaPath = Join-Path $folder 'reports/gate.area'
    $marker = Select-String -LiteralPath $console -SimpleMatch 'SYNTHESIS_COMPLETE' -Quiet
    if ($exitCode -ne 0 -or !$marker -or !(Test-Path -LiteralPath $areaPath)) { throw "TD failed for $variant; inspect $console" }
    $actualRtl = Join-Path $folder 'reports/actualparams.rtl.log'
    $actualGate = Join-Path $folder 'reports/actualparams.gate.log'
    if (!(Test-Path -LiteralPath $actualRtl) -or !(Test-Path -LiteralPath $actualGate)) { throw "actualparams reports missing for $variant" }
    $actual = (Get-Content -LiteralPath $actualRtl -Raw) + "`n" + (Get-Content -LiteralPath $actualGate -Raw)
    foreach ($check in @(
        'add_map_lut_struct[^\r\n]*high',
        'map_mode[^\r\n]*area_prior',
        'multi_thread_mapping[^\r\n]*partition',
        'resource_sharing[^\r\n]*auto',
        'shifter_style[^\r\n]*shifter_reg',
        'min_ripple_len[^\r\n]*18',
        'mapper_lut_delay[^\r\n]*1600'
    )) {
        if ($actual -notmatch $check) { throw "Expected synthesis parameter not verified ($check) for $variant; inspect actualparams reports" }
    }
    $area = Get-Content -LiteralPath $areaPath -Raw
    $rows.Add([pscustomobject]@{
        variant=$variant
        top=if($variant -eq 'generic_000'){'mapper_pair_generic'}else{'mapper_pair_specialized'}
        rtl_sha256=(Get-FileHash -LiteralPath (Join-Path $folder 'fat32_file_sector.v') -Algorithm SHA256).Hash.ToLowerInvariant()
        wrapper_sha256=(Get-FileHash -LiteralPath (Join-Path $folder 'mapper_pair.v') -Algorithm SHA256).Hash.ToLowerInvariant()
        device_lut=[int]([regex]::Match($area,'(?m)^#lut\s+(\d+)').Groups[1].Value)
        device_reg=[int]([regex]::Match($area,'(?m)^#reg\s+(\d+)').Groups[1].Value)
        generic_lut=[int]([regex]::Match($area,'(?m)^#Total_luts\s+(\d+)').Groups[1].Value)
        dsp=[int]([regex]::Match($area,'(?m)^#dsp\s+(\d+)').Groups[1].Value)
        bram=[int]([regex]::Match($area,'(?m)^#bram\s+(\d+)').Groups[1].Value)
        area_report=$areaPath; actualparams_rtl=$actualRtl; actualparams_gate=$actualGate; console=$console
    })
}
$rows | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $runs 'summary.json') -Encoding utf8
$rows | Export-Csv -LiteralPath (Join-Path $runs 'summary.csv') -NoTypeInformation -Encoding utf8
$rows | Format-Table variant,device_lut,device_reg,generic_lut,bram,dsp,rtl_sha256,wrapper_sha256 -AutoSize
