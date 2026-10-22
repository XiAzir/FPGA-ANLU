$ErrorActionPreference = 'Stop'
$project = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
$rtl = Join-Path $project 'development\player_video23_mode_switch\src\user_source\hdl_source'
$fixture = Join-Path $project 'development\system_verification_20261016\card'
$iv = Join-Path $project 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\iverilog.exe'
$vvp = Join-Path $project 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\vvp.exe'
$out = Join-Path $PSScriptRoot 'tb_skip_cmd16.vvp'
$log = Join-Path $PSScriptRoot 'skip_cmd16_run.log'
$sources = @(
  (Join-Path $rtl 'SD\sd_card_top.v'),
  (Join-Path $PSScriptRoot 'skip_cmd16\sd_card_sec_read_write.v'),
  (Join-Path $rtl 'SD\sd_card_cmd.v'),
  (Join-Path $rtl 'SD\spi_master.v'),
  (Join-Path $rtl 'fat32_catalog.v'),
  (Join-Path $PSScriptRoot 'sd_spi_card_model_fault.v'),
  (Join-Path $PSScriptRoot 'tb_c23_cold_mount.v')
)
Set-Content -Path $log -Value ''
Push-Location $fixture
try {
  & $iv -g2005 -o $out -s tb_c23_cold_mount @sources 2>&1 | Tee-Object -FilePath $log
  if ($LASTEXITCODE -ne 0) { throw "iverilog failed: $LASTEXITCODE" }
  & $vvp $out +CMD16_FAULT +SKIP_CMD16 2>&1 | Tee-Object -FilePath $log -Append
  if ($LASTEXITCODE -ne 0) { throw "candidate case failed: $LASTEXITCODE" }
  if (-not (Select-String -Path $log -SimpleMatch 'PASS skip-CMD16 cold mount' -Quiet)) {
    throw 'candidate PASS marker missing'
  }
} finally { Pop-Location }
