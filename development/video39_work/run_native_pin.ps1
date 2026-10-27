param([Parameter(Mandatory=$true)][ValidateSet(39)][int]$Version,[int]$Words=30000)
$ErrorActionPreference='Stop'
$repo=(Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '../..')).Path
$candidate=Join-Path $repo "development/player_video${Version}_native1080p30"
$sim=Join-Path $PSScriptRoot "pin_c$Version"
New-Item -ItemType Directory -Force -Path $sim | Out-Null
$tool='E:/ModelsimSE/win64'
$library=Join-Path $sim ('work_'+(Get-Date -Format 'HHmmss'))
$ini=(Join-Path $sim 'modelsim.ini').Replace('\','/')
[IO.File]::WriteAllText($ini,"[Library]`nwork = $($library.Replace('\','/'))`nothers = E:/ModelsimSE/modelsim.ini`n",[Text.Encoding]::ASCII)
$gate=Join-Path $candidate "build/manual/AC201_video${Version}_native1080p30_gate.v"
$original=[IO.File]::ReadAllText($gate)
$renamed=[regex]::Replace($original,'(?m)^module top\b','module hdmi_open_gate')
if($original -ceq $renamed){throw 'Mapped top not found'}
$gateCopy=Join-Path $sim 'gate.v'
[IO.File]::WriteAllText($gateCopy,$renamed,[Text.Encoding]::ASCII)
$modelRoot='C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/sim_release'
$models=@('common/al_map_seq.v','common/al_map_lut.v','common/al_map_alu2b.v','common/al_map_basic.v',
    'eg4/eg_phy_glbl.v','eg4/eg_logic_io.v','eg4/eg_logic_clk.v','eg4/eg_logic_gate.v','eg4/eg_logic_bram.v',
    'eg4/eg_phy_dff.v','eg4/eg_phy_lslice.v','eg4/eg_phy_mslice.v','eg4/eg_phy_pad.v','eg4/eg_phy_clk.v',
    'eg4/eg_phy_bram.v','eg4/eg_phy_config.v','eg4/eg_phy_pll.v')|ForEach-Object {"$modelRoot/$_"}
$binding=[ordered]@{
    mapped_gate=$gate
    mapped_sha256=(Get-FileHash -LiteralPath $gate -Algorithm SHA256).Hash
    replay_sha256=(Get-FileHash -LiteralPath $gateCopy -Algorithm SHA256).Hash
    only_top_renamed=([regex]::Replace($renamed,'(?m)^module hdmi_open_gate\b','module top') -ceq $original)
    bench_sha256=(Get-FileHash -LiteralPath (Join-Path $PSScriptRoot 'tb_gate_pins.sv') -Algorithm SHA256).Hash
    simulation_initialization=@{pll_primitive_input_reset_ns=200;startup_count_force=999999;production_pll_reset_unchanged=$true}
    vendor_models=@($models | ForEach-Object { @{path=$_;sha256=(Get-FileHash -LiteralPath $_ -Algorithm SHA256).Hash} })
}
$binding|ConvertTo-Json -Depth 5|Set-Content -LiteralPath (Join-Path $sim 'source_binding.json') -Encoding utf8
& "$tool/vlib.exe" $library *> (Join-Path $sim 'library.log')
if($LASTEXITCODE -ne 0){throw 'vlib failed'}
& "$tool/vlog.exe" -timescale 1ns/1ps -modelsimini $ini -work work @models $gateCopy *> (Join-Path $sim 'compile.log')
if($LASTEXITCODE -ne 0){throw 'gate compilation failed'}
& "$tool/vlog.exe" -sv -modelsimini $ini -work work (Join-Path $PSScriptRoot 'tb_gate_pins.sv') *> (Join-Path $sim 'bench_compile.log')
if($LASTEXITCODE -ne 0){throw 'bench compilation failed'}
$stream=(Join-Path $sim 'words.txt').Replace('\','/')
$runLog=Join-Path $sim 'run.log'
$timer=[Diagnostics.Stopwatch]::StartNew()
& "$tool/vsim.exe" -c -modelsimini $ini -novopt work.tb_gate_pins work.glbl "-gMAX_WORDS=$Words" "+OUT=$stream" -do 'onerror {quit -code 2 -f}; onbreak {quit -code 3 -f}; run -all; quit -code 0 -f' *> $runLog
$exitCode=$LASTEXITCODE
$timer.Stop()
$runText=[IO.File]::ReadAllText($runLog)
$result=[ordered]@{
    version=$Version;words=$Words;exit_code=$exitCode
    duration_seconds=[Math]::Round($timer.Elapsed.TotalSeconds,3)
    completed=$runText.Contains('OPEN_TX_PIN_CAPTURE_COMPLETE')
    stream=$stream
}
$result|ConvertTo-Json|Set-Content -LiteralPath (Join-Path $sim 'capture.json') -Encoding utf8
$result|ConvertTo-Json -Compress
if($exitCode -ne 0 -or -not $result.completed){throw "C$Version pin capture failed, see $runLog"}
python (Join-Path $PSScriptRoot 'check_native_pin_stream.py') --version $Version --stream $stream --output (Join-Path $sim 'analysis.json')
if($LASTEXITCODE -ne 0){throw "C$Version pin protocol verification failed"}
