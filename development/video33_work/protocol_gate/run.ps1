param([ValidateSet(35,36)][int]$Version = 36, [int]$Words = 20000)
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '../../..')).Path
$candidate = if ($Version -eq 36) {'C11336_1080p15_serial_bufg'} else {'C11335_640x480_60hz_33_165_bufg'}
$project = "AC201_$candidate"
$netlist = Join-Path $root "development/video33_work/candidates/$candidate/build/manual/${project}_gate.v"
$tool = 'E:/ModelsimSE/win64'
$lib = "work_c$Version"
Set-Location -LiteralPath $PSScriptRoot
$libPath = (Join-Path $PSScriptRoot $lib).Replace('\','/')
$modelsimIni = (Join-Path $PSScriptRoot "C${Version}_modelsim.ini").Replace('\','/')
[IO.File]::WriteAllText($modelsimIni,"[Library]`nwork = $libPath`nothers = E:/ModelsimSE/modelsim.ini`n",[Text.Encoding]::ASCII)
$sourceText = [IO.File]::ReadAllText($netlist)
$copyText = [regex]::Replace($sourceText,'(?m)^module top\b','module hdmi_diag_gate')
$copyPath = Join-Path $PSScriptRoot "C${Version}_gate.v"
[IO.File]::WriteAllText($copyPath,$copyText,[Text.Encoding]::ASCII)
$binding = [ordered]@{
    source = $netlist
    source_sha256 = (Get-FileHash -LiteralPath $netlist -Algorithm SHA256).Hash
    generated = $copyPath
    generated_sha256 = (Get-FileHash -LiteralPath $copyPath -Algorithm SHA256).Hash
    only_top_module_renamed = ([regex]::Replace($copyText,'(?m)^module hdmi_diag_gate\b','module top') -ceq $sourceText)
}
$binding | ConvertTo-Json | Set-Content -LiteralPath "C${Version}_binding.json" -Encoding utf8
& "$tool/vlib.exe" $lib *> "C${Version}_library.log"
$simulationRoot = 'C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/sim_release'
$modelFiles = @('common/al_map_seq.v','common/al_map_lut.v','common/al_map_alu2b.v','common/al_map_basic.v',
    'eg4/eg_phy_glbl.v','eg4/eg_logic_io.v','eg4/eg_logic_clk.v','eg4/eg_logic_gate.v','eg4/eg_logic_bram.v',
    'eg4/eg_phy_dff.v','eg4/eg_phy_lslice.v','eg4/eg_phy_mslice.v','eg4/eg_phy_pad.v','eg4/eg_phy_clk.v',
    'eg4/eg_phy_bram.v','eg4/eg_phy_config.v','eg4/eg_phy_pll.v') | ForEach-Object { "$simulationRoot/$_" }
& "$tool/vlog.exe" -timescale 1ns/1ps -modelsimini $modelsimIni -work work @modelFiles $copyPath *> "C${Version}_compile.log"
if ($LASTEXITCODE -ne 0) { throw "C$Version netlist compilation failed" }
& "$tool/vlog.exe" -sv -modelsimini $modelsimIni -work work (Join-Path $PSScriptRoot 'tb_gate_pins.sv') *> "C${Version}_tb_compile.log"
if ($LASTEXITCODE -ne 0) { throw "C$Version testbench compilation failed" }
$simulationTimer = [Diagnostics.Stopwatch]::StartNew()
& "$tool/vsim.exe" -c -modelsimini $modelsimIni work.tb_gate_pins work.glbl "-gMAX_WORDS=$Words" "+OUT=C${Version}_words.txt" -do 'onerror {quit -code 2 -f}; onbreak {quit -code 3 -f}; run -all; quit -code 0 -f' *> "C${Version}_run.log"
$simExit = $LASTEXITCODE
$simulationTimer.Stop()
Write-Output "Simulation wall seconds: $($simulationTimer.Elapsed.TotalSeconds)"
$runText = [IO.File]::ReadAllText((Join-Path $PSScriptRoot "C${Version}_run.log"))
Write-Output ($runText -split "`r?`n" | Select-Object -Last 12)
if ($simExit -ne 0) { throw "C$Version netlist capture failed with exit $simExit" }
if ($runText -notmatch 'GATE_PIN_CAPTURE_COMPLETE') { throw "C$Version capture did not complete" }
