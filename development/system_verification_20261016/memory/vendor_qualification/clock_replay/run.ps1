param([switch]$Capture)
$ErrorActionPreference='Stop'
$here=$PSScriptRoot
$dev=(Resolve-Path (Join-Path $here '..\..\..')).Path
$project=(Resolve-Path (Join-Path $dev '..\..')).Path
$tool='E:\ModelsimSE\win64'
$env:MGLS_LICENSE_FILE=[Environment]::GetEnvironmentVariable('MGLS_LICENSE_FILE','User')
Push-Location $here
try {
  if($Capture) {
    & "$tool\vlog.exe" -modelsimini modelsim.ini -work work `
      (Join-Path $project 'development\player_spectrum_fft_recover\src\user_source\hdl_source\IP\sys_pll.v') `
      (Join-Path $project 'development\player_spectrum_fft_recover\src\user_source\hdl_source\IP\video_pll.v') `
      'tb_capture_pll.v' *> 'vlog_capture.log'
    if($LASTEXITCODE -ne 0){throw "capture vlog failed: $LASTEXITCODE"}
    & "$tool\vsim.exe" -c -novopt -modelsimini modelsim.ini -lib work -L adapter_work -L eg4 `
      tb_capture_pll eg4.glbl -do 'do run_capture.do' -l capture.log
    if($LASTEXITCODE -ne 0){throw "capture vsim failed: $LASTEXITCODE"}
    if(-not (Select-String -Path capture.log -SimpleMatch 'CAPTURE_DONE' -Quiet)){throw 'capture marker missing'}
    & python gen_replay.py *> gen_replay.log
    if($LASTEXITCODE -ne 0){throw "replay generation failed: $LASTEXITCODE"}
  }
  & "$tool\vlog.exe" -modelsimini modelsim.ini -work work `
    'pll_clock_replay.v' `
    (Join-Path $project 'development\player_spectrum_fft_recover\src\user_source\hdl_source\IP\sys_pll.v') `
    (Join-Path $project 'development\player_spectrum_fft_recover\src\user_source\hdl_source\IP\video_pll.v') `
    'tb_compare_pll_replay.v' *> 'vlog_compare.log'
  if($LASTEXITCODE -ne 0){throw "compare vlog failed: $LASTEXITCODE"}
  & "$tool\vsim.exe" -c -novopt -modelsimini modelsim.ini -lib work -L adapter_work -L eg4 `
    tb_compare_pll_replay eg4.glbl -do 'do run_capture.do' -l compare.log
  if($LASTEXITCODE -ne 0){throw "compare vsim failed: $LASTEXITCODE"}
  if(-not (Select-String -Path compare.log -SimpleMatch 'PASS_PLL_REPLAY 20us' -Quiet)){throw 'replay PASS marker missing'}
  & "$tool\vlog.exe" -modelsimini modelsim.ini -work work 'pll_clock_replay.v' 'tb_guard_freq_negative.v' 'tb_guard_reset_negative.v' *> 'vlog_guard.log'
  if($LASTEXITCODE -ne 0){throw "guard vlog failed: $LASTEXITCODE"}
  & "$tool\vsim.exe" -c -novopt -modelsimini modelsim.ini -lib work tb_guard_freq_negative -do 'run 1 us; quit -code 0 -f' -l guard_freq.log
  if($LASTEXITCODE -ne 0 -or -not (Select-String -Path guard_freq.log -SimpleMatch 'FATAL replay reference clock period 18.0000 ns' -Quiet)){throw 'frequency negative did not trigger expected fatal'}
  & "$tool\vsim.exe" -c -novopt -modelsimini modelsim.ini -lib work tb_guard_reset_negative -do 'run 1 us; quit -code 0 -f' -l guard_reset.log
  if($LASTEXITCODE -ne 0 -or -not (Select-String -Path guard_reset.log -SimpleMatch 'FATAL replay reset deviated from recorded constant 0' -Quiet)){throw 'reset negative did not trigger expected fatal'}
  $paths=[ordered]@{
    adapter='development/system_verification_20261016/pll/eg_phy_pll_init_adapter.v'
    sys_wrapper='development/player_spectrum_fft_recover/src/user_source/hdl_source/IP/sys_pll.v'
    video_wrapper='development/player_spectrum_fft_recover/src/user_source/hdl_source/IP/video_pll.v'
  }
  $sha=[ordered]@{}
  foreach($key in $paths.Keys){$sha[$key]=(Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $project $paths[$key])).Hash.ToLowerInvariant()}
  foreach($file in @('pll_trace.csv','pll_clock_replay.v','gen_replay.py','replay_meta.json','tb_capture_pll.v','tb_compare_pll_replay.v','tb_guard_freq_negative.v','tb_guard_reset_negative.v','capture.log','vlog_capture.log','compare.log','vlog_compare.log','guard_freq.log','guard_reset.log')){$sha[$file]=(Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $here $file)).Hash.ToLowerInvariant()}
  $summary=[ordered]@{
    status='PASS_SCOPE'
    simulator='ModelSim SE-64 10.1c, -novopt'
    replay_module='pll_clock_replay'
    replay_sha256=$sha['pll_clock_replay.v']
    capture_window='0..10 us from unchanged production sys_pll/video_pll wrappers using local initialization-adapted EG_PHY_PLL functional model'
    compare_window='0..20 us, settle-delta excluded only before 1 ps; every subsequent output transition checked at +1 ps and value, transition counts and final value compared'
    outputs=@('sys_pll clk0_out','sys_pll clk1_out','sys_pll clk2_out','video_pll clk0_out','video_pll clk1_out','sys extlock','video extlock')
    lock_time_ns=944.875
    captured_repeat_half_period_ns=@{sys0=10.0;sys1=10.0;sys2=10.0;pclk=20.0;serclk=4.0}
    compared_transition_counts=@{sys0=1932;sys1=1932;sys2=1933;pclk=966;serclk=4828}
    refclk_guard='requires 50 MHz; edge-to-edge period must equal 20.0 ns; watchdog detects stopped/slow input; any reset value/change away from constant 0 is fatal'
    guard_negative_tests='PASS: 18ns refclk period fatal at 27ns; reset high fatal at 50ns'
    extension='recorded events are used through 10 us; after the final recorded edge each clock repeats at the stable captured half-period, lock remains at its recorded final value'
    boundary='optional simulation acceleration only for these exact PLL wrappers, adapter model revision, 50 MHz reference and reset held at 0; not a synthesis replacement, not a hardware PLL model qualification, and not valid after source/configuration changes'
    sim_log='compare.log'
    source_sha256=$sha
  }
  $summary|ConvertTo-Json -Depth 8|Set-Content -Encoding utf8 summary.json
} finally { Pop-Location }
