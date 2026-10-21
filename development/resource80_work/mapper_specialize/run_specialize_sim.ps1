$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$iverilog = Resolve-AnluTool -Name 'iverilog'
$vvp = Resolve-AnluTool -Name 'vvp'
$out = Join-Path $PSScriptRoot 'build'
$null = New-Item -ItemType Directory -Force -Path $out
$modes = @(
    @{ name='generic'; geometry=0; static=0; stable=0 },
    @{ name='catalog'; geometry=1; static=0; stable=0 },
    @{ name='static_file'; geometry=0; static=1; stable=0 },
    @{ name='request_stable'; geometry=0; static=0; stable=1 },
    @{ name='catalog_static'; geometry=1; static=1; stable=0 },
    @{ name='catalog_request'; geometry=1; static=0; stable=1 },
    @{ name='static_request'; geometry=0; static=1; stable=1 },
    @{ name='all_specialized'; geometry=1; static=1; stable=1 }
)
$rows = [System.Collections.Generic.List[object]]::new()
foreach ($mode in $modes) {
    $image = Join-Path $out "$($mode.name).vvp"
    $log = Join-Path $out "$($mode.name).log"
    & $iverilog -g2005 -Wall -s tb_mapper_specialize `
        "-Ptb_mapper_specialize.CATALOG_GEOMETRY=$($mode.geometry)" `
        "-Ptb_mapper_specialize.STATIC_FILE=$($mode.static)" `
        "-Ptb_mapper_specialize.REQUEST_STABLE=$($mode.stable)" `
        -o $image (Join-Path $PSScriptRoot 'tb_mapper_specialize.v') `
        (Join-Path $PSScriptRoot 'fat32_file_sector.v') `
        (Join-Path $PSScriptRoot 'fat32_file_sector_generic.v') 2>&1 |
        Tee-Object -FilePath (Join-Path $out "$($mode.name).iverilog.log")
    if ($LASTEXITCODE -ne 0) { throw "iverilog failed for $($mode.name)" }
    & $vvp $image 2>&1 | Tee-Object -FilePath $log
    if ($LASTEXITCODE -ne 0) { throw "vvp failed for $($mode.name)" }
    $pass = Select-String -LiteralPath $log -SimpleMatch "PASS: mapper specialization contract differential $($mode.geometry)$($mode.static)$($mode.stable)" -Quiet
    if (!$pass) { throw "specialization checks failed for $($mode.name); inspect $log" }
    $rows.Add([pscustomobject]@{mode=$mode.name; geometry=$mode.geometry; static_file=$mode.static; request_stable=$mode.stable; result='PASS'; log=$log})
}
$rows | ConvertTo-Json -Depth 3 | Set-Content -LiteralPath (Join-Path $out 'summary.json') -Encoding utf8
$rows | Format-Table mode,geometry,static_file,request_stable,result -AutoSize
