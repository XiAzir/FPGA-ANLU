param(
    [Parameter(Mandatory=$true)][ValidateSet('C41','C42')][string]$Case,
    [Parameter(Mandatory=$true)][string]$GateFile,
    [Parameter(Mandatory=$true)][string]$ExpectedSha256,
    [switch]$InjectC40Request,
    [switch]$RunSimulation,
    [int]$MaxMeasureCycles = 30000,
    [int]$TargetArefCommands = 10,
    [int]$Traffic = 0,
    [int]$AckEdge = 0,
    [int]$BurstWords = 256,
    [ValidateSet(10,20)][int]$MemPeriodNs = 10,
    [int]$ShiftDelayNs = 4,
    [int]$RefreshIntervalNs = 15620,
    [int]$TRcNs = 63,
    [int]$TRcdNs = 21,
    [int]$TRpNs = 21,
    [int]$TRasNs = 42,
    [int]$TWrCycles = 2,
    [int]$TRfcNs = 63,
    [int]$TRrdNs = 14,
    [int]$TMrdCycles = 2,
    [switch]$InjectReadBitError,
    [ValidateSet(0,1,2)][int]$CaptureMode = 2,
    [switch]$DiagnoseMissingInitAref,
    [switch]$RoutedNetlist
)
$ErrorActionPreference='Stop'
$root=(Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '../..')).Path
$gate=(Resolve-Path -LiteralPath $GateFile).Path
$actual=(Get-FileHash -LiteralPath $gate -Algorithm SHA256).Hash.ToLowerInvariant()
if($actual -ne $ExpectedSha256.ToLowerInvariant()) { throw "Gate SHA mismatch: expected $ExpectedSha256, actual $actual" }
if($InjectC40Request) { throw 'C41/C42 memory runs do not use C40 request injection' }
if($ShiftDelayNs -lt 0 -or $ShiftDelayNs -ge $MemPeriodNs) { throw 'ShiftDelayNs must be within one memory-clock period' }
if($RefreshIntervalNs -le 0) { throw 'RefreshIntervalNs must be positive' }
$expectedRefreshCycles=[int][Math]::Round($RefreshIntervalNs/$MemPeriodNs,[MidpointRounding]::AwayFromZero)

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

$shell=Join-Path $PSScriptRoot 'eg_phy_sdram_model.v'
$bench=Join-Path $PSScriptRoot 'tb_memory_gate.sv'
$deviceModel=Join-Path $PSScriptRoot 'IS42s32200.v'
Copy-Item -LiteralPath $shell,$bench,$deviceModel -Destination $runDir
Copy-Item -LiteralPath $PSCommandPath -Destination (Join-Path $runDir 'runner.ps1')
$shell=Join-Path $runDir 'eg_phy_sdram_model.v'
$bench=Join-Path $runDir 'tb_memory_gate.sv'
$modelCompileDefine="+define+SDRAM_T_DPL_NS=$($MemPeriodNs*2)"
$benchDefines=@()
if($Case -eq 'C42') { $benchDefines=@('+define+PRODUCTION_DATA_DELAY0') }
$taskResetCopies=@()
if($RoutedNetlist) {
    $taskBenchText=[IO.File]::ReadAllText($bench)
    $taskBenchText=$taskBenchText.Replace('u2_wrrd/Sdr_ref_req_syn_4','u2_wrrd/Sdr_ref_req')
    $taskBenchText=$taskBenchText.Replace('u2_ram/Sdr_clk_sft','u2_ram/SDRAM_CLK')
    $taskBenchText=$taskBenchText.Replace('dut.\u_frame_buffer/u_sdram/u2_ram/App_rd_en ', 'dut.\u_frame_buffer/u_sdram/App_rd_en ')
    $taskBenchText=[regex]::Replace($taskBenchText,'(?m)^\s*force dut\.\\u_frame_buffer/u_sdram/u2_ram/App_wr_addr\s*=.*?;\r?\n','')
    $taskBenchText=$taskBenchText.Replace("force dut.rst_all = 1'b1;", "tb_mem_rst = 1'b1;")
    $taskBenchText=$taskBenchText.Replace("force dut.rst_all = 1'b0;", "tb_mem_rst = 1'b0;")
    $taskResetCopies=@([regex]::Matches($original,'(?m)^\s*wire (rst_all_dup_\d+);') | ForEach-Object {$_.Groups[1].Value})
    if($taskResetCopies.Count -eq 0) {throw 'No routed reset replicas found'}
    $taskForces=@("  reg tb_mem_rst=1'b1;",'  initial begin')
    $taskForces+=@($taskResetCopies | ForEach-Object {"    force dut.$_ = tb_mem_rst;"})
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
    inject_c40_request=$InjectC40Request.IsPresent
    simulation_started=$RunSimulation.IsPresent
    mem_period_ns=$MemPeriodNs
    shifted_clock_ns=$ShiftDelayNs
    expected_refresh_interval_ns=$RefreshIntervalNs
    expected_refresh_cycles=$expectedRefreshCycles
    device_timing=@{tRC_ns=$TRcNs;tRCD_ns=$TRcdNs;tRP_ns=$TRpNs;tRAS_ns=$TRasNs;tWR_cycles=$TWrCycles;tRFC_ns=$TRfcNs;tRRD_ns=$TRrdNs;tMRD_cycles=$TMrdCycles}
    inject_read_bit_error=$InjectReadBitError.IsPresent
    capture_mode=$CaptureMode
    diagnose_missing_init_aref=$DiagnoseMissingInitAref.IsPresent
    use_public_init_done=($Case -eq 'C42' -or $RoutedNetlist.IsPresent)
    production_capture_binding=if($Case -eq 'C42'){'controller raw output (DATA_DELAY0)'}else{'legacy backend read_capture_data (DATA_DELAY1)'}
    model_tDPL_ns=$($MemPeriodNs*2)
    init_pin_trace_window_ns=1000
    init_pin_trace_file='init_pin_trace.csv'
    traffic=$Traffic
    burst_words=$BurstWords
    simulation_ack_stage0_edge_override=$AckEdge
    traffic_force_nodes=@('App_wr_en','App_rd_en','App_wr_addr=incrementing_4word_burst','App_rd_addr=incrementing_4word_burst')
    address_alias_forces=@('frame_fifo_read_m0/App_rd_addr','frame_fifo_write_m0/App_wr_addr_r')
    bench_sha256=(Get-FileHash -LiteralPath $bench -Algorithm SHA256).Hash
    device_model_sha256=(Get-FileHash -LiteralPath (Join-Path $PSScriptRoot 'IS42s32200.v') -Algorithm SHA256).Hash
    device_model_source='APUG011 official reference model; see source_receipt.json in prior harness'
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
& "$tool/vlog.exe" -timescale 1ns/1ps -modelsimini $modelsIni -work work (Join-Path $runDir 'IS42s32200.v') *> (Join-Path $runDir 'memory_model_compile.log')
if($LASTEXITCODE -ne 0) { throw 'IS42s32200 model compilation failed' }
& "$tool/vlog.exe" -sv $modelCompileDefine -timescale 1ns/1ps -modelsimini $modelsIni -work work $shell *> (Join-Path $runDir 'device_shell_compile.log')
if($LASTEXITCODE -ne 0) { throw 'SDRAM command shell compilation failed' }
& "$tool/vlog.exe" -timescale 1ns/1ps -modelsimini $modelsIni -work work $gateCopy *> (Join-Path $runDir 'gate_compile.log')
if($LASTEXITCODE -ne 0) { throw 'Mapped gate compilation failed; inspect gate_compile.log' }
& "$tool/vlog.exe" -sv @benchDefines -timescale 1ns/1ps -modelsimini $modelsIni -work work $bench *> (Join-Path $runDir 'bench_compile.log')
if($LASTEXITCODE -ne 0) { throw 'Bench compilation failed; inspect bench_compile.log' }
$inject=if($InjectC40Request){1}else{0}
$injectReadBitErrorValue=if($InjectReadBitError.IsPresent){1}else{0}
$usePublicInitDone=if($Case -eq 'C42' -or $RoutedNetlist.IsPresent){1}else{0}
$runLog=Join-Path $runDir 'run.log'
$tracePath=(Join-Path $runDir 'command_trace.csv').Replace('\','/')
$initTracePath=(Join-Path $runDir 'init_pin_trace.csv').Replace('\','/')
& "$tool/vsim.exe" -c -modelsimini $modelsIni -novopt work.tb_gate_refresh work.glbl "+INJECT_REQ=0" "+TRACE=$tracePath" "+INIT_TRACE=$initTracePath" "-gTRAFFIC=$Traffic" "-gACK_EDGE=$AckEdge" "-gBURST_WORDS=$BurstWords" "-gMEM_PERIOD_NS=$MemPeriodNs" "-gSHIFT_DELAY_NS=$ShiftDelayNs" "-gEXPECT_REFRESH_CYCLES=$expectedRefreshCycles" "-gT_RFC_NS=$TRfcNs" "-gT_RRD_NS=$TRrdNs" "-gT_MRD_CYCLES=$TMrdCycles" "-gCAPTURE_MODE=$CaptureMode" "-gUSE_PUBLIC_INIT_DONE=$usePublicInitDone" "-gDIAGNOSE_MISSING_INIT_AREF=$([int]$DiagnoseMissingInitAref.IsPresent)" "-gINJECT_READ_BIT_ERROR=$injectReadBitErrorValue" "-gMAX_MEASURE_CYCLES=$MaxMeasureCycles" "-gTARGET_AREFS=$TargetArefCommands" "-gCASE_C40=0" -do 'onerror {quit -code 2 -f}; onbreak {quit -code 3 -f}; run -all; quit -code 0 -f' *> $runLog
$exitCode=$LASTEXITCODE
$runText=[IO.File]::ReadAllText($runLog)
$modelTimingErrors=[regex]::Matches($runText,'(?im)ERROR:\s+t(?:RC|RCD|RP|RAS|RRD|MRD|DPL)\s+violation')
$negativeDetected=$runText.Contains('strict production capture scoreboard mismatch')
$initStatus=if($runText.Contains('INIT_AREF_MISSING')){'FAIL'}elseif($runText.Contains('INIT_SEQUENCE_PASS')){'PASS'}else{'INCOMPLETE'}
$dataStatus=if($runText.Contains('DATA_SCOREBOARD_PASS')){'PASS'}elseif($Traffic -eq 1){'FAIL'}else{'NOT_RUN'}
$overallPass=($exitCode -eq 0 -and $runText.Contains('GATE_REFRESH_COMPLETE') -and $initStatus -eq 'PASS' -and ($Traffic -ne 1 -or $dataStatus -eq 'PASS') -and $modelTimingErrors.Count -eq 0)
$result=[ordered]@{case=$Case;exit_code=$exitCode;complete=$runText.Contains('GATE_REFRESH_COMPLETE');init_status=$initStatus;data_status=$dataStatus;overall_pass=$overallPass;negative_control_detected=$negativeDetected;model_timing_error_count=$modelTimingErrors.Count;run_log=$runLog;init_pin_trace=$initTracePath}
$result | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $runDir 'result.json') -Encoding utf8
$result | ConvertTo-Json -Compress
if($InjectReadBitError) {
    if($exitCode -eq 0 -or -not $negativeDetected) { throw "Single-bit negative control was not detected; see $runLog" }
    Write-Output 'Single-bit negative control detected as expected.'
} elseif(-not $overallPass) { throw "Gate run did not PASS init and data scopes (init=$initStatus data=$dataStatus); see $runLog" }




