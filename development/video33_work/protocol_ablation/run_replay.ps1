param([Parameter(Mandatory=$true)][ValidateSet('A','B')][string]$Variant,[int]$Words=200000)
$ErrorActionPreference='Stop'
$root=Split-Path -Parent $MyInvocation.MyCommand.Path
$case=Join-Path $root $Variant
$simDir=Join-Path $case 'sim'
New-Item -ItemType Directory -Force $simDir | Out-Null
$tool='E:/ModelsimSE/win64'
$libName='work'
$lib=Join-Path $simDir ("work_{0}_{1}" -f $Variant,(Get-Date -Format 'HHmmss'))
$ini=Join-Path $simDir 'modelsim.ini'
$netlist=Join-Path $case "build/manual/AC201_protocol_ablation_${Variant}_gate.v"
if(!(Test-Path -LiteralPath $netlist)){throw "Missing mapped netlist: $netlist"}
$iniText="[Library]`nwork = $($lib.Replace('\','/'))`nothers = E:/ModelsimSE/modelsim.ini`n"
[IO.File]::WriteAllText($ini,$iniText,[Text.Encoding]::ASCII)
$source=[IO.File]::ReadAllText($netlist)
$renamed=[regex]::Replace($source,'(?m)^module top\b','module hdmi_diag_gate')
if($renamed -ceq $source){throw 'Top-module rename made no change'}
$gateCopy=Join-Path $simDir "${Variant}_gate.v"
[IO.File]::WriteAllText($gateCopy,$renamed,[Text.Encoding]::ASCII)
$binding=[ordered]@{mapped_gate=$netlist;mapped_sha256=(Get-FileHash -LiteralPath $netlist -Algorithm SHA256).Hash;replay_gate=$gateCopy;replay_sha256=(Get-FileHash -LiteralPath $gateCopy -Algorithm SHA256).Hash;only_top_renamed=([regex]::Replace($renamed,'(?m)^module hdmi_diag_gate\b','module top') -ceq $source);words=$Words}
$binding|ConvertTo-Json|Set-Content -LiteralPath (Join-Path $simDir "${Variant}_gate_binding.json") -Encoding utf8
& "$tool/vlib.exe" $lib *> (Join-Path $simDir "${Variant}_library.log")
if($LASTEXITCODE -ne 0){throw "vlib failed for $Variant"}
$simulationRoot='C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/sim_release'
$modelFiles=@('common/al_map_seq.v','common/al_map_lut.v','common/al_map_alu2b.v','common/al_map_basic.v','eg4/eg_phy_glbl.v','eg4/eg_logic_io.v','eg4/eg_logic_clk.v','eg4/eg_logic_gate.v','eg4/eg_logic_bram.v','eg4/eg_phy_dff.v','eg4/eg_phy_lslice.v','eg4/eg_phy_mslice.v','eg4/eg_phy_pad.v','eg4/eg_phy_clk.v','eg4/eg_phy_bram.v','eg4/eg_phy_config.v','eg4/eg_phy_pll.v')|ForEach-Object{"$simulationRoot/$_"}
& "$tool/vlog.exe" -timescale 1ns/1ps -modelsimini $($ini.Replace('\','/') ) -work $libName @modelFiles $gateCopy *> (Join-Path $simDir "${Variant}_compile.log")
if($LASTEXITCODE -ne 0){throw "Mapped gate compile failed for $Variant"}
& "$tool/vlog.exe" -sv -modelsimini $($ini.Replace('\','/') ) -work $libName (Join-Path $root 'tb_gate_pins.sv') *> (Join-Path $simDir "${Variant}_tb_compile.log")
if($LASTEXITCODE -ne 0){throw "Pin bench compile failed for $Variant"}
$stream=Join-Path $simDir "${Variant}_words.txt"
$start=[Diagnostics.Stopwatch]::StartNew()
& "$tool/vsim.exe" -c -modelsimini $($ini.Replace('\','/') ) -novopt "work.tb_gate_pins" "work.glbl" "-gMAX_WORDS=$Words" "+OUT=$($stream.Replace('\','/'))" -do 'onerror {quit -code 2 -f}; onbreak {quit -code 3 -f}; run -all; quit -code 0 -f' *> (Join-Path $simDir "${Variant}_run.log")
$exit=$LASTEXITCODE;$start.Stop();$text=Get-Content -Raw (Join-Path $simDir "${Variant}_run.log")
$bytes=if(Test-Path -LiteralPath $stream){(Get-Item $stream).Length}else{0}
$result=[ordered]@{variant=$Variant;words=$Words;exit_code=$exit;duration_seconds=[Math]::Round($start.Elapsed.TotalSeconds,2);capture_complete=($text -match 'GATE_PIN_CAPTURE_COMPLETE');stream=(Split-Path $stream -Leaf);stream_bytes=$bytes;model_ini=(Split-Path $ini -Leaf);model_library=$libName}
$result|ConvertTo-Json|Set-Content -LiteralPath (Join-Path $simDir "${Variant}_capture.json") -Encoding utf8
$result
if($exit -ne 0 -or -not $result.capture_complete){throw "Pin replay for $Variant failed; inspect ${Variant}_run.log"}