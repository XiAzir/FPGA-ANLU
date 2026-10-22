$ErrorActionPreference = 'Stop'
$project = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
$fixture = Join-Path $project 'development\system_verification_20261016\card'
$here = $PSScriptRoot
$rtl = Join-Path $project 'development/player_video25_sdhc_init/src/user_source/hdl_source'
$iv = Join-Path $project 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\iverilog.exe'
$vvp = Join-Path $project 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\vvp.exe'
$out = Join-Path $here 'tb_sd_quiesce_c25_actual.vvp'
$log = Join-Path $here 'sd_quiesce_c25_actual.log'
$sources = @(
  (Join-Path $rtl 'SD/sd_card_top.v'),
  (Join-Path $rtl 'SD/sd_card_sec_read_write.v'),
  (Join-Path $rtl 'SD/sd_card_cmd.v'),
  (Join-Path $rtl 'SD/spi_master.v'),
  (Join-Path $rtl 'fat32_catalog.v'),
  (Join-Path $here 'sd_spi_card_model.v'),
  (Join-Path $rtl 'player_mode_quiesce.v'),
  (Join-Path $here 'tb_sd_quiesce_integration.v')
)
Push-Location $fixture
try {
  & $iv -g2005 -o $out -s tb_sd_quiesce_integration @sources 2>&1 | Tee-Object -FilePath $log
  if ($LASTEXITCODE -ne 0) { throw "iverilog failed: $LASTEXITCODE" }
  & $vvp $out 2>&1 | Tee-Object -FilePath $log -Append
  if ($LASTEXITCODE -ne 0) { throw "vvp failed: $LASTEXITCODE" }
  if (-not (Select-String -Path $log -SimpleMatch 'PASS six phase drain preserved catalog/card session' -Quiet)) {
    throw 'PASS marker missing from simulation log'
  }
} finally { Pop-Location }


