$ErrorActionPreference = 'Stop'
$env:MGLS_LICENSE_FILE = [Environment]::GetEnvironmentVariable('MGLS_LICENSE_FILE','User')

$project = 'E:\VSCODE-project\FPGA-ANLU'
$scanRoot = Join-Path $project 'development\regression_failed_releases_20261016\rtl\coeff_scan'
$runRoot = Join-Path $scanRoot ('run_' + (Get-Date -Format 'yyyyMMdd_HHmmss'))
$vlib = 'E:\ModelsimSE\win64\vlib.exe'
$vmap = 'E:\ModelsimSE\win64\vmap.exe'
$vlog = 'E:\ModelsimSE\win64\vlog.exe'
$vsim = 'E:\ModelsimSE\win64\vsim.exe'
$vendorLib = Join-Path $project 'development\player_spectrum_fft_recover\build\board_feedback_no_signal_20261014\modelsim\work'
$vendorInfo = Join-Path $vendorLib '_info'
$tb = Join-Path $scanRoot 'tb_coeff_rom_scan.v'
$releases = @(
    @{ id='C11306'; tree='player_spectrum_private_init'; checkpoint='music_spectrum_private_init_20261013_candidate' },
    @{ id='C11307'; tree='player_spectrum_observed'; checkpoint='music_spectrum_observed_20261013_candidate' }
)

foreach($tool in @($vlib,$vmap,$vlog,$vsim)) { if(-not (Test-Path -LiteralPath $tool)) { throw "Missing ModelSim tool: $tool" } }
if(-not (Test-Path -LiteralPath $vendorLib)) { throw "Missing precompiled EG4 library: $vendorLib" }
New-Item -ItemType Directory -Force -Path $runRoot | Out-Null

$results = [System.Collections.Generic.List[object]]::new()
foreach($r in $releases) {
    $snap = Join-Path (Join-Path (Join-Path (Join-Path $project 'development') $r.tree) 'checkpoints') $r.checkpoint
    $rom = Join-Path $snap 'src\user_source\hdl_source\spectrum_coeff_rom.v'
    $hann = Join-Path $snap 'src\user_source\hdl_source\spectrum_hann.mem'
    $twiddle = Join-Path $snap 'src\user_source\hdl_source\spectrum_twiddle.mem'
    $manifestPath = Join-Path $snap 'manifest.json'
    $manifest = @(Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json)
    $manifestMap = @{}
    foreach($entry in $manifest) { $manifestMap[$entry.path.Replace('\','/')] = $entry.sha256.ToLowerInvariant() }
    $inputProof = @()
    foreach($f in @($rom,$hann,$twiddle)) {
        $relative = [System.IO.Path]::GetRelativePath($snap,$f).Replace('\','/')
        $sha = (Get-FileHash -Algorithm SHA256 -LiteralPath $f).Hash.ToLowerInvariant()
        $manifestSha = $manifestMap[$relative]
        $inputProof += [pscustomobject]@{path=$relative;sha256=$sha;manifest_sha256=$manifestSha;matches_manifest=($sha -eq $manifestSha)}
    }
    if(@($inputProof | Where-Object {-not $_.matches_manifest}).Count -gt 0) { throw "$($r.id): ROM/golden input differs from checkpoint manifest" }

    $case = Join-Path $runRoot $r.id
    New-Item -ItemType Directory -Force -Path $case | Out-Null
    Copy-Item -LiteralPath $tb -Destination (Join-Path $case 'tb_coeff_rom_scan.v')
    Copy-Item -LiteralPath $hann -Destination (Join-Path $case 'spectrum_hann.mem')
    Copy-Item -LiteralPath $twiddle -Destination (Join-Path $case 'spectrum_twiddle.mem')
    $copiedProof = @(@{source=$tb;name='tb_coeff_rom_scan.v'},@{source=$hann;name='spectrum_hann.mem'},@{source=$twiddle;name='spectrum_twiddle.mem'} | ForEach-Object {
        $dest=Join-Path $case $_.name
        [pscustomobject]@{path=$_.name;sha256=(Get-FileHash -Algorithm SHA256 -LiteralPath $dest).Hash.ToLowerInvariant();matches_source=((Get-FileHash -Algorithm SHA256 -LiteralPath $dest).Hash -eq (Get-FileHash -Algorithm SHA256 -LiteralPath $_.source).Hash)}
    })
    $libDir = Join-Path $case 'work'
    & $vlib $libDir *> (Join-Path $case 'vlib.log')
    if($LASTEXITCODE -ne 0) { throw "$($r.id): vlib failed" }
    Push-Location $case
    try {
        & $vmap work $libDir *> (Join-Path $case 'vmap_work.log')
        if($LASTEXITCODE -ne 0) { throw "$($r.id): work library map failed" }
        & $vmap EG4 $vendorLib *> (Join-Path $case 'vmap_EG4.log')
        if($LASTEXITCODE -ne 0) { throw "$($r.id): EG4 library map failed" }
        & $vlog -work work -vlog01compat (Join-Path $case 'tb_coeff_rom_scan.v') $rom *> (Join-Path $case 'compile.log')
        $compileCode = $LASTEXITCODE
        $simCode = $null
        if($compileCode -eq 0) {
            & $vsim -c -modelsimini 'modelsim.ini' -lib work -L work -L EG4 -novopt -do 'run -all; quit -f' work.tb_coeff_rom_scan EG4.glbl '+HAN=spectrum_hann.mem' '+TWI=spectrum_twiddle.mem' -l 'simulation.log' *> (Join-Path $case 'console.log')
            $simCode = $LASTEXITCODE
        }
    } finally { Pop-Location }

    $simText = if(Test-Path (Join-Path $case 'simulation.log')) { Get-Content -Raw (Join-Path $case 'simulation.log') } else { '' }
    $hannMatch = [regex]::Match($simText,'(?m)^# SCAN Hann words=1024 unknown=(\d+) mismatches=(\d+) first_index=(-?\d+) first_got=([0-9a-fA-FxX]+) first_expected=([0-9a-fA-FxX]+)\r?$')
    $twiddleMatch = [regex]::Match($simText,'(?m)^# SCAN Twiddle words=512 unknown=(\d+) mismatches=(\d+) first_index=(-?\d+) first_got=([0-9a-fA-FxX]+) first_expected=([0-9a-fA-FxX]+)\r?$')
    $pass = ($compileCode -eq 0 -and $simCode -eq 0 -and $hannMatch.Success -and $twiddleMatch.Success -and $simText -match '(?m)^# PASS coeff_rom_scan ' -and $simText -notmatch 'Failed to open readmem file' -and $simText -match 'Loading EG4\.EG_PHY_BRAM' -and $simText -match 'Loading EG4\.glbl')
    $romText = Get-Content -Raw -LiteralPath $rom
    $controls = [pscustomobject]@{
        rom_version=$r.id
        hann_low_and_high='Both versions: SP8K, addra={hann_addr,3''b111}, cea=hann_en, csa=3''b111, wea=0; no meaningful read-control difference observed.'
        twiddle_low_and_high=if($r.id -eq 'C11306') { 'PDPW8K; A and B addresses both twiddle_addr; cea=twiddle_en and ceb=twiddle_en; csa=csb=3''b111; wea=0/web=0; outputs use doa low 9 bits plus dob upper 9 bits.' } else { 'PDPW8K; A and B addresses both twiddle_addr; cea=0, ceb=1; csa=csb={twiddle_en,2''b00}; wea=1/web=0; outputs use doa low 9 bits plus dob upper 9 bits.' }
        raw_rom_sha256=(Get-FileHash -Algorithm SHA256 -LiteralPath $rom).Hash.ToLowerInvariant()
        raw_rom_text_has_private_sim_define=($romText -match 'PRIVATE_ROM_BEHAVIORAL_SIM')
        behavioral_branch_enabled=$false
    }
    $results.Add([pscustomobject]@{
        id=$r.id; tree=$r.tree; checkpoint=$r.checkpoint
        checkpoint_manifest_sha256=(Get-FileHash -Algorithm SHA256 -LiteralPath $manifestPath).Hash.ToLowerInvariant()
        input_hashes=$inputProof; copied_input_hashes=$copiedProof
        isolated_tb_sha256=(Get-FileHash -Algorithm SHA256 -LiteralPath $tb).Hash.ToLowerInvariant()
        compile_exit_code=$compileCode; simulation_exit_code=$simCode
        loaded_eg_phy_bram=($simText -match 'Loading EG4\.EG_PHY_BRAM'); loaded_glbl=($simText -match 'Loading EG4\.glbl')
        readmem_open_failure=($simText -match 'Failed to open readmem file')
        hann=if($hannMatch.Success){[pscustomobject]@{words=1024;unknown=[int]$hannMatch.Groups[1].Value;mismatches=[int]$hannMatch.Groups[2].Value;first_index=[int]$hannMatch.Groups[3].Value;first_got=$hannMatch.Groups[4].Value;first_expected=$hannMatch.Groups[5].Value}}else{$null}
        twiddle=if($twiddleMatch.Success){[pscustomobject]@{words=512;unknown=[int]$twiddleMatch.Groups[1].Value;mismatches=[int]$twiddleMatch.Groups[2].Value;first_index=[int]$twiddleMatch.Groups[3].Value;first_got=$twiddleMatch.Groups[4].Value;first_expected=$twiddleMatch.Groups[5].Value}}else{$null}
        controls=$controls; status=if($pass){'PASS'}elseif($compileCode -ne 0){'COMPILE_FAILURE'}elseif($hannMatch.Success -and $twiddleMatch.Success -and -not ($simText -match 'Failed to open readmem file') -and $simText -match 'Loading EG4\.EG_PHY_BRAM' -and $simText -match 'Loading EG4\.glbl'){'READBACK_MISMATCH'}else{'SCAN_FAILURE'}
        limitations='Standalone coefficient ROM RTL scan against frozen .mem files using the installed precompiled EG_PHY_BRAM simulation model; does not validate mapped silicon behavior, analyzer scheduling, complete top-level startup, PHY, routed timing, or board behavior.'
    })
    $results[-1] | ConvertTo-Json -Depth 7 | Set-Content -LiteralPath (Join-Path $case 'result.json') -Encoding utf8
    Write-Output ("{0}: {1}; hann_mismatch={2}; twiddle_mismatch={3}; eg4_bram={4}" -f $r.id,$results[-1].status,$results[-1].hann.mismatches,$results[-1].twiddle.mismatches,$results[-1].loaded_eg_phy_bram)
}

$snap06 = Join-Path $project 'development\player_spectrum_private_init\checkpoints\music_spectrum_private_init_20261013_candidate'
$snap07 = Join-Path $project 'development\player_spectrum_observed\checkpoints\music_spectrum_observed_20261013_candidate'
$rom06 = Join-Path $snap06 'src\user_source\hdl_source\spectrum_coeff_rom.v'
$rom07 = Join-Path $snap07 'src\user_source\hdl_source\spectrum_coeff_rom.v'
$init06 = @(Get-Content -LiteralPath $rom06 | Where-Object {$_ -match '^\s*\.INIT(P)?_[0-9A-F]{2}\('} | ForEach-Object {$_.Trim()})
$init07 = @(Get-Content -LiteralPath $rom07 | Where-Object {$_ -match '^\s*\.INIT(P)?_[0-9A-F]{2}\('} | ForEach-Object {$_.Trim()})
$romComparison = [pscustomobject]@{
    c11306_rom_sha256=(Get-FileHash -Algorithm SHA256 -LiteralPath $rom06).Hash.ToLowerInvariant()
    c11307_rom_sha256=(Get-FileHash -Algorithm SHA256 -LiteralPath $rom07).Hash.ToLowerInvariant()
    init_constant_line_count_c11306=$init06.Count; init_constant_line_count_c11307=$init07.Count
    init_constants_same_order_and_value=([string]::Join("`n",$init06) -ceq [string]::Join("`n",$init07))
    hann_golden_sha256_c11306=(Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $snap06 'src\user_source\hdl_source\spectrum_hann.mem')).Hash.ToLowerInvariant()
    hann_golden_sha256_c11307=(Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $snap07 'src\user_source\hdl_source\spectrum_hann.mem')).Hash.ToLowerInvariant()
    twiddle_golden_sha256_c11306=(Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $snap06 'src\user_source\hdl_source\spectrum_twiddle.mem')).Hash.ToLowerInvariant()
    twiddle_golden_sha256_c11307=(Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $snap07 'src\user_source\hdl_source\spectrum_twiddle.mem')).Hash.ToLowerInvariant()
    observed_read_side_change='C11306 enables both PDPW8K sides with cea=ceb=twiddle_en and fixed csa=csb=111. C11307 selects the port-B read side by holding ceb=1/CEBMUX=1 and gating csb={twiddle_en,2''b00}; it disables port A with cea=0/CEAMUX=0. Both use identical address wiring and identical INIT constants.'
}
$summary = [pscustomobject]@{
    run_directory=$runRoot; simulator='ModelSim SE-64 10.1c'; vendor_library=$vendorLib
    vendor_library_info_sha256=(Get-FileHash -Algorithm SHA256 -LiteralPath $vendorInfo).Hash.ToLowerInvariant()
    command_line='pwsh -NoProfile -File development/regression_failed_releases_20261016/rtl/coeff_scan/run_coeff_scan.ps1'
    define_PRIVATE_ROM_BEHAVIORAL_SIM=$false; rom_comparison=$romComparison; result_count=$results.Count; results=@($results)
    rationale='Directly scan both clocked ROM outputs at every address, separately from the analyzer/testbench pipeline, to test whether C11306 coefficients themselves read back correctly.'
}
$summary | ConvertTo-Json -Depth 9 | Set-Content -LiteralPath (Join-Path $scanRoot 'summary.json') -Encoding utf8
