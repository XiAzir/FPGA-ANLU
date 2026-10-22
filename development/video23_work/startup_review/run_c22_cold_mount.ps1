$ErrorActionPreference = 'Stop'
$project = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
$rtl = Join-Path $PSScriptRoot 'c22'
$fixture = Join-Path $project 'development\system_verification_20261016\card'
$iv = Join-Path $project 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\iverilog.exe'
$vvp = Join-Path $project 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\vvp.exe'
$out = Join-Path $PSScriptRoot 'tb_c22_cold_mount.vvp'
$log = Join-Path $PSScriptRoot 'c22_cold_mount_run.log'
$sources = @(
  (Join-Path $rtl 'sd_card_top.v'),
  (Join-Path $rtl 'sd_card_sec_read_write.v'),
  (Join-Path $rtl 'sd_card_cmd.v'),
  (Join-Path $rtl 'spi_master.v'),
  (Join-Path $rtl 'fat32_catalog.v'),
  (Join-Path $PSScriptRoot 'sd_spi_card_model_fault.v'),
  (Join-Path $PSScriptRoot 'tb_c23_cold_mount.v')
)
Set-Content -Path $log -Value ''
Push-Location $fixture
try {
  & $iv -g2005 -o $out -s tb_c23_cold_mount @sources 2>&1 | Tee-Object -FilePath $log
  if ($LASTEXITCODE -ne 0) { throw "iverilog failed: $LASTEXITCODE" }
  & $vvp $out 2>&1 | Tee-Object -FilePath $log -Append
  if ($LASTEXITCODE -ne 0) { throw "normal case failed: $LASTEXITCODE" }
  if (-not (Select-String -Path $log -SimpleMatch 'PASS normal cold mount' -Quiet)) { throw 'normal PASS marker missing' }
  & $vvp $out +CMD16_FAULT 2>&1 | Tee-Object -FilePath $log -Append
  if ($LASTEXITCODE -ne 0) { throw "fault case failed: $LASTEXITCODE" }
  if (-not (Select-String -Path $log -SimpleMatch 'PASS injected CMD16 rejection' -Quiet)) { throw 'fault PASS marker missing' }
} finally { Pop-Location }
