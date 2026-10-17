$ErrorActionPreference = 'Stop'
$env:MGLS_LICENSE_FILE = [Environment]::GetEnvironmentVariable('MGLS_LICENSE_FILE','User')

$project = 'E:\VSCODE-project\FPGA-ANLU'
$outRoot = Join-Path $project 'development\regression_failed_releases_20261016\rtl'
$runRoot = Join-Path $outRoot ('run_' + (Get-Date -Format 'yyyyMMdd_HHmmss'))
$vsim = 'E:\ModelsimSE\win64\vsim.exe'
$vlib = 'E:\ModelsimSE\win64\vlib.exe'
$vmap = 'E:\ModelsimSE\win64\vmap.exe'
$vlog = 'E:\ModelsimSE\win64\vlog.exe'
$vendorLib = Join-Path $project 'development\player_spectrum_fft_recover\build\board_feedback_no_signal_20261014\modelsim\work'
$releases = @(
    @{ id='C11304'; tree='player_spectrum'; checkpoint='music_spectrum_20261013_candidate'; rom=$false },
    @{ id='C11305'; tree='player_spectrum_baseline_phy'; checkpoint='music_spectrum_baseline_phy_20261013_candidate'; rom=$false },
    @{ id='C11306'; tree='player_spectrum_private_init'; checkpoint='music_spectrum_private_init_20261013_candidate'; rom=$true },
    @{ id='C11307'; tree='player_spectrum_observed'; checkpoint='music_spectrum_observed_20261013_candidate'; rom=$true },
    @{ id='C11308'; tree='player_spectrum_tf_margin'; checkpoint='music_spectrum_tf_margin_20261014_candidate'; rom=$true },
    @{ id='C11309'; tree='player_spectrum_clock_route'; checkpoint='music_spectrum_clock_route_20261014_candidate'; rom=$true },
    @{ id='C11310'; tree='player_spectrum_fft_recover'; checkpoint='music_spectrum_fft_recover_20261014_candidate'; rom=$true }
)

foreach ($tool in @($vsim, $vlib, $vmap, $vlog)) {
    if (-not (Test-Path -LiteralPath $tool)) { throw "Missing ModelSim executable: $tool" }
}
if (-not (Test-Path -LiteralPath $vendorLib)) { throw "Missing precompiled vendor library: $vendorLib" }

$results = [System.Collections.Generic.List[object]]::new()
foreach ($release in $releases) {
    $snap = Join-Path (Join-Path (Join-Path (Join-Path $project 'development') $release.tree) 'checkpoints') $release.checkpoint
    $caseRoot = Join-Path $runRoot $release.id
    $libDir = Join-Path $caseRoot 'work'
    $manifestPath = Join-Path $snap 'manifest.json'
    $tb = Join-Path $snap 'sim\tb_player_spectrum_analyzer.v'
    $rtl = Join-Path $snap 'src\user_source\hdl_source\player_spectrum_analyzer.v'
    $rom = Join-Path $snap 'src\user_source\hdl_source\spectrum_coeff_rom.v'
    $vec = Join-Path $snap 'sim\vectors\all_samples.mem'
    $exp = Join-Path $snap 'sim\vectors\all_expected.mem'
    $manifest = @(Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json)
    $manifestFiles = @{}
    foreach ($entry in $manifest) { $manifestFiles[$entry.path.Replace('\','/')] = $entry.sha256.ToLowerInvariant() }

    $inputs = [System.Collections.Generic.List[object]]::new()
    $hdl = Join-Path $snap 'src\user_source\hdl_source'
    $hann = Join-Path $hdl 'spectrum_hann.mem'
    $twiddle = Join-Path $hdl 'spectrum_twiddle.mem'
    foreach ($file in @($tb, $rtl, $vec, $exp, $hann, $twiddle) + $(if ($release.rom) { @($rom) } else { @() })) {
        if (-not (Test-Path -LiteralPath $file)) { throw "$($release.id): required frozen input is missing: $file" }
        $relative = [System.IO.Path]::GetRelativePath($snap, $file).Replace('\','/')
        $actual = (Get-FileHash -Algorithm SHA256 -LiteralPath $file).Hash.ToLowerInvariant()
        $expected = $manifestFiles[$relative]
        $inputs.Add([pscustomobject]@{ path=$relative; sha256=$actual; manifest_sha256=$expected; matches_manifest=($expected -eq $actual) })
    }
    if (@($inputs | Where-Object { -not $_.matches_manifest }).Count -gt 0) { throw "$($release.id): frozen input SHA256 differs from manifest" }

    New-Item -ItemType Directory -Force -Path $caseRoot | Out-Null
    foreach ($source in @($vec, $exp, $hann, $twiddle)) {
        Copy-Item -LiteralPath $source -Destination (Join-Path $caseRoot (Split-Path -Leaf $source))
    }
    if (Test-Path -LiteralPath $libDir) { throw "Refusing to reuse existing isolated library: $libDir" }
    & $vlib $libDir *> (Join-Path $caseRoot 'vlib.log')
    if ($LASTEXITCODE -ne 0) { throw "$($release.id): vlib failed ($LASTEXITCODE)" }
    Push-Location $caseRoot
    try {
        & $vmap work $libDir *> (Join-Path $caseRoot 'vmap_work.log')
        if ($LASTEXITCODE -ne 0) { throw "$($release.id): vmap work failed ($LASTEXITCODE)" }
        & $vmap EG4 $vendorLib *> (Join-Path $caseRoot 'vmap_EG4.log')
        if ($LASTEXITCODE -ne 0) { throw "$($release.id): vmap EG4 failed ($LASTEXITCODE)" }
        $compatDir = Join-Path $caseRoot 'compat'
        New-Item -ItemType Directory -Force -Path $compatDir | Out-Null
        $originalTbText = [System.IO.File]::ReadAllText($tb)
        $tbAnchor = '        $readmemh(exp_file,expected_mem);'
        $tbGuard = @(
            '        for(i=0;i<CASES*1024;i=i+1)'
            '            if ((^sample_mem[i]) === 1''bx) $fatal(1,"input sample vector contains unknown or unloaded word index=%0d",i);'
            '        for(i=0;i<CASES*24;i=i+1)'
            '            if ((^expected_mem[i]) === 1''bx) $fatal(1,"expected vector contains unknown or unloaded word index=%0d",i);'
        ) -join "`r`n"
        if (([regex]::Matches($originalTbText,[regex]::Escape($tbAnchor))).Count -ne 1) { throw "$($release.id): cannot locate sealed testbench vector load point" }
        $tbCompatText = $originalTbText.Replace($tbAnchor,$tbAnchor + "`r`n" + $tbGuard)
        $tbReverseText = $tbCompatText.Replace($tbAnchor + "`r`n" + $tbGuard,$tbAnchor)
        if ($tbReverseText -cne $originalTbText) { throw "$($release.id): TB input guard changed content outside the inserted checks" }
        $compileTb = Join-Path $compatDir 'tb_player_spectrum_analyzer.v'
        [System.IO.File]::WriteAllText($compileTb,$tbCompatText,[System.Text.UTF8Encoding]::new($false))
        $tbProof = [pscustomobject]@{
            applied=$true; change='Added sample_mem and expected_mem reduction-X checks immediately after the two $readmemh calls.'
            original_sha256=(Get-FileHash -Algorithm SHA256 -LiteralPath $tb).Hash.ToLowerInvariant()
            guarded_copy_sha256=(Get-FileHash -Algorithm SHA256 -LiteralPath $compileTb).Hash.ToLowerInvariant()
            inverse_transform_matches_original=$true
        }
        $tbProof | ConvertTo-Json -Depth 3 | Set-Content -LiteralPath (Join-Path $compatDir 'tb_guard_proof.json') -Encoding utf8
        @(
            '--- a/tb_player_spectrum_analyzer.v'
            '+++ b/tb_player_spectrum_analyzer.v (isolated input-guard copy)'
            '         $readmemh(exp_file,expected_mem);'
            '+        for(i=0;i<CASES*1024;i=i+1)'
            '+            if ((^sample_mem[i]) === 1''bx) $fatal(1,"input sample vector contains unknown or unloaded word index=%0d",i);'
            '+        for(i=0;i<CASES*24;i=i+1)'
            '+            if ((^expected_mem[i]) === 1''bx) $fatal(1,"expected vector contains unknown or unloaded word index=%0d",i);'
        ) | Set-Content -LiteralPath (Join-Path $compatDir 'tb_guard.diff') -Encoding utf8

        $compileRtl = $rtl
        $compatibility = $null
        if ($release.rom) {
            $originalText = [System.IO.File]::ReadAllText($rtl)
            $declPattern = '(?m)^[ \t]*reg \[8:0\] twiddle_addr;\r?\n'
            $declarationMatches = [regex]::Matches($originalText, $declPattern)
            $anchor = '    reg [3:0] fft_stage;'
            $originalAnchor = '    reg [9:0] fft_addr_a, fft_addr_b;'
            if ($declarationMatches.Count -ne 1 -or ([regex]::Matches($originalText, [regex]::Escape($anchor))).Count -ne 1 -or ([regex]::Matches($originalText, [regex]::Escape($originalAnchor))).Count -ne 1) {
                throw "$($release.id): cannot apply exact twiddle_addr compatibility relocation"
            }
            $compatText = [regex]::Replace($originalText, $declPattern, '', 1)
            $compatText = $compatText.Replace($anchor, $anchor + "`r`n    reg [8:0] twiddle_addr;")
            $compileRtl = Join-Path $compatDir 'player_spectrum_analyzer.v'
            [System.IO.File]::WriteAllText($compileRtl, $compatText, [System.Text.UTF8Encoding]::new($false))
            $reverseText = [regex]::Replace($compatText, '(?m)^    reg \[8:0\] twiddle_addr;\r?\n', '', 1)
            $reverseText = $reverseText.Replace($originalAnchor, $originalAnchor + "`r`n    reg [8:0] twiddle_addr;")
            $compatibility = [pscustomobject]@{
                applied=$true; change='Moved reg [8:0] twiddle_addr declaration before the first module instance to avoid ModelSim 10.1c implicit-net redeclaration failure.'
                original_sha256=(Get-FileHash -Algorithm SHA256 -LiteralPath $rtl).Hash.ToLowerInvariant()
                compatibility_copy_sha256=(Get-FileHash -Algorithm SHA256 -LiteralPath $compileRtl).Hash.ToLowerInvariant()
                inverse_transform_matches_original=($reverseText -ceq $originalText)
            }
            if (-not $compatibility.inverse_transform_matches_original) { throw "$($release.id): compatibility relocation changed more than the declaration position" }
            $compatibility | ConvertTo-Json -Depth 3 | Set-Content -LiteralPath (Join-Path $compatDir 'relocation_proof.json') -Encoding utf8
        }
        $compileArgs = @('-work','work','-vlog01compat',("+incdir+" + (Split-Path -Parent $rtl)),$compileTb,$compileRtl)
        if ($release.rom) { $compileArgs += $rom }
        $compileStart = Get-Date
        & $vlog @compileArgs *> (Join-Path $caseRoot 'compile.log')
        $compileCode = $LASTEXITCODE
        $compileEnd = Get-Date
        $simCode = $null
        $simStart = $null
        $simEnd = $null
        if ($compileCode -eq 0) {
            $simStart = Get-Date
            & $vsim -c -modelsimini 'modelsim.ini' -lib work -L work -L EG4 -novopt -do 'run -all; quit -f' work.tb_player_spectrum_analyzer EG4.glbl '+VEC=all_samples.mem' '+EXP=all_expected.mem' -l 'simulation.log' *> (Join-Path $caseRoot 'console.log')
            $simCode = $LASTEXITCODE
            $simEnd = Get-Date
        }
    } finally { Pop-Location }

    $compileText = if (Test-Path (Join-Path $caseRoot 'compile.log')) { Get-Content -Raw (Join-Path $caseRoot 'compile.log') } else { '' }
    $simText = if (Test-Path (Join-Path $caseRoot 'simulation.log')) { Get-Content -Raw (Join-Path $caseRoot 'simulation.log') } else { '' }
    $consoleText = if (Test-Path (Join-Path $caseRoot 'console.log')) { Get-Content -Raw (Join-Path $caseRoot 'console.log') } else { '' }
    $passSignature = [regex]::Match($simText,'(?m)^# PASS spectrum_analyzer.*$').Value
    $readmemFailure = $simText -match 'Failed to open readmem file'
    $passed = ($compileCode -eq 0 -and $simCode -eq 0 -and $passSignature -ne '' -and -not $readmemFailure -and $simText -match 'Loading EG4\.glbl')
    $results.Add([pscustomobject]@{
        id=$release.id; source_tree=$release.tree; checkpoint=$release.checkpoint
        manifest_sha256=(Get-FileHash -Algorithm SHA256 -LiteralPath $manifestPath).Hash.ToLowerInvariant()
        manifest_inputs=$inputs; independent_rom_present=$release.rom; compatibility_relocation=$compatibility; testbench_input_guard=$tbProof
        compile_exit_code=$compileCode; compile_started=$compileStart.ToString('o'); compile_ended=$compileEnd.ToString('o')
        simulation_exit_code=$simCode; simulation_started=if($simStart){$simStart.ToString('o')}else{$null}; simulation_ended=if($simEnd){$simEnd.ToString('o')}else{$null}
        compile_error_signature=if($compileCode -ne 0){($compileText -split "`r?`n" | Select-Object -Last 12) -join "`n"}else{$null}
        simulator_loaded_eg_phy_bram=($simText -match 'Loading EG4\.EG_PHY_BRAM')
        simulator_loaded_glbl=($simText -match 'Loading EG4\.glbl')
        private_rom_behavioral_sim_defined=$false
        copied_runtime_inputs=@(@($vec,$exp,$hann,$twiddle)|ForEach-Object {[pscustomobject]@{path=(Split-Path -Leaf $_);sha256=(Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $caseRoot (Split-Path -Leaf $_))).Hash.ToLowerInvariant();matches_source=((Get-FileHash -Algorithm SHA256 -LiteralPath $_).Hash -eq (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $caseRoot (Split-Path -Leaf $_))).Hash)}})
        readmem_open_failure=$readmemFailure
        pass_signature=$passSignature
        failure_signatures=@([regex]::Matches($simText,'(?m)^FAIL.*$') | ForEach-Object {$_.Value})
        status=if($compileCode -ne 0){'COMPILE_FAILURE'}elseif($passed -and -not $release.rom -and -not ($simText -match 'Loading EG4\.EG_PHY_BRAM')){'PASS_RTL_ARRAY_ROM'}elseif($passed){'PASS'}elseif($simCode -ne 0 -or $simText -match '^FAIL|Fatal:' -or -not $passed){'SIMULATION_FAILURE'}else{'INCOMPLETE'}
        limitation='RTL-only controlled audio-input test; no whole-system startup, PHY, routed SDF, or hardware validation.'
    })
    $results[-1] | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath (Join-Path $caseRoot 'result.json') -Encoding utf8
    Write-Output ("{0}: {1}; compile={2}; sim={3}; loaded_BRAM={4}; loaded_glbl={5}" -f $release.id,$results[-1].status,$compileCode,$simCode,$results[-1].simulator_loaded_eg_phy_bram,$results[-1].simulator_loaded_glbl)
}

$summary = [pscustomobject]@{
    run_id='regression_failed_releases_20261016'; created_utc=(Get-Date).ToUniversalTime().ToString('o')
    run_directory=$runRoot
    simulator='ModelSim SE-64 10.1c'; scope='Offline RTL-only replay of frozen analyzer and sealed testbench.'
    command_line='pwsh -NoProfile -File development/regression_failed_releases_20261016/rtl/run_retest.ps1'
    result_count=$results.Count; results=@($results)
    global_limitation='Not a whole-system simulation: no full-player startup, PHY behavior, routed SDF, or physical hardware.'
}
$summary | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $outRoot 'summary.json') -Encoding utf8
