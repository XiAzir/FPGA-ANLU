$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$td = Resolve-AnluTool -Name 'td_commands_prompt'
$runs = Join-Path $PSScriptRoot 'synthesis'
python (Join-Path $PSScriptRoot 'prepare_synthesis.py') | Set-Content -LiteralPath (Join-Path $runs 'prepare.log') -Encoding utf8
if ($LASTEXITCODE -ne 0) { throw "prepare_synthesis.py failed: $LASTEXITCODE" }
$rows = [System.Collections.Generic.List[object]]::new()
foreach ($variant in @('reference', 'shared36')) {
    $folder = Join-Path $runs $variant
    $console = Join-Path $folder 'console.log'
    Push-Location $folder
    try {
        & $td ((Join-Path $folder 'run_syn.tcl').Replace('\','/')) *> $console
        $exitCode = $LASTEXITCODE
    } finally { Pop-Location }
    $areaPath = Join-Path $folder 'reports/gate.area'
    $marker = Select-String -LiteralPath $console -SimpleMatch 'SYNTHESIS_COMPLETE' -Quiet
    if ($exitCode -ne 0 -or !$marker -or !(Test-Path -LiteralPath $areaPath)) { throw "TD synthesis failed for $variant; inspect $console" }
    $area = Get-Content -LiteralPath $areaPath -Raw
    $deviceLut = [int]([regex]::Match($area, '(?m)^#lut\s+(\d+)').Groups[1].Value)
    $reg = [int]([regex]::Match($area, '(?m)^#reg\s+(\d+)').Groups[1].Value)
    $dsp = [int]([regex]::Match($area, '(?m)^#dsp\s+(\d+)').Groups[1].Value)
    $genericLut = [int]([regex]::Match($area, '(?m)^#Total_luts\s+(\d+)').Groups[1].Value)
    $ripple = [int]([regex]::Match($area, '(?m)^\|top\s+\|fat32_catalog\s+\|\d+\s+\|(\d+)').Groups[1].Value)
    $seq = [int]([regex]::Match($area, '(?m)^\|top\s+\|fat32_catalog\s+\|\d+\s+\|\d+\s+\|(\d+)').Groups[1].Value)
    $hdl = Join-Path $folder 'fat32_catalog.v'
    $rows.Add([pscustomobject]@{
        variant=$variant; exit_code=$exitCode; synthesis_marker=[bool]$marker
        hdl_sha256=(Get-FileHash -LiteralPath $hdl -Algorithm SHA256).Hash.ToLowerInvariant()
        device_lut=$deviceLut; reg=$reg; generic_lut=$genericLut; ripple=$ripple; seq=$seq; dsp=$dsp
        area_report=$areaPath; console_log=$console
    })
}
$rows | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $runs 'synthesis_summary.json') -Encoding utf8
$rows | Export-Csv -LiteralPath (Join-Path $runs 'synthesis_summary.csv') -NoTypeInformation -Encoding utf8
$rows | Format-Table variant,device_lut,reg,generic_lut,ripple,seq,dsp,hdl_sha256 -AutoSize
