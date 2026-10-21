$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$td = Resolve-AnluTool -Name 'td_commands_prompt'
$runs = Join-Path $PSScriptRoot 'runs'
python (Join-Path $PSScriptRoot 'prepare.py') | Set-Content -LiteralPath (Join-Path $runs 'prepare.log') -Encoding utf8
if ($LASTEXITCODE -ne 0) { throw "prepare.py failed: $LASTEXITCODE" }
$rows = [System.Collections.Generic.List[object]]::new()
foreach ($variant in @('baseline', 'adder_chain_threshold_high')) {
    foreach ($module in @('fat32_catalog', 'fat32_file_sector')) {
        $folder = Join-Path $runs "${module}_${variant}"
        $console = Join-Path $folder 'console.log'
        Push-Location $folder
        try {
            & $td ((Join-Path $folder 'run_syn.tcl').Replace('\','/')) *> $console
            $exitCode = $LASTEXITCODE
        } finally { Pop-Location }
        $areaPath = Join-Path $folder 'reports/gate.area'
        $marker = Select-String -LiteralPath $console -SimpleMatch 'SYNTHESIS_COMPLETE' -Quiet
        if ($exitCode -ne 0 -or !$marker -or !(Test-Path -LiteralPath $areaPath)) { throw "TD failed for $module/$variant; inspect $console" }
        $area = Get-Content -LiteralPath $areaPath -Raw
        $actualRtl = Join-Path $folder 'reports/actualparams.rtl.log'
        $actualGate = Join-Path $folder 'reports/actualparams.gate.log'
        if (!(Test-Path -LiteralPath $actualRtl) -or !(Test-Path -LiteralPath $actualGate)) { throw "actualparams reports missing for $module/$variant" }
        $actual = (Get-Content -LiteralPath $actualRtl -Raw) + "`n" + (Get-Content -LiteralPath $actualGate -Raw)
        if ($variant -eq 'adder_chain_threshold_high') {
            if ($actual -notmatch 'min_ripple_len[^\r\n]*18' -or $actual -notmatch 'mapper_lut_delay[^\r\n]*1600') {
                throw "official strategy params not verified in actualparams for $module; inspect $actualRtl and $actualGate"
            }
        }
        $rtl = Join-Path $folder "$module.v"
        $deviceLut = [int]([regex]::Match($area, '(?m)^#lut\s+(\d+)').Groups[1].Value)
        $deviceReg = [int]([regex]::Match($area, '(?m)^#reg\s+(\d+)').Groups[1].Value)
        $ripple = [int]([regex]::Match($area, '(?m)^\|top\s+\|' + $module + '\s+\|\d+\s+\|(\d+)').Groups[1].Value)
        $seq = [int]([regex]::Match($area, '(?m)^\|top\s+\|' + $module + '\s+\|\d+\s+\|\d+\s+\|(\d+)').Groups[1].Value)
        $genericLut = [int]([regex]::Match($area, '(?m)^#Total_luts\s+(\d+)').Groups[1].Value)
        $dsp = [int]([regex]::Match($area, '(?m)^#dsp\s+(\d+)').Groups[1].Value)
        $rows.Add([pscustomobject]@{
            module=$module; variant=$variant; exit_code=$exitCode; marker=[bool]$marker
            input_sha256=(Get-FileHash -LiteralPath $rtl -Algorithm SHA256).Hash.ToLowerInvariant()
            device_lut=$deviceLut; device_reg=$deviceReg; ripple=$ripple; seq=$seq; generic_lut=$genericLut; dsp=$dsp
            actualparams_rtl=$actualRtl; actualparams_gate=$actualGate; area_report=$areaPath; console=$console
        })
    }
}
$rows | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $runs 'summary.json') -Encoding utf8
$rows | Export-Csv -LiteralPath (Join-Path $runs 'summary.csv') -NoTypeInformation -Encoding utf8
$rows | Sort-Object module,variant | Format-Table module,variant,device_lut,device_reg,ripple,seq,generic_lut,dsp,input_sha256 -AutoSize
