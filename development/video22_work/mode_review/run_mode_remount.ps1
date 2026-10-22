$ErrorActionPreference = 'Stop'
$project = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
$here = $PSScriptRoot
$fixture = Join-Path $project 'development\system_verification_20261016\card'
$rtl = Join-Path $project 'development\player_video21_diag\src\user_source\hdl_source'
$iverilog = Join-Path $project 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\iverilog.exe'
$vvp = Join-Path $project 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\vvp.exe'
$out = Join-Path $here 'tb_mode_remount.vvp'
$log = Join-Path $here 'mode_remount_run.log'
$sources = @(
  (Join-Path $rtl 'SD\sd_card_top.v'),
  (Join-Path $rtl 'SD\sd_card_sec_read_write.v'),
  (Join-Path $rtl 'SD\sd_card_cmd.v'),
  (Join-Path $rtl 'SD\spi_master.v'),
  (Join-Path $rtl 'fat32_catalog.v'),
  (Join-Path $fixture 'sd_spi_card_model.v'),
  (Join-Path $here 'tb_mode_remount.v')
)
Push-Location $fixture
try {
  & $iverilog -g2005 -o $out -s tb_mode_remount @sources 2>&1 | Tee-Object -FilePath $log
  if ($LASTEXITCODE -ne 0) { throw "iverilog failed: $LASTEXITCODE" }
  & $vvp $out 2>&1 | Tee-Object -FilePath $log -Append
  if ($LASTEXITCODE -ne 0) { throw "vvp failed: $LASTEXITCODE" }
  if (-not (Select-String -Path $log -SimpleMatch 'PASS six runtime reset phases preserved complete catalog metadata' -Quiet)) {
    throw 'PASS marker missing from simulation log'
  }
} finally { Pop-Location }
