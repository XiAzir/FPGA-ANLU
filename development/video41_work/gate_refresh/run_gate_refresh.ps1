param(
    [Parameter(Mandatory=$true)][ValidateSet('C40','C41')][string]$Case,
    [Parameter(Mandatory=$true)][string]$GateFile,
    [Parameter(Mandatory=$true)][string]$ExpectedSha256,
    [switch]$InjectC40Request,
    [switch]$RunSimulation,
    [int]$MaxMeasureCycles = 12000,
    [int]$TargetArefCommands = 10,
    [int]$Traffic = 0,
    [int]$AckEdge = 0,
    [int]$BurstWords = 4,
    [switch]$RoutedNetlist
)
$ErrorActionPreference='Stop'
$root=(Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '../..')).Path
$gate=(Resolve-Path -LiteralPath $GateFile).Path
$actual=(Get-FileHash -LiteralPath $gate -Algorithm SHA256).Hash.ToLowerInvariant()
if($actual -ne $ExpectedSha256.ToLowerInvariant()) { throw "Gate SHA mismatch: expected $ExpectedSha256, actual $actual" }
if($Case -eq 'C40' -and $actual -ne '200c8de5910970b96ea29a9913075ba96d07bcbee1b398b541103332e4f301d6') { throw 'C40 input is not the audited C40 gate file' }
if($InjectC40Request -and $Case -ne 'C40') { throw '-InjectC40Request is reserved for the C40 constant-net injection control' }

$stamp=Get-Date -Format 'yyyyMMdd_HHmmss'
$runDir=Join-Path $PSScriptRoot ("run_{0}_{1}" -f $Case,$stamp)
New-Item -ItemType Directory -Path $runDir | Out-Null
$original=[IO.File]::ReadAllText($gate)
$renamed=[regex]::Replace($original,'(?m)^module top\b','module gate_refresh_top')
if($original -ceq $renamed) { throw 'Could not rename mapped top module in simulation copy' }
$restore=[regex]::Replace($renamed,'(?m)^module gate_refresh_top\b','module top')
if($restore -cne $original) { throw 'Simulation copy changes more than the top module name' }
$gateCopy=Join-Path $runDir 'gate_refresh_top.v'
[IO.File]::WriteAllText($gateCopy,$renamed,[Text.Encoding]::ASCII)

$tool='E:/ModelsimSE/win64'
$modelRoot='C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/sim_release'
$models=@('common/al_map_seq.v','common/al_map_lut.v','common/al_map_alu2b.v','common/al_map_basic.v',
    'eg4/eg_phy_glbl.v','eg4/eg_logic_io.v','eg4/eg_logic_clk.v','eg4/eg_logic_gate.v','eg4/eg_logic_bram.v',
    'eg4/eg_phy_dff.v','eg4/eg_phy_lslice.v','eg4/eg_phy_mslice.v','eg4/eg_phy_mult18.v','eg4/eg_phy_pad.v','eg4/eg_phy_clk.v',
    'eg4/eg_phy_bram.v','eg4/eg_phy_config.v','eg4/eg_phy_pll.v','eg4/eg_phy_bankref.v') | ForEach-Object { Join-Path $modelRoot $_ }
foreach($f in $models) { if(-not (Test-Path -LiteralPath $f)) { throw "Missing mapped-cell simulation model: $f" } }
$modelsIni=(Join-Path $runDir 'modelsim.ini').Replace('\','/')
$work=Join-Path $runDir 'work'
[IO.File]::WriteAllText($modelsIni,"[Library]
work = $($work.Replace('\','/'))
others = E:/ModelsimSE/modelsim.ini
",[Text.Encoding]::ASCII)

$shell=Join-Path $PSScriptRoot 'eg_phy_sdram_shell.sv'
$bench=Join-Path $PSScriptRoot 'tb_gate_refresh.sv'
Copy-Item -LiteralPath $shell,$bench -Destination $runDir
Copy-Item -LiteralPath $PSCommandPath -Destination (Join-Path $runDir 'runner.ps1')
$shell=Join-Path $runDir 'eg_phy_sdram_shell.sv'
$bench=Join-Path $runDir 'tb_gate_refresh.sv'
$taskResetCopies=@()
if($RoutedNetlist) {
    $taskBenchText=[IO.File]::ReadAllText($bench)
    $taskBenchText=$taskBenchText.Replace('u2_wrrd/Sdr_ref_req_syn_4','u2_wrrd/Sdr_ref_req')
    $taskBenchText=$taskBenchText.Replace('dut.\u_frame_buffer/u_sdram/u2_ram/u1_init_ref/init_done_reg_syn_5 ', 'dut.\u_frame_buffer/u_legacy_frame_backend/Sdr_init_done ')
    $taskBenchText=$taskBenchText.Replace('u2_ram/Sdr_clk_sft','u2_ram/SDRAM_CLK')
    $taskBenchText=$taskBenchText.Replace('dut.\u_frame_buffer/u_sdram/u2_ram/App_rd_en ', 'dut.\u_frame_buffer/u_sdram/App_rd_en ')
    $taskBenchText=[regex]::Replace($taskBenchText,'(?m)^\s*force dut\.\\u_frame_buffer/u_sdram/u2_ram/App_wr_addr\s*=.*?;\r?\n','')
    $taskBenchText=$taskBenchText.Replace("force dut.rst_all = 1'b1;", "tb_mem_rst = 1'b1;")
    $taskBenchText=$taskBenchText.Replace("force dut.rst_all = 1'b0;", "tb_mem_rst = 1'b0;")
    $taskResetCopies=@([regex]::Matches($original,'(?m)^\s*wire (rst_all_dup_\d+);') | ForEach-Object {$_.Groups[1].Value})
    if($taskResetCopies.Count -eq 0) {throw 'No routed reset replicas found'}
    $taskForces=@("  reg tb_mem_rst=1'b1;",'  initial begin')
    $taskForces+=@($taskResetCopies | ForEach-Object {"    force dut.$_ = tb_mem_rst;"})
    $taskForces+="    force dut.\u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/jpeg_mode_latch  = 1'b0;"
    $taskForces+='  end'
    $taskBenchText=$taskBenchText.Replace('module tb_gate_refresh;',"module tb_gate_refresh;`n"+($taskForces -join "`n"))
    [IO.File]::WriteAllText($bench,$taskBenchText,[Text.Encoding]::ASCII)
}
$manifest=[ordered]@{
    case=$Case; gate_file=$gate; original_gate_sha256=$actual
    simulation_gate_copy_sha256=(Get-FileHash -LiteralPath $gateCopy -Algorithm SHA256).Hash
    copy_diff=$true; only_module_rename_verified=$true
    mapped_cone=$false
    routed_netlist=$RoutedNetlist.IsPresent
    routed_reset_replicas=$taskResetCopies
    routed_input_aliases=@('Sdr_ref_req','legacy_frame_backend/Sdr_init_done','u2_ram/SDRAM_CLK','u_sdram/App_rd_en','photo_App_wr_addr_r')
    forced_clock_nodes=@('dut.\sys_pll_m0/clk0_buf','dut.\u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/mem_clk','dut.\u_frame_buffer/u_sdram/u2_ram/Sdr_clk_sft','dut.clk0')
    forced_reset_node='dut.rst_all'
    forced_startup_node='dut.\u_frame_buffer/u_sdram/u2_ram/u1_init_ref/pwr_200ms_cnt'
    forced_idle_node=$null
    c40_only_injected_node='dut.\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/Sdr_ref_req'
    observed_request_node='dut.\u_frame_buffer/u_sdram/u2_ram/u2_wrrd/Sdr_ref_req_syn_4'
    observed_ack_node='dut.\u_frame_buffer/u_sdram/u2_ram/u1_init_ref/Sdr_ref_ack'
    phy_command_ports=@('clk0','cs_n','cke','ras_n','cas_n','we_n')
    inject_c40_request=[bool]$InjectC40Request
    simulation_started=[bool]$RunSimulation
    shifted_clock_ns=8
    traffic=$Traffic
    burst_words=$BurstWords
    simulation_ack_stage0_edge_override=$AckEdge
    traffic_force_nodes=@('App_wr_en','App_rd_en','App_wr_addr=incrementing_4word_burst','App_rd_addr=incrementing_4word_burst')
    address_alias_forces=@('frame_fifo_read_m0/App_rd_addr','frame_fifo_write_m0/App_wr_addr_r')
    bench_sha256=(Get-FileHash -LiteralPath $bench -Algorithm SHA256).Hash
    device_shell_sha256=(Get-FileHash -LiteralPath $shell -Algorithm SHA256).Hash
    runner_sha256=(Get-FileHash -LiteralPath $PSCommandPath -Algorithm SHA256).Hash
    vendor_model_sha256=@($models | ForEach-Object { @{path=$_;sha256=(Get-FileHash -LiteralPath $_ -Algorithm SHA256).Hash} })
}
$manifest | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath (Join-Path $runDir 'source_binding.json') -Encoding utf8
if(-not $RunSimulation) {
    Write-Output "Prepared $runDir; no compile or simulation was started. Pass -RunSimulation only when ready."
    exit 0
}

& "$tool/vlib.exe" $work *> (Join-Path $runDir 'library.log')
if($LASTEXITCODE -ne 0) { throw 'vlib failed' }
& "$tool/vlog.exe" -timescale 1ns/1ps -modelsimini $modelsIni -work work @models *> (Join-Path $runDir 'compile.log')
if($LASTEXITCODE -ne 0) { throw 'Mapped-cell model compilation failed; inspect compile.log' }
& "$tool/vlog.exe" -sv -timescale 1ns/1ps -modelsimini $modelsIni -work work $shell *> (Join-Path $runDir 'device_shell_compile.log')
if($LASTEXITCODE -ne 0) { throw 'SDRAM command shell compilation failed' }
& "$tool/vlog.exe" -timescale 1ns/1ps -modelsimini $modelsIni -work work $gateCopy *> (Join-Path $runDir 'gate_compile.log')
if($LASTEXITCODE -ne 0) { throw 'Mapped gate compilation failed; inspect gate_compile.log' }
& "$tool/vlog.exe" -sv -timescale 1ns/1ps -modelsimini $modelsIni -work work $bench *> (Join-Path $runDir 'bench_compile.log')
if($LASTEXITCODE -ne 0) { throw 'Bench compilation failed; inspect bench_compile.log' }
$inject=if($InjectC40Request){1}else{0}
$runLog=Join-Path $runDir 'run.log'
$tracePath=(Join-Path $runDir 'command_trace.csv').Replace('\','/')
& "$tool/vsim.exe" -c -modelsimini $modelsIni -novopt work.tb_gate_refresh work.glbl "+INJECT_REQ=$inject" "+TRACE=$tracePath" "-gTRAFFIC=$Traffic" "-gACK_EDGE=$AckEdge" "-gBURST_WORDS=$BurstWords" "-gMAX_MEASURE_CYCLES=$MaxMeasureCycles" "-gTARGET_AREFS=$TargetArefCommands" "-gCASE_C40=$([int]($Case -eq 'C40'))" -do 'onerror {quit -code 2 -f}; onbreak {quit -code 3 -f}; run -all; quit -code 0 -f' *> $runLog
$exitCode=$LASTEXITCODE
$runText=[IO.File]::ReadAllText($runLog)
$result=[ordered]@{case=$Case;exit_code=$exitCode;complete=$runText.Contains('GATE_REFRESH_COMPLETE');run_log=$runLog}
$result | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $runDir 'result.json') -Encoding utf8
$result | ConvertTo-Json -Compress
if($exitCode -ne 0 -or -not $result.complete) { throw "Gate refresh capture failed; see $runLog" }




